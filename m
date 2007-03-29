From: akpm@linux-foundation.org
Subject: - holepunch-fix-disconnected-pages-after-second-truncate.patch removed from -mm tree
Date: Thu, 29 Mar 2007 16:37:38 -0700
Message-ID: <200703292337.l2TNbcdC015131@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43287 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934399AbXC2Xk7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Mar 2007 19:40:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, mszeredi@suse.cz, npiggin@suse.de, pbadari@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     holepunch: fix disconnected pages after second truncate
has been removed from the -mm tree.  Its filename was
     holepunch-fix-disconnected-pages-after-second-truncate.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: holepunch: fix disconnected pages after second truncate
From: Hugh Dickins <hugh@veritas.com>

shmem_truncate_range has its own truncate_inode_pages_range, to free any pages
racily instantiated while it was in progress: a SHMEM_PAGEIN flag is set when
this might have happened.  But holepunching gets no chance to clear that flag
at the start of vmtruncate_range, so it's always set (unless a truncate came
just before), so holepunch almost always does this second
truncate_inode_pages_range.

shmem holepunch has unlikely swap<->file races hereabouts whatever we do
(without a fuller rework than is fit for this release): I was going to skip
the second truncate in the punch_hole case, but Miklos points out that would
make holepunch correctness more vulnerable to swapoff.  So keep the second
truncate, but follow it by an unmap_mapping_range to eliminate the
disconnected pages (freed from pagecache while still mapped in userspace) that
it might have left behind.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: Miklos Szeredi <mszeredi@suse.cz>
Cc: Badari Pulavarty <pbadari@us.ibm.com>
Cc: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN mm/shmem.c~holepunch-fix-disconnected-pages-after-second-truncate mm/shmem.c
--- a/mm/shmem.c~holepunch-fix-disconnected-pages-after-second-truncate
+++ a/mm/shmem.c
@@ -674,8 +674,16 @@ done2:
 		 * generic_delete_inode did it, before we lowered next_index.
 		 * Also, though shmem_getpage checks i_size before adding to
 		 * cache, no recheck after: so fix the narrow window there too.
+		 *
+		 * Recalling truncate_inode_pages_range and unmap_mapping_range
+		 * every time for punch_hole (which never got a chance to clear
+		 * SHMEM_PAGEIN at the start of vmtruncate_range) is expensive,
+		 * yet hardly ever necessary: try to optimize them out later.
 		 */
 		truncate_inode_pages_range(inode->i_mapping, start, end);
+		if (punch_hole)
+			unmap_mapping_range(inode->i_mapping, start,
+							end - start, 1);
 	}
 
 	spin_lock(&info->lock);
_

Patches currently in -mm which might be from hugh@veritas.com are

origin.patch
git-drm.patch
mm-more-rmap-checking.patch
mm-make-read_cache_page-synchronous.patch
fs-buffer-dont-pageuptodate-without-page-locked.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
i386-add-ptep_test_and_clear_dirtyyoung.patch
i386-use-pte_update_defer-in-ptep_test_and_clear_dirtyyoung.patch
i386-use-pte_update_defer-in-ptep_test_and_clear_dirtyyoung-fix.patch
smaps-extract-pmd-walker-from-smaps-code.patch
smaps-add-pages-referenced-count-to-smaps.patch
smaps-add-clear_refs-file-to-clear-reference.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix-fix-2.patch
smaps-use-ptep_test_and_clear_young.patch
tty-in-tiocsctty-when-we-steal-a-tty-hang-it-up-fix.patch
ext2-reservations.patch
ext2-balloc-use-io_error-label.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-swap-prefetch.patch
