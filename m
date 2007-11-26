From: akpm@linux-foundation.org
Subject: - revoke-core-code.patch removed from -mm tree
Date: Mon, 26 Nov 2007 11:36:11 -0800
Message-ID: <200711261936.lAQJaBxI019280@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50802 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753818AbXKZTgu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Nov 2007 14:36:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: penberg@cs.helsinki.fi, bunk@stusta.de, clameter@sgi.com, frederik.deweerdt@gmail.com, hch@lst.de, mm-commits@vger.kernel.org


The patch titled
     revoke: core code
has been removed from the -mm tree.  Its filename was
     revoke-core-code.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: revoke: core code
From: Pekka Enberg <penberg@cs.helsinki.fi>

The revokeat(2) and frevoke(2) system calls invalidate open file descriptors
and shared mappings of an inode.  After an successful revocation, operations
on file descriptors fail with the EBADF or ENXIO error code for regular and
device files, respectively.  Attempting to read from or write to a revoked
mapping causes SIGBUS.

The actual operation is done in two passes:

 1. Revoke all file descriptors that point to the given inode. We do
    this under tasklist_lock so that after this pass, we don't need
    to worry about racing with close(2) or dup(2).

 2. Take down shared memory mappings of the inode and close all file
    pointers.

The file descriptors and memory mapping ranges are preserved until the
owning task does close(2) and munmap(2), respectively.


You use revoke() (with chown, for example) to gain exclusive access to 
an inode that might be in use by other processes. This means that we must 
mke sure that:

  - operations on opened file descriptors pointing to that inode fail
  - there are no shared mappings visible to other processes
  - in-progress system calls are either completed (writes) or abort 
    (reads)

After revoke() system call returns, you are guaranteed to have revoked 
access to an inode for any processes that had access to it when you 
started the operation. The caller is responsible for blocking any future 
open(2) calls that might occur while revoke() takes care of fork(2) and 
dup(2) during the operation.

[bunk@stusta.de: various cleanups]
[clameter@sgi.com: slab allocators: Remove multiple alignment specifications]
[deweerdt@free.fr: fix use-uninitialised bug]
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Frederik Deweerdt <frederik.deweerdt@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/Makefile                  |    1 
 fs/revoke.c                  |  774 +++++++++++++++++++++++++++++++++
 fs/revoked_inode.c           |  417 +++++++++++++++++
 include/linux/fs.h           |    8 
 include/linux/magic.h        |    1 
 include/linux/mm.h           |    1 
 include/linux/revoked_fs_i.h |   18 
 include/linux/syscalls.h     |    3 
 mm/mmap.c                    |   11 
 9 files changed, 1234 insertions(+)

diff -puN fs/Makefile~revoke-core-code fs/Makefile
--- a/fs/Makefile~revoke-core-code
+++ a/fs/Makefile
@@ -19,6 +19,7 @@ else
 obj-y +=	no-block.o
 endif
 
+obj-$(CONFIG_MMU)		+= revoke.o revoked_inode.o
 obj-$(CONFIG_INOTIFY)		+= inotify.o
 obj-$(CONFIG_INOTIFY_USER)	+= inotify_user.o
 obj-$(CONFIG_EPOLL)		+= eventpoll.o
diff -puN /dev/null fs/revoke.c
--- /dev/null
+++ a/fs/revoke.c
@@ -0,0 +1,774 @@
+/*
+ * fs/revoke.c - Invalidate all current open file descriptors of an inode.
+ *
+ * Copyright (C) 2006-2007  Pekka Enberg
+ *
+ * This file is released under the GPLv2.
+ */
+
+#include <linux/file.h>
+#include <linux/fs.h>
+#include <linux/namei.h>
+#include <linux/magic.h>
+#include <linux/mm.h>
+#include <linux/mman.h>
+#include <linux/module.h>
+#include <linux/mount.h>
+#include <linux/sched.h>
+#include <linux/revoked_fs_i.h>
+#include <linux/syscalls.h>
+
+/**
+ * fileset - an array of file pointers.
+ * @files:    the array of file pointers
+ * @nr:               number of elements in the array
+ * @end:      index to next unused file pointer
+ */
+struct fileset {
+	struct file	**files;
+	unsigned long	nr;
+	unsigned long	end;
+};
+
+/**
+ * revoke_details - details of the revoke operation
+ * @inode:            invalidate open file descriptors of this inode
+ * @fset:             set of files that point to a revoked inode
+ * @restore_start:    index to the first file pointer that is currently in
+ *                    use by a file descriptor but the real file has not
+ *                    been revoked
+ */
+struct revoke_details {
+	struct fileset	*fset;
+	unsigned long	restore_start;
+};
+
+static struct kmem_cache *revokefs_inode_cache;
+
+static inline bool fset_is_full(struct fileset *set)
+{
+	return set->nr == set->end;
+}
+
+static inline struct file *fset_get_filp(struct fileset *set)
+{
+	return set->files[set->end++];
+}
+
+static struct fileset *alloc_fset(unsigned long size)
+{
+	struct fileset *fset;
+
+	fset = kzalloc(sizeof *fset, GFP_KERNEL);
+	if (!fset)
+		return NULL;
+
+	fset->files = kcalloc(size, sizeof(struct file *), GFP_KERNEL);
+	if (!fset->files) {
+		kfree(fset);
+		return NULL;
+	}
+	fset->nr = size;
+	return fset;
+}
+
+static void free_fset(struct fileset *fset)
+{
+      int i;
+
+      for (i = fset->end; i < fset->nr; i++)
+              fput(fset->files[i]);
+
+      kfree(fset->files);
+      kfree(fset);
+}
+
+/*
+ * Revoked file descriptors point to inodes in the revokefs filesystem.
+ */
+static struct vfsmount *revokefs_mnt;
+
+static struct file *get_revoked_file(void)
+{
+	struct dentry *dentry;
+	struct inode *inode;
+	struct file *filp;
+	struct qstr name;
+
+	filp = get_empty_filp();
+	if (!filp)
+		goto err;
+
+	inode = new_inode(revokefs_mnt->mnt_sb);
+	if (!inode)
+		goto err_inode;
+
+	name.name = "revoked_file";
+	name.len = strlen(name.name);
+	dentry = d_alloc(revokefs_mnt->mnt_sb->s_root, &name);
+	if (!dentry)
+		goto err_dentry;
+
+	d_instantiate(dentry, inode);
+
+	filp->f_mapping = inode->i_mapping;
+	filp->f_dentry = dget(dentry);
+	filp->f_vfsmnt = mntget(revokefs_mnt);
+	filp->f_op = fops_get(inode->i_fop);
+	filp->f_pos = 0;
+
+	return filp;
+
+  err_dentry:
+	iput(inode);
+  err_inode:
+	fput(filp);
+  err:
+	return NULL;
+}
+
+static inline bool can_revoke_file(struct file *file, struct inode *inode,
+				   struct file *to_exclude)
+{
+	if (!file || file == to_exclude)
+		return false;
+
+	return file->f_dentry->d_inode == inode;
+}
+
+/*
+ * 	LOCKING: task_lock(owner)
+ */
+static int revoke_fds(struct task_struct *owner,
+		      struct inode *inode,
+		      struct file *to_exclude, struct fileset *fset)
+{
+	struct files_struct *files;
+	struct fdtable *fdt;
+	unsigned int fd;
+	int err = 0;
+
+	files = get_files_struct(owner);
+	if (!files)
+		goto out;
+
+	spin_lock(&files->file_lock);
+	fdt = files_fdtable(files);
+
+	for (fd = 0; fd < fdt->max_fds; fd++) {
+		struct revokefs_inode_info *info;
+		struct file *filp, *new_filp;
+		struct inode *new_inode;
+
+		filp = fcheck_files(files, fd);
+		if (!can_revoke_file(filp, inode, to_exclude))
+			continue;
+
+		if (!filp->f_op->revoke) {
+			err = -EOPNOTSUPP;
+			goto failed;
+		}
+
+		if (fset_is_full(fset)) {
+			err = -ENOMEM;
+			goto failed;
+		}
+
+		new_filp = fset_get_filp(fset);
+
+		/*
+		 * Replace original struct file pointer with a pointer to
+		 * a 'revoked file.'  After this point, we don't need to worry
+		 * about racing with sys_close or sys_dup.
+		 */
+		rcu_assign_pointer(fdt->fd[fd], new_filp);
+
+		/*
+		 * Hold on to task until we can take down the file and its
+		 * mmap.
+		 */
+		get_task_struct(owner);
+
+		new_inode = new_filp->f_dentry->d_inode;
+		make_revoked_inode(new_inode, inode->i_mode & S_IFMT);
+
+		info = revokefs_i(new_inode);
+		info->fd = fd;
+		info->file = filp;
+		info->owner = owner;
+	}
+  failed:
+	spin_unlock(&files->file_lock);
+	put_files_struct(files);
+  out:
+	return err;
+}
+
+static inline bool can_revoke_vma(struct vm_area_struct *vma,
+				  struct inode *inode, struct file *to_exclude)
+{
+	struct file *file = vma->vm_file;
+
+	if (vma->vm_flags & VM_REVOKED)
+		return false;
+
+	if (!file || file == to_exclude)
+		return false;
+
+	return file->f_path.dentry->d_inode == inode;
+}
+
+static int __revoke_break_cow(struct task_struct *tsk, struct inode *inode,
+			      struct file *to_exclude)
+{
+	struct mm_struct *mm = tsk->mm;
+	struct vm_area_struct *vma;
+	int err = 0;
+
+	down_read(&mm->mmap_sem);
+	for (vma = mm->mmap; vma != NULL; vma = vma->vm_next) {
+		int ret;
+
+		if (vma->vm_flags & VM_SHARED)
+			continue;
+
+		if (!can_revoke_vma(vma, inode, to_exclude))
+			continue;
+
+		ret = get_user_pages(tsk, tsk->mm, vma->vm_start,
+				     vma_pages(vma), 1, 1, NULL, NULL);
+		if (ret < 0) {
+			err = ret;
+			break;
+		}
+
+		unlink_file_vma(vma);
+		fput(vma->vm_file);
+		vma->vm_file = NULL;
+	}
+	up_read(&mm->mmap_sem);
+	return err;
+}
+
+static int revoke_break_cow(struct fileset *fset, struct inode *inode,
+			    struct file *to_exclude)
+{
+	unsigned long i;
+	int err = 0;
+
+	for (i = 0; i < fset->end; i++) {
+		struct revokefs_inode_info *info;
+		struct file *this;
+
+		this = fset->files[i];
+		info = revokefs_i(this->f_dentry->d_inode);
+
+		err = __revoke_break_cow(info->owner, inode, to_exclude);
+		if (err)
+			break;
+	}
+	return err;
+}
+
+/*
+ *	 LOCKING: down_write(&mm->mmap_sem)
+ *	 	    -> spin_lock(&mapping->i_mmap_lock)
+ */
+static int revoke_vma(struct vm_area_struct *vma, struct zap_details *details)
+{
+	unsigned long restart_addr, start_addr, end_addr;
+	int need_break;
+
+	start_addr = vma->vm_start;
+	end_addr = vma->vm_end;
+
+  again:
+	restart_addr = zap_page_range(vma, start_addr, end_addr - start_addr,
+				      details);
+
+	need_break = need_resched() || need_lockbreak(details->i_mmap_lock);
+	if (need_break)
+		goto out_need_break;
+
+	if (restart_addr < end_addr) {
+		start_addr = restart_addr;
+		goto again;
+	}
+	vma->vm_flags |= VM_REVOKED;
+	return 0;
+
+  out_need_break:
+	spin_unlock(details->i_mmap_lock);
+	cond_resched();
+	spin_lock(details->i_mmap_lock);
+	return -EINTR;
+}
+
+/*
+ *	LOCKING: spin_lock(&mapping->i_mmap_lock)
+ */
+static int revoke_mm(struct mm_struct *mm, struct address_space *mapping,
+		     struct file *to_exclude)
+{
+	struct vm_area_struct *vma;
+	struct zap_details details;
+	int err = 0;
+
+	details.i_mmap_lock = &mapping->i_mmap_lock;
+
+	/*
+ 	 * If ->mmap_sem is under contention, we continue scanning other
+ 	 * mms and try again later.
+ 	 */
+	if (!down_write_trylock(&mm->mmap_sem)) {
+		err = -EAGAIN;
+		goto out;
+	}
+	for (vma = mm->mmap; vma != NULL; vma = vma->vm_next) {
+		if (!(vma->vm_flags & VM_SHARED))
+			continue;
+
+		if (!can_revoke_vma(vma, mapping->host, to_exclude))
+			continue;
+
+		err = revoke_vma(vma, &details);
+		if (err)
+			break;
+
+		__unlink_file_vma(vma);
+		fput(vma->vm_file);
+		vma->vm_file = NULL;
+	}
+	up_write(&mm->mmap_sem);
+  out:
+	return err;
+}
+
+/*
+ *	LOCKING: spin_lock(&mapping->i_mmap_lock)
+ */
+static void revoke_mapping_tree(struct address_space *mapping,
+				struct file *to_exclude)
+{
+	struct vm_area_struct *vma;
+	struct prio_tree_iter iter;
+	int try_again = 0;
+
+  restart:
+	vma_prio_tree_foreach(vma, &iter, &mapping->i_mmap, 0, ULONG_MAX) {
+		int err;
+
+		if (!(vma->vm_flags & VM_SHARED))
+			continue;
+
+		if (likely(!can_revoke_vma(vma, mapping->host, to_exclude)))
+			continue;
+
+		err = revoke_mm(vma->vm_mm, mapping, to_exclude);
+		if (err == -EAGAIN)
+			try_again = 1;
+
+		goto restart;
+	}
+	if (try_again) {
+		cond_resched();
+		goto restart;
+	}
+}
+
+/*
+ *	LOCKING: spin_lock(&mapping->i_mmap_lock)
+ */
+static void revoke_mapping_list(struct address_space *mapping,
+				struct file *to_exclude)
+{
+	struct vm_area_struct *vma;
+	int try_again = 0;
+
+  restart:
+	list_for_each_entry(vma, &mapping->i_mmap_nonlinear, shared.vm_set.list) {
+		int err;
+
+		if (likely(!can_revoke_vma(vma, mapping->host, to_exclude)))
+			continue;
+
+		err = revoke_mm(vma->vm_mm, mapping, to_exclude);
+		if (err == -EAGAIN) {
+			try_again = 1;
+			continue;
+		}
+		if (err == -EINTR)
+			goto restart;
+	}
+	if (try_again) {
+		cond_resched();
+		goto restart;
+	}
+}
+
+static void revoke_mapping(struct address_space *mapping, struct file *to_exclude)
+{
+	spin_lock(&mapping->i_mmap_lock);
+	if (unlikely(!prio_tree_empty(&mapping->i_mmap)))
+		revoke_mapping_tree(mapping, to_exclude);
+	if (unlikely(!list_empty(&mapping->i_mmap_nonlinear)))
+		revoke_mapping_list(mapping, to_exclude);
+	spin_unlock(&mapping->i_mmap_lock);
+}
+
+static void restore_file(struct revokefs_inode_info *info)
+{
+	struct files_struct *files;
+
+	files = get_files_struct(info->owner);
+	if (files) {
+		struct fdtable *fdt;
+		struct file *filp;
+
+		spin_lock(&files->file_lock);
+		fdt = files_fdtable(files);
+
+		filp = fdt->fd[info->fd];
+		if (filp)
+			fput(filp);
+
+		rcu_assign_pointer(fdt->fd[info->fd], info->file);
+		FD_SET(info->fd, fdt->close_on_exec);
+		spin_unlock(&files->file_lock);
+		put_files_struct(files);
+	}
+	put_task_struct(info->owner);
+	info->owner = NULL;	/* To avoid double-restore. */
+}
+
+static void restore_files(struct revoke_details *details)
+{
+	unsigned long i;
+
+	for (i = details->restore_start; i < details->fset->end; i++) {
+		struct revokefs_inode_info *info;
+		struct file *filp;
+
+		filp = details->fset->files[i];
+		info = revokefs_i(filp->f_dentry->d_inode);
+
+		restore_file(info);
+	}
+}
+
+static int revoke_files(struct revoke_details *details)
+{
+	unsigned long i;
+	int err = 0;
+
+	for (i = 0; i < details->fset->end; i++) {
+		struct revokefs_inode_info *info;
+		struct file *this, *filp;
+		struct inode *inode;
+
+		this = details->fset->files[i];
+		inode = this->f_dentry->d_inode;
+		info = revokefs_i(inode);
+
+		/*
+		 * Increase count before attempting to close file as
+		 * an partially closed file can no longer be restored.
+		 */
+		details->restore_start++;
+		filp = info->file;
+		err = filp->f_op->revoke(filp, inode->i_mapping);
+		put_task_struct(info->owner);
+		info->owner = NULL;	/* To avoid restoring closed file. */
+		if (err)
+			goto out;
+	}
+  out:
+	return err;
+}
+
+/*
+ *	Returns the maximum number of file descriptors pointing to an inode.
+ *
+ *	LOCKING: read_lock(&tasklist_lock)
+ */
+static unsigned long inode_fds(struct inode *inode, struct file *to_exclude)
+{
+	struct task_struct *g, *p;
+	unsigned long nr_fds = 0;
+
+	do_each_thread(g, p) {
+		struct files_struct *files;
+		struct fdtable *fdt;
+		unsigned int fd;
+
+		files = get_files_struct(p);
+		if (!files)
+			continue;
+
+		spin_lock(&files->file_lock);
+		fdt = files_fdtable(files);
+		for (fd = 0; fd < fdt->max_fds; fd++) {
+			struct file *file;
+
+			file = fcheck_files(files, fd);
+			if (can_revoke_file(file, inode, to_exclude)) {
+				nr_fds += fdt->max_fds;
+				break;
+			}
+		}
+		spin_unlock(&files->file_lock);
+		put_files_struct(files);
+	}
+	while_each_thread(g, p);
+	return nr_fds;
+}
+
+static struct fileset *__alloc_revoke_fset(unsigned long size)
+{
+	struct fileset *fset;
+	int i;
+
+	fset = alloc_fset(size);
+	if (!fset)
+		return NULL;
+
+	for (i = 0; i < fset->nr; i++) {
+		struct file *filp;
+
+		filp = get_revoked_file();
+		if (!filp)
+			goto err;
+
+		fset->files[i] = filp;
+	}
+	return fset;
+  err:
+	free_fset(fset);
+	return NULL;
+}
+
+static int do_revoke(struct inode *inode, struct file *to_exclude)
+{
+	struct revoke_details details;
+	struct fileset *fset = NULL;
+	struct task_struct *g, *p;
+	unsigned long nr_fds;
+	int err = 0;
+
+	if (current->fsuid != inode->i_uid && !capable(CAP_FOWNER)) {
+		err = -EPERM;
+		goto out;
+	}
+
+  retry:
+	if (signal_pending(current)) {
+		err = -ERESTARTSYS;
+		goto out;
+	}
+
+	read_lock(&tasklist_lock);
+	nr_fds = inode_fds(inode, to_exclude);
+	read_unlock(&tasklist_lock);
+
+	if (!nr_fds)
+		goto out;
+
+	/*
+	 * Pre-allocate memory because the first pass is done under
+	 * tasklist_lock.
+	 */
+	fset = __alloc_revoke_fset(nr_fds);
+	if (!fset) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	read_lock(&tasklist_lock);
+
+	/*
+	 * If someone forked while we were allocating memory, try again.
+	 */
+	if (inode_fds(inode, to_exclude) > fset->nr) {
+		read_unlock(&tasklist_lock);
+		free_fset(fset);
+		goto retry;
+	}
+
+	details.fset = fset;
+	details.restore_start = 0;
+
+	/*
+	 * First revoke the descriptors. After we are done, no one can start
+	 * new operations on them.
+	 */
+	do_each_thread(g, p) {
+		err = revoke_fds(p, inode, to_exclude, fset);
+		if (err)
+			goto exit_loop;
+	}
+	while_each_thread(g, p);
+  exit_loop:
+	read_unlock(&tasklist_lock);
+
+	if (err)
+		goto out_restore;
+
+	/*
+	 * Take down shared memory mappings.
+	 */
+	revoke_mapping(inode->i_mapping, to_exclude);
+
+	/*
+ 	 * Break COW for private mappings.
+ 	 */
+	err = revoke_break_cow(fset, inode, to_exclude);
+	if (err)
+		goto out_restore;
+
+	/*
+	 * Now, revoke the files for good.
+	 */
+	err = revoke_files(&details);
+	if (err)
+		goto out_restore;
+
+  out_free_table:
+	free_fset(fset);
+  out:
+	return err;
+
+  out_restore:
+	restore_files(&details);
+	goto out_free_table;
+}
+
+asmlinkage long sys_revokeat(int dfd, const char __user * filename)
+{
+	struct nameidata nd;
+	int err;
+
+	err = __user_walk_fd(dfd, filename, 0, &nd);
+	if (!err) {
+		err = do_revoke(nd.dentry->d_inode, NULL);
+		path_release(&nd);
+	}
+	return err;
+}
+
+asmlinkage long sys_frevoke(unsigned int fd)
+{
+	struct file *file = fget(fd);
+	int err = -EBADF;
+
+	if (file) {
+		err = do_revoke(file->f_dentry->d_inode, file);
+		fput(file);
+	}
+	return err;
+}
+
+int generic_file_revoke(struct file *file, struct address_space *new_mapping)
+{
+	struct address_space *mapping = file->f_mapping;
+	int err;
+
+	/*
+	 * Flush pending writes.
+	 */
+	err = do_fsync(file, 1);
+	if (err)
+		goto out;
+
+	file->f_mapping = new_mapping;
+
+	/*
+	 * Make pending reads fail.
+	 */
+	err = invalidate_inode_pages2(mapping);
+
+  out:
+	return err;
+}
+EXPORT_SYMBOL(generic_file_revoke);
+
+/*
+ *	Filesystem for revoked files.
+ */
+
+static struct inode *revokefs_alloc_inode(struct super_block *sb)
+{
+	struct revokefs_inode_info *info;
+
+	info = kmem_cache_alloc(revokefs_inode_cache, GFP_KERNEL);
+	if (!info)
+		return NULL;
+
+	return &info->vfs_inode;
+}
+
+static void revokefs_destroy_inode(struct inode *inode)
+{
+	kmem_cache_free(revokefs_inode_cache, revokefs_i(inode));
+}
+
+static struct super_operations revokefs_super_ops = {
+	.alloc_inode = revokefs_alloc_inode,
+	.destroy_inode = revokefs_destroy_inode,
+	.drop_inode = generic_delete_inode,
+};
+
+static int revokefs_get_sb(struct file_system_type *fs_type,
+			   int flags, const char *dev_name, void *data,
+			   struct vfsmount *mnt)
+{
+	return get_sb_pseudo(fs_type, "revoke:", &revokefs_super_ops,
+			     REVOKEFS_MAGIC, mnt);
+}
+
+static struct file_system_type revokefs_fs_type = {
+	.name = "revokefs",
+	.get_sb = revokefs_get_sb,
+	.kill_sb = kill_anon_super
+};
+
+static void revokefs_init_inode(void *obj, struct kmem_cache *cache,
+				unsigned long flags)
+{
+	struct revokefs_inode_info *info = obj;
+
+	info->owner = NULL;
+	inode_init_once(&info->vfs_inode);
+}
+
+static int __init revokefs_init(void)
+{
+	int err = -ENOMEM;
+
+	revokefs_inode_cache =
+	    kmem_cache_create("revokefs_inode_cache",
+			      sizeof(struct revokefs_inode_info),
+			      0,
+			      (SLAB_HWCACHE_ALIGN | SLAB_RECLAIM_ACCOUNT |
+			       SLAB_MEM_SPREAD), revokefs_init_inode);
+	if (!revokefs_inode_cache)
+		goto out;
+
+	err = register_filesystem(&revokefs_fs_type);
+	if (err)
+		goto err_register;
+
+	revokefs_mnt = kern_mount(&revokefs_fs_type);
+	if (IS_ERR(revokefs_mnt)) {
+		err = PTR_ERR(revokefs_mnt);
+		goto err_mnt;
+	}
+  out:
+	return err;
+  err_mnt:
+	unregister_filesystem(&revokefs_fs_type);
+  err_register:
+	kmem_cache_destroy(revokefs_inode_cache);
+	return err;
+}
+
+late_initcall(revokefs_init);
diff -puN /dev/null fs/revoked_inode.c
--- /dev/null
+++ a/fs/revoked_inode.c
@@ -0,0 +1,417 @@
+/*
+ * fs/revoked_inode.c
+ *
+ * Copyright (C) 2007  Pekka Enberg
+ *
+ * Provide stub functions for revoked inodes. Based on fs/bad_inode.c which is
+ *
+ * Copyright (C) 1997  Stephen Tweedie
+ *
+ * This file is released under the GPLv2.
+ */
+
+#include <linux/fs.h>
+#include <linux/module.h>
+#include <linux/stat.h>
+#include <linux/time.h>
+#include <linux/smp_lock.h>
+#include <linux/namei.h>
+#include <linux/poll.h>
+#include <linux/revoked_fs_i.h>
+
+static loff_t revoked_file_llseek(struct file *file, loff_t offset, int origin)
+{
+	return -EBADF;
+}
+
+static ssize_t revoked_file_read(struct file *filp, char __user * buf,
+				 size_t size, loff_t * ppos)
+{
+	return -EBADF;
+}
+
+static ssize_t revoked_special_file_read(struct file *filp, char __user * buf,
+					 size_t size, loff_t * ppos)
+{
+	return 0;
+}
+
+static ssize_t revoked_file_write(struct file *filp, const char __user * buf,
+				  size_t siz, loff_t * ppos)
+{
+	return -EBADF;
+}
+
+static ssize_t revoked_file_aio_read(struct kiocb *iocb,
+				     const struct iovec *iov,
+				     unsigned long nr_segs, loff_t pos)
+{
+	return -EBADF;
+}
+
+static ssize_t revoked_file_aio_write(struct kiocb *iocb,
+				      const struct iovec *iov,
+				      unsigned long nr_segs, loff_t pos)
+{
+	return -EBADF;
+}
+
+static int revoked_file_readdir(struct file *filp, void *dirent,
+				filldir_t filldir)
+{
+	return -EBADF;
+}
+
+static unsigned int revoked_file_poll(struct file *filp, poll_table * wait)
+{
+	return POLLERR;
+}
+
+static int revoked_file_ioctl(struct inode *inode, struct file *filp,
+			      unsigned int cmd, unsigned long arg)
+{
+	return -EBADF;
+}
+
+static long revoked_file_unlocked_ioctl(struct file *file, unsigned cmd,
+					unsigned long arg)
+{
+	return -EBADF;
+}
+
+static long revoked_file_compat_ioctl(struct file *file, unsigned int cmd,
+				      unsigned long arg)
+{
+	return -EBADF;
+}
+
+static int revoked_file_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	return -EBADF;
+}
+
+static int revoked_file_open(struct inode *inode, struct file *filp)
+{
+	return -EBADF;
+}
+
+static int revoked_file_flush(struct file *file, fl_owner_t id)
+{
+	return filp_close(file, id);
+}
+
+static int revoked_file_release(struct inode *inode, struct file *filp)
+{
+	return -EBADF;
+}
+
+static int revoked_file_fsync(struct file *file, struct dentry *dentry,
+			      int datasync)
+{
+	return -EBADF;
+}
+
+static int revoked_file_aio_fsync(struct kiocb *iocb, int datasync)
+{
+	return -EBADF;
+}
+
+static int revoked_file_fasync(int fd, struct file *filp, int on)
+{
+	return -EBADF;
+}
+
+static int revoked_file_lock(struct file *file, int cmd, struct file_lock *fl)
+{
+	return -EBADF;
+}
+
+static ssize_t revoked_file_sendfile(struct file *in_file, loff_t * ppos,
+				     size_t count, read_actor_t actor,
+				     void *target)
+{
+	return -EBADF;
+}
+
+static ssize_t revoked_file_sendpage(struct file *file, struct page *page,
+				     int off, size_t len, loff_t * pos,
+				     int more)
+{
+	return -EBADF;
+}
+
+static unsigned long revoked_file_get_unmapped_area(struct file *file,
+						    unsigned long addr,
+						    unsigned long len,
+						    unsigned long pgoff,
+						    unsigned long flags)
+{
+	return -EBADF;
+}
+
+static int revoked_file_check_flags(int flags)
+{
+	return -EBADF;
+}
+
+static int revoked_file_dir_notify(struct file *file, unsigned long arg)
+{
+	return -EBADF;
+}
+
+static int revoked_file_flock(struct file *filp, int cmd, struct file_lock *fl)
+{
+	return -EBADF;
+}
+
+static ssize_t revoked_file_splice_write(struct pipe_inode_info *pipe,
+					 struct file *out, loff_t * ppos,
+					 size_t len, unsigned int flags)
+{
+	return -EBADF;
+}
+
+static ssize_t revoked_file_splice_read(struct file *in, loff_t * ppos,
+					struct pipe_inode_info *pipe,
+					size_t len, unsigned int flags)
+{
+	return -EBADF;
+}
+
+static const struct file_operations revoked_file_ops = {
+	.llseek = revoked_file_llseek,
+	.read = revoked_file_read,
+	.write = revoked_file_write,
+	.aio_read = revoked_file_aio_read,
+	.aio_write = revoked_file_aio_write,
+	.readdir = revoked_file_readdir,
+	.poll = revoked_file_poll,
+	.ioctl = revoked_file_ioctl,
+	.unlocked_ioctl = revoked_file_unlocked_ioctl,
+	.compat_ioctl = revoked_file_compat_ioctl,
+	.mmap = revoked_file_mmap,
+	.open = revoked_file_open,
+	.flush = revoked_file_flush,
+	.release = revoked_file_release,
+	.fsync = revoked_file_fsync,
+	.aio_fsync = revoked_file_aio_fsync,
+	.fasync = revoked_file_fasync,
+	.lock = revoked_file_lock,
+	.sendfile = revoked_file_sendfile,
+	.sendpage = revoked_file_sendpage,
+	.get_unmapped_area = revoked_file_get_unmapped_area,
+	.check_flags = revoked_file_check_flags,
+	.dir_notify = revoked_file_dir_notify,
+	.flock = revoked_file_flock,
+	.splice_write = revoked_file_splice_write,
+	.splice_read = revoked_file_splice_read,
+};
+
+static const struct file_operations revoked_special_file_ops = {
+	.llseek = revoked_file_llseek,
+	.read = revoked_special_file_read,
+	.write = revoked_file_write,
+	.aio_read = revoked_file_aio_read,
+	.aio_write = revoked_file_aio_write,
+	.readdir = revoked_file_readdir,
+	.poll = revoked_file_poll,
+	.ioctl = revoked_file_ioctl,
+	.unlocked_ioctl = revoked_file_unlocked_ioctl,
+	.compat_ioctl = revoked_file_compat_ioctl,
+	.mmap = revoked_file_mmap,
+	.open = revoked_file_open,
+	.flush = revoked_file_flush,
+	.release = revoked_file_release,
+	.fsync = revoked_file_fsync,
+	.aio_fsync = revoked_file_aio_fsync,
+	.fasync = revoked_file_fasync,
+	.lock = revoked_file_lock,
+	.sendfile = revoked_file_sendfile,
+	.sendpage = revoked_file_sendpage,
+	.get_unmapped_area = revoked_file_get_unmapped_area,
+	.check_flags = revoked_file_check_flags,
+	.dir_notify = revoked_file_dir_notify,
+	.flock = revoked_file_flock,
+	.splice_write = revoked_file_splice_write,
+	.splice_read = revoked_file_splice_read,
+};
+
+static int revoked_inode_create(struct inode *dir, struct dentry *dentry,
+				int mode, struct nameidata *nd)
+{
+	return -EBADF;
+}
+
+static struct dentry *revoked_inode_lookup(struct inode *dir,
+					   struct dentry *dentry,
+					   struct nameidata *nd)
+{
+	return ERR_PTR(-EBADF);
+}
+
+static int revoked_inode_link(struct dentry *old_dentry, struct inode *dir,
+			      struct dentry *dentry)
+{
+	return -EBADF;
+}
+
+static int revoked_inode_unlink(struct inode *dir, struct dentry *dentry)
+{
+	return -EBADF;
+}
+
+static int revoked_inode_symlink(struct inode *dir, struct dentry *dentry,
+				 const char *symname)
+{
+	return -EBADF;
+}
+
+static int revoked_inode_mkdir(struct inode *dir, struct dentry *dentry,
+			       int mode)
+{
+	return -EBADF;
+}
+
+static int revoked_inode_rmdir(struct inode *dir, struct dentry *dentry)
+{
+	return -EBADF;
+}
+
+static int revoked_inode_mknod(struct inode *dir, struct dentry *dentry,
+			       int mode, dev_t rdev)
+{
+	return -EBADF;
+}
+
+static int revoked_inode_rename(struct inode *old_dir,
+				struct dentry *old_dentry,
+				struct inode *new_dir,
+				struct dentry *new_dentry)
+{
+	return -EBADF;
+}
+
+static int revoked_inode_readlink(struct dentry *dentry, char __user * buffer,
+				  int buflen)
+{
+	return -EBADF;
+}
+
+static int revoked_inode_permission(struct inode *inode, int mask,
+				    struct nameidata *nd)
+{
+	return -EBADF;
+}
+
+static int revoked_inode_getattr(struct vfsmount *mnt, struct dentry *dentry,
+				 struct kstat *stat)
+{
+	return -EBADF;
+}
+
+static int revoked_inode_setattr(struct dentry *direntry, struct iattr *attrs)
+{
+	return -EBADF;
+}
+
+static int revoked_inode_setxattr(struct dentry *dentry, const char *name,
+				  const void *value, size_t size, int flags)
+{
+	return -EBADF;
+}
+
+static ssize_t revoked_inode_getxattr(struct dentry *dentry, const char *name,
+				      void *buffer, size_t size)
+{
+	return -EBADF;
+}
+
+static ssize_t revoked_inode_listxattr(struct dentry *dentry, char *buffer,
+				       size_t buffer_size)
+{
+	return -EBADF;
+}
+
+static int revoked_inode_removexattr(struct dentry *dentry, const char *name)
+{
+	return -EBADF;
+}
+
+static struct inode_operations revoked_inode_ops = {
+	.create = revoked_inode_create,
+	.lookup = revoked_inode_lookup,
+	.link = revoked_inode_link,
+	.unlink = revoked_inode_unlink,
+	.symlink = revoked_inode_symlink,
+	.mkdir = revoked_inode_mkdir,
+	.rmdir = revoked_inode_rmdir,
+	.mknod = revoked_inode_mknod,
+	.rename = revoked_inode_rename,
+	.readlink = revoked_inode_readlink,
+	/* follow_link must be no-op, otherwise unmounting this inode
+	   won't work */
+	/* put_link returns void */
+	/* truncate returns void */
+	.permission = revoked_inode_permission,
+	.getattr = revoked_inode_getattr,
+	.setattr = revoked_inode_setattr,
+	.setxattr = revoked_inode_setxattr,
+	.getxattr = revoked_inode_getxattr,
+	.listxattr = revoked_inode_listxattr,
+	.removexattr = revoked_inode_removexattr,
+	/* truncate_range returns void */
+};
+
+static int revoked_readpage(struct file *file, struct page *page)
+{
+	return -EIO;
+}
+
+static int revoked_writepage(struct page *page, struct writeback_control *wbc)
+{
+	return -EIO;
+}
+
+static int revoked_prepare_write(struct file *file, struct page *page,
+				 unsigned from, unsigned to)
+{
+	return -EIO;
+}
+
+static int revoked_commit_write(struct file *file, struct page *page,
+				unsigned from, unsigned to)
+{
+	return -EIO;
+}
+
+static ssize_t revoked_direct_IO(int rw, struct kiocb *iocb,
+				 const struct iovec *iov, loff_t offset,
+				 unsigned long nr_segs)
+{
+	return -EIO;
+}
+
+static const struct address_space_operations revoked_aops = {
+        .readpage       = revoked_readpage,
+        .writepage      = revoked_writepage,
+        .prepare_write  = revoked_prepare_write,
+        .commit_write   = revoked_commit_write,
+        .direct_IO      = revoked_direct_IO,
+};
+
+void make_revoked_inode(struct inode *inode, int mode)
+{
+	remove_inode_hash(inode);
+
+	inode->i_mode = mode;
+	inode->i_atime = inode->i_mtime = inode->i_ctime =
+	    current_fs_time(inode->i_sb);
+	inode->i_op = &revoked_inode_ops;
+
+	if (special_file(mode))
+		inode->i_fop = &revoked_special_file_ops;
+	else
+		inode->i_fop = &revoked_file_ops;
+
+	inode->i_mapping->a_ops = &revoked_aops;
+}
diff -puN include/linux/fs.h~revoke-core-code include/linux/fs.h
--- a/include/linux/fs.h~revoke-core-code
+++ a/include/linux/fs.h
@@ -1198,6 +1198,7 @@ struct file_operations {
 	ssize_t (*splice_write)(struct pipe_inode_info *, struct file *, loff_t *, size_t, unsigned int);
 	ssize_t (*splice_read)(struct file *, loff_t *, struct pipe_inode_info *, size_t, unsigned int);
 	int (*setlease)(struct file *, long, struct file_lock **);
+	int (*revoke)(struct file *, struct address_space *);
 };
 
 struct inode_operations {
@@ -1829,6 +1830,13 @@ extern ssize_t generic_splice_sendpage(s
 extern long do_splice_direct(struct file *in, loff_t *ppos, struct file *out,
 		size_t len, unsigned int flags);
 
+/* fs/revoke.c */
+#ifdef CONFIG_MMU
+extern int generic_file_revoke(struct file *, struct address_space *);
+#else
+#define generic_file_revoke NULL
+#endif
+
 extern void
 file_ra_state_init(struct file_ra_state *ra, struct address_space *mapping);
 extern loff_t no_llseek(struct file *file, loff_t offset, int origin);
diff -puN include/linux/magic.h~revoke-core-code include/linux/magic.h
--- a/include/linux/magic.h~revoke-core-code
+++ a/include/linux/magic.h
@@ -34,6 +34,7 @@
 #define REISERFS_SUPER_MAGIC_STRING	"ReIsErFs"
 #define REISER2FS_SUPER_MAGIC_STRING	"ReIsEr2Fs"
 #define REISER2FS_JR_SUPER_MAGIC_STRING	"ReIsEr3Fs"
+#define REVOKEFS_MAGIC		0x5245564B      /* REVK */
 
 #define UNIONFS_SUPER_MAGIC 0xf15f083d
 
diff -puN include/linux/mm.h~revoke-core-code include/linux/mm.h
--- a/include/linux/mm.h~revoke-core-code
+++ a/include/linux/mm.h
@@ -1017,6 +1017,7 @@ extern int split_vma(struct mm_struct *,
 extern int insert_vm_struct(struct mm_struct *, struct vm_area_struct *);
 extern void __vma_link_rb(struct mm_struct *, struct vm_area_struct *,
 	struct rb_node **, struct rb_node *);
+extern void __unlink_file_vma(struct vm_area_struct *);
 extern void unlink_file_vma(struct vm_area_struct *);
 extern struct vm_area_struct *copy_vma(struct vm_area_struct **,
 	unsigned long addr, unsigned long len, pgoff_t pgoff);
diff -puN /dev/null include/linux/revoked_fs_i.h
--- /dev/null
+++ a/include/linux/revoked_fs_i.h
@@ -0,0 +1,18 @@
+#ifndef _LINUX_REVOKED_FS_I_H
+#define _LINUX_REVOKED_FS_I_H
+
+struct revokefs_inode_info {
+	struct task_struct *owner;
+	struct file *file;
+	unsigned int fd;
+	struct inode vfs_inode;
+};
+
+static inline struct revokefs_inode_info *revokefs_i(struct inode *inode)
+{
+	return container_of(inode, struct revokefs_inode_info, vfs_inode);
+}
+
+void make_revoked_inode(struct inode *, int);
+
+#endif
diff -puN include/linux/syscalls.h~revoke-core-code include/linux/syscalls.h
--- a/include/linux/syscalls.h~revoke-core-code
+++ a/include/linux/syscalls.h
@@ -614,4 +614,7 @@ asmlinkage long sys_fallocate(int fd, in
 
 int kernel_execve(const char *filename, char *const argv[], char *const envp[]);
 
+asmlinkage long sys_revokeat(int dfd, const char __user *filename);
+asmlinkage long sys_frevoke(unsigned int fd);
+
 #endif
diff -puN mm/mmap.c~revoke-core-code mm/mmap.c
--- a/mm/mmap.c~revoke-core-code
+++ a/mm/mmap.c
@@ -205,6 +205,17 @@ static void __remove_shared_vm_struct(st
 }
 
 /*
+ * Requires inode->i_mapping->i_mmap_lock
+ */
+void __unlink_file_vma(struct vm_area_struct *vma)
+{
+	struct file *file = vma->vm_file;
+	struct address_space *mapping = file->f_mapping;
+
+	__remove_shared_vm_struct(vma, file, mapping);
+}
+
+/*
  * Unlink a file-based vm structure from its prio_tree, to hide
  * vma from rmap and vmtruncate before freeing its page tables.
  */
_

Patches currently in -mm which might be from penberg@cs.helsinki.fi are

git-unionfs.patch
slub-consolidate-add_partial-and-add_partial_tail-to-one-function.patch
slub-fix-coding-style-violations.patch
slub-fix-coding-style-violations-checkpatch-fixes.patch
slub-noinline-some-functions-to-avoid-them-being-folded-into-alloc-free.patch
slub-move-kmem_cache_node-determination-into-add_full-and-add_partial.patch
slub-avoid-checking-for-a-valid-object-before-zeroing-on-the-fast-path.patch
slub-__slab_alloc-exit-path-consolidation.patch
slub-provide-unique-end-marker-for-each-slab.patch
slub-provide-unique-end-marker-for-each-slab-fix.patch
slub-avoid-referencing-kmem_cache-structure-in-__slab_alloc.patch
slub-optional-fast-path-using-cmpxchg_local.patch
slub-do-our-own-locking-via-slab_lock-and-slab_unlock.patch
slub-do-our-own-locking-via-slab_lock-and-slab_unlock-checkpatch-fixes.patch
slub-restructure-slab-alloc.patch
revoke-core-code.patch
revoke-support-for-ext2-and-ext3.patch
revoke-add-documentation.patch
revoke-wire-up-i386-system-calls.patch
revoke-vs-git-block.patch
slab-leaks3-default-y.patch
