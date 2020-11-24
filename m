Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4B61C56202
	for <mm-commits@archiver.kernel.org>; Tue, 24 Nov 2020 00:37:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E61A20757
	for <mm-commits@archiver.kernel.org>; Tue, 24 Nov 2020 00:37:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cj2nCdLd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729905AbgKXAhD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 23 Nov 2020 19:37:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:43670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727107AbgKXAhC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 23 Nov 2020 19:37:02 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1D19420729;
        Tue, 24 Nov 2020 00:37:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1606178220;
        bh=3T3hBsmFMM3DtqcbchtblWzaKAJ7eCYjcZoE6Ol1Op4=;
        h=Date:From:To:Subject:From;
        b=cj2nCdLd6aBZF2cputijDtgL1VkoQrGuKYmqck4pZmtugaQa5A/SGxBHSeivt+O4I
         xaQ1s3Lof4VtdHuVPArAmE/UESH1fCkBKsY+pK7wnJbe30Ej5YTJ99zOx8+dc1BHkU
         9HHtqHAv2nqgV8jX2/oMlBY9nM6zu6zilBGmr+So=
Date:   Mon, 23 Nov 2020 16:36:59 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, andreyknvl@google.com,
        aryabinin@virtuozzo.com, Branislav.Rankov@arm.com,
        catalin.marinas@arm.com, dvyukov@google.com, elver@google.com,
        eugenis@google.com, glider@google.com, gor@linux.ibm.com,
        kevin.brodsky@arm.com, mm-commits@vger.kernel.org,
        vincenzo.frascino@arm.com, will.deacon@arm.com
Subject:  + kasan-mm-untag-page-address-in-free_reserved_area.patch
 added to -mm tree
Message-ID: <20201124003659.iaVEh-889%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan, mm: untag page address in free_reserved_area
has been added to the -mm tree.  Its filename is
     kasan-mm-untag-page-address-in-free_reserved_area.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-mm-untag-page-address-in-free_reserved_area.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-mm-untag-page-address-in-free_reserved_area.patch

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
Subject: kasan, mm: untag page address in free_reserved_area

free_reserved_area() memsets the pages belonging to a given memory area. 
As that memory hasn't been allocated via page_alloc, the KASAN tags that
those pages have are 0x00.  As the result the memset might result in a tag
mismatch.

Untag the address to avoid spurious faults.

Link: https://lkml.kernel.org/r/ebef6425f4468d063e2f09c1b62ccbb2236b71d3.1606161801.git.andreyknvl@google.com
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Tested-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Branislav Rankov <Branislav.Rankov@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Marco Elver <elver@google.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/mm/page_alloc.c~kasan-mm-untag-page-address-in-free_reserved_area
+++ a/mm/page_alloc.c
@@ -7662,6 +7662,11 @@ unsigned long free_reserved_area(void *s
 		 * alias for the memset().
 		 */
 		direct_map_addr = page_address(page);
+		/*
+		 * Perform a kasan-unchecked memset() since this memory
+		 * has not been initialized.
+		 */
+		direct_map_addr = kasan_reset_tag(direct_map_addr);
 		if ((unsigned int)poison <= 0xFF)
 			memset(direct_map_addr, poison, PAGE_SIZE);
 
_

Patches currently in -mm which might be from vincenzo.frascino@arm.com are

mm-vmalloc-fix-kasan-shadow-poisoning-size.patch
arm64-enable-armv85-a-asm-arch-option.patch
arm64-mte-add-in-kernel-mte-helpers.patch
arm64-mte-reset-the-page-tag-in-page-flags.patch
arm64-mte-add-in-kernel-tag-fault-handler.patch
arm64-kasan-allow-enabling-in-kernel-mte.patch
arm64-mte-convert-gcr_user-into-an-exclude-mask.patch
arm64-mte-switch-gcr_el1-in-kernel-entry-and-exit.patch
kasan-mm-untag-page-address-in-free_reserved_area.patch
kselftest-arm64-check-gcr_el1-after-context-switch.patch

