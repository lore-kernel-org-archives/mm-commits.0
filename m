Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2043DC433E6
	for <mm-commits@archiver.kernel.org>; Sun, 17 Jan 2021 20:00:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D7D4F224DE
	for <mm-commits@archiver.kernel.org>; Sun, 17 Jan 2021 20:00:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729856AbhAQUAQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jan 2021 15:00:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:45136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730181AbhAQUAO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 17 Jan 2021 15:00:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 29F3C2250E;
        Sun, 17 Jan 2021 19:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1610913554;
        bh=ps1AXx9xFQk4MTfShLYiWA5iJHurA1i6XZdTWFWLTvQ=;
        h=Date:From:To:Subject:From;
        b=R74zAjXf/3BmQyVJ7VKXdEw22kCkY+AgvJ3GxdCJJCB7hOuk7+wFeQZtTFO5x1Zf1
         zyagnVwA5jtXoG8x630yf2E950aIk1aQFXazv/LEdjAgRLm+iLtxUetYPWMcgAnENC
         PlSfAPgXdyMc2DLjRGFt/k/cMxDuOEVCQoQYPjDM=
Date:   Sun, 17 Jan 2021 11:59:12 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, aryabinin@virtuozzo.com,
        Branislav.Rankov@arm.com, catalin.marinas@arm.com,
        dvyukov@google.com, elver@google.com, eugenis@google.com,
        glider@google.com, kevin.brodsky@arm.com,
        mm-commits@vger.kernel.org, vincenzo.frascino@arm.com,
        will.deacon@arm.com
Subject:  [to-be-updated]
 kasan-add-compiler-barriers-to-kunit_expect_kasan_fail.patch removed from
 -mm tree
Message-ID: <20210117195912.x4US638Y6%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: add compiler barriers to KUNIT_EXPECT_KASAN_FAIL
has been removed from the -mm tree.  Its filename was
     kasan-add-compiler-barriers-to-kunit_expect_kasan_fail.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: add compiler barriers to KUNIT_EXPECT_KASAN_FAIL

It might not be obvious to the compiler that the expression must be
executed between writing and reading to fail_data. In this case, the
compiler might reorder or optimize away some of the accesses, and
the tests will fail.

Add compiler barriers around the expression in KUNIT_EXPECT_KASAN_FAIL.

Link: https://lkml.kernel.org/r/a37dab02f89ad93cc986a87866da74fb8be1850d.1609871239.git.andreyknvl@google.com
Link: https://linux-review.googlesource.com/id/I046079f48641a1d36fe627fc8827a9249102fd50Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
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

 lib/test_kasan.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/lib/test_kasan.c~kasan-add-compiler-barriers-to-kunit_expect_kasan_fail
+++ a/lib/test_kasan.c
@@ -79,7 +79,9 @@ static void kasan_test_exit(struct kunit
 				NULL,				\
 				&resource,			\
 				"kasan_data", &fail_data);	\
+	barrier();						\
 	expression;						\
+	barrier();						\
 	KUNIT_EXPECT_EQ(test,					\
 			fail_data.report_expected,		\
 			fail_data.report_found);		\
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-fix-hw_tags-boot-parameters.patch
kasan-adopt-kmalloc_uaf2-test-to-hw_tags-mode.patch
kasan-fix-memory-corruption-in-kasan_bitops_tags-test.patch
kasan-fix-bug-detection-via-ksize-for-hw_tags-mode.patch
kasan-add-proper-page-allocator-tests.patch

