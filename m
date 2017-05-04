From: akpm@linux-foundation.org
Subject: [merged]
 mm-fix-check-for-reclaimable-pages-in-pf_memalloc-reclaim-throttling.patch
 removed from -mm tree
Date: Thu, 04 May 2017 12:09:01 -0700
Message-ID: <20170504190901.Chkou5SIO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50802 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756327AbdEDTJD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 4 May 2017 15:09:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, hejianet@gmail.com, hillf.zj@alibaba-inc.com, mgorman@suse.de, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix check for reclaimable pages in PF_MEMALLOC reclaim throttling
has been removed from the -mm tree.  Its filename was
     mm-fix-check-for-reclaimable-pages-in-pf_memalloc-reclaim-throttling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: fix check for reclaimable pages in PF_MEMALLOC reclaim throttling

PF_MEMALLOC direct reclaimers get throttled on a node when the sum of all
free pages in each zone fall below half the min watermark.  During the
summation, we want to exclude zones that don't have reclaimables. 
Checking the same pgdat over and over again doesn't make sense.

Fixes: 599d0c954f91 ("mm, vmscan: move LRU lists to node")
Link: http://lkml.kernel.org/r/20170228214007.5621-3-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Hillf Danton <hillf.zj@alibaba-inc.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Jia He <hejianet@gmail.com>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN mm/vmscan.c~mm-fix-check-for-reclaimable-pages-in-pf_memalloc-reclaim-throttling mm/vmscan.c
--- a/mm/vmscan.c~mm-fix-check-for-reclaimable-pages-in-pf_memalloc-reclaim-throttling
+++ a/mm/vmscan.c
@@ -2835,8 +2835,10 @@ static bool allow_direct_reclaim(pg_data
 
 	for (i = 0; i <= ZONE_NORMAL; i++) {
 		zone = &pgdat->node_zones[i];
-		if (!managed_zone(zone) ||
-		    pgdat_reclaimable_pages(pgdat) == 0)
+		if (!managed_zone(zone))
+			continue;
+
+		if (!zone_reclaimable_pages(zone))
 			continue;
 
 		pfmemalloc_reserve += min_wmark_pages(zone);
_

Patches currently in -mm which might be from hannes@cmpxchg.org are


