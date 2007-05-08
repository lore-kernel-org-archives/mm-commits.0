From: akpm@linux-foundation.org
Subject: - slub-slab-allocators-remove-slab_ctor_atomic.patch removed from -mm tree
Date: Mon, 07 May 2007 17:09:04 -0700
Message-ID: <200705080009.l48094Th009422@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:41496 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967447AbXEHAJY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:09:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     slab allocators: Remove SLAB_CTOR_ATOMIC
has been removed from the -mm tree.  Its filename was
     slub-slab-allocators-remove-slab_ctor_atomic.patch

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

 mm/slub.c |   10 ++--------
 1 files changed, 2 insertions(+), 8 deletions(-)

diff -puN mm/slub.c~slub-slab-allocators-remove-slab_ctor_atomic mm/slub.c
--- a/mm/slub.c~slub-slab-allocators-remove-slab_ctor_atomic
+++ a/mm/slub.c
@@ -802,14 +802,8 @@ static void setup_object(struct kmem_cac
 		init_tracking(s, object);
 	}
 
-	if (unlikely(s->ctor)) {
-		int mode = SLAB_CTOR_CONSTRUCTOR;
-
-		if (!(s->flags & __GFP_WAIT))
-			mode |= SLAB_CTOR_ATOMIC;
-
-		s->ctor(object, s, mode);
-	}
+	if (unlikely(s->ctor))
+		s->ctor(object, s, SLAB_CTOR_CONSTRUCTOR);
 }
 
 static struct page *new_slab(struct kmem_cache *s, gfp_t flags, int node)
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
