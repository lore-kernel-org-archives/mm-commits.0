From: akpm@linux-foundation.org
Subject: [merged] vmscan-check-high-watermark-after-shrink-zone.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:03:20 -0800
Message-ID: <201003091903.o29J3K9L030961@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45025 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755810Ab0CITEJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:04:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan.kim@gmail.com, fengguang.wu@intel.com, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     vmscan: check high watermark after shrink zone
has been removed from the -mm tree.  Its filename was
     vmscan-check-high-watermark-after-shrink-zone.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmscan: check high watermark after shrink zone
From: Minchan Kim <minchan.kim@gmail.com>

Kswapd checks that zone has sufficient pages free via zone_watermark_ok().

If any zone doesn't have enough pages, we set all_zones_ok to zero. 
!all_zone_ok makes kswapd retry rather than sleeping.

I think the watermark check before shrink_zone() is pointless.  Only after
kswapd has tried to shrink the zone is the check meaningful.

Move the check to after the call to shrink_zone().

[akpm@linux-foundation.org: fix comment, layout]
Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Rik van Riel <riel@redhat.com>
Reviewed-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff -puN mm/vmscan.c~vmscan-check-high-watermark-after-shrink-zone mm/vmscan.c
--- a/mm/vmscan.c~vmscan-check-high-watermark-after-shrink-zone
+++ a/mm/vmscan.c
@@ -2060,9 +2060,6 @@ loop_again:
 					priority != DEF_PRIORITY)
 				continue;
 
-			if (!zone_watermark_ok(zone, order,
-					high_wmark_pages(zone), end_zone, 0))
-				all_zones_ok = 0;
 			temp_priority[i] = priority;
 			sc.nr_scanned = 0;
 			note_zone_scanning_priority(zone, priority);
@@ -2102,13 +2099,18 @@ loop_again:
 			    total_scanned > sc.nr_reclaimed + sc.nr_reclaimed / 2)
 				sc.may_writepage = 1;
 
-			/*
-			 * We are still under min water mark. it mean we have
-			 * GFP_ATOMIC allocation failure risk. Hurry up!
-			 */
-			if (!zone_watermark_ok(zone, order, min_wmark_pages(zone),
-					      end_zone, 0))
-				has_under_min_watermark_zone = 1;
+			if (!zone_watermark_ok(zone, order,
+					high_wmark_pages(zone), end_zone, 0)) {
+				all_zones_ok = 0;
+				/*
+				 * We are still under min water mark.  This
+				 * means that we have a GFP_ATOMIC allocation
+				 * failure risk. Hurry up!
+				 */
+				if (!zone_watermark_ok(zone, order,
+					    min_wmark_pages(zone), end_zone, 0))
+					has_under_min_watermark_zone = 1;
+			}
 
 		}
 		if (all_zones_ok)
_

Patches currently in -mm which might be from minchan.kim@gmail.com are

linux-next.patch

