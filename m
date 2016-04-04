From: akpm@linux-foundation.org
Subject: [merged] mm-fix-invalid-node-in-alloc_migrate_target.patch
 removed from -mm tree
Date: Mon, 04 Apr 2016 11:09:38 -0700
Message-ID: <5702ade2.O8+qDVWXYp7Sju1a%akpm__8166.42139475352$1459793401$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56934 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753517AbcDDSJj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Apr 2016 14:09:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: qiuxishi@huawei.com, js1304@gmail.com, lauraa@codeaurora.org, n-horiguchi@ah.jp.nec.com, rientjes@google.com, stable@vger.kernel.org, vbabka@suse.cz, wangxq10@lzu.edu.cn, zhuhui@xiaomi.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix invalid node in alloc_migrate_target()
has been removed from the -mm tree.  Its filename was
     mm-fix-invalid-node-in-alloc_migrate_target.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Xishi Qiu <qiuxishi@huawei.com>
Subject: mm: fix invalid node in alloc_migrate_target()

It is incorrect to use next_node to find a target node, it will
return MAX_NUMNODES or invalid node. This will lead to crash in
buddy system allocation.

Fixes: c8721bbbdd36 ("mm: memory-hotplug: enable memory hotplug to handle hugepage")
Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Joonsoo Kim <js1304@gmail.com>
Cc: David Rientjes <rientjes@google.com>
Cc: "Laura Abbott" <lauraa@codeaurora.org>
Cc: Hui Zhu <zhuhui@xiaomi.com>
Cc: Wang Xiaoqiang <wangxq10@lzu.edu.cn>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_isolation.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN mm/page_isolation.c~mm-fix-invalid-node-in-alloc_migrate_target mm/page_isolation.c
--- a/mm/page_isolation.c~mm-fix-invalid-node-in-alloc_migrate_target
+++ a/mm/page_isolation.c
@@ -289,11 +289,11 @@ struct page *alloc_migrate_target(struct
 	 * now as a simple work-around, we use the next node for destination.
 	 */
 	if (PageHuge(page)) {
-		nodemask_t src = nodemask_of_node(page_to_nid(page));
-		nodemask_t dst;
-		nodes_complement(dst, src);
+		int node = next_online_node(page_to_nid(page));
+		if (node == MAX_NUMNODES)
+			node = first_online_node;
 		return alloc_huge_page_node(page_hstate(compound_head(page)),
-					    next_node(page_to_nid(page), dst));
+					    node);
 	}
 
 	if (PageHighMem(page))
_

Patches currently in -mm which might be from qiuxishi@huawei.com are


