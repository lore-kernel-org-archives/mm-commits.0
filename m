From: akpm@linux-foundation.org
Subject: [merged]
 mm-vmscanc-remove-unused-return-value-of-shrink_node.patch removed from -mm
 tree
Date: Fri, 31 Jan 2020 15:18:36 -0800
Message-ID: <20200131231836.wyRBATR3o%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:50686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726347AbgAaXSi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 31 Jan 2020 18:18:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david@redhat.com, liu.song11@zte.com.cn, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmscan.c: remove unused return value of shrink_node
has been removed from the -mm tree.  Its filename was
     mm-vmscanc-remove-unused-return-value-of-shrink_node.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Liu Song <liu.song11@zte.com.cn>
Subject: mm/vmscan.c: remove unused return value of shrink_node

The return value of shrink_node is not used, so remove
unnecessary operations.

Link: http://lkml.kernel.org/r/20191128143524.3223-1-fishland@aliyun.com
Signed-off-by: Liu Song <liu.song11@zte.com.cn>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/mm/vmscan.c~mm-vmscanc-remove-unused-return-value-of-shrink_node
+++ a/mm/vmscan.c
@@ -2695,7 +2695,7 @@ static void shrink_node_memcgs(pg_data_t
 	} while ((memcg = mem_cgroup_iter(target_memcg, memcg, NULL)));
 }
 
-static bool shrink_node(pg_data_t *pgdat, struct scan_control *sc)
+static void shrink_node(pg_data_t *pgdat, struct scan_control *sc)
 {
 	struct reclaim_state *reclaim_state = current->reclaim_state;
 	unsigned long nr_reclaimed, nr_scanned;
@@ -2874,8 +2874,6 @@ again:
 	 */
 	if (reclaimable)
 		pgdat->kswapd_failures = 0;
