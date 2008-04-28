From: akpm@linux-foundation.org
Subject: - mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-deporkify.patch removed from -mm tree
Date: Sun, 27 Apr 2008 23:53:01 -0700
Message-ID: <200804280653.m3S6r1Oh012634@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32867 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756338AbYD1Gxq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 02:53:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, clameter@sgi.com, hugh@veritas.com, kamezawa.hiroyu@jp.fujitsu.com, lee.schermerhorn@hp.com, nickpiggin@yahoo.com.au, mm-commits@vger.kernel.org


The patch titled
     Uninline zonelist iterator helper functions
has been removed from the -mm tree.  Its filename was
     mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-deporkify.patch

This patch was dropped because it was folded into mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Uninline zonelist iterator helper functions
From: Mel Gorman <mel@csn.ul.ie>

for_each_zone_zonelist_nodemask() uses large inlined helpers.  The number of
callsites using it means that the size of the text section is increased.  This
patch uninlines the helpers to reduce the amount of text bloat.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c            |    4 +-
 include/linux/mmzone.h |   62 ++++++---------------------------------
 mm/mempolicy.c         |    4 +-
 mm/mmzone.c            |   30 ++++++++++++++++++
 mm/page_alloc.c        |   10 +++++-
 5 files changed, 54 insertions(+), 56 deletions(-)

diff -puN fs/buffer.c~mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-deporkify fs/buffer.c
--- a/fs/buffer.c~mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-deporkify
+++ a/fs/buffer.c
@@ -361,6 +361,7 @@ void invalidate_bdev(struct block_device
 static void free_more_memory(void)
 {
 	struct zoneref *zrefs;
+	struct zone *dummy;
 	int nid;
 
 	wakeup_pdflush(1024);
@@ -368,7 +369,8 @@ static void free_more_memory(void)
 
 	for_each_online_node(nid) {
 		zrefs = first_zones_zonelist(node_zonelist(nid, GFP_NOFS),
-						gfp_zone(GFP_NOFS), NULL);
+						gfp_zone(GFP_NOFS), NULL,
+						&dummy);
 		if (zrefs->zone)
 			try_to_free_pages(node_zonelist(nid, GFP_NOFS), 0,
 						GFP_NOFS);
diff -puN include/linux/mmzone.h~mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-deporkify include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-deporkify
+++ a/include/linux/mmzone.h
@@ -750,59 +750,19 @@ static inline int zonelist_node_idx(stru
 #endif /* CONFIG_NUMA */
 }
 
-static inline void zoneref_set_zone(struct zone *zone, struct zoneref *zoneref)
-{
-	zoneref->zone = zone;
-	zoneref->zone_idx = zone_idx(zone);
-}
-
-static inline int zref_in_nodemask(struct zoneref *zref, nodemask_t *nodes)
-{
-#ifdef CONFIG_NUMA
-	return node_isset(zonelist_node_idx(zref), *nodes);
-#else
-	return 1;
-#endif /* CONFIG_NUMA */
-}
+struct zoneref *next_zones_zonelist(struct zoneref *z,
+					enum zone_type highest_zoneidx,
+					nodemask_t *nodes,
+					struct zone **zone);
 
 /* Returns the first zone at or below highest_zoneidx in a zonelist */
 static inline struct zoneref *first_zones_zonelist(struct zonelist *zonelist,
 					enum zone_type highest_zoneidx,
-					nodemask_t *nodes)
+					nodemask_t *nodes,
+					struct zone **zone)
 {
-	struct zoneref *z;
-
-	/* Find the first suitable zone to use for the allocation */
-	z = zonelist->_zonerefs;
-	if (likely(nodes == NULL))
-		while (zonelist_zone_idx(z) > highest_zoneidx)
-			z++;
-	else
-		while (zonelist_zone_idx(z) > highest_zoneidx ||
-				(z->zone && !zref_in_nodemask(z, nodes)))
-			z++;
-
-	return z;
-}
-
-/* Returns the next zone at or below highest_zoneidx in a zonelist */
-static inline struct zoneref *next_zones_zonelist(struct zoneref *z,
-					enum zone_type highest_zoneidx,
-					nodemask_t *nodes)
-{
-	/*
-	 * Find the next suitable zone to use for the allocation.
-	 * Only filter based on nodemask if it's set
-	 */
-	if (likely(nodes == NULL))
-		while (zonelist_zone_idx(z) > highest_zoneidx)
-			z++;
-	else
-		while (zonelist_zone_idx(z) > highest_zoneidx ||
-				(z->zone && !zref_in_nodemask(z, nodes)))
-			z++;
-
-	return z;
+	return next_zones_zonelist(zonelist->_zonerefs, highest_zoneidx, nodes,
+								zone);
 }
 
 /**
@@ -817,11 +777,9 @@ static inline struct zoneref *next_zones
  * within a given nodemask
  */
 #define for_each_zone_zonelist_nodemask(zone, z, zlist, highidx, nodemask) \
-	for (z = first_zones_zonelist(zlist, highidx, nodemask),	\
-					zone = zonelist_zone(z++);	\
+	for (z = first_zones_zonelist(zlist, highidx, nodemask, &zone);	\
 		zone;							\
-		z = next_zones_zonelist(z, highidx, nodemask),		\
-					zone = zonelist_zone(z++))
+		z = next_zones_zonelist(z, highidx, nodemask, &zone))	\
 
 /**
  * for_each_zone_zonelist - helper macro to iterate over valid zones in a zonelist at or below a given zone index
diff -puN mm/mempolicy.c~mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-deporkify mm/mempolicy.c
--- a/mm/mempolicy.c~mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-deporkify
+++ a/mm/mempolicy.c
@@ -1214,10 +1214,12 @@ unsigned slab_node(struct mempolicy *pol
 		 */
 		struct zonelist *zonelist;
 		struct zoneref *z;
+		struct zone *dummy;
 		enum zone_type highest_zoneidx = gfp_zone(GFP_KERNEL);
 		zonelist = &NODE_DATA(numa_node_id())->node_zonelists[0];
 		z = first_zones_zonelist(zonelist, highest_zoneidx,
-							&policy->v.nodes);
+							&policy->v.nodes,
+							&dummy);
 		return zonelist_node_idx(z);
 	}
 
diff -puN mm/mmzone.c~mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-deporkify mm/mmzone.c
--- a/mm/mmzone.c~mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-deporkify
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
diff -puN mm/page_alloc.c~mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-deporkify mm/page_alloc.c
--- a/mm/page_alloc.c~mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-deporkify
+++ a/mm/page_alloc.c
@@ -1388,9 +1388,9 @@ get_page_from_freelist(gfp_t gfp_mask, n
 	int zlc_active = 0;		/* set if using zonelist_cache */
 	int did_zlc_setup = 0;		/* just call zlc_setup() one time */
 
-	z = first_zones_zonelist(zonelist, high_zoneidx, nodemask);
+	z = first_zones_zonelist(zonelist, high_zoneidx, nodemask,
+							&preferred_zone);
 	classzone_idx = zonelist_zone_idx(z);
-	preferred_zone = zonelist_zone(z);
 
 zonelist_scan:
 	/*
@@ -1896,6 +1896,12 @@ void show_free_areas(void)
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

remove-set_migrateflags.patch
mm-use-zonelists-instead-of-zones-when-direct-reclaiming-pages.patch
mm-introduce-node_zonelist-for-accessing-the-zonelist-for-a-gfp-mask.patch
mm-remember-what-the-preferred-zone-is-for-zone_statistics.patch
mm-use-two-zonelist-that-are-filtered-by-gfp-mask.patch
mm-have-zonelist-contains-structs-with-both-a-zone-pointer-and-zone_idx.patch
mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask.patch
mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-deporkify.patch
mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-deporkify-fix.patch
hugetlb-decrease-hugetlb_lock-cycling-in-gather_surplus_huge_pages.patch
mempolicy-add-bitmap_onto-and-bitmap_fold-operations.patch
mm-make-early_pfn_to_nid-a-c-function.patch
sparsemem-vmemmap-does-not-need-section-bits.patch
kbuild-create-a-way-to-create-preprocessor-constants-from-c-expressions.patch
pageflags-use-an-enum-for-the-flags.patch
pageflags-get-rid-of-flags_reserved.patch
pageflags-introduce-macros-to-generate-page-flag-functions.patch
pageflags-convert-to-the-use-of-new-macros.patch
pageflags-use-proper-page-flag-functions-in-xen.patch
pageflags-eliminate-pg_xxx-aliases.patch
hugetlb-vmstat-events-for-huge-page-allocations.patch
mempolicy-rename-mpol_free-to-mpol_put.patch
mempolicy-rename-mpol_copy-to-mpol_dup.patch
mempolicy-write-lock-mmap_sem-while-changing-task-mempolicy.patch
mempolicy-fixup-fallback-for-default-shmem-policy.patch
mempolicy-rename-struct-mempolicy-policy-member-to-mode.patch
mempolicy-mark-shared-policies-for-unref.patch
mempolicy-document-setget_policy-vm_ops-apis.patch
mempolicy-rework-mempolicy-reference-counting.patch
mempolicy-use-mpol_preferred-for-system-wide-default-policy.patch
mempolicy-mpol_preferred-cleanups-for-local-allocation.patch
mempolicy-use-mpol_f_local-to-indicate-preferred-local-policy.patch
mempolicy-use-mpol_f_local-to-indicate-preferred-local-policy-fix.patch
mempolicy-clean-up-mpol-to-str-mempolicy-formatting.patch
mempolicy-rework-shmem-mpol-parsing-and-display.patch
mempolicy-support-mpol=local-tmpfs-mount-option.patch
mempolicy-use-struct-mempolicy-pointer-in-shmem_sb_info.patch
mempolicy-use-struct-mempolicy-pointer-in-shmem_sb_info-fix.patch
mempolicy-use-struct-mempolicy-pointer-in-shmem_sb_info-fix-fix.patch
mempolicy-use-struct-mempolicy-pointer-in-shmem_sb_info-fix-fix-fix.patch
mm-fix-broken-gfp_zone-with-__gfp_thisnode.patch

