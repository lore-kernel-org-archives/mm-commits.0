From: akpm@linux-foundation.org
Subject: + cma-migrate-mlocked-pages.patch added to -mm tree
Date: Wed, 26 Sep 2012 14:36:00 -0700
Message-ID: <20120926213600.A52AF100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:59431 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994Ab2IZVgB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 26 Sep 2012 17:36:01 -0400
Received: by qcqs25 with SMTP id s25so131631qcq.1
        for <mm-commits@vger.kernel.org>; Wed, 26 Sep 2012 14:36:01 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: minchan@kernel.org, b.zolnierkie@samsung.com, m.szyprowski@samsung.com, mgorman@suse.de, mina86@mina86.com


The patch titled
     Subject: CMA: migrate mlocked pages
has been added to the -mm tree.  Its filename is
     cma-migrate-mlocked-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Mel Gorman <mgorman@suse.de>
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

diff -puN include/linux/mmzone.h~cma-migrate-mlocked-page include/linux/mmzone.h
--- a/include/linux/mmzone.h~cma-migrate-mlocked-page
+++ a/include/linux/mmzone.h
@@ -218,6 +218,8 @@ struct lruvec {
 #define ISOLATE_UNMAPPED	((__force isolate_mode_t)0x2)
 /* Isolate for asynchronous migration */
 #define ISOLATE_ASYNC_MIGRATE	((__force isolate_mode_t)0x4)
+/* Isolate unevictable pages */
+#define ISOLATE_UNEVICTABLE	((__force isolate_mode_t)0x8)
 
 /* LRU Isolation modes. */
 typedef unsigned __bitwise__ isolate_mode_t;
diff -puN mm/compaction.c~cma-migrate-mlocked-page mm/compaction.c
--- a/mm/compaction.c~cma-migrate-mlocked-page
+++ a/mm/compaction.c
@@ -445,6 +445,7 @@ static bool too_many_isolated(struct zon
  * @cc:		Compaction control structure.
  * @low_pfn:	The first PFN of the range.
  * @end_pfn:	The one-past-the-last PFN of the range.
+ * @unevictable: true if it allows to isolate unevictable pages
  *
  * Isolate all pages that can be migrated from the range specified by
  * [low_pfn, end_pfn).  Returns zero if there is a fatal signal
@@ -460,7 +461,7 @@ static bool too_many_isolated(struct zon
  */
 unsigned long
 isolate_migratepages_range(struct zone *zone, struct compact_control *cc,
-			   unsigned long low_pfn, unsigned long end_pfn)
+		unsigned long low_pfn, unsigned long end_pfn, bool unevictable)
 {
 	unsigned long last_pageblock_nr = 0, pageblock_nr;
 	unsigned long nr_scanned = 0, nr_isolated = 0;
@@ -586,6 +587,9 @@ isolate_migratepages_range(struct zone *
 		if (!cc->sync)
 			mode |= ISOLATE_ASYNC_MIGRATE;
 
+		if (unevictable)
+			mode |= ISOLATE_UNEVICTABLE;
+
 		lruvec = mem_cgroup_page_lruvec(page, zone);
 
 		/* Try isolate the page */
@@ -791,7 +795,7 @@ static isolate_migrate_t isolate_migrate
 	}
 
 	/* Perform the isolation */
-	low_pfn = isolate_migratepages_range(zone, cc, low_pfn, end_pfn);
+	low_pfn = isolate_migratepages_range(zone, cc, low_pfn, end_pfn, false);
 	if (!low_pfn || cc->contended)
 		return ISOLATE_ABORT;
 
diff -puN mm/internal.h~cma-migrate-mlocked-page mm/internal.h
--- a/mm/internal.h~cma-migrate-mlocked-page
+++ a/mm/internal.h
@@ -138,7 +138,7 @@ unsigned long
 isolate_freepages_range(unsigned long start_pfn, unsigned long end_pfn);
 unsigned long
 isolate_migratepages_range(struct zone *zone, struct compact_control *cc,
-			   unsigned long low_pfn, unsigned long end_pfn);
+	unsigned long low_pfn, unsigned long end_pfn, bool unevictable);
 
 #endif
 
diff -puN mm/page_alloc.c~cma-migrate-mlocked-page mm/page_alloc.c
--- a/mm/page_alloc.c~cma-migrate-mlocked-page
+++ a/mm/page_alloc.c
@@ -5688,7 +5688,7 @@ static int __alloc_contig_migrate_range(
 		if (list_empty(&cc.migratepages)) {
 			cc.nr_migratepages = 0;
 			pfn = isolate_migratepages_range(cc.zone, &cc,
-							 pfn, end);
+							 pfn, end, true);
 			if (!pfn) {
 				ret = -EINTR;
 				break;
diff -puN mm/vmscan.c~cma-migrate-mlocked-page mm/vmscan.c
--- a/mm/vmscan.c~cma-migrate-mlocked-page
+++ a/mm/vmscan.c
@@ -1009,8 +1009,8 @@ int __isolate_lru_page(struct page *page
 	if (!PageLRU(page))
 		return ret;
 
-	/* Do not give back unevictable pages for compaction */
-	if (PageUnevictable(page))
+	/* Compaction can't handle unevictable pages but CMA can do */
+	if (PageUnevictable(page) && !(mode & ISOLATE_UNEVICTABLE))
 		return ret;
 
 	ret = -EBUSY;
_

Patches currently in -mm which might be from minchan@kernel.org are

linux-next.patch
mm-remove-__gfp_no_kswapd.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix-fix.patch
mm-compaction-update-comment-in-try_to_compact_pages.patch
mm-vmscan-scale-number-of-pages-reclaimed-by-reclaim-compaction-based-on-failures.patch
mm-vmscan-scale-number-of-pages-reclaimed-by-reclaim-compaction-based-on-failures-fix.patch
mm-compaction-capture-a-suitable-high-order-page-immediately-when-it-is-made-available.patch
mm-cma-discard-clean-pages-during-contiguous-allocation-instead-of-migration.patch
mm-cma-discard-clean-pages-during-contiguous-allocation-instead-of-migration-fix.patch
mm-cma-discard-clean-pages-during-contiguous-allocation-instead-of-migration-fix-fix.patch
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
memory-hotplug-fix-pages-missed-by-race-rather-than-failng-fix.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
mm-memblock-reduce-overhead-in-binary-search.patch
mm-memblock-use-existing-interface-to-set-nid.patch
mm-memblock-cleanup-early_node_map-related-comments.patch
mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long.patch
mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long-fix.patch
mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long-fix-2.patch
mm-compaction-move-fatal-signal-check-out-of-compact_checklock_irqsave.patch
mm-compaction-acquire-the-zone-lru_lock-as-late-as-possible-fix.patch
mm-compaction-acquire-the-zone-lru_lock-as-late-as-possible-fix-fix.patch
mm-compaction-acquire-the-zone-lock-as-late-as-possible.patch
revert-mm-have-order-0-compaction-start-off-where-it-left.patch
mm-page_alloc-refactor-out-__alloc_contig_migrate_alloc.patch
mm-page_alloc-refactor-out-__alloc_contig_migrate_alloc-checkpatch-fixes.patch
memory-hotplug-dont-replace-lowmem-pages-with-highmem.patch
mm-enable-config_compaction-by-default.patch
mm-numa-reclaim-from-all-nodes-within-reclaim-distance.patch
mm-numa-reclaim-from-all-nodes-within-reclaim-distance-fix.patch
mm-revert-0def08e3-mm-mempolicyc-check-return-code-of-check_range.patch
mm-revert-0def08e3-mm-mempolicyc-check-return-code-of-check_range-fix.patch
memory-hotplug-fix-zone-stat-mismatch.patch
cma-migrate-mlocked-pages.patch
cma-decrease-ccnr_migratepages-after-reclaiming-pagelist.patch

