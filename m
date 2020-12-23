Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B4B2C433E0
	for <mm-commits@archiver.kernel.org>; Wed, 23 Dec 2020 18:29:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 07D40224B0
	for <mm-commits@archiver.kernel.org>; Wed, 23 Dec 2020 18:29:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728394AbgLWS3r (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 23 Dec 2020 13:29:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:45418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728385AbgLWS3r (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 23 Dec 2020 13:29:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A3837224BE;
        Wed, 23 Dec 2020 18:28:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608748132;
        bh=r/yzexrVksoYndUGDOTSYst7WVkMEOvIKZwkIzQQylc=;
        h=Date:From:To:Subject:From;
        b=I8IOFLIXZW3K2gwsCb1/xuWU/H2zPrw7vepTnXoSDxydeyODhB6rNRxmvDSsS7V7p
         dRm7tRPiC1Y+IBn1etVbAIDMXrgOdssmn83uEbJCKyxa9YpfvMMCB6dA3h09d84iv7
         jeod7YEccRdcTSL/fcQvEK6ydOMYfXnwFyhV5iMM=
Date:   Wed, 23 Dec 2020 10:28:51 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, aryabinin@virtuozzo.com,
        Branislav.Rankov@arm.com, catalin.marinas@arm.com,
        dvyukov@google.com, elver@google.com, eugenis@google.com,
        glider@google.com, gor@linux.ibm.com, kevin.brodsky@arm.com,
        mm-commits@vger.kernel.org, vincenzo.frascino@arm.com,
        will.deacon@arm.com
Subject:  [merged]
 kasan-rename-print_shadow_for_address-to-print_memory_metadata.patch
 removed from -mm tree
Message-ID: <20201223182851.nkUpnrirb%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: rename print_shadow_for_address to print_memory_metadata
has been removed from the -mm tree.  Its filename was
     kasan-rename-print_shadow_for_address-to-print_memory_metadata.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: rename print_shadow_for_address to print_memory_metadata

This is a preparatory commit for the upcoming addition of a new hardware
tag-based (MTE-based) KASAN mode.

Hardware tag-based KASAN won't be using shadow memory, but will reuse this
function.  Rename "shadow" to implementation-neutral "metadata".

No functional changes.

Link: https://lkml.kernel.org/r/dd955c5aadaee16aef451a6189d19172166a23f5.1606161801.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Signed-off-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
Reviewed-by: Marco Elver <elver@google.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Tested-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Branislav Rankov <Branislav.Rankov@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/report.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/kasan/report.c~kasan-rename-print_shadow_for_address-to-print_memory_metadata
+++ a/mm/kasan/report.c
@@ -252,7 +252,7 @@ static int shadow_pointer_offset(const v
 		(shadow - row) / SHADOW_BYTES_PER_BLOCK + 1;
 }
 
-static void print_shadow_for_address(const void *addr)
+static void print_memory_metadata(const void *addr)
 {
 	int i;
 	const void *shadow = kasan_mem_to_shadow(addr);
@@ -338,7 +338,7 @@ void kasan_report_invalid_free(void *obj
 	pr_err("\n");
 	print_address_description(object, tag);
 	pr_err("\n");
-	print_shadow_for_address(object);
+	print_memory_metadata(object);
 	end_report(&flags);
 }
 
@@ -379,7 +379,7 @@ static void __kasan_report(unsigned long
 	if (addr_has_metadata(untagged_addr)) {
 		print_address_description(untagged_addr, get_tag(tagged_addr));
 		pr_err("\n");
-		print_shadow_for_address(info.first_bad_addr);
+		print_memory_metadata(info.first_bad_addr);
 	} else {
 		dump_stack();
 	}
_

Patches currently in -mm which might be from andreyknvl@google.com are


