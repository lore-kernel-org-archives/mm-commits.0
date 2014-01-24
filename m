From: akpm@linux-foundation.org
Subject: [merged] fs-ramfs-move-ramfs_aops-to-inodec.patch removed from
 -mm tree
Date: Fri, 24 Jan 2014 11:02:10 -0800
Message-ID: <52e2b8b2.NN0Ahgp2RfxmYG5m%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43682 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752950AbaAXTCK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 14:02:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, axel.lin@ingics.com

Subject: [merged] fs-ramfs-move-ramfs_aops-to-inodec.patch removed from -mm tree
To: axel.lin@ingics.com,viro@zeniv.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 11:02:10 -0800


The patch titled
     Subject: fs/ramfs: move ramfs_aops to inode.c
has been removed from the -mm tree.  Its filename was
     fs-ramfs-move-ramfs_aops-to-inodec.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Axel Lin <axel.lin@ingics.com>
Subject: fs/ramfs: move ramfs_aops to inode.c

ramfs_aops is identical in file-mmu.c and file-nommu.c.  Thus move it to
fs/ramfs/inode.c and make it static.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ramfs/file-mmu.c   |    7 -------
 fs/ramfs/file-nommu.c |    7 -------
 fs/ramfs/inode.c      |    7 +++++++
 fs/ramfs/internal.h   |    1 -
 4 files changed, 7 insertions(+), 15 deletions(-)

diff -puN fs/ramfs/file-mmu.c~fs-ramfs-move-ramfs_aops-to-inodec fs/ramfs/file-mmu.c
--- a/fs/ramfs/file-mmu.c~fs-ramfs-move-ramfs_aops-to-inodec
+++ a/fs/ramfs/file-mmu.c
@@ -30,13 +30,6 @@
 
 #include "internal.h"
 
-const struct address_space_operations ramfs_aops = {
-	.readpage	= simple_readpage,
-	.write_begin	= simple_write_begin,
-	.write_end	= simple_write_end,
-	.set_page_dirty = __set_page_dirty_no_writeback,
-};
-
 const struct file_operations ramfs_file_operations = {
 	.read		= do_sync_read,
 	.aio_read	= generic_file_aio_read,
diff -puN fs/ramfs/file-nommu.c~fs-ramfs-move-ramfs_aops-to-inodec fs/ramfs/file-nommu.c
--- a/fs/ramfs/file-nommu.c~fs-ramfs-move-ramfs_aops-to-inodec
+++ a/fs/ramfs/file-nommu.c
@@ -34,13 +34,6 @@ static unsigned long ramfs_nommu_get_unm
 						   unsigned long flags);
 static int ramfs_nommu_mmap(struct file *file, struct vm_area_struct *vma);
 
-const struct address_space_operations ramfs_aops = {
-	.readpage		= simple_readpage,
-	.write_begin		= simple_write_begin,
-	.write_end		= simple_write_end,
-	.set_page_dirty		= __set_page_dirty_no_writeback,
-};
-
 const struct file_operations ramfs_file_operations = {
 	.mmap			= ramfs_nommu_mmap,
 	.get_unmapped_area	= ramfs_nommu_get_unmapped_area,
diff -puN fs/ramfs/inode.c~fs-ramfs-move-ramfs_aops-to-inodec fs/ramfs/inode.c
--- a/fs/ramfs/inode.c~fs-ramfs-move-ramfs_aops-to-inodec
+++ a/fs/ramfs/inode.c
@@ -43,6 +43,13 @@
 static const struct super_operations ramfs_ops;
 static const struct inode_operations ramfs_dir_inode_operations;
 
+static const struct address_space_operations ramfs_aops = {
+	.readpage	= simple_readpage,
+	.write_begin	= simple_write_begin,
+	.write_end	= simple_write_end,
+	.set_page_dirty	= __set_page_dirty_no_writeback,
+};
+
 static struct backing_dev_info ramfs_backing_dev_info = {
 	.name		= "ramfs",
 	.ra_pages	= 0,	/* No readahead */
diff -puN fs/ramfs/internal.h~fs-ramfs-move-ramfs_aops-to-inodec fs/ramfs/internal.h
--- a/fs/ramfs/internal.h~fs-ramfs-move-ramfs_aops-to-inodec
+++ a/fs/ramfs/internal.h
@@ -10,5 +10,4 @@
  */
 
 
-extern const struct address_space_operations ramfs_aops;
 extern const struct inode_operations ramfs_file_inode_operations;
_

Patches currently in -mm which might be from axel.lin@ingics.com are

origin.patch
linux-next.patch

