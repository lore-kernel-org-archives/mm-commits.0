From: akpm@linux-foundation.org
Subject: [merged] mm-update-numa-counter-threshold-size.patch
 removed from -mm tree
Date: Mon, 11 Sep 2017 12:39:58 -0700
Message-ID: <20170911193958.XhluI2e7t%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49264 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751028AbdIKTj7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 11 Sep 2017 15:39:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aaron.lu@intel.com, andi.kleen@intel.com, brouer@redhat.com, cl@linux.com, dave.hansen@intel.com, hannes@cmpxchg.org, kemi.wang@intel.com, mgorman@techsingularity.net, mhocko@suse.com, mm-commits@vger.kernel.org, tim.c.chen@intel.com, ying.huang@intel.com


The patch titled
     Subject: mm: update NUMA counter threshold size
has been removed from the -mm tree.  Its filename was
     mm-update-numa-counter-threshold-size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kemi Wang <kemi.wang@intel.com>
Subject: mm: update NUMA counter threshold size

There is significant overhead in cache bouncing caused by zone counters
(NUMA associated counters) update in parallel in multi-threaded page
allocation (suggested by Dave Hansen).

This patch updates NUMA counter threshold to a fixed size of MAX_U16 - 2,
as a small threshold greatly increases the update frequency of the global
counter from local per cpu counter(suggested by Ying Huang).

The rationality is that these statistics counters don't affect the
kernel's decision, unlike other VM counters, so it's not a problem to use
a large threshold.

With this patchset, we see 31.3% drop of CPU cycles(537-->369) for per
single page allocation and reclaim on Jesper's page_bench03 benchmark.

Benchmark provided by Jesper D Brouer(increase loop times to 10000000):
https://github.com/netoptimizer/prototype-kernel/tree/master/kernel/mm/
bench

 Threshold   CPU cycles    Throughput(88 threads)
     32          799         241760478
     64          640         301628829
     125         537         358906028 <==> system by default (base)
     256         468         412397590
     512         428         450550704
     4096        399         482520943
     20000       394         489009617
     30000       395         488017817
     65533       369(-31.3%) 521661345(+45.3%) <==> with this patchset
     N/A         342(-36.3%) 562900157(+56.8%) <==> disable zone_statistics

Link: http://lkml.kernel.org/r/1503568801-21305-3-git-send-email-kemi.wang@intel.com
Signed-off-by: Kemi Wang <kemi.wang@intel.com>
Reported-by: Jesper Dangaard Brouer <brouer@redhat.com>
Suggested-by: Dave Hansen <dave.hansen@intel.com>
Suggested-by: Ying Huang <ying.huang@intel.com>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Aaron Lu <aaron.lu@intel.com>
Cc: Andi Kleen <andi.kleen@intel.com>
Cc: Christopher Lameter <cl@linux.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Tim Chen <tim.c.chen@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    3 +--
 mm/vmstat.c            |   28 ++++++++++------------------
 2 files changed, 11 insertions(+), 20 deletions(-)

diff -puN include/linux/mmzone.h~mm-update-numa-counter-threshold-size include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-update-numa-counter-threshold-size
+++ a/include/linux/mmzone.h
@@ -282,8 +282,7 @@ struct per_cpu_pageset {
 	struct per_cpu_pages pcp;
 #ifdef CONFIG_NUMA
 	s8 expire;
-	s8 numa_stat_threshold;
-	s8 vm_numa_stat_diff[NR_VM_NUMA_STAT_ITEMS];
+	u16 vm_numa_stat_diff[NR_VM_NUMA_STAT_ITEMS];
 #endif
 #ifdef CONFIG_SMP
 	s8 stat_threshold;
diff -puN mm/vmstat.c~mm-update-numa-counter-threshold-size mm/vmstat.c
--- a/mm/vmstat.c~mm-update-numa-counter-threshold-size
+++ a/mm/vmstat.c
@@ -30,6 +30,8 @@
 
 #include "internal.h"
 
+#define NUMA_STATS_THRESHOLD (U16_MAX - 2)
+
 #ifdef CONFIG_VM_EVENT_COUNTERS
 DEFINE_PER_CPU(struct vm_event_state, vm_event_states) = {{0}};
 EXPORT_PER_CPU_SYMBOL(vm_event_states);
@@ -194,10 +196,7 @@ void refresh_zone_stat_thresholds(void)
 
 			per_cpu_ptr(zone->pageset, cpu)->stat_threshold
 							= threshold;
-#ifdef CONFIG_NUMA
-			per_cpu_ptr(zone->pageset, cpu)->numa_stat_threshold
-							= threshold;
-#endif
+
 			/* Base nodestat threshold on the largest populated zone. */
 			pgdat_threshold = per_cpu_ptr(pgdat->per_cpu_nodestats, cpu)->stat_threshold;
 			per_cpu_ptr(pgdat->per_cpu_nodestats, cpu)->stat_threshold
@@ -231,14 +230,9 @@ void set_pgdat_percpu_threshold(pg_data_
 			continue;
 
 		threshold = (*calculate_pressure)(zone);
-		for_each_online_cpu(cpu) {
+		for_each_online_cpu(cpu)
 			per_cpu_ptr(zone->pageset, cpu)->stat_threshold
 							= threshold;
-#ifdef CONFIG_NUMA
-			per_cpu_ptr(zone->pageset, cpu)->numa_stat_threshold
-							= threshold;
-#endif
-		}
 	}
 }
 
@@ -874,16 +868,14 @@ void __inc_numa_state(struct zone *zone,
 				 enum numa_stat_item item)
 {
 	struct per_cpu_pageset __percpu *pcp = zone->pageset;
-	s8 __percpu *p = pcp->vm_numa_stat_diff + item;
-	s8 v, t;
+	u16 __percpu *p = pcp->vm_numa_stat_diff + item;
+	u16 v;
 
 	v = __this_cpu_inc_return(*p);
-	t = __this_cpu_read(pcp->numa_stat_threshold);
-	if (unlikely(v > t)) {
-		s8 overstep = t >> 1;
 
-		zone_numa_state_add(v + overstep, zone, item);
-		__this_cpu_write(*p, -overstep);
+	if (unlikely(v > NUMA_STATS_THRESHOLD)) {
+		zone_numa_state_add(v, zone, item);
+		__this_cpu_write(*p, 0);
 	}
 }
 
@@ -1798,7 +1790,7 @@ static bool need_update(int cpu)
 
 		BUILD_BUG_ON(sizeof(p->vm_stat_diff[0]) != 1);
 #ifdef CONFIG_NUMA
-		BUILD_BUG_ON(sizeof(p->vm_numa_stat_diff[0]) != 1);
+		BUILD_BUG_ON(sizeof(p->vm_numa_stat_diff[0]) != 2);
 #endif
 		/*
 		 * The fast way of checking if there are any vmstat diffs.
_

Patches currently in -mm which might be from kemi.wang@intel.com are


