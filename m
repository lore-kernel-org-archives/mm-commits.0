Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B198C433E0
	for <mm-commits@archiver.kernel.org>; Sun, 17 Jan 2021 20:00:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 144FA224BD
	for <mm-commits@archiver.kernel.org>; Sun, 17 Jan 2021 20:00:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730191AbhAQUAc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jan 2021 15:00:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:45192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730192AbhAQUAa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 17 Jan 2021 15:00:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EC1F0224BD;
        Sun, 17 Jan 2021 19:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1610913575;
        bh=pBhfNsbV+09ak1xy2EnHO55C/vsgqRay+EkvQcmuVp0=;
        h=Date:From:To:Subject:From;
        b=qml2b1Iexhdpx53v64RP3mXBN8UrngyurDYO7vR9KglCEJu/me0hTXc2uHI5lhR3V
         Njw95wC4dgGJsItX/5SdfTUnYed2+nMFwMNB5dzvSV+U4LH95jG8YohtVgQsaqBVwx
         +GmSK7GX5L+ewmXHOIySpS9c1lvdFXee4RWX8dB4=
Date:   Sun, 17 Jan 2021 11:59:34 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, aryabinin@virtuozzo.com,
        Branislav.Rankov@arm.com, catalin.marinas@arm.com,
        dvyukov@google.com, elver@google.com, eugenis@google.com,
        glider@google.com, kevin.brodsky@arm.com,
        mm-commits@vger.kernel.org, vincenzo.frascino@arm.com,
        will.deacon@arm.com
Subject:  [to-be-updated]
 kasan-add-proper-page-allocator-tests.patch removed from -mm tree
Message-ID: <20210117195934.XsDpJpubD%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: add proper page allocator tests
has been removed from the -mm tree.  Its filename was
     kasan-add-proper-page-allocator-tests.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: add proper page allocator tests

The currently existing page allocator tests rely on kmalloc fallback
with large sizes that is only present for SLUB. Add proper tests that
use alloc/free_pages().

Link: https://lkml.kernel.org/r/15ca1976b26aa9edcec4a9d0f3b73f5b6536e5d0.1609871239.git.andreyknvl@google.com
Link: https://linux-review.googlesource.com/id/Ia173d5a1b215fe6b2548d814ef0f4433cf983570
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
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

 lib/test_kasan.c |   54 ++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 49 insertions(+), 5 deletions(-)

--- a/lib/test_kasan.c~kasan-add-proper-page-allocator-tests
+++ a/lib/test_kasan.c
@@ -128,6 +128,12 @@ static void kmalloc_node_oob_right(struc
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
@@ -138,14 +144,11 @@ static void kmalloc_pagealloc_oob_right(
 		return;
 	}
 
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
 
@@ -161,8 +164,8 @@ static void kmalloc_pagealloc_uaf(struct
 
 	ptr = kmalloc(size, GFP_KERNEL);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
-
 	kfree(ptr);
+
 	KUNIT_EXPECT_KASAN_FAIL(test, ptr[0] = 0);
 }
 
@@ -182,6 +185,45 @@ static void kmalloc_pagealloc_invalid_fr
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
+	if (IS_ENABLED(CONFIG_KASAN_GENERIC)) {
+		kunit_info(test, "skipping, CONFIG_KASAN_GENERIC enabled");
+		return;
+	}
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
@@ -933,6 +975,8 @@ static struct kunit_case kasan_kunit_tes
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

kasan-fix-hw_tags-boot-parameters.patch

