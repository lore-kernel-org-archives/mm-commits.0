From: akpm@linux-foundation.org
Subject: [patch 044/101] mm, vmscan: Have kswapd reclaim from all zones if reclaiming and buffer_heads_over_limit
Date: Thu, 28 Jul 2016 15:46:44 -0700
Message-ID: <579a8b54.wIO6qxamtE2uNbw0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56970 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890AbcG1Wqp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Jul 2016 18:46:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mgorman@techsingularity.net, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, iamjoonsoo.kim@lge.com, mhocko@kernel.org, minchan@kernel.org, riel@surriel.com, vbabka@suse.cz

From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm, vmscan: Have kswapd reclaim from all zones if reclaiming and buffer_heads_over_limit

The buffer_heads_over_limit limit in kswapd is inconsistent with direct
reclaim behaviour. It may force an an attempt to reclaim from all zones and
then not reclaim at all because higher zones were balanced than required
by the original request.

This patch will causes kswapd to consider reclaiming from all zones if
buffer_heads_over_limit.  However, if there are eligible zones for the
allocation request that woke kswapd then no reclaim will occur even if
buffer_heads_over_limit. This avoids kswapd over-reclaiming just because
buffer_heads_over_limit.

[mgorman@techsingularity.net: fix comment about buffer_heads_over_limit]
  Link: http://lkml.kernel.org/r/1468404004-5085-2-git-send-email-mgorman@techsingularity.net
Link: http://lkml.kernel.org/r/1467970510-21195-28-git-send-email-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Rik van Riel <riel@surriel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-have-kswapd-reclaim-from-all-zones-if-reclaiming-and-buffer_heads_over_limit mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-have-kswapd-reclaim-from-all-zones-if-reclaiming-and-buffer_heads_over_limit
+++ a/mm/vmscan.c
@@ -3123,7 +3123,6 @@ static int balance_pgdat(pg_data_t *pgda
 		.may_writepage = !laptop_mode,
 		.may_unmap = 1,
 		.may_swap = 1,
-		.reclaim_idx = classzone_idx,
 	};
 	count_vm_event(PAGEOUTRUN);
 
@@ -3131,12 +3130,17 @@ static int balance_pgdat(pg_data_t *pgda
 		bool raise_priority = true;
 
 		sc.nr_reclaimed = 0;
+		sc.reclaim_idx = classzone_idx;
 
 		/*
-		 * If the number of buffer_heads in the machine exceeds the
-		 * maximum allowed level then reclaim from all zones. This is
-		 * not specific to highmem as highmem may not exist but it is
-		 * it is expected that buffer_heads are stripped in writeback.
+		 * If the number of buffer_heads exceeds the maximum allowed
+		 * then consider reclaiming from all zones. This has a dual
+		 * purpose -- on 64-bit systems it is expected that
+		 * buffer_heads are stripped during active rotation. On 32-bit
+		 * systems, highmem pages can pin lowmem memory and shrinking
+		 * buffers can relieve lowmem pressure. Reclaim may still not
+		 * go ahead if all eligible zones for the original allocation
+		 * request are balanced to avoid excessive reclaim from kswapd.
 		 */
 		if (buffer_heads_over_limit) {
 			for (i = MAX_NR_ZONES - 1; i >= 0; i--) {
@@ -3155,14 +3159,16 @@ static int balance_pgdat(pg_data_t *pgda
 		 * Scanning from low to high zone would allow congestion to be
 		 * cleared during a very small window when a small low
 		 * zone was balanced even under extreme pressure when the
-		 * overall node may be congested.
+		 * overall node may be congested. Note that sc.reclaim_idx
+		 * is not used as buffer_heads_over_limit may have adjusted
+		 * it.
 		 */
-		for (i = sc.reclaim_idx; i >= 0; i--) {
+		for (i = classzone_idx; i >= 0; i--) {
 			zone = pgdat->node_zones + i;
 			if (!populated_zone(zone))
 				continue;
 
-			if (zone_balanced(zone, sc.order, sc.reclaim_idx))
+			if (zone_balanced(zone, sc.order, classzone_idx))
 				goto out;
 		}
 
_
