From: akpm@linux-foundation.org
Subject: [merged]
 mm-vmscanc-use-div_round_up-for-calculation-of-zones-balance_gap-and-correct-comments.patch removed from -mm tree
Date: Thu, 05 Jun 2014 12:53:01 -0700
Message-ID: <5390ca9d.JY+/2iD1y6UCTLhX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56521 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753189AbaFETxC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 15:53:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, aquini@redhat.com, nasa4836@gmail.com

Subject: [merged] mm-vmscanc-use-div_round_up-for-calculation-of-zones-balance_gap-and-correct-comments.patch removed from -mm tree
To: nasa4836@gmail.com,aquini@redhat.com,riel@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 12:53:01 -0700


The patch titled
     Subject: mm/vmscan.c: use DIV_ROUND_UP for calculation of zone's balance_gap and correct comments.
has been removed from the -mm tree.  Its filename was
     mm-vmscanc-use-div_round_up-for-calculation-of-zones-balance_gap-and-correct-comments.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jianyu Zhan <nasa4836@gmail.com>
Subject: mm/vmscan.c: use DIV_ROUND_UP for calculation of zone's balance_gap and correct comments.

Currently, we use (zone->managed_pages + KSWAPD_ZONE_BALANCE_GAP_RATIO-1)
/ KSWAPD_ZONE_BALANCE_GAP_RATIO to avoid a zero gap value.  It's better to
use DIV_ROUND_UP macro for neater code and clear meaning.

Besides, the gap value is calculated against the per-zone "managed pages",
not "present pages".  This patch also corrects the comment and do some
rephrasing.

Signed-off-by: Jianyu Zhan <nasa4836@gmail.com>
Acked-by: Rik van Riel <riel@redhat.com>
Acked-by: Rafael Aquini <aquini@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    8 ++++----
 mm/vmscan.c          |   10 ++++------
 2 files changed, 8 insertions(+), 10 deletions(-)

diff -puN include/linux/swap.h~mm-vmscanc-use-div_round_up-for-calculation-of-zones-balance_gap-and-correct-comments include/linux/swap.h
--- a/include/linux/swap.h~mm-vmscanc-use-div_round_up-for-calculation-of-zones-balance_gap-and-correct-comments
+++ a/include/linux/swap.h
@@ -166,10 +166,10 @@ enum {
 #define COMPACT_CLUSTER_MAX SWAP_CLUSTER_MAX
 
 /*
- * Ratio between the present memory in the zone and the "gap" that
- * we're allowing kswapd to shrink in addition to the per-zone high
- * wmark, even for zones that already have the high wmark satisfied,
- * in order to provide better per-zone lru behavior. We are ok to
+ * Ratio between zone->managed_pages and the "gap" that above the per-zone
+ * "high_wmark". While balancing nodes, We allow kswapd to shrink zones that
+ * do not meet the (high_wmark + gap) watermark, even which already met the
+ * high_wmark, in order to provide better per-zone lru behavior. We are ok to
  * spend not more than 1% of the memory for this zone balancing "gap".
  */
 #define KSWAPD_ZONE_BALANCE_GAP_RATIO 100
diff -puN mm/vmscan.c~mm-vmscanc-use-div_round_up-for-calculation-of-zones-balance_gap-and-correct-comments mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscanc-use-div_round_up-for-calculation-of-zones-balance_gap-and-correct-comments
+++ a/mm/vmscan.c
@@ -2295,9 +2295,8 @@ static inline bool compaction_ready(stru
 	 * there is a buffer of free pages available to give compaction
 	 * a reasonable chance of completing and allocating the page
 	 */
-	balance_gap = min(low_wmark_pages(zone),
-		(zone->managed_pages + KSWAPD_ZONE_BALANCE_GAP_RATIO-1) /
-			KSWAPD_ZONE_BALANCE_GAP_RATIO);
+	balance_gap = min(low_wmark_pages(zone), DIV_ROUND_UP(
+			zone->managed_pages, KSWAPD_ZONE_BALANCE_GAP_RATIO));
 	watermark = high_wmark_pages(zone) + balance_gap + (2UL << sc->order);
 	watermark_ok = zone_watermark_ok_safe(zone, 0, watermark, 0, 0);
 
@@ -2949,9 +2948,8 @@ static bool kswapd_shrink_zone(struct zo
 	 * high wmark plus a "gap" where the gap is either the low
 	 * watermark or 1% of the zone, whichever is smaller.
 	 */
-	balance_gap = min(low_wmark_pages(zone),
-		(zone->managed_pages + KSWAPD_ZONE_BALANCE_GAP_RATIO-1) /
-		KSWAPD_ZONE_BALANCE_GAP_RATIO);
+	balance_gap = min(low_wmark_pages(zone), DIV_ROUND_UP(
+			zone->managed_pages, KSWAPD_ZONE_BALANCE_GAP_RATIO));
 
 	/*
 	 * If there is no low memory pressure or the zone is balanced then no
_

Patches currently in -mm which might be from nasa4836@gmail.com are

origin.patch
linux-next.patch
mm-memcontrol-clean-up-memcg-zoneinfo-lookup.patch
mm-memcontrol-remove-unnecessary-memcg-argument-from-soft-limit-functions.patch

