From: akpm@linux-foundation.org
Subject: +
 mm-page_alloc-prevent-migrate_reserve-pages-from-being-misplaced.patch
 added to -mm tree
Date: Fri, 18 Apr 2014 15:10:49 -0700
Message-ID: <5351a2e9.njX8wC0nyN6wpJEH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43183 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754232AbaDRWKv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 18 Apr 2014 18:10:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ytk.lee@samsung.com, riel@redhat.com, minchan@kernel.org, mina86@mina86.com, mgorman@suse.de, m.szyprowski@samsung.com, kosaki.motohiro@jp.fujitsu.com, iamjoonsoo.kim@lge.com, hughd@google.com, b.zolnierkie@samsung.com, vbabka@suse.cz

Subject: + mm-page_alloc-prevent-migrate_reserve-pages-from-being-misplaced.patch added to -mm tree
To: vbabka@suse.cz,b.zolnierkie@samsung.com,hughd@google.com,iamjoonsoo.kim@lge.com,kosaki.motohiro@jp.fujitsu.com,m.szyprowski@samsung.com,mgorman@suse.de,mina86@mina86.com,minchan@kernel.org,riel@redhat.com,ytk.lee@samsung.com
From: akpm@linux-foundation.org
Date: Fri, 18 Apr 2014 15:10:49 -0700


The patch titled
     Subject: mm/page_alloc: prevent MIGRATE_RESERVE pages from being misplaced
has been added to the -mm tree.  Its filename is
     mm-page_alloc-prevent-migrate_reserve-pages-from-being-misplaced.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-prevent-migrate_reserve-pages-from-being-misplaced.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-prevent-migrate_reserve-pages-from-being-misplaced.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm/page_alloc: prevent MIGRATE_RESERVE pages from being misplaced

For the MIGRATE_RESERVE pages, it is important they do not get misplaced
on free_list of other migratetype, otherwise the whole MIGRATE_RESERVE
pageblock might be changed to other migratetype in
try_to_steal_freepages().

Currently, it is however possible for this to happen when MIGRATE_RESERVE
page is allocated on pcplist through rmqueue_bulk() as a fallback for
other desired migratetype, and then later freed back through
free_pcppages_bulk() without being actually used.  This happens because
free_pcppages_bulk() uses get_freepage_migratetype() to choose the
free_list, and rmqueue_bulk() calls set_freepage_migratetype() with the
*desired* migratetype and not the page's original MIGRATE_RESERVE
migratetype.

This patch fixes the problem by moving the call to
set_freepage_migratetype() from rmqueue_bulk() down to
__rmqueue_smallest() and __rmqueue_fallback() where the actual page's
migratetype (e.g.  from which free_list the page is taken from) is used. 
Note that this migratetype might be different from the pageblock's
migratetype due to freepage stealing decisions.  This is OK, as page
stealing never uses MIGRATE_RESERVE as a fallback, and also takes care to
leave all MIGRATE_CMA pages on the correct freelist.

Therefore, as an additional benefit, the call to
get_pageblock_migratetype() from rmqueue_bulk() when CMA is enabled, can
be removed completely.  This relies on the fact that MIGRATE_CMA
pageblocks are created only during system init, and the above.  The
related is_migrate_isolate() check is also unnecessary, as memory
isolation has other ways to move pages between freelists, and drain pcp
lists containing pages that should be isolated.  The buffered_rmqueue()
can also benefit from calling get_freepage_migratetype() instead of
get_pageblock_migratetype().

A separate patch will add VM_BUG_ON checks for the invariant that for
MIGRATE_RESERVE and MIGRATE_CMA pageblocks, freepage_migratetype must
equal to pageblock_migratetype so that these pages always go to the
correct free_list.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reported-by: Yong-Taek Lee <ytk.lee@samsung.com>
Reported-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Suggested-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Suggested-by: Mel Gorman <mgorman@suse.de>
Cc: Minchan Kim <minchan@kernel.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-prevent-migrate_reserve-pages-from-being-misplaced mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-prevent-migrate_reserve-pages-from-being-misplaced
+++ a/mm/page_alloc.c
@@ -931,6 +931,7 @@ struct page *__rmqueue_smallest(struct z
 		rmv_page_order(page);
 		area->nr_free--;
 		expand(zone, page, order, current_order, area, migratetype);
+		set_freepage_migratetype(page, migratetype);
 		return page;
 	}
 
@@ -1057,7 +1058,9 @@ static int try_to_steal_freepages(struct
 
 	/*
 	 * When borrowing from MIGRATE_CMA, we need to release the excess
-	 * buddy pages to CMA itself.
+	 * buddy pages to CMA itself. We also ensure the freepage_migratetype
+	 * is set to CMA so it is returned to the correct freelist in case
+	 * the page ends up being not actually allocated from the pcp lists.
 	 */
 	if (is_migrate_cma(fallback_type))
 		return fallback_type;
@@ -1125,6 +1128,12 @@ __rmqueue_fallback(struct zone *zone, in
 
 			expand(zone, page, order, current_order, area,
 			       new_type);
+			/* The freepage_migratetype may differ from pageblock's
+			 * migratetype depending on the decisions in
+			 * try_to_steal_freepages. This is OK as long as it does
+			 * not differ for MIGRATE_CMA type.
+			 */
+			set_freepage_migratetype(page, new_type);
 
 			trace_mm_page_alloc_extfrag(page, order, current_order,
 				start_migratetype, migratetype, new_type);
@@ -1175,7 +1184,7 @@ static int rmqueue_bulk(struct zone *zon
 			unsigned long count, struct list_head *list,
 			int migratetype, int cold)
 {
-	int mt = migratetype, i;
+	int i;
 
 	spin_lock(&zone->lock);
 	for (i = 0; i < count; ++i) {
@@ -1196,14 +1205,8 @@ static int rmqueue_bulk(struct zone *zon
 			list_add(&page->lru, list);
 		else
 			list_add_tail(&page->lru, list);
-		if (IS_ENABLED(CONFIG_CMA)) {
-			mt = get_pageblock_migratetype(page);
-			if (!is_migrate_cma(mt) && !is_migrate_isolate(mt))
-				mt = migratetype;
-		}
-		set_freepage_migratetype(page, mt);
 		list = &page->lru;
-		if (is_migrate_cma(mt))
+		if (is_migrate_cma(get_freepage_migratetype(page)))
 			__mod_zone_page_state(zone, NR_FREE_CMA_PAGES,
 					      -(1 << order));
 	}
@@ -1572,7 +1575,7 @@ again:
 		if (!page)
 			goto failed;
 		__mod_zone_freepage_state(zone, -(1 << order),
-					  get_pageblock_migratetype(page));
+					  get_freepage_migratetype(page));
 	}
 
 	__mod_zone_page_state(zone, NR_ALLOC_BATCH, -(1 << order));
_

Patches currently in -mm which might be from vbabka@suse.cz are

thp-close-race-between-split-and-zap-huge-pages.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
mm-page_alloc-prevent-migrate_reserve-pages-from-being-misplaced.patch
mm-page_alloc-debug_vm-checks-for-free_list-placement-of-cma-and-reserve-pages.patch

