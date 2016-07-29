From: akpm@linux-foundation.org
Subject: [merged]
 mm-page_alloc-wake-kswapd-based-on-the-highest-eligible-zone.patch removed
 from -mm tree
Date: Fri, 29 Jul 2016 11:55:09 -0700
Message-ID: <579ba68d.evYre8sDusbnBwNM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37331 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834AbcG2SzK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 29 Jul 2016 14:55:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, iamjoonsoo.kim@lge.com, mhocko@kernel.org, minchan@kernel.org, riel@surriel.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: wake kswapd based on the highest eligible zone
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-wake-kswapd-based-on-the-highest-eligible-zone.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm, page_alloc: wake kswapd based on the highest eligible zone

The ac_classzone_idx is used as the basis for waking kswapd and that is based
on the preferred zoneref. If the preferred zoneref's first zone is lower
than what is available on other nodes, it's possible that kswapd is woken
on a zone with only higher, but still eligible, zones. As classzone_idx
is strictly adhered to now, it causes a problem because eligible pages
are skipped.

For example, node 0 has only DMA32 and node 1 has only NORMAL. An allocating
context running on node 0 may wake kswapd on node 1 telling it to skip
all NORMAL pages.

Link: http://lkml.kernel.org/r/1467970510-21195-23-git-send-email-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Hillf Danton <hillf.zj@alibaba-inc.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Rik van Riel <riel@surriel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-page_alloc-wake-kswapd-based-on-the-highest-eligible-zone mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-wake-kswapd-based-on-the-highest-eligible-zone
+++ a/mm/page_alloc.c
@@ -3372,7 +3372,7 @@ static void wake_all_kswapds(unsigned in
 	for_each_zone_zonelist_nodemask(zone, z, ac->zonelist,
 					ac->high_zoneidx, ac->nodemask) {
 		if (last_pgdat != zone->zone_pgdat)
-			wakeup_kswapd(zone, order, ac_classzone_idx(ac));
+			wakeup_kswapd(zone, order, ac->high_zoneidx);
 		last_pgdat = zone->zone_pgdat;
 	}
 }
_

Patches currently in -mm which might be from mgorman@techsingularity.net are


