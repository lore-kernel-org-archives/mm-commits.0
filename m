From: akpm@linux-foundation.org
Subject: [merged] mm-vmallocc-remove-dead-code-in-vb_alloc.patch removed
 from -mm tree
Date: Tue, 09 Jul 2013 16:19:31 -0700
Message-ID: <51dc9a83.GvdVOvxP66kdiMsn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38824 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753653Ab3GIXTc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jul 2013 19:19:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mel@csn.ul.ie, hannes@cmpxchg.org, zhangyanfei@cn.fujitsu.com

Subject: [merged] mm-vmallocc-remove-dead-code-in-vb_alloc.patch removed from -mm tree
To: zhangyanfei@cn.fujitsu.com,hannes@cmpxchg.org,mel@csn.ul.ie,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 09 Jul 2013 16:19:31 -0700


The patch titled
     Subject: mm/vmalloc.c: remove dead code in vb_alloc
has been removed from the -mm tree.  Its filename was
     mm-vmallocc-remove-dead-code-in-vb_alloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: mm/vmalloc.c: remove dead code in vb_alloc

Space in a vmap block that was once allocated is considered dirty and
not made available for allocation again before the whole block is
recycled. The result is that free space within a vmap block is always
contiguous.

So if a vmap block has enough free space for allocation, the allocation
is impossible to fail. Thus, the fragmented block purging was never invoked
from vb_alloc(). So remove this dead code.

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   16 +---------------
 1 file changed, 1 insertion(+), 15 deletions(-)

diff -puN mm/vmalloc.c~mm-vmallocc-remove-dead-code-in-vb_alloc mm/vmalloc.c
--- a/mm/vmalloc.c~mm-vmallocc-remove-dead-code-in-vb_alloc
+++ a/mm/vmalloc.c
@@ -910,7 +910,6 @@ static void *vb_alloc(unsigned long size
 	struct vmap_block *vb;
 	unsigned long addr = 0;
 	unsigned int order;
-	int purge = 0;
 
 	BUG_ON(size & ~PAGE_MASK);
 	BUG_ON(size > PAGE_SIZE*VMAP_MAX_ALLOC);
@@ -934,17 +933,7 @@ again:
 		if (vb->free < 1UL << order)
 			goto next;
 
-		i = bitmap_find_free_region(vb->alloc_map,
-						VMAP_BBMAP_BITS, order);
-
-		if (i < 0) {
-			if (vb->free + vb->dirty == VMAP_BBMAP_BITS) {
-				/* fragmented and no outstanding allocations */
-				BUG_ON(vb->dirty != VMAP_BBMAP_BITS);
-				purge = 1;
-			}
-			goto next;
-		}
+		i = VMAP_BBMAP_BITS - vb->free;
 		addr = vb->va->va_start + (i << PAGE_SHIFT);
 		BUG_ON(addr_to_vb_idx(addr) !=
 				addr_to_vb_idx(vb->va->va_start));
@@ -960,9 +949,6 @@ next:
 		spin_unlock(&vb->lock);
 	}
 
-	if (purge)
-		purge_fragmented_blocks_thiscpu();
