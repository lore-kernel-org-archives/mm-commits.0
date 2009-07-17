From: akpm@linux-foundation.org
Subject: + vmscan-move-pgdeactivate-modification-to-shrink_active_list.patch added to -mm tree
Date: Thu, 16 Jul 2009 17:15:03 -0700
Message-ID: <200907170015.n6H0F3OZ008133@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51464 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933682AbZGQAQS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Jul 2009 20:16:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, fengguang.wu@intel.com, hannes@cmpxchg.org, mel@csn.ul.ie, minchan.kim@gmail.com, riel@redhat.com


The patch titled
     vmscan: move PGDEACTIVATE modification to shrink_active_list()
has been added to the -mm tree.  Its filename is
     vmscan-move-pgdeactivate-modification-to-shrink_active_list.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmscan: move PGDEACTIVATE modification to shrink_active_list()
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Pgmoved accounting in move_active_pages_to_lru() doesn't make any sense. 
it can be calculated in irq enabled area.

This patch move #-of-deactivating-pages calcution to shrink_active_list().

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN mm/vmscan.c~vmscan-move-pgdeactivate-modification-to-shrink_active_list mm/vmscan.c
--- a/mm/vmscan.c~vmscan-move-pgdeactivate-modification-to-shrink_active_list
+++ a/mm/vmscan.c
@@ -1260,7 +1260,6 @@ static void move_active_pages_to_lru(str
 				     struct list_head *list,
 				     enum lru_list lru)
 {
-	unsigned long pgmoved = 0;
 	struct pagevec pvec;
 	struct page *page;
 
@@ -1274,7 +1273,6 @@ static void move_active_pages_to_lru(str
 		SetPageLRU(page);
 
 		add_page_to_lru_list(zone, page, lru);
-		pgmoved++;
 
 		if (!pagevec_add(&pvec, page) || list_empty(list)) {
 			spin_unlock_irq(&zone->lru_lock);
@@ -1284,8 +1282,6 @@ static void move_active_pages_to_lru(str
 			spin_lock_irq(&zone->lru_lock);
 		}
 	}
-	if (!is_active_lru(lru))
-		__count_vm_events(PGDEACTIVATE, pgmoved);
 }
 
 static void shrink_active_list(unsigned long nr_pages, struct zone *zone,
@@ -1300,6 +1296,7 @@ static void shrink_active_list(unsigned 
 	struct page *page;
 	struct zone_reclaim_stat *reclaim_stat = get_reclaim_stat(zone, sc);
 	unsigned long nr_rotated = 0;
+	unsigned long nr_deactivate = 0;
 
 	lru_add_drain();
 	spin_lock_irq(&zone->lru_lock);
@@ -1354,6 +1351,7 @@ static void shrink_active_list(unsigned 
 
 		ClearPageActive(page);	/* we are de-activating */
 		list_add(&page->lru, &l_inactive);
+		nr_deactivate++;
 	}
 
 	/*
@@ -1367,6 +1365,7 @@ static void shrink_active_list(unsigned 
 	 * get_scan_ratio.
 	 */
 	reclaim_stat->recent_rotated[!!file] += nr_rotated;
+	__count_vm_events(PGDEACTIVATE, nr_deactivate);
 
 	move_active_pages_to_lru(zone, &l_active,
 						LRU_ACTIVE + file * LRU_FILE);
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

linux-next.patch
mm-copy-over-oom_adj-value-at-fork-time.patch
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
vmscan-dont-attempt-to-reclaim-anon-page-in-lumpy-reclaim-when-no-swap-space-is-avilable-cleanup.patch
vmscan-move-clearpageactive-from-move_active_pages-to-shrink_active_list.patch
vmscan-kill-unnecessary-page-flag-test.patch
vmscan-kill-unnecessary-prefetch.patch
vmscan-use-add_page_to_lru_list-helper-function.patch
vmscan-move-pgdeactivate-modification-to-shrink_active_list.patch
getrusage-fill-ru_maxrss-value.patch
getrusage-fill-ru_maxrss-value-update.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

