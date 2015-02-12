From: akpm@linux-foundation.org
Subject: [merged]
 mm-always-steal-split-buddies-in-fallback-allocations.patch removed from
 -mm tree
Date: Thu, 12 Feb 2015 11:38:51 -0800
Message-ID: <54dd014b.b0j7w/Hi6Njw66EJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58527 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752410AbbBLTiw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Feb 2015 14:38:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, aneesh.kumar@linux.vnet.ibm.com, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, kirill.shutemov@linux.intel.com, kosaki.motohiro@jp.fujitsu.com, mgorman@suse.de, mhocko@suse.cz, minchan@kernel.org, riel@redhat.com, rientjes@google.com, zhangyanfei@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: always steal split buddies in fallback allocations
has been removed from the -mm tree.  Its filename was
     mm-always-steal-split-buddies-in-fallback-allocations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm: always steal split buddies in fallback allocations

When allocation falls back to another migratetype, it will steal a page
with highest available order, and (depending on this order and desired
migratetype), it might also steal the rest of free pages from the same
pageblock.

Given the preference of highest available order, it is likely that it will
be higher than the desired order, and result in the stolen buddy page
being split.  The remaining pages after split are currently stolen only
when the rest of the free pages are stolen.  This can however lead to
situations where for MOVABLE allocations we split e.g.  order-4 fallback
UNMOVABLE page, but steal only order-0 page.  Then on the next MOVABLE
allocation (which may be batched to fill the pcplists) we split another
order-3 or higher page, etc.  By stealing all pages that we have split, we
can avoid further stealing.

This patch therefore adjusts the page stealing so that buddy pages created
by split are always stolen.  This has effect only on MOVABLE allocations,
as RECLAIMABLE and UNMOVABLE allocations already always do that in
addition to stealing the rest of free pages from the pageblock.  The
change also allows to simplify try_to_steal_freepages() and factor out CMA
handling.

According to Mel, it has been intended since the beginning that buddy
pages after split would be stolen always, but it doesn't seem like it was
ever the case until commit 47118af076f6 ("mm: mmzone: MIGRATE_CMA
migration type added").  The commit has unintentionally introduced this
behavior, but was reverted by commit 0cbef29a7821 ("mm:
__rmqueue_fallback() should respect pageblock type").  Neither included
evaluation.

My evaluation with stress-highalloc from mmtests shows about 2.5x
reduction of page stealing events for MOVABLE allocations, without
affecting the page stealing events for other allocation migratetypes.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   62 +++++++++++++++++++++-------------------------
 1 file changed, 29 insertions(+), 33 deletions(-)

diff -puN mm/page_alloc.c~mm-always-steal-split-buddies-in-fallback-allocations mm/page_alloc.c
--- a/mm/page_alloc.c~mm-always-steal-split-buddies-in-fallback-allocations
+++ a/mm/page_alloc.c
@@ -1125,33 +1125,18 @@ static void change_pageblock_range(struc
 /*
  * If breaking a large block of pages, move all free pages to the preferred
  * allocation list. If falling back for a reclaimable kernel allocation, be
- * more aggressive about taking ownership of free pages.
- *
- * On the other hand, never change migration type of MIGRATE_CMA pageblocks
- * nor move CMA pages to different free lists. We don't want unmovable pages
- * to be allocated from MIGRATE_CMA areas.
- *
- * Returns the allocation migratetype if free pages were stolen, or the
- * fallback migratetype if it was decided not to steal.
+ * more aggressive about taking ownership of free pages. If we claim more than
+ * half of the pageblock, change pageblock's migratetype as well.
  */
-static int try_to_steal_freepages(struct zone *zone, struct page *page,
+static void try_to_steal_freepages(struct zone *zone, struct page *page,
 				  int start_type, int fallback_type)
 {
 	int current_order = page_order(page);
 
-	/*
-	 * When borrowing from MIGRATE_CMA, we need to release the excess
-	 * buddy pages to CMA itself. We also ensure the freepage_migratetype
-	 * is set to CMA so it is returned to the correct freelist in case
-	 * the page ends up being not actually allocated from the pcp lists.
-	 */
-	if (is_migrate_cma(fallback_type))
-		return fallback_type;
-
 	/* Take ownership for orders >= pageblock_order */
 	if (current_order >= pageblock_order) {
 		change_pageblock_range(page, current_order, start_type);
-		return start_type;
+		return;
 	}
 
 	if (current_order >= pageblock_order / 2 ||
@@ -1165,11 +1150,7 @@ static int try_to_steal_freepages(struct
 		if (pages >= (1 << (pageblock_order-1)) ||
 				page_group_by_mobility_disabled)
 			set_pageblock_migratetype(page, start_type);
-
-		return start_type;
 	}
-
-	return fallback_type;
 }
 
 /* Remove an element from the buddy allocator from the fallback list */
@@ -1179,14 +1160,15 @@ __rmqueue_fallback(struct zone *zone, un
 	struct free_area *area;
 	unsigned int current_order;
 	struct page *page;
-	int migratetype, new_type, i;
 
 	/* Find the largest possible block of pages in the other list */
 	for (current_order = MAX_ORDER-1;
 				current_order >= order && current_order <= MAX_ORDER-1;
 				--current_order) {
+		int i;
 		for (i = 0;; i++) {
-			migratetype = fallbacks[start_migratetype][i];
+			int migratetype = fallbacks[start_migratetype][i];
+			int buddy_type = start_migratetype;
 
 			/* MIGRATE_RESERVE handled later if necessary */
 			if (migratetype == MIGRATE_RESERVE)
@@ -1200,22 +1182,36 @@ __rmqueue_fallback(struct zone *zone, un
 					struct page, lru);
 			area->nr_free--;
 
-			new_type = try_to_steal_freepages(zone, page,
-							  start_migratetype,
-							  migratetype);
+			if (!is_migrate_cma(migratetype)) {
+				try_to_steal_freepages(zone, page,
+							start_migratetype,
+							migratetype);
+			} else {
+				/*
+				 * When borrowing from MIGRATE_CMA, we need to
+				 * release the excess buddy pages to CMA
+				 * itself, and we do not try to steal extra
+				 * free pages.
+				 */
+				buddy_type = migratetype;
+			}
 
 			/* Remove the page from the freelists */
 			list_del(&page->lru);
 			rmv_page_order(page);
 
 			expand(zone, page, order, current_order, area,
-			       new_type);
-			/* The freepage_migratetype may differ from pageblock's
+					buddy_type);
+
+			/*
+			 * The freepage_migratetype may differ from pageblock's
 			 * migratetype depending on the decisions in
-			 * try_to_steal_freepages. This is OK as long as it does
-			 * not differ for MIGRATE_CMA type.
+			 * try_to_steal_freepages(). This is OK as long as it
+			 * does not differ for MIGRATE_CMA pageblocks. For CMA
+			 * we need to make sure unallocated pages flushed from
+			 * pcp lists are returned to the correct freelist.
 			 */
-			set_freepage_migratetype(page, new_type);
+			set_freepage_migratetype(page, buddy_type);
 
 			trace_mm_page_alloc_extfrag(page, order, current_order,
 				start_migratetype, migratetype);
_

Patches currently in -mm which might be from vbabka@suse.cz are

origin.patch
mm-compaction-fix-wrong-order-check-in-compact_finished.patch
mm-compaction-stop-the-isolation-when-we-isolate-enough-freepage.patch
mm-internalh-dont-split-printk-call-in-two.patch
mm-page_allocc-pull-out-init-code-from-build_all_zonelists.patch
mm-mm_initc-mark-mminit_verify_zonelist-as-__init.patch
mm-mm_initc-mark-mminit_loglevel-__meminitdata.patch
kernel-cpusetc-mark-cpuset_init_current_mems_allowed-as-__init.patch
mm-fix-negative-nr_isolated-counts.patch
zram-fix-umount-reset_store-mount-race-condition.patch

