Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80393C56202
	for <mm-commits@archiver.kernel.org>; Tue, 24 Nov 2020 00:38:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C62720782
	for <mm-commits@archiver.kernel.org>; Tue, 24 Nov 2020 00:38:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vhqwsUKu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728226AbgKXAiw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 23 Nov 2020 19:38:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:44476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728093AbgKXAiv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 23 Nov 2020 19:38:51 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C81B20729;
        Tue, 24 Nov 2020 00:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1606178328;
        bh=KgUwzeHl/rZzaeyR9K+d9vFBtlgvw0g7Nnj+XXoFqIk=;
        h=Date:From:To:Subject:From;
        b=vhqwsUKus/dIJkKhw8ywLvkGq/NGGKFHcu+/YwU0CWiXa4nyLTPIQ2+p+qyl7jzrr
         JCytfY9/bGyKyxgbsPvT5Dhy0dZwS9+o2aNP4AjCCZpnWpTuVARN6TRYWjSqPr/mhN
         cwL1qf/mlPQqMcb8Yrx9SHO/xBsnE2ZgfP+XwZyk=
Date:   Mon, 23 Nov 2020 16:38:47 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, aryabinin@virtuozzo.com,
        Branislav.Rankov@arm.com, catalin.marinas@arm.com,
        dvyukov@google.com, elver@google.com, eugenis@google.com,
        glider@google.com, gor@linux.ibm.com, kevin.brodsky@arm.com,
        mm-commits@vger.kernel.org, Vincenzo.Frascino@arm.com,
        will.deacon@arm.com
Subject:  + kasan-sanitize-objects-when-metadata-doesnt-fit.patch
 added to -mm tree
Message-ID: <20201124003847.kq-XDK9QD%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: sanitize objects when metadata doesn't fit
has been added to the -mm tree.  Its filename is
     kasan-sanitize-objects-when-metadata-doesnt-fit.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-sanitize-objects-when-metadata-doesnt-fit.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-sanitize-objects-when-metadata-doesnt-fit.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: sanitize objects when metadata doesn't fit

KASAN marks caches that are sanitized with the SLAB_KASAN cache flag. 
Currently if the metadata that is appended after the object (stores e.g. 
stack trace ids) doesn't fit into KMALLOC_MAX_SIZE (can only happen with
SLAB, see the comment in the patch), KASAN turns off sanitization
completely.

With this change sanitization of the object data is always enabled. 
However the metadata is only stored when it fits.  Instead of checking for
SLAB_KASAN flag accross the code to find out whether the metadata is
there, use cache->kasan_info.alloc/free_meta_offset.  As 0 can be a valid
value for free_meta_offset, introduce KASAN_NO_FREE_META as an indicator
that the free metadata is missing.

Without this change all sanitized KASAN objects would be put into
quarantine with generic KASAN.  With this change, only the objects that
have metadata (i.e.  when it fits) are put into quarantine, the rest is
freed right away.

Along the way rework __kasan_cache_create() and add claryfying comments.

Link: https://lkml.kernel.org/r/aee34b87a5e4afe586c2ac6a0b32db8dc4dcc2dc.1606162397.git.andreyknvl@google.com
Link: https://linux-review.googlesource.com/id/Icd947e2bea054cb5cfbdc6cf6652227d97032dcb
Co-developed-by: Vincenzo Frascino <Vincenzo.Frascino@arm.com>
Signed-off-by: Vincenzo Frascino <Vincenzo.Frascino@arm.com>
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Tested-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Branislav Rankov <Branislav.Rankov@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/common.c         |  116 ++++++++++++++++++++++--------------
 mm/kasan/generic.c        |   15 ++--
 mm/kasan/hw_tags.c        |    6 +
 mm/kasan/kasan.h          |   17 ++++-
 mm/kasan/quarantine.c     |   16 ++++
 mm/kasan/report.c         |   43 +++++++------
 mm/kasan/report_sw_tags.c |    9 +-
 mm/kasan/sw_tags.c        |    4 +
 8 files changed, 149 insertions(+), 77 deletions(-)

--- a/mm/kasan/common.c~kasan-sanitize-objects-when-metadata-doesnt-fit
+++ a/mm/kasan/common.c
@@ -115,9 +115,6 @@ void __kasan_free_pages(struct page *pag
  */
 static inline unsigned int optimal_redzone(unsigned int object_size)
 {
-	if (!IS_ENABLED(CONFIG_KASAN_GENERIC))
-		return 0;
-
 	return
 		object_size <= 64        - 16   ? 16 :
 		object_size <= 128       - 32   ? 32 :
@@ -131,47 +128,77 @@ static inline unsigned int optimal_redzo
 void __kasan_cache_create(struct kmem_cache *cache, unsigned int *size,
 			  slab_flags_t *flags)
 {
-	unsigned int orig_size = *size;
-	unsigned int redzone_size;
-	int redzone_adjust;
+	unsigned int ok_size;
+	unsigned int optimal_size;
+
+	/*
+	 * SLAB_KASAN is used to mark caches as ones that are sanitized by
+	 * KASAN. Currently this flag is used in two places:
+	 * 1. In slab_ksize() when calculating the size of the accessible
+	 *    memory within the object.
+	 * 2. In slab_common.c to prevent merging of sanitized caches.
+	 */
+	*flags |= SLAB_KASAN;
 
-	if (!kasan_stack_collection_enabled()) {
-		*flags |= SLAB_KASAN;
+	if (!kasan_stack_collection_enabled())
 		return;
-	}
 
-	/* Add alloc meta. */
+	ok_size = *size;
+
+	/* Add alloc meta into redzone. */
 	cache->kasan_info.alloc_meta_offset = *size;
 	*size += sizeof(struct kasan_alloc_meta);
 
-	/* Add free meta. */
-	if (IS_ENABLED(CONFIG_KASAN_GENERIC) &&
-	    (cache->flags & SLAB_TYPESAFE_BY_RCU || cache->ctor ||
-	     cache->object_size < sizeof(struct kasan_free_meta))) {
-		cache->kasan_info.free_meta_offset = *size;
-		*size += sizeof(struct kasan_free_meta);
+	/*
+	 * If alloc meta doesn't fit, don't add it.
+	 * This can only happen with SLAB, as it has KMALLOC_MAX_SIZE equal
+	 * to KMALLOC_MAX_CACHE_SIZE and doesn't fall back to page_alloc for
+	 * larger sizes.
+	 */
+	if (*size > KMALLOC_MAX_SIZE) {
+		cache->kasan_info.alloc_meta_offset = 0;
+		*size = ok_size;
+		/* Continue, since free meta might still fit. */
 	}
 
-	redzone_size = optimal_redzone(cache->object_size);
-	redzone_adjust = redzone_size -	(*size - cache->object_size);
-	if (redzone_adjust > 0)
-		*size += redzone_adjust;
-
-	*size = min_t(unsigned int, KMALLOC_MAX_SIZE,
-			max(*size, cache->object_size + redzone_size));
+	/* Only the generic mode uses free meta or flexible redzones. */
+	if (!IS_ENABLED(CONFIG_KASAN_GENERIC)) {
+		cache->kasan_info.free_meta_offset = KASAN_NO_FREE_META;
+		return;
+	}
 
 	/*
-	 * If the metadata doesn't fit, don't enable KASAN at all.
+	 * Add free meta into redzone when it's not possible to store
+	 * it in the object. This is the case when:
+	 * 1. Object is SLAB_TYPESAFE_BY_RCU, which means that it can
+	 *    be touched after it was freed, or
+	 * 2. Object has a constructor, which means it's expected to
+	 *    retain its content until the next allocation, or
+	 * 3. Object is too small.
+	 * Otherwise cache->kasan_info.free_meta_offset = 0 is implied.
 	 */
-	if (*size <= cache->kasan_info.alloc_meta_offset ||
-			*size <= cache->kasan_info.free_meta_offset) {
-		cache->kasan_info.alloc_meta_offset = 0;
-		cache->kasan_info.free_meta_offset = 0;
-		*size = orig_size;
-		return;
+	if ((cache->flags & SLAB_TYPESAFE_BY_RCU) || cache->ctor ||
+	    cache->object_size < sizeof(struct kasan_free_meta)) {
+		ok_size = *size;
+
+		cache->kasan_info.free_meta_offset = *size;
+		*size += sizeof(struct kasan_free_meta);
+
+		/* If free meta doesn't fit, don't add it. */
+		if (*size > KMALLOC_MAX_SIZE) {
+			cache->kasan_info.free_meta_offset = KASAN_NO_FREE_META;
+			*size = ok_size;
+		}
 	}
 
-	*flags |= SLAB_KASAN;
+	/* Calculate size with optimal redzone. */
+	optimal_size = cache->object_size + optimal_redzone(cache->object_size);
+	/* Limit it with KMALLOC_MAX_SIZE (relevant for SLAB only). */
+	if (optimal_size > KMALLOC_MAX_SIZE)
+		optimal_size = KMALLOC_MAX_SIZE;
+	/* Use optimal size if the size with added metas is not large enough. */
+	if (*size < optimal_size)
+		*size = optimal_size;
 }
 
 size_t __kasan_metadata_size(struct kmem_cache *cache)
@@ -187,15 +214,21 @@ size_t __kasan_metadata_size(struct kmem
 struct kasan_alloc_meta *kasan_get_alloc_meta(struct kmem_cache *cache,
 					      const void *object)
 {
+	if (!cache->kasan_info.alloc_meta_offset)
+		return NULL;
 	return kasan_reset_tag(object) + cache->kasan_info.alloc_meta_offset;
 }
 
+#ifdef CONFIG_KASAN_GENERIC
 struct kasan_free_meta *kasan_get_free_meta(struct kmem_cache *cache,
 					    const void *object)
 {
 	BUILD_BUG_ON(sizeof(struct kasan_free_meta) > 32);
+	if (cache->kasan_info.free_meta_offset == KASAN_NO_FREE_META)
+		return NULL;
 	return kasan_reset_tag(object) + cache->kasan_info.free_meta_offset;
 }
+#endif
 
 void __kasan_poison_slab(struct page *page)
 {
@@ -272,11 +305,9 @@ void * __must_check __kasan_init_slab_ob
 	struct kasan_alloc_meta *alloc_meta;
 
 	if (kasan_stack_collection_enabled()) {
-		if (!(cache->flags & SLAB_KASAN))
-			return (void *)object;
-
 		alloc_meta = kasan_get_alloc_meta(cache, object);
-		__memset(alloc_meta, 0, sizeof(*alloc_meta));
+		if (alloc_meta)
+			__memset(alloc_meta, 0, sizeof(*alloc_meta));
 	}
 
 	/* Tag is ignored in set_tag() without CONFIG_KASAN_SW/HW_TAGS */
@@ -318,15 +349,12 @@ static bool ____kasan_slab_free(struct k
 	if (!kasan_stack_collection_enabled())
 		return false;
 
-	if ((IS_ENABLED(CONFIG_KASAN_GENERIC) && !quarantine) ||
-			unlikely(!(cache->flags & SLAB_KASAN)))
+	if ((IS_ENABLED(CONFIG_KASAN_GENERIC) && !quarantine))
 		return false;
 
 	kasan_set_free_info(cache, object, tag);
 
-	quarantine_put(cache, object);
-
-	return IS_ENABLED(CONFIG_KASAN_GENERIC);
+	return quarantine_put(cache, object);
 }
 
 bool __kasan_slab_free(struct kmem_cache *cache, void *object, unsigned long ip)
@@ -359,7 +387,11 @@ void __kasan_slab_free_mempool(void *ptr
 
 static void set_alloc_info(struct kmem_cache *cache, void *object, gfp_t flags)
 {
-	kasan_set_track(&kasan_get_alloc_meta(cache, object)->alloc_track, flags);
+	struct kasan_alloc_meta *alloc_meta;
+
+	alloc_meta = kasan_get_alloc_meta(cache, object);
+	if (alloc_meta)
+		kasan_set_track(&alloc_meta->alloc_track, flags);
 }
 
 static void *____kasan_kmalloc(struct kmem_cache *cache, const void *object,
@@ -389,7 +421,7 @@ static void *____kasan_kmalloc(struct km
 	poison_range((void *)redzone_start, redzone_end - redzone_start,
 		     KASAN_KMALLOC_REDZONE);
 
-	if (kasan_stack_collection_enabled() && (cache->flags & SLAB_KASAN))
+	if (kasan_stack_collection_enabled())
 		set_alloc_info(cache, (void *)object, flags);
 
 	return set_tag(object, tag);
--- a/mm/kasan/generic.c~kasan-sanitize-objects-when-metadata-doesnt-fit
+++ a/mm/kasan/generic.c
@@ -338,10 +338,10 @@ void kasan_record_aux_stack(void *addr)
 	cache = page->slab_cache;
 	object = nearest_obj(cache, page, addr);
 	alloc_meta = kasan_get_alloc_meta(cache, object);
+	if (!alloc_meta)
+		return;
 
-	/*
-	 * record the last two call_rcu() call stacks.
-	 */
+	/* Record the last two call_rcu() call stacks. */
 	alloc_meta->aux_stack[1] = alloc_meta->aux_stack[0];
 	alloc_meta->aux_stack[0] = kasan_save_stack(GFP_NOWAIT);
 }
@@ -352,11 +352,11 @@ void kasan_set_free_info(struct kmem_cac
 	struct kasan_free_meta *free_meta;
 
 	free_meta = kasan_get_free_meta(cache, object);
-	kasan_set_track(&free_meta->free_track, GFP_NOWAIT);
+	if (!free_meta)
+		return;
 
-	/*
-	 *  the object was freed and has free track set
-	 */
+	kasan_set_track(&free_meta->free_track, GFP_NOWAIT);
+	/* The object was freed and has free track set. */
 	*(u8 *)kasan_mem_to_shadow(object) = KASAN_KMALLOC_FREETRACK;
 }
 
@@ -365,5 +365,6 @@ struct kasan_track *kasan_get_free_track
 {
 	if (*(u8 *)kasan_mem_to_shadow(object) != KASAN_KMALLOC_FREETRACK)
 		return NULL;
+	/* Free meta must be present with KASAN_KMALLOC_FREETRACK. */
 	return &kasan_get_free_meta(cache, object)->free_track;
 }
--- a/mm/kasan/hw_tags.c~kasan-sanitize-objects-when-metadata-doesnt-fit
+++ a/mm/kasan/hw_tags.c
@@ -187,7 +187,8 @@ void kasan_set_free_info(struct kmem_cac
 	struct kasan_alloc_meta *alloc_meta;
 
 	alloc_meta = kasan_get_alloc_meta(cache, object);
-	kasan_set_track(&alloc_meta->free_track[0], GFP_NOWAIT);
+	if (alloc_meta)
+		kasan_set_track(&alloc_meta->free_track[0], GFP_NOWAIT);
 }
 
 struct kasan_track *kasan_get_free_track(struct kmem_cache *cache,
@@ -196,5 +197,8 @@ struct kasan_track *kasan_get_free_track
 	struct kasan_alloc_meta *alloc_meta;
 
 	alloc_meta = kasan_get_alloc_meta(cache, object);
+	if (!alloc_meta)
+		return NULL;
+
 	return &alloc_meta->free_track[0];
 }
--- a/mm/kasan/kasan.h~kasan-sanitize-objects-when-metadata-doesnt-fit
+++ a/mm/kasan/kasan.h
@@ -156,20 +156,31 @@ struct kasan_alloc_meta {
 struct qlist_node {
 	struct qlist_node *next;
 };
+
+/*
+ * Generic mode either stores free meta in the object itself or in the redzone
+ * after the object. In the former case free meta offset is 0, in the latter
+ * case it has some sane value smaller than INT_MAX. Use INT_MAX as free meta
+ * offset when free meta isn't present.
+ */
+#define KASAN_NO_FREE_META INT_MAX
+
 struct kasan_free_meta {
+#ifdef CONFIG_KASAN_GENERIC
 	/* This field is used while the object is in the quarantine.
 	 * Otherwise it might be used for the allocator freelist.
 	 */
 	struct qlist_node quarantine_link;
-#ifdef CONFIG_KASAN_GENERIC
 	struct kasan_track free_track;
 #endif
 };
 
 struct kasan_alloc_meta *kasan_get_alloc_meta(struct kmem_cache *cache,
 						const void *object);
+#ifdef CONFIG_KASAN_GENERIC
 struct kasan_free_meta *kasan_get_free_meta(struct kmem_cache *cache,
 						const void *object);
+#endif
 
 #if defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS)
 
@@ -234,11 +245,11 @@ struct kasan_track *kasan_get_free_track
 
 #if defined(CONFIG_KASAN_GENERIC) && \
 	(defined(CONFIG_SLAB) || defined(CONFIG_SLUB))
-void quarantine_put(struct kmem_cache *cache, void *object);
+bool quarantine_put(struct kmem_cache *cache, void *object);
 void quarantine_reduce(void);
 void quarantine_remove_cache(struct kmem_cache *cache);
 #else
-static inline void quarantine_put(struct kmem_cache *cache, void *object) { }
+static inline bool quarantine_put(struct kmem_cache *cache, void *object) { return false; }
 static inline void quarantine_reduce(void) { }
 static inline void quarantine_remove_cache(struct kmem_cache *cache) { }
 #endif
--- a/mm/kasan/quarantine.c~kasan-sanitize-objects-when-metadata-doesnt-fit
+++ a/mm/kasan/quarantine.c
@@ -135,7 +135,12 @@ static void qlink_free(struct qlist_node
 	if (IS_ENABLED(CONFIG_SLAB))
 		local_irq_save(flags);
 
+	/*
+	 * As the object now gets freed from the quaratine, assume that its
+	 * free track is no longer valid.
+	 */
 	*(u8 *)kasan_mem_to_shadow(object) = KASAN_KMALLOC_FREE;
+
 	___cache_free(cache, object, _THIS_IP_);
 
 	if (IS_ENABLED(CONFIG_SLAB))
@@ -161,7 +166,7 @@ static void qlist_free_all(struct qlist_
 	qlist_init(q);
 }
 
-void quarantine_put(struct kmem_cache *cache, void *object)
+bool quarantine_put(struct kmem_cache *cache, void *object)
 {
 	unsigned long flags;
 	struct qlist_head *q;
@@ -169,6 +174,13 @@ void quarantine_put(struct kmem_cache *c
 	struct kasan_free_meta *meta = kasan_get_free_meta(cache, object);
 
 	/*
+	 * If there's no metadata for this object, don't put it into
+	 * quarantine.
+	 */
+	if (!meta)
+		return false;
+
+	/*
 	 * Note: irq must be disabled until after we move the batch to the
 	 * global quarantine. Otherwise quarantine_remove_cache() can miss
 	 * some objects belonging to the cache if they are in our local temp
@@ -200,6 +212,8 @@ void quarantine_put(struct kmem_cache *c
 	}
 
 	local_irq_restore(flags);
+
+	return true;
 }
 
 void quarantine_reduce(void)
--- a/mm/kasan/report.c~kasan-sanitize-objects-when-metadata-doesnt-fit
+++ a/mm/kasan/report.c
@@ -168,32 +168,35 @@ static void describe_object_addr(struct
 static void describe_object_stacks(struct kmem_cache *cache, void *object,
 					const void *addr, u8 tag)
 {
-	struct kasan_alloc_meta *alloc_meta = kasan_get_alloc_meta(cache, object);
-
-	if (cache->flags & SLAB_KASAN) {
-		struct kasan_track *free_track;
+	struct kasan_alloc_meta *alloc_meta;
+	struct kasan_track *free_track;
 
+	alloc_meta = kasan_get_alloc_meta(cache, object);
+	if (alloc_meta) {
 		print_track(&alloc_meta->alloc_track, "Allocated");
 		pr_err("\n");
-		free_track = kasan_get_free_track(cache, object, tag);
-		if (free_track) {
-			print_track(free_track, "Freed");
-			pr_err("\n");
-		}
+	}
+
+	free_track = kasan_get_free_track(cache, object, tag);
+	if (free_track) {
+		print_track(free_track, "Freed");
+		pr_err("\n");
+	}
 
 #ifdef CONFIG_KASAN_GENERIC
-		if (alloc_meta->aux_stack[0]) {
-			pr_err("Last call_rcu():\n");
-			print_stack(alloc_meta->aux_stack[0]);
-			pr_err("\n");
-		}
-		if (alloc_meta->aux_stack[1]) {
-			pr_err("Second to last call_rcu():\n");
-			print_stack(alloc_meta->aux_stack[1]);
-			pr_err("\n");
-		}
-#endif
+	if (!alloc_meta)
+		return;
+	if (alloc_meta->aux_stack[0]) {
+		pr_err("Last call_rcu():\n");
+		print_stack(alloc_meta->aux_stack[0]);
+		pr_err("\n");
 	}
+	if (alloc_meta->aux_stack[1]) {
+		pr_err("Second to last call_rcu():\n");
+		print_stack(alloc_meta->aux_stack[1]);
+		pr_err("\n");
+	}
+#endif
 }
 
 static void describe_object(struct kmem_cache *cache, void *object,
--- a/mm/kasan/report_sw_tags.c~kasan-sanitize-objects-when-metadata-doesnt-fit
+++ a/mm/kasan/report_sw_tags.c
@@ -48,9 +48,12 @@ const char *get_bug_type(struct kasan_ac
 		object = nearest_obj(cache, page, (void *)addr);
 		alloc_meta = kasan_get_alloc_meta(cache, object);
 
-		for (i = 0; i < KASAN_NR_FREE_STACKS; i++)
-			if (alloc_meta->free_pointer_tag[i] == tag)
-				return "use-after-free";
+		if (alloc_meta) {
+			for (i = 0; i < KASAN_NR_FREE_STACKS; i++) {
+				if (alloc_meta->free_pointer_tag[i] == tag)
+					return "use-after-free";
+			}
+		}
 		return "out-of-bounds";
 	}
 
--- a/mm/kasan/sw_tags.c~kasan-sanitize-objects-when-metadata-doesnt-fit
+++ a/mm/kasan/sw_tags.c
@@ -170,6 +170,8 @@ void kasan_set_free_info(struct kmem_cac
 	u8 idx = 0;
 
 	alloc_meta = kasan_get_alloc_meta(cache, object);
+	if (!alloc_meta)
+		return;
 
 #ifdef CONFIG_KASAN_SW_TAGS_IDENTIFY
 	idx = alloc_meta->free_track_idx;
@@ -187,6 +189,8 @@ struct kasan_track *kasan_get_free_track
 	int i = 0;
 
 	alloc_meta = kasan_get_alloc_meta(cache, object);
+	if (!alloc_meta)
+		return NULL;
 
 #ifdef CONFIG_KASAN_SW_TAGS_IDENTIFY
 	for (i = 0; i < KASAN_NR_FREE_STACKS; i++) {
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-drop-unnecessary-gpl-text-from-comment-headers.patch
kasan-kasan_vmalloc-depends-on-kasan_generic.patch
kasan-group-vmalloc-code.patch
kasan-shadow-declarations-only-for-software-modes.patch
kasan-rename-unpoison_shadow-to-unpoison_range.patch
kasan-rename-kasan_shadow_-to-kasan_granule_.patch
kasan-only-build-initc-for-software-modes.patch
kasan-split-out-shadowc-from-commonc.patch
kasan-define-kasan_memory_per_shadow_page.patch
kasan-rename-report-and-tags-files.patch
kasan-dont-duplicate-config-dependencies.patch
kasan-hide-invalid-free-check-implementation.patch
kasan-decode-stack-frame-only-with-kasan_stack_enable.patch
kasan-arm64-only-init-shadow-for-software-modes.patch
kasan-arm64-only-use-kasan_depth-for-software-modes.patch
kasan-arm64-move-initialization-message.patch
kasan-arm64-rename-kasan_init_tags-and-mark-as-__init.patch
kasan-rename-addr_has_shadow-to-addr_has_metadata.patch
kasan-rename-print_shadow_for_address-to-print_memory_metadata.patch
kasan-rename-shadow-layout-macros-to-meta.patch
kasan-separate-metadata_fetch_row-for-each-mode.patch
kasan-arm64-dont-allow-sw_tags-with-arm64_mte.patch
kasan-introduce-config_kasan_hw_tags.patch
arm64-kasan-align-allocations-for-hw_tags.patch
arm64-kasan-add-arch-layer-for-memory-tagging-helpers.patch
kasan-define-kasan_granule_size-for-hw_tags.patch
kasan-x86-s390-update-undef-config_kasan.patch
kasan-arm64-expand-config_kasan-checks.patch
kasan-arm64-implement-hw_tags-runtime.patch
kasan-arm64-print-report-from-tag-fault-handler.patch
kasan-mm-reset-tags-when-accessing-metadata.patch
kasan-arm64-enable-config_kasan_hw_tags.patch
kasan-add-documentation-for-hardware-tag-based-mode.patch
kasan-simplify-quarantine_put-call-site.patch
kasan-rename-get_alloc-free_info.patch
kasan-introduce-set_alloc_info.patch
kasan-arm64-unpoison-stack-only-with-config_kasan_stack.patch
kasan-allow-vmap_stack-for-hw_tags-mode.patch
kasan-remove-__kasan_unpoison_stack.patch
kasan-inline-kasan_reset_tag-for-tag-based-modes.patch
kasan-inline-random_tag-for-hw_tags.patch
kasan-open-code-kasan_unpoison_slab.patch
kasan-inline-unpoison_range-and-check_invalid_free.patch
kasan-add-and-integrate-kasan-boot-parameters.patch
kasan-mm-check-kasan_enabled-in-annotations.patch
kasan-mm-rename-kasan_poison_kfree.patch
kasan-dont-round_up-too-much.patch
kasan-simplify-assign_tag-and-set_tag-calls.patch
kasan-clarify-comment-in-__kasan_kfree_large.patch
kasan-sanitize-objects-when-metadata-doesnt-fit.patch
kasan-mm-allow-cache-merging-with-no-metadata.patch
kasan-update-documentation.patch

