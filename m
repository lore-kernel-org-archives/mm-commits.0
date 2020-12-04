Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88FE6C433FE
	for <mm-commits@archiver.kernel.org>; Fri,  4 Dec 2020 00:04:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 496B6222B6
	for <mm-commits@archiver.kernel.org>; Fri,  4 Dec 2020 00:04:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389473AbgLDAEk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 3 Dec 2020 19:04:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:54172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389468AbgLDAEj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 3 Dec 2020 19:04:39 -0500
Date:   Thu, 03 Dec 2020 16:03:57 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1607040238;
        bh=gG8Bflz9ey02nCATmZ9VBuIWJDd0MOfrucxuqpyMvg4=;
        h=From:To:Subject:From;
        b=sCF3qIrk0ElVW9s0gLMRsStWIqIF6XYBxbHMCgO94h6qnLkc7moYMLbgBLzvmurQJ
         Ishr9ddtbjUmiPJVbDRROWwoQzE2gaim/BbLeaurFGPrTNCci0V3VFFZa10gXm/WfG
         KokSIeNiYei6KBETGvXQLHNtNajWQ82oVvS6S8DY=
From:   akpm@linux-foundation.org
To:     ardb@kernel.org, arnd@arndb.de, aryabinin@virtuozzo.com,
        dvyukov@google.com, elver@google.com, georgepope@android.com,
        herbert@gondor.apana.org.au, keescook@chromium.org,
        masahiroy@kernel.org, michal.lkml@markovi.net,
        mm-commits@vger.kernel.org, natechancellor@gmail.com,
        ndesaulniers@google.com, oberpar@linux.ibm.com,
        rdunlap@infradead.org, torvalds@linux-foundation.org
Subject:  + ubsan-disable-ubsan_trap-for-allconfig.patch added to
 -mm tree
Message-ID: <20201204000357.IFn5SHmHZ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ubsan: disable UBSAN_TRAP for all*config
has been added to the -mm tree.  Its filename is
     ubsan-disable-ubsan_trap-for-allconfig.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ubsan-disable-ubsan_trap-for-allconfig.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ubsan-disable-ubsan_trap-for-allconfig.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: ubsan: disable UBSAN_TRAP for all*config

Doing all*config builds attempts to build as much as possible. UBSAN_TRAP
effectively short-circuits lib/usban.c, so it should be disabled for
COMPILE_TEST so that the lib/ubsan.c code gets built.

Link: https://lkml.kernel.org/r/20201203004437.389959-5-keescook@chromium.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: George Popescu <georgepope@android.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Marco Elver <elver@google.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Michal Marek <michal.lkml@markovi.net>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Peter Oberparleiter <oberpar@linux.ibm.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.ubsan |    1 +
 1 file changed, 1 insertion(+)

--- a/lib/Kconfig.ubsan~ubsan-disable-ubsan_trap-for-allconfig
+++ a/lib/Kconfig.ubsan
@@ -14,6 +14,7 @@ if UBSAN
 
 config UBSAN_TRAP
 	bool "On Sanitizer warnings, abort the running kernel code"
+	depends on !COMPILE_TEST
 	depends on $(cc-option, -fsanitize-undefined-trap-on-error)
 	help
 	  Building kernels with Sanitizer features enabled tends to grow
_

Patches currently in -mm which might be from keescook@chromium.org are

ubsan-remove-redundant-wno-maybe-uninitialized.patch
ubsan-move-cc-option-tests-into-kconfig.patch
ubsan-disable-object-size-sanitizer-under-gcc.patch
ubsan-disable-ubsan_trap-for-allconfig.patch
ubsan-enable-for-allconfig-builds.patch
ubsan-remove-ubsan_misc-in-favor-of-individual-options.patch
ubsan-expand-tests-and-reporting.patch

