From: akpm@linux-foundation.org
Subject: [merged] mm-compaction-cache-if-a-pageblock-was-scanned-and-no-pages-were-isolated.patch removed from -mm tree
Date: Tue, 09 Oct 2012 11:12:29 -0700
Message-ID: <20121009181230.640BC20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:60537 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756748Ab2JISMd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 14:12:33 -0400
Received: by mail-wg0-f74.google.com with SMTP id dt11so364671wgb.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 11:12:32 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, aquini@redhat.com, avi@redhat.com, b.zolnierkie@samsung.com, broonie@opensource.wolfsonmicro.com, fengguang.wu@intel.com, kyungmin.park@samsung.com, mina86@mina86.com, richard@arachsys.com, riel@redhat.com, shli@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: compaction: cache if a pageblock was scanned and no pages were isolated
has been removed from the -mm tree.  Its filename was
     mm-compaction-cache-if-a-pageblock-was-scanned-and-no-pages-were-isolated.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: compaction: cache if a pageblock was scanned and no pages were isolated

When compaction was implemented it was known that scanning could
potentially be excessive.  The ideal was that a counter be maintained for
each pageblock but maintaining this information would incur a severe
penalty due to a shared writable cache line.  It has reached the point
where the scanning costs are a serious problem, particularly on
long-lived systems where a large process starts and allocates a large
number of THPs at the same time.

Instead of using a shared counter, this patch adds another bit to the
pageblock flags called PG_migrate_skip.  If a pageblock is scanned by
either migrate or free scanner and 0 pages were isolated, the pageblock is
marked to be skipped in the future.  When scanning, this bit is checked
before any scanning takes place and the block skipped if set.

The main difficulty with a patch like this is "when to ignore the cached
information?" If it's ignored too often, the scanning rates will still be
excessive.  If the information is too stale then allocations will fail
that might have otherwise succeeded.  In this patch

o CMA always ignores the information
o If the migrate and free scanner meet then the cached information will
  be discarded if it's at least 5 seconds since the last time the cache
  was discarded
o If there are a large number of allocation failures, discard the cache.

The time-based heuristic is very clumsy but there are few choices for a
better event.  Depending solely on multiple allocation failures still
allows excessive scanning when THP allocations are failing in quick
succession due to memory pressure.  Waiting until memory pressure is
relieved would cause compaction to continually fail instead of using
reclaim/compaction to try allocate the page.  The time-based mechanism is
clumsy but a better option is not obvious.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Richard Davies <richard@arachsys.com>
Cc: Shaohua Li <shli@kernel.org>
Cc: Avi Kivity <avi@redhat.com>
Acked-by: Rafael Aquini <aquini@redhat.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h          |    3 
 include/linux/pageblock-flags.h |   19 ++++
 mm/compaction.c                 |  125 +++++++++++++++++++++++++-----
 mm/internal.h                   |    4 
 mm/page_alloc.c                 |   38 ++++-----
 5 files changed, 151 insertions(+), 38 deletions(-)

diff -puN include/linux/mmzone.h~mm-compaction-cache-if-a-pageblock-was-scanned-and-no-pages-were-isolated include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-compaction-cache-if-a-pageblock-was-scanned-and-no-pages-were-isolated
+++ a/include/linux/mmzone.h
@@ -369,6 +369,9 @@ struct zone {
 	 */
 	spinlock_t		lock;
 	int                     all_unreclaimable; /* All pages pinned */
+#if defined CONFIG_COMPACTION || defined CONFIG_CMA
+	unsigned long		compact_blockskip_expire;
+#endif
 #ifdef CONFIG_MEMORY_HOTPLUG
 	/* see spanned/present_pages for more description */
 	seqlock_t		span_seqlock;
diff -puN include/linux/pageblock-flags.h~mm-compaction-cache-if-a-pageblock-was-scanned-and-no-pages-were-isolated include/linux/pageblock-flags.h
--- a/include/linux/pageblock-flags.h~mm-compaction-cache-if-a-pageblock-was-scanned-and-no-pages-were-isolated
+++ a/include/linux/pageblock-flags.h
@@ -30,6 +30,9 @@ enum pageblock_bits {
 	PB_migrate,
 	PB_migrate_end = PB_migrate + 3 - 1,
 			/* 3 bits required for migrate types */
+#ifdef CONFIG_COMPACTION
+	PB_migrate_skip,/* If set the block is skipped by compaction */
+#endif /* CONFIG_COMPACTION */
 	NR_PAGEBLOCK_BITS
 };
 
@@ -65,10 +68,22 @@ unsigned long get_pageblock_flags_group(
 void set_pageblock_flags_group(struct page *page, unsigned long flags,
 					int start_bitidx, int end_bitidx);
 
+#ifdef CONFIG_COMPACTION
+#define get_pageblock_skip(page) \
+			get_pageblock_flags_group(page, PB_migrate_skip,     \
+							PB_migrate_skip + 1)
+#define clear_pageblock_skip(page) \
+			set_pageblock_flags_group(page, 0, PB_migrate_skip,  \
+							PB_migrate_skip + 1)
+#define set_pageblock_skip(page) \
+			set_pageblock_flags_group(page, 1, PB_migrate_skip,  \
+							PB_migrate_skip + 1)
+#endif /* CONFIG_COMPACTION */
+
 #define get_pageblock_flags(page) \
-			get_pageblock_flags_group(page, 0, NR_PAGEBLOCK_BITS-1)
+			get_pageblock_flags_group(page, 0, PB_migrate_end)
 #define set_pageblock_flags(page, flags) \
 			set_pageblock_flags_group(page, flags,	\
-						  0, NR_PAGEBLOCK_BITS-1)
+						  0, PB_migrate_end)
 
 #endif	/* PAGEBLOCK_FLAGS_H */
diff -puN mm/compaction.c~mm-compaction-cache-if-a-pageblock-was-scanned-and-no-pages-were-isolated mm/compaction.c
--- a/mm/compaction.c~mm-compaction-cache-if-a-pageblock-was-scanned-and-no-pages-were-isolated
+++ a/mm/compaction.c
@@ -50,6 +50,79 @@ static inline bool migrate_async_suitabl
 	return is_migrate_cma(migratetype) || migratetype == MIGRATE_MOVABLE;
 }
 
+#ifdef CONFIG_COMPACTION
+/* Returns true if the pageblock should be scanned for pages to isolate. */
+static inline bool isolation_suitable(struct compact_control *cc,
+					struct page *page)
+{
+	if (cc->ignore_skip_hint)
+		return true;
+
+	return !get_pageblock_skip(page);
+}
+
+/*
+ * This function is called to clear all cached information on pageblocks that
+ * should be skipped for page isolation when the migrate and free page scanner
+ * meet.
+ */
+static void reset_isolation_suitable(struct zone *zone)
+{
+	unsigned long start_pfn = zone->zone_start_pfn;
+	unsigned long end_pfn = zone->zone_start_pfn + zone->spanned_pages;
+	unsigned long pfn;
+
+	/*
+	 * Do not reset more than once every five seconds. If allocations are
+	 * failing sufficiently quickly to allow this to happen then continually
+	 * scanning for compaction is not going to help. The choice of five
+	 * seconds is arbitrary but will mitigate excessive scanning.
+	 */
+	if (time_before(jiffies, zone->compact_blockskip_expire))
+		return;
+	zone->compact_blockskip_expire = jiffies + (HZ * 5);
+
+	/* Walk the zone and mark every pageblock as suitable for isolation */
+	for (pfn = start_pfn; pfn < end_pfn; pfn += pageblock_nr_pages) {
+		struct page *page;
+
+		cond_resched();
+
+		if (!pfn_valid(pfn))
+			continue;
+
+		page = pfn_to_page(pfn);
+		if (zone != page_zone(page))
+			continue;
+
+		clear_pageblock_skip(page);
+	}
+}
+
+/*
+ * If no pages were isolated then mark this pageblock to be skipped in the
+ * future. The information is later cleared by reset_isolation_suitable().
+ */
+static void update_pageblock_skip(struct page *page, unsigned long nr_isolated)
+{
+	if (!page)
+		return;
+
+	if (!nr_isolated)
+		set_pageblock_skip(page);
+}
+#else
+static inline bool isolation_suitable(struct compact_control *cc,
+					struct page *page)
+{
+	return true;
+}
+
+static void update_pageblock_skip(struct page *page, unsigned long nr_isolated)
+{
+}
+#endif /* CONFIG_COMPACTION */
+
 static inline bool should_release_lock(spinlock_t *lock)
 {
 	return need_resched() || spin_is_contended(lock);
@@ -181,7 +254,7 @@ static unsigned long isolate_freepages_b
 				bool strict)
 {
 	int nr_scanned = 0, total_isolated = 0;
-	struct page *cursor;
+	struct page *cursor, *valid_page = NULL;
 	unsigned long nr_strict_required = end_pfn - blockpfn;
 	unsigned long flags;
 	bool locked = false;
@@ -196,6 +269,8 @@ static unsigned long isolate_freepages_b
 		nr_scanned++;
 		if (!pfn_valid_within(blockpfn))
 			continue;
+		if (!valid_page)
+			valid_page = page;
 		if (!PageBuddy(page))
 			continue;
 
@@ -250,6 +325,10 @@ static unsigned long isolate_freepages_b
 	if (locked)
 		spin_unlock_irqrestore(&cc->zone->lock, flags);
 
+	/* Update the pageblock-skip if the whole pageblock was scanned */
+	if (blockpfn == end_pfn)
+		update_pageblock_skip(valid_page, total_isolated);
+
 	return total_isolated;
 }
 
@@ -267,22 +346,14 @@ static unsigned long isolate_freepages_b
  * a free page).
  */
 unsigned long
-isolate_freepages_range(unsigned long start_pfn, unsigned long end_pfn)
+isolate_freepages_range(struct compact_control *cc,
+			unsigned long start_pfn, unsigned long end_pfn)
 {
 	unsigned long isolated, pfn, block_end_pfn;
-	struct zone *zone = NULL;
 	LIST_HEAD(freelist);
 
-	/* cc needed for isolate_freepages_block to acquire zone->lock */
-	struct compact_control cc = {
-		.sync = true,
-	};
-
-	if (pfn_valid(start_pfn))
-		cc.zone = zone = page_zone(pfn_to_page(start_pfn));
-
 	for (pfn = start_pfn; pfn < end_pfn; pfn += isolated) {
-		if (!pfn_valid(pfn) || zone != page_zone(pfn_to_page(pfn)))
+		if (!pfn_valid(pfn) || cc->zone != page_zone(pfn_to_page(pfn)))
 			break;
 
 		/*
@@ -292,7 +363,7 @@ isolate_freepages_range(unsigned long st
 		block_end_pfn = ALIGN(pfn + 1, pageblock_nr_pages);
 		block_end_pfn = min(block_end_pfn, end_pfn);
 
-		isolated = isolate_freepages_block(&cc, pfn, block_end_pfn,
+		isolated = isolate_freepages_block(cc, pfn, block_end_pfn,
 						   &freelist, true);
 
 		/*
@@ -387,6 +458,7 @@ isolate_migratepages_range(struct zone *
 	struct lruvec *lruvec;
 	unsigned long flags;
 	bool locked = false;
+	struct page *page = NULL, *valid_page = NULL;
 
 	/*
 	 * Ensure that there are not too many pages isolated from the LRU
@@ -407,8 +479,6 @@ isolate_migratepages_range(struct zone *
 	/* Time to isolate some pages for migration */
 	cond_resched();
 	for (; low_pfn < end_pfn; low_pfn++) {
-		struct page *page;
-
 		/* give a chance to irqs before checking need_resched() */
 		if (locked && !((low_pfn+1) % SWAP_CLUSTER_MAX)) {
 			if (should_release_lock(&zone->lru_lock)) {
@@ -444,6 +514,14 @@ isolate_migratepages_range(struct zone *
 		if (page_zone(page) != zone)
 			continue;
 
+		if (!valid_page)
+			valid_page = page;
+
+		/* If isolation recently failed, do not retry */
+		pageblock_nr = low_pfn >> pageblock_order;
+		if (!isolation_suitable(cc, page))
+			goto next_pageblock;
+
 		/* Skip if free */
 		if (PageBuddy(page))
 			continue;
@@ -453,7 +531,6 @@ isolate_migratepages_range(struct zone *
 		 * migration is optimistic to see if the minimum amount of work
 		 * satisfies the allocation
 		 */
-		pageblock_nr = low_pfn >> pageblock_order;
 		if (!cc->sync && last_pageblock_nr != pageblock_nr &&
 		    !migrate_async_suitable(get_pageblock_migratetype(page))) {
 			goto next_pageblock;
@@ -530,6 +607,10 @@ next_pageblock:
 	if (locked)
 		spin_unlock_irqrestore(&zone->lru_lock, flags);
 
+	/* Update the pageblock-skip if the whole pageblock was scanned */
+	if (low_pfn == end_pfn)
+		update_pageblock_skip(valid_page, nr_isolated);
+
 	trace_mm_compaction_isolate_migratepages(nr_scanned, nr_isolated);
 
 	return low_pfn;
@@ -593,6 +674,10 @@ static void isolate_freepages(struct zon
 		if (!suitable_migration_target(page))
 			continue;
 
+		/* If isolation recently failed, do not retry */
+		if (!isolation_suitable(cc, page))
+			continue;
+
 		/* Found a block suitable for isolating free pages from */
 		isolated = 0;
 		end_pfn = min(pfn + pageblock_nr_pages, zone_end_pfn);
@@ -709,8 +794,10 @@ static int compact_finished(struct zone 
 		return COMPACT_PARTIAL;
 
 	/* Compaction run completes if the migrate and free scanner meet */
-	if (cc->free_pfn <= cc->migrate_pfn)
+	if (cc->free_pfn <= cc->migrate_pfn) {
+		reset_isolation_suitable(cc->zone);
 		return COMPACT_COMPLETE;
+	}
 
 	/*
 	 * order == -1 is expected when compacting via
@@ -818,6 +905,10 @@ static int compact_zone(struct zone *zon
 	cc->free_pfn = cc->migrate_pfn + zone->spanned_pages;
 	cc->free_pfn &= ~(pageblock_nr_pages-1);
 
+	/* Clear pageblock skip if there are numerous alloc failures */
+	if (zone->compact_defer_shift == COMPACT_MAX_DEFER_SHIFT)
+		reset_isolation_suitable(zone);
+
 	migrate_prep_local();
 
 	while ((ret = compact_finished(zone, cc)) == COMPACT_CONTINUE) {
diff -puN mm/internal.h~mm-compaction-cache-if-a-pageblock-was-scanned-and-no-pages-were-isolated mm/internal.h
--- a/mm/internal.h~mm-compaction-cache-if-a-pageblock-was-scanned-and-no-pages-were-isolated
+++ a/mm/internal.h
@@ -120,6 +120,7 @@ struct compact_control {
 	unsigned long free_pfn;		/* isolate_freepages search base */
 	unsigned long migrate_pfn;	/* isolate_migratepages search base */
 	bool sync;			/* Synchronous migration */
+	bool ignore_skip_hint;		/* Scan blocks even if marked skip */
 
 	int order;			/* order a direct compactor needs */
 	int migratetype;		/* MOVABLE, RECLAIMABLE etc */
@@ -129,7 +130,8 @@ struct compact_control {
 };
 
 unsigned long
-isolate_freepages_range(unsigned long start_pfn, unsigned long end_pfn);
+isolate_freepages_range(struct compact_control *cc,
+			unsigned long start_pfn, unsigned long end_pfn);
 unsigned long
 isolate_migratepages_range(struct zone *zone, struct compact_control *cc,
 			   unsigned long low_pfn, unsigned long end_pfn);
diff -puN mm/page_alloc.c~mm-compaction-cache-if-a-pageblock-was-scanned-and-no-pages-were-isolated mm/page_alloc.c
--- a/mm/page_alloc.c~mm-compaction-cache-if-a-pageblock-was-scanned-and-no-pages-were-isolated
+++ a/mm/page_alloc.c
@@ -5679,7 +5679,8 @@ __alloc_contig_migrate_alloc(struct page
 }
 
 /* [start, end) must belong to a single zone. */
-static int __alloc_contig_migrate_range(unsigned long start, unsigned long end)
+static int __alloc_contig_migrate_range(struct compact_control *cc,
+					unsigned long start, unsigned long end)
 {
 	/* This function is based on compact_zone() from compaction.c. */
 
@@ -5687,25 +5688,17 @@ static int __alloc_contig_migrate_range(
 	unsigned int tries = 0;
 	int ret = 0;
 
-	struct compact_control cc = {
-		.nr_migratepages = 0,
-		.order = -1,
-		.zone = page_zone(pfn_to_page(start)),
-		.sync = true,
-	};
-	INIT_LIST_HEAD(&cc.migratepages);
-
 	migrate_prep_local();
 
-	while (pfn < end || !list_empty(&cc.migratepages)) {
+	while (pfn < end || !list_empty(&cc->migratepages)) {
 		if (fatal_signal_pending(current)) {
 			ret = -EINTR;
 			break;
 		}
 
-		if (list_empty(&cc.migratepages)) {
-			cc.nr_migratepages = 0;
-			pfn = isolate_migratepages_range(cc.zone, &cc,
+		if (list_empty(&cc->migratepages)) {
+			cc->nr_migratepages = 0;
+			pfn = isolate_migratepages_range(cc->zone, cc,
 							 pfn, end);
 			if (!pfn) {
 				ret = -EINTR;
@@ -5717,14 +5710,14 @@ static int __alloc_contig_migrate_range(
 			break;
 		}
 
-		reclaim_clean_pages_from_list(cc.zone, &cc.migratepages);
+		reclaim_clean_pages_from_list(cc->zone, &cc->migratepages);
 
-		ret = migrate_pages(&cc.migratepages,
+		ret = migrate_pages(&cc->migratepages,
 				    __alloc_contig_migrate_alloc,
 				    0, false, MIGRATE_SYNC);
 	}
 
-	putback_lru_pages(&cc.migratepages);
+	putback_lru_pages(&cc->migratepages);
 	return ret > 0 ? 0 : ret;
 }
 
@@ -5803,6 +5796,15 @@ int alloc_contig_range(unsigned long sta
 	unsigned long outer_start, outer_end;
 	int ret = 0, order;
 
+	struct compact_control cc = {
+		.nr_migratepages = 0,
+		.order = -1,
+		.zone = page_zone(pfn_to_page(start)),
+		.sync = true,
+		.ignore_skip_hint = true,
+	};
+	INIT_LIST_HEAD(&cc.migratepages);
+
 	/*
 	 * What we do here is we mark all pageblocks in range as
 	 * MIGRATE_ISOLATE.  Because pageblock and max order pages may
@@ -5832,7 +5834,7 @@ int alloc_contig_range(unsigned long sta
 	if (ret)
 		goto done;
 
-	ret = __alloc_contig_migrate_range(start, end);
+	ret = __alloc_contig_migrate_range(&cc, start, end);
 	if (ret)
 		goto done;
 
@@ -5881,7 +5883,7 @@ int alloc_contig_range(unsigned long sta
 	__reclaim_pages(zone, GFP_HIGHUSER_MOVABLE, end-start);
 
 	/* Grab isolated pages from freelists. */
-	outer_end = isolate_freepages_range(outer_start, end);
+	outer_end = isolate_freepages_range(&cc, outer_start, end);
 	if (!outer_end) {
 		ret = -EBUSY;
 		goto done;
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch

