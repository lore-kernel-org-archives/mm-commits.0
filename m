From: akpm@linux-foundation.org
Subject: + kmemleak-add-the-slub-memory-allocation-freeing-hooks.patch added to -mm tree
Date: Mon, 29 Dec 2008 16:22:57 -0800
Message-ID: <200812300022.mBU0MvX8005931@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53698 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752736AbYL3AXQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Dec 2008 19:23:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: catalin.marinas@arm.com, cl@linux-foundation.org, penberg@cs.helsinki.fi


The patch titled
     kmemleak: add the slub memory allocation/freeing hooks
has been added to the -mm tree.  Its filename is
     kmemleak-add-the-slub-memory-allocation-freeing-hooks.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -18,6 +18,7 @@
 #include <linux/seq_file.h>
 #include <linux/cpu.h>
 #include <linux/cpuset.h>
+#include <linux/kmemleak.h>
 #include <linux/mempolicy.h>
 #include <linux/ctype.h>
 #include <linux/debugobjects.h>
@@ -142,7 +143,7 @@
  * Set of flags that will prevent slab merging
  */
 #define SLUB_NEVER_MERGE (SLAB_RED_ZONE | SLAB_POISON | SLAB_STORE_USER | \
-		SLAB_TRACE | SLAB_DESTROY_BY_RCU)
+		SLAB_TRACE | SLAB_DESTROY_BY_RCU | SLAB_NOLEAKTRACE)
 
 #define SLUB_MERGE_SAME (SLAB_DEBUG_FREE | SLAB_RECLAIM_ACCOUNT | \
 		SLAB_CACHE_DMA | SLAB_NOTRACK)
@@ -1634,6 +1635,7 @@ static __always_inline void *slab_alloc(
 	if (unlikely((gfpflags & __GFP_ZERO) && object))
 		memset(object, 0, objsize);
 
+	kmemleak_alloc_recursive(object, objsize, 1, s->flags, gfpflags);
 	kmemcheck_slab_alloc(s, gfpflags, object, c->objsize);
 	return object;
 }
@@ -1765,6 +1767,7 @@ static __always_inline void slab_free(st
 	struct kmem_cache_cpu *c;
 	unsigned long flags;
 
+	kmemleak_free_recursive(x, s->flags);
 	local_irq_save(flags);
 	c = get_cpu_slab(s, smp_processor_id());
 	kmemcheck_slab_free(s, object, c->objsize);
_

Patches currently in -mm which might be from catalin.marinas@arm.com are

origin.patch
linux-next.patch
kmemleak-add-the-base-support.patch
kmemleak-add-the-base-support-fix.patch
kmemleak-add-documentation-on-the-memory-leak-detector.patch
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

