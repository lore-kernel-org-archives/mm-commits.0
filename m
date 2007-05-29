From: akpm@linux-foundation.org
Subject: + with-reiserfs-no-longer-using-the-weird-generic_cont_expand-remove-it-completely.patch added to -mm tree
Date: Tue, 29 May 2007 14:20:32 -0700
Message-ID: <200705292120.l4TLKWcS011794@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:37562 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751401AbXE2VUh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 17:20:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de


The patch titled
     With reiserfs no longer using the weird generic_cont_expand, remove it completely.
has been added to the -mm tree.  Its filename is
     with-reiserfs-no-longer-using-the-weird-generic_cont_expand-remove-it-completely.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -2158,25 +2158,6 @@ out:
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
@@ -3103,7 +3084,6 @@ EXPORT_SYMBOL(file_fsync);
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
 void block_sync_page(struct page *);
_

Patches currently in -mm which might be from npiggin@suse.de are

mm-fix-fault-vs-invalidate-race-for-linear-mappings.patch
mm-fix-fault-vs-invalidate-race-for-linear-mappings-fix.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-merge-nopfn-into-fault.patch
mm-remove-legacy-cruft.patch
mm-debug-check-for-the-fault-vs-invalidate-race.patch
mm-fix-clear_page_dirty_for_io-vs-fault-race.patch
git-arm-master.patch
slob-rework-freelist-handling.patch
slob-remove-bigblock-tracking.patch
slob-improved-alignment-handling.patch
mm-revert-kernel_ds-buffered-write-optimisation.patch
revert-81b0c8713385ce1b1b9058e916edcf9561ad76d6.patch
revert-6527c2bdf1f833cc18e8f42bd97973d583e4aa83.patch
mm-clean-up-buffered-write-code.patch
mm-debug-write-deadlocks.patch
mm-trim-more-holes.patch
mm-buffered-write-cleanup.patch
mm-write-iovec-cleanup.patch
mm-fix-pagecache-write-deadlocks.patch
mm-buffered-write-iterator.patch
fs-fix-data-loss-on-error.patch
fs-introduce-write_begin-write_end-and-perform_write-aops.patch
mm-restore-kernel_ds-optimisations.patch
implement-simple-fs-aops.patch
block_dev-convert-to-new-aops.patch
ext2-convert-to-new-aops.patch
ext3-convert-to-new-aops.patch
ext4-convert-to-new-aops.patch
xfs-convert-to-new-aops.patch
fs-new-cont-helpers.patch
fat-convert-to-new-aops.patch
hfs-convert-to-new-aops.patch
hfsplus-convert-to-new-aops.patch
hpfs-convert-to-new-aops.patch
bfs-convert-to-new-aops.patch
qnx4-convert-to-new-aops.patch
reiserfs-use-generic-write.patch
reiserfs-convert-to-new-aops.patch
reiserfs-use-generic_cont_expand_simple.patch
with-reiserfs-no-longer-using-the-weird-generic_cont_expand-remove-it-completely.patch
nfs-convert-to-new-aops.patch
smb-convert-to-new-aops.patch
fuse-convert-to-new-aops.patch
hostfs-convert-to-new-aops.patch
jffs2-convert-to-new-aops.patch
ufs-convert-to-new-aops.patch
udf-convert-to-new-aops.patch
sysv-convert-to-new-aops.patch
minix-convert-to-new-aops.patch
jfs-convert-to-new-aops.patch
mm-document-fault_data-and-flags.patch
fs-introduce-some-page-buffer-invariants.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-revoke.patch
