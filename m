Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6792CC433FE
	for <mm-commits@archiver.kernel.org>; Thu,  3 Dec 2020 22:44:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 15361223E4
	for <mm-commits@archiver.kernel.org>; Thu,  3 Dec 2020 22:44:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728973AbgLCWow (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 3 Dec 2020 17:44:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:58082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727664AbgLCWow (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 3 Dec 2020 17:44:52 -0500
Date:   Thu, 03 Dec 2020 14:44:10 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1607035452;
        bh=dTV/qZoYjXhbGFzQSNKdk0hBv7GMFYcukQ6WBjaGv4I=;
        h=From:To:Subject:From;
        b=Sayavku97E3NAUbkpEaPVU8wrtHFEgi8H5rp8FAmevLxMj6j+5B4ZB5NBMCZ3eqyu
         Djl0ywHPOu2ew3sBQmOAiJ55VDk/jmNUtP+NXHifcRNrwOwzb8o3MOeBOtWt0xYX65
         W56XmXnAkqcrpzsUCThcwSca1XsBjMS84MegxTug=
From:   akpm@linux-foundation.org
To:     andriy.shevchenko@linux.intel.com, arnd@arndb.de, bp@suse.de,
        jpa@git.mail.kapsi.fi, mm-commits@vger.kernel.org,
        natechancellor@gmail.com, ndesaulniers@google.com
Subject:  + selftest-fpu-avoid-clang-warning.patch added to -mm
 tree
Message-ID: <20201203224410.J8FKJ1amv%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftest/fpu: avoid clang warning
has been added to the -mm tree.  Its filename is
     selftest-fpu-avoid-clang-warning.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/selftest-fpu-avoid-clang-warning.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/selftest-fpu-avoid-clang-warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: selftest/fpu: avoid clang warning

With extra warnings enabled, clang complains about the redundant
-mhard-float argument:

clang: error: argument unused during compilation: '-mhard-float' [-Werror,-Wunused-command-line-argument]

Move this into the gcc-only part of the Makefile.

Link: https://lkml.kernel.org/r/20201203223652.1320700-1-arnd@kernel.org
Fixes: 4185b3b92792 ("selftests/fpu: Add an FPU selftest")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Nathan Chancellor <natechancellor@gmail.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Petteri Aimonen <jpa@git.mail.kapsi.fi>
Cc: Borislav Petkov <bp@suse.de>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Makefile |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/lib/Makefile~selftest-fpu-avoid-clang-warning
+++ a/lib/Makefile
@@ -107,7 +107,7 @@ obj-$(CONFIG_TEST_FREE_PAGES) += test_fr
 # off the generation of FPU/SSE* instructions for kernel proper but FPU_FLAGS
 # get appended last to CFLAGS and thus override those previous compiler options.
 #
-FPU_CFLAGS := -mhard-float -msse -msse2
+FPU_CFLAGS := -msse -msse2
 ifdef CONFIG_CC_IS_GCC
 # Stack alignment mismatch, proceed with caution.
 # GCC < 7.1 cannot compile code using `double` and -mpreferred-stack-boundary=3
@@ -120,6 +120,7 @@ ifdef CONFIG_CC_IS_GCC
 #  -mpreferred-stack-boundary=3 is not between 4 and 12
 #
 # can be triggered. Otherwise gcc doesn't complain.
+FPU_CFLAGS += -mhard-float
 FPU_CFLAGS += $(call cc-option,-msse -mpreferred-stack-boundary=3,-mpreferred-stack-boundary=4)
 endif
 
_

Patches currently in -mm which might be from arnd@arndb.de are

selftest-fpu-avoid-clang-warning.patch

