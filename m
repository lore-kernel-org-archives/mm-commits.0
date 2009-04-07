From: akpm@linux-foundation.org
Subject: [merged] nilfs2-file-operations.patch removed from -mm tree
Date: Tue, 07 Apr 2009 12:08:42 -0700
Message-ID: <200904071908.n37J8gg5011928@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52935 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753366AbZDGTpM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Apr 2009 15:45:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: konishi.ryusuke@lab.ntt.co.jp, mm-commits@vger.kernel.org


The patch titled
     nilfs2: file operations
has been removed from the -mm tree.  Its filename was
     nilfs2-file-operations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: nilfs2: file operations
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

This adds primitives for regular file handling.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/file.c |  125 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 125 insertions(+)

diff -puN /dev/null fs/nilfs2/file.c
--- /dev/null
+++ a/fs/nilfs2/file.c
@@ -0,0 +1,125 @@
+/*
+ * file.c - NILFS regular file handling primitives including fsync().
+ *
+ * Copyright (C) 2005-2008 Nippon Telegraph and Telephone Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ *
+ * Written by Amagai Yoshiji <amagai@osrg.net>,
+ *            Ryusuke Konishi <ryusuke@osrg.net>
+ */
+
+#include <linux/fs.h>
+#include <linux/mm.h>
+#include <linux/writeback.h>
+#include "nilfs.h"
+#include "segment.h"
+
+int nilfs_sync_file(struct file *file, struct dentry *dentry, int datasync)
+{
+	/*
+	 * Called from fsync() system call
+	 * This is the only entry point that can catch write and synch
+	 * timing for both data blocks and intermediate blocks.
+	 *
+	 * This function should be implemented when the writeback function
+	 * will be implemented.
+	 */
+	struct inode *inode = dentry->d_inode;
+	int err;
+
+	if (!nilfs_inode_dirty(inode))
+		return 0;
+
+	if (datasync)
+		err = nilfs_construct_dsync_segment(inode->i_sb, inode);
+	else
+		err = nilfs_construct_segment(inode->i_sb);
+
+	return err;
+}
+
+static ssize_t
+nilfs_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
+		     unsigned long nr_segs, loff_t pos)
+{
+	struct file *file = iocb->ki_filp;
+	struct inode *inode = file->f_dentry->d_inode;
+	ssize_t ret;
+
+	ret = generic_file_aio_write(iocb, iov, nr_segs, pos);
+	if (ret <= 0)
+		return ret;
+
+	if ((file->f_flags & O_SYNC) || IS_SYNC(inode)) {
+		int err;
+
+		err = nilfs_construct_dsync_segment(inode->i_sb, inode);
+		if (unlikely(err))
+			return err;
+	}
+	return ret;
+}
+
+static int nilfs_page_mkwrite(struct vm_area_struct *vma, struct page *page)
+{
+	if (!(vma->vm_flags & (VM_WRITE | VM_MAYWRITE)))
+		return -EPERM;
+	SetPageChecked(page);
+	wait_on_page_writeback(page);
+	return 0;
+}
+
+struct vm_operations_struct nilfs_file_vm_ops = {
+	.fault		= filemap_fault,
+	.page_mkwrite	= nilfs_page_mkwrite,
+};
+
+static int nilfs_file_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	file_accessed(file);
+	vma->vm_ops = &nilfs_file_vm_ops;
+	vma->vm_flags |= VM_CAN_NONLINEAR;
+	return 0;
+}
+
+/*
+ * We have mostly NULL's here: the current defaults are ok for
+ * the nilfs filesystem.
+ */
+struct file_operations nilfs_file_operations = {
+	.llseek		= generic_file_llseek,
+	.read		= do_sync_read,
+	.write		= do_sync_write,
+	.aio_read	= generic_file_aio_read,
+	.aio_write	= nilfs_file_aio_write,
+	.ioctl		= nilfs_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl	= nilfs_compat_ioctl,
+#endif	/* CONFIG_COMPAT */
+	.mmap		= nilfs_file_mmap,
+	.open		= generic_file_open,
+	/* .release	= nilfs_release_file, */
+	.fsync		= nilfs_sync_file,
+	.splice_read	= generic_file_splice_read,
+};
+
+struct inode_operations nilfs_file_inode_operations = {
+	.truncate	= nilfs_truncate,
+	.setattr	= nilfs_setattr,
+	.permission     = nilfs_permission,
+};
+
+/* end of file */
_

Patches currently in -mm which might be from konishi.ryusuke@lab.ntt.co.jp are

origin.patch

