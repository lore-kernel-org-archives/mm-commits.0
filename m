From: akpm@linux-foundation.org
Subject: + slab-slub-slob-convert-slab_flags_t-to-32-bit.patch added to
 -mm tree
Date: Thu, 02 Nov 2017 14:42:54 -0700
Message-ID: <59fb915e.AFBhdJzGmBt98j5I%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39430 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934115AbdKBVmz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 2 Nov 2017 17:42:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slab, slub, slob: convert slab_flags_t to 32-bit
has been added to the -mm tree.  Its filename is
     slab-slub-slob-convert-slab_flags_t-to-32-bit.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/slab-slub-slob-convert-slab_flags_t-to-32-bit.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/slab-slub-slob-convert-slab_flags_t-to-32-bit.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: slab, slub, slob: convert slab_flags_t to 32-bit

struct kmem_cache::flags is "unsigned long" which is unnecessary on 64-bit
as no flags are defined in the higher bits.

Switch the field to 32-bit and save some space on x86_64 until such flags
appear:

	add/remove: 0/0 grow/shrink: 0/107 up/down: 0/-657 (-657)
	function                                     old     new   delta
	sysfs_slab_add                               720     719      -1
				...
	check_object                                 699     676     -23

Link: http://lkml.kernel.org/r/20171021100635.GA8287@avx2
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Acked-by: Pekka Enberg <penberg@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slab.h  |   44 ++++++++++++++++++++--------------------
 include/linux/types.h |    2 -
 mm/slab.c             |    4 +--
 mm/slub.c             |    4 +--
 4 files changed, 27 insertions(+), 27 deletions(-)

diff -puN include/linux/slab.h~slab-slub-slob-convert-slab_flags_t-to-32-bit include/linux/slab.h
--- a/include/linux/slab.h~slab-slub-slob-convert-slab_flags_t-to-32-bit
+++ a/include/linux/slab.h
@@ -22,19 +22,19 @@
  * The ones marked DEBUG are only valid if CONFIG_DEBUG_SLAB is set.
  */
 /* DEBUG: Perform (expensive) checks on alloc/free */
-#define SLAB_CONSISTENCY_CHECKS	((slab_flags_t __force)0x00000100UL)
+#define SLAB_CONSISTENCY_CHECKS	((slab_flags_t __force)0x00000100U)
 /* DEBUG: Red zone objs in a cache */
-#define SLAB_RED_ZONE		((slab_flags_t __force)0x00000400UL)
+#define SLAB_RED_ZONE		((slab_flags_t __force)0x00000400U)
 /* DEBUG: Poison objects */
-#define SLAB_POISON		((slab_flags_t __force)0x00000800UL)
+#define SLAB_POISON		((slab_flags_t __force)0x00000800U)
 /* Align objs on cache lines */
-#define SLAB_HWCACHE_ALIGN	((slab_flags_t __force)0x00002000UL)
+#define SLAB_HWCACHE_ALIGN	((slab_flags_t __force)0x00002000U)
 /* Use GFP_DMA memory */
-#define SLAB_CACHE_DMA		((slab_flags_t __force)0x00004000UL)
+#define SLAB_CACHE_DMA		((slab_flags_t __force)0x00004000U)
 /* DEBUG: Store the last owner for bug hunting */
-#define SLAB_STORE_USER		((slab_flags_t __force)0x00010000UL)
+#define SLAB_STORE_USER		((slab_flags_t __force)0x00010000U)
 /* Panic if kmem_cache_create() fails */
-#define SLAB_PANIC		((slab_flags_t __force)0x00040000UL)
+#define SLAB_PANIC		((slab_flags_t __force)0x00040000U)
 /*
  * SLAB_TYPESAFE_BY_RCU - **WARNING** READ THIS!
  *
@@ -73,50 +73,50 @@
  * Note that SLAB_TYPESAFE_BY_RCU was originally named SLAB_DESTROY_BY_RCU.
  */
 /* Defer freeing slabs to RCU */
-#define SLAB_TYPESAFE_BY_RCU	((slab_flags_t __force)0x00080000UL)
+#define SLAB_TYPESAFE_BY_RCU	((slab_flags_t __force)0x00080000U)
 /* Spread some memory over cpuset */
-#define SLAB_MEM_SPREAD		((slab_flags_t __force)0x00100000UL)
+#define SLAB_MEM_SPREAD		((slab_flags_t __force)0x00100000U)
 /* Trace allocations and frees */
-#define SLAB_TRACE		((slab_flags_t __force)0x00200000UL)
+#define SLAB_TRACE		((slab_flags_t __force)0x00200000U)
 
 /* Flag to prevent checks on free */
 #ifdef CONFIG_DEBUG_OBJECTS
-# define SLAB_DEBUG_OBJECTS	((slab_flags_t __force)0x00400000UL)
+# define SLAB_DEBUG_OBJECTS	((slab_flags_t __force)0x00400000U)
 #else
-# define SLAB_DEBUG_OBJECTS	((slab_flags_t __force)0x00000000UL)
+# define SLAB_DEBUG_OBJECTS	0
 #endif
 
 /* Avoid kmemleak tracing */
-#define SLAB_NOLEAKTRACE	((slab_flags_t __force)0x00800000UL)
+#define SLAB_NOLEAKTRACE	((slab_flags_t __force)0x00800000U)
 
 /* Don't track use of uninitialized memory */
 #ifdef CONFIG_KMEMCHECK
-# define SLAB_NOTRACK		((slab_flags_t __force)0x01000000UL)
+# define SLAB_NOTRACK		((slab_flags_t __force)0x01000000U)
 #else
-# define SLAB_NOTRACK		((slab_flags_t __force)0x00000000UL)
+# define SLAB_NOTRACK		0
 #endif
 /* Fault injection mark */
 #ifdef CONFIG_FAILSLAB
-# define SLAB_FAILSLAB		((slab_flags_t __force)0x02000000UL)
+# define SLAB_FAILSLAB		((slab_flags_t __force)0x02000000U)
 #else
-# define SLAB_FAILSLAB		((slab_flags_t __force)0x00000000UL)
+# define SLAB_FAILSLAB		0
 #endif
 /* Account to memcg */
 #if defined(CONFIG_MEMCG) && !defined(CONFIG_SLOB)
-# define SLAB_ACCOUNT		((slab_flags_t __force)0x04000000UL)
+# define SLAB_ACCOUNT		((slab_flags_t __force)0x04000000U)
 #else
-# define SLAB_ACCOUNT		((slab_flags_t __force)0x00000000UL)
+# define SLAB_ACCOUNT		0
 #endif
 
 #ifdef CONFIG_KASAN
-#define SLAB_KASAN		((slab_flags_t __force)0x08000000UL)
+#define SLAB_KASAN		((slab_flags_t __force)0x08000000U)
 #else
-#define SLAB_KASAN		((slab_flags_t __force)0x00000000UL)
+#define SLAB_KASAN		0
 #endif
 
 /* The following flags affect the page allocator grouping pages by mobility */
 /* Objects are reclaimable */
-#define SLAB_RECLAIM_ACCOUNT	((slab_flags_t __force)0x00020000UL)
+#define SLAB_RECLAIM_ACCOUNT	((slab_flags_t __force)0x00020000U)
 #define SLAB_TEMPORARY		SLAB_RECLAIM_ACCOUNT	/* Objects are short-lived */
 /*
  * ZERO_SIZE_PTR will be returned for zero sized kmalloc requests.
diff -puN include/linux/types.h~slab-slub-slob-convert-slab_flags_t-to-32-bit include/linux/types.h
--- a/include/linux/types.h~slab-slub-slob-convert-slab_flags_t-to-32-bit
+++ a/include/linux/types.h
@@ -156,7 +156,7 @@ typedef u32 dma_addr_t;
 #endif
 
 typedef unsigned __bitwise gfp_t;
-typedef unsigned long __bitwise slab_flags_t;
+typedef unsigned __bitwise slab_flags_t;
 typedef unsigned __bitwise fmode_t;
 
 #ifdef CONFIG_PHYS_ADDR_T_64BIT
diff -puN mm/slab.c~slab-slub-slob-convert-slab_flags_t-to-32-bit mm/slab.c
--- a/mm/slab.c~slab-slub-slob-convert-slab_flags_t-to-32-bit
+++ a/mm/slab.c
@@ -252,8 +252,8 @@ static void kmem_cache_node_init(struct
 	MAKE_LIST((cachep), (&(ptr)->slabs_free), slabs_free, nodeid);	\
 	} while (0)
 
-#define CFLGS_OBJFREELIST_SLAB	((slab_flags_t __force)0x40000000UL)
-#define CFLGS_OFF_SLAB		((slab_flags_t __force)0x80000000UL)
+#define CFLGS_OBJFREELIST_SLAB	((slab_flags_t __force)0x40000000U)
+#define CFLGS_OFF_SLAB		((slab_flags_t __force)0x80000000U)
 #define	OBJFREELIST_SLAB(x)	((x)->flags & CFLGS_OBJFREELIST_SLAB)
 #define	OFF_SLAB(x)	((x)->flags & CFLGS_OFF_SLAB)
 
diff -puN mm/slub.c~slab-slub-slob-convert-slab_flags_t-to-32-bit mm/slub.c
--- a/mm/slub.c~slab-slub-slob-convert-slab_flags_t-to-32-bit
+++ a/mm/slub.c
@@ -194,9 +194,9 @@ static inline bool kmem_cache_has_cpu_pa
 
 /* Internal SLUB flags */
 /* Poison object */
-#define __OBJECT_POISON		((slab_flags_t __force)0x80000000UL)
+#define __OBJECT_POISON		((slab_flags_t __force)0x80000000U)
 /* Use cmpxchg_double */
-#define __CMPXCHG_DOUBLE	((slab_flags_t __force)0x40000000UL)
+#define __CMPXCHG_DOUBLE	((slab_flags_t __force)0x40000000U)
 
 /*
  * Tracking user of a slab.
_

Patches currently in -mm which might be from adobriyan@gmail.com are

slab-slub-slob-add-slab_flags_t.patch
slab-slub-slob-convert-slab_flags_t-to-32-bit.patch
proc-uninline-name_to_int.patch
proc-use-do-while-in-name_to_int.patch
seq_file-delete-small-value-optimization.patch

