From: akpm@osdl.org
Subject: - slab-use-a-multiply-instead-of-a-divide-in-obj_to_index.patch removed from -mm tree
Date: Wed, 13 Dec 2006 22:07:05 -0800
Message-ID: <200612140607.kBE675Tk001893@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51984 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751890AbWLNGHg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Dec 2006 01:07:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dada1@cosmosbay.com, clameter@sgi.com, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     SLAB: use a multiply instead of a divide in obj_to_index()
has been removed from the -mm tree.  Its filename was
     slab-use-a-multiply-instead-of-a-divide-in-obj_to_index.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: SLAB: use a multiply instead of a divide in obj_to_index()
From: Eric Dumazet <dada1@cosmosbay.com>

When some objects are allocated by one CPU but freed by another CPU we can
consume lot of cycles doing divides in obj_to_index().

(Typical load on a dual processor machine where network interrupts are
handled by one particular CPU (allocating skbufs), and the other CPU is
running the application (consuming and freeing skbufs))

Here on one production server (dual-core AMD Opteron 285), I noticed this
divide took 1.20 % of CPU_CLK_UNHALTED events in kernel.  But Opteron are
quite modern cpus and the divide is much more expensive on oldest
architectures :

On a 200 MHz sparcv9 machine, the division takes 64 cycles instead of 1
cycle for a multiply.

Doing some math, we can use a reciprocal multiplication instead of a divide.

If we want to compute V = (A / B)  (A and B being u32 quantities)
we can instead use :

V = ((u64)A * RECIPROCAL(B)) >> 32 ;

where RECIPROCAL(B) is precalculated to ((1LL << 32) + (B - 1)) / B

Note :

I wrote pure C code for clarity. gcc output for i386 is not optimal but
acceptable :

mull   0x14(%ebx)
mov    %edx,%eax // part of the >> 32
xor     %edx,%edx // useless
mov    %eax,(%esp) // could be avoided
mov    %edx,0x4(%esp) // useless
mov    (%esp),%ebx

[akpm@osdl.org: small cleanups]
Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/reciprocal_div.h |   32 +++++++++++++++++++++++++++++++
 lib/Makefile                   |    2 -
 lib/reciprocal_div.c           |    9 ++++++++
 mm/slab.c                      |   18 ++++++++++++++---
 4 files changed, 57 insertions(+), 4 deletions(-)

diff -puN /dev/null include/linux/reciprocal_div.h
--- /dev/null
+++ a/include/linux/reciprocal_div.h
@@ -0,0 +1,32 @@
+#ifndef _LINUX_RECIPROCAL_DIV_H
+#define _LINUX_RECIPROCAL_DIV_H
+
+#include <linux/types.h>
+
+/*
+ * This file describes reciprocical division.
+ *
+ * This optimizes the (A/B) problem, when A and B are two u32
+ * and B is a known value (but not known at compile time)
+ *
+ * The math principle used is :
+ *   Let RECIPROCAL_VALUE(B) be (((1LL << 32) + (B - 1))/ B)
+ *   Then A / B = (u32)(((u64)(A) * (R)) >> 32)
+ *
+ * This replaces a divide by a multiply (and a shift), and
+ * is generally less expensive in CPU cycles.
+ */
+
+/*
+ * Computes the reciprocal value (R) for the value B of the divisor.
+ * Should not be called before each reciprocal_divide(),
+ * or else the performance is slower than a normal divide.
+ */
+extern u32 reciprocal_value(u32 B);
+
+
+static inline u32 reciprocal_divide(u32 A, u32 R)
+{
+	return (u32)(((u64)A * R) >> 32);
+}
+#endif
diff -puN lib/Makefile~slab-use-a-multiply-instead-of-a-divide-in-obj_to_index lib/Makefile
--- a/lib/Makefile~slab-use-a-multiply-instead-of-a-divide-in-obj_to_index
+++ a/lib/Makefile
@@ -5,7 +5,7 @@
 lib-y := ctype.o string.o vsprintf.o cmdline.o \
 	 bust_spinlocks.o rbtree.o radix-tree.o dump_stack.o \
 	 idr.o div64.o int_sqrt.o bitmap.o extable.o prio_tree.o \
-	 sha1.o irq_regs.o
+	 sha1.o irq_regs.o reciprocal_div.o
 
 lib-$(CONFIG_MMU) += ioremap.o
 lib-$(CONFIG_SMP) += cpumask.o
diff -puN /dev/null lib/reciprocal_div.c
--- /dev/null
+++ a/lib/reciprocal_div.c
@@ -0,0 +1,9 @@
+#include <asm/div64.h>
+#include <linux/reciprocal_div.h>
+
+u32 reciprocal_value(u32 k)
+{
+	u64 val = (1LL << 32) + (k - 1);
+	do_div(val, k);
+	return (u32)val;
+}
diff -puN mm/slab.c~slab-use-a-multiply-instead-of-a-divide-in-obj_to_index mm/slab.c
--- a/mm/slab.c~slab-use-a-multiply-instead-of-a-divide-in-obj_to_index
+++ a/mm/slab.c
@@ -109,6 +109,7 @@
 #include	<linux/mutex.h>
 #include	<linux/fault-inject.h>
 #include	<linux/rtmutex.h>
+#include	<linux/reciprocal_div.h>
 
 #include	<asm/cacheflush.h>
 #include	<asm/tlbflush.h>
@@ -386,6 +387,7 @@ struct kmem_cache {
 	unsigned int shared;
 
 	unsigned int buffer_size;
+	u32 reciprocal_buffer_size;
 /* 3) touched by every alloc & free from the backend */
 	struct kmem_list3 *nodelists[MAX_NUMNODES];
 
@@ -627,10 +629,17 @@ static inline void *index_to_obj(struct 
 	return slab->s_mem + cache->buffer_size * idx;
 }
 
-static inline unsigned int obj_to_index(struct kmem_cache *cache,
-					struct slab *slab, void *obj)
+/*
+ * We want to avoid an expensive divide : (offset / cache->buffer_size)
+ *   Using the fact that buffer_size is a constant for a particular cache,
+ *   we can replace (offset / cache->buffer_size) by
+ *   reciprocal_divide(offset, cache->reciprocal_buffer_size)
+ */
+static inline unsigned int obj_to_index(const struct kmem_cache *cache,
+					const struct slab *slab, void *obj)
 {
-	return (unsigned)(obj - slab->s_mem) / cache->buffer_size;
+	u32 offset = (obj - slab->s_mem);
+	return reciprocal_divide(offset, cache->reciprocal_buffer_size);
 }
 
 /*
@@ -1427,6 +1436,8 @@ void __init kmem_cache_init(void)
 
 	cache_cache.buffer_size = ALIGN(cache_cache.buffer_size,
 					cache_line_size());
+	cache_cache.reciprocal_buffer_size =
+		reciprocal_value(cache_cache.buffer_size);
 
 	for (order = 0; order < MAX_ORDER; order++) {
 		cache_estimate(order, cache_cache.buffer_size,
@@ -2313,6 +2324,7 @@ kmem_cache_create (const char *name, siz
 	if (flags & SLAB_CACHE_DMA)
 		cachep->gfpflags |= GFP_DMA;
 	cachep->buffer_size = size;
+	cachep->reciprocal_buffer_size = reciprocal_value(size);
 
 	if (flags & CFLGS_OFF_SLAB) {
 		cachep->slabp_cache = kmem_find_general_cachep(slab_size, 0u);
_

Patches currently in -mm which might be from dada1@cosmosbay.com are

convert-i386-pda-code-to-use-%fs.patch
convert-i386-pda-code-to-use-%fs-fixes.patch
get-rid-of-arch_have_xtime_lock.patch
introduce-time_data-a-new-structure-to-hold-jiffies-xtime.patch

