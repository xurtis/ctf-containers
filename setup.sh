#!/bin/bash
set -e

if [ $UID -ne 0 ]; then
    echo "Must be run as root"
    exit 1
fi

# Install required packages
apt-get update
apt-get install -y docker gcc make

# Create the base static container
docker build -t ctf-static-base web-base

# Create the base network container
pushd net-base
make
popd
docker build -t ctf-net-base net-base

# Create the base web container
docker build -t ctf-web-base web-base

# Create a docker user
mkdir /home/ctf
mkdir /home/ctf/static
chmod -R 775 /home/ctf

useradd -M -U -G docker -d /home/ctf ctf

chown ctf:ctf /home/ctf