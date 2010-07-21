From: akpm@linux-foundation.org
Subject: + vmscan-shrink_slab-require-number-of-lru_pages-not-page-order-fix.patch added to -mm tree
Date: Wed, 21 Jul 2010 16:05:57 -0700
Message-ID: <201007212305.o6LN5vc7020287@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49253 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754907Ab0GUXGT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Jul 2010 19:06:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, cl@linux-foundation.org, hannes@cmpxchg.org, minchan.kim@gmail.com, riel@redhat.com


The patch titled
     vmscan-shrink_slab-require-number-of-lru_pages-not-page-order-fix
has been added to the -mm tree.  Its filename is
     vmscan-shrink_slab-require-number-of-lru_pages-not-page-order-fix.patch

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
Subject: vmscan-shrink_slab-require-number-of-lru_pages-not-page-order-fix
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Andrew Morton pointed out shrink_slab() may change number of reclaimable
pages (e.g.  shrink_icache_memory()->prune_icache() will remove unmapped
pagecache).

So, we need to recalculate lru_pages on each shrink_slab() calling.
This patch fixes it.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff -puN mm/vmscan.c~vmscan-shrink_slab-require-number-of-lru_pages-not-page-order-fix mm/vmscan.c
--- a/mm/vmscan.c~vmscan-shrink_slab-require-number-of-lru_pages-not-page-order-fix
+++ a/mm/vmscan.c
@@ -2625,8 +2625,6 @@ static int __zone_reclaim(struct zone *z
 
 	nr_slab_pages0 = zone_page_state(zone, NR_SLAB_RECLAIMABLE);
 	if (nr_slab_pages0 > zone->min_slab_pages) {
-		unsigned long lru_pages = zone_reclaimable_pages(zone);
-
 		/*
 		 * shrink_slab() does not currently allow us to determine how
 		 * many pages were freed in this zone. So we take the current
@@ -2637,10 +2635,18 @@ static int __zone_reclaim(struct zone *z
 		 * Note that shrink_slab will free memory on all zones and may
 		 * take a long time.
 		 */
-		while (shrink_slab(sc.nr_scanned, gfp_mask, lru_pages) &&
-		       (zone_page_state(zone, NR_SLAB_RECLAIMABLE) + nr_pages >
-				nr_slab_pages0))
-			;
+		for (;;) {
+			unsigned long lru_pages = zone_reclaimable_pages(zone);
+
+			/* No reclaimable slab or very low memroy pressure */
+			if (!shrink_slab(sc.nr_scanned, gfp_mask, lru_pages))
+				break;
+
+			/* Freed enouch memory */
+			nr_slab_pages1 = zone_page_state(zone, NR_SLAB_RECLAIMABLE);
+			if (nr_slab_pages1 + nr_pages <= nr_slab_pages0)
+				break;
+		}
 
 		/*
 		 * Update nr_reclaimed by the number of slab pages we
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
acpi-fix-unused-function-warning.patch
serial-mmio32-support-for-8250_earlyc.patch
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
vmscan-shrink_slab-require-number-of-lru_pages-not-page-order.patch
vmscan-shrink_slab-require-number-of-lru_pages-not-page-order-fix.patch
reiser4.patch

