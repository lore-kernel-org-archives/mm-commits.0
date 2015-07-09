From: akpm@linux-foundation.org
Subject: + slub-improve-bulk-alloc-strategy.patch added to -mm tree
Date: Thu, 09 Jul 2015 12:03:11 -0700
Message-ID: <559ec56f.Qd8VC2Y8Td8/dp5H%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47901 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885AbbGITDM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Jul 2015 15:03:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: brouer@redhat.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slub: improve bulk alloc strategy
has been added to the -mm tree.  Its filename is
     slub-improve-bulk-alloc-strategy.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/slub-improve-bulk-alloc-strategy.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/slub-improve-bulk-alloc-strategy.patch

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
Subject: slub: improve bulk alloc strategy

Call slowpath __slab_alloc() from within the bulk loop, as the side-effect
of this call likely repopulates c->freelist.

Choose to reenable local IRQs while calling slowpath.

Saving some optimizations for later.  E.g.  it is possible to extract
parts of __slab_alloc() and avoid the unnecessary and expensive (37
cycles) local_irq_{save,restore}.  For now, be happy calling
__slab_alloc() this lower icache impact of this func and I don't have to
worry about correctness.

Measurements on CPU CPU i7-4790K @ 4.00GHz
Baseline normal fastpath (alloc+free cost): 42 cycles(tsc) 10.601 ns

Bulk- fallback                   - this-patch
  1 -  58 cycles(tsc) 14.516 ns  -  49 cycles(tsc) 12.459 ns  improved 15.5%
  2 -  51 cycles(tsc) 12.930 ns  -  38 cycles(tsc)  9.605 ns  improved 25.5%
  3 -  49 cycles(tsc) 12.274 ns  -  34 cycles(tsc)  8.525 ns  improved 30.6%
  4 -  48 cycles(tsc) 12.058 ns  -  32 cycles(tsc)  8.036 ns  improved 33.3%
  8 -  46 cycles(tsc) 11.609 ns  -  31 cycles(tsc)  7.756 ns  improved 32.6%
 16 -  45 cycles(tsc) 11.451 ns  -  32 cycles(tsc)  8.148 ns  improved 28.9%
 30 -  79 cycles(tsc) 19.865 ns  -  68 cycles(tsc) 17.164 ns  improved 13.9%
 32 -  76 cycles(tsc) 19.212 ns  -  66 cycles(tsc) 16.584 ns  improved 13.2%
 34 -  74 cycles(tsc) 18.600 ns  -  63 cycles(tsc) 15.954 ns  improved 14.9%
 48 -  88 cycles(tsc) 22.092 ns  -  77 cycles(tsc) 19.373 ns  improved 12.5%
 64 -  80 cycles(tsc) 20.043 ns  -  68 cycles(tsc) 17.188 ns  improved 15.0%
128 -  99 cycles(tsc) 24.818 ns  -  89 cycles(tsc) 22.404 ns  improved 10.1%
158 -  99 cycles(tsc) 24.977 ns  -  92 cycles(tsc) 23.089 ns  improved  7.1%
250 - 106 cycles(tsc) 26.552 ns  -  99 cycles(tsc) 24.785 ns  improved  6.6%

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff -puN mm/slub.c~slub-improve-bulk-alloc-strategy mm/slub.c
--- a/mm/slub.c~slub-improve-bulk-alloc-strategy
+++ a/mm/slub.c
@@ -2779,8 +2779,22 @@ bool kmem_cache_alloc_bulk(struct kmem_c
 	for (i = 0; i < size; i++) {
 		void *object = c->freelist;
 
-		if (!object)
-			break;
+		if (unlikely(!object)) {
+			local_irq_enable();
+			/*
+			 * Invoking slow path likely have side-effect
+			 * of re-populating per CPU c->freelist
+			 */
+			p[i] = __slab_alloc(s, flags, NUMA_NO_NODE,
+					    _RET_IP_, c);
+			if (unlikely(!p[i])) {
+				__kmem_cache_free_bulk(s, i, p);
+				return false;
+			}
+			local_irq_disable();
+			c = this_cpu_ptr(s->cpu_slab);
+			continue; /* goto for-loop */
+		}
 
 		c->freelist = get_freepointer(s, object);
 		p[i] = object;
@@ -2796,14 +2810,6 @@ bool kmem_cache_alloc_bulk(struct kmem_c
 			memset(p[j], 0, s->object_size);
 	}
 
-	/* Fallback to single elem alloc */
-	for (; i < size; i++) {
-		void *x = p[i] = kmem_cache_alloc(s, flags);
-		if (unlikely(!x)) {
-			__kmem_cache_free_bulk(s, i, p);
-			return false;
-		}
-	}
 	return true;
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

