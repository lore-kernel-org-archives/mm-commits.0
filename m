From: akpm@linux-foundation.org
Subject: + slub-add-support-for-kmem_cache_debug-in-bulk-calls.patch added to -mm tree
Date: Thu, 09 Jul 2015 12:03:15 -0700
Message-ID: <559ec573.TO/UZfYnEk4Krb2T%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47913 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179AbbGITDQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Jul 2015 15:03:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: brouer@redhat.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slub: add support for kmem_cache_debug in bulk calls
has been added to the -mm tree.  Its filename is
     slub-add-support-for-kmem_cache_debug-in-bulk-calls.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/slub-add-support-for-kmem_cache_debug-in-bulk-calls.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/slub-add-support-for-kmem_cache_debug-in-bulk-calls.patch

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
Subject: slub: add support for kmem_cache_debug in bulk calls

Per request of Joonsoo Kim adding kmem debug support.

I've tested that when debugging is disabled, then there is almost no
performance impact as this code basically gets removed by the compiler.

Need some guidance in enabling and testing this.

bulk- PREVIOUS                  - THIS-PATCH
  1 -  43 cycles(tsc) 10.811 ns -  44 cycles(tsc) 11.236 ns  improved  -2.3%
  2 -  27 cycles(tsc)  6.867 ns -  28 cycles(tsc)  7.019 ns  improved  -3.7%
  3 -  21 cycles(tsc)  5.496 ns -  22 cycles(tsc)  5.526 ns  improved  -4.8%
  4 -  24 cycles(tsc)  6.038 ns -  19 cycles(tsc)  4.786 ns  improved  20.8%
  8 -  17 cycles(tsc)  4.280 ns -  18 cycles(tsc)  4.572 ns  improved  -5.9%
 16 -  17 cycles(tsc)  4.483 ns -  18 cycles(tsc)  4.658 ns  improved  -5.9%
 30 -  18 cycles(tsc)  4.531 ns -  18 cycles(tsc)  4.568 ns  improved   0.0%
 32 -  58 cycles(tsc) 14.586 ns -  65 cycles(tsc) 16.454 ns  improved -12.1%
 34 -  53 cycles(tsc) 13.391 ns -  63 cycles(tsc) 15.932 ns  improved -18.9%
 48 -  65 cycles(tsc) 16.268 ns -  50 cycles(tsc) 12.506 ns  improved  23.1%
 64 -  53 cycles(tsc) 13.440 ns -  63 cycles(tsc) 15.929 ns  improved -18.9%
128 -  79 cycles(tsc) 19.899 ns -  86 cycles(tsc) 21.583 ns  improved  -8.9%
158 -  90 cycles(tsc) 22.732 ns -  90 cycles(tsc) 22.552 ns  improved   0.0%
250 -  95 cycles(tsc) 23.916 ns -  98 cycles(tsc) 24.589 ns  improved  -3.2%

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

diff -puN mm/slub.c~slub-add-support-for-kmem_cache_debug-in-bulk-calls mm/slub.c
--- a/mm/slub.c~slub-add-support-for-kmem_cache_debug-in-bulk-calls
+++ a/mm/slub.c
@@ -2757,10 +2757,6 @@ void kmem_cache_free_bulk(struct kmem_ca
 	struct page *page;
 	int i;
 
-	/* Debugging fallback to generic bulk */
-	if (kmem_cache_debug(s))
-		return __kmem_cache_free_bulk(s, size, p);
-
 	local_irq_disable();
 	c = this_cpu_ptr(s->cpu_slab);
 
@@ -2768,8 +2764,13 @@ void kmem_cache_free_bulk(struct kmem_ca
 		void *object = p[i];
 
 		BUG_ON(!object);
+		/* kmem cache debug support */
+		s = cache_from_obj(s, object);
+		if (unlikely(!s))
+			goto exit;
+		slab_free_hook(s, object);
+
 		page = virt_to_head_page(object);
-		BUG_ON(s != page->slab_cache); /* Check if valid slab page */
 
 		if (c->page == page) {
 			/* Fastpath: local CPU free */
@@ -2784,6 +2785,7 @@ void kmem_cache_free_bulk(struct kmem_ca
 			c = this_cpu_ptr(s->cpu_slab);
 		}
 	}
+exit:
 	c->tid = next_tid(c->tid);
 	local_irq_enable();
 }
@@ -2796,10 +2798,6 @@ bool kmem_cache_alloc_bulk(struct kmem_c
 	struct kmem_cache_cpu *c;
 	int i;
 
-	/* Debugging fallback to generic bulk */
-	if (kmem_cache_debug(s))
-		return __kmem_cache_alloc_bulk(s, flags, size, p);
-
 	/*
 	 * Drain objects in the per cpu slab, while disabling local
 	 * IRQs, which protects against PREEMPT and interrupts
@@ -2828,8 +2826,20 @@ bool kmem_cache_alloc_bulk(struct kmem_c
 			continue; /* goto for-loop */
 		}
 
+		/* kmem_cache debug support */
+		s = slab_pre_alloc_hook(s, flags);
+		if (unlikely(!s)) {
+			__kmem_cache_free_bulk(s, i, p);
+			c->tid = next_tid(c->tid);
+			local_irq_enable();
+			return false;
+		}
+
 		c->freelist = get_freepointer(s, object);
 		p[i] = object;
+
+		/* kmem_cache debug support */
+		slab_post_alloc_hook(s, flags, object);
 	}
 	c->tid = next_tid(c->tid);
 	local_irq_enable();
_

Patches currently in -mm which might be from brouer@redhat.com are

slub-fix-spelling-succedd-to-succeed.patch
slab-infrastructure-for-bulk-object-allocation-and-freeing.patch
slub-bulk-alloc-extract-objects-from-the-per-cpu-slab.patch
slub-improve-bulk-alloc-strategy.patch
slub-initial-bulk-free-implementation.patch
slub-add-support-for-kmem_cache_debug-in-bulk-calls.patch

