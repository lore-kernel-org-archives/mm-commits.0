From: akpm@linux-foundation.org
Subject: + mm-compaction-cache-if-a-pageblock-was-scanned-and-no-pages-were-isolated.patch added to -mm tree
Date: Fri, 21 Sep 2012 14:33:11 -0700
Message-ID: <20120921213311.7F5451E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:35410 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753566Ab2IUVdM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 21 Sep 2012 17:33:12 -0400
Received: by mail-qc0-f202.google.com with SMTP id s25so229004qcq.1
        for <mm-commits@vger.kernel.org>; Fri, 21 Sep 2012 14:33:12 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mgorman@suse.de, aquini@redhat.com, avi@redhat.com, richard@arachsys.com, riel@redhat.com, shli@kernel.org


The patch titled
     Subject: mm: compaction: cache if a pageblock was scanned and no pages were isolated
has been added to the -mm tree.  Its filename is
     mm-compaction-cache-if-a-pageblock-was-scanned-and-no-pages-were-isolated.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h          |    3 
 include/linux/pageblock-flags.h |   19 +++++-
 mm/compaction.c                 |   93 ++++++++++++++++++++++++++++--
 mm/internal.h                   |    1 
 mm/page_alloc.c                 |    1 
 5 files changed, 111 insertions(+), 6 deletions(-)

diff -puN include/linux/mmzone.h~mm-compaction-cache-if-a-pageblock-was-scanned-and-no-pages-were-isolated include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-compaction-cache-if-a-pageblock-was-scanned-and-no-pages-were-isolated
+++ a/include/linux/mmzone.h
@@ -384,6 +384,9 @@ struct zone {
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
@@ -50,6 +50,64 @@ static inline bool migrate_async_suitabl
 	return is_migrate_cma(migratetype) || migratetype == MIGRATE_MOVABLE;
 }
 
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
+
 static inline bool should_release_lock(spinlock_t *lock)
 {
 	return need_resched() || spin_is_contended(lock);
@@ -182,7 +240,7 @@ static unsigned long isolate_freepages_b
 				bool strict)
 {
 	int nr_scanned = 0, total_isolated = 0;
-	struct page *cursor;
+	struct page *cursor, *valid_page = NULL;
 	unsigned long flags;
 	bool locked = false;
 
@@ -196,6 +254,8 @@ static unsigned long isolate_freepages_b
 		if (!pfn_valid_within(blockpfn))
 			goto strict_check;
 		nr_scanned++;
+		if (!valid_page)
+			valid_page = page;
 
 		if (!PageBuddy(page))
 			goto strict_check;
@@ -253,6 +313,10 @@ out:
 	if (locked)
 		spin_unlock_irqrestore(&cc->zone->lock, flags);
 
+	/* Update the pageblock-skip if the whole pageblock was scanned */
+	if (blockpfn == end_pfn)
+		update_pageblock_skip(valid_page, total_isolated);
+
 	return total_isolated;
 }
 
@@ -390,6 +454,7 @@ isolate_migratepages_range(struct zone *
 	struct lruvec *lruvec;
 	unsigned long flags;
 	bool locked = false;
+	struct page *page = NULL, *valid_page = NULL;
 
 	/*
 	 * Ensure that there are not too many pages isolated from the LRU
@@ -410,7 +475,6 @@ isolate_migratepages_range(struct zone *
 	/* Time to isolate some pages for migration */
 	cond_resched();
 	for (; low_pfn < end_pfn; low_pfn++) {
-		struct page *page;
 
 		/* give a chance to irqs before checking need_resched() */
 		if (locked && !((low_pfn+1) % SWAP_CLUSTER_MAX)) {
@@ -447,6 +511,14 @@ isolate_migratepages_range(struct zone *
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
@@ -456,7 +528,6 @@ isolate_migratepages_range(struct zone *
 		 * migration is optimistic to see if the minimum amount of work
 		 * satisfies the allocation
 		 */
-		pageblock_nr = low_pfn >> pageblock_order;
 		if (!cc->sync && last_pageblock_nr != pageblock_nr &&
 		    !migrate_async_suitable(get_pageblock_migratetype(page))) {
 			goto next_pageblock;
@@ -531,6 +602,10 @@ next_pageblock:
 	if (locked)
 		spin_unlock_irqrestore(&zone->lru_lock, flags);
 
+	/* Update the pageblock-skip if the whole pageblock was scanned */
+	if (low_pfn == end_pfn)
+		update_pageblock_skip(valid_page, nr_isolated);
+
 	trace_mm_compaction_isolate_migratepages(nr_scanned, nr_isolated);
 
 	return low_pfn;
@@ -594,6 +669,10 @@ static void isolate_freepages(struct zon
 		if (!suitable_migration_target(page))
 			continue;
 
+		/* If isolation recently failed, do not retry */
+		if (!isolation_suitable(cc, page))
+			continue;
+
 		/* Found a block suitable for isolating free pages from */
 		isolated = 0;
 		end_pfn = min(pfn + pageblock_nr_pages, zone_end_pfn);
@@ -710,8 +789,10 @@ static int compact_finished(struct zone 
 		return COMPACT_PARTIAL;
 
 	/* Compaction run completes if the migrate and free scanner meet */
-	if (cc->free_pfn <= cc->migrate_pfn)
+	if (cc->free_pfn <= cc->migrate_pfn) {
+		reset_isolation_suitable(cc->zone);
 		return COMPACT_COMPLETE;
+	}
 
 	/*
 	 * order == -1 is expected when compacting via
@@ -819,6 +900,10 @@ static int compact_zone(struct zone *zon
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
@@ -121,6 +121,7 @@ struct compact_control {
 	unsigned long free_pfn;		/* isolate_freepages search base */
 	unsigned long migrate_pfn;	/* isolate_migratepages search base */
 	bool sync;			/* Synchronous migration */
+	bool ignore_skip_hint;		/* Scan blocks even if marked skip */
 
 	int order;			/* order a direct compactor needs */
 	int migratetype;		/* MOVABLE, RECLAIMABLE etc */
diff -puN mm/page_alloc.c~mm-compaction-cache-if-a-pageblock-was-scanned-and-no-pages-were-isolated mm/page_alloc.c
--- a/mm/page_alloc.c~mm-compaction-cache-if-a-pageblock-was-scanned-and-no-pages-were-isolated
+++ a/mm/page_alloc.c
@@ -5690,6 +5690,7 @@ static int __alloc_contig_migrate_range(
 		.order = -1,
 		.zone = page_zone(pfn_to_page(start)),
 		.sync = true,
+		.ignore_skip_hint = true,
 	};
 	INIT_LIST_HEAD(&cc.migratepages);
 
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
mm-remove-__gfp_no_kswapd.patch
mm-compaction-update-comment-in-try_to_compact_pages.patch
mm-vmscan-scale-number-of-pages-reclaimed-by-reclaim-compaction-based-on-failures.patch
mm-vmscan-scale-number-of-pages-reclaimed-by-reclaim-compaction-based-on-failures-fix.patch
mm-compaction-capture-a-suitable-high-order-page-immediately-when-it-is-made-available.patch
revert-mm-mempolicy-let-vma_merge-and-vma_split-handle-vma-vm_policy-linkages.patch
mempolicy-remove-mempolicy-sharing.patch
mempolicy-fix-a-race-in-shared_policy_replace.patch
mempolicy-fix-refcount-leak-in-mpol_set_shared_policy.patch
mempolicy-fix-a-memory-corruption-by-refcount-imbalance-in-alloc_pages_vma.patch
mempolicy-fix-a-memory-corruption-by-refcount-imbalance-in-alloc_pages_vma-v2.patch
mm-cma-discard-clean-pages-during-contiguous-allocation-instead-of-migration.patch
mm-cma-discard-clean-pages-during-contiguous-allocation-instead-of-migration-fix.patch
mm-fix-tracing-in-free_pcppages_bulk.patch
mm-fix-tracing-in-free_pcppages_bulk-fix.patch
cma-fix-counting-of-isolated-pages.patch
cma-count-free-cma-pages.patch
cma-count-free-cma-pages-fix.patch
cma-fix-watermark-checking.patch
mm-page_alloc-use-get_freepage_migratetype-instead-of-page_private.patch
mm-remain-migratetype-in-freed-page.patch
memory-hotplug-bug-fix-race-between-isolation-and-allocation.patch
memory-hotplug-fix-pages-missed-by-race-rather-than-failing.patch
mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long.patch
mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long-fix.patch
mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long-fix-2.patch
mm-compaction-move-fatal-signal-check-out-of-compact_checklock_irqsave.patch
mm-compaction-update-try_to_compact_pageskerneldoc-comment.patch
mm-compaction-acquire-the-zone-lru_lock-as-late-as-possible.patch
mm-compaction-acquire-the-zone-lock-as-late-as-possible.patch
revert-mm-have-order-0-compaction-start-off-where-it-left.patch
mm-compaction-cache-if-a-pageblock-was-scanned-and-no-pages-were-isolated.patch
mm-compaction-restart-compaction-from-near-where-it-left-off.patch
mm-numa-reclaim-from-all-nodes-within-reclaim-distance.patch
mm-numa-reclaim-from-all-nodes-within-reclaim-distance-fix.patch
mm-thp-fix-pmd_present-for-split_huge_page-and-prot_none-with-thp.patch
mm-revert-0def08e3-mm-mempolicyc-check-return-code-of-check_range.patch
mm-revert-0def08e3-mm-mempolicyc-check-return-code-of-check_range-fix.patch

