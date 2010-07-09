From: akpm@linux-foundation.org
Subject: + vmscan-protect-reading-of-reclaim_stat-with-lru_lock.patch added to -mm tree
Date: Fri, 09 Jul 2010 15:52:10 -0700
Message-ID: <201007092252.o69MqAH0030093@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52325 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753636Ab0GIWwX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jul 2010 18:52:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, riel@redhat.com


The patch titled
     vmscan: protect reading of reclaim_stat with lru_lock
has been added to the -mm tree.  Its filename is
     vmscan-protect-reading-of-reclaim_stat-with-lru_lock.patch

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
Subject: vmscan: protect reading of reclaim_stat with lru_lock
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Rik van Riel pointed out reading reclaim_stat should be protected
lru_lock, otherwise vmscan might sweep 2x much pages.

This fault was introduced by

  commit 4f98a2fee8acdb4ac84545df98cccecfd130f8db
  Author: Rik van Riel <riel@redhat.com>
  Date:   Sat Oct 18 20:26:32 2008 -0700

    vmscan: split LRU lists into anon & file sets

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff -puN mm/vmscan.c~vmscan-protect-reading-of-reclaim_stat-with-lru_lock mm/vmscan.c
--- a/mm/vmscan.c~vmscan-protect-reading-of-reclaim_stat-with-lru_lock
+++ a/mm/vmscan.c
@@ -1626,6 +1626,13 @@ static void get_scan_count(struct zone *
 	}
 
 	/*
+	 * With swappiness at 100, anonymous and file have the same priority.
+	 * This scanning priority is essentially the inverse of IO cost.
+	 */
+	anon_prio = sc->swappiness;
+	file_prio = 200 - sc->swappiness;
+
+	/*
 	 * OK, so we have swap space and a fair amount of page cache
 	 * pages.  We use the recently rotated / recently scanned
 	 * ratios to determine how valuable each cache is.
@@ -1636,28 +1643,18 @@ static void get_scan_count(struct zone *
 	 *
 	 * anon in [0], file in [1]
 	 */
+	spin_lock_irq(&zone->lru_lock);
 	if (unlikely(reclaim_stat->recent_scanned[0] > anon / 4)) {
-		spin_lock_irq(&zone->lru_lock);
 		reclaim_stat->recent_scanned[0] /= 2;
 		reclaim_stat->recent_rotated[0] /= 2;
-		spin_unlock_irq(&zone->lru_lock);
 	}
 
 	if (unlikely(reclaim_stat->recent_scanned[1] > file / 4)) {
-		spin_lock_irq(&zone->lru_lock);
 		reclaim_stat->recent_scanned[1] /= 2;
 		reclaim_stat->recent_rotated[1] /= 2;
-		spin_unlock_irq(&zone->lru_lock);
 	}
 
 	/*
-	 * With swappiness at 100, anonymous and file have the same priority.
-	 * This scanning priority is essentially the inverse of IO cost.
-	 */
-	anon_prio = sc->swappiness;
-	file_prio = 200 - sc->swappiness;
-
-	/*
 	 * The amount of pressure on anon vs file pages is inversely
 	 * proportional to the fraction of recently scanned pages on
 	 * each list that were recently referenced and in active use.
@@ -1667,6 +1664,7 @@ static void get_scan_count(struct zone *
 
 	fp = (file_prio + 1) * (reclaim_stat->recent_scanned[1] + 1);
 	fp /= reclaim_stat->recent_rotated[1] + 1;
+	spin_unlock_irq(&zone->lru_lock);
 
 	fraction[0] = ap;
 	fraction[1] = fp;
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

acpi-fix-unused-function-warning.patch
serial-mmio32-support-for-8250_earlyc-fix-fix.patch
security-add-const-to-security_task_setscheduler.patch
sched-make-sched_param-argument-static-variables-in-some-sched_setscheduler-caller.patch
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
oom-dont-try-to-kill-oom_unkillable-child.patch
oom-dont-try-to-kill-oom_unkillable-child-checkpatch-fixes.patch
oom-oom_kill_process-doesnt-select-kthread-child.patch
oom-make-oom_unkillable_task-helper-function.patch
oom-oom_kill_process-needs-to-check-that-p-is-unkillable.patch
oom-proc-pid-oom_score-treat-kernel-thread-honestly.patch
oom-kill-duplicate-oom_disable-check.patch
oom-move-oom_disable-check-from-oom_kill_task-to-out_of_memory.patch
oom-cleanup-has_intersects_mems_allowed.patch
oom-remove-child-mm-check-from-oom_kill_process.patch
oom-give-the-dying-task-a-higher-priority.patch
oom-multi-threaded-process-coredump-dont-make-deadlock.patch
rmap-add-exclusive-page-to-private-anon_vma-on-swapin.patch
mm-set-vm_fault_write-in-do_swap_page.patch
drivers-base-nodec-reduce-stack-usage-of-node_read_meminfo.patch
vmscan-avoid-subtraction-of-unsigned-types.patch
vmscan-protect-reading-of-reclaim_stat-with-lru_lock.patch
reiser4.patch

