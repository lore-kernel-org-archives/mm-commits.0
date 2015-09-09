From: akpm@linux-foundation.org
Subject: [merged] ext4-use-ext4_get_block_write-for-dax.patch removed from -mm tree
Date: Wed, 09 Sep 2015 12:43:15 -0700
Message-ID: <55f08bd3.t5H1aHCg+KuwCKLH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38805 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753382AbbIITnP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2015 15:43:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: willy@linux.intel.com, andy.rudoff@intel.com, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: ext4: use ext4_get_block_write() for DAX
has been removed from the -mm tree.  Its filename was
     ext4-use-ext4_get_block_write-for-dax.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Matthew Wilcox <willy@linux.intel.com>
Subject: ext4: use ext4_get_block_write() for DAX

DAX relies on the get_block function either zeroing newly allocated blocks
before they're findable by subsequent calls to get_block, or marking newly
allocated blocks as unwritten.  ext4_get_block() cannot create unwritten
extents, but ext4_get_block_write() can.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Reported-by: Andy Rudoff <andy.rudoff@intel.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/file.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN fs/ext4/file.c~ext4-use-ext4_get_block_write-for-dax fs/ext4/file.c
--- a/fs/ext4/file.c~ext4-use-ext4_get_block_write-for-dax
+++ a/fs/ext4/file.c
@@ -196,7 +196,7 @@ out:
 static void ext4_end_io_unwritten(struct buffer_head *bh, int uptodate)
 {
 	struct inode *inode = bh->b_assoc_map->host;
-	/* XXX: breaks on 32-bit > 16GB. Is that even supported? */
+	/* XXX: breaks on 32-bit > 16TB. Is that even supported? */
 	loff_t offset = (loff_t)(uintptr_t)bh->b_private << inode->i_blkbits;
 	int err;
 	if (!uptodate)
@@ -207,8 +207,7 @@ static void ext4_end_io_unwritten(struct
 
 static int ext4_dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
-	return dax_fault(vma, vmf, ext4_get_block, ext4_end_io_unwritten);
-					/* Is this the right get_block? */
+	return dax_fault(vma, vmf, ext4_get_block_write, ext4_end_io_unwritten);
 }
 
 static int ext4_dax_pmd_fault(struct vm_area_struct *vma, unsigned long addr,
@@ -220,7 +219,8 @@ static int ext4_dax_pmd_fault(struct vm_
 
 static int ext4_dax_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
-	return dax_mkwrite(vma, vmf, ext4_get_block, ext4_end_io_unwritten);
+	return dax_mkwrite(vma, vmf, ext4_get_block_write,
+				ext4_end_io_unwritten);
 }
 
 static const struct vm_operations_struct ext4_dax_vm_ops = {
_

Patches currently in -mm which might be from willy@linux.intel.com are


