Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BDECC2D0E4
	for <mm-commits@archiver.kernel.org>; Tue, 24 Nov 2020 00:35:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F378E20729
	for <mm-commits@archiver.kernel.org>; Tue, 24 Nov 2020 00:35:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jcMu+O6o"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729496AbgKXAfV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 23 Nov 2020 19:35:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:42902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729950AbgKXAfV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 23 Nov 2020 19:35:21 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 33FB220757;
        Tue, 24 Nov 2020 00:35:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1606178119;
        bh=0DYjxDJfouZaHErKRxOg32VHhTEExYNVzMtky2IFCz8=;
        h=Date:From:To:Subject:From;
        b=jcMu+O6oK0kEzoxHZ28rb0gNlUkBnSCSM5Smy5rZ9m50U4f5DqiXmRNxsnfwQ855a
         dysM99mj85vq3TS4r++EsL7YoalkoWKmD5CwTI8nNuXsAv5MKL/HjNzRYoRB40fgPj
         Kpujgvs2poFiC4QQ4JrjN6CFGzIUd+jmXSzH5EkQ=
Date:   Mon, 23 Nov 2020 16:35:18 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, aryabinin@virtuozzo.com,
        Branislav.Rankov@arm.com, catalin.marinas@arm.com,
        dvyukov@google.com, elver@google.com, eugenis@google.com,
        glider@google.com, gor@linux.ibm.com, kevin.brodsky@arm.com,
        mm-commits@vger.kernel.org, vincenzo.frascino@arm.com,
        will.deacon@arm.com
Subject:  + kasan-rename-unpoison_shadow-to-unpoison_range.patch
 added to -mm tree
Message-ID: <20201124003518.3i3ML9LyV%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: rename (un)poison_shadow to (un)poison_range
has been added to the -mm tree.  Its filename is
     kasan-rename-unpoison_shadow-to-unpoison_range.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-rename-unpoison_shadow-to-unpoison_range.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-rename-unpoison_shadow-to-unpoison_range.patch

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
Subject: kasan: rename (un)poison_shadow to (un)poison_range

This is a preparatory commit for the upcoming addition of a new hardware
tag-based (MTE-based) KASAN mode.

The new mode won't be using shadow memory.  Rename external annotation
kasan_unpoison_shadow() to kasan_unpoison_range(), and introduce internal
functions (un)poison_range() (without kasan_ prefix).

Co-developed-by: Marco Elver <elver@google.com>
Link: https://lkml.kernel.org/r/fccdcaa13dc6b2211bf363d6c6d499279a54fe3a.1606161801.git.andreyknvl@google.com
Signed-off-by: Marco Elver <elver@google.com>
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Signed-off-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Tested-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
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

 include/linux/kasan.h |    6 ++--
 kernel/fork.c         |    4 +--
 mm/kasan/common.c     |   49 ++++++++++++++++++++++------------------
 mm/kasan/generic.c    |   23 ++++++++----------
 mm/kasan/kasan.h      |    3 +-
 mm/kasan/tags.c       |    2 -
 mm/slab_common.c      |    2 -
 7 files changed, 47 insertions(+), 42 deletions(-)

--- a/include/linux/kasan.h~kasan-rename-unpoison_shadow-to-unpoison_range
+++ a/include/linux/kasan.h
@@ -71,7 +71,7 @@ extern void kasan_enable_current(void);
 /* Disable reporting bugs for current task */
 extern void kasan_disable_current(void);
 
-void kasan_unpoison_shadow(const void *address, size_t size);
+void kasan_unpoison_range(const void *address, size_t size);
 
 void kasan_unpoison_task_stack(struct task_struct *task);
 
@@ -108,7 +108,7 @@ struct kasan_cache {
 size_t __ksize(const void *);
 static inline void kasan_unpoison_slab(const void *ptr)
 {
-	kasan_unpoison_shadow(ptr, __ksize(ptr));
+	kasan_unpoison_range(ptr, __ksize(ptr));
 }
 size_t kasan_metadata_size(struct kmem_cache *cache);
 
@@ -117,7 +117,7 @@ void kasan_restore_multi_shot(bool enabl
 
 #else /* CONFIG_KASAN */
 
-static inline void kasan_unpoison_shadow(const void *address, size_t size) {}
+static inline void kasan_unpoison_range(const void *address, size_t size) {}
 
 static inline void kasan_unpoison_task_stack(struct task_struct *task) {}
 
--- a/kernel/fork.c~kasan-rename-unpoison_shadow-to-unpoison_range
+++ a/kernel/fork.c
@@ -225,8 +225,8 @@ static unsigned long *alloc_thread_stack
 		if (!s)
 			continue;
 
-		/* Clear the KASAN shadow of the stack. */
-		kasan_unpoison_shadow(s->addr, THREAD_SIZE);
+		/* Mark stack accessible for KASAN. */
+		kasan_unpoison_range(s->addr, THREAD_SIZE);
 
 		/* Clear stale pointers from reused stack. */
 		memset(s->addr, 0, THREAD_SIZE);
--- a/mm/kasan/common.c~kasan-rename-unpoison_shadow-to-unpoison_range
+++ a/mm/kasan/common.c
@@ -109,7 +109,7 @@ void *memcpy(void *dest, const void *src
  * Poisons the shadow memory for 'size' bytes starting from 'addr'.
  * Memory addresses should be aligned to KASAN_SHADOW_SCALE_SIZE.
  */
-void kasan_poison_shadow(const void *address, size_t size, u8 value)
+void poison_range(const void *address, size_t size, u8 value)
 {
 	void *shadow_start, *shadow_end;
 
@@ -130,7 +130,7 @@ void kasan_poison_shadow(const void *add
 	__memset(shadow_start, value, shadow_end - shadow_start);
 }
 
-void kasan_unpoison_shadow(const void *address, size_t size)
+void unpoison_range(const void *address, size_t size)
 {
 	u8 tag = get_tag(address);
 
@@ -149,7 +149,7 @@ void kasan_unpoison_shadow(const void *a
 	if (is_kfence_address(address))
 		return;
 
-	kasan_poison_shadow(address, size, tag);
+	poison_range(address, size, tag);
 
 	if (size & KASAN_SHADOW_MASK) {
 		u8 *shadow = (u8 *)kasan_mem_to_shadow(address + size);
@@ -161,12 +161,17 @@ void kasan_unpoison_shadow(const void *a
 	}
 }
 
+void kasan_unpoison_range(const void *address, size_t size)
+{
+	unpoison_range(address, size);
+}
+
 static void __kasan_unpoison_stack(struct task_struct *task, const void *sp)
 {
 	void *base = task_stack_page(task);
 	size_t size = sp - base;
 
-	kasan_unpoison_shadow(base, size);
+	unpoison_range(base, size);
 }
 
 /* Unpoison the entire stack for a task. */
@@ -185,7 +190,7 @@ asmlinkage void kasan_unpoison_task_stac
 	 */
 	void *base = (void *)((unsigned long)watermark & ~(THREAD_SIZE - 1));
 
-	kasan_unpoison_shadow(base, watermark - base);
+	unpoison_range(base, watermark - base);
 }
 
 void kasan_alloc_pages(struct page *page, unsigned int order)
@@ -199,13 +204,13 @@ void kasan_alloc_pages(struct page *page
 	tag = random_tag();
 	for (i = 0; i < (1 << order); i++)
 		page_kasan_tag_set(page + i, tag);
-	kasan_unpoison_shadow(page_address(page), PAGE_SIZE << order);
+	unpoison_range(page_address(page), PAGE_SIZE << order);
 }
 
 void kasan_free_pages(struct page *page, unsigned int order)
 {
 	if (likely(!PageHighMem(page)))
-		kasan_poison_shadow(page_address(page),
+		poison_range(page_address(page),
 				PAGE_SIZE << order,
 				KASAN_FREE_PAGE);
 }
@@ -297,18 +302,18 @@ void kasan_poison_slab(struct page *page
 
 	for (i = 0; i < compound_nr(page); i++)
 		page_kasan_tag_reset(page + i);
-	kasan_poison_shadow(page_address(page), page_size(page),
-			KASAN_KMALLOC_REDZONE);
+	poison_range(page_address(page), page_size(page),
+		     KASAN_KMALLOC_REDZONE);
 }
 
 void kasan_unpoison_object_data(struct kmem_cache *cache, void *object)
 {
-	kasan_unpoison_shadow(object, cache->object_size);
+	unpoison_range(object, cache->object_size);
 }
 
 void kasan_poison_object_data(struct kmem_cache *cache, void *object)
 {
-	kasan_poison_shadow(object,
+	poison_range(object,
 			round_up(cache->object_size, KASAN_SHADOW_SCALE_SIZE),
 			KASAN_KMALLOC_REDZONE);
 }
@@ -424,7 +429,7 @@ static bool __kasan_slab_free(struct kme
 	}
 
 	rounded_up_size = round_up(cache->object_size, KASAN_SHADOW_SCALE_SIZE);
-	kasan_poison_shadow(object, rounded_up_size, KASAN_KMALLOC_FREE);
+	poison_range(object, rounded_up_size, KASAN_KMALLOC_FREE);
 
 	if ((IS_ENABLED(CONFIG_KASAN_GENERIC) && !quarantine) ||
 			unlikely(!(cache->flags & SLAB_KASAN)))
@@ -467,9 +472,9 @@ static void *__kasan_kmalloc(struct kmem
 		tag = assign_tag(cache, object, false, keep_tag);
 
 	/* Tag is ignored in set_tag without CONFIG_KASAN_SW_TAGS */
-	kasan_unpoison_shadow(set_tag(object, tag), size);
-	kasan_poison_shadow((void *)redzone_start, redzone_end - redzone_start,
-		KASAN_KMALLOC_REDZONE);
+	unpoison_range(set_tag(object, tag), size);
+	poison_range((void *)redzone_start, redzone_end - redzone_start,
+		     KASAN_KMALLOC_REDZONE);
 
 	if (cache->flags & SLAB_KASAN)
 		kasan_set_track(&get_alloc_info(cache, object)->alloc_track, flags);
@@ -508,9 +513,9 @@ void * __must_check kasan_kmalloc_large(
 				KASAN_SHADOW_SCALE_SIZE);
 	redzone_end = (unsigned long)ptr + page_size(page);
 
-	kasan_unpoison_shadow(ptr, size);
-	kasan_poison_shadow((void *)redzone_start, redzone_end - redzone_start,
-		KASAN_PAGE_REDZONE);
+	unpoison_range(ptr, size);
+	poison_range((void *)redzone_start, redzone_end - redzone_start,
+		     KASAN_PAGE_REDZONE);
 
 	return (void *)ptr;
 }
@@ -542,7 +547,7 @@ void kasan_poison_kfree(void *ptr, unsig
 			kasan_report_invalid_free(ptr, ip);
 			return;
 		}
-		kasan_poison_shadow(ptr, page_size(page), KASAN_FREE_PAGE);
+		poison_range(ptr, page_size(page), KASAN_FREE_PAGE);
 	} else {
 		__kasan_slab_free(page->slab_cache, ptr, ip, false);
 	}
@@ -728,7 +733,7 @@ int kasan_populate_vmalloc(unsigned long
 	 * // vmalloc() allocates memory
 	 * // let a = area->addr
 	 * // we reach kasan_populate_vmalloc
-	 * // and call kasan_unpoison_shadow:
+	 * // and call unpoison_range:
 	 * STORE shadow(a), unpoison_val
 	 * ...
 	 * STORE shadow(a+99), unpoison_val	x = LOAD p
@@ -763,7 +768,7 @@ void kasan_poison_vmalloc(const void *st
 		return;
 
 	size = round_up(size, KASAN_SHADOW_SCALE_SIZE);
-	kasan_poison_shadow(start, size, KASAN_VMALLOC_INVALID);
+	poison_range(start, size, KASAN_VMALLOC_INVALID);
 }
 
 void kasan_unpoison_vmalloc(const void *start, unsigned long size)
@@ -771,7 +776,7 @@ void kasan_unpoison_vmalloc(const void *
 	if (!is_vmalloc_or_module_addr(start))
 		return;
 
-	kasan_unpoison_shadow(start, size);
+	unpoison_range(start, size);
 }
 
 static int kasan_depopulate_vmalloc_pte(pte_t *ptep, unsigned long addr,
--- a/mm/kasan/generic.c~kasan-rename-unpoison_shadow-to-unpoison_range
+++ a/mm/kasan/generic.c
@@ -203,11 +203,11 @@ static void register_global(struct kasan
 {
 	size_t aligned_size = round_up(global->size, KASAN_SHADOW_SCALE_SIZE);
 
-	kasan_unpoison_shadow(global->beg, global->size);
+	unpoison_range(global->beg, global->size);
 
-	kasan_poison_shadow(global->beg + aligned_size,
-		global->size_with_redzone - aligned_size,
-		KASAN_GLOBAL_REDZONE);
+	poison_range(global->beg + aligned_size,
+		     global->size_with_redzone - aligned_size,
+		     KASAN_GLOBAL_REDZONE);
 }
 
 void __asan_register_globals(struct kasan_global *globals, size_t size)
@@ -286,13 +286,12 @@ void __asan_alloca_poison(unsigned long
 
 	WARN_ON(!IS_ALIGNED(addr, KASAN_ALLOCA_REDZONE_SIZE));
 
-	kasan_unpoison_shadow((const void *)(addr + rounded_down_size),
-			      size - rounded_down_size);
-	kasan_poison_shadow(left_redzone, KASAN_ALLOCA_REDZONE_SIZE,
-			KASAN_ALLOCA_LEFT);
-	kasan_poison_shadow(right_redzone,
-			padding_size + KASAN_ALLOCA_REDZONE_SIZE,
-			KASAN_ALLOCA_RIGHT);
+	unpoison_range((const void *)(addr + rounded_down_size),
+		       size - rounded_down_size);
+	poison_range(left_redzone, KASAN_ALLOCA_REDZONE_SIZE,
+		     KASAN_ALLOCA_LEFT);
+	poison_range(right_redzone, padding_size + KASAN_ALLOCA_REDZONE_SIZE,
+		     KASAN_ALLOCA_RIGHT);
 }
 EXPORT_SYMBOL(__asan_alloca_poison);
 
@@ -302,7 +301,7 @@ void __asan_allocas_unpoison(const void
 	if (unlikely(!stack_top || stack_top > stack_bottom))
 		return;
 
-	kasan_unpoison_shadow(stack_top, stack_bottom - stack_top);
+	unpoison_range(stack_top, stack_bottom - stack_top);
 }
 EXPORT_SYMBOL(__asan_allocas_unpoison);
 
--- a/mm/kasan/kasan.h~kasan-rename-unpoison_shadow-to-unpoison_range
+++ a/mm/kasan/kasan.h
@@ -150,7 +150,8 @@ static inline bool addr_has_shadow(const
 	return (addr >= kasan_shadow_to_mem((void *)KASAN_SHADOW_START));
 }
 
-void kasan_poison_shadow(const void *address, size_t size, u8 value);
+void poison_range(const void *address, size_t size, u8 value);
+void unpoison_range(const void *address, size_t size);
 
 /**
  * check_memory_region - Check memory region, and report if invalid access.
--- a/mm/kasan/tags.c~kasan-rename-unpoison_shadow-to-unpoison_range
+++ a/mm/kasan/tags.c
@@ -153,7 +153,7 @@ EXPORT_SYMBOL(__hwasan_storeN_noabort);
 
 void __hwasan_tag_memory(unsigned long addr, u8 tag, unsigned long size)
 {
-	kasan_poison_shadow((void *)addr, size, tag);
+	poison_range((void *)addr, size, tag);
 }
 EXPORT_SYMBOL(__hwasan_tag_memory);
 
--- a/mm/slab_common.c~kasan-rename-unpoison_shadow-to-unpoison_range
+++ a/mm/slab_common.c
@@ -1179,7 +1179,7 @@ size_t ksize(const void *objp)
 	 * We assume that ksize callers could use whole allocated area,
 	 * so we need to unpoison this area.
 	 */
-	kasan_unpoison_shadow(objp, size);
+	kasan_unpoison_range(objp, size);
 	return size;
 }
 EXPORT_SYMBOL(ksize);
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

