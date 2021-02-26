Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11E91C433E0
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 00:50:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE60B64E2B
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 00:50:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231320AbhBZAuV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 19:50:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:35380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230352AbhBZAuV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 19:50:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 573C664DA3;
        Fri, 26 Feb 2021 00:49:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614300580;
        bh=G/ffaCxbxi599g0O95qENOe3WbJffVVXSYhSz9q3zb0=;
        h=Date:From:To:Subject:From;
        b=XGnIXzR4rv6olcrCQltvggrjE1789Le0EfltgXHfhyECStToKhWx3vsTDKYOasNOg
         AGwCFk5ZiiHBTjDPMZ/3V/F19HpePlIzuMsmJkl1ihVxhDMAFoMO/GUzo+H66EaPPi
         tzeTkAQVIRwQDu5KMDqLFOPxkuINczB2rs3JNYeI=
Date:   Thu, 25 Feb 2021 16:49:39 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, catalin.marinas@arm.com, elver@google.com,
        mm-commits@vger.kernel.org, vincenzo.frascino@arm.com,
        will@kernel.org
Subject:  [folded-merged]
 arm64-kasan-simplify-and-inline-mte-functions-fix.patch removed from -mm
 tree
Message-ID: <20210226004939.z6fc3AP5t%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arm64: fix warning in mte_get_random_tag()
has been removed from the -mm tree.  Its filename was
     arm64-kasan-simplify-and-inline-mte-functions-fix.patch

This patch was dropped because it was folded into arm64-kasan-simplify-and-inline-mte-functions.patch

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

arm64-kasan-simplify-and-inline-mte-functions.patch

