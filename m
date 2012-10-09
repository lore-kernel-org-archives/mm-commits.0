From: akpm@linux-foundation.org
Subject: [merged] mm-compaction-clear-pg_migrate_skip-based-on-compaction-and-reclaim-activity.patch removed from -mm tree
Date: Tue, 09 Oct 2012 11:12:40 -0700
Message-ID: <20121009181241.4CBED20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:41968 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756748Ab2JISMn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 14:12:43 -0400
Received: by mail-bk0-f74.google.com with SMTP id q16so362365bkw.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 11:12:43 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, aquini@redhat.com, avi@redhat.com, richard@arachsys.com, riel@redhat.com, shli@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: compaction: clear PG_migrate_skip based on compaction and reclaim activity
has been removed from the -mm tree.  Its filename was
     mm-compaction-clear-pg_migrate_skip-based-on-compaction-and-reclaim-activity.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -370,7 +370,8 @@ struct zone {
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
@@ -102,9 +93,24 @@ static void reset_isolation_suitable(str
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
@@ -820,7 +826,15 @@ static int compact_finished(struct zone 
 
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
 
@@ -943,9 +957,13 @@ static int compact_zone(struct zone *zon
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
@@ -2172,6 +2172,7 @@ __alloc_pages_direct_compact(gfp_t gfp_m
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

origin.patch

