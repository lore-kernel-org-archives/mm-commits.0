From: akpm@linux-foundation.org
Subject: + slab-implement-bulk-free-in-slab-allocator.patch added to -mm
 tree
Date: Tue, 26 Jan 2016 20:40:11 -0800
Message-ID: <56a84a2b.sNF1JacSw8frICxE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60820 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753036AbcA0EkM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jan 2016 23:40:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: brouer@redhat.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slab: implement bulk free in SLAB allocator
has been added to the -mm tree.  Its filename is
     slab-implement-bulk-free-in-slab-allocator.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/slab-implement-bulk-free-in-slab-allocator.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/slab-implement-bulk-free-in-slab-allocator.patch

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
Subject: slab: implement bulk free in SLAB allocator

This patch implements the free side of bulk API for the SLAB allocator
kmem_cache_free_bulk(), and concludes the implementation of optimized bulk
API for SLAB allocator.

Benchmarked[1] cost of alloc+free (obj size 256 bytes) on CPU i7-4790K @
4.00GHz, with no debug options, no PREEMPT and CONFIG_MEMCG_KMEM=y but no
active user of kmemcg.

SLAB single alloc+free cost: 87 cycles(tsc) 21.814 ns with this
optimized config.

bulk- Current fallback          - optimized SLAB bulk
  1 - 102 cycles(tsc) 25.747 ns - 41 cycles(tsc) 10.490 ns - improved 59.8%
  2 -  94 cycles(tsc) 23.546 ns - 26 cycles(tsc)  6.567 ns - improved 72.3%
  3 -  92 cycles(tsc) 23.127 ns - 20 cycles(tsc)  5.244 ns - improved 78.3%
  4 -  90 cycles(tsc) 22.663 ns - 18 cycles(tsc)  4.588 ns - improved 80.0%
  8 -  88 cycles(tsc) 22.242 ns - 14 cycles(tsc)  3.656 ns - improved 84.1%
 16 -  88 cycles(tsc) 22.010 ns - 13 cycles(tsc)  3.480 ns - improved 85.2%
 30 -  89 cycles(tsc) 22.305 ns - 13 cycles(tsc)  3.303 ns - improved 85.4%
 32 -  89 cycles(tsc) 22.277 ns - 13 cycles(tsc)  3.309 ns - improved 85.4%
 34 -  88 cycles(tsc) 22.246 ns - 13 cycles(tsc)  3.294 ns - improved 85.2%
 48 -  88 cycles(tsc) 22.121 ns - 13 cycles(tsc)  3.492 ns - improved 85.2%
 64 -  88 cycles(tsc) 22.052 ns - 13 cycles(tsc)  3.411 ns - improved 85.2%
128 -  89 cycles(tsc) 22.452 ns - 15 cycles(tsc)  3.841 ns - improved 83.1%
158 -  89 cycles(tsc) 22.403 ns - 14 cycles(tsc)  3.746 ns - improved 84.3%
250 -  91 cycles(tsc) 22.775 ns - 16 cycles(tsc)  4.111 ns - improved 82.4%

Notice it is not recommended to do very large bulk operation with
this bulk API, because local IRQs are disabled in this period.

[1] https://github.com/netoptimizer/prototype-kernel/blob/master/kernel/mm/slab_bulk_test01.c

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |   29 +++++++++++++++++++++++------
 1 file changed, 23 insertions(+), 6 deletions(-)

diff -puN mm/slab.c~slab-implement-bulk-free-in-slab-allocator mm/slab.c
--- a/mm/slab.c~slab-implement-bulk-free-in-slab-allocator
+++ a/mm/slab.c
@@ -3383,12 +3383,6 @@ void *kmem_cache_alloc(struct kmem_cache
 }
 EXPORT_SYMBOL(kmem_cache_alloc);
 
-void kmem_cache_free_bulk(struct kmem_cache *s, size_t size, void **p)
-{
-	__kmem_cache_free_bulk(s, size, p);
-}
-EXPORT_SYMBOL(kmem_cache_free_bulk);
-
 static __always_inline void
 cache_alloc_debugcheck_after_bulk(struct kmem_cache *s, gfp_t flags,
 				  size_t size, void **p, unsigned long caller)
@@ -3582,6 +3576,29 @@ void kmem_cache_free(struct kmem_cache *
 }
 EXPORT_SYMBOL(kmem_cache_free);
 
+void kmem_cache_free_bulk(struct kmem_cache *orig_s, size_t size, void **p)
+{
+	struct kmem_cache *s;
+	size_t i;
+
+	local_irq_disable();
+	for (i = 0; i < size; i++) {
+		void *objp = p[i];
+
+		s = cache_from_obj(orig_s, objp);
+
+		debug_check_no_locks_freed(objp, s->object_size);
+		if (!(s->flags & SLAB_DEBUG_OBJECTS))
+			debug_check_no_obj_freed(objp, s->object_size);
+
+		__cache_free(s, objp, _RET_IP_);
+	}
+	local_irq_enable();
+
+	/* FIXME: add tracing */
+}
+EXPORT_SYMBOL(kmem_cache_free_bulk);
+
 /**
  * kfree - free previously allocated memory
  * @objp: pointer returned by kmalloc.
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

