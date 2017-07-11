From: akpm@linux-foundation.org
Subject: [merged]
 hugetlb-memory_hotplug-prefer-to-use-reserved-pages-for-migration.patch
 removed from -mm tree
Date: Tue, 11 Jul 2017 12:23:57 -0700
Message-ID: <20170711192357.DsBrqBzFN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47766 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933716AbdGKTX6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Jul 2017 15:23:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: js1304@gmail.com, mhocko@suse.com, mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, qiuxishi@huawei.com, vbabka@suse.cz, zhongjiang@huawei.com


The patch titled
     Subject: hugetlb, memory_hotplug: prefer to use reserved pages for migration
has been removed from the -mm tree.  Its filename was
     hugetlb-memory_hotplug-prefer-to-use-reserved-pages-for-migration.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: hugetlb, memory_hotplug: prefer to use reserved pages for migration

new_node_page will try to use the origin's next NUMA node as the migration
destination for hugetlb pages.  If such a node doesn't have any
preallocated pool it falls back to __alloc_buddy_huge_page_no_mpol to
allocate a surplus page instead.  This is quite subotpimal for any
configuration when hugetlb pages are no distributed to all NUMA nodes
evenly.  Say we have a hotplugable node 4 and spare hugetlb pages are node
0

/sys/devices/system/node/node0/hugepages/hugepages-2048kB/nr_hugepages:10000
/sys/devices/system/node/node1/hugepages/hugepages-2048kB/nr_hugepages:0
/sys/devices/system/node/node2/hugepages/hugepages-2048kB/nr_hugepages:0
/sys/devices/system/node/node3/hugepages/hugepages-2048kB/nr_hugepages:0
/sys/devices/system/node/node4/hugepages/hugepages-2048kB/nr_hugepages:10000
/sys/devices/system/node/node5/hugepages/hugepages-2048kB/nr_hugepages:0
/sys/devices/system/node/node6/hugepages/hugepages-2048kB/nr_hugepages:0
/sys/devices/system/node/node7/hugepages/hugepages-2048kB/nr_hugepages:0

Now we consume the whole pool on node 4 and try to offline this node.  All
the allocated pages should be moved to node0 which has enough preallocated
pages to hold them.  With the current implementation offlining very likely
fails because hugetlb allocations during runtime are much less reliable.

Fix this by reusing the nodemask which excludes migration source and try
to find a first node which has a page in the preallocated pool first and
fall back to __alloc_buddy_huge_page_no_mpol only when the whole pool is
consumed.

[akpm@linux-foundation.org: remove bogus arg from alloc_huge_page_nodemask() stub]
Link: http://lkml.kernel.org/r/20170608074553.22152-3-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Xishi Qiu <qiuxishi@huawei.com>
Cc: zhong jiang <zhongjiang@huawei.com>
Cc: Joonsoo Kim <js1304@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    2 ++
 mm/hugetlb.c            |   27 +++++++++++++++++++++++++++
 mm/memory_hotplug.c     |    9 ++-------
 3 files changed, 31 insertions(+), 7 deletions(-)

diff -puN include/linux/hugetlb.h~hugetlb-memory_hotplug-prefer-to-use-reserved-pages-for-migration include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~hugetlb-memory_hotplug-prefer-to-use-reserved-pages-for-migration
+++ a/include/linux/hugetlb.h
@@ -349,6 +349,7 @@ struct page *alloc_huge_page(struct vm_a
 struct page *alloc_huge_page_node(struct hstate *h, int nid);
 struct page *alloc_huge_page_noerr(struct vm_area_struct *vma,
 				unsigned long addr, int avoid_reserve);
+struct page *alloc_huge_page_nodemask(struct hstate *h, const nodemask_t *nmask);
 int huge_add_to_page_cache(struct page *page, struct address_space *mapping,
 			pgoff_t idx);
 
@@ -524,6 +525,7 @@ static inline void set_huge_swap_pte_at(
 struct hstate {};
 #define alloc_huge_page(v, a, r) NULL
 #define alloc_huge_page_node(h, nid) NULL
+#define alloc_huge_page_nodemask(h, nmask) NULL
 #define alloc_huge_page_noerr(v, a, r) NULL
 #define alloc_bootmem_huge_page(h) NULL
 #define hstate_file(f) NULL
diff -puN mm/hugetlb.c~hugetlb-memory_hotplug-prefer-to-use-reserved-pages-for-migration mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-memory_hotplug-prefer-to-use-reserved-pages-for-migration
+++ a/mm/hugetlb.c
@@ -1723,6 +1723,33 @@ struct page *alloc_huge_page_node(struct
 	return page;
 }
 
+struct page *alloc_huge_page_nodemask(struct hstate *h, const nodemask_t *nmask)
+{
+	struct page *page = NULL;
+	int node;
+
+	spin_lock(&hugetlb_lock);
+	if (h->free_huge_pages - h->resv_huge_pages > 0) {
+		for_each_node_mask(node, *nmask) {
+			page = dequeue_huge_page_node_exact(h, node);
+			if (page)
+				break;
+		}
+	}
+	spin_unlock(&hugetlb_lock);
+	if (page)
+		return page;
+
+	/* No reservations, try to overcommit */
+	for_each_node_mask(node, *nmask) {
+		page = __alloc_buddy_huge_page_no_mpol(h, node);
+		if (page)
+			return page;
+	}
+
+	return NULL;
+}
+
 /*
  * Increase the hugetlb pool such that it can accommodate a reservation
  * of size 'delta'.
diff -puN mm/memory_hotplug.c~hugetlb-memory_hotplug-prefer-to-use-reserved-pages-for-migration mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~hugetlb-memory_hotplug-prefer-to-use-reserved-pages-for-migration
+++ a/mm/memory_hotplug.c
@@ -1446,14 +1446,9 @@ static struct page *new_node_page(struct
 	if (nodes_empty(nmask))
 		node_set(nid, nmask);
 
-	/*
-	 * TODO: allocate a destination hugepage from a nearest neighbor node,
-	 * accordance with memory policy of the user process if possible. For
-	 * now as a simple work-around, we use the next node for destination.
-	 */
 	if (PageHuge(page))
-		return alloc_huge_page_node(page_hstate(compound_head(page)),
-					next_node_in(nid, nmask));
+		return alloc_huge_page_nodemask(
+				page_hstate(compound_head(page)), &nmask);
 
 	if (PageHighMem(page)
 	    || (zone_idx(page_zone(page)) == ZONE_MOVABLE))
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

