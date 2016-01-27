From: akpm@linux-foundation.org
Subject: + mm-slab-move-slub-alloc-hooks-to-common-mm-slabh.patch added to -mm tree
Date: Tue, 26 Jan 2016 19:29:06 -0800
Message-ID: <56a83982.lxETvOJ9K3IbbXsa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55751 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269AbcA0D3H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jan 2016 22:29:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: brouer@redhat.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab: move SLUB alloc hooks to common mm/slab.h
has been added to the -mm tree.  Its filename is
     mm-slab-move-slub-alloc-hooks-to-common-mm-slabh.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slab-move-slub-alloc-hooks-to-common-mm-slabh.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-slab-move-slub-alloc-hooks-to-common-mm-slabh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jesper Dangaard Brouer <brouer@redhat.com>
Subject: mm/slab: move SLUB alloc hooks to common mm/slab.h

First step towards sharing alloc_hook's between SLUB and SLAB allocators. 
Move the SLUB allocators *_alloc_hook to the common mm/slab.h for internal
slab definitions.

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.h |   62 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 mm/slub.c |   54 ---------------------------------------------
 2 files changed, 62 insertions(+), 54 deletions(-)

diff -puN mm/slab.h~mm-slab-move-slub-alloc-hooks-to-common-mm-slabh mm/slab.h
--- a/mm/slab.h~mm-slab-move-slub-alloc-hooks-to-common-mm-slabh
+++ a/mm/slab.h
@@ -38,6 +38,10 @@ struct kmem_cache {
 #endif
 
 #include <linux/memcontrol.h>
+#include <linux/fault-inject.h>
+#include <linux/kmemcheck.h>
+#include <linux/kasan.h>
+#include <linux/kmemleak.h>
 
 /*
  * State of the slab allocator.
@@ -320,6 +324,64 @@ static inline struct kmem_cache *cache_f
 	return s;
 }
 
+static inline size_t slab_ksize(const struct kmem_cache *s)
+{
+#ifndef CONFIG_SLUB
+	return s->object_size;
+
+#else /* CONFIG_SLUB */
+# ifdef CONFIG_SLUB_DEBUG
+	/*
+	 * Debugging requires use of the padding between object
+	 * and whatever may come after it.
+	 */
+	if (s->flags & (SLAB_RED_ZONE | SLAB_POISON))
+		return s->object_size;
+# endif
+	/*
+	 * If we have the need to store the freelist pointer
+	 * back there or track user information then we can
+	 * only use the space before that information.
+	 */
+	if (s->flags & (SLAB_DESTROY_BY_RCU | SLAB_STORE_USER))
+		return s->inuse;
+	/*
+	 * Else we can use all the padding etc for the allocation
+	 */
+	return s->size;
+#endif
+}
+
+static inline struct kmem_cache *slab_pre_alloc_hook(struct kmem_cache *s,
+						     gfp_t flags)
+{
+	flags &= gfp_allowed_mask;
+	lockdep_trace_alloc(flags);
+	might_sleep_if(gfpflags_allow_blocking(flags));
+
+	if (should_failslab(s->object_size, flags, s->flags))
+		return NULL;
+
+	return memcg_kmem_get_cache(s, flags);
+}
+
+static inline void slab_post_alloc_hook(struct kmem_cache *s, gfp_t flags,
+					size_t size, void **p)
+{
+	size_t i;
+
+	flags &= gfp_allowed_mask;
+	for (i = 0; i < size; i++) {
+		void *object = p[i];
+
+		kmemcheck_slab_alloc(s, flags, object, slab_ksize(s));
+		kmemleak_alloc_recursive(object, s->object_size, 1,
+					 s->flags, flags);
+		kasan_slab_alloc(s, object);
+	}
+	memcg_kmem_put_cache(s);
+}
+
 #ifndef CONFIG_SLOB
 /*
  * The slab lists for all objects.
diff -puN mm/slub.c~mm-slab-move-slub-alloc-hooks-to-common-mm-slabh mm/slub.c
--- a/mm/slub.c~mm-slab-move-slub-alloc-hooks-to-common-mm-slabh
+++ a/mm/slub.c
@@ -284,30 +284,6 @@ static inline int slab_index(void *p, st
 	return (p - addr) / s->size;
 }
 
-static inline size_t slab_ksize(const struct kmem_cache *s)
-{
-#ifdef CONFIG_SLUB_DEBUG
-	/*
-	 * Debugging requires use of the padding between object
-	 * and whatever may come after it.
-	 */
-	if (s->flags & (SLAB_RED_ZONE | SLAB_POISON))
-		return s->object_size;
-
-#endif
-	/*
-	 * If we have the need to store the freelist pointer
-	 * back there or track user information then we can
-	 * only use the space before that information.
-	 */
-	if (s->flags & (SLAB_DESTROY_BY_RCU | SLAB_STORE_USER))
-		return s->inuse;
-	/*
-	 * Else we can use all the padding etc for the allocation
-	 */
-	return s->size;
-}
-
 static inline int order_objects(int order, unsigned long size, int reserved)
 {
 	return ((PAGE_SIZE << order) - reserved) / size;
@@ -1281,36 +1257,6 @@ static inline void kfree_hook(const void
 	kasan_kfree_large(x);
 }
 
-static inline struct kmem_cache *slab_pre_alloc_hook(struct kmem_cache *s,
-						     gfp_t flags)
-{
-	flags &= gfp_allowed_mask;
-	lockdep_trace_alloc(flags);
-	might_sleep_if(gfpflags_allow_blocking(flags));
-
-	if (should_failslab(s->object_size, flags, s->flags))
-		return NULL;
-
-	return memcg_kmem_get_cache(s, flags);
-}
-
-static inline void slab_post_alloc_hook(struct kmem_cache *s, gfp_t flags,
-					size_t size, void **p)
-{
-	size_t i;
-
-	flags &= gfp_allowed_mask;
-	for (i = 0; i < size; i++) {
-		void *object = p[i];
-
-		kmemcheck_slab_alloc(s, flags, object, slab_ksize(s));
-		kmemleak_alloc_recursive(object, s->object_size, 1,
-					 s->flags, flags);
-		kasan_slab_alloc(s, object);
-	}
-	memcg_kmem_put_cache(s);
-}
