From: akpm@linux-foundation.org
Subject: + r-o-bind-mounts-filesystem-helpers-for-custom-struct-files.patch added to -mm tree
Date: Fri, 21 Sep 2007 01:02:00 -0700
Message-ID: <200709210802.l8L820ct025677@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57707 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752048AbXIUICT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Sep 2007 04:02:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: haveblue@us.ibm.com, hch@lst.de


The patch titled
     r/o bind mounts: filesystem helpers for custom 'struct file's
has been added to the -mm tree.  Its filename is
     r-o-bind-mounts-filesystem-helpers-for-custom-struct-files.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: r/o bind mounts: filesystem helpers for custom 'struct file's
From: Dave Hansen <haveblue@us.ibm.com>

Why do we need r/o bind mounts?

This feature allows a read-only view into a read-write filesystem.  In the
process of doing that, it also provides infrastructure for keeping track of
the number of writers to any given mount.

This has a number of uses.  It allows chroots to have parts of filesystems
writable.  It will be useful for containers in the future because users may
have root inside a container, but should not be allowed to write to
somefilesystems.  This also replaces patches that vserver has had out of the
tree for several years.

It allows security enhancement by making sure that parts of your filesystem
read-only (such as when you don't trust your FTP server), when you don't want
to have entire new filesystems mounted, or when you want atime selectively
updated.  I've been using the following script to test that the feature is
working as desired.  It takes a directory and makes a regular bind and a r/o
bind mount of it.  It then performs some normal filesystem operations on the
three directories, including ones that are expected to fail, like creating a
file on the r/o mount.


This patch:

Some filesystems forego the vfs and may_open() and create their own 'struct
file's.

This patch creates a couple of helper functions which can be used by these
filesystems, and will provide a unified place which the r/o bind mount code
may patch.

Also, rename an existing, static-scope init_file() to a less generic name.

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/configfs/dir.c    |    5 ++-
 fs/file_table.c      |   60 +++++++++++++++++++++++++++++++++++++++++
 fs/hugetlbfs/inode.c |   22 ++++++---------
 include/linux/file.h |    9 ++++++
 ipc/shm.c            |   13 +++-----
 mm/shmem.c           |    7 +---
 mm/tiny-shmem.c      |   19 ++++--------
 net/socket.c         |   18 ++++++------
 8 files changed, 104 insertions(+), 49 deletions(-)

diff -puN fs/configfs/dir.c~r-o-bind-mounts-filesystem-helpers-for-custom-struct-files fs/configfs/dir.c
--- a/fs/configfs/dir.c~r-o-bind-mounts-filesystem-helpers-for-custom-struct-files
+++ a/fs/configfs/dir.c
@@ -142,7 +142,7 @@ static int init_dir(struct inode * inode
 	return 0;
 }
 
-static int init_file(struct inode * inode)
+static int configfs_init_file(struct inode * inode)
 {
 	inode->i_size = PAGE_SIZE;
 	inode->i_fop = &configfs_file_operations;
@@ -283,7 +283,8 @@ static int configfs_attach_attr(struct c
 
 	dentry->d_fsdata = configfs_get(sd);
 	sd->s_dentry = dentry;
-	error = configfs_create(dentry, (attr->ca_mode & S_IALLUGO) | S_IFREG, init_file);
+	error = configfs_create(dentry, (attr->ca_mode & S_IALLUGO) | S_IFREG,
+				configfs_init_file);
 	if (error) {
 		configfs_put(sd);
 		return error;
diff -puN fs/file_table.c~r-o-bind-mounts-filesystem-helpers-for-custom-struct-files fs/file_table.c
--- a/fs/file_table.c~r-o-bind-mounts-filesystem-helpers-for-custom-struct-files
+++ a/fs/file_table.c
@@ -137,6 +137,66 @@ fail:
 
 EXPORT_SYMBOL(get_empty_filp);
 
+/**
+ * alloc_file - allocate and initialize a 'struct file'
+ * @mnt: the vfsmount on which the file will reside
+ * @dentry: the dentry representing the new file
+ * @mode: the mode with which the new file will be opened
+ * @fop: the 'struct file_operations' for the new file
+ *
+ * Use this instead of get_empty_filp() to get a new
+ * 'struct file'.  Do so because of the same initialization
+ * pitfalls reasons listed for init_file().  This is a
+ * preferred interface to using init_file().
+ *
+ * If all the callers of init_file() are eliminated, its
+ * code should be moved into this function.
+ */
+struct file *alloc_file(struct vfsmount *mnt, struct dentry *dentry,
+		mode_t mode, const struct file_operations *fop)
+{
+	struct file *file;
+	struct path;
+
+	file = get_empty_filp();
+	if (!file)
+		return NULL;
+
+	init_file(file, mnt, dentry, mode, fop);
+	return file;
+}
+EXPORT_SYMBOL(alloc_file);
+
+/**
+ * init_file - initialize a 'struct file'
+ * @file: the already allocated 'struct file' to initialized
+ * @mnt: the vfsmount on which the file resides
+ * @dentry: the dentry representing this file
+ * @mode: the mode the file is opened with
+ * @fop: the 'struct file_operations' for this file
+ *
+ * Use this instead of setting the members directly.  Doing so
+ * avoids making mistakes like forgetting the mntget() or
+ * forgetting to take a write on the mnt.
+ *
+ * Note: This is a crappy interface.  It is here to make
+ * merging with the existing users of get_empty_filp()
+ * who have complex failure logic easier.  All users
+ * of this should be moving to alloc_file().
+ */
+int init_file(struct file *file, struct vfsmount *mnt, struct dentry *dentry,
+	   mode_t mode, const struct file_operations *fop)
+{
+	int error = 0;
+	file->f_path.dentry = dentry;
+	file->f_path.mnt = mntget(mnt);
+	file->f_mapping = dentry->d_inode->i_mapping;
+	file->f_mode = mode;
+	file->f_op = fop;
+	return error;
+}
+EXPORT_SYMBOL(init_file);
+
 void fastcall fput(struct file *file)
 {
 	if (atomic_dec_and_test(&file->f_count))
diff -puN fs/hugetlbfs/inode.c~r-o-bind-mounts-filesystem-helpers-for-custom-struct-files fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~r-o-bind-mounts-filesystem-helpers-for-custom-struct-files
+++ a/fs/hugetlbfs/inode.c
@@ -923,16 +923,11 @@ struct file *hugetlb_file_setup(const ch
 	if (!dentry)
 		goto out_shm_unlock;
 
-	error = -ENFILE;
-	file = get_empty_filp();
-	if (!file)
-		goto out_dentry;
-
 	error = -ENOSPC;
 	inode = hugetlbfs_get_inode(root->d_sb, current->fsuid,
 				current->fsgid, S_IFREG | S_IRWXUGO, 0);
 	if (!inode)
-		goto out_file;
+		goto out_dentry;
 
 	error = -ENOMEM;
 	if (hugetlb_reserve_pages(inode, 0, size >> HPAGE_SHIFT))
@@ -941,17 +936,18 @@ struct file *hugetlb_file_setup(const ch
 	d_instantiate(dentry, inode);
 	inode->i_size = size;
 	inode->i_nlink = 0;
-	file->f_path.mnt = mntget(hugetlbfs_vfsmount);
-	file->f_path.dentry = dentry;
-	file->f_mapping = inode->i_mapping;
-	file->f_op = &hugetlbfs_file_operations;
-	file->f_mode = FMODE_WRITE | FMODE_READ;
+
+	error = -ENFILE;
+	file = alloc_file(hugetlbfs_vfsmount, dentry,
+			FMODE_WRITE | FMODE_READ,
+			&hugetlbfs_file_operations);
+	if (!file)
+		goto out_inode;
+
 	return file;
 
 out_inode:
 	iput(inode);
-out_file:
-	put_filp(file);
 out_dentry:
 	dput(dentry);
 out_shm_unlock:
diff -puN include/linux/file.h~r-o-bind-mounts-filesystem-helpers-for-custom-struct-files include/linux/file.h
--- a/include/linux/file.h~r-o-bind-mounts-filesystem-helpers-for-custom-struct-files
+++ a/include/linux/file.h
@@ -62,6 +62,15 @@ extern struct kmem_cache *filp_cachep;
 extern void FASTCALL(__fput(struct file *));
 extern void FASTCALL(fput(struct file *));
 
+struct file_operations;
+struct vfsmount;
+struct dentry;
+extern int init_file(struct file *, struct vfsmount *mnt,
+		struct dentry *dentry, mode_t mode,
+		const struct file_operations *fop);
+extern struct file *alloc_file(struct vfsmount *, struct dentry *dentry,
+		mode_t mode, const struct file_operations *fop);
+
 static inline void fput_light(struct file *file, int fput_needed)
 {
 	if (unlikely(fput_needed))
diff -puN ipc/shm.c~r-o-bind-mounts-filesystem-helpers-for-custom-struct-files ipc/shm.c
--- a/ipc/shm.c~r-o-bind-mounts-filesystem-helpers-for-custom-struct-files
+++ a/ipc/shm.c
@@ -907,7 +907,7 @@ long do_shmat(int shmid, char __user *sh
 		goto out_unlock;
 
 	path.dentry = dget(shp->shm_file->f_path.dentry);
-	path.mnt    = mntget(shp->shm_file->f_path.mnt);
+	path.mnt    = shp->shm_file->f_path.mnt;
 	shp->shm_nattch++;
 	size = i_size_read(path.dentry->d_inode);
 	shm_unlock(shp);
@@ -915,18 +915,16 @@ long do_shmat(int shmid, char __user *sh
 	err = -ENOMEM;
 	sfd = kzalloc(sizeof(*sfd), GFP_KERNEL);
 	if (!sfd)
-		goto out_put_path;
+		goto out_put_dentry;
 
 	err = -ENOMEM;
-	file = get_empty_filp();
+
+	file = alloc_file(path.mnt, path.dentry, f_mode, &shm_file_operations);
 	if (!file)
 		goto out_free;
 
-	file->f_op = &shm_file_operations;
 	file->private_data = sfd;
-	file->f_path = path;
 	file->f_mapping = shp->shm_file->f_mapping;
-	file->f_mode = f_mode;
 	sfd->id = shp->id;
 	sfd->ns = get_ipc_ns(ns);
 	sfd->file = shp->shm_file;
@@ -977,9 +975,8 @@ out_unlock:
 
 out_free:
 	kfree(sfd);
-out_put_path:
+out_put_dentry:
 	dput(path.dentry);
-	mntput(path.mnt);
 	goto out_nattch;
 }
 
diff -puN mm/shmem.c~r-o-bind-mounts-filesystem-helpers-for-custom-struct-files mm/shmem.c
--- a/mm/shmem.c~r-o-bind-mounts-filesystem-helpers-for-custom-struct-files
+++ a/mm/shmem.c
@@ -2543,11 +2543,8 @@ struct file *shmem_file_setup(char *name
 	d_instantiate(dentry, inode);
 	inode->i_size = size;
 	inode->i_nlink = 0;	/* It is unlinked */
-	file->f_path.mnt = mntget(shm_mnt);
-	file->f_path.dentry = dentry;
-	file->f_mapping = inode->i_mapping;
-	file->f_op = &shmem_file_operations;
-	file->f_mode = FMODE_WRITE | FMODE_READ;
+	init_file(file, shm_mnt, dentry, FMODE_WRITE | FMODE_READ,
+			&shmem_file_operations);
 	return file;
 
 close_file:
diff -puN mm/tiny-shmem.c~r-o-bind-mounts-filesystem-helpers-for-custom-struct-files mm/tiny-shmem.c
--- a/mm/tiny-shmem.c~r-o-bind-mounts-filesystem-helpers-for-custom-struct-files
+++ a/mm/tiny-shmem.c
@@ -66,24 +66,19 @@ struct file *shmem_file_setup(char *name
 	if (!dentry)
 		goto put_memory;
 
-	error = -ENFILE;
-	file = get_empty_filp();
-	if (!file)
-		goto put_dentry;
-
 	error = -ENOSPC;
 	inode = ramfs_get_inode(root->d_sb, S_IFREG | S_IRWXUGO, 0);
 	if (!inode)
-		goto close_file;
+		goto put_dentry;
 
 	d_instantiate(dentry, inode);
-	inode->i_nlink = 0;	/* It is unlinked */
+	error = -ENFILE;
+	file = alloc_file(shm_mnt, dentry, FMODE_WRITE | FMODE_READ,
+			&ramfs_file_operations);
+	if (!file)
+		goto put_dentry;
 
-	file->f_path.mnt = mntget(shm_mnt);
-	file->f_path.dentry = dentry;
-	file->f_mapping = inode->i_mapping;
-	file->f_op = &ramfs_file_operations;
-	file->f_mode = FMODE_WRITE | FMODE_READ;
+	inode->i_nlink = 0;	/* It is unlinked */
 
 	/* notify everyone as to the change of file size */
 	error = do_truncate(dentry, size, 0, file);
diff -puN net/socket.c~r-o-bind-mounts-filesystem-helpers-for-custom-struct-files net/socket.c
--- a/net/socket.c~r-o-bind-mounts-filesystem-helpers-for-custom-struct-files
+++ a/net/socket.c
@@ -368,26 +368,26 @@ static int sock_alloc_fd(struct file **f
 
 static int sock_attach_fd(struct socket *sock, struct file *file)
 {
+	struct dentry *dentry;
 	struct qstr name = { .name = "" };
 
-	file->f_path.dentry = d_alloc(sock_mnt->mnt_sb->s_root, &name);
-	if (unlikely(!file->f_path.dentry))
+	dentry = d_alloc(sock_mnt->mnt_sb->s_root, &name);
+	if (unlikely(!dentry))
 		return -ENOMEM;
 
-	file->f_path.dentry->d_op = &sockfs_dentry_operations;
+	dentry->d_op = &sockfs_dentry_operations;
 	/*
 	 * We dont want to push this dentry into global dentry hash table.
 	 * We pretend dentry is already hashed, by unsetting DCACHE_UNHASHED
 	 * This permits a working /proc/$pid/fd/XXX on sockets
 	 */
-	file->f_path.dentry->d_flags &= ~DCACHE_UNHASHED;
-	d_instantiate(file->f_path.dentry, SOCK_INODE(sock));
-	file->f_path.mnt = mntget(sock_mnt);
-	file->f_mapping = file->f_path.dentry->d_inode->i_mapping;
+	dentry->d_flags &= ~DCACHE_UNHASHED;
+	d_instantiate(dentry, SOCK_INODE(sock));
 
 	sock->file = file;
-	file->f_op = SOCK_INODE(sock)->i_fop = &socket_file_ops;
-	file->f_mode = FMODE_READ | FMODE_WRITE;
+	init_file(file, sock_mnt, dentry, FMODE_READ | FMODE_WRITE,
+		  &socket_file_ops);
+	SOCK_INODE(sock)->i_fop = &socket_file_ops;
 	file->f_flags = O_RDWR;
 	file->f_pos = 0;
 	file->private_data = sock;
_

Patches currently in -mm which might be from haveblue@us.ibm.com are

revert-gregkh-driver-warn-when-statically-allocated-kobjects-are-used.patch
make-kobject-dynamic-allocation-check-use-kallsyms_lookup.patch
generic-virtual-memmap-support-for-sparsemem-remove-excess-debugging.patch
generic-virtual-memmap-support-for-sparsemem-simplify-initialisation-code-and-reduce-duplication.patch
generic-virtual-memmap-support-for-sparsemem-pull-out-the-vmemmap-code-into-its-own-file.patch
ppc64-sparsemem_vmemmap-support-vmemmap-ppc64-convert-vmm_-macros-to-a-real-function.patch
r-o-bind-mounts-filesystem-helpers-for-custom-struct-files.patch
r-o-bind-mounts-rearrange-may_open-to-be-r-o-friendly.patch
r-o-bind-mounts-give-may_open-a-local-mnt-variable.patch
r-o-bind-mounts-create-cleanup-helper-svc_msnfs.patch
r-o-bind-mounts-stub-functions.patch
r-o-bind-mounts-elevate-write-count-opend-files.patch
r-o-bind-mounts-elevate-write-count-for-some-ioctls.patch
r-o-bind-mounts-elevate-writer-count-for-chown-and-friends.patch
r-o-bind-mounts-make-access-use-mnt-check.patch
r-o-bind-mounts-elevate-mnt-writers-for-callers-of-vfs_mkdir.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl.patch
r-o-bind-mounts-elevate-write-count-for-link-and-symlink-calls.patch
r-o-bind-mounts-elevate-mount-count-for-extended-attributes.patch
r-o-bind-mounts-elevate-write-count-for-file_update_time.patch
r-o-bind-mounts-unix_find_other-elevate-write-count-for-touch_atime.patch
r-o-bind-mounts-elevate-write-count-over-calls-to-vfs_rename.patch
r-o-bind-mounts-nfs-check-mnt-instead-of-superblock-directly.patch
r-o-bind-mounts-elevate-writer-count-for-do_sys_truncate.patch
r-o-bind-mounts-elevate-write-count-for-do_utimes.patch
r-o-bind-mounts-elevate-write-count-for-do_sys_utime-and-touch_atime.patch
r-o-bind-mounts-sys_mknodat-elevate-write-count-for-vfs_mknod-create.patch
r-o-bind-mounts-elevate-mnt-writers-for-vfs_unlink-callers.patch
r-o-bind-mounts-do_rmdir-elevate-write-count.patch
r-o-bind-mounts-track-number-of-mount-writers.patch
r-o-bind-mounts-honor-r-w-changes-at-do_remount-time.patch
cpuset-zero-malloc-revert-the-old-cpuset-fix.patch
task-containersv11-basic-task-container-framework.patch
task-containersv11-add-tasks-file-interface.patch
task-containersv11-add-fork-exit-hooks.patch
task-containersv11-add-container_clone-interface.patch
task-containersv11-add-procfs-interface.patch
task-containersv11-shared-container-subsystem-group-arrays.patch
task-containersv11-automatic-userspace-notification-of-idle-containers.patch
task-containersv11-make-cpusets-a-client-of-containers.patch
task-containersv11-example-cpu-accounting-subsystem.patch
task-containersv11-simple-task-container-debug-info-subsystem.patch
pid-namespaces-define-and-use-task_active_pid_ns-wrapper.patch
pid-namespaces-rename-child_reaper-function.patch
pid-namespaces-use-task_pid-to-find-leaders-pid.patch
pid-namespaces-define-is_global_init-and-is_container_init.patch
pid-namespaces-define-is_global_init-and-is_container_init-versus-x86_64-mm-i386-show-unhandled-signals-v3.patch
pid-namespaces-move-alloc_pid-to-copy_process.patch
page-owner-tracking-leak-detector.patch
