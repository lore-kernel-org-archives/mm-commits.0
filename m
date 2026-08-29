Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BE021C5D72
	for <mm-commits@vger.kernel.org>; Sat, 29 Aug 2026 02:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787971427; cv=none; b=m1H9b88EfqMqdgr0ZFnhM/0gg5ADcTSByHrWmH+jM6nRXkq+RcnWer98jAY3ie13RTfBcqNXBwDZhJkFvv5FFbEzLFxnkdaEzPk2jlmYQv6bEAFnQ+jyBIxAJ0AG6XqVChzrfdbeW6eKVnI7L1y5+IJG2H4P2tstDajZUHAOYjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787971427; c=relaxed/simple;
	bh=RLIScDD/Gy+jc0HHZ2SfmQ0bzwRR7qkIcS3X3J2Foqg=;
	h=Date:To:From:Subject:Message-Id; b=oSxsRBHNnhv7pxtEcnRHL4X0LPC50gRUTKmbx2yJZModGR/8yjuv/XqZ/Mv4JLqcbLmyztNc1AT8+T6AUnqHvdqdSF8BaJF9ZyeGrRYcxj6EF3Z0cY9yPjQRxJTwk1jUMZ9p90PhfgTGZeI3orUsdYtbtc5pHlTZoLjWmwlu0pE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=US+/DXja; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="US+/DXja"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB18C1F000E9;
	Sat, 29 Aug 2026 02:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787971425;
	bh=IAuqAMRIey34XlHFwwJKe9mi4me34wD1Knm06pHkLC4=;
	h=Date:To:From:Subject;
	b=US+/DXjaF7Lz67MH9+7Jt1C5WYDYQUD1p3B9rkom69h6hTPgBKUlIMVJUKzcCV930
	 NwtCyv9Ao0iHFx/jLdR0+l1rJx/2sFT1qDh8CyTMenVSLHa+xZL5sYhicgXgcnksuA
	 c3DXtJBd0ycPZ7Sf/n0y2lH8rt5X8PlYWR7copog=
Date: Fri, 28 Aug 2026 19:43:45 -0700
To: mm-commits@vger.kernel.org,tjmercier@google.com,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,ljs@kernel.org,kasong@tencent.com,hannes@cmpxchg.org,david@kernel.org,baohua@kernel.org,axelrasmussen@google.com,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-remove-v1-soft-limit-reclaim.patch added to mm-new branch
Message-Id: <20260829024345.AB18C1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: remove v1 soft limit reclaim
has been added to the -mm mm-new branch.  Its filename is
     memcg-remove-v1-soft-limit-reclaim.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-remove-v1-soft-limit-reclaim.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg: remove v1 soft limit reclaim
Date: Tue, 11 Aug 2026 13:31:56 -0700

Patch series "memcg: remove the v1 soft limit".


This patch (of 8):

Nothing can put a cgroup on the soft limit rbtree anymore, so the tree is
always empty and both callers of memcg1_soft_limit_reclaim() are
guaranteed no-ops.  Remove the reclaim pass from direct reclaim and from
kswapd, along with its implementation.

In shrink_zones() this leaves the global reclaim branch with a last_pgdat
check that is now redundant with the identical check right below it, so
drop it and move the explaining comment down to the check that remains. 
That check could only ever fire once last_pgdat was set, which implies
first_pgdat had already been assigned, so skipping it does not change
which node consider_reclaim_throttle() gets.

Link: https://lore.kernel.org/20260811203203.3456029-1-shakeel.butt@linux.dev
Link: https://lore.kernel.org/20260811203203.3456029-3-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: T.J. Mercier <tjmercier@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   12 --
 mm/memcontrol-v1.c         |  175 -----------------------------------
 mm/vmscan.c                |   39 +------
 3 files changed, 6 insertions(+), 220 deletions(-)

--- a/include/linux/memcontrol.h~memcg-remove-v1-soft-limit-reclaim
+++ a/include/linux/memcontrol.h
@@ -1929,10 +1929,6 @@ static inline bool mem_cgroup_zswap_writ
 /* Cgroup v1-related declarations */
 
 #ifdef CONFIG_MEMCG_V1
-unsigned long memcg1_soft_limit_reclaim(pg_data_t *pgdat, int order,
-					gfp_t gfp_mask,
-					unsigned long *total_scanned);
-
 bool mem_cgroup_oom_synchronize(bool wait);
 
 static inline bool task_in_memcg_oom(struct task_struct *p)
@@ -1953,14 +1949,6 @@ static inline void mem_cgroup_exit_user_
 }
 
 #else /* CONFIG_MEMCG_V1 */
-static inline
-unsigned long memcg1_soft_limit_reclaim(pg_data_t *pgdat, int order,
-					gfp_t gfp_mask,
-					unsigned long *total_scanned)
-{
-	return 0;
-}
-
 static inline bool task_in_memcg_oom(struct task_struct *p)
 {
 	return false;
--- a/mm/memcontrol-v1.c~memcg-remove-v1-soft-limit-reclaim
+++ a/mm/memcontrol-v1.c
@@ -34,13 +34,6 @@ struct mem_cgroup_tree {
 
 static struct mem_cgroup_tree soft_limit_tree __read_mostly;
 
-/*
- * Maximum loops in mem_cgroup_soft_reclaim(), used for soft
- * limit reclaim to prevent infinite loops, if they ever occur.
- */
-#define	MEM_CGROUP_MAX_RECLAIM_LOOPS		100
-#define	MEM_CGROUP_MAX_SOFT_LIMIT_RECLAIM_LOOPS	2
-
 /* for OOM */
 struct mem_cgroup_eventfd_list {
 	struct list_head list;
@@ -233,174 +226,6 @@ void memcg1_remove_from_trees(struct mem
 	}
 }
 
-static struct mem_cgroup_per_node *
-__mem_cgroup_largest_soft_limit_node(struct mem_cgroup_tree_per_node *mctz)
-{
-	struct mem_cgroup_per_node *mz;
-
-retry:
-	mz = NULL;
-	if (!mctz->rb_rightmost)
-		goto done;		/* Nothing to reclaim from */
-
-	mz = rb_entry(mctz->rb_rightmost,
-		      struct mem_cgroup_per_node, tree_node);
-	/*
-	 * Remove the node now but someone else can add it back,
-	 * we will to add it back at the end of reclaim to its correct
-	 * position in the tree.
-	 */
-	__mem_cgroup_remove_exceeded(mz, mctz);
-	if (!soft_limit_excess(mz->memcg) ||
-	    !css_tryget(&mz->memcg->css))
-		goto retry;
-done:
-	return mz;
-}
-
-static struct mem_cgroup_per_node *
-mem_cgroup_largest_soft_limit_node(struct mem_cgroup_tree_per_node *mctz)
-{
-	struct mem_cgroup_per_node *mz;
-
-	spin_lock_irq(&mctz->lock);
-	mz = __mem_cgroup_largest_soft_limit_node(mctz);
-	spin_unlock_irq(&mctz->lock);
-	return mz;
-}
-
-static int mem_cgroup_soft_reclaim(struct mem_cgroup *root_memcg,
-				   pg_data_t *pgdat,
-				   gfp_t gfp_mask,
-				   unsigned long *total_scanned)
-{
-	struct mem_cgroup *victim = NULL;
-	int total = 0;
-	int loop = 0;
-	unsigned long excess;
-	unsigned long nr_scanned;
-	struct mem_cgroup_reclaim_cookie reclaim = {
-		.pgdat = pgdat,
-	};
-
-	excess = soft_limit_excess(root_memcg);
-
-	while (1) {
-		victim = mem_cgroup_iter(root_memcg, victim, &reclaim);
-		if (!victim) {
-			loop++;
-			if (loop >= 2) {
-				/*
-				 * If we have not been able to reclaim
-				 * anything, it might because there are
-				 * no reclaimable pages under this hierarchy
-				 */
-				if (!total)
-					break;
-				/*
-				 * We want to do more targeted reclaim.
-				 * excess >> 2 is not to excessive so as to
-				 * reclaim too much, nor too less that we keep
-				 * coming back to reclaim from this cgroup
-				 */
-				if (total >= (excess >> 2) ||
-					(loop > MEM_CGROUP_MAX_RECLAIM_LOOPS))
-					break;
-			}
-			continue;
-		}
-		total += mem_cgroup_shrink_node(victim, gfp_mask, false,
-					pgdat, &nr_scanned);
-		*total_scanned += nr_scanned;
-		if (!soft_limit_excess(root_memcg))
-			break;
-	}
-	mem_cgroup_iter_break(root_memcg, victim);
-	return total;
-}
-
-unsigned long memcg1_soft_limit_reclaim(pg_data_t *pgdat, int order,
-					    gfp_t gfp_mask,
-					    unsigned long *total_scanned)
-{
-	unsigned long nr_reclaimed = 0;
-	struct mem_cgroup_per_node *mz, *next_mz = NULL;
-	unsigned long reclaimed;
-	int loop = 0;
-	struct mem_cgroup_tree_per_node *mctz;
-	unsigned long excess;
-
-	if (lru_gen_enabled())
-		return 0;
-
-	if (order > 0)
-		return 0;
-
-	mctz = soft_limit_tree.rb_tree_per_node[pgdat->node_id];
-
-	/*
-	 * Do not even bother to check the largest node if the root
-	 * is empty. Do it lockless to prevent lock bouncing. Races
-	 * are acceptable as soft limit is best effort anyway.
-	 */
-	if (!mctz || RB_EMPTY_ROOT(&mctz->rb_root))
-		return 0;
-
-	/*
-	 * This loop can run a while, specially if mem_cgroup's continuously
-	 * keep exceeding their soft limit and putting the system under
-	 * pressure
-	 */
-	do {
-		if (next_mz)
-			mz = next_mz;
-		else
-			mz = mem_cgroup_largest_soft_limit_node(mctz);
-		if (!mz)
-			break;
-
-		reclaimed = mem_cgroup_soft_reclaim(mz->memcg, pgdat,
-						    gfp_mask, total_scanned);
-		nr_reclaimed += reclaimed;
-		spin_lock_irq(&mctz->lock);
-
-		/*
-		 * If we failed to reclaim anything from this memory cgroup
-		 * it is time to move on to the next cgroup
-		 */
-		next_mz = NULL;
-		if (!reclaimed)
-			next_mz = __mem_cgroup_largest_soft_limit_node(mctz);
-
-		excess = soft_limit_excess(mz->memcg);
-		/*
-		 * One school of thought says that we should not add
-		 * back the node to the tree if reclaim returns 0.
-		 * But our reclaim could return 0, simply because due
-		 * to priority we are exposing a smaller subset of
-		 * memory to reclaim from. Consider this as a longer
-		 * term TODO.
-		 */
-		/* If excess == 0, no tree ops */
-		__mem_cgroup_insert_exceeded(mz, mctz, excess);
-		spin_unlock_irq(&mctz->lock);
-		css_put(&mz->memcg->css);
-		loop++;
-		/*
-		 * Could not reclaim anything and there are no more
-		 * mem cgroups to try or we seem to be looping without
-		 * reclaiming anything.
-		 */
-		if (!nr_reclaimed &&
-			(next_mz == NULL ||
-			loop > MEM_CGROUP_MAX_SOFT_LIMIT_RECLAIM_LOOPS))
-			break;
-	} while (!nr_reclaimed);
-	if (next_mz)
-		css_put(&next_mz->memcg->css);
-	return nr_reclaimed;
-}
-
 static u64 mem_cgroup_move_charge_read(struct cgroup_subsys_state *css,
 				struct cftype *cft)
 {
--- a/mm/vmscan.c~memcg-remove-v1-soft-limit-reclaim
+++ a/mm/vmscan.c
@@ -6444,8 +6444,6 @@ static void shrink_zones(struct zonelist
 {
 	struct zoneref *z;
 	struct zone *zone;
-	unsigned long nr_soft_reclaimed;
-	unsigned long nr_soft_scanned;
 	gfp_t orig_mask;
 	pg_data_t *last_pgdat = NULL;
 	pg_data_t *first_pgdat = NULL;
@@ -6487,35 +6485,17 @@ static void shrink_zones(struct zonelist
 				sc->compaction_ready = true;
 				continue;
 			}
-
-			/*
-			 * Shrink each node in the zonelist once. If the
-			 * zonelist is ordered by zone (not the default) then a
-			 * node may be shrunk multiple times but in that case
-			 * the user prefers lower zones being preserved.
-			 */
-			if (zone->zone_pgdat == last_pgdat)
-				continue;
-
-			/*
-			 * This steals pages from memory cgroups over softlimit
-			 * and returns the number of reclaimed pages and
-			 * scanned pages. This works for global memory pressure
-			 * and balancing, not for a memcg's limit.
-			 */
-			nr_soft_scanned = 0;
-			nr_soft_reclaimed = memcg1_soft_limit_reclaim(zone->zone_pgdat,
-								      sc->order, sc->gfp_mask,
-								      &nr_soft_scanned);
-			sc->nr_reclaimed += nr_soft_reclaimed;
-			sc->nr_scanned += nr_soft_scanned;
-			/* need some check for avoid more shrink_zone() */
 		}
 
 		if (!first_pgdat)
 			first_pgdat = zone->zone_pgdat;
 
-		/* See comment about same check for global reclaim above */
+		/*
+		 * Shrink each node in the zonelist once. If the zonelist is
+		 * ordered by zone (not the default) then a node may be shrunk
+		 * multiple times but in that case the user prefers lower zones
+		 * being preserved.
+		 */
 		if (zone->zone_pgdat == last_pgdat)
 			continue;
 		last_pgdat = zone->zone_pgdat;
@@ -7176,8 +7156,6 @@ clear_reclaim_active(pg_data_t *pgdat, i
 static int balance_pgdat(pg_data_t *pgdat, int order, int highest_zoneidx)
 {
 	int i;
-	unsigned long nr_soft_reclaimed;
-	unsigned long nr_soft_scanned;
 	unsigned long pflags;
 	unsigned long nr_boost_reclaim;
 	unsigned long zone_boosts[MAX_NR_ZONES] = { 0, };
@@ -7283,12 +7261,7 @@ restart:
 		 */
 		kswapd_age_node(pgdat, &sc);
 
-		/* Call soft limit reclaim before calling shrink_node. */
 		sc.nr_scanned = 0;
-		nr_soft_scanned = 0;
-		nr_soft_reclaimed = memcg1_soft_limit_reclaim(pgdat, sc.order,
-							      sc.gfp_mask, &nr_soft_scanned);
-		sc.nr_reclaimed += nr_soft_reclaimed;
 
 		/*
 		 * There should be no need to raise the scanning priority if
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

memcg-clear-flushing_cached_charge-on-cpu-offline.patch
memcg-trim-the-per-cpu-charge-stock-instead-of-draining-it.patch
memcg-remove-v1-soft-limit-reclaim.patch
memcg-remove-mem_cgroup_shrink_node.patch
memcg-remove-the-soft-limit-reclaim-tracepoints.patch
memcg-remove-the-soft-limit-rbtree.patch
memcg-remove-lru_gen_soft_reclaim.patch
memcg-remove-the-per-node-soft-limit-tree-fields.patch
memcg-remove-mem_cgroup-soft_limit.patch
memcg-simplify-v1-event-ratelimiting.patch

