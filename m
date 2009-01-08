From: akpm@linux-foundation.org
Subject: - kmemleak-add-the-slub-memory-allocation-freeing-hooks.patch removed from -mm tree
Date: Thu, 08 Jan 2009 14:46:02 -0800
Message-ID: <200901082246.n08Mk2YV025575@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57238 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757042AbZAHWrM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jan 2009 17:47:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: catalin.marinas@arm.com, cl@linux-foundation.org, penberg@cs.helsinki.fi, mm-commits@vger.kernel.org


The patch titled
     kmemleak: add the slub memory allocation/freeing hooks
has been removed from the -mm tree.  Its filename was
     kmemleak-add-the-slub-memory-allocation-freeing-hooks.patch

This patch was dropped because other changes were merged, which wrecked this patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kmemleak: add the slub memory allocation/freeing hooks
From: Catalin Marinas <catalin.marinas@arm.com>

Add the callbacks to kmemleak_(alloc|free) functions from the slub
allocator.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN mm/slub.c~kmemleak-add-the-slub-memory-allocation-freeing-hooks mm/slub.c
--- a/mm/slub.c~kmemleak-add-the-slub-memory-allocation-freeing-hooks
+++ a/mm/slub.c
@@ -19,6 +19,7 @@
 #include <trace/kmemtrace.h>
 #include <linux/cpu.h>
 #include <linux/cpuset.h>
+#include <linux/kmemleak.h>
 #include <linux/mempolicy.h>
 #include <linux/ctype.h>
 #include <linux/debugobjects.h>
@@ -143,7 +144,7 @@
  * Set of flags that will prevent slab merging
  */
 #define SLUB_NEVER_MERGE (SLAB_RED_ZONE | SLAB_POISON | SLAB_STORE_USER | \
-		SLAB_TRACE | SLAB_DESTROY_BY_RCU)
+		SLAB_TRACE | SLAB_DESTROY_BY_RCU | SLAB_NOLEAKTRACE)
 
 #define SLUB_MERGE_SAME (SLAB_DEBUG_FREE | SLAB_RECLAIM_ACCOUNT | \
 		SLAB_CACHE_DMA | SLAB_NOTRACK)
@@ -1630,6 +1631,7 @@ static __always_inline void *slab_alloc(
 	if (unlikely((gfpflags & __GFP_ZERO) && object))
 		memset(object, 0, objsize);
 
+	kmemleak_alloc_recursive(object, objsize, 1, s->flags, gfpflags);
 	kmemcheck_slab_alloc(s, gfpflags, object, c->objsize);
 	return object;
 }
@@ -1761,6 +1763,7 @@ static __always_inline void slab_free(st
 	struct kmem_cache_cpu *c;
 	unsigned long flags;
 
+	kmemleak_free_recursive(x, s->flags);
 	local_irq_save(flags);
 	c = get_cpu_slab(s, smp_processor_id());
 	kmemcheck_slab_free(s, object, c->objsize);
_

Patches currently in -mm which might be from catalin.marinas@arm.com are

origin.patch
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

