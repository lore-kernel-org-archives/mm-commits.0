Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB05AC433F5
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:09:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229525AbiJCVJf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:09:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229924AbiJCVH4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:07:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA4E34E868
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:06:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 66DD3610A3
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:06:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE801C433B5;
        Mon,  3 Oct 2022 21:06:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831167;
        bh=vyDnCPH0v7byyQIwJsPZ8IQDOuJkgj9M1IINdZ+uvHA=;
        h=Date:To:From:Subject:From;
        b=dkbkPsqyF45cIohr+694H2WxB55b34vBliI0o3zDO0FSo7S5yjTlIdu3yfbMNmlzS
         JyRbuhkK7EZzH2shhZRGqDMHNAL5EEz9HB8pHAduFaeRWkoctl0FDWxR5EIO0QC5Is
         FDvqFFFc/KT59EOoT0qblLhcXL7Sxqo/Uuy1oL78=
Date:   Mon, 03 Oct 2022 14:06:07 -0700
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com, pcc@google.com,
        glider@google.com, eugenis@google.com, elver@google.com,
        dvyukov@google.com, andreyknvl@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kasan-only-define-kasan_cache_create-for-generic-mode.patch removed from -mm tree
Message-Id: <20221003210607.BE801C433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kasan: only define kasan_cache_create for Generic mode
has been removed from the -mm tree.  Its filename was
     kasan-only-define-kasan_cache_create-for-generic-mode.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: only define kasan_cache_create for Generic mode
Date: Mon, 5 Sep 2022 23:05:33 +0200

Right now, kasan_cache_create() assigns SLAB_KASAN for all KASAN modes and
then sets up metadata-related cache parameters for the Generic mode.

SLAB_KASAN is used in two places:

1. In slab_ksize() to account for per-object metadata when
   calculating the size of the accessible memory within the object.
2. In slab_common.c via kasan_never_merge() to prevent merging of
   caches with per-object metadata.

Both cases are only relevant when per-object metadata is present, which is
only the case with the Generic mode.

Thus, assign SLAB_KASAN and define kasan_cache_create() only for the
Generic mode.

Also update the SLAB_KASAN-related comment.

Link: https://lkml.kernel.org/r/61faa2aa1906e2d02c97d00ddf99ce8911dda095.1662411799.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Peter Collingbourne <pcc@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kasan.h |   18 ++++++------------
 include/linux/slab.h  |    2 +-
 mm/kasan/common.c     |   16 ----------------
 mm/kasan/generic.c    |   17 ++++++++++++++++-
 4 files changed, 23 insertions(+), 30 deletions(-)

--- a/include/linux/kasan.h~kasan-only-define-kasan_cache_create-for-generic-mode
+++ a/include/linux/kasan.h
@@ -128,15 +128,6 @@ static __always_inline void kasan_unpois
 		__kasan_unpoison_pages(page, order, init);
 }
 
-void __kasan_cache_create(struct kmem_cache *cache, unsigned int *size,
-				slab_flags_t *flags);
-static __always_inline void kasan_cache_create(struct kmem_cache *cache,
-				unsigned int *size, slab_flags_t *flags)
-{
-	if (kasan_enabled())
-		__kasan_cache_create(cache, size, flags);
-}
-
 void __kasan_cache_create_kmalloc(struct kmem_cache *cache);
 static __always_inline void kasan_cache_create_kmalloc(struct kmem_cache *cache)
 {
@@ -260,9 +251,6 @@ static inline void kasan_poison_pages(st
 				      bool init) {}
 static inline void kasan_unpoison_pages(struct page *page, unsigned int order,
 					bool init) {}
-static inline void kasan_cache_create(struct kmem_cache *cache,
-				      unsigned int *size,
-				      slab_flags_t *flags) {}
 static inline void kasan_cache_create_kmalloc(struct kmem_cache *cache) {}
 static inline void kasan_poison_slab(struct slab *slab) {}
 static inline void kasan_unpoison_object_data(struct kmem_cache *cache,
@@ -316,6 +304,8 @@ static inline void kasan_unpoison_task_s
 
 size_t kasan_metadata_size(struct kmem_cache *cache);
 slab_flags_t kasan_never_merge(void);
+void kasan_cache_create(struct kmem_cache *cache, unsigned int *size,
+			slab_flags_t *flags);
 
 void kasan_cache_shrink(struct kmem_cache *cache);
 void kasan_cache_shutdown(struct kmem_cache *cache);
@@ -334,6 +324,10 @@ static inline slab_flags_t kasan_never_m
 {
 	return 0;
 }
+/* And no cache-related metadata initialization is required. */
+static inline void kasan_cache_create(struct kmem_cache *cache,
+				      unsigned int *size,
+				      slab_flags_t *flags) {}
 
 static inline void kasan_cache_shrink(struct kmem_cache *cache) {}
 static inline void kasan_cache_shutdown(struct kmem_cache *cache) {}
--- a/include/linux/slab.h~kasan-only-define-kasan_cache_create-for-generic-mode
+++ a/include/linux/slab.h
@@ -106,7 +106,7 @@
 # define SLAB_ACCOUNT		0
 #endif
 
-#ifdef CONFIG_KASAN
+#ifdef CONFIG_KASAN_GENERIC
 #define SLAB_KASAN		((slab_flags_t __force)0x08000000U)
 #else
 #define SLAB_KASAN		0
--- a/mm/kasan/common.c~kasan-only-define-kasan_cache_create-for-generic-mode
+++ a/mm/kasan/common.c
@@ -110,22 +110,6 @@ void __kasan_poison_pages(struct page *p
 			     KASAN_PAGE_FREE, init);
 }
 
-void __kasan_cache_create(struct kmem_cache *cache, unsigned int *size,
-			  slab_flags_t *flags)
-{
-	/*
-	 * SLAB_KASAN is used to mark caches as ones that are sanitized by
-	 * KASAN. Currently this flag is used in two places:
-	 * 1. In slab_ksize() when calculating the size of the accessible
-	 *    memory within the object.
-	 * 2. In slab_common.c to prevent merging of sanitized caches.
-	 */
-	*flags |= SLAB_KASAN;
-
-	if (kasan_requires_meta())
-		kasan_init_cache_meta(cache, size);
-}
-
 void __kasan_cache_create_kmalloc(struct kmem_cache *cache)
 {
 	cache->kasan_info.is_kmalloc = true;
--- a/mm/kasan/generic.c~kasan-only-define-kasan_cache_create-for-generic-mode
+++ a/mm/kasan/generic.c
@@ -352,11 +352,26 @@ static inline unsigned int optimal_redzo
 		object_size <= (1 << 16) - 1024 ? 1024 : 2048;
 }
 
-void kasan_init_cache_meta(struct kmem_cache *cache, unsigned int *size)
+void kasan_cache_create(struct kmem_cache *cache, unsigned int *size,
+			  slab_flags_t *flags)
 {
 	unsigned int ok_size;
 	unsigned int optimal_size;
 
+	if (!kasan_requires_meta())
+		return;
+
+	/*
+	 * SLAB_KASAN is used to mark caches that are sanitized by KASAN
+	 * and that thus have per-object metadata.
+	 * Currently this flag is used in two places:
+	 * 1. In slab_ksize() to account for per-object metadata when
+	 *    calculating the size of the accessible memory within the object.
+	 * 2. In slab_common.c via kasan_never_merge() to prevent merging of
+	 *    caches with per-object metadata.
+	 */
+	*flags |= SLAB_KASAN;
+
 	ok_size = *size;
 
 	/* Add alloc meta into redzone. */
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-fix-array-bounds-warnings-in-tests.patch

