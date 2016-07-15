From: akpm@linux-foundation.org
Subject: [to-be-updated]
 mem-hotplug-use-gfp_highuser_movable-and-alloc-from-next-node-in-alloc_migrate_target.patch removed from -mm tree
Date: Fri, 15 Jul 2016 16:04:13 -0700
Message-ID: <57896bed.8USwsp2JZ+jtuPkY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39862 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325AbcGOXEP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Jul 2016 19:04:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: qiuxishi@huawei.com, iamjoonsoo.kim@lge.com, n-horiguchi@ah.jp.nec.com, rientjes@google.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mem-hotplug: use GFP_HIGHUSER_MOVABLE and alloc from next node in alloc_migrate_target()
has been removed from the -mm tree.  Its filename was
     mem-hotplug-use-gfp_highuser_movable-and-alloc-from-next-node-in-alloc_migrate_target.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Xishi Qiu <qiuxishi@huawei.com>
Subject: mem-hotplug: use GFP_HIGHUSER_MOVABLE and alloc from next node in alloc_migrate_target()

alloc_migrate_target() is called from migrate_pages(), and the page is
always from user space, so we can add __GFP_HIGHMEM directly.

Second, when we offline a node, the new page should alloced from other
nodes instead of the current node, because re-migrate is a waste of time.

Link: http://lkml.kernel.org/r/5786F81B.1070502@huawei.com
Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_isolation.c |   16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff -puN mm/page_isolation.c~mem-hotplug-use-gfp_highuser_movable-and-alloc-from-next-node-in-alloc_migrate_target mm/page_isolation.c
--- a/mm/page_isolation.c~mem-hotplug-use-gfp_highuser_movable-and-alloc-from-next-node-in-alloc_migrate_target
+++ a/mm/page_isolation.c
@@ -283,20 +283,16 @@ int test_pages_isolated(unsigned long st
 struct page *alloc_migrate_target(struct page *page, unsigned long private,
 				  int **resultp)
 {
-	gfp_t gfp_mask = GFP_USER | __GFP_MOVABLE;
-
 	/*
-	 * TODO: allocate a destination hugepage from a nearest neighbor node,
+	 * TODO: allocate a destination page from a nearest neighbor node,
 	 * accordance with memory policy of the user process if possible. For
 	 * now as a simple work-around, we use the next node for destination.
 	 */
+	int nid = next_node_in(page_to_nid(page), node_online_map);
+
 	if (PageHuge(page))
 		return alloc_huge_page_node(page_hstate(compound_head(page)),
-					    next_node_in(page_to_nid(page),
-							 node_online_map));
-
-	if (PageHighMem(page))
-		gfp_mask |= __GFP_HIGHMEM;
