From: akpm@linux-foundation.org
Subject: - udf-convert-to-new-aops.patch removed from -mm tree
Date: Mon, 09 Jul 2007 13:53:49 -0700
Message-ID: <200707092053.l69Krnvc010966@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54995 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754480AbXGIUyE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jul 2007 16:54:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, bfennema@falcon.csc.calpoly.edu, jack@ucw.cz, mm-commits@vger.kernel.org


The patch titled
     udf: convert to new aops
has been removed from the -mm tree.  Its filename was
     udf-convert-to-new-aops.patch

This patch was dropped because it was folded into ufs-convert-to-new-aops-fix.patch

------------------------------------------------------
Subject: udf: convert to new aops
From: Nick Piggin <npiggin@suse.de>

Convert udf to new aops.  Also seem to have fixed pagecache corruption in
udf_adinicb_commit_write -- page was marked uptodate when it is not.  Also,
fixed the silly setup where prepare_write was doing a kmap to be used in
commit_write: just do kmap_atomic in write_end.  Use libfs helpers to make
this easier.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: <bfennema@falcon.csc.calpoly.edu>
Cc: Jan Kara <jack@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/udf/file.c  |   32 +++++++++++++-------------------
 fs/udf/inode.c |   11 +++++++----
 2 files changed, 20 insertions(+), 23 deletions(-)

diff -puN fs/udf/file.c~udf-convert-to-new-aops fs/udf/file.c
--- a/fs/udf/file.c~udf-convert-to-new-aops
+++ a/fs/udf/file.c
@@ -74,34 +74,28 @@ static int udf_adinicb_writepage(struct 
 	return 0;
 }
 
-static int udf_adinicb_prepare_write(struct file *file, struct page *page, unsigned offset, unsigned to)
+static int udf_adinicb_write_end(struct file *file, struct address_space *mapping,
+			loff_t pos, unsigned len, unsigned copied,
+			struct page *page, void *fsdata)
 {
-	kmap(page);
-	return 0;
-}
-
-static int udf_adinicb_commit_write(struct file *file, struct page *page, unsigned offset, unsigned to)
-{
-	struct inode *inode = page->mapping->host;
-	char *kaddr = page_address(page);
+	struct inode *inode = mapping->host;
+	unsigned offset = pos & (PAGE_CACHE_SIZE - 1);
+	char *kaddr;
 
+	kaddr = kmap_atomic(page, KM_USER0);
 	memcpy(UDF_I_DATA(inode) + UDF_I_LENEATTR(inode) + offset,
-		kaddr + offset, to - offset);
-	mark_inode_dirty(inode);
-	SetPageUptodate(page);
-	kunmap(page);
-	/* only one page here */
-	if (to > inode->i_size)
-		inode->i_size = to;
-	return 0;
+		kaddr + offset, copied);
+	kunmap_atomic(kaddr, KM_USER0);
+
+	return simple_write_end(file, mapping, pos, len, copied, page, fsdata);
 }
 
 const struct address_space_operations udf_adinicb_aops = {
 	.readpage		= udf_adinicb_readpage,
 	.writepage		= udf_adinicb_writepage,
 	.sync_page		= block_sync_page,
-	.prepare_write		= udf_adinicb_prepare_write,
-	.commit_write		= udf_adinicb_commit_write,
+	.write_begin		= simple_write_begin,
+	.write_end		= udf_adinicb_write_end,
 };
 
 static ssize_t udf_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
diff -puN fs/udf/inode.c~udf-convert-to-new-aops fs/udf/inode.c
--- a/fs/udf/inode.c~udf-convert-to-new-aops
+++ a/fs/udf/inode.c
@@ -131,9 +131,12 @@ static int udf_readpage(struct file *fil
 	return block_read_full_page(page, udf_get_block);
 }
 
-static int udf_prepare_write(struct file *file, struct page *page, unsigned from, unsigned to)
+static int udf_write_begin(struct file *file, struct address_space *mapping,
+			loff_t pos, unsigned len, unsigned flags,
+			struct page **pagep, void **fsdata)
 {
-	return block_prepare_write(page, from, to, udf_get_block);
+	return block_write_begin(file, mapping, pos, len, flags, pagep, fsdata,
+				udf_get_block);
 }
 
 static sector_t udf_bmap(struct address_space *mapping, sector_t block)
@@ -145,8 +148,8 @@ const struct address_space_operations ud
 	.readpage		= udf_readpage,
 	.writepage		= udf_writepage,
 	.sync_page		= block_sync_page,
-	.prepare_write		= udf_prepare_write,
-	.commit_write		= generic_commit_write,
+	.write_begin		= udf_write_begin,
+	.write_end		= generic_write_end,
 	.bmap			= udf_bmap,
 };
 
_

Patches currently in -mm which might be from npiggin@suse.de are

slob-rework-freelist-handling.patch
slob-remove-bigblock-tracking.patch
slob-improved-alignment-handling.patch
mm-fix-fault-vs-invalidate-race-for-linear-mappings.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-merge-nopfn-into-fault.patch
mm-remove-legacy-cruft.patch
mm-debug-check-for-the-fault-vs-invalidate-race.patch
mm-fix-clear_page_dirty_for_io-vs-fault-race.patch
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
ext3-convert-to-new-aops-fix.patch
ext4-convert-to-new-aops.patch
ext4-convert-to-new-aops-fix.patch
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
ufs-convert-to-new-aops-fix.patch
udf-convert-to-new-aops.patch
sysv-convert-to-new-aops.patch
sysv-convert-to-new-aops-fix.patch
minix-convert-to-new-aops.patch
minix-convert-to-new-aops-fix.patch
jfs-convert-to-new-aops.patch
fs-adfs-convert-to-new-aops.patch
fs-affs-convert-to-new-aops.patch
ocfs2-convert-to-new-aops.patch
fix-read-truncate-race.patch
fs-remove-some-aop_truncated_page.patch
mm-document-fault_data-and-flags.patch
fs-introduce-some-page-buffer-invariants.patch
fs-reiserfs-cleanups.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-revoke.patch
reiser4-fix-for-new-aops-patches.patch
