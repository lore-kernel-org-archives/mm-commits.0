From: akpm@linux-foundation.org
Subject: [merged] slub-fix-kmem-cgroup-bug-in-kmem_cache_alloc_bulk.patch
 removed from -mm tree
Date: Mon, 23 Nov 2015 12:15:42 -0800
Message-ID: <565373ee.M1O0SYjhk4SvgIQO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53652 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753567AbbKWUPn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Nov 2015 15:15:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: brouer@redhat.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slub: fix kmem cgroup bug in kmem_cache_alloc_bulk
has been removed from the -mm tree.  Its filename was
     slub-fix-kmem-cgroup-bug-in-kmem_cache_alloc_bulk.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jesper Dangaard Brouer <brouer@redhat.com>
Subject: slub: fix kmem cgroup bug in kmem_cache_alloc_bulk

The call slab_pre_alloc_hook() interacts with kmemgc and is not allowed to
be called several times inside the bulk alloc for loop, due to the call to
memcg_kmem_get_cache().

This would result in hitting the VM_BUG_ON in __memcg_kmem_get_cache.

As suggested by Vladimir Davydov, change slab_post_alloc_hook() to be able
to handle an array of objects.

A subtle detail is, loop iterator "i" in slab_post_alloc_hook() must have
same type (size_t) as size argument.  This helps the compiler to easier
realize that it can remove the loop, when all debug statements inside loop
evaluates to nothing.  Note, this is only an issue because the kernel is
compiled with GCC option: -fno-strict-overflow

In slab_alloc_node() the compiler inlines and optimizes the invocation of
slab_post_alloc_hook(s, flags, 1, &object) by removing the loop and access
object directly.

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Reported-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Suggested-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Reviewed-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   40 ++++++++++++++++++++++------------------
 1 file changed, 22 insertions(+), 18 deletions(-)

diff -puN mm/slub.c~slub-fix-kmem-cgroup-bug-in-kmem_cache_alloc_bulk mm/slub.c
--- a/mm/slub.c~slub-fix-kmem-cgroup-bug-in-kmem_cache_alloc_bulk
+++ a/mm/slub.c
@@ -1292,14 +1292,21 @@ static inline struct kmem_cache *slab_pr
 	return memcg_kmem_get_cache(s, flags);
 }
 
-static inline void slab_post_alloc_hook(struct kmem_cache *s,
-					gfp_t flags, void *object)
+static inline void slab_post_alloc_hook(struct kmem_cache *s, gfp_t flags,
+					size_t size, void **p)
 {
+	size_t i;
+
 	flags &= gfp_allowed_mask;
-	kmemcheck_slab_alloc(s, flags, object, slab_ksize(s));
-	kmemleak_alloc_recursive(object, s->object_size, 1, s->flags, flags);
+	for (i = 0; i < size; i++) {
+		void *object = p[i];
+
+		kmemcheck_slab_alloc(s, flags, object, slab_ksize(s));
+		kmemleak_alloc_recursive(object, s->object_size, 1,
+					 s->flags, flags);
+		kasan_slab_alloc(s, object);
+	}
 	memcg_kmem_put_cache(s);
-	kasan_slab_alloc(s, object);
 }
 
 static inline void slab_free_hook(struct kmem_cache *s, void *x)
@@ -2475,7 +2482,7 @@ static void *__slab_alloc(struct kmem_ca
 static __always_inline void *slab_alloc_node(struct kmem_cache *s,
 		gfp_t gfpflags, int node, unsigned long addr)
 {
-	void **object;
+	void *object;
 	struct kmem_cache_cpu *c;
 	struct page *page;
 	unsigned long tid;
@@ -2554,7 +2561,7 @@ redo:
 	if (unlikely(gfpflags & __GFP_ZERO) && object)
 		memset(object, 0, s->object_size);
 
-	slab_post_alloc_hook(s, gfpflags, object);
+	slab_post_alloc_hook(s, gfpflags, 1, &object);
 
 	return object;
 }
@@ -2904,6 +2911,10 @@ bool kmem_cache_alloc_bulk(struct kmem_c
 	struct kmem_cache_cpu *c;
 	int i;
 
+	/* memcg and kmem_cache debug support */
+	s = slab_pre_alloc_hook(s, flags);
+	if (unlikely(!s))
+		return false;
 	/*
 	 * Drain objects in the per cpu slab, while disabling local
 	 * IRQs, which protects against PREEMPT and interrupts
@@ -2928,17 +2939,8 @@ bool kmem_cache_alloc_bulk(struct kmem_c
 			c = this_cpu_ptr(s->cpu_slab);
 			continue; /* goto for-loop */
 		}
-
-		/* kmem_cache debug support */
-		s = slab_pre_alloc_hook(s, flags);
-		if (unlikely(!s))
-			goto error;
-
 		c->freelist = get_freepointer(s, object);
 		p[i] = object;
-
-		/* kmem_cache debug support */
-		slab_post_alloc_hook(s, flags, object);
 	}
 	c->tid = next_tid(c->tid);
 	local_irq_enable();
@@ -2951,11 +2953,13 @@ bool kmem_cache_alloc_bulk(struct kmem_c
 			memset(p[j], 0, s->object_size);
 	}
 
+	/* memcg and kmem_cache debug support */
+	slab_post_alloc_hook(s, flags, size, p);
 	return true;
