Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8C0EC433E0
	for <mm-commits@archiver.kernel.org>; Wed, 23 Dec 2020 18:30:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7BF9F223E0
	for <mm-commits@archiver.kernel.org>; Wed, 23 Dec 2020 18:30:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728452AbgLWSaS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 23 Dec 2020 13:30:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:46042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727040AbgLWSaS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 23 Dec 2020 13:30:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AD719223E0;
        Wed, 23 Dec 2020 18:29:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608748154;
        bh=u4ozf2hQgX7OlrRVKAJaXklU7FYLwxHEZVjarYILmBU=;
        h=Date:From:To:Subject:From;
        b=n5GuWgLwgW0bq0e6NXO39M6nQ+m/KZp6GY0fhV0KLggEYNmnAiI8G2mY+4EtNLW9E
         ZCfIKX7dWtgZpbIxymNWrBiXvd5KTxip4CEYmiDtqJvNdMiHpPEnFNmVzbQdMpgdXj
         Q2FPXt7MtCYCoL5JUyn6giuYc7SHnhJGzhbXqwos=
Date:   Wed, 23 Dec 2020 10:29:13 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, andreyknvl@google.com,
        aryabinin@virtuozzo.com, Branislav.Rankov@arm.com,
        catalin.marinas@arm.com, dvyukov@google.com, elver@google.com,
        eugenis@google.com, glider@google.com, gor@linux.ibm.com,
        kevin.brodsky@arm.com, mm-commits@vger.kernel.org,
        vincenzo.frascino@arm.com, will.deacon@arm.com
Subject:  [merged]
 kasan-mm-untag-page-address-in-free_reserved_area.patch removed from -mm
 tree
Message-ID: <20201223182913.H2Jyb_Ctm%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan, mm: untag page address in free_reserved_area
has been removed from the -mm tree.  Its filename was
     kasan-mm-untag-page-address-in-free_reserved_area.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -7671,6 +7671,11 @@ unsigned long free_reserved_area(void *s
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


