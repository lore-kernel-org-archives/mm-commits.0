Return-Path: <SRS0=A/n1=BU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BD13C433E0
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:39:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE706206C3
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:39:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597027180;
	bh=blVplkP8ihezzCuNE/DkX+Cdcv8Bk+KNWma78acIHgg=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=Ofrd2oWrZSLKYMm5FcdOZmwsrhP7w7RbQKSViO1TtLjCZqT4ZmJOjZYfNsvBLwyPs
	 gpRGcLF2kru4gu1zs4HLK/zyCNjPVlSnAd5mnRElGrcJnQEqARhDUmOmZRiMy8coOw
	 t2vj4jCn0jXy+VYQ1dUmhfQJkCCIfNlumpMmGgL0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726219AbgHJCjj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 Aug 2020 22:39:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:42778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726350AbgHJCjj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 Aug 2020 22:39:39 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 930C02065D;
        Mon, 10 Aug 2020 02:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597027178;
        bh=blVplkP8ihezzCuNE/DkX+Cdcv8Bk+KNWma78acIHgg=;
        h=Date:From:To:Subject:From;
        b=oNnCVZxR3Y/nLtLGDljxuer265x4BvnRFcNRnCzcsLHj7Iu817d82ZeQXRra+jWx2
         pQ+vPFIgugOXYWCCzoF2Cn5OxnLTibcdm6P9ukKzASoxgjoclkWFqjyiH1ZhCfuUOy
         jgSWD053VQyelLdroX14NZQwXQzPo998hzpg+SG4=
Date:   Sun, 09 Aug 2020 19:39:38 -0700
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, ardb@kernel.org, aryabinin@virtuozzo.com,
        catalin.marinas@arm.com, dvyukov@google.com, elver@google.com,
        glider@google.com, lenaptr@google.com, mm-commits@vger.kernel.org,
        vincenzo.frascino@arm.com, walter-zh.wu@mediatek.com
Subject:  [merged]
 kasan-adjust-kasan_stack_oob-for-tag-based-mode.patch removed from -mm tree
Message-ID: <20200810023938.Yo_qsD6B3%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: adjust kasan_stack_oob for tag-based mode
has been removed from the -mm tree.  Its filename was
     kasan-adjust-kasan_stack_oob-for-tag-based-mode.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from andreyknvl@google.com are


