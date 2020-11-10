Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 589F1C4742C
	for <mm-commits@archiver.kernel.org>; Tue, 10 Nov 2020 23:05:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F4BE207BB
	for <mm-commits@archiver.kernel.org>; Tue, 10 Nov 2020 23:05:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="w1wV2hLF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732289AbgKJXFv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 Nov 2020 18:05:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:57536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732240AbgKJXFv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 10 Nov 2020 18:05:51 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3161620679;
        Tue, 10 Nov 2020 23:05:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605049549;
        bh=9YsrN9zZWPs4Yp6qJVRTRpYuo8G4Kjcv3QPA2ONp2aU=;
        h=Date:From:To:Subject:From;
        b=w1wV2hLFZj+cX3SWEtw4Ba6RrMgN5pROL1Jzh83nAKIitSHV+GafGipimixLkNNhu
         er1Rnf/K3yKnNYIxtMQv59ytHjsgvZVSN20l+7BGMXAYKn3UK70Xyvp9O8JpF/vj9V
         SY+OSnlyntFKml4CG4EbkIoAavxUeqQk1vHixfNY=
Date:   Tue, 10 Nov 2020 15:05:48 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, aryabinin@virtuozzo.com,
        Branislav.Rankov@arm.com, catalin.marinas@arm.com,
        dvyukov@google.com, elver@google.com, eugenis@google.com,
        glider@google.com, kevin.brodsky@arm.com,
        mm-commits@vger.kernel.org, vincenzo.frascino@arm.com,
        will.deacon@arm.com
Subject:  + kasan-inline-and-rename-kasan_unpoison_memory.patch
 added to -mm tree
Message-ID: <20201110230548.z_dEwuHWR%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: inline and rename kasan_unpoison_memory
has been added to the -mm tree.  Its filename is
     kasan-inline-and-rename-kasan_unpoison_memory.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-inline-and-rename-kasan_unpoison_memory.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-inline-and-rename-kasan_unpoison_memory.patch

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
Subject: kasan: inline and rename kasan_unpoison_memory

Currently kasan_unpoison_memory() is used as both an external annotation
and as an internal memory poisoning helper. Rename external annotation to
kasan_unpoison_data() and inline the internal helper for hardware
tag-based mode to avoid undeeded function calls.

There's the external annotation kasan_unpoison_slab() that is currently
defined as static inline and uses kasan_unpoison_memory(). With this
change it's turned into a function call. Overall, this results in the
same number of calls for hardware tag-based mode as
kasan_unpoison_memory() is now inlined.

Link: https://lkml.kernel.org/r/0a9b63bff116734ab63d99ebd09c244332d71958.1605046662.git.andreyknvl@google.com
Link: https://linux-review.googlesource.com/id/Ia7c8b659f79209935cbaab3913bf7f082cc43a0e
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Branislav Rankov <Branislav.Rankov@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Marco Elver <elver@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kasan.h |   16 ++++++----------
 kernel/fork.c         |    2 +-
 mm/kasan/common.c     |   10 ++++++++++
 mm/kasan/hw_tags.c    |    6 ------
 mm/kasan/kasan.h      |    7 +++++++
 mm/slab_common.c      |    2 +-
 6 files changed, 25 insertions(+), 18 deletions(-)

--- a/include/linux/kasan.h~kasan-inline-and-rename-kasan_unpoison_memory
+++ a/include/linux/kasan.h
@@ -74,14 +74,15 @@ static inline void kasan_disable_current
 
 #ifdef CONFIG_KASAN
 
-void kasan_unpoison_memory(const void *address, size_t size);
-
 void kasan_alloc_pages(struct page *page, unsigned int order);
 void kasan_free_pages(struct page *page, unsigned int order);
 
 void kasan_cache_create(struct kmem_cache *cache, unsigned int *size,
 			slab_flags_t *flags);
 
+void kasan_unpoison_data(const void *address, size_t size);
+void kasan_unpoison_slab(const void *ptr);
+
 void kasan_poison_slab(struct page *page);
 void kasan_unpoison_object_data(struct kmem_cache *cache, void *object);
 void kasan_poison_object_data(struct kmem_cache *cache, void *object);
@@ -106,11 +107,6 @@ struct kasan_cache {
 	int free_meta_offset;
 };
 
-size_t __ksize(const void *);
-static inline void kasan_unpoison_slab(const void *ptr)
-{
-	kasan_unpoison_memory(ptr, __ksize(ptr));
-}
 size_t kasan_metadata_size(struct kmem_cache *cache);
 
 bool kasan_save_enable_multi_shot(void);
@@ -118,8 +114,6 @@ void kasan_restore_multi_shot(bool enabl
 
 #else /* CONFIG_KASAN */
 
-static inline void kasan_unpoison_memory(const void *address, size_t size) {}
-
 static inline void kasan_alloc_pages(struct page *page, unsigned int order) {}
 static inline void kasan_free_pages(struct page *page, unsigned int order) {}
 
@@ -127,6 +121,9 @@ static inline void kasan_cache_create(st
 				      unsigned int *size,
 				      slab_flags_t *flags) {}
 
+static inline void kasan_unpoison_data(const void *address, size_t size) { }
+static inline void kasan_unpoison_slab(const void *ptr) { }
+
 static inline void kasan_poison_slab(struct page *page) {}
 static inline void kasan_unpoison_object_data(struct kmem_cache *cache,
 					void *object) {}
@@ -166,7 +163,6 @@ static inline bool kasan_slab_free(struc
 	return false;
 }
 
-static inline void kasan_unpoison_slab(const void *ptr) { }
 static inline size_t kasan_metadata_size(struct kmem_cache *cache) { return 0; }
 
 #endif /* CONFIG_KASAN */
--- a/kernel/fork.c~kasan-inline-and-rename-kasan_unpoison_memory
+++ a/kernel/fork.c
@@ -226,7 +226,7 @@ static unsigned long *alloc_thread_stack
 			continue;
 
 		/* Mark stack accessible for KASAN. */
-		kasan_unpoison_memory(s->addr, THREAD_SIZE);
+		kasan_unpoison_data(s->addr, THREAD_SIZE);
 
 		/* Clear stale pointers from reused stack. */
 		memset(s->addr, 0, THREAD_SIZE);
--- a/mm/kasan/common.c~kasan-inline-and-rename-kasan_unpoison_memory
+++ a/mm/kasan/common.c
@@ -185,6 +185,16 @@ struct kasan_free_meta *kasan_get_free_m
 	return kasan_reset_tag(object) + cache->kasan_info.free_meta_offset;
 }
 
+void kasan_unpoison_data(const void *address, size_t size)
+{
+	kasan_unpoison_memory(address, size);
+}
+
+void kasan_unpoison_slab(const void *ptr)
+{
+	kasan_unpoison_memory(ptr, __ksize(ptr));
+}
+
 void kasan_poison_slab(struct page *page)
 {
 	unsigned long i;
--- a/mm/kasan/hw_tags.c~kasan-inline-and-rename-kasan_unpoison_memory
+++ a/mm/kasan/hw_tags.c
@@ -30,12 +30,6 @@ void kasan_init_hw_tags(void)
 	pr_info("KernelAddressSanitizer initialized\n");
 }
 
-void kasan_unpoison_memory(const void *address, size_t size)
-{
-	hw_set_mem_tag_range(kasan_reset_tag(address),
-			round_up(size, KASAN_GRANULE_SIZE), get_tag(address));
-}
-
 void kasan_set_free_info(struct kmem_cache *cache,
 				void *object, u8 tag)
 {
--- a/mm/kasan/kasan.h~kasan-inline-and-rename-kasan_unpoison_memory
+++ a/mm/kasan/kasan.h
@@ -283,6 +283,12 @@ static inline void kasan_poison_memory(c
 			round_up(size, KASAN_GRANULE_SIZE), value);
 }
 
+static inline void kasan_unpoison_memory(const void *address, size_t size)
+{
+	hw_set_mem_tag_range(kasan_reset_tag(address),
+			round_up(size, KASAN_GRANULE_SIZE), get_tag(address));
+}
+
 static inline bool check_invalid_free(void *addr)
 {
 	u8 ptr_tag = get_tag(addr);
@@ -295,6 +301,7 @@ static inline bool check_invalid_free(vo
 #else /* CONFIG_KASAN_HW_TAGS */
 
 void kasan_poison_memory(const void *address, size_t size, u8 value);
+void kasan_unpoison_memory(const void *address, size_t size);
 bool check_invalid_free(void *addr);
 
 #endif /* CONFIG_KASAN_HW_TAGS */
--- a/mm/slab_common.c~kasan-inline-and-rename-kasan_unpoison_memory
+++ a/mm/slab_common.c
@@ -1179,7 +1179,7 @@ size_t ksize(const void *objp)
 	 * We assume that ksize callers could use whole allocated area,
 	 * so we need to unpoison this area.
 	 */
-	kasan_unpoison_memory(objp, size);
+	kasan_unpoison_data(objp, size);
 	return size;
 }
 EXPORT_SYMBOL(ksize);
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-drop-unnecessary-gpl-text-from-comment-headers.patch
kasan-kasan_vmalloc-depends-on-kasan_generic.patch
kasan-group-vmalloc-code.patch
s390-kasan-include-asm-pageh-from-asm-kasanh.patch
kasan-shadow-declarations-only-for-software-modes.patch
kasan-rename-unpoison_shadow-to-unpoison_memory.patch
kasan-rename-kasan_shadow_-to-kasan_granule_.patch
kasan-only-build-initc-for-software-modes.patch
kasan-split-out-shadowc-from-commonc.patch
kasan-define-kasan_granule_page.patch
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
kasan-kasan_non_canonical_hook-only-for-software-modes.patch
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
kasan-inline-kasan_poison_memory-and-check_invalid_free.patch
kasan-inline-and-rename-kasan_unpoison_memory.patch
kasan-add-and-integrate-kasan-boot-parameters.patch
kasan-mm-check-kasan_enabled-in-annotations.patch
kasan-simplify-kasan_poison_kfree.patch
kasan-mm-rename-kasan_poison_kfree.patch
kasan-dont-round_up-too-much.patch
kasan-simplify-assign_tag-and-set_tag-calls.patch
kasan-clarify-comment-in-__kasan_kfree_large.patch
kasan-clean-up-metadata-allocation-and-usage.patch
kasan-mm-allow-cache-merging-with-no-metadata.patch
kasan-update-documentation.patch

