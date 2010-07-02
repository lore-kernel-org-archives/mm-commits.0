From: akpm@linux-foundation.org
Subject: + vmscan-kill-prev_priority-completely.patch added to -mm tree
Date: Fri, 02 Jul 2010 12:58:07 -0700
Message-ID: <201007021958.o62Jw76I023863@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45700 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759688Ab0GBT66 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 Jul 2010 15:58:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, aarcange@redhat.com, chris.mason@oracle.com, david@fromorbit.com, hannes@cmpxchg.org, hch@infradead.org, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, mrubin@google.com, npiggin@suse.de, riel@redhat.com


The patch titled
     vmscan: kill prev_priority completely
has been added to the -mm tree.  Its filename is
     vmscan-kill-prev_priority-completely.patch

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
Subject: vmscan: kill prev_priority completely
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Since 2.6.28 zone->prev_priority is unused. Then it can be removed
safely. It reduce stack usage slightly.

Now I have to say that I'm sorry. 2 years ago, I thought prev_priority
can be integrate again, it's useful. but four (or more) times trying
haven't got good performance number. Thus I give up such approach.

The rest of this changelog is notes on prev_priority and why it existed in
the first place and why it might be not necessary any more. This information
is based heavily on discussions between Andrew Morton, Rik van Riel and
Kosaki Motohiro who is heavily quotes from.

Historically prev_priority was important because it determined when the VM
would start unmapping PTE pages. i.e. there are no balances of note within
the VM, Anon vs File and Mapped vs Unmapped. Without prev_priority, there
is a potential risk of unnecessarily increasing minor faults as a large
amount of read activity of use-once pages could push mapped pages to the
end of the LRU and get unmapped.

There is no proof this is still a problem but currently it is not considered
to be. Active files are not deactivated if the active file list is smaller
than the inactive list reducing the liklihood that file-mapped pages are
being pushed off the LRU and referenced executable pages are kept on the
active list to avoid them getting pushed out by read activity.

Even if it is a problem, prev_priority prev_priority wouldn't works
nowadays. First of all, current vmscan still a lot of UP centric code. it
expose some weakness on some dozens CPUs machine. I think we need more and
more improvement.

The problem is, current vmscan mix up per-system-pressure, per-zone-pressure
and per-task-pressure a bit. example, prev_priority try to boost priority to
other concurrent priority. but if the another task have mempolicy restriction,
it is unnecessary, but also makes wrong big latency and exceeding reclaim.
per-task based priority + prev_priority adjustment make the emulation of
per-system pressure. but it have two issue 1) too rough and brutal emulation
2) we need per-zone pressure, not per-system.

Another example, currently DEF_PRIORITY is 12. it mean the lru rotate about
2 cycle (1/4096 + 1/2048 + 1/1024 + .. + 1) before invoking OOM-Killer.
but if 10,0000 thrreads enter DEF_PRIORITY reclaim at the same time, the
system have higher memory pressure than priority==0 (1/4096*10,000 > 2).
prev_priority can't solve such multithreads workload issue. In other word,
prev_priority concept assume the sysmtem don't have lots threads."

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Mel Gorman <mel@csn.ul.ie>
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

 include/linux/memcontrol.h |    5 ---
 include/linux/mmzone.h     |   15 ---------
 mm/memcontrol.c            |   31 -------------------
 mm/page_alloc.c            |    2 -
 mm/vmscan.c                |   57 -----------------------------------
 mm/vmstat.c                |    2 -
 6 files changed, 112 deletions(-)

diff -puN include/linux/memcontrol.h~vmscan-kill-prev_priority-completely include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~vmscan-kill-prev_priority-completely
+++ a/include/linux/memcontrol.h
@@ -98,11 +98,6 @@ extern void mem_cgroup_end_migration(str
 /*
  * For memory reclaim.
  */
-extern int mem_cgroup_get_reclaim_priority(struct mem_cgroup *mem);
-extern void mem_cgroup_note_reclaim_priority(struct mem_cgroup *mem,
-							int priority);
-extern void mem_cgroup_record_reclaim_priority(struct mem_cgroup *mem,
-							int priority);
 int mem_cgroup_inactive_anon_is_low(struct mem_cgroup *memcg);
 int mem_cgroup_inactive_file_is_low(struct mem_cgroup *memcg);
 unsigned long mem_cgroup_zone_nr_pages(struct mem_cgroup *memcg,
diff -puN include/linux/mmzone.h~vmscan-kill-prev_priority-completely include/linux/mmzone.h
--- a/include/linux/mmzone.h~vmscan-kill-prev_priority-completely
+++ a/include/linux/mmzone.h
@@ -348,21 +348,6 @@ struct zone {
 	atomic_long_t		vm_stat[NR_VM_ZONE_STAT_ITEMS];
 
 	/*
-	 * prev_priority holds the scanning priority for this zone.  It is
-	 * defined as the scanning priority at which we achieved our reclaim
-	 * target at the previous try_to_free_pages() or balance_pgdat()
-	 * invocation.
-	 *
-	 * We use prev_priority as a measure of how much stress page reclaim is
-	 * under - it drives the swappiness decision: whether to unmap mapped
-	 * pages.
-	 *
-	 * Access to both this field is quite racy even on uniprocessor.  But
-	 * it is expected to average out OK.
-	 */
-	int prev_priority;
-
-	/*
 	 * The target ratio of ACTIVE_ANON to INACTIVE_ANON pages on
 	 * this zone's LRU.  Maintained by the pageout code.
 	 */
diff -puN mm/memcontrol.c~vmscan-kill-prev_priority-completely mm/memcontrol.c
--- a/mm/memcontrol.c~vmscan-kill-prev_priority-completely
+++ a/mm/memcontrol.c
@@ -211,8 +211,6 @@ struct mem_cgroup {
 	*/
 	spinlock_t reclaim_param_lock;
 
-	int	prev_priority;	/* for recording reclaim priority */
-
 	/*
 	 * While reclaiming in a hierarchy, we cache the last child we
 	 * reclaimed from.
@@ -858,35 +856,6 @@ int task_in_mem_cgroup(struct task_struc
 	return ret;
 }
 
-/*
- * prev_priority control...this will be used in memory reclaim path.
- */
-int mem_cgroup_get_reclaim_priority(struct mem_cgroup *mem)
-{
-	int prev_priority;
-
-	spin_lock(&mem->reclaim_param_lock);
-	prev_priority = mem->prev_priority;
-	spin_unlock(&mem->reclaim_param_lock);
-
-	return prev_priority;
-}
-
-void mem_cgroup_note_reclaim_priority(struct mem_cgroup *mem, int priority)
-{
-	spin_lock(&mem->reclaim_param_lock);
-	if (priority < mem->prev_priority)
-		mem->prev_priority = priority;
-	spin_unlock(&mem->reclaim_param_lock);
-}
-
-void mem_cgroup_record_reclaim_priority(struct mem_cgroup *mem, int priority)
-{
-	spin_lock(&mem->reclaim_param_lock);
-	mem->prev_priority = priority;
-	spin_unlock(&mem->reclaim_param_lock);
-}
-
 static int calc_inactive_ratio(struct mem_cgroup *memcg, unsigned long *present_pages)
 {
 	unsigned long active;
diff -puN mm/page_alloc.c~vmscan-kill-prev_priority-completely mm/page_alloc.c
--- a/mm/page_alloc.c~vmscan-kill-prev_priority-completely
+++ a/mm/page_alloc.c
@@ -4092,8 +4092,6 @@ static void __paginginit free_area_init_
 		zone_seqlock_init(zone);
 		zone->zone_pgdat = pgdat;
 
-		zone->prev_priority = DEF_PRIORITY;
-
 		zone_pcp_init(zone);
 		for_each_lru(l) {
 			INIT_LIST_HEAD(&zone->lru[l].list);
diff -puN mm/vmscan.c~vmscan-kill-prev_priority-completely mm/vmscan.c
--- a/mm/vmscan.c~vmscan-kill-prev_priority-completely
+++ a/mm/vmscan.c
@@ -1288,20 +1288,6 @@ done:
 }
 
 /*
- * We are about to scan this zone at a certain priority level.  If that priority
- * level is smaller (ie: more urgent) than the previous priority, then note
- * that priority level within the zone.  This is done so that when the next
- * process comes in to scan this zone, it will immediately start out at this
- * priority level rather than having to build up its own scanning priority.
- * Here, this priority affects only the reclaim-mapped threshold.
- */
-static inline void note_zone_scanning_priority(struct zone *zone, int priority)
-{
-	if (priority < zone->prev_priority)
-		zone->prev_priority = priority;
-}
-
-/*
  * This moves pages from the active list to the inactive list.
  *
  * We move them the other way if the page is referenced by one or more
@@ -1764,17 +1750,8 @@ static bool shrink_zones(int priority, s
 		if (scanning_global_lru(sc)) {
 			if (!cpuset_zone_allowed_hardwall(zone, GFP_KERNEL))
 				continue;
-			note_zone_scanning_priority(zone, priority);
-
 			if (zone->all_unreclaimable && priority != DEF_PRIORITY)
 				continue;	/* Let kswapd poll it */
-		} else {
-			/*
-			 * Ignore cpuset limitation here. We just want to reduce
-			 * # of used pages by us regardless of memory shortage.
-			 */
-			mem_cgroup_note_reclaim_priority(sc->mem_cgroup,
-							priority);
 		}
 
 		shrink_zone(priority, zone, sc);
@@ -1875,17 +1852,6 @@ out:
 	if (priority < 0)
 		priority = 0;
 
-	if (scanning_global_lru(sc)) {
-		for_each_zone_zonelist(zone, z, zonelist, high_zoneidx) {
-
-			if (!cpuset_zone_allowed_hardwall(zone, GFP_KERNEL))
-				continue;
-
-			zone->prev_priority = priority;
-		}
-	} else
-		mem_cgroup_record_reclaim_priority(sc->mem_cgroup, priority);
-
 	delayacct_freepages_end();
 	put_mems_allowed();
 
@@ -2051,22 +2017,12 @@ static unsigned long balance_pgdat(pg_da
 		.order = order,
 		.mem_cgroup = NULL,
 	};
-	/*
-	 * temp_priority is used to remember the scanning priority at which
-	 * this zone was successfully refilled to
-	 * free_pages == high_wmark_pages(zone).
-	 */
-	int temp_priority[MAX_NR_ZONES];
-
 loop_again:
 	total_scanned = 0;
 	sc.nr_reclaimed = 0;
 	sc.may_writepage = !laptop_mode;
 	count_vm_event(PAGEOUTRUN);
 
-	for (i = 0; i < pgdat->nr_zones; i++)
-		temp_priority[i] = DEF_PRIORITY;
-
 	for (priority = DEF_PRIORITY; priority >= 0; priority--) {
 		int end_zone = 0;	/* Inclusive.  0 = ZONE_DMA */
 		unsigned long lru_pages = 0;
@@ -2134,9 +2090,7 @@ loop_again:
 			if (zone->all_unreclaimable && priority != DEF_PRIORITY)
 				continue;
 
-			temp_priority[i] = priority;
 			sc.nr_scanned = 0;
-			note_zone_scanning_priority(zone, priority);
 
 			nid = pgdat->node_id;
 			zid = zone_idx(zone);
@@ -2209,16 +2163,6 @@ loop_again:
 			break;
 	}
 out:
-	/*
-	 * Note within each zone the priority level at which this zone was
-	 * brought into a happy state.  So that the next thread which scans this
-	 * zone will start out at that priority level.
-	 */
-	for (i = 0; i < pgdat->nr_zones; i++) {
-		struct zone *zone = pgdat->node_zones + i;
-
-		zone->prev_priority = temp_priority[i];
-	}
 	if (!all_zones_ok) {
 		cond_resched();
 
@@ -2637,7 +2581,6 @@ static int __zone_reclaim(struct zone *z
 		 */
 		priority = ZONE_RECLAIM_PRIORITY;
 		do {
-			note_zone_scanning_priority(zone, priority);
 			shrink_zone(priority, zone, &sc);
 			priority--;
 		} while (priority >= 0 && sc.nr_reclaimed < nr_pages);
diff -puN mm/vmstat.c~vmscan-kill-prev_priority-completely mm/vmstat.c
--- a/mm/vmstat.c~vmscan-kill-prev_priority-completely
+++ a/mm/vmstat.c
@@ -853,11 +853,9 @@ static void zoneinfo_show_print(struct s
 	}
 	seq_printf(m,
 		   "\n  all_unreclaimable: %u"
-		   "\n  prev_priority:     %i"
 		   "\n  start_pfn:         %lu"
 		   "\n  inactive_ratio:    %u",
 		   zone->all_unreclaimable,
-		   zone->prev_priority,
 		   zone->zone_start_pfn,
 		   zone->inactive_ratio);
 	seq_putc(m, '\n');
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

