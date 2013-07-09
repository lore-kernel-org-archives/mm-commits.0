From: akpm@linux-foundation.org
Subject: [merged] mm-vmallocc-remove-alloc_map-from-vmap_block.patch
 removed from -mm tree
Date: Tue, 09 Jul 2013 16:19:35 -0700
Message-ID: <51dc9a87.J1wJ/XBynYF7pIcK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38831 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753845Ab3GIXTg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jul 2013 19:19:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mel@csn.ul.ie, hannes@cmpxchg.org, zhangyanfei@cn.fujitsu.com

Subject: [merged] mm-vmallocc-remove-alloc_map-from-vmap_block.patch removed from -mm tree
To: zhangyanfei@cn.fujitsu.com,hannes@cmpxchg.org,mel@csn.ul.ie,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 09 Jul 2013 16:19:35 -0700


The patch titled
     Subject: mm/vmalloc.c: remove alloc_map from vmap_block
has been removed from the -mm tree.  Its filename was
     mm-vmallocc-remove-alloc_map-from-vmap_block.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: mm/vmalloc.c: remove alloc_map from vmap_block

As we have removed the dead code in the vb_alloc, it seems there is no
place to use the alloc_map.  So there is no reason to maintain the
alloc_map in vmap_block.

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN mm/vmalloc.c~mm-vmallocc-remove-alloc_map-from-vmap_block mm/vmalloc.c
--- a/mm/vmalloc.c~mm-vmallocc-remove-alloc_map-from-vmap_block
+++ a/mm/vmalloc.c
@@ -754,7 +754,6 @@ struct vmap_block {
 	struct vmap_area *va;
 	struct vmap_block_queue *vbq;
 	unsigned long free, dirty;
-	DECLARE_BITMAP(alloc_map, VMAP_BBMAP_BITS);
 	DECLARE_BITMAP(dirty_map, VMAP_BBMAP_BITS);
 	struct list_head free_list;
 	struct rcu_head rcu_head;
@@ -820,7 +819,6 @@ static struct vmap_block *new_vmap_block
 	vb->va = va;
 	vb->free = VMAP_BBMAP_BITS;
 	vb->dirty = 0;
-	bitmap_zero(vb->alloc_map, VMAP_BBMAP_BITS);
 	bitmap_zero(vb->dirty_map, VMAP_BBMAP_BITS);
 	INIT_LIST_HEAD(&vb->free_list);
 
@@ -873,7 +871,6 @@ static void purge_fragmented_blocks(int
 		if (vb->free + vb->dirty == VMAP_BBMAP_BITS && vb->dirty != VMAP_BBMAP_BITS) {
 			vb->free = 0; /* prevent further allocs after releasing lock */
 			vb->dirty = VMAP_BBMAP_BITS; /* prevent purging it again */
-			bitmap_fill(vb->alloc_map, VMAP_BBMAP_BITS);
 			bitmap_fill(vb->dirty_map, VMAP_BBMAP_BITS);
 			spin_lock(&vbq->lock);
 			list_del_rcu(&vb->free_list);
_

Patches currently in -mm which might be from zhangyanfei@cn.fujitsu.com are

origin.patch
linux-next.patch

