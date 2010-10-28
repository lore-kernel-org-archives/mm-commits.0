From: akpm@linux-foundation.org
Subject: + mm-vmstat-use-a-single-setter-function-and-callback-for-adjusting-percpu-thresholds.patch added to -mm tree
Date: Thu, 28 Oct 2010 15:20:24 -0700
Message-ID: <201010282220.o9SMKOUH024578@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37507 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751725Ab0J1WUz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Oct 2010 18:20:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie, cl@linux.com, kamezawa.hiroyu@jp.fujitsu.com


The patch titled
     mm: vmstat: use a single setter function and callback for adjusting percpu thresholds
has been added to the -mm tree.  Its filename is
     mm-vmstat-use-a-single-setter-function-and-callback-for-adjusting-percpu-thresholds.patch

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
Subject: mm: vmstat: use a single setter function and callback for adjusting percpu thresholds
From: Mel Gorman <mel@csn.ul.ie>

reduce_pgdat_percpu_threshold() and restore_pgdat_percpu_threshold() exist
to adjust the per-cpu vmstat thresholds while kswapd is awake to avoid
errors due to counter drift.  The functions duplicate some code so this
patch replaces them with a single set_pgdat_percpu_threshold() that takes
a callback function to calculate the desired threshold as a parameter.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: Christoph Lameter <cl@linux.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmstat.h |   10 ++++++----
 mm/vmscan.c            |    6 ++++--
 mm/vmstat.c            |   32 ++++++--------------------------
 3 files changed, 16 insertions(+), 32 deletions(-)

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
@@ -2441,9 +2441,11 @@ static int kswapd(void *p)
 				 */
 				if (!sleeping_prematurely(pgdat, order, remaining)) {
 					trace_mm_vmscan_kswapd_sleep(pgdat->node_id);
-					restore_pgdat_percpu_threshold(pgdat);
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
@@ -185,7 +185,8 @@ static void refresh_zone_stat_thresholds
 	}
 }
 
-void reduce_pgdat_percpu_threshold(pg_data_t *pgdat)
+void set_pgdat_percpu_threshold(pg_data_t *pgdat,
+				int (*calculate_pressure)(struct zone *))
 {
 	struct zone *zone;
 	int cpu;
@@ -198,28 +199,7 @@ void reduce_pgdat_percpu_threshold(pg_da
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
