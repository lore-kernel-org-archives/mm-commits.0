Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B946C433E0
	for <mm-commits@archiver.kernel.org>; Thu, 11 Feb 2021 23:41:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B6E964DA5
	for <mm-commits@archiver.kernel.org>; Thu, 11 Feb 2021 23:41:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229944AbhBKXlS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 11 Feb 2021 18:41:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:50862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229553AbhBKXlR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 11 Feb 2021 18:41:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BC00B64E3B;
        Thu, 11 Feb 2021 23:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1613086837;
        bh=RGJtkhoghX4BDSOzSpsfOGPyKAjJ0gMfL8UkerhrOe8=;
        h=Date:From:To:Subject:From;
        b=PgT6rAkAl6D1I6ANyVYdVL170EnTAJMetxCvdZqyPzGRJhssoOXXbaWHslK7/vDJA
         AsoKCLCTQXAo7Te8g6zShLp5UAziwuTnNuo3DMeRDIDwm+475l56HZh1H59UUFntAR
         XGbQo5z8SodUeE8UNvcQUAXBWrOjyQ7DczAe6kHs=
Date:   Thu, 11 Feb 2021 15:40:36 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, will@kernel.org, elver@google.com,
        catalin.marinas@arm.com, andreyknvl@google.com,
        vincenzo.frascino@arm.com
Subject:  + arm64-kasan-simplify-and-inline-mte-functions-fix.patch
 added to -mm tree
Message-ID: <20210211234036.Nb4Pg%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arm64: fix warning in mte_get_random_tag()
has been added to the -mm tree.  Its filename is
     arm64-kasan-simplify-and-inline-mte-functions-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/arm64-kasan-simplify-and-inline-mte-functions-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/arm64-kasan-simplify-and-inline-mte-functions-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vincenzo Frascino <vincenzo.frascino@arm.com>
Subject: arm64: fix warning in mte_get_random_tag()

The simplification of mte_get_random_tag() caused the introduction of the
warning below:

In file included from arch/arm64/include/asm/kasan.h:9,
                 from include/linux/kasan.h:16,
                 from mm/kasan/common.c:14:
mm/kasan/common.c: In function `mte_get_random_tag':
arch/arm64/include/asm/mte-kasan.h:45:9: warning: `addr' is used
                                         uninitialized [-Wuninitialized]
   45 |         asm(__MTE_PREAMBLE "irg %0, %0"
      |

Fix the warning using "=r" for the address in the asm inline.

Link: https://lkml.kernel.org/r/20210211152208.23811-1-vincenzo.frascino@arm.com
Fixes: c8f8de4c0887 ("arm64: kasan: simplify and inline MTE functions")
Signed-off-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
Acked-by: Andrey Konovalov <andreyknvl@google.com>
Tested-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/mte-kasan.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/include/asm/mte-kasan.h~arm64-kasan-simplify-and-inline-mte-functions-fix
+++ a/arch/arm64/include/asm/mte-kasan.h
@@ -43,7 +43,7 @@ static inline u8 mte_get_random_tag(void
 	void *addr;
 
 	asm(__MTE_PREAMBLE "irg %0, %0"
-		: "+r" (addr));
+		: "=r" (addr));
 
 	return mte_get_ptr_tag(addr);
 }
_

Patches currently in -mm which might be from vincenzo.frascino@arm.com are

arm64-kasan-simplify-and-inline-mte-functions-fix.patch

