Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17347C48BE0
	for <mm-commits@archiver.kernel.org>; Fri, 11 Jun 2021 23:18:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC18C613F0
	for <mm-commits@archiver.kernel.org>; Fri, 11 Jun 2021 23:18:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230396AbhFKXUr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Jun 2021 19:20:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:60580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230470AbhFKXUr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 11 Jun 2021 19:20:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C6B4F611B0;
        Fri, 11 Jun 2021 23:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623453529;
        bh=x/FwTZu40gBzRP01EnNVlJp3Y9BHh9Wd3qlQ3DNj9NM=;
        h=Date:From:To:Subject:From;
        b=UfctG6C9twFaXM93bbPSXK7lgqY3WEI92jJjvealUJmABax283eG9ZPQ+BD/+gDXd
         txzCbSD73LKSa/cCdaT0xc8qWlEfrY6ICVmag6krXiBDgKBWT3hpnMES+29DNTvr0G
         w3q3UhrLUuMtARIKEF0gzgA5amoTvUobZE6SMIrs=
Date:   Fri, 11 Jun 2021 16:18:48 -0700
From:   akpm@linux-foundation.org
To:     brouer@redhat.com, dave.hansen@linux.intel.com,
        mgorman@techsingularity.net, mhocko@kernel.org,
        mm-commits@vger.kernel.org, vbabka@suse.cz, ziy@nvidia.com
Subject:  +
 =?US-ASCII?Q?mm-page=5Falloc-allow-high-order-pages-to-be-stored-on-the?=
 =?US-ASCII?Q?-per-cpu-lists.patch?= added to -mm tree
Message-ID: <20210611231848.aCgycDPrD%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: allow high-order pages to be stored on the per-cpu lists
has been added to the -mm tree.  Its filename is
     mm-page_alloc-allow-high-order-pages-to-be-stored-on-the-per-cpu-lists.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-allow-high-order-pages-to-be-stored-on-the-per-cpu-lists.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-allow-high-order-pages-to-be-stored-on-the-per-cpu-lists.patch

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
Subject: mm/page_alloc: allow high-order pages to be stored on the per-cpu lists

The per-cpu page allocator (PCP) only stores order-0 pages.  This means
that all THP and "cheap" high-order allocations including SLUB contends on
the zone->lock.  This patch extends the PCP allocator to store THP and
"cheap" high-order pages.  Note that struct per_cpu_pages increases in
size to 256 bytes (4 cache lines) on x86-64.

Note that this is not necessarily a universal performance win because of
how it is implemented.  High-order pages can cause pcp->high to be
exceeded prematurely for lower-orders so for example, a large number of
THP pages being freed could release order-0 pages from the PCP lists. 
Hence, much depends on the allocation/free pattern as observed by a single
CPU to determine if caching helps or hurts a particular workload.

That said, basic performance testing passed.  The following is a netperf
UDP_STREAM test which hits the relevant patches as some of the network
allocations are high-order.

netperf-udp
                                 5.13.0-rc2             5.13.0-rc2
                           mm-pcpburst-v3r4   mm-pcphighorder-v1r7
Hmean     send-64         261.46 (   0.00%)      266.30 *   1.85%*
Hmean     send-128        516.35 (   0.00%)      536.78 *   3.96%*
Hmean     send-256       1014.13 (   0.00%)     1034.63 *   2.02%*
Hmean     send-1024      3907.65 (   0.00%)     4046.11 *   3.54%*
Hmean     send-2048      7492.93 (   0.00%)     7754.85 *   3.50%*
Hmean     send-3312     11410.04 (   0.00%)    11772.32 *   3.18%*
Hmean     send-4096     13521.95 (   0.00%)    13912.34 *   2.89%*
Hmean     send-8192     21660.50 (   0.00%)    22730.72 *   4.94%*
Hmean     send-16384    31902.32 (   0.00%)    32637.50 *   2.30%*

Functionally, a patch like this is necessary to make bulk allocation of
high-order pages work with similar performance to order-0 bulk
allocations.  The bulk allocator is not updated in this series as it would
have to be determined by bulk allocation users how they want to track the
order of pages allocated with the bulk allocator.

Link: https://lkml.kernel.org/r/20210611135753.GC30378@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |   20 ++++
 mm/internal.h          |    2 
 mm/page_alloc.c        |  169 ++++++++++++++++++++++++++++-----------
 mm/swap.c              |    2 
 4 files changed, 144 insertions(+), 49 deletions(-)

--- a/include/linux/mmzone.h~mm-page_alloc-allow-high-order-pages-to-be-stored-on-the-per-cpu-lists
+++ a/include/linux/mmzone.h
@@ -333,6 +333,24 @@ enum zone_watermarks {
 	NR_WMARK
 };
 
+/*
+ * One per migratetype for each PAGE_ALLOC_COSTLY_ORDER plus one additional
+ * for pageblock size for THP if configured.
+ */
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+#define NR_PCP_THP 1
+#else
+#define NR_PCP_THP 0
+#endif
+#define NR_PCP_LISTS (MIGRATE_PCPTYPES * (PAGE_ALLOC_COSTLY_ORDER + 1 + NR_PCP_THP))
+
+/*
+ * Shift to encode migratetype and order in the same integer, with order
+ * in the least significant bits.
+ */
+#define NR_PCP_ORDER_WIDTH 8
+#define NR_PCP_ORDER_MASK ((1<<NR_PCP_ORDER_WIDTH) - 1)
+
 #define min_wmark_pages(z) (z->_watermark[WMARK_MIN] + z->watermark_boost)
 #define low_wmark_pages(z) (z->_watermark[WMARK_LOW] + z->watermark_boost)
 #define high_wmark_pages(z) (z->_watermark[WMARK_HIGH] + z->watermark_boost)
@@ -349,7 +367,7 @@ struct per_cpu_pages {
 #endif
 
 	/* Lists of pages, one per migrate type stored on the pcp-lists */
-	struct list_head lists[MIGRATE_PCPTYPES];
+	struct list_head lists[NR_PCP_LISTS];
 };
 
 struct per_cpu_zonestat {
--- a/mm/internal.h~mm-page_alloc-allow-high-order-pages-to-be-stored-on-the-per-cpu-lists
+++ a/mm/internal.h
@@ -203,7 +203,7 @@ extern void post_alloc_hook(struct page
 					gfp_t gfp_flags);
 extern int user_min_free_kbytes;
 
-extern void free_unref_page(struct page *page);
+extern void free_unref_page(struct page *page, unsigned int order);
 extern void free_unref_page_list(struct list_head *list);
 
 extern void zone_pcp_update(struct zone *zone, int cpu_online);
--- a/mm/page_alloc.c~mm-page_alloc-allow-high-order-pages-to-be-stored-on-the-per-cpu-lists
+++ a/mm/page_alloc.c
@@ -674,10 +674,53 @@ out:
 	add_taint(TAINT_BAD_PAGE, LOCKDEP_NOW_UNRELIABLE);
 }
 
+static inline unsigned int order_to_pindex(int migratetype, int order)
+{
+	int base = order;
+
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	if (order > PAGE_ALLOC_COSTLY_ORDER) {
+		VM_BUG_ON(order != pageblock_order);
+		base = PAGE_ALLOC_COSTLY_ORDER + 1;
+	}
+#else
+	VM_BUG_ON(order > PAGE_ALLOC_COSTLY_ORDER);
+#endif
+
+	return (MIGRATE_PCPTYPES * base) + migratetype;
+}
+
+static inline int pindex_to_order(unsigned int pindex)
+{
+	int order = pindex / MIGRATE_PCPTYPES;
+
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	if (order > PAGE_ALLOC_COSTLY_ORDER) {
+		order = pageblock_order;
+		VM_BUG_ON(order != pageblock_order);
+	}
+#else
+	VM_BUG_ON(order > PAGE_ALLOC_COSTLY_ORDER);
+#endif
+
+	return order;
+}
+
+static inline bool pcp_allowed_order(unsigned int order)
+{
+	if (order <= PAGE_ALLOC_COSTLY_ORDER)
+		return true;
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	if (order == pageblock_order)
+		return true;
+#endif
+	return false;
+}
+
 static inline void free_the_page(struct page *page, unsigned int order)
 {
-	if (order == 0)		/* Via pcp? */
-		free_unref_page(page);
+	if (pcp_allowed_order(order))		/* Via pcp? */
+		free_unref_page(page, order);
 	else
 		__free_pages_ok(page, order, FPI_NONE);
 }
@@ -700,7 +743,7 @@ static inline void free_the_page(struct
 void free_compound_page(struct page *page)
 {
 	mem_cgroup_uncharge(page);
-	__free_pages_ok(page, compound_order(page), FPI_NONE);
+	free_the_page(page, compound_order(page));
 }
 
 void prep_compound_page(struct page *page, unsigned int order)
@@ -1350,9 +1393,9 @@ static __always_inline bool free_pages_p
  * to pcp lists. With debug_pagealloc also enabled, they are also rechecked when
  * moved from pcp lists to free lists.
  */
-static bool free_pcp_prepare(struct page *page)
+static bool free_pcp_prepare(struct page *page, unsigned int order)
 {
-	return free_pages_prepare(page, 0, true, FPI_NONE);
+	return free_pages_prepare(page, order, true, FPI_NONE);
 }
 
 static bool bulkfree_pcp_prepare(struct page *page)
@@ -1369,12 +1412,12 @@ static bool bulkfree_pcp_prepare(struct
  * debug_pagealloc enabled, they are checked also immediately when being freed
  * to the pcp lists.
  */
-static bool free_pcp_prepare(struct page *page)
+static bool free_pcp_prepare(struct page *page, unsigned int order)
 {
 	if (debug_pagealloc_enabled_static())
-		return free_pages_prepare(page, 0, true, FPI_NONE);
+		return free_pages_prepare(page, order, true, FPI_NONE);
 	else
-		return free_pages_prepare(page, 0, false, FPI_NONE);
+		return free_pages_prepare(page, order, false, FPI_NONE);
 }
 
 static bool bulkfree_pcp_prepare(struct page *page)
@@ -1406,8 +1449,10 @@ static inline void prefetch_buddy(struct
 static void free_pcppages_bulk(struct zone *zone, int count,
 					struct per_cpu_pages *pcp)
 {
-	int migratetype = 0;
+	int pindex = 0;
 	int batch_free = 0;
+	int nr_freed = 0;
+	unsigned int order;
 	int prefetch_nr = READ_ONCE(pcp->batch);
 	bool isolated_pageblocks;
 	struct page *page, *tmp;
@@ -1418,7 +1463,7 @@ static void free_pcppages_bulk(struct zo
 	 * below while (list_empty(list)) loop.
 	 */
 	count = min(pcp->count, count);
-	while (count) {
+	while (count > 0) {
 		struct list_head *list;
 
 		/*
@@ -1430,24 +1475,31 @@ static void free_pcppages_bulk(struct zo
 		 */
 		do {
 			batch_free++;
-			if (++migratetype == MIGRATE_PCPTYPES)
-				migratetype = 0;
-			list = &pcp->lists[migratetype];
+			if (++pindex == NR_PCP_LISTS)
+				pindex = 0;
+			list = &pcp->lists[pindex];
 		} while (list_empty(list));
 
 		/* This is the only non-empty list. Free them all. */
-		if (batch_free == MIGRATE_PCPTYPES)
+		if (batch_free == NR_PCP_LISTS)
 			batch_free = count;
 
+		order = pindex_to_order(pindex);
+		BUILD_BUG_ON(MAX_ORDER >= (1<<NR_PCP_ORDER_WIDTH));
 		do {
 			page = list_last_entry(list, struct page, lru);
 			/* must delete to avoid corrupting pcp list */
 			list_del(&page->lru);
-			pcp->count--;
+			nr_freed += 1 << order;
+			count -= 1 << order;
 
 			if (bulkfree_pcp_prepare(page))
 				continue;
 
+			/* Encode order with the migratetype */
+			page->index <<= NR_PCP_ORDER_WIDTH;
+			page->index |= order;
+
 			list_add_tail(&page->lru, &head);
 
 			/*
@@ -1463,8 +1515,9 @@ static void free_pcppages_bulk(struct zo
 				prefetch_buddy(page);
 				prefetch_nr--;
 			}
-		} while (--count && --batch_free && !list_empty(list));
+		} while (count > 0 && --batch_free && !list_empty(list));
 	}
+	pcp->count -= nr_freed;
 
 	/*
 	 * local_lock_irq held so equivalent to spin_lock_irqsave for
@@ -1479,14 +1532,19 @@ static void free_pcppages_bulk(struct zo
 	 */
 	list_for_each_entry_safe(page, tmp, &head, lru) {
 		int mt = get_pcppage_migratetype(page);
+
+		/* mt has been encoded with the order (see above) */
+		order = mt & NR_PCP_ORDER_MASK;
+		mt >>= NR_PCP_ORDER_WIDTH;
+
 		/* MIGRATE_ISOLATE page should not go to pcplists */
 		VM_BUG_ON_PAGE(is_migrate_isolate(mt), page);
 		/* Pageblock could have been isolated meanwhile */
 		if (unlikely(isolated_pageblocks))
 			mt = get_pageblock_migratetype(page);
 
-		__free_one_page(page, page_to_pfn(page), zone, 0, mt, FPI_NONE);
-		trace_mm_page_pcpu_drain(page, 0, mt);
+		__free_one_page(page, page_to_pfn(page), zone, order, mt, FPI_NONE);
+		trace_mm_page_pcpu_drain(page, order, mt);
 	}
 	spin_unlock(&zone->lock);
 }
@@ -3263,11 +3321,12 @@ void mark_free_pages(struct zone *zone)
 }
 #endif /* CONFIG_PM */
 
-static bool free_unref_page_prepare(struct page *page, unsigned long pfn)
+static bool free_unref_page_prepare(struct page *page, unsigned long pfn,
+							unsigned int order)
 {
 	int migratetype;
 
-	if (!free_pcp_prepare(page))
+	if (!free_pcp_prepare(page, order))
 		return false;
 
 	migratetype = get_pfnblock_migratetype(page, pfn);
@@ -3317,16 +3376,18 @@ static int nr_pcp_high(struct per_cpu_pa
 }
 
 static void free_unref_page_commit(struct page *page, unsigned long pfn,
-				   int migratetype)
+				   int migratetype, unsigned int order)
 {
 	struct zone *zone = page_zone(page);
 	struct per_cpu_pages *pcp;
 	int high;
+	int pindex;
 
 	__count_vm_event(PGFREE);
 	pcp = this_cpu_ptr(zone->per_cpu_pageset);
-	list_add(&page->lru, &pcp->lists[migratetype]);
-	pcp->count++;
+	pindex = order_to_pindex(migratetype, order);
+	list_add(&page->lru, &pcp->lists[pindex]);
+	pcp->count += 1 << order;
 	high = nr_pcp_high(pcp, zone);
 	if (pcp->count >= high) {
 		int batch = READ_ONCE(pcp->batch);
@@ -3336,15 +3397,15 @@ static void free_unref_page_commit(struc
 }
 
 /*
- * Free a 0-order page
+ * Free a pcp page
  */
-void free_unref_page(struct page *page)
+void free_unref_page(struct page *page, unsigned int order)
 {
 	unsigned long flags;
 	unsigned long pfn = page_to_pfn(page);
 	int migratetype;
 
-	if (!free_unref_page_prepare(page, pfn))
+	if (!free_unref_page_prepare(page, pfn, order))
 		return;
 
 	/*
@@ -3357,14 +3418,14 @@ void free_unref_page(struct page *page)
 	migratetype = get_pcppage_migratetype(page);
 	if (unlikely(migratetype >= MIGRATE_PCPTYPES)) {
 		if (unlikely(is_migrate_isolate(migratetype))) {
-			free_one_page(page_zone(page), page, pfn, 0, migratetype, FPI_NONE);
+			free_one_page(page_zone(page), page, pfn, order, migratetype, FPI_NONE);
 			return;
 		}
 		migratetype = MIGRATE_MOVABLE;
 	}
 
 	local_lock_irqsave(&pagesets.lock, flags);
-	free_unref_page_commit(page, pfn, migratetype);
+	free_unref_page_commit(page, pfn, migratetype, order);
 	local_unlock_irqrestore(&pagesets.lock, flags);
 }
 
@@ -3381,7 +3442,7 @@ void free_unref_page_list(struct list_he
 	/* Prepare pages for freeing */
 	list_for_each_entry_safe(page, next, list, lru) {
 		pfn = page_to_pfn(page);
-		if (!free_unref_page_prepare(page, pfn))
+		if (!free_unref_page_prepare(page, pfn, 0))
 			list_del(&page->lru);
 
 		/*
@@ -3413,7 +3474,7 @@ void free_unref_page_list(struct list_he
 		set_page_private(page, 0);
 		migratetype = get_pcppage_migratetype(page);
 		trace_mm_page_free_batched(page);
-		free_unref_page_commit(page, pfn, migratetype);
+		free_unref_page_commit(page, pfn, migratetype, 0);
 
 		/*
 		 * Guard against excessive IRQ disabled times when we get
@@ -3549,7 +3610,8 @@ static inline void zone_statistics(struc
 
 /* Remove page from the per-cpu list, caller must protect the list */
 static inline
-struct page *__rmqueue_pcplist(struct zone *zone, int migratetype,
+struct page *__rmqueue_pcplist(struct zone *zone, unsigned int order,
+			int migratetype,
 			unsigned int alloc_flags,
 			struct per_cpu_pages *pcp,
 			struct list_head *list)
@@ -3558,16 +3620,30 @@ struct page *__rmqueue_pcplist(struct zo
 
 	do {
 		if (list_empty(list)) {
-			pcp->count += rmqueue_bulk(zone, 0,
-					READ_ONCE(pcp->batch), list,
+			int batch = READ_ONCE(pcp->batch);
+			int alloced;
+
+			/*
+			 * Scale batch relative to order if batch implies
+			 * free pages can be stored on the PCP. Batch can
+			 * be 1 for small zones or for boot pagesets which
+			 * should never store free pages as the pages may
+			 * belong to arbitrary zones.
+			 */
+			if (batch > 1)
+				batch = max(batch >> order, 2);
+			alloced = rmqueue_bulk(zone, order,
+					batch, list,
 					migratetype, alloc_flags);
+
+			pcp->count += alloced << order;
 			if (unlikely(list_empty(list)))
 				return NULL;
 		}
 
 		page = list_first_entry(list, struct page, lru);
 		list_del(&page->lru);
-		pcp->count--;
+		pcp->count -= 1 << order;
 	} while (check_new_pcp(page));
 
 	return page;
@@ -3575,8 +3651,9 @@ struct page *__rmqueue_pcplist(struct zo
 
 /* Lock and remove page from the per-cpu list */
 static struct page *rmqueue_pcplist(struct zone *preferred_zone,
-			struct zone *zone, gfp_t gfp_flags,
-			int migratetype, unsigned int alloc_flags)
+			struct zone *zone, unsigned int order,
+			gfp_t gfp_flags, int migratetype,
+			unsigned int alloc_flags)
 {
 	struct per_cpu_pages *pcp;
 	struct list_head *list;
@@ -3592,8 +3669,8 @@ static struct page *rmqueue_pcplist(stru
 	 */
 	pcp = this_cpu_ptr(zone->per_cpu_pageset);
 	pcp->free_factor >>= 1;
-	list = &pcp->lists[migratetype];
-	page = __rmqueue_pcplist(zone,  migratetype, alloc_flags, pcp, list);
+	list = &pcp->lists[order_to_pindex(migratetype, order)];
+	page = __rmqueue_pcplist(zone, order, migratetype, alloc_flags, pcp, list);
 	local_unlock_irqrestore(&pagesets.lock, flags);
 	if (page) {
 		__count_zid_vm_events(PGALLOC, page_zonenum(page), 1);
@@ -3614,15 +3691,15 @@ struct page *rmqueue(struct zone *prefer
 	unsigned long flags;
 	struct page *page;
 
-	if (likely(order == 0)) {
+	if (likely(pcp_allowed_order(order))) {
 		/*
 		 * MIGRATE_MOVABLE pcplist could have the pages on CMA area and
 		 * we need to skip it when CMA area isn't allowed.
 		 */
 		if (!IS_ENABLED(CONFIG_CMA) || alloc_flags & ALLOC_CMA ||
 				migratetype != MIGRATE_MOVABLE) {
-			page = rmqueue_pcplist(preferred_zone, zone, gfp_flags,
-					migratetype, alloc_flags);
+			page = rmqueue_pcplist(preferred_zone, zone, order,
+					gfp_flags, migratetype, alloc_flags);
 			goto out;
 		}
 	}
@@ -5197,7 +5274,7 @@ unsigned long __alloc_pages_bulk(gfp_t g
 	/* Attempt the batch allocation */
 	local_lock_irqsave(&pagesets.lock, flags);
 	pcp = this_cpu_ptr(zone->per_cpu_pageset);
-	pcp_list = &pcp->lists[ac.migratetype];
+	pcp_list = &pcp->lists[order_to_pindex(ac.migratetype, 0)];
 
 	while (nr_populated < nr_pages) {
 
@@ -5207,7 +5284,7 @@ unsigned long __alloc_pages_bulk(gfp_t g
 			continue;
 		}
 
-		page = __rmqueue_pcplist(zone, ac.migratetype, alloc_flags,
+		page = __rmqueue_pcplist(zone, 0, ac.migratetype, alloc_flags,
 								pcp, pcp_list);
 		if (unlikely(!page)) {
 			/* Try and get at least one page */
@@ -6753,13 +6830,13 @@ static void pageset_update(struct per_cp
 
 static void per_cpu_pages_init(struct per_cpu_pages *pcp, struct per_cpu_zonestat *pzstats)
 {
-	int migratetype;
+	int pindex;
 
 	memset(pcp, 0, sizeof(*pcp));
 	memset(pzstats, 0, sizeof(*pzstats));
 
-	for (migratetype = 0; migratetype < MIGRATE_PCPTYPES; migratetype++)
-		INIT_LIST_HEAD(&pcp->lists[migratetype]);
+	for (pindex = 0; pindex < NR_PCP_LISTS; pindex++)
+		INIT_LIST_HEAD(&pcp->lists[pindex]);
 
 	/*
 	 * Set batch and high values safe for a boot pageset. A true percpu
--- a/mm/swap.c~mm-page_alloc-allow-high-order-pages-to-be-stored-on-the-per-cpu-lists
+++ a/mm/swap.c
@@ -95,7 +95,7 @@ static void __put_single_page(struct pag
 {
 	__page_cache_release(page);
 	mem_cgroup_uncharge(page);
-	free_unref_page(page);
+	free_unref_page(page, 0);
 }
 
 static void __put_compound_page(struct page *page)
_

Patches currently in -mm which might be from mgorman@techsingularity.net are

mm-page_alloc-split-per-cpu-page-lists-and-zone-stats.patch
mm-page_alloc-split-per-cpu-page-lists-and-zone-stats-fix.patch
mm-page_alloc-split-per-cpu-page-lists-and-zone-stats-fix-fix.patch
mm-page_alloc-convert-per-cpu-list-protection-to-local_lock.patch
mm-page_alloc-convert-per-cpu-list-protection-to-local_lock-fix.patch
mm-vmstat-convert-numa-statistics-to-basic-numa-counters.patch
mm-vmstat-inline-numa-event-counter-updates.patch
mm-page_alloc-batch-the-accounting-updates-in-the-bulk-allocator.patch
mm-page_alloc-reduce-duration-that-irqs-are-disabled-for-vm-counters.patch
mm-page_alloc-explicitly-acquire-the-zone-lock-in-__free_pages_ok.patch
mm-page_alloc-avoid-conflating-irqs-disabled-with-zone-lock.patch
mm-page_alloc-update-pgfree-outside-the-zone-lock-in-__free_pages_ok.patch
mm-page_alloc-delete-vmpercpu_pagelist_fraction.patch
mm-page_alloc-disassociate-the-pcp-high-from-pcp-batch.patch
mm-page_alloc-disassociate-the-pcp-high-from-pcp-batch-fix-2.patch
mm-page_alloc-adjust-pcp-high-after-cpu-hotplug-events.patch
mm-page_alloc-scale-the-number-of-pages-that-are-batch-freed.patch
mm-page_alloc-limit-the-number-of-pages-on-pcp-lists-when-reclaim-is-active.patch
mm-page_alloc-introduce-vmpercpu_pagelist_high_fraction.patch
mm-page_alloc-introduce-vmpercpu_pagelist_high_fraction-fix.patch
mm-page_alloc-move-free_the_page.patch
mm-page_alloc-allow-high-order-pages-to-be-stored-on-the-per-cpu-lists.patch
mm-vmscan-remove-kerneldoc-like-comment-from-isolate_lru_pages.patch
mm-vmalloc-include-header-for-prototype-of-set_iounmap_nonlazy.patch
mm-page_alloc-make-should_fail_alloc_page-a-static-function-should_fail_alloc_page-static.patch
mm-mapping_dirty_helpers-remove-double-note-in-kerneldoc.patch
mm-memcontrolc-fix-kerneldoc-comment-for-mem_cgroup_calculate_protection.patch
mm-memory_hotplug-fix-kerneldoc-comment-for-__try_online_node.patch
mm-memory_hotplug-fix-kerneldoc-comment-for-__remove_memory.patch
mm-zbud-add-kerneldoc-fields-for-zbud_pool.patch
mm-z3fold-add-kerneldoc-fields-for-z3fold_pool.patch
mm-swap-make-swap_address_space-an-inline-function.patch
mm-mmap_lock-remove-dead-code-for-config_tracing-configurations.patch
mm-page_alloc-move-prototype-for-find_suitable_fallback.patch
mm-swap-make-node_data-an-inline-function-on-config_flatmem.patch

