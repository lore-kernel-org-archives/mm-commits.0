From: akpm@linux-foundation.org
Subject: - remove-page_group_by_mobility.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:34:58 -0700
Message-ID: <200710162034.l9GKYwtW015007@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44452 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966215AbXJPVsz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:48:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, apw@shadowen.org, mm-commits@vger.kernel.org


The patch titled
     remove PAGE_GROUP_BY_MOBILITY
has been removed from the -mm tree.  Its filename was
     remove-page_group_by_mobility.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: remove PAGE_GROUP_BY_MOBILITY
From: Mel Gorman <mel@csn.ul.ie>

Grouping pages by mobility can be disabled at compile-time. This was
considered undesirable by a number of people. However, in the current stack of
patches, it is not a simple case of just dropping the configurable patch as it
would cause merge conflicts.  This patch backs out the configuration option.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    9 --------
 init/Kconfig           |   13 ------------
 mm/page_alloc.c        |   42 +--------------------------------------
 3 files changed, 2 insertions(+), 62 deletions(-)

diff -puN include/linux/mmzone.h~remove-page_group_by_mobility include/linux/mmzone.h
--- a/include/linux/mmzone.h~remove-page_group_by_mobility
+++ a/include/linux/mmzone.h
@@ -33,21 +33,12 @@
  */
 #define PAGE_ALLOC_COSTLY_ORDER 3
 
-#ifdef CONFIG_PAGE_GROUP_BY_MOBILITY
 #define MIGRATE_UNMOVABLE     0
 #define MIGRATE_RECLAIMABLE   1
 #define MIGRATE_MOVABLE       2
 #define MIGRATE_HIGHATOMIC    3
 #define MIGRATE_RESERVE       4
 #define MIGRATE_TYPES         5
-#else
-#define MIGRATE_UNMOVABLE     0
-#define MIGRATE_UNRECLAIMABLE 0
-#define MIGRATE_MOVABLE       0
-#define MIGRATE_HIGHATOMIC    0
-#define MIGRATE_RESERVE       0
-#define MIGRATE_TYPES         1
-#endif
 
 #define for_each_migratetype_order(order, type) \
 	for (order = 0; order < MAX_ORDER; order++) \
diff -puN init/Kconfig~remove-page_group_by_mobility init/Kconfig
--- a/init/Kconfig~remove-page_group_by_mobility
+++ a/init/Kconfig
@@ -607,19 +607,6 @@ config BASE_SMALL
 	default 0 if BASE_FULL
 	default 1 if !BASE_FULL
 
-config PAGE_GROUP_BY_MOBILITY
-	bool "Group pages based on their mobility in the page allocator"
-	def_bool y
-	help
-	  The standard allocator will fragment memory over time which means
-	  that high order allocations will fail even if kswapd is running. If
-	  this option is set, the allocator will try and group page types
-	  based on their ability to migrate or reclaim. This is a best effort
-	  attempt at lowering fragmentation which a few workloads care about.
-	  The loss is a more complex allocator that may perform slower. If
-	  you are interested in working with large pages, say Y and set
-	  /proc/sys/vm/min_free_bytes to 16374. Otherwise say N
-
 menuconfig MODULES
 	bool "Enable loadable module support"
 	help
diff -puN mm/page_alloc.c~remove-page_group_by_mobility mm/page_alloc.c
--- a/mm/page_alloc.c~remove-page_group_by_mobility
+++ a/mm/page_alloc.c
@@ -158,7 +158,6 @@ int nr_node_ids __read_mostly = MAX_NUMN
 EXPORT_SYMBOL(nr_node_ids);
 #endif
 
-#ifdef CONFIG_PAGE_GROUP_BY_MOBILITY
 int page_group_by_mobility_disabled __read_mostly;
 
 static inline int get_pageblock_migratetype(struct page *page)
@@ -192,22 +191,6 @@ static inline int allocflags_to_migratet
 		((gfp_flags & __GFP_RECLAIMABLE) != 0);
 }
 
-#else
-static inline int get_pageblock_migratetype(struct page *page)
-{
-	return MIGRATE_UNMOVABLE;
-}
-
-static void set_pageblock_migratetype(struct page *page, int migratetype)
-{
-}
-
-static inline int allocflags_to_migratetype(gfp_t gfp_flags, int order)
-{
-	return MIGRATE_UNMOVABLE;
-}
-#endif /* CONFIG_PAGE_GROUP_BY_MOBILITY */
-
 #ifdef CONFIG_DEBUG_VM
 static int page_outside_zone_boundaries(struct zone *zone, struct page *page)
 {
@@ -718,7 +701,6 @@ static struct page *__rmqueue_smallest(s
 }
 
 
-#ifdef CONFIG_PAGE_GROUP_BY_MOBILITY
 /*
  * This array describes the order lists are fallen back to when
  * the free lists for the desirable migrate type are depleted
@@ -750,7 +732,7 @@ int move_freepages(struct zone *zone,
 	 * CONFIG_HOLES_IN_ZONE is set. This bug check is probably redundant
 	 * anyway as we check zone boundaries in move_freepages_block().
 	 * Remove at a later date when no bug reports exist related to
-	 * CONFIG_PAGE_GROUP_BY_MOBILITY
+	 * grouping pages by mobility
 	 */
 	BUG_ON(page_zone(start_page) != page_zone(end_page));
 #endif
@@ -899,13 +881,6 @@ retry:
 	/* Use MIGRATE_RESERVE rather than fail an allocation */
 	return __rmqueue_smallest(zone, order, MIGRATE_RESERVE);
 }
-#else
-static struct page *__rmqueue_fallback(struct zone *zone, int order,
-						int start_migratetype)
-{
-	return NULL;
-}
-#endif /* CONFIG_PAGE_GROUP_BY_MOBILITY */
 
 /*
  * Do the hard work of removing an element from the buddy allocator.
@@ -1033,7 +1008,6 @@ void mark_free_pages(struct zone *zone)
 }
 #endif /* CONFIG_PM */
 
-#if defined(CONFIG_HIBERNATION) || defined(CONFIG_PAGE_GROUP_BY_MOBILITY)
 /*
  * Spill all of this CPU's per-cpu pages back into the buddy allocator.
  */
@@ -1064,9 +1038,6 @@ void drain_all_local_pages(void)
 
 	smp_call_function(smp_drain_local_pages, NULL, 0, 1);
 }
-#else
-void drain_all_local_pages(void) {}
-#endif /* CONFIG_HIBERNATION || CONFIG_PAGE_GROUP_BY_MOBILITY */
 
 /*
  * Free a 0-order page
@@ -1157,7 +1128,6 @@ again:
 				goto failed;
 		}
 
-#ifdef CONFIG_PAGE_GROUP_BY_MOBILITY
 		/* Find a page of the appropriate migrate type */
 		list_for_each_entry(page, &pcp->list, lru)
 			if (page_private(page) == migratetype)
@@ -1169,9 +1139,6 @@ again:
 					pcp->batch, &pcp->list, migratetype);
 			page = list_entry(pcp->list.next, struct page, lru);
 		}
-#else
-		page = list_entry(pcp->list.next, struct page, lru);
-#endif /* CONFIG_PAGE_GROUP_BY_MOBILITY */
 
 		list_del(&page->lru);
 		pcp->count--;
@@ -2525,7 +2492,6 @@ static inline unsigned long wait_table_b
 
 #define LONG_ALIGN(x) (((x)+(sizeof(long))-1)&~((sizeof(long))-1))
 
-#ifdef CONFIG_PAGE_GROUP_BY_MOBILITY
 /*
  * Mark a number of MAX_ORDER_NR_PAGES blocks as MIGRATE_RESERVE. The number
  * of blocks reserved is based on zone->pages_min. The memory within the
@@ -2579,11 +2545,7 @@ static void setup_zone_migrate_reserve(s
 		}
 	}
 }
-#else
-static inline void setup_zone_migrate_reserve(struct zone *zone)
-{
-}
-#endif /* CONFIG_PAGE_GROUP_BY_MOBILITY */
+
 /*
  * Initially all pages are reserved - free ones are freed
  * up by free_all_bootmem() once the early boot process is
_

Patches currently in -mm which might be from mel@csn.ul.ie are

origin.patch
ext2-reservations.patch
page-owner-tracking-leak-detector.patch
add-debugging-aid-for-memory-initialisation-problems.patch
