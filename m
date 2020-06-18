From: akpm@linux-foundation.org
Subject: + vmalloc-convert-to-xarray.patch added to -mm tree
Date: Wed, 17 Jun 2020 18:34:02 -0700
Message-ID: <20200618013402.D9Sub%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:45426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733029AbgFRBeD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 17 Jun 2020 21:34:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, william.kucharski@oracle.com, willy@infradead.org


The patch titled
     Subject: vmalloc: convert to XArray
has been added to the -mm tree.  Its filename is
     vmalloc-convert-to-xarray.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/vmalloc-convert-to-xarray.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/vmalloc-convert-to-xarray.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: vmalloc: convert to XArray

The radix tree of vmap blocks is simpler to express as an XArray.  Reduces
both the text and data sizes of the object file and eliminates a user of
the radix tree preload API.

Link: http://lkml.kernel.org/r/20200603171448.5894-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: William Kucharski <william.kucharski@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   40 +++++++++++-----------------------------
 1 file changed, 11 insertions(+), 29 deletions(-)

--- a/mm/vmalloc.c~vmalloc-convert-to-xarray
+++ a/mm/vmalloc.c
@@ -25,7 +25,7 @@
 #include <linux/list.h>
 #include <linux/notifier.h>
 #include <linux/rbtree.h>
-#include <linux/radix-tree.h>
+#include <linux/xarray.h>
 #include <linux/rcupdate.h>
 #include <linux/pfn.h>
 #include <linux/kmemleak.h>
@@ -1514,12 +1514,11 @@ struct vmap_block {
 static DEFINE_PER_CPU(struct vmap_block_queue, vmap_block_queue);
 
 /*
- * Radix tree of vmap blocks, indexed by address, to quickly find a vmap block
+ * XArray of vmap blocks, indexed by address, to quickly find a vmap block
  * in the free path. Could get rid of this if we change the API to return a
  * "cookie" from alloc, to be passed to free. But no big deal yet.
  */
-static DEFINE_SPINLOCK(vmap_block_tree_lock);
-static RADIX_TREE(vmap_block_tree, GFP_ATOMIC);
+static DEFINE_XARRAY(vmap_blocks);
 
 /*
  * We should probably have a fallback mechanism to allocate virtual memory
@@ -1576,13 +1575,6 @@ static void *new_vmap_block(unsigned int
 		return ERR_CAST(va);
 	}
 
-	err = radix_tree_preload(gfp_mask);
-	if (unlikely(err)) {
-		kfree(vb);
-		free_vmap_area(va);
-		return ERR_PTR(err);
-	}
-
 	vaddr = vmap_block_vaddr(va->va_start, 0);
 	spin_lock_init(&vb->lock);
 	vb->va = va;
@@ -1595,11 +1587,12 @@ static void *new_vmap_block(unsigned int
 	INIT_LIST_HEAD(&vb->free_list);
 
 	vb_idx = addr_to_vb_idx(va->va_start);
-	spin_lock(&vmap_block_tree_lock);
-	err = radix_tree_insert(&vmap_block_tree, vb_idx, vb);
-	spin_unlock(&vmap_block_tree_lock);
-	BUG_ON(err);
-	radix_tree_preload_end();
+	err = xa_insert(&vmap_blocks, vb_idx, vb, gfp_mask);
+	if (err) {
+		kfree(vb);
+		free_vmap_area(va);
+		return ERR_PTR(err);
+	}
 
 	vbq = &get_cpu_var(vmap_block_queue);
 	spin_lock(&vbq->lock);
@@ -1613,12 +1606,8 @@ static void *new_vmap_block(unsigned int
 static void free_vmap_block(struct vmap_block *vb)
 {
 	struct vmap_block *tmp;
-	unsigned long vb_idx;
 
-	vb_idx = addr_to_vb_idx(vb->va->va_start);
-	spin_lock(&vmap_block_tree_lock);
-	tmp = radix_tree_delete(&vmap_block_tree, vb_idx);
-	spin_unlock(&vmap_block_tree_lock);
+	tmp = xa_erase(&vmap_blocks, addr_to_vb_idx(vb->va->va_start));
 	BUG_ON(tmp != vb);
 
 	free_vmap_area_noflush(vb->va);
@@ -1724,7 +1713,6 @@ static void *vb_alloc(unsigned long size
 static void vb_free(unsigned long addr, unsigned long size)
 {
 	unsigned long offset;
-	unsigned long vb_idx;
 	unsigned int order;
 	struct vmap_block *vb;
 
@@ -1734,14 +1722,8 @@ static void vb_free(unsigned long addr,
 	flush_cache_vunmap(addr, addr + size);
 
 	order = get_order(size);
-
 	offset = (addr & (VMAP_BLOCK_SIZE - 1)) >> PAGE_SHIFT;
