Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA92EC433E6
	for <mm-commits@archiver.kernel.org>; Wed, 23 Dec 2020 18:28:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A119D2229C
	for <mm-commits@archiver.kernel.org>; Wed, 23 Dec 2020 18:28:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727720AbgLWS25 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 23 Dec 2020 13:28:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:44098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727296AbgLWS25 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 23 Dec 2020 13:28:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BCF152229C;
        Wed, 23 Dec 2020 18:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608748096;
        bh=QaoSiRLdn7AjNnfLxWPJl9A3H1+2wKJtsarG0kLrTjE=;
        h=Date:From:To:Subject:From;
        b=OhfDKyKfLIs6fUxOa3N1IeHzHgWSA60UiTQ/v+fhRHPOVMxUh2f14QXpn4IS3Jtvr
         pcuMfqIjbKQv5WY61lt53uZMoFNAYzeGYPdtnCe9v1EAsIXdKK120XVbluSVIRVfi5
         NHERj7xmcn/SjyqcvPPCEpiYJy8c34kjwJf31b1U=
Date:   Wed, 23 Dec 2020 10:28:15 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, aryabinin@virtuozzo.com,
        Branislav.Rankov@arm.com, catalin.marinas@arm.com,
        dvyukov@google.com, elver@google.com, eugenis@google.com,
        glider@google.com, gor@linux.ibm.com, kevin.brodsky@arm.com,
        mm-commits@vger.kernel.org, vincenzo.frascino@arm.com,
        will.deacon@arm.com
Subject:  [merged]
 kasan-kasan_vmalloc-depends-on-kasan_generic.patch removed from -mm tree
Message-ID: <20201223182815.t6mz32lst%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: KASAN_VMALLOC depends on KASAN_GENERIC
has been removed from the -mm tree.  Its filename was
     kasan-kasan_vmalloc-depends-on-kasan_generic.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: KASAN_VMALLOC depends on KASAN_GENERIC

Currently only generic KASAN mode supports vmalloc, reflect that in the
config.

Link: https://lkml.kernel.org/r/0c493d3a065ad95b04313d00244e884a7e2498ff.1606161801.git.andreyknvl@google.com
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

 lib/Kconfig.kasan |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/Kconfig.kasan~kasan-kasan_vmalloc-depends-on-kasan_generic
+++ a/lib/Kconfig.kasan
@@ -146,7 +146,7 @@ config KASAN_SW_TAGS_IDENTIFY
 
 config KASAN_VMALLOC
 	bool "Back mappings in vmalloc space with real shadow memory"
-	depends on HAVE_ARCH_KASAN_VMALLOC
+	depends on KASAN_GENERIC && HAVE_ARCH_KASAN_VMALLOC
 	help
 	  By default, the shadow region for vmalloc space is the read-only
 	  zero page. This means that KASAN cannot detect errors involving
_

Patches currently in -mm which might be from andreyknvl@google.com are


