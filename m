Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793249205;
	b=FlcnXdNYtmUOBP4/UfjRL8OBKW87qm+k5uCg0iXWRyMoZwG3LklkHTxU+kF4BdG9AcRG
	 T5ZQMV0d/KiMrkC1Ev/JPeAh5ETelpaKMjiSn+3EViWhyG639A6R4nA+DkIfJT03dipmh
	 izJbpU5/x+pA2uIQLRFhKqiJUrcw8snMm4YiTeazJi4NMlkrxsJRfQL7fBZQ+nTylrMYt
	 f3CEuSwEwASAkdd2wAUmxoAqkpgK76l0OOEKs230mHjQY2Hsnq1cw7DgAys43tZtrNstW
	 fIrrIFCdPtC/pEpMsJGMZpGkmAE/jUhPb7kPVmDqWwuqZOmDqENbt2UyGygomGj9d1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793249205;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=Mhgrmj/q2RvORIsJ1TB3MiYfncKCdYwy66UjW7dCaKc=;
	b=iSL2h46vL3U6FlxtD2Gc4XKO/8j5G6MwPUahgW0a8vjjcm71ap3j4DO3wAWH7IdA3OUg
	 vzr8zk5ifWfdOrua7NWUJed58F12WIKKg51O+vkmY3wt042JeX9cUwPthCmmN1i9L2xIZ
	 lJJ/U2AQOYwnSKyzgw7K78UtY0hWFhVvEOO2Rb78+GLtYwnpk3qnUzrDtHrTCB1HSkVlr
	 dzJH0hHD+fVcXDtDdGXNkZQA0Ry+0NdnvkvCRj4vgpMNVHWT9GGVlze2toRtIY+sgZ/fI
	 +tLPMnCpYvSOAJmyWRnOAt18HbDZboKLz6M0j2Ta05gwWi7vkAmMBOzb+fF9t0wr/wg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=nt64c2lP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE496606A31C;
	Thu, 29 Oct 2026 04:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=nt64c2lP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42FD41F01828;
	Thu, 29 Oct 2026 04:46:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793249204;
	bh=Mhgrmj/q2RvORIsJ1TB3MiYfncKCdYwy66UjW7dCaKc=;
	h=Date:To:From:Subject;
	b=nt64c2lPAK/5MSK4tcCqEthqZA4y5f6n/2MdCLtW6l6S4FxThUnB3xn0GgJNFHSWQ
	 M2x+Qlw5/7mbGKNTK6CI9yIqwQbEpYMafBfmHVkY+rV+3F4tawgdtAuAypIuJ+V0iP
	 HykkHojiZnvLwLgF1OhH0CkGrNmmoDSJZ+4e8vfA=
Date: Wed, 28 Oct 2026 21:46:43 -0700
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,vbabka@kernel.org,
	stable@vger.kernel.org,ryabinin.a.a@gmail.com,roman.gushchin@linux.dev,
	rientjes@google.com,harry@kernel.org,hao.li@linux.dev,glider@google.com,
	dvyukov@google.com,cl@gentwo.org,andreyknvl@gmail.com,kuniyu@google.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kasan-detect-double-free-involving-kfree_rcu_sheaf.patch added to mm-hotfixes-unstable branch
Message-Id: <20261029044644.42FD41F01828@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/kasan: detect double-free involving kfree_rcu_sheaf().
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-kasan-detect-double-free-involving-kfree_rcu_sheaf.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kasan-detect-double-free-involving-kfree_rcu_sheaf.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Kuniyuki Iwashima <kuniyu@google.com>
Subject: mm/kasan: detect double-free involving kfree_rcu_sheaf().
Date: Wed, 28 Oct 2026 19:39:19 +0000

Patch series "mm/kasan: Detect double-free involving kfree_rcu_sheaf().",
v3.

Recently, syzbot has reported several weird use-after-free splats.

What they have in common is that "Freed by" points to rcu_free_sheaf(),
whereas the object shown in "Call Trace:" and "Allocated by" is never
supposed to be freed via kfree_rcu().

This means the object was a victim of a double-free somewhere else and
was silently poisoned by rcu_free_sheaf() after being reallocated.

This happens because kfree_rcu_sheaf() queues an object into the RCU
sheaf without invoking any KASAN hooks.

This series enables KASAN to detect double-free involving
kfree_rcu_sheaf() immediately and adds KUnit tests for it.


This patch (of 2):

syzbot reported a weird use-after-free splat. [0]

In the report, an object in the kmalloc-64 cache was freed via
rcu_free_sheaf() while it was still in use, even though the
object should always be freed with kfree() (in xfrm_hash_free()),
implying that the object was a victim of a double-free involving
kfree_rcu() somewhere else.

When kvfree_call_rcu() frees an object via kfree_rcu_sheaf() and
queues it into pcs->rcu_free, debug facilities are skipped, e.g.,
kasan_slab_pre_free(), kasan_record_aux_stack(),
debug_rcu_head_queue(), etc.

As a result, KASAN cannot detect the double-free at the call site.

If the object is still in the KASAN quarantine when the sheaf is
flushed, KASAN can detect the double-free in rcu_free_sheaf(), but
with no trace of the suspect.

Worse yet, once the object is evicted from the quarantine and
reallocated before the sheaf is flushed, rcu_free_sheaf() silently
poisons the live object, resulting in a false-positive use-after-free
report on the new user.

If __kfree_rcu_sheaf() simply calls kasan_slab_pre_free(), we
can detect the second kfree_rcu(), but only while the object is
poisoned in the KASAN quarantine after the first free:

  kfree()     --(poisoned)--------------------> kfree_rcu()
  kfree_rcu() -> rcu_free_sheaf() -(poisoned)-> kfree_rcu()

An object queued in pcs->rcu_free remains unpoisoned until the
sheaf becomes full and rcu_free_sheaf() runs after the RCU
grace period, so a subsequent kfree_rcu() or kfree() before
rcu_free_sheaf() cannot be detected by shadow bytes alone:

  kfree_rcu() -(unpoisoned)-> kfree_rcu() -> rcu_free_sheaf() (too late!)
  kfree_rcu() -(unpoisoned)-> kfree()     -> rcu_free_sheaf() (too late!)

These cases can be detected if we call debug_rcu_head_queue()
before kfree_rcu_sheaf(), but ODEBUG splat only shows the second
free.

To detect these cases with KASAN, we just need a 1-bit flag
to indicate the state, which can reuse an unused bit in struct
kasan_track.pid. (PID_MAX_LIMIT is 1<<22)

The bit is marked along with recording the stack trace when
deferring slab frees in kfree_rcu_sheaf() and checked in
check_slab_allocation() so that any double-free pattern above
can be detected immediately.

Link: https://lore.kernel.org/20261028194014.3671161-1-kuniyu@google.com
Link: https://lore.kernel.org/20261028194014.3671161-2-kuniyu@google.com
Link: https://lore.kernel.org/all/6ac959ee.70ed5d86.2ac85.007d.GAE@google.com/ #[0]
Fixes: ec66e0d59952 ("slab: add sheaf support for batching kfree_rcu() operations")
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Tested-by: Alexander Potapenko <glider@google.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Reviewed-by: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Harry Yoo <harry@kernel.org>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Hao Li <hao.li@linux.dev>
Cc: Christoph Lameter <cl@gentwo.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: <stable@vger.kernel.org>
---

 include/linux/kasan.h |   15 +++++++++++----
 mm/kasan/common.c     |   13 ++++++++-----
 mm/kasan/generic.c    |   17 ++++++++++++++++-
 mm/kasan/kasan.h      |   34 +++++++++++++++++++++++++++++++++-
 mm/slub.c             |   13 ++++++++++---
 5 files changed, 78 insertions(+), 14 deletions(-)

--- a/include/linux/kasan.h~mm-kasan-detect-double-free-involving-kfree_rcu_sheaf
+++ a/include/linux/kasan.h
@@ -180,10 +180,12 @@ static __always_inline void * __must_che
 }
 
 bool __kasan_slab_pre_free(struct kmem_cache *s, void *object,
-			unsigned long ip);
+			   unsigned long ip, bool after_rcu_delay);
 /**
  * kasan_slab_pre_free - Check whether freeing a slab object is safe.
+ * @s: Cache the object belongs to.
  * @object: Object to be freed.
+ * @after_rcu_delay: Whether the free follows an RCU grace period.
  *
  * This function checks whether freeing the given object is safe. It may
  * check for double-free and invalid-free bugs and report them.
@@ -193,10 +195,12 @@ bool __kasan_slab_pre_free(struct kmem_c
  * @Return true if freeing the object is unsafe; false otherwise.
  */
 static __always_inline bool kasan_slab_pre_free(struct kmem_cache *s,
-						void *object)
+						void *object,
+						bool after_rcu_delay)
 {
 	if (kasan_enabled())
-		return __kasan_slab_pre_free(s, object, _RET_IP_);
+		return __kasan_slab_pre_free(s, object, _RET_IP_,
+					     after_rcu_delay);
 	return false;
 }
 
@@ -424,7 +428,8 @@ static inline void *kasan_init_slab_obj(
 	return (void *)object;
 }
 
-static inline bool kasan_slab_pre_free(struct kmem_cache *s, void *object)
+static inline bool kasan_slab_pre_free(struct kmem_cache *s, void *object,
+				       bool after_rcu_delay)
 {
 	return false;
 }
@@ -495,6 +500,7 @@ void kasan_cache_create(struct kmem_cach
 void kasan_cache_shrink(struct kmem_cache *cache);
 void kasan_cache_shutdown(struct kmem_cache *cache);
 void kasan_record_aux_stack(void *ptr);
+void kasan_mark_rcu_free_pending(void *ptr);
 
 #else /* CONFIG_KASAN_GENERIC */
 
@@ -512,6 +518,7 @@ static inline void kasan_cache_create(st
 static inline void kasan_cache_shrink(struct kmem_cache *cache) {}
 static inline void kasan_cache_shutdown(struct kmem_cache *cache) {}
 static inline void kasan_record_aux_stack(void *ptr) {}
+static inline void kasan_mark_rcu_free_pending(void *ptr) {}
 
 #endif /* CONFIG_KASAN_GENERIC */
 
--- a/mm/kasan/common.c~mm-kasan-detect-double-free-involving-kfree_rcu_sheaf
+++ a/mm/kasan/common.c
@@ -68,6 +68,7 @@ void kasan_set_track(struct kasan_track
 	track->timestamp = ts_nsec >> 9;
 #endif /* CONFIG_KASAN_EXTRA_INFO */
 	track->pid = current->pid;
+	track->rcu_free = 0;
 	track->stack = stack;
 }
 
@@ -231,7 +232,7 @@ void * __must_check __kasan_init_slab_ob
 
 /* Returns true when freeing the object is not safe. */
 static bool check_slab_allocation(struct kmem_cache *cache, void *object,
-				  unsigned long ip)
+				  unsigned long ip, bool after_rcu_delay)
 {
 	void *tagged_object = object;
 
@@ -242,7 +243,8 @@ static bool check_slab_allocation(struct
 		return true;
 	}
 
-	if (!kasan_byte_accessible(tagged_object)) {
+	if (!kasan_byte_accessible(tagged_object) ||
+	    kasan_check_rcu_free(cache, object, after_rcu_delay)) {
 		kasan_report_invalid_free(tagged_object, ip, KASAN_REPORT_DOUBLE_FREE);
 		return true;
 	}
@@ -259,17 +261,18 @@ static inline void poison_slab_object(st
 
 	kasan_poison(object, round_up(cache->object_size, KASAN_GRANULE_SIZE),
 			KASAN_SLAB_FREE, init);
+	kasan_clear_rcu_free(cache, object);
 
 	if (kasan_stack_collection_enabled())
 		kasan_save_free_info(cache, tagged_object);
 }
 
 bool __kasan_slab_pre_free(struct kmem_cache *cache, void *object,
-				unsigned long ip)
+			   unsigned long ip, bool after_rcu_delay)
 {
 	if (is_kfence_address(object))
 		return false;
-	return check_slab_allocation(cache, object, ip);
+	return check_slab_allocation(cache, object, ip, after_rcu_delay);
 }
 
 bool __kasan_slab_free(struct kmem_cache *cache, void *object, bool init,
@@ -544,7 +547,7 @@ bool __kasan_mempool_poison_object(void
 
 	slab = page_slab(page);
 
-	if (check_slab_allocation(slab->slab_cache, ptr, ip))
+	if (check_slab_allocation(slab->slab_cache, ptr, ip, false))
 		return false;
 
 	poison_slab_object(slab->slab_cache, ptr, false);
--- a/mm/kasan/generic.c~mm-kasan-detect-double-free-involving-kfree_rcu_sheaf
+++ a/mm/kasan/generic.c
@@ -533,10 +533,13 @@ size_t kasan_metadata_size(struct kmem_c
 }
 
 /*
+ * Records an auxiliary stack trace for the object at @addr and, if @rcu_free
+ * is set, marks the object as pending an RCU-delayed free.
+ *
  * This function avoids dynamic memory allocations and thus can be called from
  * contexts that do not allow allocating memory.
  */
-void kasan_record_aux_stack(void *addr)
+static void __kasan_record_aux_stack(void *addr, bool rcu_free)
 {
 	struct slab *slab = kasan_addr_to_slab(addr);
 	struct kmem_cache *cache;
@@ -552,10 +555,22 @@ void kasan_record_aux_stack(void *addr)
 	if (!alloc_meta)
 		return;
 
+	if (rcu_free)
+		alloc_meta->alloc_track.rcu_free = 1;
 	alloc_meta->aux_stack[1] = alloc_meta->aux_stack[0];
 	alloc_meta->aux_stack[0] = kasan_save_stack(0, 0);
 }
 
+void kasan_record_aux_stack(void *addr)
+{
+	__kasan_record_aux_stack(addr, false);
+}
+
+void kasan_mark_rcu_free_pending(void *addr)
+{
+	__kasan_record_aux_stack(addr, true);
+}
+
 void kasan_save_alloc_info(struct kmem_cache *cache, void *object, gfp_t flags)
 {
 	struct kasan_alloc_meta *alloc_meta;
--- a/mm/kasan/kasan.h~mm-kasan-detect-double-free-involving-kfree_rcu_sheaf
+++ a/mm/kasan/kasan.h
@@ -191,7 +191,10 @@ static inline bool kasan_requires_meta(v
 #define KASAN_STACK_DEPTH 64
 
 struct kasan_track {
-	u32 pid;
+#define KASAN_PID_BITS const_ilog2(PID_MAX_LIMIT)
+	u32 pid:KASAN_PID_BITS;
+	u32 rcu_free:1;
+	u32 unused:32 - (KASAN_PID_BITS + 1);
 	depot_stack_handle_t stack;
 #ifdef CONFIG_KASAN_EXTRA_INFO
 	u64 cpu:20;
@@ -390,8 +393,37 @@ struct kasan_alloc_meta *kasan_get_alloc
 struct kasan_free_meta *kasan_get_free_meta(struct kmem_cache *cache,
 						const void *object);
 void kasan_init_object_meta(struct kmem_cache *cache, const void *object);
+
+static inline bool kasan_check_rcu_free(struct kmem_cache *cache,
+					const void *object,
+					bool after_rcu_delay)
+{
+	struct kasan_alloc_meta *alloc_meta;
+
+	alloc_meta = kasan_get_alloc_meta(cache, object);
+	if (!alloc_meta)
+		return false;
+
+	return alloc_meta->alloc_track.rcu_free != after_rcu_delay;
+}
+
+static inline void kasan_clear_rcu_free(struct kmem_cache *cache,
+					const void *object)
+{
+	struct kasan_alloc_meta *alloc_meta;
+
+	alloc_meta = kasan_get_alloc_meta(cache, object);
+	if (alloc_meta)
+		alloc_meta->alloc_track.rcu_free = 0;
+}
 #else
 static inline void kasan_init_object_meta(struct kmem_cache *cache, const void *object) { }
+static inline bool kasan_check_rcu_free(struct kmem_cache *cache, const void *object,
+					bool after_rcu_delay)
+{
+	return false;
+}
+static inline void kasan_clear_rcu_free(struct kmem_cache *cache, const void *object) { }
 #endif
 
 depot_stack_handle_t kasan_save_stack(gfp_t flags, depot_flags_t depot_flags);
--- a/mm/slub.c~mm-kasan-detect-double-free-involving-kfree_rcu_sheaf
+++ a/mm/slub.c
@@ -2722,7 +2722,7 @@ bool slab_free_hook(struct kmem_cache *s
 	 * Give KASAN a chance to notice an invalid free operation before we
 	 * modify the object.
 	 */
-	if (kasan_slab_pre_free(s, x))
+	if (kasan_slab_pre_free(s, x, after_rcu_delay))
 		return false;
 
 #ifdef CONFIG_SLUB_RCU_DEBUG
@@ -2738,7 +2738,7 @@ bool slab_free_hook(struct kmem_cache *s
 			 * We have to do this manually because the rcu_head is
 			 * not located inside the object.
 			 */
-			kasan_record_aux_stack(x);
+			kasan_mark_rcu_free_pending(x);
 
 			delayed_free->object = x;
 			call_rcu(&delayed_free->head, slab_free_after_rcu_debug);
@@ -6298,6 +6298,12 @@ bool __kfree_rcu_sheaf(struct kmem_cache
 	}
 
 do_free:
+	if (unlikely(kasan_slab_pre_free(s, obj, false))) {
+		local_unlock(&s->cpu_sheaves->lock);
+		goto out;
+	}
+
+	kasan_mark_rcu_free_pending(obj);
 
 	rcu_sheaf = pcs->rcu_free;
 
@@ -6338,6 +6344,7 @@ do_free:
 	local_unlock(&s->cpu_sheaves->lock);
 
 	stat(s, FREE_RCU_SHEAF);
+out:
 	if (!IS_ENABLED(CONFIG_PREEMPT_RT))
 		lock_map_release(&kfree_rcu_sheaf_map);
 	return true;
@@ -6971,7 +6978,7 @@ void kfree_nolock(const void *object)
 	 *  -> kfree_nolock() -> kasan_report_invalid_free() on the same CPU
 	 * is double buggy and deserves to deadlock.
 	 */
-	if (kasan_slab_pre_free(s, x))
+	if (kasan_slab_pre_free(s, x, false))
 		return;
 	/*
 	 * memcg, kasan_slab_pre_free are done for 'x'.
_

Patches currently in -mm which might be from kuniyu@google.com are

mm-kasan-detect-double-free-involving-kfree_rcu_sheaf.patch
mm-kasan-kunit-add-double-free-tests-involving-kfree_rcu_sheaf.patch

