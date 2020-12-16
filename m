Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 213D7C4361B
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:47:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E8F582332A
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:47:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725968AbgLPErC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 23:47:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:52132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725889AbgLPErC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 23:47:02 -0500
Date:   Tue, 15 Dec 2020 20:46:20 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608093981;
        bh=4k/+tgTxFlLalla+1ymz/UzoyUIWLlP5hW+3nfOpiYg=;
        h=From:To:Subject:In-Reply-To:From;
        b=gErBTB1rYE4kILR1E5cYOZKTSW0gNNoSH4p2NBr4xVLl6qvdTL3UDUYCtrHI9eBi2
         TTo5nJYrf6NUuMVS3eXnCOC9ELVNRbn5/jw8tQOnvLDZn7TeaJTjLDEPlxwD8xaNXA
         osKuSTeN711lYOjky9eRGRqDiMLb60Nq+32RauMQ=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, ardb@kernel.org, arnd@arndb.de,
        aryabinin@virtuozzo.com, dvyukov@google.com, elver@google.com,
        georgepope@android.com, herbert@gondor.apana.org.au,
        keescook@chromium.org, linux-mm@kvack.org, masahiroy@kernel.org,
        michal.lkml@markovi.net, mm-commits@vger.kernel.org,
        natechancellor@gmail.com, ndesaulniers@google.com,
        oberpar@linux.ibm.com, rdunlap@infradead.org,
        torvalds@linux-foundation.org
Subject:  [patch 74/95] ubsan: remove redundant
 -Wno-maybe-uninitialized
Message-ID: <20201216044620.KHEWfklze%akpm@linux-foundation.org>
In-Reply-To: <20201215204156.f05ec694b907845bcfab5c44@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Kees Cook <keescook@chromium.org>
Subject: ubsan: remove redundant -Wno-maybe-uninitialized

Patch series "Clean up UBSAN Makefile", v2.

This series attempts to address the issues seen with UBSAN's object-size
sanitizer causing problems under GCC.  In the process, the Kconfig and
Makefile are refactored to do all the cc-option calls in the Kconfig. 
Additionally start to detangle -Wno-maybe-uninitialized, disable
UBSAN_TRAP under COMPILE_TEST for wider build coverage, and expand the
libusan tests.


This patch (of 7):

In commit 78a5255ffb6a ("Stop the ad-hoc games with
-Wno-maybe-initialized") -Wmaybe-uninitialized was disabled globally, so
keeping the disabling logic here too doesn't make sense.

Link: https://lkml.kernel.org/r/20201203004437.389959-1-keescook@chromium.org
Link: https://lkml.kernel.org/r/20201203004437.389959-2-keescook@chromium.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Michal Marek <michal.lkml@markovi.net>
Cc: Nathan Chancellor <natechancellor@gmail.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: George Popescu <georgepope@android.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Peter Oberparleiter <oberpar@linux.ibm.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.ubsan      |    4 ----
 scripts/Makefile.ubsan |    4 ----
 2 files changed, 8 deletions(-)

--- a/lib/Kconfig.ubsan~ubsan-remove-redundant-wno-maybe-uninitialized
+++ a/lib/Kconfig.ubsan
@@ -72,10 +72,6 @@ config UBSAN_MISC
 config UBSAN_SANITIZE_ALL
 	bool "Enable instrumentation for the entire kernel"
 	depends on ARCH_HAS_UBSAN_SANITIZE_ALL
-
-	# We build with -Wno-maybe-uninitilzed, but we still want to
-	# use -Wmaybe-uninitilized in allmodconfig builds.
-	# So dependsy bellow used to disable this option in allmodconfig
 	depends on !COMPILE_TEST
 	default y
 	help
--- a/scripts/Makefile.ubsan~ubsan-remove-redundant-wno-maybe-uninitialized
+++ a/scripts/Makefile.ubsan
@@ -31,7 +31,3 @@ endif
 ifdef CONFIG_UBSAN_TRAP
       CFLAGS_UBSAN += $(call cc-option, -fsanitize-undefined-trap-on-error)
 endif
-
-      # -fsanitize=* options makes GCC less smart than usual and
-      # increase number of 'maybe-uninitialized false-positives
-      CFLAGS_UBSAN += $(call cc-option, -Wno-maybe-uninitialized)
_
