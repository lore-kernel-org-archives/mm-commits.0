From: akpm@linux-foundation.org
Subject: [merged]
 mm-compaction-correct-to-flush-migrated-pages-if-pageblock-skip-happens.patch removed from -mm tree
Date: Wed, 09 Sep 2015 12:53:32 -0700
Message-ID: <55f08e3c.fxgLcbdTzmd4/8wP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41062 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755390AbbIITxd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2015 15:53:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, mgorman@suse.de, minchan@kernel.org, riel@redhat.com, rientjes@google.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/compaction: correct to flush migrated pages if pageblock skip happens
has been removed from the -mm tree.  Its filename was
     mm-compaction-correct-to-flush-migrated-pages-if-pageblock-skip-happens.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/compaction: correct to flush migrated pages if pageblock skip happens

We cache isolate_start_pfn before entering isolate_migratepages().  If
pageblock is skipped in isolate_migratepages() due to whatever reason,
cc->migrate_pfn can be far from isolate_start_pfn hence we flush pages
that were freed.  For example, the following scenario can be possible:

- assume order-9 compaction, pageblock order is 9
- start_isolate_pfn is 0x200
- isolate_migratepages()
  - skip a number of pageblocks
  - start to isolate from pfn 0x600
  - cc->migrate_pfn = 0x620
  - return
- last_migrated_pfn is set to 0x200
- check flushing condition
  - current_block_start is set to 0x600
  - last_migrated_pfn < current_block_start then do useless flush

This wrong flush would not help the performance and success rate so
this patch tries to fix it. One simple way to know the exact position
where we start to isolate migratable pages is that we cache it
in isolate_migratepages() before entering actual isolation. This patch
implements that and fixes the problem.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   30 +++++++++++++++---------------
 mm/internal.h   |    1 +
 2 files changed, 16 insertions(+), 15 deletions(-)

diff -puN mm/compaction.c~mm-compaction-correct-to-flush-migrated-pages-if-pageblock-skip-happens mm/compaction.c
--- a/mm/compaction.c~mm-compaction-correct-to-flush-migrated-pages-if-pageblock-skip-happens
+++ a/mm/compaction.c
@@ -1115,6 +1115,7 @@ static isolate_migrate_t isolate_migrate
 					struct compact_control *cc)
 {
 	unsigned long low_pfn, end_pfn;
+	unsigned long isolate_start_pfn;
 	struct page *page;
 	const isolate_mode_t isolate_mode =
 		(sysctl_compact_unevictable_allowed ? ISOLATE_UNEVICTABLE : 0) |
@@ -1163,6 +1164,7 @@ static isolate_migrate_t isolate_migrate
 			continue;
 
 		/* Perform the isolation */
+		isolate_start_pfn = low_pfn;
 		low_pfn = isolate_migratepages_block(cc, low_pfn, end_pfn,
 								isolate_mode);
 
@@ -1172,6 +1174,15 @@ static isolate_migrate_t isolate_migrate
 		}
 
 		/*
+		 * Record where we could have freed pages by migration and not
+		 * yet flushed them to buddy allocator.
+		 * - this is the lowest page that could have been isolated and
+		 * then freed by migration.
+		 */
+		if (cc->nr_migratepages && !cc->last_migrated_pfn)
+			cc->last_migrated_pfn = isolate_start_pfn;
+
+		/*
 		 * Either we isolated something and proceed with migration. Or
 		 * we failed and compact_zone should decide if we should
 		 * continue or not.
@@ -1342,7 +1353,6 @@ static int compact_zone(struct zone *zon
 	unsigned long end_pfn = zone_end_pfn(zone);
 	const int migratetype = gfpflags_to_migratetype(cc->gfp_mask);
 	const bool sync = cc->mode != MIGRATE_ASYNC;
-	unsigned long last_migrated_pfn = 0;
 
 	ret = compaction_suitable(zone, cc->order, cc->alloc_flags,
 							cc->classzone_idx);
@@ -1380,6 +1390,7 @@ static int compact_zone(struct zone *zon
 		zone->compact_cached_migrate_pfn[0] = cc->migrate_pfn;
 		zone->compact_cached_migrate_pfn[1] = cc->migrate_pfn;
 	}
+	cc->last_migrated_pfn = 0;
 
 	trace_mm_compaction_begin(start_pfn, cc->migrate_pfn,
 				cc->free_pfn, end_pfn, sync);
@@ -1389,7 +1400,6 @@ static int compact_zone(struct zone *zon
 	while ((ret = compact_finished(zone, cc, migratetype)) ==
 						COMPACT_CONTINUE) {
 		int err;
-		unsigned long isolate_start_pfn = cc->migrate_pfn;
 
 		switch (isolate_migratepages(zone, cc)) {
 		case ISOLATE_ABORT:
@@ -1429,16 +1439,6 @@ static int compact_zone(struct zone *zon
 			}
 		}
 
-		/*
-		 * Record where we could have freed pages by migration and not
-		 * yet flushed them to buddy allocator. We use the pfn that
-		 * isolate_migratepages() started from in this loop iteration
-		 * - this is the lowest page that could have been isolated and
-		 * then freed by migration.
-		 */
-		if (!last_migrated_pfn)
-			last_migrated_pfn = isolate_start_pfn;
-
 check_drain:
 		/*
 		 * Has the migration scanner moved away from the previous
@@ -1447,18 +1447,18 @@ check_drain:
 		 * compact_finished() can detect immediately if allocation
 		 * would succeed.
 		 */
-		if (cc->order > 0 && last_migrated_pfn) {
+		if (cc->order > 0 && cc->last_migrated_pfn) {
 			int cpu;
 			unsigned long current_block_start =
 				cc->migrate_pfn & ~((1UL << cc->order) - 1);
 
-			if (last_migrated_pfn < current_block_start) {
+			if (cc->last_migrated_pfn < current_block_start) {
 				cpu = get_cpu();
 				lru_add_drain_cpu(cpu);
 				drain_local_pages(zone);
 				put_cpu();
 				/* No more flushing until we migrate again */
-				last_migrated_pfn = 0;
+				cc->last_migrated_pfn = 0;
 			}
 		}
 
diff -puN mm/internal.h~mm-compaction-correct-to-flush-migrated-pages-if-pageblock-skip-happens mm/internal.h
--- a/mm/internal.h~mm-compaction-correct-to-flush-migrated-pages-if-pageblock-skip-happens
+++ a/mm/internal.h
@@ -182,6 +182,7 @@ struct compact_control {
 	unsigned long nr_migratepages;	/* Number of pages to migrate */
 	unsigned long free_pfn;		/* isolate_freepages search base */
 	unsigned long migrate_pfn;	/* isolate_migratepages search base */
+	unsigned long last_migrated_pfn;/* Not yet flushed page being freed */
 	enum migrate_mode mode;		/* Async or sync migration mode */
 	bool ignore_skip_hint;		/* Scan blocks even if marked skip */
 	int order;			/* order a direct compactor needs */
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are


