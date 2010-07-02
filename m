From: akpm@linux-foundation.org
Subject: + vmscan-simplify-shrink_inactive_list.patch added to -mm tree
Date: Fri, 02 Jul 2010 12:58:11 -0700
Message-ID: <201007021958.o62JwBh8023866@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45235 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759688Ab0GBT6n (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 Jul 2010 15:58:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, aarcange@redhat.com, chris.mason@oracle.com, david@fromorbit.com, hannes@cmpxchg.org, hch@infradead.org, kamezawa.hiroyu@jp.fujitsu.com, mrubin@google.com, npiggin@suse.de, riel@redhat.com


The patch titled
     vmscan: simplify shrink_inactive_list()
has been added to the -mm tree.  Its filename is
     vmscan-simplify-shrink_inactive_list.patch

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
Subject: vmscan: simplify shrink_inactive_list()
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Now, max_scan of shrink_inactive_list() is always passed less than
SWAP_CLUSTER_MAX.  then, we can remove scanning pages loop in it.  This
patch also help stack diet.

detail
 - remove "while (nr_scanned < max_scan)" loop
 - remove nr_freed (now, we use nr_reclaimed directly)
 - remove nr_scan (now, we use nr_scanned directly)
 - rename max_scan to nr_to_scan
 - pass nr_to_scan into isolate_pages() directly instead
   using SWAP_CLUSTER_MAX

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Michael Rubin <mrubin@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |  211 +++++++++++++++++++++++---------------------------
 1 file changed, 100 insertions(+), 111 deletions(-)

diff -puN mm/vmscan.c~vmscan-simplify-shrink_inactive_list mm/vmscan.c
--- a/mm/vmscan.c~vmscan-simplify-shrink_inactive_list
+++ a/mm/vmscan.c
@@ -1134,15 +1134,21 @@ static int too_many_isolated(struct zone
  * shrink_inactive_list() is a helper for shrink_zone().  It returns the number
  * of reclaimed pages
  */
-static unsigned long shrink_inactive_list(unsigned long max_scan,
+static unsigned long shrink_inactive_list(unsigned long nr_to_scan,
 			struct zone *zone, struct scan_control *sc,
 			int priority, int file)
 {
 	LIST_HEAD(page_list);
 	struct pagevec pvec;
-	unsigned long nr_scanned = 0;
+	unsigned long nr_scanned;
 	unsigned long nr_reclaimed = 0;
 	struct zone_reclaim_stat *reclaim_stat = get_reclaim_stat(zone, sc);
+	struct page *page;
+	unsigned long nr_taken;
+	unsigned long nr_active;
+	unsigned int count[NR_LRU_LISTS] = { 0, };
+	unsigned long nr_anon;
+	unsigned long nr_file;
 
 	while (unlikely(too_many_isolated(zone, file, sc))) {
 		congestion_wait(BLK_RW_ASYNC, HZ/10);
@@ -1157,129 +1163,112 @@ static unsigned long shrink_inactive_lis
 
 	lru_add_drain();
 	spin_lock_irq(&zone->lru_lock);
-	do {
-		struct page *page;
-		unsigned long nr_taken;
-		unsigned long nr_scan;
-		unsigned long nr_freed;
-		unsigned long nr_active;
-		unsigned int count[NR_LRU_LISTS] = { 0, };
-		int mode = sc->lumpy_reclaim_mode ? ISOLATE_BOTH : ISOLATE_INACTIVE;
-		unsigned long nr_anon;
-		unsigned long nr_file;
 
-		if (scanning_global_lru(sc)) {
-			nr_taken = isolate_pages_global(SWAP_CLUSTER_MAX,
-							&page_list, &nr_scan,
-							sc->order, mode,
-							zone, 0, file);
-			zone->pages_scanned += nr_scan;
-			if (current_is_kswapd())
-				__count_zone_vm_events(PGSCAN_KSWAPD, zone,
-						       nr_scan);
-			else
-				__count_zone_vm_events(PGSCAN_DIRECT, zone,
-						       nr_scan);
-		} else {
-			nr_taken = mem_cgroup_isolate_pages(SWAP_CLUSTER_MAX,
-							&page_list, &nr_scan,
-							sc->order, mode,
-							zone, sc->mem_cgroup,
-							0, file);
-			/*
-			 * mem_cgroup_isolate_pages() keeps track of
-			 * scanned pages on its own.
-			 */
-		}
+	if (scanning_global_lru(sc)) {
+		nr_taken = isolate_pages_global(nr_to_scan,
+			&page_list, &nr_scanned, sc->order,
+			sc->lumpy_reclaim_mode ? ISOLATE_BOTH : ISOLATE_INACTIVE,
+			zone, 0, file);
+		zone->pages_scanned += nr_scanned;
+		if (current_is_kswapd())
+			__count_zone_vm_events(PGSCAN_KSWAPD, zone,
+					       nr_scanned);
+		else
+			__count_zone_vm_events(PGSCAN_DIRECT, zone,
+					       nr_scanned);
+	} else {
+		nr_taken = mem_cgroup_isolate_pages(nr_to_scan,
+			&page_list, &nr_scanned, sc->order,
+			sc->lumpy_reclaim_mode ? ISOLATE_BOTH : ISOLATE_INACTIVE,
+			zone, sc->mem_cgroup,
+			0, file);
+		/*
+		 * mem_cgroup_isolate_pages() keeps track of
+		 * scanned pages on its own.
+		 */
+	}
 
-		if (nr_taken == 0)
-			goto done;
+	if (nr_taken == 0)
+		goto done;
 
-		nr_active = clear_active_flags(&page_list, count);
-		__count_vm_events(PGDEACTIVATE, nr_active);
+	nr_active = clear_active_flags(&page_list, count);
+	__count_vm_events(PGDEACTIVATE, nr_active);
 
-		__mod_zone_page_state(zone, NR_ACTIVE_FILE,
-						-count[LRU_ACTIVE_FILE]);
-		__mod_zone_page_state(zone, NR_INACTIVE_FILE,
-						-count[LRU_INACTIVE_FILE]);
-		__mod_zone_page_state(zone, NR_ACTIVE_ANON,
-						-count[LRU_ACTIVE_ANON]);
-		__mod_zone_page_state(zone, NR_INACTIVE_ANON,
-						-count[LRU_INACTIVE_ANON]);
-
-		nr_anon = count[LRU_ACTIVE_ANON] + count[LRU_INACTIVE_ANON];
-		nr_file = count[LRU_ACTIVE_FILE] + count[LRU_INACTIVE_FILE];
-		__mod_zone_page_state(zone, NR_ISOLATED_ANON, nr_anon);
-		__mod_zone_page_state(zone, NR_ISOLATED_FILE, nr_file);
+	__mod_zone_page_state(zone, NR_ACTIVE_FILE,
+					-count[LRU_ACTIVE_FILE]);
+	__mod_zone_page_state(zone, NR_INACTIVE_FILE,
+					-count[LRU_INACTIVE_FILE]);
+	__mod_zone_page_state(zone, NR_ACTIVE_ANON,
+					-count[LRU_ACTIVE_ANON]);
+	__mod_zone_page_state(zone, NR_INACTIVE_ANON,
+					-count[LRU_INACTIVE_ANON]);
+
+	nr_anon = count[LRU_ACTIVE_ANON] + count[LRU_INACTIVE_ANON];
+	nr_file = count[LRU_ACTIVE_FILE] + count[LRU_INACTIVE_FILE];
+	__mod_zone_page_state(zone, NR_ISOLATED_ANON, nr_anon);
+	__mod_zone_page_state(zone, NR_ISOLATED_FILE, nr_file);
 
-		reclaim_stat->recent_scanned[0] += nr_anon;
-		reclaim_stat->recent_scanned[1] += nr_file;
+	reclaim_stat->recent_scanned[0] += nr_anon;
+	reclaim_stat->recent_scanned[1] += nr_file;
 
-		spin_unlock_irq(&zone->lru_lock);
+	spin_unlock_irq(&zone->lru_lock);
 
-		nr_scanned += nr_scan;
-		nr_freed = shrink_page_list(&page_list, sc, PAGEOUT_IO_ASYNC);
+	nr_reclaimed = shrink_page_list(&page_list, sc, PAGEOUT_IO_ASYNC);
+
+	/*
+	 * If we are direct reclaiming for contiguous pages and we do
+	 * not reclaim everything in the list, try again and wait
+	 * for IO to complete. This will stall high-order allocations
+	 * but that should be acceptable to the caller
+	 */
+	if (nr_reclaimed < nr_taken && !current_is_kswapd() && sc->lumpy_reclaim_mode) {
+		congestion_wait(BLK_RW_ASYNC, HZ/10);
 
 		/*
-		 * If we are direct reclaiming for contiguous pages and we do
-		 * not reclaim everything in the list, try again and wait
-		 * for IO to complete. This will stall high-order allocations
-		 * but that should be acceptable to the caller
+		 * The attempt at page out may have made some
+		 * of the pages active, mark them inactive again.
 		 */
-		if (nr_freed < nr_taken && !current_is_kswapd() &&
-		    sc->lumpy_reclaim_mode) {
-			congestion_wait(BLK_RW_ASYNC, HZ/10);
-
-			/*
-			 * The attempt at page out may have made some
-			 * of the pages active, mark them inactive again.
-			 */
-			nr_active = clear_active_flags(&page_list, count);
-			count_vm_events(PGDEACTIVATE, nr_active);
-
-			nr_freed += shrink_page_list(&page_list, sc,
-							PAGEOUT_IO_SYNC);
-		}
+		nr_active = clear_active_flags(&page_list, count);
+		count_vm_events(PGDEACTIVATE, nr_active);
 
-		nr_reclaimed += nr_freed;
+		nr_reclaimed += shrink_page_list(&page_list, sc, PAGEOUT_IO_SYNC);
+	}
 
-		local_irq_disable();
-		if (current_is_kswapd())
-			__count_vm_events(KSWAPD_STEAL, nr_freed);
-		__count_zone_vm_events(PGSTEAL, zone, nr_freed);
+	local_irq_disable();
+	if (current_is_kswapd())
+		__count_vm_events(KSWAPD_STEAL, nr_reclaimed);
+	__count_zone_vm_events(PGSTEAL, zone, nr_reclaimed);
 
-		spin_lock(&zone->lru_lock);
-		/*
-		 * Put back any unfreeable pages.
-		 */
-		while (!list_empty(&page_list)) {
-			int lru;
-			page = lru_to_page(&page_list);
-			VM_BUG_ON(PageLRU(page));
-			list_del(&page->lru);
-			if (unlikely(!page_evictable(page, NULL))) {
-				spin_unlock_irq(&zone->lru_lock);
-				putback_lru_page(page);
-				spin_lock_irq(&zone->lru_lock);
-				continue;
-			}
-			SetPageLRU(page);
-			lru = page_lru(page);
-			add_page_to_lru_list(zone, page, lru);
-			if (is_active_lru(lru)) {
-				int file = is_file_lru(lru);
-				reclaim_stat->recent_rotated[file]++;
-			}
-			if (!pagevec_add(&pvec, page)) {
-				spin_unlock_irq(&zone->lru_lock);
-				__pagevec_release(&pvec);
-				spin_lock_irq(&zone->lru_lock);
-			}
+	spin_lock(&zone->lru_lock);
+	/*
+	 * Put back any unfreeable pages.
+	 */
+	while (!list_empty(&page_list)) {
+		int lru;
+		page = lru_to_page(&page_list);
+		VM_BUG_ON(PageLRU(page));
+		list_del(&page->lru);
+		if (unlikely(!page_evictable(page, NULL))) {
+			spin_unlock_irq(&zone->lru_lock);
+			putback_lru_page(page);
+			spin_lock_irq(&zone->lru_lock);
+			continue;
 		}
-		__mod_zone_page_state(zone, NR_ISOLATED_ANON, -nr_anon);
-		__mod_zone_page_state(zone, NR_ISOLATED_FILE, -nr_file);
-
-  	} while (nr_scanned < max_scan);
+		SetPageLRU(page);
+		lru = page_lru(page);
+		add_page_to_lru_list(zone, page, lru);
+		if (is_active_lru(lru)) {
+			int file = is_file_lru(lru);
+			reclaim_stat->recent_rotated[file]++;
+		}
+		if (!pagevec_add(&pvec, page)) {
+			spin_unlock_irq(&zone->lru_lock);
+			__pagevec_release(&pvec);
+			spin_lock_irq(&zone->lru_lock);
+		}
+	}
+	__mod_zone_page_state(zone, NR_ISOLATED_ANON, -nr_anon);
+	__mod_zone_page_state(zone, NR_ISOLATED_FILE, -nr_file);
 
 done:
 	spin_unlock_irq(&zone->lru_lock);
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
acpi-fix-unused-function-warning.patch
mm-use-memdup_user.patch
oom-check-pf_kthread-instead-of-mm-to-skip-kthreads.patch
oom-pf_exiting-check-should-take-mm-into-account.patch
oom-introduce-find_lock_task_mm-to-fix-mm-false-positives.patch
oom-dump_tasks-use-find_lock_task_mm-too.patch
oom-improve-commentary-in-dump_tasks.patch
oom-dump_tasks-use-find_lock_task_mm-too-dump_tasks-use-find_lock_task_mm-too-fix.patch
oom-give-current-access-to-memory-reserves-if-it-has-been-killed.patch
oom-avoid-sending-exiting-tasks-a-sigkill.patch
oom-filter-tasks-not-sharing-the-same-cpuset.patch
oom-sacrifice-child-with-highest-badness-score-for-parent.patch
oom-sacrifice-child-with-highest-badness-score-for-parent-protect-dereferencing-of-tasks-comm.patch
oom-sacrifice-child-with-highest-badness-score-for-parent-fix.patch
oom-select-task-from-tasklist-for-mempolicy-ooms.patch
oom-select-task-from-tasklist-for-mempolicy-ooms-add-has_intersects_mems_allowed-uma-variant.patch
oom-select-task-from-tasklist-for-mempolicy-ooms-introduce-find_lock_task_mm-to-fix-mm-false-positives-fix.patch
oom-enable-oom-tasklist-dump-by-default.patch
oom-avoid-oom-killer-for-lowmem-allocations.patch
oom-extract-panic-helper-function.patch
oom-remove-special-handling-for-pagefault-ooms.patch
oom-move-sysctl-declarations-to-oomh.patch
mm-rename-try_set_zone_oom-to-try_set_zonelist_oom.patch
oom-remove-constraint-argument-from-select_bad_process-and-__out_of_memory.patch
oom-fold-__out_of_memory-into-out_of_memory.patch
mm-use-for_each_online_cpu-in-vmstat.patch
mempolicy-reduce-stack-size-of-migrate_pages.patch
mempolicy-reduce-stack-size-of-migrate_pages-fix.patch
vmscan-zone_reclaim-dont-call-disable_swap_token.patch
vmscan-recalculate-lru_pages-on-each-priority.patch
vmscan-tracing-add-trace-events-for-kswapd-wakeup-sleeping-and-direct-reclaim.patch
vmscan-tracing-add-trace-events-for-lru-page-isolation.patch
vmscan-tracing-add-trace-event-when-a-page-is-written.patch
vmscan-tracing-add-a-postprocessing-script-for-reclaim-related-ftrace-events.patch
vmscan-kill-prev_priority-completely.patch
vmscan-simplify-shrink_inactive_list.patch
vmscan-remove-unnecessary-temporary-vars-in-do_try_to_free_pages.patch
vmscan-set-up-pagevec-as-late-as-possible-in-shrink_inactive_list.patch
vmscan-set-up-pagevec-as-late-as-possible-in-shrink_page_list.patch
vmscan-update-isolated-page-counters-outside-of-main-path-in-shrink_inactive_list.patch
reiser4.patch

