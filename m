From: akpm@linux-foundation.org
Subject: [merged] cma-migrate-mlocked-pages.patch removed from -mm tree
Date: Tue, 09 Oct 2012 11:14:35 -0700
Message-ID: <20121009181435.C5E7A100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:43458 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756823Ab2JISOg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 14:14:36 -0400
Received: by mail-qa0-f74.google.com with SMTP id a16so519186qae.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 11:14:36 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, b.zolnierkie@samsung.com, m.szyprowski@samsung.com, mgorman@suse.de, mina86@mina86.com, mm-commits@vger.kernel.org


The patch titled
     Subject: CMA: migrate mlocked pages
has been removed from the -mm tree.  Its filename was
     cma-migrate-mlocked-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: CMA: migrate mlocked pages

Presently CMA cannot migrate mlocked pages so it ends up failing to allocate
contiguous memory space.

This patch makes mlocked pages be migrated out.  Of course, it can affect
realtime processes but in CMA usecase, contiguous memory allocation failing
is far worse than access latency to an mlocked page being variable while
CMA is running.  If someone wants to make the system realtime, he shouldn't
enable CMA because stalls can still happen at random times.

[akpm@linux-foundation.org: tweak comment text, per Mel]
Signed-off-by: Minchan Kim <minchan@kernel.org>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    2 ++
 mm/compaction.c        |    8 ++++++--
 mm/internal.h          |    2 +-
 mm/page_alloc.c        |    2 +-
 mm/vmscan.c            |    4 ++--
 5 files changed, 12 insertions(+), 6 deletions(-)

diff -puN include/linux/mmzone.h~cma-migrate-mlocked-pages include/linux/mmzone.h
--- a/include/linux/mmzone.h~cma-migrate-mlocked-pages
+++ a/include/linux/mmzone.h
@@ -218,6 +218,8 @@ struct lruvec {
 #define ISOLATE_UNMAPPED	((__force isolate_mode_t)0x2)
 /* Isolate for asynchronous migration */
 #define ISOLATE_ASYNC_MIGRATE	((__force isolate_mode_t)0x4)
+/* Isolate unevictable pages */
+#define ISOLATE_UNEVICTABLE	((__force isolate_mode_t)0x8)
 
 /* LRU Isolation modes. */
 typedef unsigned __bitwise__ isolate_mode_t;
diff -puN mm/compaction.c~cma-migrate-mlocked-pages mm/compaction.c
--- a/mm/compaction.c~cma-migrate-mlocked-pages
+++ a/mm/compaction.c
@@ -461,6 +461,7 @@ static bool too_many_isolated(struct zon
  * @cc:		Compaction control structure.
  * @low_pfn:	The first PFN of the range.
  * @end_pfn:	The one-past-the-last PFN of the range.
+ * @unevictable: true if it allows to isolate unevictable pages
  *
  * Isolate all pages that can be migrated from the range specified by
  * [low_pfn, end_pfn).  Returns zero if there is a fatal signal
@@ -476,7 +477,7 @@ static bool too_many_isolated(struct zon
  */
 unsigned long
 isolate_migratepages_range(struct zone *zone, struct compact_control *cc,
-			   unsigned long low_pfn, unsigned long end_pfn)
+		unsigned long low_pfn, unsigned long end_pfn, bool unevictable)
 {
 	unsigned long last_pageblock_nr = 0, pageblock_nr;
 	unsigned long nr_scanned = 0, nr_isolated = 0;
@@ -602,6 +603,9 @@ isolate_migratepages_range(struct zone *
 		if (!cc->sync)
 			mode |= ISOLATE_ASYNC_MIGRATE;
 
+		if (unevictable)
+			mode |= ISOLATE_UNEVICTABLE;
+
 		lruvec = mem_cgroup_page_lruvec(page, zone);
 
 		/* Try isolate the page */
@@ -807,7 +811,7 @@ static isolate_migrate_t isolate_migrate
 	}
 
 	/* Perform the isolation */
-	low_pfn = isolate_migratepages_range(zone, cc, low_pfn, end_pfn);
+	low_pfn = isolate_migratepages_range(zone, cc, low_pfn, end_pfn, false);
 	if (!low_pfn || cc->contended)
 		return ISOLATE_ABORT;
 
diff -puN mm/internal.h~cma-migrate-mlocked-pages mm/internal.h
--- a/mm/internal.h~cma-migrate-mlocked-pages
+++ a/mm/internal.h
@@ -138,7 +138,7 @@ isolate_freepages_range(struct compact_c
 			unsigned long start_pfn, unsigned long end_pfn);
 unsigned long
 isolate_migratepages_range(struct zone *zone, struct compact_control *cc,
-			   unsigned long low_pfn, unsigned long end_pfn);
+	unsigned long low_pfn, unsigned long end_pfn, bool unevictable);
 
 #endif
 
diff -puN mm/page_alloc.c~cma-migrate-mlocked-pages mm/page_alloc.c
--- a/mm/page_alloc.c~cma-migrate-mlocked-pages
+++ a/mm/page_alloc.c
@@ -5690,7 +5690,7 @@ static int __alloc_contig_migrate_range(
 		if (list_empty(&cc->migratepages)) {
 			cc->nr_migratepages = 0;
 			pfn = isolate_migratepages_range(cc->zone, cc,
-							 pfn, end);
+							 pfn, end, true);
 			if (!pfn) {
 				ret = -EINTR;
 				break;
diff -puN mm/vmscan.c~cma-migrate-mlocked-pages mm/vmscan.c
--- a/mm/vmscan.c~cma-migrate-mlocked-pages
+++ a/mm/vmscan.c
@@ -1009,8 +1009,8 @@ int __isolate_lru_page(struct page *page
 	if (!PageLRU(page))
 		return ret;
 
-	/* Do not give back unevictable pages for compaction */
-	if (PageUnevictable(page))
+	/* Compaction should not handle unevictable pages but CMA can do so */
+	if (PageUnevictable(page) && !(mode & ISOLATE_UNEVICTABLE))
 		return ret;
 
 	ret = -EBUSY;
_

Patches currently in -mm which might be from minchan@kernel.org are

origin.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
mm-memblock-reduce-overhead-in-binary-search.patch

