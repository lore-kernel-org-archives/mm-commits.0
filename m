From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 055/118] mm/vmscan.c: remove unused return value
 of shrink_node
Date: Thu, 30 Jan 2020 22:14:08 -0800
Message-ID: <20200131061408.EKjcvXSEW%akpm@linux-foundation.org>
References: <20200130221021.5f0211c56346d5485af07923@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:33846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725907AbgAaGOJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 31 Jan 2020 01:14:09 -0500
In-Reply-To: <20200130221021.5f0211c56346d5485af07923@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, david@redhat.com, linux-mm@kvack.org, liu.song11@zte.com.cn, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

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
