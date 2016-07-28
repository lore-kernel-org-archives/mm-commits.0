From: akpm@linux-foundation.org
Subject: [patch 023/101] mm, vmscan: have kswapd only scan based on the
 highest requested zone
Date: Thu, 28 Jul 2016 15:45:40 -0700
Message-ID: <579a8b14.S10WzayatWYSpUTU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56706 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488AbcG1Wpm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Jul 2016 18:45:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mgorman@techsingularity.net, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, iamjoonsoo.kim@lge.com, mhocko@kernel.org, minchan@kernel.org, riel@surriel.com, vbabka@suse.cz

From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm, vmscan: have kswapd only scan based on the highest requested zone

kswapd checks all eligible zones to see if they need balancing even if it
was woken for a lower zone.  This made sense when we reclaimed on a
per-zone basis because we wanted to shrink zones fairly so avoid
age-inversion problems.  Ideally this is completely unnecessary when
reclaiming on a per-node basis.  In theory, there may still be anomalies
when all requests are for lower zones and very old pages are preserved in
higher zones but this should be the exceptional case.

Link: http://lkml.kernel.org/r/1467970510-21195-7-git-send-email-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Rik van Riel <riel@surriel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-have-kswapd-only-scan-based-on-the-highest-requested-zone mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-have-kswapd-only-scan-based-on-the-highest-requested-zone
+++ a/mm/vmscan.c
@@ -3209,11 +3209,8 @@ static int balance_pgdat(pg_data_t *pgda
 
 		sc.nr_reclaimed = 0;
 
-		/*
-		 * Scan in the highmem->dma direction for the highest
-		 * zone which needs scanning
-		 */
-		for (i = pgdat->nr_zones - 1; i >= 0; i--) {
+		/* Scan from the highest requested zone to dma */
+		for (i = classzone_idx; i >= 0; i--) {
 			struct zone *zone = pgdat->node_zones + i;
 
 			if (!populated_zone(zone))
_
