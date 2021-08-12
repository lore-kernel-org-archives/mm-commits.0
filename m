Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23CE8C4338F
	for <mm-commits@archiver.kernel.org>; Thu, 12 Aug 2021 20:56:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0901860F35
	for <mm-commits@archiver.kernel.org>; Thu, 12 Aug 2021 20:56:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234006AbhHLU4a (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 12 Aug 2021 16:56:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:48972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232611AbhHLU42 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 12 Aug 2021 16:56:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9911D60C41;
        Thu, 12 Aug 2021 20:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1628801762;
        bh=IoEh0cdMFy2VQUXfZsUe2T0MJAtR4LyfbeR3dFiks7o=;
        h=Date:From:To:Subject:From;
        b=E5EG4FPi4wZeiJdu65y1PYATfABs+SMA/2Bg7MNPv6X6J4lMxM1SQdXbdi3+bttNL
         GmryGluNd7u/yom6uScGfYDPCLFjcL9GwYx/LSmittWYlB/EXReVh780k44BTMoquL
         Xy4uS8RjhK5XIg3E5cSnSYebiFJm8bnU/anmS1dk=
Date:   Thu, 12 Aug 2021 13:56:02 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, glider@google.com, elver@google.com,
        dvyukov@google.com, aryabinin@virtuozzo.com, andreyknvl@gmail.com
Subject:  + kasan-test-clean-up-ksize_uaf.patch added to -mm tree
Message-ID: <20210812205602.0BPug%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: test: clean up ksize_uaf
has been added to the -mm tree.  Its filename is
     kasan-test-clean-up-ksize_uaf.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-test-clean-up-ksize_uaf.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-test-clean-up-ksize_uaf.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@gmail.com>
Subject: kasan: test: clean up ksize_uaf

Some KASAN tests use global variables to store function returns values so
that the compiler doesn't optimize away these functions.

ksize_uaf() doesn't call any functions, so it doesn't need to use
kasan_int_result.  Use volatile accesses instead, to be consistent with
other similar tests.

Link: https://lkml.kernel.org/r/a1fc34faca4650f4a6e4dfb3f8d8d82c82eb953a.1628779805.git.andreyknvl@gmail.com
Signed-off-by: Andrey Konovalov <andreyknvl@gmail.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_kasan.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/lib/test_kasan.c~kasan-test-clean-up-ksize_uaf
+++ a/lib/test_kasan.c
@@ -737,8 +737,8 @@ static void ksize_uaf(struct kunit *test
 	kfree(ptr);
 
 	KUNIT_EXPECT_KASAN_FAIL(test, ksize(ptr));
-	KUNIT_EXPECT_KASAN_FAIL(test, kasan_int_result = *ptr);
-	KUNIT_EXPECT_KASAN_FAIL(test, kasan_int_result = *(ptr + size));
+	KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr)[0]);
+	KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr)[size]);
 }
 
 static void kasan_stack_oob(struct kunit *test)
_

Patches currently in -mm which might be from andreyknvl@gmail.com are

kasan-test-rework-kmalloc_oob_right.patch
kasan-test-avoid-writing-invalid-memory.patch
kasan-test-avoid-corrupting-memory-via-memset.patch
kasan-test-disable-kmalloc_memmove_invalid_size-for-hw_tags.patch
kasan-test-only-do-kmalloc_uaf_memset-for-generic-mode.patch
kasan-test-clean-up-ksize_uaf.patch
kasan-test-avoid-corrupting-memory-in-copy_user_test.patch
kasan-test-avoid-corrupting-memory-in-kasan_rcu_uaf.patch

