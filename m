From: akpm@linux-foundation.org
Subject: + memcg-mem_cgroup_shrink_node_zone-doesnt-need-scnodemask.patch added to -mm tree
Date: Thu, 29 Jul 2010 12:23:01 -0700
Message-ID: <201007291923.o6TJN1Ne028842@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33883 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756879Ab0G2TXi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Jul 2010 15:23:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, balbir@in.ibm.com, d-nishimura@mtf.biglobe.ne.jp, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie


The patch titled
     memcg: mem_cgroup_shrink_node_zone() doesn't need sc.nodemask
has been added to the -mm tree.  Its filename is
     memcg-mem_cgroup_shrink_node_zone-doesnt-need-scnodemask.patch

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
Subject: memcg: mem_cgroup_shrink_node_zone() doesn't need sc.nodemask
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Currently mem_cgroup_shrink_node_zone() call shrink_zone() directly.  thus
it doesn't need to initialize sc.nodemask because shrink_zone() doesn't
use it at all.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Nishimura Daisuke <d-nishimura@mtf.biglobe.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    3 +--
 mm/memcontrol.c      |    3 +--
 mm/vmscan.c          |    5 +----
 3 files changed, 3 insertions(+), 8 deletions(-)

diff -puN include/linux/swap.h~memcg-mem_cgroup_shrink_node_zone-doesnt-need-scnodemask include/linux/swap.h
--- a/include/linux/swap.h~memcg-mem_cgroup_shrink_node_zone-doesnt-need-scnodemask
+++ a/include/linux/swap.h
@@ -244,8 +244,7 @@ extern unsigned long try_to_free_mem_cgr
 extern unsigned long mem_cgroup_shrink_node_zone(struct mem_cgroup *mem,
 						gfp_t gfp_mask, bool noswap,
 						unsigned int swappiness,
-						struct zone *zone,
-						int nid);
+						struct zone *zone);
 extern int __isolate_lru_page(struct page *page, int mode, int file);
 extern unsigned long shrink_all_memory(unsigned long nr_pages);
 extern int vm_swappiness;
diff -puN mm/memcontrol.c~memcg-mem_cgroup_shrink_node_zone-doesnt-need-scnodemask mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-mem_cgroup_shrink_node_zone-doesnt-need-scnodemask
+++ a/mm/memcontrol.c
@@ -1282,8 +1282,7 @@ static int mem_cgroup_hierarchical_recla
 		/* we use swappiness of local cgroup */
 		if (check_soft)
 			ret = mem_cgroup_shrink_node_zone(victim, gfp_mask,
-				noswap, get_swappiness(victim), zone,
-				zone->zone_pgdat->node_id);
+				noswap, get_swappiness(victim), zone);
 		else
 			ret = try_to_free_mem_cgroup_pages(victim, gfp_mask,
 						noswap, get_swappiness(victim));
diff -puN mm/vmscan.c~memcg-mem_cgroup_shrink_node_zone-doesnt-need-scnodemask mm/vmscan.c
--- a/mm/vmscan.c~memcg-mem_cgroup_shrink_node_zone-doesnt-need-scnodemask
+++ a/mm/vmscan.c
@@ -1934,7 +1934,7 @@ unsigned long try_to_free_pages(struct z
 unsigned long mem_cgroup_shrink_node_zone(struct mem_cgroup *mem,
 						gfp_t gfp_mask, bool noswap,
 						unsigned int swappiness,
-						struct zone *zone, int nid)
+						struct zone *zone)
 {
 	struct scan_control sc = {
 		.nr_to_reclaim = SWAP_CLUSTER_MAX,
@@ -1945,11 +1945,8 @@ unsigned long mem_cgroup_shrink_node_zon
 		.order = 0,
 		.mem_cgroup = mem,
 	};
-	nodemask_t nm  = nodemask_of_node(nid);
-
 	sc.gfp_mask = (gfp_mask & GFP_RECLAIM_MASK) |
 			(GFP_HIGHUSER_MOVABLE & ~GFP_RECLAIM_MASK);
-	sc.nodemask = &nm;
 
 	trace_mm_vmscan_memcg_softlimit_reclaim_begin(0,
 						      sc.may_writepage,
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

