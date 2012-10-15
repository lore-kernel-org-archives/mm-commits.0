From: akpm@linux-foundation.org
Subject: + mm-vmscan-scale-number-of-pages-reclaimed-by-reclaim-compaction-only-in-direct-reclaim.patch added to -mm tree
Date: Mon, 15 Oct 2012 15:23:13 -0700
Message-ID: <20121015222313.B3DD6100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:36917 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752042Ab2JOWXP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 15 Oct 2012 18:23:15 -0400
Received: by mail-vc0-f202.google.com with SMTP id fy27so694433vcb.1
        for <mm-commits@vger.kernel.org>; Mon, 15 Oct 2012 15:23:14 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mgorman@suse.de, Valdis.Kletnieks@vt.edu, jslaby@suse.cz, minchan@kernel.org, riel@redhat.com


The patch titled
     Subject: mm: vmscan: scale number of pages reclaimed by reclaim/compaction only in direct reclaim
has been added to the -mm tree.  Its filename is
     mm-vmscan-scale-number-of-pages-reclaimed-by-reclaim-compaction-only-in-direct-reclaim.patch

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

mm-vmscan-scale-number-of-pages-reclaimed-by-reclaim-compaction-only-in-direct-reclaim.patch

