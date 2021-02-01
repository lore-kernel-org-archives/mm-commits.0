Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00788C433E6
	for <mm-commits@archiver.kernel.org>; Mon,  1 Feb 2021 22:47:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD6B264D9C
	for <mm-commits@archiver.kernel.org>; Mon,  1 Feb 2021 22:47:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229973AbhBAWrq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 1 Feb 2021 17:47:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:33406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229959AbhBAWrn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 1 Feb 2021 17:47:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 04E0164EAC;
        Mon,  1 Feb 2021 22:46:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1612219597;
        bh=fpgW88pZ6/CgLoaZIjx5dC7KMiLwxCZZ8ZqQVV0lYWU=;
        h=Date:From:To:Subject:From;
        b=AVxdw/ZJ1TlqeYgnBRiRo3b2P2ZHbB92GJ7sASV9TnouyYsW1eP8derQYu3RzUpYP
         KhRHcjNWjjCE/3Dc8RonfVp8wwVMNfdshvcb3q0l4D8/S1b67TYXknRVlpiOwRNpeZ
         4nCqfs3sRN+SO3kvT1NI6qpeZUR0gz6WwLYiv7SE=
Date:   Mon, 01 Feb 2021 14:46:36 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, aryabinin@virtuozzo.com,
        Branislav.Rankov@arm.com, catalin.marinas@arm.com,
        dvyukov@google.com, elver@google.com, eugenis@google.com,
        glider@google.com, kevin.brodsky@arm.com,
        mm-commits@vger.kernel.org, pcc@google.com,
        vincenzo.frascino@arm.com, will.deacon@arm.com
Subject:  + kasan-always-inline-hw_tags-helper-functions.patch
 added to -mm tree
Message-ID: <20210201224636.qf7MV-8mN%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: always inline HW_TAGS helper functions
has been added to the -mm tree.  Its filename is
     kasan-always-inline-hw_tags-helper-functions.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-always-inline-hw_tags-helper-functions.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-always-inline-hw_tags-helper-functions.patch

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
Subject: kasan: always inline HW_TAGS helper functions

Mark all static functions in common.c and kasan.h that are used for
hardware tag-based KASAN as __always_inline to avoid unnecessary function
calls.

Link: https://lkml.kernel.org/r/05a45017b4cb15344395650e880bbab0fe6ba3e4.1612208222.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Branislav Rankov <Branislav.Rankov@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Marco Elver <elver@google.com>
Cc: Peter Collingbourne <pcc@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/common.c |   13 +++++++------
 mm/kasan/kasan.h  |    6 +++---
 2 files changed, 10 insertions(+), 9 deletions(-)

--- a/mm/kasan/common.c~kasan-always-inline-hw_tags-helper-functions
+++ a/mm/kasan/common.c
@@ -279,7 +279,8 @@ void __kasan_poison_object_data(struct k
  *    based on objects indexes, so that objects that are next to each other
  *    get different tags.
  */
-static u8 assign_tag(struct kmem_cache *cache, const void *object, bool init)
+static __always_inline u8 assign_tag(struct kmem_cache *cache,
+					const void *object, bool init)
 {
 	if (IS_ENABLED(CONFIG_KASAN_GENERIC))
 		return 0xff;
@@ -321,8 +322,8 @@ void * __must_check __kasan_init_slab_ob
 	return (void *)object;
 }
 
-static bool ____kasan_slab_free(struct kmem_cache *cache, void *object,
-			      unsigned long ip, bool quarantine)
+static __always_inline bool ____kasan_slab_free(struct kmem_cache *cache,
+				void *object, unsigned long ip, bool quarantine)
 {
 	u8 tag;
 	void *tagged_object;
@@ -366,7 +367,7 @@ bool __kasan_slab_free(struct kmem_cache
 	return ____kasan_slab_free(cache, object, ip, true);
 }
 
-static bool ____kasan_kfree_large(void *ptr, unsigned long ip)
+static __always_inline bool ____kasan_kfree_large(void *ptr, unsigned long ip)
 {
 	if (ptr != page_address(virt_to_head_page(ptr))) {
 		kasan_report_invalid_free(ptr, ip);
@@ -461,8 +462,8 @@ void * __must_check __kasan_slab_alloc(s
 	return tagged_object;
 }
 
-static void *____kasan_kmalloc(struct kmem_cache *cache, const void *object,
-					size_t size, gfp_t flags)
+static __always_inline void *____kasan_kmalloc(struct kmem_cache *cache,
+				const void *object, size_t size, gfp_t flags)
 {
 	unsigned long redzone_start;
 	unsigned long redzone_end;
--- a/mm/kasan/kasan.h~kasan-always-inline-hw_tags-helper-functions
+++ a/mm/kasan/kasan.h
@@ -318,7 +318,7 @@ static inline u8 kasan_random_tag(void)
 
 #ifdef CONFIG_KASAN_HW_TAGS
 
-static inline void kasan_poison(const void *addr, size_t size, u8 value)
+static __always_inline void kasan_poison(const void *addr, size_t size, u8 value)
 {
 	addr = kasan_reset_tag(addr);
 
@@ -334,7 +334,7 @@ static inline void kasan_poison(const vo
 	hw_set_mem_tag_range((void *)addr, size, value);
 }
 
-static inline void kasan_unpoison(const void *addr, size_t size)
+static __always_inline void kasan_unpoison(const void *addr, size_t size)
 {
 	u8 tag = get_tag(addr);
 
@@ -349,7 +349,7 @@ static inline void kasan_unpoison(const
 	hw_set_mem_tag_range((void *)addr, size, tag);
 }
 
-static inline bool kasan_byte_accessible(const void *addr)
+static __always_inline bool kasan_byte_accessible(const void *addr)
 {
 	u8 ptr_tag = get_tag(addr);
 	u8 mem_tag = hw_get_mem_tag((void *)addr);
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-prefix-global-functions-with-kasan_.patch
kasan-clarify-hw_tags-impact-on-tbi.patch
kasan-clean-up-comments-in-tests.patch
kasan-add-macros-to-simplify-checking-test-constraints.patch
kasan-add-match-all-tag-tests.patch
kasan-arm64-allow-using-kunit-tests-with-hw_tags-mode.patch
kasan-rename-config_test_kasan_module.patch
kasan-add-compiler-barriers-to-kunit_expect_kasan_fail.patch
kasan-adapt-kmalloc_uaf2-test-to-hw_tags-mode.patch
kasan-fix-memory-corruption-in-kasan_bitops_tags-test.patch
kasan-move-_ret_ip_-to-inline-wrappers.patch
kasan-fix-bug-detection-via-ksize-for-hw_tags-mode.patch
kasan-add-proper-page-allocator-tests.patch
kasan-add-a-test-for-kmem_cache_alloc-free_bulk.patch
kasan-dont-run-tests-when-kasan-is-not-enabled.patch
kasan-mm-dont-save-alloc-stacks-twice.patch
kasan-mm-optimize-kmalloc-poisoning.patch
kasan-optimize-large-kmalloc-poisoning.patch
kasan-clean-up-setting-free-info-in-kasan_slab_free.patch
kasan-unify-large-kfree-checks.patch
kasan-rework-krealloc-tests.patch
kasan-mm-remove-krealloc-side-effect.patch
kasan-mm-optimize-krealloc-poisoning.patch
kasan-ensure-poisoning-size-alignment.patch
arm64-kasan-simplify-and-inline-mte-functions.patch
kasan-always-inline-hw_tags-helper-functions.patch
arm64-kasan-export-mte-symbols-for-kasan-tests.patch

