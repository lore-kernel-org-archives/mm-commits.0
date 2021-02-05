Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D6EFC433DB
	for <mm-commits@archiver.kernel.org>; Fri,  5 Feb 2021 21:20:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E3BC764FB9
	for <mm-commits@archiver.kernel.org>; Fri,  5 Feb 2021 21:20:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233088AbhBEVUH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Feb 2021 16:20:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:44834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233798AbhBEVTE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Feb 2021 16:19:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1FCC864FBB;
        Fri,  5 Feb 2021 21:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1612559903;
        bh=tc0Ups7iy39l5U+NUVHQ0J/Z1FkZUnaOqbyQn9K/nKI=;
        h=Date:From:To:Subject:From;
        b=TGBP8K99Z8Sy6ugR5A546tW1lE7NXgV+dNbLVbDSihNwniLA+j+nIvAV8lMmLaoSU
         fnOb1+zmVbVMawsSj7AtMbrcSkkRLYmpzdw/OEnhF2QPzUiOed3a7SihLyLkKI1lQT
         E7h+mDPJvCIroHLuL+0e4GJjakljOF49Lis3uhyE=
Date:   Fri, 05 Feb 2021 13:18:22 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, aryabinin@virtuozzo.com,
        Branislav.Rankov@arm.com, catalin.marinas@arm.com,
        dvyukov@google.com, elver@google.com, eugenis@google.com,
        glider@google.com, kevin.brodsky@arm.com,
        mm-commits@vger.kernel.org, pcc@google.com,
        vincenzo.frascino@arm.com, will.deacon@arm.com
Subject:  + kasan-unify-large-kfree-checks.patch added to -mm tree
Message-ID: <20210205211822.poO8iULsn%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: unify large kfree checks
has been added to the -mm tree.  Its filename is
     kasan-unify-large-kfree-checks.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-unify-large-kfree-checks.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-unify-large-kfree-checks.patch

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
Subject: kasan: unify large kfree checks

Unify checks in kasan_kfree_large() and in kasan_slab_free_mempool() for
large allocations as it's done for small kfree() allocations.

With this change, kasan_slab_free_mempool() starts checking that the first
byte of the memory that's being freed is accessible.

Link: https://lkml.kernel.org/r/14ffc4cd867e0b1ed58f7527e3b748a1b4ad08aa.1612546384.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Branislav Rankov <Branislav.Rankov@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Peter Collingbourne <pcc@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kasan.h |   16 ++++++++--------
 mm/kasan/common.c     |   36 ++++++++++++++++++++++++++----------
 2 files changed, 34 insertions(+), 18 deletions(-)

--- a/include/linux/kasan.h~kasan-unify-large-kfree-checks
+++ a/include/linux/kasan.h
@@ -200,6 +200,13 @@ static __always_inline bool kasan_slab_f
 	return false;
 }
 
+void __kasan_kfree_large(void *ptr, unsigned long ip);
+static __always_inline void kasan_kfree_large(void *ptr)
+{
+	if (kasan_enabled())
+		__kasan_kfree_large(ptr, _RET_IP_);
+}
+
 void __kasan_slab_free_mempool(void *ptr, unsigned long ip);
 static __always_inline void kasan_slab_free_mempool(void *ptr)
 {
@@ -247,13 +254,6 @@ static __always_inline void * __must_che
 	return (void *)object;
 }
 
-void __kasan_kfree_large(void *ptr, unsigned long ip);
-static __always_inline void kasan_kfree_large(void *ptr)
-{
-	if (kasan_enabled())
-		__kasan_kfree_large(ptr, _RET_IP_);
-}
-
 /*
  * Unlike kasan_check_read/write(), kasan_check_byte() is performed even for
  * the hardware tag-based mode that doesn't rely on compiler instrumentation.
@@ -302,6 +302,7 @@ static inline bool kasan_slab_free(struc
 {
 	return false;
 }
+static inline void kasan_kfree_large(void *ptr) {}
 static inline void kasan_slab_free_mempool(void *ptr) {}
 static inline void *kasan_slab_alloc(struct kmem_cache *s, void *object,
 				   gfp_t flags)
@@ -322,7 +323,6 @@ static inline void *kasan_krealloc(const
 {
 	return (void *)object;
 }
-static inline void kasan_kfree_large(void *ptr) {}
 static inline bool kasan_check_byte(const void *address)
 {
 	return true;
--- a/mm/kasan/common.c~kasan-unify-large-kfree-checks
+++ a/mm/kasan/common.c
@@ -364,6 +364,31 @@ bool __kasan_slab_free(struct kmem_cache
 	return ____kasan_slab_free(cache, object, ip, true);
 }
 
+static bool ____kasan_kfree_large(void *ptr, unsigned long ip)
+{
+	if (ptr != page_address(virt_to_head_page(ptr))) {
+		kasan_report_invalid_free(ptr, ip);
+		return true;
+	}
+
+	if (!kasan_byte_accessible(ptr)) {
+		kasan_report_invalid_free(ptr, ip);
+		return true;
+	}
+
+	/*
+	 * The object will be poisoned by kasan_free_pages() or
+	 * kasan_slab_free_mempool().
+	 */
+
+	return false;
+}
+
+void __kasan_kfree_large(void *ptr, unsigned long ip)
+{
+	____kasan_kfree_large(ptr, ip);
+}
+
 void __kasan_slab_free_mempool(void *ptr, unsigned long ip)
 {
 	struct page *page;
@@ -377,10 +402,8 @@ void __kasan_slab_free_mempool(void *ptr
 	 * KMALLOC_MAX_SIZE, and kmalloc falls back onto page_alloc.
 	 */
 	if (unlikely(!PageSlab(page))) {
-		if (ptr != page_address(page)) {
-			kasan_report_invalid_free(ptr, ip);
+		if (____kasan_kfree_large(ptr, ip))
 			return;
-		}
 		kasan_poison(ptr, page_size(page), KASAN_FREE_PAGE);
 	} else {
 		____kasan_slab_free(page->slab_cache, ptr, ip, false);
@@ -539,13 +562,6 @@ void * __must_check __kasan_krealloc(con
 		return ____kasan_kmalloc(page->slab_cache, object, size, flags);
 }
 
-void __kasan_kfree_large(void *ptr, unsigned long ip)
-{
-	if (ptr != page_address(virt_to_head_page(ptr)))
-		kasan_report_invalid_free(ptr, ip);
-	/* The object will be poisoned by kasan_free_pages(). */
-}
-
 bool __kasan_check_byte(const void *address, unsigned long ip)
 {
 	if (!kasan_byte_accessible(address)) {
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

