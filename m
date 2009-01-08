From: akpm@linux-foundation.org
Subject: - kmemleak-add-the-slab-memory-allocation-freeing-hooks.patch removed from -mm tree
Date: Thu, 08 Jan 2009 14:45:57 -0800
Message-ID: <200901082245.n08MjvjZ025485@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55206 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763394AbZAHWqq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jan 2009 17:46:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: catalin.marinas@arm.com, penberg@cs.helsinki.fi, mm-commits@vger.kernel.org


The patch titled
     kmemleak: add the slab memory allocation/freeing hooks
has been removed from the -mm tree.  Its filename was
     kmemleak-add-the-slab-memory-allocation-freeing-hooks.patch

This patch was dropped because other changes were merged, which wrecked this patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kmemleak: add the slab memory allocation/freeing hooks
From: Catalin Marinas <catalin.marinas@arm.com>

Add the callbacks to kmemleak_(alloc|free) functions from the slab
allocator.  The patch also adds the SLAB_NOLEAKTRACE flag to avoid
recursive calls to kmemleak when it allocates its own data structures.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slab.h |    2 ++
 mm/slab.c            |   33 +++++++++++++++++++++++++++++++--
 2 files changed, 33 insertions(+), 2 deletions(-)

diff -puN include/linux/slab.h~kmemleak-add-the-slab-memory-allocation-freeing-hooks include/linux/slab.h
--- a/include/linux/slab.h~kmemleak-add-the-slab-memory-allocation-freeing-hooks
+++ a/include/linux/slab.h
@@ -69,6 +69,8 @@
 # define SLAB_NOTRACK		0x00000000UL
 #endif
 
+#define SLAB_NOLEAKTRACE	0x00800000UL	/* Avoid kmemleak tracing */
+
 /* The following flags affect the page allocator grouping pages by mobility */
 #define SLAB_RECLAIM_ACCOUNT	0x00020000UL		/* Objects are reclaimable */
 #define SLAB_TEMPORARY		SLAB_RECLAIM_ACCOUNT	/* Objects are short-lived */
diff -puN mm/slab.c~kmemleak-add-the-slab-memory-allocation-freeing-hooks mm/slab.c
--- a/mm/slab.c~kmemleak-add-the-slab-memory-allocation-freeing-hooks
+++ a/mm/slab.c
@@ -106,6 +106,7 @@
 #include	<linux/string.h>
 #include	<linux/uaccess.h>
 #include	<linux/nodemask.h>
+#include	<linux/kmemleak.h>
 #include	<linux/mempolicy.h>
 #include	<linux/mutex.h>
 #include	<linux/fault-inject.h>
@@ -179,13 +180,13 @@
 			 SLAB_STORE_USER | \
 			 SLAB_RECLAIM_ACCOUNT | SLAB_PANIC | \
 			 SLAB_DESTROY_BY_RCU | SLAB_MEM_SPREAD | \
-			 SLAB_DEBUG_OBJECTS | SLAB_NOTRACK)
+			 SLAB_DEBUG_OBJECTS | SLAB_NOTRACK | SLAB_NOLEAKTRACE)
 #else
 # define CREATE_MASK	(SLAB_HWCACHE_ALIGN | \
 			 SLAB_CACHE_DMA | \
 			 SLAB_RECLAIM_ACCOUNT | SLAB_PANIC | \
 			 SLAB_DESTROY_BY_RCU | SLAB_MEM_SPREAD | \
-			 SLAB_DEBUG_OBJECTS | SLAB_NOTRACK)
+			 SLAB_DEBUG_OBJECTS | SLAB_NOTRACK | SLAB_NOLEAKTRACE)
 #endif
 
 /*
@@ -885,6 +886,14 @@ static struct array_cache *alloc_arrayca
 	struct array_cache *nc = NULL;
 
 	nc = kmalloc_node(memsize, GFP_KERNEL, node);
+	/*
+	 * The array_cache structures contain pointers to free object.
+	 * However, when such objects are allocated or transfered to another
+	 * cache the pointers are not cleared and they could be counted as
+	 * valid references during a kmemleak scan. Therefore, kmemleak must
+	 * not scan such objects.
+	 */
+	kmemleak_no_scan(nc);
 	if (nc) {
 		nc->avail = 0;
 		nc->limit = entries;
@@ -2549,6 +2558,15 @@ static struct slab *alloc_slabmgmt(struc
 		/* Slab management obj is off-slab. */
 		slabp = kmem_cache_alloc_node(cachep->slabp_cache,
 					      local_flags, nodeid);
+		/*
+		 * If the first object in the slab is leaked (it's allocated
+		 * but no one has a reference to it), we want to make sure
+		 * kmemleak does not treat the ->s_mem pointer as a reference
+		 * to the object. Otherwise we will not report the leak.
+		 */
+		kmemleak_scan_area(slabp, offsetof(struct slab, list),
+				   sizeof(struct list_head),
+				   local_flags & ~GFP_THISNODE);
 		if (!slabp)
 			return NULL;
 	} else {
@@ -3145,6 +3163,12 @@ static inline void *____cache_alloc(stru
 		STATS_INC_ALLOCMISS(cachep);
 		objp = cache_alloc_refill(cachep, flags);
 	}
+	/*
+	 * To avoid a false negative, if an object that is in one of the
+	 * per-CPU caches is leaked, we need to make sure kmemleak doesn't
+	 * treat the array pointers as a reference to the object.
+	 */
+	kmemleak_erase(&ac->entry[ac->avail]);
 	return objp;
 }
 
@@ -3362,6 +3386,8 @@ __cache_alloc_node(struct kmem_cache *ca
   out:
 	local_irq_restore(save_flags);
 	ptr = cache_alloc_debugcheck_after(cachep, flags, ptr, caller);
+	kmemleak_alloc_recursive(ptr, obj_size(cachep), 1, cachep->flags,
+				 flags);
 
 	if (likely(ptr))
 		kmemcheck_slab_alloc(cachep, flags, ptr, obj_size(cachep));
@@ -3418,6 +3444,8 @@ __cache_alloc(struct kmem_cache *cachep,
 	objp = __do_cache_alloc(cachep, flags);
 	local_irq_restore(save_flags);
 	objp = cache_alloc_debugcheck_after(cachep, flags, objp, caller);
+	kmemleak_alloc_recursive(objp, obj_size(cachep), 1, cachep->flags,
+				 flags);
 	prefetchw(objp);
 
 	if (likely(objp))
@@ -3536,6 +3564,7 @@ static inline void __cache_free(struct k
 	struct array_cache *ac = cpu_cache_get(cachep);
 
 	check_irq_off();
+	kmemleak_free_recursive(objp, cachep->flags);
 	objp = cache_free_debugcheck(cachep, objp, __builtin_return_address(0));
 
 	kmemcheck_slab_free(cachep, objp, obj_size(cachep));
_

Patches currently in -mm which might be from catalin.marinas@arm.com are

origin.patch
kmemleak-add-the-slab-memory-allocation-freeing-hooks.patch
kmemleak-add-the-slob-memory-allocation-freeing-hooks.patch
kmemleak-add-the-slub-memory-allocation-freeing-hooks.patch
kmemleak-add-the-vmalloc-memory-allocation-freeing-hooks.patch
kmemleak-add-kmemleak_alloc-callback-from-alloc_large_system_hash.patch
kmemleak-add-modules-support.patch
x86-provide-_sdata-in-the-vmlinux_ldss-files.patch
arm-provide-_sdata-and-__bss_stop-in-the-vmlinuxldss-file.patch
kmemleak-remove-some-of-the-kmemleak-false-positives.patch
kmemleak-enable-the-building-of-the-memory-leak-detector.patch
kmemleak-simple-testing-module-for-kmemleak.patch
kmemleak-add-the-corresponding-maintainers-entry.patch

