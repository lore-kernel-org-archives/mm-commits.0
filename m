From: akpm@linux-foundation.org
Subject: [merged] mm-revert-mm-vmscan-scale-number-of-pages-reclaimed-by-reclaim-compaction-based-on-failures.patch removed from -mm tree
Date: Mon, 19 Nov 2012 12:21:51 -0800
Message-ID: <20121119202152.4B0E420004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:43073 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754186Ab2KSUVz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 19 Nov 2012 15:21:55 -0500
Received: by mail-bk0-f74.google.com with SMTP id je9so213826bkc.1
        for <mm-commits@vger.kernel.org>; Mon, 19 Nov 2012 12:21:54 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, Valdis.Kletnieks@vt.edu, jirislaby@gmail.com, johannes.hirte@fem.tu-ilmenau.de, jslaby@suse.cz, riel@redhat.com, zkabelac@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: revert "mm: vmscan: scale number of pages reclaimed by reclaim/compaction based on failures"
has been removed from the -mm tree.  Its filename was
     mm-revert-mm-vmscan-scale-number-of-pages-reclaimed-by-reclaim-compaction-based-on-failures.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: revert "mm: vmscan: scale number of pages reclaimed by reclaim/compaction based on failures"

Jiri Slaby reported the following:

	(It's an effective revert of "mm: vmscan: scale number of pages
	reclaimed by reclaim/compaction based on failures".) Given kswapd
	had hours of runtime in ps/top output yesterday in the morning
	and after the revert it's now 2 minutes in sum for the last 24h,
	I would say, it's gone.

The intention of the patch in question was to compensate for the loss of
lumpy reclaim.  Part of the reason lumpy reclaim worked is because it
aggressively reclaimed pages and this patch was meant to be a sane
compromise.

When compaction fails, it gets deferred and both compaction and
reclaim/compaction is deferred avoid excessive reclaim.  However, since
commit c6543459 ("mm: remove __GFP_NO_KSWAPD"), kswapd is woken up each
time and continues reclaiming which was not taken into account when the
patch was developed.

Attempts to address the problem ended up just changing the shape of the
problem instead of fixing it.  The release window gets closer and while a
THP allocation failing is not a major problem, kswapd chewing up a lot of
CPU is.  This patch reverts "mm: vmscan: scale number of pages reclaimed
by reclaim/compaction based on failures" and will be revisited in the
future.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Cc: Zdenek Kabelac <zkabelac@redhat.com>
Tested-by: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Cc: Jiri Slaby <jirislaby@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   25 -------------------------
 1 file changed, 25 deletions(-)

diff -puN mm/vmscan.c~mm-revert-mm-vmscan-scale-number-of-pages-reclaimed-by-reclaim-compaction-based-on-failures mm/vmscan.c
--- a/mm/vmscan.c~mm-revert-mm-vmscan-scale-number-of-pages-reclaimed-by-reclaim-compaction-based-on-failures
+++ a/mm/vmscan.c
@@ -1760,28 +1760,6 @@ static bool in_reclaim_compaction(struct
 	return false;
 }
 
-#ifdef CONFIG_COMPACTION
-/*
- * If compaction is deferred for sc->order then scale the number of pages
- * reclaimed based on the number of consecutive allocation failures
- */
-static unsigned long scale_for_compaction(unsigned long pages_for_compaction,
-			struct lruvec *lruvec, struct scan_control *sc)
-{
-	struct zone *zone = lruvec_zone(lruvec);
-
-	if (zone->compact_order_failed <= sc->order)
-		pages_for_compaction <<= zone->compact_defer_shift;
-	return pages_for_compaction;
-}
-#else
-static unsigned long scale_for_compaction(unsigned long pages_for_compaction,
-			struct lruvec *lruvec, struct scan_control *sc)
-{
-	return pages_for_compaction;
-}
-#endif
-
 /*
  * Reclaim/compaction is used for high-order allocation requests. It reclaims
  * order-0 pages before compacting the zone. should_continue_reclaim() returns
@@ -1829,9 +1807,6 @@ static inline bool should_continue_recla
 	 * inactive lists are large enough, continue reclaiming
 	 */
 	pages_for_compaction = (2UL << sc->order);
