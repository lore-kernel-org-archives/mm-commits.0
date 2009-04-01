From: akpm@linux-foundation.org
Subject: [merged] vmap-remove-needless-lock-and-list-in-vmap.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:34:10 -0700
Message-ID: <200904011834.n31IYAMs007021@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47805 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756288AbZDASgx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 14:36:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan.kim@gmail.com, npiggin@suse.de, mm-commits@vger.kernel.org


The patch titled
     vmap: remove needless lock and list in vmap
has been removed from the -mm tree.  Its filename was
     vmap-remove-needless-lock-and-list-in-vmap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmap: remove needless lock and list in vmap
From: MinChan Kim <minchan.kim@gmail.com>

vmap's dirty_list is unused.  It's for optimizing flushing.  but Nick
didn't write the code yet.  so, we don't need it until time as it is
needed.

This patch removes vmap_block's dirty_list and codes related to it.

Signed-off-by: MinChan Kim <minchan.kim@gmail.com>
Acked-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   19 +++----------------
 1 file changed, 3 insertions(+), 16 deletions(-)

diff -puN mm/vmalloc.c~vmap-remove-needless-lock-and-list-in-vmap mm/vmalloc.c
--- a/mm/vmalloc.c~vmap-remove-needless-lock-and-list-in-vmap
+++ a/mm/vmalloc.c
@@ -671,10 +671,7 @@ struct vmap_block {
 	DECLARE_BITMAP(alloc_map, VMAP_BBMAP_BITS);
 	DECLARE_BITMAP(dirty_map, VMAP_BBMAP_BITS);
 	union {
-		struct {
-			struct list_head free_list;
-			struct list_head dirty_list;
-		};
+		struct list_head free_list;
 		struct rcu_head rcu_head;
 	};
 };
@@ -741,7 +738,6 @@ static struct vmap_block *new_vmap_block
 	bitmap_zero(vb->alloc_map, VMAP_BBMAP_BITS);
 	bitmap_zero(vb->dirty_map, VMAP_BBMAP_BITS);
 	INIT_LIST_HEAD(&vb->free_list);
-	INIT_LIST_HEAD(&vb->dirty_list);
 
 	vb_idx = addr_to_vb_idx(va->va_start);
 	spin_lock(&vmap_block_tree_lock);
@@ -772,12 +768,7 @@ static void free_vmap_block(struct vmap_
 	struct vmap_block *tmp;
 	unsigned long vb_idx;
 
-	spin_lock(&vb->vbq->lock);
-	if (!list_empty(&vb->free_list))
-		list_del(&vb->free_list);
-	if (!list_empty(&vb->dirty_list))
-		list_del(&vb->dirty_list);
-	spin_unlock(&vb->vbq->lock);
+	BUG_ON(!list_empty(&vb->free_list));
 
 	vb_idx = addr_to_vb_idx(vb->va->va_start);
 	spin_lock(&vmap_block_tree_lock);
@@ -862,11 +853,7 @@ static void vb_free(const void *addr, un
 
 	spin_lock(&vb->lock);
 	bitmap_allocate_region(vb->dirty_map, offset >> PAGE_SHIFT, order);
-	if (!vb->dirty) {
-		spin_lock(&vb->vbq->lock);
-		list_add(&vb->dirty_list, &vb->vbq->dirty);
-		spin_unlock(&vb->vbq->lock);
-	}
+
 	vb->dirty += 1UL << order;
 	if (vb->dirty == VMAP_BBMAP_BITS) {
 		BUG_ON(vb->free || !list_empty(&vb->free_list));
_

Patches currently in -mm which might be from minchan.kim@gmail.com are

origin.patch

