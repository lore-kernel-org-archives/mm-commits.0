From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated]
 mm-hugetlb-unify-migration-callbacks.patch removed from -mm tree
Date: Tue, 07 Jul 2020 12:47:20 -0700
Message-ID: <20200707194720.Wv20cf-XI%akpm@linux-foundation.org>
References: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727791AbgGGTrV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Jul 2020 15:47:21 -0400
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: guro@fb.com, hch@infradead.org, iamjoonsoo.kim@lge.com, mgorman@techsingularity.net, mhocko@suse.com, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, vbabka@suse.cz


The patch titled
     Subject: mm/hugetlb: unify migration callbacks
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-unify-migration-callbacks.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/hugetlb: unify migration callbacks

There is no difference between two migration callback functions,
alloc_huge_page_node() and alloc_huge_page_nodemask(), except
__GFP_THISNODE handling.

This patch adds an argument, gfp_mask, on alloc_huge_page_nodemask() and
replaces the callsite for alloc_huge_page_node() with the call to
alloc_huge_page_nodemask(..., __GFP_THISNODE).

It's safe to remove a node id check in alloc_huge_page_node() since
there is no caller passing NUMA_NO_NODE as a node id.

Link: http://lkml.kernel.org/r/1592892828-1934-4-git-send-email-iamjoonsoo.kim@lge.com
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |   11 +++--------
 mm/hugetlb.c            |   26 +++-----------------------
 mm/mempolicy.c          |    9 +++++----
 mm/migrate.c            |    5 +++--
 4 files changed, 14 insertions(+), 37 deletions(-)

--- a/include/linux/hugetlb.h~mm-hugetlb-unify-migration-callbacks
+++ a/include/linux/hugetlb.h
@@ -504,9 +504,8 @@ struct huge_bootmem_page {
 
 struct page *alloc_huge_page(struct vm_area_struct *vma,
 				unsigned long addr, int avoid_reserve);
-struct page *alloc_huge_page_node(struct hstate *h, int nid);
 struct page *alloc_huge_page_nodemask(struct hstate *h, int preferred_nid,
-				nodemask_t *nmask);
+				nodemask_t *nmask, gfp_t gfp_mask);
 struct page *alloc_huge_page_vma(struct hstate *h, struct vm_area_struct *vma,
 				unsigned long address);
 struct page *alloc_migrate_huge_page(struct hstate *h, gfp_t gfp_mask,
@@ -759,13 +758,9 @@ static inline struct page *alloc_huge_pa
 	return NULL;
 }
 
-static inline struct page *alloc_huge_page_node(struct hstate *h, int nid)
-{
-	return NULL;
-}
-
 static inline struct page *
-alloc_huge_page_nodemask(struct hstate *h, int preferred_nid, nodemask_t *nmask)
+alloc_huge_page_nodemask(struct hstate *h, int preferred_nid,
+			nodemask_t *nmask, gfp_t gfp_mask)
 {
 	return NULL;
 }
--- a/mm/hugetlb.c~mm-hugetlb-unify-migration-callbacks
+++ a/mm/hugetlb.c
@@ -1980,30 +1980,10 @@ struct page *alloc_buddy_huge_page_with_
 }
 
 /* page migration callback function */
-struct page *alloc_huge_page_node(struct hstate *h, int nid)
-{
-	gfp_t gfp_mask = htlb_alloc_mask(h);
-	struct page *page = NULL;
-
-	if (nid != NUMA_NO_NODE)
-		gfp_mask |= __GFP_THISNODE;
-
-	spin_lock(&hugetlb_lock);
-	if (h->free_huge_pages - h->resv_huge_pages > 0)
-		page = dequeue_huge_page_nodemask(h, gfp_mask, nid, NULL);
-	spin_unlock(&hugetlb_lock);
-
-	if (!page)
-		page = alloc_migrate_huge_page(h, gfp_mask, nid, NULL);
-
-	return page;
-}
-
-/* page migration callback function */
 struct page *alloc_huge_page_nodemask(struct hstate *h, int preferred_nid,
-		nodemask_t *nmask)
+		nodemask_t *nmask, gfp_t gfp_mask)
 {
-	gfp_t gfp_mask = htlb_alloc_mask(h);
+	gfp_mask |= htlb_alloc_mask(h);
 
 	spin_lock(&hugetlb_lock);
 	if (h->free_huge_pages - h->resv_huge_pages > 0) {
@@ -2032,7 +2012,7 @@ struct page *alloc_huge_page_vma(struct
 
 	gfp_mask = htlb_alloc_mask(h);
 	node = huge_node(vma, address, gfp_mask, &mpol, &nodemask);
-	page = alloc_huge_page_nodemask(h, node, nodemask);
+	page = alloc_huge_page_nodemask(h, node, nodemask, 0);
 	mpol_cond_put(mpol);
 
 	return page;
--- a/mm/mempolicy.c~mm-hugetlb-unify-migration-callbacks
+++ a/mm/mempolicy.c
@@ -1068,10 +1068,11 @@ static int migrate_page_add(struct page
 /* page allocation callback for NUMA node migration */
 struct page *alloc_new_node_page(struct page *page, unsigned long node)
 {
-	if (PageHuge(page))
-		return alloc_huge_page_node(page_hstate(compound_head(page)),
-					node);
-	else if (PageTransHuge(page)) {
+	if (PageHuge(page)) {
+		return alloc_huge_page_nodemask(
+			page_hstate(compound_head(page)), node,
+			NULL, __GFP_THISNODE);
+	} else if (PageTransHuge(page)) {
 		struct page *thp;
 
 		thp = alloc_pages_node(node,
--- a/mm/migrate.c~mm-hugetlb-unify-migration-callbacks
+++ a/mm/migrate.c
@@ -1520,10 +1520,11 @@ struct page *new_page_nodemask(struct pa
 	unsigned int order = 0;
 	struct page *new_page = NULL;
 
-	if (PageHuge(page))
+	if (PageHuge(page)) {
 		return alloc_huge_page_nodemask(
 				page_hstate(compound_head(page)),
-				preferred_nid, nodemask);
+				preferred_nid, nodemask, 0);
+	}
 
 	if (PageTransHuge(page)) {
 		gfp_mask |= GFP_TRANSHUGE;
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

mm-hugetlb-make-hugetlb-migration-callback-cma-aware.patch
mm-migrate-make-a-standard-migration-target-allocation-function.patch
mm-gup-use-a-standard-migration-target-allocation-callback.patch
mm-mempolicy-use-a-standard-migration-target-allocation-callback.patch
mm-page_alloc-remove-a-wrapper-for-alloc_migration_target.patch
