From: akpm@linux-foundation.org
Subject: [merged] mm-compaction-acquire-the-zone-lock-as-late-as-possible.patch removed from -mm tree
Date: Tue, 09 Oct 2012 11:12:19 -0700
Message-ID: <20121009181220.431D05C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:41968 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756748Ab2JISMX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 14:12:23 -0400
Received: by mail-bk0-f74.google.com with SMTP id q16so362365bkw.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 11:12:22 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, aquini@redhat.com, avi@redhat.com, minchan@kernel.org, peter.ujfalusi@ti.com, richard@arachsys.com, riel@redhat.com, shli@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: compaction: acquire the zone->lock as late as possible
has been removed from the -mm tree.  Its filename was
     mm-compaction-acquire-the-zone-lock-as-late-as-possible.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: compaction: acquire the zone->lock as late as possible

Compaction's free scanner acquires the zone->lock when checking for
PageBuddy pages and isolating them.  It does this even if there are no
PageBuddy pages in the range.

This patch defers acquiring the zone lock for as long as possible.  In the
event there are no free pages in the pageblock then the lock will not be
acquired at all which reduces contention on zone->lock.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Richard Davies <richard@arachsys.com>
Cc: Shaohua Li <shli@kernel.org>
Cc: Avi Kivity <avi@redhat.com>
Acked-by: Rafael Aquini <aquini@redhat.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Tested-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |  140 ++++++++++++++++++++++++----------------------
 1 file changed, 76 insertions(+), 64 deletions(-)

diff -puN mm/compaction.c~mm-compaction-acquire-the-zone-lock-as-late-as-possible mm/compaction.c
--- a/mm/compaction.c~mm-compaction-acquire-the-zone-lock-as-late-as-possible
+++ a/mm/compaction.c
@@ -93,6 +93,27 @@ static inline bool compact_trylock_irqsa
 	return compact_checklock_irqsave(lock, flags, false, cc);
 }
 
+/* Returns true if the page is within a block suitable for migration to */
+static bool suitable_migration_target(struct page *page)
+{
+	int migratetype = get_pageblock_migratetype(page);
+
+	/* Don't interfere with memory hot-remove or the min_free_kbytes blocks */
+	if (migratetype == MIGRATE_ISOLATE || migratetype == MIGRATE_RESERVE)
+		return false;
+
+	/* If the page is a large free page, then allow migration */
+	if (PageBuddy(page) && page_order(page) >= pageblock_order)
+		return true;
+
+	/* If the block is MIGRATE_MOVABLE or MIGRATE_CMA, allow migration */
+	if (migrate_async_suitable(migratetype))
+		return true;
+
+	/* Otherwise skip the block */
+	return false;
+}
+
 static void compact_capture_page(struct compact_control *cc)
 {
 	unsigned long flags;
@@ -153,38 +174,56 @@ static void compact_capture_page(struct 
  * pages inside of the pageblock (even though it may still end up isolating
  * some pages).
  */
-static unsigned long isolate_freepages_block(unsigned long blockpfn,
+static unsigned long isolate_freepages_block(struct compact_control *cc,
+				unsigned long blockpfn,
 				unsigned long end_pfn,
 				struct list_head *freelist,
 				bool strict)
 {
 	int nr_scanned = 0, total_isolated = 0;
 	struct page *cursor;
+	unsigned long nr_strict_required = end_pfn - blockpfn;
+	unsigned long flags;
+	bool locked = false;
 
 	cursor = pfn_to_page(blockpfn);
 
-	/* Isolate free pages. This assumes the block is valid */
+	/* Isolate free pages. */
 	for (; blockpfn < end_pfn; blockpfn++, cursor++) {
 		int isolated, i;
 		struct page *page = cursor;
 
-		if (!pfn_valid_within(blockpfn)) {
-			if (strict)
-				return 0;
-			continue;
-		}
 		nr_scanned++;
+		if (!pfn_valid_within(blockpfn))
+			continue;
+		if (!PageBuddy(page))
+			continue;
+
+		/*
+		 * The zone lock must be held to isolate freepages.
+		 * Unfortunately this is a very coarse lock and can be
+		 * heavily contended if there are parallel allocations
+		 * or parallel compactions. For async compaction do not
+		 * spin on the lock and we acquire the lock as late as
+		 * possible.
+		 */
+		locked = compact_checklock_irqsave(&cc->zone->lock, &flags,
+								locked, cc);
+		if (!locked)
+			break;
+
+		/* Recheck this is a suitable migration target under lock */
+		if (!strict && !suitable_migration_target(page))
+			break;
 
-		if (!PageBuddy(page)) {
-			if (strict)
-				return 0;
+		/* Recheck this is a buddy page under lock */
+		if (!PageBuddy(page))
 			continue;
-		}
 
 		/* Found a free page, break it into order-0 pages */
 		isolated = split_free_page(page);
 		if (!isolated && strict)
-			return 0;
+			break;
 		total_isolated += isolated;
 		for (i = 0; i < isolated; i++) {
 			list_add(&page->lru, freelist);
@@ -199,6 +238,18 @@ static unsigned long isolate_freepages_b
 	}
 
 	trace_mm_compaction_isolate_freepages(nr_scanned, total_isolated);
+
+	/*
+	 * If strict isolation is requested by CMA then check that all the
+	 * pages requested were isolated. If there were any failures, 0 is
+	 * returned and CMA will fail.
+	 */
+	if (strict && nr_strict_required != total_isolated)
+		total_isolated = 0;
+
+	if (locked)
+		spin_unlock_irqrestore(&cc->zone->lock, flags);
+
 	return total_isolated;
 }
 
@@ -218,12 +269,17 @@ static unsigned long isolate_freepages_b
 unsigned long
 isolate_freepages_range(unsigned long start_pfn, unsigned long end_pfn)
 {
-	unsigned long isolated, pfn, block_end_pfn, flags;
+	unsigned long isolated, pfn, block_end_pfn;
 	struct zone *zone = NULL;
 	LIST_HEAD(freelist);
 
+	/* cc needed for isolate_freepages_block to acquire zone->lock */
+	struct compact_control cc = {
+		.sync = true,
+	};
+
 	if (pfn_valid(start_pfn))
-		zone = page_zone(pfn_to_page(start_pfn));
+		cc.zone = zone = page_zone(pfn_to_page(start_pfn));
 
 	for (pfn = start_pfn; pfn < end_pfn; pfn += isolated) {
 		if (!pfn_valid(pfn) || zone != page_zone(pfn_to_page(pfn)))
@@ -236,10 +292,8 @@ isolate_freepages_range(unsigned long st
 		block_end_pfn = ALIGN(pfn + 1, pageblock_nr_pages);
 		block_end_pfn = min(block_end_pfn, end_pfn);
 
-		spin_lock_irqsave(&zone->lock, flags);
-		isolated = isolate_freepages_block(pfn, block_end_pfn,
+		isolated = isolate_freepages_block(&cc, pfn, block_end_pfn,
 						   &freelist, true);
-		spin_unlock_irqrestore(&zone->lock, flags);
 
 		/*
 		 * In strict mode, isolate_freepages_block() returns 0 if
@@ -483,29 +537,6 @@ next_pageblock:
 
 #endif /* CONFIG_COMPACTION || CONFIG_CMA */
 #ifdef CONFIG_COMPACTION
-
-/* Returns true if the page is within a block suitable for migration to */
-static bool suitable_migration_target(struct page *page)
-{
-
-	int migratetype = get_pageblock_migratetype(page);
-
-	/* Don't interfere with memory hot-remove or the min_free_kbytes blocks */
-	if (migratetype == MIGRATE_ISOLATE || migratetype == MIGRATE_RESERVE)
-		return false;
-
-	/* If the page is a large free page, then allow migration */
-	if (PageBuddy(page) && page_order(page) >= pageblock_order)
-		return true;
-
-	/* If the block is MIGRATE_MOVABLE or MIGRATE_CMA, allow migration */
-	if (migrate_async_suitable(migratetype))
-		return true;
-
-	/* Otherwise skip the block */
-	return false;
-}
-
 /*
  * Returns the start pfn of the last page block in a zone.  This is the starting
  * point for full compaction of a zone.  Compaction searches for free pages from
@@ -529,7 +560,6 @@ static void isolate_freepages(struct zon
 {
 	struct page *page;
 	unsigned long high_pfn, low_pfn, pfn, zone_end_pfn, end_pfn;
-	unsigned long flags;
 	int nr_freepages = cc->nr_freepages;
 	struct list_head *freelist = &cc->freepages;
 
@@ -577,30 +607,12 @@ static void isolate_freepages(struct zon
 		if (!suitable_migration_target(page))
 			continue;
 
-		/*
-		 * Found a block suitable for isolating free pages from. Now
-		 * we disabled interrupts, double check things are ok and
-		 * isolate the pages. This is to minimise the time IRQs
-		 * are disabled
-		 */
+		/* Found a block suitable for isolating free pages from */
 		isolated = 0;
-
-		/*
-		 * The zone lock must be held to isolate freepages. This
-		 * unfortunately this is a very coarse lock and can be
-		 * heavily contended if there are parallel allocations
-		 * or parallel compactions. For async compaction do not
-		 * spin on the lock
-		 */
-		if (!compact_trylock_irqsave(&zone->lock, &flags, cc))
-			break;
-		if (suitable_migration_target(page)) {
-			end_pfn = min(pfn + pageblock_nr_pages, zone_end_pfn);
-			isolated = isolate_freepages_block(pfn, end_pfn,
-							   freelist, false);
-			nr_freepages += isolated;
-		}
-		spin_unlock_irqrestore(&zone->lock, flags);
+		end_pfn = min(pfn + pageblock_nr_pages, zone_end_pfn);
+		isolated = isolate_freepages_block(cc, pfn, end_pfn,
+						   freelist, false);
+		nr_freepages += isolated;
 
 		/*
 		 * Record the highest PFN we isolated pages from. When next
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch

