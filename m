Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25EF0C433E6
	for <mm-commits@archiver.kernel.org>; Thu, 11 Mar 2021 22:45:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F0E5264F26
	for <mm-commits@archiver.kernel.org>; Thu, 11 Mar 2021 22:45:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229505AbhCKWpS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 11 Mar 2021 17:45:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:34482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229574AbhCKWpI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 11 Mar 2021 17:45:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 65B1664F26;
        Thu, 11 Mar 2021 22:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615502708;
        bh=vcI+NkFOm2hGRosoWVDEdbMg+4ltMeimDLnZmwpGVmE=;
        h=Date:From:To:Subject:From;
        b=AhBYPQrkw7zYBkii5bt1bT94Njko/rKcdETu7NkXgNHtAal0jOvQOurqpu/sOT3x5
         Q+/n5/m5P7OujnN8KCTgeRT1NmDJIDQN/nBpWUU61I6rbKBVXM2J6kxz0//5qxNrIM
         /EHfDeJdoN1zz6Rj29GkqkQLcPVU+UpKATjIriNc=
Date:   Thu, 11 Mar 2021 14:45:06 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, aryabinin@virtuozzo.com,
        Branislav.Rankov@arm.com, catalin.marinas@arm.com, cl@linux.com,
        dvyukov@google.com, elver@google.com, eugenis@google.com,
        glider@google.com, iamjoonsoo.kim@lge.com, kevin.brodsky@arm.com,
        mm-commits@vger.kernel.org, pcc@google.com, penberg@kernel.org,
        rientjes@google.com, vbabka@suse.cz, vincenzo.frascino@arm.com,
        will.deacon@arm.com
Subject:  + kasan-mm-integrate-page_alloc-init-with-hw_tags.patch
 added to -mm tree
Message-ID: <20210311224506.nmMaeUjxp%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan, mm: integrate page_alloc init with HW_TAGS
has been added to the -mm tree.  Its filename is
     kasan-mm-integrate-page_alloc-init-with-hw_tags.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-mm-integrate-page_alloc-init-with-hw_tags.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-mm-integrate-page_alloc-init-with-hw_tags.patch

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
Subject: kasan, mm: integrate page_alloc init with HW_TAGS

This change uses the previously added memory initialization feature of
HW_TAGS KASAN routines for page_alloc memory when init_on_alloc/free is
enabled.

With this change, kernel_init_free_pages() is no longer called when both
HW_TAGS KASAN and init_on_alloc/free are enabled.  Instead, memory is
initialized in KASAN runtime.

To avoid discrepancies with which memory gets initialized that can be
caused by future changes, both KASAN and kernel_init_free_pages() hooks
are put together and a warning comment is added.

This patch changes the order in which memory initialization and page
poisoning hooks are called.  This doesn't lead to any side-effects, as
whenever page poisoning is enabled, memory initialization gets disabled.

Combining setting allocation tags with memory initialization improves
HW_TAGS KASAN performance when init_on_alloc/free is enabled.

Link: https://lkml.kernel.org/r/e77f0d5b1b20658ef0b8288625c74c2b3690e725.1615296150.git.andreyknvl@google.com
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

 include/linux/kasan.h |   30 ++++++++++++++++++++++--------
 mm/kasan/common.c     |    8 ++++----
 mm/mempool.c          |    4 ++--
 mm/page_alloc.c       |   37 ++++++++++++++++++++++++++-----------
 4 files changed, 54 insertions(+), 25 deletions(-)

--- a/include/linux/kasan.h~kasan-mm-integrate-page_alloc-init-with-hw_tags
+++ a/include/linux/kasan.h
@@ -96,6 +96,11 @@ static __always_inline bool kasan_enable
 	return static_branch_likely(&kasan_flag_enabled);
 }
 
+static inline bool kasan_has_integrated_init(void)
+{
+	return kasan_enabled();
+}
+
 #else /* CONFIG_KASAN_HW_TAGS */
 
 static inline bool kasan_enabled(void)
@@ -103,6 +108,11 @@ static inline bool kasan_enabled(void)
 	return true;
 }
 
+static inline bool kasan_has_integrated_init(void)
+{
+	return false;
+}
+
 #endif /* CONFIG_KASAN_HW_TAGS */
 
 slab_flags_t __kasan_never_merge(void);
@@ -120,20 +130,20 @@ static __always_inline void kasan_unpois
 		__kasan_unpoison_range(addr, size);
 }
 
-void __kasan_alloc_pages(struct page *page, unsigned int order);
+void __kasan_alloc_pages(struct page *page, unsigned int order, bool init);
 static __always_inline void kasan_alloc_pages(struct page *page,
-						unsigned int order)
+						unsigned int order, bool init)
 {
 	if (kasan_enabled())
-		__kasan_alloc_pages(page, order);
+		__kasan_alloc_pages(page, order, init);
 }
 
-void __kasan_free_pages(struct page *page, unsigned int order);
+void __kasan_free_pages(struct page *page, unsigned int order, bool init);
 static __always_inline void kasan_free_pages(struct page *page,
-						unsigned int order)
+						unsigned int order, bool init)
 {
 	if (kasan_enabled())
-		__kasan_free_pages(page, order);
+		__kasan_free_pages(page, order, init);
 }
 
 void __kasan_cache_create(struct kmem_cache *cache, unsigned int *size,
@@ -277,13 +287,17 @@ static inline bool kasan_enabled(void)
 {
 	return false;
 }
+static inline bool kasan_has_integrated_init(void)
+{
+	return false;
+}
 static inline slab_flags_t kasan_never_merge(void)
 {
 	return 0;
 }
 static inline void kasan_unpoison_range(const void *address, size_t size) {}
-static inline void kasan_alloc_pages(struct page *page, unsigned int order) {}
-static inline void kasan_free_pages(struct page *page, unsigned int order) {}
+static inline void kasan_alloc_pages(struct page *page, unsigned int order, bool init) {}
+static inline void kasan_free_pages(struct page *page, unsigned int order, bool init) {}
 static inline void kasan_cache_create(struct kmem_cache *cache,
 				      unsigned int *size,
 				      slab_flags_t *flags) {}
--- a/mm/kasan/common.c~kasan-mm-integrate-page_alloc-init-with-hw_tags
+++ a/mm/kasan/common.c
@@ -97,7 +97,7 @@ slab_flags_t __kasan_never_merge(void)
 	return 0;
 }
 
-void __kasan_alloc_pages(struct page *page, unsigned int order)
+void __kasan_alloc_pages(struct page *page, unsigned int order, bool init)
 {
 	u8 tag;
 	unsigned long i;
@@ -108,14 +108,14 @@ void __kasan_alloc_pages(struct page *pa
 	tag = kasan_random_tag();
 	for (i = 0; i < (1 << order); i++)
 		page_kasan_tag_set(page + i, tag);
-	kasan_unpoison(page_address(page), PAGE_SIZE << order, false);
+	kasan_unpoison(page_address(page), PAGE_SIZE << order, init);
 }
 
-void __kasan_free_pages(struct page *page, unsigned int order)
+void __kasan_free_pages(struct page *page, unsigned int order, bool init)
 {
 	if (likely(!PageHighMem(page)))
 		kasan_poison(page_address(page), PAGE_SIZE << order,
-			     KASAN_FREE_PAGE, false);
+			     KASAN_FREE_PAGE, init);
 }
 
 /*
--- a/mm/mempool.c~kasan-mm-integrate-page_alloc-init-with-hw_tags
+++ a/mm/mempool.c
@@ -106,7 +106,7 @@ static __always_inline void kasan_poison
 	if (pool->alloc == mempool_alloc_slab || pool->alloc == mempool_kmalloc)
 		kasan_slab_free_mempool(element);
 	else if (pool->alloc == mempool_alloc_pages)
-		kasan_free_pages(element, (unsigned long)pool->pool_data);
+		kasan_free_pages(element, (unsigned long)pool->pool_data, false);
 }
 
 static void kasan_unpoison_element(mempool_t *pool, void *element)
@@ -114,7 +114,7 @@ static void kasan_unpoison_element(mempo
 	if (pool->alloc == mempool_alloc_slab || pool->alloc == mempool_kmalloc)
 		kasan_unpoison_range(element, __ksize(element));
 	else if (pool->alloc == mempool_alloc_pages)
-		kasan_alloc_pages(element, (unsigned long)pool->pool_data);
+		kasan_alloc_pages(element, (unsigned long)pool->pool_data, false);
 }
 
 static __always_inline void add_element(mempool_t *pool, void *element)
--- a/mm/page_alloc.c~kasan-mm-integrate-page_alloc-init-with-hw_tags
+++ a/mm/page_alloc.c
@@ -396,14 +396,14 @@ static DEFINE_STATIC_KEY_TRUE(deferred_p
  * initialization is done, but this is not likely to happen.
  */
 static inline void kasan_free_nondeferred_pages(struct page *page, int order,
-							fpi_t fpi_flags)
+						bool init, fpi_t fpi_flags)
 {
 	if (static_branch_unlikely(&deferred_pages))
 		return;
 	if (!IS_ENABLED(CONFIG_KASAN_GENERIC) &&
 			(fpi_flags & FPI_SKIP_KASAN_POISON))
 		return;
-	kasan_free_pages(page, order);
+	kasan_free_pages(page, order, init);
 }
 
 /* Returns true if the struct page for the pfn is uninitialised */
@@ -455,12 +455,12 @@ defer_init(int nid, unsigned long pfn, u
 }
 #else
 static inline void kasan_free_nondeferred_pages(struct page *page, int order,
-							fpi_t fpi_flags)
+						bool init, fpi_t fpi_flags)
 {
 	if (!IS_ENABLED(CONFIG_KASAN_GENERIC) &&
 			(fpi_flags & FPI_SKIP_KASAN_POISON))
 		return;
-	kasan_free_pages(page, order);
+	kasan_free_pages(page, order, init);
 }
 
 static inline bool early_page_uninitialised(unsigned long pfn)
@@ -1242,6 +1242,7 @@ static __always_inline bool free_pages_p
 			unsigned int order, bool check_free, fpi_t fpi_flags)
 {
 	int bad = 0;
+	bool init;
 
 	VM_BUG_ON_PAGE(PageTail(page), page);
 
@@ -1299,16 +1300,21 @@ static __always_inline bool free_pages_p
 		debug_check_no_obj_freed(page_address(page),
 					   PAGE_SIZE << order);
 	}
-	if (want_init_on_free())
-		kernel_init_free_pages(page, 1 << order);
 
 	kernel_poison_pages(page, 1 << order);
 
 	/*
+	 * As memory initialization might be integrated into KASAN,
+	 * kasan_free_pages and kernel_init_free_pages must be
+	 * kept together to avoid discrepancies in behavior.
+	 *
 	 * With hardware tag-based KASAN, memory tags must be set before the
 	 * page becomes unavailable via debug_pagealloc or arch_free_page.
 	 */
-	kasan_free_nondeferred_pages(page, order, fpi_flags);
+	init = want_init_on_free();
+	if (init && !kasan_has_integrated_init())
+		kernel_init_free_pages(page, 1 << order);
+	kasan_free_nondeferred_pages(page, order, init, fpi_flags);
 
 	/*
 	 * arch_free_page() can make the page's contents inaccessible.  s390
@@ -2315,17 +2321,26 @@ static bool check_new_pages(struct page
 inline void post_alloc_hook(struct page *page, unsigned int order,
 				gfp_t gfp_flags)
 {
+	bool init;
+
 	set_page_private(page, 0);
 	set_page_refcounted(page);
 
 	arch_alloc_page(page, order);
 	debug_pagealloc_map_pages(page, 1 << order);
-	kasan_alloc_pages(page, order);
-	kernel_unpoison_pages(page, 1 << order);
-	set_page_owner(page, order, gfp_flags);
 
-	if (!want_init_on_free() && want_init_on_alloc(gfp_flags))
+	/*
+	 * As memory initialization might be integrated into KASAN,
+	 * kasan_alloc_pages and kernel_init_free_pages must be
+	 * kept together to avoid discrepancies in behavior.
+	 */
+	init = !want_init_on_free() && want_init_on_alloc(gfp_flags);
+	kasan_alloc_pages(page, order, init);
+	if (init && !kasan_has_integrated_init())
 		kernel_init_free_pages(page, 1 << order);
+
+	kernel_unpoison_pages(page, 1 << order);
+	set_page_owner(page, order, gfp_flags);
 }
 
 static void prep_new_page(struct page *page, unsigned int order, gfp_t gfp_flags,
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

