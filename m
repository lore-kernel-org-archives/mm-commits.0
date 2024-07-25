Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DB0C4B5AE
	for <mm-commits@vger.kernel.org>; Thu, 25 Jul 2024 20:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721937755; cv=none; b=XdGnMlS631Fx6LQLPRPVDkENHcLV418JB9rKgXBQFKVWAQlBwttQ9CGKV7vfYcf6m+0Oj+PzeNU35nQi1SzzX0zf08LWr1BIxOR9kXmKTeNxJwOpxxhvW12lraM0BWndQ73BRCE05NvRshb9FFn/Zf2GZaDdjrCWvPnKO5ANIXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721937755; c=relaxed/simple;
	bh=3MQd37zE+sLF3Ut+FUHGhZp2iGvgmJqHEOAWoIPPoIc=;
	h=Date:To:From:Subject:Message-Id; b=gAVvoW7InQVgG5aoXfpYp5xRwe6hTqu0Vhuw7yvi3IQUXvX0ZlKMFbY/lgTmCC8eg8g0GNTKGRm7qsQPXYkNDKy4CqOb5nQzTeHKJXDP9Ve5+uhxRjyPNoL4P9Oy9sNrLGQ1RGdHAI+uoGmgcdmAZTr7OSW6BALaaLcp/stIkAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NBgMg/Iu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NBgMg/Iu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98A51C116B1;
	Thu, 25 Jul 2024 20:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1721937754;
	bh=3MQd37zE+sLF3Ut+FUHGhZp2iGvgmJqHEOAWoIPPoIc=;
	h=Date:To:From:Subject:From;
	b=NBgMg/IuYMs1p0lkLkyredKN1wa78sA+odyz41sAblYTQIaSJgXWSqSYCeyYb/yO1
	 jI3hafQlKlwP8MdwFRSuhHsr4WOeDVwZNgNIbfqKCsc4YxqPY88+PpV9tg28F70ZHR
	 Vz6oECpOT05yITIAsN0fqbQxFCORGgWq+aBHt9oE=
Date: Thu, 25 Jul 2024 13:02:34 -0700
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,vbabka@suse.cz,ryabinin.a.a@gmail.com,roman.gushchin@linux.dev,rientjes@google.com,penberg@kernel.org,iamjoonsoo.kim@lge.com,glider@google.com,elver@google.com,dvyukov@google.com,cl@linux.com,andreyknvl@gmail.com,42.hyeyoo@gmail.com,jannh@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + slub-introduce-config_slub_rcu_debug-v3.patch added to mm-unstable branch
Message-Id: <20240725200234.98A51C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: slub-introduce-config_slub_rcu_debug-v3
has been added to the -mm mm-unstable branch.  Its filename is
     slub-introduce-config_slub_rcu_debug-v3.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/slub-introduce-config_slub_rcu_debug-v3.patch

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
Subject: slub-introduce-config_slub_rcu_debug-v3
Date: Thu, 25 Jul 2024 17:31:35 +0200

- use dynamically allocated rcu_head to avoid having to add slab
  metadata, per Vlastimil

- add a warning in the kconfig help text that objects can be recycled
  immediately under memory pressure


Link: https://lkml.kernel.org/r/20240725-kasan-tsbrcu-v3-2-51c92f8f1101@google.com
Signed-off-by: Jann Horn <jannh@google.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>	[slab]
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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kasan.h |   24 ++++++-----------
 mm/Kconfig.debug      |    4 ++
 mm/kasan/common.c     |   23 +++++-----------
 mm/slab.h             |    3 --
 mm/slub.c             |   55 ++++++++++++++++++++--------------------
 5 files changed, 48 insertions(+), 61 deletions(-)

--- a/include/linux/kasan.h~slub-introduce-config_slub_rcu_debug-v3
+++ a/include/linux/kasan.h
@@ -186,12 +186,15 @@ static __always_inline bool kasan_slab_p
 }
 
 bool __kasan_slab_free(struct kmem_cache *s, void *object,
-			unsigned long ip, bool init);
+			unsigned long ip, bool init, bool after_rcu_delay);
 static __always_inline bool kasan_slab_free(struct kmem_cache *s,
-						void *object, bool init)
+						void *object, bool init,
+						bool after_rcu_delay)
 {
-	if (kasan_enabled())
-		return __kasan_slab_free(s, object, _RET_IP_, init);
+	if (kasan_enabled()) {
+		return __kasan_slab_free(s, object, _RET_IP_, init,
+				after_rcu_delay);
+	}
 	return false;
 }
 
@@ -349,8 +352,6 @@ static __always_inline void kasan_mempoo
 		__kasan_mempool_unpoison_object(ptr, size, _RET_IP_);
 }
 
-void kasan_poison_range_as_redzone(void *ptr, size_t size);
-
 /*
  * Unlike kasan_check_read/write(), kasan_check_byte() is performed even for
  * the hardware tag-based mode that doesn't rely on compiler instrumentation.
@@ -363,8 +364,6 @@ static __always_inline bool kasan_check_
 	return true;
 }
 
-size_t kasan_align(size_t size);
-
 #else /* CONFIG_KASAN */
 
 static inline void kasan_unpoison_range(const void *address, size_t size) {}
@@ -391,7 +390,8 @@ static inline bool kasan_slab_pre_free(s
 	return false;
 }
 
-static inline bool kasan_slab_free(struct kmem_cache *s, void *object, bool init)
+static inline bool kasan_slab_free(struct kmem_cache *s, void *object,
+				   bool init, bool after_rcu_delay)
 {
 	return false;
 }
@@ -426,16 +426,10 @@ static inline bool kasan_mempool_poison_
 }
 static inline void kasan_mempool_unpoison_object(void *ptr, size_t size) {}
 
-static inline void kasan_poison_range_as_redzone(void *ptr, size_t size) {}
-
 static inline bool kasan_check_byte(const void *address)
 {
 	return true;
 }
-static inline size_t kasan_align(size_t size)
-{
-	return size;
-}
 
 #endif /* CONFIG_KASAN */
 
--- a/mm/kasan/common.c~slub-introduce-config_slub_rcu_debug-v3
+++ a/mm/kasan/common.c
@@ -238,7 +238,8 @@ static enum free_validation_result check
 }
 
 static inline bool poison_slab_object(struct kmem_cache *cache, void *object,
-				      unsigned long ip, bool init)
+				      unsigned long ip, bool init,
+				      bool after_rcu_delay)
 {
 	void *tagged_object = object;
 	enum free_validation_result valid = check_slab_free(cache, object, ip);
@@ -252,7 +253,7 @@ static inline bool poison_slab_object(st
 
 	/* RCU slabs could be legally used after free within the RCU period. */
 	if (unlikely(cache->flags & SLAB_TYPESAFE_BY_RCU) &&
-	    !IS_ENABLED(CONFIG_SLUB_RCU_DEBUG))
+	    !after_rcu_delay)
 		return false;
 
 	kasan_poison(object, round_up(cache->object_size, KASAN_GRANULE_SIZE),
@@ -271,7 +272,8 @@ bool __kasan_slab_pre_free(struct kmem_c
 }
 
 bool __kasan_slab_free(struct kmem_cache *cache, void *object,
-				unsigned long ip, bool init)
+				unsigned long ip, bool init,
+				bool after_rcu_delay)
 {
 	if (is_kfence_address(object))
 		return false;
@@ -281,7 +283,7 @@ bool __kasan_slab_free(struct kmem_cache
 	 * freelist. The object will thus never be allocated again and its
 	 * metadata will never get released.
 	 */
-	if (poison_slab_object(cache, object, ip, init))
+	if (poison_slab_object(cache, object, ip, init, after_rcu_delay))
 		return true;
 
 	/*
@@ -536,7 +538,7 @@ bool __kasan_mempool_poison_object(void
 		return false;
 
 	slab = folio_slab(folio);
-	return !poison_slab_object(slab->slab_cache, ptr, ip, false);
+	return !poison_slab_object(slab->slab_cache, ptr, ip, false, false);
 }
 
 void __kasan_mempool_unpoison_object(void *ptr, size_t size, unsigned long ip)
@@ -567,12 +569,6 @@ void __kasan_mempool_unpoison_object(voi
 		poison_kmalloc_redzone(slab->slab_cache, ptr, size, flags);
 }
 
-void kasan_poison_range_as_redzone(void *ptr, size_t size)
-{
-	if (kasan_enabled())
-		kasan_poison(ptr, size, KASAN_SLAB_REDZONE, false);
-}
-
 bool __kasan_check_byte(const void *address, unsigned long ip)
 {
 	if (!kasan_byte_accessible(address)) {
@@ -581,8 +577,3 @@ bool __kasan_check_byte(const void *addr
 	}
 	return true;
 }
-
-size_t kasan_align(size_t size)
-{
-	return round_up(size, KASAN_GRANULE_SIZE);
-}
--- a/mm/Kconfig.debug~slub-introduce-config_slub_rcu_debug-v3
+++ a/mm/Kconfig.debug
@@ -93,6 +93,10 @@ config SLUB_RCU_DEBUG
 	  catching all the bugs WAY more than performance, you might want to
 	  also turn on CONFIG_RCU_STRICT_GRACE_PERIOD.
 
+	  WARNING:
+	  This is designed as a debugging feature, not a security feature.
+	  Objects are sometimes recycled without RCU delay under memory pressure.
+
 	  If unsure, say N.
 
 config PAGE_OWNER
--- a/mm/slab.h~slub-introduce-config_slub_rcu_debug-v3
+++ a/mm/slab.h
@@ -275,9 +275,6 @@ struct kmem_cache {
 	int refcount;			/* Refcount for slab cache destroy */
 	void (*ctor)(void *object);	/* Object constructor */
 	unsigned int inuse;		/* Offset to metadata */
-#ifdef CONFIG_SLUB_RCU_DEBUG
-	unsigned int debug_rcu_head_offset;
-#endif
 	unsigned int align;		/* Alignment */
 	unsigned int red_left_pad;	/* Left redzone padding size */
 	const char *name;		/* Name (only for display!) */
--- a/mm/slub.c~slub-introduce-config_slub_rcu_debug-v3
+++ a/mm/slub.c
@@ -1253,8 +1253,7 @@ skip_bug_print:
  * 	A. Free pointer (if we cannot overwrite object on free)
  * 	B. Tracking data for SLAB_STORE_USER
  *	C. Original request size for kmalloc object (SLAB_STORE_USER enabled)
- *	D. RCU head for CONFIG_SLUB_RCU_DEBUG (with padding around it)
- *	E. Padding to reach required alignment boundary or at minimum
+ *	D. Padding to reach required alignment boundary or at minimum
  * 		one word if debugging is on to be able to detect writes
  * 		before the word boundary.
  *
@@ -1280,11 +1279,6 @@ static int check_pad_bytes(struct kmem_c
 			off += sizeof(unsigned int);
 	}
 
-#ifdef CONFIG_SLUB_RCU_DEBUG
-	if (s->flags & SLAB_TYPESAFE_BY_RCU)
-		off = kasan_align(s->debug_rcu_head_offset + sizeof(struct rcu_head));
-#endif /* CONFIG_SLUB_RCU_DEBUG */
-
 	off += kasan_metadata_size(s, false);
 
 	if (size_from_object(s) == off)
@@ -2208,6 +2202,11 @@ static inline void memcg_slab_free_hook(
 
 #ifdef CONFIG_SLUB_RCU_DEBUG
 static void slab_free_after_rcu_debug(struct rcu_head *rcu_head);
+
+struct rcu_delayed_free {
+	struct rcu_head head;
+	void *object;
+};
 #endif
 
 /*
@@ -2247,12 +2246,23 @@ bool slab_free_hook(struct kmem_cache *s
 
 #ifdef CONFIG_SLUB_RCU_DEBUG
 	if ((s->flags & SLAB_TYPESAFE_BY_RCU) && !after_rcu_delay) {
-		struct rcu_head *rcu_head;
+		struct rcu_delayed_free *delayed_free;
 
-		rcu_head = kasan_reset_tag(x) + s->debug_rcu_head_offset;
-		kasan_unpoison_range(rcu_head, sizeof(*rcu_head));
-		call_rcu(rcu_head, slab_free_after_rcu_debug);
-		return false;
+		delayed_free = kmalloc(sizeof(*delayed_free), GFP_NOWAIT);
+		if (delayed_free) {
+			/*
+			 * Let KASAN track our call stack as a "related work
+			 * creation", just like if the object had been freed
+			 * normally via kfree_rcu().
+			 * We have to do this manually because the rcu_head is
+			 * not located inside the object.
+			 */
+			kasan_record_aux_stack_noalloc(x);
+
+			delayed_free->object = x;
+			call_rcu(&delayed_free->head, slab_free_after_rcu_debug);
+			return false;
+		}
 	}
 #endif /* CONFIG_SLUB_RCU_DEBUG */
 
@@ -2279,7 +2289,7 @@ bool slab_free_hook(struct kmem_cache *s
 		       s->size - inuse - rsize);
 	}
 	/* KASAN might put x into memory quarantine, delaying its reuse. */
-	return !kasan_slab_free(s, x, init);
+	return !kasan_slab_free(s, x, init, after_rcu_delay);
 }
 
 static __fastpath_inline
@@ -4531,9 +4541,11 @@ void slab_free_bulk(struct kmem_cache *s
 #ifdef CONFIG_SLUB_RCU_DEBUG
 static void slab_free_after_rcu_debug(struct rcu_head *rcu_head)
 {
-	struct slab *slab = virt_to_slab(rcu_head);
+	struct rcu_delayed_free *delayed_free =
+			container_of(rcu_head, struct rcu_delayed_free, head);
+	void *object = delayed_free->object;
+	struct slab *slab = virt_to_slab(object);
 	struct kmem_cache *s;
-	void *object;
 
 	if (WARN_ON(is_kfence_address(rcu_head)))
 		return;
@@ -4544,13 +4556,12 @@ static void slab_free_after_rcu_debug(st
 	s = slab->slab_cache;
 	if (WARN_ON(!(s->flags & SLAB_TYPESAFE_BY_RCU)))
 		return;
-	object = (void *)rcu_head - s->debug_rcu_head_offset;
-	kasan_poison_range_as_redzone(rcu_head, kasan_align(sizeof(*rcu_head)));
 
 	/* resume freeing */
 	if (!slab_free_hook(s, object, slab_want_init_on_free(s), true))
 		return;
 	do_slab_free(s, slab, object, NULL, 1, _THIS_IP_);
+	kfree(delayed_free);
 }
 #endif /* CONFIG_SLUB_RCU_DEBUG */
 
@@ -5284,16 +5295,6 @@ static int calculate_sizes(struct kmem_c
 		if (flags & SLAB_KMALLOC)
 			size += sizeof(unsigned int);
 	}
-
-#ifdef CONFIG_SLUB_RCU_DEBUG
-	if (flags & SLAB_TYPESAFE_BY_RCU) {
-		size = kasan_align(size);
-		size = ALIGN(size, __alignof__(struct rcu_head));
-		s->debug_rcu_head_offset = size;
-		size += sizeof(struct rcu_head);
-		size = kasan_align(size);
-	}
-#endif /* CONFIG_SLUB_RCU_DEBUG */
 #endif
 
 	kasan_cache_create(s, &size, &s->flags);
_

Patches currently in -mm which might be from jannh@google.com are

kasan-catch-invalid-free-before-slub-reinitializes-the-object.patch
slub-introduce-config_slub_rcu_debug.patch
slub-introduce-config_slub_rcu_debug-v3.patch

