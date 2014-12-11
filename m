From: akpm@linux-foundation.org
Subject: [merged]
 memcg-remove-mem_cgroup_reclaimable-check-from-soft-reclaim.patch removed
 from -mm tree
Date: Thu, 11 Dec 2014 10:57:18 -0800
Message-ID: <5489e90e.j9UwDbONyhCT4Bw7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45373 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755794AbaLKS5T (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 13:57:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, hannes@cmpxchg.org, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: remove mem_cgroup_reclaimable check from soft reclaim
has been removed from the -mm tree.  Its filename was
     memcg-remove-mem_cgroup_reclaimable-check-from-soft-reclaim.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: memcg: remove mem_cgroup_reclaimable check from soft reclaim

mem_cgroup_reclaimable() checks whether a cgroup has reclaimable pages on
*any* NUMA node.  However, the only place where it's called is
mem_cgroup_soft_reclaim(), which tries to reclaim memory from a *specific*
zone.  So the way it is used is incorrect - it will return true even if
the cgroup doesn't have pages on the zone we're scanning.

I think we can get rid of this check completely, because
mem_cgroup_shrink_node_zone(), which is called by
mem_cgroup_soft_reclaim() if mem_cgroup_reclaimable() returns true, is
equivalent to shrink_lruvec(), which exits almost immediately if the
lruvec passed to it is empty.  So there's no need to optimize anything
here.  Besides, we don't have such a check in the general scan path
(shrink_zone) either.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   43 -------------------------------------------
 1 file changed, 43 deletions(-)

diff -puN mm/memcontrol.c~memcg-remove-mem_cgroup_reclaimable-check-from-soft-reclaim mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-remove-mem_cgroup_reclaimable-check-from-soft-reclaim
+++ a/mm/memcontrol.c
@@ -1743,52 +1743,11 @@ int mem_cgroup_select_victim_node(struct
 	memcg->last_scanned_node = node;
 	return node;
 }
-
-/*
- * Check all nodes whether it contains reclaimable pages or not.
- * For quick scan, we make use of scan_nodes. This will allow us to skip
- * unused nodes. But scan_nodes is lazily updated and may not cotain
- * enough new information. We need to do double check.
- */
-static bool mem_cgroup_reclaimable(struct mem_cgroup *memcg, bool noswap)
-{
-	int nid;
-
-	/*
-	 * quick check...making use of scan_node.
-	 * We can skip unused nodes.
-	 */
-	if (!nodes_empty(memcg->scan_nodes)) {
-		for (nid = first_node(memcg->scan_nodes);
-		     nid < MAX_NUMNODES;
-		     nid = next_node(nid, memcg->scan_nodes)) {
-
-			if (test_mem_cgroup_node_reclaimable(memcg, nid, noswap))
-				return true;
-		}
-	}
-	/*
-	 * Check rest of nodes.
-	 */
-	for_each_node_state(nid, N_MEMORY) {
-		if (node_isset(nid, memcg->scan_nodes))
-			continue;
-		if (test_mem_cgroup_node_reclaimable(memcg, nid, noswap))
-			return true;
-	}
-	return false;
-}
-
 #else
 int mem_cgroup_select_victim_node(struct mem_cgroup *memcg)
 {
 	return 0;
 }
-
-static bool mem_cgroup_reclaimable(struct mem_cgroup *memcg, bool noswap)
-{
-	return test_mem_cgroup_node_reclaimable(memcg, 0, noswap);
-}
 #endif
 
 static int mem_cgroup_soft_reclaim(struct mem_cgroup *root_memcg,
@@ -1832,8 +1791,6 @@ static int mem_cgroup_soft_reclaim(struc
 			}
 			continue;
 		}
-		if (!mem_cgroup_reclaimable(victim, false))
-			continue;
 		total += mem_cgroup_shrink_node_zone(victim, gfp_mask, false,
 						     zone, &nr_scanned);
 		*total_scanned += nr_scanned;
_

Patches currently in -mm which might be from vdavydov@parallels.com are

origin.patch
memcg-__mem_cgroup_free-remove-stale-disarm_static_keys-comment.patch
memcg-dont-check-mm-in-__memcg_kmem_get_cachenewpage_charge.patch
memcg-do-not-abuse-memcg_kmem_skip_account.patch
memcg-zap-kmem_account_flags.patch
memcg-only-check-memcg_kmem_skip_account-in-__memcg_kmem_get_cache.patch
memcg-turn-memcg_kmem_skip_account-into-a-bit-field.patch
mm-vmscan-invoke-slab-shrinkers-from-shrink_zone.patch
mm-vmscan-invoke-slab-shrinkers-from-shrink_zone-fix.patch
memcg-fix-possible-use-after-free-in-memcg_kmem_get_cache.patch
linux-next.patch
slab-fix-cpuset-check-in-fallback_alloc.patch
slub-fix-cpuset-check-in-get_any_partial.patch

