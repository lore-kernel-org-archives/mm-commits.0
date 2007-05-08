From: akpm@linux-foundation.org
Subject: - slub-slab-allocators-remove-obsolete-slab_must_hwcache_align.patch removed from -mm tree
Date: Mon, 07 May 2007 17:08:59 -0700
Message-ID: <200705080008.l4808xBB009416@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:34448 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967441AbXEHAJW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:09:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, penberg@cs.helsinki.fi, mm-commits@vger.kernel.org


The patch titled
     slab allocators: Remove obsolete SLAB_MUST_HWCACHE_ALIGN
has been removed from the -mm tree.  Its filename was
     slub-slab-allocators-remove-obsolete-slab_must_hwcache_align.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: slab allocators: Remove obsolete SLAB_MUST_HWCACHE_ALIGN
From: Christoph Lameter <clameter@sgi.com>

This patch was recently posted to lkml and acked by Pekka.

The flag SLAB_MUST_HWCACHE_ALIGN is

1. Never checked by SLAB at all.

2. A duplicate of SLAB_HWCACHE_ALIGN for SLUB

3. Fulfills the role of SLAB_HWCACHE_ALIGN for SLOB.

The only remaining use is in sparc64 and ppc64 and their use there
reflects some earlier role that the slab flag once may have had. If
its specified then SLAB_HWCACHE_ALIGN is also specified.

The flag is confusing, inconsistent and has no purpose.

Remove it.

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff -puN mm/slub.c~slub-slab-allocators-remove-obsolete-slab_must_hwcache_align mm/slub.c
--- a/mm/slub.c~slub-slab-allocators-remove-obsolete-slab_must_hwcache_align
+++ a/mm/slub.c
@@ -1496,7 +1496,7 @@ static unsigned long calculate_alignment
 	 * specified alignment though. If that is greater
 	 * then use it.
 	 */
-	if ((flags & (SLAB_MUST_HWCACHE_ALIGN | SLAB_HWCACHE_ALIGN)) &&
+	if ((flags & SLAB_HWCACHE_ALIGN) &&
 			size > L1_CACHE_BYTES / 2)
 		return max_t(unsigned long, align, L1_CACHE_BYTES);
 
@@ -3142,8 +3142,7 @@ SLAB_ATTR(reclaim_account);
 
 static ssize_t hwcache_align_show(struct kmem_cache *s, char *buf)
 {
-	return sprintf(buf, "%d\n", !!(s->flags &
-		(SLAB_HWCACHE_ALIGN|SLAB_MUST_HWCACHE_ALIGN)));
+	return sprintf(buf, "%d\n", !!(s->flags & SLAB_HWCACHE_ALIGN));
 }
 SLAB_ATTR_RO(hwcache_align);
 
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
