Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81B8AC433E6
	for <mm-commits@archiver.kernel.org>; Wed,  6 Jan 2021 00:12:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5BE7F22E03
	for <mm-commits@archiver.kernel.org>; Wed,  6 Jan 2021 00:12:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726255AbhAFAMV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 5 Jan 2021 19:12:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:44162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726098AbhAFAMU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 5 Jan 2021 19:12:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 12F7B230FC;
        Wed,  6 Jan 2021 00:11:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1609891878;
        bh=2QQdlnTsYCCtiZ212TzcrjEc8XWFG3+b9nC5y7SkpDo=;
        h=Date:From:To:Subject:From;
        b=BWB/D0sodFCJkSbfT5kDKgmvqK8Ql/Qmdre3OvkgH4baIkZtcJxVLQ33YF02ey2nD
         GLZnfApDAV/inVyJT3NMBnKZlYwK3z9k9WjTppMAXtxjSsKEBWFhM95/lzmsfkRHXH
         rMPkGdt1sg4F2CTmMcikwR9cip3IYFx4b+QnIPAU=
Date:   Tue, 05 Jan 2021 16:11:17 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, aryabinin@virtuozzo.com,
        Branislav.Rankov@arm.com, catalin.marinas@arm.com,
        dvyukov@google.com, elver@google.com, eugenis@google.com,
        glider@google.com, kevin.brodsky@arm.com,
        mm-commits@vger.kernel.org, vincenzo.frascino@arm.com,
        will.deacon@arm.com
Subject:  + kasan-adopt-kmalloc_uaf2-test-to-hw_tags-mode.patch
 added to -mm tree
Message-ID: <20210106001117.Nwastq0c3%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: adopt kmalloc_uaf2 test to HW_TAGS mode
has been added to the -mm tree.  Its filename is
     kasan-adopt-kmalloc_uaf2-test-to-hw_tags-mode.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-adopt-kmalloc_uaf2-test-to-hw_tags-mode.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-adopt-kmalloc_uaf2-test-to-hw_tags-mode.patch

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
Subject: kasan: adopt kmalloc_uaf2 test to HW_TAGS mode

In the kmalloc_uaf2() test, the pointers to the two allocated memory
blocks might be the same, and the test will fail. With the software
tag-based mode, the probability of the that happening is 1/254, so it's
hard to observe the failure. For the hardware tag-based mode though,
the probablity is 1/14, which is quite noticable.

Allow up to 4 attempts at generating different tags for the tag-based
modes.

Link: https://lkml.kernel.org/r/9a4f47fe8717b4b249591b307cdd1f26c46dcb82.1609871239.git.andreyknvl@google.com
Link: https://linux-review.googlesource.com/id/Ibfa458ef2804ff465d8eb07434a300bf36388d55Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
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

 lib/test_kasan.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/lib/test_kasan.c~kasan-adopt-kmalloc_uaf2-test-to-hw_tags-mode
+++ a/lib/test_kasan.c
@@ -375,7 +375,9 @@ static void kmalloc_uaf2(struct kunit *t
 {
 	char *ptr1, *ptr2;
 	size_t size = 43;
+	int counter = 0;
 
+again:
 	ptr1 = kmalloc(size, GFP_KERNEL);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr1);
 
@@ -384,6 +386,13 @@ static void kmalloc_uaf2(struct kunit *t
 	ptr2 = kmalloc(size, GFP_KERNEL);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr2);
 
+	/*
+	 * For tag-based KASAN ptr1 and ptr2 tags might happen to be the same.
+	 * Allow up to 4 attempts at generating different tags.
+	 */
+	if (!IS_ENABLED(CONFIG_KASAN_GENERIC) && ptr1 == ptr2 && counter++ < 4)
+		goto again;
+
 	KUNIT_EXPECT_KASAN_FAIL(test, ptr1[40] = 'x');
 	KUNIT_EXPECT_PTR_NE(test, ptr1, ptr2);
 
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-prefix-exported-functions-with-kasan_.patch
kasan-clarify-hw_tags-impact-on-tbi.patch
kasan-clean-up-comments-in-tests.patch
kasan-add-match-all-tag-tests.patch
kasan-arm64-allow-using-kunit-tests-with-hw_tags-mode.patch
kasan-rename-config_test_kasan_module.patch
kasan-add-compiler-barriers-to-kunit_expect_kasan_fail.patch
kasan-adopt-kmalloc_uaf2-test-to-hw_tags-mode.patch
kasan-fix-memory-corruption-in-kasan_bitops_tags-test.patch
kasan-fix-bug-detection-via-ksize-for-hw_tags-mode.patch
kasan-add-proper-page-allocator-tests.patch

