From: akpm@linux-foundation.org
Subject: [merged] slabh-sprinkle-__assume_aligned-attributes.patch removed from -mm tree
Date: Mon, 23 Nov 2015 12:14:51 -0800
Message-ID: <565373bb.3JSwnAxdU/Ix2rlx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53554 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347AbbKWUOw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Nov 2015 15:14:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slab.h: sprinkle __assume_aligned attributes
has been removed from the -mm tree.  Its filename was
     slabh-sprinkle-__assume_aligned-attributes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: slab.h: sprinkle __assume_aligned attributes

The various allocators return aligned memory.  Telling the compiler that
allows it to generate better code in many cases, for example when the
return value is immediately passed to memset().

Some code does become larger, but at least we win twice as much as we lose:

$ scripts/bloat-o-meter /tmp/vmlinux vmlinux
add/remove: 0/0 grow/shrink: 13/52 up/down: 995/-2140 (-1145)

An example of the different (and smaller) code can be seen in mm_alloc(). Before:

:       48 8d 78 08             lea    0x8(%rax),%rdi
:       48 89 c1                mov    %rax,%rcx
:       48 89 c2                mov    %rax,%rdx
:       48 c7 00 00 00 00 00    movq   $0x0,(%rax)
:       48 c7 80 48 03 00 00    movq   $0x0,0x348(%rax)
:       00 00 00 00
:       31 c0                   xor    %eax,%eax
:       48 83 e7 f8             and    $0xfffffffffffffff8,%rdi
:       48 29 f9                sub    %rdi,%rcx
:       81 c1 50 03 00 00       add    $0x350,%ecx
:       c1 e9 03                shr    $0x3,%ecx
:       f3 48 ab                rep stos %rax,%es:(%rdi)

After:

:       48 89 c2                mov    %rax,%rdx
:       b9 6a 00 00 00          mov    $0x6a,%ecx
:       31 c0                   xor    %eax,%eax
:       48 89 d7                mov    %rdx,%rdi
:       f3 48 ab                rep stos %rax,%es:(%rdi)

So gcc's strategy is to do two possibly (but not really, of course)
unaligned stores to the first and last word, then do an aligned rep stos
covering the middle part with a little overlap.  Maybe arches which do not
allow unaligned stores gain even more.

I don't know if gcc can actually make use of alignments greater than 8 for
anything, so one could probably drop the __assume_xyz_alignment macros and
just use __assume_aligned(8).

The increases in code size are mostly caused by gcc deciding to
opencode strlen() using the check-four-bytes-at-a-time trick when it
knows the buffer is sufficiently aligned (one function grew by 200
bytes). Now it turns out that many of these strlen() calls showing up
were in fact redundant, and they're gone from -next. Applying the two
patches to next-20151001 bloat-o-meter instead says

add/remove: 0/0 grow/shrink: 6/52 up/down: 244/-2140 (-1896)

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slab.h |   43 ++++++++++++++++++++++++-----------------
 1 file changed, 26 insertions(+), 17 deletions(-)

diff -puN include/linux/slab.h~slabh-sprinkle-__assume_aligned-attributes include/linux/slab.h
--- a/include/linux/slab.h~slabh-sprinkle-__assume_aligned-attributes
+++ a/include/linux/slab.h
@@ -158,6 +158,24 @@ size_t ksize(const void *);
 #endif
 
 /*
+ * Setting ARCH_SLAB_MINALIGN in arch headers allows a different alignment.
+ * Intended for arches that get misalignment faults even for 64 bit integer
+ * aligned buffers.
+ */
+#ifndef ARCH_SLAB_MINALIGN
+#define ARCH_SLAB_MINALIGN __alignof__(unsigned long long)
+#endif
+
+/*
+ * kmalloc and friends return ARCH_KMALLOC_MINALIGN aligned
+ * pointers. kmem_cache_alloc and friends return ARCH_SLAB_MINALIGN
+ * aligned pointers.
+ */
+#define __assume_kmalloc_alignment __assume_aligned(ARCH_KMALLOC_MINALIGN)
+#define __assume_slab_alignment __assume_aligned(ARCH_SLAB_MINALIGN)
+#define __assume_page_alignment __assume_aligned(PAGE_SIZE)
+
+/*
  * Kmalloc array related definitions
  */
 
@@ -286,8 +304,8 @@ static __always_inline int kmalloc_index
 }
 #endif /* !CONFIG_SLOB */
 
-void *__kmalloc(size_t size, gfp_t flags);
-void *kmem_cache_alloc(struct kmem_cache *, gfp_t flags);
+void *__kmalloc(size_t size, gfp_t flags) __assume_kmalloc_alignment;
+void *kmem_cache_alloc(struct kmem_cache *, gfp_t flags) __assume_slab_alignment;
 void kmem_cache_free(struct kmem_cache *, void *);
 
 /*
@@ -301,8 +319,8 @@ void kmem_cache_free_bulk(struct kmem_ca
 bool kmem_cache_alloc_bulk(struct kmem_cache *, gfp_t, size_t, void **);
 
 #ifdef CONFIG_NUMA
-void *__kmalloc_node(size_t size, gfp_t flags, int node);
-void *kmem_cache_alloc_node(struct kmem_cache *, gfp_t flags, int node);
+void *__kmalloc_node(size_t size, gfp_t flags, int node) __assume_kmalloc_alignment;
+void *kmem_cache_alloc_node(struct kmem_cache *, gfp_t flags, int node) __assume_slab_alignment;
 #else
 static __always_inline void *__kmalloc_node(size_t size, gfp_t flags, int node)
 {
@@ -316,12 +334,12 @@ static __always_inline void *kmem_cache_
 #endif
 
 #ifdef CONFIG_TRACING
-extern void *kmem_cache_alloc_trace(struct kmem_cache *, gfp_t, size_t);
+extern void *kmem_cache_alloc_trace(struct kmem_cache *, gfp_t, size_t) __assume_slab_alignment;
 
 #ifdef CONFIG_NUMA
 extern void *kmem_cache_alloc_node_trace(struct kmem_cache *s,
 					   gfp_t gfpflags,
-					   int node, size_t size);
+					   int node, size_t size) __assume_slab_alignment;
 #else
 static __always_inline void *
 kmem_cache_alloc_node_trace(struct kmem_cache *s,
@@ -354,10 +372,10 @@ kmem_cache_alloc_node_trace(struct kmem_
 }
 #endif /* CONFIG_TRACING */
 
-extern void *kmalloc_order(size_t size, gfp_t flags, unsigned int order);
+extern void *kmalloc_order(size_t size, gfp_t flags, unsigned int order) __assume_page_alignment;
 
 #ifdef CONFIG_TRACING
-extern void *kmalloc_order_trace(size_t size, gfp_t flags, unsigned int order);
+extern void *kmalloc_order_trace(size_t size, gfp_t flags, unsigned int order) __assume_page_alignment;
 #else
 static __always_inline void *
 kmalloc_order_trace(size_t size, gfp_t flags, unsigned int order)
@@ -482,15 +500,6 @@ static __always_inline void *kmalloc_nod
 	return __kmalloc_node(size, flags, node);
 }
 
-/*
- * Setting ARCH_SLAB_MINALIGN in arch headers allows a different alignment.
- * Intended for arches that get misalignment faults even for 64 bit integer
- * aligned buffers.
- */
-#ifndef ARCH_SLAB_MINALIGN
-#define ARCH_SLAB_MINALIGN __alignof__(unsigned long long)
-#endif
