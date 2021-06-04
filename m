Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31306C47097
	for <mm-commits@archiver.kernel.org>; Fri,  4 Jun 2021 03:03:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1572C6140A
	for <mm-commits@archiver.kernel.org>; Fri,  4 Jun 2021 03:03:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbhFDDFS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 3 Jun 2021 23:05:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:49622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229794AbhFDDFR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 3 Jun 2021 23:05:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DD33061407;
        Fri,  4 Jun 2021 03:03:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1622775799;
        bh=KRYZlw/iRx0qrYCiMswHlarCd1c5uHvUpPLGwRELHiY=;
        h=Date:From:To:Subject:From;
        b=ToEAqdji7aABWOlRZh7xZKDGd3kNE7nOZb1dH1fVfNL7oLJqHRrXkt9Hfoz22HJYB
         FBucsL2p//PzdEE8yMVWGU5Qy2B5cnFxk+KSvFslMDa9+Jp5WSvsRVskWJwJWwlqhu
         l6LU0FYxYpDYweVqZTWMLtD+OyMLLPjECUKBaaj0=
Date:   Thu, 03 Jun 2021 20:03:18 -0700
From:   akpm@linux-foundation.org
To:     andreyknvl@gmail.com, catalin.marinas@arm.com, eugenis@google.com,
        glider@google.com, jannh@google.com, mm-commits@vger.kernel.org,
        pcc@google.com, vincenzo.frascino@arm.com
Subject:  +
 kasan-use-separate-unpoison-implementation-for-integrated-init.patch added
 to -mm tree
Message-ID: <20210604030318.uBOgtBB2C%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: use separate (un)poison implementation for integrated init
has been added to the -mm tree.  Its filename is
     kasan-use-separate-unpoison-implementation-for-integrated-init.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-use-separate-unpoison-implementation-for-integrated-init.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-use-separate-unpoison-implementation-for-integrated-init.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Peter Collingbourne <pcc@google.com>
Subject: kasan: use separate (un)poison implementation for integrated init

Currently with integrated init page_alloc.c needs to know whether
kasan_alloc_pages() will zero initialize memory, but this will start
becoming more complicated once we start adding tag initialization support
for user pages.  To avoid page_alloc.c needing to know more details of
what integrated init will do, move the unpoisoning logic for integrated
init into the HW tags implementation.  Currently the logic is identical
but it will diverge in subsequent patches.

For symmetry do the same for poisoning although this logic will be
unaffected by subsequent patches.

Link: https://linux-review.googlesource.com/id/I2c550234c6c4a893c48c18ff0c6ce658c7c67056
Link: https://lkml.kernel.org/r/20210602235230.3928842-3-pcc@google.com
Signed-off-by: Peter Collingbourne <pcc@google.com>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kasan.h |   64 +++++++++++++++++++++++-----------------
 mm/kasan/common.c     |    4 +-
 mm/kasan/hw_tags.c    |   22 +++++++++++++
 mm/mempool.c          |    6 ++-
 mm/page_alloc.c       |   55 ++++++++++++++++++----------------
 5 files changed, 95 insertions(+), 56 deletions(-)

--- a/include/linux/kasan.h~kasan-use-separate-unpoison-implementation-for-integrated-init
+++ a/include/linux/kasan.h
@@ -2,6 +2,7 @@
 #ifndef _LINUX_KASAN_H
 #define _LINUX_KASAN_H
 
+#include <linux/bug.h>
 #include <linux/static_key.h>
 #include <linux/types.h>
 
@@ -79,14 +80,6 @@ static inline void kasan_disable_current
 
 #endif /* CONFIG_KASAN_GENERIC || CONFIG_KASAN_SW_TAGS */
 
-#ifdef CONFIG_KASAN
-
-struct kasan_cache {
-	int alloc_meta_offset;
-	int free_meta_offset;
-	bool is_kmalloc;
-};
-
 #ifdef CONFIG_KASAN_HW_TAGS
 
 DECLARE_STATIC_KEY_FALSE(kasan_flag_enabled);
@@ -101,11 +94,14 @@ static inline bool kasan_has_integrated_
 	return kasan_enabled();
 }
 
+void kasan_alloc_pages(struct page *page, unsigned int order, gfp_t flags);
+void kasan_free_pages(struct page *page, unsigned int order);
+
 #else /* CONFIG_KASAN_HW_TAGS */
 
 static inline bool kasan_enabled(void)
 {
-	return true;
+	return IS_ENABLED(CONFIG_KASAN);
 }
 
 static inline bool kasan_has_integrated_init(void)
@@ -113,8 +109,30 @@ static inline bool kasan_has_integrated_
 	return false;
 }
 
+static __always_inline void kasan_alloc_pages(struct page *page,
+					      unsigned int order, gfp_t flags)
+{
+	/* Only available for integrated init. */
+	BUILD_BUG();
+}
+
+static __always_inline void kasan_free_pages(struct page *page,
+					     unsigned int order)
+{
+	/* Only available for integrated init. */
+	BUILD_BUG();
+}
+
 #endif /* CONFIG_KASAN_HW_TAGS */
 
+#ifdef CONFIG_KASAN
+
+struct kasan_cache {
+	int alloc_meta_offset;
+	int free_meta_offset;
+	bool is_kmalloc;
+};
+
 slab_flags_t __kasan_never_merge(void);
 static __always_inline slab_flags_t kasan_never_merge(void)
 {
@@ -130,20 +148,20 @@ static __always_inline void kasan_unpois
 		__kasan_unpoison_range(addr, size);
 }
 
-void __kasan_alloc_pages(struct page *page, unsigned int order, bool init);
-static __always_inline void kasan_alloc_pages(struct page *page,
+void __kasan_poison_pages(struct page *page, unsigned int order, bool init);
+static __always_inline void kasan_poison_pages(struct page *page,
 						unsigned int order, bool init)
 {
 	if (kasan_enabled())
-		__kasan_alloc_pages(page, order, init);
+		__kasan_poison_pages(page, order, init);
 }
 
-void __kasan_free_pages(struct page *page, unsigned int order, bool init);
-static __always_inline void kasan_free_pages(struct page *page,
-						unsigned int order, bool init)
+void __kasan_unpoison_pages(struct page *page, unsigned int order, bool init);
+static __always_inline void kasan_unpoison_pages(struct page *page,
+						 unsigned int order, bool init)
 {
 	if (kasan_enabled())
-		__kasan_free_pages(page, order, init);
+		__kasan_unpoison_pages(page, order, init);
 }
 
 void __kasan_cache_create(struct kmem_cache *cache, unsigned int *size,
@@ -285,21 +303,15 @@ void kasan_restore_multi_shot(bool enabl
 
 #else /* CONFIG_KASAN */
 
-static inline bool kasan_enabled(void)
-{
-	return false;
-}
-static inline bool kasan_has_integrated_init(void)
-{
-	return false;
-}
 static inline slab_flags_t kasan_never_merge(void)
 {
 	return 0;
 }
 static inline void kasan_unpoison_range(const void *address, size_t size) {}
-static inline void kasan_alloc_pages(struct page *page, unsigned int order, bool init) {}
-static inline void kasan_free_pages(struct page *page, unsigned int order, bool init) {}
+static inline void kasan_poison_pages(struct page *page, unsigned int order,
+				      bool init) {}
+static inline void kasan_unpoison_pages(struct page *page, unsigned int order,
+					bool init) {}
 static inline void kasan_cache_create(struct kmem_cache *cache,
 				      unsigned int *size,
 				      slab_flags_t *flags) {}
--- a/mm/kasan/common.c~kasan-use-separate-unpoison-implementation-for-integrated-init
+++ a/mm/kasan/common.c
@@ -100,7 +100,7 @@ slab_flags_t __kasan_never_merge(void)
 	return 0;
 }
 
-void __kasan_alloc_pages(struct page *page, unsigned int order, bool init)
+void __kasan_unpoison_pages(struct page *page, unsigned int order, bool init)
 {
 	u8 tag;
 	unsigned long i;
@@ -114,7 +114,7 @@ void __kasan_alloc_pages(struct page *pa
 	kasan_unpoison(page_address(page), PAGE_SIZE << order, init);
 }
 
-void __kasan_free_pages(struct page *page, unsigned int order, bool init)
+void __kasan_poison_pages(struct page *page, unsigned int order, bool init)
 {
 	if (likely(!PageHighMem(page)))
 		kasan_poison(page_address(page), PAGE_SIZE << order,
--- a/mm/kasan/hw_tags.c~kasan-use-separate-unpoison-implementation-for-integrated-init
+++ a/mm/kasan/hw_tags.c
@@ -238,6 +238,28 @@ struct kasan_track *kasan_get_free_track
 	return &alloc_meta->free_track[0];
 }
 
+void kasan_alloc_pages(struct page *page, unsigned int order, gfp_t flags)
+{
+	/*
+	 * This condition should match the one in post_alloc_hook() in
+	 * page_alloc.c.
+	 */
+	bool init = !want_init_on_free() && want_init_on_alloc(flags);
+
+	kasan_unpoison_pages(page, order, init);
+}
+
+void kasan_free_pages(struct page *page, unsigned int order)
+{
+	/*
+	 * This condition should match the one in free_pages_prepare() in
+	 * page_alloc.c.
+	 */
+	bool init = want_init_on_free();
+
+	kasan_poison_pages(page, order, init);
+}
+
 #if IS_ENABLED(CONFIG_KASAN_KUNIT_TEST)
 
 void kasan_set_tagging_report_once(bool state)
--- a/mm/mempool.c~kasan-use-separate-unpoison-implementation-for-integrated-init
+++ a/mm/mempool.c
@@ -106,7 +106,8 @@ static __always_inline void kasan_poison
 	if (pool->alloc == mempool_alloc_slab || pool->alloc == mempool_kmalloc)
 		kasan_slab_free_mempool(element);
 	else if (pool->alloc == mempool_alloc_pages)
-		kasan_free_pages(element, (unsigned long)pool->pool_data, false);
+		kasan_poison_pages(element, (unsigned long)pool->pool_data,
+				   false);
 }
 
 static void kasan_unpoison_element(mempool_t *pool, void *element)
@@ -114,7 +115,8 @@ static void kasan_unpoison_element(mempo
 	if (pool->alloc == mempool_alloc_slab || pool->alloc == mempool_kmalloc)
 		kasan_unpoison_range(element, __ksize(element));
 	else if (pool->alloc == mempool_alloc_pages)
-		kasan_alloc_pages(element, (unsigned long)pool->pool_data, false);
+		kasan_unpoison_pages(element, (unsigned long)pool->pool_data,
+				     false);
 }
 
 static __always_inline void add_element(mempool_t *pool, void *element)
--- a/mm/page_alloc.c~kasan-use-separate-unpoison-implementation-for-integrated-init
+++ a/mm/page_alloc.c
@@ -400,7 +400,7 @@ int page_group_by_mobility_disabled __re
 static DEFINE_STATIC_KEY_TRUE(deferred_pages);
 
 /*
- * Calling kasan_free_pages() only after deferred memory initialization
+ * Calling kasan_poison_pages() only after deferred memory initialization
  * has completed. Poisoning pages during deferred memory init will greatly
  * lengthen the process and cause problem in large memory systems as the
  * deferred pages initialization is done with interrupt disabled.
@@ -412,15 +412,11 @@ static DEFINE_STATIC_KEY_TRUE(deferred_p
  * on-demand allocation and then freed again before the deferred pages
  * initialization is done, but this is not likely to happen.
  */
-static inline void kasan_free_nondeferred_pages(struct page *page, int order,
-						bool init, fpi_t fpi_flags)
+static inline bool should_skip_kasan_poison(fpi_t fpi_flags)
 {
-	if (static_branch_unlikely(&deferred_pages))
-		return;
-	if (!IS_ENABLED(CONFIG_KASAN_GENERIC) &&
-			(fpi_flags & FPI_SKIP_KASAN_POISON))
-		return;
-	kasan_free_pages(page, order, init);
+	return static_branch_unlikely(&deferred_pages) ||
+	       (!IS_ENABLED(CONFIG_KASAN_GENERIC) &&
+		(fpi_flags & FPI_SKIP_KASAN_POISON));
 }
 
 /* Returns true if the struct page for the pfn is uninitialised */
@@ -471,13 +467,10 @@ defer_init(int nid, unsigned long pfn, u
 	return false;
 }
 #else
-static inline void kasan_free_nondeferred_pages(struct page *page, int order,
-						bool init, fpi_t fpi_flags)
+static inline bool should_skip_kasan_poison(fpi_t fpi_flags)
 {
-	if (!IS_ENABLED(CONFIG_KASAN_GENERIC) &&
-			(fpi_flags & FPI_SKIP_KASAN_POISON))
-		return;
-	kasan_free_pages(page, order, init);
+	return (!IS_ENABLED(CONFIG_KASAN_GENERIC) &&
+		(fpi_flags & FPI_SKIP_KASAN_POISON));
 }
 
 static inline bool early_page_uninitialised(unsigned long pfn)
@@ -1314,7 +1307,7 @@ static __always_inline bool free_pages_p
 			unsigned int order, bool check_free, fpi_t fpi_flags)
 {
 	int bad = 0;
-	bool init;
+	bool skip_kasan_poison = should_skip_kasan_poison(fpi_flags);
 
 	VM_BUG_ON_PAGE(PageTail(page), page);
 
@@ -1383,10 +1376,17 @@ static __always_inline bool free_pages_p
 	 * With hardware tag-based KASAN, memory tags must be set before the
 	 * page becomes unavailable via debug_pagealloc or arch_free_page.
 	 */
-	init = want_init_on_free();
-	if (init && !kasan_has_integrated_init())
-		kernel_init_free_pages(page, 1 << order);
-	kasan_free_nondeferred_pages(page, order, init, fpi_flags);
+	if (kasan_has_integrated_init()) {
+		if (!skip_kasan_poison)
+			kasan_free_pages(page, order);
+	} else {
+		bool init = want_init_on_free();
+
+		if (init)
+			kernel_init_free_pages(page, 1 << order);
+		if (!skip_kasan_poison)
+			kasan_poison_pages(page, order, init);
+	}
 
 	/*
 	 * arch_free_page() can make the page's contents inaccessible.  s390
@@ -2412,8 +2412,6 @@ static bool check_new_pages(struct page
 inline void post_alloc_hook(struct page *page, unsigned int order,
 				gfp_t gfp_flags)
 {
-	bool init;
-
 	set_page_private(page, 0);
 	set_page_refcounted(page);
 
@@ -2432,10 +2430,15 @@ inline void post_alloc_hook(struct page
 	 * kasan_alloc_pages and kernel_init_free_pages must be
 	 * kept together to avoid discrepancies in behavior.
 	 */
-	init = !want_init_on_free() && want_init_on_alloc(gfp_flags);
-	kasan_alloc_pages(page, order, init);
-	if (init && !kasan_has_integrated_init())
-		kernel_init_free_pages(page, 1 << order);
+	if (kasan_has_integrated_init()) {
+		kasan_alloc_pages(page, order, gfp_flags);
+	} else {
+		bool init = !want_init_on_free() && want_init_on_alloc(gfp_flags);
+
+		kasan_unpoison_pages(page, order, init);
+		if (init)
+			kernel_init_free_pages(page, 1 << order);
+	}
 
 	set_page_owner(page, order, gfp_flags);
 }
_

Patches currently in -mm which might be from pcc@google.com are

mm-improve-mprotectrw-efficiency-on-pages-referenced-once.patch
mm-improve-mprotectrw-efficiency-on-pages-referenced-once-v5.patch
mm-arch-remove-indirection-level-in-alloc_zeroed_user_highpage_movable.patch
kasan-use-separate-unpoison-implementation-for-integrated-init.patch
arm64-mte-handle-tags-zeroing-at-page-allocation-time.patch
kasan-disable-freed-user-page-poisoning-with-hw-tags.patch

