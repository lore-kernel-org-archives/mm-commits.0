From: akpm@linux-foundation.org
Subject: [merged]
 mm-unify-new_node_page-and-alloc_migrate_target.patch removed from -mm tree
Date: Tue, 11 Jul 2017 12:24:00 -0700
Message-ID: <20170711192400.-5uoLRYGI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47779 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933716AbdGKTYB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Jul 2017 15:24:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: js1304@gmail.com, mhocko@suse.com, mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, qiuxishi@huawei.com, vbabka@suse.cz, zhongjiang@huawei.com


The patch titled
     Subject: mm: unify new_node_page and alloc_migrate_target
has been removed from the -mm tree.  Its filename was
     mm-unify-new_node_page-and-alloc_migrate_target.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm: unify new_node_page and alloc_migrate_target

394e31d2ceb4 ("mem-hotplug: alloc new page from a nearest neighbor node
when mem-offline") has duplicated a large part of alloc_migrate_target
with some hotplug specific special casing.  To be more precise it tried to
enfore the allocation from a different node than the original page.  As a
result the two function diverged in their shared logic, e.g.  the hugetlb
allocation strategy.  Let's unify the two and express different NUMA
requirements by the given nodemask.  new_node_page will simply exclude the
node it doesn't care about and alloc_migrate_target will use all the
available nodes.  alloc_migrate_target will then learn to migrate hugetlb
pages more sanely and use preallocated pool when possible.

Please note that alloc_migrate_target used to call alloc_page resp. 
alloc_pages_current so the memory policy of the current context which is
quite strange when we consider that it is used in the context of
alloc_contig_range which just tries to migrate pages which stand in the
way.

Link: http://lkml.kernel.org/r/20170608074553.22152-4-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Xishi Qiu <qiuxishi@huawei.com>
Cc: zhong jiang <zhongjiang@huawei.com>
Cc: Joonsoo Kim <js1304@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/migrate.h |   16 ++++++++++++++++
 mm/memory_hotplug.c     |   11 +----------
 mm/page_isolation.c     |   18 ++----------------
 3 files changed, 19 insertions(+), 26 deletions(-)

diff -puN include/linux/migrate.h~mm-unify-new_node_page-and-alloc_migrate_target include/linux/migrate.h
--- a/include/linux/migrate.h~mm-unify-new_node_page-and-alloc_migrate_target
+++ a/include/linux/migrate.h
@@ -4,6 +4,7 @@
 #include <linux/mm.h>
 #include <linux/mempolicy.h>
 #include <linux/migrate_mode.h>
+#include <linux/hugetlb.h>
 
 typedef struct page *new_page_t(struct page *page, unsigned long private,
 				int **reason);
@@ -30,6 +31,21 @@ enum migrate_reason {
 /* In mm/debug.c; also keep sync with include/trace/events/migrate.h */
 extern char *migrate_reason_names[MR_TYPES];
 
+static inline struct page *new_page_nodemask(struct page *page,
+				int preferred_nid, nodemask_t *nodemask)
+{
+	gfp_t gfp_mask = GFP_USER | __GFP_MOVABLE;
+
+	if (PageHuge(page))
+		return alloc_huge_page_nodemask(page_hstate(compound_head(page)),
+				nodemask);
+
+	if (PageHighMem(page) || (zone_idx(page_zone(page)) == ZONE_MOVABLE))
+		gfp_mask |= __GFP_HIGHMEM;
+
+	return __alloc_pages_nodemask(gfp_mask, 0, preferred_nid, nodemask);
+}
+
 #ifdef CONFIG_MIGRATION
 
 extern void putback_movable_pages(struct list_head *l);
diff -puN mm/memory_hotplug.c~mm-unify-new_node_page-and-alloc_migrate_target mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-unify-new_node_page-and-alloc_migrate_target
+++ a/mm/memory_hotplug.c
@@ -1433,7 +1433,6 @@ static unsigned long scan_movable_pages(
 static struct page *new_node_page(struct page *page, unsigned long private,
 		int **result)
 {
-	gfp_t gfp_mask = GFP_USER | __GFP_MOVABLE;
 	int nid = page_to_nid(page);
 	nodemask_t nmask = node_states[N_MEMORY];
 
@@ -1446,15 +1445,7 @@ static struct page *new_node_page(struct
 	if (nodes_empty(nmask))
 		node_set(nid, nmask);
 
-	if (PageHuge(page))
-		return alloc_huge_page_nodemask(
-				page_hstate(compound_head(page)), &nmask);
-
-	if (PageHighMem(page)
-	    || (zone_idx(page_zone(page)) == ZONE_MOVABLE))
-		gfp_mask |= __GFP_HIGHMEM;
-
-	return __alloc_pages_nodemask(gfp_mask, 0, nid, &nmask);
+	return new_page_nodemask(page, nid, &nmask);
 }
 
 #define NR_OFFLINE_AT_ONCE_PAGES	(256)
diff -puN mm/page_isolation.c~mm-unify-new_node_page-and-alloc_migrate_target mm/page_isolation.c
--- a/mm/page_isolation.c~mm-unify-new_node_page-and-alloc_migrate_target
+++ a/mm/page_isolation.c
@@ -8,6 +8,7 @@
 #include <linux/memory.h>
 #include <linux/hugetlb.h>
 #include <linux/page_owner.h>
+#include <linux/migrate.h>
 #include "internal.h"
 
 #define CREATE_TRACE_POINTS
@@ -294,20 +295,5 @@ int test_pages_isolated(unsigned long st
 struct page *alloc_migrate_target(struct page *page, unsigned long private,
 				  int **resultp)
 {
-	gfp_t gfp_mask = GFP_USER | __GFP_MOVABLE;
-
-	/*
-	 * TODO: allocate a destination hugepage from a nearest neighbor node,
-	 * accordance with memory policy of the user process if possible. For
-	 * now as a simple work-around, we use the next node for destination.
-	 */
-	if (PageHuge(page))
-		return alloc_huge_page_node(page_hstate(compound_head(page)),
-					    next_node_in(page_to_nid(page),
-							 node_online_map));
-
-	if (PageHighMem(page))
-		gfp_mask |= __GFP_HIGHMEM;
