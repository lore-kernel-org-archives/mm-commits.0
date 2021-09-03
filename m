Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0448C433F5
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:59:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 865F161131
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:59:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350017AbhICVAZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 17:00:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:59130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239176AbhICVAX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Sep 2021 17:00:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7E76361107;
        Fri,  3 Sep 2021 20:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630702762;
        bh=Aa2203rOQS7LtsF+l7t1+t86w/kic2qf+3dB7eIC/tc=;
        h=Date:From:To:Subject:From;
        b=RaLBdb0/VWJMG7aX+6wj3YmDMVQZR6Yp7iRhH/8HANlot1Sm6mtkAOTrRR6/Qu42m
         p5n2wKZT4tF2O8QdcgBx2sSjQ2Czvw8GNLCvjUgRj3/FHw0huG+/wl3XN9o+IdtKyZ
         mRts9zmFoZqP29NV/JnzWmzjLWf80Jo/ewJcZrGA=
Date:   Fri, 03 Sep 2021 13:59:22 -0700
From:   akpm@linux-foundation.org
To:     andreyknvl@gmail.com, aryabinin@virtuozzo.com, dvyukov@google.com,
        elver@google.com, glider@google.com, mm-commits@vger.kernel.org
Subject:  [merged] kasan-test-clean-up-ksize_uaf.patch removed from
 -mm tree
Message-ID: <20210903205922.AdWrFVWTC%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: test: clean up ksize_uaf
has been removed from the -mm tree.  Its filename was
     kasan-test-clean-up-ksize_uaf.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


