Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE610C433E9
	for <mm-commits@archiver.kernel.org>; Fri,  5 Feb 2021 21:20:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B75FE64FBB
	for <mm-commits@archiver.kernel.org>; Fri,  5 Feb 2021 21:20:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233113AbhBEVUg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Feb 2021 16:20:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:45102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233125AbhBEVUQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Feb 2021 16:20:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2432264FC6;
        Fri,  5 Feb 2021 21:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1612559909;
        bh=H+nvbqtHceq49U26FGWQ4uVE6Z5g5rO6y0mi18jPMv4=;
        h=Date:From:To:Subject:From;
        b=IxnFUVUWuOgl7AVgX1WSAssWyrIjK3+q/wpTUuip8tklKjeM5/2IyYx2vSaDzotEq
         WfFcoc3KyRFWh/cs/6GCkgz9tl20rb2DcE8j4kF7jCDeryq2TKhN6jeHycZ5sLLk27
         KDwbkbN2H3UVKSmVX0OkyKI/8jAUsQ62HXWl9Ikw=
Date:   Fri, 05 Feb 2021 13:18:28 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, aryabinin@virtuozzo.com,
        Branislav.Rankov@arm.com, catalin.marinas@arm.com,
        dvyukov@google.com, elver@google.com, eugenis@google.com,
        glider@google.com, kevin.brodsky@arm.com,
        mm-commits@vger.kernel.org, pcc@google.com,
        vincenzo.frascino@arm.com, will.deacon@arm.com
Subject:  + kasan-mm-fail-krealloc-on-freed-objects.patch added to
 -mm tree
Message-ID: <20210205211828.zrjK-CTm6%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan, mm: fail krealloc on freed objects
has been added to the -mm tree.  Its filename is
     kasan-mm-fail-krealloc-on-freed-objects.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-mm-fail-krealloc-on-freed-objects.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-mm-fail-krealloc-on-freed-objects.patch

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
Subject: kasan, mm: fail krealloc on freed objects

Currently, if krealloc() is called on a freed object with KASAN enabled,
it allocates and returns a new object, but doesn't copy any memory from
the old one as ksize() returns 0.  This makes the caller believe that
krealloc() succeeded (KASAN report is printed though).

This patch adds an accessibility check into __do_krealloc().  If the check
fails, krealloc() returns NULL.  This check duplicates the one in ksize();
this is fixed in the following patch.

This patch also adds a KASAN-KUnit test to check krealloc() behaviour when
it's called on a freed object.

Link: https://lkml.kernel.org/r/cbcf7b02be0a1ca11de4f833f2ff0b3f2c9b00c8.1612546384.git.andreyknvl@google.com
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

 lib/test_kasan.c |   20 ++++++++++++++++++++
 mm/slab_common.c |    3 +++
 2 files changed, 23 insertions(+)

--- a/lib/test_kasan.c~kasan-mm-fail-krealloc-on-freed-objects
+++ a/lib/test_kasan.c
@@ -353,6 +353,25 @@ static void krealloc_pagealloc_less_oob(
 					KMALLOC_MAX_CACHE_SIZE + 201);
 }
 
+/*
+ * Check that krealloc() detects a use-after-free, returns NULL,
+ * and doesn't unpoison the freed object.
+ */
+static void krealloc_uaf(struct kunit *test)
+{
+	char *ptr1, *ptr2;
+	int size1 = 201;
+	int size2 = 235;
+
+	ptr1 = kmalloc(size1, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr1);
+	kfree(ptr1);
+
+	KUNIT_EXPECT_KASAN_FAIL(test, ptr2 = krealloc(ptr1, size2, GFP_KERNEL));
+	KUNIT_ASSERT_PTR_EQ(test, (void *)ptr2, NULL);
+	KUNIT_EXPECT_KASAN_FAIL(test, *(volatile char *)ptr1);
+}
+
 static void kmalloc_oob_16(struct kunit *test)
 {
 	struct {
@@ -1050,6 +1069,7 @@ static struct kunit_case kasan_kunit_tes
 	KUNIT_CASE(krealloc_less_oob),
 	KUNIT_CASE(krealloc_pagealloc_more_oob),
 	KUNIT_CASE(krealloc_pagealloc_less_oob),
+	KUNIT_CASE(krealloc_uaf),
 	KUNIT_CASE(kmalloc_oob_16),
 	KUNIT_CASE(kmalloc_uaf_16),
 	KUNIT_CASE(kmalloc_oob_in_memset),
--- a/mm/slab_common.c~kasan-mm-fail-krealloc-on-freed-objects
+++ a/mm/slab_common.c
@@ -1061,6 +1061,9 @@ static __always_inline void *__do_kreall
 	void *ret;
 	size_t ks;
 
+	if (likely(!ZERO_OR_NULL_PTR(p)) && !kasan_check_byte(p))
+		return NULL;
+
 	ks = ksize(p);
 
 	if (ks >= new_size) {
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

