Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29509ECAAA1
	for <mm-commits@archiver.kernel.org>; Mon,  5 Sep 2022 22:48:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232409AbiIEWsQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 5 Sep 2022 18:48:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232362AbiIEWsH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 5 Sep 2022 18:48:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8117A44548
        for <mm-commits@vger.kernel.org>; Mon,  5 Sep 2022 15:48:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 09607B815E6
        for <mm-commits@vger.kernel.org>; Mon,  5 Sep 2022 22:48:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CE1FC433D6;
        Mon,  5 Sep 2022 22:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662418082;
        bh=F+dAcizvbX9Vah+60bCU0sj8NsqIE0EoKgjsDUWiZI8=;
        h=Date:To:From:Subject:From;
        b=JFXh9r1zxOAHZgS0lR3K9nrryl94ORlTwop+wdz2fDPGQOO/M4HmZavQ51Q/Tc/js
         ZuhVkhbPSxObFhoTHL78sDU++wClXncnl4lzhDgzM3MUb+1oArFl9ToWuUH65nNzeD
         xCv/z0h0WH3Ov2SQm0FssrOr6pKTaWkY6oSlON0I=
Date:   Mon, 05 Sep 2022 15:48:01 -0700
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com, pcc@google.com,
        glider@google.com, eugenis@google.com, elver@google.com,
        dvyukov@google.com, andreyknvl@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-introduce-kasan_requires_meta.patch added to mm-unstable branch
Message-Id: <20220905224802.9CE1FC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: introduce kasan_requires_meta
has been added to the -mm mm-unstable branch.  Its filename is
     kasan-introduce-kasan_requires_meta.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-introduce-kasan_requires_meta.patch

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
Subject: kasan: introduce kasan_requires_meta
Date: Mon, 5 Sep 2022 23:05:26 +0200

Add a kasan_requires_meta() helper that indicates whether the enabled
KASAN mode requires per-object metadata and use this helper in the common
code.

Also hide kasan_init_object_meta() under CONFIG_KASAN_GENERIC ifdef check,
as Generic is the only mode that uses per-object metadata.

To allow for a potential future change that makes Generic KASAN support
the kasan.stacktrace command-line parameter, let kasan_requires_meta()
return kasan_stack_collection_enabled() instead of simply returning true.

Link: https://lkml.kernel.org/r/cf837e9996246aaaeebf704ccf8ec26a34fcf64f.1662411799.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Peter Collingbourne <pcc@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/common.c |   13 +++++--------
 mm/kasan/kasan.h  |   33 +++++++++++++++++++++++++++++----
 mm/kasan/tags.c   |    4 ----
 3 files changed, 34 insertions(+), 16 deletions(-)

--- a/mm/kasan/common.c~kasan-introduce-kasan_requires_meta
+++ a/mm/kasan/common.c
@@ -88,13 +88,10 @@ asmlinkage void kasan_unpoison_task_stac
 }
 #endif /* CONFIG_KASAN_STACK */
 
-/*
- * Only allow cache merging when stack collection is disabled and no metadata
- * is present.
- */
+/* Only allow cache merging when no per-object metadata is present. */
 slab_flags_t __kasan_never_merge(void)
 {
-	if (kasan_stack_collection_enabled())
+	if (kasan_requires_meta())
 		return SLAB_KASAN;
 	return 0;
 }
@@ -152,7 +149,7 @@ void __kasan_cache_create(struct kmem_ca
 	 */
 	*flags |= SLAB_KASAN;
 
-	if (!kasan_stack_collection_enabled())
+	if (!kasan_requires_meta())
 		return;
 
 	ok_size = *size;
@@ -220,7 +217,7 @@ void __kasan_cache_create_kmalloc(struct
 
 size_t __kasan_metadata_size(struct kmem_cache *cache)
 {
-	if (!kasan_stack_collection_enabled())
+	if (!kasan_requires_meta())
 		return 0;
 	return (cache->kasan_info.alloc_meta_offset ?
 		sizeof(struct kasan_alloc_meta) : 0) +
@@ -295,7 +292,7 @@ void * __must_check __kasan_init_slab_ob
 						const void *object)
 {
 	/* Initialize per-object metadata if it is present. */
-	if (kasan_stack_collection_enabled())
+	if (kasan_requires_meta())
 		kasan_init_object_meta(cache, object);
 
 	/* Tag is ignored in set_tag() without CONFIG_KASAN_SW/HW_TAGS */
--- a/mm/kasan/kasan.h~kasan-introduce-kasan_requires_meta
+++ a/mm/kasan/kasan.h
@@ -43,7 +43,7 @@ static inline bool kasan_sync_fault_poss
 	return kasan_mode == KASAN_MODE_SYNC || kasan_mode == KASAN_MODE_ASYMM;
 }
 
-#else
+#else /* CONFIG_KASAN_HW_TAGS */
 
 static inline bool kasan_stack_collection_enabled(void)
 {
@@ -60,7 +60,31 @@ static inline bool kasan_sync_fault_poss
 	return true;
 }
 
-#endif
+#endif /* CONFIG_KASAN_HW_TAGS */
+
+#ifdef CONFIG_KASAN_GENERIC
+
+/* Generic KASAN uses per-object metadata to store stack traces. */
+static inline bool kasan_requires_meta(void)
+{
+	/*
+	 * Technically, Generic KASAN always collects stack traces right now.
+	 * However, let's use kasan_stack_collection_enabled() in case the
+	 * kasan.stacktrace command-line argument is changed to affect
+	 * Generic KASAN.
+	 */
+	return kasan_stack_collection_enabled();
+}
+
+#else /* CONFIG_KASAN_GENERIC */
+
+/* Tag-based KASAN modes do not use per-object metadata. */
+static inline bool kasan_requires_meta(void)
+{
+	return false;
+}
+
+#endif /* CONFIG_KASAN_GENERIC */
 
 #if defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS)
 #define KASAN_GRANULE_SIZE	(1UL << KASAN_SHADOW_SCALE_SHIFT)
@@ -272,13 +296,14 @@ void kasan_report_invalid_free(void *obj
 struct page *kasan_addr_to_page(const void *addr);
 struct slab *kasan_addr_to_slab(const void *addr);
 
-void kasan_init_object_meta(struct kmem_cache *cache, const void *object);
-
 #ifdef CONFIG_KASAN_GENERIC
+void kasan_init_object_meta(struct kmem_cache *cache, const void *object);
 struct kasan_alloc_meta *kasan_get_alloc_meta(struct kmem_cache *cache,
 						const void *object);
 struct kasan_free_meta *kasan_get_free_meta(struct kmem_cache *cache,
 						const void *object);
+#else
+static inline void kasan_init_object_meta(struct kmem_cache *cache, const void *object) { }
 #endif
 
 depot_stack_handle_t kasan_save_stack(gfp_t flags, bool can_alloc);
--- a/mm/kasan/tags.c~kasan-introduce-kasan_requires_meta
+++ a/mm/kasan/tags.c
@@ -17,10 +17,6 @@
 
 #include "kasan.h"
 
-void kasan_init_object_meta(struct kmem_cache *cache, const void *object)
-{
-}
-
 void kasan_save_alloc_info(struct kmem_cache *cache, void *object, gfp_t flags)
 {
 }
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

