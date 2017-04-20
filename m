From: akpm@linux-foundation.org
Subject: [patch 1/2] Revert "mm, page_alloc: only use per-cpu allocator
 for irq-safe requests"
Date: Thu, 20 Apr 2017 14:37:43 -0700
Message-ID: <58f92a27.FCEWXVJ724WvEtPK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44498 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S971116AbdDTVho (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Apr 2017 17:37:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mgorman@techsingularity.net, brouer@redhat.com, ttoukan.linux@gmail.com

From: Mel Gorman <mgorman@techsingularity.net>
Subject: Revert "mm, page_alloc: only use per-cpu allocator for irq-safe requests"

This reverts 374ad05ab64.  While the patch worked great for userspace
allocations, the fact that softirq loses the per-cpu allocator caused
problems.  It needs to be redone taking into account that a separate list
is needed for hard/soft IRQs or alternatively find a cheap way of
detecting reentry due to an interrupt.  Both are possible but sufficiently
tricky that it shouldn't be rushed.  Jesper had one method for allowing
softirqs but reported that the cost was high enough that it performed
similarly to a plain revert.  His figures for netperf TCP_STREAM were as
follows

Baseline v4.10.0  : 60316 Mbit/s
Current 4.11.0-rc6: 47491 Mbit/s
Jesper's patch    : 60662 Mbit/s
This patch        : 60106 Mbit/s

As this is a regression, I wish to revert to noirq allocator for now and
go back to the drawing board.

Link: http://lkml.kernel.org/r/20170415145350.ixy7vtrzdzve57mh@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Reported-by: Tariq Toukan <ttoukan.linux@gmail.com>
Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   43 ++++++++++++++++++++-----------------------
 1 file changed, 20 insertions(+), 23 deletions(-)

diff -puN mm/page_alloc.c~revert-mm-page_alloc-only-use-per-cpu-allocator-for-irq-safe-requests mm/page_alloc.c
--- a/mm/page_alloc.c~revert-mm-page_alloc-only-use-per-cpu-allocator-for-irq-safe-requests
+++ a/mm/page_alloc.c
@@ -1090,10 +1090,10 @@ static void free_pcppages_bulk(struct zo
 {
 	int migratetype = 0;
 	int batch_free = 0;
-	unsigned long nr_scanned, flags;
+	unsigned long nr_scanned;
 	bool isolated_pageblocks;
 
-	spin_lock_irqsave(&zone->lock, flags);
+	spin_lock(&zone->lock);
 	isolated_pageblocks = has_isolate_pageblock(zone);
 	nr_scanned = node_page_state(zone->zone_pgdat, NR_PAGES_SCANNED);
 	if (nr_scanned)
@@ -1142,7 +1142,7 @@ static void free_pcppages_bulk(struct zo
 			trace_mm_page_pcpu_drain(page, 0, mt);
 		} while (--count && --batch_free && !list_empty(list));
 	}
-	spin_unlock_irqrestore(&zone->lock, flags);
+	spin_unlock(&zone->lock);
 }
 
 static void free_one_page(struct zone *zone,
@@ -1150,9 +1150,8 @@ static void free_one_page(struct zone *z
 				unsigned int order,
 				int migratetype)
 {
-	unsigned long nr_scanned, flags;
-	spin_lock_irqsave(&zone->lock, flags);
-	__count_vm_events(PGFREE, 1 << order);
+	unsigned long nr_scanned;
+	spin_lock(&zone->lock);
 	nr_scanned = node_page_state(zone->zone_pgdat, NR_PAGES_SCANNED);
 	if (nr_scanned)
 		__mod_node_page_state(zone->zone_pgdat, NR_PAGES_SCANNED, -nr_scanned);
@@ -1162,7 +1161,7 @@ static void free_one_page(struct zone *z
 		migratetype = get_pfnblock_migratetype(page, pfn);
 	}
 	__free_one_page(page, pfn, zone, order, migratetype);
-	spin_unlock_irqrestore(&zone->lock, flags);
+	spin_unlock(&zone->lock);
 }
 
 static void __meminit __init_single_page(struct page *page, unsigned long pfn,
@@ -1240,6 +1239,7 @@ void __meminit reserve_bootmem_region(ph
 
 static void __free_pages_ok(struct page *page, unsigned int order)
 {
+	unsigned long flags;
 	int migratetype;
 	unsigned long pfn = page_to_pfn(page);
 
@@ -1247,7 +1247,10 @@ static void __free_pages_ok(struct page
 		return;
 
 	migratetype = get_pfnblock_migratetype(page, pfn);
+	local_irq_save(flags);
+	__count_vm_events(PGFREE, 1 << order);
 	free_one_page(page_zone(page), page, pfn, order, migratetype);
+	local_irq_restore(flags);
 }
 
 static void __init __free_pages_boot_core(struct page *page, unsigned int order)
@@ -2219,9 +2222,8 @@ static int rmqueue_bulk(struct zone *zon
 			int migratetype, bool cold)
 {
 	int i, alloced = 0;
-	unsigned long flags;
 
-	spin_lock_irqsave(&zone->lock, flags);
+	spin_lock(&zone->lock);
 	for (i = 0; i < count; ++i) {
 		struct page *page = __rmqueue(zone, order, migratetype);
 		if (unlikely(page == NULL))
@@ -2257,7 +2259,7 @@ static int rmqueue_bulk(struct zone *zon
 	 * pages added to the pcp list.
 	 */
 	__mod_zone_page_state(zone, NR_FREE_PAGES, -(i << order));
-	spin_unlock_irqrestore(&zone->lock, flags);
+	spin_unlock(&zone->lock);
 	return alloced;
 }
 
@@ -2485,20 +2487,17 @@ void free_hot_cold_page(struct page *pag
 {
 	struct zone *zone = page_zone(page);
 	struct per_cpu_pages *pcp;
+	unsigned long flags;
 	unsigned long pfn = page_to_pfn(page);
 	int migratetype;
 
-	if (in_interrupt()) {
-		__free_pages_ok(page, 0);
-		return;
-	}
-
 	if (!free_pcp_prepare(page))
 		return;
 
 	migratetype = get_pfnblock_migratetype(page, pfn);
 	set_pcppage_migratetype(page, migratetype);
-	preempt_disable();
+	local_irq_save(flags);
+	__count_vm_event(PGFREE);
 
 	/*
 	 * We only track unmovable, reclaimable and movable on pcp lists.
@@ -2515,7 +2514,6 @@ void free_hot_cold_page(struct page *pag
 		migratetype = MIGRATE_MOVABLE;
 	}
 
-	__count_vm_event(PGFREE);
 	pcp = &this_cpu_ptr(zone->pageset)->pcp;
 	if (!cold)
 		list_add(&page->lru, &pcp->lists[migratetype]);
@@ -2529,7 +2527,7 @@ void free_hot_cold_page(struct page *pag
 	}
 
 out:
-	preempt_enable();
+	local_irq_restore(flags);
 }
 
 /*
@@ -2654,8 +2652,6 @@ static struct page *__rmqueue_pcplist(st
 {
 	struct page *page;
 
-	VM_BUG_ON(in_interrupt());
-
 	do {
 		if (list_empty(list)) {
 			pcp->count += rmqueue_bulk(zone, 0,
@@ -2686,8 +2682,9 @@ static struct page *rmqueue_pcplist(stru
 	struct list_head *list;
 	bool cold = ((gfp_flags & __GFP_COLD) != 0);
 	struct page *page;
+	unsigned long flags;
 
-	preempt_disable();
+	local_irq_save(flags);
 	pcp = &this_cpu_ptr(zone->pageset)->pcp;
 	list = &pcp->lists[migratetype];
 	page = __rmqueue_pcplist(zone,  migratetype, cold, pcp, list);
@@ -2695,7 +2692,7 @@ static struct page *rmqueue_pcplist(stru
 		__count_zid_vm_events(PGALLOC, page_zonenum(page), 1 << order);
 		zone_statistics(preferred_zone, zone);
 	}
-	preempt_enable();
+	local_irq_restore(flags);
 	return page;
 }
 
@@ -2711,7 +2708,7 @@ struct page *rmqueue(struct zone *prefer
 	unsigned long flags;
 	struct page *page;
 
-	if (likely(order == 0) && !in_interrupt()) {
+	if (likely(order == 0)) {
 		page = rmqueue_pcplist(preferred_zone, zone, order,
 				gfp_flags, migratetype);
 		goto out;
_
