From: akpm@linux-foundation.org
Subject: [patch 018/124] mm, page_alloc: split buffered_rmqueue()
Date: Fri, 24 Feb 2017 14:56:26 -0800
Message-ID: <58b0ba1a.90nDeM9DXHbsuVrZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37168 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751268AbdBXW42 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Feb 2017 17:56:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mgorman@techsingularity.net, brouer@redhat.com, hillf.zj@alibaba-inc.com, vbabka@suse.cz

From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm, page_alloc: split buffered_rmqueue()

Patch series "Use per-cpu allocator for !irq requests and prepare for a
bulk allocator", v5.

This series is motivated by a conversation led by Jesper Dangaard Brouer
at the last LSF/MM proposing a generic page pool for DMA-coherent pages. 
Part of his motivation was due to the overhead of allocating multiple
order-0 that led some drivers to use high-order allocations and splitting
them.  This is very slow in some cases.

The first two patches in this series restructure the page allocator such
that it is relatively easy to introduce an order-0 bulk page allocator.  A
patch exists to do that and has been handed over to Jesper until an
in-kernel users is created.  The third patch prevents the per-cpu
allocator being drained from IPI context as that can potentially corrupt
the list after patch four is merged.  The final patch alters the per-cpu
alloctor to make it exclusive to !irq requests.  This cuts allocation/free
overhead by roughly 30%.

Performance tests from both Jesper and me are included in the patch.


This patch (of 4):

buffered_rmqueue removes a page from a given zone and uses the per-cpu
list for order-0.  This is fine but a hypothetical caller that wanted
multiple order-0 pages has to disable/reenable interrupts multiple times. 
This patch structures buffere_rmqueue such that it's relatively easy to
build a bulk order-0 page allocator.  There is no functional change.

[mgorman@techsingularity.net: failed per-cpu refill may blow up]
  Link: http://lkml.kernel.org/r/20170124112723.mshmgwq2ihxku2um@techsingularity.net
Link: http://lkml.kernel.org/r/20170123153906.3122-2-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |  128 ++++++++++++++++++++++++++++------------------
 1 file changed, 79 insertions(+), 49 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-split-buffered_rmqueue mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-split-buffered_rmqueue
+++ a/mm/page_alloc.c
@@ -2600,74 +2600,104 @@ static inline void zone_statistics(struc
 #endif
 }
 
+/* Remove page from the per-cpu list, caller must protect the list */
+static struct page *__rmqueue_pcplist(struct zone *zone, int migratetype,
+			bool cold, struct per_cpu_pages *pcp,
+			struct list_head *list)
+{
+	struct page *page;
+
+	do {
+		if (list_empty(list)) {
+			pcp->count += rmqueue_bulk(zone, 0,
+					pcp->batch, list,
+					migratetype, cold);
+			if (unlikely(list_empty(list)))
+				return NULL;
+		}
+
+		if (cold)
+			page = list_last_entry(list, struct page, lru);
+		else
+			page = list_first_entry(list, struct page, lru);
+
+		list_del(&page->lru);
+		pcp->count--;
+	} while (check_new_pcp(page));
+
+	return page;
+}
+
+/* Lock and remove page from the per-cpu list */
+static struct page *rmqueue_pcplist(struct zone *preferred_zone,
+			struct zone *zone, unsigned int order,
+			gfp_t gfp_flags, int migratetype)
+{
+	struct per_cpu_pages *pcp;
+	struct list_head *list;
+	bool cold = ((gfp_flags & __GFP_COLD) != 0);
+	struct page *page;
+	unsigned long flags;
+
+	local_irq_save(flags);
+	pcp = &this_cpu_ptr(zone->pageset)->pcp;
+	list = &pcp->lists[migratetype];
+	page = __rmqueue_pcplist(zone,  migratetype, cold, pcp, list);
+	if (page) {
+		__count_zid_vm_events(PGALLOC, page_zonenum(page), 1 << order);
+		zone_statistics(preferred_zone, zone);
+	}
+	local_irq_restore(flags);
+	return page;
+}
+
 /*
  * Allocate a page from the given zone. Use pcplists for order-0 allocations.
  */
 static inline
-struct page *buffered_rmqueue(struct zone *preferred_zone,
+struct page *rmqueue(struct zone *preferred_zone,
 			struct zone *zone, unsigned int order,
 			gfp_t gfp_flags, unsigned int alloc_flags,
 			int migratetype)
 {
 	unsigned long flags;
 	struct page *page;
-	bool cold = ((gfp_flags & __GFP_COLD) != 0);
 
 	if (likely(order == 0)) {
-		struct per_cpu_pages *pcp;
-		struct list_head *list;
-
-		local_irq_save(flags);
-		do {
-			pcp = &this_cpu_ptr(zone->pageset)->pcp;
-			list = &pcp->lists[migratetype];
-			if (list_empty(list)) {
-				pcp->count += rmqueue_bulk(zone, 0,
-						pcp->batch, list,
-						migratetype, cold);
-				if (unlikely(list_empty(list)))
-					goto failed;
-			}
-
-			if (cold)
-				page = list_last_entry(list, struct page, lru);
-			else
-				page = list_first_entry(list, struct page, lru);
-
-			list_del(&page->lru);
-			pcp->count--;
+		page = rmqueue_pcplist(preferred_zone, zone, order,
+				gfp_flags, migratetype);
+		goto out;
+	}
 
-		} while (check_new_pcp(page));
-	} else {
-		/*
-		 * We most definitely don't want callers attempting to
-		 * allocate greater than order-1 page units with __GFP_NOFAIL.
-		 */
-		WARN_ON_ONCE((gfp_flags & __GFP_NOFAIL) && (order > 1));
-		spin_lock_irqsave(&zone->lock, flags);
+	/*
+	 * We most definitely don't want callers attempting to
+	 * allocate greater than order-1 page units with __GFP_NOFAIL.
+	 */
+	WARN_ON_ONCE((gfp_flags & __GFP_NOFAIL) && (order > 1));
+	spin_lock_irqsave(&zone->lock, flags);
 
-		do {
-			page = NULL;
-			if (alloc_flags & ALLOC_HARDER) {
-				page = __rmqueue_smallest(zone, order, MIGRATE_HIGHATOMIC);
-				if (page)
-					trace_mm_page_alloc_zone_locked(page, order, migratetype);
-			}
-			if (!page)
-				page = __rmqueue(zone, order, migratetype);
-		} while (page && check_new_pages(page, order));
-		spin_unlock(&zone->lock);
+	do {
+		page = NULL;
+		if (alloc_flags & ALLOC_HARDER) {
+			page = __rmqueue_smallest(zone, order, MIGRATE_HIGHATOMIC);
+			if (page)
+				trace_mm_page_alloc_zone_locked(page, order, migratetype);
+		}
 		if (!page)
-			goto failed;
-		__mod_zone_freepage_state(zone, -(1 << order),
-					  get_pcppage_migratetype(page));
-	}
+			page = __rmqueue(zone, order, migratetype);
+	} while (page && check_new_pages(page, order));
+	spin_unlock(&zone->lock);
+	if (!page)
+		goto failed;
+	__mod_zone_freepage_state(zone, -(1 << order),
+				  get_pcppage_migratetype(page));
 
 	__count_zid_vm_events(PGALLOC, page_zonenum(page), 1 << order);
 	zone_statistics(preferred_zone, zone);
 	local_irq_restore(flags);
 
-	VM_BUG_ON_PAGE(bad_range(zone, page), page);
+out:
+	VM_BUG_ON_PAGE(page && bad_range(zone, page), page);
 	return page;
 
 failed:
@@ -2972,7 +3002,7 @@ get_page_from_freelist(gfp_t gfp_mask, u
 		}
 
 try_this_zone:
-		page = buffered_rmqueue(ac->preferred_zoneref->zone, zone, order,
+		page = rmqueue(ac->preferred_zoneref->zone, zone, order,
 				gfp_mask, alloc_flags, ac->migratetype);
 		if (page) {
 			prep_new_page(page, order, gfp_mask, alloc_flags);
_
