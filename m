From: akpm@linux-foundation.org
Subject: [merged] mm-introduce-single-zone-pcplists-drain.patch removed
 from -mm tree
Date: Thu, 11 Dec 2014 10:56:14 -0800
Message-ID: <5489e8ce.pRTUmtXmV+g95Etp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45116 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757828AbaLKS4P (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 13:56:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, iamjoonsoo.kim@lge.com, isimatu.yasuaki@jp.fujitsu.com, m.szyprowski@samsung.com, mgorman@suse.de, mina86@mina86.com, n-horiguchi@ah.jp.nec.com, qiuxishi@huawei.com, riel@redhat.com, vdavydov@parallels.com, zhangyanfei@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: introduce single zone pcplists drain
has been removed from the -mm tree.  Its filename was
     mm-introduce-single-zone-pcplists-drain.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm: introduce single zone pcplists drain

The functions for draining per-cpu pages back to buddy allocators
currently always operate on all zones.  There are however several cases
where the drain is only needed in the context of a single zone, and
spilling other pcplists is a waste of time both due to the extra spilling
and later refilling.

This patch introduces new zone pointer parameter to drain_all_pages() and
changes the dummy parameter of drain_local_pages() to be also a zone
pointer.  When NULL is passed, the functions operate on all zones as
usual.  Passing a specific zone pointer reduces the work to the single
zone.

All callers are updated to pass the NULL pointer in this patch. 
Conversion to single zone (where appropriate) is done in further patches.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Xishi Qiu <qiuxishi@huawei.com>
Cc: Vladimir Davydov <vdavydov@parallels.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |    4 +-
 mm/memory-failure.c |    4 +-
 mm/memory_hotplug.c |    4 +-
 mm/page_alloc.c     |   81 +++++++++++++++++++++++++++++-------------
 mm/page_isolation.c |    2 -
 5 files changed, 63 insertions(+), 32 deletions(-)

diff -puN include/linux/gfp.h~mm-introduce-single-zone-pcplists-drain include/linux/gfp.h
--- a/include/linux/gfp.h~mm-introduce-single-zone-pcplists-drain
+++ a/include/linux/gfp.h
@@ -381,8 +381,8 @@ extern void free_kmem_pages(unsigned lon
 
 void page_alloc_init(void);
 void drain_zone_pages(struct zone *zone, struct per_cpu_pages *pcp);
-void drain_all_pages(void);
-void drain_local_pages(void *dummy);
+void drain_all_pages(struct zone *zone);
+void drain_local_pages(struct zone *zone);
 
 /*
  * gfp_allowed_mask is set to GFP_BOOT_MASK during early boot to restrict what
diff -puN mm/memory-failure.c~mm-introduce-single-zone-pcplists-drain mm/memory-failure.c
--- a/mm/memory-failure.c~mm-introduce-single-zone-pcplists-drain
+++ a/mm/memory-failure.c
@@ -233,7 +233,7 @@ void shake_page(struct page *p, int acce
 		lru_add_drain_all();
 		if (PageLRU(p))
 			return;
-		drain_all_pages();
+		drain_all_pages(NULL);
 		if (PageLRU(p) || is_free_buddy_page(p))
 			return;
 	}
@@ -1661,7 +1661,7 @@ static int __soft_offline_page(struct pa
 			if (!is_free_buddy_page(page))
 				lru_add_drain_all();
 			if (!is_free_buddy_page(page))
-				drain_all_pages();
+				drain_all_pages(NULL);
 			SetPageHWPoison(page);
 			if (!is_free_buddy_page(page))
 				pr_info("soft offline: %#lx: page leaked\n",
diff -puN mm/memory_hotplug.c~mm-introduce-single-zone-pcplists-drain mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-introduce-single-zone-pcplists-drain
+++ a/mm/memory_hotplug.c
@@ -1725,7 +1725,7 @@ repeat:
 	if (drain) {
 		lru_add_drain_all();
 		cond_resched();
-		drain_all_pages();
+		drain_all_pages(NULL);
 	}
 
 	pfn = scan_movable_pages(start_pfn, end_pfn);
@@ -1747,7 +1747,7 @@ repeat:
 	lru_add_drain_all();
 	yield();
 	/* drain pcp pages, this is synchronous. */
-	drain_all_pages();
+	drain_all_pages(NULL);
 	/*
 	 * dissolve free hugepages in the memory block before doing offlining
 	 * actually in order to make hugetlbfs's object counting consistent.
diff -puN mm/page_alloc.c~mm-introduce-single-zone-pcplists-drain mm/page_alloc.c
--- a/mm/page_alloc.c~mm-introduce-single-zone-pcplists-drain
+++ a/mm/page_alloc.c
@@ -1267,55 +1267,75 @@ void drain_zone_pages(struct zone *zone,
 #endif
 
 /*
- * Drain pages of the indicated processor.
+ * Drain pcplists of the indicated processor and zone.
  *
  * The processor must either be the current processor and the
  * thread pinned to the current processor or a processor that
  * is not online.
  */
-static void drain_pages(unsigned int cpu)
+static void drain_pages_zone(unsigned int cpu, struct zone *zone)
 {
 	unsigned long flags;
-	struct zone *zone;
+	struct per_cpu_pageset *pset;
+	struct per_cpu_pages *pcp;
 
-	for_each_populated_zone(zone) {
-		struct per_cpu_pageset *pset;
-		struct per_cpu_pages *pcp;
+	local_irq_save(flags);
+	pset = per_cpu_ptr(zone->pageset, cpu);
 
-		local_irq_save(flags);
-		pset = per_cpu_ptr(zone->pageset, cpu);
+	pcp = &pset->pcp;
+	if (pcp->count) {
+		free_pcppages_bulk(zone, pcp->count, pcp);
+		pcp->count = 0;
+	}
+	local_irq_restore(flags);
+}
 
-		pcp = &pset->pcp;
-		if (pcp->count) {
-			free_pcppages_bulk(zone, pcp->count, pcp);
-			pcp->count = 0;
-		}
-		local_irq_restore(flags);
+/*
+ * Drain pcplists of all zones on the indicated processor.
+ *
+ * The processor must either be the current processor and the
+ * thread pinned to the current processor or a processor that
+ * is not online.
+ */
+static void drain_pages(unsigned int cpu)
+{
+	struct zone *zone;
+
+	for_each_populated_zone(zone) {
+		drain_pages_zone(cpu, zone);
 	}
 }
 
 /*
  * Spill all of this CPU's per-cpu pages back into the buddy allocator.
+ *
+ * The CPU has to be pinned. When zone parameter is non-NULL, spill just
+ * the single zone's pages.
  */
-void drain_local_pages(void *arg)
+void drain_local_pages(struct zone *zone)
 {
-	drain_pages(smp_processor_id());
+	int cpu = smp_processor_id();
+
+	if (zone)
+		drain_pages_zone(cpu, zone);
+	else
+		drain_pages(cpu);
 }
 
 /*
  * Spill all the per-cpu pages from all CPUs back into the buddy allocator.
  *
+ * When zone parameter is non-NULL, spill just the single zone's pages.
+ *
  * Note that this code is protected against sending an IPI to an offline
  * CPU but does not guarantee sending an IPI to newly hotplugged CPUs:
  * on_each_cpu_mask() blocks hotplug and won't talk to offlined CPUs but
  * nothing keeps CPUs from showing up after we populated the cpumask and
  * before the call to on_each_cpu_mask().
  */
-void drain_all_pages(void)
+void drain_all_pages(struct zone *zone)
 {
 	int cpu;
-	struct per_cpu_pageset *pcp;
-	struct zone *zone;
 
 	/*
 	 * Allocate in the BSS so we wont require allocation in
@@ -1330,20 +1350,31 @@ void drain_all_pages(void)
 	 * disables preemption as part of its processing
 	 */
 	for_each_online_cpu(cpu) {
+		struct per_cpu_pageset *pcp;
+		struct zone *z;
 		bool has_pcps = false;
-		for_each_populated_zone(zone) {
+
+		if (zone) {
 			pcp = per_cpu_ptr(zone->pageset, cpu);
-			if (pcp->pcp.count) {
+			if (pcp->pcp.count)
 				has_pcps = true;
-				break;
+		} else {
+			for_each_populated_zone(z) {
+				pcp = per_cpu_ptr(z->pageset, cpu);
+				if (pcp->pcp.count) {
+					has_pcps = true;
+					break;
+				}
 			}
 		}
+
 		if (has_pcps)
 			cpumask_set_cpu(cpu, &cpus_with_pcps);
 		else
 			cpumask_clear_cpu(cpu, &cpus_with_pcps);
 	}
-	on_each_cpu_mask(&cpus_with_pcps, drain_local_pages, NULL, 1);
+	on_each_cpu_mask(&cpus_with_pcps, (smp_call_func_t) drain_local_pages,
+								zone, 1);
 }
 
 #ifdef CONFIG_HIBERNATION
@@ -2433,7 +2464,7 @@ retry:
 	 * pages are pinned on the per-cpu lists. Drain them and try again
 	 */
 	if (!page && !drained) {
-		drain_all_pages();
+		drain_all_pages(NULL);
 		drained = true;
 		goto retry;
 	}
@@ -6385,7 +6416,7 @@ int alloc_contig_range(unsigned long sta
 	 */
 
 	lru_add_drain_all();
-	drain_all_pages();
+	drain_all_pages(NULL);
 
 	order = 0;
 	outer_start = start;
diff -puN mm/page_isolation.c~mm-introduce-single-zone-pcplists-drain mm/page_isolation.c
--- a/mm/page_isolation.c~mm-introduce-single-zone-pcplists-drain
+++ a/mm/page_isolation.c
@@ -68,7 +68,7 @@ out:
 
 	spin_unlock_irqrestore(&zone->lock, flags);
 	if (!ret)
-		drain_all_pages();
+		drain_all_pages(NULL);
 	return ret;
 }
 
_

Patches currently in -mm which might be from vbabka@suse.cz are

origin.patch
mm-debug-pagealloc-cleanup-page-guard-code.patch

