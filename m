From: akpm@linux-foundation.org
Subject: [merged] mm-vmstat-use-a-single-setter-function-and-callback-for-adjusting-percpu-thresholds.patch removed from -mm tree
Date: Fri, 14 Jan 2011 14:44:23 -0800
Message-ID: <201101142247.p0EMlDQm004974@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52263 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752525Ab1ANWro (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Jan 2011 17:47:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, cl@linux.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     mm: vmstat: use a single setter function and callback for adjusting percpu thresholds
has been removed from the -mm tree.  Its filename was
     mm-vmstat-use-a-single-setter-function-and-callback-for-adjusting-percpu-thresholds.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: vmstat: use a single setter function and callback for adjusting percpu thresholds
From: Mel Gorman <mel@csn.ul.ie>

reduce_pgdat_percpu_threshold() and restore_pgdat_percpu_threshold() exist
to adjust the per-cpu vmstat thresholds while kswapd is awake to avoid
errors due to counter drift.  The functions duplicate some code so this
patch replaces them with a single set_pgdat_percpu_threshold() that takes
a callback function to calculate the desired threshold as a parameter.

[akpm@linux-foundation.org: readability tweak]
[kosaki.motohiro@jp.fujitsu.com: set_pgdat_percpu_threshold(): don't use for_each_online_cpu]
Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: Christoph Lameter <cl@linux.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmstat.h |   10 ++++++----
 mm/vmscan.c            |   19 +++++++++++++++++--
 mm/vmstat.c            |   36 +++++++-----------------------------
 3 files changed, 30 insertions(+), 35 deletions(-)

diff -puN include/linux/vmstat.h~mm-vmstat-use-a-single-setter-function-and-callback-for-adjusting-percpu-thresholds include/linux/vmstat.h
--- a/include/linux/vmstat.h~mm-vmstat-use-a-single-setter-function-and-callback-for-adjusting-percpu-thresholds
+++ a/include/linux/vmstat.h
@@ -254,8 +254,11 @@ extern void dec_zone_state(struct zone *
 extern void __dec_zone_state(struct zone *, enum zone_stat_item);
 
 void refresh_cpu_vm_stats(int);
-void reduce_pgdat_percpu_threshold(pg_data_t *pgdat);
-void restore_pgdat_percpu_threshold(pg_data_t *pgdat);
+
+int calculate_pressure_threshold(struct zone *zone);
+int calculate_normal_threshold(struct zone *zone);
+void set_pgdat_percpu_threshold(pg_data_t *pgdat,
+				int (*calculate_pressure)(struct zone *));
 #else /* CONFIG_SMP */
 
 /*
@@ -300,8 +303,7 @@ static inline void __dec_zone_page_state
 #define dec_zone_page_state __dec_zone_page_state
 #define mod_zone_page_state __mod_zone_page_state
 
-static inline void reduce_pgdat_percpu_threshold(pg_data_t *pgdat) { }
-static inline void restore_pgdat_percpu_threshold(pg_data_t *pgdat) { }
+#define set_pgdat_percpu_threshold(pgdat, callback) { }
 
 static inline void refresh_cpu_vm_stats(int cpu) { }
 #endif
diff -puN mm/vmscan.c~mm-vmstat-use-a-single-setter-function-and-callback-for-adjusting-percpu-thresholds mm/vmscan.c
--- a/mm/vmscan.c~mm-vmstat-use-a-single-setter-function-and-callback-for-adjusting-percpu-thresholds
+++ a/mm/vmscan.c
@@ -2448,9 +2448,24 @@ static int kswapd(void *p)
 				 */
 				if (!sleeping_prematurely(pgdat, order, remaining)) {
 					trace_mm_vmscan_kswapd_sleep(pgdat->node_id);
-					restore_pgdat_percpu_threshold(pgdat);
+
+					/*
+					 * vmstat counters are not perfectly
+					 * accurate and the estimated value
+					 * for counters such as NR_FREE_PAGES
+					 * can deviate from the true value by
+					 * nr_online_cpus * threshold. To
+					 * avoid the zone watermarks being
+					 * breached while under pressure, we
+					 * reduce the per-cpu vmstat threshold
+					 * while kswapd is awake and restore
+					 * them before going back to sleep.
+					 */
+					set_pgdat_percpu_threshold(pgdat,
+						calculate_normal_threshold);
 					schedule();
-					reduce_pgdat_percpu_threshold(pgdat);
+					set_pgdat_percpu_threshold(pgdat,
+						calculate_pressure_threshold);
 				} else {
 					if (remaining)
 						count_vm_event(KSWAPD_LOW_WMARK_HIT_QUICKLY);
diff -puN mm/vmstat.c~mm-vmstat-use-a-single-setter-function-and-callback-for-adjusting-percpu-thresholds mm/vmstat.c
--- a/mm/vmstat.c~mm-vmstat-use-a-single-setter-function-and-callback-for-adjusting-percpu-thresholds
+++ a/mm/vmstat.c
@@ -83,7 +83,7 @@ EXPORT_SYMBOL(vm_stat);
 
 #ifdef CONFIG_SMP
 
-static int calculate_pressure_threshold(struct zone *zone)
+int calculate_pressure_threshold(struct zone *zone)
 {
 	int threshold;
 	int watermark_distance;
@@ -107,7 +107,7 @@ static int calculate_pressure_threshold(
 	return threshold;
 }
 
-static int calculate_threshold(struct zone *zone)
+int calculate_normal_threshold(struct zone *zone)
 {
 	int threshold;
 	int mem;	/* memory in 128 MB units */
@@ -166,7 +166,7 @@ static void refresh_zone_stat_thresholds
 	for_each_populated_zone(zone) {
 		unsigned long max_drift, tolerate_drift;
 
-		threshold = calculate_threshold(zone);
+		threshold = calculate_normal_threshold(zone);
 
 		for_each_online_cpu(cpu)
 			per_cpu_ptr(zone->pageset, cpu)->stat_threshold
@@ -185,46 +185,24 @@ static void refresh_zone_stat_thresholds
 	}
 }
 
-void reduce_pgdat_percpu_threshold(pg_data_t *pgdat)
+void set_pgdat_percpu_threshold(pg_data_t *pgdat,
+				int (*calculate_pressure)(struct zone *))
 {
 	struct zone *zone;
 	int cpu;
 	int threshold;
 	int i;
 
-	get_online_cpus();
 	for (i = 0; i < pgdat->nr_zones; i++) {
 		zone = &pgdat->node_zones[i];
 		if (!zone->percpu_drift_mark)
 			continue;
 
-		threshold = calculate_pressure_threshold(zone);
-		for_each_online_cpu(cpu)
-			per_cpu_ptr(zone->pageset, cpu)->stat_threshold
-							= threshold;
-	}
-	put_online_cpus();
-}
-
-void restore_pgdat_percpu_threshold(pg_data_t *pgdat)
-{
-	struct zone *zone;
-	int cpu;
-	int threshold;
-	int i;
-
-	get_online_cpus();
-	for (i = 0; i < pgdat->nr_zones; i++) {
-		zone = &pgdat->node_zones[i];
-		if (!zone->percpu_drift_mark)
-			continue;
-
-		threshold = calculate_threshold(zone);
-		for_each_online_cpu(cpu)
+		threshold = (*calculate_pressure)(zone);
+		for_each_possible_cpu(cpu)
 			per_cpu_ptr(zone->pageset, cpu)->stat_threshold
 							= threshold;
 	}
-	put_online_cpus();
 }
 
 /*
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

