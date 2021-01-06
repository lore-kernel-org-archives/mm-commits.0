Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E2A8C433E0
	for <mm-commits@archiver.kernel.org>; Wed,  6 Jan 2021 00:11:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3720522D74
	for <mm-commits@archiver.kernel.org>; Wed,  6 Jan 2021 00:11:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725808AbhAFALf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 5 Jan 2021 19:11:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:43902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725778AbhAFALf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 5 Jan 2021 19:11:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7875C22D74;
        Wed,  6 Jan 2021 00:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1609891853;
        bh=8OPbv3iBC0ct5czsceEret0nbKvK9jt3vlkh2c89/2I=;
        h=Date:From:To:Subject:From;
        b=Wuk/EEF6FEnB8dK7MmVV0ildgwX+HGIuMtcUZC5Bq/P+/Y6Q9yLfhJRfpvLUsbqQY
         Y3GH/w7luDZVSstIxW541g96S0DdBWD4YtkSKp74MvWeIlS5ADuHByY0hQwVR5X0+m
         RAUjvexBRqgxHU95BA52p176RlPOExTb9wVtajIM=
Date:   Tue, 05 Jan 2021 16:10:51 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, aryabinin@virtuozzo.com,
        Branislav.Rankov@arm.com, catalin.marinas@arm.com,
        dvyukov@google.com, elver@google.com, eugenis@google.com,
        glider@google.com, kevin.brodsky@arm.com,
        mm-commits@vger.kernel.org, vincenzo.frascino@arm.com,
        will.deacon@arm.com
Subject:  + kasan-prefix-exported-functions-with-kasan_.patch added
 to -mm tree
Message-ID: <20210106001051.sK5WVd4iL%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: prefix exported functions with kasan_
has been added to the -mm tree.  Its filename is
     kasan-prefix-exported-functions-with-kasan_.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-prefix-exported-functions-with-kasan_.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-prefix-exported-functions-with-kasan_.patch

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
Subject: kasan: prefix exported functions with kasan_

Patch series "kasan: HW_TAGS tests support and fixes".

This patchset adds support for running KASAN-KUnit tests with the
hardware tag-based mode and also contains a few fixes.


This patch (of 11):

There's a number of internal KASAN functions that are used across multiple
source code files and therefore aren't marked as static inline.  To avoid
littering the kernel function names list with generic functions, prefix
all such KASAN functions with kasan_.

As a part of this change:

- Rename internal (un)poison_range() to kasan_(un)poison() (no _range)
  to avoid name collision with a public kasan_unpoison_range().

- Rename check_memory_region() to kasan_check_range(), as it seems to be
  a more fitting name.

Link: https://lkml.kernel.org/r/cover.1609871239.git.andreyknvl@google.com
Link: https://lkml.kernel.org/r/ec89a6eef2254602f5134d676242c0da43fb4caa.1609871239.git.andreyknvl@google.com
Link: https://linux-review.googlesource.com/id/I719cc93483d4ba288a634dba80ee6b7f2809cd26
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Suggested-by: Marco Elver <elver@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Branislav Rankov <Branislav.Rankov@arm.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/common.c         |   47 +++++++++++++++++------------------
 mm/kasan/generic.c        |   36 +++++++++++++--------------
 mm/kasan/kasan.h          |   48 ++++++++++++++++++------------------
 mm/kasan/quarantine.c     |   22 ++++++++--------
 mm/kasan/report.c         |   13 +++++----
 mm/kasan/report_generic.c |    8 +++---
 mm/kasan/report_hw_tags.c |    8 +++---
 mm/kasan/report_sw_tags.c |    8 +++---
 mm/kasan/shadow.c         |   26 +++++++++----------
 mm/kasan/sw_tags.c        |   16 ++++++------
 tools/objtool/check.c     |    2 -
 11 files changed, 117 insertions(+), 117 deletions(-)

--- a/mm/kasan/common.c~kasan-prefix-exported-functions-with-kasan_
+++ a/mm/kasan/common.c
@@ -60,7 +60,7 @@ void kasan_disable_current(void)
 
 void __kasan_unpoison_range(const void *address, size_t size)
 {
-	unpoison_range(address, size);
+	kasan_unpoison(address, size);
 }
 
 #if CONFIG_KASAN_STACK
@@ -69,7 +69,7 @@ void kasan_unpoison_task_stack(struct ta
 {
 	void *base = task_stack_page(task);
 
-	unpoison_range(base, THREAD_SIZE);
+	kasan_unpoison(base, THREAD_SIZE);
 }
 
 /* Unpoison the stack for the current task beyond a watermark sp value. */
@@ -82,7 +82,7 @@ asmlinkage void kasan_unpoison_task_stac
 	 */
 	void *base = (void *)((unsigned long)watermark & ~(THREAD_SIZE - 1));
 
-	unpoison_range(base, watermark - base);
+	kasan_unpoison(base, watermark - base);
 }
 #endif /* CONFIG_KASAN_STACK */
 
@@ -105,18 +105,17 @@ void __kasan_alloc_pages(struct page *pa
 	if (unlikely(PageHighMem(page)))
 		return;
 
-	tag = random_tag();
+	tag = kasan_random_tag();
 	for (i = 0; i < (1 << order); i++)
 		page_kasan_tag_set(page + i, tag);
-	unpoison_range(page_address(page), PAGE_SIZE << order);
+	kasan_unpoison(page_address(page), PAGE_SIZE << order);
 }
 
 void __kasan_free_pages(struct page *page, unsigned int order)
 {
 	if (likely(!PageHighMem(page)))
-		poison_range(page_address(page),
-				PAGE_SIZE << order,
-				KASAN_FREE_PAGE);
+		kasan_poison(page_address(page), PAGE_SIZE << order,
+			     KASAN_FREE_PAGE);
 }
 
 /*
@@ -246,18 +245,18 @@ void __kasan_poison_slab(struct page *pa
 
 	for (i = 0; i < compound_nr(page); i++)
 		page_kasan_tag_reset(page + i);
-	poison_range(page_address(page), page_size(page),
+	kasan_poison(page_address(page), page_size(page),
 		     KASAN_KMALLOC_REDZONE);
 }
 
 void __kasan_unpoison_object_data(struct kmem_cache *cache, void *object)
 {
-	unpoison_range(object, cache->object_size);
+	kasan_unpoison(object, cache->object_size);
 }
 
 void __kasan_poison_object_data(struct kmem_cache *cache, void *object)
 {
-	poison_range(object, cache->object_size, KASAN_KMALLOC_REDZONE);
+	kasan_poison(object, cache->object_size, KASAN_KMALLOC_REDZONE);
 }
 
 /*
@@ -294,7 +293,7 @@ static u8 assign_tag(struct kmem_cache *
 	 * set, assign a tag when the object is being allocated (init == false).
 	 */
 	if (!cache->ctor && !(cache->flags & SLAB_TYPESAFE_BY_RCU))
-		return init ? KASAN_TAG_KERNEL : random_tag();
+		return init ? KASAN_TAG_KERNEL : kasan_random_tag();
 
 	/* For caches that either have a constructor or SLAB_TYPESAFE_BY_RCU: */
 #ifdef CONFIG_SLAB
@@ -305,7 +304,7 @@ static u8 assign_tag(struct kmem_cache *
 	 * For SLUB assign a random tag during slab creation, otherwise reuse
 	 * the already assigned tag.
 	 */
-	return init ? random_tag() : get_tag(object);
+	return init ? kasan_random_tag() : get_tag(object);
 #endif
 }
 
@@ -346,12 +345,12 @@ static bool ____kasan_slab_free(struct k
 	if (unlikely(cache->flags & SLAB_TYPESAFE_BY_RCU))
 		return false;
 
-	if (check_invalid_free(tagged_object)) {
+	if (kasan_check_invalid_free(tagged_object)) {
 		kasan_report_invalid_free(tagged_object, ip);
 		return true;
 	}
 
-	poison_range(object, cache->object_size, KASAN_KMALLOC_FREE);
+	kasan_poison(object, cache->object_size, KASAN_KMALLOC_FREE);
 
 	if (!kasan_stack_collection_enabled())
 		return false;
@@ -361,7 +360,7 @@ static bool ____kasan_slab_free(struct k
 
 	kasan_set_free_info(cache, object, tag);
 
-	return quarantine_put(cache, object);
+	return kasan_quarantine_put(cache, object);
 }
 
 bool __kasan_slab_free(struct kmem_cache *cache, void *object, unsigned long ip)
@@ -386,7 +385,7 @@ void __kasan_slab_free_mempool(void *ptr
 			kasan_report_invalid_free(ptr, ip);
 			return;
 		}
-		poison_range(ptr, page_size(page), KASAN_FREE_PAGE);
+		kasan_poison(ptr, page_size(page), KASAN_FREE_PAGE);
 	} else {
 		____kasan_slab_free(page->slab_cache, ptr, ip, false);
 	}
@@ -409,7 +408,7 @@ static void *____kasan_kmalloc(struct km
 	u8 tag;
 
 	if (gfpflags_allow_blocking(flags))
-		quarantine_reduce();
+		kasan_quarantine_reduce();
 
 	if (unlikely(object == NULL))
 		return NULL;
@@ -421,9 +420,9 @@ static void *____kasan_kmalloc(struct km
 	tag = assign_tag(cache, object, false, keep_tag);
 
 	/* Tag is ignored in set_tag without CONFIG_KASAN_SW/HW_TAGS */
-	unpoison_range(set_tag(object, tag), size);
-	poison_range((void *)redzone_start, redzone_end - redzone_start,
-		     KASAN_KMALLOC_REDZONE);
+	kasan_unpoison(set_tag(object, tag), size);
+	kasan_poison((void *)redzone_start, redzone_end - redzone_start,
+			   KASAN_KMALLOC_REDZONE);
 
 	if (kasan_stack_collection_enabled())
 		set_alloc_info(cache, (void *)object, flags);
@@ -452,7 +451,7 @@ void * __must_check __kasan_kmalloc_larg
 	unsigned long redzone_end;
 
 	if (gfpflags_allow_blocking(flags))
-		quarantine_reduce();
+		kasan_quarantine_reduce();
 
 	if (unlikely(ptr == NULL))
 		return NULL;
@@ -462,8 +461,8 @@ void * __must_check __kasan_kmalloc_larg
 				KASAN_GRANULE_SIZE);
 	redzone_end = (unsigned long)ptr + page_size(page);
 
-	unpoison_range(ptr, size);
-	poison_range((void *)redzone_start, redzone_end - redzone_start,
+	kasan_unpoison(ptr, size);
+	kasan_poison((void *)redzone_start, redzone_end - redzone_start,
 		     KASAN_PAGE_REDZONE);
 
 	return (void *)ptr;
--- a/mm/kasan/generic.c~kasan-prefix-exported-functions-with-kasan_
+++ a/mm/kasan/generic.c
@@ -158,7 +158,7 @@ static __always_inline bool memory_is_po
 	return memory_is_poisoned_n(addr, size);
 }
 
-static __always_inline bool check_memory_region_inline(unsigned long addr,
+static __always_inline bool check_region_inline(unsigned long addr,
 						size_t size, bool write,
 						unsigned long ret_ip)
 {
@@ -179,13 +179,13 @@ static __always_inline bool check_memory
 	return !kasan_report(addr, size, write, ret_ip);
 }
 
-bool check_memory_region(unsigned long addr, size_t size, bool write,
-				unsigned long ret_ip)
+bool kasan_check_range(unsigned long addr, size_t size, bool write,
+					unsigned long ret_ip)
 {
-	return check_memory_region_inline(addr, size, write, ret_ip);
+	return check_region_inline(addr, size, write, ret_ip);
 }
 
-bool check_invalid_free(void *addr)
+bool kasan_check_invalid_free(void *addr)
 {
 	s8 shadow_byte = READ_ONCE(*(s8 *)kasan_mem_to_shadow(addr));
 
@@ -194,22 +194,22 @@ bool check_invalid_free(void *addr)
 
 void kasan_cache_shrink(struct kmem_cache *cache)
 {
-	quarantine_remove_cache(cache);
+	kasan_quarantine_remove_cache(cache);
 }
 
 void kasan_cache_shutdown(struct kmem_cache *cache)
 {
 	if (!__kmem_cache_empty(cache))
-		quarantine_remove_cache(cache);
+		kasan_quarantine_remove_cache(cache);
 }
 
 static void register_global(struct kasan_global *global)
 {
 	size_t aligned_size = round_up(global->size, KASAN_GRANULE_SIZE);
 
-	unpoison_range(global->beg, global->size);
+	kasan_unpoison(global->beg, global->size);
 
-	poison_range(global->beg + aligned_size,
+	kasan_poison(global->beg + aligned_size,
 		     global->size_with_redzone - aligned_size,
 		     KASAN_GLOBAL_REDZONE);
 }
@@ -231,7 +231,7 @@ EXPORT_SYMBOL(__asan_unregister_globals)
 #define DEFINE_ASAN_LOAD_STORE(size)					\
 	void __asan_load##size(unsigned long addr)			\
 	{								\
-		check_memory_region_inline(addr, size, false, _RET_IP_);\
+		check_region_inline(addr, size, false, _RET_IP_);	\
 	}								\
 	EXPORT_SYMBOL(__asan_load##size);				\
 	__alias(__asan_load##size)					\
@@ -239,7 +239,7 @@ EXPORT_SYMBOL(__asan_unregister_globals)
 	EXPORT_SYMBOL(__asan_load##size##_noabort);			\
 	void __asan_store##size(unsigned long addr)			\
 	{								\
-		check_memory_region_inline(addr, size, true, _RET_IP_);	\
+		check_region_inline(addr, size, true, _RET_IP_);	\
 	}								\
 	EXPORT_SYMBOL(__asan_store##size);				\
 	__alias(__asan_store##size)					\
@@ -254,7 +254,7 @@ DEFINE_ASAN_LOAD_STORE(16);
 
 void __asan_loadN(unsigned long addr, size_t size)
 {
-	check_memory_region(addr, size, false, _RET_IP_);
+	kasan_check_range(addr, size, false, _RET_IP_);
 }
 EXPORT_SYMBOL(__asan_loadN);
 
@@ -264,7 +264,7 @@ EXPORT_SYMBOL(__asan_loadN_noabort);
 
 void __asan_storeN(unsigned long addr, size_t size)
 {
-	check_memory_region(addr, size, true, _RET_IP_);
+	kasan_check_range(addr, size, true, _RET_IP_);
 }
 EXPORT_SYMBOL(__asan_storeN);
 
@@ -290,11 +290,11 @@ void __asan_alloca_poison(unsigned long
 
 	WARN_ON(!IS_ALIGNED(addr, KASAN_ALLOCA_REDZONE_SIZE));
 
-	unpoison_range((const void *)(addr + rounded_down_size),
-		       size - rounded_down_size);
-	poison_range(left_redzone, KASAN_ALLOCA_REDZONE_SIZE,
+	kasan_unpoison((const void *)(addr + rounded_down_size),
+			size - rounded_down_size);
+	kasan_poison(left_redzone, KASAN_ALLOCA_REDZONE_SIZE,
 		     KASAN_ALLOCA_LEFT);
-	poison_range(right_redzone, padding_size + KASAN_ALLOCA_REDZONE_SIZE,
+	kasan_poison(right_redzone, padding_size + KASAN_ALLOCA_REDZONE_SIZE,
 		     KASAN_ALLOCA_RIGHT);
 }
 EXPORT_SYMBOL(__asan_alloca_poison);
@@ -305,7 +305,7 @@ void __asan_allocas_unpoison(const void
 	if (unlikely(!stack_top || stack_top > stack_bottom))
 		return;
 
-	unpoison_range(stack_top, stack_bottom - stack_top);
+	kasan_unpoison(stack_top, stack_bottom - stack_top);
 }
 EXPORT_SYMBOL(__asan_allocas_unpoison);
 
--- a/mm/kasan/kasan.h~kasan-prefix-exported-functions-with-kasan_
+++ a/mm/kasan/kasan.h
@@ -195,14 +195,14 @@ static inline bool addr_has_metadata(con
 }
 
 /**
- * check_memory_region - Check memory region, and report if invalid access.
+ * kasan_check_range - Check memory region, and report if invalid access.
  * @addr: the accessed address
  * @size: the accessed size
  * @write: true if access is a write access
  * @ret_ip: return address
  * @return: true if access was valid, false if invalid
  */
-bool check_memory_region(unsigned long addr, size_t size, bool write,
+bool kasan_check_range(unsigned long addr, size_t size, bool write,
 				unsigned long ret_ip);
 
 #else /* CONFIG_KASAN_GENERIC || CONFIG_KASAN_SW_TAGS */
@@ -215,19 +215,19 @@ static inline bool addr_has_metadata(con
 #endif /* CONFIG_KASAN_GENERIC || CONFIG_KASAN_SW_TAGS */
 
 #if defined(CONFIG_KASAN_SW_TAGS) || defined(CONFIG_KASAN_HW_TAGS)
-void print_tags(u8 addr_tag, const void *addr);
+void kasan_print_tags(u8 addr_tag, const void *addr);
 #else
-static inline void print_tags(u8 addr_tag, const void *addr) { }
+static inline void kasan_print_tags(u8 addr_tag, const void *addr) { }
 #endif
 
-void *find_first_bad_addr(void *addr, size_t size);
-const char *get_bug_type(struct kasan_access_info *info);
-void metadata_fetch_row(char *buffer, void *row);
+void *kasan_find_first_bad_addr(void *addr, size_t size);
+const char *kasan_get_bug_type(struct kasan_access_info *info);
+void kasan_metadata_fetch_row(char *buffer, void *row);
 
 #if defined(CONFIG_KASAN_GENERIC) && CONFIG_KASAN_STACK
-void print_address_stack_frame(const void *addr);
+void kasan_print_address_stack_frame(const void *addr);
 #else
-static inline void print_address_stack_frame(const void *addr) { }
+static inline void kasan_print_address_stack_frame(const void *addr) { }
 #endif
 
 bool kasan_report(unsigned long addr, size_t size,
@@ -244,13 +244,13 @@ struct kasan_track *kasan_get_free_track
 
 #if defined(CONFIG_KASAN_GENERIC) && \
 	(defined(CONFIG_SLAB) || defined(CONFIG_SLUB))
-bool quarantine_put(struct kmem_cache *cache, void *object);
-void quarantine_reduce(void);
-void quarantine_remove_cache(struct kmem_cache *cache);
+bool kasan_quarantine_put(struct kmem_cache *cache, void *object);
+void kasan_quarantine_reduce(void);
+void kasan_quarantine_remove_cache(struct kmem_cache *cache);
 #else
-static inline bool quarantine_put(struct kmem_cache *cache, void *object) { return false; }
-static inline void quarantine_reduce(void) { }
-static inline void quarantine_remove_cache(struct kmem_cache *cache) { }
+static inline bool kasan_quarantine_put(struct kmem_cache *cache, void *object) { return false; }
+static inline void kasan_quarantine_reduce(void) { }
+static inline void kasan_quarantine_remove_cache(struct kmem_cache *cache) { }
 #endif
 
 #ifndef arch_kasan_set_tag
@@ -293,28 +293,28 @@ static inline const void *arch_kasan_set
 #endif /* CONFIG_KASAN_HW_TAGS */
 
 #ifdef CONFIG_KASAN_SW_TAGS
-u8 random_tag(void);
+u8 kasan_random_tag(void);
 #elif defined(CONFIG_KASAN_HW_TAGS)
-static inline u8 random_tag(void) { return hw_get_random_tag(); }
+static inline u8 kasan_random_tag(void) { return hw_get_random_tag(); }
 #else
-static inline u8 random_tag(void) { return 0; }
+static inline u8 kasan_random_tag(void) { return 0; }
 #endif
 
 #ifdef CONFIG_KASAN_HW_TAGS
 
-static inline void poison_range(const void *address, size_t size, u8 value)
+static inline void kasan_poison(const void *address, size_t size, u8 value)
 {
 	hw_set_mem_tag_range(kasan_reset_tag(address),
 			round_up(size, KASAN_GRANULE_SIZE), value);
 }
 
-static inline void unpoison_range(const void *address, size_t size)
+static inline void kasan_unpoison(const void *address, size_t size)
 {
 	hw_set_mem_tag_range(kasan_reset_tag(address),
 			round_up(size, KASAN_GRANULE_SIZE), get_tag(address));
 }
 
-static inline bool check_invalid_free(void *addr)
+static inline bool kasan_check_invalid_free(void *addr)
 {
 	u8 ptr_tag = get_tag(addr);
 	u8 mem_tag = hw_get_mem_tag(addr);
@@ -325,9 +325,9 @@ static inline bool check_invalid_free(vo
 
 #else /* CONFIG_KASAN_HW_TAGS */
 
-void poison_range(const void *address, size_t size, u8 value);
-void unpoison_range(const void *address, size_t size);
-bool check_invalid_free(void *addr);
+void kasan_poison(const void *address, size_t size, u8 value);
+void kasan_unpoison(const void *address, size_t size);
+bool kasan_check_invalid_free(void *addr);
 
 #endif /* CONFIG_KASAN_HW_TAGS */
 
--- a/mm/kasan/quarantine.c~kasan-prefix-exported-functions-with-kasan_
+++ a/mm/kasan/quarantine.c
@@ -168,7 +168,7 @@ static void qlist_free_all(struct qlist_
 	qlist_init(q);
 }
 
-bool quarantine_put(struct kmem_cache *cache, void *object)
+bool kasan_quarantine_put(struct kmem_cache *cache, void *object)
 {
 	unsigned long flags;
 	struct qlist_head *q;
@@ -184,11 +184,11 @@ bool quarantine_put(struct kmem_cache *c
 
 	/*
 	 * Note: irq must be disabled until after we move the batch to the
-	 * global quarantine. Otherwise quarantine_remove_cache() can miss
-	 * some objects belonging to the cache if they are in our local temp
-	 * list. quarantine_remove_cache() executes on_each_cpu() at the
-	 * beginning which ensures that it either sees the objects in per-cpu
-	 * lists or in the global quarantine.
+	 * global quarantine. Otherwise kasan_quarantine_remove_cache() can
+	 * miss some objects belonging to the cache if they are in our local
+	 * temp list. kasan_quarantine_remove_cache() executes on_each_cpu()
+	 * at the beginning which ensures that it either sees the objects in
+	 * per-cpu lists or in the global quarantine.
 	 */
 	local_irq_save(flags);
 
@@ -222,7 +222,7 @@ bool quarantine_put(struct kmem_cache *c
 	return true;
 }
 
-void quarantine_reduce(void)
+void kasan_quarantine_reduce(void)
 {
 	size_t total_size, new_quarantine_size, percpu_quarantines;
 	unsigned long flags;
@@ -234,7 +234,7 @@ void quarantine_reduce(void)
 		return;
 
 	/*
-	 * srcu critical section ensures that quarantine_remove_cache()
+	 * srcu critical section ensures that kasan_quarantine_remove_cache()
 	 * will not miss objects belonging to the cache while they are in our
 	 * local to_free list. srcu is chosen because (1) it gives us private
 	 * grace period domain that does not interfere with anything else,
@@ -309,15 +309,15 @@ static void per_cpu_remove_cache(void *a
 }
 
 /* Free all quarantined objects belonging to cache. */
-void quarantine_remove_cache(struct kmem_cache *cache)
+void kasan_quarantine_remove_cache(struct kmem_cache *cache)
 {
 	unsigned long flags, i;
 	struct qlist_head to_free = QLIST_INIT;
 
 	/*
 	 * Must be careful to not miss any objects that are being moved from
-	 * per-cpu list to the global quarantine in quarantine_put(),
-	 * nor objects being freed in quarantine_reduce(). on_each_cpu()
+	 * per-cpu list to the global quarantine in kasan_quarantine_put(),
+	 * nor objects being freed in kasan_quarantine_reduce(). on_each_cpu()
 	 * achieves the first goal, while synchronize_srcu() achieves the
 	 * second.
 	 */
--- a/mm/kasan/report.c~kasan-prefix-exported-functions-with-kasan_
+++ a/mm/kasan/report.c
@@ -61,7 +61,7 @@ __setup("kasan_multi_shot", kasan_set_mu
 static void print_error_description(struct kasan_access_info *info)
 {
 	pr_err("BUG: KASAN: %s in %pS\n",
-		get_bug_type(info), (void *)info->ip);
+		kasan_get_bug_type(info), (void *)info->ip);
 	if (info->access_size)
 		pr_err("%s of size %zu at addr %px by task %s/%d\n",
 			info->is_write ? "Write" : "Read", info->access_size,
@@ -247,7 +247,7 @@ static void print_address_description(vo
 		dump_page(page, "kasan: bad access detected");
 	}
 
-	print_address_stack_frame(addr);
+	kasan_print_address_stack_frame(addr);
 }
 
 static bool meta_row_is_guilty(const void *row, const void *addr)
@@ -293,7 +293,7 @@ static void print_memory_metadata(const
 		 * function, because generic functions may try to
 		 * access kasan mapping for the passed address.
 		 */
-		metadata_fetch_row(&metadata[0], row);
+		kasan_metadata_fetch_row(&metadata[0], row);
 
 		print_hex_dump(KERN_ERR, buffer,
 			DUMP_PREFIX_NONE, META_BYTES_PER_ROW, 1,
@@ -350,7 +350,7 @@ void kasan_report_invalid_free(void *obj
 
 	start_report(&flags);
 	pr_err("BUG: KASAN: double-free or invalid-free in %pS\n", (void *)ip);
-	print_tags(tag, object);
+	kasan_print_tags(tag, object);
 	pr_err("\n");
 	print_address_description(object, tag);
 	pr_err("\n");
@@ -378,7 +378,8 @@ static void __kasan_report(unsigned long
 
 	info.access_addr = tagged_addr;
 	if (addr_has_metadata(untagged_addr))
-		info.first_bad_addr = find_first_bad_addr(tagged_addr, size);
+		info.first_bad_addr =
+			kasan_find_first_bad_addr(tagged_addr, size);
 	else
 		info.first_bad_addr = untagged_addr;
 	info.access_size = size;
@@ -389,7 +390,7 @@ static void __kasan_report(unsigned long
 
 	print_error_description(&info);
 	if (addr_has_metadata(untagged_addr))
-		print_tags(get_tag(tagged_addr), info.first_bad_addr);
+		kasan_print_tags(get_tag(tagged_addr), info.first_bad_addr);
 	pr_err("\n");
 
 	if (addr_has_metadata(untagged_addr)) {
--- a/mm/kasan/report_generic.c~kasan-prefix-exported-functions-with-kasan_
+++ a/mm/kasan/report_generic.c
@@ -30,7 +30,7 @@
 #include "kasan.h"
 #include "../slab.h"
 
-void *find_first_bad_addr(void *addr, size_t size)
+void *kasan_find_first_bad_addr(void *addr, size_t size)
 {
 	void *p = addr;
 
@@ -105,7 +105,7 @@ static const char *get_wild_bug_type(str
 	return bug_type;
 }
 
-const char *get_bug_type(struct kasan_access_info *info)
+const char *kasan_get_bug_type(struct kasan_access_info *info)
 {
 	/*
 	 * If access_size is a negative number, then it has reason to be
@@ -123,7 +123,7 @@ const char *get_bug_type(struct kasan_ac
 	return get_wild_bug_type(info);
 }
 
-void metadata_fetch_row(char *buffer, void *row)
+void kasan_metadata_fetch_row(char *buffer, void *row)
 {
 	memcpy(buffer, kasan_mem_to_shadow(row), META_BYTES_PER_ROW);
 }
@@ -263,7 +263,7 @@ static bool __must_check get_address_sta
 	return true;
 }
 
-void print_address_stack_frame(const void *addr)
+void kasan_print_address_stack_frame(const void *addr)
 {
 	unsigned long offset;
 	const char *frame_descr;
--- a/mm/kasan/report_hw_tags.c~kasan-prefix-exported-functions-with-kasan_
+++ a/mm/kasan/report_hw_tags.c
@@ -15,17 +15,17 @@
 
 #include "kasan.h"
 
-const char *get_bug_type(struct kasan_access_info *info)
+const char *kasan_get_bug_type(struct kasan_access_info *info)
 {
 	return "invalid-access";
 }
 
-void *find_first_bad_addr(void *addr, size_t size)
+void *kasan_find_first_bad_addr(void *addr, size_t size)
 {
 	return kasan_reset_tag(addr);
 }
 
-void metadata_fetch_row(char *buffer, void *row)
+void kasan_metadata_fetch_row(char *buffer, void *row)
 {
 	int i;
 
@@ -33,7 +33,7 @@ void metadata_fetch_row(char *buffer, vo
 		buffer[i] = hw_get_mem_tag(row + i * KASAN_GRANULE_SIZE);
 }
 
-void print_tags(u8 addr_tag, const void *addr)
+void kasan_print_tags(u8 addr_tag, const void *addr)
 {
 	u8 memory_tag = hw_get_mem_tag((void *)addr);
 
--- a/mm/kasan/report_sw_tags.c~kasan-prefix-exported-functions-with-kasan_
+++ a/mm/kasan/report_sw_tags.c
@@ -29,7 +29,7 @@
 #include "kasan.h"
 #include "../slab.h"
 
-const char *get_bug_type(struct kasan_access_info *info)
+const char *kasan_get_bug_type(struct kasan_access_info *info)
 {
 #ifdef CONFIG_KASAN_SW_TAGS_IDENTIFY
 	struct kasan_alloc_meta *alloc_meta;
@@ -72,7 +72,7 @@ const char *get_bug_type(struct kasan_ac
 	return "invalid-access";
 }
 
-void *find_first_bad_addr(void *addr, size_t size)
+void *kasan_find_first_bad_addr(void *addr, size_t size)
 {
 	u8 tag = get_tag(addr);
 	void *p = kasan_reset_tag(addr);
@@ -83,12 +83,12 @@ void *find_first_bad_addr(void *addr, si
 	return p;
 }
 
-void metadata_fetch_row(char *buffer, void *row)
+void kasan_metadata_fetch_row(char *buffer, void *row)
 {
 	memcpy(buffer, kasan_mem_to_shadow(row), META_BYTES_PER_ROW);
 }
 
-void print_tags(u8 addr_tag, const void *addr)
+void kasan_print_tags(u8 addr_tag, const void *addr)
 {
 	u8 *shadow = (u8 *)kasan_mem_to_shadow(addr);
 
--- a/mm/kasan/shadow.c~kasan-prefix-exported-functions-with-kasan_
+++ a/mm/kasan/shadow.c
@@ -27,20 +27,20 @@
 
 bool __kasan_check_read(const volatile void *p, unsigned int size)
 {
-	return check_memory_region((unsigned long)p, size, false, _RET_IP_);
+	return kasan_check_range((unsigned long)p, size, false, _RET_IP_);
 }
 EXPORT_SYMBOL(__kasan_check_read);
 
 bool __kasan_check_write(const volatile void *p, unsigned int size)
 {
-	return check_memory_region((unsigned long)p, size, true, _RET_IP_);
+	return kasan_check_range((unsigned long)p, size, true, _RET_IP_);
 }
 EXPORT_SYMBOL(__kasan_check_write);
 
 #undef memset
 void *memset(void *addr, int c, size_t len)
 {
-	if (!check_memory_region((unsigned long)addr, len, true, _RET_IP_))
+	if (!kasan_check_range((unsigned long)addr, len, true, _RET_IP_))
 		return NULL;
 
 	return __memset(addr, c, len);
@@ -50,8 +50,8 @@ void *memset(void *addr, int c, size_t l
 #undef memmove
 void *memmove(void *dest, const void *src, size_t len)
 {
-	if (!check_memory_region((unsigned long)src, len, false, _RET_IP_) ||
-	    !check_memory_region((unsigned long)dest, len, true, _RET_IP_))
+	if (!kasan_check_range((unsigned long)src, len, false, _RET_IP_) ||
+	    !kasan_check_range((unsigned long)dest, len, true, _RET_IP_))
 		return NULL;
 
 	return __memmove(dest, src, len);
@@ -61,8 +61,8 @@ void *memmove(void *dest, const void *sr
 #undef memcpy
 void *memcpy(void *dest, const void *src, size_t len)
 {
-	if (!check_memory_region((unsigned long)src, len, false, _RET_IP_) ||
-	    !check_memory_region((unsigned long)dest, len, true, _RET_IP_))
+	if (!kasan_check_range((unsigned long)src, len, false, _RET_IP_) ||
+	    !kasan_check_range((unsigned long)dest, len, true, _RET_IP_))
 		return NULL;
 
 	return __memcpy(dest, src, len);
@@ -72,7 +72,7 @@ void *memcpy(void *dest, const void *src
  * Poisons the shadow memory for 'size' bytes starting from 'addr'.
  * Memory addresses should be aligned to KASAN_GRANULE_SIZE.
  */
-void poison_range(const void *address, size_t size, u8 value)
+void kasan_poison(const void *address, size_t size, u8 value)
 {
 	void *shadow_start, *shadow_end;
 
@@ -90,7 +90,7 @@ void poison_range(const void *address, s
 	__memset(shadow_start, value, shadow_end - shadow_start);
 }
 
-void unpoison_range(const void *address, size_t size)
+void kasan_unpoison(const void *address, size_t size)
 {
 	u8 tag = get_tag(address);
 
@@ -101,7 +101,7 @@ void unpoison_range(const void *address,
 	 */
 	address = kasan_reset_tag(address);
 
-	poison_range(address, size, tag);
+	kasan_poison(address, size, tag);
 
 	if (size & KASAN_GRANULE_MASK) {
 		u8 *shadow = (u8 *)kasan_mem_to_shadow(address + size);
@@ -286,7 +286,7 @@ int kasan_populate_vmalloc(unsigned long
 	 * // vmalloc() allocates memory
 	 * // let a = area->addr
 	 * // we reach kasan_populate_vmalloc
-	 * // and call unpoison_range:
+	 * // and call kasan_unpoison:
 	 * STORE shadow(a), unpoison_val
 	 * ...
 	 * STORE shadow(a+99), unpoison_val	x = LOAD p
@@ -321,7 +321,7 @@ void kasan_poison_vmalloc(const void *st
 		return;
 
 	size = round_up(size, KASAN_GRANULE_SIZE);
-	poison_range(start, size, KASAN_VMALLOC_INVALID);
+	kasan_poison(start, size, KASAN_VMALLOC_INVALID);
 }
 
 void kasan_unpoison_vmalloc(const void *start, unsigned long size)
@@ -329,7 +329,7 @@ void kasan_unpoison_vmalloc(const void *
 	if (!is_vmalloc_or_module_addr(start))
 		return;
 
-	unpoison_range(start, size);
+	kasan_unpoison(start, size);
 }
 
 static int kasan_depopulate_vmalloc_pte(pte_t *ptep, unsigned long addr,
--- a/mm/kasan/sw_tags.c~kasan-prefix-exported-functions-with-kasan_
+++ a/mm/kasan/sw_tags.c
@@ -57,7 +57,7 @@ void __init kasan_init_sw_tags(void)
  * sequence has in fact positive effect, since interrupts that randomly skew
  * PRNG at unpredictable points do only good.
  */
-u8 random_tag(void)
+u8 kasan_random_tag(void)
 {
 	u32 state = this_cpu_read(prng_state);
 
@@ -67,7 +67,7 @@ u8 random_tag(void)
 	return (u8)(state % (KASAN_TAG_MAX + 1));
 }
 
-bool check_memory_region(unsigned long addr, size_t size, bool write,
+bool kasan_check_range(unsigned long addr, size_t size, bool write,
 				unsigned long ret_ip)
 {
 	u8 tag;
@@ -118,7 +118,7 @@ bool check_memory_region(unsigned long a
 	return true;
 }
 
-bool check_invalid_free(void *addr)
+bool kasan_check_invalid_free(void *addr)
 {
 	u8 tag = get_tag(addr);
 	u8 shadow_byte = READ_ONCE(*(u8 *)kasan_mem_to_shadow(kasan_reset_tag(addr)));
@@ -130,12 +130,12 @@ bool check_invalid_free(void *addr)
 #define DEFINE_HWASAN_LOAD_STORE(size)					\
 	void __hwasan_load##size##_noabort(unsigned long addr)		\
 	{								\
-		check_memory_region(addr, size, false, _RET_IP_);	\
+		kasan_check_range(addr, size, false, _RET_IP_);	\
 	}								\
 	EXPORT_SYMBOL(__hwasan_load##size##_noabort);			\
 	void __hwasan_store##size##_noabort(unsigned long addr)		\
 	{								\
-		check_memory_region(addr, size, true, _RET_IP_);	\
+		kasan_check_range(addr, size, true, _RET_IP_);		\
 	}								\
 	EXPORT_SYMBOL(__hwasan_store##size##_noabort)
 
@@ -147,19 +147,19 @@ DEFINE_HWASAN_LOAD_STORE(16);
 
 void __hwasan_loadN_noabort(unsigned long addr, unsigned long size)
 {
-	check_memory_region(addr, size, false, _RET_IP_);
+	kasan_check_range(addr, size, false, _RET_IP_);
 }
 EXPORT_SYMBOL(__hwasan_loadN_noabort);
 
 void __hwasan_storeN_noabort(unsigned long addr, unsigned long size)
 {
-	check_memory_region(addr, size, true, _RET_IP_);
+	kasan_check_range(addr, size, true, _RET_IP_);
 }
 EXPORT_SYMBOL(__hwasan_storeN_noabort);
 
 void __hwasan_tag_memory(unsigned long addr, u8 tag, unsigned long size)
 {
-	poison_range((void *)addr, size, tag);
+	kasan_poison((void *)addr, size, tag);
 }
 EXPORT_SYMBOL(__hwasan_tag_memory);
 
--- a/tools/objtool/check.c~kasan-prefix-exported-functions-with-kasan_
+++ a/tools/objtool/check.c
@@ -576,7 +576,7 @@ static void add_ignores(struct objtool_f
 static const char *uaccess_safe_builtin[] = {
 	/* KASAN */
 	"kasan_report",
-	"check_memory_region",
+	"kasan_check_range",
 	/* KASAN out-of-line */
 	"__asan_loadN_noabort",
 	"__asan_load1_noabort",
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-prefix-exported-functions-with-kasan_.patch
kasan-clarify-hw_tags-impact-on-tbi.patch
kasan-clean-up-comments-in-tests.patch
kasan-add-match-all-tag-tests.patch
kasan-arm64-allow-using-kunit-tests-with-hw_tags-mode.patch
kasan-rename-config_test_kasan_module.patch
kasan-add-compiler-barriers-to-kunit_expect_kasan_fail.patch
kasan-adopt-kmalloc_uaf2-test-to-hw_tags-mode.patch
kasan-fix-memory-corruption-in-kasan_bitops_tags-test.patch
kasan-fix-bug-detection-via-ksize-for-hw_tags-mode.patch
kasan-add-proper-page-allocator-tests.patch

