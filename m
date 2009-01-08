From: akpm@linux-foundation.org
Subject: - kmemleak-add-the-slob-memory-allocation-freeing-hooks.patch removed from -mm tree
Date: Thu, 08 Jan 2009 14:45:59 -0800
Message-ID: <200901082245.n08MjxWp025530@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47241 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756793AbZAHWrM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jan 2009 17:47:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: catalin.marinas@arm.com, mpm@selenic.com, penberg@cs.helsinki.fi, mm-commits@vger.kernel.org


The patch titled
     kmemleak: add the slob memory allocation/freeing hooks
has been removed from the -mm tree.  Its filename was
     kmemleak-add-the-slob-memory-allocation-freeing-hooks.patch

This patch was dropped because other changes were merged, which wrecked this patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kmemleak: add the slob memory allocation/freeing hooks
From: Catalin Marinas <catalin.marinas@arm.com>

Add the callbacks to kmemleak_(alloc|free) functions from the slob
allocator.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Matt Mackall <mpm@selenic.com>
Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slob.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN mm/slob.c~kmemleak-add-the-slob-memory-allocation-freeing-hooks mm/slob.c
--- a/mm/slob.c~kmemleak-add-the-slob-memory-allocation-freeing-hooks
+++ a/mm/slob.c
@@ -60,6 +60,7 @@
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/mm.h>
+#include <linux/kmemleak.h>
 #include <linux/cache.h>
 #include <linux/init.h>
 #include <linux/module.h>
@@ -494,7 +495,7 @@ void *__kmalloc_node(size_t size, gfp_t 
 					  _RET_IP_, ret,
 					  size, PAGE_SIZE << order, gfp, node);
 	}
-
+	kmemleak_alloc(ret, size, 1, gfp);
 	return ret;
 }
 EXPORT_SYMBOL(__kmalloc_node);
@@ -505,6 +506,7 @@ void kfree(const void *block)
 
 	if (unlikely(ZERO_OR_NULL_PTR(block)))
 		return;
+	kmemleak_free(block);
 
 	sp = (struct slob_page *)virt_to_page(block);
 	if (slob_page(sp)) {
@@ -569,12 +571,14 @@ struct kmem_cache *kmem_cache_create(con
 	} else if (flags & SLAB_PANIC)
 		panic("Cannot create slab cache %s\n", name);
 
+	kmemleak_alloc(c, sizeof(struct kmem_cache), 1, GFP_KERNEL);
 	return c;
 }
 EXPORT_SYMBOL(kmem_cache_create);
 
 void kmem_cache_destroy(struct kmem_cache *c)
 {
+	kmemleak_free(c);
 	slob_free(c, sizeof(struct kmem_cache));
 }
 EXPORT_SYMBOL(kmem_cache_destroy);
@@ -600,6 +604,7 @@ void *kmem_cache_alloc_node(struct kmem_
 	if (c->ctor)
 		c->ctor(b);
 
+	kmemleak_alloc_recursive(b, c->size, 1, c->flags, flags);
 	return b;
 }
 EXPORT_SYMBOL(kmem_cache_alloc_node);
@@ -622,6 +627,7 @@ static void kmem_rcu_free(struct rcu_hea
 
 void kmem_cache_free(struct kmem_cache *c, void *b)
 {
+	kmemleak_free_recursive(b, c->flags);
 	if (unlikely(c->flags & SLAB_DESTROY_BY_RCU)) {
 		struct slob_rcu *slob_rcu;
 		slob_rcu = b + (c->size - sizeof(struct slob_rcu));
_

Patches currently in -mm which might be from catalin.marinas@arm.com are

origin.patch
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

