Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12D18C433DB
	for <mm-commits@archiver.kernel.org>; Wed, 23 Dec 2020 18:30:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DCC8622287
	for <mm-commits@archiver.kernel.org>; Wed, 23 Dec 2020 18:30:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727377AbgLWSau (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 23 Dec 2020 13:30:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:46582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726384AbgLWSau (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 23 Dec 2020 13:30:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9A979222B3;
        Wed, 23 Dec 2020 18:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608748210;
        bh=TsCfTwd5djLh6oYhK9Orce9zSJz4jiUuuGKxGMYbss4=;
        h=Date:From:To:Subject:From;
        b=fEI1Ik5gZb025vS5vKlwFThWiq3tnnGbspSA/3V14kqs1PFK/V2ngZObG4SbmijG2
         cXeFIInYW2FeBa/Bs9pFrZy7RLgKCIrr/zZ+EuRdRFcrvn+Nv/jDeRsBZOARVWSEEx
         FJB+te3kDiUNs+pJyvMWTfz88xwRYQbihMJM6fVQ=
Date:   Wed, 23 Dec 2020 10:30:09 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, aryabinin@virtuozzo.com,
        Branislav.Rankov@arm.com, catalin.marinas@arm.com,
        dvyukov@google.com, elver@google.com, eugenis@google.com,
        glider@google.com, gor@linux.ibm.com, kevin.brodsky@arm.com,
        mm-commits@vger.kernel.org, vincenzo.frascino@arm.com,
        will.deacon@arm.com
Subject:  [merged]
 kasan-clarify-comment-in-__kasan_kfree_large.patch removed from -mm tree
Message-ID: <20201223183009.5vZuq0CJi%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: clarify comment in __kasan_kfree_large
has been removed from the -mm tree.  Its filename was
     kasan-clarify-comment-in-__kasan_kfree_large.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from andreyknvl@google.com are


