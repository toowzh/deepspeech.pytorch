FROM pytorch/pytorch:1.0-cuda10.0-cudnn7-devel

WORKDIR /workspace/

# install basics
RUN apt-get update -y
RUN apt-get install -y git curl ca-certificates bzip2 cmake tree htop bmon iotop sox libsox-dev libsox-fmt-all vim

# install python deps
RUN pip install -i https://pypi.tuna.tsinghua.edu.cn/simple cython visdom cffi tensorboardX wget

# install warp-CTC
ENV CUDA_HOME=/usr/local/cuda
RUN git clone https://github.com/SeanNaren/warp-ctc.git
RUN cd warp-ctc; mkdir build; cd build; cmake ..; make
RUN cd warp-ctc; cd pytorch_binding; python setup.py install

# install pytorch audio
RUN git clone https://github.com/pytorch/audio.git
RUN cd audio; python setup.py install

# install ctcdecode
#RUN git clone --recursive https://github.com/parlance/ctcdecode.git
RUN git clone --recursive https://github.com/toowzh/ctcdecode.git
RUN cd ctcdecode; pip install -i https://pypi.tuna.tsinghua.edu.cn/simple .

ENV LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH

# install apex
RUN git clone --recursive https://github.com/NVIDIA/apex.git
RUN cd apex; pip install -i https://pypi.tuna.tsinghua.edu.cn/simple .

# install deepspeech.pytorch
ADD . /workspace/deepspeech.pytorch
RUN cd deepspeech.pytorch; pip install -i https://pypi.tuna.tsinghua.edu.cn/simple -r requirements.txt

# launch jupiter
RUN pip install -i https://pypi.tuna.tsinghua.edu.cn/simple jupyter
RUN mkdir data; mkdir notebooks;
CMD jupyter-notebook --ip="*" --no-browser --allow-root
