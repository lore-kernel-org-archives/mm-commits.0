From: akpm@linux-foundation.org
Subject: + mm-compaction-clear-pg_migrate_skip-based-on-compaction-and-reclaim-activity.patch added to -mm tree
Date: Thu, 27 Sep 2012 14:04:02 -0700
Message-ID: <20120927210403.421C820004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:43597 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755164Ab2I0VEG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 27 Sep 2012 17:04:06 -0400
Received: by weyx43 with SMTP id x43so112042wey.1
        for <mm-commits@vger.kernel.org>; Thu, 27 Sep 2012 14:04:04 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mgorman@suse.de, aquini@redhat.com, avi@redhat.com, richard@arachsys.com, riel@redhat.com, shli@kernel.org


The patch titled
     Subject: mm: compaction: clear PG_migrate_skip based on compaction and reclaim activity
has been added to the -mm tree.  Its filename is
     mm-compaction-clear-pg_migrate_skip-based-on-compaction-and-reclaim-activity.patch

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
Subject: mm: compaction: clear PG_migrate_skip based on compaction and reclaim activity

Compaction caches if a pageblock was scanned and no pages were isolated so
that the pageblocks can be skipped in the future to reduce scanning.  This
information is not cleared by the page allocator based on activity due to
the impact it would have to the page allocator fast paths.  Hence there is
a requirement that something clear the cache or pageblocks will be skipped
forever.  Currently the cache is cleared if there were a number of recent
allocation failures and it has not been cleared within the last 5 seconds.
Time-based decisions like this are terrible as they have no relationship
to VM activity and is basically a big hammer.

Unfortunately, accurate heuristics would add cost to some hot paths so
this patch implements a rough heuristic.  There are two cases where the
cache is cleared.

1. If a !kswapd process completes a compaction cycle (migrate and free
   scanner meet), the zone is marked compact_blockskip_flush. When kswapd
   goes to sleep, it will clear the cache. This is expected to be the
   common case where the cache is cleared. It does not really matter if
   kswapd happens to be asleep or going to sleep when the flag is set as
   it will be woken on the next allocation request.

2. If there have been multiple failures recently and compaction just
   finished being deferred then a process will clear the cache and start a
   full scan.  This situation happens if there are multiple high-order
   allocation requests under heavy memory pressure.

The clearing of the PG_migrate_skip bits and other scans is inherently
racy but the race is harmless.  For allocations that can fail such as THP,
they will simply fail.  For requests that cannot fail, they will retry the
allocation.  Tests indicated that scanning rates were roughly similar to
when the time-based heuristic was used and the allocation success rates
were similar.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Richard Davies <richard@arachsys.com>
Cc: Shaohua Li <shli@kernel.org>
Cc: Avi Kivity <avi@redhat.com>
Cc: Rafael Aquini <aquini@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compaction.h |   15 ++++++++++
 include/linux/mmzone.h     |    3 +-
 mm/compaction.c            |   50 +++++++++++++++++++++++------------
 mm/page_alloc.c            |    1 
 mm/vmscan.c                |    8 +++++
 5 files changed, 60 insertions(+), 17 deletions(-)

diff -puN include/linux/compaction.h~mm-compaction-clear-pg_migrate_skip-based-on-compaction-and-reclaim-activity include/linux/compaction.h
--- a/include/linux/compaction.h~mm-compaction-clear-pg_migrate_skip-based-on-compaction-and-reclaim-activity
+++ a/include/linux/compaction.h
@@ -24,6 +24,7 @@ extern unsigned long try_to_compact_page
 			int order, gfp_t gfp_mask, nodemask_t *mask,
 			bool sync, bool *contended, struct page **page);
 extern int compact_pgdat(pg_data_t *pgdat, int order);
+extern void reset_isolation_suitable(pg_data_t *pgdat);
 extern unsigned long compaction_suitable(struct zone *zone, int order);
 
 /* Do not skip compaction more than 64 times */
@@ -61,6 +62,16 @@ static inline bool compaction_deferred(s
 	return zone->compact_considered < defer_limit;
 }
 
+/* Returns true if restarting compaction after many failures */
+static inline bool compaction_restarting(struct zone *zone, int order)
+{
+	if (order < zone->compact_order_failed)
+		return false;
+
+	return zone->compact_defer_shift == COMPACT_MAX_DEFER_SHIFT &&
+		zone->compact_considered >= 1UL << zone->compact_defer_shift;
+}
+
 #else
 static inline unsigned long try_to_compact_pages(struct zonelist *zonelist,
 			int order, gfp_t gfp_mask, nodemask_t *nodemask,
@@ -74,6 +85,10 @@ static inline int compact_pgdat(pg_data_
 	return COMPACT_CONTINUE;
 }
 
+static inline void reset_isolation_suitable(pg_data_t *pgdat)
+{
+}
+
 static inline unsigned long compaction_suitable(struct zone *zone, int order)
 {
 	return COMPACT_SKIPPED;
diff -puN include/linux/mmzone.h~mm-compaction-clear-pg_migrate_skip-based-on-compaction-and-reclaim-activity include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-compaction-clear-pg_migrate_skip-based-on-compaction-and-reclaim-activity
+++ a/include/linux/mmzone.h
@@ -369,7 +369,8 @@ struct zone {
 	spinlock_t		lock;
 	int                     all_unreclaimable; /* All pages pinned */
 #if defined CONFIG_COMPACTION || defined CONFIG_CMA
-	unsigned long		compact_blockskip_expire;
+	/* Set to true when the PG_migrate_skip bits should be cleared */
+	bool			compact_blockskip_flush;
 
 	/* pfns where compaction scanners should start */
 	unsigned long		compact_cached_free_pfn;
diff -puN mm/compaction.c~mm-compaction-clear-pg_migrate_skip-based-on-compaction-and-reclaim-activity mm/compaction.c
--- a/mm/compaction.c~mm-compaction-clear-pg_migrate_skip-based-on-compaction-and-reclaim-activity
+++ a/mm/compaction.c
@@ -66,24 +66,15 @@ static inline bool isolation_suitable(st
  * should be skipped for page isolation when the migrate and free page scanner
  * meet.
  */
-static void reset_isolation_suitable(struct zone *zone)
+static void __reset_isolation_suitable(struct zone *zone)
 {
 	unsigned long start_pfn = zone->zone_start_pfn;
 	unsigned long end_pfn = zone->zone_start_pfn + zone->spanned_pages;
 	unsigned long pfn;
 
-	/*
-	 * Do not reset more than once every five seconds. If allocations are
-	 * failing sufficiently quickly to allow this to happen then continually
-	 * scanning for compaction is not going to help. The choice of five
-	 * seconds is arbitrary but will mitigate excessive scanning.
-	 */
-	if (time_before(jiffies, zone->compact_blockskip_expire))
-		return;
-
 	zone->compact_cached_migrate_pfn = start_pfn;
 	zone->compact_cached_free_pfn = end_pfn;
-	zone->compact_blockskip_expire = jiffies + (HZ * 5);
+	zone->compact_blockskip_flush = false;
 
 	/* Walk the zone and mark every pageblock as suitable for isolation */
 	for (pfn = start_pfn; pfn < end_pfn; pfn += pageblock_nr_pages) {
@@ -99,9 +90,24 @@ static void reset_isolation_suitable(str
 	}
 }
 
+void reset_isolation_suitable(pg_data_t *pgdat)
+{
+	int zoneid;
+
+	for (zoneid = 0; zoneid < MAX_NR_ZONES; zoneid++) {
+		struct zone *zone = &pgdat->node_zones[zoneid];
+		if (!populated_zone(zone))
+			continue;
+
+		/* Only flush if a full compaction finished recently */
+		if (zone->compact_blockskip_flush)
+			__reset_isolation_suitable(zone);
+	}
+}
+
 /*
  * If no pages were isolated then mark this pageblock to be skipped in the
- * future. The information is later cleared by reset_isolation_suitable().
+ * future. The information is later cleared by __reset_isolation_suitable().
  */
 static void update_pageblock_skip(struct compact_control *cc,
 			struct page *page, unsigned long nr_isolated,
@@ -822,7 +828,15 @@ static int compact_finished(struct zone 
 
 	/* Compaction run completes if the migrate and free scanner meet */
 	if (cc->free_pfn <= cc->migrate_pfn) {
-		reset_isolation_suitable(cc->zone);
+		/*
+		 * Mark that the PG_migrate_skip information should be cleared
+		 * by kswapd when it goes to sleep. kswapd does not set the
+		 * flag itself as the decision to be clear should be directly
+		 * based on an allocation request.
+		 */
+		if (!current_is_kswapd())
+			zone->compact_blockskip_flush = true;
+
 		return COMPACT_COMPLETE;
 	}
 
@@ -945,9 +959,13 @@ static int compact_zone(struct zone *zon
 		zone->compact_cached_migrate_pfn = cc->migrate_pfn;
 	}
 
-	/* Clear pageblock skip if there are numerous alloc failures */
-	if (zone->compact_defer_shift == COMPACT_MAX_DEFER_SHIFT)
-		reset_isolation_suitable(zone);
+	/*
+	 * Clear pageblock skip if there were failures recently and compaction
+	 * is about to be retried after being deferred. kswapd does not do
+	 * this reset as it'll reset the cached information when going to sleep.
+	 */
+	if (compaction_restarting(zone, cc->order) && !current_is_kswapd())
+		__reset_isolation_suitable(zone);
 
 	migrate_prep_local();
 
diff -puN mm/page_alloc.c~mm-compaction-clear-pg_migrate_skip-based-on-compaction-and-reclaim-activity mm/page_alloc.c
--- a/mm/page_alloc.c~mm-compaction-clear-pg_migrate_skip-based-on-compaction-and-reclaim-activity
+++ a/mm/page_alloc.c
@@ -2171,6 +2171,7 @@ __alloc_pages_direct_compact(gfp_t gfp_m
 				preferred_zone, migratetype);
 		if (page) {
 got_page:
+			preferred_zone->compact_blockskip_flush = false;
 			preferred_zone->compact_considered = 0;
 			preferred_zone->compact_defer_shift = 0;
 			if (order >= preferred_zone->compact_order_failed)
diff -puN mm/vmscan.c~mm-compaction-clear-pg_migrate_skip-based-on-compaction-and-reclaim-activity mm/vmscan.c
--- a/mm/vmscan.c~mm-compaction-clear-pg_migrate_skip-based-on-compaction-and-reclaim-activity
+++ a/mm/vmscan.c
@@ -2895,6 +2895,14 @@ static void kswapd_try_to_sleep(pg_data_
 		 */
 		set_pgdat_percpu_threshold(pgdat, calculate_normal_threshold);
 
+		/*
+		 * Compaction records what page blocks it recently failed to
+		 * isolate pages from and skips them in the future scanning.
+		 * When kswapd is going to sleep, it is reasonable to assume
+		 * that pages and compaction may succeed so reset the cache.
+		 */
+		reset_isolation_suitable(pgdat);
+
 		if (!kthread_should_stop())
 			schedule();
 
_

Patches currently in -mm which might be from mgorman@suse.de are

thp-avoid-vm_bug_on-page_countpage-false-positives-in-__collapse_huge_page_copy.patch
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
cma-fix-watermark-checking-fix.patch
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
mm-compaction-acquire-the-zone-lru_lock-as-late-as-possible-fix.patch
mm-compaction-acquire-the-zone-lru_lock-as-late-as-possible-fix-fix.patch
mm-compaction-acquire-the-zone-lock-as-late-as-possible.patch
mm-compaction-acquire-the-zone-lock-as-late-as-possible-fix-2.patch
revert-mm-have-order-0-compaction-start-off-where-it-left.patch
mm-compaction-cache-if-a-pageblock-was-scanned-and-no-pages-were-isolated.patch
mm-compaction-cache-if-a-pageblock-was-scanned-and-no-pages-were-isolated-fix.patch
mm-compaction-restart-compaction-from-near-where-it-left-off.patch
mm-compaction-clear-pg_migrate_skip-based-on-compaction-and-reclaim-activity.patch
mm-numa-reclaim-from-all-nodes-within-reclaim-distance.patch
mm-numa-reclaim-from-all-nodes-within-reclaim-distance-fix.patch
mm-numa-reclaim-from-all-nodes-within-reclaim-distance-fix-fix.patch
mm-thp-fix-pmd_present-for-split_huge_page-and-prot_none-with-thp.patch
mm-revert-0def08e3-mm-mempolicyc-check-return-code-of-check_range.patch
mm-revert-0def08e3-mm-mempolicyc-check-return-code-of-check_range-fix.patch
cma-migrate-mlocked-pages.patch
cma-decrease-ccnr_migratepages-after-reclaiming-pagelist.patch

