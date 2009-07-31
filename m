From: akpm@linux-foundation.org
Subject: [withdrawn] vmscan-use-add_page_to_lru_list-helper-function.patch removed from -mm tree
Date: Thu, 30 Jul 2009 19:35:08 -0700
Message-ID: <200907310235.n6V2Z8Wc008538@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33264 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751244AbZGaCgC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 30 Jul 2009 22:36:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, fengguang.wu@intel.com, hannes@cmpxchg.org, mel@csn.ul.ie, minchan.kim@gmail.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     vmscan: Use add_page_to_lru_list() helper function
has been removed from the -mm tree.  Its filename was
     vmscan-use-add_page_to_lru_list-helper-function.patch

This patch was dropped because it was withdrawn

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmscan: Use add_page_to_lru_list() helper function
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

add_page_to_lru_list() is equivalent to
  - add lru list (global)
  - add lru list (mem-cgroup)
  - modify zone stat

We can use it.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN mm/vmscan.c~vmscan-use-add_page_to_lru_list-helper-function mm/vmscan.c
--- a/mm/vmscan.c~vmscan-use-add_page_to_lru_list-helper-function
+++ a/mm/vmscan.c
@@ -1268,12 +1268,12 @@ static void move_active_pages_to_lru(str
 
 	while (!list_empty(list)) {
 		page = lru_to_page(list);
+		list_del(&page->lru);
 
 		VM_BUG_ON(PageLRU(page));
 		SetPageLRU(page);
 
-		list_move(&page->lru, &zone->lru[lru].list);
-		mem_cgroup_add_lru_list(page, lru);
+		add_page_to_lru_list(zone, page, lru);
 		pgmoved++;
 
 		if (!pagevec_add(&pvec, page) || list_empty(list)) {
@@ -1284,7 +1284,6 @@ static void move_active_pages_to_lru(str
 			spin_lock_irq(&zone->lru_lock);
 		}
 	}
-	__mod_zone_page_state(zone, NR_LRU_BASE + lru, pgmoved);
 	if (!is_active_lru(lru))
 		__count_vm_events(PGDEACTIVATE, pgmoved);
 }
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
linux-next.patch
mm-make-set_mempolicympol_interleav-n_high_memory-aware.patch
mm-make-set_mempolicympol_interleav-n_high_memory-aware-fix.patch
readahead-add-blk_run_backing_dev.patch
readahead-add-blk_run_backing_dev-fix.patch
readahead-add-blk_run_backing_dev-fix-fix-2.patch
mm-clean-up-page_remove_rmap.patch
mm-show_free_areas-display-slab-pages-in-two-separate-fields.patch
mm-oom-analysis-add-per-zone-statistics-to-show_free_areas.patch
mm-oom-analysis-add-buffer-cache-information-to-show_free_areas.patch
mm-oom-analysis-show-kernel-stack-usage-in-proc-meminfo-and-oom-log-output.patch
mm-oom-analysis-add-shmem-vmstat.patch
mm-rename-pgmoved-variable-in-shrink_active_list.patch
mm-shrink_inactive_list-nr_scan-accounting-fix-fix.patch
mm-vmstat-add-isolate-pages.patch
mm-vmstat-add-isolate-pages-fix.patch
vmscan-throttle-direct-reclaim-when-too-many-pages-are-isolated-already.patch
mm-remove-__addsub_zone_page_state.patch
mm-count-only-reclaimable-lru-pages-v2.patch
vmscan-dont-attempt-to-reclaim-anon-page-in-lumpy-reclaim-when-no-swap-space-is-avilable.patch
vmscan-move-clearpageactive-from-move_active_pages-to-shrink_active_list.patch
vmscan-kill-unnecessary-page-flag-test.patch
vmscan-kill-unnecessary-prefetch.patch
vmscan-use-add_page_to_lru_list-helper-function.patch
vmscan-move-pgdeactivate-modification-to-shrink_active_list.patch
mm-perform-non-atomic-test-clear-of-pg_mlocked-on-free.patch
mm-introduce-proc-pid-oom_adj_child.patch
getrusage-fill-ru_maxrss-value.patch
getrusage-fill-ru_maxrss-value-update.patch
memory-controller-soft-limit-documentation-v9.patch
memory-controller-soft-limit-interface-v9.patch
memory-controller-soft-limit-organize-cgroups-v9.patch
memory-controller-soft-limit-refactor-reclaim-flags-v9.patch
memory-controller-soft-limit-reclaim-on-contention-v9.patch
memory-controller-soft-limit-reclaim-on-contention-v9-fix.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

