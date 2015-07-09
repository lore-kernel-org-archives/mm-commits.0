From: akpm@linux-foundation.org
Subject: + slub-initial-bulk-free-implementation.patch added to -mm tree
Date: Thu, 09 Jul 2015 12:03:13 -0700
Message-ID: <559ec571./e6yugGCjJILQupR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47907 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128AbbGITDO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Jul 2015 15:03:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: brouer@redhat.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slub: initial bulk free implementation
has been added to the -mm tree.  Its filename is
     slub-initial-bulk-free-implementation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/slub-initial-bulk-free-implementation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/slub-initial-bulk-free-implementation.patch

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
Subject: slub: initial bulk free implementation

This implements SLUB specific kmem_cache_free_bulk().  SLUB allocator now
both have bulk alloc and free implemented.

Choose to reenable local IRQs while calling slowpath __slab_free().  In
worst case, where all objects hit slowpath call, the performance should
still be faster than fallback function __kmem_cache_free_bulk(), because
local_irq_{disable+enable} is very fast (7-cycles), while the fallback
invokes this_cpu_cmpxchg() which is slightly slower (9-cycles). 
Nitpicking, this should be faster for N>=4, due to the entry cost of
local_irq_{disable+enable}.

Do notice that the save+restore variant is very expensive, this is key to
why this optimization works.

CPU: i7-4790K CPU @ 4.00GHz
 * local_irq_{disable,enable}:  7 cycles(tsc) - 1.821 ns
 * local_irq_{save,restore}  : 37 cycles(tsc) - 9.443 ns

Measurements on CPU CPU i7-4790K @ 4.00GHz
Baseline normal fastpath (alloc+free cost): 43 cycles(tsc) 10.834 ns

Bulk- fallback                   - this-patch
  1 -  58 cycles(tsc) 14.542 ns  -  43 cycles(tsc) 10.811 ns  improved 25.9%
  2 -  50 cycles(tsc) 12.659 ns  -  27 cycles(tsc)  6.867 ns  improved 46.0%
  3 -  48 cycles(tsc) 12.168 ns  -  21 cycles(tsc)  5.496 ns  improved 56.2%
  4 -  47 cycles(tsc) 11.987 ns  -  24 cycles(tsc)  6.038 ns  improved 48.9%
  8 -  46 cycles(tsc) 11.518 ns  -  17 cycles(tsc)  4.280 ns  improved 63.0%
 16 -  45 cycles(tsc) 11.366 ns  -  17 cycles(tsc)  4.483 ns  improved 62.2%
 30 -  45 cycles(tsc) 11.433 ns  -  18 cycles(tsc)  4.531 ns  improved 60.0%
 32 -  75 cycles(tsc) 18.983 ns  -  58 cycles(tsc) 14.586 ns  improved 22.7%
 34 -  71 cycles(tsc) 17.940 ns  -  53 cycles(tsc) 13.391 ns  improved 25.4%
 48 -  80 cycles(tsc) 20.077 ns  -  65 cycles(tsc) 16.268 ns  improved 18.8%
 64 -  71 cycles(tsc) 17.799 ns  -  53 cycles(tsc) 13.440 ns  improved 25.4%
128 -  91 cycles(tsc) 22.980 ns  -  79 cycles(tsc) 19.899 ns  improved 13.2%
158 - 100 cycles(tsc) 25.241 ns  -  90 cycles(tsc) 22.732 ns  improved 10.0%
250 - 102 cycles(tsc) 25.583 ns  -  95 cycles(tsc) 23.916 ns  improved  6.9%

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   34 +++++++++++++++++++++++++++++++++-
 1 file changed, 33 insertions(+), 1 deletion(-)

diff -puN mm/slub.c~slub-initial-bulk-free-implementation mm/slub.c
--- a/mm/slub.c~slub-initial-bulk-free-implementation
+++ a/mm/slub.c
@@ -2753,7 +2753,39 @@ EXPORT_SYMBOL(kmem_cache_free);
 /* Note that interrupts must be enabled when calling this function. */
 void kmem_cache_free_bulk(struct kmem_cache *s, size_t size, void **p)
 {
-	__kmem_cache_free_bulk(s, size, p);
+	struct kmem_cache_cpu *c;
+	struct page *page;
+	int i;
+
+	/* Debugging fallback to generic bulk */
+	if (kmem_cache_debug(s))
+		return __kmem_cache_free_bulk(s, size, p);
+
+	local_irq_disable();
+	c = this_cpu_ptr(s->cpu_slab);
+
+	for (i = 0; i < size; i++) {
+		void *object = p[i];
+
+		BUG_ON(!object);
+		page = virt_to_head_page(object);
+		BUG_ON(s != page->slab_cache); /* Check if valid slab page */
+
+		if (c->page == page) {
+			/* Fastpath: local CPU free */
+			set_freepointer(s, object, c->freelist);
+			c->freelist = object;
+		} else {
+			c->tid = next_tid(c->tid);
+			local_irq_enable();
+			/* Slowpath: overhead locked cmpxchg_double_slab */
+			__slab_free(s, page, object, _RET_IP_);
+			local_irq_disable();
+			c = this_cpu_ptr(s->cpu_slab);
+		}
+	}
+	c->tid = next_tid(c->tid);
+	local_irq_enable();
 }
 EXPORT_SYMBOL(kmem_cache_free_bulk);
 
_

Patches currently in -mm which might be from brouer@redhat.com are

slub-fix-spelling-succedd-to-succeed.patch
slab-infrastructure-for-bulk-object-allocation-and-freeing.patch
slub-bulk-alloc-extract-objects-from-the-per-cpu-slab.patch
slub-improve-bulk-alloc-strategy.patch
slub-initial-bulk-free-implementation.patch
slub-add-support-for-kmem_cache_debug-in-bulk-calls.patch

