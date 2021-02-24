Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D5A5C433DB
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:07:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A08964F08
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:07:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235279AbhBXUHv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:07:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:59402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234283AbhBXUHR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 15:07:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A1A1664F0E;
        Wed, 24 Feb 2021 20:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614197156;
        bh=iXxCAfUagaaNEkYZ2Acgf0LD3UD8IMv4eWVMhOt8pPM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=o09mvRr+PulX4UxT/0HS6phu22cd6Uhe3+7yvEFo3NHv7ucRoy3WYvjvlTtdGV+W8
         EtjaqpwXv88FUwboKKXsRmWOaw+FrsNoL4o1iJCOi2NpXDvFP7LuWL4e/EMx56oWlG
         jBn5dwusjpw9O8zdV0lqCfk4kQRyUuk3j9CVUJyo=
Date:   Wed, 24 Feb 2021 12:05:55 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@google.com,
        aryabinin@virtuozzo.com, Branislav.Rankov@arm.com,
        catalin.marinas@arm.com, dvyukov@google.com, elver@google.com,
        eugenis@google.com, glider@google.com, kevin.brodsky@arm.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, pcc@google.com,
        torvalds@linux-foundation.org, vincenzo.frascino@arm.com,
        will.deacon@arm.com
Subject:  [patch 098/173] kasan: add proper page allocator tests
Message-ID: <20210224200555.zQSVpXkxz%akpm@linux-foundation.org>
In-Reply-To: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
