From: akpm@linux-foundation.org
Subject: [to-be-updated] mm-compaction-memory-compaction-core-fix.patch removed from -mm tree
Date: Thu, 22 Apr 2010 12:06:34 -0700
Message-ID: <201004221906.o3MJ6YWt002128@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51723 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753960Ab0DVTO7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 22 Apr 2010 15:14:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, aarcange@redhat.com, cl@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     mm: compaction: various fixes to the patch 'Memory compaction core'
has been removed from the -mm tree.  Its filename was
     mm-compaction-memory-compaction-core-fix.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: compaction: various fixes to the patch 'Memory compaction core'
From: Mel Gorman <mel@csn.ul.ie>

 o Use unsigned long instead of int for page counters
 o Simplify logic in isolate_freepages_block() and isolate_migratepages()
 o Optimise isolate_freepages_block to use a cursor
 o Use bool instead of int for true/false
 o Clarify some comments
 o Improve control flow in isolate_migratepages()
 o Add newlines for clarity
 o Simply loop in compact_zones

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Cc: Rik van Riel <riel@redhat.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   81 ++++++++++++++++++++++++++--------------------
 mm/page_alloc.c |    2 -
 2 files changed, 47 insertions(+), 36 deletions(-)

diff -puN mm/Kconfig~mm-compaction-memory-compaction-core-fix mm/Kconfig
diff -puN mm/compaction.c~mm-compaction-memory-compaction-core-fix mm/compaction.c
--- a/mm/compaction.c~mm-compaction-memory-compaction-core-fix
+++ a/mm/compaction.c
@@ -36,10 +36,10 @@ struct compact_control {
 	struct zone *zone;
 };
 
-static int release_freepages(struct list_head *freelist)
+static unsigned long release_freepages(struct list_head *freelist)
 {
 	struct page *page, *next;
-	int count = 0;
+	unsigned long count = 0;
 
 	list_for_each_entry_safe(page, next, freelist, lru) {
 		list_del(&page->lru);
@@ -51,28 +51,33 @@ static int release_freepages(struct list
 }
 
 /* Isolate free pages onto a private freelist. Must hold zone->lock */
-static int isolate_freepages_block(struct zone *zone,
+static unsigned long isolate_freepages_block(struct zone *zone,
 				unsigned long blockpfn,
 				struct list_head *freelist)
 {
 	unsigned long zone_end_pfn, end_pfn;
 	int total_isolated = 0;
+	struct page *cursor;
 
 	/* Get the last PFN we should scan for free pages at */
 	zone_end_pfn = zone->zone_start_pfn + zone->spanned_pages;
-	end_pfn = blockpfn + pageblock_nr_pages;
-	if (end_pfn > zone_end_pfn)
-		end_pfn = zone_end_pfn;
+	end_pfn = min(blockpfn + pageblock_nr_pages, zone_end_pfn);
 
-	/* Isolate free pages. This assumes the block is valid */
+	/* Find the first usable PFN in the block to initialse page cursor */
 	for (; blockpfn < end_pfn; blockpfn++) {
-		struct page *page;
+		if (pfn_valid_within(blockpfn))
+			break;
+	}
+	cursor = pfn_to_page(blockpfn);
+
+	/* Isolate free pages. This assumes the block is valid */
+	for (; blockpfn < end_pfn; blockpfn++, cursor++) {
 		int isolated, i;
+		struct page *page = cursor;
 
 		if (!pfn_valid_within(blockpfn))
 			continue;
 
-		page = pfn_to_page(blockpfn);
 		if (!PageBuddy(page))
 			continue;
 
@@ -85,38 +90,40 @@ static int isolate_freepages_block(struc
 		}
 
 		/* If a page was split, advance to the end of it */
-		if (isolated)
+		if (isolated) {
 			blockpfn += isolated - 1;
+			cursor += isolated - 1;
+		}
 	}
 
 	return total_isolated;
 }
 
-/* Returns 1 if the page is within a block suitable for migration to */
-static int suitable_migration_target(struct page *page)
+/* Returns true if the page is within a block suitable for migration to */
+static bool suitable_migration_target(struct page *page)
 {
 
 	int migratetype = get_pageblock_migratetype(page);
 
 	/* Don't interfere with memory hot-remove or the min_free_kbytes blocks */
 	if (migratetype == MIGRATE_ISOLATE || migratetype == MIGRATE_RESERVE)
-		return 0;
+		return false;
 
 	/* If the page is a large free page, then allow migration */
 	if (PageBuddy(page) && page_order(page) >= pageblock_order)
-		return 1;
+		return true;
 
 	/* If the block is MIGRATE_MOVABLE, allow migration */
 	if (migratetype == MIGRATE_MOVABLE)
-		return 1;
+		return true;
 
 	/* Otherwise skip the block */
-	return 0;
+	return false;
 }
 
 /*
  * Based on information in the current compact_control, find blocks
- * suitable for isolating free pages from
+ * suitable for isolating free pages from and then isolate them.
  */
 static void isolate_freepages(struct zone *zone,
 				struct compact_control *cc)
@@ -139,7 +146,7 @@ static void isolate_freepages(struct zon
 	spin_lock_irqsave(&zone->lock, flags);
 	for (; pfn > low_pfn && cc->nr_migratepages > nr_freepages;
 					pfn -= pageblock_nr_pages) {
-		int isolated;
+		unsigned long isolated;
 
 		if (!pfn_valid(pfn))
 			continue;
@@ -195,7 +202,7 @@ static void acct_isolated(struct zone *z
 }
 
 /* Similar to reclaim, but different enough that they don't share logic */
-static int too_many_isolated(struct zone *zone)
+static bool too_many_isolated(struct zone *zone)
 {
 
 	unsigned long inactive, isolated;
@@ -216,16 +223,12 @@ static unsigned long isolate_migratepage
 					struct compact_control *cc)
 {
 	unsigned long low_pfn, end_pfn;
-	struct list_head *migratelist;
-
-	low_pfn = cc->migrate_pfn;
-	migratelist = &cc->migratepages;
+	struct list_head *migratelist = &cc->migratepages;
 
 	/* Do not scan outside zone boundaries */
-	if (low_pfn < zone->zone_start_pfn)
-		low_pfn = zone->zone_start_pfn;
+	low_pfn = max(cc->migrate_pfn, zone->zone_start_pfn);
 
-	/* Setup to scan one block but not past where we are migrating to */
+	/* Only scan within a pageblock boundary */
 	end_pfn = ALIGN(low_pfn + pageblock_nr_pages, pageblock_nr_pages);
 
 	/* Do not cross the free scanner or scan within a memory hole */
@@ -234,7 +237,11 @@ static unsigned long isolate_migratepage
 		return 0;
 	}
 
-	/* Do not isolate the world */
+	/*
+	 * Ensure that there are not too many pages isolated from the LRU
+	 * list by either parallel reclaimers or compaction. If there are,
+	 * delay for some time until fewer pages are isolated
+	 */
 	while (unlikely(too_many_isolated(zone))) {
 		congestion_wait(BLK_RW_ASYNC, HZ/10);
 
@@ -257,12 +264,14 @@ static unsigned long isolate_migratepage
 		}
 
 		/* Try isolate the page */
-		if (__isolate_lru_page(page, ISOLATE_BOTH, 0) == 0) {
-			del_page_from_lru_list(zone, page, page_lru(page));
-			list_add(&page->lru, migratelist);
-			mem_cgroup_del_lru(page);
-			cc->nr_migratepages++;
-		}
+		if (__isolate_lru_page(page, ISOLATE_BOTH, 0) != 0)
+			continue;
+
+		/* Successfully isolated */
+		del_page_from_lru_list(zone, page, page_lru(page));
+		list_add(&page->lru, migratelist);
+		mem_cgroup_del_lru(page);
+		cc->nr_migratepages++;
 
 		/* Avoid isolating too much */
 		if (cc->nr_migratepages == COMPACT_CLUSTER_MAX)
@@ -313,6 +322,7 @@ static void update_nr_listpages(struct c
 	int nr_migratepages = 0;
 	int nr_freepages = 0;
 	struct page *page;
+
 	list_for_each_entry(page, &cc->migratepages, lru)
 		nr_migratepages++;
 	list_for_each_entry(page, &cc->freepages, lru)
@@ -337,7 +347,7 @@ static inline int compact_finished(struc
 
 static int compact_zone(struct zone *zone, struct compact_control *cc)
 {
-	int ret = COMPACT_INCOMPLETE;
+	int ret;
 
 	/* Setup to move all movable pages to the end of the zone */
 	cc->migrate_pfn = zone->zone_start_pfn;
@@ -346,8 +356,9 @@ static int compact_zone(struct zone *zon
 
 	migrate_prep();
 
-	for (; ret == COMPACT_INCOMPLETE; ret = compact_finished(zone, cc)) {
+	while ((ret = compact_finished(zone, cc)) == COMPACT_INCOMPLETE) {
 		unsigned long nr_migrate, nr_remaining;
+
 		if (!isolate_migratepages(zone, cc))
 			continue;
 
diff -puN mm/page_alloc.c~mm-compaction-memory-compaction-core-fix mm/page_alloc.c
--- a/mm/page_alloc.c~mm-compaction-memory-compaction-core-fix
+++ a/mm/page_alloc.c
@@ -1222,7 +1222,7 @@ int split_free_page(struct page *page)
 	zone = page_zone(page);
 	order = page_order(page);
 
-	/* Obey watermarks or the system could deadlock */
+	/* Obey watermarks as if the page was being allocated */
 	watermark = low_wmark_pages(zone) + (1 << order);
 	if (!zone_watermark_ok(zone, 0, watermark, 0, 0))
 		return 0;
_

Patches currently in -mm which might be from mel@csn.ul.ie are

linux-next.patch
hugetlb-fix-infinite-loop-in-get_futex_key-when-backed-by-huge-pages.patch
hugetlb-fix-infinite-loop-in-get_futex_key-when-backed-by-huge-pages-fix.patch
hugetlbfs-kill-applications-that-use-map_noreserve-with-sigbus-instead-of-oom-killer.patch
page-allocator-reduce-fragmentation-in-buddy-allocator-by-adding-buddies-that-are-merging-to-the-tail-of-the-free-lists.patch
mempolicy-remove-redundant-code.patch
mm-default-to-node-zonelist-ordering-when-nodes-have-only-lowmem.patch
mm-compaction-memory-compaction-core-fix.patch
mm-compaction-memory-compaction-core-fix-page-buddy-can-go-away-before-reading-page_order-while-isolating-pages-for-migration.patch
mm-compaction-memory-compaction-core-map-free-pages-in-the-address-space-after-they-get-split-for-compaction.patch
mm-compaction-add-proc-trigger-for-memory-compaction.patch
mm-compaction-add-proc-trigger-for-memory-compaction-fix.patch
mm-compaction-add-proc-trigger-for-memory-compaction-fix-fix.patch
mm-compaction-add-sys-trigger-for-per-node-memory-compaction.patch
mm-compaction-direct-compact-when-a-high-order-allocation-fails.patch
mm-compaction-direct-compact-when-a-high-order-allocation-fails-reject-fix.patch
mm-compaction-add-a-tunable-that-decides-when-memory-should-be-compacted-and-when-it-should-be-reclaimed.patch
vmstat-fix-build-errors-when-proc_fs-is-disabled.patch
vmstat-fix-build-errors-when-proc_fs-is-disabled-checkpatch-fixes.patch
mm-migration-allow-the-migration-of-pageswapcache-pages.patch
mm-migration-allow-the-migration-of-pageswapcache-pages-fix.patch
mm-compaction-do-not-display-compaction-related-stats-when-config_compaction.patch
mm-compaction-do-not-display-compaction-related-stats-when-config_compaction-fix.patch
mm-compaction-do-not-display-compaction-related-stats-when-config_compaction-fix-fix-2.patch
mm-compaction-do-not-display-compaction-related-stats-when-config_compaction-fix-fix-2-do-not-compact-twice.patch
mm-compaction-do-not-display-compaction-related-stats-when-config_co-mpaction-reject-fixpatch-added-to-mm-tree.patch
mm-introduce-free_pages_prepare.patch
mm-introduce-free_pages_prepare-fix.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
numa-add-generic-percpu-var-numa_node_id-implementation.patch
numa-x86_64-use-generic-percpu-var-numa_node_id-implementation.patch
numa-ia64-use-generic-percpu-var-numa_node_id-implementation.patch
numa-introduce-numa_mem_id-effective-local-memory-node-id.patch
numa-ia64-support-numa_mem_id-for-memoryless-nodes.patch
numa-slab-use-numa_mem_id-for-slab-local-memory-node.patch
numa-in-kernel-profiling-use-cpu_to_mem-for-per-cpu-allocations.patch
numa-update-documentation-vm-numa-add-memoryless-node-info.patch
add-debugging-aid-for-memory-initialisation-problems.patch

