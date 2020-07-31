Return-Path: <SRS0=f579=BK=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74F0EC433E0
	for <mm-commits@archiver.kernel.org>; Fri, 31 Jul 2020 19:24:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5DAAA22B42
	for <mm-commits@archiver.kernel.org>; Fri, 31 Jul 2020 19:24:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596223472;
	bh=/1i5+P0HBMauQT4k2hBF+oh5XLqJNuuXrZJIwVZndZM=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=KF+jMCToNNy3Px+ehBzuiZwW6WJUOChRMIVblNXS0Je3B/RqNRzLPeWaeMMhMTUSt
	 60lfUbbslvlsxYijfnyAyVHt+Ro1xebzLlR5FB57eo8uzOWGbEX8E96C6SAydpPX6b
	 ilXhN83GozfZO9nkJ+Wz6Nfzbq63t/Qif0XlscOc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728086AbgGaTYc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 31 Jul 2020 15:24:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:38518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726726AbgGaTYc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 31 Jul 2020 15:24:32 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0793A22B3F;
        Fri, 31 Jul 2020 19:24:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596223471;
        bh=/1i5+P0HBMauQT4k2hBF+oh5XLqJNuuXrZJIwVZndZM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ldryTC50vbv7VyJl0Udx/kXEGHj25omGWwQZV03iatPC1ePyrQQJRa3A4+fmklhQ/
         CMWejY7ZHcBo918rVtwAr4WX4b3MSKwhO/MZmPYuw6p+fP/n5PkwtE9EsVrsoz+AxS
         g+2sLMlETIFolFO3gaRMo8tSw3cm4PpusGw7oBDw=
Date:   Fri, 31 Jul 2020 12:24:30 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     andreyknvl@google.com, aryabinin@virtuozzo.com,
        catalin.marinas@arm.com, dvyukov@google.com, elver@google.com,
        glider@google.com, lenaptr@google.com, mm-commits@vger.kernel.org,
        vincenzo.frascino@arm.com, walter-zh.wu@mediatek.com
Subject:  + kasan-adjust-kasan_stack_oob-for-tag-based-mode.patch
 added to -mm tree
Message-ID: <20200731192430.u_rWsqY4V%akpm@linux-foundation.org>
In-Reply-To: <20200723211432.b31831a0df3bc2cbdae31b40@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: adjust kasan_stack_oob for tag-based mode
has been added to the -mm tree.  Its filename is
     kasan-adjust-kasan_stack_oob-for-tag-based-mode.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kasan-adjust-kasan_stack_oob-for-tag-based-mode.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kasan-adjust-kasan_stack_oob-for-tag-based-mode.patch

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
Subject: kasan: adjust kasan_stack_oob for tag-based mode

Use OOB_TAG_OFF as access offset to land the access into the next granule.

Link: http://lkml.kernel.org/r/403b259f1de49a7a3694531c851ac28326a586a8.1596199677.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Suggested-by: Walter Wu <walter-zh.wu@mediatek.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Elena Petrova <lenaptr@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_kasan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/test_kasan.c~kasan-adjust-kasan_stack_oob-for-tag-based-mode
+++ a/lib/test_kasan.c
@@ -488,7 +488,7 @@ static noinline void __init kasan_global
 static noinline void __init kasan_stack_oob(void)
 {
 	char stack_array[10];
-	volatile int i = 0;
+	volatile int i = OOB_TAG_OFF;
 	char *p = &stack_array[ARRAY_SIZE(stack_array) + i];
 
 	pr_info("out-of-bounds on stack\n");
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-dont-tag-stacks-allocated-with-pagealloc.patch
kasan-arm64-dont-instrument-functions-that-enable-kasan.patch
kasan-allow-enabling-stack-tagging-for-tag-based-mode.patch
kasan-adjust-kasan_stack_oob-for-tag-based-mode.patch

