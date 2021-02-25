Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CBC6C433E6
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:30:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB4AB64F3F
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:30:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233839AbhBYTaP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 14:30:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:38152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234444AbhBYT1v (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 14:27:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CBC5664F8C;
        Thu, 25 Feb 2021 19:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614280555;
        bh=fR9iNih0K21vROYpv/PD8J7R/AycTtNuU2VNd2/cRZY=;
        h=Date:From:To:Subject:From;
        b=X9WP4ZX7kP/GFNGsOnXriAgOcMXt3PeQwJslqwjwEQl2GfjBJnsVbQodRk6jh6jrp
         ETmZr90eoRd3ye5Wby74hTneTNvIC9Kqkp7XPR4lg2Kh0Rvn5VUvTzhEIujS9R+3n2
         k33fpgmYNmVuI3CjceHoEQZx9odhxF+O9WxkhEJk=
Date:   Thu, 25 Feb 2021 11:15:54 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, aryabinin@virtuozzo.com,
        Branislav.Rankov@arm.com, catalin.marinas@arm.com,
        dvyukov@google.com, elver@google.com, eugenis@google.com,
        glider@google.com, kevin.brodsky@arm.com,
        mm-commits@vger.kernel.org, pcc@google.com,
        vincenzo.frascino@arm.com, will.deacon@arm.com
Subject:  [merged] kasan-add-proper-page-allocator-tests.patch
 removed from -mm tree
Message-ID: <20210225191554.4dWLjGRLM%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: add proper page allocator tests
has been removed from the -mm tree.  Its filename was
     kasan-add-proper-page-allocator-tests.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: add proper page allocator tests

The currently existing page allocator tests rely on kmalloc fallback
with large sizes that is only present for SLUB. Add proper tests that
use alloc/free_pages().

Link: https://linux-review.googlesource.com/id/Ia173d5a1b215fe6b2548d814ef0f4433cf983570
Link: https://lkml.kernel.org/r/a2648930e55ff75b8e700f2e0d905c2b55a67483.1610733117.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
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

 lib/test_kasan.c |   51 ++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 46 insertions(+), 5 deletions(-)

--- a/lib/test_kasan.c~kasan-add-proper-page-allocator-tests
+++ a/lib/test_kasan.c
@@ -147,6 +147,12 @@ static void kmalloc_node_oob_right(struc
 	kfree(ptr);
 }
 
+/*
+ * These kmalloc_pagealloc_* tests try allocating a memory chunk that doesn't
+ * fit into a slab cache and therefore is allocated via the page allocator
+ * fallback. Since this kind of fallback is only implemented for SLUB, these
+ * tests are limited to that allocator.
+ */
 static void kmalloc_pagealloc_oob_right(struct kunit *test)
 {
 	char *ptr;
@@ -154,14 +160,11 @@ static void kmalloc_pagealloc_oob_right(
 
 	KASAN_TEST_NEEDS_CONFIG_ON(test, CONFIG_SLUB);
 
-	/*
-	 * Allocate a chunk that does not fit into a SLUB cache to trigger
-	 * the page allocator fallback.
-	 */
 	ptr = kmalloc(size, GFP_KERNEL);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
 
 	KUNIT_EXPECT_KASAN_FAIL(test, ptr[size + OOB_TAG_OFF] = 0);
+
 	kfree(ptr);
 }
 
@@ -174,8 +177,8 @@ static void kmalloc_pagealloc_uaf(struct
 
 	ptr = kmalloc(size, GFP_KERNEL);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
-
 	kfree(ptr);
+
 	KUNIT_EXPECT_KASAN_FAIL(test, ptr[0] = 0);
 }
 
@@ -192,6 +195,42 @@ static void kmalloc_pagealloc_invalid_fr
 	KUNIT_EXPECT_KASAN_FAIL(test, kfree(ptr + 1));
 }
 
+static void pagealloc_oob_right(struct kunit *test)
+{
+	char *ptr;
+	struct page *pages;
+	size_t order = 4;
+	size_t size = (1UL << (PAGE_SHIFT + order));
+
+	/*
+	 * With generic KASAN page allocations have no redzones, thus
+	 * out-of-bounds detection is not guaranteed.
+	 * See https://bugzilla.kernel.org/show_bug.cgi?id=210503.
+	 */
+	KASAN_TEST_NEEDS_CONFIG_OFF(test, CONFIG_KASAN_GENERIC);
+
+	pages = alloc_pages(GFP_KERNEL, order);
+	ptr = page_address(pages);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
+
+	KUNIT_EXPECT_KASAN_FAIL(test, ptr[size] = 0);
+	free_pages((unsigned long)ptr, order);
+}
+
+static void pagealloc_uaf(struct kunit *test)
+{
+	char *ptr;
+	struct page *pages;
+	size_t order = 4;
+
+	pages = alloc_pages(GFP_KERNEL, order);
+	ptr = page_address(pages);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
+	free_pages((unsigned long)ptr, order);
+
+	KUNIT_EXPECT_KASAN_FAIL(test, ptr[0] = 0);
+}
+
 static void kmalloc_large_oob_right(struct kunit *test)
 {
 	char *ptr;
@@ -903,6 +942,8 @@ static struct kunit_case kasan_kunit_tes
 	KUNIT_CASE(kmalloc_pagealloc_oob_right),
 	KUNIT_CASE(kmalloc_pagealloc_uaf),
 	KUNIT_CASE(kmalloc_pagealloc_invalid_free),
+	KUNIT_CASE(pagealloc_oob_right),
+	KUNIT_CASE(pagealloc_uaf),
 	KUNIT_CASE(kmalloc_large_oob_right),
 	KUNIT_CASE(kmalloc_oob_krealloc_more),
 	KUNIT_CASE(kmalloc_oob_krealloc_less),
_

Patches currently in -mm which might be from andreyknvl@google.com are

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
kasan-clarify-that-only-first-bug-is-reported-in-hw_tags.patch

