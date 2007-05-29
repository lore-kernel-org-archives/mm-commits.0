From: akpm@linux-foundation.org
Subject: + jfs-convert-to-new-aops.patch added to -mm tree
Date: Tue, 29 May 2007 14:20:52 -0700
Message-ID: <200705292120.l4TLKqQw011839@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:59929 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751182AbXE2VVY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 17:21:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de, shaggy@austin.ibm.com


The patch titled
     jfs: convert to new aops
has been added to the -mm tree.  Its filename is
     jfs-convert-to-new-aops.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: jfs: convert to new aops
From: Nick Piggin <npiggin@suse.de>

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Dave Kleikamp <shaggy@austin.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jfs/inode.c |   19 +++++++++++--------
 1 files changed, 11 insertions(+), 8 deletions(-)

diff -puN fs/jfs/inode.c~jfs-convert-to-new-aops fs/jfs/inode.c
--- a/fs/jfs/inode.c~jfs-convert-to-new-aops
+++ a/fs/jfs/inode.c
@@ -255,7 +255,7 @@ int jfs_get_block(struct inode *ip, sect
 
 static int jfs_writepage(struct page *page, struct writeback_control *wbc)
 {
-	return nobh_writepage(page, jfs_get_block, wbc);
+	return block_write_full_page(page, jfs_get_block, wbc);
 }
 
 static int jfs_writepages(struct address_space *mapping,
@@ -275,10 +275,13 @@ static int jfs_readpages(struct file *fi
 	return mpage_readpages(mapping, pages, nr_pages, jfs_get_block);
 }
 
-static int jfs_prepare_write(struct file *file,
-			     struct page *page, unsigned from, unsigned to)
-{
-	return nobh_prepare_write(page, from, to, jfs_get_block);
+static int jfs_write_begin(struct file *file, struct address_space *mapping,
+				loff_t pos, unsigned len, unsigned flags,
+				struct page **pagep, void **fsdata)
+{
+	*pagep = NULL;
+	return block_write_begin(file, mapping, pos, len, flags, pagep, fsdata,
+				jfs_get_block);
 }
 
 static sector_t jfs_bmap(struct address_space *mapping, sector_t block)
@@ -302,8 +305,8 @@ const struct address_space_operations jf
 	.writepage	= jfs_writepage,
 	.writepages	= jfs_writepages,
 	.sync_page	= block_sync_page,
-	.prepare_write	= jfs_prepare_write,
-	.commit_write	= nobh_commit_write,
+	.write_begin	= jfs_write_begin,
+	.write_end	= generic_write_end,
 	.bmap		= jfs_bmap,
 	.direct_IO	= jfs_direct_IO,
 };
@@ -356,7 +359,7 @@ void jfs_truncate(struct inode *ip)
 {
 	jfs_info("jfs_truncate: size = 0x%lx", (ulong) ip->i_size);
 
-	nobh_truncate_page(ip->i_mapping, ip->i_size);
+	block_truncate_page(ip->i_mapping, ip->i_size, jfs_get_block);
 
 	IWRITE_LOCK(ip, RDWRLOCK_NORMAL);
 	jfs_truncate_nolock(ip, ip->i_size);
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
