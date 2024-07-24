Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AE3565E20
	for <mm-commits@vger.kernel.org>; Wed, 24 Jul 2024 19:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721847822; cv=none; b=eiawZHDmvNkpHpnH43VWsIb4+Cr33Iz3ftlRhEcPdTRp+CFi4t0dxADzs+quCj04waGFx18ZKlfFwCIh/WhGB+AykGTiyMdpXt676VYL7bnBaQfl8dlLYMxmTto8g9VPpFUul8sHx8omel3vbdc21t8oF/bn9jCFxRi+isyYUbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721847822; c=relaxed/simple;
	bh=pUkWMafZezYq8Ef0mQ8HgWYHUPDoydfSHh6HLZKGOxo=;
	h=Date:To:From:Subject:Message-Id; b=Umcg/m5GkvQpu81FORDfnGiqRAZ8V0l88z2acv1AY0KXAY1EGdCj8PU1gqokX6Y4jkvnrsVYlHbPy2mXbjgLg+vLYVDXHHZ9u740DH415ACWtrZzmpHeAU+PTeGbpKEHERmTXUx/U4ROiRxXxNJZ7rJd0xbmfioTXRRoejv423M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qXSMb+yh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qXSMb+yh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C1CBC32781;
	Wed, 24 Jul 2024 19:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1721847821;
	bh=pUkWMafZezYq8Ef0mQ8HgWYHUPDoydfSHh6HLZKGOxo=;
	h=Date:To:From:Subject:From;
	b=qXSMb+yhe8pLU5IlrmrfgO9oexu7HmrRi2lj94dQugrjKUAgvts2bHDzyZntAysxu
	 xmRTxhjUniPfKcCABHdYrMyq1CliEfY80dxK0EWOCdYXh4xepMaPC+2VpllFpqfXCS
	 7i1Q6EgjIBTQ6KI9uWcvmpi8NpFm6H3PxXQjNkSI=
Date: Wed, 24 Jul 2024 12:03:40 -0700
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,vbabka@suse.cz,ryabinin.a.a@gmail.com,roman.gushchin@linux.dev,rientjes@google.com,penberg@kernel.org,iamjoonsoo.kim@lge.com,glider@google.com,elver@google.com,dvyukov@google.com,cl@linux.com,andreyknvl@gmail.com,42.hyeyoo@gmail.com,jannh@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + slub-introduce-config_slub_rcu_debug.patch added to mm-unstable branch
Message-Id: <20240724190341.8C1CBC32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: slub: introduce CONFIG_SLUB_RCU_DEBUG
has been added to the -mm mm-unstable branch.  Its filename is
     slub-introduce-config_slub_rcu_debug.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/slub-introduce-config_slub_rcu_debug.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Jann Horn <jannh@google.com>
Subject: slub: introduce CONFIG_SLUB_RCU_DEBUG
Date: Wed, 24 Jul 2024 18:34:13 +0200

Currently, KASAN is unable to catch use-after-free in SLAB_TYPESAFE_BY_RCU
slabs because use-after-free is allowed within the RCU grace period by
design.

Add a SLUB debugging feature which RCU-delays every individual
kmem_cache_free() before either actually freeing the object or handing it
off to KASAN, and change KASAN to poison freed objects as normal when this
option is enabled.

Note that this creates an aligned 16-byte area in the middle of the slab
metadata area, which kinda sucks but seems to be necessary in order to be
able to store an rcu_head in there that can be unpoisoned while the RCU
callback is pending.  (metadata_access_enable/disable doesn't work here
because while the RCU callback is pending, it will be accessed by
asynchronous RCU processing.) To be able to re-poison the area after the
RCU callback is done executing, a new helper
kasan_poison_range_as_redzone() is necessary.

For now I've configured Kconfig.debug to default-enable this feature in
the KASAN GENERIC and SW_TAGS modes; I'm not enabling it by default in
HW_TAGS mode because I'm not sure if it might have unwanted performance
degradation effects there.

Note that this is mostly useful with KASAN in the quarantine-based GENERIC
mode; SLAB_TYPESAFE_BY_RCU slabs are basically always also slabs with a
->ctor, and KASAN's assign_tag() currently has to assign fixed tags for
those, reducing the effectiveness of SW_TAGS/HW_TAGS mode.  (A possible
future extension of this work would be to also let SLUB call the ->ctor()
on every allocation instead of only when the slab page is allocated; then
tag-based modes would be able to assign new tags on every reallocation.)

Link: https://lkml.kernel.org/r/20240724-kasan-tsbrcu-v2-2-45f898064468@google.com
Signed-off-by: Jann Horn <jannh@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Marco Elver <elver@google.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kasan.h |   10 +++++
 mm/Kconfig.debug      |   25 +++++++++++++
 mm/kasan/common.c     |   14 ++++++-
 mm/kasan/kasan_test.c |   44 +++++++++++++++++++++++
 mm/slab.h             |    3 +
 mm/slab_common.c      |   12 ++++++
 mm/slub.c             |   75 +++++++++++++++++++++++++++++++++++-----
 7 files changed, 174 insertions(+), 9 deletions(-)

--- a/include/linux/kasan.h~slub-introduce-config_slub_rcu_debug
+++ a/include/linux/kasan.h
@@ -349,6 +349,8 @@ static __always_inline void kasan_mempoo
 		__kasan_mempool_unpoison_object(ptr, size, _RET_IP_);
 }
 
+void kasan_poison_range_as_redzone(void *ptr, size_t size);
+
 /*
  * Unlike kasan_check_read/write(), kasan_check_byte() is performed even for
  * the hardware tag-based mode that doesn't rely on compiler instrumentation.
@@ -361,6 +363,8 @@ static __always_inline bool kasan_check_
 	return true;
 }
 
+size_t kasan_align(size_t size);
+
 #else /* CONFIG_KASAN */
 
 static inline void kasan_unpoison_range(const void *address, size_t size) {}
@@ -416,10 +420,16 @@ static inline bool kasan_mempool_poison_
 }
 static inline void kasan_mempool_unpoison_object(void *ptr, size_t size) {}
 
+static inline void kasan_poison_range_as_redzone(void *ptr, size_t size) {}
+
 static inline bool kasan_check_byte(const void *address)
 {
 	return true;
 }
+static inline size_t kasan_align(size_t size)
+{
+	return size;
+}
 
 #endif /* CONFIG_KASAN */
 
--- a/mm/kasan/common.c~slub-introduce-config_slub_rcu_debug
+++ a/mm/kasan/common.c
@@ -251,7 +251,8 @@ static inline bool poison_slab_object(st
 	object = kasan_reset_tag(object);
 
 	/* RCU slabs could be legally used after free within the RCU period. */
-	if (unlikely(cache->flags & SLAB_TYPESAFE_BY_RCU))
+	if (unlikely(cache->flags & SLAB_TYPESAFE_BY_RCU) &&
+	    !IS_ENABLED(CONFIG_SLUB_RCU_DEBUG))
 		return false;
 
 	kasan_poison(object, round_up(cache->object_size, KASAN_GRANULE_SIZE),
@@ -566,6 +567,12 @@ void __kasan_mempool_unpoison_object(voi
 		poison_kmalloc_redzone(slab->slab_cache, ptr, size, flags);
 }
 
+void kasan_poison_range_as_redzone(void *ptr, size_t size)
+{
+	if (kasan_enabled())
+		kasan_poison(ptr, size, KASAN_SLAB_REDZONE, false);
+}
+
 bool __kasan_check_byte(const void *address, unsigned long ip)
 {
 	if (!kasan_byte_accessible(address)) {
@@ -574,3 +581,8 @@ bool __kasan_check_byte(const void *addr
 	}
 	return true;
 }
+
+size_t kasan_align(size_t size)
+{
+	return round_up(size, KASAN_GRANULE_SIZE);
+}
--- a/mm/kasan/kasan_test.c~slub-introduce-config_slub_rcu_debug
+++ a/mm/kasan/kasan_test.c
@@ -996,6 +996,49 @@ static void kmem_cache_invalid_free(stru
 	kmem_cache_destroy(cache);
 }
 
+static void kmem_cache_rcu_uaf(struct kunit *test)
+{
+	char *p;
+	size_t size = 200;
+	struct kmem_cache *cache;
+
+	KASAN_TEST_NEEDS_CONFIG_ON(test, CONFIG_SLUB_RCU_DEBUG);
+
+	cache = kmem_cache_create("test_cache", size, 0, SLAB_TYPESAFE_BY_RCU,
+				  NULL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, cache);
+
+	p = kmem_cache_alloc(cache, GFP_KERNEL);
+	if (!p) {
+		kunit_err(test, "Allocation failed: %s\n", __func__);
+		kmem_cache_destroy(cache);
+		return;
+	}
+	*p = 1;
+
+	rcu_read_lock();
+
+	/* Free the object - this will internally schedule an RCU callback. */
+	kmem_cache_free(cache, p);
+
+	/* We should still be allowed to access the object at this point because
+	 * the cache is SLAB_TYPESAFE_BY_RCU and we've been in an RCU read-side
+	 * critical section since before the kmem_cache_free().
+	 */
+	READ_ONCE(*p);
+
+	rcu_read_unlock();
+
+	/* Wait for the RCU callback to execute; after this, the object should
+	 * have actually been freed from KASAN's perspective.
+	 */
+	rcu_barrier();
+
+	KUNIT_EXPECT_KASAN_FAIL(test, READ_ONCE(*p));
+
+	kmem_cache_destroy(cache);
+}
+
 static void empty_cache_ctor(void *object) { }
 
 static void kmem_cache_double_destroy(struct kunit *test)
@@ -1937,6 +1980,7 @@ static struct kunit_case kasan_kunit_tes
 	KUNIT_CASE(kmem_cache_oob),
 	KUNIT_CASE(kmem_cache_double_free),
 	KUNIT_CASE(kmem_cache_invalid_free),
+	KUNIT_CASE(kmem_cache_rcu_uaf),
 	KUNIT_CASE(kmem_cache_double_destroy),
 	KUNIT_CASE(kmem_cache_accounted),
 	KUNIT_CASE(kmem_cache_bulk),
--- a/mm/Kconfig.debug~slub-introduce-config_slub_rcu_debug
+++ a/mm/Kconfig.debug
@@ -70,6 +70,31 @@ config SLUB_DEBUG_ON
 	  off in a kernel built with CONFIG_SLUB_DEBUG_ON by specifying
 	  "slab_debug=-".
 
+config SLUB_RCU_DEBUG
+	bool "Make use-after-free detection possible in TYPESAFE_BY_RCU caches"
+	depends on SLUB_DEBUG
+	default KASAN_GENERIC || KASAN_SW_TAGS
+	help
+	  Make SLAB_TYPESAFE_BY_RCU caches behave approximately as if the cache
+	  was not marked as SLAB_TYPESAFE_BY_RCU and every caller used
+	  kfree_rcu() instead.
+
+	  This is intended for use in combination with KASAN, to enable KASAN to
+	  detect use-after-free accesses in such caches.
+	  (KFENCE is able to do that independent of this flag.)
+
+	  This might degrade performance.
+	  Unfortunately this also prevents a very specific bug pattern from
+	  triggering (insufficient checks against an object being recycled
+	  within the RCU grace period); so this option can be turned off even on
+	  KASAN builds, in case you want to test for such a bug.
+
+	  If you're using this for testing bugs / fuzzing and care about
+	  catching all the bugs WAY more than performance, you might want to
+	  also turn on CONFIG_RCU_STRICT_GRACE_PERIOD.
+
+	  If unsure, say N.
+
 config PAGE_OWNER
 	bool "Track page owner"
 	depends on DEBUG_KERNEL && STACKTRACE_SUPPORT
--- a/mm/slab_common.c~slub-introduce-config_slub_rcu_debug
+++ a/mm/slab_common.c
@@ -542,6 +542,18 @@ static void slab_caches_to_rcu_destroy_w
 
 static int shutdown_cache(struct kmem_cache *s)
 {
+	if (IS_ENABLED(CONFIG_SLUB_RCU_DEBUG) &&
+	    (s->flags & SLAB_TYPESAFE_BY_RCU)) {
+		/*
+		 * Under CONFIG_SLUB_RCU_DEBUG, when objects in a
+		 * SLAB_TYPESAFE_BY_RCU slab are freed, SLUB will internally
+		 * defer their freeing with call_rcu().
+		 * Wait for such call_rcu() invocations here before actually
+		 * destroying the cache.
+		 */
+		rcu_barrier();
+	}
+
 	/* free asan quarantined objects */
 	kasan_cache_shutdown(s);
 
--- a/mm/slab.h~slub-introduce-config_slub_rcu_debug
+++ a/mm/slab.h
@@ -275,6 +275,9 @@ struct kmem_cache {
 	int refcount;			/* Refcount for slab cache destroy */
 	void (*ctor)(void *object);	/* Object constructor */
 	unsigned int inuse;		/* Offset to metadata */
+#ifdef CONFIG_SLUB_RCU_DEBUG
+	unsigned int debug_rcu_head_offset;
+#endif
 	unsigned int align;		/* Alignment */
 	unsigned int red_left_pad;	/* Left redzone padding size */
 	const char *name;		/* Name (only for display!) */
--- a/mm/slub.c~slub-introduce-config_slub_rcu_debug
+++ a/mm/slub.c
@@ -1253,7 +1253,8 @@ skip_bug_print:
  * 	A. Free pointer (if we cannot overwrite object on free)
  * 	B. Tracking data for SLAB_STORE_USER
  *	C. Original request size for kmalloc object (SLAB_STORE_USER enabled)
- *	D. Padding to reach required alignment boundary or at minimum
+ *	D. RCU head for CONFIG_SLUB_RCU_DEBUG (with padding around it)
+ *	E. Padding to reach required alignment boundary or at minimum
  * 		one word if debugging is on to be able to detect writes
  * 		before the word boundary.
  *
@@ -1279,6 +1280,11 @@ static int check_pad_bytes(struct kmem_c
 			off += sizeof(unsigned int);
 	}
 
+#ifdef CONFIG_SLUB_RCU_DEBUG
+	if (s->flags & SLAB_TYPESAFE_BY_RCU)
+		off = kasan_align(s->debug_rcu_head_offset + sizeof(struct rcu_head));
+#endif /* CONFIG_SLUB_RCU_DEBUG */
+
 	off += kasan_metadata_size(s, false);
 
 	if (size_from_object(s) == off)
@@ -2200,15 +2206,21 @@ static inline void memcg_slab_free_hook(
 }
 #endif /* CONFIG_MEMCG */
 
+#ifdef CONFIG_SLUB_RCU_DEBUG
+static void slab_free_after_rcu_debug(struct rcu_head *rcu_head);
+#endif
+
 /*
  * Hooks for other subsystems that check memory allocations. In a typical
  * production configuration these hooks all should produce no code at all.
  *
  * Returns true if freeing of the object can proceed, false if its reuse
- * was delayed by KASAN quarantine, or it was returned to KFENCE.
+ * was delayed by CONFIG_SLUB_RCU_DEBUG or KASAN quarantine, or it was returned
+ * to KFENCE.
  */
 static __always_inline
-bool slab_free_hook(struct kmem_cache *s, void *x, bool init)
+bool slab_free_hook(struct kmem_cache *s, void *x, bool init,
+		    bool after_rcu_delay)
 {
 	kmemleak_free_recursive(x, s->flags);
 	kmsan_slab_free(s, x);
@@ -2219,7 +2231,7 @@ bool slab_free_hook(struct kmem_cache *s
 		debug_check_no_obj_freed(x, s->object_size);
 
 	/* Use KCSAN to help debug racy use-after-free. */
-	if (!(s->flags & SLAB_TYPESAFE_BY_RCU))
+	if (!(s->flags & SLAB_TYPESAFE_BY_RCU) || after_rcu_delay)
 		__kcsan_check_access(x, s->object_size,
 				     KCSAN_ACCESS_WRITE | KCSAN_ACCESS_ASSERT);
 
@@ -2233,6 +2245,17 @@ bool slab_free_hook(struct kmem_cache *s
 	if (kasan_slab_pre_free(s, x))
 		return false;
 
+#ifdef CONFIG_SLUB_RCU_DEBUG
+	if ((s->flags & SLAB_TYPESAFE_BY_RCU) && !after_rcu_delay) {
+		struct rcu_head *rcu_head;
+
+		rcu_head = kasan_reset_tag(x) + s->debug_rcu_head_offset;
+		kasan_unpoison_range(rcu_head, sizeof(*rcu_head));
+		call_rcu(rcu_head, slab_free_after_rcu_debug);
+		return false;
+	}
+#endif /* CONFIG_SLUB_RCU_DEBUG */
+
 	/*
 	 * As memory initialization might be integrated into KASAN,
 	 * kasan_slab_free and initialization memset's must be
@@ -2270,7 +2293,7 @@ bool slab_free_freelist_hook(struct kmem
 	bool init;
 
 	if (is_kfence_address(next)) {
-		slab_free_hook(s, next, false);
+		slab_free_hook(s, next, false, false);
 		return false;
 	}
 
@@ -2285,7 +2308,7 @@ bool slab_free_freelist_hook(struct kmem
 		next = get_freepointer(s, object);
 
 		/* If object's reuse doesn't have to be delayed */
-		if (likely(slab_free_hook(s, object, init))) {
+		if (likely(slab_free_hook(s, object, init, false))) {
 			/* Move object to the new freelist */
 			set_freepointer(s, object, *head);
 			*head = object;
@@ -4477,7 +4500,7 @@ void slab_free(struct kmem_cache *s, str
 	memcg_slab_free_hook(s, slab, &object, 1);
 	alloc_tagging_slab_free_hook(s, slab, &object, 1);
 
-	if (likely(slab_free_hook(s, object, slab_want_init_on_free(s))))
+	if (likely(slab_free_hook(s, object, slab_want_init_on_free(s), false)))
 		do_slab_free(s, slab, object, object, 1, addr);
 }
 
@@ -4486,7 +4509,7 @@ void slab_free(struct kmem_cache *s, str
 static noinline
 void memcg_alloc_abort_single(struct kmem_cache *s, void *object)
 {
-	if (likely(slab_free_hook(s, object, slab_want_init_on_free(s))))
+	if (likely(slab_free_hook(s, object, slab_want_init_on_free(s), false)))
 		do_slab_free(s, virt_to_slab(object), object, object, 1, _RET_IP_);
 }
 #endif
@@ -4505,6 +4528,32 @@ void slab_free_bulk(struct kmem_cache *s
 		do_slab_free(s, slab, head, tail, cnt, addr);
 }
 
+#ifdef CONFIG_SLUB_RCU_DEBUG
+static void slab_free_after_rcu_debug(struct rcu_head *rcu_head)
+{
+	struct slab *slab = virt_to_slab(rcu_head);
+	struct kmem_cache *s;
+	void *object;
+
+	if (WARN_ON(is_kfence_address(rcu_head)))
+		return;
+
+	/* find the object and the cache again */
+	if (WARN_ON(!slab))
+		return;
+	s = slab->slab_cache;
+	if (WARN_ON(!(s->flags & SLAB_TYPESAFE_BY_RCU)))
+		return;
+	object = (void *)rcu_head - s->debug_rcu_head_offset;
+	kasan_poison_range_as_redzone(rcu_head, kasan_align(sizeof(*rcu_head)));
+
+	/* resume freeing */
+	if (!slab_free_hook(s, object, slab_want_init_on_free(s), true))
+		return;
+	do_slab_free(s, slab, object, NULL, 1, _THIS_IP_);
+}
+#endif /* CONFIG_SLUB_RCU_DEBUG */
+
 #ifdef CONFIG_KASAN_GENERIC
 void ___cache_free(struct kmem_cache *cache, void *x, unsigned long addr)
 {
@@ -5235,6 +5284,16 @@ static int calculate_sizes(struct kmem_c
 		if (flags & SLAB_KMALLOC)
 			size += sizeof(unsigned int);
 	}
+
+#ifdef CONFIG_SLUB_RCU_DEBUG
+	if (flags & SLAB_TYPESAFE_BY_RCU) {
+		size = kasan_align(size);
+		size = ALIGN(size, __alignof__(struct rcu_head));
+		s->debug_rcu_head_offset = size;
+		size += sizeof(struct rcu_head);
+		size = kasan_align(size);
+	}
+#endif /* CONFIG_SLUB_RCU_DEBUG */
 #endif
 
 	kasan_cache_create(s, &size, &s->flags);
_

Patches currently in -mm which might be from jannh@google.com are

kasan-catch-invalid-free-before-slub-reinitializes-the-object.patch
slub-introduce-config_slub_rcu_debug.patch

