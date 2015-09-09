From: akpm@linux-foundation.org
Subject: [merged] mm-fix-type-information-of-memoryless-node.patch removed from -mm tree
Date: Wed, 09 Sep 2015 12:53:49 -0700
Message-ID: <55f08e4d.Jw/wZWcZjh3kb/TD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41314 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752829AbbIITxt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2015 15:53:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: thunder.leizhen@huawei.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc.c: fix type information of memoryless node
has been removed from the -mm tree.  Its filename was
     mm-fix-type-information-of-memoryless-node.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Zhen Lei <thunder.leizhen@huawei.com>
Subject: mm/page_alloc.c: fix type information of memoryless node

For a memoryless node, the output of get_pfn_range_for_nid are all zero.
It will display mem from 0 to -1.

Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-fix-type-information-of-memoryless-node mm/page_alloc.c
--- a/mm/page_alloc.c~mm-fix-type-information-of-memoryless-node
+++ a/mm/page_alloc.c
@@ -5476,7 +5476,8 @@ void __paginginit free_area_init_node(in
 #ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
 	get_pfn_range_for_nid(nid, &start_pfn, &end_pfn);
 	pr_info("Initmem setup node %d [mem %#018Lx-%#018Lx]\n", nid,
-		(u64)start_pfn << PAGE_SHIFT, ((u64)end_pfn << PAGE_SHIFT) - 1);
+		(u64)start_pfn << PAGE_SHIFT,
+		end_pfn ? ((u64)end_pfn << PAGE_SHIFT) - 1 : 0);
 #endif
 	calculate_node_totalpages(pgdat, start_pfn, end_pfn,
 				  zones_size, zholes_size);
_

Patches currently in -mm which might be from thunder.leizhen@huawei.com are


