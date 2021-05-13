Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 158B0C433ED
	for <mm-commits@archiver.kernel.org>; Thu, 13 May 2021 00:29:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D32CC613DF
	for <mm-commits@archiver.kernel.org>; Thu, 13 May 2021 00:29:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232637AbhEMAas (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 May 2021 20:30:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:41862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235378AbhEMAai (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 May 2021 20:30:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1B2A4613DF;
        Thu, 13 May 2021 00:29:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620865768;
        bh=0zMx36NlhK+Xfd5CdPWwQ+4H9eSpJ9tmDCb6DdTwhPo=;
        h=Date:From:To:Subject:From;
        b=MgwwFtAlx+XckOHyVEWaeReXRnP2M9vBldPgbQgxMdVvx0p5Z8vHb/4qg4juchkfm
         JSp774g+8lhUbRwvAK6w7wiGo9D5JGbW383PGThe1oh9xraa4AmVqi/jr1AmdhEPLy
         ALP7zvK3BfWYWs85jYhnSdYh8C8Hj19D9ShFNYec=
Date:   Wed, 12 May 2021 17:29:27 -0700
From:   akpm@linux-foundation.org
To:     bigeasy@linutronix.de, brouer@redhat.com, chuck.lever@oracle.com,
        mgorman@techsingularity.net, mhocko@kernel.org, mingo@kernel.org,
        mm-commits@vger.kernel.org, peterz@infradead.org,
        tglx@linutronix.de, vbabka@suse.cz
Subject:  +
 mm-vmstat-convert-numa-statistics-to-basic-numa-counters.patch added to -mm
 tree
Message-ID: <20210513002927.CPtJesS6J%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmstat: convert NUMA statistics to basic NUMA counters
has been added to the -mm tree.  Its filename is
     mm-vmstat-convert-numa-statistics-to-basic-numa-counters.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-vmstat-convert-numa-statistics-to-basic-numa-counters.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-vmstat-convert-numa-statistics-to-basic-numa-counters.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm/vmstat: convert NUMA statistics to basic NUMA counters

NUMA statistics are maintained on the zone level for hits, misses, foreign
etc but nothing relies on them being perfectly accurate for functional
correctness.  The counters are used by userspace to get a general overview
of a workloads NUMA behaviour but the page allocator incurs a high cost to
maintain perfect accuracy similar to what is required for a vmstat like
NR_FREE_PAGES.  There even is a sysctl vm.numa_stat to allow userspace to
turn off the collection of NUMA statistics like NUMA_HIT.

This patch converts NUMA_HIT and friends to be NUMA events with similar
accuracy to VM events.  There is a possibility that slight errors will be
introduced but the overall trend as seen by userspace will be similar. 
The counters are no longer updated from vmstat_refresh context as it is
unnecessary overhead for counters that may never be read by userspace. 
Note that counters could be maintained at the node level to save space but
it would have a user-visible impact due to /proc/zoneinfo.

[lkp@intel.com: Fix misplaced closing brace for !CONFIG_NUMA]
Link: https://lkml.kernel.org/r/20210512095458.30632-4-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Chuck Lever <chuck.lever@oracle.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/node.c    |   18 ++-
 include/linux/mmzone.h |   13 +-
 include/linux/vmstat.h |   43 ++++-----
 mm/mempolicy.c         |    2 
 mm/page_alloc.c        |   12 +-
 mm/vmstat.c            |  177 +++++++++++++++------------------------
 6 files changed, 116 insertions(+), 149 deletions(-)

--- a/drivers/base/node.c~mm-vmstat-convert-numa-statistics-to-basic-numa-counters
+++ a/drivers/base/node.c
@@ -482,6 +482,7 @@ static DEVICE_ATTR(meminfo, 0444, node_r
 static ssize_t node_read_numastat(struct device *dev,
 				  struct device_attribute *attr, char *buf)
 {
+	fold_vm_numa_events();
 	return sysfs_emit(buf,
 			  "numa_hit %lu\n"
 			  "numa_miss %lu\n"
@@ -489,12 +490,12 @@ static ssize_t node_read_numastat(struct
 			  "interleave_hit %lu\n"
 			  "local_node %lu\n"
 			  "other_node %lu\n",
-			  sum_zone_numa_state(dev->id, NUMA_HIT),
-			  sum_zone_numa_state(dev->id, NUMA_MISS),
-			  sum_zone_numa_state(dev->id, NUMA_FOREIGN),
-			  sum_zone_numa_state(dev->id, NUMA_INTERLEAVE_HIT),
-			  sum_zone_numa_state(dev->id, NUMA_LOCAL),
-			  sum_zone_numa_state(dev->id, NUMA_OTHER));
+			  sum_zone_numa_event_state(dev->id, NUMA_HIT),
+			  sum_zone_numa_event_state(dev->id, NUMA_MISS),
+			  sum_zone_numa_event_state(dev->id, NUMA_FOREIGN),
+			  sum_zone_numa_event_state(dev->id, NUMA_INTERLEAVE_HIT),
+			  sum_zone_numa_event_state(dev->id, NUMA_LOCAL),
+			  sum_zone_numa_event_state(dev->id, NUMA_OTHER));
 }
 static DEVICE_ATTR(numastat, 0444, node_read_numastat, NULL);
 
@@ -512,10 +513,11 @@ static ssize_t node_read_vmstat(struct d
 				     sum_zone_node_page_state(nid, i));
 
 #ifdef CONFIG_NUMA
-	for (i = 0; i < NR_VM_NUMA_STAT_ITEMS; i++)
+	fold_vm_numa_events();
+	for (i = 0; i < NR_VM_NUMA_EVENT_ITEMS; i++)
 		len += sysfs_emit_at(buf, len, "%s %lu\n",
 				     numa_stat_name(i),
-				     sum_zone_numa_state(nid, i));
+				     sum_zone_numa_event_state(nid, i));
 
 #endif
 	for (i = 0; i < NR_VM_NODE_STAT_ITEMS; i++) {
--- a/include/linux/mmzone.h~mm-vmstat-convert-numa-statistics-to-basic-numa-counters
+++ a/include/linux/mmzone.h
@@ -135,10 +135,10 @@ enum numa_stat_item {
 	NUMA_INTERLEAVE_HIT,	/* interleaver preferred this zone */
 	NUMA_LOCAL,		/* allocation from local node */
 	NUMA_OTHER,		/* allocation from other node */
-	NR_VM_NUMA_STAT_ITEMS
+	NR_VM_NUMA_EVENT_ITEMS
 };
 #else
-#define NR_VM_NUMA_STAT_ITEMS 0
+#define NR_VM_NUMA_EVENT_ITEMS 0
 #endif
 
 enum zone_stat_item {
@@ -357,7 +357,12 @@ struct per_cpu_zonestat {
 	s8 stat_threshold;
 #endif
 #ifdef CONFIG_NUMA
-	u16 vm_numa_stat_diff[NR_VM_NUMA_STAT_ITEMS];
+	/*
+	 * Low priority inaccurate counters that are only folded
+	 * on demand. Use a large type to avoid the overhead of
+	 * folding during refresh_cpu_vm_stats.
+	 */
+	unsigned long vm_numa_event[NR_VM_NUMA_EVENT_ITEMS];
 #endif
 };
 
@@ -623,7 +628,7 @@ struct zone {
 	ZONE_PADDING(_pad3_)
 	/* Zone statistics */
 	atomic_long_t		vm_stat[NR_VM_ZONE_STAT_ITEMS];
-	atomic_long_t		vm_numa_stat[NR_VM_NUMA_STAT_ITEMS];
+	atomic_long_t		vm_numa_event[NR_VM_NUMA_EVENT_ITEMS];
 } ____cacheline_internodealigned_in_smp;
 
 enum pgdat_flags {
--- a/include/linux/vmstat.h~mm-vmstat-convert-numa-statistics-to-basic-numa-counters
+++ a/include/linux/vmstat.h
@@ -138,34 +138,27 @@ static inline void vm_events_fold_cpu(in
  * Zone and node-based page accounting with per cpu differentials.
  */
 extern atomic_long_t vm_zone_stat[NR_VM_ZONE_STAT_ITEMS];
-extern atomic_long_t vm_numa_stat[NR_VM_NUMA_STAT_ITEMS];
 extern atomic_long_t vm_node_stat[NR_VM_NODE_STAT_ITEMS];
+extern atomic_long_t vm_numa_event[NR_VM_NUMA_EVENT_ITEMS];
 
 #ifdef CONFIG_NUMA
-static inline void zone_numa_state_add(long x, struct zone *zone,
-				 enum numa_stat_item item)
+static inline void zone_numa_event_add(long x, struct zone *zone,
+				enum numa_stat_item item)
 {
-	atomic_long_add(x, &zone->vm_numa_stat[item]);
-	atomic_long_add(x, &vm_numa_stat[item]);
+	atomic_long_add(x, &zone->vm_numa_event[item]);
+	atomic_long_add(x, &vm_numa_event[item]);
 }
 
-static inline unsigned long global_numa_state(enum numa_stat_item item)
+static inline unsigned long zone_numa_event_state(struct zone *zone,
+					enum numa_stat_item item)
 {
-	long x = atomic_long_read(&vm_numa_stat[item]);
-
-	return x;
+	return atomic_long_read(&zone->vm_numa_event[item]);
 }
 
-static inline unsigned long zone_numa_state_snapshot(struct zone *zone,
-					enum numa_stat_item item)
+static inline unsigned long
+global_numa_event_state(enum numa_stat_item item)
 {
-	long x = atomic_long_read(&zone->vm_numa_stat[item]);
-	int cpu;
-
-	for_each_online_cpu(cpu)
-		x += per_cpu_ptr(zone->per_cpu_zonestats, cpu)->vm_numa_stat_diff[item];
-
-	return x;
+	return atomic_long_read(&vm_numa_event[item]);
 }
 #endif /* CONFIG_NUMA */
 
@@ -245,18 +238,22 @@ static inline unsigned long zone_page_st
 }
 
 #ifdef CONFIG_NUMA
-extern void __inc_numa_state(struct zone *zone, enum numa_stat_item item);
+extern void __count_numa_event(struct zone *zone, enum numa_stat_item item);
 extern unsigned long sum_zone_node_page_state(int node,
 					      enum zone_stat_item item);
-extern unsigned long sum_zone_numa_state(int node, enum numa_stat_item item);
+extern unsigned long sum_zone_numa_event_state(int node, enum numa_stat_item item);
 extern unsigned long node_page_state(struct pglist_data *pgdat,
 						enum node_stat_item item);
 extern unsigned long node_page_state_pages(struct pglist_data *pgdat,
 					   enum node_stat_item item);
+extern void fold_vm_numa_events(void);
 #else
 #define sum_zone_node_page_state(node, item) global_zone_page_state(item)
 #define node_page_state(node, item) global_node_page_state(item)
 #define node_page_state_pages(node, item) global_node_page_state_pages(item)
+static inline void fold_vm_numa_events(void)
+{
+}
 #endif /* CONFIG_NUMA */
 
 #ifdef CONFIG_SMP
@@ -428,7 +425,7 @@ static inline const char *numa_stat_name
 static inline const char *node_stat_name(enum node_stat_item item)
 {
 	return vmstat_text[NR_VM_ZONE_STAT_ITEMS +
-			   NR_VM_NUMA_STAT_ITEMS +
+			   NR_VM_NUMA_EVENT_ITEMS +
 			   item];
 }
 
@@ -440,7 +437,7 @@ static inline const char *lru_list_name(
 static inline const char *writeback_stat_name(enum writeback_stat_item item)
 {
 	return vmstat_text[NR_VM_ZONE_STAT_ITEMS +
-			   NR_VM_NUMA_STAT_ITEMS +
+			   NR_VM_NUMA_EVENT_ITEMS +
 			   NR_VM_NODE_STAT_ITEMS +
 			   item];
 }
@@ -449,7 +446,7 @@ static inline const char *writeback_stat
 static inline const char *vm_event_name(enum vm_event_item item)
 {
 	return vmstat_text[NR_VM_ZONE_STAT_ITEMS +
-			   NR_VM_NUMA_STAT_ITEMS +
+			   NR_VM_NUMA_EVENT_ITEMS +
 			   NR_VM_NODE_STAT_ITEMS +
 			   NR_VM_WRITEBACK_STAT_ITEMS +
 			   item];
--- a/mm/mempolicy.c~mm-vmstat-convert-numa-statistics-to-basic-numa-counters
+++ a/mm/mempolicy.c
@@ -2150,7 +2150,7 @@ static struct page *alloc_page_interleav
 		return page;
 	if (page && page_to_nid(page) == nid) {
 		preempt_disable();
-		__inc_numa_state(page_zone(page), NUMA_INTERLEAVE_HIT);
+		__count_numa_event(page_zone(page), NUMA_INTERLEAVE_HIT);
 		preempt_enable();
 	}
 	return page;
--- a/mm/page_alloc.c~mm-vmstat-convert-numa-statistics-to-basic-numa-counters
+++ a/mm/page_alloc.c
@@ -3469,12 +3469,12 @@ static inline void zone_statistics(struc
 		local_stat = NUMA_OTHER;
 
 	if (zone_to_nid(z) == zone_to_nid(preferred_zone))
-		__inc_numa_state(z, NUMA_HIT);
+		__count_numa_event(z, NUMA_HIT);
 	else {
-		__inc_numa_state(z, NUMA_MISS);
-		__inc_numa_state(preferred_zone, NUMA_FOREIGN);
+		__count_numa_event(z, NUMA_MISS);
+		__count_numa_event(preferred_zone, NUMA_FOREIGN);
 	}
-	__inc_numa_state(z, local_stat);
+	__count_numa_event(z, local_stat);
 #endif
 }
 
@@ -6746,8 +6746,8 @@ void __init setup_per_cpu_pageset(void)
 	 */
 	for_each_possible_cpu(cpu) {
 		struct per_cpu_zonestat *pzstats = &per_cpu(boot_zonestats, cpu);
-		memset(pzstats->vm_numa_stat_diff, 0,
-		       sizeof(pzstats->vm_numa_stat_diff));
+		memset(pzstats->vm_numa_event, 0,
+		       sizeof(pzstats->vm_numa_event));
 	}
 #endif
 
--- a/mm/vmstat.c~mm-vmstat-convert-numa-statistics-to-basic-numa-counters
+++ a/mm/vmstat.c
@@ -31,8 +31,6 @@
 
 #include "internal.h"
 
-#define NUMA_STATS_THRESHOLD (U16_MAX - 2)
-
 #ifdef CONFIG_NUMA
 int sysctl_vm_numa_stat = ENABLE_NUMA_STAT;
 
@@ -41,11 +39,12 @@ static void zero_zone_numa_counters(stru
 {
 	int item, cpu;
 
-	for (item = 0; item < NR_VM_NUMA_STAT_ITEMS; item++) {
-		atomic_long_set(&zone->vm_numa_stat[item], 0);
-		for_each_online_cpu(cpu)
-			per_cpu_ptr(zone->per_cpu_zonestats, cpu)->vm_numa_stat_diff[item]
+	for (item = 0; item < NR_VM_NUMA_EVENT_ITEMS; item++) {
+		atomic_long_set(&zone->vm_numa_event[item], 0);
+		for_each_online_cpu(cpu) {
+			per_cpu_ptr(zone->per_cpu_zonestats, cpu)->vm_numa_event[item]
 						= 0;
+		}
 	}
 }
 
@@ -63,8 +62,8 @@ static void zero_global_numa_counters(vo
 {
 	int item;
 
-	for (item = 0; item < NR_VM_NUMA_STAT_ITEMS; item++)
-		atomic_long_set(&vm_numa_stat[item], 0);
+	for (item = 0; item < NR_VM_NUMA_EVENT_ITEMS; item++)
+		atomic_long_set(&vm_numa_event[item], 0);
 }
 
 static void invalid_numa_statistics(void)
@@ -161,10 +160,9 @@ void vm_events_fold_cpu(int cpu)
  * vm_stat contains the global counters
  */
 atomic_long_t vm_zone_stat[NR_VM_ZONE_STAT_ITEMS] __cacheline_aligned_in_smp;
-atomic_long_t vm_numa_stat[NR_VM_NUMA_STAT_ITEMS] __cacheline_aligned_in_smp;
 atomic_long_t vm_node_stat[NR_VM_NODE_STAT_ITEMS] __cacheline_aligned_in_smp;
+atomic_long_t vm_numa_event[NR_VM_NUMA_EVENT_ITEMS] __cacheline_aligned_in_smp;
 EXPORT_SYMBOL(vm_zone_stat);
-EXPORT_SYMBOL(vm_numa_stat);
 EXPORT_SYMBOL(vm_node_stat);
 
 #ifdef CONFIG_SMP
@@ -706,8 +704,7 @@ EXPORT_SYMBOL(dec_node_page_state);
  * Fold a differential into the global counters.
  * Returns the number of counters updated.
  */
-#ifdef CONFIG_NUMA
-static int fold_diff(int *zone_diff, int *numa_diff, int *node_diff)
+static int fold_diff(int *zone_diff, int *node_diff)
 {
 	int i;
 	int changes = 0;
@@ -718,12 +715,6 @@ static int fold_diff(int *zone_diff, int
 			changes++;
 	}
 
-	for (i = 0; i < NR_VM_NUMA_STAT_ITEMS; i++)
-		if (numa_diff[i]) {
-			atomic_long_add(numa_diff[i], &vm_numa_stat[i]);
-			changes++;
-	}
-
 	for (i = 0; i < NR_VM_NODE_STAT_ITEMS; i++)
 		if (node_diff[i]) {
 			atomic_long_add(node_diff[i], &vm_node_stat[i]);
@@ -731,26 +722,34 @@ static int fold_diff(int *zone_diff, int
 	}
 	return changes;
 }
-#else
-static int fold_diff(int *zone_diff, int *node_diff)
+
+#ifdef CONFIG_NUMA
+static void fold_vm_zone_numa_events(struct zone *zone)
 {
-	int i;
-	int changes = 0;
+	unsigned long zone_numa_events[NR_VM_NUMA_EVENT_ITEMS] = { 0, };
+	int cpu;
+	enum numa_stat_item item;
 
-	for (i = 0; i < NR_VM_ZONE_STAT_ITEMS; i++)
-		if (zone_diff[i]) {
-			atomic_long_add(zone_diff[i], &vm_zone_stat[i]);
-			changes++;
-	}
+	for_each_online_cpu(cpu) {
+		struct per_cpu_zonestat *pzstats;
 
-	for (i = 0; i < NR_VM_NODE_STAT_ITEMS; i++)
-		if (node_diff[i]) {
-			atomic_long_add(node_diff[i], &vm_node_stat[i]);
-			changes++;
+		pzstats = per_cpu_ptr(zone->per_cpu_zonestats, cpu);
+		for (item = 0; item < NR_VM_NUMA_EVENT_ITEMS; item++)
+			zone_numa_events[item] += xchg(&pzstats->vm_numa_event[item], 0);
 	}
-	return changes;
+
+	for (item = 0; item < NR_VM_NUMA_EVENT_ITEMS; item++)
+		zone_numa_event_add(zone_numa_events[item], zone, item);
 }
-#endif /* CONFIG_NUMA */
+
+void fold_vm_numa_events(void)
+{
+	struct zone *zone;
+
+	for_each_populated_zone(zone)
+		fold_vm_zone_numa_events(zone);
+}
+#endif
 
 /*
  * Update the zone counters for the current cpu.
@@ -774,15 +773,14 @@ static int refresh_cpu_vm_stats(bool do_
 	struct zone *zone;
 	int i;
 	int global_zone_diff[NR_VM_ZONE_STAT_ITEMS] = { 0, };
-#ifdef CONFIG_NUMA
-	int global_numa_diff[NR_VM_NUMA_STAT_ITEMS] = { 0, };
-#endif
 	int global_node_diff[NR_VM_NODE_STAT_ITEMS] = { 0, };
 	int changes = 0;
 
 	for_each_populated_zone(zone) {
 		struct per_cpu_zonestat __percpu *pzstats = zone->per_cpu_zonestats;
+#ifdef CONFIG_NUMA
 		struct per_cpu_pages __percpu *pcp = zone->per_cpu_pageset;
+#endif
 
 		for (i = 0; i < NR_VM_ZONE_STAT_ITEMS; i++) {
 			int v;
@@ -799,17 +797,6 @@ static int refresh_cpu_vm_stats(bool do_
 			}
 		}
 #ifdef CONFIG_NUMA
-		for (i = 0; i < NR_VM_NUMA_STAT_ITEMS; i++) {
-			int v;
-
-			v = this_cpu_xchg(pzstats->vm_numa_stat_diff[i], 0);
-			if (v) {
-
-				atomic_long_add(v, &zone->vm_numa_stat[i]);
-				global_numa_diff[i] += v;
-				__this_cpu_write(pcp->expire, 3);
-			}
-		}
 
 		if (do_pagesets) {
 			cond_resched();
@@ -857,12 +844,7 @@ static int refresh_cpu_vm_stats(bool do_
 		}
 	}
 
-#ifdef CONFIG_NUMA
-	changes += fold_diff(global_zone_diff, global_numa_diff,
-			     global_node_diff);
-#else
 	changes += fold_diff(global_zone_diff, global_node_diff);
-#endif
 	return changes;
 }
 
@@ -877,9 +859,6 @@ void cpu_vm_stats_fold(int cpu)
 	struct zone *zone;
 	int i;
 	int global_zone_diff[NR_VM_ZONE_STAT_ITEMS] = { 0, };
-#ifdef CONFIG_NUMA
-	int global_numa_diff[NR_VM_NUMA_STAT_ITEMS] = { 0, };
-#endif
 	int global_node_diff[NR_VM_NODE_STAT_ITEMS] = { 0, };
 
 	for_each_populated_zone(zone) {
@@ -887,7 +866,7 @@ void cpu_vm_stats_fold(int cpu)
 
 		pzstats = per_cpu_ptr(zone->per_cpu_zonestats, cpu);
 
-		for (i = 0; i < NR_VM_ZONE_STAT_ITEMS; i++)
+		for (i = 0; i < NR_VM_ZONE_STAT_ITEMS; i++) {
 			if (pzstats->vm_stat_diff[i]) {
 				int v;
 
@@ -896,17 +875,17 @@ void cpu_vm_stats_fold(int cpu)
 				atomic_long_add(v, &zone->vm_stat[i]);
 				global_zone_diff[i] += v;
 			}
-
+		}
 #ifdef CONFIG_NUMA
-		for (i = 0; i < NR_VM_NUMA_STAT_ITEMS; i++)
-			if (pzstats->vm_numa_stat_diff[i]) {
-				int v;
-
-				v = pzstats->vm_numa_stat_diff[i];
-				pzstats->vm_numa_stat_diff[i] = 0;
-				atomic_long_add(v, &zone->vm_numa_stat[i]);
-				global_numa_diff[i] += v;
+		for (i = 0; i < NR_VM_NUMA_EVENT_ITEMS; i++) {
+			if (pzstats->vm_numa_event[i]) {
+				unsigned long v;
+
+				v = pzstats->vm_numa_event[i];
+				pzstats->vm_numa_event[i] = 0;
+				zone_numa_event_add(v, zone, i);
 			}
+		}
 #endif
 	}
 
@@ -926,11 +905,7 @@ void cpu_vm_stats_fold(int cpu)
 			}
 	}
 
-#ifdef CONFIG_NUMA
-	fold_diff(global_zone_diff, global_numa_diff, global_node_diff);
-#else
 	fold_diff(global_zone_diff, global_node_diff);
-#endif
 }
 
 /*
@@ -939,43 +914,37 @@ void cpu_vm_stats_fold(int cpu)
  */
 void drain_zonestat(struct zone *zone, struct per_cpu_zonestat *pzstats)
 {
+	unsigned long v;
 	int i;
 
-	for (i = 0; i < NR_VM_ZONE_STAT_ITEMS; i++)
+	for (i = 0; i < NR_VM_ZONE_STAT_ITEMS; i++) {
 		if (pzstats->vm_stat_diff[i]) {
-			int v = pzstats->vm_stat_diff[i];
+			v = pzstats->vm_stat_diff[i];
 			pzstats->vm_stat_diff[i] = 0;
-			atomic_long_add(v, &zone->vm_stat[i]);
-			atomic_long_add(v, &vm_zone_stat[i]);
+			zone_page_state_add(v, zone, i);
 		}
+	}
 
 #ifdef CONFIG_NUMA
-	for (i = 0; i < NR_VM_NUMA_STAT_ITEMS; i++)
-		if (pzstats->vm_numa_stat_diff[i]) {
-			int v = pzstats->vm_numa_stat_diff[i];
-
-			pzstats->vm_numa_stat_diff[i] = 0;
-			atomic_long_add(v, &zone->vm_numa_stat[i]);
-			atomic_long_add(v, &vm_numa_stat[i]);
+	for (i = 0; i < NR_VM_NUMA_EVENT_ITEMS; i++) {
+		if (pzstats->vm_numa_event[i]) {
+			v = pzstats->vm_numa_event[i];
+			pzstats->vm_numa_event[i] = 0;
+			zone_numa_event_add(v, zone, i);
 		}
+	}
 #endif
 }
 #endif
 
 #ifdef CONFIG_NUMA
-void __inc_numa_state(struct zone *zone,
+/* See __count_vm_event comment on why raw_cpu_inc is used. */
+void __count_numa_event(struct zone *zone,
 				 enum numa_stat_item item)
 {
 	struct per_cpu_zonestat __percpu *pzstats = zone->per_cpu_zonestats;
-	u16 __percpu *p = pzstats->vm_numa_stat_diff + item;
-	u16 v;
-
-	v = __this_cpu_inc_return(*p);
 
-	if (unlikely(v > NUMA_STATS_THRESHOLD)) {
-		zone_numa_state_add(v, zone, item);
-		__this_cpu_write(*p, 0);
-	}
+	raw_cpu_inc(pzstats->vm_numa_event[item]);
 }
 
 /*
@@ -996,19 +965,16 @@ unsigned long sum_zone_node_page_state(i
 	return count;
 }
 
-/*
- * Determine the per node value of a numa stat item. To avoid deviation,
- * the per cpu stat number in vm_numa_stat_diff[] is also included.
- */
-unsigned long sum_zone_numa_state(int node,
+/* Determine the per node value of a numa stat item. */
+unsigned long sum_zone_numa_event_state(int node,
 				 enum numa_stat_item item)
 {
 	struct zone *zones = NODE_DATA(node)->node_zones;
-	int i;
 	unsigned long count = 0;
+	int i;
 
 	for (i = 0; i < MAX_NR_ZONES; i++)
-		count += zone_numa_state_snapshot(zones + i, item);
+		count += zone_numa_event_state(zones + i, item);
 
 	return count;
 }
@@ -1687,9 +1653,9 @@ static void zoneinfo_show_print(struct s
 			   zone_page_state(zone, i));
 
 #ifdef CONFIG_NUMA
-	for (i = 0; i < NR_VM_NUMA_STAT_ITEMS; i++)
+	for (i = 0; i < NR_VM_NUMA_EVENT_ITEMS; i++)
 		seq_printf(m, "\n      %-12s %lu", numa_stat_name(i),
-			   zone_numa_state_snapshot(zone, i));
+			   zone_numa_event_state(zone, i));
 #endif
 
 	seq_printf(m, "\n  pagesets");
@@ -1743,7 +1709,7 @@ static const struct seq_operations zonei
 };
 
 #define NR_VMSTAT_ITEMS (NR_VM_ZONE_STAT_ITEMS + \
-			 NR_VM_NUMA_STAT_ITEMS + \
+			 NR_VM_NUMA_EVENT_ITEMS + \
 			 NR_VM_NODE_STAT_ITEMS + \
 			 NR_VM_WRITEBACK_STAT_ITEMS + \
 			 (IS_ENABLED(CONFIG_VM_EVENT_COUNTERS) ? \
@@ -1758,6 +1724,7 @@ static void *vmstat_start(struct seq_fil
 		return NULL;
 
 	BUILD_BUG_ON(ARRAY_SIZE(vmstat_text) < NR_VMSTAT_ITEMS);
+	fold_vm_numa_events();
 	v = kmalloc_array(NR_VMSTAT_ITEMS, sizeof(unsigned long), GFP_KERNEL);
 	m->private = v;
 	if (!v)
@@ -1767,9 +1734,9 @@ static void *vmstat_start(struct seq_fil
 	v += NR_VM_ZONE_STAT_ITEMS;
 
 #ifdef CONFIG_NUMA
-	for (i = 0; i < NR_VM_NUMA_STAT_ITEMS; i++)
-		v[i] = global_numa_state(i);
-	v += NR_VM_NUMA_STAT_ITEMS;
+	for (i = 0; i < NR_VM_NUMA_EVENT_ITEMS; i++)
+		v[i] = global_numa_event_state(i);
+	v += NR_VM_NUMA_EVENT_ITEMS;
 #endif
 
 	for (i = 0; i < NR_VM_NODE_STAT_ITEMS; i++) {
@@ -1939,11 +1906,7 @@ static bool need_update(int cpu)
 		if (memchr_inv(pzstats->vm_stat_diff, 0, NR_VM_ZONE_STAT_ITEMS *
 			       sizeof(pzstats->vm_stat_diff[0])))
 			return true;
-#ifdef CONFIG_NUMA
-		if (memchr_inv(pzstats->vm_numa_stat_diff, 0, NR_VM_NUMA_STAT_ITEMS *
-			       sizeof(pzstats->vm_numa_stat_diff[0])))
-			return true;
-#endif
+
 		if (last_pgdat == zone->zone_pgdat)
 			continue;
 		last_pgdat = zone->zone_pgdat;
_

Patches currently in -mm which might be from mgorman@techsingularity.net are

mm-page_alloc-split-per-cpu-page-lists-and-zone-stats.patch
mm-page_alloc-convert-per-cpu-list-protection-to-local_lock.patch
mm-vmstat-convert-numa-statistics-to-basic-numa-counters.patch
mm-vmstat-inline-numa-event-counter-updates.patch
mm-page_alloc-batch-the-accounting-updates-in-the-bulk-allocator.patch
mm-page_alloc-reduce-duration-that-irqs-are-disabled-for-vm-counters.patch
mm-page_alloc-explicitly-acquire-the-zone-lock-in-__free_pages_ok.patch
mm-page_alloc-avoid-conflating-irqs-disabled-with-zone-lock.patch
mm-page_alloc-update-pgfree-outside-the-zone-lock-in-__free_pages_ok.patch

