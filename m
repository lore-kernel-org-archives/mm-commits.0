From: akpm@linux-foundation.org
Subject: - mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:51:08 -0700
Message-ID: <200804282151.m3SLp82s017553@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49344 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964945AbYD1Vvx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:51:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, clameter@sgi.com, hugh@veritas.com, kamezawa.hiroyu@jp.fujitsu.com, lee.schermerhorn@hp.com, nickpiggin@yahoo.com.au, mm-commits@vger.kernel.org


The patch titled
     mm: filter based on a nodemask as well as a gfp_mask
has been removed from the -mm tree.  Its filename was
     mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: filter based on a nodemask as well as a gfp_mask
From: Mel Gorman <mel@csn.ul.ie>

The MPOL_BIND policy creates a zonelist that is used for allocations
controlled by that mempolicy.  As the per-node zonelist is already being
filtered based on a zone id, this patch adds a version of __alloc_pages() that
takes a nodemask for further filtering.  This eliminates the need for
MPOL_BIND to create a custom zonelist.

A positive benefit of this is that allocations using MPOL_BIND now use the
local node's distance-ordered zonelist instead of a custom node-id-ordered
zonelist.  I.e., pages will be allocated from the closest allowed node with
available memory.

[Lee.Schermerhorn@hp.com: Mempolicy: update stale documentation and comments]
[Lee.Schermerhorn@hp.com: Mempolicy: make dequeue_huge_page_vma() obey MPOL_BIND nodemask]
[Lee.Schermerhorn@hp.com: Mempolicy: make dequeue_huge_page_vma() obey MPOL_BIND nodemask rework]
Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/numa_memory_policy.txt |   11 -
 fs/buffer.c                             |    9 -
 include/linux/cpuset.h                  |    4 
 include/linux/gfp.h                     |    4 
 include/linux/mempolicy.h               |   19 +-
 include/linux/mmzone.h                  |   80 +++++----
 kernel/cpuset.c                         |   18 --
 mm/hugetlb.c                            |    6 
 mm/mempolicy.c                          |  184 ++++++++--------------
 mm/mmzone.c                             |   30 +++
 mm/page_alloc.c                         |   50 ++++-
 11 files changed, 224 insertions(+), 191 deletions(-)

diff -puN Documentation/vm/numa_memory_policy.txt~mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask Documentation/vm/numa_memory_policy.txt
--- a/Documentation/vm/numa_memory_policy.txt~mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask
+++ a/Documentation/vm/numa_memory_policy.txt
@@ -182,14 +182,9 @@ Components of Memory Policies
 	    The Default mode does not use the optional set of nodes.
 
 	MPOL_BIND:  This mode specifies that memory must come from the
-	set of nodes specified by the policy.
-
-	    The memory policy APIs do not specify an order in which the nodes
-	    will be searched.  However, unlike "local allocation", the Bind
-	    policy does not consider the distance between the nodes.  Rather,
-	    allocations will fallback to the nodes specified by the policy in
-	    order of numeric node id.  Like everything in Linux, this is subject
-	    to change.
+	set of nodes specified by the policy.  Memory will be allocated from
+	the node in the set with sufficient free memory that is closest to
+	the node where the allocation takes place.
 
 	MPOL_PREFERRED:  This mode specifies that the allocation should be
 	attempted from the single node specified in the policy.  If that
diff -puN fs/buffer.c~mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask fs/buffer.c
--- a/fs/buffer.c~mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask
+++ a/fs/buffer.c
@@ -360,16 +360,17 @@ void invalidate_bdev(struct block_device
  */
 static void free_more_memory(void)
 {
-	struct zoneref *zrefs;
+	struct zone *zone;
 	int nid;
 
 	wakeup_pdflush(1024);
 	yield();
 
 	for_each_online_node(nid) {
-		zrefs = first_zones_zonelist(node_zonelist(nid, GFP_NOFS),
-						gfp_zone(GFP_NOFS));
-		if (zrefs->zone)
+		(void)first_zones_zonelist(node_zonelist(nid, GFP_NOFS),
+						gfp_zone(GFP_NOFS), NULL,
+						&zone);
+		if (zone)
 			try_to_free_pages(node_zonelist(nid, GFP_NOFS), 0,
 						GFP_NOFS);
 	}
diff -puN include/linux/cpuset.h~mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask include/linux/cpuset.h
--- a/include/linux/cpuset.h~mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask
+++ a/include/linux/cpuset.h
@@ -26,7 +26,7 @@ extern nodemask_t cpuset_mems_allowed(st
 #define cpuset_current_mems_allowed (current->mems_allowed)
 void cpuset_init_current_mems_allowed(void);
 void cpuset_update_task_memory_state(void);
-int cpuset_zonelist_valid_mems_allowed(struct zonelist *zl);
+int cpuset_nodemask_valid_mems_allowed(nodemask_t *nodemask);
 
 extern int __cpuset_zone_allowed_softwall(struct zone *z, gfp_t gfp_mask);
 extern int __cpuset_zone_allowed_hardwall(struct zone *z, gfp_t gfp_mask);
@@ -103,7 +103,7 @@ static inline nodemask_t cpuset_mems_all
 static inline void cpuset_init_current_mems_allowed(void) {}
 static inline void cpuset_update_task_memory_state(void) {}
 
-static inline int cpuset_zonelist_valid_mems_allowed(struct zonelist *zl)
+static inline int cpuset_nodemask_valid_mems_allowed(nodemask_t *nodemask)
 {
 	return 1;
 }
diff -puN include/linux/gfp.h~mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask include/linux/gfp.h
--- a/include/linux/gfp.h~mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask
+++ a/include/linux/gfp.h
@@ -182,6 +182,10 @@ static inline void arch_alloc_page(struc
 
 extern struct page *__alloc_pages(gfp_t, unsigned int, struct zonelist *);
 
+extern struct page *
+__alloc_pages_nodemask(gfp_t, unsigned int,
+				struct zonelist *, nodemask_t *nodemask);
+
 static inline struct page *alloc_pages_node(int nid, gfp_t gfp_mask,
 						unsigned int order)
 {
diff -puN include/linux/mempolicy.h~mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask include/linux/mempolicy.h
--- a/include/linux/mempolicy.h~mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask
+++ a/include/linux/mempolicy.h
@@ -54,19 +54,20 @@ struct mm_struct;
  * mmap_sem.
  *
  * Freeing policy:
- * When policy is MPOL_BIND v.zonelist is kmalloc'ed and must be kfree'd.
- * All other policies don't have any external state. mpol_free() handles this.
+ * Mempolicy objects are reference counted.  A mempolicy will be freed when
+ * mpol_free() decrements the reference count to zero.
  *
  * Copying policy objects:
- * For MPOL_BIND the zonelist must be always duplicated. mpol_clone() does this.
+ * mpol_copy() allocates a new mempolicy and copies the specified mempolicy
+ * to the new storage.  The reference count of the new object is initialized
+ * to 1, representing the caller of mpol_copy().
  */
 struct mempolicy {
 	atomic_t refcnt;
 	short policy; 	/* See MPOL_* above */
 	union {
-		struct zonelist  *zonelist;	/* bind */
 		short 		 preferred_node; /* preferred */
-		nodemask_t	 nodes;		/* interleave */
+		nodemask_t	 nodes;		/* interleave/bind */
 		/* undefined for default */
 	} v;
 	nodemask_t cpuset_mems_allowed;	/* mempolicy relative to these nodes */
@@ -151,7 +152,8 @@ extern void mpol_fix_fork_child_flag(str
 
 extern struct mempolicy default_policy;
 extern struct zonelist *huge_zonelist(struct vm_area_struct *vma,
-		unsigned long addr, gfp_t gfp_flags, struct mempolicy **mpol);
+				unsigned long addr, gfp_t gfp_flags,
+				struct mempolicy **mpol, nodemask_t **nodemask);
 extern unsigned slab_node(struct mempolicy *policy);
 
 extern enum zone_type policy_zone;
@@ -239,8 +241,11 @@ static inline void mpol_fix_fork_child_f
 }
 
 static inline struct zonelist *huge_zonelist(struct vm_area_struct *vma,
- 		unsigned long addr, gfp_t gfp_flags, struct mempolicy **mpol)
+				unsigned long addr, gfp_t gfp_flags,
+				struct mempolicy **mpol, nodemask_t **nodemask)
 {
+	*mpol = NULL;
+	*nodemask = NULL;
 	return node_zonelist(0, gfp_flags);
 }
 
diff -puN include/linux/mmzone.h~mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask
+++ a/include/linux/mmzone.h
@@ -749,36 +749,60 @@ static inline int zonelist_node_idx(stru
 #endif /* CONFIG_NUMA */
 }
 
-static inline void zoneref_set_zone(struct zone *zone, struct zoneref *zoneref)
-{
-	zoneref->zone = zone;
-	zoneref->zone_idx = zone_idx(zone);
-}
+/**
+ * next_zones_zonelist - Returns the next zone at or below highest_zoneidx within the allowed nodemask using a cursor within a zonelist as a starting point
+ * @z - The cursor used as a starting point for the search
+ * @highest_zoneidx - The zone index of the highest zone to return
+ * @nodes - An optional nodemask to filter the zonelist with
+ * @zone - The first suitable zone found is returned via this parameter
+ *
+ * This function returns the next zone at or below a given zone index that is
+ * within the allowed nodemask using a cursor as the starting point for the
+ * search. The zoneref returned is a cursor that is used as the next starting
+ * point for future calls to next_zones_zonelist().
+ */
+struct zoneref *next_zones_zonelist(struct zoneref *z,
+					enum zone_type highest_zoneidx,
+					nodemask_t *nodes,
+					struct zone **zone);
 
-/* Returns the first zone at or below highest_zoneidx in a zonelist */
+/**
+ * first_zones_zonelist - Returns the first zone at or below highest_zoneidx within the allowed nodemask in a zonelist
+ * @zonelist - The zonelist to search for a suitable zone
+ * @highest_zoneidx - The zone index of the highest zone to return
+ * @nodes - An optional nodemask to filter the zonelist with
+ * @zone - The first suitable zone found is returned via this parameter
+ *
+ * This function returns the first zone at or below a given zone index that is
+ * within the allowed nodemask. The zoneref returned is a cursor that can be
+ * used to iterate the zonelist with next_zones_zonelist. The cursor should
+ * not be used by the caller as it does not match the value of the zone
+ * returned.
+ */
 static inline struct zoneref *first_zones_zonelist(struct zonelist *zonelist,
-					enum zone_type highest_zoneidx)
+					enum zone_type highest_zoneidx,
+					nodemask_t *nodes,
+					struct zone **zone)
 {
-	struct zoneref *z;
-
-	/* Find the first suitable zone to use for the allocation */
-	z = zonelist->_zonerefs;
-	while (zonelist_zone_idx(z) > highest_zoneidx)
-		z++;
-
-	return z;
+	return next_zones_zonelist(zonelist->_zonerefs, highest_zoneidx, nodes,
+								zone);
 }
 
-/* Returns the next zone at or below highest_zoneidx in a zonelist */
-static inline struct zoneref *next_zones_zonelist(struct zoneref *z,
-					enum zone_type highest_zoneidx)
-{
-	/* Find the next suitable zone to use for the allocation */
-	while (zonelist_zone_idx(z) > highest_zoneidx)
-		z++;
-
-	return z;
-}
+/**
+ * for_each_zone_zonelist_nodemask - helper macro to iterate over valid zones in a zonelist at or below a given zone index and within a nodemask
+ * @zone - The current zone in the iterator
+ * @z - The current pointer within zonelist->zones being iterated
+ * @zlist - The zonelist being iterated
+ * @highidx - The zone index of the highest zone to return
+ * @nodemask - Nodemask allowed by the allocator
+ *
+ * This iterator iterates though all zones at or below a given zone index and
+ * within a given nodemask
+ */
+#define for_each_zone_zonelist_nodemask(zone, z, zlist, highidx, nodemask) \
+	for (z = first_zones_zonelist(zlist, highidx, nodemask, &zone);	\
+		zone;							\
+		z = next_zones_zonelist(z, highidx, nodemask, &zone))	\
 
 /**
  * for_each_zone_zonelist - helper macro to iterate over valid zones in a zonelist at or below a given zone index
@@ -790,11 +814,7 @@ static inline struct zoneref *next_zones
  * This iterator iterates though all zones at or below a given zone index.
  */
 #define for_each_zone_zonelist(zone, z, zlist, highidx) \
-	for (z = first_zones_zonelist(zlist, highidx),			\
-					zone = zonelist_zone(z++);	\
-		zone;							\
-		z = next_zones_zonelist(z, highidx),			\
-					zone = zonelist_zone(z++))
+	for_each_zone_zonelist_nodemask(zone, z, zlist, highidx, NULL)
 
 #ifdef CONFIG_SPARSEMEM
 #include <asm/sparsemem.h>
diff -puN kernel/cpuset.c~mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask kernel/cpuset.c
--- a/kernel/cpuset.c~mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask
+++ a/kernel/cpuset.c
@@ -1958,22 +1958,14 @@ nodemask_t cpuset_mems_allowed(struct ta
 }
 
 /**
- * cpuset_zonelist_valid_mems_allowed - check zonelist vs. curremt mems_allowed
- * @zl: the zonelist to be checked
+ * cpuset_nodemask_valid_mems_allowed - check nodemask vs. curremt mems_allowed
+ * @nodemask: the nodemask to be checked
  *
- * Are any of the nodes on zonelist zl allowed in current->mems_allowed?
+ * Are any of the nodes in the nodemask allowed in current->mems_allowed?
  */
-int cpuset_zonelist_valid_mems_allowed(struct zonelist *zl)
+int cpuset_nodemask_valid_mems_allowed(nodemask_t *nodemask)
 {
-	int i;
-
-	for (i = 0; zl->_zonerefs[i].zone; i++) {
-		int nid = zonelist_node_idx(&zl->_zonerefs[i]);
-
-		if (node_isset(nid, current->mems_allowed))
-			return 1;
-	}
-	return 0;
+	return nodes_intersects(*nodemask, current->mems_allowed);
 }
 
 /*
diff -puN mm/hugetlb.c~mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask mm/hugetlb.c
--- a/mm/hugetlb.c~mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask
+++ a/mm/hugetlb.c
@@ -95,12 +95,14 @@ static struct page *dequeue_huge_page_vm
 	int nid;
 	struct page *page = NULL;
 	struct mempolicy *mpol;
+	nodemask_t *nodemask;
 	struct zonelist *zonelist = huge_zonelist(vma, address,
-					htlb_alloc_mask, &mpol);
+					htlb_alloc_mask, &mpol, &nodemask);
 	struct zone *zone;
 	struct zoneref *z;
 
-	for_each_zone_zonelist(zone, z, zonelist, MAX_NR_ZONES - 1) {
+	for_each_zone_zonelist_nodemask(zone, z, zonelist,
+						MAX_NR_ZONES - 1, nodemask) {
 		nid = zone_to_nid(zone);
 		if (cpuset_zone_allowed_softwall(zone, htlb_alloc_mask) &&
 		    !list_empty(&hugepage_freelists[nid])) {
diff -puN mm/mempolicy.c~mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask mm/mempolicy.c
--- a/mm/mempolicy.c~mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask
+++ a/mm/mempolicy.c
@@ -163,42 +163,25 @@ static int mpol_check_policy(int mode, n
 	return 0;
 }
 
-/* Generate a custom zonelist for the BIND policy. */
-static struct zonelist *bind_zonelist(nodemask_t *nodes)
+/* Check that the nodemask contains at least one populated zone */
+static int is_valid_nodemask(nodemask_t *nodemask)
 {
-	struct zonelist *zl;
-	int num, max, nd;
-	enum zone_type k;
+	int nd, k;
 
-	max = 1 + MAX_NR_ZONES * nodes_weight(*nodes);
-	max++;			/* space for zlcache_ptr (see mmzone.h) */
-	zl = kmalloc(sizeof(struct zone *) * max, GFP_KERNEL);
-	if (!zl)
-		return ERR_PTR(-ENOMEM);
-	zl->zlcache_ptr = NULL;
-	num = 0;
-	/* First put in the highest zones from all nodes, then all the next 
-	   lower zones etc. Avoid empty zones because the memory allocator
-	   doesn't like them. If you implement node hot removal you
-	   have to fix that. */
-	k = MAX_NR_ZONES - 1;
-	while (1) {
-		for_each_node_mask(nd, *nodes) { 
-			struct zone *z = &NODE_DATA(nd)->node_zones[k];
-			if (z->present_pages > 0) 
-				zoneref_set_zone(z, &zl->_zonerefs[num++]);
+	/* Check that there is something useful in this mask */
+	k = policy_zone;
+
+	for_each_node_mask(nd, *nodemask) {
+		struct zone *z;
+
+		for (k = 0; k <= policy_zone; k++) {
+			z = &NODE_DATA(nd)->node_zones[k];
+			if (z->present_pages > 0)
+				return 1;
 		}
-		if (k == 0)
-			break;
-		k--;
-	}
-	if (num == 0) {
-		kfree(zl);
-		return ERR_PTR(-EINVAL);
 	}
-	zl->_zonerefs[num].zone = NULL;
-	zl->_zonerefs[num].zone_idx = 0;
-	return zl;
+
+	return 0;
 }
 
 /* Create a new policy */
@@ -229,12 +212,11 @@ static struct mempolicy *mpol_new(int mo
 			policy->v.preferred_node = -1;
 		break;
 	case MPOL_BIND:
-		policy->v.zonelist = bind_zonelist(nodes);
-		if (IS_ERR(policy->v.zonelist)) {
-			void *error_code = policy->v.zonelist;
+		if (!is_valid_nodemask(nodes)) {
 			kmem_cache_free(policy_cache, policy);
-			return error_code;
+			return ERR_PTR(-EINVAL);
 		}
+		policy->v.nodes = *nodes;
 		break;
 	}
 	policy->policy = mode;
@@ -500,19 +482,12 @@ static long do_set_mempolicy(int mode, n
 /* Fill a zone bitmap for a policy */
 static void get_zonemask(struct mempolicy *p, nodemask_t *nodes)
 {
-	int i;
-
 	nodes_clear(*nodes);
 	switch (p->policy) {
-	case MPOL_BIND:
-		for (i = 0; p->v.zonelist->_zonerefs[i].zone; i++) {
-			struct zoneref *zref;
-			zref = &p->v.zonelist->_zonerefs[i];
-			node_set(zonelist_node_idx(zref), *nodes);
-		}
-		break;
 	case MPOL_DEFAULT:
 		break;
+	case MPOL_BIND:
+		/* Fall through */
 	case MPOL_INTERLEAVE:
 		*nodes = p->v.nodes;
 		break;
@@ -1160,6 +1135,18 @@ static struct mempolicy * get_vma_policy
 	return pol;
 }
 
+/* Return a nodemask representing a mempolicy */
+static nodemask_t *nodemask_policy(gfp_t gfp, struct mempolicy *policy)
+{
+	/* Lower zones don't get a nodemask applied for MPOL_BIND */
+	if (unlikely(policy->policy == MPOL_BIND) &&
+			gfp_zone(gfp) >= policy_zone &&
+			cpuset_nodemask_valid_mems_allowed(&policy->v.nodes))
+		return &policy->v.nodes;
+
+	return NULL;
+}
+
 /* Return a zonelist representing a mempolicy */
 static struct zonelist *zonelist_policy(gfp_t gfp, struct mempolicy *policy)
 {
@@ -1172,12 +1159,17 @@ static struct zonelist *zonelist_policy(
 			nd = numa_node_id();
 		break;
 	case MPOL_BIND:
-		/* Lower zones don't get a policy applied */
-		/* Careful: current->mems_allowed might have moved */
-		if (gfp_zone(gfp) >= policy_zone)
-			if (cpuset_zonelist_valid_mems_allowed(policy->v.zonelist))
-				return policy->v.zonelist;
-		/*FALL THROUGH*/
+		/*
+		 * Normally, MPOL_BIND allocations node-local are node-local
+		 * within the allowed nodemask. However, if __GFP_THISNODE is
+		 * set and the current node is part of the mask, we use the
+		 * the zonelist for the first node in the mask instead.
+		 */
+		nd = numa_node_id();
+		if (unlikely(gfp & __GFP_THISNODE) &&
+				unlikely(!node_isset(nd, policy->v.nodes)))
+			nd = first_node(policy->v.nodes);
+		break;
 	case MPOL_INTERLEAVE: /* should not happen */
 	case MPOL_DEFAULT:
 		nd = numa_node_id();
@@ -1220,7 +1212,14 @@ unsigned slab_node(struct mempolicy *pol
 		 * Follow bind policy behavior and start allocation at the
 		 * first node.
 		 */
-		return zonelist_node_idx(policy->v.zonelist->_zonerefs);
+		struct zonelist *zonelist;
+		struct zone *zone;
+		enum zone_type highest_zoneidx = gfp_zone(GFP_KERNEL);
+		zonelist = &NODE_DATA(numa_node_id())->node_zonelists[0];
+		(void)first_zones_zonelist(zonelist, highest_zoneidx,
+							&policy->v.nodes,
+							&zone);
+		return zone->node;
 	}
 
 	case MPOL_PREFERRED:
@@ -1278,25 +1277,31 @@ static inline unsigned interleave_nid(st
  * @vma = virtual memory area whose policy is sought
  * @addr = address in @vma for shared policy lookup and interleave policy
  * @gfp_flags = for requested zone
- * @mpol = pointer to mempolicy pointer for reference counted 'BIND policy
+ * @mpol = pointer to mempolicy pointer for reference counted mempolicy
+ * @nodemask = pointer to nodemask pointer for MPOL_BIND nodemask
  *
  * Returns a zonelist suitable for a huge page allocation.
- * If the effective policy is 'BIND, returns pointer to policy's zonelist.
+ * If the effective policy is 'BIND, returns pointer to local node's zonelist,
+ * and a pointer to the mempolicy's @nodemask for filtering the zonelist.
  * If it is also a policy for which get_vma_policy() returns an extra
- * reference, we must hold that reference until after allocation.
+ * reference, we must hold that reference until after the allocation.
  * In that case, return policy via @mpol so hugetlb allocation can drop
- * the reference.  For non-'BIND referenced policies, we can/do drop the
+ * the reference. For non-'BIND referenced policies, we can/do drop the
  * reference here, so the caller doesn't need to know about the special case
  * for default and current task policy.
  */
 struct zonelist *huge_zonelist(struct vm_area_struct *vma, unsigned long addr,
-				gfp_t gfp_flags, struct mempolicy **mpol)
+				gfp_t gfp_flags, struct mempolicy **mpol,
+				nodemask_t **nodemask)
 {
 	struct mempolicy *pol = get_vma_policy(current, vma, addr);
 	struct zonelist *zl;
 
 	*mpol = NULL;		/* probably no unref needed */
-	if (pol->policy == MPOL_INTERLEAVE) {
+	*nodemask = NULL;	/* assume !MPOL_BIND */
+	if (pol->policy == MPOL_BIND) {
+			*nodemask = &pol->v.nodes;
+	} else if (pol->policy == MPOL_INTERLEAVE) {
 		unsigned nid;
 
 		nid = interleave_nid(pol, vma, addr, HPAGE_SHIFT);
@@ -1376,14 +1381,15 @@ alloc_page_vma(gfp_t gfp, struct vm_area
 		/*
 		 * slow path: ref counted policy -- shared or vma
 		 */
-		struct page *page =  __alloc_pages(gfp, 0, zl);
+		struct page *page =  __alloc_pages_nodemask(gfp, 0,
+						zl, nodemask_policy(gfp, pol));
 		__mpol_free(pol);
 		return page;
 	}
 	/*
 	 * fast path:  default or task policy
 	 */
-	return __alloc_pages(gfp, 0, zl);
+	return __alloc_pages_nodemask(gfp, 0, zl, nodemask_policy(gfp, pol));
 }
 
 /**
@@ -1415,7 +1421,8 @@ struct page *alloc_pages_current(gfp_t g
 		pol = &default_policy;
 	if (pol->policy == MPOL_INTERLEAVE)
 		return alloc_page_interleave(gfp, order, interleave_nodes(pol));
-	return __alloc_pages(gfp, order, zonelist_policy(gfp, pol));
+	return __alloc_pages_nodemask(gfp, order,
+			zonelist_policy(gfp, pol), nodemask_policy(gfp, pol));
 }
 EXPORT_SYMBOL(alloc_pages_current);
 
@@ -1440,14 +1447,6 @@ struct mempolicy *__mpol_copy(struct mem
 	}
 	*new = *old;
 	atomic_set(&new->refcnt, 1);
-	if (new->policy == MPOL_BIND) {
-		int sz = ksize(old->v.zonelist);
-		new->v.zonelist = kmemdup(old->v.zonelist, sz, GFP_KERNEL);
-		if (!new->v.zonelist) {
-			kmem_cache_free(policy_cache, new);
-			return ERR_PTR(-ENOMEM);
-		}
-	}
 	return new;
 }
 
@@ -1461,21 +1460,12 @@ int __mpol_equal(struct mempolicy *a, st
 	switch (a->policy) {
 	case MPOL_DEFAULT:
 		return 1;
+	case MPOL_BIND:
+		/* Fall through */
 	case MPOL_INTERLEAVE:
 		return nodes_equal(a->v.nodes, b->v.nodes);
 	case MPOL_PREFERRED:
 		return a->v.preferred_node == b->v.preferred_node;
-	case MPOL_BIND: {
-		int i;
-		for (i = 0; a->v.zonelist->_zonerefs[i].zone; i++) {
-			struct zone *za, *zb;
-			za = zonelist_zone(&a->v.zonelist->_zonerefs[i]);
-			zb = zonelist_zone(&b->v.zonelist->_zonerefs[i]);
-			if (za != zb)
-				return 0;
-		}
-		return b->v.zonelist->_zonerefs[i].zone == NULL;
-	}
 	default:
 		BUG();
 		return 0;
@@ -1487,8 +1477,6 @@ void __mpol_free(struct mempolicy *p)
 {
 	if (!atomic_dec_and_test(&p->refcnt))
 		return;
-	if (p->policy == MPOL_BIND)
-		kfree(p->v.zonelist);
 	p->policy = MPOL_DEFAULT;
 	kmem_cache_free(policy_cache, p);
 }
@@ -1779,6 +1767,8 @@ static void mpol_rebind_policy(struct me
 	switch (pol->policy) {
 	case MPOL_DEFAULT:
 		break;
+	case MPOL_BIND:
+		/* Fall through */
 	case MPOL_INTERLEAVE:
 		nodes_remap(tmp, pol->v.nodes, *mpolmask, *newmask);
 		pol->v.nodes = tmp;
@@ -1791,32 +1781,6 @@ static void mpol_rebind_policy(struct me
 						*mpolmask, *newmask);
 		*mpolmask = *newmask;
 		break;
-	case MPOL_BIND: {
-		nodemask_t nodes;
-		struct zoneref *z;
-		struct zonelist *zonelist;
-
-		nodes_clear(nodes);
-		for (z = pol->v.zonelist->_zonerefs; z->zone; z++)
-			node_set(zonelist_node_idx(z), nodes);
-		nodes_remap(tmp, nodes, *mpolmask, *newmask);
-		nodes = tmp;
-
-		zonelist = bind_zonelist(&nodes);
-
-		/* If no mem, then zonelist is NULL and we keep old zonelist.
-		 * If that old zonelist has no remaining mems_allowed nodes,
-		 * then zonelist_policy() will "FALL THROUGH" to MPOL_DEFAULT.
-		 */
-
-		if (!IS_ERR(zonelist)) {
-			/* Good - got mem - substitute new zonelist */
-			kfree(pol->v.zonelist);
-			pol->v.zonelist = zonelist;
-		}
-		*mpolmask = *newmask;
-		break;
-	}
 	default:
 		BUG();
 		break;
@@ -1879,9 +1843,7 @@ static inline int mpol_to_str(char *buff
 		break;
 
 	case MPOL_BIND:
-		get_zonemask(pol, &nodes);
-		break;
-
+		/* Fall through */
 	case MPOL_INTERLEAVE:
 		nodes = pol->v.nodes;
 		break;
diff -puN mm/mmzone.c~mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask mm/mmzone.c
--- a/mm/mmzone.c~mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask
+++ a/mm/mmzone.c
@@ -42,3 +42,33 @@ struct zone *next_zone(struct zone *zone
 	return zone;
 }
 
+static inline int zref_in_nodemask(struct zoneref *zref, nodemask_t *nodes)
+{
+#ifdef CONFIG_NUMA
+	return node_isset(zonelist_node_idx(zref), *nodes);
+#else
+	return 1;
+#endif /* CONFIG_NUMA */
+}
+
+/* Returns the next zone at or below highest_zoneidx in a zonelist */
+struct zoneref *next_zones_zonelist(struct zoneref *z,
+					enum zone_type highest_zoneidx,
+					nodemask_t *nodes,
+					struct zone **zone)
+{
+	/*
+	 * Find the next suitable zone to use for the allocation.
+	 * Only filter based on nodemask if it's set
+	 */
+	if (likely(nodes == NULL))
+		while (zonelist_zone_idx(z) > highest_zoneidx)
+			z++;
+	else
+		while (zonelist_zone_idx(z) > highest_zoneidx ||
+				(z->zone && !zref_in_nodemask(z, nodes)))
+			z++;
+
+	*zone = zonelist_zone(z++);
+	return z;
+}
diff -puN mm/page_alloc.c~mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask mm/page_alloc.c
--- a/mm/page_alloc.c~mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask
+++ a/mm/page_alloc.c
@@ -1377,7 +1377,7 @@ static void zlc_mark_zone_full(struct zo
  * a page.
  */
 static struct page *
-get_page_from_freelist(gfp_t gfp_mask, unsigned int order,
+get_page_from_freelist(gfp_t gfp_mask, nodemask_t *nodemask, unsigned int order,
 		struct zonelist *zonelist, int high_zoneidx, int alloc_flags)
 {
 	struct zoneref *z;
@@ -1388,16 +1388,17 @@ get_page_from_freelist(gfp_t gfp_mask, u
 	int zlc_active = 0;		/* set if using zonelist_cache */
 	int did_zlc_setup = 0;		/* just call zlc_setup() one time */
 
-	z = first_zones_zonelist(zonelist, high_zoneidx);
-	classzone_idx = zonelist_zone_idx(z);
-	preferred_zone = zonelist_zone(z);
+	(void)first_zones_zonelist(zonelist, high_zoneidx, nodemask,
+							&preferred_zone);
+	classzone_idx = zone_idx(preferred_zone);
 
 zonelist_scan:
 	/*
 	 * Scan zonelist, looking for a zone with enough free.
 	 * See also cpuset_zone_allowed() comment in kernel/cpuset.c.
 	 */
-	for_each_zone_zonelist(zone, z, zonelist, high_zoneidx) {
+	for_each_zone_zonelist_nodemask(zone, z, zonelist,
+						high_zoneidx, nodemask) {
 		if (NUMA_BUILD && zlc_active &&
 			!zlc_zone_worth_trying(zonelist, z, allowednodes))
 				continue;
@@ -1447,9 +1448,9 @@ try_next_zone:
 /*
  * This is the 'heart' of the zoned buddy allocator.
  */
-struct page *
-__alloc_pages(gfp_t gfp_mask, unsigned int order,
-		struct zonelist *zonelist)
+static struct page *
+__alloc_pages_internal(gfp_t gfp_mask, unsigned int order,
+			struct zonelist *zonelist, nodemask_t *nodemask)
 {
 	const gfp_t wait = gfp_mask & __GFP_WAIT;
 	enum zone_type high_zoneidx = gfp_zone(gfp_mask);
@@ -1478,7 +1479,7 @@ restart:
 		return NULL;
 	}
 
-	page = get_page_from_freelist(gfp_mask|__GFP_HARDWALL, order,
+	page = get_page_from_freelist(gfp_mask|__GFP_HARDWALL, nodemask, order,
 			zonelist, high_zoneidx, ALLOC_WMARK_LOW|ALLOC_CPUSET);
 	if (page)
 		goto got_pg;
@@ -1523,7 +1524,7 @@ restart:
 	 * Ignore cpuset if GFP_ATOMIC (!wait) rather than fail alloc.
 	 * See also cpuset_zone_allowed() comment in kernel/cpuset.c.
 	 */
-	page = get_page_from_freelist(gfp_mask, order, zonelist,
+	page = get_page_from_freelist(gfp_mask, nodemask, order, zonelist,
 						high_zoneidx, alloc_flags);
 	if (page)
 		goto got_pg;
@@ -1536,7 +1537,7 @@ rebalance:
 		if (!(gfp_mask & __GFP_NOMEMALLOC)) {
 nofail_alloc:
 			/* go through the zonelist yet again, ignoring mins */
-			page = get_page_from_freelist(gfp_mask, order,
+			page = get_page_from_freelist(gfp_mask, nodemask, order,
 				zonelist, high_zoneidx, ALLOC_NO_WATERMARKS);
 			if (page)
 				goto got_pg;
@@ -1571,7 +1572,7 @@ nofail_alloc:
 		drain_all_pages();
 
 	if (likely(did_some_progress)) {
-		page = get_page_from_freelist(gfp_mask, order,
+		page = get_page_from_freelist(gfp_mask, nodemask, order,
 					zonelist, high_zoneidx, alloc_flags);
 		if (page)
 			goto got_pg;
@@ -1587,8 +1588,9 @@ nofail_alloc:
 		 * a parallel oom killing, we must fail if we're still
 		 * under heavy pressure.
 		 */
-		page = get_page_from_freelist(gfp_mask|__GFP_HARDWALL, order,
-			zonelist, high_zoneidx, ALLOC_WMARK_HIGH|ALLOC_CPUSET);
+		page = get_page_from_freelist(gfp_mask|__GFP_HARDWALL, nodemask,
+			order, zonelist, high_zoneidx,
+			ALLOC_WMARK_HIGH|ALLOC_CPUSET);
 		if (page) {
 			clear_zonelist_oom(zonelist, gfp_mask);
 			goto got_pg;
@@ -1637,6 +1639,20 @@ got_pg:
 	return page;
 }
 
+struct page *
+__alloc_pages(gfp_t gfp_mask, unsigned int order,
+		struct zonelist *zonelist)
+{
+	return __alloc_pages_internal(gfp_mask, order, zonelist, NULL);
+}
+
+struct page *
+__alloc_pages_nodemask(gfp_t gfp_mask, unsigned int order,
+		struct zonelist *zonelist, nodemask_t *nodemask)
+{
+	return __alloc_pages_internal(gfp_mask, order, zonelist, nodemask);
+}
+
 EXPORT_SYMBOL(__alloc_pages);
 
 /*
@@ -1880,6 +1896,12 @@ void show_free_areas(void)
 	show_swap_cache_info();
 }
 
+static void zoneref_set_zone(struct zone *zone, struct zoneref *zoneref)
+{
+	zoneref->zone = zone;
+	zoneref->zone_idx = zone_idx(zone);
+}
+
 /*
  * Builds allocation fallback zone lists.
  *
_

Patches currently in -mm which might be from mel@csn.ul.ie are

origin.patch
mm-fix-usemap-initialization.patch
mm-fix-misleading-__gfp_repeat-related-comments.patch
page-allcoator-smarter-retry-of-costly-order-allocations.patch
page-allocator-explicitly-retry-hugepage-allocations.patch
memcgroup-move-memory-controller-allocations-to-their-own-slabs.patch
page-owner-tracking-leak-detector.patch
add-debugging-aid-for-memory-initialisation-problems.patch

