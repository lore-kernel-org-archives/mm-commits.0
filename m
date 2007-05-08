From: akpm@linux-foundation.org
Subject: - slub-slab-allocators-remove-slab_debug_initial-flag.patch removed from -mm tree
Date: Mon, 07 May 2007 17:09:01 -0700
Message-ID: <200705080009.l48091vD009419@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:46007 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967452AbXEHAJd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:09:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     slab allocators: Remove SLAB_DEBUG_INITIAL flag
has been removed from the -mm tree.  Its filename was
     slub-slab-allocators-remove-slab_debug_initial-flag.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: slab allocators: Remove SLAB_DEBUG_INITIAL flag
From: Christoph Lameter <clameter@sgi.com>

I have never seen a use of SLAB_DEBUG_INITIAL.  It is only supported by
SLAB.

I think its purpose was to have a callback after an object has been freed
to verify that the state is the constructor state again?  The callback is
performed before each freeing of an object.

I would think that it is much easier to check the object state manually
before the free.  That also places the check near the code object
manipulation of the object.

Also the SLAB_DEBUG_INITIAL callback is only performed if the kernel was
compiled with SLAB debugging on.  If there would be code in a constructor
handling SLAB_DEBUG_INITIAL then it would have to be conditional on
SLAB_DEBUG otherwise it would just be dead code.  But there is no such code
in the kernel.  I think SLUB_DEBUG_INITIAL is too problematic to make real
use of, difficult to understand and there are easier ways to accomplish the
same effect (i.e.  add debug code before kfree).

There is a related flag SLAB_CTOR_VERIFY that is frequently checked to be
clear in fs inode caches.  Remove the pointless checks (they would even be
pointless without removeal of SLAB_DEBUG_INITIAL) from the fs constructors.

This is the last slab flag that SLUB did not support.  Remove the check for
unimplemented flags from SLUB.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   10 ----------
 1 files changed, 10 deletions(-)

diff -puN mm/slub.c~slub-slab-allocators-remove-slab_debug_initial-flag mm/slub.c
--- a/mm/slub.c~slub-slab-allocators-remove-slab_debug_initial-flag
+++ a/mm/slub.c
@@ -97,9 +97,6 @@
  *
  * - Support PAGE_ALLOC_DEBUG. Should be easy to do.
  *
- * - SLAB_DEBUG_INITIAL is not supported but I have never seen a use of
- *   it.
- *
  * - Variable sizing of the per node arrays
  */
 
@@ -126,11 +123,6 @@
 #endif
 
 /*
- * Flags from the regular SLAB that SLUB does not support:
- */
-#define SLUB_UNIMPLEMENTED (SLAB_DEBUG_INITIAL)
-
-/*
  * Mininum number of partial slabs. These will be left on the partial
  * lists even if they are empty. kmem_cache_shrink may reclaim them.
  */
@@ -1748,8 +1740,6 @@ static int kmem_cache_open(struct kmem_c
 	s->flags = flags;
 	s->align = align;
 
-	BUG_ON(flags & SLUB_UNIMPLEMENTED);
-
 	/*
 	 * The page->offset field is only 16 bit wide. This is an offset
 	 * in units of words from the beginning of an object. If the slab
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
