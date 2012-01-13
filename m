From: akpm@linux-foundation.org
Subject: [merged] mm-vmscan-when-reclaiming-for-compaction-ensure-there-are-sufficient-free-pages-available.patch removed from -mm tree
Date: Fri, 13 Jan 2012 12:35:29 -0800
Message-ID: <20120113203529.D3A181E004D@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:42894 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759067Ab2AMUfb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2012 15:35:31 -0500
Received: by yhjj52 with SMTP id j52so102112yhj.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2012 12:35:30 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, aarcange@redhat.com, adi@hexapodia.org, davej@redhat.com, jack@suse.cz, jweiner@redhat.com, minchan.kim@gmail.com, nai.xia@gmail.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmscan: when reclaiming for compaction, ensure there are sufficient free pages available
has been removed from the -mm tree.  Its filename was
     mm-vmscan-when-reclaiming-for-compaction-ensure-there-are-sufficient-free-pages-available.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -2163,6 +2163,42 @@ static void shrink_zone(int priority, st
 	} while (memcg);
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
@@ -2180,8 +2216,8 @@ static void shrink_zone(int priority, st
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
@@ -2215,9 +2251,7 @@ static bool shrink_zones(int priority, s
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

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
mm-fix-null-ptr-dereference-in-__count_immobile_pages.patch
mm-__count_immobile_pages-make-sure-the-node-is-online.patch

