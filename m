From: akpm@linux-foundation.org
Subject: + mm-vmscan-when-reclaiming-for-compaction-ensure-there-are-sufficient-free-pages-available.patch added to -mm tree
Date: Fri, 16 Dec 2011 15:30:08 -0800
Message-ID: <20111216233009.68AB61E004D@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:43186 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462Ab1LPXaK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 16 Dec 2011 18:30:10 -0500
Received: by mail-yw0-f74.google.com with SMTP id j51so584979yhj.1
        for <mm-commits@vger.kernel.org>; Fri, 16 Dec 2011 15:30:10 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mgorman@suse.de, aarcange@redhat.com, adi@hexapodia.org, davej@redhat.com, jack@suse.cz, jweiner@redhat.com, minchan.kim@gmail.com, nai.xia@gmail.com, riel@redhat.com


The patch titled
     Subject: mm: vmscan: when reclaiming for compaction, ensure there are sufficient free pages available
has been added to the -mm tree.  Its filename is
     mm-vmscan-when-reclaiming-for-compaction-ensure-there-are-sufficient-free-pages-available.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: vmscan: when reclaiming for compaction, ensure there are sufficient free pages available

In commit e0887c19 ("vmscan: limit direct reclaim for higher order
allocations"), Rik noted that reclaim was too aggressive when THP was
enabled.  In his initial patch he used the number of free pages to decide
if reclaim should abort for compaction.  My feedback was that reclaim and
compaction should be using the same logic when deciding if reclaim should
be aborted.

Unfortunately, this had the effect of reducing THP success rates when the
workload included something like streaming reads that continually
allocated pages.  The window during which compaction could run and return
a THP was too small.

This patch combines Rik's two patches together.  compaction_suitable() is
still used to decide if reclaim should be aborted to allow compaction is
used.  However, it will also ensure that there is a reasonable buffer of
free pages available.  This improves upon the THP allocation success rates
but bounds the number of pages that are freed for compaction.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Rik van Riel<riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Dave Jones <davej@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Andy Isaacson <adi@hexapodia.org>
Cc: Nai Xia <nai.xia@gmail.com>
Cc: Johannes Weiner <jweiner@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   44 +++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 39 insertions(+), 5 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-when-reclaiming-for-compaction-ensure-there-are-sufficient-free-pages-available mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-when-reclaiming-for-compaction-ensure-there-are-sufficient-free-pages-available
+++ a/mm/vmscan.c
@@ -2110,6 +2110,42 @@ restart:
 	throttle_vm_writeout(sc->gfp_mask);
 }
 
+/* Returns true if compaction should go ahead for a high-order request */
+static inline bool compaction_ready(struct zone *zone, struct scan_control *sc)
+{
+	unsigned long balance_gap, watermark;
+	bool watermark_ok;
+
+	/* Do not consider compaction for orders reclaim is meant to satisfy */
+	if (sc->order <= PAGE_ALLOC_COSTLY_ORDER)
+		return false;
+
+	/*
+	 * Compaction takes time to run and there are potentially other
+	 * callers using the pages just freed. Continue reclaiming until
+	 * there is a buffer of free pages available to give compaction
+	 * a reasonable chance of completing and allocating the page
+	 */
+	balance_gap = min(low_wmark_pages(zone),
+		(zone->present_pages + KSWAPD_ZONE_BALANCE_GAP_RATIO-1) /
+			KSWAPD_ZONE_BALANCE_GAP_RATIO);
+	watermark = high_wmark_pages(zone) + balance_gap + (2UL << sc->order);
+	watermark_ok = zone_watermark_ok_safe(zone, 0, watermark, 0, 0);
+
+	/*
+	 * If compaction is deferred, reclaim up to a point where
+	 * compaction will have a chance of success when re-enabled
+	 */
+	if (compaction_deferred(zone))
+		return watermark_ok;
+
+	/* If compaction is not ready to start, keep reclaiming */
+	if (!compaction_suitable(zone, sc->order))
+		return false;
+
+	return watermark_ok;
+}
+
 /*
  * This is the direct reclaim path, for page-allocating processes.  We only
  * try to reclaim pages from zones which will satisfy the caller's allocation
@@ -2127,8 +2163,8 @@ restart:
  * scan then give up on it.
  *
  * This function returns true if a zone is being reclaimed for a costly
- * high-order allocation and compaction is either ready to begin or deferred.
- * This indicates to the caller that it should retry the allocation or fail.
+ * high-order allocation and compaction is ready to begin. This indicates to
+ * the caller that it should retry the allocation or fail.
  */
 static bool shrink_zones(int priority, struct zonelist *zonelist,
 					struct scan_control *sc)
@@ -2162,9 +2198,7 @@ static bool shrink_zones(int priority, s
 				 * noticable problem, like transparent huge page
 				 * allocations.
 				 */
-				if (sc->order > PAGE_ALLOC_COSTLY_ORDER &&
-					(compaction_suitable(zone, sc->order) ||
-					 compaction_deferred(zone))) {
+				if (compaction_ready(zone, sc)) {
 					should_abort_reclaim = true;
 					continue;
 				}
_
Subject: Subject: mm: vmscan: when reclaiming for compaction, ensure there are sufficient free pages available

Patches currently in -mm which might be from mgorman@suse.de are

linux-next.patch
mm-page-writebackc-make-determine_dirtyable_memory-static-again.patch
mm-reduce-the-amount-of-work-done-when-updating-min_free_kbytes.patch
mm-reduce-the-amount-of-work-done-when-updating-min_free_kbytes-checkpatch-fixes.patch
mm-avoid-livelock-on-__gfp_fs-allocations-v2.patch
mm-more-intensive-memory-corruption-debug.patch
mm-more-intensive-memory-corruption-debug-fix.patch
pm-hibernate-do-not-count-debug-pages-as-savable.patch
slub-min-order-when-debug_guardpage_minorder-0.patch
mm-debug-test-for-online-nid-when-allocating-on-single-node.patch
mm-exclude-reserved-pages-from-dirtyable-memory.patch
mm-exclude-reserved-pages-from-dirtyable-memory-fix.patch
mm-try-to-distribute-dirty-pages-fairly-across-zones.patch
mm-filemap-pass-__gfp_write-from-grab_cache_page_write_begin.patch
btrfs-pass-__gfp_write-for-buffered-write-page-allocations.patch
mm-compaction-push-isolate-search-base-of-compact-control-one-pfn-ahead.patch
mm-fix-off-by-two-in-__zone_watermark_ok.patch
mremap-enforce-rmap-src-dst-vma-ordering-in-case-of-vma_merge-succeeding-in-copy_vma.patch
mremap-enforce-rmap-src-dst-vma-ordering-in-case-of-vma_merge-succeeding-in-copy_vma-update.patch
mm-do-not-stall-in-synchronous-compaction-for-thp-allocations.patch
revert-mm-do-not-stall-in-synchronous-compaction-for-thp-allocations.patch
mm-compaction-allow-compaction-to-isolate-dirty-pages.patch
mm-compaction-use-synchronous-compaction-for-proc-sys-vm-compact_memory.patch
mm-vmscan-check-if-we-isolated-a-compound-page-during-lumpy-scan.patch
mm-vmscan-do-not-oom-if-aborting-reclaim-to-start-compaction.patch
mm-compaction-determine-if-dirty-pages-can-be-migrated-without-blocking-within-migratepage.patch
mm-compaction-make-isolate_lru_page-filter-aware-again.patch
mm-page-allocator-do-not-call-direct-reclaim-for-thp-allocations-while-compaction-is-deferred.patch
mm-compaction-introduce-sync-light-migration-for-use-by-compaction.patch
mm-vmscan-when-reclaiming-for-compaction-ensure-there-are-sufficient-free-pages-available.patch
mm-vmscan-check-if-reclaim-should-really-abort-even-if-compaction_ready-is-true-for-one-zone.patch
mm-isolate-pages-for-immediate-reclaim-on-their-own-lru.patch

