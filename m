From: akpm@linux-foundation.org
Subject: [merged]
 mm-memory_hotplug-simplify-empty-node-mask-handling-in-new_node_page.patch
 removed from -mm tree
Date: Tue, 11 Jul 2017 12:23:54 -0700
Message-ID: <20170711192354.pcobW-721%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47754 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933716AbdGKTXz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Jul 2017 15:23:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: js1304@gmail.com, mhocko@suse.com, mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, qiuxishi@huawei.com, vbabka@suse.cz, zhongjiang@huawei.com


The patch titled
     Subject: mm, memory_hotplug: simplify empty node mask handling in new_node_page
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-simplify-empty-node-mask-handling-in-new_node_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm, memory_hotplug: simplify empty node mask handling in new_node_page

new_node_page tries to allocate the target page on a different NUMA node
than the source page.  This makes sense in most cases during the hotplug
because we are likely to offline the whole numa node.  But there are cases
where there are no other nodes to fallback (e.g.  when offlining parts of
the only existing node) and we have to fallback to allocating from the
source node.  The current code does that but it can be simplified by
checking the nmask and updating it before we even try to allocate rather
than special casing it.

This patch shouldn't introduce any functional change.

Link: http://lkml.kernel.org/r/20170608074553.22152-2-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Xishi Qiu <qiuxishi@huawei.com>
Cc: zhong jiang <zhongjiang@huawei.com>
Cc: Joonsoo Kim <js1304@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff -puN mm/memory_hotplug.c~mm-memory_hotplug-simplify-empty-node-mask-handling-in-new_node_page mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-memory_hotplug-simplify-empty-node-mask-handling-in-new_node_page
+++ a/mm/memory_hotplug.c
@@ -1436,7 +1436,15 @@ static struct page *new_node_page(struct
 	gfp_t gfp_mask = GFP_USER | __GFP_MOVABLE;
 	int nid = page_to_nid(page);
 	nodemask_t nmask = node_states[N_MEMORY];
-	struct page *new_page = NULL;
+
+	/*
+	 * try to allocate from a different node but reuse this node if there
+	 * are no other online nodes to be used (e.g. we are offlining a part
+	 * of the only existing node)
+	 */
+	node_clear(nid, nmask);
+	if (nodes_empty(nmask))
+		node_set(nid, nmask);
 
 	/*
 	 * TODO: allocate a destination hugepage from a nearest neighbor node,
@@ -1447,18 +1455,11 @@ static struct page *new_node_page(struct
 		return alloc_huge_page_node(page_hstate(compound_head(page)),
 					next_node_in(nid, nmask));
 
-	node_clear(nid, nmask);
-
 	if (PageHighMem(page)
 	    || (zone_idx(page_zone(page)) == ZONE_MOVABLE))
 		gfp_mask |= __GFP_HIGHMEM;
 
-	if (!nodes_empty(nmask))
-		new_page = __alloc_pages_nodemask(gfp_mask, 0, nid, &nmask);
-	if (!new_page)
-		new_page = __alloc_pages(gfp_mask, 0, nid);
