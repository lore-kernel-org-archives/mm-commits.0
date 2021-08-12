Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 212EBC4338F
	for <mm-commits@archiver.kernel.org>; Thu, 12 Aug 2021 20:56:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0710C60FC3
	for <mm-commits@archiver.kernel.org>; Thu, 12 Aug 2021 20:56:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233651AbhHLU40 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 12 Aug 2021 16:56:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:48936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232611AbhHLU40 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 12 Aug 2021 16:56:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9AAE060E9B;
        Thu, 12 Aug 2021 20:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1628801760;
        bh=5KYVbJe3Kx/9ib4rtA03NkcLihPiiPBvBzpg5mSPvNs=;
        h=Date:From:To:Subject:From;
        b=aIoB3G/0n+XYI3qDRM8ljH+BjZrOyyAw+b1WE98o41mNHPRjo4YFq6jPayYuX3uRs
         QkBoyHD95lZ0YGVsP6ekZe3VN6zrOM8O2XtPe3Ws9fy9LLTDqaRzGC5k2YoqUxf+4J
         6x1s5mWGIj2TLRFmHV/OqLO2aSsErQGn5FedhHho=
Date:   Thu, 12 Aug 2021 13:56:00 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, glider@google.com, elver@google.com,
        dvyukov@google.com, aryabinin@virtuozzo.com, andreyknvl@gmail.com
Subject:  +
 kasan-test-only-do-kmalloc_uaf_memset-for-generic-mode.patch added to -mm
 tree
Message-ID: <20210812205600.Y-uDH%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: test: only do kmalloc_uaf_memset for generic mode
has been added to the -mm tree.  Its filename is
     kasan-test-only-do-kmalloc_uaf_memset-for-generic-mode.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-test-only-do-kmalloc_uaf_memset-for-generic-mode.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-test-only-do-kmalloc_uaf_memset-for-generic-mode.patch

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
Subject: kasan: test: only do kmalloc_uaf_memset for generic mode

kmalloc_uaf_memset() writes to freed memory, which is only safe with the
GENERIC mode (as it uses quarantine).  For other modes, this test corrupts
kernel memory, which might result in a crash.

Only enable kmalloc_uaf_memset() for the GENERIC mode.

Link: https://lkml.kernel.org/r/2e1c87b607b1292556cde3cab2764f108542b60c.1628779805.git.andreyknvl@gmail.com
Signed-off-by: Andrey Konovalov <andreyknvl@gmail.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_kasan.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/lib/test_kasan.c~kasan-test-only-do-kmalloc_uaf_memset-for-generic-mode
+++ a/lib/test_kasan.c
@@ -534,6 +534,12 @@ static void kmalloc_uaf_memset(struct ku
 	char *ptr;
 	size_t size = 33;
 
+	/*
+	 * Only generic KASAN uses quarantine, which is required to avoid a
+	 * kernel memory corruption this test causes.
+	 */
+	KASAN_TEST_NEEDS_CONFIG_ON(test, CONFIG_KASAN_GENERIC);
+
 	ptr = kmalloc(size, GFP_KERNEL);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
 
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

