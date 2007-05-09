From: akpm@linux-foundation.org
Subject: - slub-clean-up-krealloc.patch removed from -mm tree
Date: Wed, 09 May 2007 14:47:55 -0700
Message-ID: <200705092147.l49LltlV002525@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:40990 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757203AbXEIVr5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:47:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     SLUB: clean up krealloc
has been removed from the -mm tree.  Its filename was
     slub-clean-up-krealloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: SLUB: clean up krealloc
From: Christoph Lameter <clameter@sgi.com>

We really do not need all this gaga there.

ksize gives us all the information we need to figure out if the object can
cope with the new size.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff -puN mm/slub.c~slub-clean-up-krealloc mm/slub.c
--- a/mm/slub.c~slub-clean-up-krealloc
+++ a/mm/slub.c
@@ -2199,9 +2199,8 @@ EXPORT_SYMBOL(kmem_cache_shrink);
  */
 void *krealloc(const void *p, size_t new_size, gfp_t flags)
 {
-	struct kmem_cache *new_cache;
 	void *ret;
-	struct page *page;
+	size_t ks;
 
 	if (unlikely(!p))
 		return kmalloc(new_size, flags);
@@ -2211,19 +2210,13 @@ void *krealloc(const void *p, size_t new
 		return NULL;
 	}
 
-	page = virt_to_head_page(p);
-
-	new_cache = get_slab(new_size, flags);
-
-	/*
- 	 * If new size fits in the current cache, bail out.
- 	 */
-	if (likely(page->slab == new_cache))
+	ks = ksize(p);
+	if (ks >= new_size)
 		return (void *)p;
 
 	ret = kmalloc(new_size, flags);
 	if (ret) {
-		memcpy(ret, p, min(new_size, ksize(p)));
+		memcpy(ret, p, min(new_size, ks));
 		kfree(p);
 	}
 	return ret;
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
slub-support-concurrent-local-and-remote-frees-and-allocs-on-a-slab.patch
quicklist-support-for-ia64.patch
quicklist-support-for-x86_64.patch
slub-exploit-page-mobility-to-increase-allocation-order.patch
slub-mm-only-make-slub-the-default-slab-allocator.patch
slub-reduce-antifrag-max-order.patch
slub-i386-support.patch
define-percpu-smp-cacheline-align-interface.patch
call-percpu-smp-cacheline-algin-interface.patch
remove-constructor-from-buffer_head.patch
mm-implement-swap-prefetching.patch
revoke-core-code.patch
