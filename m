From: akpm@linux-foundation.org
Subject: + mm-have-order-0-compaction-start-off-where-it-left.patch added to -mm tree
Date: Thu, 28 Jun 2012 13:59:48 -0700
Message-ID: <20120628205948.BD3BBA0329@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:37065 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754853Ab2F1U7u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Jun 2012 16:59:50 -0400
Received: by qcsu6 with SMTP id u6so257110qcs.1
        for <mm-commits@vger.kernel.org>; Thu, 28 Jun 2012 13:59:49 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: riel@redhat.com, jaschut@sandia.gov, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, minchan.kim@gmail.com


The patch titled
     Subject: mm: have order > 0 compaction start off where it left
has been added to the -mm tree.  Its filename is
     mm-have-order-0-compaction-start-off-where-it-left.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rik van Riel <riel@redhat.com>
Subject: mm: have order > 0 compaction start off where it left

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

The obvious solution is to have isolate_freepages remember where it left
off last time, and continue at that point the next time it gets invoked
for an order > 0 compaction.  This could cause compaction to fail if
cc->free_pfn and cc->migrate_pfn are close together initially, in that
case we restart from the end of the zone and try once more.

Forced full (order == -1) compactions are left alone.

Cc: Mel Gorman <mel@csn.ul.ie>
Reported-by: Jim Schutt <jaschut@sandia.gov>
Signed-off-by: Rik van Riel <riel@redhat.com>
Tested-by: Jim Schutt <jaschut@sandia.gov>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    4 +++
 mm/compaction.c        |   48 +++++++++++++++++++++++++++++++++++----
 mm/internal.h          |    2 +
 mm/page_alloc.c        |    5 ++++
 4 files changed, 55 insertions(+), 4 deletions(-)

diff -puN include/linux/mmzone.h~mm-have-order-0-compaction-start-off-where-it-left include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-have-order-0-compaction-start-off-where-it-left
+++ a/include/linux/mmzone.h
@@ -367,6 +367,10 @@ struct zone {
 	 */
 	spinlock_t		lock;
 	int                     all_unreclaimable; /* All pages pinned */
+#if defined CONFIG_COMPACTION || defined CONFIG_CMA
+	/* pfn where the last order > 0 compaction isolated free pages */
+	unsigned long		compact_cached_free_pfn;
+#endif
 #ifdef CONFIG_MEMORY_HOTPLUG
 	/* see spanned/present_pages for more description */
 	seqlock_t		span_seqlock;
diff -puN mm/compaction.c~mm-have-order-0-compaction-start-off-where-it-left mm/compaction.c
--- a/mm/compaction.c~mm-have-order-0-compaction-start-off-where-it-left
+++ a/mm/compaction.c
@@ -422,6 +422,17 @@ static void isolate_freepages(struct zon
 					pfn -= pageblock_nr_pages) {
 		unsigned long isolated;
 
+		/*
+		 * Skip ahead if another thread is compacting in the area
+		 * simultaneously. If we wrapped around, we can only skip
+		 * ahead if zone->compact_cached_free_pfn also wrapped to
+		 * above our starting point.
+		 */
+		if (cc->order > 0 && (!cc->wrapped ||
+				      zone->compact_cached_free_pfn >
+				      cc->start_free_pfn))
+			pfn = min(pfn, zone->compact_cached_free_pfn);
+
 		if (!pfn_valid(pfn))
 			continue;
 
@@ -463,6 +474,8 @@ static void isolate_freepages(struct zon
 		 */
 		if (isolated)
 			high_pfn = max(high_pfn, pfn);
+		if (cc->order > 0)
+			zone->compact_cached_free_pfn = high_pfn;
 	}
 
 	/* split_free_page does not map the pages */
@@ -565,8 +578,27 @@ static int compact_finished(struct zone 
 	if (fatal_signal_pending(current))
 		return COMPACT_PARTIAL;
 
-	/* Compaction run completes if the migrate and free scanner meet */
-	if (cc->free_pfn <= cc->migrate_pfn)
+	/*
+	 * A full (order == -1) compaction run starts at the beginning and
+	 * end of a zone; it completes when the migrate and free scanner meet. 
+	 * A partial (order > 0) compaction can start with the free scanner
+	 * at a random point in the zone, and may have to restart.
+	 */
+	if (cc->free_pfn <= cc->migrate_pfn) {
+		if (cc->order > 0 && !cc->wrapped) {
+			/* We started partway through; restart at the end. */
+			unsigned long free_pfn;
+			free_pfn = zone->zone_start_pfn + zone->spanned_pages;
+			free_pfn &= ~(pageblock_nr_pages-1);
+			zone->compact_cached_free_pfn = free_pfn;
+			cc->wrapped = 1;
+			return COMPACT_CONTINUE;
+		}
+		return COMPACT_COMPLETE;
+	}
+
+	/* We wrapped around and ended up where we started. */
+	if (cc->wrapped && cc->free_pfn <= cc->start_free_pfn)
 		return COMPACT_COMPLETE;
 
 	/*
@@ -664,8 +696,16 @@ static int compact_zone(struct zone *zon
 
 	/* Setup to move all movable pages to the end of the zone */
 	cc->migrate_pfn = zone->zone_start_pfn;
-	cc->free_pfn = cc->migrate_pfn + zone->spanned_pages;
-	cc->free_pfn &= ~(pageblock_nr_pages-1);
+
+	if (cc->order > 0) {
+		/* Incremental compaction. Start where the last one stopped. */
+		cc->free_pfn = zone->compact_cached_free_pfn;
+		cc->start_free_pfn = cc->free_pfn;
+	} else {
+		/* Order == -1 starts at the end of the zone. */
+		cc->free_pfn = cc->migrate_pfn + zone->spanned_pages;
+		cc->free_pfn &= ~(pageblock_nr_pages-1);
+	}
 
 	migrate_prep_local();
 
diff -puN mm/internal.h~mm-have-order-0-compaction-start-off-where-it-left mm/internal.h
--- a/mm/internal.h~mm-have-order-0-compaction-start-off-where-it-left
+++ a/mm/internal.h
@@ -118,8 +118,10 @@ struct compact_control {
 	unsigned long nr_freepages;	/* Number of isolated free pages */
 	unsigned long nr_migratepages;	/* Number of pages to migrate */
 	unsigned long free_pfn;		/* isolate_freepages search base */
+	unsigned long start_free_pfn;	/* where we started the search */
 	unsigned long migrate_pfn;	/* isolate_migratepages search base */
 	bool sync;			/* Synchronous migration */
+	bool wrapped;			/* Last round for order>0 compaction */
 
 	int order;			/* order a direct compactor needs */
 	int migratetype;		/* MOVABLE, RECLAIMABLE etc */
diff -puN mm/page_alloc.c~mm-have-order-0-compaction-start-off-where-it-left mm/page_alloc.c
--- a/mm/page_alloc.c~mm-have-order-0-compaction-start-off-where-it-left
+++ a/mm/page_alloc.c
@@ -4396,6 +4396,11 @@ static void __paginginit free_area_init_
 
 		zone->spanned_pages = size;
 		zone->present_pages = realsize;
+#if defined CONFIG_COMPACTION || defined CONFIG_CMA
+		zone->compact_cached_free_pfn = zone->zone_start_pfn +
+						zone->spanned_pages;
+		zone->compact_cached_free_pfn &= ~(pageblock_nr_pages-1);
+#endif
 #ifdef CONFIG_NUMA
 		zone->node = nid;
 		zone->min_unmapped_pages = (realsize*sysctl_min_unmapped_ratio)
_
Subject: Subject: mm: have order > 0 compaction start off where it left

Patches currently in -mm which might be from riel@redhat.com are

linux-next.patch
mm-thp-abort-compaction-if-migration-page-cannot-be-charged-to-memcg.patch
swap-allow-swap-readahead-to-be-merged.patch
memcg-prevent-oom-with-too-many-dirty-pages.patch
mm-clear-pages_scanned-only-if-draining-a-pcp-adds-pages-to-the-buddy-allocator-again.patch
mm-fix-page-reclaim-comment-error.patch
mm-remove-unused-lru_all_evictable.patch
mm-have-order-0-compaction-start-off-where-it-left.patch
tmpfs-implement-numa-node-interleaving.patch
tmpfs-implement-numa-node-interleaving-fix.patch

