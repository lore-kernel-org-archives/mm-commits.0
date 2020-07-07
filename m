From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated]
 mm-gup-use-a-standard-migration-target-allocation-callback.patch removed
 from -mm tree
Date: Tue, 07 Jul 2020 12:47:29 -0700
Message-ID: <20200707194729.aB4cll1Se%akpm@linux-foundation.org>
References: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:59140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727791AbgGGTra (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Jul 2020 15:47:30 -0400
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: guro@fb.com, hch@infradead.org, iamjoonsoo.kim@lge.com, mgorman@techsingularity.net, mhocko@suse.com, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, vbabka@suse.cz


The patch titled
     Subject: mm/gup: use a standard migration target allocation callback
has been removed from the -mm tree.  Its filename was
     mm-gup-use-a-standard-migration-target-allocation-callback.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/gup: use a standard migration target allocation callback

There is a well-defined migration target allocation callback.  It's mostly
similar with new_non_cma_page() except considering CMA pages.

This patch adds a CMA consideration to the standard migration target
allocation callback and use it on gup.c.

Link: http://lkml.kernel.org/r/1592892828-1934-7-git-send-email-iamjoonsoo.kim@lge.com
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c      |   57 ++++++------------------------------------------
 mm/internal.h |    1 
 mm/migrate.c  |    4 ++-
 3 files changed, 12 insertions(+), 50 deletions(-)

--- a/mm/gup.c~mm-gup-use-a-standard-migration-target-allocation-callback
+++ a/mm/gup.c
@@ -1608,56 +1608,15 @@ static bool check_dax_vmas(struct vm_are
 }
 
 #ifdef CONFIG_CMA
-static struct page *new_non_cma_page(struct page *page, unsigned long private)
+static struct page *alloc_migration_target_non_cma(struct page *page, unsigned long private)
 {
-	/*
-	 * We want to make sure we allocate the new page from the same node
-	 * as the source page.
-	 */
-	int nid = page_to_nid(page);
-	/*
-	 * Trying to allocate a page for migration. Ignore allocation
-	 * failure warnings. We don't force __GFP_THISNODE here because
-	 * this node here is the node where we have CMA reservation and
-	 * in some case these nodes will have really less non movable
-	 * allocation memory.
-	 */
-	gfp_t gfp_mask = GFP_USER | __GFP_NOWARN;
-
-	if (PageHighMem(page))
-		gfp_mask |= __GFP_HIGHMEM;
-
-#ifdef CONFIG_HUGETLB_PAGE
-	if (PageHuge(page)) {
-		struct hstate *h = page_hstate(page);
+	struct migration_target_control mtc = {
+		.nid = page_to_nid(page),
+		.gfp_mask = GFP_USER | __GFP_NOWARN,
+		.skip_cma = true,
+	};
 
-		/*
-		 * We don't want to dequeue from the pool because pool pages will
-		 * mostly be from the CMA region.
-		 */
-		return alloc_huge_page_nodemask(h, nid, NULL, gfp_mask, true);
-	}
-#endif
-	if (PageTransHuge(page)) {
-		struct page *thp;
-		/*
-		 * ignore allocation failure warnings
-		 */
-		gfp_t thp_gfpmask = GFP_TRANSHUGE | __GFP_NOWARN;
-
-		/*
-		 * Remove the movable mask so that we don't allocate from
-		 * CMA area again.
-		 */
-		thp_gfpmask &= ~__GFP_MOVABLE;
-		thp = __alloc_pages_node(nid, thp_gfpmask, HPAGE_PMD_ORDER);
-		if (!thp)
-			return NULL;
-		prep_transhuge_page(thp);
-		return thp;
-	}
-
-	return __alloc_pages_node(nid, gfp_mask, 0);
+	return alloc_migration_target(page, (unsigned long)&mtc);
 }
 
 static long check_and_migrate_cma_pages(struct task_struct *tsk,
@@ -1719,7 +1678,7 @@ check_again:
 		for (i = 0; i < nr_pages; i++)
 			put_page(pages[i]);
 
-		if (migrate_pages(&cma_page_list, new_non_cma_page,
+		if (migrate_pages(&cma_page_list, alloc_migration_target_non_cma,
 				  NULL, 0, MIGRATE_SYNC, MR_CONTIG_RANGE)) {
 			/*
 			 * some of the pages failed migration. Do get_user_pages
--- a/mm/internal.h~mm-gup-use-a-standard-migration-target-allocation-callback
+++ a/mm/internal.h
@@ -619,6 +619,7 @@ struct migration_target_control {
 	int nid;		/* preferred node id */
 	nodemask_t *nmask;
 	gfp_t gfp_mask;
+	bool skip_cma;
 };
 
 #endif	/* __MM_INTERNAL_H */
--- a/mm/migrate.c~mm-gup-use-a-standard-migration-target-allocation-callback
+++ a/mm/migrate.c
@@ -1527,7 +1527,7 @@ struct page *alloc_migration_target(stru
 	if (PageHuge(page)) {
 		return alloc_huge_page_nodemask(
 				page_hstate(compound_head(page)), mtc->nid,
-				mtc->nmask, gfp_mask, false);
+				mtc->nmask, gfp_mask, mtc->skip_cma);
 	}
 
 	if (PageTransHuge(page)) {
@@ -1538,6 +1538,8 @@ struct page *alloc_migration_target(stru
 	zidx = zone_idx(page_zone(page));
 	if (is_highmem_idx(zidx) || zidx == ZONE_MOVABLE)
 		gfp_mask |= __GFP_HIGHMEM;
+	if (mtc->skip_cma)
+		gfp_mask &= ~__GFP_MOVABLE;
 
 	new_page = __alloc_pages_nodemask(gfp_mask, order,
 				mtc->nid, mtc->nmask);
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

mm-mempolicy-use-a-standard-migration-target-allocation-callback.patch
mm-page_alloc-remove-a-wrapper-for-alloc_migration_target.patch
