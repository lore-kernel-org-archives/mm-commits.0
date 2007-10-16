From: akpm@linux-foundation.org
Subject: - mm-clarify-__add_to_swap_cache-locking-fix.patch removed from -mm tree
Date: Mon, 15 Oct 2007 21:05:17 -0700
Message-ID: <200710160405.l9G45Hok007918@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45367 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751146AbXJPEFX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 00:05:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, nickpiggin@yahoo.com.au, mm-commits@vger.kernel.org


The patch titled
     mm-clarify-__add_to_swap_cache-locking fix
has been removed from the -mm tree.  Its filename was
     mm-clarify-__add_to_swap_cache-locking-fix.patch

This patch was dropped because it was folded into mm-clarify-__add_to_swap_cache-locking.patch

------------------------------------------------------
Subject: mm-clarify-__add_to_swap_cache-locking fix
From: Hugh Dickins <hugh@veritas.com>

Nick's mm-clarify-__add_to_swap_cache-locking.patch is fine for mainline,
but soon generates a "kernel BUG at mm/swap_state.c:78!" when it meets
mm-implement-swap-prefetching.patch in 2.6.23-rc2-mm1.  We could add a fix
to the latter, but I think it's better to adjust Nick's, so that it's right
for whichever tree it's in: move the responsibility to SetPageLocked from
read_swap_cache_async to add_to_swap_cache.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_state.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN mm/swap_state.c~mm-clarify-__add_to_swap_cache-locking-fix mm/swap_state.c
--- a/mm/swap_state.c~mm-clarify-__add_to_swap_cache-locking-fix
+++ a/mm/swap_state.c
@@ -99,15 +99,18 @@ static int add_to_swap_cache(struct page
 {
 	int error;
 
+	BUG_ON(PageLocked(page));
 	if (!swap_duplicate(entry)) {
 		INC_CACHE_INFO(noent_race);
 		return -ENOENT;
 	}
+	SetPageLocked(page);
 	error = __add_to_swap_cache(page, entry, GFP_KERNEL);
 	/*
 	 * Anon pages are already on the LRU, we don't run lru_cache_add here.
 	 */
 	if (error) {
+		ClearPageLocked(page);
 		swap_free(entry);
 		if (error == -EEXIST)
 			INC_CACHE_INFO(exist_race);
@@ -338,7 +341,6 @@ struct page *read_swap_cache_async(swp_e
 								vma, addr);
 			if (!new_page)
 				break;		/* Out of memory */
-			SetPageLocked(new_page);/* could be non-atomic op */
 		}
 
 		/*
@@ -362,9 +364,7 @@ struct page *read_swap_cache_async(swp_e
 		}
 	} while (err != -ENOENT && err != -ENOMEM);
 
-	if (new_page) {
-		ClearPageLocked(new_page);
+	if (new_page)
 		page_cache_release(new_page);
-	}
 	return found_page;
 }
_

Patches currently in -mm which might be from hugh@veritas.com are

origin.patch
mm-clarify-__add_to_swap_cache-locking.patch
mm-clarify-__add_to_swap_cache-locking-fix.patch
radix-tree-use-indirect-bit.patch
use-vm_read-write-exec-to-set-vm_page_prot.patch
mm-use-pagevec-to-rotate-reclaimable-page-fix-2.patch
mm-use-pagevec-to-rotate-reclaimable-page-fix-bug-at-include-linux-mmh220.patch
mm-use-pagevec-to-rotate-reclaimable-page-kill-redundancy-in-rotate_reclaimable_page.patch
mm-use-pagevec-to-rotate-reclaimable-page-move_tail_pages-into-lru_add_drain.patch
introduce-write_begin-write_end-aops-important-fix.patch
reiserfs-convert-to-new-aops-fix.patch
hostfs-convert-to-new-aops-fix.patch
affs-convert-to-new-aops-fix.patch
flush-cache-before-installing-new-page-at-migraton.patch
flush-icache-before-set_pte-on-ia64-flush-icache-at-set_pte.patch
flush-icache-before-set_pte-on-ia64-flush-icache-at-set_pte-fix.patch
flush-icache-before-set_pte-on-ia64-flush-icache-at-set_pte-fix-update.patch
maps-pssproportional-set-size-accounting-in-smaps.patch
mm-shmemc-make-3-functions-static.patch
lib-percpu_counter_sub.patch
mm-per-device-dirty-threshold-fix.patch
ext2-reservations.patch
fix-for-ext2-reservation.patch
ext2-balloc-use-io_error-label.patch
memory-controller-memory-accounting-v7-fix-swapoff-breakage-however.patch
exportfs-add-fid-type.patch
exportfs-add-new-methods.patch
shmem-new-export-ops.patch
exportfs-remove-old-methods.patch
exportfs-make-struct-export_operations-const.patch
exportfs-update-documentation.patch
prio_tree-debugging-patch.patch
