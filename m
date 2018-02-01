From: akpm@linux-foundation.org
Subject: [merged]
 mm-hugetlb-further-simplify-hugetlb-allocation-api.patch removed from -mm
 tree
Date: Thu, 01 Feb 2018 11:34:47 -0800
Message-ID: <20180201193447.XQEI6H1JZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33278 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754673AbeBATe4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Feb 2018 14:34:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ar@linux.vnet.ibm.com, dan.carpenter@oracle.com, khandual@linux.vnet.ibm.com, kirill.shutemov@linux.intel.com, mhocko@suse.com, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, vbabka@suse.cz, zi.yan@cs.rutgers.edu


The patch titled
     Subject: mm, hugetlb: further simplify hugetlb allocation API
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-further-simplify-hugetlb-allocation-api.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm, hugetlb: further simplify hugetlb allocation API

Hugetlb allocator has several layer of allocation functions depending and
the purpose of the allocation.  There are two allocators depending on
whether the page can be allocated from the page allocator or we need a
contiguous allocator.  This is currently opencoded in
alloc_fresh_huge_page which is the only path that might allocate giga
pages which require the later allocator.  Create alloc_fresh_huge_page
which hides this implementation detail and use it in all callers which
hardcoded the buddy allocator path (__hugetlb_alloc_buddy_huge_page). 
This shouldn't introduce any funtional change because both migration and
surplus allocators exlude giga pages explicitly.

While we are at it let's do some renaming.  The current scheme is not
consistent and overly painfull to read and understand.  Get rid of prefix
underscores from most functions.  There is no real reason to make names
longer.

* alloc_fresh_huge_page is the new layer to abstract underlying
  allocator
* __hugetlb_alloc_buddy_huge_page becomes shorter and neater
  alloc_buddy_huge_page.
* Former alloc_fresh_huge_page becomes alloc_pool_huge_page because we put
  the new page directly to the pool
* alloc_surplus_huge_page can drop the opencoded prep_new_huge_page code
  as it uses alloc_fresh_huge_page now
* others lose their excessive prefix underscores to make names shorter

[dan.carpenter@oracle.com: fix double unlock bug in alloc_surplus_huge_page()]
  Link: http://lkml.kernel.org/r/20180109200559.g3iz5kvbdrz7yydp@mwanda
Link: http://lkml.kernel.org/r/20180103093213.26329-6-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andrea Reale <ar@linux.vnet.ibm.com>
Cc: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <zi.yan@cs.rutgers.edu>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   80 ++++++++++++++++++++++++++-----------------------
 1 file changed, 43 insertions(+), 37 deletions(-)

diff -puN mm/hugetlb.c~mm-hugetlb-further-simplify-hugetlb-allocation-api mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-further-simplify-hugetlb-allocation-api
+++ a/mm/hugetlb.c
@@ -1378,7 +1378,7 @@ pgoff_t __basepage_index(struct page *pa
 	return (index << compound_order(page_head)) + compound_idx;
 }
 
-static struct page *__hugetlb_alloc_buddy_huge_page(struct hstate *h,
+static struct page *alloc_buddy_huge_page(struct hstate *h,
 		gfp_t gfp_mask, int nid, nodemask_t *nmask)
 {
 	int order = huge_page_order(h);
@@ -1397,33 +1397,48 @@ static struct page *__hugetlb_alloc_budd
 }
 
 /*
+ * Common helper to allocate a fresh hugetlb page. All specific allocators
+ * should use this function to get new hugetlb pages
+ */
+static struct page *alloc_fresh_huge_page(struct hstate *h,
+		gfp_t gfp_mask, int nid, nodemask_t *nmask)
+{
+	struct page *page;
+
+	if (hstate_is_gigantic(h))
+		page = alloc_gigantic_page(h, gfp_mask, nid, nmask);
+	else
+		page = alloc_buddy_huge_page(h, gfp_mask,
+				nid, nmask);
+	if (!page)
+		return NULL;
+
+	if (hstate_is_gigantic(h))
+		prep_compound_gigantic_page(page, huge_page_order(h));
+	prep_new_huge_page(h, page, page_to_nid(page));
+
+	return page;
+}
+
+/*
  * Allocates a fresh page to the hugetlb allocator pool in the node interleaved
  * manner.
  */
-static int alloc_fresh_huge_page(struct hstate *h, nodemask_t *nodes_allowed)
+static int alloc_pool_huge_page(struct hstate *h, nodemask_t *nodes_allowed)
 {
 	struct page *page;
 	int nr_nodes, node;
 	gfp_t gfp_mask = htlb_alloc_mask(h) | __GFP_THISNODE;
 
 	for_each_node_mask_to_alloc(h, nr_nodes, node, nodes_allowed) {
-		if (hstate_is_gigantic(h))
-			page = alloc_gigantic_page(h, gfp_mask,
-					node, nodes_allowed);
-		else
-			page = __hugetlb_alloc_buddy_huge_page(h, gfp_mask,
-					node, nodes_allowed);
+		page = alloc_fresh_huge_page(h, gfp_mask, node, nodes_allowed);
 		if (page)
 			break;
-
 	}
 
 	if (!page)
 		return 0;
 
-	if (hstate_is_gigantic(h))
-		prep_compound_gigantic_page(page, huge_page_order(h));
-	prep_new_huge_page(h, page, page_to_nid(page));
 	put_page(page); /* free it into the hugepage allocator */
 
 	return 1;
@@ -1537,7 +1552,7 @@ int dissolve_free_huge_pages(unsigned lo
 /*
  * Allocates a fresh surplus page from the page allocator.
  */
-static struct page *__alloc_surplus_huge_page(struct hstate *h, gfp_t gfp_mask,
+static struct page *alloc_surplus_huge_page(struct hstate *h, gfp_t gfp_mask,
 		int nid, nodemask_t *nmask)
 {
 	struct page *page = NULL;
@@ -1550,9 +1565,9 @@ static struct page *__alloc_surplus_huge
 		goto out_unlock;
 	spin_unlock(&hugetlb_lock);
 
-	page = __hugetlb_alloc_buddy_huge_page(h, gfp_mask, nid, nmask);
+	page = alloc_fresh_huge_page(h, gfp_mask, nid, nmask);
 	if (!page)
-		goto out_unlock;
+		return NULL;
 
 	spin_lock(&hugetlb_lock);
 	/*
@@ -1567,16 +1582,8 @@ static struct page *__alloc_surplus_huge
 		put_page(page);
 		page = NULL;
 	} else {
-		int r_nid;
-
 		h->surplus_huge_pages++;
-		h->nr_huge_pages++;
-		INIT_LIST_HEAD(&page->lru);
-		r_nid = page_to_nid(page);
-		set_compound_page_dtor(page, HUGETLB_PAGE_DTOR);
-		set_hugetlb_cgroup(page, NULL);
-		h->nr_huge_pages_node[r_nid]++;
-		h->surplus_huge_pages_node[r_nid]++;
+		h->nr_huge_pages_node[page_to_nid(page)]++;
 	}
 
 out_unlock:
@@ -1585,7 +1592,7 @@ out_unlock:
 	return page;
 }
 
-static struct page *__alloc_migrate_huge_page(struct hstate *h, gfp_t gfp_mask,
+static struct page *alloc_migrate_huge_page(struct hstate *h, gfp_t gfp_mask,
 		int nid, nodemask_t *nmask)
 {
 	struct page *page;
@@ -1593,7 +1600,7 @@ static struct page *__alloc_migrate_huge
 	if (hstate_is_gigantic(h))
 		return NULL;
 
-	page = __hugetlb_alloc_buddy_huge_page(h, gfp_mask, nid, nmask);
+	page = alloc_fresh_huge_page(h, gfp_mask, nid, nmask);
 	if (!page)
 		return NULL;
 
@@ -1601,7 +1608,6 @@ static struct page *__alloc_migrate_huge
 	 * We do not account these pages as surplus because they are only
 	 * temporary and will be released properly on the last reference
 	 */
-	prep_new_huge_page(h, page, page_to_nid(page));
 	SetPageHugeTemporary(page);
 
 	return page;
@@ -1611,7 +1617,7 @@ static struct page *__alloc_migrate_huge
  * Use the VMA's mpolicy to allocate a huge page from the buddy.
  */
 static
-struct page *__alloc_buddy_huge_page_with_mpol(struct hstate *h,
+struct page *alloc_buddy_huge_page_with_mpol(struct hstate *h,
 		struct vm_area_struct *vma, unsigned long addr)
 {
 	struct page *page;
@@ -1621,7 +1627,7 @@ struct page *__alloc_buddy_huge_page_wit
 	nodemask_t *nodemask;
 
 	nid = huge_node(vma, addr, gfp_mask, &mpol, &nodemask);
-	page = __alloc_surplus_huge_page(h, gfp_mask, nid, nodemask);
+	page = alloc_surplus_huge_page(h, gfp_mask, nid, nodemask);
 	mpol_cond_put(mpol);
 
 	return page;
@@ -1642,7 +1648,7 @@ struct page *alloc_huge_page_node(struct
 	spin_unlock(&hugetlb_lock);
 
 	if (!page)
-		page = __alloc_migrate_huge_page(h, gfp_mask, nid, NULL);
+		page = alloc_migrate_huge_page(h, gfp_mask, nid, NULL);
 
 	return page;
 }
@@ -1665,7 +1671,7 @@ struct page *alloc_huge_page_nodemask(st
 	}
 	spin_unlock(&hugetlb_lock);
 
-	return __alloc_migrate_huge_page(h, gfp_mask, preferred_nid, nmask);
+	return alloc_migrate_huge_page(h, gfp_mask, preferred_nid, nmask);
 }
 
 /*
@@ -1693,7 +1699,7 @@ static int gather_surplus_pages(struct h
 retry:
 	spin_unlock(&hugetlb_lock);
 	for (i = 0; i < needed; i++) {
-		page = __alloc_surplus_huge_page(h, htlb_alloc_mask(h),
+		page = alloc_surplus_huge_page(h, htlb_alloc_mask(h),
 				NUMA_NO_NODE, NULL);
 		if (!page) {
 			alloc_ok = false;
@@ -2030,7 +2036,7 @@ struct page *alloc_huge_page(struct vm_a
 	page = dequeue_huge_page_vma(h, vma, addr, avoid_reserve, gbl_chg);
 	if (!page) {
 		spin_unlock(&hugetlb_lock);
-		page = __alloc_buddy_huge_page_with_mpol(h, vma, addr);
+		page = alloc_buddy_huge_page_with_mpol(h, vma, addr);
 		if (!page)
 			goto out_uncharge_cgroup;
 		if (!avoid_reserve && vma_has_reserves(vma, gbl_chg)) {
@@ -2170,7 +2176,7 @@ static void __init hugetlb_hstate_alloc_
 		if (hstate_is_gigantic(h)) {
 			if (!alloc_bootmem_huge_page(h))
 				break;
-		} else if (!alloc_fresh_huge_page(h,
+		} else if (!alloc_pool_huge_page(h,
 					 &node_states[N_MEMORY]))
 			break;
 		cond_resched();
@@ -2290,7 +2296,7 @@ static unsigned long set_max_huge_pages(
 	 * First take pages out of surplus state.  Then make up the
 	 * remaining difference by allocating fresh huge pages.
 	 *
-	 * We might race with __alloc_surplus_huge_page() here and be unable
+	 * We might race with alloc_surplus_huge_page() here and be unable
 	 * to convert a surplus huge page to a normal huge page. That is
 	 * not critical, though, it just means the overall size of the
 	 * pool might be one hugepage larger than it needs to be, but
@@ -2313,7 +2319,7 @@ static unsigned long set_max_huge_pages(
 		/* yield cpu to avoid soft lockup */
 		cond_resched();
 
-		ret = alloc_fresh_huge_page(h, nodes_allowed);
+		ret = alloc_pool_huge_page(h, nodes_allowed);
 		spin_lock(&hugetlb_lock);
 		if (!ret)
 			goto out;
@@ -2333,7 +2339,7 @@ static unsigned long set_max_huge_pages(
 	 * By placing pages into the surplus state independent of the
 	 * overcommit value, we are allowing the surplus pool size to
 	 * exceed overcommit. There are few sane options here. Since
-	 * __alloc_surplus_huge_page() is checking the global counter,
+	 * alloc_surplus_huge_page() is checking the global counter,
 	 * though, we'll note that we're not allowed to exceed surplus
 	 * and won't grow the pool anywhere else. Not until one of the
 	 * sysctls are changed, or the surplus pages go out of use.
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

