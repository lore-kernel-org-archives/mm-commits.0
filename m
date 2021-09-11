Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 847CDC433EF
	for <mm-commits@archiver.kernel.org>; Sat, 11 Sep 2021 22:15:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E31B60FDC
	for <mm-commits@archiver.kernel.org>; Sat, 11 Sep 2021 22:15:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230493AbhIKWQn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 11 Sep 2021 18:16:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:52204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229800AbhIKWQn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 11 Sep 2021 18:16:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CA74860F6C;
        Sat, 11 Sep 2021 22:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631398530;
        bh=sfziY8PCXnUqk4vjmW+9HPG/QnHa/bllbFBnzy2XeYA=;
        h=Date:From:To:Subject:From;
        b=fRYGMfrPxL7ozV2MDf3i+2jIZqC28/sIjiiB1aeDv3lXfLGBNxAaERpz8d0mHPj/c
         gOi1cpDCQ8uJMfgo3+Jokb37ue70fzuL1jPEa1OGoEFFIbVRryE8ddcdlQhJ3Bc25I
         rqvmaU9pHXYH7TEOFDzK4/rj3s8lvlCAiP/bviMI=
Date:   Sat, 11 Sep 2021 15:15:29 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, tarasmadan@google.com,
        ryabinin.a.a@gmail.com, nogikh@google.com, glider@google.com,
        dvyukov@google.com, andreyknvl@gmail.com, elver@google.com
Subject:  +
 kasan-fix-kconfig-check-of-cc_has_working_nosanitize_address.patch added to
 -mm tree
Message-ID: <20210911221529.1kbgF%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: fix Kconfig check of CC_HAS_WORKING_NOSANITIZE_ADDRESS
has been added to the -mm tree.  Its filename is
     kasan-fix-kconfig-check-of-cc_has_working_nosanitize_address.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-fix-kconfig-check-of-cc_has_working_nosanitize_address.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-fix-kconfig-check-of-cc_has_working_nosanitize_address.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Marco Elver <elver@google.com>
Subject: kasan: fix Kconfig check of CC_HAS_WORKING_NOSANITIZE_ADDRESS

In the main KASAN config option CC_HAS_WORKING_NOSANITIZE_ADDRESS is
checked for instrumentation-based modes.  However, if
HAVE_ARCH_KASAN_HW_TAGS is true all modes may still be selected.

To fix, also make the software modes depend on
CC_HAS_WORKING_NOSANITIZE_ADDRESS.

Link: https://lkml.kernel.org/r/20210910084240.1215803-1-elver@google.com
Fixes: 6a63a63ff1ac ("kasan: introduce CONFIG_KASAN_HW_TAGS")
Signed-off-by: Marco Elver <elver@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Aleksandr Nogikh <nogikh@google.com>
Cc: Taras Madan <tarasmadan@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.kasan |    2 ++
 1 file changed, 2 insertions(+)

--- a/lib/Kconfig.kasan~kasan-fix-kconfig-check-of-cc_has_working_nosanitize_address
+++ a/lib/Kconfig.kasan
@@ -66,6 +66,7 @@ choice
 config KASAN_GENERIC
 	bool "Generic mode"
 	depends on HAVE_ARCH_KASAN && CC_HAS_KASAN_GENERIC
+	depends on CC_HAS_WORKING_NOSANITIZE_ADDRESS
 	select SLUB_DEBUG if SLUB
 	select CONSTRUCTORS
 	help
@@ -86,6 +87,7 @@ config KASAN_GENERIC
 config KASAN_SW_TAGS
 	bool "Software tag-based mode"
 	depends on HAVE_ARCH_KASAN_SW_TAGS && CC_HAS_KASAN_SW_TAGS
+	depends on CC_HAS_WORKING_NOSANITIZE_ADDRESS
 	select SLUB_DEBUG if SLUB
 	select CONSTRUCTORS
 	help
_

Patches currently in -mm which might be from elver@google.com are

kasan-fix-kconfig-check-of-cc_has_working_nosanitize_address.patch

