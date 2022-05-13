Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE5B9C433FE
	for <mm-commits@archiver.kernel.org>; Fri, 13 May 2022 19:25:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383919AbiEMTZP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 May 2022 15:25:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229958AbiEMTX2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 May 2022 15:23:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1FDB2DA86
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 12:22:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 654E060C14
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 19:22:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9D19C34113;
        Fri, 13 May 2022 19:22:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652469743;
        bh=nYULQkFQGp6JGFHGRV0ANEOrUKF3ld2JCZ1ReJXK7k4=;
        h=Date:To:From:Subject:From;
        b=B2ybFax3ZpO4kgwMEJBKdj16/z5Zpg+T/BBSSPuuqoxF/hRuCYPLP22nYcBAxpn0w
         2bFRd4Ld1GnC6M7+2YgGuD0Hs70mtEA/JYdNWnj6fyLraXj6dPQ/3qOR1F0XeRSky7
         tPcLxer4UbqWFh2vZH5WaeJeeqzyOLhebNW4+nsY=
Date:   Fri, 13 May 2022 12:22:23 -0700
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com,
        glider@google.com, elver@google.com, dvyukov@google.com,
        andreyknvl@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kasan-give-better-names-to-shadow-values.patch removed from -mm tree
Message-Id: <20220513192223.B9D19C34113@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kasan: give better names to shadow values
has been removed from the -mm tree.  Its filename was
     kasan-give-better-names-to-shadow-values.patch

This patch was dropped because it was merged into the mm-stable branch\nof git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: give better names to shadow values

Rename KASAN_KMALLOC_* shadow values to KASAN_SLAB_*, as they are used for
all slab allocations, not only for kmalloc.

Also rename KASAN_FREE_PAGE to KASAN_PAGE_FREE to be consistent with
KASAN_PAGE_REDZONE and KASAN_SLAB_FREE.

Link: https://lkml.kernel.org/r/bebcaf4eafdb0cabae0401a69c0af956aa87fcaa.1652111464.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/common.c         |   12 ++++++------
 mm/kasan/generic.c        |    6 +++---
 mm/kasan/kasan.h          |   14 +++++++-------
 mm/kasan/quarantine.c     |    2 +-
 mm/kasan/report_generic.c |    8 ++++----
 5 files changed, 21 insertions(+), 21 deletions(-)

--- a/mm/kasan/common.c~kasan-give-better-names-to-shadow-values
+++ a/mm/kasan/common.c
@@ -117,7 +117,7 @@ void __kasan_poison_pages(struct page *p
 {
 	if (likely(!PageHighMem(page)))
 		kasan_poison(page_address(page), PAGE_SIZE << order,
-			     KASAN_FREE_PAGE, init);
+			     KASAN_PAGE_FREE, init);
 }
 
 /*
@@ -254,7 +254,7 @@ void __kasan_poison_slab(struct slab *sl
 	for (i = 0; i < compound_nr(page); i++)
 		page_kasan_tag_reset(page + i);
 	kasan_poison(page_address(page), page_size(page),
-		     KASAN_KMALLOC_REDZONE, false);
+		     KASAN_SLAB_REDZONE, false);
 }
 
 void __kasan_unpoison_object_data(struct kmem_cache *cache, void *object)
@@ -265,7 +265,7 @@ void __kasan_unpoison_object_data(struct
 void __kasan_poison_object_data(struct kmem_cache *cache, void *object)
 {
 	kasan_poison(object, round_up(cache->object_size, KASAN_GRANULE_SIZE),
-			KASAN_KMALLOC_REDZONE, false);
+			KASAN_SLAB_REDZONE, false);
 }
 
 /*
@@ -357,7 +357,7 @@ static inline bool ____kasan_slab_free(s
 	}
 
 	kasan_poison(object, round_up(cache->object_size, KASAN_GRANULE_SIZE),
-			KASAN_KMALLOC_FREE, init);
+			KASAN_SLAB_FREE, init);
 
 	if ((IS_ENABLED(CONFIG_KASAN_GENERIC) && !quarantine))
 		return false;
@@ -414,7 +414,7 @@ void __kasan_slab_free_mempool(void *ptr
 	if (unlikely(!folio_test_slab(folio))) {
 		if (____kasan_kfree_large(ptr, ip))
 			return;
-		kasan_poison(ptr, folio_size(folio), KASAN_FREE_PAGE, false);
+		kasan_poison(ptr, folio_size(folio), KASAN_PAGE_FREE, false);
 	} else {
 		struct slab *slab = folio_slab(folio);
 
@@ -505,7 +505,7 @@ static inline void *____kasan_kmalloc(st
 	redzone_end = round_up((unsigned long)(object + cache->object_size),
 				KASAN_GRANULE_SIZE);
 	kasan_poison((void *)redzone_start, redzone_end - redzone_start,
-			   KASAN_KMALLOC_REDZONE, false);
+			   KASAN_SLAB_REDZONE, false);
 
 	/*
 	 * Save alloc info (if possible) for kmalloc() allocations.
--- a/mm/kasan/generic.c~kasan-give-better-names-to-shadow-values
+++ a/mm/kasan/generic.c
@@ -369,14 +369,14 @@ void kasan_set_free_info(struct kmem_cac
 
 	kasan_set_track(&free_meta->free_track, GFP_NOWAIT);
 	/* The object was freed and has free track set. */
-	*(u8 *)kasan_mem_to_shadow(object) = KASAN_KMALLOC_FREETRACK;
+	*(u8 *)kasan_mem_to_shadow(object) = KASAN_SLAB_FREETRACK;
 }
 
 struct kasan_track *kasan_get_free_track(struct kmem_cache *cache,
 				void *object, u8 tag)
 {
-	if (*(u8 *)kasan_mem_to_shadow(object) != KASAN_KMALLOC_FREETRACK)
+	if (*(u8 *)kasan_mem_to_shadow(object) != KASAN_SLAB_FREETRACK)
 		return NULL;
-	/* Free meta must be present with KASAN_KMALLOC_FREETRACK. */
+	/* Free meta must be present with KASAN_SLAB_FREETRACK. */
 	return &kasan_get_free_meta(cache, object)->free_track;
 }
--- a/mm/kasan/kasan.h~kasan-give-better-names-to-shadow-values
+++ a/mm/kasan/kasan.h
@@ -74,22 +74,22 @@ static inline bool kasan_sync_fault_poss
 #define KASAN_MEMORY_PER_SHADOW_PAGE	(KASAN_GRANULE_SIZE << PAGE_SHIFT)
 
 #ifdef CONFIG_KASAN_GENERIC
-#define KASAN_FREE_PAGE		0xFF  /* freed page */
+#define KASAN_PAGE_FREE		0xFF  /* freed page */
 #define KASAN_PAGE_REDZONE	0xFE  /* redzone for kmalloc_large allocation */
-#define KASAN_KMALLOC_REDZONE	0xFC  /* redzone for slab object */
-#define KASAN_KMALLOC_FREE	0xFB  /* freed slab object */
+#define KASAN_SLAB_REDZONE	0xFC  /* redzone for slab object */
+#define KASAN_SLAB_FREE		0xFB  /* freed slab object */
 #define KASAN_VMALLOC_INVALID	0xF8  /* inaccessible space in vmap area */
 #else
-#define KASAN_FREE_PAGE		KASAN_TAG_INVALID
+#define KASAN_PAGE_FREE		KASAN_TAG_INVALID
 #define KASAN_PAGE_REDZONE	KASAN_TAG_INVALID
-#define KASAN_KMALLOC_REDZONE	KASAN_TAG_INVALID
-#define KASAN_KMALLOC_FREE	KASAN_TAG_INVALID
+#define KASAN_SLAB_REDZONE	KASAN_TAG_INVALID
+#define KASAN_SLAB_FREE		KASAN_TAG_INVALID
 #define KASAN_VMALLOC_INVALID	KASAN_TAG_INVALID /* only used for SW_TAGS */
 #endif
 
 #ifdef CONFIG_KASAN_GENERIC
 
-#define KASAN_KMALLOC_FREETRACK	0xFA  /* freed slab object with free track */
+#define KASAN_SLAB_FREETRACK	0xFA  /* freed slab object with free track */
 #define KASAN_GLOBAL_REDZONE	0xF9  /* redzone for global variable */
 
 /* Stack redzone shadow values. Compiler ABI, do not change. */
--- a/mm/kasan/quarantine.c~kasan-give-better-names-to-shadow-values
+++ a/mm/kasan/quarantine.c
@@ -163,7 +163,7 @@ static void qlink_free(struct qlist_node
 	 * As the object now gets freed from the quarantine, assume that its
 	 * free track is no longer valid.
 	 */
-	*(u8 *)kasan_mem_to_shadow(object) = KASAN_KMALLOC_FREE;
+	*(u8 *)kasan_mem_to_shadow(object) = KASAN_SLAB_FREE;
 
 	___cache_free(cache, object, _THIS_IP_);
 
--- a/mm/kasan/report_generic.c~kasan-give-better-names-to-shadow-values
+++ a/mm/kasan/report_generic.c
@@ -66,7 +66,7 @@ static const char *get_shadow_bug_type(s
 		bug_type = "out-of-bounds";
 		break;
 	case KASAN_PAGE_REDZONE:
-	case KASAN_KMALLOC_REDZONE:
+	case KASAN_SLAB_REDZONE:
 		bug_type = "slab-out-of-bounds";
 		break;
 	case KASAN_GLOBAL_REDZONE:
@@ -78,9 +78,9 @@ static const char *get_shadow_bug_type(s
 	case KASAN_STACK_PARTIAL:
 		bug_type = "stack-out-of-bounds";
 		break;
-	case KASAN_FREE_PAGE:
-	case KASAN_KMALLOC_FREE:
-	case KASAN_KMALLOC_FREETRACK:
+	case KASAN_PAGE_FREE:
+	case KASAN_SLAB_FREE:
+	case KASAN_SLAB_FREETRACK:
 		bug_type = "use-after-free";
 		break;
 	case KASAN_ALLOCA_LEFT:
_

Patches currently in -mm which might be from andreyknvl@google.com are


