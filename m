From: akpm@linux-foundation.org
Subject: [folded-dropped] mm-compaction-acquire-the-zone-lock-as-late-as-possible-fix-2.patch removed from -mm tree
Date: Mon, 08 Oct 2012 16:12:19 -0700
Message-ID: <20121008231220.A02FE5C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-la0-f74.google.com ([209.85.215.74]:38094 "EHLO
	mail-la0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766Ab2JHXMX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Oct 2012 19:12:23 -0400
Received: by mail-la0-f74.google.com with SMTP id j13so240100lah.1
        for <mm-commits@vger.kernel.org>; Mon, 08 Oct 2012 16:12:22 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, aquini@redhat.com, avi@redhat.com, richard@arachsys.com, riel@redhat.com, shli@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: compaction: iron out isolate_freepages_block() and isolate_freepages_range()
has been removed from the -mm tree.  Its filename was
     mm-compaction-acquire-the-zone-lock-as-late-as-possible-fix-2.patch

This patch was dropped because it was folded into mm-compaction-acquire-the-zone-lock-as-late-as-possible.patch

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: compaction: iron out isolate_freepages_block() and isolate_freepages_range()

Andrew pointed out that isolate_freepages_block() is "straggly" and
isolate_freepages_range() is making assumptions on how compact_control is
used which is delicate.  This patch straightens isolate_freepages_block()
and makes it fly straight and initialses compact_control to zeros in
isolate_freepages_range().  The code should be easier to follow and is
functionally equivalent.  The CMA failure path is now a little more
expensive but that is a marginal corner-case.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Richard Davies <richard@arachsys.com>
Cc: Shaohua Li <shli@kernel.org>
Cc: Avi Kivity <avi@redhat.com>
Cc: Rafael Aquini <aquini@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   48 +++++++++++++++++++++-------------------------
 1 file changed, 22 insertions(+), 26 deletions(-)

diff -puN mm/compaction.c~mm-compaction-acquire-the-zone-lock-as-late-as-possible-fix-2 mm/compaction.c
--- a/mm/compaction.c~mm-compaction-acquire-the-zone-lock-as-late-as-possible-fix-2
+++ a/mm/compaction.c
@@ -96,7 +96,6 @@ static inline bool compact_trylock_irqsa
 /* Returns true if the page is within a block suitable for migration to */
 static bool suitable_migration_target(struct page *page)
 {
-
 	int migratetype = get_pageblock_migratetype(page);
 
 	/* Don't interfere with memory hot-remove or the min_free_kbytes blocks */
@@ -188,21 +187,20 @@ static unsigned long isolate_freepages_b
 
 	cursor = pfn_to_page(blockpfn);
 
-	/* Isolate free pages. This assumes the block is valid */
+	/* Isolate free pages. */
 	for (; blockpfn < end_pfn; blockpfn++, cursor++) {
 		int isolated, i;
 		struct page *page = cursor;
 
-		if (!pfn_valid_within(blockpfn))
-			goto strict_check;
 		nr_scanned++;
-
+		if (!pfn_valid_within(blockpfn))
+			continue;
 		if (!PageBuddy(page))
-			goto strict_check;
+			continue;
 
 		/*
-		 * The zone lock must be held to isolate freepages. This
-		 * unfortunately this is a very coarse lock and can be
+		 * The zone lock must be held to isolate freepages.
+		 * Unfortunately this is a very coarse lock and can be
 		 * heavily contended if there are parallel allocations
 		 * or parallel compactions. For async compaction do not
 		 * spin on the lock and we acquire the lock as late as
@@ -219,12 +217,12 @@ static unsigned long isolate_freepages_b
 
 		/* Recheck this is a buddy page under lock */
 		if (!PageBuddy(page))
-			goto strict_check;
+			continue;
 
 		/* Found a free page, break it into order-0 pages */
 		isolated = split_free_page(page);
 		if (!isolated && strict)
-			goto strict_check;
+			break;
 		total_isolated += isolated;
 		for (i = 0; i < isolated; i++) {
 			list_add(&page->lru, freelist);
@@ -236,20 +234,18 @@ static unsigned long isolate_freepages_b
 			blockpfn += isolated - 1;
 			cursor += isolated - 1;
 		}
-
-		continue;
-
-strict_check:
-		/* Abort isolation if the caller requested strict isolation */
-		if (strict) {
-			total_isolated = 0;
-			goto out;
-		}
 	}
 
 	trace_mm_compaction_isolate_freepages(nr_scanned, total_isolated);
 
-out:
+	/*
+	 * If strict isolation is requested by CMA then check that all the
+	 * pages scanned were isolated. If there were any failures, 0 is
+	 * returned and CMA will fail.
+	 */
+	if (strict && nr_scanned != total_isolated)
+		total_isolated = 0;
+
 	if (locked)
 		spin_unlock_irqrestore(&cc->zone->lock, flags);
 
@@ -275,14 +271,14 @@ isolate_freepages_range(unsigned long st
 	unsigned long isolated, pfn, block_end_pfn;
 	struct zone *zone = NULL;
 	LIST_HEAD(freelist);
-	struct compact_control cc;
-
-	if (pfn_valid(start_pfn))
-		zone = page_zone(pfn_to_page(start_pfn));
 
 	/* cc needed for isolate_freepages_block to acquire zone->lock */
-	cc.zone = zone;
-	cc.sync = true;
+	struct compact_control cc = {
+		.sync = true,
+	};
+
+	if (pfn_valid(start_pfn))
+		cc.zone = zone = page_zone(pfn_to_page(start_pfn));
 
 	for (pfn = start_pfn; pfn < end_pfn; pfn += isolated) {
 		if (!pfn_valid(pfn) || zone != page_zone(pfn_to_page(pfn)))
_

Patches currently in -mm which might be from mgorman@suse.de are

mm-remove-__gfp_no_kswapd.patch
mm-compaction-update-comment-in-try_to_compact_pages.patch
mm-vmscan-scale-number-of-pages-reclaimed-by-reclaim-compaction-based-on-failures.patch
mm-compaction-capture-a-suitable-high-order-page-immediately-when-it-is-made-available.patch
revert-mm-mempolicy-let-vma_merge-and-vma_split-handle-vma-vm_policy-linkages.patch
mempolicy-remove-mempolicy-sharing.patch
mempolicy-fix-a-race-in-shared_policy_replace.patch
mempolicy-fix-refcount-leak-in-mpol_set_shared_policy.patch
mempolicy-fix-a-memory-corruption-by-refcount-imbalance-in-alloc_pages_vma.patch
mm-cma-discard-clean-pages-during-contiguous-allocation-instead-of-migration.patch
mm-fix-tracing-in-free_pcppages_bulk.patch
cma-fix-counting-of-isolated-pages.patch
cma-count-free-cma-pages.patch
cma-fix-watermark-checking.patch
mm-page_alloc-use-get_freepage_migratetype-instead-of-page_private.patch
mm-remain-migratetype-in-freed-page.patch
memory-hotplug-bug-fix-race-between-isolation-and-allocation.patch
memory-hotplug-fix-pages-missed-by-race-rather-than-failing.patch
mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long.patch
mm-compaction-move-fatal-signal-check-out-of-compact_checklock_irqsave.patch
mm-compaction-update-try_to_compact_pageskerneldoc-comment.patch
mm-compaction-acquire-the-zone-lru_lock-as-late-as-possible.patch
mm-compaction-acquire-the-zone-lock-as-late-as-possible.patch
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

