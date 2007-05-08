From: akpm@linux-foundation.org
Subject: - slab-allocators-remove-useless-__gfp_no_grow-flag.patch removed from -mm tree
Date: Mon, 07 May 2007 17:04:26 -0700
Message-ID: <200705080004.l4804QYv009012@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:52647 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967356AbXEHAEq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:04:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     Slab allocators: remove useless __GFP_NO_GROW flag
has been removed from the -mm tree.  Its filename was
     slab-allocators-remove-useless-__gfp_no_grow-flag.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Slab allocators: remove useless __GFP_NO_GROW flag
From: Christoph Lameter <clameter@sgi.com>

There is no user remaining and I have never seen any use of that flag.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |    3 +--
 mm/slab.c           |    6 ++----
 2 files changed, 3 insertions(+), 6 deletions(-)

diff -puN include/linux/gfp.h~slab-allocators-remove-useless-__gfp_no_grow-flag include/linux/gfp.h
--- a/include/linux/gfp.h~slab-allocators-remove-useless-__gfp_no_grow-flag
+++ a/include/linux/gfp.h
@@ -40,7 +40,6 @@ struct vm_area_struct;
 #define __GFP_REPEAT	((__force gfp_t)0x400u)	/* Retry the allocation.  Might fail */
 #define __GFP_NOFAIL	((__force gfp_t)0x800u)	/* Retry for ever.  Cannot fail */
 #define __GFP_NORETRY	((__force gfp_t)0x1000u)/* Do not retry.  Might fail */
-#define __GFP_NO_GROW	((__force gfp_t)0x2000u)/* Slab internal usage */
 #define __GFP_COMP	((__force gfp_t)0x4000u)/* Add compound page metadata */
 #define __GFP_ZERO	((__force gfp_t)0x8000u)/* Return zeroed page on success */
 #define __GFP_NOMEMALLOC ((__force gfp_t)0x10000u) /* Don't use emergency reserves */
@@ -53,7 +52,7 @@ struct vm_area_struct;
 /* if you forget to add the bitmask here kernel will crash, period */
 #define GFP_LEVEL_MASK (__GFP_WAIT|__GFP_HIGH|__GFP_IO|__GFP_FS| \
 			__GFP_COLD|__GFP_NOWARN|__GFP_REPEAT| \
-			__GFP_NOFAIL|__GFP_NORETRY|__GFP_NO_GROW|__GFP_COMP| \
+			__GFP_NOFAIL|__GFP_NORETRY|__GFP_COMP| \
 			__GFP_NOMEMALLOC|__GFP_HARDWALL|__GFP_THISNODE)
 
 /* This equals 0, but use constants in case they ever change */
diff -puN mm/slab.c~slab-allocators-remove-useless-__gfp_no_grow-flag mm/slab.c
--- a/mm/slab.c~slab-allocators-remove-useless-__gfp_no_grow-flag
+++ a/mm/slab.c
@@ -2746,9 +2746,7 @@ static int cache_grow(struct kmem_cache 
 	 * Be lazy and only check for valid flags here,  keeping it out of the
 	 * critical path in kmem_cache_alloc().
 	 */
-	BUG_ON(flags & ~(GFP_DMA | GFP_LEVEL_MASK | __GFP_NO_GROW));
-	if (flags & __GFP_NO_GROW)
-		return 0;
+	BUG_ON(flags & ~(GFP_DMA | GFP_LEVEL_MASK));
 
 	ctor_flags = SLAB_CTOR_CONSTRUCTOR;
 	local_flags = (flags & GFP_LEVEL_MASK);
@@ -3252,7 +3250,7 @@ retry:
 					flags | GFP_THISNODE, nid);
 	}
 
-	if (!obj && !(flags & __GFP_NO_GROW)) {
+	if (!obj) {
 		/*
 		 * This allocation will be performed within the constraints
 		 * of the current cpuset / memory policy requirements.
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
