From: akpm@linux-foundation.org
Subject: + vmscan-isolated_lru_pages-stop-neighbour-search-if-neighbour-cannot-be-isolated.patch added to -mm tree
Date: Thu, 16 Sep 2010 15:28:41 -0700
Message-ID: <201009162228.o8GMSfQ6017350@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45343 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753180Ab0IPWip (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Sep 2010 18:38:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, fengguang.wu@intel.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, minchan.kim@gmail.com, riel@redhat.com


The patch titled
     vmscan: isolate_lru_pages(): stop neighbour search if neighbour cannot be isolated
has been added to the -mm tree.  Its filename is
     vmscan-isolated_lru_pages-stop-neighbour-search-if-neighbour-cannot-be-isolated.patch

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
Subject: vmscan: isolate_lru_pages(): stop neighbour search if neighbour cannot be isolated
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

isolate_lru_pages() does not just isolate LRU tail pages, but also
isolates neighbour pages of the eviction page.  The neighbour search does
not stop even if neighbours cannot be isolated which is excessive as the
lumpy reclaim will no longer result in a successful higher order
allocation.  This patch stops the PFN neighbour pages if an isolation
fails and moves on to the next block.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: Wu Fengguang <fengguang.wu@intel.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff -puN mm/vmscan.c~vmscan-isolated_lru_pages-stop-neighbour-search-if-neighbour-cannot-be-isolated mm/vmscan.c
--- a/mm/vmscan.c~vmscan-isolated_lru_pages-stop-neighbour-search-if-neighbour-cannot-be-isolated
+++ a/mm/vmscan.c
@@ -1051,7 +1051,7 @@ static unsigned long isolate_lru_pages(u
 
 			/* Check that we have not crossed a zone boundary. */
 			if (unlikely(page_zone_id(cursor_page) != zone_id))
-				continue;
+				break;
 
 			/*
 			 * If we don't have enough swap space, reclaiming of
@@ -1059,8 +1059,8 @@ static unsigned long isolate_lru_pages(u
 			 * pointless.
 			 */
 			if (nr_swap_pages <= 0 && PageAnon(cursor_page) &&
-					!PageSwapCache(cursor_page))
-				continue;
+			    !PageSwapCache(cursor_page))
+				break;
 
 			if (__isolate_lru_page(cursor_page, mode, file) == 0) {
 				list_move(&cursor_page->lru, dst);
@@ -1071,11 +1071,16 @@ static unsigned long isolate_lru_pages(u
 					nr_lumpy_dirty++;
 				scan++;
 			} else {
-				if (mode == ISOLATE_BOTH &&
-						page_count(cursor_page))
-					nr_lumpy_failed++;
+				/* the page is freed already. */
+				if (!page_count(cursor_page))
+					continue;
+				break;
 			}
 		}
+
+		/* If we break out of the loop above, lumpy reclaim failed */
+		if (pfn < end_pfn)
+			nr_lumpy_failed++;
 	}
 
 	*scanned = scan;
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

oom-always-return-a-badness-score-of-non-zero-for-eligible-tasks.patch
linux-next.patch
vmscan-check-all_unreclaimable-in-direct-reclaim-path.patch
vmscan-check-all_unreclaimable-in-direct-reclaim-path-v2.patch
proc-pid-smaps-fix-dirty-pages-accounting.patch
proc-pid-smaps-export-amount-of-anonymous-memory-in-a-mapping.patch
oom-filter-unkillable-tasks-from-tasklist-dump.patch
security-add-const-to-security_task_setscheduler.patch
sched-make-sched_param-argument-static-variables-in-some-sched_setscheduler-caller.patch
oom-add-per-mm-oom-disable-count.patch
oom-avoid-killing-a-task-if-a-thread-sharing-its-mm-cannot-be-killed.patch
oom-kill-all-threads-sharing-oom-killed-tasks-mm.patch
oom-kill-all-threads-sharing-oom-killed-tasks-mm-fix.patch
oom-kill-all-threads-sharing-oom-killed-tasks-mm-fix-fix.patch
oom-rewrite-error-handling-for-oom_adj-and-oom_score_adj-tunables.patch
oom-fix-locking-for-oom_adj-and-oom_score_adj.patch
mm-only-build-per-node-scan_unevictable-functions-when-numa-is-enabled.patch
vmscan-prevent-background-aging-of-anon-page-in-no-swap-system.patch
mm-mempolicy-check-return-code-of-check_range.patch
mm-add-account_page_writeback.patch
writeback-add-nr_dirtied-and-nr_written-to-proc-vmstat.patch
writeback-add-nr_dirtied-and-nr_written-to-proc-vmstat-update.patch
writeback-add-sys-devices-system-node-node-vmstat.patch
writeback-add-sys-devices-system-node-node-vmstat-update.patch
writeback-report-dirty-thresholds-in-proc-vmstat.patch
vmscan-delete-dead-code.patch
tracing-vmscan-add-trace-events-for-lru-list-shrinking.patch
writeback-account-for-time-spent-congestion_waited.patch
vmscan-synchronous-lumpy-reclaim-should-not-call-congestion_wait.patch
vmscan-narrow-the-scenarios-lumpy-reclaim-uses-synchrounous-reclaim.patch
vmscan-remove-dead-code-in-shrink_inactive_list.patch
vmscan-isolated_lru_pages-stop-neighbour-search-if-neighbour-cannot-be-isolated.patch
writeback-do-not-sleep-on-the-congestion-queue-if-there-are-no-congested-bdis.patch
writeback-do-not-sleep-on-the-congestion-queue-if-there-are-no-congested-bdis-or-if-significant-congestion-is-not-being-encountered-in-the-current-zone.patch
core_pattern-fix-long-parameters-was-truncated-by-core_pattern-handler.patch
core_pattern-fix-long-parameters-was-truncated-by-core_pattern-handler-update.patch
core_pattern-fix-long-parameters-was-truncated-by-core_pattern-handler-update-2.patch
reiser4.patch

