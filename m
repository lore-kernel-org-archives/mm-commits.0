From: akpm@linux-foundation.org
Subject: + mm-compaction-cache-if-a-pageblock-was-scanned-and-no-pages-were-isolated-fix3.patch added to -mm tree
Date: Mon, 08 Oct 2012 12:14:05 -0700
Message-ID: <20121008191406.39C845C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ea0-f202.google.com ([209.85.215.202]:61266 "EHLO
	mail-ea0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753498Ab2JHTOJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Oct 2012 15:14:09 -0400
Received: by mail-ea0-f202.google.com with SMTP id q10so33966eaa.1
        for <mm-commits@vger.kernel.org>; Mon, 08 Oct 2012 12:14:08 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mgorman@suse.de, b.zolnierkie@samsung.com, broonie@opensource.wolfsonmicro.com, kyungmin.park@samsung.com, m.szyprowski@samsung.com, mina86@mina86.com, peter.ujfalusi@ti.com, thierry.reding@avionic-design.de


The patch titled
     Subject: mm-compaction-cache-if-a-pageblock-was-scanned-and-no-pages-were-isolated-fix3
has been added to the -mm tree.  Its filename is
     mm-compaction-cache-if-a-pageblock-was-scanned-and-no-pages-were-isolated-fix3.patch

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
Subject: mm-compaction-cache-if-a-pageblock-was-scanned-and-no-pages-were-isolated-fix3

The following patch still has not been tested but I'm reposting it
anyway. I've sent a rebased patch on top of next-20121004 that includes
this patch privately to Thierry for testing.

CMA requires that the PG_migrate_skip hint be skipped but it was only
skipping it when isolating pages for migration, not for free. Ensure
cc->isolate_skip_hint gets passed in both cases.

This is a fix for
mm-compaction-cache-if-a-pageblock-was-scanned-and-no-pages-were-isolated-fix.patch
but is based on top of linux-next/akpm as of 20121004. It will cause
minor conflicts when it is slotted into place but the resolutions should
be straight-forward.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Minchan Kim <minchan@kernel.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   16 ++++------------
 mm/internal.h   |    3 ++-
 mm/page_alloc.c |   39 ++++++++++++++++++++-------------------
 3 files changed, 26 insertions(+), 32 deletions(-)

diff -puN mm/compaction.c~mm-compaction-cache-if-a-pageblock-was-scanned-and-no-pages-were-isolated-fix3 mm/compaction.c
--- a/mm/compaction.c~mm-compaction-cache-if-a-pageblock-was-scanned-and-no-pages-were-isolated-fix3
+++ a/mm/compaction.c
@@ -346,22 +346,14 @@ static unsigned long isolate_freepages_b
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
@@ -371,7 +363,7 @@ isolate_freepages_range(unsigned long st
 		block_end_pfn = ALIGN(pfn + 1, pageblock_nr_pages);
 		block_end_pfn = min(block_end_pfn, end_pfn);
 
-		isolated = isolate_freepages_block(&cc, pfn, block_end_pfn,
+		isolated = isolate_freepages_block(cc, pfn, block_end_pfn,
 						   &freelist, true);
 
 		/*
diff -puN mm/internal.h~mm-compaction-cache-if-a-pageblock-was-scanned-and-no-pages-were-isolated-fix3 mm/internal.h
--- a/mm/internal.h~mm-compaction-cache-if-a-pageblock-was-scanned-and-no-pages-were-isolated-fix3
+++ a/mm/internal.h
@@ -131,7 +131,8 @@ struct compact_control {
 };
 
 unsigned long
-isolate_freepages_range(unsigned long start_pfn, unsigned long end_pfn);
+isolate_freepages_range(struct compact_control *cc,
+			unsigned long start_pfn, unsigned long end_pfn);
 unsigned long
 isolate_migratepages_range(struct zone *zone, struct compact_control *cc,
 			   unsigned long low_pfn, unsigned long end_pfn);
diff -puN mm/page_alloc.c~mm-compaction-cache-if-a-pageblock-was-scanned-and-no-pages-were-isolated-fix3 mm/page_alloc.c
--- a/mm/page_alloc.c~mm-compaction-cache-if-a-pageblock-was-scanned-and-no-pages-were-isolated-fix3
+++ a/mm/page_alloc.c
@@ -5678,7 +5678,8 @@ __alloc_contig_migrate_alloc(struct page
 }
 
 /* [start, end) must belong to a single zone. */
-static int __alloc_contig_migrate_range(unsigned long start, unsigned long end)
+static int __alloc_contig_migrate_range(struct compact_control *cc,
+					unsigned long start, unsigned long end)
 {
 	/* This function is based on compact_zone() from compaction.c. */
 
@@ -5686,26 +5687,17 @@ static int __alloc_contig_migrate_range(
 	unsigned int tries = 0;
 	int ret = 0;
 
-	struct compact_control cc = {
-		.nr_migratepages = 0,
-		.order = -1,
-		.zone = page_zone(pfn_to_page(start)),
-		.sync = true,
-		.ignore_skip_hint = true,
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
@@ -5717,14 +5709,14 @@ static int __alloc_contig_migrate_range(
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
 
@@ -5803,6 +5795,15 @@ int alloc_contig_range(unsigned long sta
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
@@ -5832,7 +5833,7 @@ int alloc_contig_range(unsigned long sta
 	if (ret)
 		goto done;
 
-	ret = __alloc_contig_migrate_range(start, end);
+	ret = __alloc_contig_migrate_range(&cc, start, end);
 	if (ret)
 		goto done;
 
@@ -5881,7 +5882,7 @@ int alloc_contig_range(unsigned long sta
 	__reclaim_pages(zone, GFP_HIGHUSER_MOVABLE, end-start);
 
 	/* Grab isolated pages from freelists. */
-	outer_end = isolate_freepages_range(outer_start, end);
+	outer_end = isolate_freepages_range(&cc, outer_start, end);
 	if (!outer_end) {
 		ret = -EBUSY;
 		goto done;
_

Patches currently in -mm which might be from mgorman@suse.de are

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
mm-compaction-acquire-the-zone-lock-as-late-as-possible-fix-3.patch
revert-mm-have-order-0-compaction-start-off-where-it-left.patch
mm-compaction-cache-if-a-pageblock-was-scanned-and-no-pages-were-isolated.patch
mm-compaction-cache-if-a-pageblock-was-scanned-and-no-pages-were-isolated-fix.patch
mm-compaction-cache-if-a-pageblock-was-scanned-and-no-pages-were-isolated-fix2.patch
mm-compaction-cache-if-a-pageblock-was-scanned-and-no-pages-were-isolated-fix3.patch
mm-compaction-restart-compaction-from-near-where-it-left-off.patch
mm-compaction-restart-compaction-from-near-where-it-left-off-fix.patch
mm-compaction-clear-pg_migrate_skip-based-on-compaction-and-reclaim-activity.patch
mm-numa-reclaim-from-all-nodes-within-reclaim-distance.patch
mm-numa-reclaim-from-all-nodes-within-reclaim-distance-fix.patch
mm-numa-reclaim-from-all-nodes-within-reclaim-distance-fix-fix.patch
mm-thp-fix-pmd_present-for-split_huge_page-and-prot_none-with-thp.patch
mm-revert-0def08e3-mm-mempolicyc-check-return-code-of-check_range.patch
mm-revert-0def08e3-mm-mempolicyc-check-return-code-of-check_range-fix.patch
cma-migrate-mlocked-pages.patch
cma-migrate-mlocked-pages-fix.patch
cma-decrease-ccnr_migratepages-after-reclaiming-pagelist.patch
make-gfp_notrack-definition-unconditional.patch

