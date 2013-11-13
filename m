From: akpm@linux-foundation.org
Subject: [merged] mm-vmalloc-use-numa_no_node.patch removed from -mm tree
Date: Wed, 13 Nov 2013 12:37:43 -0800
Message-ID: <5283e317.FqdLBM5/U5+lKRmY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42483 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123Ab3KMUhn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Nov 2013 15:37:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, wujianguo@huawei.com

Subject: [merged] mm-vmalloc-use-numa_no_node.patch removed from -mm tree
To: wujianguo@huawei.com,rientjes@google.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 13 Nov 2013 12:37:43 -0800


The patch titled
     Subject: mm/vmalloc: use NUMA_NO_NODE
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-use-numa_no_node.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jianguo Wu <wujianguo@huawei.com>
Subject: mm/vmalloc: use NUMA_NO_NODE

Use more appropriate "if (node == NUMA_NO_NODE)" instead of "if (node < 0)"

Signed-off-by: Jianguo Wu <wujianguo@huawei.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/vmalloc.c~mm-vmalloc-use-numa_no_node mm/vmalloc.c
--- a/mm/vmalloc.c~mm-vmalloc-use-numa_no_node
+++ a/mm/vmalloc.c
@@ -1577,7 +1577,7 @@ static void *__vmalloc_area_node(struct
 		struct page *page;
 		gfp_t tmp_mask = gfp_mask | __GFP_NOWARN;
 
-		if (node < 0)
+		if (node == NUMA_NO_NODE)
 			page = alloc_page(tmp_mask);
 		else
 			page = alloc_pages_node(node, tmp_mask, order);
_

Patches currently in -mm which might be from wujianguo@huawei.com are

origin.patch
x86-srat-use-numa_no_node.patch
linux-next.patch

