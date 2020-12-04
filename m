Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E896C433FE
	for <mm-commits@archiver.kernel.org>; Fri,  4 Dec 2020 00:04:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0E00D224B2
	for <mm-commits@archiver.kernel.org>; Fri,  4 Dec 2020 00:04:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389472AbgLDAEn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 3 Dec 2020 19:04:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:54228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389468AbgLDAEn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 3 Dec 2020 19:04:43 -0500
Date:   Thu, 03 Dec 2020 16:04:00 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1607040242;
        bh=sNrSVNBxkEjUi0lkSN/YA921cdsWrt/ro3ebMF0r/Rw=;
        h=From:To:Subject:From;
        b=IfQ08TY1DKlgrCbGzHHjk6c4Gpx6LPJYd1mkFG+oKqE17yR/7FM82TKdRenl9Xorb
         35O5i9pFjiTsnYEZ1WXIGY4q0AdzIYvwZSSwdMCdh+/isnkmuL0c2dhYyd1w4l6gvY
         Jaxc5lXMwzGy8TYftr2g3HTo+XINqZQ3VGZ+ft5M=
From:   akpm@linux-foundation.org
To:     ardb@kernel.org, arnd@arndb.de, aryabinin@virtuozzo.com,
        dvyukov@google.com, elver@google.com, georgepope@android.com,
        herbert@gondor.apana.org.au, keescook@chromium.org,
        masahiroy@kernel.org, michal.lkml@markovi.net,
        mm-commits@vger.kernel.org, natechancellor@gmail.com,
        ndesaulniers@google.com, oberpar@linux.ibm.com,
        rdunlap@infradead.org, torvalds@linux-foundation.org
Subject:  + ubsan-enable-for-allconfig-builds.patch added to -mm
 tree
Message-ID: <20201204000400.XF6Wu9xG5%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ubsan: enable for all*config builds
has been added to the -mm tree.  Its filename is
     ubsan-enable-for-allconfig-builds.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ubsan-enable-for-allconfig-builds.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ubsan-enable-for-allconfig-builds.patch

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
Subject: ubsan: enable for all*config builds

With UBSAN_OBJECT_SIZE disabled for GCC, only UBSAN_ALIGNMENT remained a
noisy UBSAN option.  Disable it for COMPILE_TEST so the rest of UBSAN can
be used for full all*config builds or other large combinations.

Link: https://lore.kernel.org/lkml/CAHk-=wgXW=YLxGN0QVpp-1w5GDd2pf1W-FqY15poKzoVfik2qA@mail.gmail.com/
Link: https://lkml.kernel.org/r/20201203004437.389959-6-keescook@chromium.org
Signed-off-by: Kees Cook <keescook@chromium.org>
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
Cc: Nathan Chancellor <natechancellor@gmail.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Peter Oberparleiter <oberpar@linux.ibm.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.ubsan |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/lib/Kconfig.ubsan~ubsan-enable-for-allconfig-builds
+++ a/lib/Kconfig.ubsan
@@ -130,7 +130,6 @@ config UBSAN_ENUM
 config UBSAN_SANITIZE_ALL
 	bool "Enable instrumentation for the entire kernel"
 	depends on ARCH_HAS_UBSAN_SANITIZE_ALL
-	depends on !COMPILE_TEST
 	default y
 	help
 	  This option activates instrumentation for the entire kernel.
@@ -142,7 +141,7 @@ config UBSAN_SANITIZE_ALL
 config UBSAN_ALIGNMENT
 	bool "Enable checks for pointers alignment"
 	default !HAVE_EFFICIENT_UNALIGNED_ACCESS
-	depends on !UBSAN_TRAP
+	depends on !UBSAN_TRAP && !COMPILE_TEST
 	depends on $(cc-option,-fsanitize=alignment)
 	help
 	  This option enables the check of unaligned memory accesses.
_

Patches currently in -mm which might be from keescook@chromium.org are

ubsan-remove-redundant-wno-maybe-uninitialized.patch
ubsan-move-cc-option-tests-into-kconfig.patch
ubsan-disable-object-size-sanitizer-under-gcc.patch
ubsan-disable-ubsan_trap-for-allconfig.patch
ubsan-enable-for-allconfig-builds.patch
ubsan-remove-ubsan_misc-in-favor-of-individual-options.patch
ubsan-expand-tests-and-reporting.patch

