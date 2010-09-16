From: akpm@linux-foundation.org
Subject: + vmscan-remove-dead-code-in-shrink_inactive_list.patch added to -mm tree
Date: Thu, 16 Sep 2010 15:28:38 -0700
Message-ID: <201009162228.o8GMScS4017347@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37862 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752950Ab0IPWin (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Sep 2010 18:38:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, fengguang.wu@intel.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, minchan.kim@gmail.com, riel@redhat.com


The patch titled
     vmscan: remove dead code in shrink_inactive_list()
has been added to the -mm tree.  Its filename is
     vmscan-remove-dead-code-in-shrink_inactive_list.patch

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
Subject: vmscan: remove dead code in shrink_inactive_list()
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

After synchrounous lumpy reclaim, the page_list is guaranteed to not have
active pages as page activation in shrink_page_list() disables lumpy
reclaim.  Remove the dead code.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    8 --------
 1 file changed, 8 deletions(-)

diff -puN mm/vmscan.c~vmscan-remove-dead-code-in-shrink_inactive_list mm/vmscan.c
--- a/mm/vmscan.c~vmscan-remove-dead-code-in-shrink_inactive_list
+++ a/mm/vmscan.c
@@ -1331,7 +1331,6 @@ shrink_inactive_list(unsigned long nr_to
 	unsigned long nr_scanned;
 	unsigned long nr_reclaimed = 0;
 	unsigned long nr_taken;
-	unsigned long nr_active;
 	unsigned long nr_anon;
 	unsigned long nr_file;
 
@@ -1386,13 +1385,6 @@ shrink_inactive_list(unsigned long nr_to
 
 	/* Check if we should syncronously wait for writeback */
 	if (should_reclaim_stall(nr_taken, nr_reclaimed, priority, sc)) {
-		/*
-		 * The attempt at page out may have made some
-		 * of the pages active, mark them inactive again.
-		 */
-		nr_active = clear_active_flags(&page_list, NULL);
-		count_vm_events(PGDEACTIVATE, nr_active);
-
 		set_lumpy_reclaim_mode(priority, sc, true);
 		nr_reclaimed += shrink_page_list(&page_list, sc);
 	}
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

