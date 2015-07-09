From: akpm@linux-foundation.org
Subject: + slub-bulk-alloc-extract-objects-from-the-per-cpu-slab.patch
 added to -mm tree
Date: Thu, 09 Jul 2015 12:03:09 -0700
Message-ID: <559ec56d.xEjD2X9O+NVZKtw6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47896 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128AbbGITDL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Jul 2015 15:03:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: brouer@redhat.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slub bulk alloc: extract objects from the per cpu slab
has been added to the -mm tree.  Its filename is
     slub-bulk-alloc-extract-objects-from-the-per-cpu-slab.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/slub-bulk-alloc-extract-objects-from-the-per-cpu-slab.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/slub-bulk-alloc-extract-objects-from-the-per-cpu-slab.patch

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
Subject: slub bulk alloc: extract objects from the per cpu slab

First piece: acceleration of retrieval of per cpu objects

If we are allocating lots of objects then it is advantageous to disable
interrupts and avoid the this_cpu_cmpxchg() operation to get these objects
faster.

Note that we cannot do the fast operation if debugging is enabled, because
we would have to add extra code to do all the debugging checks.  And it
would not be fast anyway.

Note also that the requirement of having interrupts disabled avoids having
to do processor flag operations.

Allocate as many objects as possible in the fast way and then fall back to
the generic implementation for the rest of the objects.

Measurements on CPU CPU i7-4790K @ 4.00GHz
Baseline normal fastpath (alloc+free cost): 42 cycles(tsc) 10.554 ns

Bulk- fallback                   - this-patch
  1 -  57 cycles(tsc) 14.432 ns  -  48 cycles(tsc) 12.155 ns  improved 15.8%
  2 -  50 cycles(tsc) 12.746 ns  -  37 cycles(tsc)  9.390 ns  improved 26.0%
  3 -  48 cycles(tsc) 12.180 ns  -  33 cycles(tsc)  8.417 ns  improved 31.2%
  4 -  48 cycles(tsc) 12.015 ns  -  32 cycles(tsc)  8.045 ns  improved 33.3%
  8 -  46 cycles(tsc) 11.526 ns  -  30 cycles(tsc)  7.699 ns  improved 34.8%
 16 -  45 cycles(tsc) 11.418 ns  -  32 cycles(tsc)  8.205 ns  improved 28.9%
 30 -  80 cycles(tsc) 20.246 ns  -  73 cycles(tsc) 18.328 ns  improved  8.8%
 32 -  79 cycles(tsc) 19.946 ns  -  72 cycles(tsc) 18.208 ns  improved  8.9%
 34 -  78 cycles(tsc) 19.659 ns  -  71 cycles(tsc) 17.987 ns  improved  9.0%
 48 -  86 cycles(tsc) 21.516 ns  -  82 cycles(tsc) 20.566 ns  improved  4.7%
 64 -  93 cycles(tsc) 23.423 ns  -  89 cycles(tsc) 22.480 ns  improved  4.3%
128 - 100 cycles(tsc) 25.170 ns  -  99 cycles(tsc) 24.871 ns  improved  1.0%
158 - 102 cycles(tsc) 25.549 ns  - 101 cycles(tsc) 25.375 ns  improved  1.0%
250 - 101 cycles(tsc) 25.344 ns  - 100 cycles(tsc) 25.182 ns  improved  1.0%

Signed-off-by: Christoph Lameter <cl@linux.com>
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   49 +++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 47 insertions(+), 2 deletions(-)

diff -puN mm/slub.c~slub-bulk-alloc-extract-objects-from-the-per-cpu-slab mm/slub.c
--- a/mm/slub.c~slub-bulk-alloc-extract-objects-from-the-per-cpu-slab
+++ a/mm/slub.c
@@ -2750,16 +2750,61 @@ void kmem_cache_free(struct kmem_cache *
 }
 EXPORT_SYMBOL(kmem_cache_free);
 
+/* Note that interrupts must be enabled when calling this function. */
 void kmem_cache_free_bulk(struct kmem_cache *s, size_t size, void **p)
 {
 	__kmem_cache_free_bulk(s, size, p);
 }
 EXPORT_SYMBOL(kmem_cache_free_bulk);
 
+/* Note that interrupts must be enabled when calling this function. */
 bool kmem_cache_alloc_bulk(struct kmem_cache *s, gfp_t flags, size_t size,
-								void **p)
+			   void **p)
 {
-	return __kmem_cache_alloc_bulk(s, flags, size, p);
+	struct kmem_cache_cpu *c;
+	int i;
+
+	/* Debugging fallback to generic bulk */
+	if (kmem_cache_debug(s))
+		return __kmem_cache_alloc_bulk(s, flags, size, p);
+
+	/*
+	 * Drain objects in the per cpu slab, while disabling local
+	 * IRQs, which protects against PREEMPT and interrupts
+	 * handlers invoking normal fastpath.
+	 */
+	local_irq_disable();
+	c = this_cpu_ptr(s->cpu_slab);
+
+	for (i = 0; i < size; i++) {
+		void *object = c->freelist;
+
+		if (!object)
+			break;
+
+		c->freelist = get_freepointer(s, object);
+		p[i] = object;
+	}
+	c->tid = next_tid(c->tid);
+	local_irq_enable();
+
+	/* Clear memory outside IRQ disabled fastpath loop */
+	if (unlikely(flags & __GFP_ZERO)) {
+		int j;
+
+		for (j = 0; j < i; j++)
+			memset(p[j], 0, s->object_size);
+	}
+
+	/* Fallback to single elem alloc */
+	for (; i < size; i++) {
+		void *x = p[i] = kmem_cache_alloc(s, flags);
+		if (unlikely(!x)) {
+			__kmem_cache_free_bulk(s, i, p);
+			return false;
+		}
+	}
+	return true;
 }
 EXPORT_SYMBOL(kmem_cache_alloc_bulk);
 
_

Patches currently in -mm which might be from brouer@redhat.com are

slub-fix-spelling-succedd-to-succeed.patch
slab-infrastructure-for-bulk-object-allocation-and-freeing.patch
slub-bulk-alloc-extract-objects-from-the-per-cpu-slab.patch
slub-improve-bulk-alloc-strategy.patch
slub-initial-bulk-free-implementation.patch
slub-add-support-for-kmem_cache_debug-in-bulk-calls.patch

