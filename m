From: akpm@linux-foundation.org
Subject: [merged] mm-avoid-calling-pgdat_balanced-needlessly.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:49:02 -0800
Message-ID: <20130225204902.B40F75A42E4@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:62254 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759217Ab3BYUtE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:49:04 -0500
Received: by mail-yh0-f74.google.com with SMTP id z6so346817yhz.1
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:49:03 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zlatko.calusic@iskon.hr, hughd@google.com, mgorman@suse.de, minchan.kim@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: avoid calling pgdat_balanced() needlessly
has been removed from the -mm tree.  Its filename was
     mm-avoid-calling-pgdat_balanced-needlessly.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Zlatko Calusic <zlatko.calusic@iskon.hr>
Subject: mm: avoid calling pgdat_balanced() needlessly

Now that balance_pgdat() is slightly tidied up, thanks to more capable
pgdat_balanced(), it's become obvious that pgdat_balanced() is called to
check the status, then break the loop if pgdat is balanced, just to be
immediately called again.  The second call is completely unnecessary, of
course.

The patch introduces pgdat_is_balanced boolean, which helps resolve the
above suboptimal behavior, with the added benefit of slightly better
documenting one other place in the function where we jump and skip lots of
code.

Signed-off-by: Zlatko Calusic <zlatko.calusic@iskon.hr>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Hugh Dickins <hughd@google.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff -puN mm/vmscan.c~mm-avoid-calling-pgdat_balanced-needlessly mm/vmscan.c
--- a/mm/vmscan.c~mm-avoid-calling-pgdat_balanced-needlessly
+++ a/mm/vmscan.c
@@ -2616,6 +2616,7 @@ static bool prepare_kswapd_sleep(pg_data
 static unsigned long balance_pgdat(pg_data_t *pgdat, int order,
 							int *classzone_idx)
 {
+	bool pgdat_is_balanced = false;
 	struct zone *unbalanced_zone;
 	int i;
 	int end_zone = 0;	/* Inclusive.  0 = ZONE_DMA */
@@ -2690,8 +2691,11 @@ loop_again:
 				zone_clear_flag(zone, ZONE_CONGESTED);
 			}
 		}
-		if (i < 0)
+
+		if (i < 0) {
+			pgdat_is_balanced = true;
 			goto out;
+		}
 
 		for (i = 0; i <= end_zone; i++) {
 			struct zone *zone = pgdat->node_zones + i;
@@ -2818,8 +2822,11 @@ loop_again:
 				pfmemalloc_watermark_ok(pgdat))
 			wake_up(&pgdat->pfmemalloc_wait);
 
-		if (pgdat_balanced(pgdat, order, *classzone_idx))
+		if (pgdat_balanced(pgdat, order, *classzone_idx)) {
+			pgdat_is_balanced = true;
 			break;		/* kswapd: all done */
+		}
+
 		/*
 		 * OK, kswapd is getting into trouble.  Take a nap, then take
 		 * another pass across the zones.
@@ -2840,9 +2847,9 @@ loop_again:
 		if (sc.nr_reclaimed >= SWAP_CLUSTER_MAX)
 			break;
 	} while (--sc.priority >= 0);
-out:
 
-	if (!pgdat_balanced(pgdat, order, *classzone_idx)) {
+out:
+	if (!pgdat_is_balanced) {
 		cond_resched();
 
 		try_to_freeze();
_

Patches currently in -mm which might be from zlatko.calusic@iskon.hr are

origin.patch

