From: akpm@linux-foundation.org
Subject: [merged]
 =?US-ASCII?Q?mm-hugetlb-integrate-giga-hugetlb-more-naturally-to-the-a?=
 =?US-ASCII?Q?llocation-path.patch?= removed from -mm tree
Date: Thu, 01 Feb 2018 11:34:38 -0800
Message-ID: <20180201193438.JbjdggOmq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33044 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754605AbeBATep (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Feb 2018 14:34:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ar@linux.vnet.ibm.com, khandual@linux.vnet.ibm.com, kirill.shutemov@linux.intel.com, mhocko@suse.com, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, vbabka@suse.cz, zi.yan@cs.rutgers.edu


The patch titled
     Subject: mm, hugetlb: integrate giga hugetlb more naturally to the allocation path
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-integrate-giga-hugetlb-more-naturally-to-the-allocation-path.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm, hugetlb: integrate giga hugetlb more naturally to the allocation path

Gigantic hugetlb pages were ingrown to the hugetlb code as an alien specie
with a lot of special casing.  The allocation path is not an exception. 
Unnecessarily so to be honest.  It is true that the underlying allocator
is different but that is an implementation detail.

This patch unifies the hugetlb allocation path that a prepares fresh pool
pages.  alloc_fresh_gigantic_page basically copies alloc_fresh_huge_page
logic so we can move everything there.  This will simplify
set_max_huge_pages which doesn't have to care about what kind of huge page
we allocate.

Link: http://lkml.kernel.org/r/20180103093213.26329-3-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andrea Reale <ar@linux.vnet.ibm.com>
Cc: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <zi.yan@cs.rutgers.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   55 ++++++++++++-------------------------------------
 1 file changed, 14 insertions(+), 41 deletions(-)

diff -puN mm/hugetlb.c~mm-hugetlb-integrate-giga-hugetlb-more-naturally-to-the-allocation-path mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-integrate-giga-hugetlb-more-naturally-to-the-allocation-path
+++ a/mm/hugetlb.c
@@ -1106,7 +1106,8 @@ static bool zone_spans_last_pfn(const st
 	return zone_spans_pfn(zone, last_pfn);
 }
 
-static struct page *alloc_gigantic_page(int nid, struct hstate *h)
+static struct page *alloc_gigantic_page(struct hstate *h, gfp_t gfp_mask,
+		int nid, nodemask_t *nodemask)
 {
 	unsigned int order = huge_page_order(h);
 	unsigned long nr_pages = 1 << order;
@@ -1114,11 +1115,9 @@ static struct page *alloc_gigantic_page(
 	struct zonelist *zonelist;
 	struct zone *zone;
 	struct zoneref *z;
-	gfp_t gfp_mask;
 
-	gfp_mask = htlb_alloc_mask(h) | __GFP_THISNODE;
 	zonelist = node_zonelist(nid, gfp_mask);
-	for_each_zone_zonelist_nodemask(zone, z, zonelist, gfp_zone(gfp_mask), NULL) {
+	for_each_zone_zonelist_nodemask(zone, z, zonelist, gfp_zone(gfp_mask), nodemask) {
 		spin_lock_irqsave(&zone->lock, flags);
 
 		pfn = ALIGN(zone->zone_start_pfn, nr_pages);
@@ -1149,42 +1148,13 @@ static struct page *alloc_gigantic_page(
 static void prep_new_huge_page(struct hstate *h, struct page *page, int nid);
 static void prep_compound_gigantic_page(struct page *page, unsigned int order);
 
-static struct page *alloc_fresh_gigantic_page_node(struct hstate *h, int nid)
-{
-	struct page *page;
-
-	page = alloc_gigantic_page(nid, h);
-	if (page) {
-		prep_compound_gigantic_page(page, huge_page_order(h));
-		prep_new_huge_page(h, page, nid);
-		put_page(page); /* free it into the hugepage allocator */
-	}
-
-	return page;
-}
-
-static int alloc_fresh_gigantic_page(struct hstate *h,
-				nodemask_t *nodes_allowed)
-{
-	struct page *page = NULL;
-	int nr_nodes, node;
-
-	for_each_node_mask_to_alloc(h, nr_nodes, node, nodes_allowed) {
-		page = alloc_fresh_gigantic_page_node(h, node);
-		if (page)
-			return 1;
-	}
-
-	return 0;
-}
-
 #else /* !CONFIG_ARCH_HAS_GIGANTIC_PAGE */
 static inline bool gigantic_page_supported(void) { return false; }
+static struct page *alloc_gigantic_page(struct hstate *h, gfp_t gfp_mask,
+		int nid, nodemask_t *nodemask) { return NULL; }
 static inline void free_gigantic_page(struct page *page, unsigned int order) { }
 static inline void destroy_compound_gigantic_page(struct page *page,
 						unsigned int order) { }
-static inline int alloc_fresh_gigantic_page(struct hstate *h,
-					nodemask_t *nodes_allowed) { return 0; }
 #endif
 
 static void update_and_free_page(struct hstate *h, struct page *page)
@@ -1410,8 +1380,12 @@ static int alloc_fresh_huge_page(struct
 	gfp_t gfp_mask = htlb_alloc_mask(h) | __GFP_THISNODE;
 
 	for_each_node_mask_to_alloc(h, nr_nodes, node, nodes_allowed) {
-		page = __hugetlb_alloc_buddy_huge_page(h, gfp_mask,
-				node, nodes_allowed);
+		if (hstate_is_gigantic(h))
+			page = alloc_gigantic_page(h, gfp_mask,
+					node, nodes_allowed);
+		else
+			page = __hugetlb_alloc_buddy_huge_page(h, gfp_mask,
+					node, nodes_allowed);
 		if (page)
 			break;
 
@@ -1420,6 +1394,8 @@ static int alloc_fresh_huge_page(struct
 	if (!page)
 		return 0;
 
+	if (hstate_is_gigantic(h))
+		prep_compound_gigantic_page(page, huge_page_order(h));
 	prep_new_huge_page(h, page, page_to_nid(page));
 	put_page(page); /* free it into the hugepage allocator */
 
@@ -2307,10 +2283,7 @@ static unsigned long set_max_huge_pages(
 		/* yield cpu to avoid soft lockup */
 		cond_resched();
 
-		if (hstate_is_gigantic(h))
-			ret = alloc_fresh_gigantic_page(h, nodes_allowed);
-		else
-			ret = alloc_fresh_huge_page(h, nodes_allowed);
+		ret = alloc_fresh_huge_page(h, nodes_allowed);
 		spin_lock(&hugetlb_lock);
 		if (!ret)
 			goto out;
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-oom-docs-describe-the-cgroup-aware-oom-killer-fix-2.patch
mm-introduce-map_fixed_safe.patch
fs-elf-drop-map_fixed-usage-from-elf_map.patch
fs-elf-drop-map_fixed-usage-from-elf_map-fix-fix.patch
mm-numa-rework-do_pages_move.patch
mm-migrate-remove-reason-argument-from-new_page_t.patch
mm-migrate-remove-reason-argument-from-new_page_t-fix-3.patch
mm-unclutter-thp-migration.patch
net-netfilter-x_tablesc-remove-size-check.patch

