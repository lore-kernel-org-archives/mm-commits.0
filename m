From: akpm@linux-foundation.org
Subject: - mm-revert-kernel_ds-buffered-write-optimisation.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:31:54 -0700
Message-ID: <200710162031.l9GKVsmx014539@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35374 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753651AbXJPVps (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:45:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     mm: revert KERNEL_DS buffered write optimisation
has been removed from the -mm tree.  Its filename was
     mm-revert-kernel_ds-buffered-write-optimisation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: mm: revert KERNEL_DS buffered write optimisation
From: Nick Piggin <npiggin@suse.de>

Revert the patch from Neil Brown to optimise NFSD writev handling.

Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   32 +++++++++++++-------------------
 1 file changed, 13 insertions(+), 19 deletions(-)

diff -puN mm/filemap.c~mm-revert-kernel_ds-buffered-write-optimisation mm/filemap.c
--- a/mm/filemap.c~mm-revert-kernel_ds-buffered-write-optimisation
+++ a/mm/filemap.c
@@ -1874,27 +1874,21 @@ generic_file_buffered_write(struct kiocb
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
