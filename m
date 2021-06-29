Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BF7EC11F64
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:41:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0681161D0D
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:41:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231878AbhF2CoG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:44:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:36368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231857AbhF2CoG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 22:44:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 78C2C61D0B;
        Tue, 29 Jun 2021 02:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624934498;
        bh=W1BFOccxCPCSbR33j17X2aKCo8w4druCuC41CTngyUk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=1O33HIk1d9Kt+jRxdEkpumyMyL6Dtutcf+g7SmrfrUy5GJdA/CEhDCKnkZkQ4JZ4O
         N12zzRFHW/Xc0pXdEwXLpjRJE3AA61hNqev6/Si59TIWIePDblcAD0SRvRPlnG2Sgc
         pTJToifO0J5LMc+6DBFwgnXQ4gd+m457XBc1EoJY=
Date:   Mon, 28 Jun 2021 19:41:38 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bigeasy@linutronix.de,
        brouer@redhat.com, chuck.lever@oracle.com, linux-mm@kvack.org,
        mgorman@techsingularity.net, mhocko@kernel.org, mingo@kernel.org,
        mm-commits@vger.kernel.org, peterz@infradead.org,
        tglx@linutronix.de, torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 160/192] mm/page_alloc: split per cpu page lists
 and zone stats
Message-ID: <20210629024138.Kh1pBmreI%akpm@linux-foundation.org>
In-Reply-To: <20210628193256.008961950a714730751c1423@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm/page_alloc: split per cpu page lists and zone stats

The PCP (per-cpu page allocator in page_alloc.c) shares locking
requirements with vmstat and the zone lock which is inconvenient and
causes some issues.  For example, the PCP list and vmstat share the same
per-cpu space meaning that it's possible that vmstat updates dirty cache
lines holding per-cpu lists across CPUs unless padding is used.  Second,
PREEMPT_RT does not want to disable IRQs for too long in the page
allocator.

This series splits the locking requirements and uses locks types more
suitable for PREEMPT_RT, reduces the time when special locking is required
for stats and reduces the time when IRQs need to be disabled on
!PREEMPT_RT kernels.

Why local_lock?  PREEMPT_RT considers the following sequence to be unsafe
as documented in Documentation/locking/locktypes.rst

   local_irq_disable();
   spin_lock(&lock);

The pcp allocator has this sequence for rmqueue_pcplist (local_irq_save)
-> __rmqueue_pcplist -> rmqueue_bulk (spin_lock).  While it's possible to
separate this out, it generally means there are points where we enable
IRQs and reenable them again immediately.  To prevent a migration and the
per-cpu pointer going stale, migrate_disable is also needed.  That is a
custom lock that is similar, but worse, than local_lock.  Furthermore, on
PREEMPT_RT, it's undesirable to leave IRQs disabled for too long.  By
converting to local_lock which disables migration on PREEMPT_RT, the
locking requirements can be separated and start moving the protections for
PCP, stats and the zone lock to PREEMPT_RT-safe equivalent locking.  As a
bonus, local_lock also means that PROVE_LOCKING does something useful.

After that, it's obvious that zone_statistics incurs too much overhead and
leaves IRQs disabled for longer than necessary on !PREEMPT_RT kernels. 
zone_statistics uses perfectly accurate counters requiring IRQs be
disabled for parallel RMW sequences when inaccurate ones like vm_events
would do.  The series makes the NUMA statistics (NUMA_HIT and friends)
inaccurate counters that then require no special protection on
!PREEMPT_RT.

The bulk page allocator can then do stat updates in bulk with IRQs enabled
which should improve the efficiency.  Technically, this could have been
done without the local_lock and vmstat conversion work and the order
simply reflects the timing of when different series were implemented.

Finally, there are places where we conflate IRQs being disabled for the
PCP with the IRQ-safe zone spinlock.  The remainder of the series reduces
the scope of what is protected by disabled IRQs on !PREEMPT_RT kernels. 
By the end of the series, page_alloc.c does not call local_irq_save so the
locking scope is a bit clearer.  The one exception is that modifying
NR_FREE_PAGES still happens in places where it's known the IRQs are
disabled as it's harmless for PREEMPT_RT and would be expensive to split
the locking there.

No performance data is included because despite the overhead of the stats,
it's within the noise for most workloads on !PREEMPT_RT.  However, Jesper
Dangaard Brouer ran a page allocation microbenchmark on a E5-1650 v4 @
3.60GHz CPU on the first version of this series.  Focusing on the array
variant of the bulk page allocator reveals the following.

(CPU: Intel(R) Xeon(R) CPU E5-1650 v4 @ 3.60GHz)
ARRAY variant: time_bulk_page_alloc_free_array: step=bulk size

         Baseline        Patched
 1       56.383          54.225 (+3.83%)
 2       40.047          35.492 (+11.38%)
 3       37.339          32.643 (+12.58%)
 4       35.578          30.992 (+12.89%)
 8       33.592          29.606 (+11.87%)
 16      32.362          28.532 (+11.85%)
 32      31.476          27.728 (+11.91%)
 64      30.633          27.252 (+11.04%)
 128     30.596          27.090 (+11.46%)

While this is a positive outcome, the series is more likely to be
interesting to the RT people in terms of getting parts of the PREEMPT_RT
tree into mainline.  


This patch (of 9):

The per-cpu page allocator lists and the per-cpu vmstat deltas are stored
in the same struct per_cpu_pages even though vmstats have no direct impact
on the per-cpu page lists.  This is inconsistent because the vmstats for a
node are stored on a dedicated structure.  The bigger issue is that the
per_cpu_pages structure is not cache-aligned and stat updates either cache
conflict with adjacent per-cpu lists incurring a runtime cost or padding
is required incurring a memory cost.

This patch splits the per-cpu pagelists and the vmstat deltas into
separate structures.  It's mostly a mechanical conversion but some
variable renaming is done to clearly distinguish the per-cpu pages
structure (pcp) from the vmstats (pzstats).

Superficially, this appears to increase the size of the per_cpu_pages
structure but the movement of expire fills a structure hole so there is no
impact overall.

[mgorman@techsingularity.net: make it W=1 cleaner]
  Link: https://lkml.kernel.org/r/20210514144622.GA3735@techsingularity.net
[mgorman@techsingularity.net: make it W=1 even cleaner]
  Link: https://lkml.kernel.org/r/20210516140705.GB3735@techsingularity.net
[lkp@intel.com: check struct per_cpu_zonestat has a non-zero size]
[vbabka@suse.cz: Init zone->per_cpu_zonestats properly]
Link: https://lkml.kernel.org/r/20210512095458.30632-1-mgorman@techsingularity.net
Link: https://lkml.kernel.org/r/20210512095458.30632-2-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Chuck Lever <chuck.lever@oracle.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |   18 +++----
 include/linux/vmstat.h |    8 +--
 mm/page_alloc.c        |   85 ++++++++++++++++++---------------
 mm/vmstat.c            |   98 ++++++++++++++++++++-------------------
 4 files changed, 113 insertions(+), 96 deletions(-)

--- a/include/linux/mmzone.h~mm-page_alloc-split-per-cpu-page-lists-and-zone-stats
+++ a/include/linux/mmzone.h
@@ -341,20 +341,21 @@ struct per_cpu_pages {
 	int count;		/* number of pages in the list */
 	int high;		/* high watermark, emptying needed */
 	int batch;		/* chunk size for buddy add/remove */
+#ifdef CONFIG_NUMA
+	int expire;		/* When 0, remote pagesets are drained */
+#endif
 
 	/* Lists of pages, one per migrate type stored on the pcp-lists */
 	struct list_head lists[MIGRATE_PCPTYPES];
 };
 
-struct per_cpu_pageset {
-	struct per_cpu_pages pcp;
-#ifdef CONFIG_NUMA
-	s8 expire;
-	u16 vm_numa_stat_diff[NR_VM_NUMA_STAT_ITEMS];
-#endif
+struct per_cpu_zonestat {
 #ifdef CONFIG_SMP
-	s8 stat_threshold;
 	s8 vm_stat_diff[NR_VM_ZONE_STAT_ITEMS];
+	s8 stat_threshold;
+#endif
+#ifdef CONFIG_NUMA
+	u16 vm_numa_stat_diff[NR_VM_NUMA_STAT_ITEMS];
 #endif
 };
 
@@ -484,7 +485,8 @@ struct zone {
 	int node;
 #endif
 	struct pglist_data	*zone_pgdat;
-	struct per_cpu_pageset __percpu *pageset;
+	struct per_cpu_pages	__percpu *per_cpu_pageset;
+	struct per_cpu_zonestat	__percpu *per_cpu_zonestats;
 	/*
 	 * the high and batch values are copied to individual pagesets for
 	 * faster access
--- a/include/linux/vmstat.h~mm-page_alloc-split-per-cpu-page-lists-and-zone-stats
+++ a/include/linux/vmstat.h
@@ -163,7 +163,7 @@ static inline unsigned long zone_numa_st
 	int cpu;
 
 	for_each_online_cpu(cpu)
-		x += per_cpu_ptr(zone->pageset, cpu)->vm_numa_stat_diff[item];
+		x += per_cpu_ptr(zone->per_cpu_zonestats, cpu)->vm_numa_stat_diff[item];
 
 	return x;
 }
@@ -236,7 +236,7 @@ static inline unsigned long zone_page_st
 #ifdef CONFIG_SMP
 	int cpu;
 	for_each_online_cpu(cpu)
-		x += per_cpu_ptr(zone->pageset, cpu)->vm_stat_diff[item];
+		x += per_cpu_ptr(zone->per_cpu_zonestats, cpu)->vm_stat_diff[item];
 
 	if (x < 0)
 		x = 0;
@@ -291,7 +291,7 @@ struct ctl_table;
 int vmstat_refresh(struct ctl_table *, int write, void *buffer, size_t *lenp,
 		loff_t *ppos);
 
-void drain_zonestat(struct zone *zone, struct per_cpu_pageset *);
+void drain_zonestat(struct zone *zone, struct per_cpu_zonestat *);
 
 int calculate_pressure_threshold(struct zone *zone);
 int calculate_normal_threshold(struct zone *zone);
@@ -399,7 +399,7 @@ static inline void cpu_vm_stats_fold(int
 static inline void quiet_vmstat(void) { }
 
 static inline void drain_zonestat(struct zone *zone,
-			struct per_cpu_pageset *pset) { }
+			struct per_cpu_zonestat *pzstats) { }
 #endif		/* CONFIG_SMP */
 
 static inline void __mod_zone_freepage_state(struct zone *zone, int nr_pages,
--- a/mm/page_alloc.c~mm-page_alloc-split-per-cpu-page-lists-and-zone-stats
+++ a/mm/page_alloc.c
@@ -3026,15 +3026,14 @@ void drain_zone_pages(struct zone *zone,
 static void drain_pages_zone(unsigned int cpu, struct zone *zone)
 {
 	unsigned long flags;
-	struct per_cpu_pageset *pset;
 	struct per_cpu_pages *pcp;
 
 	local_irq_save(flags);
-	pset = per_cpu_ptr(zone->pageset, cpu);
 
-	pcp = &pset->pcp;
+	pcp = per_cpu_ptr(zone->per_cpu_pageset, cpu);
 	if (pcp->count)
 		free_pcppages_bulk(zone, pcp->count, pcp);
+
 	local_irq_restore(flags);
 }
 
@@ -3133,7 +3132,7 @@ static void __drain_all_pages(struct zon
 	 * disables preemption as part of its processing
 	 */
 	for_each_online_cpu(cpu) {
-		struct per_cpu_pageset *pcp;
+		struct per_cpu_pages *pcp;
 		struct zone *z;
 		bool has_pcps = false;
 
@@ -3144,13 +3143,13 @@ static void __drain_all_pages(struct zon
 			 */
 			has_pcps = true;
 		} else if (zone) {
-			pcp = per_cpu_ptr(zone->pageset, cpu);
-			if (pcp->pcp.count)
+			pcp = per_cpu_ptr(zone->per_cpu_pageset, cpu);
+			if (pcp->count)
 				has_pcps = true;
 		} else {
 			for_each_populated_zone(z) {
-				pcp = per_cpu_ptr(z->pageset, cpu);
-				if (pcp->pcp.count) {
+				pcp = per_cpu_ptr(z->per_cpu_pageset, cpu);
+				if (pcp->count) {
 					has_pcps = true;
 					break;
 				}
@@ -3280,7 +3279,7 @@ static void free_unref_page_commit(struc
 		migratetype = MIGRATE_MOVABLE;
 	}
 
-	pcp = &this_cpu_ptr(zone->pageset)->pcp;
+	pcp = this_cpu_ptr(zone->per_cpu_pageset);
 	list_add(&page->lru, &pcp->lists[migratetype]);
 	pcp->count++;
 	if (pcp->count >= READ_ONCE(pcp->high))
@@ -3496,7 +3495,7 @@ static struct page *rmqueue_pcplist(stru
 	unsigned long flags;
 
 	local_irq_save(flags);
-	pcp = &this_cpu_ptr(zone->pageset)->pcp;
+	pcp = this_cpu_ptr(zone->per_cpu_pageset);
 	list = &pcp->lists[migratetype];
 	page = __rmqueue_pcplist(zone,  migratetype, alloc_flags, pcp, list);
 	if (page) {
@@ -5105,7 +5104,7 @@ unsigned long __alloc_pages_bulk(gfp_t g
 
 	/* Attempt the batch allocation */
 	local_irq_save(flags);
-	pcp = &this_cpu_ptr(zone->pageset)->pcp;
+	pcp = this_cpu_ptr(zone->per_cpu_pageset);
 	pcp_list = &pcp->lists[ac.migratetype];
 
 	while (nr_populated < nr_pages) {
@@ -5720,7 +5719,7 @@ void show_free_areas(unsigned int filter
 			continue;
 
 		for_each_online_cpu(cpu)
-			free_pcp += per_cpu_ptr(zone->pageset, cpu)->pcp.count;
+			free_pcp += per_cpu_ptr(zone->per_cpu_pageset, cpu)->count;
 	}
 
 	printk("active_anon:%lu inactive_anon:%lu isolated_anon:%lu\n"
@@ -5812,7 +5811,7 @@ void show_free_areas(unsigned int filter
 
 		free_pcp = 0;
 		for_each_online_cpu(cpu)
-			free_pcp += per_cpu_ptr(zone->pageset, cpu)->pcp.count;
+			free_pcp += per_cpu_ptr(zone->per_cpu_pageset, cpu)->count;
 
 		show_node(zone);
 		printk(KERN_CONT
@@ -5853,7 +5852,7 @@ void show_free_areas(unsigned int filter
 			K(zone_page_state(zone, NR_MLOCK)),
 			K(zone_page_state(zone, NR_BOUNCE)),
 			K(free_pcp),
-			K(this_cpu_read(zone->pageset->pcp.count)),
+			K(this_cpu_read(zone->per_cpu_pageset->count)),
 			K(zone_page_state(zone, NR_FREE_CMA_PAGES)));
 		printk("lowmem_reserve[]:");
 		for (i = 0; i < MAX_NR_ZONES; i++)
@@ -6180,11 +6179,12 @@ static void build_zonelists(pg_data_t *p
  * not check if the processor is online before following the pageset pointer.
  * Other parts of the kernel may not check if the zone is available.
  */
-static void pageset_init(struct per_cpu_pageset *p);
+static void per_cpu_pages_init(struct per_cpu_pages *pcp, struct per_cpu_zonestat *pzstats);
 /* These effectively disable the pcplists in the boot pageset completely */
 #define BOOT_PAGESET_HIGH	0
 #define BOOT_PAGESET_BATCH	1
-static DEFINE_PER_CPU(struct per_cpu_pageset, boot_pageset);
+static DEFINE_PER_CPU(struct per_cpu_pages, boot_pageset);
+static DEFINE_PER_CPU(struct per_cpu_zonestat, boot_zonestats);
 static DEFINE_PER_CPU(struct per_cpu_nodestat, boot_nodestats);
 
 static void __build_all_zonelists(void *data)
@@ -6251,7 +6251,7 @@ build_all_zonelists_init(void)
 	 * (a chicken-egg dilemma).
 	 */
 	for_each_possible_cpu(cpu)
-		pageset_init(&per_cpu(boot_pageset, cpu));
+		per_cpu_pages_init(&per_cpu(boot_pageset, cpu), &per_cpu(boot_zonestats, cpu));
 
 	mminit_verify_zonelist();
 	cpuset_init_current_mems_allowed();
@@ -6650,14 +6650,13 @@ static void pageset_update(struct per_cp
 	WRITE_ONCE(pcp->high, high);
 }
 
-static void pageset_init(struct per_cpu_pageset *p)
+static void per_cpu_pages_init(struct per_cpu_pages *pcp, struct per_cpu_zonestat *pzstats)
 {
-	struct per_cpu_pages *pcp;
 	int migratetype;
 
-	memset(p, 0, sizeof(*p));
+	memset(pcp, 0, sizeof(*pcp));
+	memset(pzstats, 0, sizeof(*pzstats));
 
-	pcp = &p->pcp;
 	for (migratetype = 0; migratetype < MIGRATE_PCPTYPES; migratetype++)
 		INIT_LIST_HEAD(&pcp->lists[migratetype]);
 
@@ -6674,12 +6673,12 @@ static void pageset_init(struct per_cpu_
 static void __zone_set_pageset_high_and_batch(struct zone *zone, unsigned long high,
 		unsigned long batch)
 {
-	struct per_cpu_pageset *p;
+	struct per_cpu_pages *pcp;
 	int cpu;
 
 	for_each_possible_cpu(cpu) {
-		p = per_cpu_ptr(zone->pageset, cpu);
-		pageset_update(&p->pcp, high, batch);
+		pcp = per_cpu_ptr(zone->per_cpu_pageset, cpu);
+		pageset_update(pcp, high, batch);
 	}
 }
 
@@ -6714,13 +6713,20 @@ static void zone_set_pageset_high_and_ba
 
 void __meminit setup_zone_pageset(struct zone *zone)
 {
-	struct per_cpu_pageset *p;
 	int cpu;
 
-	zone->pageset = alloc_percpu(struct per_cpu_pageset);
+	/* Size may be 0 on !SMP && !NUMA */
+	if (sizeof(struct per_cpu_zonestat) > 0)
+		zone->per_cpu_zonestats = alloc_percpu(struct per_cpu_zonestat);
+
+	zone->per_cpu_pageset = alloc_percpu(struct per_cpu_pages);
 	for_each_possible_cpu(cpu) {
-		p = per_cpu_ptr(zone->pageset, cpu);
-		pageset_init(p);
+		struct per_cpu_pages *pcp;
+		struct per_cpu_zonestat *pzstats;
+
+		pcp = per_cpu_ptr(zone->per_cpu_pageset, cpu);
+		pzstats = per_cpu_ptr(zone->per_cpu_zonestats, cpu);
+		per_cpu_pages_init(pcp, pzstats);
 	}
 
 	zone_set_pageset_high_and_batch(zone);
@@ -6747,9 +6753,9 @@ void __init setup_per_cpu_pageset(void)
 	 * the nodes these zones are associated with.
 	 */
 	for_each_possible_cpu(cpu) {
-		struct per_cpu_pageset *pcp = &per_cpu(boot_pageset, cpu);
-		memset(pcp->vm_numa_stat_diff, 0,
-		       sizeof(pcp->vm_numa_stat_diff));
+		struct per_cpu_zonestat *pzstats = &per_cpu(boot_zonestats, cpu);
+		memset(pzstats->vm_numa_stat_diff, 0,
+		       sizeof(pzstats->vm_numa_stat_diff));
 	}
 #endif
 
@@ -6765,7 +6771,8 @@ static __meminit void zone_pcp_init(stru
 	 * relies on the ability of the linker to provide the
 	 * offset of a (static) per cpu variable into the per cpu area.
 	 */
-	zone->pageset = &boot_pageset;
+	zone->per_cpu_pageset = &boot_pageset;
+	zone->per_cpu_zonestats = &boot_zonestats;
 	zone->pageset_high = BOOT_PAGESET_HIGH;
 	zone->pageset_batch = BOOT_PAGESET_BATCH;
 
@@ -9046,15 +9053,17 @@ void zone_pcp_enable(struct zone *zone)
 void zone_pcp_reset(struct zone *zone)
 {
 	int cpu;
-	struct per_cpu_pageset *pset;
+	struct per_cpu_zonestat *pzstats;
 
-	if (zone->pageset != &boot_pageset) {
+	if (zone->per_cpu_pageset != &boot_pageset) {
 		for_each_online_cpu(cpu) {
-			pset = per_cpu_ptr(zone->pageset, cpu);
-			drain_zonestat(zone, pset);
+			pzstats = per_cpu_ptr(zone->per_cpu_zonestats, cpu);
+			drain_zonestat(zone, pzstats);
 		}
-		free_percpu(zone->pageset);
-		zone->pageset = &boot_pageset;
+		free_percpu(zone->per_cpu_pageset);
+		free_percpu(zone->per_cpu_zonestats);
+		zone->per_cpu_pageset = &boot_pageset;
+		zone->per_cpu_zonestats = &boot_zonestats;
 	}
 }
 
--- a/mm/vmstat.c~mm-page_alloc-split-per-cpu-page-lists-and-zone-stats
+++ a/mm/vmstat.c
@@ -44,7 +44,7 @@ static void zero_zone_numa_counters(stru
 	for (item = 0; item < NR_VM_NUMA_STAT_ITEMS; item++) {
 		atomic_long_set(&zone->vm_numa_stat[item], 0);
 		for_each_online_cpu(cpu)
-			per_cpu_ptr(zone->pageset, cpu)->vm_numa_stat_diff[item]
+			per_cpu_ptr(zone->per_cpu_zonestats, cpu)->vm_numa_stat_diff[item]
 						= 0;
 	}
 }
@@ -266,7 +266,7 @@ void refresh_zone_stat_thresholds(void)
 		for_each_online_cpu(cpu) {
 			int pgdat_threshold;
 
-			per_cpu_ptr(zone->pageset, cpu)->stat_threshold
+			per_cpu_ptr(zone->per_cpu_zonestats, cpu)->stat_threshold
 							= threshold;
 
 			/* Base nodestat threshold on the largest populated zone. */
@@ -303,7 +303,7 @@ void set_pgdat_percpu_threshold(pg_data_
 
 		threshold = (*calculate_pressure)(zone);
 		for_each_online_cpu(cpu)
-			per_cpu_ptr(zone->pageset, cpu)->stat_threshold
+			per_cpu_ptr(zone->per_cpu_zonestats, cpu)->stat_threshold
 							= threshold;
 	}
 }
@@ -316,7 +316,7 @@ void set_pgdat_percpu_threshold(pg_data_
 void __mod_zone_page_state(struct zone *zone, enum zone_stat_item item,
 			   long delta)
 {
-	struct per_cpu_pageset __percpu *pcp = zone->pageset;
+	struct per_cpu_zonestat __percpu *pcp = zone->per_cpu_zonestats;
 	s8 __percpu *p = pcp->vm_stat_diff + item;
 	long x;
 	long t;
@@ -389,7 +389,7 @@ EXPORT_SYMBOL(__mod_node_page_state);
  */
 void __inc_zone_state(struct zone *zone, enum zone_stat_item item)
 {
-	struct per_cpu_pageset __percpu *pcp = zone->pageset;
+	struct per_cpu_zonestat __percpu *pcp = zone->per_cpu_zonestats;
 	s8 __percpu *p = pcp->vm_stat_diff + item;
 	s8 v, t;
 
@@ -435,7 +435,7 @@ EXPORT_SYMBOL(__inc_node_page_state);
 
 void __dec_zone_state(struct zone *zone, enum zone_stat_item item)
 {
-	struct per_cpu_pageset __percpu *pcp = zone->pageset;
+	struct per_cpu_zonestat __percpu *pcp = zone->per_cpu_zonestats;
 	s8 __percpu *p = pcp->vm_stat_diff + item;
 	s8 v, t;
 
@@ -495,7 +495,7 @@ EXPORT_SYMBOL(__dec_node_page_state);
 static inline void mod_zone_state(struct zone *zone,
        enum zone_stat_item item, long delta, int overstep_mode)
 {
-	struct per_cpu_pageset __percpu *pcp = zone->pageset;
+	struct per_cpu_zonestat __percpu *pcp = zone->per_cpu_zonestats;
 	s8 __percpu *p = pcp->vm_stat_diff + item;
 	long o, n, t, z;
 
@@ -781,19 +781,22 @@ static int refresh_cpu_vm_stats(bool do_
 	int changes = 0;
 
 	for_each_populated_zone(zone) {
-		struct per_cpu_pageset __percpu *p = zone->pageset;
+		struct per_cpu_zonestat __percpu *pzstats = zone->per_cpu_zonestats;
+#ifdef CONFIG_NUMA
+		struct per_cpu_pages __percpu *pcp = zone->per_cpu_pageset;
+#endif
 
 		for (i = 0; i < NR_VM_ZONE_STAT_ITEMS; i++) {
 			int v;
 
-			v = this_cpu_xchg(p->vm_stat_diff[i], 0);
+			v = this_cpu_xchg(pzstats->vm_stat_diff[i], 0);
 			if (v) {
 
 				atomic_long_add(v, &zone->vm_stat[i]);
 				global_zone_diff[i] += v;
 #ifdef CONFIG_NUMA
 				/* 3 seconds idle till flush */
-				__this_cpu_write(p->expire, 3);
+				__this_cpu_write(pcp->expire, 3);
 #endif
 			}
 		}
@@ -801,12 +804,12 @@ static int refresh_cpu_vm_stats(bool do_
 		for (i = 0; i < NR_VM_NUMA_STAT_ITEMS; i++) {
 			int v;
 
-			v = this_cpu_xchg(p->vm_numa_stat_diff[i], 0);
+			v = this_cpu_xchg(pzstats->vm_numa_stat_diff[i], 0);
 			if (v) {
 
 				atomic_long_add(v, &zone->vm_numa_stat[i]);
 				global_numa_diff[i] += v;
-				__this_cpu_write(p->expire, 3);
+				__this_cpu_write(pcp->expire, 3);
 			}
 		}
 
@@ -819,23 +822,23 @@ static int refresh_cpu_vm_stats(bool do_
 			 * Check if there are pages remaining in this pageset
 			 * if not then there is nothing to expire.
 			 */
-			if (!__this_cpu_read(p->expire) ||
-			       !__this_cpu_read(p->pcp.count))
+			if (!__this_cpu_read(pcp->expire) ||
+			       !__this_cpu_read(pcp->count))
 				continue;
 
 			/*
 			 * We never drain zones local to this processor.
 			 */
 			if (zone_to_nid(zone) == numa_node_id()) {
-				__this_cpu_write(p->expire, 0);
+				__this_cpu_write(pcp->expire, 0);
 				continue;
 			}
 
-			if (__this_cpu_dec_return(p->expire))
+			if (__this_cpu_dec_return(pcp->expire))
 				continue;
 
-			if (__this_cpu_read(p->pcp.count)) {
-				drain_zone_pages(zone, this_cpu_ptr(&p->pcp));
+			if (__this_cpu_read(pcp->count)) {
+				drain_zone_pages(zone, this_cpu_ptr(pcp));
 				changes++;
 			}
 		}
@@ -882,27 +885,27 @@ void cpu_vm_stats_fold(int cpu)
 	int global_node_diff[NR_VM_NODE_STAT_ITEMS] = { 0, };
 
 	for_each_populated_zone(zone) {
-		struct per_cpu_pageset *p;
+		struct per_cpu_zonestat *pzstats;
 
-		p = per_cpu_ptr(zone->pageset, cpu);
+		pzstats = per_cpu_ptr(zone->per_cpu_zonestats, cpu);
 
 		for (i = 0; i < NR_VM_ZONE_STAT_ITEMS; i++)
-			if (p->vm_stat_diff[i]) {
+			if (pzstats->vm_stat_diff[i]) {
 				int v;
 
-				v = p->vm_stat_diff[i];
-				p->vm_stat_diff[i] = 0;
+				v = pzstats->vm_stat_diff[i];
+				pzstats->vm_stat_diff[i] = 0;
 				atomic_long_add(v, &zone->vm_stat[i]);
 				global_zone_diff[i] += v;
 			}
 
 #ifdef CONFIG_NUMA
 		for (i = 0; i < NR_VM_NUMA_STAT_ITEMS; i++)
-			if (p->vm_numa_stat_diff[i]) {
+			if (pzstats->vm_numa_stat_diff[i]) {
 				int v;
 
-				v = p->vm_numa_stat_diff[i];
-				p->vm_numa_stat_diff[i] = 0;
+				v = pzstats->vm_numa_stat_diff[i];
+				pzstats->vm_numa_stat_diff[i] = 0;
 				atomic_long_add(v, &zone->vm_numa_stat[i]);
 				global_numa_diff[i] += v;
 			}
@@ -936,24 +939,24 @@ void cpu_vm_stats_fold(int cpu)
  * this is only called if !populated_zone(zone), which implies no other users of
  * pset->vm_stat_diff[] exist.
  */
-void drain_zonestat(struct zone *zone, struct per_cpu_pageset *pset)
+void drain_zonestat(struct zone *zone, struct per_cpu_zonestat *pzstats)
 {
 	int i;
 
 	for (i = 0; i < NR_VM_ZONE_STAT_ITEMS; i++)
-		if (pset->vm_stat_diff[i]) {
-			int v = pset->vm_stat_diff[i];
-			pset->vm_stat_diff[i] = 0;
+		if (pzstats->vm_stat_diff[i]) {
+			int v = pzstats->vm_stat_diff[i];
+			pzstats->vm_stat_diff[i] = 0;
 			atomic_long_add(v, &zone->vm_stat[i]);
 			atomic_long_add(v, &vm_zone_stat[i]);
 		}
 
 #ifdef CONFIG_NUMA
 	for (i = 0; i < NR_VM_NUMA_STAT_ITEMS; i++)
-		if (pset->vm_numa_stat_diff[i]) {
-			int v = pset->vm_numa_stat_diff[i];
+		if (pzstats->vm_numa_stat_diff[i]) {
+			int v = pzstats->vm_numa_stat_diff[i];
 
-			pset->vm_numa_stat_diff[i] = 0;
+			pzstats->vm_numa_stat_diff[i] = 0;
 			atomic_long_add(v, &zone->vm_numa_stat[i]);
 			atomic_long_add(v, &vm_numa_stat[i]);
 		}
@@ -965,8 +968,8 @@ void drain_zonestat(struct zone *zone, s
 void __inc_numa_state(struct zone *zone,
 				 enum numa_stat_item item)
 {
-	struct per_cpu_pageset __percpu *pcp = zone->pageset;
-	u16 __percpu *p = pcp->vm_numa_stat_diff + item;
+	struct per_cpu_zonestat __percpu *pzstats = zone->per_cpu_zonestats;
+	u16 __percpu *p = pzstats->vm_numa_stat_diff + item;
 	u16 v;
 
 	v = __this_cpu_inc_return(*p);
@@ -1693,21 +1696,23 @@ static void zoneinfo_show_print(struct s
 
 	seq_printf(m, "\n  pagesets");
 	for_each_online_cpu(i) {
-		struct per_cpu_pageset *pageset;
+		struct per_cpu_pages *pcp;
+		struct per_cpu_zonestat __maybe_unused *pzstats;
 
-		pageset = per_cpu_ptr(zone->pageset, i);
+		pcp = per_cpu_ptr(zone->per_cpu_pageset, i);
 		seq_printf(m,
 			   "\n    cpu: %i"
 			   "\n              count: %i"
 			   "\n              high:  %i"
 			   "\n              batch: %i",
 			   i,
-			   pageset->pcp.count,
-			   pageset->pcp.high,
-			   pageset->pcp.batch);
+			   pcp->count,
+			   pcp->high,
+			   pcp->batch);
 #ifdef CONFIG_SMP
+		pzstats = per_cpu_ptr(zone->per_cpu_zonestats, i);
 		seq_printf(m, "\n  vm stats threshold: %d",
-				pageset->stat_threshold);
+				pzstats->stat_threshold);
 #endif
 	}
 	seq_printf(m,
@@ -1927,17 +1932,18 @@ static bool need_update(int cpu)
 	struct zone *zone;
 
 	for_each_populated_zone(zone) {
-		struct per_cpu_pageset *p = per_cpu_ptr(zone->pageset, cpu);
+		struct per_cpu_zonestat *pzstats = per_cpu_ptr(zone->per_cpu_zonestats, cpu);
 		struct per_cpu_nodestat *n;
+
 		/*
 		 * The fast way of checking if there are any vmstat diffs.
 		 */
-		if (memchr_inv(p->vm_stat_diff, 0, NR_VM_ZONE_STAT_ITEMS *
-			       sizeof(p->vm_stat_diff[0])))
+		if (memchr_inv(pzstats->vm_stat_diff, 0, NR_VM_ZONE_STAT_ITEMS *
+			       sizeof(pzstats->vm_stat_diff[0])))
 			return true;
 #ifdef CONFIG_NUMA
-		if (memchr_inv(p->vm_numa_stat_diff, 0, NR_VM_NUMA_STAT_ITEMS *
-			       sizeof(p->vm_numa_stat_diff[0])))
+		if (memchr_inv(pzstats->vm_numa_stat_diff, 0, NR_VM_NUMA_STAT_ITEMS *
+			       sizeof(pzstats->vm_numa_stat_diff[0])))
 			return true;
 #endif
 		if (last_pgdat == zone->zone_pgdat)
_
