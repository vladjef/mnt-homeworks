#!/bin/bash

home_dir=$(pwd)
docker_dir="docker"
playbook_dir="playbook"
playbook="site.yml"
inventory="inventory/prod.yml"

echo -n 'Please type vault password for ansible: '
read -s pass

if [ "${pass}" ];
then
  # Stop docker containers
  cd $home_dir/$docker_dir || exit
  sudo docker-compose up -d

  cd $home_dir/$playbook_dir || exit
  echo "${pass}" > vault_pass
  
  # Run ansible test playbook
  sudo ansible-playbook $playbook -i $inventory --vault-password-file $home_dir/playbook/vault_pass
  
  rm -f $home_dir/playbook/vault_pass

  # Stop docker containers
  cd $home_dir/$docker_dir || exit
  sudo docker-compose down
else
  echo "Vault password is empty."
fi