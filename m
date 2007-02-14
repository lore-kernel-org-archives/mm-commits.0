From: akpm@linux-foundation.org
Subject: - r-o-bind-mounts-filesystem-helpers-for-custom-struct-files.patch removed from -mm tree
Date: Wed, 14 Feb 2007 10:52:10 -0800
Message-ID: <200702141852.l1EIqBqw005698@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39150 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932440AbXBNSwZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 Feb 2007 13:52:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hansendc@us.ibm.com, haveblue@us.ibm.com, hch@lst.de, linuxram@us.ibm.com, miklos@szeredi.hu, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     r/o bind mounts: filesystem helpers for custom 'struct file's
has been removed from the -mm tree.  Its filename was
     r-o-bind-mounts-filesystem-helpers-for-custom-struct-files.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: r/o bind mounts: filesystem helpers for custom 'struct file's
From: Dave Hansen <hansendc@us.ibm.com>

Some filesystems forego the vfs and may_open() and create their own 'struct
file's.

This patch creates a couple of helper functions which can be used by these
filesystems, and will provide a unified place which the r/o bind mount code
may patch.

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Ram Pai <linuxram@us.ibm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/file_table.c      |   36 ++++++++++++++++++++++++++++++++++++
 fs/hugetlbfs/inode.c |   22 +++++++++-------------
 include/linux/file.h |    8 ++++++++
 mm/shmem.c           |    7 ++-----
 mm/tiny-shmem.c      |   24 +++++++++---------------
 net/socket.c         |   18 +++++++++---------
 6 files changed, 73 insertions(+), 42 deletions(-)

diff -puN fs/file_table.c~r-o-bind-mounts-filesystem-helpers-for-custom-struct-files fs/file_table.c
--- a/fs/file_table.c~r-o-bind-mounts-filesystem-helpers-for-custom-struct-files
+++ a/fs/file_table.c
@@ -139,6 +139,42 @@ fail:
 
 EXPORT_SYMBOL(get_empty_filp);
 
+struct file *alloc_file(struct vfsmount *mnt,  struct dentry *dentry,
+		mode_t mode, const struct file_operations *fop)
+{
+	struct file *file;
+
+	file = get_empty_filp();
+	if (!file)
+		return NULL;
+
+	init_file(file, mnt, dentry, mode, fop);
+	return file;
+}
+
+EXPORT_SYMBOL(alloc_file);
+
+/*
+ * Note: This is a crappy interface.  It is here to make
+ * merging with the existing users of get_empty_filp()
+ * who have complex failure logic easier.  All users
+ * of this should be moving to alloc_file().
+ */
+int init_file(struct file *file, struct vfsmount *mnt,
+	   struct dentry *dentry, mode_t mode,
+	   const struct file_operations *fop)
+{
+	int error = 0;
+	file->f_vfsmnt = mntget(mnt);
+	file->f_dentry = dentry;
+	file->f_mapping = dentry->d_inode->i_mapping;
+	file->f_mode = mode;
+	file->f_op = fop;
+	return error;
+}
+
+EXPORT_SYMBOL(init_file);
+
 void fastcall fput(struct file *file)
 {
 	if (atomic_dec_and_test(&file->f_count))
diff -puN fs/hugetlbfs/inode.c~r-o-bind-mounts-filesystem-helpers-for-custom-struct-files fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~r-o-bind-mounts-filesystem-helpers-for-custom-struct-files
+++ a/fs/hugetlbfs/inode.c
@@ -759,16 +759,11 @@ struct file *hugetlb_zero_setup(size_t s
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
@@ -777,17 +772,18 @@ struct file *hugetlb_zero_setup(size_t s
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
@@ -62,6 +62,14 @@ extern struct kmem_cache *filp_cachep;
 extern void FASTCALL(__fput(struct file *));
 extern void FASTCALL(fput(struct file *));
 
+struct file_operations;
+struct vfsmount;
+struct dentry;
+extern int init_file(struct file *, struct vfsmount *, struct dentry *dentry,
+		mode_t mode, const struct file_operations *fop);
+extern struct file *alloc_file(struct vfsmount *, struct dentry *dentry,
+		mode_t mode, const struct file_operations *fop);
+
 static inline void fput_light(struct file *file, int fput_needed)
 {
 	if (unlikely(fput_needed))
diff -puN mm/shmem.c~r-o-bind-mounts-filesystem-helpers-for-custom-struct-files mm/shmem.c
--- a/mm/shmem.c~r-o-bind-mounts-filesystem-helpers-for-custom-struct-files
+++ a/mm/shmem.c
@@ -2497,11 +2497,8 @@ struct file *shmem_file_setup(char *name
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
+		goto put_inode;
 
-	file->f_path.mnt = mntget(shm_mnt);
-	file->f_path.dentry = dentry;
-	file->f_mapping = inode->i_mapping;
-	file->f_op = &ramfs_file_operations;
-	file->f_mode = FMODE_WRITE | FMODE_READ;
+	inode->i_nlink = 0;	/* It is unlinked */
 
 	/* notify everyone as to the change of file size */
 	error = do_truncate(dentry, size, 0, file);
@@ -91,9 +86,8 @@ struct file *shmem_file_setup(char *name
 		goto close_file;
 
 	return file;
-
-close_file:
-	put_filp(file);
+put_inode:
+	iput(inode);
 put_dentry:
 	dput(dentry);
 put_memory:
diff -puN net/socket.c~r-o-bind-mounts-filesystem-helpers-for-custom-struct-files net/socket.c
--- a/net/socket.c~r-o-bind-mounts-filesystem-helpers-for-custom-struct-files
+++ a/net/socket.c
@@ -355,6 +355,7 @@ static int sock_alloc_fd(struct file **f
 
 static int sock_attach_fd(struct socket *sock, struct file *file)
 {
+	struct dentry *dentry;
 	struct qstr this;
 	char name[32];
 
@@ -362,24 +363,23 @@ static int sock_attach_fd(struct socket 
 	this.name = name;
 	this.hash = 0;
 
-	file->f_path.dentry = d_alloc(sock_mnt->mnt_sb->s_root, &this);
-	if (unlikely(!file->f_path.dentry))
+	dentry = d_alloc(sock_mnt->mnt_sb->s_root, &this);
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
-
+	dentry->d_flags &= ~DCACHE_UNHASHED;
+	d_instantiate(dentry, SOCK_INODE(sock));
+	init_file(file, sock_mnt, dentry, FMODE_READ | FMODE_WRITE,
+		&socket_file_ops);
+	SOCK_INODE(sock)->i_fop = &socket_file_ops;
 	sock->file = file;
 	file->f_op = SOCK_INODE(sock)->i_fop = &socket_file_ops;
-	file->f_mode = FMODE_READ | FMODE_WRITE;
 	file->f_flags = O_RDWR;
 	file->f_pos = 0;
 	file->private_data = sock;
_

Patches currently in -mm which might be from hansendc@us.ibm.com are

r-o-bind-mounts-filesystem-helpers-for-custom-struct-files.patch
r-o-bind-mounts-add-vfsmount-writer-counts.patch
r-o-bind-mounts-record-when-sb_writer_count-elevated-for-inode.patch
r-o-bind-mounts-elevate-writer-count-for-chown-and-friends.patch
r-o-bind-mounts-elevate-mnt-writers-for-callers-of-vfs_mkdir.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl.patch
r-o-bind-mounts-elevate-write-count-for-link-and-symlink-calls.patch
r-o-bind-mounts-elevate-mount-count-for-extended-attributes.patch
r-o-bind-mounts-mount_is_safe-add-comment.patch
r-o-bind-mounts-unix_find_other-elevate-write-count-for-touch_atime.patch
r-o-bind-mounts-elevate-write-count-over-calls-to-vfs_rename.patch
r-o-bind-mounts-elevate-write-count-files-are-opened.patch
r-o-bind-mounts-elevate-writer-count-for-do_sys_truncate.patch
r-o-bind-mounts-elevate-write-count-for-do_utimes.patch
r-o-bind-mounts-elevate-write-count-for-do_sys_utime-and-touch_atime.patch
r-o-bind-mounts-sys_mknodat-elevate-write-count-for-vfs_mknod-create.patch
r-o-bind-mounts-elevate-mnt-writers-for-vfs_unlink-callers.patch
r-o-bind-mounts-do_rmdir-elevate-write-count.patch
r-o-bind-mounts-elevate-writer-count-for-custom-struct_file.patch
r-o-bind-mounts-gfs-check-nlink-count.patch
r-o-bind-mounts-honor-r-w-changes-at-do_remount-time.patch
r-o-bind-mounts-kill-open-files-traverse-on-remount-ro.patch
