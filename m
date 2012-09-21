From: akpm@linux-foundation.org
Subject: + mm-compaction-acquire-the-zone-lock-as-late-as-possible.patch added to -mm tree
Date: Fri, 21 Sep 2012 14:33:04 -0700
Message-ID: <20120921213305.58421100048@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:35410 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753566Ab2IUVdH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 21 Sep 2012 17:33:07 -0400
Received: by qcqs25 with SMTP id s25so229004qcq.1
        for <mm-commits@vger.kernel.org>; Fri, 21 Sep 2012 14:33:06 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mgorman@suse.de, aquini@redhat.com, avi@redhat.com, richard@arachsys.com, riel@redhat.com, shli@kernel.org


The patch titled
     Subject: mm: compaction: acquire the zone->lock as late as possible
has been added to the -mm tree.  Its filename is
     mm-compaction-acquire-the-zone-lock-as-late-as-possible.patch

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
Subject: mm: compaction: acquire the zone->lock as late as possible

Compaction's free scanner acquires the zone->lock when checking for
PageBuddy pages and isolating them.  It does this even if there are no
PageBuddy pages in the range.

This patch defers acquiring the zone lock for as long as possible.  In the
event there are no free pages in the pageblock then the lock will not be
acquired at all which reduces contention on zone->lock.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Richard Davies <richard@arachsys.com>
Cc: Shaohua Li <shli@kernel.org>
Cc: Avi Kivity <avi@redhat.com>
Acked-by: Rafael Aquini <aquini@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |  141 +++++++++++++++++++++++++---------------------
 1 file changed, 78 insertions(+), 63 deletions(-)

diff -puN mm/compaction.c~mm-compaction-acquire-the-zone-lock-as-late-as-possible mm/compaction.c
--- a/mm/compaction.c~mm-compaction-acquire-the-zone-lock-as-late-as-possible
+++ a/mm/compaction.c
@@ -93,6 +93,28 @@ static inline bool compact_trylock_irqsa
 	return compact_checklock_irqsave(lock, flags, false, cc);
 }
 
+/* Returns true if the page is within a block suitable for migration to */
+static bool suitable_migration_target(struct page *page)
+{
+
+	int migratetype = get_pageblock_migratetype(page);
+
+	/* Don't interfere with memory hot-remove or the min_free_kbytes blocks */
+	if (migratetype == MIGRATE_ISOLATE || migratetype == MIGRATE_RESERVE)
+		return false;
+
+	/* If the page is a large free page, then allow migration */
+	if (PageBuddy(page) && page_order(page) >= pageblock_order)
+		return true;
+
+	/* If the block is MIGRATE_MOVABLE or MIGRATE_CMA, allow migration */
+	if (migrate_async_suitable(migratetype))
+		return true;
+
+	/* Otherwise skip the block */
+	return false;
+}
+
 static void compact_capture_page(struct compact_control *cc)
 {
 	unsigned long flags;
@@ -153,13 +175,16 @@ static void compact_capture_page(struct 
  * pages inside of the pageblock (even though it may still end up isolating
  * some pages).
  */
-static unsigned long isolate_freepages_block(unsigned long blockpfn,
+static unsigned long isolate_freepages_block(struct compact_control *cc,
+				unsigned long blockpfn,
 				unsigned long end_pfn,
 				struct list_head *freelist,
 				bool strict)
 {
 	int nr_scanned = 0, total_isolated = 0;
 	struct page *cursor;
+	unsigned long flags;
+	bool locked = false;
 
 	cursor = pfn_to_page(blockpfn);
 
@@ -168,23 +193,38 @@ static unsigned long isolate_freepages_b
 		int isolated, i;
 		struct page *page = cursor;
 
-		if (!pfn_valid_within(blockpfn)) {
-			if (strict)
-				return 0;
-			continue;
-		}
+		if (!pfn_valid_within(blockpfn))
+			goto strict_check;
 		nr_scanned++;
 
-		if (!PageBuddy(page)) {
-			if (strict)
-				return 0;
-			continue;
-		}
+		if (!PageBuddy(page))
+			goto strict_check;
+
+		/*
+		 * The zone lock must be held to isolate freepages. This
+		 * unfortunately this is a very coarse lock and can be
+		 * heavily contended if there are parallel allocations
+		 * or parallel compactions. For async compaction do not
+		 * spin on the lock and we acquire the lock as late as
+		 * possible.
+		 */
+		locked = compact_checklock_irqsave(&cc->zone->lock, &flags,
+								locked, cc);
+		if (!locked)
+			break;
+
+		/* Recheck this is a suitable migration target under lock */
+		if (!strict && !suitable_migration_target(page))
+			break;
+
+		/* Recheck this is a buddy page under lock */
+		if (!PageBuddy(page))
+			goto strict_check;
 
 		/* Found a free page, break it into order-0 pages */
 		isolated = split_free_page(page);
 		if (!isolated && strict)
-			return 0;
+			goto strict_check;
 		total_isolated += isolated;
 		for (i = 0; i < isolated; i++) {
 			list_add(&page->lru, freelist);
@@ -196,9 +236,23 @@ static unsigned long isolate_freepages_b
 			blockpfn += isolated - 1;
 			cursor += isolated - 1;
 		}
+
+		continue;
+
+strict_check:
+		/* Abort isolation if the caller requested strict isolation */
+		if (strict) {
+			total_isolated = 0;
+			goto out;
+		}
 	}
 
 	trace_mm_compaction_isolate_freepages(nr_scanned, total_isolated);
+
+out:
+	if (locked)
+		spin_unlock_irqrestore(&cc->zone->lock, flags);
+
 	return total_isolated;
 }
 
@@ -218,13 +272,18 @@ static unsigned long isolate_freepages_b
 unsigned long
 isolate_freepages_range(unsigned long start_pfn, unsigned long end_pfn)
 {
-	unsigned long isolated, pfn, block_end_pfn, flags;
+	unsigned long isolated, pfn, block_end_pfn;
 	struct zone *zone = NULL;
 	LIST_HEAD(freelist);
+	struct compact_control cc;
 
 	if (pfn_valid(start_pfn))
 		zone = page_zone(pfn_to_page(start_pfn));
 
+	/* cc needed for isolate_freepages_block to acquire zone->lock */
+	cc.zone = zone;
+	cc.sync = true;
+
 	for (pfn = start_pfn; pfn < end_pfn; pfn += isolated) {
 		if (!pfn_valid(pfn) || zone != page_zone(pfn_to_page(pfn)))
 			break;
@@ -236,10 +295,8 @@ isolate_freepages_range(unsigned long st
 		block_end_pfn = ALIGN(pfn + 1, pageblock_nr_pages);
 		block_end_pfn = min(block_end_pfn, end_pfn);
 
-		spin_lock_irqsave(&zone->lock, flags);
-		isolated = isolate_freepages_block(pfn, block_end_pfn,
+		isolated = isolate_freepages_block(&cc, pfn, block_end_pfn,
 						   &freelist, true);
-		spin_unlock_irqrestore(&zone->lock, flags);
 
 		/*
 		 * In strict mode, isolate_freepages_block() returns 0 if
@@ -481,29 +538,6 @@ next_pageblock:
 
 #endif /* CONFIG_COMPACTION || CONFIG_CMA */
 #ifdef CONFIG_COMPACTION
-
-/* Returns true if the page is within a block suitable for migration to */
-static bool suitable_migration_target(struct page *page)
-{
-
-	int migratetype = get_pageblock_migratetype(page);
-
-	/* Don't interfere with memory hot-remove or the min_free_kbytes blocks */
-	if (migratetype == MIGRATE_ISOLATE || migratetype == MIGRATE_RESERVE)
-		return false;
-
-	/* If the page is a large free page, then allow migration */
-	if (PageBuddy(page) && page_order(page) >= pageblock_order)
-		return true;
-
-	/* If the block is MIGRATE_MOVABLE or MIGRATE_CMA, allow migration */
-	if (migrate_async_suitable(migratetype))
-		return true;
-
-	/* Otherwise skip the block */
-	return false;
-}
-
 /*
  * Returns the start pfn of the last page block in a zone.  This is the starting
  * point for full compaction of a zone.  Compaction searches for free pages from
@@ -527,7 +561,6 @@ static void isolate_freepages(struct zon
 {
 	struct page *page;
 	unsigned long high_pfn, low_pfn, pfn, zone_end_pfn, end_pfn;
-	unsigned long flags;
 	int nr_freepages = cc->nr_freepages;
 	struct list_head *freelist = &cc->freepages;
 
@@ -575,30 +608,12 @@ static void isolate_freepages(struct zon
 		if (!suitable_migration_target(page))
 			continue;
 
-		/*
-		 * Found a block suitable for isolating free pages from. Now
-		 * we disabled interrupts, double check things are ok and
-		 * isolate the pages. This is to minimise the time IRQs
-		 * are disabled
-		 */
+		/* Found a block suitable for isolating free pages from */
 		isolated = 0;
-
-		/*
-		 * The zone lock must be held to isolate freepages. This
-		 * unfortunately this is a very coarse lock and can be
-		 * heavily contended if there are parallel allocations
-		 * or parallel compactions. For async compaction do not
-		 * spin on the lock
-		 */
-		if (!compact_trylock_irqsave(&zone->lock, &flags, cc))
-			break;
-		if (suitable_migration_target(page)) {
-			end_pfn = min(pfn + pageblock_nr_pages, zone_end_pfn);
-			isolated = isolate_freepages_block(pfn, end_pfn,
-							   freelist, false);
-			nr_freepages += isolated;
-		}
-		spin_unlock_irqrestore(&zone->lock, flags);
+		end_pfn = min(pfn + pageblock_nr_pages, zone_end_pfn);
+		isolated = isolate_freepages_block(cc, pfn, end_pfn,
+						   freelist, false);
+		nr_freepages += isolated;
 
 		/*
 		 * Record the highest PFN we isolated pages from. When next
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

