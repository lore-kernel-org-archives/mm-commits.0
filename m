From: akpm@linux-foundation.org
Subject: [merged] mm-kswapd-stop-high-order-balancing-when-any-suitable-zone-is-balanced.patch removed from -mm tree
Date: Fri, 14 Jan 2011 14:45:52 -0800
Message-ID: <201101142248.p0EMmgeg005226@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52925 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752525Ab1ANWtG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Jan 2011 17:49:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, dave@linux.vnet.ibm.com, emunson@mgebm.net, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, riel@redhat.com


The patch titled
     mm: kswapd: stop high-order balancing when any suitable zone is balanced
has been removed from the -mm tree.  Its filename was
     mm-kswapd-stop-high-order-balancing-when-any-suitable-zone-is-balanced.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: kswapd: stop high-order balancing when any suitable zone is balanced
From: Mel Gorman <mel@csn.ul.ie>

Simon Kirby reported the following problem

   We're seeing cases on a number of servers where cache never fully
   grows to use all available memory.  Sometimes we see servers with 4 GB
   of memory that never seem to have less than 1.5 GB free, even with a
   constantly-active VM.  In some cases, these servers also swap out while
   this happens, even though they are constantly reading the working set
   into memory.  We have been seeing this happening for a long time; I
   don't think it's anything recent, and it still happens on 2.6.36.

After some debugging work by Simon, Dave Hansen and others, the prevaling
theory became that kswapd is reclaiming order-3 pages requested by SLUB
too aggressive about it.

There are two apparent problems here.  On the target machine, there is a
small Normal zone in comparison to DMA32.  As kswapd tries to balance all
zones, it would continually try reclaiming for Normal even though DMA32
was balanced enough for callers.  The second problem is that
sleeping_prematurely() does not use the same logic as balance_pgdat() when
deciding whether to sleep or not.  This keeps kswapd artifically awake.

A number of tests were run and the figures from previous postings will
look very different for a few reasons.  One, the old figures were forcing
my network card to use GFP_ATOMIC in attempt to replicate Simon's problem.
 Second, I previous specified slub_min_order=3 again in an attempt to
reproduce Simon's problem.  In this posting, I'm depending on Simon to say
whether his problem is fixed or not and these figures are to show the
impact to the ordinary cases.  Finally, the "vmscan" figures are taken
from /proc/vmstat instead of the tracepoints.  There is less information
but recording is less disruptive.

The first test of relevance was postmark with a process running in the
background reading a large amount of anonymous memory in blocks.  The
objective was to vaguely simulate what was happening on Simon's machine
and it's memory intensive enough to have kswapd awake.

POSTMARK
                                            traceonly          kanyzone
Transactions per second:              156.00 ( 0.00%)   153.00 (-1.96%)
Data megabytes read per second:        21.51 ( 0.00%)    21.52 ( 0.05%)
Data megabytes written per second:     29.28 ( 0.00%)    29.11 (-0.58%)
Files created alone per second:       250.00 ( 0.00%)   416.00 (39.90%)
Files create/transact per second:      79.00 ( 0.00%)    76.00 (-3.95%)
Files deleted alone per second:       520.00 ( 0.00%)   420.00 (-23.81%)
Files delete/transact per second:      79.00 ( 0.00%)    76.00 (-3.95%)

MMTests Statistics: duration
User/Sys Time Running Test (seconds)         16.58      17.4
Total Elapsed Time (seconds)                218.48    222.47

VMstat Reclaim Statistics: vmscan
Direct reclaims                                  0          4
Direct reclaim pages scanned                     0        203
Direct reclaim pages reclaimed                   0        184
Kswapd pages scanned                        326631     322018
Kswapd pages reclaimed                      312632     309784
Kswapd low wmark quickly                         1          4
Kswapd high wmark quickly                      122        475
Kswapd skip congestion_wait                      1          0
Pages activated                             700040     705317
Pages deactivated                           212113     203922
Pages written                                 9875       6363

Total pages scanned                         326631    322221
Total pages reclaimed                       312632    309968
%age total pages scanned/reclaimed          95.71%    96.20%
%age total pages scanned/written             3.02%     1.97%

proc vmstat: Faults
Major Faults                                   300       254
Minor Faults                                645183    660284
Page ins                                    493588    486704
Page outs                                  4960088   4986704
Swap ins                                      1230       661
Swap outs                                     9869      6355

Performance is mildly affected because kswapd is no longer doing as much
work and the background memory consumer process is getting in the way. 
Note that kswapd scanned and reclaimed fewer pages as it's less aggressive
and overall fewer pages were scanned and reclaimed.  Swap in/out is
particularly reduced again reflecting kswapd throwing out fewer pages.

The slight performance impact is unfortunate here but it looks like a
direct result of kswapd being less aggressive.  As the bug report is about
too many pages being freed by kswapd, it may have to be accepted for now.

The second test is a streaming IO benchmark that was previously used by
Johannes to show regressions in page reclaim.

MICRO
					 traceonly  kanyzone
User/Sys Time Running Test (seconds)         29.29     28.87
Total Elapsed Time (seconds)                492.18    488.79

VMstat Reclaim Statistics: vmscan
Direct reclaims                               2128       1460
Direct reclaim pages scanned               2284822    1496067
Direct reclaim pages reclaimed              148919     110937
Kswapd pages scanned                      15450014   16202876
Kswapd pages reclaimed                     8503697    8537897
Kswapd low wmark quickly                      3100       3397
Kswapd high wmark quickly                     1860       7243
Kswapd skip congestion_wait                    708        801
Pages activated                               9635       9573
Pages deactivated                             1432       1271
Pages written                                  223       1130

Total pages scanned                       17734836  17698943
Total pages reclaimed                      8652616   8648834
%age total pages scanned/reclaimed          48.79%    48.87%
%age total pages scanned/written             0.00%     0.01%

proc vmstat: Faults
Major Faults                                   165       221
Minor Faults                               9655785   9656506
Page ins                                      3880      7228
Page outs                                 37692940  37480076
Swap ins                                         0        69
Swap outs                                       19        15

Again fewer pages are scanned and reclaimed as expected and this time the
test completed faster.  Note that kswapd is hitting its watermarks faster
(low and high wmark quickly) which I expect is due to kswapd reclaiming
fewer pages.

I also ran fs-mark, iozone and sysbench but there is nothing interesting
to report in the figures.  Performance is not significantly changed and
the reclaim statistics look reasonable.


Tgis patch:

When the allocator enters its slow path, kswapd is woken up to balance the
node.  It continues working until all zones within the node are balanced. 
For order-0 allocations, this makes perfect sense but for higher orders it
can have unintended side-effects.  If the zone sizes are imbalanced,
kswapd may reclaim heavily within a smaller zone discarding an excessive
number of pages.  The user-visible behaviour is that kswapd is awake and
reclaiming even though plenty of pages are free from a suitable zone.

This patch alters the "balance" logic for high-order reclaim allowing
kswapd to stop if any suitable zone becomes balanced to reduce the number
of pages it reclaims from other zones.  kswapd still tries to ensure that
order-0 watermarks for all zones are met before sleeping.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Eric B Munson <emunson@mgebm.net>
Cc: Simon Kirby <sim@hostway.ca>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Shaohua Li <shaohua.li@intel.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    3 +
 mm/page_alloc.c        |    8 ++--
 mm/vmscan.c            |   68 +++++++++++++++++++++++++++++++++------
 3 files changed, 66 insertions(+), 13 deletions(-)

diff -puN include/linux/mmzone.h~mm-kswapd-stop-high-order-balancing-when-any-suitable-zone-is-balanced include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-kswapd-stop-high-order-balancing-when-any-suitable-zone-is-balanced
+++ a/include/linux/mmzone.h
@@ -639,6 +639,7 @@ typedef struct pglist_data {
 	wait_queue_head_t kswapd_wait;
 	struct task_struct *kswapd;
 	int kswapd_max_order;
+	enum zone_type classzone_idx;
 } pg_data_t;
 
 #define node_present_pages(nid)	(NODE_DATA(nid)->node_present_pages)
@@ -654,7 +655,7 @@ typedef struct pglist_data {
 
 extern struct mutex zonelists_mutex;
 void build_all_zonelists(void *data);
-void wakeup_kswapd(struct zone *zone, int order);
+void wakeup_kswapd(struct zone *zone, int order, enum zone_type classzone_idx);
 bool zone_watermark_ok(struct zone *z, int order, unsigned long mark,
 		int classzone_idx, int alloc_flags);
 bool zone_watermark_ok_safe(struct zone *z, int order, unsigned long mark,
diff -puN mm/page_alloc.c~mm-kswapd-stop-high-order-balancing-when-any-suitable-zone-is-balanced mm/page_alloc.c
--- a/mm/page_alloc.c~mm-kswapd-stop-high-order-balancing-when-any-suitable-zone-is-balanced
+++ a/mm/page_alloc.c
@@ -1944,13 +1944,14 @@ __alloc_pages_high_priority(gfp_t gfp_ma
 
 static inline
 void wake_all_kswapd(unsigned int order, struct zonelist *zonelist,
-						enum zone_type high_zoneidx)
+						enum zone_type high_zoneidx,
+						enum zone_type classzone_idx)
 {
 	struct zoneref *z;
 	struct zone *zone;
 
 	for_each_zone_zonelist(zone, z, zonelist, high_zoneidx)
-		wakeup_kswapd(zone, order);
+		wakeup_kswapd(zone, order, classzone_idx);
 }
 
 static inline int
@@ -2028,7 +2029,8 @@ __alloc_pages_slowpath(gfp_t gfp_mask, u
 		goto nopage;
 
 restart:
-	wake_all_kswapd(order, zonelist, high_zoneidx);
+	wake_all_kswapd(order, zonelist, high_zoneidx,
+						zone_idx(preferred_zone));
 
 	/*
 	 * OK, we're below the kswapd watermark and have kicked background
diff -puN mm/vmscan.c~mm-kswapd-stop-high-order-balancing-when-any-suitable-zone-is-balanced mm/vmscan.c
--- a/mm/vmscan.c~mm-kswapd-stop-high-order-balancing-when-any-suitable-zone-is-balanced
+++ a/mm/vmscan.c
@@ -2246,11 +2246,14 @@ static int sleeping_prematurely(pg_data_
  * interoperates with the page allocator fallback scheme to ensure that aging
  * of pages is balanced across the zones.
  */
-static unsigned long balance_pgdat(pg_data_t *pgdat, int order)
+static unsigned long balance_pgdat(pg_data_t *pgdat, int order,
+							int classzone_idx)
 {
 	int all_zones_ok;
+	int any_zone_ok;
 	int priority;
 	int i;
+	int end_zone = 0;	/* Inclusive.  0 = ZONE_DMA */
 	unsigned long total_scanned;
 	struct reclaim_state *reclaim_state = current->reclaim_state;
 	struct scan_control sc = {
@@ -2273,7 +2276,6 @@ loop_again:
 	count_vm_event(PAGEOUTRUN);
 
 	for (priority = DEF_PRIORITY; priority >= 0; priority--) {
-		int end_zone = 0;	/* Inclusive.  0 = ZONE_DMA */
 		unsigned long lru_pages = 0;
 		int has_under_min_watermark_zone = 0;
 
@@ -2282,6 +2284,7 @@ loop_again:
 			disable_swap_token();
 
 		all_zones_ok = 1;
+		any_zone_ok = 0;
 
 		/*
 		 * Scan in the highmem->dma direction for the highest
@@ -2400,10 +2403,12 @@ loop_again:
 				 * spectulatively avoid congestion waits
 				 */
 				zone_clear_flag(zone, ZONE_CONGESTED);
+				if (i <= classzone_idx)
+					any_zone_ok = 1;
 			}
 
 		}
-		if (all_zones_ok)
+		if (all_zones_ok || (order && any_zone_ok))
 			break;		/* kswapd: all done */
 		/*
 		 * OK, kswapd is getting into trouble.  Take a nap, then take
@@ -2426,7 +2431,13 @@ loop_again:
 			break;
 	}
 out:
-	if (!all_zones_ok) {
+
+	/*
+	 * order-0: All zones must meet high watermark for a balanced node
+	 * high-order: Any zone below pgdats classzone_idx must meet the high
+	 *             watermark for a balanced node
+	 */
+	if (!(all_zones_ok || (order && any_zone_ok))) {
 		cond_resched();
 
 		try_to_freeze();
@@ -2451,6 +2462,36 @@ out:
 		goto loop_again;
 	}
 
+	/*
+	 * If kswapd was reclaiming at a higher order, it has the option of
+	 * sleeping without all zones being balanced. Before it does, it must
+	 * ensure that the watermarks for order-0 on *all* zones are met and
+	 * that the congestion flags are cleared. The congestion flag must
+	 * be cleared as kswapd is the only mechanism that clears the flag
+	 * and it is potentially going to sleep here.
+	 */
+	if (order) {
+		for (i = 0; i <= end_zone; i++) {
+			struct zone *zone = pgdat->node_zones + i;
+
+			if (!populated_zone(zone))
+				continue;
+
+			if (zone->all_unreclaimable && priority != DEF_PRIORITY)
+				continue;
+
+			/* Confirm the zone is balanced for order-0 */
+			if (!zone_watermark_ok(zone, 0,
+					high_wmark_pages(zone), 0, 0)) {
+				order = sc.order = 0;
+				goto loop_again;
+			}
+
+			/* If balanced, clear the congested flag */
+			zone_clear_flag(zone, ZONE_CONGESTED);
+		}
+	}
+
 	return sc.nr_reclaimed;
 }
 
@@ -2514,6 +2555,7 @@ static void kswapd_try_to_sleep(pg_data_
 static int kswapd(void *p)
 {
 	unsigned long order;
+	int classzone_idx;
 	pg_data_t *pgdat = (pg_data_t*)p;
 	struct task_struct *tsk = current;
 
@@ -2544,21 +2586,27 @@ static int kswapd(void *p)
 	set_freezable();
 
 	order = 0;
+	classzone_idx = MAX_NR_ZONES - 1;
 	for ( ; ; ) {
 		unsigned long new_order;
+		int new_classzone_idx;
 		int ret;
 
 		new_order = pgdat->kswapd_max_order;
+		new_classzone_idx = pgdat->classzone_idx;
 		pgdat->kswapd_max_order = 0;
-		if (order < new_order) {
+		pgdat->classzone_idx = MAX_NR_ZONES - 1;
+		if (order < new_order || classzone_idx > new_classzone_idx) {
 			/*
 			 * Don't sleep if someone wants a larger 'order'
-			 * allocation
+			 * allocation or has tigher zone constraints
 			 */
 			order = new_order;
+			classzone_idx = new_classzone_idx;
 		} else {
 			kswapd_try_to_sleep(pgdat, order);
 			order = pgdat->kswapd_max_order;
+			classzone_idx = pgdat->classzone_idx;
 		}
 
 		ret = try_to_freeze();
@@ -2571,7 +2619,7 @@ static int kswapd(void *p)
 		 */
 		if (!ret) {
 			trace_mm_vmscan_kswapd_wake(pgdat->node_id, order);
-			balance_pgdat(pgdat, order);
+			balance_pgdat(pgdat, order, classzone_idx);
 		}
 	}
 	return 0;
@@ -2580,7 +2628,7 @@ static int kswapd(void *p)
 /*
  * A zone is low on free memory, so wake its kswapd task to service it.
  */
-void wakeup_kswapd(struct zone *zone, int order)
+void wakeup_kswapd(struct zone *zone, int order, enum zone_type classzone_idx)
 {
 	pg_data_t *pgdat;
 
@@ -2590,8 +2638,10 @@ void wakeup_kswapd(struct zone *zone, in
 	if (!cpuset_zone_allowed_hardwall(zone, GFP_KERNEL))
 		return;
 	pgdat = zone->zone_pgdat;
-	if (pgdat->kswapd_max_order < order)
+	if (pgdat->kswapd_max_order < order) {
 		pgdat->kswapd_max_order = order;
+		pgdat->classzone_idx = min(pgdat->classzone_idx, classzone_idx);
+	}
 	if (!waitqueue_active(&pgdat->kswapd_wait))
 		return;
 	if (zone_watermark_ok_safe(zone, order, low_wmark_pages(zone), 0, 0))
_

Patches currently in -mm which might be from mel@csn.ul.ie are

origin.patch
linux-next.patch
writeback-io-less-balance_dirty_pages.patch
writeback-consolidate-variable-names-in-balance_dirty_pages.patch
writeback-per-task-rate-limit-on-balance_dirty_pages.patch
writeback-per-task-rate-limit-on-balance_dirty_pages-fix.patch
writeback-prevent-duplicate-balance_dirty_pages_ratelimited-calls.patch
writeback-account-per-bdi-accumulated-written-pages.patch
writeback-bdi-write-bandwidth-estimation.patch
writeback-bdi-write-bandwidth-estimation-fix.patch
writeback-show-bdi-write-bandwidth-in-debugfs.patch
writeback-quit-throttling-when-bdi-dirty-pages-dropped-low.patch
writeback-reduce-per-bdi-dirty-threshold-ramp-up-time.patch
writeback-make-reasonable-gap-between-the-dirty-background-thresholds.patch
writeback-scale-down-max-throttle-bandwidth-on-concurrent-dirtiers.patch
writeback-add-trace-event-for-balance_dirty_pages.patch
writeback-make-nr_to_write-a-per-file-limit.patch
writeback-make-nr_to_write-a-per-file-limit-fix.patch
thp-add-pagetranscompound.patch
add-debugging-aid-for-memory-initialisation-problems.patch

