From: akpm@linux-foundation.org
Subject: [merged] slab-implement-bulking-for-slab-allocator.patch removed
 from -mm tree
Date: Mon, 23 Nov 2015 12:15:34 -0800
Message-ID: <565373e6.Y4Px1tDRUd3UsyB2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53657 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753780AbbKWUPf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Nov 2015 15:15:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: brouer@redhat.com, alexander.h.duyck@redhat.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slab: implement bulking for SLAB allocator
has been removed from the -mm tree.  Its filename was
     slab-implement-bulking-for-slab-allocator.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jesper Dangaard Brouer <brouer@redhat.com>
Subject: slab: implement bulking for SLAB allocator

Implement a basic approach of bulking in the SLAB allocator.  Simply use
local_irq_{disable,enable} and call single alloc/free in a loop.  This
simple implementation approach is surprising fast.

Notice the normal SLAB fastpath is: 96 cycles (24.119 ns).  Below table
show that single object bulking only takes 42 cycles.  This can be
explained by the bulk APIs requirement to be called from a known interrupt
context, that is with interrupts enabled.  This allow us to avoid the
expensive (37 cycles) local_irq_{save,restore}, and instead use the much
faster (7 cycles) local_irq_{disable,restore}.

Benchmarked[1] obj size 256 bytes on CPU i7-4790K @ 4.00GHz:

bulk - Current                  - simple SLAB bulk implementation
  1 - 115 cycles(tsc) 28.812 ns - 42 cycles(tsc) 10.715 ns - improved 63.5%
  2 - 103 cycles(tsc) 25.956 ns - 27 cycles(tsc)  6.985 ns - improved 73.8%
  3 - 101 cycles(tsc) 25.336 ns - 22 cycles(tsc)  5.733 ns - improved 78.2%
  4 - 100 cycles(tsc) 25.147 ns - 21 cycles(tsc)  5.319 ns - improved 79.0%
  8 -  98 cycles(tsc) 24.616 ns - 18 cycles(tsc)  4.620 ns - improved 81.6%
 16 -  97 cycles(tsc) 24.408 ns - 17 cycles(tsc)  4.344 ns - improved 82.5%
 30 -  98 cycles(tsc) 24.641 ns - 16 cycles(tsc)  4.202 ns - improved 83.7%
 32 -  98 cycles(tsc) 24.607 ns - 16 cycles(tsc)  4.199 ns - improved 83.7%
 34 -  98 cycles(tsc) 24.605 ns - 18 cycles(tsc)  4.579 ns - improved 81.6%
 48 -  97 cycles(tsc) 24.463 ns - 17 cycles(tsc)  4.405 ns - improved 82.5%
 64 -  97 cycles(tsc) 24.370 ns - 17 cycles(tsc)  4.384 ns - improved 82.5%
128 -  99 cycles(tsc) 24.763 ns - 19 cycles(tsc)  4.755 ns - improved 80.8%
158 -  98 cycles(tsc) 24.708 ns - 18 cycles(tsc)  4.723 ns - improved 81.6%
250 - 101 cycles(tsc) 25.342 ns - 20 cycles(tsc)  5.035 ns - improved 80.2%

Also notice how well bulking maintains the performance when the bulk
size increases (which is a soar spot for the SLUB allocator).

Increasing the bulk size further:
 20 cycles(tsc)  5.214 ns (bulk: 512)
 30 cycles(tsc)  7.734 ns (bulk: 768)
 40 cycles(tsc) 10.244 ns (bulk:1024)
 72 cycles(tsc) 18.049 ns (bulk:2048)
 90 cycles(tsc) 22.585 ns (bulk:4096)

It is not recommended to perform large bulking with SLAB, as local
interrupts are disabled for the entire period.  If these kind of use-cases
evolve, this interface should be adjusted to mitigate/reduce the
interrupts off period.

[1] https://github.com/netoptimizer/prototype-kernel/blob/master/kernel/mm/slab_bulk_test01.c

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Alexander Duyck <alexander.h.duyck@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |   87 +++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 62 insertions(+), 25 deletions(-)

diff -puN mm/slab.c~slab-implement-bulking-for-slab-allocator mm/slab.c
--- a/mm/slab.c~slab-implement-bulking-for-slab-allocator
+++ a/mm/slab.c
@@ -3231,11 +3231,15 @@ __do_cache_alloc(struct kmem_cache *cach
 #endif /* CONFIG_NUMA */
 
 static __always_inline void *
-slab_alloc(struct kmem_cache *cachep, gfp_t flags, unsigned long caller)
+slab_alloc(struct kmem_cache *cachep, gfp_t flags, unsigned long caller,
+	   bool irq_off_needed)
 {
 	unsigned long save_flags;
 	void *objp;
 
+	/* Compiler need to remove irq_off_needed branch statements */
+	BUILD_BUG_ON(!__builtin_constant_p(irq_off_needed));
+
 	flags &= gfp_allowed_mask;
 
 	lockdep_trace_alloc(flags);
@@ -3246,9 +3250,11 @@ slab_alloc(struct kmem_cache *cachep, gf
 	cachep = memcg_kmem_get_cache(cachep, flags);
 
 	cache_alloc_debugcheck_before(cachep, flags);
-	local_irq_save(save_flags);
+	if (irq_off_needed)
+		local_irq_save(save_flags);
 	objp = __do_cache_alloc(cachep, flags);
-	local_irq_restore(save_flags);
+	if (irq_off_needed)
+		local_irq_restore(save_flags);
 	objp = cache_alloc_debugcheck_after(cachep, flags, objp, caller);
 	kmemleak_alloc_recursive(objp, cachep->object_size, 1, cachep->flags,
 				 flags);
@@ -3404,7 +3410,7 @@ static inline void __cache_free(struct k
  */
 void *kmem_cache_alloc(struct kmem_cache *cachep, gfp_t flags)
 {
-	void *ret = slab_alloc(cachep, flags, _RET_IP_);
+	void *ret = slab_alloc(cachep, flags, _RET_IP_, true);
 
 	trace_kmem_cache_alloc(_RET_IP_, ret,
 			       cachep->object_size, cachep->size, flags);
@@ -3413,16 +3419,23 @@ void *kmem_cache_alloc(struct kmem_cache
 }
 EXPORT_SYMBOL(kmem_cache_alloc);
 
-void kmem_cache_free_bulk(struct kmem_cache *s, size_t size, void **p)
-{
-	__kmem_cache_free_bulk(s, size, p);
-}
-EXPORT_SYMBOL(kmem_cache_free_bulk);
-
+/* Note that interrupts must be enabled when calling this function. */
 bool kmem_cache_alloc_bulk(struct kmem_cache *s, gfp_t flags, size_t size,
-								void **p)
+			   void **p)
 {
-	return __kmem_cache_alloc_bulk(s, flags, size, p);
+	size_t i;
+
+	local_irq_disable();
+	for (i = 0; i < size; i++) {
+		void *x = p[i] = slab_alloc(s, flags, _RET_IP_, false);
+
+		if (!x) {
+			__kmem_cache_free_bulk(s, i, p);
+			return false;
+		}
+	}
+	local_irq_enable();
+	return true;
 }
 EXPORT_SYMBOL(kmem_cache_alloc_bulk);
 
@@ -3432,7 +3445,7 @@ kmem_cache_alloc_trace(struct kmem_cache
 {
 	void *ret;
 
-	ret = slab_alloc(cachep, flags, _RET_IP_);
+	ret = slab_alloc(cachep, flags, _RET_IP_, true);
 
 	trace_kmalloc(_RET_IP_, ret,
 		      size, cachep->size, flags);
@@ -3523,7 +3536,7 @@ static __always_inline void *__do_kmallo
 	cachep = kmalloc_slab(size, flags);
 	if (unlikely(ZERO_OR_NULL_PTR(cachep)))
 		return cachep;
-	ret = slab_alloc(cachep, flags, caller);
+	ret = slab_alloc(cachep, flags, caller, true);
 
 	trace_kmalloc(caller, ret,
 		      size, cachep->size, flags);
@@ -3543,32 +3556,56 @@ void *__kmalloc_track_caller(size_t size
 }
 EXPORT_SYMBOL(__kmalloc_track_caller);
 
-/**
- * kmem_cache_free - Deallocate an object
- * @cachep: The cache the allocation was from.
- * @objp: The previously allocated object.
- *
- * Free an object which was previously allocated from this
- * cache.
- */
-void kmem_cache_free(struct kmem_cache *cachep, void *objp)
+/* Caller is responsible for disabling local IRQs */
+static __always_inline void __kmem_cache_free(struct kmem_cache *cachep,
+					      void *objp, bool irq_off_needed)
 {
 	unsigned long flags;
+
+	/* Compiler need to remove irq_off_needed branch statements */
+	BUILD_BUG_ON(!__builtin_constant_p(irq_off_needed));
+
 	cachep = cache_from_obj(cachep, objp);
 	if (!cachep)
 		return;
 
-	local_irq_save(flags);
+	if (irq_off_needed)
+		local_irq_save(flags);
 	debug_check_no_locks_freed(objp, cachep->object_size);
 	if (!(cachep->flags & SLAB_DEBUG_OBJECTS))
 		debug_check_no_obj_freed(objp, cachep->object_size);
 	__cache_free(cachep, objp, _RET_IP_);
-	local_irq_restore(flags);
+	if (irq_off_needed)
+		local_irq_restore(flags);
+}
 
+/**
+ * kmem_cache_free - Deallocate an object
+ * @cachep: The cache the allocation was from.
+ * @objp: The previously allocated object.
+ *
+ * Free an object which was previously allocated from this
+ * cache.
+ */
+void kmem_cache_free(struct kmem_cache *cachep, void *objp)
+{
+	__kmem_cache_free(cachep, objp, true);
 	trace_kmem_cache_free(_RET_IP_, objp);
 }
 EXPORT_SYMBOL(kmem_cache_free);
 
+/* Note that interrupts must be enabled when calling this function. */
+void kmem_cache_free_bulk(struct kmem_cache *s, size_t size, void **p)
+{
+	size_t i;
+
+	local_irq_disable();
+	for (i = 0; i < size; i++)
+		__kmem_cache_free(s, p[i], false);
+	local_irq_enable();
+}
+EXPORT_SYMBOL(kmem_cache_free_bulk);
+
 /**
  * kfree - free previously allocated memory
  * @objp: pointer returned by kmalloc.
_

Patches currently in -mm which might be from brouer@redhat.com are


