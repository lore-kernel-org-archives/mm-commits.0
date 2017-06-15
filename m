From: akpm@linux-foundation.org
Subject: + mm-unify-new_node_page-and-alloc_migrate_target.patch added to
 -mm tree
Date: Thu, 15 Jun 2017 15:27:54 -0700
Message-ID: <594309ea.TkxCwlWZcjNDUQbt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46016 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752063AbdFOW1z (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Jun 2017 18:27:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, js1304@gmail.com, n-horiguchi@ah.jp.nec.com, qiuxishi@huawei.com, vbabka@suse.cz, zhongjiang@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: unify new_node_page and alloc_migrate_target
has been added to the -mm tree.  Its filename is
     mm-unify-new_node_page-and-alloc_migrate_target.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-unify-new_node_page-and-alloc_migrate_target.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-unify-new_node_page-and-alloc_migrate_target.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

 include/linux/migrate.h |   17 +++++++++++++++++
 mm/memory_hotplug.c     |   11 +----------
 mm/page_isolation.c     |   18 ++----------------
 3 files changed, 20 insertions(+), 26 deletions(-)

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
@@ -30,6 +31,22 @@ enum migrate_reason {
 /* In mm/debug.c; also keep sync with include/trace/events/migrate.h */
 extern char *migrate_reason_names[MR_TYPES];
 
+static inline struct page *new_page_nodemask(struct page *page, int preferred_nid,
+		nodemask_t *nodemask)
+{
+	gfp_t gfp_mask = GFP_USER | __GFP_MOVABLE;
+
+	if (PageHuge(page))
+		return alloc_huge_page_nodemask(page_hstate(compound_head(page)),
+				nodemask);
+
+	if (PageHighMem(page)
+	    || (zone_idx(page_zone(page)) == ZONE_MOVABLE))
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
@@ -1442,7 +1442,6 @@ static unsigned long scan_movable_pages(
 static struct page *new_node_page(struct page *page, unsigned long private,
 		int **result)
 {
-	gfp_t gfp_mask = GFP_USER | __GFP_MOVABLE;
 	int nid = page_to_nid(page);
 	nodemask_t nmask = node_states[N_MEMORY];
 
@@ -1455,15 +1454,7 @@ static struct page *new_node_page(struct
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
-
-	return alloc_page(gfp_mask);
+	return new_page_nodemask(page, numa_node_id(), &node_states[N_MEMORY]);
 }
_

Patches currently in -mm which might be from mhocko@suse.com are

fs-file-replace-alloc_fdmem-with-kvmalloc-alternative.patch
mm-remove-return-value-from-init_currently_empty_zone.patch
mm-memory_hotplug-use-node-instead-of-zone-in-can_online_high_movable.patch
mm-drop-page_initialized-check-from-get_nid_for_pfn.patch
mm-memory_hotplug-get-rid-of-is_zone_device_section.patch
mm-memory_hotplug-split-up-register_one_node.patch
mm-memory_hotplug-consider-offline-memblocks-removable.patch
mm-consider-zone-which-is-not-fully-populated-to-have-holes.patch
mm-consider-zone-which-is-not-fully-populated-to-have-holes-fix.patch
mm-compaction-skip-over-holes-in-__reset_isolation_suitable.patch
mm-__first_valid_page-skip-over-offline-pages.patch
mm-vmstat-skip-reporting-offline-pages-in-pagetypeinfo.patch
mm-vmstat-skip-reporting-offline-pages-in-pagetypeinfo-fix.patch
mm-memory_hotplug-do-not-associate-hotadded-memory-to-zones-until-online.patch
mm-memory_hotplug-fix-mmop_online_keep-behavior.patch
mm-memory_hotplug-do-not-assume-zone_normal-is-default-kernel-zone.patch
mm-memory_hotplug-replace-for_device-by-want_memblock-in-arch_add_memory.patch
mm-memory_hotplug-fix-the-section-mismatch-warning.patch
mm-memory_hotplug-remove-unused-cruft-after-memory-hotplug-rework.patch
mm-adaptive-hash-table-scaling-fix.patch
mm-memory_hotplug-drop-artificial-restriction-on-online-offline.patch
mm-memory_hotplug-drop-config_movable_node.patch
mm-memory_hotplug-move-movable_node-to-the-hotplug-proper.patch
mm-make-pr_set_thp_disable-immediately-active.patch
mm-memory_hotplug-simplify-empty-node-mask-handling-in-new_node_page.patch
hugetlb-memory_hotplug-prefer-to-use-reserved-pages-for-migration.patch
mm-unify-new_node_page-and-alloc_migrate_target.patch
lib-rhashtablec-use-kvzalloc-in-bucket_table_alloc-when-possible.patch
netfilter-use-kvmalloc-xt_alloc_table_info.patch

