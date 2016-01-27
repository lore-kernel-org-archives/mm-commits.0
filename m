From: akpm@linux-foundation.org
Subject: +
 slab-avoid-running-debug-slab-code-with-irqs-disabled-for-alloc_bulk.patch
 added to -mm tree
Date: Tue, 26 Jan 2016 19:29:13 -0800
Message-ID: <56a83989.3lqFepR7H+rJCZYW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55796 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477AbcA0D3O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jan 2016 22:29:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: brouer@redhat.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slab: avoid running debug SLAB code with IRQs disabled for alloc_bulk
has been added to the -mm tree.  Its filename is
     slab-avoid-running-debug-slab-code-with-irqs-disabled-for-alloc_bulk.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/slab-avoid-running-debug-slab-code-with-irqs-disabled-for-alloc_bulk.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/slab-avoid-running-debug-slab-code-with-irqs-disabled-for-alloc_bulk.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jesper Dangaard Brouer <brouer@redhat.com>
Subject: slab: avoid running debug SLAB code with IRQs disabled for alloc_bulk

Move the call to cache_alloc_debugcheck_after() outside the IRQ disabled
section in kmem_cache_alloc_bulk().

When CONFIG_DEBUG_SLAB is disabled the compiler should remove this code.

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff -puN mm/slab.c~slab-avoid-running-debug-slab-code-with-irqs-disabled-for-alloc_bulk mm/slab.c
--- a/mm/slab.c~slab-avoid-running-debug-slab-code-with-irqs-disabled-for-alloc_bulk
+++ a/mm/slab.c
@@ -3389,6 +3389,16 @@ void kmem_cache_free_bulk(struct kmem_ca
 }
 EXPORT_SYMBOL(kmem_cache_free_bulk);
 
+static __always_inline void
+cache_alloc_debugcheck_after_bulk(struct kmem_cache *s, gfp_t flags,
+				  size_t size, void **p, unsigned long caller)
+{
+	size_t i;
+
+	for (i = 0; i < size; i++)
+		p[i] = cache_alloc_debugcheck_after(s, flags, p[i], caller);
+}
+
 int kmem_cache_alloc_bulk(struct kmem_cache *s, gfp_t flags, size_t size,
 			  void **p)
 {
@@ -3404,15 +3414,14 @@ int kmem_cache_alloc_bulk(struct kmem_ca
 	for (i = 0; i < size; i++) {
 		void *objp = __do_cache_alloc(s, flags);
 
-		/* this call could be done outside IRQ disabled section */
-		objp = cache_alloc_debugcheck_after(s, flags, objp, _RET_IP_);
-
 		if (unlikely(!objp))
 			goto error;
 		p[i] = objp;
 	}
 	local_irq_enable();
 
+	cache_alloc_debugcheck_after_bulk(s, flags, size, p, _RET_IP_);
+
 	/* Clear memory outside IRQ disabled section */
 	if (unlikely(flags & __GFP_ZERO))
 		for (i = 0; i < size; i++)
@@ -3423,6 +3432,7 @@ int kmem_cache_alloc_bulk(struct kmem_ca
 	return size;
 error:
 	local_irq_enable();
+	cache_alloc_debugcheck_after_bulk(s, flags, i, p, _RET_IP_);
 	slab_post_alloc_hook(s, flags, i, p);
 	__kmem_cache_free_bulk(s, i, p);
 	return 0;
_

Patches currently in -mm which might be from brouer@redhat.com are

slub-cleanup-code-for-kmem-cgroup-support-to-kmem_cache_free_bulk.patch
mm-slab-move-slub-alloc-hooks-to-common-mm-slabh.patch
mm-fault-inject-take-over-bootstrap-kmem_cache-check.patch
slab-use-slab_pre_alloc_hook-in-slab-allocator-shared-with-slub.patch
mm-kmemcheck-skip-object-if-slab-allocation-failed.patch
slab-use-slab_post_alloc_hook-in-slab-allocator-shared-with-slub.patch
slab-implement-bulk-alloc-in-slab-allocator.patch
slab-avoid-running-debug-slab-code-with-irqs-disabled-for-alloc_bulk.patch
slab-implement-bulk-free-in-slab-allocator.patch
mm-new-api-kfree_bulk-for-slabslub-allocators.patch
mm-fix-some-spelling.patch

