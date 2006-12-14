From: akpm@osdl.org
Subject: - cpuset-rework-cpuset_zone_allowed-api.patch removed from -mm tree
Date: Wed, 13 Dec 2006 22:06:52 -0800
Message-ID: <200612140606.kBE66qUX001886@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51940 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751869AbWLNGHK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Dec 2006 01:07:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pj@sgi.com, mm-commits@vger.kernel.org


The patch titled
     cpuset: rework cpuset_zone_allowed api
has been removed from the -mm tree.  Its filename was
     cpuset-rework-cpuset_zone_allowed-api.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: cpuset: rework cpuset_zone_allowed api
From: Paul Jackson <pj@sgi.com>

Elaborate the API for calling cpuset_zone_allowed(), so that users have to
explicitly choose between the two variants:

  cpuset_zone_allowed_hardwall()
  cpuset_zone_allowed_softwall()

Until now, whether or not you got the hardwall flavor depended solely on
whether or not you or'd in the __GFP_HARDWALL gfp flag to the gfp_mask
argument.

If you didn't specify __GFP_HARDWALL, you implicitly got the softwall
version.

Unfortunately, this meant that users would end up with the softwall version
without thinking about it.  Since only the softwall version might sleep,
this led to bugs with possible sleeping in interrupt context on more than
one occassion.

The hardwall version requires that the current tasks mems_allowed allows
the node of the specified zone (or that you're in interrupt or that
__GFP_THISNODE is set or that you're on a one cpuset system.)

The softwall version, depending on the gfp_mask, might allow a node if it
was allowed in the nearest enclusing cpuset marked mem_exclusive (which
requires taking the cpuset lock 'callback_mutex' to evaluate.)

This patch removes the cpuset_zone_allowed() call, and forces the caller to
explicitly choose between the hardwall and the softwall case.

If the caller wants the gfp_mask to determine this choice, they should (1)
be sure they can sleep or that __GFP_HARDWALL is set, and (2) invoke the
cpuset_zone_allowed_softwall() routine.

This adds another 100 or 200 bytes to the kernel text space, due to the few
lines of nearly duplicate code at the top of both cpuset_zone_allowed_*
routines.  It should save a few instructions executed for the calls that
turned into calls of cpuset_zone_allowed_hardwall, thanks to not having to
set (before the call) then check (within the call) the __GFP_HARDWALL flag.

For the most critical call, from get_page_from_freelist(), the same
instructions are executed as before -- the old cpuset_zone_allowed()
routine it used to call is the same code as the
cpuset_zone_allowed_softwall() routine that it calls now.

Not a perfect win, but seems worth it, to reduce this chance of hitting a
sleeping with irq off complaint again.

Signed-off-by: Paul Jackson <pj@sgi.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/cpuset.h |   22 ++++++++--
 kernel/cpuset.c        |   82 +++++++++++++++++++++++++++++++--------
 mm/hugetlb.c           |    2 
 mm/oom_kill.c          |    2 
 mm/page_alloc.c        |    2 
 mm/slab.c              |    2 
 mm/vmscan.c            |    8 +--
 7 files changed, 92 insertions(+), 28 deletions(-)

diff -puN include/linux/cpuset.h~cpuset-rework-cpuset_zone_allowed-api include/linux/cpuset.h
--- a/include/linux/cpuset.h~cpuset-rework-cpuset_zone_allowed-api
+++ a/include/linux/cpuset.h
@@ -30,10 +30,19 @@ void cpuset_update_task_memory_state(voi
 		nodes_subset((nodes), current->mems_allowed)
 int cpuset_zonelist_valid_mems_allowed(struct zonelist *zl);
 
-extern int __cpuset_zone_allowed(struct zone *z, gfp_t gfp_mask);
-static int inline cpuset_zone_allowed(struct zone *z, gfp_t gfp_mask)
+extern int __cpuset_zone_allowed_softwall(struct zone *z, gfp_t gfp_mask);
+extern int __cpuset_zone_allowed_hardwall(struct zone *z, gfp_t gfp_mask);
+
+static int inline cpuset_zone_allowed_softwall(struct zone *z, gfp_t gfp_mask)
+{
+	return number_of_cpusets <= 1 ||
+		__cpuset_zone_allowed_softwall(z, gfp_mask);
+}
+
+static int inline cpuset_zone_allowed_hardwall(struct zone *z, gfp_t gfp_mask)
 {
-	return number_of_cpusets <= 1 || __cpuset_zone_allowed(z, gfp_mask);
+	return number_of_cpusets <= 1 ||
+		__cpuset_zone_allowed_hardwall(z, gfp_mask);
 }
 
 extern int cpuset_excl_nodes_overlap(const struct task_struct *p);
@@ -94,7 +103,12 @@ static inline int cpuset_zonelist_valid_
 	return 1;
 }
 
-static inline int cpuset_zone_allowed(struct zone *z, gfp_t gfp_mask)
+static inline int cpuset_zone_allowed_softwall(struct zone *z, gfp_t gfp_mask)
+{
+	return 1;
+}
+
+static inline int cpuset_zone_allowed_hardwall(struct zone *z, gfp_t gfp_mask)
 {
 	return 1;
 }
diff -puN kernel/cpuset.c~cpuset-rework-cpuset_zone_allowed-api kernel/cpuset.c
--- a/kernel/cpuset.c~cpuset-rework-cpuset_zone_allowed-api
+++ a/kernel/cpuset.c
@@ -2342,32 +2342,48 @@ static const struct cpuset *nearest_excl
 }
 
 /**
- * cpuset_zone_allowed - Can we allocate memory on zone z's memory node?
+ * cpuset_zone_allowed_softwall - Can we allocate on zone z's memory node?
  * @z: is this zone on an allowed node?
- * @gfp_mask: memory allocation flags (we use __GFP_HARDWALL)
+ * @gfp_mask: memory allocation flags
  *
- * If we're in interrupt, yes, we can always allocate.  If zone
+ * If we're in interrupt, yes, we can always allocate.  If
+ * __GFP_THISNODE is set, yes, we can always allocate.  If zone
  * z's node is in our tasks mems_allowed, yes.  If it's not a
  * __GFP_HARDWALL request and this zone's nodes is in the nearest
  * mem_exclusive cpuset ancestor to this tasks cpuset, yes.
  * Otherwise, no.
  *
+ * If __GFP_HARDWALL is set, cpuset_zone_allowed_softwall()
+ * reduces to cpuset_zone_allowed_hardwall().  Otherwise,
+ * cpuset_zone_allowed_softwall() might sleep, and might allow a zone
+ * from an enclosing cpuset.
+ *
+ * cpuset_zone_allowed_hardwall() only handles the simpler case of
+ * hardwall cpusets, and never sleeps.
+ *
+ * The __GFP_THISNODE placement logic is really handled elsewhere,
+ * by forcibly using a zonelist starting at a specified node, and by
+ * (in get_page_from_freelist()) refusing to consider the zones for
+ * any node on the zonelist except the first.  By the time any such
+ * calls get to this routine, we should just shut up and say 'yes'.
+ *
  * GFP_USER allocations are marked with the __GFP_HARDWALL bit,
  * and do not allow allocations outside the current tasks cpuset.
  * GFP_KERNEL allocations are not so marked, so can escape to the
- * nearest mem_exclusive ancestor cpuset.
+ * nearest enclosing mem_exclusive ancestor cpuset.
  *
- * Scanning up parent cpusets requires callback_mutex.  The __alloc_pages()
- * routine only calls here with __GFP_HARDWALL bit _not_ set if
- * it's a GFP_KERNEL allocation, and all nodes in the current tasks
- * mems_allowed came up empty on the first pass over the zonelist.
- * So only GFP_KERNEL allocations, if all nodes in the cpuset are
- * short of memory, might require taking the callback_mutex mutex.
+ * Scanning up parent cpusets requires callback_mutex.  The
+ * __alloc_pages() routine only calls here with __GFP_HARDWALL bit
+ * _not_ set if it's a GFP_KERNEL allocation, and all nodes in the
+ * current tasks mems_allowed came up empty on the first pass over
+ * the zonelist.  So only GFP_KERNEL allocations, if all nodes in the
+ * cpuset are short of memory, might require taking the callback_mutex
+ * mutex.
  *
  * The first call here from mm/page_alloc:get_page_from_freelist()
- * has __GFP_HARDWALL set in gfp_mask, enforcing hardwall cpusets, so
- * no allocation on a node outside the cpuset is allowed (unless in
- * interrupt, of course).
+ * has __GFP_HARDWALL set in gfp_mask, enforcing hardwall cpusets,
+ * so no allocation on a node outside the cpuset is allowed (unless
+ * in interrupt, of course).
  *
  * The second pass through get_page_from_freelist() doesn't even call
  * here for GFP_ATOMIC calls.  For those calls, the __alloc_pages()
@@ -2380,12 +2396,12 @@ static const struct cpuset *nearest_excl
  *	GFP_USER     - only nodes in current tasks mems allowed ok.
  *
  * Rule:
- *    Don't call cpuset_zone_allowed() if you can't sleep, unless you
+ *    Don't call cpuset_zone_allowed_softwall if you can't sleep, unless you
  *    pass in the __GFP_HARDWALL flag set in gfp_flag, which disables
  *    the code that might scan up ancestor cpusets and sleep.
- **/
+ */
 
-int __cpuset_zone_allowed(struct zone *z, gfp_t gfp_mask)
+int __cpuset_zone_allowed_softwall(struct zone *z, gfp_t gfp_mask)
 {
 	int node;			/* node that zone z is on */
 	const struct cpuset *cs;	/* current cpuset ancestors */
@@ -2415,6 +2431,40 @@ int __cpuset_zone_allowed(struct zone *z
 	return allowed;
 }
 
+/*
+ * cpuset_zone_allowed_hardwall - Can we allocate on zone z's memory node?
+ * @z: is this zone on an allowed node?
+ * @gfp_mask: memory allocation flags
+ *
+ * If we're in interrupt, yes, we can always allocate.
+ * If __GFP_THISNODE is set, yes, we can always allocate.  If zone
+ * z's node is in our tasks mems_allowed, yes.   Otherwise, no.
+ *
+ * The __GFP_THISNODE placement logic is really handled elsewhere,
+ * by forcibly using a zonelist starting at a specified node, and by
+ * (in get_page_from_freelist()) refusing to consider the zones for
+ * any node on the zonelist except the first.  By the time any such
+ * calls get to this routine, we should just shut up and say 'yes'.
+ *
+ * Unlike the cpuset_zone_allowed_softwall() variant, above,
+ * this variant requires that the zone be in the current tasks
+ * mems_allowed or that we're in interrupt.  It does not scan up the
+ * cpuset hierarchy for the nearest enclosing mem_exclusive cpuset.
+ * It never sleeps.
+ */
+
+int __cpuset_zone_allowed_hardwall(struct zone *z, gfp_t gfp_mask)
+{
+	int node;			/* node that zone z is on */
+
+	if (in_interrupt() || (gfp_mask & __GFP_THISNODE))
+		return 1;
+	node = zone_to_nid(z);
+	if (node_isset(node, current->mems_allowed))
+		return 1;
+	return 0;
+}
+
 /**
  * cpuset_lock - lock out any changes to cpuset structures
  *
diff -puN mm/hugetlb.c~cpuset-rework-cpuset_zone_allowed-api mm/hugetlb.c
--- a/mm/hugetlb.c~cpuset-rework-cpuset_zone_allowed-api
+++ a/mm/hugetlb.c
@@ -73,7 +73,7 @@ static struct page *dequeue_huge_page(st
 
 	for (z = zonelist->zones; *z; z++) {
 		nid = zone_to_nid(*z);
-		if (cpuset_zone_allowed(*z, GFP_HIGHUSER) &&
+		if (cpuset_zone_allowed_softwall(*z, GFP_HIGHUSER) &&
 		    !list_empty(&hugepage_freelists[nid]))
 			break;
 	}
diff -puN mm/oom_kill.c~cpuset-rework-cpuset_zone_allowed-api mm/oom_kill.c
--- a/mm/oom_kill.c~cpuset-rework-cpuset_zone_allowed-api
+++ a/mm/oom_kill.c
@@ -177,7 +177,7 @@ static inline int constrained_alloc(stru
 	nodemask_t nodes = node_online_map;
 
 	for (z = zonelist->zones; *z; z++)
-		if (cpuset_zone_allowed(*z, gfp_mask))
+		if (cpuset_zone_allowed_softwall(*z, gfp_mask))
 			node_clear(zone_to_nid(*z), nodes);
 		else
 			return CONSTRAINT_CPUSET;
diff -puN mm/page_alloc.c~cpuset-rework-cpuset_zone_allowed-api mm/page_alloc.c
--- a/mm/page_alloc.c~cpuset-rework-cpuset_zone_allowed-api
+++ a/mm/page_alloc.c
@@ -1162,7 +1162,7 @@ zonelist_scan:
 			zone->zone_pgdat != zonelist->zones[0]->zone_pgdat))
 				break;
 		if ((alloc_flags & ALLOC_CPUSET) &&
-			!cpuset_zone_allowed(zone, gfp_mask))
+			!cpuset_zone_allowed_softwall(zone, gfp_mask))
 				goto try_next_zone;
 
 		if (!(alloc_flags & ALLOC_NO_WATERMARKS)) {
diff -puN mm/slab.c~cpuset-rework-cpuset_zone_allowed-api mm/slab.c
--- a/mm/slab.c~cpuset-rework-cpuset_zone_allowed-api
+++ a/mm/slab.c
@@ -3262,7 +3262,7 @@ retry:
 	for (z = zonelist->zones; *z && !obj; z++) {
 		nid = zone_to_nid(*z);
 
-		if (cpuset_zone_allowed(*z, flags | __GFP_HARDWALL) &&
+		if (cpuset_zone_allowed_hardwall(*z, flags) &&
 			cache->nodelists[nid] &&
 			cache->nodelists[nid]->free_objects)
 				obj = ____cache_alloc_node(cache,
diff -puN mm/vmscan.c~cpuset-rework-cpuset_zone_allowed-api mm/vmscan.c
--- a/mm/vmscan.c~cpuset-rework-cpuset_zone_allowed-api
+++ a/mm/vmscan.c
@@ -984,7 +984,7 @@ static unsigned long shrink_zones(int pr
 		if (!populated_zone(zone))
 			continue;
 
-		if (!cpuset_zone_allowed(zone, __GFP_HARDWALL))
+		if (!cpuset_zone_allowed_hardwall(zone, GFP_KERNEL))
 			continue;
 
 		note_zone_scanning_priority(zone, priority);
@@ -1034,7 +1034,7 @@ unsigned long try_to_free_pages(struct z
 	for (i = 0; zones[i] != NULL; i++) {
 		struct zone *zone = zones[i];
 
-		if (!cpuset_zone_allowed(zone, __GFP_HARDWALL))
+		if (!cpuset_zone_allowed_hardwall(zone, GFP_KERNEL))
 			continue;
 
 		lru_pages += zone->nr_active + zone->nr_inactive;
@@ -1089,7 +1089,7 @@ out:
 	for (i = 0; zones[i] != 0; i++) {
 		struct zone *zone = zones[i];
 
-		if (!cpuset_zone_allowed(zone, __GFP_HARDWALL))
+		if (!cpuset_zone_allowed_hardwall(zone, GFP_KERNEL))
 			continue;
 
 		zone->prev_priority = priority;
@@ -1354,7 +1354,7 @@ void wakeup_kswapd(struct zone *zone, in
 		return;
 	if (pgdat->kswapd_max_order < order)
 		pgdat->kswapd_max_order = order;
-	if (!cpuset_zone_allowed(zone, __GFP_HARDWALL))
+	if (!cpuset_zone_allowed_hardwall(zone, GFP_KERNEL))
 		return;
 	if (!waitqueue_active(&pgdat->kswapd_wait))
 		return;
_

Patches currently in -mm which might be from pj@sgi.com are

config_vm_event_counter-comment-decrustify.patch
cpuset-remove-sched-domain-hooks-from-cpusets.patch

