From: akpm@linux-foundation.org
Subject: [merged] ext4-add-ext4_get_block_dax.patch removed from -mm tree
Date: Wed, 09 Sep 2015 12:43:21 -0700
Message-ID: <55f08bd9.z0VaSNsOLgL0z4zT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38815 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753382AbbIITnV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2015 15:43:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: willy@linux.intel.com, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: ext4: add ext4_get_block_dax()
has been removed from the -mm tree.  Its filename was
     ext4-add-ext4_get_block_dax.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Matthew Wilcox <willy@linux.intel.com>
Subject: ext4: add ext4_get_block_dax()

DAX wants different semantics from any currently-existing ext4 get_block
callback.  Unlike ext4_get_block_write(), it needs to honour the 'create'
flag, and unlike ext4_get_block(), it needs to be able to return unwritten
extents.  So introduce a new ext4_get_block_dax() which has those
semantics.  We could also change ext4_get_block_write() to honour the
'create' flag, but that might have consequences on other users that I do
not currently understand.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/ext4.h  |    2 ++
 fs/ext4/file.c  |    6 +++---
 fs/ext4/inode.c |   11 +++++++++++
 3 files changed, 16 insertions(+), 3 deletions(-)

diff -puN fs/ext4/ext4.h~ext4-add-ext4_get_block_dax fs/ext4/ext4.h
--- a/fs/ext4/ext4.h~ext4-add-ext4_get_block_dax
+++ a/fs/ext4/ext4.h
@@ -2272,6 +2272,8 @@ struct buffer_head *ext4_getblk(handle_t
 struct buffer_head *ext4_bread(handle_t *, struct inode *, ext4_lblk_t, int);
 int ext4_get_block_write(struct inode *inode, sector_t iblock,
 			 struct buffer_head *bh_result, int create);
+int ext4_get_block_dax(struct inode *inode, sector_t iblock,
+			 struct buffer_head *bh_result, int create);
 int ext4_get_block(struct inode *inode, sector_t iblock,
 				struct buffer_head *bh_result, int create);
 int ext4_da_get_block_prep(struct inode *inode, sector_t iblock,
diff -puN fs/ext4/file.c~ext4-add-ext4_get_block_dax fs/ext4/file.c
--- a/fs/ext4/file.c~ext4-add-ext4_get_block_dax
+++ a/fs/ext4/file.c
@@ -207,19 +207,19 @@ static void ext4_end_io_unwritten(struct
 
 static int ext4_dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
-	return dax_fault(vma, vmf, ext4_get_block_write, ext4_end_io_unwritten);
+	return dax_fault(vma, vmf, ext4_get_block_dax, ext4_end_io_unwritten);
 }
 
 static int ext4_dax_pmd_fault(struct vm_area_struct *vma, unsigned long addr,
 						pmd_t *pmd, unsigned int flags)
 {
-	return dax_pmd_fault(vma, addr, pmd, flags, ext4_get_block_write,
+	return dax_pmd_fault(vma, addr, pmd, flags, ext4_get_block_dax,
 				ext4_end_io_unwritten);
 }
 
 static int ext4_dax_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
-	return dax_mkwrite(vma, vmf, ext4_get_block_write,
+	return dax_mkwrite(vma, vmf, ext4_get_block_dax,
 				ext4_end_io_unwritten);
 }
 
diff -puN fs/ext4/inode.c~ext4-add-ext4_get_block_dax fs/ext4/inode.c
--- a/fs/ext4/inode.c~ext4-add-ext4_get_block_dax
+++ a/fs/ext4/inode.c
@@ -3021,6 +3021,17 @@ static int ext4_get_block_write_nolock(s
 			       EXT4_GET_BLOCKS_NO_LOCK);
 }
 
+int ext4_get_block_dax(struct inode *inode, sector_t iblock,
+		   struct buffer_head *bh_result, int create)
+{
+	int flags = EXT4_GET_BLOCKS_PRE_IO | EXT4_GET_BLOCKS_UNWRIT_EXT;
+	if (create)
+		flags |= EXT4_GET_BLOCKS_CREATE;
+	ext4_debug("ext4_get_block_dax: inode %lu, create flag %d\n",
+		   inode->i_ino, create);
+	return _ext4_get_block(inode, iblock, bh_result, flags);
+}
+
 static void ext4_end_io_dio(struct kiocb *iocb, loff_t offset,
 			    ssize_t size, void *private)
 {
_

Patches currently in -mm which might be from willy@linux.intel.com are


