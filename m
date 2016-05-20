From: akpm@linux-foundation.org
Subject: [merged] include-linux-apply-__malloc-attribute.patch removed
 from -mm tree
Date: Fri, 20 May 2016 14:03:58 -0700
Message-ID: <573f7bbe.lXHSjgoQo8b8BYy2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46906 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836AbcETVD7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 17:03:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, ak@linux.intel.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux: apply __malloc attribute
has been removed from the -mm tree.  Its filename was
     include-linux-apply-__malloc-attribute.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: include/linux: apply __malloc attribute

Attach the malloc attribute to a few allocation functions.  This helps gcc
generate better code by telling it that the return value doesn't alias any
existing pointers (which is even more valuable given the pessimizations
implied by -fno-strict-aliasing).

A simple example of what this allows gcc to do can be seen by looking at
the last part of drm_atomic_helper_plane_reset:

	plane->state = kzalloc(sizeof(*plane->state), GFP_KERNEL);

	if (plane->state) {
		plane->state->plane = plane;
		plane->state->rotation = BIT(DRM_ROTATE_0);
	}

which compiles to

    e8 99 bf d6 ff          callq  ffffffff8116d540 <kmem_cache_alloc_trace>
    48 85 c0                test   %rax,%rax
    48 89 83 40 02 00 00    mov    %rax,0x240(%rbx)
    74 11                   je     ffffffff814015c4 <drm_atomic_helper_plane_reset+0x64>
    48 89 18                mov    %rbx,(%rax)
    48 8b 83 40 02 00 00    mov    0x240(%rbx),%rax [*]
    c7 40 40 01 00 00 00    movl   $0x1,0x40(%rax)

With this patch applied, the instruction at [*] is elided, since the store
to plane->state->plane is known to not alter the value of plane->state.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bootmem.h |   16 ++++++++--------
 include/linux/device.h  |   12 ++++++------
 include/linux/kernel.h  |    4 ++--
 include/linux/mempool.h |    3 ++-
 include/linux/slab.h    |   16 ++++++++--------
 include/linux/string.h  |    2 +-
 6 files changed, 27 insertions(+), 26 deletions(-)

diff -puN include/linux/bootmem.h~include-linux-apply-__malloc-attribute include/linux/bootmem.h
--- a/include/linux/bootmem.h~include-linux-apply-__malloc-attribute
+++ a/include/linux/bootmem.h
@@ -83,34 +83,34 @@ extern void *__alloc_bootmem(unsigned lo
 			     unsigned long goal);
 extern void *__alloc_bootmem_nopanic(unsigned long size,
 				     unsigned long align,
-				     unsigned long goal);
+				     unsigned long goal) __malloc;
 extern void *__alloc_bootmem_node(pg_data_t *pgdat,
 				  unsigned long size,
 				  unsigned long align,
-				  unsigned long goal);
+				  unsigned long goal) __malloc;
 void *__alloc_bootmem_node_high(pg_data_t *pgdat,
 				  unsigned long size,
 				  unsigned long align,
-				  unsigned long goal);
+				  unsigned long goal) __malloc;
 extern void *__alloc_bootmem_node_nopanic(pg_data_t *pgdat,
 				  unsigned long size,
 				  unsigned long align,
-				  unsigned long goal);
+				  unsigned long goal) __malloc;
 void *___alloc_bootmem_node_nopanic(pg_data_t *pgdat,
 				  unsigned long size,
 				  unsigned long align,
 				  unsigned long goal,
-				  unsigned long limit);
+				  unsigned long limit) __malloc;
 extern void *__alloc_bootmem_low(unsigned long size,
 				 unsigned long align,
-				 unsigned long goal);
+				 unsigned long goal) __malloc;
 void *__alloc_bootmem_low_nopanic(unsigned long size,
 				 unsigned long align,
-				 unsigned long goal);
+				 unsigned long goal) __malloc;
 extern void *__alloc_bootmem_low_node(pg_data_t *pgdat,
 				      unsigned long size,
 				      unsigned long align,
-				      unsigned long goal);
+				      unsigned long goal) __malloc;
 
 #ifdef CONFIG_NO_BOOTMEM
 /* We are using top down, so it is safe to use 0 here */
diff -puN include/linux/device.h~include-linux-apply-__malloc-attribute include/linux/device.h
--- a/include/linux/device.h~include-linux-apply-__malloc-attribute
+++ a/include/linux/device.h
@@ -609,14 +609,14 @@ typedef int (*dr_match_t)(struct device
 
 #ifdef CONFIG_DEBUG_DEVRES
 extern void *__devres_alloc_node(dr_release_t release, size_t size, gfp_t gfp,
-				 int nid, const char *name);
+				 int nid, const char *name) __malloc;
 #define devres_alloc(release, size, gfp) \
 	__devres_alloc_node(release, size, gfp, NUMA_NO_NODE, #release)
 #define devres_alloc_node(release, size, gfp, nid) \
 	__devres_alloc_node(release, size, gfp, nid, #release)
 #else
 extern void *devres_alloc_node(dr_release_t release, size_t size, gfp_t gfp,
-			       int nid);
+			       int nid) __malloc;
 static inline void *devres_alloc(dr_release_t release, size_t size, gfp_t gfp)
 {
 	return devres_alloc_node(release, size, gfp, NUMA_NO_NODE);
@@ -648,12 +648,12 @@ extern void devres_remove_group(struct d
 extern int devres_release_group(struct device *dev, void *id);
 
 /* managed devm_k.alloc/kfree for device drivers */
-extern void *devm_kmalloc(struct device *dev, size_t size, gfp_t gfp);
+extern void *devm_kmalloc(struct device *dev, size_t size, gfp_t gfp) __malloc;
 extern __printf(3, 0)
 char *devm_kvasprintf(struct device *dev, gfp_t gfp, const char *fmt,
-		      va_list ap);
+		      va_list ap) __malloc;
 extern __printf(3, 4)
-char *devm_kasprintf(struct device *dev, gfp_t gfp, const char *fmt, ...);
+char *devm_kasprintf(struct device *dev, gfp_t gfp, const char *fmt, ...) __malloc;
 static inline void *devm_kzalloc(struct device *dev, size_t size, gfp_t gfp)
 {
 	return devm_kmalloc(dev, size, gfp | __GFP_ZERO);
@@ -671,7 +671,7 @@ static inline void *devm_kcalloc(struct
 	return devm_kmalloc_array(dev, n, size, flags | __GFP_ZERO);
 }
 extern void devm_kfree(struct device *dev, void *p);
-extern char *devm_kstrdup(struct device *dev, const char *s, gfp_t gfp);
+extern char *devm_kstrdup(struct device *dev, const char *s, gfp_t gfp) __malloc;
 extern void *devm_kmemdup(struct device *dev, const void *src, size_t len,
 			  gfp_t gfp);
 
diff -puN include/linux/kernel.h~include-linux-apply-__malloc-attribute include/linux/kernel.h
--- a/include/linux/kernel.h~include-linux-apply-__malloc-attribute
+++ a/include/linux/kernel.h
@@ -412,9 +412,9 @@ extern __printf(3, 4)
 int scnprintf(char *buf, size_t size, const char *fmt, ...);
 extern __printf(3, 0)
 int vscnprintf(char *buf, size_t size, const char *fmt, va_list args);
-extern __printf(2, 3)
+extern __printf(2, 3) __malloc
 char *kasprintf(gfp_t gfp, const char *fmt, ...);
-extern __printf(2, 0)
+extern __printf(2, 0) __malloc
 char *kvasprintf(gfp_t gfp, const char *fmt, va_list args);
 extern __printf(2, 0)
 const char *kvasprintf_const(gfp_t gfp, const char *fmt, va_list args);
diff -puN include/linux/mempool.h~include-linux-apply-__malloc-attribute include/linux/mempool.h
--- a/include/linux/mempool.h~include-linux-apply-__malloc-attribute
+++ a/include/linux/mempool.h
@@ -5,6 +5,7 @@
 #define _LINUX_MEMPOOL_H
 
 #include <linux/wait.h>
+#include <linux/compiler.h>
 
 struct kmem_cache;
 
@@ -31,7 +32,7 @@ extern mempool_t *mempool_create_node(in
 
 extern int mempool_resize(mempool_t *pool, int new_min_nr);
 extern void mempool_destroy(mempool_t *pool);
-extern void * mempool_alloc(mempool_t *pool, gfp_t gfp_mask);
+extern void *mempool_alloc(mempool_t *pool, gfp_t gfp_mask) __malloc;
 extern void mempool_free(void *element, mempool_t *pool);
 
 /*
diff -puN include/linux/slab.h~include-linux-apply-__malloc-attribute include/linux/slab.h
--- a/include/linux/slab.h~include-linux-apply-__malloc-attribute
+++ a/include/linux/slab.h
@@ -315,8 +315,8 @@ static __always_inline int kmalloc_index
 }
 #endif /* !CONFIG_SLOB */
 
-void *__kmalloc(size_t size, gfp_t flags) __assume_kmalloc_alignment;
-void *kmem_cache_alloc(struct kmem_cache *, gfp_t flags) __assume_slab_alignment;
+void *__kmalloc(size_t size, gfp_t flags) __assume_kmalloc_alignment __malloc;
+void *kmem_cache_alloc(struct kmem_cache *, gfp_t flags) __assume_slab_alignment __malloc;
 void kmem_cache_free(struct kmem_cache *, void *);
 
 /*
@@ -339,8 +339,8 @@ static __always_inline void kfree_bulk(s
 }
 
 #ifdef CONFIG_NUMA
-void *__kmalloc_node(size_t size, gfp_t flags, int node) __assume_kmalloc_alignment;
-void *kmem_cache_alloc_node(struct kmem_cache *, gfp_t flags, int node) __assume_slab_alignment;
+void *__kmalloc_node(size_t size, gfp_t flags, int node) __assume_kmalloc_alignment __malloc;
+void *kmem_cache_alloc_node(struct kmem_cache *, gfp_t flags, int node) __assume_slab_alignment __malloc;
 #else
 static __always_inline void *__kmalloc_node(size_t size, gfp_t flags, int node)
 {
@@ -354,12 +354,12 @@ static __always_inline void *kmem_cache_
 #endif
 
 #ifdef CONFIG_TRACING
-extern void *kmem_cache_alloc_trace(struct kmem_cache *, gfp_t, size_t) __assume_slab_alignment;
+extern void *kmem_cache_alloc_trace(struct kmem_cache *, gfp_t, size_t) __assume_slab_alignment __malloc;
 
 #ifdef CONFIG_NUMA
 extern void *kmem_cache_alloc_node_trace(struct kmem_cache *s,
 					   gfp_t gfpflags,
-					   int node, size_t size) __assume_slab_alignment;
+					   int node, size_t size) __assume_slab_alignment __malloc;
 #else
 static __always_inline void *
 kmem_cache_alloc_node_trace(struct kmem_cache *s,
@@ -392,10 +392,10 @@ kmem_cache_alloc_node_trace(struct kmem_
 }
 #endif /* CONFIG_TRACING */
 
-extern void *kmalloc_order(size_t size, gfp_t flags, unsigned int order) __assume_page_alignment;
+extern void *kmalloc_order(size_t size, gfp_t flags, unsigned int order) __assume_page_alignment __malloc;
 
 #ifdef CONFIG_TRACING
-extern void *kmalloc_order_trace(size_t size, gfp_t flags, unsigned int order) __assume_page_alignment;
+extern void *kmalloc_order_trace(size_t size, gfp_t flags, unsigned int order) __assume_page_alignment __malloc;
 #else
 static __always_inline void *
 kmalloc_order_trace(size_t size, gfp_t flags, unsigned int order)
diff -puN include/linux/string.h~include-linux-apply-__malloc-attribute include/linux/string.h
--- a/include/linux/string.h~include-linux-apply-__malloc-attribute
+++ a/include/linux/string.h
@@ -119,7 +119,7 @@ char *strreplace(char *s, char old, char
 
 extern void kfree_const(const void *x);
 
-extern char *kstrdup(const char *s, gfp_t gfp);
+extern char *kstrdup(const char *s, gfp_t gfp) __malloc;
 extern const char *kstrdup_const(const char *s, gfp_t gfp);
 extern char *kstrndup(const char *s, size_t len, gfp_t gfp);
 extern void *kmemdup(const void *src, size_t len, gfp_t gfp);
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

init-mainc-simplify-initcall_blacklisted.patch

