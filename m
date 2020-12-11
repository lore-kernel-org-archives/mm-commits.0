Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C2F8C433FE
	for <mm-commits@archiver.kernel.org>; Fri, 11 Dec 2020 22:38:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 15FF123C83
	for <mm-commits@archiver.kernel.org>; Fri, 11 Dec 2020 22:38:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390903AbgLKVhU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Dec 2020 16:37:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:60858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392776AbgLKVhR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 11 Dec 2020 16:37:17 -0500
Date:   Fri, 11 Dec 2020 13:36:35 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1607722596;
        bh=6buXg179dc1hdMRmbtFDqCzc/aZHzakFw0JVoG+g1wc=;
        h=From:To:Subject:In-Reply-To:From;
        b=nMNCPHgGD92QEjG9LKX3A2M345z9uXEXOEtoy8nUTl4Bypn4GcQRE271LDTi6vnpK
         8sq/7XShc9VIJze+kKuIUHEZypy2Ze56yzqSsTaj5pSxMWAkHB8orPZz576oHkSwO1
         5G/sHjJ0yQzGDdQ0Xf/dVfWrKmWkSkpG2Vgpt29c=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        arnd@arndb.de, bp@suse.de, jpa@git.mail.kapsi.fi,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        natechancellor@gmail.com, ndesaulniers@google.com,
        torvalds@linux-foundation.org
Subject:  [patch 3/8] selftest/fpu: avoid clang warning
Message-ID: <20201211213635.QbYDxhklm%akpm@linux-foundation.org>
In-Reply-To: <20201211133555.88407977f082963499ed343c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
