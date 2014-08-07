From: akpm@linux-foundation.org
Subject: [merged]
 mm-slub-slub_debug=n-use-the-same-alloc-free-hooks-as-for-slub_debug=y.patch removed from -mm tree
Date: Thu, 07 Aug 2014 13:03:01 -0700
Message-ID: <53e3db75.cXzMUUIx8mpJ6VqN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ie0-f201.google.com ([209.85.223.201]:51064 "EHLO
	mail-ie0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755191AbaHGUDC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:03:02 -0400
Received: by mail-ie0-f201.google.com with SMTP id tr6so841793ieb.2
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:03:01 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.ryabinin@samsung.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: slub: SLUB_DEBUG=n: use the same alloc/free hooks as for SLUB_DEBUG=y
has been removed from the -mm tree.  Its filename was
     mm-slub-slub_debug=n-use-the-same-alloc-free-hooks-as-for-slub_debug=y.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrey Ryabinin <a.ryabinin@samsung.com>
Subject: mm: slub: SLUB_DEBUG=n: use the same alloc/free hooks as for SLUB_DEBUG=y

There are two versions of alloc/free hooks now - one for
CONFIG_SLUB_DEBUG=y and another one for CONFIG_SLUB_DEBUG=n.

I see no reason why calls to other debugging subsystems (LOCKDEP,
DEBUG_ATOMIC_SLEEP, KMEMCHECK and FAILSLAB) are hidden under SLUB_DEBUG. 
All this features should work regardless of SLUB_DEBUG config, as all of
them already have own Kconfig options.

This also fixes failslab for CONFIG_SLUB_DEBUG=n configuration.  It simply
has not worked before because should_failslab() call was in a hook hidden
under "#ifdef CONFIG_SLUB_DEBUG #else".

Note: There is one concealed change in allocation path for SLUB_DEBUG=n
and all other debugging features disabled.  The might_sleep_if() call can
generate some code even if DEBUG_ATOMIC_SLEEP=n.  For PREEMPT_VOLUNTARY=y
might_sleep() inserts _cond_resched() call, but I think it should be ok.

Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   97 +++++++++++++++++++---------------------------------
 1 file changed, 36 insertions(+), 61 deletions(-)

diff -puN mm/slub.c~mm-slub-slub_debug=n-use-the-same-alloc-free-hooks-as-for-slub_debug=y mm/slub.c
--- a/mm/slub.c~mm-slub-slub_debug=n-use-the-same-alloc-free-hooks-as-for-slub_debug=y
+++ a/mm/slub.c
@@ -940,60 +940,6 @@ static void trace(struct kmem_cache *s,
 }
 
 /*
- * Hooks for other subsystems that check memory allocations. In a typical
- * production configuration these hooks all should produce no code at all.
- */
-static inline void kmalloc_large_node_hook(void *ptr, size_t size, gfp_t flags)
-{
-	kmemleak_alloc(ptr, size, 1, flags);
-}
-
-static inline void kfree_hook(const void *x)
-{
-	kmemleak_free(x);
-}
-
-static inline int slab_pre_alloc_hook(struct kmem_cache *s, gfp_t flags)
-{
-	flags &= gfp_allowed_mask;
-	lockdep_trace_alloc(flags);
-	might_sleep_if(flags & __GFP_WAIT);
-
-	return should_failslab(s->object_size, flags, s->flags);
-}
-
-static inline void slab_post_alloc_hook(struct kmem_cache *s,
-					gfp_t flags, void *object)
-{
-	flags &= gfp_allowed_mask;
-	kmemcheck_slab_alloc(s, flags, object, slab_ksize(s));
-	kmemleak_alloc_recursive(object, s->object_size, 1, s->flags, flags);
-}
-
-static inline void slab_free_hook(struct kmem_cache *s, void *x)
-{
-	kmemleak_free_recursive(x, s->flags);
-
-	/*
-	 * Trouble is that we may no longer disable interrupts in the fast path
-	 * So in order to make the debug calls that expect irqs to be
-	 * disabled we need to disable interrupts temporarily.
-	 */
-#if defined(CONFIG_KMEMCHECK) || defined(CONFIG_LOCKDEP)
-	{
-		unsigned long flags;
-
-		local_irq_save(flags);
-		kmemcheck_slab_free(s, x, s->object_size);
-		debug_check_no_locks_freed(x, s->object_size);
-		local_irq_restore(flags);
-	}
-#endif
-	if (!(s->flags & SLAB_DEBUG_OBJECTS))
-		debug_check_no_obj_freed(x, s->object_size);
-}
-
-/*
  * Tracking of fully allocated slabs for debugging purposes.
  */
 static void add_full(struct kmem_cache *s,
@@ -1277,6 +1223,12 @@ static inline void inc_slabs_node(struct
 static inline void dec_slabs_node(struct kmem_cache *s, int node,
 							int objects) {}
 
+#endif /* CONFIG_SLUB_DEBUG */
+
+/*
+ * Hooks for other subsystems that check memory allocations. In a typical
+ * production configuration these hooks all should produce no code at all.
+ */
 static inline void kmalloc_large_node_hook(void *ptr, size_t size, gfp_t flags)
 {
 	kmemleak_alloc(ptr, size, 1, flags);
@@ -1288,21 +1240,44 @@ static inline void kfree_hook(const void
 }
 
 static inline int slab_pre_alloc_hook(struct kmem_cache *s, gfp_t flags)
-							{ return 0; }
+{
+	flags &= gfp_allowed_mask;
+	lockdep_trace_alloc(flags);
+	might_sleep_if(flags & __GFP_WAIT);
 
-static inline void slab_post_alloc_hook(struct kmem_cache *s, gfp_t flags,
-		void *object)
+	return should_failslab(s->object_size, flags, s->flags);
+}
+
+static inline void slab_post_alloc_hook(struct kmem_cache *s,
+					gfp_t flags, void *object)
 {
-	kmemleak_alloc_recursive(object, s->object_size, 1, s->flags,
-		flags & gfp_allowed_mask);
+	flags &= gfp_allowed_mask;
+	kmemcheck_slab_alloc(s, flags, object, slab_ksize(s));
+	kmemleak_alloc_recursive(object, s->object_size, 1, s->flags, flags);
 }
 
 static inline void slab_free_hook(struct kmem_cache *s, void *x)
 {
 	kmemleak_free_recursive(x, s->flags);
-}
 
-#endif /* CONFIG_SLUB_DEBUG */
+	/*
+	 * Trouble is that we may no longer disable interrupts in the fast path
+	 * So in order to make the debug calls that expect irqs to be
+	 * disabled we need to disable interrupts temporarily.
+	 */
+#if defined(CONFIG_KMEMCHECK) || defined(CONFIG_LOCKDEP)
+	{
+		unsigned long flags;
+
+		local_irq_save(flags);
+		kmemcheck_slab_free(s, x, s->object_size);
+		debug_check_no_locks_freed(x, s->object_size);
+		local_irq_restore(flags);
+	}
+#endif
+	if (!(s->flags & SLAB_DEBUG_OBJECTS))
+		debug_check_no_obj_freed(x, s->object_size);
+}
 
 /*
  * Slab allocation and freeing
_

Patches currently in -mm which might be from a.ryabinin@samsung.com are

origin.patch
lib-idr-fix-out-of-bounds-pointer-dereference.patch

