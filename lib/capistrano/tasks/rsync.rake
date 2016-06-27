namespace :rsync do
  include_dir  = fetch(:include_dir) || "*"
  exclude_dir  = Array(fetch(:exclude_dir))

  exclude_args = exclude_dir.map { |dir| "--exclude '#{dir}'"}

  # Defalut to :all roles
  rsync_roles = fetch(:rsync_roles, :all)

  rsync_verbose = fetch(:rsync_verbose, true) ? "v" : ""

  desc "Deploy to release_path"
  task :deploy do
    on roles(rsync_roles) do
      # Make sure the release directory exists
      puts "==> release_path: #{release_path} is created on #{rsync_roles} roles <=="
      execute :mkdir, "-p", release_path

      # Upload the archive, extract it and finally remove the tmp_file
      execute :rsync, "-ar", exclude_args, repo_path, release_path
    end
  end

  task :clean do |t|
  end

  after 'deploy:finished', 'rsync:clean'

  task :create_release => :deploy
  task :check
  task :set_current_revision
end
