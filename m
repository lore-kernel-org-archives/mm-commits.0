From: akpm@linux-foundation.org
Subject: - mm-page_remove_rmap-comments-on-pageanon.patch removed from -mm tree
Date: Wed, 20 Aug 2008 20:49:12 -0700
Message-ID: <200808210349.m7L3nCEd015620@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32953 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755134AbYHUDuL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 20 Aug 2008 23:50:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, schwidefsky@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     mm: page_remove_rmap comments on PageAnon
has been removed from the -mm tree.  Its filename was
     mm-page_remove_rmap-comments-on-pageanon.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: page_remove_rmap comments on PageAnon
From: Hugh Dickins <hugh@veritas.com>

Add a comment to s390's page_test_dirty/page_clear_dirty/page_set_dirty
dance in page_remove_rmap(): I was wrong to think the PageSwapCache test
could be avoided, and would like a comment in there to remind me.  And
mention s390, to help us remember that this block is not really common.

Also move down the "It would be tidy to reset PageAnon" comment: it does
not belong to s390's block, and it would be unwise to reset PageAnon
before we're done with testing it.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Acked-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |   25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff -puN mm/rmap.c~mm-page_remove_rmap-comments-on-pageanon mm/rmap.c
--- a/mm/rmap.c~mm-page_remove_rmap-comments-on-pageanon
+++ a/mm/rmap.c
@@ -659,23 +659,30 @@ void page_remove_rmap(struct page *page,
 		}
 
 		/*
-		 * It would be tidy to reset the PageAnon mapping here,
-		 * but that might overwrite a racing page_add_anon_rmap
-		 * which increments mapcount after us but sets mapping
-		 * before us: so leave the reset to free_hot_cold_page,
-		 * and remember that it's only reliable while mapped.
-		 * Leaving it set also helps swapoff to reinstate ptes
-		 * faster for those pages still in swapcache.
+		 * Now that the last pte has gone, s390 must transfer dirty
+		 * flag from storage key to struct page.  We can usually skip
+		 * this if the page is anon, so about to be freed; but perhaps
+		 * not if it's in swapcache - there might be another pte slot
+		 * containing the swap entry, but page not yet written to swap.
 		 */
 		if ((!PageAnon(page) || PageSwapCache(page)) &&
 		    page_test_dirty(page)) {
 			page_clear_dirty(page);
 			set_page_dirty(page);
 		}
-		mem_cgroup_uncharge_page(page);
 
+		mem_cgroup_uncharge_page(page);
 		__dec_zone_page_state(page,
-				PageAnon(page) ? NR_ANON_PAGES : NR_FILE_MAPPED);
+			PageAnon(page) ? NR_ANON_PAGES : NR_FILE_MAPPED);
+		/*
+		 * It would be tidy to reset the PageAnon mapping here,
+		 * but that might overwrite a racing page_add_anon_rmap
+		 * which increments mapcount after us but sets mapping
+		 * before us: so leave the reset to free_hot_cold_page,
+		 * and remember that it's only reliable while mapped.
+		 * Leaving it set also helps swapoff to reinstate ptes
+		 * faster for those pages still in swapcache.
+		 */
 	}
 }
 
_

Patches currently in -mm which might be from hugh@veritas.com are

memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info.patch
mm-owner-fix-race-between-swap-and-exit.patch
mm-owner-fix-race-between-swap-and-exit-fix.patch
define-page_file_cache-function.patch
vmscan-split-lru-lists-into-anon-file-sets.patch
mlock-mlocked-pages-are-unevictable.patch
mlock-mlocked-pages-are-unevictable-fix.patch
vmscan-unevictable-lru-scan-sysctl.patch
mmapc-deinline-a-few-functions.patch
memrlimit-add-memrlimit-controller-accounting-and-control.patch
memrlimit-add-memrlimit-controller-accounting-and-control-memory-rlimit-enhance-mm_owner_changed-callback-to-deal-with-exited-owner.patch
memrlimit-add-memrlimit-controller-accounting-and-control-memory-rlimit-fix-crash-on-fork.patch
memrlimit-improve-error-handling.patch
memrlimit-improve-error-handling-update.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback.patch
make-mm-rmapc-anon_vma_cachep-static.patch
prio_tree-debugging-patch.patch

