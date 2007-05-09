From: akpm@linux-foundation.org
Subject: - slub-add-support-for-dynamic-cacheline-size-determination.patch removed from -mm tree
Date: Wed, 09 May 2007 14:47:47 -0700
Message-ID: <200705092147.l49Lllg0002509@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:43191 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755699AbXEIVru (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:47:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     SLUB: add support for dynamic cacheline size determination
has been removed from the -mm tree.  Its filename was
     slub-add-support-for-dynamic-cacheline-size-determination.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: SLUB: add support for dynamic cacheline size determination
From: Christoph Lameter <clameter@sgi.com>

SLUB currently assumes that the cacheline size is static.  However, i386 f.e. 
supports dynamic cache line size determination.

Use cache_line_size() instead of L1_CACHE_BYTES in the allocator.

That also explains the purpose of SLAB_HWCACHE_ALIGN.  So we will need to keep
that one around to allow dynamic aligning of objects depending on boot
determination of the cache line size.

[akpm@linux-foundation.org: need to define it before we use it]
Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff -puN mm/slub.c~slub-add-support-for-dynamic-cacheline-size-determination mm/slub.c
--- a/mm/slub.c~slub-add-support-for-dynamic-cacheline-size-determination
+++ a/mm/slub.c
@@ -157,6 +157,11 @@
 /* Internal SLUB flags */
 #define __OBJECT_POISON 0x80000000	/* Poison object */
 
+/* Not all arches define cache_line_size */
+#ifndef cache_line_size
+#define cache_line_size()	L1_CACHE_BYTES
+#endif
+
 static int kmem_size = sizeof(struct kmem_cache);
 
 #ifdef CONFIG_SMP
@@ -1480,8 +1485,8 @@ static unsigned long calculate_alignment
 	 * then use it.
 	 */
 	if ((flags & SLAB_HWCACHE_ALIGN) &&
-			size > L1_CACHE_BYTES / 2)
-		return max_t(unsigned long, align, L1_CACHE_BYTES);
+			size > cache_line_size() / 2)
+		return max_t(unsigned long, align, cache_line_size());
 
 	if (align < ARCH_SLAB_MINALIGN)
 		return ARCH_SLAB_MINALIGN;
@@ -1667,8 +1672,8 @@ static int calculate_sizes(struct kmem_c
 		size += sizeof(void *);
 	/*
 	 * Determine the alignment based on various parameters that the
-	 * user specified (this is unecessarily complex due to the attempt
-	 * to be compatible with SLAB. Should be cleaned up some day).
+	 * user specified and the dynamic determination of cache line size
+	 * on bootup.
 	 */
 	align = calculate_alignment(flags, align, s->objsize);
 
@@ -2280,7 +2285,7 @@ void __init kmem_cache_init(void)
 
 	printk(KERN_INFO "SLUB: Genslabs=%d, HWalign=%d, Order=%d-%d, MinObjects=%d,"
 		" Processors=%d, Nodes=%d\n",
-		KMALLOC_SHIFT_HIGH, L1_CACHE_BYTES,
+		KMALLOC_SHIFT_HIGH, cache_line_size(),
 		slub_min_order, slub_max_order, slub_min_objects,
 		nr_cpu_ids, nr_node_ids);
 }
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
slub-support-concurrent-local-and-remote-frees-and-allocs-on-a-slab.patch
quicklist-support-for-ia64.patch
quicklist-support-for-x86_64.patch
slub-exploit-page-mobility-to-increase-allocation-order.patch
slub-mm-only-make-slub-the-default-slab-allocator.patch
slub-reduce-antifrag-max-order.patch
slub-i386-support.patch
define-percpu-smp-cacheline-align-interface.patch
call-percpu-smp-cacheline-algin-interface.patch
remove-constructor-from-buffer_head.patch
mm-implement-swap-prefetching.patch
revoke-core-code.patch
