From: akpm@linux-foundation.org
Subject: [merged] mm-reduce-the-amount-of-work-done-when-updating-min_free_kbytes.patch removed from -mm tree
Date: Wed, 11 Jan 2012 13:26:35 -0800
Message-ID: <20120111212635.9DEFD10004D@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:58471 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758145Ab2AKV0g (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2012 16:26:36 -0500
Received: by mail-gy0-f202.google.com with SMTP id r15so136887ghr.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2012 13:26:35 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: reduce the amount of work done when updating min_free_kbytes
has been removed from the -mm tree.  Its filename was
     mm-reduce-the-amount-of-work-done-when-updating-min_free_kbytes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: reduce the amount of work done when updating min_free_kbytes

When min_free_kbytes is updated, some pageblocks are marked
MIGRATE_RESERVE.  Ordinarily, this work is unnoticable as it happens early
in boot but on large machines with 1TB of memory, this has been reported
to delay boot times, probably due to the NUMA distances involved.

The bulk of the work is due to calling calling pageblock_is_reserved() an
unnecessary amount of times and accessing far more struct page metadata
than is necessary.  This patch significantly reduces the amount of work
done by setup_zone_migrate_reserve() improving boot times on 1TB machines.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   40 ++++++++++++++++++++++++----------------
 1 file changed, 24 insertions(+), 16 deletions(-)

diff -puN mm/page_alloc.c~mm-reduce-the-amount-of-work-done-when-updating-min_free_kbytes mm/page_alloc.c
--- a/mm/page_alloc.c~mm-reduce-the-amount-of-work-done-when-updating-min_free_kbytes
+++ a/mm/page_alloc.c
@@ -3388,25 +3388,33 @@ static void setup_zone_migrate_reserve(s
 		if (page_to_nid(page) != zone_to_nid(zone))
 			continue;
 
-		/* Blocks with reserved pages will never free, skip them. */
-		block_end_pfn = min(pfn + pageblock_nr_pages, end_pfn);
-		if (pageblock_is_reserved(pfn, block_end_pfn))
-			continue;
-
 		block_migratetype = get_pageblock_migratetype(page);
 
-		/* If this block is reserved, account for it */
-		if (reserve > 0 && block_migratetype == MIGRATE_RESERVE) {
-			reserve--;
-			continue;
-		}
+		/* Only test what is necessary when the reserves are not met */
+		if (reserve > 0) {
+			/*
+			 * Blocks with reserved pages will never free, skip
+			 * them.
+			 */
+			block_end_pfn = min(pfn + pageblock_nr_pages, end_pfn);
+			if (pageblock_is_reserved(pfn, block_end_pfn))
+				continue;
 
-		/* Suitable for reserving if this block is movable */
-		if (reserve > 0 && block_migratetype == MIGRATE_MOVABLE) {
-			set_pageblock_migratetype(page, MIGRATE_RESERVE);
-			move_freepages_block(zone, page, MIGRATE_RESERVE);
-			reserve--;
-			continue;
+			/* If this block is reserved, account for it */
+			if (block_migratetype == MIGRATE_RESERVE) {
+				reserve--;
+				continue;
+			}
+
+			/* Suitable for reserving if this block is movable */
+			if (block_migratetype == MIGRATE_MOVABLE) {
+				set_pageblock_migratetype(page,
+							MIGRATE_RESERVE);
+				move_freepages_block(zone, page,
+							MIGRATE_RESERVE);
+				reserve--;
+				continue;
+			}
 		}
 
 		/*
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
linux-next.patch
mm-compaction-allow-compaction-to-isolate-dirty-pages.patch
mm-compaction-use-synchronous-compaction-for-proc-sys-vm-compact_memory.patch
mm-vmscan-check-if-we-isolated-a-compound-page-during-lumpy-scan.patch
mm-vmscan-do-not-oom-if-aborting-reclaim-to-start-compaction.patch
mm-compaction-determine-if-dirty-pages-can-be-migrated-without-blocking-within-migratepage.patch
mm-compaction-make-isolate_lru_page-filter-aware-again.patch
mm-page-allocator-do-not-call-direct-reclaim-for-thp-allocations-while-compaction-is-deferred.patch
mm-compaction-introduce-sync-light-migration-for-use-by-compaction.patch
mm-compaction-introduce-sync-light-migration-for-use-by-compaction-fix.patch
mm-compaction-introduce-sync-light-migration-for-use-by-compaction-fix-fix.patch
mm-compaction-introduce-sync-light-migration-for-use-by-compaction-fix-fix-3.patch
mm-vmscan-when-reclaiming-for-compaction-ensure-there-are-sufficient-free-pages-available.patch
mm-vmscan-check-if-reclaim-should-really-abort-even-if-compaction_ready-is-true-for-one-zone.patch
radix_tree-take-radix_tree_path-off-stack.patch
radix_tree-take-radix_tree_path-off-stack-expand-comment-on-optimization.patch

