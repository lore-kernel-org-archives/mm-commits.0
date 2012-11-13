From: akpm@linux-foundation.org
Subject: [withdrawn] mm-vmscan-scale-number-of-pages-reclaimed-by-reclaim-compaction-only-in-direct-reclaim.patch removed from -mm tree
Date: Tue, 13 Nov 2012 14:45:06 -0800
Message-ID: <20121113224506.A5DA5100048@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:33774 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754220Ab2KMWpI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 13 Nov 2012 17:45:08 -0500
Received: by mail-qc0-f202.google.com with SMTP id s25so917853qcq.1
        for <mm-commits@vger.kernel.org>; Tue, 13 Nov 2012 14:45:07 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, Valdis.Kletnieks@vt.edu, jslaby@suse.cz, minchan@kernel.org, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmscan: scale number of pages reclaimed by reclaim/compaction only in direct reclaim
has been removed from the -mm tree.  Its filename was
     mm-vmscan-scale-number-of-pages-reclaimed-by-reclaim-compaction-only-in-direct-reclaim.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: vmscan: scale number of pages reclaimed by reclaim/compaction only in direct reclaim

Jiri Slaby reported the following:

	(It's an effective revert of "mm: vmscan: scale number of pages
	reclaimed by reclaim/compaction based on failures".)
	Given kswapd had hours of runtime in ps/top output yesterday in the
	morning and after the revert it's now 2 minutes in sum for the last 24h,
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

As it is not taking deferred compaction into account in this path it scans
aggressively before falling out and making the compaction_deferred check
in compaction_ready.  This patch avoids kswapd scaling pages for reclaim
and leaves the aggressive reclaim to the process attempting the THP
allocation.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reported-by: Jiri Slaby <jslaby@suse.cz>
Cc: Rik van Riel <riel@redhat.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-scale-number-of-pages-reclaimed-by-reclaim-compaction-only-in-direct-reclaim mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-scale-number-of-pages-reclaimed-by-reclaim-compaction-only-in-direct-reclaim
+++ a/mm/vmscan.c
@@ -1763,14 +1763,20 @@ static bool in_reclaim_compaction(struct
 #ifdef CONFIG_COMPACTION
 /*
  * If compaction is deferred for sc->order then scale the number of pages
- * reclaimed based on the number of consecutive allocation failures
+ * reclaimed based on the number of consecutive allocation failures. This
+ * scaling only happens for direct reclaim as it is about to attempt
+ * compaction. If compaction fails, future allocations will be deferred
+ * and reclaim avoided. On the other hand, kswapd does not take compaction
+ * deferral into account so if it scaled, it could scan excessively even
+ * though allocations are temporarily not being attempted.
  */
 static unsigned long scale_for_compaction(unsigned long pages_for_compaction,
 			struct lruvec *lruvec, struct scan_control *sc)
 {
 	struct zone *zone = lruvec_zone(lruvec);
 
-	if (zone->compact_order_failed <= sc->order)
+	if (zone->compact_order_failed <= sc->order &&
+	    !current_is_kswapd())
 		pages_for_compaction <<= zone->compact_defer_shift;
 	return pages_for_compaction;
 }
_

Patches currently in -mm which might be from mgorman@suse.de are

linux-next.patch
mm-fix-a-regression-with-highmem-introduced-by-changeset-7f1290f2f2a4d.patch
memory_hotplug-fix-possible-incorrect-node_states.patch
slub-hotplug-ignore-unrelated-nodes-hot-adding-and-hot-removing.patch
mm-add-comment-on-storage-key-dirty-bit-semantics.patch
mm-refactor-reinsert-of-swap_info-in-sys_swapoff.patch
mm-do-not-call-frontswap_init-during-swapoff.patch
mm-memmap_init_zone-performance-improvement.patch
mm-allocate-kernel-pages-to-the-right-memcg.patch

