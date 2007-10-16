From: akpm@linux-foundation.org
Subject: - with-reiserfs-no-longer-using-the-weird-generic_cont_expand-remove-it-completely.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:33:03 -0700
Message-ID: <200710162033.l9GKX3dj014749@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33983 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936034AbXJPVjL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:39:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, mm-commits@vger.kernel.org


The patch titled
     With reiserfs no longer using the weird generic_cont_expand, remove it completely.
has been removed from the -mm tree.  Its filename was
     with-reiserfs-no-longer-using-the-weird-generic_cont_expand-remove-it-completely.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: With reiserfs no longer using the weird generic_cont_expand, remove it completely.
From: Nick Piggin <npiggin@suse.de>

Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c                 |   20 --------------------
 include/linux/buffer_head.h |    1 -
 2 files changed, 21 deletions(-)

diff -puN fs/buffer.c~with-reiserfs-no-longer-using-the-weird-generic_cont_expand-remove-it-completely fs/buffer.c
--- a/fs/buffer.c~with-reiserfs-no-longer-using-the-weird-generic_cont_expand-remove-it-completely
+++ a/fs/buffer.c
@@ -2189,25 +2189,6 @@ out:
 	return err;
 }
 
-int generic_cont_expand(struct inode *inode, loff_t size)
-{
-	unsigned int offset;
-
-	offset = (size & (PAGE_CACHE_SIZE - 1)); /* Within page */
-
-	/* ugh.  in prepare/commit_write, if from==to==start of block, we
-	 * skip the prepare.  make sure we never send an offset for the start
-	 * of a block.
-	 * XXX: actually, this should be handled in those filesystems by
-	 * checking for the AOP_FLAG_CONT_EXPAND flag.
-	 */
-	if ((offset & (inode->i_sb->s_blocksize - 1)) == 0) {
-		/* caller must handle this extra byte. */
-		size++;
-	}
-	return generic_cont_expand_simple(inode, size);
-}
-
 int cont_expand_zero(struct file *file, struct address_space *mapping,
 			loff_t pos, loff_t *bytes)
 {
@@ -3192,7 +3173,6 @@ EXPORT_SYMBOL(file_fsync);
 EXPORT_SYMBOL(fsync_bdev);
 EXPORT_SYMBOL(generic_block_bmap);
 EXPORT_SYMBOL(generic_commit_write);
-EXPORT_SYMBOL(generic_cont_expand);
 EXPORT_SYMBOL(generic_cont_expand_simple);
 EXPORT_SYMBOL(init_buffer);
 EXPORT_SYMBOL(invalidate_bdev);
diff -puN include/linux/buffer_head.h~with-reiserfs-no-longer-using-the-weird-generic_cont_expand-remove-it-completely include/linux/buffer_head.h
--- a/include/linux/buffer_head.h~with-reiserfs-no-longer-using-the-weird-generic_cont_expand-remove-it-completely
+++ a/include/linux/buffer_head.h
@@ -217,7 +217,6 @@ int block_prepare_write(struct page*, un
 int cont_write_begin(struct file *, struct address_space *, loff_t,
 			unsigned, unsigned, struct page **, void **,
 			get_block_t *, loff_t *);
-int generic_cont_expand(struct inode *inode, loff_t size);
 int generic_cont_expand_simple(struct inode *inode, loff_t size);
 int block_commit_write(struct page *page, unsigned from, unsigned to);
 int block_page_mkwrite(struct vm_area_struct *vma, struct page *page,
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
mm-document-tree_lock-zonelock-lockorder.patch
fs-reiserfs-cleanups.patch
atomic_opstxt-has-incorrect-misleading-and-insufficient-information.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-revoke.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-revoke-fix.patch
bitops-introduce-lock-ops.patch
alpha-fix-bitops.patch
alpha-lock-bitops.patch
alpha-lock-bitops-fix.patch
ia64-lock-bitops.patch
mips-fix-bitops.patch
mips-lock-bitops.patch
powerpc-lock-bitops.patch
powerpc-lock-bitops-fix.patch
bit_spin_lock-use-lock-bitops.patch
reiser4-fix-for-new-aops-patches.patch
