From: akpm@linux-foundation.org
Subject: +
 mm-slab_common-move-kmem_cache-definition-to-internal-header.patch added to -mm tree
Date: Tue, 26 Aug 2014 16:17:09 -0700
Message-ID: <53fd1575.rZQD7SpXF0WQQZDQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oa0-f74.google.com ([209.85.219.74]:63866 "EHLO
	mail-oa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752275AbaHZXRK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Aug 2014 19:17:10 -0400
Received: by mail-oa0-f74.google.com with SMTP id eb12so3054336oac.3
        for <mm-commits@vger.kernel.org>; Tue, 26 Aug 2014 16:17:10 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, cl@linux.com, penberg@kernel.org, rientjes@google.com, zhangyanfei@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab_common: move kmem_cache definition to internal header
has been added to the -mm tree.  Its filename is
     mm-slab_common-move-kmem_cache-definition-to-internal-header.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slab_common-move-kmem_cache-definition-to-internal-header.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-slab_common-move-kmem_cache-definition-to-internal-header.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slab.h |   42 -----------------------------------------
 mm/slab.h            |   33 ++++++++++++++++++++++++++++++++
 mm/slab_common.c     |    8 +++++++
 3 files changed, 42 insertions(+), 41 deletions(-)

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
diff -puN mm/slab.h~mm-slab_common-move-kmem_cache-definition-to-internal-header mm/slab.h
--- a/mm/slab.h~mm-slab_common-move-kmem_cache-definition-to-internal-header
+++ a/mm/slab.h
@@ -4,6 +4,39 @@
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
 /*
  * State of the slab allocator.
  *
diff -puN mm/slab_common.c~mm-slab_common-move-kmem_cache-definition-to-internal-header mm/slab_common.c
--- a/mm/slab_common.c~mm-slab_common-move-kmem_cache-definition-to-internal-header
+++ a/mm/slab_common.c
@@ -30,6 +30,14 @@ LIST_HEAD(slab_caches);
 DEFINE_MUTEX(slab_mutex);
 struct kmem_cache *kmem_cache;
 
+/*
+ * Determine the size of a slab object
+ */
+unsigned int kmem_cache_size(struct kmem_cache *s)
+{
+	return s->object_size;
+}
+
 #ifdef CONFIG_DEBUG_VM
 static int kmem_cache_sanity_check(const char *name, size_t size)
 {
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

mm-slab_commonc-suppress-warning.patch
mm-cma-adjust-address-limit-to-avoid-hitting-low-high-memory-boundary.patch
arm-mm-dont-limit-default-cma-region-only-to-low-memory.patch
mm-slab_common-move-kmem_cache-definition-to-internal-header.patch
mm-slb-always-track-caller-in-kmalloc_node_track_caller.patch
mm-slab-move-cache_flusharray-out-of-unlikelytext-section.patch
mm-slab-noinline-__ac_put_obj.patch
mm-slab-factor-out-unlikely-part-of-cache_free_alien.patch
mm-page_alloc-determine-migratetype-only-once.patch
mm-thp-dont-hold-mmap_sem-in-khugepaged-when-allocating-thp.patch
mm-compaction-defer-each-zone-individually-instead-of-preferred-zone.patch
mm-compaction-defer-each-zone-individually-instead-of-preferred-zone-fix.patch
mm-compaction-do-not-count-compact_stall-if-all-zones-skipped-compaction.patch
mm-compaction-do-not-recheck-suitable_migration_target-under-lock.patch
mm-compaction-move-pageblock-checks-up-from-isolate_migratepages_range.patch
mm-compaction-reduce-zone-checking-frequency-in-the-migration-scanner.patch
mm-compaction-khugepaged-should-not-give-up-due-to-need_resched.patch
mm-compaction-khugepaged-should-not-give-up-due-to-need_resched-fix.patch
mm-compaction-remember-position-within-pageblock-in-free-pages-scanner.patch
mm-compaction-skip-buddy-pages-by-their-order-in-the-migrate-scanner.patch
mm-rename-allocflags_to_migratetype-for-clarity.patch
mm-compaction-pass-gfp-mask-to-compact_control.patch
zsmalloc-move-pages_allocated-to-zs_pool.patch
zsmalloc-change-return-value-unit-of-zs_get_total_size_bytes.patch
zram-zram-memory-size-limitation.patch
zram-report-maximum-used-memory.patch
page-owners-correct-page-order-when-to-free-page.patch

