From: akpm@linux-foundation.org
Subject: + mm-page_alloc-factor-out-fallback-freepage-checking.patch added to -mm tree
Date: Wed, 18 Feb 2015 15:09:59 -0800
Message-ID: <54e51bc7.SIzBnc/xsaAosUo0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48398 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646AbbBRXKA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Feb 2015 18:10:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, mgorman@suse.de, riel@redhat.com, rientjes@google.com, vbabka@suse.cz, zhangyanfei@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: factor out fallback freepage checking
has been added to the -mm tree.  Its filename is
     mm-page_alloc-factor-out-fallback-freepage-checking.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-factor-out-fallback-freepage-checking.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-factor-out-fallback-freepage-checking.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/page_alloc: factor out fallback freepage checking

This is preparation step to use page allocator's anti fragmentation logic
in compaction.  This patch just separates fallback freepage checking part
from fallback freepage management part.  Therefore, there is no functional
change.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>
Cc: David Rientjes <rientjes@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |  153 ++++++++++++++++++++++++++++------------------
 1 file changed, 96 insertions(+), 57 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-factor-out-fallback-freepage-checking mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-factor-out-fallback-freepage-checking
+++ a/mm/page_alloc.c
@@ -1145,14 +1145,40 @@ static void change_pageblock_range(struc
  * as fragmentation caused by those allocations polluting movable pageblocks
  * is worse than movable allocations stealing from unmovable and reclaimable
  * pageblocks.
- *
- * If we claim more than half of the pageblock, change pageblock's migratetype
- * as well.
  */
-static void try_to_steal_freepages(struct zone *zone, struct page *page,
-				  int start_type, int fallback_type)
+static bool can_steal_fallback(unsigned int order, int start_mt)
+{
+	/*
+	 * Leaving this order check is intended, although there is
+	 * relaxed order check in next check. The reason is that
+	 * we can actually steal whole pageblock if this condition met,
+	 * but, below check doesn't guarantee it and that is just heuristic
+	 * so could be changed anytime.
+	 */
+	if (order >= pageblock_order)
+		return true;
+
+	if (order >= pageblock_order / 2 ||
+		start_mt == MIGRATE_RECLAIMABLE ||
+		start_mt == MIGRATE_UNMOVABLE ||
+		page_group_by_mobility_disabled)
+		return true;
+
+	return false;
+}
+
+/*
+ * This function implements actual steal behaviour. If order is large enough,
+ * we can steal whole pageblock. If not, we first move freepages in this
+ * pageblock and check whether half of pages are moved or not. If half of
+ * pages are moved, we can change migratetype of pageblock and permanently
+ * use it's pages as requested migratetype in the future.
+ */
+static void steal_suitable_fallback(struct zone *zone, struct page *page,
+							  int start_type)
 {
 	int current_order = page_order(page);
+	int pages;
 
 	/* Take ownership for orders >= pageblock_order */
 	if (current_order >= pageblock_order) {
@@ -1160,19 +1186,40 @@ static void try_to_steal_freepages(struc
 		return;
 	}
 
-	if (current_order >= pageblock_order / 2 ||
-	    start_type == MIGRATE_RECLAIMABLE ||
-	    start_type == MIGRATE_UNMOVABLE ||
-	    page_group_by_mobility_disabled) {
-		int pages;
-
-		pages = move_freepages_block(zone, page, start_type);
-
-		/* Claim the whole block if over half of it is free */
-		if (pages >= (1 << (pageblock_order-1)) ||
-				page_group_by_mobility_disabled)
-			set_pageblock_migratetype(page, start_type);
+	pages = move_freepages_block(zone, page, start_type);
+
+	/* Claim the whole block if over half of it is free */
+	if (pages >= (1 << (pageblock_order-1)) ||
+			page_group_by_mobility_disabled)
+		set_pageblock_migratetype(page, start_type);
+}
+
+/* Check whether there is a suitable fallback freepage with requested order. */
+static int find_suitable_fallback(struct free_area *area, unsigned int order,
+					int migratetype, bool *can_steal)
+{
+	int i;
+	int fallback_mt;
+
+	if (area->nr_free == 0)
+		return -1;
+
+	*can_steal = false;
+	for (i = 0;; i++) {
+		fallback_mt = fallbacks[migratetype][i];
+		if (fallback_mt == MIGRATE_RESERVE)
+			break;
+
+		if (list_empty(&area->free_list[fallback_mt]))
+			continue;
+
+		if (can_steal_fallback(order, migratetype))
+			*can_steal = true;
+
+		return fallback_mt;
 	}
+
+	return -1;
 }
 
 /* Remove an element from the buddy allocator from the fallback list */
@@ -1182,53 +1229,45 @@ __rmqueue_fallback(struct zone *zone, un
 	struct free_area *area;
 	unsigned int current_order;
 	struct page *page;
+	int fallback_mt;
+	bool can_steal;
 
 	/* Find the largest possible block of pages in the other list */
 	for (current_order = MAX_ORDER-1;
 				current_order >= order && current_order <= MAX_ORDER-1;
 				--current_order) {
-		int i;
-		for (i = 0;; i++) {
-			int migratetype = fallbacks[start_migratetype][i];
-			int buddy_type = start_migratetype;
-
-			/* MIGRATE_RESERVE handled later if necessary */
-			if (migratetype == MIGRATE_RESERVE)
-				break;
-
-			area = &(zone->free_area[current_order]);
-			if (list_empty(&area->free_list[migratetype]))
-				continue;
-
-			page = list_entry(area->free_list[migratetype].next,
-					struct page, lru);
-			area->nr_free--;
-
-			try_to_steal_freepages(zone, page, start_migratetype,
-								migratetype);
-
-			/* Remove the page from the freelists */
-			list_del(&page->lru);
-			rmv_page_order(page);
-
-			expand(zone, page, order, current_order, area,
-					buddy_type);
-
-			/*
-			 * The freepage_migratetype may differ from pageblock's
-			 * migratetype depending on the decisions in
-			 * try_to_steal_freepages(). This is OK as long as it
-			 * does not differ for MIGRATE_CMA pageblocks. For CMA
-			 * we need to make sure unallocated pages flushed from
-			 * pcp lists are returned to the correct freelist.
-			 */
-			set_freepage_migratetype(page, buddy_type);
+		area = &(zone->free_area[current_order]);
+		fallback_mt = find_suitable_fallback(area, current_order,
+				start_migratetype, &can_steal);
+		if (fallback_mt == -1)
+			continue;
+
+		page = list_entry(area->free_list[fallback_mt].next,
+						struct page, lru);
+		if (can_steal)
+			steal_suitable_fallback(zone, page, start_migratetype);
+
+		/* Remove the page from the freelists */
+		area->nr_free--;
+		list_del(&page->lru);
+		rmv_page_order(page);
+
+		expand(zone, page, order, current_order, area,
+					start_migratetype);
+		/*
+		 * The freepage_migratetype may differ from pageblock's
+		 * migratetype depending on the decisions in
+		 * try_to_steal_freepages(). This is OK as long as it
+		 * does not differ for MIGRATE_CMA pageblocks. For CMA
+		 * we need to make sure unallocated pages flushed from
+		 * pcp lists are returned to the correct freelist.
+		 */
+		set_freepage_migratetype(page, start_migratetype);
 
-			trace_mm_page_alloc_extfrag(page, order, current_order,
-				start_migratetype, migratetype);
+		trace_mm_page_alloc_extfrag(page, order, current_order,
+			start_migratetype, fallback_mt);
 
-			return page;
-		}
+		return page;
 	}
 
 	return NULL;
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

origin.patch
mm-nommu-fix-memory-leak.patch
zram-use-proper-type-to-update-max_used_pages.patch
mm-cma-debugfs-interface.patch
mm-cma-allocation-trigger.patch
mm-cma-release-trigger.patch
mm-cma-allocation-trigger-fix.patch
mm-cma-change-fallback-behaviour-for-cma-freepage.patch
mm-page_alloc-factor-out-fallback-freepage-checking.patch
mm-compaction-enhance-compaction-finish-condition.patch

