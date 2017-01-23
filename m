From: akpm@linux-foundation.org
Subject: + mm-page_alloc-split-buffered_rmqueue.patch added to -mm tree
Date: Mon, 23 Jan 2017 14:53:54 -0800
Message-ID: <58868982.UlC8c0OFGepzEC3O%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44688 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751355AbdAWWxz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 23 Jan 2017 17:53:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, brouer@redhat.com, hillf.zj@alibaba-inc.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: split buffered_rmqueue()
has been added to the -mm tree.  Its filename is
     mm-page_alloc-split-buffered_rmqueue.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-split-buffered_rmqueue.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-split-buffered_rmqueue.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Link: http://lkml.kernel.org/r/20170123153906.3122-2-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |  126 ++++++++++++++++++++++++++++------------------
 1 file changed, 78 insertions(+), 48 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-split-buffered_rmqueue mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-split-buffered_rmqueue
+++ a/mm/page_alloc.c
@@ -2600,73 +2600,103 @@ static inline void zone_statistics(struc
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
 
+out:
 	VM_BUG_ON_PAGE(bad_range(zone, page), page);
 	return page;
 
@@ -2972,7 +3002,7 @@ get_page_from_freelist(gfp_t gfp_mask, u
 		}
 
 try_this_zone:
-		page = buffered_rmqueue(ac->preferred_zoneref->zone, zone, order,
+		page = rmqueue(ac->preferred_zoneref->zone, zone, order,
 				gfp_mask, alloc_flags, ac->migratetype);
 		if (page) {
 			prep_new_page(page, order, gfp_mask, alloc_flags);
_

Patches currently in -mm which might be from mgorman@techsingularity.net are

mm-page_alloc-split-buffered_rmqueue.patch
mm-page_alloc-split-alloc_pages_nodemask.patch
mm-page_alloc-drain-per-cpu-pages-from-workqueue-context.patch
mm-page_alloc-only-use-per-cpu-allocator-for-irq-safe-requests.patch

