From: akpm@linux-foundation.org
Subject: +
 mm-vmscan-fix-memcg-aware-shrinkers-not-called-on-global-reclaim.patch
 added to -mm tree
Date: Mon, 01 Aug 2016 14:39:15 -0700
Message-ID: <579fc183.PxgDLZdf47KcBxOR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43691 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559AbcHAVrN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Aug 2016 17:47:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@virtuozzo.com, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, iamjoonsoo.kim@lge.com, mgorman@techsingularity.net, mhocko@suse.com, minchan@kernel.org, riel@surriel.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmscan: fix memcg-aware shrinkers not called on global reclaim
has been added to the -mm tree.  Its filename is
     mm-vmscan-fix-memcg-aware-shrinkers-not-called-on-global-reclaim.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-fix-memcg-aware-shrinkers-not-called-on-global-reclaim.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-fix-memcg-aware-shrinkers-not-called-on-global-reclaim.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

radix-tree-account-nodes-to-memcg-only-if-explicitly-requested.patch
mm-vmscan-fix-memcg-aware-shrinkers-not-called-on-global-reclaim.patch
mm-memcontrol-fix-swap-counter-leak-on-swapout-from-offline-cgroup.patch
mm-memcontrol-fix-memcg-id-ref-counter-on-swap-charge-move.patch
mm-memcontrol-add-sanity-checks-for-memcg-idref-on-get-put.patch
mm-oom-deduplicate-victim-selection-code-for-memcg-and-global-oom.patch

