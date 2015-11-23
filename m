From: akpm@linux-foundation.org
Subject: [merged]
 slub-create-new-___slab_alloc-function-that-can-be-called-with-irqs-disabled.patch removed from -mm tree
Date: Mon, 23 Nov 2015 12:15:28 -0800
Message-ID: <565373e0.AqE/wG18D5tW1uxD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53624 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753661AbbKWUP2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Nov 2015 15:15:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cl@linux.com, alexander.h.duyck@redhat.com, brouer@redhat.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slub: create new ___slab_alloc function that can be called with irqs disabled
has been removed from the -mm tree.  Its filename was
     slub-create-new-___slab_alloc-function-that-can-be-called-with-irqs-disabled.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christoph Lameter <cl@linux.com>
Subject: slub: create new ___slab_alloc function that can be called with irqs disabled

Bulk alloc needs a function like that because it enables interrupts before
calling __slab_alloc which promptly disables them again using the expensive
local_irq_save().

Signed-off-by: Christoph Lameter <cl@linux.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Alexander Duyck <alexander.h.duyck@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   44 +++++++++++++++++++++++++++++---------------
 1 file changed, 29 insertions(+), 15 deletions(-)

diff -puN mm/slub.c~slub-create-new-___slab_alloc-function-that-can-be-called-with-irqs-disabled mm/slub.c
--- a/mm/slub.c~slub-create-new-___slab_alloc-function-that-can-be-called-with-irqs-disabled
+++ a/mm/slub.c
@@ -2295,23 +2295,15 @@ static inline void *get_freelist(struct
  * And if we were unable to get a new slab from the partial slab lists then
  * we need to allocate a new slab. This is the slowest path since it involves
  * a call to the page allocator and the setup of a new slab.
+ *
+ * Version of __slab_alloc to use when we know that interrupts are
+ * already disabled (which is the case for bulk allocation).
  */
-static void *__slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
+static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
 			  unsigned long addr, struct kmem_cache_cpu *c)
 {
 	void *freelist;
 	struct page *page;
-	unsigned long flags;
-
-	local_irq_save(flags);
-#ifdef CONFIG_PREEMPT
-	/*
-	 * We may have been preempted and rescheduled on a different
-	 * cpu before disabling interrupts. Need to reload cpu area
-	 * pointer.
-	 */
-	c = this_cpu_ptr(s->cpu_slab);
-#endif
 
 	page = c->page;
 	if (!page)
@@ -2369,7 +2361,6 @@ load_freelist:
 	VM_BUG_ON(!c->page->frozen);
 	c->freelist = get_freepointer(s, freelist);
 	c->tid = next_tid(c->tid);
-	local_irq_restore(flags);
 	return freelist;
 
 new_slab:
@@ -2386,7 +2377,6 @@ new_slab:
 
 	if (unlikely(!freelist)) {
 		slab_out_of_memory(s, gfpflags, node);
-		local_irq_restore(flags);
 		return NULL;
 	}
 
@@ -2402,11 +2392,35 @@ new_slab:
 	deactivate_slab(s, page, get_freepointer(s, freelist));
 	c->page = NULL;
 	c->freelist = NULL;
-	local_irq_restore(flags);
 	return freelist;
 }
 
 /*
+ * Another one that disabled interrupt and compensates for possible
+ * cpu changes by refetching the per cpu area pointer.
+ */
+static void *__slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
+			  unsigned long addr, struct kmem_cache_cpu *c)
+{
+	void *p;
+	unsigned long flags;
+
+	local_irq_save(flags);
+#ifdef CONFIG_PREEMPT
+	/*
+	 * We may have been preempted and rescheduled on a different
+	 * cpu before disabling interrupts. Need to reload cpu area
+	 * pointer.
+	 */
+	c = this_cpu_ptr(s->cpu_slab);
+#endif
+
+	p = ___slab_alloc(s, gfpflags, node, addr, c);
+	local_irq_restore(flags);
+	return p;
+}
+
+/*
  * Inlined fastpath so that allocation functions (kmalloc, kmem_cache_alloc)
  * have the fastpath folded into their functions. So no function call
  * overhead for requests that can be satisfied on the fastpath.
_

Patches currently in -mm which might be from cl@linux.com are


