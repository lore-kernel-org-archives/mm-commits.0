Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5B6AECAAD3
	for <mm-commits@archiver.kernel.org>; Mon,  5 Sep 2022 22:48:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232283AbiIEWsQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 5 Sep 2022 18:48:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232371AbiIEWsJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 5 Sep 2022 18:48:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2887444576
        for <mm-commits@vger.kernel.org>; Mon,  5 Sep 2022 15:48:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B6711B815D7
        for <mm-commits@vger.kernel.org>; Mon,  5 Sep 2022 22:48:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BFA5C43470;
        Mon,  5 Sep 2022 22:48:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662418085;
        bh=hUeoYAKEMpgIJKg1xgfXOCAe8ZV80sMWxNsMHtD70Dc=;
        h=Date:To:From:Subject:From;
        b=lrfuL3oqj5R/E6HfDGnKddagGod3RSGkJnQkKo7DuDyTCFCnM6zLvTKOOgwkVZ/t1
         8qLG1aMDO225MgJny5c2fchKpGKigTIR5OXClfH5X450v7Z0kpw6E4LeywvB/eV5q2
         ZtNhkIQccLJb2ttE8vSAOUBjCJEKJMi/6xgTzrw8=
Date:   Mon, 05 Sep 2022 15:48:04 -0700
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com, pcc@google.com,
        glider@google.com, eugenis@google.com, elver@google.com,
        dvyukov@google.com, andreyknvl@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-introduce-kasan_init_cache_meta.patch added to mm-unstable branch
Message-Id: <20220905224805.5BFA5C43470@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: introduce kasan_init_cache_meta
has been added to the -mm mm-unstable branch.  Its filename is
     kasan-introduce-kasan_init_cache_meta.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-introduce-kasan_init_cache_meta.patch

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
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: introduce kasan_init_cache_meta
Date: Mon, 5 Sep 2022 23:05:27 +0200

Add a kasan_init_cache_meta() helper that initializes metadata-related
cache parameters and use this helper in the common KASAN code.

Put the implementation of this new helper into generic.c, as only the
Generic mode uses per-object metadata.

Link: https://lkml.kernel.org/r/a6d7ea01876eb36472c9879f7b23f1b24766276e.1662411799.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Peter Collingbourne <pcc@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/common.c  |   80 +------------------------------------------
 mm/kasan/generic.c |   79 ++++++++++++++++++++++++++++++++++++++++++
 mm/kasan/kasan.h   |    2 +
 3 files changed, 83 insertions(+), 78 deletions(-)

--- a/mm/kasan/common.c~kasan-introduce-kasan_init_cache_meta
+++ a/mm/kasan/common.c
@@ -118,28 +118,9 @@ void __kasan_poison_pages(struct page *p
 			     KASAN_PAGE_FREE, init);
 }
 
-/*
- * Adaptive redzone policy taken from the userspace AddressSanitizer runtime.
- * For larger allocations larger redzones are used.
- */
-static inline unsigned int optimal_redzone(unsigned int object_size)
-{
-	return
-		object_size <= 64        - 16   ? 16 :
-		object_size <= 128       - 32   ? 32 :
-		object_size <= 512       - 64   ? 64 :
-		object_size <= 4096      - 128  ? 128 :
-		object_size <= (1 << 14) - 256  ? 256 :
-		object_size <= (1 << 15) - 512  ? 512 :
-		object_size <= (1 << 16) - 1024 ? 1024 : 2048;
-}
-
 void __kasan_cache_create(struct kmem_cache *cache, unsigned int *size,
 			  slab_flags_t *flags)
 {
-	unsigned int ok_size;
-	unsigned int optimal_size;
-
 	/*
 	 * SLAB_KASAN is used to mark caches as ones that are sanitized by
 	 * KASAN. Currently this flag is used in two places:
@@ -149,65 +130,8 @@ void __kasan_cache_create(struct kmem_ca
 	 */
 	*flags |= SLAB_KASAN;
 
-	if (!kasan_requires_meta())
-		return;
-
-	ok_size = *size;
-
-	/* Add alloc meta into redzone. */
-	cache->kasan_info.alloc_meta_offset = *size;
-	*size += sizeof(struct kasan_alloc_meta);
-
-	/*
-	 * If alloc meta doesn't fit, don't add it.
-	 * This can only happen with SLAB, as it has KMALLOC_MAX_SIZE equal
-	 * to KMALLOC_MAX_CACHE_SIZE and doesn't fall back to page_alloc for
-	 * larger sizes.
-	 */
-	if (*size > KMALLOC_MAX_SIZE) {
-		cache->kasan_info.alloc_meta_offset = 0;
-		*size = ok_size;
-		/* Continue, since free meta might still fit. */
-	}
-
-	/* Only the generic mode uses free meta or flexible redzones. */
-	if (!IS_ENABLED(CONFIG_KASAN_GENERIC)) {
-		cache->kasan_info.free_meta_offset = KASAN_NO_FREE_META;
-		return;
-	}
-
-	/*
-	 * Add free meta into redzone when it's not possible to store
-	 * it in the object. This is the case when:
-	 * 1. Object is SLAB_TYPESAFE_BY_RCU, which means that it can
-	 *    be touched after it was freed, or
-	 * 2. Object has a constructor, which means it's expected to
-	 *    retain its content until the next allocation, or
-	 * 3. Object is too small.
-	 * Otherwise cache->kasan_info.free_meta_offset = 0 is implied.
-	 */
-	if ((cache->flags & SLAB_TYPESAFE_BY_RCU) || cache->ctor ||
-	    cache->object_size < sizeof(struct kasan_free_meta)) {
-		ok_size = *size;
-
-		cache->kasan_info.free_meta_offset = *size;
-		*size += sizeof(struct kasan_free_meta);
-
-		/* If free meta doesn't fit, don't add it. */
-		if (*size > KMALLOC_MAX_SIZE) {
-			cache->kasan_info.free_meta_offset = KASAN_NO_FREE_META;
-			*size = ok_size;
-		}
-	}
-
-	/* Calculate size with optimal redzone. */
-	optimal_size = cache->object_size + optimal_redzone(cache->object_size);
-	/* Limit it with KMALLOC_MAX_SIZE (relevant for SLAB only). */
-	if (optimal_size > KMALLOC_MAX_SIZE)
-		optimal_size = KMALLOC_MAX_SIZE;
-	/* Use optimal size if the size with added metas is not large enough. */
-	if (*size < optimal_size)
-		*size = optimal_size;
+	if (kasan_requires_meta())
+		kasan_init_cache_meta(cache, size);
 }
 
 void __kasan_cache_create_kmalloc(struct kmem_cache *cache)
--- a/mm/kasan/generic.c~kasan-introduce-kasan_init_cache_meta
+++ a/mm/kasan/generic.c
@@ -328,6 +328,85 @@ DEFINE_ASAN_SET_SHADOW(f3);
 DEFINE_ASAN_SET_SHADOW(f5);
 DEFINE_ASAN_SET_SHADOW(f8);
 
+/*
+ * Adaptive redzone policy taken from the userspace AddressSanitizer runtime.
+ * For larger allocations larger redzones are used.
+ */
+static inline unsigned int optimal_redzone(unsigned int object_size)
+{
+	return
+		object_size <= 64        - 16   ? 16 :
+		object_size <= 128       - 32   ? 32 :
+		object_size <= 512       - 64   ? 64 :
+		object_size <= 4096      - 128  ? 128 :
+		object_size <= (1 << 14) - 256  ? 256 :
+		object_size <= (1 << 15) - 512  ? 512 :
+		object_size <= (1 << 16) - 1024 ? 1024 : 2048;
+}
+
+void kasan_init_cache_meta(struct kmem_cache *cache, unsigned int *size)
+{
+	unsigned int ok_size;
+	unsigned int optimal_size;
+
+	ok_size = *size;
+
+	/* Add alloc meta into redzone. */
+	cache->kasan_info.alloc_meta_offset = *size;
+	*size += sizeof(struct kasan_alloc_meta);
+
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
+	}
+
+	/* Only the generic mode uses free meta or flexible redzones. */
+	if (!IS_ENABLED(CONFIG_KASAN_GENERIC)) {
+		cache->kasan_info.free_meta_offset = KASAN_NO_FREE_META;
+		return;
+	}
+
+	/*
+	 * Add free meta into redzone when it's not possible to store
+	 * it in the object. This is the case when:
+	 * 1. Object is SLAB_TYPESAFE_BY_RCU, which means that it can
+	 *    be touched after it was freed, or
+	 * 2. Object has a constructor, which means it's expected to
+	 *    retain its content until the next allocation, or
+	 * 3. Object is too small.
+	 * Otherwise cache->kasan_info.free_meta_offset = 0 is implied.
+	 */
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
+	}
+
+	/* Calculate size with optimal redzone. */
+	optimal_size = cache->object_size + optimal_redzone(cache->object_size);
+	/* Limit it with KMALLOC_MAX_SIZE (relevant for SLAB only). */
+	if (optimal_size > KMALLOC_MAX_SIZE)
+		optimal_size = KMALLOC_MAX_SIZE;
+	/* Use optimal size if the size with added metas is not large enough. */
+	if (*size < optimal_size)
+		*size = optimal_size;
+}
+
 struct kasan_alloc_meta *kasan_get_alloc_meta(struct kmem_cache *cache,
 					      const void *object)
 {
--- a/mm/kasan/kasan.h~kasan-introduce-kasan_init_cache_meta
+++ a/mm/kasan/kasan.h
@@ -297,12 +297,14 @@ struct page *kasan_addr_to_page(const vo
 struct slab *kasan_addr_to_slab(const void *addr);
 
 #ifdef CONFIG_KASAN_GENERIC
+void kasan_init_cache_meta(struct kmem_cache *cache, unsigned int *size);
 void kasan_init_object_meta(struct kmem_cache *cache, const void *object);
 struct kasan_alloc_meta *kasan_get_alloc_meta(struct kmem_cache *cache,
 						const void *object);
 struct kasan_free_meta *kasan_get_free_meta(struct kmem_cache *cache,
 						const void *object);
 #else
+static inline void kasan_init_cache_meta(struct kmem_cache *cache, unsigned int *size) { }
 static inline void kasan_init_object_meta(struct kmem_cache *cache, const void *object) { }
 #endif
 
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-check-kasan_no_free_meta-in-__kasan_metadata_size.patch
kasan-rename-kasan_set__info-to-kasan_save__info.patch
kasan-move-is_kmalloc-check-out-of-save_alloc_info.patch
kasan-split-save_alloc_info-implementations.patch
kasan-drop-config_kasan_tags_identify.patch
kasan-introduce-kasan_print_aux_stacks.patch
kasan-introduce-kasan_get_alloc_track.patch
kasan-introduce-kasan_init_object_meta.patch
kasan-clear-metadata-functions-for-tag-based-modes.patch
kasan-move-kasan_get__meta-to-genericc.patch
kasan-introduce-kasan_requires_meta.patch
kasan-introduce-kasan_init_cache_meta.patch
kasan-drop-config_kasan_generic-check-from-kasan_init_cache_meta.patch
kasan-only-define-kasan_metadata_size-for-generic-mode.patch
kasan-only-define-kasan_never_merge-for-generic-mode.patch
kasan-only-define-metadata-offsets-for-generic-mode.patch
kasan-only-define-metadata-structs-for-generic-mode.patch
kasan-only-define-kasan_cache_create-for-generic-mode.patch
kasan-pass-tagged-pointers-to-kasan_save_alloc-free_info.patch
kasan-move-kasan_get_alloc-free_track-definitions.patch
kasan-cosmetic-changes-in-reportc.patch
kasan-use-virt_addr_valid-in-kasan_addr_to_page-slab.patch
kasan-use-kasan_addr_to_slab-in-print_address_description.patch
kasan-make-kasan_addr_to_page-static.patch
kasan-simplify-print_report.patch
kasan-introduce-complete_report_info.patch
kasan-fill-in-cache-and-object-in-complete_report_info.patch
kasan-rework-function-arguments-in-reportc.patch
kasan-introduce-kasan_complete_mode_report_info.patch
kasan-implement-stack-ring-for-tag-based-modes.patch
kasan-support-kasanstacktrace-for-sw_tags.patch
kasan-dynamically-allocate-stack-ring-entries.patch
kasan-better-identify-bug-types-for-tag-based-modes.patch
kasan-add-another-use-after-free-test.patch
kasan-move-tests-to-mm-kasan.patch

