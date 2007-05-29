From: akpm@linux-foundation.org
Subject: + hpfs-convert-to-new-aops.patch added to -mm tree
Date: Tue, 29 May 2007 14:20:19 -0700
Message-ID: <200705292120.l4TLKJqn011772@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:39528 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751416AbXE2VU1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 17:20:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de, mikulas@artax.karlin.mff.cuni.cz


The patch titled
     hpfs: convert to new aops
has been added to the -mm tree.  Its filename is
     hpfs-convert-to-new-aops.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: hpfs: convert to new aops
From: Nick Piggin <npiggin@suse.de>

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: <mikulas@artax.karlin.mff.cuni.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hpfs/file.c |   20 ++++++++++++++------
 1 files changed, 14 insertions(+), 6 deletions(-)

diff -puN fs/hpfs/file.c~hpfs-convert-to-new-aops fs/hpfs/file.c
--- a/fs/hpfs/file.c~hpfs-convert-to-new-aops
+++ a/fs/hpfs/file.c
@@ -86,25 +86,33 @@ static int hpfs_writepage(struct page *p
 {
 	return block_write_full_page(page,hpfs_get_block, wbc);
 }
+
 static int hpfs_readpage(struct file *file, struct page *page)
 {
 	return block_read_full_page(page,hpfs_get_block);
 }
-static int hpfs_prepare_write(struct file *file, struct page *page, unsigned from, unsigned to)
-{
-	return cont_prepare_write(page,from,to,hpfs_get_block,
-		&hpfs_i(page->mapping->host)->mmu_private);
+
+static int hpfs_write_begin(struct file *file, struct address_space *mapping,
+			loff_t pos, unsigned len, unsigned flags,
+			struct page **pagep, void **fsdata)
+{
+	*pagep = NULL;
+	return cont_write_begin(file, mapping, pos, len, flags, pagep, fsdata,
+				hpfs_get_block,
+				&hpfs_i(mapping->host)->mmu_private);
 }
+
 static sector_t _hpfs_bmap(struct address_space *mapping, sector_t block)
 {
 	return generic_block_bmap(mapping,block,hpfs_get_block);
 }
+
 const struct address_space_operations hpfs_aops = {
 	.readpage = hpfs_readpage,
 	.writepage = hpfs_writepage,
 	.sync_page = block_sync_page,
-	.prepare_write = hpfs_prepare_write,
-	.commit_write = generic_commit_write,
+	.write_begin = hpfs_write_begin,
+	.write_end = generic_write_end,
 	.bmap = _hpfs_bmap
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
