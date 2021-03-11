Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44E76C433E9
	for <mm-commits@archiver.kernel.org>; Thu, 11 Mar 2021 22:45:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0CE0064F8F
	for <mm-commits@archiver.kernel.org>; Thu, 11 Mar 2021 22:45:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229441AbhCKWpS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 11 Mar 2021 17:45:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:34454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229517AbhCKWpD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 11 Mar 2021 17:45:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7F32064F88;
        Thu, 11 Mar 2021 22:45:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615502703;
        bh=ZOZfvD6XTZnnmNE6OkXhdE9Vz3PXg++UezOTCrgOPeQ=;
        h=Date:From:To:Subject:From;
        b=G/pMyHko8dqe5lcr/VNBWndnxNDZY4/rDSWgVAh8Nao9jUV1Y3NCvG02wwo6VWOlJ
         JI5JXe6Pzm33E4JXXagUUc0tHhYQRJ5nxcF2UOerOSD0AO3VWDQ72lpf75fCAHufOn
         GIjLnz1HKcqnff7MP5y+JQa/Kno7ECAOaI8NOP+E=
Date:   Thu, 11 Mar 2021 14:45:01 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, aryabinin@virtuozzo.com,
        Branislav.Rankov@arm.com, catalin.marinas@arm.com, cl@linux.com,
        dvyukov@google.com, elver@google.com, eugenis@google.com,
        glider@google.com, iamjoonsoo.kim@lge.com, kevin.brodsky@arm.com,
        mm-commits@vger.kernel.org, pcc@google.com, penberg@kernel.org,
        rientjes@google.com, vbabka@suse.cz, vincenzo.frascino@arm.com,
        will.deacon@arm.com
Subject:  + kasan-init-memory-in-kasan_unpoison-for-hw_tags.patch
 added to -mm tree
Message-ID: <20210311224501.THYMuuR4b%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: init memory in kasan_(un)poison for HW_TAGS
has been added to the -mm tree.  Its filename is
     kasan-init-memory-in-kasan_unpoison-for-hw_tags.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-init-memory-in-kasan_unpoison-for-hw_tags.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-init-memory-in-kasan_unpoison-for-hw_tags.patch

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
Subject: kasan: init memory in kasan_(un)poison for HW_TAGS

This change adds an argument to kasan_poison() and kasan_unpoison() that
allows initializing memory along with setting the tags for HW_TAGS.

Combining setting allocation tags with memory initialization will improve
HW_TAGS KASAN performance when init_on_alloc/free is enabled.

This change doesn't integrate memory initialization with KASAN, this is
done is subsequent patches in this series.

Link: https://lkml.kernel.org/r/3054314039fa64510947e674180d675cab1b4c41.1615296150.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Branislav Rankov <Branislav.Rankov@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Peter Collingbourne <pcc@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_kasan.c   |    4 ++--
 mm/kasan/common.c  |   28 ++++++++++++++--------------
 mm/kasan/generic.c |   12 ++++++------
 mm/kasan/kasan.h   |   14 ++++++++------
 mm/kasan/shadow.c  |   10 +++++-----
 mm/kasan/sw_tags.c |    2 +-
 6 files changed, 36 insertions(+), 34 deletions(-)

--- a/lib/test_kasan.c~kasan-init-memory-in-kasan_unpoison-for-hw_tags
+++ a/lib/test_kasan.c
@@ -1044,14 +1044,14 @@ static void match_all_mem_tag(struct kun
 			continue;
 
 		/* Mark the first memory granule with the chosen memory tag. */
-		kasan_poison(ptr, KASAN_GRANULE_SIZE, (u8)tag);
+		kasan_poison(ptr, KASAN_GRANULE_SIZE, (u8)tag, false);
 
 		/* This access must cause a KASAN report. */
 		KUNIT_EXPECT_KASAN_FAIL(test, *ptr = 0);
 	}
 
 	/* Recover the memory tag and free. */
-	kasan_poison(ptr, KASAN_GRANULE_SIZE, get_tag(ptr));
+	kasan_poison(ptr, KASAN_GRANULE_SIZE, get_tag(ptr), false);
 	kfree(ptr);
 }
 
--- a/mm/kasan/common.c~kasan-init-memory-in-kasan_unpoison-for-hw_tags
+++ a/mm/kasan/common.c
@@ -60,7 +60,7 @@ void kasan_disable_current(void)
 
 void __kasan_unpoison_range(const void *address, size_t size)
 {
-	kasan_unpoison(address, size);
+	kasan_unpoison(address, size, false);
 }
 
 #ifdef CONFIG_KASAN_STACK
@@ -69,7 +69,7 @@ void kasan_unpoison_task_stack(struct ta
 {
 	void *base = task_stack_page(task);
 
-	kasan_unpoison(base, THREAD_SIZE);
+	kasan_unpoison(base, THREAD_SIZE, false);
 }
 
 /* Unpoison the stack for the current task beyond a watermark sp value. */
@@ -82,7 +82,7 @@ asmlinkage void kasan_unpoison_task_stac
 	 */
 	void *base = (void *)((unsigned long)watermark & ~(THREAD_SIZE - 1));
 
-	kasan_unpoison(base, watermark - base);
+	kasan_unpoison(base, watermark - base, false);
 }
 #endif /* CONFIG_KASAN_STACK */
 
@@ -108,14 +108,14 @@ void __kasan_alloc_pages(struct page *pa
 	tag = kasan_random_tag();
 	for (i = 0; i < (1 << order); i++)
 		page_kasan_tag_set(page + i, tag);
-	kasan_unpoison(page_address(page), PAGE_SIZE << order);
+	kasan_unpoison(page_address(page), PAGE_SIZE << order, false);
 }
 
 void __kasan_free_pages(struct page *page, unsigned int order)
 {
 	if (likely(!PageHighMem(page)))
 		kasan_poison(page_address(page), PAGE_SIZE << order,
-			     KASAN_FREE_PAGE);
+			     KASAN_FREE_PAGE, false);
 }
 
 /*
@@ -251,18 +251,18 @@ void __kasan_poison_slab(struct page *pa
 	for (i = 0; i < compound_nr(page); i++)
 		page_kasan_tag_reset(page + i);
 	kasan_poison(page_address(page), page_size(page),
-		     KASAN_KMALLOC_REDZONE);
+		     KASAN_KMALLOC_REDZONE, false);
 }
 
 void __kasan_unpoison_object_data(struct kmem_cache *cache, void *object)
 {
-	kasan_unpoison(object, cache->object_size);
+	kasan_unpoison(object, cache->object_size, false);
 }
 
 void __kasan_poison_object_data(struct kmem_cache *cache, void *object)
 {
 	kasan_poison(object, round_up(cache->object_size, KASAN_GRANULE_SIZE),
-			KASAN_KMALLOC_REDZONE);
+			KASAN_KMALLOC_REDZONE, false);
 }
 
 /*
@@ -351,7 +351,7 @@ static inline bool ____kasan_slab_free(s
 	}
 
 	kasan_poison(object, round_up(cache->object_size, KASAN_GRANULE_SIZE),
-			KASAN_KMALLOC_FREE);
+			KASAN_KMALLOC_FREE, false);
 
 	if ((IS_ENABLED(CONFIG_KASAN_GENERIC) && !quarantine))
 		return false;
@@ -407,7 +407,7 @@ void __kasan_slab_free_mempool(void *ptr
 	if (unlikely(!PageSlab(page))) {
 		if (____kasan_kfree_large(ptr, ip))
 			return;
-		kasan_poison(ptr, page_size(page), KASAN_FREE_PAGE);
+		kasan_poison(ptr, page_size(page), KASAN_FREE_PAGE, false);
 	} else {
 		____kasan_slab_free(page->slab_cache, ptr, ip, false);
 	}
@@ -453,7 +453,7 @@ void * __must_check __kasan_slab_alloc(s
 	 * Unpoison the whole object.
 	 * For kmalloc() allocations, kasan_kmalloc() will do precise poisoning.
 	 */
-	kasan_unpoison(tagged_object, cache->object_size);
+	kasan_unpoison(tagged_object, cache->object_size, false);
 
 	/* Save alloc info (if possible) for non-kmalloc() allocations. */
 	if (kasan_stack_collection_enabled())
@@ -496,7 +496,7 @@ static inline void *____kasan_kmalloc(st
 	redzone_end = round_up((unsigned long)(object + cache->object_size),
 				KASAN_GRANULE_SIZE);
 	kasan_poison((void *)redzone_start, redzone_end - redzone_start,
-			   KASAN_KMALLOC_REDZONE);
+			   KASAN_KMALLOC_REDZONE, false);
 
 	/*
 	 * Save alloc info (if possible) for kmalloc() allocations.
@@ -546,7 +546,7 @@ void * __must_check __kasan_kmalloc_larg
 				KASAN_GRANULE_SIZE);
 	redzone_end = (unsigned long)ptr + page_size(virt_to_page(ptr));
 	kasan_poison((void *)redzone_start, redzone_end - redzone_start,
-		     KASAN_PAGE_REDZONE);
+		     KASAN_PAGE_REDZONE, false);
 
 	return (void *)ptr;
 }
@@ -563,7 +563,7 @@ void * __must_check __kasan_krealloc(con
 	 * Part of it might already have been unpoisoned, but it's unknown
 	 * how big that part is.
 	 */
-	kasan_unpoison(object, size);
+	kasan_unpoison(object, size, false);
 
 	page = virt_to_head_page(object);
 
--- a/mm/kasan/generic.c~kasan-init-memory-in-kasan_unpoison-for-hw_tags
+++ a/mm/kasan/generic.c
@@ -208,11 +208,11 @@ static void register_global(struct kasan
 {
 	size_t aligned_size = round_up(global->size, KASAN_GRANULE_SIZE);
 
-	kasan_unpoison(global->beg, global->size);
+	kasan_unpoison(global->beg, global->size, false);
 
 	kasan_poison(global->beg + aligned_size,
 		     global->size_with_redzone - aligned_size,
-		     KASAN_GLOBAL_REDZONE);
+		     KASAN_GLOBAL_REDZONE, false);
 }
 
 void __asan_register_globals(struct kasan_global *globals, size_t size)
@@ -292,11 +292,11 @@ void __asan_alloca_poison(unsigned long
 	WARN_ON(!IS_ALIGNED(addr, KASAN_ALLOCA_REDZONE_SIZE));
 
 	kasan_unpoison((const void *)(addr + rounded_down_size),
-			size - rounded_down_size);
+			size - rounded_down_size, false);
 	kasan_poison(left_redzone, KASAN_ALLOCA_REDZONE_SIZE,
-		     KASAN_ALLOCA_LEFT);
+		     KASAN_ALLOCA_LEFT, false);
 	kasan_poison(right_redzone, padding_size + KASAN_ALLOCA_REDZONE_SIZE,
-		     KASAN_ALLOCA_RIGHT);
+		     KASAN_ALLOCA_RIGHT, false);
 }
 EXPORT_SYMBOL(__asan_alloca_poison);
 
@@ -306,7 +306,7 @@ void __asan_allocas_unpoison(const void
 	if (unlikely(!stack_top || stack_top > stack_bottom))
 		return;
 
-	kasan_unpoison(stack_top, stack_bottom - stack_top);
+	kasan_unpoison(stack_top, stack_bottom - stack_top, false);
 }
 EXPORT_SYMBOL(__asan_allocas_unpoison);
 
--- a/mm/kasan/kasan.h~kasan-init-memory-in-kasan_unpoison-for-hw_tags
+++ a/mm/kasan/kasan.h
@@ -331,7 +331,7 @@ static inline u8 kasan_random_tag(void)
 
 #ifdef CONFIG_KASAN_HW_TAGS
 
-static inline void kasan_poison(const void *addr, size_t size, u8 value)
+static inline void kasan_poison(const void *addr, size_t size, u8 value, bool init)
 {
 	addr = kasan_reset_tag(addr);
 
@@ -344,10 +344,10 @@ static inline void kasan_poison(const vo
 	if (WARN_ON(size & KASAN_GRANULE_MASK))
 		return;
 
-	hw_set_mem_tag_range((void *)addr, size, value, false);
+	hw_set_mem_tag_range((void *)addr, size, value, init);
 }
 
-static inline void kasan_unpoison(const void *addr, size_t size)
+static inline void kasan_unpoison(const void *addr, size_t size, bool init)
 {
 	u8 tag = get_tag(addr);
 
@@ -361,7 +361,7 @@ static inline void kasan_unpoison(const
 		return;
 	size = round_up(size, KASAN_GRANULE_SIZE);
 
-	hw_set_mem_tag_range((void *)addr, size, tag, false);
+	hw_set_mem_tag_range((void *)addr, size, tag, init);
 }
 
 static inline bool kasan_byte_accessible(const void *addr)
@@ -380,22 +380,24 @@ static inline bool kasan_byte_accessible
  * @addr - range start address, must be aligned to KASAN_GRANULE_SIZE
  * @size - range size, must be aligned to KASAN_GRANULE_SIZE
  * @value - value that's written to metadata for the range
+ * @init - whether to initialize the memory range (only for hardware tag-based)
  *
  * The size gets aligned to KASAN_GRANULE_SIZE before marking the range.
  */
-void kasan_poison(const void *addr, size_t size, u8 value);
+void kasan_poison(const void *addr, size_t size, u8 value, bool init);
 
 /**
  * kasan_unpoison - mark the memory range as accessible
  * @addr - range start address, must be aligned to KASAN_GRANULE_SIZE
  * @size - range size, can be unaligned
+ * @init - whether to initialize the memory range (only for hardware tag-based)
  *
  * For the tag-based modes, the @size gets aligned to KASAN_GRANULE_SIZE before
  * marking the range.
  * For the generic mode, the last granule of the memory range gets partially
  * unpoisoned based on the @size.
  */
-void kasan_unpoison(const void *addr, size_t size);
+void kasan_unpoison(const void *addr, size_t size, bool init);
 
 bool kasan_byte_accessible(const void *addr);
 
--- a/mm/kasan/shadow.c~kasan-init-memory-in-kasan_unpoison-for-hw_tags
+++ a/mm/kasan/shadow.c
@@ -69,7 +69,7 @@ void *memcpy(void *dest, const void *src
 	return __memcpy(dest, src, len);
 }
 
-void kasan_poison(const void *addr, size_t size, u8 value)
+void kasan_poison(const void *addr, size_t size, u8 value, bool init)
 {
 	void *shadow_start, *shadow_end;
 
@@ -106,7 +106,7 @@ void kasan_poison_last_granule(const voi
 }
 #endif
 
-void kasan_unpoison(const void *addr, size_t size)
+void kasan_unpoison(const void *addr, size_t size, bool init)
 {
 	u8 tag = get_tag(addr);
 
@@ -129,7 +129,7 @@ void kasan_unpoison(const void *addr, si
 		return;
 
 	/* Unpoison all granules that cover the object. */
-	kasan_poison(addr, round_up(size, KASAN_GRANULE_SIZE), tag);
+	kasan_poison(addr, round_up(size, KASAN_GRANULE_SIZE), tag, false);
 
 	/* Partially poison the last granule for the generic mode. */
 	if (IS_ENABLED(CONFIG_KASAN_GENERIC))
@@ -344,7 +344,7 @@ void kasan_poison_vmalloc(const void *st
 		return;
 
 	size = round_up(size, KASAN_GRANULE_SIZE);
-	kasan_poison(start, size, KASAN_VMALLOC_INVALID);
+	kasan_poison(start, size, KASAN_VMALLOC_INVALID, false);
 }
 
 void kasan_unpoison_vmalloc(const void *start, unsigned long size)
@@ -352,7 +352,7 @@ void kasan_unpoison_vmalloc(const void *
 	if (!is_vmalloc_or_module_addr(start))
 		return;
 
-	kasan_unpoison(start, size);
+	kasan_unpoison(start, size, false);
 }
 
 static int kasan_depopulate_vmalloc_pte(pte_t *ptep, unsigned long addr,
--- a/mm/kasan/sw_tags.c~kasan-init-memory-in-kasan_unpoison-for-hw_tags
+++ a/mm/kasan/sw_tags.c
@@ -159,7 +159,7 @@ EXPORT_SYMBOL(__hwasan_storeN_noabort);
 
 void __hwasan_tag_memory(unsigned long addr, u8 tag, unsigned long size)
 {
-	kasan_poison((void *)addr, size, tag);
+	kasan_poison((void *)addr, size, tag, false);
 }
 EXPORT_SYMBOL(__hwasan_tag_memory);
 
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-mm-fix-crash-with-hw_tags-and-debug_pagealloc.patch
kasan-fix-kasan_stack-dependency-for-hw_tags.patch
kasan-fix-per-page-tags-for-non-page_alloc-pages.patch
kasan-initialize-shadow-to-tag_invalid-for-sw_tags.patch
mm-kasan-dont-poison-boot-memory-with-tag-based-modes.patch
arm64-kasan-allow-to-init-memory-when-setting-tags.patch
kasan-init-memory-in-kasan_unpoison-for-hw_tags.patch
kasan-mm-integrate-page_alloc-init-with-hw_tags.patch
kasan-mm-integrate-slab-init_on_alloc-with-hw_tags.patch
kasan-mm-integrate-slab-init_on_free-with-hw_tags.patch

