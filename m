Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD0E0C433E0
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:25:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9ADEA22CAF
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596781516;
	bh=8CjMLXFFHhtLj2yQweCyzaJNsenCOeQjrrOCzvB9ho0=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=fBaZ5BdWYKo4QXbtHZTfME/vukh7UeurkUyJ+gG4N7ecp/WeWjNEo/TU+mV/7QXC2
	 QjU5SpE3+pDkbw1fVEiY16D1RRTmtknJNt5OI/lXs+1q8fnabZBbAtcvdZh3vLsulq
	 Ya+uQs1SF1KeUmCsQWUvqsB5sYnMpSZW3KWW20c8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726401AbgHGGZP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 02:25:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:34072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726634AbgHGGZO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 02:25:14 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6824F22CAE;
        Fri,  7 Aug 2020 06:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596781514;
        bh=8CjMLXFFHhtLj2yQweCyzaJNsenCOeQjrrOCzvB9ho0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=h7pRKnuxvUB4QC/1o2vjaV4SyeQWpLW7cm7Lda1YUy7xvRcOUrxhUgnkRR9nHZo1c
         UF1fiNZU2deH1POoDEOaQXGmMqE8Rv8SHYpv63gIltrUhVLYKd+rhpyTlziD8MagyJ
         oJWv1xFo9ITUJXZObr9tciPdOv8+mX3YVAdm3ASI=
Date:   Thu, 06 Aug 2020 23:25:12 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@google.com, ardb@kernel.org,
        aryabinin@virtuozzo.com, catalin.marinas@arm.com,
        dvyukov@google.com, elver@google.com, glider@google.com,
        lenaptr@google.com, linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, vincenzo.frascino@arm.com,
        walter-zh.wu@mediatek.com
Subject:  [patch 140/163] kasan: adjust kasan_stack_oob for
 tag-based mode
Message-ID: <20200807062512.e9NsWHHeg%akpm@linux-foundation.org>
In-Reply-To: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: adjust kasan_stack_oob for tag-based mode

Use OOB_TAG_OFF as access offset to land the access into the next granule.

Link: http://lkml.kernel.org/r/403b259f1de49a7a3694531c851ac28326a586a8.1596199677.git.andreyknvl@google.com
Link: http://lkml.kernel.org/r/3063ab1411e92bce36061a96e25b651212e70ba6.1596544734.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Suggested-by: Walter Wu <walter-zh.wu@mediatek.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Elena Petrova <lenaptr@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
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
