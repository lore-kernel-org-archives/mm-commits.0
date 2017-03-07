From: akpm@linux-foundation.org
Subject: +
 mm-page_alloc-count-movable-pages-when-stealing-from-pageblock.patch added
 to -mm tree
Date: Tue, 07 Mar 2017 15:27:32 -0800
Message-ID: <58bf41e4.p0qYnfvzAMjDFWDO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51984 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756507AbdCHAVP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 7 Mar 2017 19:21:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, mgorman@techsingularity.net, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: count movable pages when stealing from pageblock
has been added to the -mm tree.  Its filename is
     mm-page_alloc-count-movable-pages-when-stealing-from-pageblock.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-count-movable-pages-when-stealing-from-pageblock.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-count-movable-pages-when-stealing-from-pageblock.patch

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
Subject: mm, page_alloc: count movable pages when stealing from pageblock

When stealing pages from pageblock of a different migratetype, we count
how many free pages were stolen, and change the pageblock's migratetype if
more than half of the pageblock was free.  This might be too conservative,
as there might be other pages that are not free, but were allocated with
the same migratetype as our allocation requested.

While we cannot determine the migratetype of allocated pages precisely (at
least without the page_owner functionality enabled), we can count pages
that compaction would try to isolate for migration - those are either on
LRU or __PageMovable().  The rest can be assumed to be MIGRATE_RECLAIMABLE
or MIGRATE_UNMOVABLE, which we cannot easily distinguish.  This counting
can be done as part of free page stealing with little additional overhead.

The page stealing code is changed so that it considers free pages plus
pages of the "good" migratetype for the decision whether to change
pageblock's migratetype.

The result should be more accurate migratetype of pageblocks wrt the
actual pages in the pageblocks, when stealing from semi-occupied
pageblocks.  This should help the efficiency of page grouping by mobility.

In testing based on 4.9 kernel with stress-highalloc from mmtests
configured for order-4 GFP_KERNEL allocations, this patch has reduced the
number of unmovable allocations falling back to movable pageblocks by 47%.
The number of movable allocations falling back to other pageblocks are
increased by 55%, but these events don't cause permanent fragmentation, so
the tradeoff should be positive.  Later patches also offset the movable
fallback increase to some extent.

Link: http://lkml.kernel.org/r/20170307131545.28577-5-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-isolation.h |    5 --
 mm/page_alloc.c                |   71 ++++++++++++++++++++++++-------
 mm/page_isolation.c            |    5 +-
 3 files changed, 61 insertions(+), 20 deletions(-)

diff -puN include/linux/page-isolation.h~mm-page_alloc-count-movable-pages-when-stealing-from-pageblock include/linux/page-isolation.h
--- a/include/linux/page-isolation.h~mm-page_alloc-count-movable-pages-when-stealing-from-pageblock
+++ a/include/linux/page-isolation.h
@@ -33,10 +33,7 @@ bool has_unmovable_pages(struct zone *zo
 			 bool skip_hwpoisoned_pages);
 void set_pageblock_migratetype(struct page *page, int migratetype);
 int move_freepages_block(struct zone *zone, struct page *page,
-				int migratetype);
-int move_freepages(struct zone *zone,
-			  struct page *start_page, struct page *end_page,
-			  int migratetype);
+				int migratetype, int *num_movable);
 
 /*
  * Changes migrate type in [start_pfn, end_pfn) to be MIGRATE_ISOLATE.
diff -puN mm/page_alloc.c~mm-page_alloc-count-movable-pages-when-stealing-from-pageblock mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-count-movable-pages-when-stealing-from-pageblock
+++ a/mm/page_alloc.c
@@ -1836,9 +1836,9 @@ static inline struct page *__rmqueue_cma
  * Note that start_page and end_pages are not aligned on a pageblock
  * boundary. If alignment is required, use move_freepages_block()
  */
-int move_freepages(struct zone *zone,
+static int move_freepages(struct zone *zone,
 			  struct page *start_page, struct page *end_page,
-			  int migratetype)
+			  int migratetype, int *num_movable)
 {
 	struct page *page;
 	unsigned int order;
@@ -1855,6 +1855,9 @@ int move_freepages(struct zone *zone,
 	VM_BUG_ON(page_zone(start_page) != page_zone(end_page));
 #endif
 
+	if (num_movable)
+		*num_movable = 0;
+
 	for (page = start_page; page <= end_page;) {
 		if (!pfn_valid_within(page_to_pfn(page))) {
 			page++;
@@ -1865,6 +1868,15 @@ int move_freepages(struct zone *zone,
 		VM_BUG_ON_PAGE(page_to_nid(page) != zone_to_nid(zone), page);
 
 		if (!PageBuddy(page)) {
+			/*
+			 * We assume that pages that could be isolated for
+			 * migration are movable. But we don't actually try
+			 * isolating, as that would be expensive.
+			 */
+			if (num_movable &&
+					(PageLRU(page) || __PageMovable(page)))
+				(*num_movable)++;
+
 			page++;
 			continue;
 		}
@@ -1880,7 +1892,7 @@ int move_freepages(struct zone *zone,
 }
 
 int move_freepages_block(struct zone *zone, struct page *page,
-				int migratetype)
+				int migratetype, int *num_movable)
 {
 	unsigned long start_pfn, end_pfn;
 	struct page *start_page, *end_page;
@@ -1897,7 +1909,8 @@ int move_freepages_block(struct zone *zo
 	if (!zone_spans_pfn(zone, end_pfn))
 		return 0;
 
-	return move_freepages(zone, start_page, end_page, migratetype);
+	return move_freepages(zone, start_page, end_page, migratetype,
+								num_movable);
 }
 
 static void change_pageblock_range(struct page *pageblock_page,
@@ -1947,22 +1960,26 @@ static bool can_steal_fallback(unsigned
 /*
  * This function implements actual steal behaviour. If order is large enough,
  * we can steal whole pageblock. If not, we first move freepages in this
- * pageblock and check whether half of pages are moved or not. If half of
- * pages are moved, we can change migratetype of pageblock and permanently
- * use it's pages as requested migratetype in the future.
+ * pageblock to our migratetype and determine how many already-allocated pages
+ * are there in the pageblock with a compatible migratetype. If at least half
+ * of pages are free or compatible, we can change migratetype of the pageblock
+ * itself, so pages freed in the future will be put on the correct free list.
  */
 static void steal_suitable_fallback(struct zone *zone, struct page *page,
 					int start_type, bool whole_block)
 {
 	unsigned int current_order = page_order(page);
 	struct free_area *area;
-	int pages;
+	int free_pages, movable_pages, alike_pages;
+	int old_block_type;
+
+	old_block_type = get_pageblock_migratetype(page);
 
 	/*
 	 * This can happen due to races and we want to prevent broken
 	 * highatomic accounting.
 	 */
-	if (is_migrate_highatomic_page(page))
+	if (is_migrate_highatomic(old_block_type))
 		goto single_page;
 
 	/* Take ownership for orders >= pageblock_order */
@@ -1975,10 +1992,35 @@ static void steal_suitable_fallback(stru
 	if (!whole_block)
 		goto single_page;
 
-	pages = move_freepages_block(zone, page, start_type);
+	free_pages = move_freepages_block(zone, page, start_type,
+						&movable_pages);
+	/*
+	 * Determine how many pages are compatible with our allocation.
+	 * For movable allocation, it's the number of movable pages which
+	 * we just obtained. For other types it's a bit more tricky.
+	 */
+	if (start_type == MIGRATE_MOVABLE) {
+		alike_pages = movable_pages;
+	} else {
+		/*
+		 * If we are falling back a RECLAIMABLE or UNMOVABLE allocation
+		 * to MOVABLE pageblock, consider all non-movable pages as
+		 * compatible. If it's UNMOVABLE falling back to RECLAIMABLE or
+		 * vice versa, be conservative since we can't distinguish the
+		 * exact migratetype of non-movable pages.
+		 */
+		if (old_block_type == MIGRATE_MOVABLE)
+			alike_pages = pageblock_nr_pages
+						- (free_pages + movable_pages);
+		else
+			alike_pages = 0;
+	}
 
-	/* Claim the whole block if over half of it is free */
-	if (pages >= (1 << (pageblock_order-1)) ||
+	/*
+	 * If a sufficient number of pages in the block are either free or of
+	 * comparable migratability as our allocation, claim the whole block.
+	 */
+	if (free_pages + alike_pages >= (1 << (pageblock_order-1)) ||
 			page_group_by_mobility_disabled)
 		set_pageblock_migratetype(page, start_type);
 
@@ -2056,7 +2098,7 @@ static void reserve_highatomic_pageblock
 	    && !is_migrate_cma(mt)) {
 		zone->nr_reserved_highatomic += pageblock_nr_pages;
 		set_pageblock_migratetype(page, MIGRATE_HIGHATOMIC);
-		move_freepages_block(zone, page, MIGRATE_HIGHATOMIC);
+		move_freepages_block(zone, page, MIGRATE_HIGHATOMIC, NULL);
 	}
 
 out_unlock:
@@ -2133,7 +2175,8 @@ static bool unreserve_highatomic_pageblo
 			 * may increase.
 			 */
 			set_pageblock_migratetype(page, ac->migratetype);
-			ret = move_freepages_block(zone, page, ac->migratetype);
+			ret = move_freepages_block(zone, page, ac->migratetype,
+									NULL);
 			if (ret) {
 				spin_unlock_irqrestore(&zone->lock, flags);
 				return ret;
diff -puN mm/page_isolation.c~mm-page_alloc-count-movable-pages-when-stealing-from-pageblock mm/page_isolation.c
--- a/mm/page_isolation.c~mm-page_alloc-count-movable-pages-when-stealing-from-pageblock
+++ a/mm/page_isolation.c
@@ -66,7 +66,8 @@ out:
 
 		set_pageblock_migratetype(page, MIGRATE_ISOLATE);
 		zone->nr_isolate_pageblock++;
-		nr_pages = move_freepages_block(zone, page, MIGRATE_ISOLATE);
+		nr_pages = move_freepages_block(zone, page, MIGRATE_ISOLATE,
+									NULL);
 
 		__mod_zone_freepage_state(zone, -nr_pages, migratetype);
 	}
@@ -120,7 +121,7 @@ static void unset_migratetype_isolate(st
 	 * pageblock scanning for freepage moving.
 	 */
 	if (!isolated_page) {
-		nr_pages = move_freepages_block(zone, page, migratetype);
+		nr_pages = move_freepages_block(zone, page, migratetype, NULL);
 		__mod_zone_freepage_state(zone, nr_pages, migratetype);
 	}
 	set_pageblock_migratetype(page, migratetype);
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-compaction-reorder-fields-in-struct-compact_control.patch
mm-compaction-remove-redundant-watermark-check-in-compact_finished.patch
mm-page_alloc-split-smallest-stolen-page-in-fallback.patch
mm-page_alloc-count-movable-pages-when-stealing-from-pageblock.patch
mm-compaction-change-migrate_async_suitable-to-suitable_migration_source.patch
mm-compaction-add-migratetype-to-compact_control.patch
mm-compaction-restrict-async-compaction-to-pageblocks-of-same-migratetype.patch
mm-compaction-finish-whole-pageblock-to-reduce-fragmentation.patch

