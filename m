From: akpm@linux-foundation.org
Subject: [merged] page-allocator-update-nr_free_pages-only-as-necessary.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:34:21 -0700
Message-ID: <200906171834.n5HIYLaO000434@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45587 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759903AbZFQSet (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:34:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, Lee.Schermerhorn@hp.com, a.p.zijlstra@chello.nl, cl@linux-foundation.org, dave@linux.vnet.ibm.com, kosaki.motohiro@jp.fujitsu.com, nickpiggin@yahoo.com.au, penberg@cs.h


The patch titled
     page allocator: update NR_FREE_PAGES only as necessary
has been removed from the -mm tree.  Its filename was
     page-allocator-update-nr_free_pages-only-as-necessary.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: page allocator: update NR_FREE_PAGES only as necessary
From: Mel Gorman <mel@csn.ul.ie>

When pages are being freed to the buddy allocator, the zone NR_FREE_PAGES
counter must be updated.  In the case of bulk per-cpu page freeing, it's
updated once per page.  This retouches cache lines more than necessary. 
Update the counters one per per-cpu bulk free.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: Christoph Lameter <cl@linux-foundation.org>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff -puN mm/page_alloc.c~page-allocator-update-nr_free_pages-only-as-necessary mm/page_alloc.c
--- a/mm/page_alloc.c~page-allocator-update-nr_free_pages-only-as-necessary
+++ a/mm/page_alloc.c
@@ -456,7 +456,6 @@ static inline void __free_one_page(struc
 		int migratetype)
 {
 	unsigned long page_idx;
-	int order_size = 1 << order;
 
 	if (unlikely(PageCompound(page)))
 		if (unlikely(destroy_compound_page(page, order)))
@@ -466,10 +465,9 @@ static inline void __free_one_page(struc
 
 	page_idx = page_to_pfn(page) & ((1 << MAX_ORDER) - 1);
 
-	VM_BUG_ON(page_idx & (order_size - 1));
+	VM_BUG_ON(page_idx & ((1 << order) - 1));
 	VM_BUG_ON(bad_range(zone, page));
 
-	__mod_zone_page_state(zone, NR_FREE_PAGES, order_size);
 	while (order < MAX_ORDER-1) {
 		unsigned long combined_idx;
 		struct page *buddy;
@@ -524,6 +522,8 @@ static void free_pages_bulk(struct zone 
 	spin_lock(&zone->lock);
 	zone_clear_flag(zone, ZONE_ALL_UNRECLAIMABLE);
 	zone->pages_scanned = 0;
+
+	__mod_zone_page_state(zone, NR_FREE_PAGES, count << order);
 	while (count--) {
 		struct page *page;
 
@@ -542,6 +542,8 @@ static void free_one_page(struct zone *z
 	spin_lock(&zone->lock);
 	zone_clear_flag(zone, ZONE_ALL_UNRECLAIMABLE);
 	zone->pages_scanned = 0;
+
+	__mod_zone_page_state(zone, NR_FREE_PAGES, 1 << order);
 	__free_one_page(page, zone, order, migratetype);
 	spin_unlock(&zone->lock);
 }
@@ -686,7 +688,6 @@ struct page *__rmqueue_smallest(struct z
 		list_del(&page->lru);
 		rmv_page_order(page);
 		area->nr_free--;
-		__mod_zone_page_state(zone, NR_FREE_PAGES, - (1UL << order));
 		expand(zone, page, order, current_order, area, migratetype);
 		return page;
 	}
@@ -826,8 +827,6 @@ __rmqueue_fallback(struct zone *zone, in
 			/* Remove the page from the freelists */
 			list_del(&page->lru);
 			rmv_page_order(page);
-			__mod_zone_page_state(zone, NR_FREE_PAGES,
-							-(1UL << order));
 
 			if (current_order == pageblock_order)
 				set_pageblock_migratetype(page,
@@ -900,6 +899,7 @@ static int rmqueue_bulk(struct zone *zon
 		set_page_private(page, migratetype);
 		list = &page->lru;
 	}
+	__mod_zone_page_state(zone, NR_FREE_PAGES, -(i << order));
 	spin_unlock(&zone->lock);
 	return i;
 }
@@ -1129,6 +1129,7 @@ again:
 	} else {
 		spin_lock_irqsave(&zone->lock, flags);
 		page = __rmqueue(zone, order, migratetype);
+		__mod_zone_page_state(zone, NR_FREE_PAGES, -(1 << order));
 		spin_unlock(&zone->lock);
 		if (!page)
 			goto failed;
_

Patches currently in -mm which might be from mel@csn.ul.ie are

origin.patch
linux-next.patch
page_alloc-oops-when-setting-percpu_pagelist_fraction.patch
memcg-fix-lru-rotation-in-isolate_pages.patch
add-debugging-aid-for-memory-initialisation-problems.patch

