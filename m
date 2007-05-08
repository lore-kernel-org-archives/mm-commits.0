From: akpm@linux-foundation.org
Subject: - slab-allocators-remove-slab_ctor_atomic.patch removed from -mm tree
Date: Mon, 07 May 2007 17:04:24 -0700
Message-ID: <200705080004.l4804OAc009009@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:38254 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967349AbXEHAEp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:04:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     slab allocators: Remove SLAB_CTOR_ATOMIC
has been removed from the -mm tree.  Its filename was
     slab-allocators-remove-slab_ctor_atomic.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: slab allocators: Remove SLAB_CTOR_ATOMIC
From: Christoph Lameter <clameter@sgi.com>

SLAB_CTOR atomic is never used which is no surprise since I cannot imagine
that one would want to do something serious in a constructor or destructor.
 In particular given that the slab allocators run with interrupts disabled.
 Actions in constructors and destructors are by their nature very limited
and usually do not go beyond initializing variables and list operations.

(The i386 pgd ctor and dtors do take a spinlock in constructor and
destructor.....  I think that is the furthest we go at this point.)

There is no flag passed to the destructor so removing SLAB_CTOR_ATOMIC also
establishes a certain symmetry.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slab.h |    1 -
 mm/slab.c            |   17 ++---------------
 2 files changed, 2 insertions(+), 16 deletions(-)

diff -puN include/linux/slab.h~slab-allocators-remove-slab_ctor_atomic include/linux/slab.h
--- a/include/linux/slab.h~slab-allocators-remove-slab_ctor_atomic
+++ a/include/linux/slab.h
@@ -33,7 +33,6 @@ typedef struct kmem_cache kmem_cache_t _
 
 /* Flags passed to a constructor functions */
 #define SLAB_CTOR_CONSTRUCTOR	0x001UL		/* If not set, then deconstructor */
-#define SLAB_CTOR_ATOMIC	0x002UL		/* Tell constructor it can't sleep */
 
 /*
  * struct kmem_cache related prototypes
diff -puN mm/slab.c~slab-allocators-remove-slab_ctor_atomic mm/slab.c
--- a/mm/slab.c~slab-allocators-remove-slab_ctor_atomic
+++ a/mm/slab.c
@@ -2752,13 +2752,6 @@ static int cache_grow(struct kmem_cache 
 
 	ctor_flags = SLAB_CTOR_CONSTRUCTOR;
 	local_flags = (flags & GFP_LEVEL_MASK);
-	if (!(local_flags & __GFP_WAIT))
-		/*
-		 * Not allowed to sleep.  Need to tell a constructor about
-		 * this - it might need to know...
-		 */
-		ctor_flags |= SLAB_CTOR_ATOMIC;
-
 	/* Take the l3 list lock to change the colour_next on this node */
 	check_irq_off();
 	l3 = cachep->nodelists[nodeid];
@@ -3092,14 +3085,8 @@ static void *cache_alloc_debugcheck_afte
 	}
 #endif
 	objp += obj_offset(cachep);
-	if (cachep->ctor && cachep->flags & SLAB_POISON) {
-		unsigned long ctor_flags = SLAB_CTOR_CONSTRUCTOR;
-
-		if (!(flags & __GFP_WAIT))
-			ctor_flags |= SLAB_CTOR_ATOMIC;
-
-		cachep->ctor(objp, cachep, ctor_flags);
-	}
+	if (cachep->ctor && cachep->flags & SLAB_POISON)
+		cachep->ctor(objp, cachep, SLAB_CTOR_CONSTRUCTOR);
 #if ARCH_SLAB_MINALIGN
 	if ((u32)objp & (ARCH_SLAB_MINALIGN-1)) {
 		printk(KERN_ERR "0x%p: not aligned to ARCH_SLAB_MINALIGN=%d\n",
diff -puN /dev/null /dev/null
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
quicklist-support-for-ia64.patch
quicklist-support-for-x86_64.patch
slub-exploit-page-mobility-to-increase-allocation-order.patch
slub-mm-only-make-slub-the-default-slab-allocator.patch
slub-i386-support.patch
remove-constructor-from-buffer_head.patch
slab-shutdown-cache_reaper-when-cpu-goes-down.patch
mm-implement-swap-prefetching.patch
revoke-core-code-slab-allocators-remove-slab_debug_initial-flag-revoke.patch
vmstat-use-our-own-timer-events.patch
make-vm-statistics-update-interval-configurable.patch
make-vm-statistics-update-interval-configurable-fix.patch
readahead-state-based-method-aging-accounting.patch
