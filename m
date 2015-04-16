From: akpm@linux-foundation.org
Subject: [merged]
 mm-vmalloc-occupy-newly-allocated-vmap-block-just-after-allocation.patch
 removed from -mm tree
Date: Thu, 16 Apr 2015 09:51:58 -0700
Message-ID: <552fe8ae.er8vT2Slr/zFhBpU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42699 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613AbbDPQq3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Apr 2015 12:46:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: r.peniaev@gmail.com, akpm@linux-foundation.org, chaowang@redhat.com, cl@linux.com, edumazet@google.com, fabf@skynet.be, gioh.kim@lge.com, iamjoonsoo.kim@lge.com, rientjes@google.com, rob.jones@codethink.co.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc: occupy newly allocated vmap block just after allocation
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-occupy-newly-allocated-vmap-block-just-after-allocation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Roman Pen <r.peniaev@gmail.com>
Subject: mm/vmalloc: occupy newly allocated vmap block just after allocation

Previous implementation allocates new vmap block and repeats search of a
free block from the very beginning, iterating over the CPU free list.

Why it can be better??

1. Allocation can happen on one CPU, but search can be done on another CPU.
   In worst case we preallocate amount of vmap blocks which is equal to
   CPU number on the system.

2. In previous patch I added newly allocated block to the tail of free list
   to avoid soon exhaustion of virtual space and give a chance to occupy
   blocks which were allocated long time ago.  Thus to find newly allocated
   block all the search sequence should be repeated, seems it is not efficient.

In this patch newly allocated block is occupied right away, address of
virtual space is returned to the caller, so there is no any need to repeat
the search sequence, allocation job is done.

Signed-off-by: Roman Pen <r.peniaev@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Eric Dumazet <edumazet@google.com>
Acked-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: David Rientjes <rientjes@google.com>
Cc: WANG Chao <chaowang@redhat.com>
Cc: Fabian Frederick <fabf@skynet.be>
Cc: Christoph Lameter <cl@linux.com>
Cc: Gioh Kim <gioh.kim@lge.com>
Cc: Rob Jones <rob.jones@codethink.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   58 +++++++++++++++++++++++++++++++------------------
 1 file changed, 37 insertions(+), 21 deletions(-)

diff -puN mm/vmalloc.c~mm-vmalloc-occupy-newly-allocated-vmap-block-just-after-allocation mm/vmalloc.c
--- a/mm/vmalloc.c~mm-vmalloc-occupy-newly-allocated-vmap-block-just-after-allocation
+++ a/mm/vmalloc.c
@@ -796,13 +796,31 @@ static unsigned long addr_to_vb_idx(unsi
 	return addr;
 }
 
-static struct vmap_block *new_vmap_block(gfp_t gfp_mask)
+static void *vmap_block_vaddr(unsigned long va_start, unsigned long pages_off)
+{
+	unsigned long addr;
+
+	addr = va_start + (pages_off << PAGE_SHIFT);
+	BUG_ON(addr_to_vb_idx(addr) != addr_to_vb_idx(va_start));
+	return (void *)addr;
+}
+
+/**
+ * new_vmap_block - allocates new vmap_block and occupies 2^order pages in this
+ *                  block. Of course pages number can't exceed VMAP_BBMAP_BITS
+ * @order:    how many 2^order pages should be occupied in newly allocated block
+ * @gfp_mask: flags for the page level allocator
+ *
+ * Returns: virtual address in a newly allocated block or ERR_PTR(-errno)
+ */
+static void *new_vmap_block(unsigned int order, gfp_t gfp_mask)
 {
 	struct vmap_block_queue *vbq;
 	struct vmap_block *vb;
 	struct vmap_area *va;
 	unsigned long vb_idx;
 	int node, err;
+	void *vaddr;
 
 	node = numa_node_id();
 
@@ -826,9 +844,12 @@ static struct vmap_block *new_vmap_block
 		return ERR_PTR(err);
 	}
 
+	vaddr = vmap_block_vaddr(va->va_start, 0);
 	spin_lock_init(&vb->lock);
 	vb->va = va;
-	vb->free = VMAP_BBMAP_BITS;
+	/* At least something should be left free */
+	BUG_ON(VMAP_BBMAP_BITS <= (1UL << order));
+	vb->free = VMAP_BBMAP_BITS - (1UL << order);
 	vb->dirty = 0;
 	bitmap_zero(vb->dirty_map, VMAP_BBMAP_BITS);
 	INIT_LIST_HEAD(&vb->free_list);
@@ -846,7 +867,7 @@ static struct vmap_block *new_vmap_block
 	spin_unlock(&vbq->lock);
 	put_cpu_var(vmap_block_queue);
 
-	return vb;
+	return vaddr;
 }
 
 static void free_vmap_block(struct vmap_block *vb)
@@ -910,7 +931,7 @@ static void *vb_alloc(unsigned long size
 {
 	struct vmap_block_queue *vbq;
 	struct vmap_block *vb;
-	unsigned long addr = 0;
+	void *vaddr = NULL;
 	unsigned int order;
 
 	BUG_ON(size & ~PAGE_MASK);
@@ -925,43 +946,38 @@ static void *vb_alloc(unsigned long size
 	}
 	order = get_order(size);
 
-again:
 	rcu_read_lock();
 	vbq = &get_cpu_var(vmap_block_queue);
 	list_for_each_entry_rcu(vb, &vbq->free, free_list) {
-		int i;
+		unsigned long pages_off;
 
 		spin_lock(&vb->lock);
-		if (vb->free < 1UL << order)
-			goto next;
+		if (vb->free < (1UL << order)) {
+			spin_unlock(&vb->lock);
+			continue;
+		}
 
-		i = VMAP_BBMAP_BITS - vb->free;
-		addr = vb->va->va_start + (i << PAGE_SHIFT);
-		BUG_ON(addr_to_vb_idx(addr) !=
-				addr_to_vb_idx(vb->va->va_start));
+		pages_off = VMAP_BBMAP_BITS - vb->free;
+		vaddr = vmap_block_vaddr(vb->va->va_start, pages_off);
 		vb->free -= 1UL << order;
 		if (vb->free == 0) {
 			spin_lock(&vbq->lock);
 			list_del_rcu(&vb->free_list);
 			spin_unlock(&vbq->lock);
 		}
+
 		spin_unlock(&vb->lock);
 		break;
-next:
-		spin_unlock(&vb->lock);
 	}
 
 	put_cpu_var(vmap_block_queue);
 	rcu_read_unlock();
 
-	if (!addr) {
-		vb = new_vmap_block(gfp_mask);
-		if (IS_ERR(vb))
-			return vb;
-		goto again;
-	}
+	/* Allocate new block if nothing was found */
+	if (!vaddr)
+		vaddr = new_vmap_block(order, gfp_mask);
 
-	return (void *)addr;
+	return vaddr;
 }
 
 static void vb_free(const void *addr, unsigned long size)
_

Patches currently in -mm which might be from r.peniaev@gmail.com are

origin.patch
fs-mpagec-forgotten-write_sync-in-case-of-data-integrity-write.patch

