Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71A1FC433DB
	for <mm-commits@archiver.kernel.org>; Wed,  6 Jan 2021 00:12:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 36EDD22D74
	for <mm-commits@archiver.kernel.org>; Wed,  6 Jan 2021 00:12:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726059AbhAFAMQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 5 Jan 2021 19:12:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:44154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726051AbhAFAMQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 5 Jan 2021 19:12:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 199A0230FB;
        Wed,  6 Jan 2021 00:11:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1609891875;
        bh=JX7kV74BlkM4bkWrZaEnnbPCXo69NG0Tlond6dtFiVU=;
        h=Date:From:To:Subject:From;
        b=V46hxw4WwnJARGXMKe+4bT4pMO+eI1QUo6HklzAfL2P4pDvNHn54T49zrAIwFordk
         +DUbjOOH4379AULjOJzlACVd+TQMiAaD+kYUhrHYxtERH+MCh1tXwYXTOimAvoK7i2
         X03JCyqCxIjSC68qKJMNF0NffWqY6HHkDNLbvb9w=
Date:   Tue, 05 Jan 2021 16:11:13 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, aryabinin@virtuozzo.com,
        Branislav.Rankov@arm.com, catalin.marinas@arm.com,
        dvyukov@google.com, elver@google.com, eugenis@google.com,
        glider@google.com, kevin.brodsky@arm.com,
        mm-commits@vger.kernel.org, vincenzo.frascino@arm.com,
        will.deacon@arm.com
Subject:  +
 kasan-add-compiler-barriers-to-kunit_expect_kasan_fail.patch added to -mm
 tree
Message-ID: <20210106001113.QfGDV0l_M%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: add compiler barriers to KUNIT_EXPECT_KASAN_FAIL
has been added to the -mm tree.  Its filename is
     kasan-add-compiler-barriers-to-kunit_expect_kasan_fail.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-add-compiler-barriers-to-kunit_expect_kasan_fail.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-add-compiler-barriers-to-kunit_expect_kasan_fail.patch

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

