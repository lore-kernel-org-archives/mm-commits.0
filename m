Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA868C433DB
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:22:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 756D564F13
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:22:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229745AbhBZBV7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 20:21:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:52948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229800AbhBZBUl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 20:20:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1EDE564F03;
        Fri, 26 Feb 2021 01:20:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614302400;
        bh=dhg8zICJof7eRtC+hfcr3dMtZ7bwBeuqyBV37wxBmVo=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=n20C4ww1L0YGOfMw9UpoW+lY5RcdQ1r1O8Z8FPTAIa4pwg43BVEqSiAU0JM7Q8R2y
         U2s3HosSQRrCPhoROBgdf0//KrnbKei6HWjhB8G1r9+VGJdZHxzoA5NQ/SEdxtt5oR
         cSsR45JiAv72n88g67r1c8VMsESBQ8Uf6j1V8eUU=
Date:   Thu, 25 Feb 2021 17:19:59 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@google.com,
        aryabinin@virtuozzo.com, Branislav.Rankov@arm.com,
        catalin.marinas@arm.com, dvyukov@google.com, elver@google.com,
        eugenis@google.com, glider@google.com, kevin.brodsky@arm.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, pcc@google.com,
        torvalds@linux-foundation.org, vincenzo.frascino@arm.com,
        will.deacon@arm.com
Subject:  [patch 071/118] kasan, mm: optimize kmalloc poisoning
Message-ID: <20210226011959.Ifhsdcy6A%akpm@linux-foundation.org>
In-Reply-To: <20210225171452.713967e96554bb6a53e44a19@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan, mm: optimize kmalloc poisoning

For allocations from kmalloc caches, kasan_kmalloc() always follows
kasan_slab_alloc().  Currenly, both of them unpoison the whole object,
which is unnecessary.

This patch provides separate implementations for both annotations:
kasan_slab_alloc() unpoisons the whole object, and kasan_kmalloc() only
poisons the redzone.

For generic KASAN, the redzone start might not be aligned to
KASAN_GRANULE_SIZE.  Therefore, the poisoning is split in two parts:
kasan_poison_last_granule() poisons the unaligned part, and then
kasan_poison() poisons the rest.

This patch also clarifies alignment guarantees of each of the poisoning
functions and drops the unnecessary round_up() call for redzone_end.

With this change, the early SLUB cache annotation needs to be changed to
kasan_slab_alloc(), as kasan_kmalloc() doesn't unpoison objects now.  The
number of poisoned bytes for objects in this cache stays the same, as
kmem_cache_node->object_size is equal to sizeof(struct kmem_cache_node).

Link: https://lkml.kernel.org/r/7e3961cb52be380bc412860332063f5f7ce10d13.1612546384.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Branislav Rankov <Branislav.Rankov@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Peter Collingbourne <pcc@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/common.c |   93 +++++++++++++++++++++++++++++---------------
 mm/kasan/kasan.h  |   43 +++++++++++++++++++-
 mm/kasan/shadow.c |   28 +++++++------
 mm/slub.c         |    3 -
 4 files changed, 119 insertions(+), 48 deletions(-)

--- a/mm/kasan/common.c~kasan-mm-optimize-kmalloc-poisoning
+++ a/mm/kasan/common.c
@@ -278,22 +278,12 @@ void __kasan_poison_object_data(struct k
  *    based on objects indexes, so that objects that are next to each other
  *    get different tags.
  */
-static u8 assign_tag(struct kmem_cache *cache, const void *object,
-			bool init, bool keep_tag)
+static u8 assign_tag(struct kmem_cache *cache, const void *object, bool init)
 {
 	if (IS_ENABLED(CONFIG_KASAN_GENERIC))
 		return 0xff;
 
 	/*
-	 * 1. When an object is kmalloc()'ed, two hooks are called:
-	 *    kasan_slab_alloc() and kasan_kmalloc(). We assign the
-	 *    tag only in the first one.
-	 * 2. We reuse the same tag for krealloc'ed objects.
-	 */
-	if (keep_tag)
-		return get_tag(object);
-
-	/*
 	 * If the cache neither has a constructor nor has SLAB_TYPESAFE_BY_RCU
 	 * set, assign a tag when the object is being allocated (init == false).
 	 */
@@ -325,7 +315,7 @@ void * __must_check __kasan_init_slab_ob
 	}
 
 	/* Tag is ignored in set_tag() without CONFIG_KASAN_SW/HW_TAGS */
-	object = set_tag(object, assign_tag(cache, object, true, false));
+	object = set_tag(object, assign_tag(cache, object, true));
 
 	return (void *)object;
 }
@@ -413,12 +403,46 @@ static void set_alloc_info(struct kmem_c
 		kasan_set_track(&alloc_meta->alloc_track, flags);
 }
 
+void * __must_check __kasan_slab_alloc(struct kmem_cache *cache,
+					void *object, gfp_t flags)
+{
+	u8 tag;
+	void *tagged_object;
+
+	if (gfpflags_allow_blocking(flags))
+		kasan_quarantine_reduce();
+
+	if (unlikely(object == NULL))
+		return NULL;
+
+	if (is_kfence_address(object))
+		return (void *)object;
+
+	/*
+	 * Generate and assign random tag for tag-based modes.
+	 * Tag is ignored in set_tag() for the generic mode.
+	 */
+	tag = assign_tag(cache, object, false);
+	tagged_object = set_tag(object, tag);
+
+	/*
+	 * Unpoison the whole object.
+	 * For kmalloc() allocations, kasan_kmalloc() will do precise poisoning.
+	 */
+	kasan_unpoison(tagged_object, cache->object_size);
+
+	/* Save alloc info (if possible) for non-kmalloc() allocations. */
+	if (kasan_stack_collection_enabled())
+		set_alloc_info(cache, (void *)object, flags, false);
+
+	return tagged_object;
+}
+
 static void *____kasan_kmalloc(struct kmem_cache *cache, const void *object,
-				size_t size, gfp_t flags, bool is_kmalloc)
+					size_t size, gfp_t flags)
 {
 	unsigned long redzone_start;
 	unsigned long redzone_end;
-	u8 tag;
 
 	if (gfpflags_allow_blocking(flags))
 		kasan_quarantine_reduce();
@@ -429,33 +453,41 @@ static void *____kasan_kmalloc(struct km
 	if (is_kfence_address(kasan_reset_tag(object)))
 		return (void *)object;
 
+	/*
+	 * The object has already been unpoisoned by kasan_slab_alloc() for
+	 * kmalloc() or by ksize() for krealloc().
+	 */
+
+	/*
+	 * The redzone has byte-level precision for the generic mode.
+	 * Partially poison the last object granule to cover the unaligned
+	 * part of the redzone.
+	 */
+	if (IS_ENABLED(CONFIG_KASAN_GENERIC))
+		kasan_poison_last_granule((void *)object, size);
+
+	/* Poison the aligned part of the redzone. */
 	redzone_start = round_up((unsigned long)(object + size),
 				KASAN_GRANULE_SIZE);
-	redzone_end = round_up((unsigned long)object + cache->object_size,
-				KASAN_GRANULE_SIZE);
-	tag = assign_tag(cache, object, false, is_kmalloc);
-
-	/* Tag is ignored in set_tag without CONFIG_KASAN_SW/HW_TAGS */
-	kasan_unpoison(set_tag(object, tag), size);
+	redzone_end = (unsigned long)object + cache->object_size;
 	kasan_poison((void *)redzone_start, redzone_end - redzone_start,
 			   KASAN_KMALLOC_REDZONE);
 
+	/*
+	 * Save alloc info (if possible) for kmalloc() allocations.
+	 * This also rewrites the alloc info when called from kasan_krealloc().
+	 */
 	if (kasan_stack_collection_enabled())
-		set_alloc_info(cache, (void *)object, flags, is_kmalloc);
+		set_alloc_info(cache, (void *)object, flags, true);
 
-	return set_tag(object, tag);
-}
-
-void * __must_check __kasan_slab_alloc(struct kmem_cache *cache,
-					void *object, gfp_t flags)
-{
-	return ____kasan_kmalloc(cache, object, cache->object_size, flags, false);
+	/* Keep the tag that was set by kasan_slab_alloc(). */
+	return (void *)object;
 }
 
 void * __must_check __kasan_kmalloc(struct kmem_cache *cache, const void *object,
 					size_t size, gfp_t flags)
 {
-	return ____kasan_kmalloc(cache, object, size, flags, true);
+	return ____kasan_kmalloc(cache, object, size, flags);
 }
 EXPORT_SYMBOL(__kasan_kmalloc);
 
@@ -496,8 +528,7 @@ void * __must_check __kasan_krealloc(con
 	if (unlikely(!PageSlab(page)))
 		return __kasan_kmalloc_large(object, size, flags);
 	else
-		return ____kasan_kmalloc(page->slab_cache, object, size,
-						flags, true);
+		return ____kasan_kmalloc(page->slab_cache, object, size, flags);
 }
 
 void __kasan_kfree_large(void *ptr, unsigned long ip)
--- a/mm/kasan/kasan.h~kasan-mm-optimize-kmalloc-poisoning
+++ a/mm/kasan/kasan.h
@@ -367,12 +367,51 @@ static inline bool kasan_byte_accessible
 
 #else /* CONFIG_KASAN_HW_TAGS */
 
-void kasan_poison(const void *address, size_t size, u8 value);
-void kasan_unpoison(const void *address, size_t size);
+/**
+ * kasan_poison - mark the memory range as unaccessible
+ * @addr - range start address, must be aligned to KASAN_GRANULE_SIZE
+ * @size - range size
+ * @value - value that's written to metadata for the range
+ *
+ * The size gets aligned to KASAN_GRANULE_SIZE before marking the range.
+ */
+void kasan_poison(const void *addr, size_t size, u8 value);
+
+/**
+ * kasan_unpoison - mark the memory range as accessible
+ * @addr - range start address, must be aligned to KASAN_GRANULE_SIZE
+ * @size - range size
+ *
+ * For the tag-based modes, the @size gets aligned to KASAN_GRANULE_SIZE before
+ * marking the range.
+ * For the generic mode, the last granule of the memory range gets partially
+ * unpoisoned based on the @size.
+ */
+void kasan_unpoison(const void *addr, size_t size);
+
 bool kasan_byte_accessible(const void *addr);
 
 #endif /* CONFIG_KASAN_HW_TAGS */
 
+#ifdef CONFIG_KASAN_GENERIC
+
+/**
+ * kasan_poison_last_granule - mark the last granule of the memory range as
+ * unaccessible
+ * @addr - range start address, must be aligned to KASAN_GRANULE_SIZE
+ * @size - range size
+ *
+ * This function is only available for the generic mode, as it's the only mode
+ * that has partially poisoned memory granules.
+ */
+void kasan_poison_last_granule(const void *address, size_t size);
+
+#else /* CONFIG_KASAN_GENERIC */
+
+static inline void kasan_poison_last_granule(const void *address, size_t size) { }
+
+#endif /* CONFIG_KASAN_GENERIC */
+
 /*
  * Exported functions for interfaces called from assembly or from generated
  * code. Declarations here to avoid warning about missing declarations.
--- a/mm/kasan/shadow.c~kasan-mm-optimize-kmalloc-poisoning
+++ a/mm/kasan/shadow.c
@@ -69,10 +69,6 @@ void *memcpy(void *dest, const void *src
 	return __memcpy(dest, src, len);
 }
 
-/*
- * Poisons the shadow memory for 'size' bytes starting from 'addr'.
- * Memory addresses should be aligned to KASAN_GRANULE_SIZE.
- */
 void kasan_poison(const void *address, size_t size, u8 value)
 {
 	void *shadow_start, *shadow_end;
@@ -83,12 +79,12 @@ void kasan_poison(const void *address, s
 	 * addresses to this function.
 	 */
 	address = kasan_reset_tag(address);
-	size = round_up(size, KASAN_GRANULE_SIZE);
 
 	/* Skip KFENCE memory if called explicitly outside of sl*b. */
 	if (is_kfence_address(address))
 		return;
 
+	size = round_up(size, KASAN_GRANULE_SIZE);
 	shadow_start = kasan_mem_to_shadow(address);
 	shadow_end = kasan_mem_to_shadow(address + size);
 
@@ -96,6 +92,16 @@ void kasan_poison(const void *address, s
 }
 EXPORT_SYMBOL(kasan_poison);
 
+#ifdef CONFIG_KASAN_GENERIC
+void kasan_poison_last_granule(const void *address, size_t size)
+{
+	if (size & KASAN_GRANULE_MASK) {
+		u8 *shadow = (u8 *)kasan_mem_to_shadow(address + size);
+		*shadow = size & KASAN_GRANULE_MASK;
+	}
+}
+#endif
+
 void kasan_unpoison(const void *address, size_t size)
 {
 	u8 tag = get_tag(address);
@@ -115,16 +121,12 @@ void kasan_unpoison(const void *address,
 	if (is_kfence_address(address))
 		return;
 
+	/* Unpoison round_up(size, KASAN_GRANULE_SIZE) bytes. */
 	kasan_poison(address, size, tag);
 
-	if (size & KASAN_GRANULE_MASK) {
-		u8 *shadow = (u8 *)kasan_mem_to_shadow(address + size);
-
-		if (IS_ENABLED(CONFIG_KASAN_SW_TAGS))
-			*shadow = tag;
-		else /* CONFIG_KASAN_GENERIC */
-			*shadow = size & KASAN_GRANULE_MASK;
-	}
+	/* Partially poison the last granule for the generic mode. */
+	if (IS_ENABLED(CONFIG_KASAN_GENERIC))
+		kasan_poison_last_granule(address, size);
 }
 
 #ifdef CONFIG_MEMORY_HOTPLUG
--- a/mm/slub.c~kasan-mm-optimize-kmalloc-poisoning
+++ a/mm/slub.c
@@ -3579,8 +3579,7 @@ static void early_kmem_cache_node_alloc(
 	init_object(kmem_cache_node, n, SLUB_RED_ACTIVE);
 	init_tracking(kmem_cache_node, n);
 #endif
-	n = kasan_kmalloc(kmem_cache_node, n, sizeof(struct kmem_cache_node),
-		      GFP_KERNEL);
+	n = kasan_slab_alloc(kmem_cache_node, n, GFP_KERNEL);
 	page->freelist = get_freepointer(kmem_cache_node, n);
 	page->inuse = 1;
 	page->frozen = 0;
_
