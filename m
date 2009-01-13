From: akpm@linux-foundation.org
Subject: + vmap-remove-needless-lock-and-list-in-vmap.patch added to -mm tree
Date: Mon, 12 Jan 2009 16:42:59 -0800
Message-ID: <200901130042.n0D0gxgb014041@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44026 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752479AbZAMAnI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Jan 2009 19:43:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: minchan.kim@gmail.com, npiggin@suse.de


The patch titled
     vmap: remove needless lock and list in vmap
has been added to the -mm tree.  Its filename is
     vmap-remove-needless-lock-and-list-in-vmap.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -653,10 +653,7 @@ struct vmap_block {
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
@@ -723,7 +720,6 @@ static struct vmap_block *new_vmap_block
 	bitmap_zero(vb->alloc_map, VMAP_BBMAP_BITS);
 	bitmap_zero(vb->dirty_map, VMAP_BBMAP_BITS);
 	INIT_LIST_HEAD(&vb->free_list);
-	INIT_LIST_HEAD(&vb->dirty_list);
 
 	vb_idx = addr_to_vb_idx(va->va_start);
 	spin_lock(&vmap_block_tree_lock);
@@ -754,12 +750,7 @@ static void free_vmap_block(struct vmap_
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
@@ -844,11 +835,7 @@ static void vb_free(const void *addr, un
 
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

vmap-remove-needless-lock-and-list-in-vmap.patch

