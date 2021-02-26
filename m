Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C415CC43381
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:22:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 86D6B64F35
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:22:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229947AbhBZBWU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 20:22:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:53282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229996AbhBZBVC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 20:21:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 47DA064F14;
        Fri, 26 Feb 2021 01:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614302421;
        bh=qfl88ZsBzHgLKPqiqjeNn8fgYrxmCNiFgXomg8Be5fE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=JiPnxTrv5Q9f9svCHRcfS4UJ/KxLbsjSUZ8eEfMudmP2Go4grTckRa/vcN1Ro8PZd
         JdeYI5kOhQwtr8/PbfSK8I4LkXfdXmdy92eXa2uaUspFoBis3U+aMlzcW14m+s4zke
         EQ07Na/IhpMK55t/187kege9I3Be2ZHYDs2gy12Y=
Date:   Thu, 25 Feb 2021 17:20:19 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@google.com,
        aryabinin@virtuozzo.com, Branislav.Rankov@arm.com,
        catalin.marinas@arm.com, dvyukov@google.com, elver@google.com,
        eugenis@google.com, glider@google.com, kevin.brodsky@arm.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, pcc@google.com,
        torvalds@linux-foundation.org, vincenzo.frascino@arm.com,
        will.deacon@arm.com
Subject:  [patch 076/118] kasan, mm: fail krealloc on freed objects
Message-ID: <20210226012019.Lz0JPHhz3%akpm@linux-foundation.org>
In-Reply-To: <20210225171452.713967e96554bb6a53e44a19@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
@@ -1136,6 +1136,9 @@ static __always_inline void *__do_kreall
 	void *ret;
 	size_t ks;
 
+	if (likely(!ZERO_OR_NULL_PTR(p)) && !kasan_check_byte(p))
+		return NULL;
+
 	ks = ksize(p);
 
 	if (ks >= new_size) {
_
