From: akpm@linux-foundation.org
Subject: +
 mm-compaction-do-not-count-compact_stall-if-all-zones-skipped-compaction.patch added to -mm tree
Date: Thu, 21 Aug 2014 15:21:56 -0700
Message-ID: <53f67104.oFVXnBwoVRY1a4OK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ie0-f201.google.com ([209.85.223.201]:37085 "EHLO
	mail-ie0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754810AbaHUWV5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Aug 2014 18:21:57 -0400
Received: by mail-ie0-f201.google.com with SMTP id tr6so813424ieb.2
        for <mm-commits@vger.kernel.org>; Thu, 21 Aug 2014 15:21:57 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, cl@linux.com, iamjoonsoo.kim@lge.com, mgorman@suse.de, mina86@mina86.com, minchan@kernel.org, n-horiguchi@ah.jp.nec.com, riel@redhat.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, compaction: do not count compact_stall if all zones skipped compaction
has been added to the -mm tree.  Its filename is
     mm-compaction-do-not-count-compact_stall-if-all-zones-skipped-compaction.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-do-not-count-compact_stall-if-all-zones-skipped-compaction.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-do-not-count-compact_stall-if-all-zones-skipped-compaction.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, compaction: do not count compact_stall if all zones skipped compaction

The compact_stall vmstat counter counts the number of allocations stalled
by direct compaction.  It does not count when all attempted zones had
deferred compaction, but it does count when all zones skipped compaction. 
The skipping is decided based on very early check of
compaction_suitable(), based on watermarks and memory fragmentation. 
Therefore it makes sense not to count skipped compactions as stalls. 
Moreover, compact_success or compact_fail is also already not being
counted when compaction was skipped, so this patch changes the
compact_stall counting to match the other two.

Additionally, restructure __alloc_pages_direct_compact() code for better
readability.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Minchan Kim <minchan@kernel.org>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Rik van Riel <riel@redhat.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   86 ++++++++++++++++++++++++----------------------
 1 file changed, 46 insertions(+), 40 deletions(-)

diff -puN mm/page_alloc.c~mm-compaction-do-not-count-compact_stall-if-all-zones-skipped-compaction mm/page_alloc.c
--- a/mm/page_alloc.c~mm-compaction-do-not-count-compact_stall-if-all-zones-skipped-compaction
+++ a/mm/page_alloc.c
@@ -2300,7 +2300,7 @@ __alloc_pages_direct_compact(gfp_t gfp_m
 {
 	struct zone *last_compact_zone = NULL;
 	unsigned long compact_result;
-
+	struct page *page;
 
 	if (!order)
 		return NULL;
@@ -2312,49 +2312,55 @@ __alloc_pages_direct_compact(gfp_t gfp_m
 						&last_compact_zone);
 	current->flags &= ~PF_MEMALLOC;
 
-	if (compact_result > COMPACT_DEFERRED)
-		count_vm_event(COMPACTSTALL);
-	else
+	switch (compact_result) {
+	case COMPACT_DEFERRED:
 		*deferred_compaction = true;
+		/* fall-through */
+	case COMPACT_SKIPPED:
+		return NULL;
+	default:
+		break;
+	}
 
-	if (compact_result > COMPACT_SKIPPED) {
-		struct page *page;
+	/*
+	 * At least in one zone compaction wasn't deferred or skipped, so let's
+	 * count a compaction stall
+	 */
+	count_vm_event(COMPACTSTALL);
+
+	/* Page migration frees to the PCP lists but we want merging */
+	drain_pages(get_cpu());
+	put_cpu();
+
+	page = get_page_from_freelist(gfp_mask, nodemask,
+			order, zonelist, high_zoneidx,
+			alloc_flags & ~ALLOC_NO_WATERMARKS,
+			preferred_zone, classzone_idx, migratetype);
+
+	if (page) {
+		struct zone *zone = page_zone(page);
+
+		zone->compact_blockskip_flush = false;
+		compaction_defer_reset(zone, order, true);
+		count_vm_event(COMPACTSUCCESS);
+		return page;
+	}
 
-		/* Page migration frees to the PCP lists but we want merging */
-		drain_pages(get_cpu());
-		put_cpu();
-
-		page = get_page_from_freelist(gfp_mask, nodemask,
-				order, zonelist, high_zoneidx,
-				alloc_flags & ~ALLOC_NO_WATERMARKS,
-				preferred_zone, classzone_idx, migratetype);
-
-		if (page) {
-			struct zone *zone = page_zone(page);
-
-			zone->compact_blockskip_flush = false;
-			compaction_defer_reset(zone, order, true);
-			count_vm_event(COMPACTSUCCESS);
-			return page;
-		}
-
-		/*
-		 * last_compact_zone is where try_to_compact_pages thought
-		 * allocation should succeed, so it did not defer compaction.
-		 * But now we know that it didn't succeed, so we do the defer.
-		 */
-		if (last_compact_zone && mode != MIGRATE_ASYNC)
-			defer_compaction(last_compact_zone, order);
-
-		/*
-		 * It's bad if compaction run occurs and fails.
-		 * The most likely reason is that pages exist,
-		 * but not enough to satisfy watermarks.
-		 */
-		count_vm_event(COMPACTFAIL);
+	/*
+	 * last_compact_zone is where try_to_compact_pages thought allocation
+	 * should succeed, so it did not defer compaction. But here we know
+	 * that it didn't succeed, so we do the defer.
+	 */
+	if (last_compact_zone && mode != MIGRATE_ASYNC)
+		defer_compaction(last_compact_zone, order);
+
+	/*
+	 * It's bad if compaction run occurs and fails. The most likely reason
+	 * is that pages exist, but not enough to satisfy watermarks.
+	 */
+	count_vm_event(COMPACTFAIL);
 
-		cond_resched();
-	}
+	cond_resched();
 
 	return NULL;
 }
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-page_alloc-determine-migratetype-only-once.patch
mm-thp-dont-hold-mmap_sem-in-khugepaged-when-allocating-thp.patch
mm-compaction-defer-each-zone-individually-instead-of-preferred-zone.patch
mm-compaction-do-not-count-compact_stall-if-all-zones-skipped-compaction.patch
mm-compaction-do-not-recheck-suitable_migration_target-under-lock.patch
mm-compaction-move-pageblock-checks-up-from-isolate_migratepages_range.patch
mm-compaction-reduce-zone-checking-frequency-in-the-migration-scanner.patch
mm-compaction-khugepaged-should-not-give-up-due-to-need_resched.patch
mm-compaction-periodically-drop-lock-and-restore-irqs-in-scanners.patch
mm-compaction-skip-rechecks-when-lock-was-already-held.patch
mm-compaction-remember-position-within-pageblock-in-free-pages-scanner.patch
mm-compaction-skip-buddy-pages-by-their-order-in-the-migrate-scanner.patch
mm-rename-allocflags_to_migratetype-for-clarity.patch
mm-compaction-pass-gfp-mask-to-compact_control.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch

