From: akpm@linux-foundation.org
Subject: +
 memcg-remove-mem_cgroup_reclaimable-check-from-soft-reclaim.patch added to
 -mm tree
Date: Thu, 23 Oct 2014 13:14:34 -0700
Message-ID: <544961aa.kWkVED6DkCZruDr7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45981 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754741AbaJWUOf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 23 Oct 2014 16:14:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, hannes@cmpxchg.org, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: remove mem_cgroup_reclaimable check from soft reclaim
has been added to the -mm tree.  Its filename is
     memcg-remove-mem_cgroup_reclaimable-check-from-soft-reclaim.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcg-remove-mem_cgroup_reclaimable-check-from-soft-reclaim.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memcg-remove-mem_cgroup_reclaimable-check-from-soft-reclaim.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-page-writeback-inline-account_page_dirtied-into-single-caller.patch
mm-memcontrol-fix-missed-end-writeback-page-accounting.patch
mm-memcontrol-fix-missed-end-writeback-page-accounting-fix.patch
mm-rmap-split-out-page_remove_file_rmap.patch
cpuset-convert-callback_mutex-to-a-spinlock.patch
cpuset-simplify-cpuset_node_allowed-api.patch
slab-fix-cpuset-check-in-fallback_alloc.patch
slub-fix-cpuset-check-in-get_any_partial.patch
mm-memcontrol-lockless-page-counters.patch
mm-hugetlb_cgroup-convert-to-lockless-page-counters.patch
kernel-res_counter-remove-the-unused-api.patch
kernel-res_counter-remove-the-unused-api-fix.patch
mm-memcontrol-convert-reclaim-iterator-to-simple-css-refcounting.patch
mm-memcontrol-take-a-css-reference-for-each-charged-page.patch
mm-memcontrol-remove-obsolete-kmemcg-pinning-tricks.patch
mm-memcontrol-continue-cache-reclaim-from-offlined-groups.patch
mm-memcontrol-remove-synchroneous-stock-draining-code.patch
mm-introduce-single-zone-pcplists-drain.patch
mm-page_isolation-drain-single-zone-pcplists.patch
mm-cma-drain-single-zone-pcplists.patch
mm-memory_hotplug-failure-drain-single-zone-pcplists.patch
memcg-simplify-unreclaimable-groups-handling-in-soft-limit-reclaim.patch
memcg-remove-activate_kmem_mutex.patch
mm-memcontrol-micro-optimize-mem_cgroup_split_huge_fixup.patch
mm-memcontrol-uncharge-pages-on-swapout.patch
mm-memcontrol-uncharge-pages-on-swapout-fix.patch
mm-memcontrol-remove-unnecessary-pcg_memsw-memoryswap-charge-flag.patch
mm-memcontrol-remove-unnecessary-pcg_mem-memory-charge-flag.patch
mm-memcontrol-remove-unnecessary-pcg_used-pc-mem_cgroup-valid-flag.patch
mm-memcontrol-remove-unnecessary-pcg_used-pc-mem_cgroup-valid-flag-fix.patch
mm-memcontrol-inline-memcg-move_lock-locking.patch
mm-memcontrol-dont-pass-a-null-memcg-to-mem_cgroup_end_move.patch
mm-memcontrol-fold-mem_cgroup_start_move-mem_cgroup_end_move.patch
mm-memcontrol-fold-mem_cgroup_start_move-mem_cgroup_end_move-fix.patch
memcg-remove-mem_cgroup_reclaimable-check-from-soft-reclaim.patch
mm-memcontrol-do-not-filter-reclaimable-nodes-in-numa-round-robin.patch

