From: akpm@linux-foundation.org
Subject: + memcg-remove-nid-and-zid-argument-from-mem_cgroup_soft_limit_reclaim.patch added to -mm tree
Date: Thu, 29 Jul 2010 12:23:03 -0700
Message-ID: <201007291923.o6TJN3K6028845@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43052 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757109Ab0G2TXi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Jul 2010 15:23:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, balbir@in.ibm.com, d-nishimura@mtf.biglobe.ne.jp, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie


The patch titled
     memcg: remove nid and zid argument from mem_cgroup_soft_limit_reclaim()
has been added to the -mm tree.  Its filename is
     memcg-remove-nid-and-zid-argument-from-mem_cgroup_soft_limit_reclaim.patch

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
Subject: memcg: remove nid and zid argument from mem_cgroup_soft_limit_reclaim()
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

mem_cgroup_soft_limit_reclaim() has zone, nid and zid argument.  but nid
and zid can be calculated from zone.  So remove it.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Nishimura Daisuke <d-nishimura@mtf.biglobe.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    6 +++---
 mm/memcontrol.c            |    5 ++---
 mm/vmscan.c                |    7 ++-----
 3 files changed, 7 insertions(+), 11 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-remove-nid-and-zid-argument-from-mem_cgroup_soft_limit_reclaim include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-remove-nid-and-zid-argument-from-mem_cgroup_soft_limit_reclaim
+++ a/include/linux/memcontrol.h
@@ -123,8 +123,8 @@ static inline bool mem_cgroup_disabled(v
 
 void mem_cgroup_update_file_mapped(struct page *page, int val);
 unsigned long mem_cgroup_soft_limit_reclaim(struct zone *zone, int order,
-						gfp_t gfp_mask, int nid,
-						int zid);
+					    gfp_t gfp_mask);
+
 #else /* CONFIG_CGROUP_MEM_RES_CTLR */
 struct mem_cgroup;
 
@@ -299,7 +299,7 @@ static inline void mem_cgroup_update_fil
 
 static inline
 unsigned long mem_cgroup_soft_limit_reclaim(struct zone *zone, int order,
-					    gfp_t gfp_mask, int nid, int zid)
+					    gfp_t gfp_mask)
 {
 	return 0;
 }
diff -puN mm/memcontrol.c~memcg-remove-nid-and-zid-argument-from-mem_cgroup_soft_limit_reclaim mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-remove-nid-and-zid-argument-from-mem_cgroup_soft_limit_reclaim
+++ a/mm/memcontrol.c
@@ -2847,8 +2847,7 @@ static int mem_cgroup_resize_memsw_limit
 }
 
 unsigned long mem_cgroup_soft_limit_reclaim(struct zone *zone, int order,
-						gfp_t gfp_mask, int nid,
-						int zid)
+					    gfp_t gfp_mask)
 {
 	unsigned long nr_reclaimed = 0;
 	struct mem_cgroup_per_zone *mz, *next_mz = NULL;
@@ -2860,7 +2859,7 @@ unsigned long mem_cgroup_soft_limit_recl
 	if (order > 0)
 		return 0;
 
-	mctz = soft_limit_tree_node_zone(nid, zid);
+	mctz = soft_limit_tree_node_zone(zone_to_nid(zone), zone_idx(zone));
 	/*
 	 * This loop can run a while, specially if mem_cgroup's continuously
 	 * keep exceeding their soft limit and putting the system under
diff -puN mm/vmscan.c~memcg-remove-nid-and-zid-argument-from-mem_cgroup_soft_limit_reclaim mm/vmscan.c
--- a/mm/vmscan.c~memcg-remove-nid-and-zid-argument-from-mem_cgroup_soft_limit_reclaim
+++ a/mm/vmscan.c
@@ -2133,7 +2133,6 @@ loop_again:
 		for (i = 0; i <= end_zone; i++) {
 			struct zone *zone = pgdat->node_zones + i;
 			int nr_slab;
-			int nid, zid;
 
 			if (!populated_zone(zone))
 				continue;
@@ -2143,14 +2142,12 @@ loop_again:
 
 			sc.nr_scanned = 0;
 
-			nid = pgdat->node_id;
-			zid = zone_idx(zone);
 			/*
 			 * Call soft limit reclaim before calling shrink_zone.
 			 * For now we ignore the return value
 			 */
-			mem_cgroup_soft_limit_reclaim(zone, order, sc.gfp_mask,
-							nid, zid);
+			mem_cgroup_soft_limit_reclaim(zone, order, sc.gfp_mask);
+
 			/*
 			 * We put equal pressure on every zone, unless one
 			 * zone has way too many pages free already.
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
linux-next.patch
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
vmscan-shrink_slab-require-number-of-lru_pages-not-page-order-fix-fix.patch
vmscan-convert-direct-reclaim-tracepoint-to-define_trace.patch
memcg-vmscan-add-memcg-reclaim-tracepoint.patch
vmscan-convert-mm_vmscan_lru_isolate-to-define_event.patch
memcg-add-mm_vmscan_memcg_isolate-tracepoint.patch
memcg-scnr_to_reclaim-should-be-initialized.patch
memcg-kill-unnecessary-initialization-in-mem_cgroup_shrink_node_zone.patch
memcg-mem_cgroup_shrink_node_zone-doesnt-need-scnodemask.patch
memcg-remove-nid-and-zid-argument-from-mem_cgroup_soft_limit_reclaim.patch
memcg-convert-to-use-zone_to_nid-from-bare-zone-zone_pgdat-node_id.patch
reiser4.patch

