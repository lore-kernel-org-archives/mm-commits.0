From: akpm@osdl.org
Subject: - unionfs-file-operations.patch removed from -mm tree
Date: Mon, 08 Jan 2007 13:09:43 -0800
Message-ID: <200701082109.l08L9hqn018994@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43549 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750878AbXAHVJz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 8 Jan 2007 16:09:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jsipek@cs.sunysb.edu, dquigley@fsl.cs.sunysb.edu, ezk@cs.sunysb.edu, mm-commits@vger.kernel.org


The patch titled
     unionfs: file operations
has been removed from the -mm tree.  Its filename was
     unionfs-file-operations.patch

This patch was dropped because I'll use the git tree

------------------------------------------------------
Subject: unionfs: file operations
From: Josef "Jeff" Sipek <jsipek@cs.sunysb.edu>

The file operations for Unionfs.

Signed-off-by: Josef "Jeff" Sipek <jsipek@cs.sunysb.edu>
Signed-off-by: David Quigley <dquigley@fsl.cs.sunysb.edu>
Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/unionfs/file.c |  257 ++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 257 insertions(+)

diff -puN /dev/null fs/unionfs/file.c
--- /dev/null
+++ a/fs/unionfs/file.c
@@ -0,0 +1,257 @@
+/*
+ * Copyright (c) 2003-2006 Erez Zadok
+ * Copyright (c) 2003-2006 Charles P. Wright
+ * Copyright (c) 2005-2006 Josef 'Jeff' Sipek
+ * Copyright (c) 2005-2006 Junjiro Okajima
+ * Copyright (c) 2005      Arun M. Krishnakumar
+ * Copyright (c) 2004-2006 David P. Quigley
+ * Copyright (c) 2003-2004 Mohammad Nayyer Zubair
+ * Copyright (c) 2003      Puja Gupta
+ * Copyright (c) 2003      Harikesavan Krishnan
+ * Copyright (c) 2003-2006 Stony Brook University
+ * Copyright (c) 2003-2006 The Research Foundation of State University of New York
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include "union.h"
+
+/* declarations for sparse */
+extern ssize_t unionfs_read(struct file *, char __user *, size_t, loff_t *);
+extern ssize_t unionfs_write(struct file *, const char __user *, size_t,
+			     loff_t *);
+
+/*******************
+ * File Operations *
+ *******************/
+
+static loff_t unionfs_llseek(struct file *file, loff_t offset, int origin)
+{
+	loff_t err;
+	struct file *hidden_file = NULL;
+
+	if ((err = unionfs_file_revalidate(file, 0)))
+		goto out;
+
+	hidden_file = unionfs_lower_file(file);
+	/* always set hidden position to this one */
+	hidden_file->f_pos = file->f_pos;
+
+	memcpy(&hidden_file->f_ra, &file->f_ra, sizeof(struct file_ra_state));
+
+	if (hidden_file->f_op && hidden_file->f_op->llseek)
+		err = hidden_file->f_op->llseek(hidden_file, offset, origin);
+	else
+		err = generic_file_llseek(hidden_file, offset, origin);
+
+	if (err < 0)
+		goto out;
+	if (err != file->f_pos) {
+		file->f_pos = err;
+		file->f_version++;
+	}
+out:
+	return err;
+}
+
+ssize_t unionfs_read(struct file * file, char __user * buf, size_t count,
+		     loff_t * ppos)
+{
+	struct file *hidden_file;
+	loff_t pos = *ppos;
+	int err;
+
+	if ((err = unionfs_file_revalidate(file, 0)))
+		goto out;
+
+	err = -EINVAL;
+	hidden_file = unionfs_lower_file(file);
+	if (!hidden_file->f_op || !hidden_file->f_op->read)
+		goto out;
+
+	err = hidden_file->f_op->read(hidden_file, buf, count, &pos);
+	*ppos = pos;
+
+out:
+	return err;
+}
+
+ssize_t __unionfs_write(struct file * file, const char __user * buf,
+			size_t count, loff_t * ppos)
+{
+	int err = -EINVAL;
+	struct file *hidden_file = NULL;
+	struct inode *inode;
+	struct inode *hidden_inode;
+	loff_t pos = *ppos;
+	int bstart, bend;
+
+	inode = file->f_dentry->d_inode;
+
+	bstart = fbstart(file);
+	bend = fbend(file);
+
+	BUG_ON(bstart == -1);
+
+	hidden_file = unionfs_lower_file(file);
+	hidden_inode = hidden_file->f_dentry->d_inode;
+
+	if (!hidden_file->f_op || !hidden_file->f_op->write)
+		goto out;
+
+	/* adjust for append -- seek to the end of the file */
+	if (file->f_flags & O_APPEND)
+		pos = inode->i_size;
+
+	err = hidden_file->f_op->write(hidden_file, buf, count, &pos);
+
+	/*
+	 * copy ctime and mtime from lower layer attributes
+	 * atime is unchanged for both layers
+	 */
+	if (err >= 0)
+		fsstack_copy_attr_times(inode, hidden_inode);
+
+	*ppos = pos;
+
+	/* update this inode's size */
+	if (pos > inode->i_size)
+		inode->i_size = pos;
+out:
+	return err;
+}
+
+ssize_t unionfs_write(struct file * file, const char __user * buf, size_t count,
+		      loff_t * ppos)
+{
+	int err = 0;
+
+	if ((err = unionfs_file_revalidate(file, 1)))
+		goto out;
+
+	err = __unionfs_write(file, buf, count, ppos);
+
+out:
+	return err;
+}
+
+static int unionfs_file_readdir(struct file *file, void *dirent,
+				filldir_t filldir)
+{
+	return -ENOTDIR;
+}
+
+static unsigned int unionfs_poll(struct file *file, poll_table * wait)
+{
+	unsigned int mask = DEFAULT_POLLMASK;
+	struct file *hidden_file = NULL;
+
+	if (unionfs_file_revalidate(file, 0)) {
+		/* We should pretend an error happend. */
+		mask = POLLERR | POLLIN | POLLOUT;
+		goto out;
+	}
+
+	hidden_file = unionfs_lower_file(file);
+
+	if (!hidden_file->f_op || !hidden_file->f_op->poll)
+		goto out;
+
+	mask = hidden_file->f_op->poll(hidden_file, wait);
+
+out:
+	return mask;
+}
+
+static int __do_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	int err;
+	struct file *hidden_file;
+
+	hidden_file = unionfs_lower_file(file);
+
+	err = -ENODEV;
+	if (!hidden_file->f_op || !hidden_file->f_op->mmap)
+		goto out;
+
+	vma->vm_file = hidden_file;
+	err = hidden_file->f_op->mmap(hidden_file, vma);
+	get_file(hidden_file);	/* make sure it doesn't get freed on us */
+	fput(file);		/* no need to keep extra ref on ours */
+out:
+	return err;
+}
+
+static int unionfs_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	int err = 0;
+	int willwrite;
+
+	/* This might could be deferred to mmap's writepage. */
+	willwrite = ((vma->vm_flags | VM_SHARED | VM_WRITE) == vma->vm_flags);
+	if ((err = unionfs_file_revalidate(file, willwrite)))
+		goto out;
+
+	err = __do_mmap(file, vma);
+
+out:
+	return err;
+}
+
+static int unionfs_fsync(struct file *file, struct dentry *dentry, int datasync)
+{
+	int err;
+	struct file *hidden_file = NULL;
+
+	if ((err = unionfs_file_revalidate(file, 1)))
+		goto out;
+
+	hidden_file = unionfs_lower_file(file);
+
+	err = -EINVAL;
+	if (!hidden_file->f_op || !hidden_file->f_op->fsync)
+		goto out;
+
+	mutex_lock(&hidden_file->f_dentry->d_inode->i_mutex);
+	err = hidden_file->f_op->fsync(hidden_file, hidden_file->f_dentry,
+				       datasync);
+	mutex_unlock(&hidden_file->f_dentry->d_inode->i_mutex);
+
+out:
+	return err;
+}
+
+static int unionfs_fasync(int fd, struct file *file, int flag)
+{
+	int err = 0;
+	struct file *hidden_file = NULL;
+
+	if ((err = unionfs_file_revalidate(file, 1)))
+		goto out;
+
+	hidden_file = unionfs_lower_file(file);
+
+	if (hidden_file->f_op && hidden_file->f_op->fasync)
+		err = hidden_file->f_op->fasync(fd, hidden_file, flag);
+
+out:
+	return err;
+}
+
+struct file_operations unionfs_main_fops = {
+	.llseek		= unionfs_llseek,
+	.read		= unionfs_read,
+	.write		= unionfs_write,
+	.readdir	= unionfs_file_readdir,
+	.poll		= unionfs_poll,
+	.unlocked_ioctl	= unionfs_ioctl,
+	.mmap		= unionfs_mmap,
+	.open		= unionfs_open,
+	.flush		= unionfs_flush,
+	.release	= unionfs_file_release,
+	.fsync		= unionfs_fsync,
+	.fasync		= unionfs_fasync,
+};
+
_

Patches currently in -mm which might be from jsipek@cs.sunysb.edu are

unionfs-file-operations.patch
unionfs-directory-file-operations.patch
unionfs-directory-manipulation-helper-functions.patch
unionfs-inode-operations.patch
unionfs-lookup-helper-functions.patch
unionfs-main-module-functions.patch
unionfs-readdir-state.patch
unionfs-rename.patch
unionfs-privileged-operations-workqueue.patch
unionfs-handling-of-stale-inodes.patch
unionfs-miscellaneous-helper-functions.patch
unionfs-superblock-operations.patch
unionfs-helper-macros-inlines.patch
unionfs-internal-include-file.patch
unionfs-include-file.patch
unionfs-unlink.patch
unionfs-kconfig-and-makefile.patch
unionfs-extended-attributes-support.patch
