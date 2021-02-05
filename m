Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D361DC43381
	for <mm-commits@archiver.kernel.org>; Fri,  5 Feb 2021 21:22:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A9E6B64FB9
	for <mm-commits@archiver.kernel.org>; Fri,  5 Feb 2021 21:22:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232861AbhBEVWW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Feb 2021 16:22:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:45204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233556AbhBEVU3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Feb 2021 16:20:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D579664FCD;
        Fri,  5 Feb 2021 21:18:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1612559925;
        bh=09fwlS06GRNi/rpCunAQOj9ARQndaB759Ka/L3Ef090=;
        h=Date:From:To:Subject:From;
        b=pdZ0aCinuk8aDzhsTFwYBY7ri2ZmJNCmv/+NiM0Jif1gnL/h5nHGjE97mJ4GFr2pd
         +JnY6qY0Ffu/x9TsSPiYNjgQyasUig9UL7Ri123delH28UGfMHS3fgnvUg160zu9gE
         xfKsUTExpyqM91fi00MncVKrklHqED+L0/TYnn4Q=
Date:   Fri, 05 Feb 2021 13:18:44 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, aryabinin@virtuozzo.com,
        Branislav.Rankov@arm.com, catalin.marinas@arm.com,
        dvyukov@google.com, elver@google.com, eugenis@google.com,
        glider@google.com, kevin.brodsky@arm.com,
        mm-commits@vger.kernel.org, pcc@google.com,
        vincenzo.frascino@arm.com, will.deacon@arm.com
Subject:  + kasan-inline-hw_tags-helper-functions.patch added to
 -mm tree
Message-ID: <20210205211844.nEumJIQhK%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: inline HW_TAGS helper functions
has been added to the -mm tree.  Its filename is
     kasan-inline-hw_tags-helper-functions.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-inline-hw_tags-helper-functions.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-inline-hw_tags-helper-functions.patch

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
Subject: kasan: inline HW_TAGS helper functions

Mark all static functions in common.c and kasan.h that are used for
hardware tag-based KASAN as inline to avoid unnecessary function calls.

Link: https://lkml.kernel.org/r/2c94a2af0657f2b95b9337232339ff5ffa643ab5.1612546384.git.andreyknvl@google.com
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
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/mm/kasan/common.c~kasan-inline-hw_tags-helper-functions
+++ a/mm/kasan/common.c
@@ -279,7 +279,8 @@ void __kasan_poison_object_data(struct k
  *    based on objects indexes, so that objects that are next to each other
  *    get different tags.
  */
-static u8 assign_tag(struct kmem_cache *cache, const void *object, bool init)
+static inline u8 assign_tag(struct kmem_cache *cache,
+					const void *object, bool init)
 {
 	if (IS_ENABLED(CONFIG_KASAN_GENERIC))
 		return 0xff;
@@ -321,8 +322,8 @@ void * __must_check __kasan_init_slab_ob
 	return (void *)object;
 }
 
-static bool ____kasan_slab_free(struct kmem_cache *cache, void *object,
-			      unsigned long ip, bool quarantine)
+static inline bool ____kasan_slab_free(struct kmem_cache *cache,
+				void *object, unsigned long ip, bool quarantine)
 {
 	u8 tag;
 	void *tagged_object;
@@ -366,7 +367,7 @@ bool __kasan_slab_free(struct kmem_cache
 	return ____kasan_slab_free(cache, object, ip, true);
 }
 
-static bool ____kasan_kfree_large(void *ptr, unsigned long ip)
+static inline bool ____kasan_kfree_large(void *ptr, unsigned long ip)
 {
 	if (ptr != page_address(virt_to_head_page(ptr))) {
 		kasan_report_invalid_free(ptr, ip);
@@ -461,8 +462,8 @@ void * __must_check __kasan_slab_alloc(s
 	return tagged_object;
 }
 
-static void *____kasan_kmalloc(struct kmem_cache *cache, const void *object,
-					size_t size, gfp_t flags)
+static inline void *____kasan_kmalloc(struct kmem_cache *cache,
+				const void *object, size_t size, gfp_t flags)
 {
 	unsigned long redzone_start;
 	unsigned long redzone_end;
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
kfence-kasan-make-kfence-compatible-with-kasan-fix-2.patch
kasan-mm-dont-save-alloc-stacks-twice.patch
kasan-mm-optimize-kmalloc-poisoning.patch
kasan-optimize-large-kmalloc-poisoning.patch
kasan-clean-up-setting-free-info-in-kasan_slab_free.patch
kasan-unify-large-kfree-checks.patch
kasan-rework-krealloc-tests.patch
kasan-mm-fail-krealloc-on-freed-objects.patch
kasan-mm-optimize-krealloc-poisoning.patch
kasan-ensure-poisoning-size-alignment.patch
arm64-kasan-simplify-and-inline-mte-functions.patch
kasan-inline-hw_tags-helper-functions.patch
arm64-kasan-export-mte-symbols-for-kasan-tests.patch
kasan-clarify-that-only-first-bug-is-reported-in-hw_tags.patch

