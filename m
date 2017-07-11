From: akpm@linux-foundation.org
Subject: [merged]
 hugetlb-add-support-for-preferred-node-to-alloc_huge_page_nodemask.patch
 removed from -mm tree
Date: Tue, 11 Jul 2017 12:24:22 -0700
Message-ID: <20170711192422.PKSoFf7bW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47878 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933716AbdGKTYX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Jul 2017 15:24:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, mhocko@suse.com, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, vbabka@suse.cz


The patch titled
     Subject: hugetlb: add support for preferred node to alloc_huge_page_nodemask
has been removed from the -mm tree.  Its filename was
     hugetlb-add-support-for-preferred-node-to-alloc_huge_page_nodemask.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: hugetlb: add support for preferred node to alloc_huge_page_nodemask

alloc_huge_page_nodemask tries to allocate from any numa node in the
allowed node mask starting from lower numa nodes.  This might lead to
filling up those low NUMA nodes while others are not used.  We can reduce
this risk by introducing a concept of the preferred node similar to what
we have in the regular page allocator.  We will start allocating from the
preferred nid and then iterate over all allowed nodes in the zonelist
order until we try them all.

This is mimicing the page allocator logic except it operates on per-node
mempools.  dequeue_huge_page_vma already does this so distill the zonelist
logic into a more generic dequeue_huge_page_nodemask and use it in
alloc_huge_page_nodemask.

This will allow us to use proper per numa distance fallback also for
alloc_huge_page_node which can use alloc_huge_page_nodemask now and we can
get rid of alloc_huge_page_node helper which doesn't have any user
anymore.

Link: http://lkml.kernel.org/r/20170622193034.28972-3-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Tested-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    5 +-
 include/linux/migrate.h |    2 
 mm/hugetlb.c            |   88 +++++++++++++++++++-------------------
 3 files changed, 48 insertions(+), 47 deletions(-)

diff -puN include/linux/hugetlb.h~hugetlb-add-support-for-preferred-node-to-alloc_huge_page_nodemask include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~hugetlb-add-support-for-preferred-node-to-alloc_huge_page_nodemask
+++ a/include/linux/hugetlb.h
@@ -349,7 +349,8 @@ struct page *alloc_huge_page(struct vm_a
 struct page *alloc_huge_page_node(struct hstate *h, int nid);
 struct page *alloc_huge_page_noerr(struct vm_area_struct *vma,
 				unsigned long addr, int avoid_reserve);
-struct page *alloc_huge_page_nodemask(struct hstate *h, nodemask_t *nmask);
+struct page *alloc_huge_page_nodemask(struct hstate *h, int preferred_nid,
+				nodemask_t *nmask);
 int huge_add_to_page_cache(struct page *page, struct address_space *mapping,
 			pgoff_t idx);
 
@@ -525,7 +526,7 @@ static inline void set_huge_swap_pte_at(
 struct hstate {};
 #define alloc_huge_page(v, a, r) NULL
 #define alloc_huge_page_node(h, nid) NULL
-#define alloc_huge_page_nodemask(h, nmask) NULL
+#define alloc_huge_page_nodemask(h, preferred_nid, nmask) NULL
 #define alloc_huge_page_noerr(v, a, r) NULL
 #define alloc_bootmem_huge_page(h) NULL
 #define hstate_file(f) NULL
diff -puN include/linux/migrate.h~hugetlb-add-support-for-preferred-node-to-alloc_huge_page_nodemask include/linux/migrate.h
--- a/include/linux/migrate.h~hugetlb-add-support-for-preferred-node-to-alloc_huge_page_nodemask
+++ a/include/linux/migrate.h
@@ -38,7 +38,7 @@ static inline struct page *new_page_node
 
 	if (PageHuge(page))
 		return alloc_huge_page_nodemask(page_hstate(compound_head(page)),
-				nodemask);
+				preferred_nid, nodemask);
 
 	if (PageHighMem(page) || (zone_idx(page_zone(page)) == ZONE_MOVABLE))
 		gfp_mask |= __GFP_HIGHMEM;
diff -puN mm/hugetlb.c~hugetlb-add-support-for-preferred-node-to-alloc_huge_page_nodemask mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-add-support-for-preferred-node-to-alloc_huge_page_nodemask
+++ a/mm/hugetlb.c
@@ -887,19 +887,39 @@ static struct page *dequeue_huge_page_no
 	return page;
 }
 
-static struct page *dequeue_huge_page_node(struct hstate *h, int nid)
+static struct page *dequeue_huge_page_nodemask(struct hstate *h, gfp_t gfp_mask, int nid,
+		nodemask_t *nmask)
 {
-	struct page *page;
-	int node;
+	unsigned int cpuset_mems_cookie;
+	struct zonelist *zonelist;
+	struct zone *zone;
+	struct zoneref *z;
+	int node = -1;
 
-	if (nid != NUMA_NO_NODE)
-		return dequeue_huge_page_node_exact(h, nid);
+	zonelist = node_zonelist(nid, gfp_mask);
+
+retry_cpuset:
+	cpuset_mems_cookie = read_mems_allowed_begin();
+	for_each_zone_zonelist_nodemask(zone, z, zonelist, gfp_zone(gfp_mask), nmask) {
+		struct page *page;
+
+		if (!cpuset_zone_allowed(zone, gfp_mask))
+			continue;
+		/*
+		 * no need to ask again on the same node. Pool is node rather than
+		 * zone aware
+		 */
+		if (zone_to_nid(zone) == node)
+			continue;
+		node = zone_to_nid(zone);
 
-	for_each_online_node(node) {
 		page = dequeue_huge_page_node_exact(h, node);
 		if (page)
 			return page;
 	}
+	if (unlikely(read_mems_allowed_retry(cpuset_mems_cookie)))
+		goto retry_cpuset;
+
 	return NULL;
 }
 
@@ -917,15 +937,11 @@ static struct page *dequeue_huge_page_vm
 				unsigned long address, int avoid_reserve,
 				long chg)
 {
-	struct page *page = NULL;
+	struct page *page;
 	struct mempolicy *mpol;
-	nodemask_t *nodemask;
 	gfp_t gfp_mask;
+	nodemask_t *nodemask;
 	int nid;
-	struct zonelist *zonelist;
-	struct zone *zone;
-	struct zoneref *z;
-	unsigned int cpuset_mems_cookie;
 
 	/*
 	 * A child process with MAP_PRIVATE mappings created by their parent
@@ -940,32 +956,15 @@ static struct page *dequeue_huge_page_vm
 	if (avoid_reserve && h->free_huge_pages - h->resv_huge_pages == 0)
 		goto err;
 
-retry_cpuset:
-	cpuset_mems_cookie = read_mems_allowed_begin();
 	gfp_mask = htlb_alloc_mask(h);
 	nid = huge_node(vma, address, gfp_mask, &mpol, &nodemask);
-	zonelist = node_zonelist(nid, gfp_mask);
-
-	for_each_zone_zonelist_nodemask(zone, z, zonelist,
-						MAX_NR_ZONES - 1, nodemask) {
-		if (cpuset_zone_allowed(zone, gfp_mask)) {
-			page = dequeue_huge_page_node(h, zone_to_nid(zone));
-			if (page) {
-				if (avoid_reserve)
-					break;
-				if (!vma_has_reserves(vma, chg))
-					break;
-
-				SetPagePrivate(page);
-				h->resv_huge_pages--;
-				break;
-			}
-		}
+	page = dequeue_huge_page_nodemask(h, gfp_mask, nid, nodemask);
+	if (page && !avoid_reserve && vma_has_reserves(vma, chg)) {
+		SetPagePrivate(page);
+		h->resv_huge_pages--;
 	}
 
 	mpol_cond_put(mpol);
-	if (unlikely(!page && read_mems_allowed_retry(cpuset_mems_cookie)))
-		goto retry_cpuset;
 	return page;
 
 err:
@@ -1633,7 +1632,7 @@ struct page *alloc_huge_page_node(struct
 
 	spin_lock(&hugetlb_lock);
 	if (h->free_huge_pages - h->resv_huge_pages > 0)
-		page = dequeue_huge_page_node(h, nid);
+		page = dequeue_huge_page_nodemask(h, gfp_mask, nid, NULL);
 	spin_unlock(&hugetlb_lock);
 
 	if (!page)
@@ -1642,26 +1641,27 @@ struct page *alloc_huge_page_node(struct
 	return page;
 }
 
-struct page *alloc_huge_page_nodemask(struct hstate *h, nodemask_t *nmask)
+
+struct page *alloc_huge_page_nodemask(struct hstate *h, int preferred_nid,
+		nodemask_t *nmask)
 {
 	gfp_t gfp_mask = htlb_alloc_mask(h);
-	struct page *page = NULL;
-	int node;
 
 	spin_lock(&hugetlb_lock);
 	if (h->free_huge_pages - h->resv_huge_pages > 0) {
-		for_each_node_mask(node, *nmask) {
-			page = dequeue_huge_page_node_exact(h, node);
-			if (page)
-				break;
+		struct page *page;
+
+		page = dequeue_huge_page_nodemask(h, gfp_mask, preferred_nid, nmask);
+		if (page) {
+			spin_unlock(&hugetlb_lock);
+			return page;
 		}
 	}
 	spin_unlock(&hugetlb_lock);
-	if (page)
-		return page;
 
 	/* No reservations, try to overcommit */
-	return __alloc_buddy_huge_page(h, gfp_mask, NUMA_NO_NODE, nmask);
+
+	return __alloc_buddy_huge_page(h, gfp_mask, preferred_nid, nmask);
 }
 
 /*
_

Patches currently in -mm which might be from mhocko@suse.com are

netfilter-use-kvmalloc-xt_alloc_table_info.patch
mips-do-not-use-__gfp_repeat-for-order-0-request.patch
mm-tree-wide-replace-__gfp_repeat-by-__gfp_retry_mayfail-with-more-useful-semantic.patch
mm-tree-wide-replace-__gfp_repeat-by-__gfp_retry_mayfail-with-more-useful-semantic-fix-2.patch
xfs-map-km_mayfail-to-__gfp_retry_mayfail.patch
mm-kvmalloc-support-__gfp_retry_mayfail-for-all-sizes.patch
drm-i915-use-__gfp_retry_mayfail.patch
mm-migration-do-not-trigger-oom-killer-when-migrating-memory.patch

