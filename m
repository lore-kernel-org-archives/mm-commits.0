Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 803DAC432C3
	for <mm-commits@archiver.kernel.org>; Wed, 27 Jan 2021 02:49:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4EB2A206CB
	for <mm-commits@archiver.kernel.org>; Wed, 27 Jan 2021 02:49:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231193AbhA0Csl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 26 Jan 2021 21:48:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:60236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390533AbhAZTrB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 26 Jan 2021 14:47:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 190622220B;
        Tue, 26 Jan 2021 19:46:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611690381;
        bh=E2H5NCddluFQ2G+mQqhJW07gnpgo3oXgiI+YQxD0pww=;
        h=Date:From:To:Subject:From;
        b=1M25exU3prkBlPOfpXbNSKHvkyIcmCeIwWSjA93BbK0Yc/c/FGdMt6e5NmldjM0SP
         r9VdFg+ugvtPjLgkS1OOX1RfnE7Oq0N3yr6K+40RTphkCp4+2d92wbM3mriojnZ0kr
         qMrqLo8py2Z17a1OiFsSOmitutKjN+GfUB8+zLz0=
Date:   Tue, 26 Jan 2021 11:46:20 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, aryabinin@virtuozzo.com,
        catalin.marinas@arm.com, dvyukov@google.com, glider@google.com,
        leonro@mellanox.com, mark.rutland@arm.com,
        mm-commits@vger.kernel.org, naresh.kamboju@linaro.org,
        paulmck@kernel.org, vincenzo.frascino@arm.com, will@kernel.org
Subject:  +
 kasan-make-addr_has_metadata-return-true-for-valid-addresses.patch added to
 -mm tree
Message-ID: <20210126194620.CmoWTPeKt%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: make addr_has_metadata() return true for valid addresses
has been added to the -mm tree.  Its filename is
     kasan-make-addr_has_metadata-return-true-for-valid-addresses.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-make-addr_has_metadata-return-true-for-valid-addresses.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-make-addr_has_metadata-return-true-for-valid-addresses.patch

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
Subject: kasan: make addr_has_metadata() return true for valid addresses

Currently, addr_has_metadata() returns true for every address.  An invalid
address (e.g.  NULL) passed to the function when, KASAN_HW_TAGS is
enabled, leads to a kernel panic.

Make addr_has_metadata() return true for valid addresses only.

Note: KASAN_HW_TAGS support for vmalloc will be added with a future patch.

Link: https://lkml.kernel.org/r/20210126134409.47894-3-vincenzo.frascino@arm.com
Fixes: 2e903b91479782b7 ("kasan, arm64: implement HW_TAGS runtime")
Signed-off-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
Reviewed-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Leon Romanovsky <leonro@mellanox.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: "Paul E . McKenney" <paulmck@kernel.org>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/kasan/kasan.h~kasan-make-addr_has_metadata-return-true-for-valid-addresses
+++ a/mm/kasan/kasan.h
@@ -209,7 +209,7 @@ bool check_memory_region(unsigned long a
 
 static inline bool addr_has_metadata(const void *addr)
 {
-	return true;
+	return (is_vmalloc_addr(addr) || virt_addr_valid(addr));
 }
 
 #endif /* CONFIG_KASAN_GENERIC || CONFIG_KASAN_SW_TAGS */
_

Patches currently in -mm which might be from vincenzo.frascino@arm.com are

kasan-add-explicit-preconditions-to-kasan_report.patch
kasan-make-addr_has_metadata-return-true-for-valid-addresses.patch

