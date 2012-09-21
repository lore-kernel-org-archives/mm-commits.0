From: akpm@linux-foundation.org
Subject: + revert-mm-have-order-0-compaction-start-off-where-it-left.patch added to -mm tree
Date: Fri, 21 Sep 2012 14:33:07 -0700
Message-ID: <20120921213308.59D6D1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:50500 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757991Ab2IUVdK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 21 Sep 2012 17:33:10 -0400
Received: by vbis24 with SMTP id s24so516031vbi.1
        for <mm-commits@vger.kernel.org>; Fri, 21 Sep 2012 14:33:09 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mgorman@suse.de, aquini@redhat.com, avi@redhat.com, richard@arachsys.com, riel@redhat.com, shli@kernel.org


The patch titled
     Subject: Revert "mm: have order > 0 compaction start off where it left"
has been added to the -mm tree.  Its filename is
     revert-mm-have-order-0-compaction-start-off-where-it-left.patch

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
Subject: Revert "mm: have order > 0 compaction start off where it left"

This reverts commit 7db8889a ("mm: have order > 0 compaction start off
where it left") and commit de74f1cc ("mm: have order > 0 compaction start
near a pageblock with free pages").  These patches were a good idea and
tests confirmed that they massively reduced the amount of scanning but the
implementation is complex and tricky to understand.  A later patch will
cache what pageblocks should be skipped and reimplements the concept of
compact_cached_free_pfn on top for both migration and free scanners.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Richard Davies <richard@arachsys.com>
Cc: Shaohua Li <shli@kernel.org>
Cc: Avi Kivity <avi@redhat.com>
Acked-by: Rafael Aquini <aquini@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    4 --
 mm/compaction.c        |   65 +++------------------------------------
 mm/internal.h          |    6 ---
 mm/page_alloc.c        |    5 ---
 4 files changed, 5 insertions(+), 75 deletions(-)

diff -puN include/linux/mmzone.h~revert-mm-have-order-0-compaction-start-off-where-it-left include/linux/mmzone.h
--- a/include/linux/mmzone.h~revert-mm-have-order-0-compaction-start-off-where-it-left
+++ a/include/linux/mmzone.h
@@ -384,10 +384,6 @@ struct zone {
 	 */
 	spinlock_t		lock;
 	int                     all_unreclaimable; /* All pages pinned */
-#if defined CONFIG_COMPACTION || defined CONFIG_CMA
-	/* pfn where the last incremental compaction isolated free pages */
-	unsigned long		compact_cached_free_pfn;
-#endif
 #ifdef CONFIG_MEMORY_HOTPLUG
 	/* see spanned/present_pages for more description */
 	seqlock_t		span_seqlock;
diff -puN mm/compaction.c~revert-mm-have-order-0-compaction-start-off-where-it-left mm/compaction.c
--- a/mm/compaction.c~revert-mm-have-order-0-compaction-start-off-where-it-left
+++ a/mm/compaction.c
@@ -539,20 +539,6 @@ next_pageblock:
 #endif /* CONFIG_COMPACTION || CONFIG_CMA */
 #ifdef CONFIG_COMPACTION
 /*
- * Returns the start pfn of the last page block in a zone.  This is the starting
- * point for full compaction of a zone.  Compaction searches for free pages from
- * the end of each zone, while isolate_freepages_block scans forward inside each
- * page block.
- */
-static unsigned long start_free_pfn(struct zone *zone)
-{
-	unsigned long free_pfn;
-	free_pfn = zone->zone_start_pfn + zone->spanned_pages;
-	free_pfn &= ~(pageblock_nr_pages-1);
-	return free_pfn;
-}
-
-/*
  * Based on information in the current compact_control, find blocks
  * suitable for isolating free pages from and then isolate them.
  */
@@ -620,19 +606,8 @@ static void isolate_freepages(struct zon
 		 * looking for free pages, the search will restart here as
 		 * page migration may have returned some pages to the allocator
 		 */
-		if (isolated) {
+		if (isolated)
 			high_pfn = max(high_pfn, pfn);
-
-			/*
-			 * If the free scanner has wrapped, update
-			 * compact_cached_free_pfn to point to the highest
-			 * pageblock with free pages. This reduces excessive
-			 * scanning of full pageblocks near the end of the
-			 * zone
-			 */
-			if (cc->order > 0 && cc->wrapped)
-				zone->compact_cached_free_pfn = high_pfn;
-		}
 	}
 
 	/* split_free_page does not map the pages */
@@ -640,11 +615,6 @@ static void isolate_freepages(struct zon
 
 	cc->free_pfn = high_pfn;
 	cc->nr_freepages = nr_freepages;
-
-	/* If compact_cached_free_pfn is reset then set it now */
-	if (cc->order > 0 && !cc->wrapped &&
-			zone->compact_cached_free_pfn == start_free_pfn(zone))
-		zone->compact_cached_free_pfn = high_pfn;
 }
 
 /*
@@ -739,26 +709,8 @@ static int compact_finished(struct zone 
 	if (fatal_signal_pending(current))
 		return COMPACT_PARTIAL;
 
-	/*
-	 * A full (order == -1) compaction run starts at the beginning and
-	 * end of a zone; it completes when the migrate and free scanner meet.
-	 * A partial (order > 0) compaction can start with the free scanner
-	 * at a random point in the zone, and may have to restart.
-	 */
-	if (cc->free_pfn <= cc->migrate_pfn) {
-		if (cc->order > 0 && !cc->wrapped) {
-			/* We started partway through; restart at the end. */
-			unsigned long free_pfn = start_free_pfn(zone);
-			zone->compact_cached_free_pfn = free_pfn;
-			cc->free_pfn = free_pfn;
-			cc->wrapped = 1;
-			return COMPACT_CONTINUE;
-		}
-		return COMPACT_COMPLETE;
-	}
-
-	/* We wrapped around and ended up where we started. */
-	if (cc->wrapped && cc->free_pfn <= cc->start_free_pfn)
+	/* Compaction run completes if the migrate and free scanner meet */
+	if (cc->free_pfn <= cc->migrate_pfn)
 		return COMPACT_COMPLETE;
 
 	/*
@@ -864,15 +816,8 @@ static int compact_zone(struct zone *zon
 
 	/* Setup to move all movable pages to the end of the zone */
 	cc->migrate_pfn = zone->zone_start_pfn;
-
-	if (cc->order > 0) {
-		/* Incremental compaction. Start where the last one stopped. */
-		cc->free_pfn = zone->compact_cached_free_pfn;
-		cc->start_free_pfn = cc->free_pfn;
-	} else {
-		/* Order == -1 starts at the end of the zone. */
-		cc->free_pfn = start_free_pfn(zone);
-	}
+	cc->free_pfn = cc->migrate_pfn + zone->spanned_pages;
+	cc->free_pfn &= ~(pageblock_nr_pages-1);
 
 	migrate_prep_local();
 
diff -puN mm/internal.h~revert-mm-have-order-0-compaction-start-off-where-it-left mm/internal.h
--- a/mm/internal.h~revert-mm-have-order-0-compaction-start-off-where-it-left
+++ a/mm/internal.h
@@ -119,14 +119,8 @@ struct compact_control {
 	unsigned long nr_freepages;	/* Number of isolated free pages */
 	unsigned long nr_migratepages;	/* Number of pages to migrate */
 	unsigned long free_pfn;		/* isolate_freepages search base */
-	unsigned long start_free_pfn;	/* where we started the search */
 	unsigned long migrate_pfn;	/* isolate_migratepages search base */
 	bool sync;			/* Synchronous migration */
-	bool wrapped;			/* Order > 0 compactions are
-					   incremental, once free_pfn
-					   and migrate_pfn meet, we restart
-					   from the top of the zone;
-					   remember we wrapped around. */
 
 	int order;			/* order a direct compactor needs */
 	int migratetype;		/* MOVABLE, RECLAIMABLE etc */
diff -puN mm/page_alloc.c~revert-mm-have-order-0-compaction-start-off-where-it-left mm/page_alloc.c
--- a/mm/page_alloc.c~revert-mm-have-order-0-compaction-start-off-where-it-left
+++ a/mm/page_alloc.c
@@ -4488,11 +4488,6 @@ static void __paginginit free_area_init_
 
 		zone->spanned_pages = size;
 		zone->present_pages = realsize;
-#if defined CONFIG_COMPACTION || defined CONFIG_CMA
-		zone->compact_cached_free_pfn = zone->zone_start_pfn +
-						zone->spanned_pages;
-		zone->compact_cached_free_pfn &= ~(pageblock_nr_pages-1);
-#endif
 #ifdef CONFIG_NUMA
 		zone->node = nid;
 		zone->min_unmapped_pages = (realsize*sysctl_min_unmapped_ratio)
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

