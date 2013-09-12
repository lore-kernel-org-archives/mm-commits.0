From: akpm@linux-foundation.org
Subject: [merged] mm-vmalloc-remove-useless-variable-in-vmap_block.patch
 removed from -mm tree
Date: Thu, 12 Sep 2013 12:43:35 -0700
Message-ID: <52321967.rrL4CbO2uirjTI5j%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58230 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755407Ab3ILTnf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:43:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zhangyanfei@cn.fujitsu.com, liwanp@linux.vnet.ibm.com, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com

Subject: [merged] mm-vmalloc-remove-useless-variable-in-vmap_block.patch removed from -mm tree
To: iamjoonsoo.kim@lge.com,hannes@cmpxchg.org,liwanp@linux.vnet.ibm.com,zhangyanfei@cn.fujitsu.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:43:35 -0700


The patch titled
     Subject: mm, vmalloc: remove useless variable in vmap_block
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-remove-useless-variable-in-vmap_block.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm, vmalloc: remove useless variable in vmap_block

vbq in vmap_block isn't used. So remove it.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Reviewed-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN mm/vmalloc.c~mm-vmalloc-remove-useless-variable-in-vmap_block mm/vmalloc.c
--- a/mm/vmalloc.c~mm-vmalloc-remove-useless-variable-in-vmap_block
+++ a/mm/vmalloc.c
@@ -752,7 +752,6 @@ struct vmap_block_queue {
 struct vmap_block {
 	spinlock_t lock;
 	struct vmap_area *va;
-	struct vmap_block_queue *vbq;
 	unsigned long free, dirty;
 	DECLARE_BITMAP(dirty_map, VMAP_BBMAP_BITS);
 	struct list_head free_list;
@@ -830,7 +829,6 @@ static struct vmap_block *new_vmap_block
 	radix_tree_preload_end();
 
 	vbq = &get_cpu_var(vmap_block_queue);
-	vb->vbq = vbq;
 	spin_lock(&vbq->lock);
 	list_add_rcu(&vb->free_list, &vbq->free);
 	spin_unlock(&vbq->lock);
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

origin.patch

