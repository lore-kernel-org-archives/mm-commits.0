From: akpm@linux-foundation.org
Subject: [merged] revert-mm-have-order-0-compaction-start-off-where-it-left.patch removed from -mm tree
Date: Tue, 09 Oct 2012 11:12:24 -0700
Message-ID: <20121009181225.4535F5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:60537 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756748Ab2JISM2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 14:12:28 -0400
Received: by mail-wg0-f74.google.com with SMTP id dt11so364671wgb.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 11:12:27 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, aquini@redhat.com, avi@redhat.com, minchan@kernel.org, richard@arachsys.com, riel@redhat.com, shli@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: revert "mm: have order > 0 compaction start off where it left"
has been removed from the -mm tree.  Its filename was
     revert-mm-have-order-0-compaction-start-off-where-it-left.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: revert "mm: have order > 0 compaction start off where it left"

This reverts commit 7db8889a ("mm: have order > 0 compaction start off
where it left") and commit de74f1cc ("mm: have order > 0 compaction start
near a pageblock with free pages").  These patches were a good idea and
tests confirmed that they massively reduced the amount of scanning but the
implementation is complex and tricky to understand.  A later patch will
cache what pageblocks should be skipped and reimplements the concept of
compact_cached_free_pfn on top for both migration and free scanners.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Richard Davies <richard@arachsys.com>
Cc: Shaohua Li <shli@kernel.org>
Cc: Avi Kivity <avi@redhat.com>
Acked-by: Rafael Aquini <aquini@redhat.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    4 --
 mm/compaction.c        |   65 +++------------------------------------
 mm/internal.h          |    6 ---
 mm/page_alloc.c        |    5 ---
 4 files changed, 5 insertions(+), 75 deletions(-)

diff -puN include/linux/mmzone.h~revert-mm-have-order-0-compaction-start-off-where-it-left include/linux/mmzone.h
--- a/include/linux/mmzone.h~revert-mm-have-order-0-compaction-start-off-where-it-left
+++ a/include/linux/mmzone.h
@@ -369,10 +369,6 @@ struct zone {
 	 */
 	spinlock_t		lock;
 	int                     all_unreclaimable; /* All pages pinned */
-#if defined CONFIG_COMPACTION || defined CONFIG_CMA
-	/* pfn where the last incremental compaction isolated free pages */
-	unsigned long		compact_cached_free_pfn;
-#endif
 #ifdef CONFIG_MEMORY_HOTPLUG
 	/* see spanned/present_pages for more description */
 	seqlock_t		span_seqlock;
diff -puN mm/compaction.c~revert-mm-have-order-0-compaction-start-off-where-it-left mm/compaction.c
--- a/mm/compaction.c~revert-mm-have-order-0-compaction-start-off-where-it-left
+++ a/mm/compaction.c
@@ -538,20 +538,6 @@ next_pageblock:
 #endif /* CONFIG_COMPACTION || CONFIG_CMA */
 #ifdef CONFIG_COMPACTION
 /*
- * Returns the start pfn of the last page block in a zone.  This is the starting
- * point for full compaction of a zone.  Compaction searches for free pages from
- * the end of each zone, while isolate_freepages_block scans forward inside each
- * page block.
- */
-static unsigned long start_free_pfn(struct zone *zone)
-{
-	unsigned long free_pfn;
-	free_pfn = zone->zone_start_pfn + zone->spanned_pages;
-	free_pfn &= ~(pageblock_nr_pages-1);
-	return free_pfn;
-}
-
-/*
  * Based on information in the current compact_control, find blocks
  * suitable for isolating free pages from and then isolate them.
  */
@@ -619,19 +605,8 @@ static void isolate_freepages(struct zon
 		 * looking for free pages, the search will restart here as
 		 * page migration may have returned some pages to the allocator
 		 */
-		if (isolated) {
+		if (isolated)
 			high_pfn = max(high_pfn, pfn);
-
-			/*
-			 * If the free scanner has wrapped, update
-			 * compact_cached_free_pfn to point to the highest
-			 * pageblock with free pages. This reduces excessive
-			 * scanning of full pageblocks near the end of the
-			 * zone
-			 */
-			if (cc->order > 0 && cc->wrapped)
-				zone->compact_cached_free_pfn = high_pfn;
-		}
 	}
 
 	/* split_free_page does not map the pages */
@@ -639,11 +614,6 @@ static void isolate_freepages(struct zon
 
 	cc->free_pfn = high_pfn;
 	cc->nr_freepages = nr_freepages;
-
-	/* If compact_cached_free_pfn is reset then set it now */
-	if (cc->order > 0 && !cc->wrapped &&
-			zone->compact_cached_free_pfn == start_free_pfn(zone))
-		zone->compact_cached_free_pfn = high_pfn;
 }
 
 /*
@@ -738,26 +708,8 @@ static int compact_finished(struct zone 
 	if (fatal_signal_pending(current))
 		return COMPACT_PARTIAL;
 
-	/*
-	 * A full (order == -1) compaction run starts at the beginning and
-	 * end of a zone; it completes when the migrate and free scanner meet.
-	 * A partial (order > 0) compaction can start with the free scanner
-	 * at a random point in the zone, and may have to restart.
-	 */
-	if (cc->free_pfn <= cc->migrate_pfn) {
-		if (cc->order > 0 && !cc->wrapped) {
-			/* We started partway through; restart at the end. */
-			unsigned long free_pfn = start_free_pfn(zone);
-			zone->compact_cached_free_pfn = free_pfn;
-			cc->free_pfn = free_pfn;
-			cc->wrapped = 1;
-			return COMPACT_CONTINUE;
-		}
-		return COMPACT_COMPLETE;
-	}
-
-	/* We wrapped around and ended up where we started. */
-	if (cc->wrapped && cc->free_pfn <= cc->start_free_pfn)
+	/* Compaction run completes if the migrate and free scanner meet */
+	if (cc->free_pfn <= cc->migrate_pfn)
 		return COMPACT_COMPLETE;
 
 	/*
@@ -863,15 +815,8 @@ static int compact_zone(struct zone *zon
 
 	/* Setup to move all movable pages to the end of the zone */
 	cc->migrate_pfn = zone->zone_start_pfn;
-
-	if (cc->order > 0) {
-		/* Incremental compaction. Start where the last one stopped. */
-		cc->free_pfn = zone->compact_cached_free_pfn;
-		cc->start_free_pfn = cc->free_pfn;
-	} else {
-		/* Order == -1 starts at the end of the zone. */
-		cc->free_pfn = start_free_pfn(zone);
-	}
+	cc->free_pfn = cc->migrate_pfn + zone->spanned_pages;
+	cc->free_pfn &= ~(pageblock_nr_pages-1);
 
 	migrate_prep_local();
 
diff -puN mm/internal.h~revert-mm-have-order-0-compaction-start-off-where-it-left mm/internal.h
--- a/mm/internal.h~revert-mm-have-order-0-compaction-start-off-where-it-left
+++ a/mm/internal.h
@@ -118,14 +118,8 @@ struct compact_control {
 	unsigned long nr_freepages;	/* Number of isolated free pages */
 	unsigned long nr_migratepages;	/* Number of pages to migrate */
 	unsigned long free_pfn;		/* isolate_freepages search base */
-	unsigned long start_free_pfn;	/* where we started the search */
 	unsigned long migrate_pfn;	/* isolate_migratepages search base */
 	bool sync;			/* Synchronous migration */
-	bool wrapped;			/* Order > 0 compactions are
-					   incremental, once free_pfn
-					   and migrate_pfn meet, we restart
-					   from the top of the zone;
-					   remember we wrapped around. */
 
 	int order;			/* order a direct compactor needs */
 	int migratetype;		/* MOVABLE, RECLAIMABLE etc */
diff -puN mm/page_alloc.c~revert-mm-have-order-0-compaction-start-off-where-it-left mm/page_alloc.c
--- a/mm/page_alloc.c~revert-mm-have-order-0-compaction-start-off-where-it-left
+++ a/mm/page_alloc.c
@@ -4490,11 +4490,6 @@ static void __paginginit free_area_init_
 
 		zone->spanned_pages = size;
 		zone->present_pages = realsize;
-#if defined CONFIG_COMPACTION || defined CONFIG_CMA
-		zone->compact_cached_free_pfn = zone->zone_start_pfn +
-						zone->spanned_pages;
-		zone->compact_cached_free_pfn &= ~(pageblock_nr_pages-1);
-#endif
 #ifdef CONFIG_NUMA
 		zone->node = nid;
 		zone->min_unmapped_pages = (realsize*sysctl_min_unmapped_ratio)
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch

