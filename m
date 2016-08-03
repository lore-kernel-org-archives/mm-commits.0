From: akpm@linux-foundation.org
Subject: [merged]
 mm-vmscan-fix-memcg-aware-shrinkers-not-called-on-global-reclaim.patch
 removed from -mm tree
Date: Wed, 03 Aug 2016 11:11:18 -0700
Message-ID: <57a233c6.zlSkhNz2vJTj2kT1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33440 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754059AbcHCSN0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Aug 2016 14:13:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@virtuozzo.com, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, iamjoonsoo.kim@lge.com, mgorman@techsingularity.net, mhocko@suse.com, minchan@kernel.org, riel@surriel.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmscan: fix memcg-aware shrinkers not called on global reclaim
has been removed from the -mm tree.  Its filename was
     mm-vmscan-fix-memcg-aware-shrinkers-not-called-on-global-reclaim.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@virtuozzo.com>
Subject: mm: vmscan: fix memcg-aware shrinkers not called on global reclaim

We must call shrink_slab() for each memory cgroup on both global and memcg
reclaim in shrink_node_memcg().  Commit d71df22b55099 accidentally changed
that so that now shrink_slab() is only called with memcg != NULL on memcg
reclaim.  As a result, memcg-aware shrinkers (including dentry/inode) are
never invoked on global reclaim.  Fix that.

Fixes: b2e18757f2c9 ("mm, vmscan: begin reclaiming pages on a per-node basis")
Link: http://lkml.kernel.org/r/1470056590-7177-1-git-send-email-vdavydov@virtuozzo.com
Signed-off-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Rik van Riel <riel@surriel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/vmscan.c~mm-vmscan-fix-memcg-aware-shrinkers-not-called-on-global-reclaim mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-fix-memcg-aware-shrinkers-not-called-on-global-reclaim
+++ a/mm/vmscan.c
@@ -2561,7 +2561,7 @@ static bool shrink_node(pg_data_t *pgdat
 			shrink_node_memcg(pgdat, memcg, sc, &lru_pages);
 			node_lru_pages += lru_pages;
 
-			if (!global_reclaim(sc))
+			if (memcg)
 				shrink_slab(sc->gfp_mask, pgdat->node_id,
 					    memcg, sc->nr_scanned - scanned,
 					    lru_pages);
_

Patches currently in -mm which might be from vdavydov@virtuozzo.com are

mm-memcontrol-fix-swap-counter-leak-on-swapout-from-offline-cgroup.patch
mm-memcontrol-fix-memcg-id-ref-counter-on-swap-charge-move.patch
mm-memcontrol-add-sanity-checks-for-memcg-idref-on-get-put.patch
mm-oom-deduplicate-victim-selection-code-for-memcg-and-global-oom.patch

