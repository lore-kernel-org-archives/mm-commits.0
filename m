From: akpm@linux-foundation.org
Subject: + xfs-convert-to-new-aops.patch added to -mm tree
Date: Tue, 29 May 2007 14:20:09 -0700
Message-ID: <200705292120.l4TLK9cV011757@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:35802 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751289AbXE2VUO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 17:20:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de


The patch titled
     xfs: convert to new aops
has been added to the -mm tree.  Its filename is
     xfs-convert-to-new-aops.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: xfs: convert to new aops
From: Nick Piggin <npiggin@suse.de>

Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/xfs/linux-2.6/xfs_aops.c |   19 +++++++++++-------
 fs/xfs/linux-2.6/xfs_lrw.c  |   35 +++++++++++-----------------------
 2 files changed, 24 insertions(+), 30 deletions(-)

diff -puN fs/xfs/linux-2.6/xfs_aops.c~xfs-convert-to-new-aops fs/xfs/linux-2.6/xfs_aops.c
--- a/fs/xfs/linux-2.6/xfs_aops.c~xfs-convert-to-new-aops
+++ a/fs/xfs/linux-2.6/xfs_aops.c
@@ -1487,13 +1487,18 @@ xfs_vm_direct_IO(
 }
 
 STATIC int
-xfs_vm_prepare_write(
+xfs_vm_write_begin(
 	struct file		*file,
-	struct page		*page,
-	unsigned int		from,
-	unsigned int		to)
+	struct address_space	*mapping,
+	loff_t			pos,
+	unsigned		len,
+	unsigned		flags,
+	struct page		**pagep,
+	void			**fsdata)
 {
-	return block_prepare_write(page, from, to, xfs_get_blocks);
+	*pagep = NULL;
+	return block_write_begin(file, mapping, pos, len, flags, pagep, fsdata,
+								xfs_get_blocks);
 }
 
 STATIC sector_t
@@ -1547,8 +1552,8 @@ const struct address_space_operations xf
 	.sync_page		= block_sync_page,
 	.releasepage		= xfs_vm_releasepage,
 	.invalidatepage		= xfs_vm_invalidatepage,
-	.prepare_write		= xfs_vm_prepare_write,
-	.commit_write		= generic_commit_write,
+	.write_begin		= xfs_vm_write_begin,
+	.write_end		= generic_write_end,
 	.bmap			= xfs_vm_bmap,
 	.direct_IO		= xfs_vm_direct_IO,
 	.migratepage		= buffer_migrate_page,
diff -puN fs/xfs/linux-2.6/xfs_lrw.c~xfs-convert-to-new-aops fs/xfs/linux-2.6/xfs_lrw.c
--- a/fs/xfs/linux-2.6/xfs_lrw.c~xfs-convert-to-new-aops
+++ a/fs/xfs/linux-2.6/xfs_lrw.c
@@ -134,45 +134,34 @@ xfs_iozero(
 	loff_t			pos,	/* offset in file		*/
 	size_t			count)	/* size of data to zero		*/
 {
-	unsigned		bytes;
 	struct page		*page;
 	struct address_space	*mapping;
 	int			status;
 
 	mapping = ip->i_mapping;
 	do {
-		unsigned long index, offset;
+		unsigned offset, bytes;
+		void *fsdata;
 
 		offset = (pos & (PAGE_CACHE_SIZE -1)); /* Within page */
-		index = pos >> PAGE_CACHE_SHIFT;
 		bytes = PAGE_CACHE_SIZE - offset;
 		if (bytes > count)
 			bytes = count;
 
-		status = -ENOMEM;
-		page = grab_cache_page(mapping, index);
-		if (!page)
-			break;
-
-		status = mapping->a_ops->prepare_write(NULL, page, offset,
-							offset + bytes);
+		status = pagecache_write_begin(NULL, mapping, pos, bytes,
+					AOP_FLAG_UNINTERRUPTIBLE,
+					&page, &fsdata);
 		if (status)
-			goto unlock;
+			break;
 
 		zero_user_page(page, offset, bytes, KM_USER0);
 
-		status = mapping->a_ops->commit_write(NULL, page, offset,
-							offset + bytes);
-		if (!status) {
-			pos += bytes;
-			count -= bytes;
-		}
-
-unlock:
-		unlock_page(page);
-		page_cache_release(page);
-		if (status)
-			break;
+		status = pagecache_write_end(NULL, mapping, pos, bytes, bytes,
+					page, fsdata);
+		WARN_ON(status <= 0); /* can't return less than zero! */
+		pos += bytes;
+		count -= bytes;
+		status = 0;
 	} while (count);
 
 	return (-status);
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
