From: akpm@linux-foundation.org
Subject: [patch 027/101] mm, vmscan: by default have direct reclaim only
 shrink once per node
Date: Thu, 28 Jul 2016 15:45:53 -0700
Message-ID: <579a8b21.7uNrPwuo/5ytDTAY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56775 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106AbcG1Wpy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Jul 2016 18:45:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mgorman@techsingularity.net, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, iamjoonsoo.kim@lge.com, mhocko@kernel.org, minchan@kernel.org, riel@surriel.com, vbabka@suse.cz

From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm, vmscan: by default have direct reclaim only shrink once per node

Direct reclaim iterates over all zones in the zonelist and shrinking them
but this is in conflict with node-based reclaim.  In the default case,
only shrink once per node.

Link: http://lkml.kernel.org/r/1467970510-21195-11-git-send-email-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Rik van Riel <riel@surriel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-by-default-have-direct-reclaim-only-shrink-once-per-node mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-by-default-have-direct-reclaim-only-shrink-once-per-node
+++ a/mm/vmscan.c
@@ -2552,14 +2552,6 @@ static inline bool compaction_ready(stru
  * try to reclaim pages from zones which will satisfy the caller's allocation
  * request.
  *
- * We reclaim from a zone even if that zone is over high_wmark_pages(zone).
- * Because:
- * a) The caller may be trying to free *extra* pages to satisfy a higher-order
- *    allocation or
- * b) The target zone may be at high_wmark_pages(zone) but the lower zones
- *    must go *over* high_wmark_pages(zone) to satisfy the `incremental min'
- *    zone defense algorithm.
- *
  * If a zone is deemed to be full of pinned pages then just give it a light
  * scan then give up on it.
  */
@@ -2571,6 +2563,7 @@ static void shrink_zones(struct zonelist
 	unsigned long nr_soft_scanned;
 	gfp_t orig_mask;
 	enum zone_type classzone_idx;
+	pg_data_t *last_pgdat = NULL;
 
 	/*
 	 * If the number of buffer_heads in the machine exceeds the maximum
@@ -2630,6 +2623,15 @@ static void shrink_zones(struct zonelist
 			}
 
 			/*
+			 * Shrink each node in the zonelist once. If the
+			 * zonelist is ordered by zone (not the default) then a
+			 * node may be shrunk multiple times but in that case
+			 * the user prefers lower zones being preserved.
+			 */
+			if (zone->zone_pgdat == last_pgdat)
+				continue;
+
+			/*
 			 * This steals pages from memory cgroups over softlimit
 			 * and returns the number of reclaimed pages and
 			 * scanned pages. This works for global memory pressure
@@ -2644,6 +2646,10 @@ static void shrink_zones(struct zonelist
 			/* need some check for avoid more shrink_zone() */
 		}
 
+		/* See comment about same check for global reclaim above */
+		if (zone->zone_pgdat == last_pgdat)
+			continue;
+		last_pgdat = zone->zone_pgdat;
 		shrink_node(zone->zone_pgdat, sc, classzone_idx);
 	}
 
_
