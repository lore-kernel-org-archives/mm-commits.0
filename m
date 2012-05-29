From: akpm@linux-foundation.org
Subject: [folded] mm-compaction-handle-incorrect-migrate_unmovable-type-pageblocks-part-2.patch removed from -mm tree
Date: Tue, 29 May 2012 14:44:11 -0700
Message-ID: <20120529214411.EE043A021B@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:41064 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084Ab2E2VoN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 29 May 2012 17:44:13 -0400
Received: by qabg24 with SMTP id g24so294311qab.1
        for <mm-commits@vger.kernel.org>; Tue, 29 May 2012 14:44:12 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: b.zolnierkie@samsung.com, kyungmin.park@samsung.com, m.szyprowski@samsung.com, mgorman@suse.de, minchan@kernel.org, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-compaction-handle-incorrect-migrate_unmovable-type-pageblocks-part-2
has been removed from the -mm tree.  Its filename was
     mm-compaction-handle-incorrect-migrate_unmovable-type-pageblocks-part-2.patch

This patch was dropped because it was folded into mm-compaction-handle-incorrect-migrate_unmovable-type-pageblocks.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: mm-compaction-handle-incorrect-migrate_unmovable-type-pageblocks-part-2

- document rescue_unmovable_pageblock()

- enum result_smt -> enum_smt_result

- fix suitable_migration_target() documentation

- add comment about zeroing cc->nr_pageblocks_skipped

- fix FAIL_UNMOVABLE_TARGET handling in isolate_freepages()


Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   38 ++++++++++++++++++++++++++------------
 1 file changed, 26 insertions(+), 12 deletions(-)

diff -puN mm/compaction.c~mm-compaction-handle-incorrect-migrate_unmovable-type-pageblocks-part-2 mm/compaction.c
--- a/mm/compaction.c~mm-compaction-handle-incorrect-migrate_unmovable-type-pageblocks-part-2
+++ a/mm/compaction.c
@@ -358,6 +358,10 @@ isolate_migratepages_range(struct zone *
 
 #endif /* CONFIG_COMPACTION || CONFIG_CMA */
 #ifdef CONFIG_COMPACTION
+/*
+ * Returns true if MIGRATE_UNMOVABLE pageblock was successfully
+ * converted to MIGRATE_MOVABLE type, false otherwise.
+ */
 static bool rescue_unmovable_pageblock(struct page *page)
 {
 	unsigned long pfn, start_pfn, end_pfn;
@@ -397,14 +401,18 @@ static bool rescue_unmovable_pageblock(s
 	return true;
 }
 
-enum result_smt {
+enum smt_result {
 	GOOD_AS_MIGRATION_TARGET,
-	FAIL_UNMOVABLE,
-	FAIL_ETC_REASON,
+	FAIL_UNMOVABLE_TARGET,
+	FAIL_BAD_TARGET,
 };
 
-/* Returns true if the page is within a block suitable for migration to */
-static enum result_smt suitable_migration_target(struct page *page,
+/*
+ * Returns GOOD_AS_MIGRATION_TARGET if the page is within a block
+ * suitable for migration to, FAIL_UNMOVABLE_TARGET if the page
+ * is within a MIGRATE_UNMOVABLE block, FAIL_BAD_TARGET otherwise.
+ */
+static enum smt_result suitable_migration_target(struct page *page,
 				      struct compact_control *cc)
 {
 
@@ -412,7 +420,7 @@ static enum result_smt suitable_migratio
 
 	/* Don't interfere with memory hot-remove or the min_free_kbytes blocks */
 	if (migratetype == MIGRATE_ISOLATE || migratetype == MIGRATE_RESERVE)
-		return FAIL_ETC_REASON;
+		return FAIL_BAD_TARGET;
 
 	/* If the page is a large free page, then allow migration */
 	if (PageBuddy(page) && page_order(page) >= pageblock_order)
@@ -425,7 +433,7 @@ static enum result_smt suitable_migratio
 
 	if (cc->mode == COMPACT_ASYNC_MOVABLE &&
 	    migratetype == MIGRATE_UNMOVABLE)
-		return FAIL_UNMOVABLE;
+		return FAIL_UNMOVABLE_TARGET;
 
 	if (cc->mode != COMPACT_ASYNC_MOVABLE &&
 	    migratetype == MIGRATE_UNMOVABLE &&
@@ -433,7 +441,7 @@ static enum result_smt suitable_migratio
 		return GOOD_AS_MIGRATION_TARGET;
 
 	/* Otherwise skip the block */
-	return FAIL_ETC_REASON;
+	return FAIL_BAD_TARGET;
 }
 
 /*
@@ -466,6 +474,11 @@ static void isolate_freepages(struct zon
 
 	zone_end_pfn = zone->zone_start_pfn + zone->spanned_pages;
 
+	/*
+	 * isolate_freepages() may be called more than once during
+	 * compact_zone_order() run and we want only the most recent
+	 * count.
+	 */
 	cc->nr_pageblocks_skipped = 0;
 
 	/*
@@ -476,7 +489,7 @@ static void isolate_freepages(struct zon
 	for (; pfn > low_pfn && cc->nr_migratepages > nr_freepages;
 					pfn -= pageblock_nr_pages) {
 		unsigned long isolated;
-		enum result_smt ret;
+		enum smt_result ret;
 
 		if (!pfn_valid(pfn))
 			continue;
@@ -495,7 +508,7 @@ static void isolate_freepages(struct zon
 		/* Check the block is suitable for migration */
 		ret = suitable_migration_target(page, cc);
 		if (ret != GOOD_AS_MIGRATION_TARGET) {
-			if (ret == FAIL_UNMOVABLE)
+			if (ret == FAIL_UNMOVABLE_TARGET)
 				cc->nr_pageblocks_skipped++;
 			continue;
 		}
@@ -513,7 +526,8 @@ static void isolate_freepages(struct zon
 			isolated = isolate_freepages_block(pfn, end_pfn,
 							   freelist, false);
 			nr_freepages += isolated;
-		}
+		} else if (ret == FAIL_UNMOVABLE_TARGET)
+			cc->nr_pageblocks_skipped++;
 		spin_unlock_irqrestore(&zone->lock, flags);
 
 		/*
@@ -745,7 +759,7 @@ static int compact_zone(struct zone *zon
 
 		nr_migrate = cc->nr_migratepages;
 		err = migrate_pages(&cc->migratepages, compaction_alloc,
-			(unsigned long)cc, false,
+			(unsigned long)&cc->freepages, false,
 			(cc->mode == COMPACT_SYNC) ? MIGRATE_SYNC_LIGHT
 						      : MIGRATE_ASYNC);
 		update_nr_listpages(cc);
_

Patches currently in -mm which might be from b.zolnierkie@samsung.com are

mm-compaction-handle-incorrect-migrate_unmovable-type-pageblocks.patch

