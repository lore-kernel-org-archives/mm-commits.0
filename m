From: akpm@linux-foundation.org
Subject: + vmscan-per-memory-cgroup-slab-shrinkers-fix.patch added to -mm
 tree
Date: Mon, 12 Jan 2015 15:47:14 -0800
Message-ID: <54b45d02.cvlxHCmf5lL09O1o%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36984 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223AbbALXrQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 12 Jan 2015 18:47:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, cl@linux.com, david@fromorbit.com, glommer@gmail.com, gthelen@google.com, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, iamjoonsoo.kim@lge.com, mhocko@suse.cz, penberg@kernel.org, rientjes@google.com, tj@kernel.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: Re: vmscan: per memory cgroup slab shrinkers
has been added to the -mm tree.  Its filename is
     vmscan-per-memory-cgroup-slab-shrinkers-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/vmscan-per-memory-cgroup-slab-shrinkers-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/vmscan-per-memory-cgroup-slab-shrinkers-fix.patch

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
Subject: Re: vmscan: per memory cgroup slab shrinkers

On Fri, Jan 09, 2015 at 02:33:46PM +0800, Hillf Danton wrote:

> Looks sc->nr_reclaimed has to be updated for "limit reclaim".
>
That's true, thank you for catching this!

I think we should move reclaim_state handling to shrink_slab(), as this
incremental patch does:

Cc: Dave Chinner <david@fromorbit.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Greg Thelen <gthelen@google.com>
Cc: Glauber Costa <glommer@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Tejun Heo <tj@kernel.org>
Reported-by: "Hillf Danton" <hillf.zj@alibaba-inc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)

diff -puN mm/vmscan.c~vmscan-per-memory-cgroup-slab-shrinkers-fix mm/vmscan.c
--- a/mm/vmscan.c~vmscan-per-memory-cgroup-slab-shrinkers-fix
+++ a/mm/vmscan.c
@@ -347,6 +347,7 @@ static unsigned long do_shrink_slab(stru
  * @memcg: memory cgroup whose slab caches to target
  * @nr_scanned: pressure numerator
  * @nr_eligible: pressure denominator
+ * @nr_reclaimed: number of reclaimed slab pages
  *
  * Call the shrink functions to age shrinkable caches.
  *
@@ -372,8 +373,10 @@ static unsigned long do_shrink_slab(stru
 static unsigned long shrink_slab(gfp_t gfp_mask, int nid,
 				 struct mem_cgroup *memcg,
 				 unsigned long nr_scanned,
-				 unsigned long nr_eligible)
+				 unsigned long nr_eligible,
+				 unsigned long *nr_reclaimed)
 {
+	struct reclaim_state *reclaim_state = current->reclaim_state;
 	struct shrinker *shrinker;
 	unsigned long freed = 0;
 
@@ -394,6 +397,9 @@ static unsigned long shrink_slab(gfp_t g
 		goto out;
 	}
 
+	if (reclaim_state)
+		reclaim_state->reclaimed_slab = 0;
+
 	list_for_each_entry(shrinker, &shrinker_list, list) {
 		struct shrink_control sc = {
 			.gfp_mask = gfp_mask,
@@ -410,6 +416,9 @@ static unsigned long shrink_slab(gfp_t g
 		freed += do_shrink_slab(&sc, shrinker, nr_scanned, nr_eligible);
 	}
 
+	if (reclaim_state)
+		*nr_reclaimed += reclaim_state->reclaimed_slab;
+
 	up_read(&shrinker_rwsem);
 out:
 	cond_resched();
@@ -419,6 +428,7 @@ out:
 void drop_slab_node(int nid)
 {
 	unsigned long freed;
+	unsigned long nr_reclaimed = 0;
 
 	do {
 		struct mem_cgroup *memcg = NULL;
@@ -426,7 +436,7 @@ void drop_slab_node(int nid)
 		freed = 0;
 		do {
 			freed += shrink_slab(GFP_KERNEL, nid, memcg,
-					     1000, 1000);
+					     1000, 1000, &nr_reclaimed);
 		} while ((memcg = mem_cgroup_iter(NULL, memcg, NULL)) != NULL);
 	} while (freed > 10);
 }
@@ -2307,7 +2317,6 @@ static inline bool should_continue_recla
 static bool shrink_zone(struct zone *zone, struct scan_control *sc,
 			bool is_classzone)
 {
-	struct reclaim_state *reclaim_state = current->reclaim_state;
 	unsigned long nr_reclaimed, nr_scanned;
 	bool reclaimable = false;
 
@@ -2339,7 +2348,7 @@ static bool shrink_zone(struct zone *zon
 			if (memcg && is_classzone)
 				shrink_slab(sc->gfp_mask, zone_to_nid(zone),
 					    memcg, sc->nr_scanned - scanned,
-					    lru_pages);
+					    lru_pages, &sc->nr_reclaimed);
 
 			/*
 			 * Direct reclaim and kswapd have to scan all memory
@@ -2366,12 +2375,7 @@ static bool shrink_zone(struct zone *zon
 		if (global_reclaim(sc) && is_classzone)
 			shrink_slab(sc->gfp_mask, zone_to_nid(zone), NULL,
 				    sc->nr_scanned - nr_scanned,
-				    zone_lru_pages);
-
-		if (reclaim_state) {
-			sc->nr_reclaimed += reclaim_state->reclaimed_slab;
-			reclaim_state->reclaimed_slab = 0;
-		}
+				    zone_lru_pages, &sc->nr_reclaimed);
 
 		vmpressure(sc->gfp_mask, sc->target_mem_cgroup,
 			   sc->nr_scanned - nr_scanned,
@@ -3335,10 +3339,7 @@ static int kswapd(void *p)
 	int balanced_classzone_idx;
 	pg_data_t *pgdat = (pg_data_t*)p;
 	struct task_struct *tsk = current;
-
-	struct reclaim_state reclaim_state = {
-		.reclaimed_slab = 0,
-	};
+	struct reclaim_state reclaim_state;
 	const struct cpumask *cpumask = cpumask_of_node(pgdat->node_id);
 
 	lockdep_set_current_reclaim_state(GFP_KERNEL);
@@ -3476,7 +3477,6 @@ unsigned long shrink_all_memory(unsigned
 
 	p->flags |= PF_MEMALLOC;
 	lockdep_set_current_reclaim_state(sc.gfp_mask);
-	reclaim_state.reclaimed_slab = 0;
 	p->reclaim_state = &reclaim_state;
 
 	nr_reclaimed = do_try_to_free_pages(zonelist, &sc);
@@ -3665,7 +3665,6 @@ static int __zone_reclaim(struct zone *z
 	 */
 	p->flags |= PF_MEMALLOC | PF_SWAPWRITE;
 	lockdep_set_current_reclaim_state(gfp_mask);
-	reclaim_state.reclaimed_slab = 0;
 	p->reclaim_state = &reclaim_state;
 
 	if (zone_pagecache_reclaimable(zone) > zone->min_unmapped_pages) {
_

Patches currently in -mm which might be from vdavydov@parallels.com are

memcg-zap-__memcg_chargeuncharge_slab.patch
memcg-zap-memcg_name-argument-of-memcg_create_kmem_cache.patch
memcg-zap-memcg_slab_caches-and-memcg_slab_mutex.patch
swap-remove-unused-mem_cgroup_uncharge_swapcache-declaration.patch
mm-memcontrol-track-move_lock-state-internally.patch
mm-vmscan-wake-up-all-pfmemalloc-throttled-processes-at-once.patch
list_lru-introduce-list_lru_shrink_countwalk.patch
fs-consolidate-nrfree_cached_objects-args-in-shrink_control.patch
vmscan-per-memory-cgroup-slab-shrinkers.patch
vmscan-per-memory-cgroup-slab-shrinkers-fix.patch
memcg-rename-some-cache-id-related-variables.patch
memcg-add-rwsem-to-synchronize-against-memcg_caches-arrays-relocation.patch
list_lru-get-rid-of-active_nodes.patch
list_lru-organize-all-list_lrus-to-list.patch
list_lru-introduce-per-memcg-lists.patch
fs-make-shrinker-memcg-aware.patch
vmscan-force-scan-offline-memory-cgroups.patch
mm-page_counter-pull-1-handling-out-of-page_counter_memparse.patch
mm-memcontrol-default-hierarchy-interface-for-memory.patch

