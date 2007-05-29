From: akpm@linux-foundation.org
Subject: + mm-revert-kernel_ds-buffered-write-optimisation.patch added to -mm tree
Date: Tue, 29 May 2007 14:19:33 -0700
Message-ID: <200705292119.l4TLJXxA011687@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:33787 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751335AbXE2VTi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 17:19:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de, neilb@suse.de


The patch titled
     mm: revert KERNEL_DS buffered write optimisation
has been added to the -mm tree.  Its filename is
     mm-revert-kernel_ds-buffered-write-optimisation.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mm: revert KERNEL_DS buffered write optimisation
From: Nick Piggin <npiggin@suse.de>

Revert the patch from Neil Brown to optimise NFSD writev handling.

Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   32 +++++++++++++-------------------
 1 files changed, 13 insertions(+), 19 deletions(-)

diff -puN mm/filemap.c~mm-revert-kernel_ds-buffered-write-optimisation mm/filemap.c
--- a/mm/filemap.c~mm-revert-kernel_ds-buffered-write-optimisation
+++ a/mm/filemap.c
@@ -1928,27 +1928,21 @@ generic_file_buffered_write(struct kiocb
 		/* Limit the size of the copy to the caller's write size */
 		bytes = min(bytes, count);
 
-		/* We only need to worry about prefaulting when writes are from
-		 * user-space.  NFSd uses vfs_writev with several non-aligned
-		 * segments in the vector, and limiting to one segment a time is
-		 * a noticeable performance for re-write
+		/*
+		 * Limit the size of the copy to that of the current segment,
+		 * because fault_in_pages_readable() doesn't know how to walk
+		 * segments.
 		 */
-		if (!segment_eq(get_fs(), KERNEL_DS)) {
-			/*
-			 * Limit the size of the copy to that of the current
-			 * segment, because fault_in_pages_readable() doesn't
-			 * know how to walk segments.
-			 */
-			bytes = min(bytes, cur_iov->iov_len - iov_base);
+		bytes = min(bytes, cur_iov->iov_len - iov_base);
+
+		/*
+		 * Bring in the user page that we will copy from _first_.
+		 * Otherwise there's a nasty deadlock on copying from the
+		 * same page as we're writing to, without it being marked
+		 * up-to-date.
+		 */
+		fault_in_pages_readable(buf, bytes);
 
-			/*
-			 * Bring in the user page that we will copy from
-			 * _first_.  Otherwise there's a nasty deadlock on
-			 * copying from the same page as we're writing to,
-			 * without it being marked up-to-date.
-			 */
-			fault_in_pages_readable(buf, bytes);
-		}
 		page = __grab_cache_page(mapping,index,&cached_page,&lru_pvec);
 		if (!page) {
 			status = -ENOMEM;
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
