From: akpm@linux-foundation.org
Subject: - mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-deporkify-fix.patch removed from -mm tree
Date: Sun, 27 Apr 2008 23:53:04 -0700
Message-ID: <200804280653.m3S6r48w012647@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43315 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753580AbYD1Gxn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 02:53:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, lee.schermerhorn@hp.com, mm-commits@vger.kernel.org


The patch titled
     fix off-by-one usage of first_zones_zonelist()
has been removed from the -mm tree.  Its filename was
     mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-deporkify-fix.patch

This patch was dropped because it was folded into mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fix off-by-one usage of first_zones_zonelist()
From: Mel Gorman <mel@csn.ul.ie>

The return value of first_zones_zonelist() is actually the zoneref AFTER the
"requested zone"--i.e., the first zone in the zonelist that satisfies any
nodemask constraint.  The "requested zone" is returned via the @zone
parameter.  The returned zoneref is intended to be passed to
next_zones_zonelist() on subsequent iterations.

This patch fixes first_zones_zonelist() callers appropriately and documents
first_zones_zonelist() to help avoid a repeat of the same mistake.

Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c            |    9 ++++-----
 include/linux/mmzone.h |   26 +++++++++++++++++++++++++-
 mm/mempolicy.c         |    9 ++++-----
 mm/page_alloc.c        |    4 ++--
 4 files changed, 35 insertions(+), 13 deletions(-)

diff -puN fs/buffer.c~mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-deporkify-fix fs/buffer.c
--- a/fs/buffer.c~mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-deporkify-fix
+++ a/fs/buffer.c
@@ -360,18 +360,17 @@ void invalidate_bdev(struct block_device
  */
 static void free_more_memory(void)
 {
-	struct zoneref *zrefs;
-	struct zone *dummy;
+	struct zone *zone;
 	int nid;
 
 	wakeup_pdflush(1024);
 	yield();
 
 	for_each_online_node(nid) {
-		zrefs = first_zones_zonelist(node_zonelist(nid, GFP_NOFS),
+		(void)first_zones_zonelist(node_zonelist(nid, GFP_NOFS),
 						gfp_zone(GFP_NOFS), NULL,
-						&dummy);
-		if (zrefs->zone)
+						&zone);
+		if (zone)
 			try_to_free_pages(node_zonelist(nid, GFP_NOFS), 0,
 						GFP_NOFS);
 	}
diff -puN include/linux/mmzone.h~mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-deporkify-fix include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-deporkify-fix
+++ a/include/linux/mmzone.h
@@ -749,12 +749,36 @@ static inline int zonelist_node_idx(stru
 #endif /* CONFIG_NUMA */
 }
 
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
 struct zoneref *next_zones_zonelist(struct zoneref *z,
 					enum zone_type highest_zoneidx,
 					nodemask_t *nodes,
 					struct zone **zone);
 
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
 					enum zone_type highest_zoneidx,
 					nodemask_t *nodes,
diff -puN mm/mempolicy.c~mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-deporkify-fix mm/mempolicy.c
--- a/mm/mempolicy.c~mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-deporkify-fix
+++ a/mm/mempolicy.c
@@ -1213,14 +1213,13 @@ unsigned slab_node(struct mempolicy *pol
 		 * first node.
 		 */
 		struct zonelist *zonelist;
-		struct zoneref *z;
-		struct zone *dummy;
+		struct zone *zone;
 		enum zone_type highest_zoneidx = gfp_zone(GFP_KERNEL);
 		zonelist = &NODE_DATA(numa_node_id())->node_zonelists[0];
-		z = first_zones_zonelist(zonelist, highest_zoneidx,
+		(void)first_zones_zonelist(zonelist, highest_zoneidx,
 							&policy->v.nodes,
-							&dummy);
-		return zonelist_node_idx(z);
+							&zone);
+		return zone->node;
 	}
 
 	case MPOL_PREFERRED:
diff -puN mm/page_alloc.c~mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-deporkify-fix mm/page_alloc.c
--- a/mm/page_alloc.c~mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-deporkify-fix
+++ a/mm/page_alloc.c
@@ -1388,9 +1388,9 @@ get_page_from_freelist(gfp_t gfp_mask, n
 	int zlc_active = 0;		/* set if using zonelist_cache */
 	int did_zlc_setup = 0;		/* just call zlc_setup() one time */
 
-	z = first_zones_zonelist(zonelist, high_zoneidx, nodemask,
+	(void)first_zones_zonelist(zonelist, high_zoneidx, nodemask,
 							&preferred_zone);
-	classzone_idx = zonelist_zone_idx(z);
+	classzone_idx = zone_idx(preferred_zone);
 
 zonelist_scan:
 	/*
_

Patches currently in -mm which might be from mel@csn.ul.ie are

remove-set_migrateflags.patch
mm-use-zonelists-instead-of-zones-when-direct-reclaiming-pages.patch
mm-introduce-node_zonelist-for-accessing-the-zonelist-for-a-gfp-mask.patch
mm-remember-what-the-preferred-zone-is-for-zone_statistics.patch
mm-use-two-zonelist-that-are-filtered-by-gfp-mask.patch
mm-have-zonelist-contains-structs-with-both-a-zone-pointer-and-zone_idx.patch
mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask.patch
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

