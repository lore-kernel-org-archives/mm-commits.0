From: akpm@linux-foundation.org
Subject: - mm-try_to_unuse-check-removing-right-swap.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:12:45 -0800
Message-ID: <200901072212.n07MCj1p012905@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34155 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756579AbZAGWNH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:13:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, holt@sgi.com, kamezawa.hiroyu@jp.fujitsu.com, lee.schermerhorn@hp.com, nickpiggin@yahoo.com.au, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     mm: try_to_unuse check removing right swap
has been removed from the -mm tree.  Its filename was
     mm-try_to_unuse-check-removing-right-swap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: try_to_unuse check removing right swap
From: Hugh Dickins <hugh@veritas.com>

There's a possible race in try_to_unuse() which Nick Piggin led me to two
years ago.  Where it does lock_page() after read_swap_cache_async(), what
if another task removed that page from swapcache just before we locked it?

It would sail though the (*swap_map > 1) tests doing nothing (because it
could not have been removed from swapcache before its swap references were
gone), until it reaches the delete_from_swap_cache(page) near the bottom.

Now imagine that this page has been allocated to swap on a different swap
area while we dropped page lock (perhaps at the top, perhaps in unuse_mm):
we could wrongly remove from swap cache before the page has been written
to swap, so a subsequent do_swap_page() would read in stale data from
swap.

I think this case could not happen before: remove_exclusive_swap_page()
refused while page count was raised.  But now with reuse_swap_page() and
try_to_free_swap() removing from swap cache without minding page count, I
think it could happen - the previous patch argued that it was safe because
try_to_unuse() already ignored page count, but overlooked that it might be
breaking the assumptions in try_to_unuse() itself.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Robin Holt <holt@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff -puN mm/swapfile.c~mm-try_to_unuse-check-removing-right-swap mm/swapfile.c
--- a/mm/swapfile.c~mm-try_to_unuse-check-removing-right-swap
+++ a/mm/swapfile.c
@@ -889,7 +889,16 @@ static int try_to_unuse(unsigned int typ
 			lock_page(page);
 			wait_on_page_writeback(page);
 		}
-		if (PageSwapCache(page))
+
+		/*
+		 * It is conceivable that a racing task removed this page from
+		 * swap cache just before we acquired the page lock at the top,
+		 * or while we dropped it in unuse_mm().  The page might even
+		 * be back in swap cache on another swap area: that we must not
+		 * delete, since it may not have been written out to swap yet.
+		 */
+		if (PageSwapCache(page) &&
+		    likely(page_private(page) == entry.val))
 			delete_from_swap_cache(page);
 
 		/*
_

Patches currently in -mm which might be from hugh@veritas.com are

origin.patch
linux-next.patch
mark-complex-bitopsh-inlines-as-__always_inline.patch
clocksource-pass-clocksource-to-read-callback.patch
clocksource-pass-clocksource-to-read-callback-sparc-cleanup.patch
bio-zero-inlined-bio_vec.patch
page_fault-retry-with-nopage_retry.patch
page_fault-retry-with-nopage_retry-fix.patch
page_fault-retry-with-nopage_retry-fix-fix.patch
mm-shmemc-fix-division-by-zero.patch
getrusage-fill-ru_maxrss-value.patch
memcg-handle-swap-caches.patch
memcg-handle-swap-caches-build-fix.patch
memcg-swap-cgroup-for-remembering-usage.patch
memcg-memswap-controller-core.patch
memcg-memswap-controller-core-make-resize-limit-hold-mutex.patch
memcg-memswap-controller-core-swapcache-fixes.patch
memcg-revert-gfp-mask-fix.patch
memcg-check-group-leader-fix.patch
memcg-memoryswap-controller-fix-limit-check.patch
memcg-swapout-refcnt-fix.patch
memcg-hierarchy-avoid-unnecessary-reclaim.patch
inactive_anon_is_low-move-to-vmscan.patch
mm-introduce-zone_reclaim-struct.patch
mm-add-zone-nr_pages-helper-function.patch
mm-make-get_scan_ratio-safe-for-memcg.patch
memcg-add-null-check-to-page_cgroup_zoneinfo.patch
memcg-add-inactive_anon_is_low.patch
memcg-add-mem_cgroup_zone_nr_pages.patch
memcg-add-zone_reclaim_stat.patch
memcg-add-zone_reclaim_stat-reclaim-stat-trivial-fixes-fix.patch
memcg-remove-mem_cgroup_cal_reclaim.patch
memcg-show-reclaim-stat.patch
memcg-rename-scan-global-lru.patch
memcg-protect-prev_priority.patch
memcg-swappiness.patch
memcg-explain-details-and-test-document.patch
memcg-fix-swap-accounting-leak-v3.patch
memcg-fix-swap-accounting-leak-doc-fix.patch
memcg-fix-shmems-swap-accounting.patch
prio_tree-debugging-patch.patch

