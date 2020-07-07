From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated]
 mm-hugetlb-make-hugetlb-migration-callback-cma-aware.patch removed from -mm
 tree
Date: Tue, 07 Jul 2020 12:47:23 -0700
Message-ID: <20200707194723.LydA0sl4J%akpm@linux-foundation.org>
References: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727791AbgGGTrY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Jul 2020 15:47:24 -0400
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: guro@fb.com, hch@infradead.org, iamjoonsoo.kim@lge.com, mgorman@techsingularity.net, mhocko@suse.com, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, vbabka@suse.cz


The patch titled
     Subject: mm/hugetlb: make hugetlb migration callback CMA aware
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-make-hugetlb-migration-callback-cma-aware.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/hugetlb: make hugetlb migration callback CMA aware

new_non_cma_page() in gup.c which try to allocate migration target page
requires to allocate the new page that is not on the CMA area. 
new_non_cma_page() implements it by removing __GFP_MOVABLE flag.  This way
works well for THP page or normal page but not for hugetlb page.

hugetlb page allocation process consists of two steps.  First is dequeing
from the pool.  Second is, if there is no available page on the queue,
allocating from the page allocator.

new_non_cma_page() can control allocation from the page allocator by
specifying correct gfp flag.  However, dequeing cannot be controlled until
now, so, new_non_cma_page() skips dequeing completely.  It is a suboptimal
since new_non_cma_page() cannot utilize hugetlb pages on the queue so this
patch tries to fix this situation.

This patch makes the deque function on hugetlb CMA aware and skip CMA
pages if newly added skip_cma argument is passed as true.

Link: http://lkml.kernel.org/r/1592892828-1934-5-git-send-email-iamjoonsoo.kim@lge.com
Acked-by: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    6 ++----
 mm/gup.c                |    3 ++-
 mm/hugetlb.c            |   31 ++++++++++++++++++++++---------
 mm/mempolicy.c          |    2 +-
 mm/migrate.c            |    2 +-
 5 files changed, 28 insertions(+), 16 deletions(-)

--- a/include/linux/hugetlb.h~mm-hugetlb-make-hugetlb-migration-callback-cma-aware
+++ a/include/linux/hugetlb.h
@@ -505,11 +505,9 @@ struct huge_bootmem_page {
 struct page *alloc_huge_page(struct vm_area_struct *vma,
 				unsigned long addr, int avoid_reserve);
 struct page *alloc_huge_page_nodemask(struct hstate *h, int preferred_nid,
-				nodemask_t *nmask, gfp_t gfp_mask);
+				nodemask_t *nmask, gfp_t gfp_mask, bool skip_cma);
 struct page *alloc_huge_page_vma(struct hstate *h, struct vm_area_struct *vma,
 				unsigned long address);
-struct page *alloc_migrate_huge_page(struct hstate *h, gfp_t gfp_mask,
-				     int nid, nodemask_t *nmask);
 int huge_add_to_page_cache(struct page *page, struct address_space *mapping,
 			pgoff_t idx);
 
@@ -760,7 +758,7 @@ static inline struct page *alloc_huge_pa
 
 static inline struct page *
 alloc_huge_page_nodemask(struct hstate *h, int preferred_nid,
-			nodemask_t *nmask, gfp_t gfp_mask)
+			nodemask_t *nmask, gfp_t gfp_mask, bool skip_cma)
 {
 	return NULL;
 }
--- a/mm/gup.c~mm-hugetlb-make-hugetlb-migration-callback-cma-aware
+++ a/mm/gup.c
@@ -1630,11 +1630,12 @@ static struct page *new_non_cma_page(str
 #ifdef CONFIG_HUGETLB_PAGE
 	if (PageHuge(page)) {
 		struct hstate *h = page_hstate(page);
+
 		/*
 		 * We don't want to dequeue from the pool because pool pages will
 		 * mostly be from the CMA region.
 		 */
-		return alloc_migrate_huge_page(h, gfp_mask, nid, NULL);
+		return alloc_huge_page_nodemask(h, nid, NULL, gfp_mask, true);
 	}
 #endif
 	if (PageTransHuge(page)) {
--- a/mm/hugetlb.c~mm-hugetlb-make-hugetlb-migration-callback-cma-aware
+++ a/mm/hugetlb.c
@@ -1034,13 +1034,18 @@ static void enqueue_huge_page(struct hst
 	h->free_huge_pages_node[nid]++;
 }
 
-static struct page *dequeue_huge_page_node_exact(struct hstate *h, int nid)
+static struct page *dequeue_huge_page_node_exact(struct hstate *h, int nid, bool skip_cma)
 {
 	struct page *page;
 
-	list_for_each_entry(page, &h->hugepage_freelists[nid], lru)
+	list_for_each_entry(page, &h->hugepage_freelists[nid], lru) {
+		if (skip_cma && is_migrate_cma_page(page))
+			continue;
+
 		if (!PageHWPoison(page))
 			break;
+	}
+
 	/*
 	 * if 'non-isolated free hugepage' not found on the list,
 	 * the allocation fails.
@@ -1055,7 +1060,7 @@ static struct page *dequeue_huge_page_no
 }
 
 static struct page *dequeue_huge_page_nodemask(struct hstate *h, gfp_t gfp_mask, int nid,
-		nodemask_t *nmask)
+		nodemask_t *nmask, bool skip_cma)
 {
 	unsigned int cpuset_mems_cookie;
 	struct zonelist *zonelist;
@@ -1080,7 +1085,7 @@ retry_cpuset:
 			continue;
 		node = zone_to_nid(zone);
 
-		page = dequeue_huge_page_node_exact(h, node);
+		page = dequeue_huge_page_node_exact(h, node, skip_cma);
 		if (page)
 			return page;
 	}
@@ -1125,7 +1130,7 @@ static struct page *dequeue_huge_page_vm
 
 	gfp_mask = htlb_alloc_mask(h);
 	nid = huge_node(vma, address, gfp_mask, &mpol, &nodemask);
-	page = dequeue_huge_page_nodemask(h, gfp_mask, nid, nodemask);
+	page = dequeue_huge_page_nodemask(h, gfp_mask, nid, nodemask, false);
 	if (page && !avoid_reserve && vma_has_reserves(vma, chg)) {
 		SetPagePrivate(page);
 		h->resv_huge_pages--;
@@ -1938,7 +1943,7 @@ out_unlock:
 	return page;
 }
 
-struct page *alloc_migrate_huge_page(struct hstate *h, gfp_t gfp_mask,
+static struct page *alloc_migrate_huge_page(struct hstate *h, gfp_t gfp_mask,
 				     int nid, nodemask_t *nmask)
 {
 	struct page *page;
@@ -1981,7 +1986,7 @@ struct page *alloc_buddy_huge_page_with_
 
 /* page migration callback function */
 struct page *alloc_huge_page_nodemask(struct hstate *h, int preferred_nid,
-		nodemask_t *nmask, gfp_t gfp_mask)
+		nodemask_t *nmask, gfp_t gfp_mask, bool skip_cma)
 {
 	gfp_mask |= htlb_alloc_mask(h);
 
@@ -1989,7 +1994,8 @@ struct page *alloc_huge_page_nodemask(st
 	if (h->free_huge_pages - h->resv_huge_pages > 0) {
 		struct page *page;
 
-		page = dequeue_huge_page_nodemask(h, gfp_mask, preferred_nid, nmask);
+		page = dequeue_huge_page_nodemask(h, gfp_mask,
+					preferred_nid, nmask, skip_cma);
 		if (page) {
 			spin_unlock(&hugetlb_lock);
 			return page;
@@ -1997,6 +2003,13 @@ struct page *alloc_huge_page_nodemask(st
 	}
 	spin_unlock(&hugetlb_lock);
 
+	/*
+	 * To skip the memory on CMA area, we need to clear __GFP_MOVABLE.
+	 * Clearing __GFP_MOVABLE at the top of this function would also skip
+	 * the proper allocation candidates for dequeue so clearing it here.
+	 */
+	if (skip_cma)
+		gfp_mask &= ~__GFP_MOVABLE;
 	return alloc_migrate_huge_page(h, gfp_mask, preferred_nid, nmask);
 }
 
@@ -2012,7 +2025,7 @@ struct page *alloc_huge_page_vma(struct
 
 	gfp_mask = htlb_alloc_mask(h);
 	node = huge_node(vma, address, gfp_mask, &mpol, &nodemask);
-	page = alloc_huge_page_nodemask(h, node, nodemask, 0);
+	page = alloc_huge_page_nodemask(h, node, nodemask, 0, false);
 	mpol_cond_put(mpol);
 
 	return page;
--- a/mm/mempolicy.c~mm-hugetlb-make-hugetlb-migration-callback-cma-aware
+++ a/mm/mempolicy.c
@@ -1071,7 +1071,7 @@ struct page *alloc_new_node_page(struct
 	if (PageHuge(page)) {
 		return alloc_huge_page_nodemask(
 			page_hstate(compound_head(page)), node,
-			NULL, __GFP_THISNODE);
+			NULL, __GFP_THISNODE, false);
 	} else if (PageTransHuge(page)) {
 		struct page *thp;
 
--- a/mm/migrate.c~mm-hugetlb-make-hugetlb-migration-callback-cma-aware
+++ a/mm/migrate.c
@@ -1523,7 +1523,7 @@ struct page *new_page_nodemask(struct pa
 	if (PageHuge(page)) {
 		return alloc_huge_page_nodemask(
 				page_hstate(compound_head(page)),
-				preferred_nid, nodemask, 0);
+				preferred_nid, nodemask, 0, false);
 	}
 
 	if (PageTransHuge(page)) {
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

mm-migrate-make-a-standard-migration-target-allocation-function.patch
mm-gup-use-a-standard-migration-target-allocation-callback.patch
mm-mempolicy-use-a-standard-migration-target-allocation-callback.patch
mm-page_alloc-remove-a-wrapper-for-alloc_migration_target.patch
