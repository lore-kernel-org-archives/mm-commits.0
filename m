From: akpm@linux-foundation.org
Subject: [merged] mm-compaction-restart-compaction-from-near-where-it-left-off.patch removed from -mm tree
Date: Tue, 09 Oct 2012 11:12:35 -0700
Message-ID: <20121009181236.486EA5C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-la0-f74.google.com ([209.85.215.74]:59246 "EHLO
	mail-la0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756748Ab2JISMj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 14:12:39 -0400
Received: by mail-la0-f74.google.com with SMTP id j13so309310lah.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 11:12:38 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, aquini@redhat.com, avi@redhat.com, fengguang.wu@intel.com, richard@arachsys.com, riel@redhat.com, shli@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: compaction: Restart compaction from near where it left off
has been removed from the -mm tree.  Its filename was
     mm-compaction-restart-compaction-from-near-where-it-left-off.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: compaction: Restart compaction from near where it left off

This is almost entirely based on Rik's previous patches and discussions
with him about how this might be implemented.

Order > 0 compaction stops when enough free pages of the correct page
order have been coalesced.  When doing subsequent higher order
allocations, it is possible for compaction to be invoked many times.

However, the compaction code always starts out looking for things to
compact at the start of the zone, and for free pages to compact things to
at the end of the zone.

This can cause quadratic behaviour, with isolate_freepages starting at the
end of the zone each time, even though previous invocations of the
compaction code already filled up all free memory on that end of the zone.
 This can cause isolate_freepages to take enormous amounts of CPU with
certain workloads on larger memory systems.

This patch caches where the migration and free scanner should start from
on subsequent compaction invocations using the pageblock-skip information.
 When compaction starts it begins from the cached restart points and will
update the cached restart points until a page is isolated or a pageblock
is skipped that would have been scanned by synchronous compaction.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Richard Davies <richard@arachsys.com>
Cc: Shaohua Li <shli@kernel.org>
Cc: Avi Kivity <avi@redhat.com>
Acked-by: Rafael Aquini <aquini@redhat.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    4 ++
 mm/compaction.c        |   58 ++++++++++++++++++++++++++++++++-------
 mm/internal.h          |    4 ++
 3 files changed, 56 insertions(+), 10 deletions(-)

diff -puN include/linux/mmzone.h~mm-compaction-restart-compaction-from-near-where-it-left-off include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-compaction-restart-compaction-from-near-where-it-left-off
+++ a/include/linux/mmzone.h
@@ -371,6 +371,10 @@ struct zone {
 	int                     all_unreclaimable; /* All pages pinned */
 #if defined CONFIG_COMPACTION || defined CONFIG_CMA
 	unsigned long		compact_blockskip_expire;
+
+	/* pfns where compaction scanners should start */
+	unsigned long		compact_cached_free_pfn;
+	unsigned long		compact_cached_migrate_pfn;
 #endif
 #ifdef CONFIG_MEMORY_HOTPLUG
 	/* see spanned/present_pages for more description */
diff -puN mm/compaction.c~mm-compaction-restart-compaction-from-near-where-it-left-off mm/compaction.c
--- a/mm/compaction.c~mm-compaction-restart-compaction-from-near-where-it-left-off
+++ a/mm/compaction.c
@@ -80,6 +80,9 @@ static void reset_isolation_suitable(str
 	 */
 	if (time_before(jiffies, zone->compact_blockskip_expire))
 		return;
+
+	zone->compact_cached_migrate_pfn = start_pfn;
+	zone->compact_cached_free_pfn = end_pfn;
 	zone->compact_blockskip_expire = jiffies + (HZ * 5);
 
 	/* Walk the zone and mark every pageblock as suitable for isolation */
@@ -103,13 +106,29 @@ static void reset_isolation_suitable(str
  * If no pages were isolated then mark this pageblock to be skipped in the
  * future. The information is later cleared by reset_isolation_suitable().
  */
-static void update_pageblock_skip(struct page *page, unsigned long nr_isolated)
+static void update_pageblock_skip(struct compact_control *cc,
+			struct page *page, unsigned long nr_isolated,
+			bool migrate_scanner)
 {
+	struct zone *zone = cc->zone;
 	if (!page)
 		return;
 
-	if (!nr_isolated)
+	if (!nr_isolated) {
+		unsigned long pfn = page_to_pfn(page);
 		set_pageblock_skip(page);
+
+		/* Update where compaction should restart */
+		if (migrate_scanner) {
+			if (!cc->finished_update_migrate &&
+			    pfn > zone->compact_cached_migrate_pfn)
+				zone->compact_cached_migrate_pfn = pfn;
+		} else {
+			if (!cc->finished_update_free &&
+			    pfn < zone->compact_cached_free_pfn)
+				zone->compact_cached_free_pfn = pfn;
+		}
+	}
 }
 #else
 static inline bool isolation_suitable(struct compact_control *cc,
@@ -118,7 +137,9 @@ static inline bool isolation_suitable(st
 	return true;
 }
 
-static void update_pageblock_skip(struct page *page, unsigned long nr_isolated)
+static void update_pageblock_skip(struct compact_control *cc,
+			struct page *page, unsigned long nr_isolated,
+			bool migrate_scanner)
 {
 }
 #endif /* CONFIG_COMPACTION */
@@ -327,7 +348,7 @@ static unsigned long isolate_freepages_b
 
 	/* Update the pageblock-skip if the whole pageblock was scanned */
 	if (blockpfn == end_pfn)
-		update_pageblock_skip(valid_page, total_isolated);
+		update_pageblock_skip(cc, valid_page, total_isolated, false);
 
 	return total_isolated;
 }
@@ -533,6 +554,7 @@ isolate_migratepages_range(struct zone *
 		 */
 		if (!cc->sync && last_pageblock_nr != pageblock_nr &&
 		    !migrate_async_suitable(get_pageblock_migratetype(page))) {
+			cc->finished_update_migrate = true;
 			goto next_pageblock;
 		}
 
@@ -583,6 +605,7 @@ isolate_migratepages_range(struct zone *
 		VM_BUG_ON(PageTransCompound(page));
 
 		/* Successfully isolated */
+		cc->finished_update_migrate = true;
 		del_page_from_lru_list(page, lruvec, page_lru(page));
 		list_add(&page->lru, migratelist);
 		cc->nr_migratepages++;
@@ -609,7 +632,7 @@ next_pageblock:
 
 	/* Update the pageblock-skip if the whole pageblock was scanned */
 	if (low_pfn == end_pfn)
-		update_pageblock_skip(valid_page, nr_isolated);
+		update_pageblock_skip(cc, valid_page, nr_isolated, true);
 
 	trace_mm_compaction_isolate_migratepages(nr_scanned, nr_isolated);
 
@@ -690,8 +713,10 @@ static void isolate_freepages(struct zon
 		 * looking for free pages, the search will restart here as
 		 * page migration may have returned some pages to the allocator
 		 */
-		if (isolated)
+		if (isolated) {
+			cc->finished_update_free = true;
 			high_pfn = max(high_pfn, pfn);
+		}
 	}
 
 	/* split_free_page does not map the pages */
@@ -888,6 +913,8 @@ unsigned long compaction_suitable(struct
 static int compact_zone(struct zone *zone, struct compact_control *cc)
 {
 	int ret;
+	unsigned long start_pfn = zone->zone_start_pfn;
+	unsigned long end_pfn = zone->zone_start_pfn + zone->spanned_pages;
 
 	ret = compaction_suitable(zone, cc->order);
 	switch (ret) {
@@ -900,10 +927,21 @@ static int compact_zone(struct zone *zon
 		;
 	}
 
-	/* Setup to move all movable pages to the end of the zone */
-	cc->migrate_pfn = zone->zone_start_pfn;
-	cc->free_pfn = cc->migrate_pfn + zone->spanned_pages;
-	cc->free_pfn &= ~(pageblock_nr_pages-1);
+	/*
+	 * Setup to move all movable pages to the end of the zone. Used cached
+	 * information on where the scanners should start but check that it
+	 * is initialised by ensuring the values are within zone boundaries.
+	 */
+	cc->migrate_pfn = zone->compact_cached_migrate_pfn;
+	cc->free_pfn = zone->compact_cached_free_pfn;
+	if (cc->free_pfn < start_pfn || cc->free_pfn > end_pfn) {
+		cc->free_pfn = end_pfn & ~(pageblock_nr_pages-1);
+		zone->compact_cached_free_pfn = cc->free_pfn;
+	}
+	if (cc->migrate_pfn < start_pfn || cc->migrate_pfn > end_pfn) {
+		cc->migrate_pfn = start_pfn;
+		zone->compact_cached_migrate_pfn = cc->migrate_pfn;
+	}
 
 	/* Clear pageblock skip if there are numerous alloc failures */
 	if (zone->compact_defer_shift == COMPACT_MAX_DEFER_SHIFT)
diff -puN mm/internal.h~mm-compaction-restart-compaction-from-near-where-it-left-off mm/internal.h
--- a/mm/internal.h~mm-compaction-restart-compaction-from-near-where-it-left-off
+++ a/mm/internal.h
@@ -121,6 +121,10 @@ struct compact_control {
 	unsigned long migrate_pfn;	/* isolate_migratepages search base */
 	bool sync;			/* Synchronous migration */
 	bool ignore_skip_hint;		/* Scan blocks even if marked skip */
+	bool finished_update_free;	/* True when the zone cached pfns are
+					 * no longer being updated
+					 */
+	bool finished_update_migrate;
 
 	int order;			/* order a direct compactor needs */
 	int migratetype;		/* MOVABLE, RECLAIMABLE etc */
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch

