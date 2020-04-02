From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 129/155] mm,thp,compaction,cma: allow THP
 migration for CMA allocations
Date: Wed, 01 Apr 2020 21:10:31 -0700
Message-ID: <20200402041031.r4WtvC5wp%akpm@linux-foundation.org>
References: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:36142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726136AbgDBEKd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Apr 2020 00:10:33 -0400
In-Reply-To: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, akpm@linux-foundation.org, js1304@gmail.com, linux-mm@kvack.org, mgorman@techsingularity.net, mhocko@kernel.org, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, riel@surriel.com, rientjes@google.com, torvalds@linux-foundation.org, vbabka@suse.cz, ziy@nvidia.com

From: Rik van Riel <riel@surriel.com>
Subject: mm,thp,compaction,cma: allow THP migration for CMA allocations

The code to implement THP migrations already exists, and the code for CMA
to clear out a region of memory already exists.

Only a few small tweaks are needed to allow CMA to move THP memory when
attempting an allocation from alloc_contig_range.

With these changes, migrating THPs from a CMA area works when allocating a
1GB hugepage from CMA memory.

[riel@surriel.com: fix hugetlbfs pages per Mike, cleanup per Vlastimil]
  Link: http://lkml.kernel.org/r/20200228104700.0af2f18d@imladris.surriel.com
Link: http://lkml.kernel.org/r/20200227213238.1298752-2-riel@surriel.com
Signed-off-by: Rik van Riel <riel@surriel.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: David Rientjes <rientjes@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Joonsoo Kim <js1304@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   22 +++++++++++++---------
 mm/page_alloc.c |    9 +++++++--
 2 files changed, 20 insertions(+), 11 deletions(-)

--- a/mm/compaction.c~mmthpcompactioncma-allow-thp-migration-for-cma-allocations
+++ a/mm/compaction.c
@@ -894,12 +894,13 @@ isolate_migratepages_block(struct compac
 
 		/*
 		 * Regardless of being on LRU, compound pages such as THP and
-		 * hugetlbfs are not to be compacted. We can potentially save
-		 * a lot of iterations if we skip them at once. The check is
-		 * racy, but we can consider only valid values and the only
-		 * danger is skipping too much.
+		 * hugetlbfs are not to be compacted unless we are attempting
+		 * an allocation much larger than the huge page size (eg CMA).
+		 * We can potentially save a lot of iterations if we skip them
+		 * at once. The check is racy, but we can consider only valid
+		 * values and the only danger is skipping too much.
 		 */
-		if (PageCompound(page)) {
+		if (PageCompound(page) && !cc->alloc_contig) {
 			const unsigned int order = compound_order(page);
 
 			if (likely(order < MAX_ORDER))
@@ -969,7 +970,7 @@ isolate_migratepages_block(struct compac
 			 * and it's on LRU. It can only be a THP so the order
 			 * is safe to read and it's 0 for tail pages.
 			 */
-			if (unlikely(PageCompound(page))) {
+			if (unlikely(PageCompound(page) && !cc->alloc_contig)) {
 				low_pfn += compound_nr(page) - 1;
 				goto isolate_fail;
 			}
@@ -981,12 +982,15 @@ isolate_migratepages_block(struct compac
 		if (__isolate_lru_page(page, isolate_mode) != 0)
 			goto isolate_fail;
 
-		VM_BUG_ON_PAGE(PageCompound(page), page);
+		/* The whole page is taken off the LRU; skip the tail pages. */
+		if (PageCompound(page))
+			low_pfn += compound_nr(page) - 1;
 
 		/* Successfully isolated */
 		del_page_from_lru_list(page, lruvec, page_lru(page));
-		inc_node_page_state(page,
-				NR_ISOLATED_ANON + page_is_file_cache(page));
+		mod_node_page_state(page_pgdat(page),
+				NR_ISOLATED_ANON + page_is_file_cache(page),
+				hpage_nr_pages(page));
 
 isolate_success:
 		list_add(&page->lru, &cc->migratepages);
--- a/mm/page_alloc.c~mmthpcompactioncma-allow-thp-migration-for-cma-allocations
+++ a/mm/page_alloc.c
@@ -8251,15 +8251,20 @@ struct page *has_unmovable_pages(struct
 
 		/*
 		 * Hugepages are not in LRU lists, but they're movable.
+		 * THPs are on the LRU, but need to be counted as #small pages.
 		 * We need not scan over tail pages because we don't
 		 * handle each tail page individually in migration.
 		 */
-		if (PageHuge(page)) {
+		if (PageHuge(page) || PageTransCompound(page)) {
 			struct page *head = compound_head(page);
 			unsigned int skip_pages;
 
-			if (!hugepage_migration_supported(page_hstate(head)))
+			if (PageHuge(page)) {
+				if (!hugepage_migration_supported(page_hstate(head)))
+					return page;
+			} else if (!PageLRU(head) && !__PageMovable(head)) {
 				return page;
+			}
 
 			skip_pages = compound_nr(head) - (page - head);
 			iter += skip_pages - 1;
_
