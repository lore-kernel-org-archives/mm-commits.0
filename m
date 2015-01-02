From: akpm@linux-foundation.org
Subject: +
 cma-fix-cmas-page-number-is-substructed-twice-in-__zone_watermark_ok.patch
 added to -mm tree
Date: Fri, 02 Jan 2015 14:34:01 -0800
Message-ID: <54a71cd9.bWDdydhCaSB65h88%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34006 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752207AbbABWeC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 Jan 2015 17:34:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zhuhui@xiaomi.com, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, isimatu.yasuaki@jp.fujitsu.com, liuweixing@xiaomi.com, mgorman@suse.de, riel@redhat.com, rientjes@google.com, sasha.levin@oracle.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: CMA: fix CMA's page number is substructed twice in __zone_watermark_ok
has been added to the -mm tree.  Its filename is
     cma-fix-cmas-page-number-is-substructed-twice-in-__zone_watermark_ok.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/cma-fix-cmas-page-number-is-substructed-twice-in-__zone_watermark_ok.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/cma-fix-cmas-page-number-is-substructed-twice-in-__zone_watermark_ok.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hui Zhu <zhuhui@xiaomi.com>
Subject: CMA: fix CMA's page number is substructed twice in __zone_watermark_ok

The original of this patch [1] is used to fix the issue in Joonsoo's CMA
patch "CMA: always treat free cma pages as non-free on watermark checking"
[2].

Joonsoo reminded me that this issue affect current kernel too.  So made a
new one for upstream.

__zone_watermark_ok() subtracts CMA pages number from free_pages if system
allocation can't use CMA areas:

	/* If allocation can't use CMA areas don't use free CMA pages */
	if (!(alloc_flags & ALLOC_CMA))
		free_cma = zone_page_state(z, NR_FREE_CMA_PAGES);

But after this part of code

	for (o = 0; o < order; o++) {
		/* At the next order, this order's pages become unavailable */
		free_pages -= z->free_area[o].nr_free << o;

CMA memory in each order is part of z->free_area[o].nr_free, then the CMA
page number of this order is subtracted twice.  This bug will make
__zone_watermark_ok return false too frequently.

This patch adds cma_free_area to struct free_area to record the number of
CMA pages.  And add it back in the order loop to handle the subtraction
twice issue.

[1] https://lkml.org/lkml/2014/12/25/43
[2] https://lkml.org/lkml/2014/5/28/110

Signed-off-by: Hui Zhu <zhuhui@xiaomi.com>
Signed-off-by: Weixing Liu <liuweixing@xiaomi.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    3 +++
 mm/page_alloc.c        |   22 ++++++++++++++++++++++
 2 files changed, 25 insertions(+)

diff -puN include/linux/mmzone.h~cma-fix-cmas-page-number-is-substructed-twice-in-__zone_watermark_ok include/linux/mmzone.h
--- a/include/linux/mmzone.h~cma-fix-cmas-page-number-is-substructed-twice-in-__zone_watermark_ok
+++ a/include/linux/mmzone.h
@@ -92,6 +92,9 @@ static inline int get_pfnblock_migratety
 struct free_area {
 	struct list_head	free_list[MIGRATE_TYPES];
 	unsigned long		nr_free;
+#ifdef CONFIG_CMA
+	unsigned long		cma_nr_free;
+#endif
 };
 
 struct pglist_data;
diff -puN mm/page_alloc.c~cma-fix-cmas-page-number-is-substructed-twice-in-__zone_watermark_ok mm/page_alloc.c
--- a/mm/page_alloc.c~cma-fix-cmas-page-number-is-substructed-twice-in-__zone_watermark_ok
+++ a/mm/page_alloc.c
@@ -650,6 +650,8 @@ static inline void __free_one_page(struc
 		} else {
 			list_del(&buddy->lru);
 			zone->free_area[order].nr_free--;
+			if (is_migrate_cma(migratetype))
+				zone->free_area[order].cma_nr_free--;
 			rmv_page_order(buddy);
 		}
 		combined_idx = buddy_idx & page_idx;
@@ -683,6 +685,8 @@ static inline void __free_one_page(struc
 	list_add(&page->lru, &zone->free_area[order].free_list[migratetype]);
 out:
 	zone->free_area[order].nr_free++;
+	if (is_migrate_cma(migratetype))
+		zone->free_area[order].cma_nr_free++;
 }
 
 static inline int free_pages_check(struct page *page)
@@ -937,6 +941,8 @@ static inline void expand(struct zone *z
 		}
 		list_add(&page[size].lru, &area->free_list[migratetype]);
 		area->nr_free++;
+		if (is_migrate_cma(migratetype))
+			area->cma_nr_free++;
 		set_page_order(&page[size], high);
 	}
 }
@@ -1020,6 +1026,8 @@ struct page *__rmqueue_smallest(struct z
 		list_del(&page->lru);
 		rmv_page_order(page);
 		area->nr_free--;
+		if (is_migrate_cma(migratetype))
+			area->cma_nr_free--;
 		expand(zone, page, order, current_order, area, migratetype);
 		set_freepage_migratetype(page, migratetype);
 		return page;
@@ -1208,6 +1216,8 @@ __rmqueue_fallback(struct zone *zone, un
 			page = list_entry(area->free_list[migratetype].next,
 					struct page, lru);
 			area->nr_free--;
+			if (is_migrate_cma(migratetype))
+				area->cma_nr_free--;
 
 			new_type = try_to_steal_freepages(zone, page,
 							  start_migratetype,
@@ -1597,6 +1607,8 @@ int __isolate_free_page(struct page *pag
 	/* Remove page from free list */
 	list_del(&page->lru);
 	zone->free_area[order].nr_free--;
+	if (is_migrate_cma(mt))
+		zone->free_area[order].cma_nr_free--;
 	rmv_page_order(page);
 
 	/* Set the pageblock if the isolated page is at least a pageblock */
@@ -1827,6 +1839,13 @@ static bool __zone_watermark_ok(struct z
 		/* At the next order, this order's pages become unavailable */
 		free_pages -= z->free_area[o].nr_free << o;
 
+		/* If CMA's page number of this order was substructed as part
+		   of "zone_page_state(z, NR_FREE_CMA_PAGES)", subtracting
+		   "z->free_area[o].nr_free << o" substructed CMA's page
+		   number of this order again.  So add it back.  */
+		if (IS_ENABLED(CONFIG_CMA) && free_cma)
+			free_pages += z->free_area[o].cma_nr_free << o;
+
 		/* Require fewer higher order pages to be free */
 		min >>= 1;
 
@@ -4228,6 +4247,7 @@ static void __meminit zone_init_free_lis
 	for_each_migratetype_order(order, t) {
 		INIT_LIST_HEAD(&zone->free_area[order].free_list[t]);
 		zone->free_area[order].nr_free = 0;
+		zone->free_area[order].cma_nr_free = 0;
 	}
 }
 
@@ -6600,6 +6620,8 @@ __offline_isolated_pages(unsigned long s
 		list_del(&page->lru);
 		rmv_page_order(page);
 		zone->free_area[order].nr_free--;
+		if (is_migrate_cma(get_pageblock_migratetype(page)))
+			zone->free_area[order].cma_nr_free--;
 		for (i = 0; i < (1 << order); i++)
 			SetPageReserved((page+i));
 		pfn += (1 << order);
_

Patches currently in -mm which might be from zhuhui@xiaomi.com are

cma-fix-cmas-page-number-is-substructed-twice-in-__zone_watermark_ok.patch

