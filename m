From: akpm@linux-foundation.org
Subject: + nilfs2-file-operations.patch added to -mm tree
Date: Wed, 17 Sep 2008 13:27:55 -0700
Message-ID: <200809172027.m8HKRthj028998@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48742 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753963AbYIQU2C (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Sep 2008 16:28:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: konishi.ryusuke@lab.ntt.co.jp


The patch titled
     nilfs2: file operations
has been added to the -mm tree.  Its filename is
     nilfs2-file-operations.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

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

nilfs2-add-document.patch
nilfs2-disk-format-and-userland-interface.patch
nilfs2-add-inode-and-other-major-structures.patch
nilfs2-integrated-block-mapping.patch
nilfs2-b-tree-based-block-mapping.patch
nilfs2-direct-block-mapping.patch
nilfs2-b-tree-node-cache.patch
nilfs2-buffer-and-page-operations.patch
nilfs2-meta-data-file.patch
nilfs2-persistent-object-allocator.patch
nilfs2-disk-address-translator.patch
nilfs2-inode-map-file.patch
nilfs2-checkpoint-file.patch
nilfs2-segment-usage-file.patch
nilfs2-inode-operations.patch
nilfs2-file-operations.patch
nilfs2-directory-entry-operations.patch
nilfs2-pathname-operations.patch
nilfs2-operations-for-the_nilfs-core-object.patch
nilfs2-super-block-operations.patch
nilfs2-segment-buffer.patch
nilfs2-segment-constructor.patch
nilfs2-recovery-functions.patch
nilfs2-another-dat-for-garbage-collection.patch
nilfs2-block-cache-for-garbage-collection.patch
nilfs2-ioctl-operations.patch
nilfs2-update-makefile-and-kconfig.patch

