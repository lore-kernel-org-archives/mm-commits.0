From: akpm@linux-foundation.org
Subject: [merged]
 mm-slb-always-track-caller-in-kmalloc_node_track_caller.patch removed from
 -mm tree
Date: Mon, 13 Oct 2014 11:18:34 -0700
Message-ID: <543c177a.sgoinE94fcgayYFT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60106 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754102AbaJMSSe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Oct 2014 14:18:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, cl@linux.com, penberg@kernel.org, rientjes@google.com, zhangyanfei@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/sl[ao]b: always track caller in kmalloc_(node_)track_caller()
has been removed from the -mm tree.  Its filename was
     mm-slb-always-track-caller-in-kmalloc_node_track_caller.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/sl[ao]b: always track caller in kmalloc_(node_)track_caller()

Now, we track caller if tracing or slab debugging is enabled.  If they are
disabled, we could save one argument passing overhead by calling
__kmalloc(_node)().  But, I think that it would be marginal.  Furthermore,
default slab allocator, SLUB, doesn't use this technique so I think that
it's okay to change this situation.

After this change, we can turn on/off CONFIG_DEBUG_SLAB without full
kernel build and remove some complicated '#if' defintion.  It looks more
benefitial to me.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slab.h |   22 ----------------------
 mm/slab.c            |   18 ------------------
 mm/slob.c            |    2 --
 3 files changed, 42 deletions(-)

diff -puN include/linux/slab.h~mm-slb-always-track-caller-in-kmalloc_node_track_caller include/linux/slab.h
--- a/include/linux/slab.h~mm-slb-always-track-caller-in-kmalloc_node_track_caller
+++ a/include/linux/slab.h
@@ -549,37 +549,15 @@ static inline void *kcalloc(size_t n, si
  * allocator where we care about the real place the memory allocation
  * request comes from.
  */
-#if defined(CONFIG_DEBUG_SLAB) || defined(CONFIG_SLUB) || \
-	(defined(CONFIG_SLAB) && defined(CONFIG_TRACING)) || \
-	(defined(CONFIG_SLOB) && defined(CONFIG_TRACING))
 extern void *__kmalloc_track_caller(size_t, gfp_t, unsigned long);
 #define kmalloc_track_caller(size, flags) \
 	__kmalloc_track_caller(size, flags, _RET_IP_)
-#else
-#define kmalloc_track_caller(size, flags) \
-	__kmalloc(size, flags)
-#endif /* DEBUG_SLAB */
 
 #ifdef CONFIG_NUMA
-/*
- * kmalloc_node_track_caller is a special version of kmalloc_node that
- * records the calling function of the routine calling it for slab leak
- * tracking instead of just the calling function (confusing, eh?).
- * It's useful when the call to kmalloc_node comes from a widely-used
- * standard allocator where we care about the real place the memory
- * allocation request comes from.
- */
-#if defined(CONFIG_DEBUG_SLAB) || defined(CONFIG_SLUB) || \
-	(defined(CONFIG_SLAB) && defined(CONFIG_TRACING)) || \
-	(defined(CONFIG_SLOB) && defined(CONFIG_TRACING))
 extern void *__kmalloc_node_track_caller(size_t, gfp_t, int, unsigned long);
 #define kmalloc_node_track_caller(size, flags, node) \
 	__kmalloc_node_track_caller(size, flags, node, \
 			_RET_IP_)
-#else
-#define kmalloc_node_track_caller(size, flags, node) \
-	__kmalloc_node(size, flags, node)
-#endif
 
 #else /* CONFIG_NUMA */
 
diff -puN mm/slab.c~mm-slb-always-track-caller-in-kmalloc_node_track_caller mm/slab.c
--- a/mm/slab.c~mm-slb-always-track-caller-in-kmalloc_node_track_caller
+++ a/mm/slab.c
@@ -3496,7 +3496,6 @@ __do_kmalloc_node(size_t size, gfp_t fla
 	return kmem_cache_alloc_node_trace(cachep, flags, node, size);
 }
 
-#if defined(CONFIG_DEBUG_SLAB) || defined(CONFIG_TRACING)
 void *__kmalloc_node(size_t size, gfp_t flags, int node)
 {
 	return __do_kmalloc_node(size, flags, node, _RET_IP_);
@@ -3509,13 +3508,6 @@ void *__kmalloc_node_track_caller(size_t
 	return __do_kmalloc_node(size, flags, node, caller);
 }
 EXPORT_SYMBOL(__kmalloc_node_track_caller);
-#else
-void *__kmalloc_node(size_t size, gfp_t flags, int node)
-{
-	return __do_kmalloc_node(size, flags, node, 0);
-}
-EXPORT_SYMBOL(__kmalloc_node);
-#endif /* CONFIG_DEBUG_SLAB || CONFIG_TRACING */
 #endif /* CONFIG_NUMA */
 
 /**
@@ -3541,8 +3533,6 @@ static __always_inline void *__do_kmallo
 	return ret;
 }
 
-
-#if defined(CONFIG_DEBUG_SLAB) || defined(CONFIG_TRACING)
 void *__kmalloc(size_t size, gfp_t flags)
 {
 	return __do_kmalloc(size, flags, _RET_IP_);
@@ -3555,14 +3545,6 @@ void *__kmalloc_track_caller(size_t size
 }
 EXPORT_SYMBOL(__kmalloc_track_caller);
 
-#else
-void *__kmalloc(size_t size, gfp_t flags)
-{
-	return __do_kmalloc(size, flags, 0);
-}
-EXPORT_SYMBOL(__kmalloc);
-#endif
-
 /**
  * kmem_cache_free - Deallocate an object
  * @cachep: The cache the allocation was from.
diff -puN mm/slob.c~mm-slb-always-track-caller-in-kmalloc_node_track_caller mm/slob.c
--- a/mm/slob.c~mm-slb-always-track-caller-in-kmalloc_node_track_caller
+++ a/mm/slob.c
@@ -468,7 +468,6 @@ void *__kmalloc(size_t size, gfp_t gfp)
 }
 EXPORT_SYMBOL(__kmalloc);
 
-#ifdef CONFIG_TRACING
 void *__kmalloc_track_caller(size_t size, gfp_t gfp, unsigned long caller)
 {
 	return __do_kmalloc_node(size, gfp, NUMA_NO_NODE, caller);
@@ -481,7 +480,6 @@ void *__kmalloc_node_track_caller(size_t
 	return __do_kmalloc_node(size, gfp, node, caller);
 }
 #endif
-#endif
 
 void kfree(const void *block)
 {
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

origin.patch
drivers-dma-coherent-add-initialization-from-device-tree.patch
drivers-dma-coherent-add-initialization-from-device-tree-fix.patch
drivers-dma-coherent-add-initialization-from-device-tree-fix-fix.patch
drivers-dma-coherent-add-initialization-from-device-tree-checkpatch-fixes.patch
drivers-dma-contiguous-add-initialization-from-device-tree.patch
page-owners-correct-page-order-when-to-free-page.patch

