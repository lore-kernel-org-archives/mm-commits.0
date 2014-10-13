From: akpm@linux-foundation.org
Subject: [merged]
 mm-slab_common-move-kmem_cache-definition-to-internal-header.patch removed
 from -mm tree
Date: Mon, 13 Oct 2014 11:18:32 -0700
Message-ID: <543c1778.vzfyzSM526ig298n%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60098 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754102AbaJMSSc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Oct 2014 14:18:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, cl@linux.com, penberg@kernel.org, rdunlap@infradead.org, rientjes@google.com, zhangyanfei@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab_common: move kmem_cache definition to internal header
has been removed from the -mm tree.  Its filename was
     mm-slab_common-move-kmem_cache-definition-to-internal-header.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/slab_common: move kmem_cache definition to internal header

We don't need to keep kmem_cache definition in include/linux/slab.h if we
don't need to inline kmem_cache_size().  According to my code inspection,
this function is only called at lc_create() in lib/lru_cache.c which may
be called at initialization phase of something, so we don't need to inline
it.  Therfore, move it to slab_common.c and move kmem_cache definition to
internal header.

After this change, we can change kmem_cache definition easily without full
kernel build.  For instance, we can turn on/off CONFIG_SLUB_STATS without
full kernel build.

[akpm@linux-foundation.org: export kmem_cache_size() to modules]
[rdunlap@infradead.org: add header files to fix kmemcheck.c build errors]
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slab.h |   42 -----------------------------------------
 mm/kmemcheck.c       |    1 
 mm/slab.h            |   35 ++++++++++++++++++++++++++++++++++
 mm/slab_common.c     |    9 ++++++++
 4 files changed, 46 insertions(+), 41 deletions(-)

diff -puN include/linux/slab.h~mm-slab_common-move-kmem_cache-definition-to-internal-header include/linux/slab.h
--- a/include/linux/slab.h~mm-slab_common-move-kmem_cache-definition-to-internal-header
+++ a/include/linux/slab.h
@@ -158,31 +158,6 @@ size_t ksize(const void *);
 #define ARCH_KMALLOC_MINALIGN __alignof__(unsigned long long)
 #endif
 
-#ifdef CONFIG_SLOB
-/*
- * Common fields provided in kmem_cache by all slab allocators
- * This struct is either used directly by the allocator (SLOB)
- * or the allocator must include definitions for all fields
- * provided in kmem_cache_common in their definition of kmem_cache.
- *
- * Once we can do anonymous structs (C11 standard) we could put a
- * anonymous struct definition in these allocators so that the
- * separate allocations in the kmem_cache structure of SLAB and
- * SLUB is no longer needed.
- */
-struct kmem_cache {
-	unsigned int object_size;/* The original size of the object */
-	unsigned int size;	/* The aligned/padded/added on size  */
-	unsigned int align;	/* Alignment as calculated */
-	unsigned long flags;	/* Active flags on the slab */
-	const char *name;	/* Slab name for sysfs */
-	int refcount;		/* Use counter */
-	void (*ctor)(void *);	/* Called on object slot creation */
-	struct list_head list;	/* List of all slab caches on the system */
-};
-
-#endif /* CONFIG_SLOB */
-
 /*
  * Kmalloc array related definitions
  */
@@ -363,14 +338,6 @@ kmem_cache_alloc_node_trace(struct kmem_
 }
 #endif /* CONFIG_TRACING */
 
-#ifdef CONFIG_SLAB
-#include <linux/slab_def.h>
-#endif
-
-#ifdef CONFIG_SLUB
-#include <linux/slub_def.h>
-#endif
-
 extern void *kmalloc_order(size_t size, gfp_t flags, unsigned int order);
 
 #ifdef CONFIG_TRACING
@@ -650,14 +617,7 @@ static inline void *kzalloc_node(size_t
 	return kmalloc_node(size, flags | __GFP_ZERO, node);
 }
 
-/*
- * Determine the size of a slab object
- */
-static inline unsigned int kmem_cache_size(struct kmem_cache *s)
-{
-	return s->object_size;
-}
-
+unsigned int kmem_cache_size(struct kmem_cache *s);
 void __init kmem_cache_init_late(void);
 
 #endif	/* _LINUX_SLAB_H */
diff -puN mm/kmemcheck.c~mm-slab_common-move-kmem_cache-definition-to-internal-header mm/kmemcheck.c
--- a/mm/kmemcheck.c~mm-slab_common-move-kmem_cache-definition-to-internal-header
+++ a/mm/kmemcheck.c
@@ -2,6 +2,7 @@
 #include <linux/mm_types.h>
 #include <linux/mm.h>
 #include <linux/slab.h>
+#include "slab.h"
 #include <linux/kmemcheck.h>
 
 void kmemcheck_alloc_shadow(struct page *page, int order, gfp_t flags, int node)
diff -puN mm/slab.h~mm-slab_common-move-kmem_cache-definition-to-internal-header mm/slab.h
--- a/mm/slab.h~mm-slab_common-move-kmem_cache-definition-to-internal-header
+++ a/mm/slab.h
@@ -4,6 +4,41 @@
  * Internal slab definitions
  */
 
+#ifdef CONFIG_SLOB
+/*
+ * Common fields provided in kmem_cache by all slab allocators
+ * This struct is either used directly by the allocator (SLOB)
+ * or the allocator must include definitions for all fields
+ * provided in kmem_cache_common in their definition of kmem_cache.
+ *
+ * Once we can do anonymous structs (C11 standard) we could put a
+ * anonymous struct definition in these allocators so that the
+ * separate allocations in the kmem_cache structure of SLAB and
+ * SLUB is no longer needed.
+ */
+struct kmem_cache {
+	unsigned int object_size;/* The original size of the object */
+	unsigned int size;	/* The aligned/padded/added on size  */
+	unsigned int align;	/* Alignment as calculated */
+	unsigned long flags;	/* Active flags on the slab */
+	const char *name;	/* Slab name for sysfs */
+	int refcount;		/* Use counter */
+	void (*ctor)(void *);	/* Called on object slot creation */
+	struct list_head list;	/* List of all slab caches on the system */
+};
+
+#endif /* CONFIG_SLOB */
+
+#ifdef CONFIG_SLAB
+#include <linux/slab_def.h>
+#endif
+
+#ifdef CONFIG_SLUB
+#include <linux/slub_def.h>
+#endif
+
+#include <linux/memcontrol.h>
+
 /*
  * State of the slab allocator.
  *
diff -puN mm/slab_common.c~mm-slab_common-move-kmem_cache-definition-to-internal-header mm/slab_common.c
--- a/mm/slab_common.c~mm-slab_common-move-kmem_cache-definition-to-internal-header
+++ a/mm/slab_common.c
@@ -30,6 +30,15 @@ LIST_HEAD(slab_caches);
 DEFINE_MUTEX(slab_mutex);
 struct kmem_cache *kmem_cache;
 
+/*
+ * Determine the size of a slab object
+ */
+unsigned int kmem_cache_size(struct kmem_cache *s)
+{
+	return s->object_size;
+}
+EXPORT_SYMBOL(kmem_cache_size);
+
 #ifdef CONFIG_DEBUG_VM
 static int kmem_cache_sanity_check(const char *name, size_t size)
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

