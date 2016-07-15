From: akpm@linux-foundation.org
Subject: +
 mem-hotplug-use-different-mempolicy-in-alloc_migrate_target.patch added to
 -mm tree
Date: Fri, 15 Jul 2016 16:05:25 -0700
Message-ID: <57896c35.fdQ8XMC0/Lnwoa//%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39878 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447AbcGOXF0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Jul 2016 19:05:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: qiuxishi@huawei.com, iamjoonsoo.kim@lge.com, n-horiguchi@ah.jp.nec.com, rientjes@google.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mem-hotplug: use different mempolicy in alloc_migrate_target()
has been added to the -mm tree.  Its filename is
     mem-hotplug-use-different-mempolicy-in-alloc_migrate_target.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mem-hotplug-use-different-mempolicy-in-alloc_migrate_target.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mem-hotplug-use-different-mempolicy-in-alloc_migrate_target.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Xishi Qiu <qiuxishi@huawei.com>
Subject: mem-hotplug: use different mempolicy in alloc_migrate_target()

When we offline a node, the new page should alloced from other nodes
instead of the current node, because re-migrate is a waste of time.  So
use preferred mempolicy for hotplug, use default mempolicy for cma.

Link: http://lkml.kernel.org/r/57884FAA.9040500@huawei.com
Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-isolation.h |    2 +-
 mm/memory_hotplug.c            |    5 ++++-
 mm/page_alloc.c                |    2 +-
 mm/page_isolation.c            |    8 +++++---
 4 files changed, 11 insertions(+), 6 deletions(-)

diff -puN include/linux/page-isolation.h~mem-hotplug-use-different-mempolicy-in-alloc_migrate_target include/linux/page-isolation.h
--- a/include/linux/page-isolation.h~mem-hotplug-use-different-mempolicy-in-alloc_migrate_target
+++ a/include/linux/page-isolation.h
@@ -65,7 +65,7 @@ undo_isolate_page_range(unsigned long st
 int test_pages_isolated(unsigned long start_pfn, unsigned long end_pfn,
 			bool skip_hwpoisoned_pages);
 
-struct page *alloc_migrate_target(struct page *page, unsigned long private,
+struct page *alloc_migrate_target(struct page *page, unsigned long nid,
 				int **resultp);
 
 #endif
diff -puN mm/memory_hotplug.c~mem-hotplug-use-different-mempolicy-in-alloc_migrate_target mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mem-hotplug-use-different-mempolicy-in-alloc_migrate_target
+++ a/mm/memory_hotplug.c
@@ -1557,12 +1557,15 @@ do_migrate_range(unsigned long start_pfn
 	int move_pages = NR_OFFLINE_AT_ONCE_PAGES;
 	int not_managed = 0;
 	int ret = 0;
+	int nid = NUMA_NO_NODE;
 	LIST_HEAD(source);
 
 	for (pfn = start_pfn; pfn < end_pfn && move_pages > 0; pfn++) {
 		if (!pfn_valid(pfn))
 			continue;
 		page = pfn_to_page(pfn);
+		if (nid == NUMA_NO_NODE)
+			nid = next_node_in(page_to_nid(page), node_online_map);
 
 		if (PageHuge(page)) {
 			struct page *head = compound_head(page);
@@ -1615,7 +1618,7 @@ do_migrate_range(unsigned long start_pfn
 		 * alloc_migrate_target should be improooooved!!
 		 * migrate_pages returns # of failed pages.
 		 */
-		ret = migrate_pages(&source, alloc_migrate_target, NULL, 0,
+		ret = migrate_pages(&source, alloc_migrate_target, NULL, nid,
 					MIGRATE_SYNC, MR_MEMORY_HOTPLUG);
 		if (ret)
 			putback_movable_pages(&source);
diff -puN mm/page_alloc.c~mem-hotplug-use-different-mempolicy-in-alloc_migrate_target mm/page_alloc.c
--- a/mm/page_alloc.c~mem-hotplug-use-different-mempolicy-in-alloc_migrate_target
+++ a/mm/page_alloc.c
@@ -7250,7 +7250,7 @@ static int __alloc_contig_migrate_range(
 		cc->nr_migratepages -= nr_reclaimed;
 
 		ret = migrate_pages(&cc->migratepages, alloc_migrate_target,
-				    NULL, 0, cc->mode, MR_CMA);
+				    NULL, NUMA_NO_NODE, cc->mode, MR_CMA);
 	}
 	if (ret < 0) {
 		putback_movable_pages(&cc->migratepages);
diff -puN mm/page_isolation.c~mem-hotplug-use-different-mempolicy-in-alloc_migrate_target mm/page_isolation.c
--- a/mm/page_isolation.c~mem-hotplug-use-different-mempolicy-in-alloc_migrate_target
+++ a/mm/page_isolation.c
@@ -280,18 +280,20 @@ int test_pages_isolated(unsigned long st
 	return pfn < end_pfn ? -EBUSY : 0;
 }
 
-struct page *alloc_migrate_target(struct page *page, unsigned long private,
+struct page *alloc_migrate_target(struct page *page, unsigned long nid,
 				  int **resultp)
 {
 	/*
-	 * TODO: allocate a destination hugepage from a nearest neighbor node,
+	 * hugeTLB: allocate a destination page from a nearest neighbor node,
 	 * accordance with memory policy of the user process if possible. For
 	 * now as a simple work-around, we use the next node for destination.
+	 * Normal page: use prefer mempolicy for destination if called by
+	 * hotplug, use default mempolicy for destination if called by cma.
 	 */
 	if (PageHuge(page))
 		return alloc_huge_page_node(page_hstate(compound_head(page)),
 					    next_node_in(page_to_nid(page),
 							 node_online_map));
 	else
-		return alloc_page(GFP_HIGHUSER_MOVABLE);
+		return alloc_pages_node(nid, GFP_HIGHUSER_MOVABLE, 0);
 }
_

Patches currently in -mm which might be from qiuxishi@huawei.com are

mem-hotplug-use-gfp_highuser_movable-in-alloc_migrate_target.patch
mem-hotplug-use-different-mempolicy-in-alloc_migrate_target.patch

