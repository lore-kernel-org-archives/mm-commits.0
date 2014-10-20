From: akpm@linux-foundation.org
Subject: + cpuset-simplify-cpuset_node_allowed-api.patch added to -mm tree
Date: Mon, 20 Oct 2014 15:36:22 -0700
Message-ID: <54458e66.7/KFY6m1rBCYcrj3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57552 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753388AbaJTWgX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Oct 2014 18:36:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, cl@linux.com, iamjoonsoo.kim@lge.com, lizefan@huawei.com, penberg@kernel.org, rientjes@google.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: cpuset: simplify cpuset_node_allowed API
has been added to the -mm tree.  Its filename is
     cpuset-simplify-cpuset_node_allowed-api.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/cpuset-simplify-cpuset_node_allowed-api.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/cpuset-simplify-cpuset_node_allowed-api.patch

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
Subject: cpuset: simplify cpuset_node_allowed API

Current cpuset API for checking if a zone/node is allowed to allocate from
looks rather awkward.  We have hardwall and softwall versions of
cpuset_node_allowed with the softwall version doing literally the same as
the hardwall version if __GFP_HARDWALL is passed to it in gfp flags.  If
it isn't, the softwall version may check the given node against the
enclosing hardwall cpuset, which it needs to take the callback lock to do.

Such a distinction was introduced by commit 02a0e53d8227 ("cpuset: rework
cpuset_zone_allowed api").  Before, we had the only version with the
__GFP_HARDWALL flag determining its behavior.  The purpose of the commit
was to avoid sleep-in-atomic bugs when someone would mistakenly call the
function without the __GFP_HARDWALL flag for an atomic allocation.  The
suffixes introduced were intended to make the callers think before using
the function.

However, since the callback lock was converted from mutex to spinlock by
the previous patch, the softwall check function cannot sleep, and these
precautions are no longer necessary.

So let's simplify the API back to the single check.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Suggested-by: David Rientjes <rientjes@google.com>
Acked-by: Christoph Lameter <cl@linux.com>
Acked-by: Zefan Li <lizefan@huawei.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cpuset.h |   37 ++++----------------------
 kernel/cpuset.c        |   55 +--------------------------------------
 mm/hugetlb.c           |    2 -
 mm/oom_kill.c          |    2 -
 mm/page_alloc.c        |    6 ++--
 mm/slab.c              |    2 -
 mm/slub.c              |    3 +-
 mm/vmscan.c            |    5 ++-
 8 files changed, 20 insertions(+), 92 deletions(-)

diff -puN include/linux/cpuset.h~cpuset-simplify-cpuset_node_allowed-api include/linux/cpuset.h
--- a/include/linux/cpuset.h~cpuset-simplify-cpuset_node_allowed-api
+++ a/include/linux/cpuset.h
@@ -48,29 +48,16 @@ extern nodemask_t cpuset_mems_allowed(st
 void cpuset_init_current_mems_allowed(void);
 int cpuset_nodemask_valid_mems_allowed(nodemask_t *nodemask);
 
-extern int __cpuset_node_allowed_softwall(int node, gfp_t gfp_mask);
-extern int __cpuset_node_allowed_hardwall(int node, gfp_t gfp_mask);
+extern int __cpuset_node_allowed(int node, gfp_t gfp_mask);
 
-static inline int cpuset_node_allowed_softwall(int node, gfp_t gfp_mask)
+static inline int cpuset_node_allowed(int node, gfp_t gfp_mask)
 {
-	return nr_cpusets() <= 1 ||
-		__cpuset_node_allowed_softwall(node, gfp_mask);
+	return nr_cpusets() <= 1 || __cpuset_node_allowed(node, gfp_mask);
 }
 
-static inline int cpuset_node_allowed_hardwall(int node, gfp_t gfp_mask)
+static inline int cpuset_zone_allowed(struct zone *z, gfp_t gfp_mask)
 {
-	return nr_cpusets() <= 1 ||
-		__cpuset_node_allowed_hardwall(node, gfp_mask);
-}
-
-static inline int cpuset_zone_allowed_softwall(struct zone *z, gfp_t gfp_mask)
-{
-	return cpuset_node_allowed_softwall(zone_to_nid(z), gfp_mask);
-}
-
-static inline int cpuset_zone_allowed_hardwall(struct zone *z, gfp_t gfp_mask)
-{
-	return cpuset_node_allowed_hardwall(zone_to_nid(z), gfp_mask);
+	return cpuset_node_allowed(zone_to_nid(z), gfp_mask);
 }
 
 extern int cpuset_mems_allowed_intersects(const struct task_struct *tsk1,
@@ -179,22 +166,12 @@ static inline int cpuset_nodemask_valid_
 	return 1;
 }
 
-static inline int cpuset_node_allowed_softwall(int node, gfp_t gfp_mask)
-{
-	return 1;
-}
-
-static inline int cpuset_node_allowed_hardwall(int node, gfp_t gfp_mask)
-{
-	return 1;
-}
-
-static inline int cpuset_zone_allowed_softwall(struct zone *z, gfp_t gfp_mask)
+static inline int cpuset_node_allowed(int node, gfp_t gfp_mask)
 {
 	return 1;
 }
 
-static inline int cpuset_zone_allowed_hardwall(struct zone *z, gfp_t gfp_mask)
+static inline int cpuset_zone_allowed(struct zone *z, gfp_t gfp_mask)
 {
 	return 1;
 }
diff -puN kernel/cpuset.c~cpuset-simplify-cpuset_node_allowed-api kernel/cpuset.c
--- a/kernel/cpuset.c~cpuset-simplify-cpuset_node_allowed-api
+++ a/kernel/cpuset.c
@@ -2453,7 +2453,7 @@ static struct cpuset *nearest_hardwall_a
 }
 
 /**
- * cpuset_node_allowed_softwall - Can we allocate on a memory node?
+ * cpuset_node_allowed - Can we allocate on a memory node?
  * @node: is this an allowed node?
  * @gfp_mask: memory allocation flags
  *
@@ -2465,13 +2465,6 @@ static struct cpuset *nearest_hardwall_a
  * flag, yes.
  * Otherwise, no.
  *
- * If __GFP_HARDWALL is set, cpuset_node_allowed_softwall() reduces to
- * cpuset_node_allowed_hardwall().  Otherwise, cpuset_node_allowed_softwall()
- * might sleep, and might allow a node from an enclosing cpuset.
- *
- * cpuset_node_allowed_hardwall() only handles the simpler case of hardwall
- * cpusets, and never sleeps.
- *
  * The __GFP_THISNODE placement logic is really handled elsewhere,
  * by forcibly using a zonelist starting at a specified node, and by
  * (in get_page_from_freelist()) refusing to consider the zones for
@@ -2506,13 +2499,8 @@ static struct cpuset *nearest_hardwall_a
  *	TIF_MEMDIE   - any node ok
  *	GFP_KERNEL   - any node in enclosing hardwalled cpuset ok
  *	GFP_USER     - only nodes in current tasks mems allowed ok.
- *
- * Rule:
- *    Don't call cpuset_node_allowed_softwall if you can't sleep, unless you
- *    pass in the __GFP_HARDWALL flag set in gfp_flag, which disables
- *    the code that might scan up ancestor cpusets and sleep.
  */
-int __cpuset_node_allowed_softwall(int node, gfp_t gfp_mask)
+int __cpuset_node_allowed(int node, gfp_t gfp_mask)
 {
 	struct cpuset *cs;		/* current cpuset ancestors */
 	int allowed;			/* is allocation in zone z allowed? */
@@ -2520,7 +2508,6 @@ int __cpuset_node_allowed_softwall(int n
 
 	if (in_interrupt() || (gfp_mask & __GFP_THISNODE))
 		return 1;
-	might_sleep_if(!(gfp_mask & __GFP_HARDWALL));
 	if (node_isset(node, current->mems_allowed))
 		return 1;
 	/*
@@ -2547,44 +2534,6 @@ int __cpuset_node_allowed_softwall(int n
 	return allowed;
 }
 
-/*
- * cpuset_node_allowed_hardwall - Can we allocate on a memory node?
- * @node: is this an allowed node?
- * @gfp_mask: memory allocation flags
- *
- * If we're in interrupt, yes, we can always allocate.  If __GFP_THISNODE is
- * set, yes, we can always allocate.  If node is in our task's mems_allowed,
- * yes.  If the task has been OOM killed and has access to memory reserves as
- * specified by the TIF_MEMDIE flag, yes.
- * Otherwise, no.
- *
- * The __GFP_THISNODE placement logic is really handled elsewhere,
- * by forcibly using a zonelist starting at a specified node, and by
- * (in get_page_from_freelist()) refusing to consider the zones for
- * any node on the zonelist except the first.  By the time any such
- * calls get to this routine, we should just shut up and say 'yes'.
- *
- * Unlike the cpuset_node_allowed_softwall() variant, above,
- * this variant requires that the node be in the current task's
- * mems_allowed or that we're in interrupt.  It does not scan up the
- * cpuset hierarchy for the nearest enclosing mem_exclusive cpuset.
- * It never sleeps.
- */
-int __cpuset_node_allowed_hardwall(int node, gfp_t gfp_mask)
-{
-	if (in_interrupt() || (gfp_mask & __GFP_THISNODE))
-		return 1;
-	if (node_isset(node, current->mems_allowed))
-		return 1;
-	/*
-	 * Allow tasks that have access to memory reserves because they have
-	 * been OOM killed to get memory anywhere.
-	 */
-	if (unlikely(test_thread_flag(TIF_MEMDIE)))
-		return 1;
-	return 0;
-}
-
 /**
  * cpuset_mem_spread_node() - On which node to begin search for a file page
  * cpuset_slab_spread_node() - On which node to begin search for a slab page
diff -puN mm/hugetlb.c~cpuset-simplify-cpuset_node_allowed-api mm/hugetlb.c
--- a/mm/hugetlb.c~cpuset-simplify-cpuset_node_allowed-api
+++ a/mm/hugetlb.c
@@ -582,7 +582,7 @@ retry_cpuset:
 
 	for_each_zone_zonelist_nodemask(zone, z, zonelist,
 						MAX_NR_ZONES - 1, nodemask) {
-		if (cpuset_zone_allowed_softwall(zone, htlb_alloc_mask(h))) {
+		if (cpuset_zone_allowed(zone, htlb_alloc_mask(h))) {
 			page = dequeue_huge_page_node(h, zone_to_nid(zone));
 			if (page) {
 				if (avoid_reserve)
diff -puN mm/oom_kill.c~cpuset-simplify-cpuset_node_allowed-api mm/oom_kill.c
--- a/mm/oom_kill.c~cpuset-simplify-cpuset_node_allowed-api
+++ a/mm/oom_kill.c
@@ -233,7 +233,7 @@ static enum oom_constraint constrained_a
 	/* Check this allocation failure is caused by cpuset's wall function */
 	for_each_zone_zonelist_nodemask(zone, z, zonelist,
 			high_zoneidx, nodemask)
-		if (!cpuset_zone_allowed_softwall(zone, gfp_mask))
+		if (!cpuset_zone_allowed(zone, gfp_mask))
 			cpuset_limited = true;
 
 	if (cpuset_limited) {
diff -puN mm/page_alloc.c~cpuset-simplify-cpuset_node_allowed-api mm/page_alloc.c
--- a/mm/page_alloc.c~cpuset-simplify-cpuset_node_allowed-api
+++ a/mm/page_alloc.c
@@ -1962,7 +1962,7 @@ zonelist_scan:
 
 	/*
 	 * Scan zonelist, looking for a zone with enough free.
-	 * See also __cpuset_node_allowed_softwall() comment in kernel/cpuset.c.
+	 * See also __cpuset_node_allowed() comment in kernel/cpuset.c.
 	 */
 	for_each_zone_zonelist_nodemask(zone, z, zonelist,
 						high_zoneidx, nodemask) {
@@ -1973,7 +1973,7 @@ zonelist_scan:
 				continue;
 		if (cpusets_enabled() &&
 			(alloc_flags & ALLOC_CPUSET) &&
-			!cpuset_zone_allowed_softwall(zone, gfp_mask))
+			!cpuset_zone_allowed(zone, gfp_mask))
 				continue;
 		/*
 		 * Distribute pages in proportion to the individual
@@ -2506,7 +2506,7 @@ gfp_to_alloc_flags(gfp_t gfp_mask)
 			alloc_flags |= ALLOC_HARDER;
 		/*
 		 * Ignore cpuset mems for GFP_ATOMIC rather than fail, see the
-		 * comment for __cpuset_node_allowed_softwall().
+		 * comment for __cpuset_node_allowed().
 		 */
 		alloc_flags &= ~ALLOC_CPUSET;
 	} else if (unlikely(rt_task(current)) && !in_interrupt())
diff -puN mm/slab.c~cpuset-simplify-cpuset_node_allowed-api mm/slab.c
--- a/mm/slab.c~cpuset-simplify-cpuset_node_allowed-api
+++ a/mm/slab.c
@@ -3012,7 +3012,7 @@ retry:
 	for_each_zone_zonelist(zone, z, zonelist, high_zoneidx) {
 		nid = zone_to_nid(zone);
 
-		if (cpuset_zone_allowed_hardwall(zone, flags) &&
+		if (cpuset_zone_allowed(zone, flags | __GFP_HARDWALL) &&
 			get_node(cache, nid) &&
 			get_node(cache, nid)->free_objects) {
 				obj = ____cache_alloc_node(cache,
diff -puN mm/slub.c~cpuset-simplify-cpuset_node_allowed-api mm/slub.c
--- a/mm/slub.c~cpuset-simplify-cpuset_node_allowed-api
+++ a/mm/slub.c
@@ -1662,7 +1662,8 @@ static void *get_any_partial(struct kmem
 
 			n = get_node(s, zone_to_nid(zone));
 
-			if (n && cpuset_zone_allowed_hardwall(zone, flags) &&
+			if (n && cpuset_zone_allowed(zone,
+						     flags | __GFP_HARDWALL) &&
 					n->nr_partial > s->min_partial) {
 				object = get_partial_node(s, n, c, flags);
 				if (object) {
diff -puN mm/vmscan.c~cpuset-simplify-cpuset_node_allowed-api mm/vmscan.c
--- a/mm/vmscan.c~cpuset-simplify-cpuset_node_allowed-api
+++ a/mm/vmscan.c
@@ -2405,7 +2405,8 @@ static bool shrink_zones(struct zonelist
 		 * to global LRU.
 		 */
 		if (global_reclaim(sc)) {
-			if (!cpuset_zone_allowed_hardwall(zone, GFP_KERNEL))
+			if (!cpuset_zone_allowed(zone,
+						 GFP_KERNEL | __GFP_HARDWALL))
 				continue;
 
 			lru_pages += zone_reclaimable_pages(zone);
@@ -3388,7 +3389,7 @@ void wakeup_kswapd(struct zone *zone, in
 	if (!populated_zone(zone))
 		return;
 
-	if (!cpuset_zone_allowed_hardwall(zone, GFP_KERNEL))
+	if (!cpuset_zone_allowed(zone, GFP_KERNEL | __GFP_HARDWALL))
 		return;
 	pgdat = zone->zone_pgdat;
 	if (pgdat->kswapd_max_order < order) {
_

Patches currently in -mm which might be from vdavydov@parallels.com are

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
mm-memcontrol-micro-optimize-mem_cgroup_update_page_stat.patch
mm-memcontrol-micro-optimize-mem_cgroup_split_huge_fixup.patch
mm-memcontrol-uncharge-pages-on-swapout.patch
mm-memcontrol-remove-unnecessary-pcg_memsw-memoryswap-charge-flag.patch
mm-memcontrol-remove-unnecessary-pcg_mem-memory-charge-flag.patch
mm-memcontrol-remove-unnecessary-pcg_used-pc-mem_cgroup-valid-flag.patch

