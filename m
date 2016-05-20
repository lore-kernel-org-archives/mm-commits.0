From: akpm@linux-foundation.org
Subject: [merged]
 mm-page_alloc-defer-debugging-checks-of-pages-allocated-from-the-pcp.patch
 removed from -mm tree
Date: Fri, 20 May 2016 14:07:05 -0700
Message-ID: <573f7c79.amOqHygxghkkAPAN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47431 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215AbcETVHG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 17:07:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, brouer@redhat.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: defer debugging checks of pages allocated from the PCP
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-defer-debugging-checks-of-pages-allocated-from-the-pcp.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm, page_alloc: defer debugging checks of pages allocated from the PCP

Every page allocated checks a number of page fields for validity.  This
catches corruption bugs of pages that are already freed but it is
expensive.  This patch weakens the debugging check by checking PCP pages
only when the PCP lists are being refilled.  All compound pages are
checked.  This potentially avoids debugging checks entirely if the PCP
lists are never emptied and refilled so some corruption issues may be
missed.  Full checking requires DEBUG_VM.

With the two deferred debugging patches applied, the impact to a page
allocator microbenchmark is

                                           4.6.0-rc3                  4.6.0-rc3
                                         inline-v3r6            deferalloc-v3r7
Min      alloc-odr0-1               344.00 (  0.00%)           317.00 (  7.85%)
Min      alloc-odr0-2               248.00 (  0.00%)           231.00 (  6.85%)
Min      alloc-odr0-4               209.00 (  0.00%)           192.00 (  8.13%)
Min      alloc-odr0-8               181.00 (  0.00%)           166.00 (  8.29%)
Min      alloc-odr0-16              168.00 (  0.00%)           154.00 (  8.33%)
Min      alloc-odr0-32              161.00 (  0.00%)           148.00 (  8.07%)
Min      alloc-odr0-64              158.00 (  0.00%)           145.00 (  8.23%)
Min      alloc-odr0-128             156.00 (  0.00%)           143.00 (  8.33%)
Min      alloc-odr0-256             168.00 (  0.00%)           154.00 (  8.33%)
Min      alloc-odr0-512             178.00 (  0.00%)           167.00 (  6.18%)
Min      alloc-odr0-1024            186.00 (  0.00%)           174.00 (  6.45%)
Min      alloc-odr0-2048            192.00 (  0.00%)           180.00 (  6.25%)
Min      alloc-odr0-4096            198.00 (  0.00%)           184.00 (  7.07%)
Min      alloc-odr0-8192            200.00 (  0.00%)           188.00 (  6.00%)
Min      alloc-odr0-16384           201.00 (  0.00%)           188.00 (  6.47%)
Min      free-odr0-1                189.00 (  0.00%)           180.00 (  4.76%)
Min      free-odr0-2                132.00 (  0.00%)           126.00 (  4.55%)
Min      free-odr0-4                104.00 (  0.00%)            99.00 (  4.81%)
Min      free-odr0-8                 90.00 (  0.00%)            85.00 (  5.56%)
Min      free-odr0-16                84.00 (  0.00%)            80.00 (  4.76%)
Min      free-odr0-32                80.00 (  0.00%)            76.00 (  5.00%)
Min      free-odr0-64                78.00 (  0.00%)            74.00 (  5.13%)
Min      free-odr0-128               77.00 (  0.00%)            73.00 (  5.19%)
Min      free-odr0-256               94.00 (  0.00%)            91.00 (  3.19%)
Min      free-odr0-512              108.00 (  0.00%)           112.00 ( -3.70%)
Min      free-odr0-1024             115.00 (  0.00%)           118.00 ( -2.61%)
Min      free-odr0-2048             120.00 (  0.00%)           125.00 ( -4.17%)
Min      free-odr0-4096             123.00 (  0.00%)           129.00 ( -4.88%)
Min      free-odr0-8192             126.00 (  0.00%)           130.00 ( -3.17%)
Min      free-odr0-16384            126.00 (  0.00%)           131.00 ( -3.97%)

Note that the free paths for large numbers of pages is impacted as the
debugging cost gets shifted into that path when the page data is no longer
necessarily cache-hot.

Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   92 ++++++++++++++++++++++++++++++++--------------
 1 file changed, 64 insertions(+), 28 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-defer-debugging-checks-of-pages-allocated-from-the-pcp mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-defer-debugging-checks-of-pages-allocated-from-the-pcp
+++ a/mm/page_alloc.c
@@ -1714,7 +1714,41 @@ static inline bool free_pages_prezeroed(
 		page_poisoning_enabled() && poisoned;
 }
 
-static int prep_new_page(struct page *page, unsigned int order, gfp_t gfp_flags,
+#ifdef CONFIG_DEBUG_VM
+static bool check_pcp_refill(struct page *page)
+{
+	return false;
+}
+
+static bool check_new_pcp(struct page *page)
+{
+	return check_new_page(page);
+}
+#else
+static bool check_pcp_refill(struct page *page)
+{
+	return check_new_page(page);
+}
+static bool check_new_pcp(struct page *page)
+{
+	return false;
+}
+#endif /* CONFIG_DEBUG_VM */
+
+static bool check_new_pages(struct page *page, unsigned int order)
+{
+	int i;
+	for (i = 0; i < (1 << order); i++) {
+		struct page *p = page + i;
+
+		if (unlikely(check_new_page(p)))
+			return true;
+	}
+
+	return false;
+}
+
+static void prep_new_page(struct page *page, unsigned int order, gfp_t gfp_flags,
 							unsigned int alloc_flags)
 {
 	int i;
@@ -1722,8 +1756,6 @@ static int prep_new_page(struct page *pa
 
 	for (i = 0; i < (1 << order); i++) {
 		struct page *p = page + i;
-		if (unlikely(check_new_page(p)))
-			return 1;
 		if (poisoned)
 			poisoned &= page_is_poisoned(p);
 	}
@@ -1755,8 +1787,6 @@ static int prep_new_page(struct page *pa
 		set_page_pfmemalloc(page);
 	else
 		clear_page_pfmemalloc(page);
-
-	return 0;
 }
 
 /*
@@ -2178,6 +2208,9 @@ static int rmqueue_bulk(struct zone *zon
 		if (unlikely(page == NULL))
 			break;
 
+		if (unlikely(check_pcp_refill(page)))
+			continue;
+
 		/*
 		 * Split buddy pages returned by expand() are received here
 		 * in physical page order. The page is added to the callers and
@@ -2593,20 +2626,22 @@ struct page *buffered_rmqueue(struct zon
 		struct list_head *list;
 
 		local_irq_save(flags);
-		pcp = &this_cpu_ptr(zone->pageset)->pcp;
-		list = &pcp->lists[migratetype];
-		if (list_empty(list)) {
-			pcp->count += rmqueue_bulk(zone, 0,
-					pcp->batch, list,
-					migratetype, cold);
-			if (unlikely(list_empty(list)))
-				goto failed;
-		}
+		do {
+			pcp = &this_cpu_ptr(zone->pageset)->pcp;
+			list = &pcp->lists[migratetype];
+			if (list_empty(list)) {
+				pcp->count += rmqueue_bulk(zone, 0,
+						pcp->batch, list,
+						migratetype, cold);
+				if (unlikely(list_empty(list)))
+					goto failed;
+			}
 
-		if (cold)
-			page = list_last_entry(list, struct page, lru);
-		else
-			page = list_first_entry(list, struct page, lru);
+			if (cold)
+				page = list_last_entry(list, struct page, lru);
+			else
+				page = list_first_entry(list, struct page, lru);
+		} while (page && check_new_pcp(page));
 
 		__dec_zone_state(zone, NR_ALLOC_BATCH);
 		list_del(&page->lru);
@@ -2619,14 +2654,16 @@ struct page *buffered_rmqueue(struct zon
 		WARN_ON_ONCE((gfp_flags & __GFP_NOFAIL) && (order > 1));
 		spin_lock_irqsave(&zone->lock, flags);
 
-		page = NULL;
-		if (alloc_flags & ALLOC_HARDER) {
-			page = __rmqueue_smallest(zone, order, MIGRATE_HIGHATOMIC);
-			if (page)
-				trace_mm_page_alloc_zone_locked(page, order, migratetype);
-		}
-		if (!page)
-			page = __rmqueue(zone, order, migratetype);
+		do {
+			page = NULL;
+			if (alloc_flags & ALLOC_HARDER) {
+				page = __rmqueue_smallest(zone, order, MIGRATE_HIGHATOMIC);
+				if (page)
+					trace_mm_page_alloc_zone_locked(page, order, migratetype);
+			}
+			if (!page)
+				page = __rmqueue(zone, order, migratetype);
+		} while (page && check_new_pages(page, order));
 		spin_unlock(&zone->lock);
 		if (!page)
 			goto failed;
@@ -2993,8 +3030,7 @@ try_this_zone:
 		page = buffered_rmqueue(ac->preferred_zoneref->zone, zone, order,
 				gfp_mask, alloc_flags, ac->migratetype);
 		if (page) {
-			if (prep_new_page(page, order, gfp_mask, alloc_flags))
-				goto try_this_zone;
+			prep_new_page(page, order, gfp_mask, alloc_flags);
 
 			/*
 			 * If this is a high-order atomic allocation then check
_

Patches currently in -mm which might be from mgorman@techsingularity.net are


