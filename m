From: akpm@linux-foundation.org
Subject: [merged]
 mm-hugetlb-unify-core-page-allocation-accounting-and-initialization.patch
 removed from -mm tree
Date: Thu, 01 Feb 2018 11:34:35 -0800
Message-ID: <20180201193435.afa3DQnQQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:32856 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754605AbeBATej (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Feb 2018 14:34:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ar@linux.vnet.ibm.com, khandual@linux.vnet.ibm.com, kirill.shutemov@linux.intel.com, mhocko@suse.com, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, vbabka@suse.cz, zi.yan@cs.rutgers.edu


The patch titled
     Subject: mm, hugetlb: unify core page allocation accounting and initialization
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-unify-core-page-allocation-accounting-and-initialization.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm, hugetlb: unify core page allocation accounting and initialization

Patch series "mm, hugetlb: allocation API and migration improvements"

Motivation:

this is a follow up for [3] for the allocation API and [4] for the hugetlb
migration.  It wasn't really easy to split those into two separate patch
series as they share some code.

My primary motivation to touch this code is to make the gigantic pages
migration working. The giga pages allocation code is just too fragile
and hacked into the hugetlb code now. This series tries to move giga
pages closer to the first class citizen. We are not there yet but having
5 patches is quite a lot already and it will already make the code much
easier to follow. I will come with other changes on top after this sees
some review.

The first two patches should be trivial to review.  The third patch
changes the way how we migrate huge pages.  Newly allocated pages are a
subject of the overcommit check and they participate surplus accounting
which is quite unfortunate as the changelog explains.  This patch doesn't
change anything wrt.  giga pages.

Patch #4 removes the surplus accounting hack from
__alloc_surplus_huge_page.  I hope I didn't miss anything there and a
deeper review is really due there.

Patch #5 finally unifies allocation paths and giga pages shouldn't be any
special anymore.  There is also some renaming going on as well.


This patch (of 6):

hugetlb allocator has two entry points to the page allocator
- alloc_fresh_huge_page_node
- __hugetlb_alloc_buddy_huge_page

The two differ very subtly in two aspects.  The first one doesn't care
about HTLB_BUDDY_* stats and it doesn't initialize the huge page. 
prep_new_huge_page is not used because it not only initializes hugetlb
specific stuff but because it also put_page and releases the page to the
hugetlb pool which is not what is required in some contexts.  This makes
things more complicated than necessary.

Simplify things by a) removing the page allocator entry point duplicity
and only keep __hugetlb_alloc_buddy_huge_page and b) make
prep_new_huge_page more reusable by removing the put_page which moves the
page to the allocator pool.  All current callers are updated to call
put_page explicitly.  Later patches will add new callers which won't need
it.

This patch shouldn't introduce any functional change.

Link: http://lkml.kernel.org/r/20180103093213.26329-2-mhocko@kernel.org
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

 mm/hugetlb.c |   61 +++++++++++++++++++++++--------------------------
 1 file changed, 29 insertions(+), 32 deletions(-)

diff -puN mm/hugetlb.c~mm-hugetlb-unify-core-page-allocation-accounting-and-initialization mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-unify-core-page-allocation-accounting-and-initialization
+++ a/mm/hugetlb.c
@@ -1157,6 +1157,7 @@ static struct page *alloc_fresh_gigantic
 	if (page) {
 		prep_compound_gigantic_page(page, huge_page_order(h));
 		prep_new_huge_page(h, page, nid);
+		put_page(page); /* free it into the hugepage allocator */
 	}
 
 	return page;
@@ -1304,7 +1305,6 @@ static void prep_new_huge_page(struct hs
 	h->nr_huge_pages++;
 	h->nr_huge_pages_node[nid]++;
 	spin_unlock(&hugetlb_lock);
-	put_page(page); /* free it into the hugepage allocator */
 }
 
 static void prep_compound_gigantic_page(struct page *page, unsigned int order)
@@ -1381,41 +1381,49 @@ pgoff_t __basepage_index(struct page *pa
 	return (index << compound_order(page_head)) + compound_idx;
 }
 
-static struct page *alloc_fresh_huge_page_node(struct hstate *h, int nid)
+static struct page *__hugetlb_alloc_buddy_huge_page(struct hstate *h,
+		gfp_t gfp_mask, int nid, nodemask_t *nmask)
 {
+	int order = huge_page_order(h);
 	struct page *page;
 
-	page = __alloc_pages_node(nid,
-		htlb_alloc_mask(h)|__GFP_COMP|__GFP_THISNODE|
-						__GFP_RETRY_MAYFAIL|__GFP_NOWARN,
-		huge_page_order(h));
-	if (page) {
-		prep_new_huge_page(h, page, nid);
-	}
+	gfp_mask |= __GFP_COMP|__GFP_RETRY_MAYFAIL|__GFP_NOWARN;
+	if (nid == NUMA_NO_NODE)
+		nid = numa_mem_id();
+	page = __alloc_pages_nodemask(gfp_mask, order, nid, nmask);
+	if (page)
+		__count_vm_event(HTLB_BUDDY_PGALLOC);
+	else
+		__count_vm_event(HTLB_BUDDY_PGALLOC_FAIL);
 
 	return page;
 }
 
+/*
+ * Allocates a fresh page to the hugetlb allocator pool in the node interleaved
+ * manner.
+ */
 static int alloc_fresh_huge_page(struct hstate *h, nodemask_t *nodes_allowed)
 {
 	struct page *page;
 	int nr_nodes, node;
-	int ret = 0;
+	gfp_t gfp_mask = htlb_alloc_mask(h) | __GFP_THISNODE;
 
 	for_each_node_mask_to_alloc(h, nr_nodes, node, nodes_allowed) {
-		page = alloc_fresh_huge_page_node(h, node);
-		if (page) {
-			ret = 1;
+		page = __hugetlb_alloc_buddy_huge_page(h, gfp_mask,
+				node, nodes_allowed);
+		if (page)
 			break;
-		}
+
 	}
 
-	if (ret)
-		count_vm_event(HTLB_BUDDY_PGALLOC);
-	else
-		count_vm_event(HTLB_BUDDY_PGALLOC_FAIL);
+	if (!page)
+		return 0;
 
-	return ret;
+	prep_new_huge_page(h, page, page_to_nid(page));
+	put_page(page); /* free it into the hugepage allocator */
+
+	return 1;
 }
 
 /*
@@ -1523,17 +1531,6 @@ int dissolve_free_huge_pages(unsigned lo
 	return rc;
 }
 
-static struct page *__hugetlb_alloc_buddy_huge_page(struct hstate *h,
-		gfp_t gfp_mask, int nid, nodemask_t *nmask)
-{
-	int order = huge_page_order(h);
-
-	gfp_mask |= __GFP_COMP|__GFP_RETRY_MAYFAIL|__GFP_NOWARN;
-	if (nid == NUMA_NO_NODE)
-		nid = numa_mem_id();
-	return __alloc_pages_nodemask(gfp_mask, order, nid, nmask);
-}
-
 static struct page *__alloc_buddy_huge_page(struct hstate *h, gfp_t gfp_mask,
 		int nid, nodemask_t *nmask)
 {
@@ -1589,11 +1586,9 @@ static struct page *__alloc_buddy_huge_p
 		 */
 		h->nr_huge_pages_node[r_nid]++;
 		h->surplus_huge_pages_node[r_nid]++;
-		__count_vm_event(HTLB_BUDDY_PGALLOC);
 	} else {
 		h->nr_huge_pages--;
 		h->surplus_huge_pages--;
-		__count_vm_event(HTLB_BUDDY_PGALLOC_FAIL);
 	}
 	spin_unlock(&hugetlb_lock);
 
@@ -2148,6 +2143,8 @@ static void __init gather_bootmem_preall
 		prep_compound_huge_page(page, h->order);
 		WARN_ON(PageReserved(page));
 		prep_new_huge_page(h, page, page_to_nid(page));
+		put_page(page); /* free it into the hugepage allocator */
+
 		/*
 		 * If we had gigantic hugepages allocated at boot time, we need
 		 * to restore the 'stolen' pages to totalram_pages in order to
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

