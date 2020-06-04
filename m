From: akpm@linux-foundation.org
Subject: [merged]
 mm-page_allocc-use-node_mask_none-in-build_zonelists.patch removed from -mm
 tree
Date: Thu, 04 Jun 2020 10:18:13 -0700
Message-ID: <20200604171813.6pPMurbkJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:39712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730072AbgFDRSO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Jun 2020 13:18:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david@redhat.com, jhubbard@nvidia.com, mm-commits@vger.kernel.org, pankaj.gupta.linux@gmail.com, richard.weiyang@gmail.com


The patch titled
     Subject: mm/page_alloc.c: use NODE_MASK_NONE in build_zonelists()
has been removed from the -mm tree.  Its filename was
     mm-page_allocc-use-node_mask_none-in-build_zonelists.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/page_alloc.c: use NODE_MASK_NONE in build_zonelists()

Slightly simplify the code by initializing user_mask with NODE_MASK_NONE,
instead of later calling nodes_clear().  This saves a line of code.

Link: http://lkml.kernel.org/r/20200330220840.21228-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/page_alloc.c~mm-page_allocc-use-node_mask_none-in-build_zonelists
+++ a/mm/page_alloc.c
@@ -5692,14 +5692,13 @@ static void build_zonelists(pg_data_t *p
 {
 	static int node_order[MAX_NUMNODES];
 	int node, load, nr_nodes = 0;
-	nodemask_t used_mask;
+	nodemask_t used_mask = NODE_MASK_NONE;
 	int local_node, prev_node;
 
 	/* NUMA-aware ordering of nodes */
 	local_node = pgdat->node_id;
 	load = nr_online_nodes;
 	prev_node = local_node;
-	nodes_clear(used_mask);
 
 	memset(node_order, 0, sizeof(node_order));
 	while ((node = find_next_best_node(local_node, &used_mask)) >= 0) {
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

bitops-simplify-get_count_order_long.patch
bitops-use-the-same-mechanism-for-get_count_order.patch
lib-test-get_count_order-long-in-test_bitopsc.patch
