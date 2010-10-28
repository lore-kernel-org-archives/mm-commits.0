From: akpm@linux-foundation.org
Subject: + mm-page-allocator-adjust-the-per-cpu-counter-threshold-when-memory-is-low.patch added to -mm tree
Date: Thu, 28 Oct 2010 15:20:21 -0700
Message-ID: <201010282220.o9SMKLNn024575@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45172 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751725Ab0J1WUx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Oct 2010 18:20:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie, cl@linux.com, shaohua.li@intel.com


The patch titled
     mm: page allocator: adjust the per-cpu counter threshold when memory is low
has been added to the -mm tree.  Its filename is
     mm-page-allocator-adjust-the-per-cpu-counter-threshold-when-memory-is-low.patch

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
Subject: mm: page allocator: adjust the per-cpu counter threshold when memory is low
From: Mel Gorman <mel@csn.ul.ie>

Commit aa45484 ("calculate a better estimate of NR_FREE_PAGES when memory
is low") noted that watermarks were based on the vmstat NR_FREE_PAGES.  To
avoid synchronization overhead, these counters are maintained on a per-cpu
basis and drained both periodically and when a threshold is above a
threshold.  On large CPU systems, the difference between the estimate and
real value of NR_FREE_PAGES can be very high.  The system can get into a
case where pages are allocated far below the min watermark potentially
causing livelock issues.  The commit solved the problem by taking a better
reading of NR_FREE_PAGES when memory was low.

Unfortately, as reported by Shaohua Li this accurate reading can consume a
large amount of CPU time on systems with many sockets due to cache line
bouncing.  This patch takes a different approach.  For large machines
where counter drift might be unsafe and while kswapd is awake, the per-cpu
thresholds for the target pgdat are reduced to limit the level of drift to
what should be a safe level.  This incurs a performance penalty in heavy
memory pressure by a factor that depends on the workload and the machine
but the machine should function correctly without accidentally exhausting
all memory on a node.  There is an additional cost when kswapd wakes and
sleeps but the event is not expected to be frequent - in Shaohua's test
case, there was one recorded sleep and wake event at least.

To ensure that kswapd wakes up, a safe version of zone_watermark_ok() is
introduced that takes a more accurate reading of NR_FREE_PAGES when called
from wakeup_kswapd, when deciding whether it is really safe to go back to
sleep in sleeping_prematurely() and when deciding if a zone is really
balanced or not in balance_pgdat().  We are still using an expensive
function but limiting how often it is called.

When the test case is reproduced, the time spent in the watermark
functions is reduced.  The following report is on the percentage of time
spent cumulatively spent in the functions zone_nr_free_pages(),
zone_watermark_ok(), __zone_watermark_ok(), zone_watermark_ok_safe(),
zone_page_state_snapshot(), zone_page_state().

vanilla                      11.6615%
disable-threshold            0.2584%

Reported-by: Shaohua Li <shaohua.li@intel.com>
Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |   10 +----
 include/linux/vmstat.h |    5 ++
 mm/mmzone.c            |   21 ------------
 mm/page_alloc.c        |   35 +++++++++++++++-----
 mm/vmscan.c            |   23 +++++++------
 mm/vmstat.c            |   68 ++++++++++++++++++++++++++++++++++++++-
 6 files changed, 115 insertions(+), 47 deletions(-)

diff -puN include/linux/mmzone.h~mm-page-allocator-adjust-the-per-cpu-counter-threshold-when-memory-is-low include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-page-allocator-adjust-the-per-cpu-counter-threshold-when-memory-is-low
+++ a/include/linux/mmzone.h
@@ -458,12 +458,6 @@ static inline int zone_is_oom_locked(con
 	return test_bit(ZONE_OOM_LOCKED, &zone->flags);
 }
 
-#ifdef CONFIG_SMP
-unsigned long zone_nr_free_pages(struct zone *zone);
-#else
-#define zone_nr_free_pages(zone) zone_page_state(zone, NR_FREE_PAGES)
-#endif /* CONFIG_SMP */
-
 /*
  * The "priority" of VM scanning is how much of the queues we will scan in one
  * go. A value of 12 for DEF_PRIORITY implies that we will scan 1/4096th of the
@@ -661,7 +655,9 @@ typedef struct pglist_data {
 extern struct mutex zonelists_mutex;
 void build_all_zonelists(void *data);
 void wakeup_kswapd(struct zone *zone, int order);
-int zone_watermark_ok(struct zone *z, int order, unsigned long mark,
+bool zone_watermark_ok(struct zone *z, int order, unsigned long mark,
+		int classzone_idx, int alloc_flags);
+bool zone_watermark_ok_safe(struct zone *z, int order, unsigned long mark,
 		int classzone_idx, int alloc_flags);
 enum memmap_context {
 	MEMMAP_EARLY,
diff -puN include/linux/vmstat.h~mm-page-allocator-adjust-the-per-cpu-counter-threshold-when-memory-is-low include/linux/vmstat.h
--- a/include/linux/vmstat.h~mm-page-allocator-adjust-the-per-cpu-counter-threshold-when-memory-is-low
+++ a/include/linux/vmstat.h
@@ -254,6 +254,8 @@ extern void dec_zone_state(struct zone *
 extern void __dec_zone_state(struct zone *, enum zone_stat_item);
 
 void refresh_cpu_vm_stats(int);
+void reduce_pgdat_percpu_threshold(pg_data_t *pgdat);
+void restore_pgdat_percpu_threshold(pg_data_t *pgdat);
 #else /* CONFIG_SMP */
 
 /*
@@ -298,6 +300,9 @@ static inline void __dec_zone_page_state
 #define dec_zone_page_state __dec_zone_page_state
 #define mod_zone_page_state __mod_zone_page_state
 
+static inline void reduce_pgdat_percpu_threshold(pg_data_t *pgdat) { }
+static inline void restore_pgdat_percpu_threshold(pg_data_t *pgdat) { }
+
 static inline void refresh_cpu_vm_stats(int cpu) { }
 #endif
 
diff -puN mm/mmzone.c~mm-page-allocator-adjust-the-per-cpu-counter-threshold-when-memory-is-low mm/mmzone.c
--- a/mm/mmzone.c~mm-page-allocator-adjust-the-per-cpu-counter-threshold-when-memory-is-low
+++ a/mm/mmzone.c
@@ -87,24 +87,3 @@ int memmap_valid_within(unsigned long pf
 	return 1;
 }
 #endif /* CONFIG_ARCH_HAS_HOLES_MEMORYMODEL */
-
-#ifdef CONFIG_SMP
-/* Called when a more accurate view of NR_FREE_PAGES is needed */
-unsigned long zone_nr_free_pages(struct zone *zone)
-{
-	unsigned long nr_free_pages = zone_page_state(zone, NR_FREE_PAGES);
-
-	/*
-	 * While kswapd is awake, it is considered the zone is under some
-	 * memory pressure. Under pressure, there is a risk that
-	 * per-cpu-counter-drift will allow the min watermark to be breached
-	 * potentially causing a live-lock. While kswapd is awake and
-	 * free pages are low, get a better estimate for free pages
-	 */
-	if (nr_free_pages < zone->percpu_drift_mark &&
-			!waitqueue_active(&zone->zone_pgdat->kswapd_wait))
-		return zone_page_state_snapshot(zone, NR_FREE_PAGES);
-
-	return nr_free_pages;
-}
-#endif /* CONFIG_SMP */
diff -puN mm/page_alloc.c~mm-page-allocator-adjust-the-per-cpu-counter-threshold-when-memory-is-low mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page-allocator-adjust-the-per-cpu-counter-threshold-when-memory-is-low
+++ a/mm/page_alloc.c
@@ -1455,24 +1455,24 @@ static inline int should_fail_alloc_page
 #endif /* CONFIG_FAIL_PAGE_ALLOC */
 
 /*
- * Return 1 if free pages are above 'mark'. This takes into account the order
+ * Return true if free pages are above 'mark'. This takes into account the order
  * of the allocation.
  */
-int zone_watermark_ok(struct zone *z, int order, unsigned long mark,
-		      int classzone_idx, int alloc_flags)
+static bool __zone_watermark_ok(struct zone *z, int order, unsigned long mark,
+		      int classzone_idx, int alloc_flags, long free_pages)
 {
 	/* free_pages my go negative - that's OK */
 	long min = mark;
-	long free_pages = zone_nr_free_pages(z) - (1 << order) + 1;
 	int o;
 
+	free_pages -= (1 << order) + 1;
 	if (alloc_flags & ALLOC_HIGH)
 		min -= min / 2;
 	if (alloc_flags & ALLOC_HARDER)
 		min -= min / 4;
 
 	if (free_pages <= min + z->lowmem_reserve[classzone_idx])
-		return 0;
+		return false;
 	for (o = 0; o < order; o++) {
 		/* At the next order, this order's pages become unavailable */
 		free_pages -= z->free_area[o].nr_free << o;
@@ -1481,9 +1481,28 @@ int zone_watermark_ok(struct zone *z, in
 		min >>= 1;
 
 		if (free_pages <= min)
-			return 0;
+			return false;
 	}
-	return 1;
+	return true;
+}
+
+bool zone_watermark_ok(struct zone *z, int order, unsigned long mark,
+		      int classzone_idx, int alloc_flags)
+{
+	return __zone_watermark_ok(z, order, mark, classzone_idx, alloc_flags,
+					zone_page_state(z, NR_FREE_PAGES));
+}
+
+bool zone_watermark_ok_safe(struct zone *z, int order, unsigned long mark,
+		      int classzone_idx, int alloc_flags)
+{
+	long free_pages = zone_page_state(z, NR_FREE_PAGES);
+
+	if (z->percpu_drift_mark && free_pages < z->percpu_drift_mark)
+		free_pages = zone_page_state_snapshot(z, NR_FREE_PAGES);
+
+	return __zone_watermark_ok(z, order, mark, classzone_idx, alloc_flags,
+								free_pages);
 }
 
 #ifdef CONFIG_NUMA
@@ -2437,7 +2456,7 @@ void show_free_areas(void)
 			" all_unreclaimable? %s"
 			"\n",
 			zone->name,
-			K(zone_nr_free_pages(zone)),
+			K(zone_page_state(zone, NR_FREE_PAGES)),
 			K(min_wmark_pages(zone)),
 			K(low_wmark_pages(zone)),
 			K(high_wmark_pages(zone)),
diff -puN mm/vmscan.c~mm-page-allocator-adjust-the-per-cpu-counter-threshold-when-memory-is-low mm/vmscan.c
--- a/mm/vmscan.c~mm-page-allocator-adjust-the-per-cpu-counter-threshold-when-memory-is-low
+++ a/mm/vmscan.c
@@ -2136,7 +2136,7 @@ static int sleeping_prematurely(pg_data_
 		if (zone->all_unreclaimable)
 			continue;
 
-		if (!zone_watermark_ok(zone, order, high_wmark_pages(zone),
+		if (!zone_watermark_ok_safe(zone, order, high_wmark_pages(zone),
 								0, 0))
 			return 1;
 	}
@@ -2223,7 +2223,7 @@ loop_again:
 				shrink_active_list(SWAP_CLUSTER_MAX, zone,
 							&sc, priority, 0);
 
-			if (!zone_watermark_ok(zone, order,
+			if (!zone_watermark_ok_safe(zone, order,
 					high_wmark_pages(zone), 0, 0)) {
 				end_zone = i;
 				break;
@@ -2269,7 +2269,7 @@ loop_again:
 			 * We put equal pressure on every zone, unless one
 			 * zone has way too many pages free already.
 			 */
-			if (!zone_watermark_ok(zone, order,
+			if (!zone_watermark_ok_safe(zone, order,
 					8*high_wmark_pages(zone), end_zone, 0))
 				shrink_zone(priority, zone, &sc);
 			reclaim_state->reclaimed_slab = 0;
@@ -2290,7 +2290,7 @@ loop_again:
 			    total_scanned > sc.nr_reclaimed + sc.nr_reclaimed / 2)
 				sc.may_writepage = 1;
 
-			if (!zone_watermark_ok(zone, order,
+			if (!zone_watermark_ok_safe(zone, order,
 					high_wmark_pages(zone), end_zone, 0)) {
 				all_zones_ok = 0;
 				/*
@@ -2298,7 +2298,7 @@ loop_again:
 				 * means that we have a GFP_ATOMIC allocation
 				 * failure risk. Hurry up!
 				 */
-				if (!zone_watermark_ok(zone, order,
+				if (!zone_watermark_ok_safe(zone, order,
 					    min_wmark_pages(zone), end_zone, 0))
 					has_under_min_watermark_zone = 1;
 			} else {
@@ -2441,7 +2441,9 @@ static int kswapd(void *p)
 				 */
 				if (!sleeping_prematurely(pgdat, order, remaining)) {
 					trace_mm_vmscan_kswapd_sleep(pgdat->node_id);
+					restore_pgdat_percpu_threshold(pgdat);
 					schedule();
+					reduce_pgdat_percpu_threshold(pgdat);
 				} else {
 					if (remaining)
 						count_vm_event(KSWAPD_LOW_WMARK_HIT_QUICKLY);
@@ -2480,16 +2482,17 @@ void wakeup_kswapd(struct zone *zone, in
 	if (!populated_zone(zone))
 		return;
 
-	pgdat = zone->zone_pgdat;
-	if (zone_watermark_ok(zone, order, low_wmark_pages(zone), 0, 0))
+	if (!cpuset_zone_allowed_hardwall(zone, GFP_KERNEL))
 		return;
+	pgdat = zone->zone_pgdat;
 	if (pgdat->kswapd_max_order < order)
 		pgdat->kswapd_max_order = order;
-	trace_mm_vmscan_wakeup_kswapd(pgdat->node_id, zone_idx(zone), order);
-	if (!cpuset_zone_allowed_hardwall(zone, GFP_KERNEL))
-		return;
 	if (!waitqueue_active(&pgdat->kswapd_wait))
 		return;
+	if (zone_watermark_ok_safe(zone, order, low_wmark_pages(zone), 0, 0))
+		return;
+
+	trace_mm_vmscan_wakeup_kswapd(pgdat->node_id, zone_idx(zone), order);
 	wake_up_interruptible(&pgdat->kswapd_wait);
 }
 
diff -puN mm/vmstat.c~mm-page-allocator-adjust-the-per-cpu-counter-threshold-when-memory-is-low mm/vmstat.c
--- a/mm/vmstat.c~mm-page-allocator-adjust-the-per-cpu-counter-threshold-when-memory-is-low
+++ a/mm/vmstat.c
@@ -83,6 +83,30 @@ EXPORT_SYMBOL(vm_stat);
 
 #ifdef CONFIG_SMP
 
+static int calculate_pressure_threshold(struct zone *zone)
+{
+	int threshold;
+	int watermark_distance;
+
+	/*
+	 * As vmstats are not up to date, there is drift between the estimated
+	 * and real values. For high thresholds and a high number of CPUs, it
+	 * is possible for the min watermark to be breached while the estimated
+	 * value looks fine. The pressure threshold is a reduced value such
+	 * that even the maximum amount of drift will not accidentally breach
+	 * the min watermark
+	 */
+	watermark_distance = low_wmark_pages(zone) - min_wmark_pages(zone);
+	threshold = max(1, (int)(watermark_distance / num_online_cpus()));
+
+	/*
+	 * Maximum threshold is 125
+	 */
+	threshold = min(125, threshold);
+
+	return threshold;
+}
+
 static int calculate_threshold(struct zone *zone)
 {
 	int threshold;
@@ -161,6 +185,48 @@ static void refresh_zone_stat_thresholds
 	}
 }
 
+void reduce_pgdat_percpu_threshold(pg_data_t *pgdat)
+{
+	struct zone *zone;
+	int cpu;
+	int threshold;
+	int i;
+
+	get_online_cpus();
+	for (i = 0; i < pgdat->nr_zones; i++) {
+		zone = &pgdat->node_zones[i];
+		if (!zone->percpu_drift_mark)
+			continue;
+
+		threshold = calculate_pressure_threshold(zone);
+		for_each_online_cpu(cpu)
+			per_cpu_ptr(zone->pageset, cpu)->stat_threshold
+							= threshold;
+	}
+	put_online_cpus();
+}
+
+void restore_pgdat_percpu_threshold(pg_data_t *pgdat)
+{
+	struct zone *zone;
+	int cpu;
+	int threshold;
+	int i;
+
+	get_online_cpus();
+	for (i = 0; i < pgdat->nr_zones; i++) {
+		zone = &pgdat->node_zones[i];
+		if (!zone->percpu_drift_mark)
+			continue;
+
+		threshold = calculate_threshold(zone);
+		for_each_online_cpu(cpu)
+			per_cpu_ptr(zone->pageset, cpu)->stat_threshold
+							= threshold;
+	}
+	put_online_cpus();
+}
+
 /*
  * For use when we know that interrupts are disabled.
  */
@@ -834,7 +900,7 @@ static void zoneinfo_show_print(struct s
 		   "\n        scanned  %lu"
 		   "\n        spanned  %lu"
 		   "\n        present  %lu",
-		   zone_nr_free_pages(zone),
+		   zone_page_state(zone, NR_FREE_PAGES),
 		   min_wmark_pages(zone),
 		   low_wmark_pages(zone),
 		   high_wmark_pages(zone),
_

Patches currently in -mm which might be from mel@csn.ul.ie are

origin.patch
linux-next.patch
mm-page-allocator-adjust-the-per-cpu-counter-threshold-when-memory-is-low.patch
mm-vmstat-use-a-single-setter-function-and-callback-for-adjusting-percpu-thresholds.patch
add-debugging-aid-for-memory-initialisation-problems.patch

