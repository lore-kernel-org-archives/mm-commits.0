From: akpm@linux-foundation.org
Subject: + fat-convert-to-new-aops.patch added to -mm tree
Date: Tue, 29 May 2007 14:20:13 -0700
Message-ID: <200705292120.l4TLKD5S011763@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:42896 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751370AbXE2VUT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 17:20:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de, hirofumi@mail.parknet.co.jp


The patch titled
     fat: convert to new aops
has been added to the -mm tree.  Its filename is
     fat-convert-to-new-aops.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fat: convert to new aops
From: Nick Piggin <npiggin@suse.de>

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/inode.c |   27 ++++++++++++++++-----------
 1 files changed, 16 insertions(+), 11 deletions(-)

diff -puN fs/fat/inode.c~fat-convert-to-new-aops fs/fat/inode.c
--- a/fs/fat/inode.c~fat-convert-to-new-aops
+++ a/fs/fat/inode.c
@@ -140,19 +140,24 @@ static int fat_readpages(struct file *fi
 	return mpage_readpages(mapping, pages, nr_pages, fat_get_block);
 }
 
-static int fat_prepare_write(struct file *file, struct page *page,
-			     unsigned from, unsigned to)
+static int fat_write_begin(struct file *file, struct address_space *mapping,
+			loff_t pos, unsigned len, unsigned flags,
+			struct page **pagep, void **fsdata)
 {
-	return cont_prepare_write(page, from, to, fat_get_block,
-				  &MSDOS_I(page->mapping->host)->mmu_private);
+	*pagep = NULL;
+	return cont_write_begin(file, mapping, pos, len, flags, pagep, fsdata,
+				fat_get_block,
+				&MSDOS_I(mapping->host)->mmu_private);
 }
 
-static int fat_commit_write(struct file *file, struct page *page,
-			    unsigned from, unsigned to)
+static int fat_write_end(struct file *file, struct address_space *mapping,
+			loff_t pos, unsigned len, unsigned copied,
+			struct page *pagep, void *fsdata)
 {
-	struct inode *inode = page->mapping->host;
-	int err = generic_commit_write(file, page, from, to);
-	if (!err && !(MSDOS_I(inode)->i_attrs & ATTR_ARCH)) {
+	struct inode *inode = mapping->host;
+	int err;
+	err = generic_write_end(file, mapping, pos, len, copied, pagep, fsdata);
+	if (!(err < 0) && !(MSDOS_I(inode)->i_attrs & ATTR_ARCH)) {
 		inode->i_mtime = inode->i_ctime = CURRENT_TIME_SEC;
 		MSDOS_I(inode)->i_attrs |= ATTR_ARCH;
 		mark_inode_dirty(inode);
@@ -201,8 +206,8 @@ static const struct address_space_operat
 	.writepage	= fat_writepage,
 	.writepages	= fat_writepages,
 	.sync_page	= block_sync_page,
-	.prepare_write	= fat_prepare_write,
-	.commit_write	= fat_commit_write,
+	.write_begin	= fat_write_begin,
+	.write_end	= fat_write_end,
 	.direct_IO	= fat_direct_IO,
 	.bmap		= _fat_bmap
 };
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
