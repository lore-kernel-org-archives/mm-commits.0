From: akpm@linux-foundation.org
Subject: + mm-compaction-acquire-the-zone-lock-as-late-as-possible-fix-2.patch added to -mm tree
Date: Mon, 24 Sep 2012 15:00:31 -0700
Message-ID: <20120924220031.BDE9B1E0048@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:60079 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927Ab2IXWAd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 24 Sep 2012 18:00:33 -0400
Received: by vcbfy27 with SMTP id fy27so821286vcb.1
        for <mm-commits@vger.kernel.org>; Mon, 24 Sep 2012 15:00:32 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mgorman@suse.de, aquini@redhat.com, avi@redhat.com, richard@arachsys.com, riel@redhat.com, shli@kernel.org


The patch titled
     Subject: mm: compaction: Iron out isolate_freepages_block() and isolate_freepages_range()
has been added to the -mm tree.  Its filename is
     mm-compaction-acquire-the-zone-lock-as-late-as-possible-fix-2.patch

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
Subject: mm: compaction: Iron out isolate_freepages_block() and isolate_freepages_range()

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
mm-compaction-acquire-the-zone-lock-as-late-as-possible.patch
mm-compaction-acquire-the-zone-lock-as-late-as-possible-fix-2.patch
revert-mm-have-order-0-compaction-start-off-where-it-left.patch
mm-compaction-cache-if-a-pageblock-was-scanned-and-no-pages-were-isolated.patch
mm-compaction-restart-compaction-from-near-where-it-left-off.patch
mm-numa-reclaim-from-all-nodes-within-reclaim-distance.patch
mm-numa-reclaim-from-all-nodes-within-reclaim-distance-fix.patch
mm-thp-fix-pmd_present-for-split_huge_page-and-prot_none-with-thp.patch
mm-revert-0def08e3-mm-mempolicyc-check-return-code-of-check_range.patch
mm-revert-0def08e3-mm-mempolicyc-check-return-code-of-check_range-fix.patch

