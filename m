Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8335C433E0
	for <mm-commits@archiver.kernel.org>; Tue, 22 Dec 2020 20:03:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8BA4D20855
	for <mm-commits@archiver.kernel.org>; Tue, 22 Dec 2020 20:03:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727201AbgLVUDl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Dec 2020 15:03:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:46870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726486AbgLVUDl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 22 Dec 2020 15:03:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0850B23133;
        Tue, 22 Dec 2020 20:03:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608667405;
        bh=JM8QWrDg7sBMI5LsEMe0za0IAKlgysbCmniUFjiFTvI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=nclu423SdrM8qiuSa+xzq5QFk/c3R0I3QHYtD77yKQ1vuKW7+zC5vE0I6w9m3IovR
         cYgZENXCZ4maG9OZlsPnIPWddDUKDH1jtjeU1VPZ88zcJnRghTd3e0UQ09CG8BFVCV
         MP8zc2ICFc4FuBY4/9kpWGKsAt/0wMUU1aOk+BAg=
Date:   Tue, 22 Dec 2020 12:03:24 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@google.com,
        aryabinin@virtuozzo.com, Branislav.Rankov@arm.com,
        catalin.marinas@arm.com, dvyukov@google.com, elver@google.com,
        eugenis@google.com, glider@google.com, gor@linux.ibm.com,
        kevin.brodsky@arm.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        vincenzo.frascino@arm.com, will.deacon@arm.com
Subject:  [patch 57/60] kasan: clarify comment in
 __kasan_kfree_large
Message-ID: <20201222200324.fNkB_D1hi%akpm@linux-foundation.org>
In-Reply-To: <20201222115844.d30aaef7df6f5b120d3e0c3d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: clarify comment in __kasan_kfree_large

Currently it says that the memory gets poisoned by page_alloc code. 
Clarify this by mentioning the specific callback that poisons the memory.

Link: https://lkml.kernel.org/r/1c8380fe0332a3bcc720fe29f1e0bef2e2974416.1606162397.git.andreyknvl@google.com
Link: https://linux-review.googlesource.com/id/I1334dffb69b87d7986fab88a1a039cc3ea764725
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Dmitry Vyukov <dvyukov@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Tested-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Branislav Rankov <Branislav.Rankov@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/common.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/kasan/common.c~kasan-clarify-comment-in-__kasan_kfree_large
+++ a/mm/kasan/common.c
@@ -446,5 +446,5 @@ void __kasan_kfree_large(void *ptr, unsi
 {
 	if (ptr != page_address(virt_to_head_page(ptr)))
 		kasan_report_invalid_free(ptr, ip);
-	/* The object will be poisoned by page_alloc. */
+	/* The object will be poisoned by kasan_free_pages(). */
 }
_
