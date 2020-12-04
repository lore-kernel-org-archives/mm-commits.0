Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25BD8C433FE
	for <mm-commits@archiver.kernel.org>; Fri,  4 Dec 2020 00:04:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D389D224BE
	for <mm-commits@archiver.kernel.org>; Fri,  4 Dec 2020 00:04:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389467AbgLDAEd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 3 Dec 2020 19:04:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:54044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389470AbgLDAEd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 3 Dec 2020 19:04:33 -0500
Date:   Thu, 03 Dec 2020 16:03:50 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1607040232;
        bh=Nn3o5F6QO4niHK9Fh/cYLTu9AvglGUuSwCx+cpHdO/c=;
        h=From:To:Subject:From;
        b=bqG+oXOidvKqcS1MR9ywVXAfjZhjZ71EPYD3fN9Amgt1gG7Zybk/7Od8NAoEICI3/
         uwHL1liZLCQxTrb69En+B80/m1teUOH+hvQrHGGi+lD0kovZsxtXrhYHVWlU51Xe6x
         yA6mNmVQI405DXuN6I+QBVH8ZGG07dDeUNYlKtZ0=
From:   akpm@linux-foundation.org
To:     ardb@kernel.org, arnd@arndb.de, aryabinin@virtuozzo.com,
        dvyukov@google.com, elver@google.com, georgepope@android.com,
        herbert@gondor.apana.org.au, keescook@chromium.org,
        masahiroy@kernel.org, michal.lkml@markovi.net,
        mm-commits@vger.kernel.org, natechancellor@gmail.com,
        ndesaulniers@google.com, oberpar@linux.ibm.com,
        rdunlap@infradead.org, torvalds@linux-foundation.org
Subject:  + ubsan-move-cc-option-tests-into-kconfig.patch added to
 -mm tree
Message-ID: <20201204000350.3emim5d2_%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ubsan: move cc-option tests into Kconfig
has been added to the -mm tree.  Its filename is
     ubsan-move-cc-option-tests-into-kconfig.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ubsan-move-cc-option-tests-into-kconfig.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ubsan-move-cc-option-tests-into-kconfig.patch

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
Subject: ubsan: move cc-option tests into Kconfig

Instead of doing if/endif blocks with cc-option calls in the UBSAN
Makefile, move all the tests into Kconfig and use the Makefile to collect
the results.

Link: https://lkml.kernel.org/r/20201203004437.389959-3-keescook@chromium.org
Link: https://lore.kernel.org/lkml/CAHk-=wjPasyJrDuwDnpHJS2TuQfExwe=px-SzLeN8GFMAQJPmQ@mail.gmail.com/
Signed-off-by: Kees Cook <keescook@chromium.org>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
Tested-by: Nathan Chancellor <natechancellor@gmail.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: George Popescu <georgepope@android.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Marco Elver <elver@google.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Michal Marek <michal.lkml@markovi.net>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Peter Oberparleiter <oberpar@linux.ibm.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.ubsan      |   61 +++++++++++++++++++++++++++++++++++++--
 scripts/Makefile.ubsan |   45 +++++++++-------------------
 2 files changed, 73 insertions(+), 33 deletions(-)

--- a/lib/Kconfig.ubsan~ubsan-move-cc-option-tests-into-kconfig
+++ a/lib/Kconfig.ubsan
@@ -36,10 +36,17 @@ config UBSAN_KCOV_BROKEN
 	  See https://bugs.llvm.org/show_bug.cgi?id=45831 for the status
 	  in newer releases.
 
+config CC_HAS_UBSAN_BOUNDS
+	def_bool $(cc-option,-fsanitize=bounds)
+
+config CC_HAS_UBSAN_ARRAY_BOUNDS
+	def_bool $(cc-option,-fsanitize=array-bounds)
+
 config UBSAN_BOUNDS
 	bool "Perform array index bounds checking"
 	default UBSAN
 	depends on !UBSAN_KCOV_BROKEN
+	depends on CC_HAS_UBSAN_ARRAY_BOUNDS || CC_HAS_UBSAN_BOUNDS
 	help
 	  This option enables detection of directly indexed out of bounds
 	  array accesses, where the array size is known at compile time.
@@ -47,15 +54,30 @@ config UBSAN_BOUNDS
 	  to the {str,mem}*cpy() family of functions (that is addressed
 	  by CONFIG_FORTIFY_SOURCE).
 
+config UBSAN_ONLY_BOUNDS
+	def_bool CC_HAS_UBSAN_BOUNDS && !CC_HAS_UBSAN_ARRAY_BOUNDS
+	depends on UBSAN_BOUNDS
+	help
+	  This is a weird case: Clang's -fsanitize=bounds includes
+	  -fsanitize=local-bounds, but it's trapping-only, so for
+	  Clang, we must use -fsanitize=array-bounds when we want
+	  traditional array bounds checking enabled. For GCC, we
+	  want -fsanitize=bounds.
+
+config UBSAN_ARRAY_BOUNDS
+	def_bool CC_HAS_UBSAN_ARRAY_BOUNDS
+	depends on UBSAN_BOUNDS
+
 config UBSAN_LOCAL_BOUNDS
 	bool "Perform array local bounds checking"
 	depends on UBSAN_TRAP
-	depends on CC_IS_CLANG
 	depends on !UBSAN_KCOV_BROKEN
+	depends on $(cc-option,-fsanitize=local-bounds)
 	help
 	  This option enables -fsanitize=local-bounds which traps when an
-	  exception/error is detected. Therefore, it should be enabled only
-	  if trapping is expected.
+	  exception/error is detected. Therefore, it may only be enabled
+	  with CONFIG_UBSAN_TRAP.
+
 	  Enabling this option detects errors due to accesses through a
 	  pointer that is derived from an object of a statically-known size,
 	  where an added offset (which may not be known statically) is
@@ -69,6 +91,38 @@ config UBSAN_MISC
 	  own Kconfig options. Disable this if you only want to have
 	  individually selected checks.
 
+config UBSAN_SHIFT
+	def_bool UBSAN_MISC
+	depends on $(cc-option,-fsanitize=shift)
+
+config UBSAN_DIV_ZERO
+	def_bool UBSAN_MISC
+	depends on $(cc-option,-fsanitize=integer-divide-by-zero)
+
+config UBSAN_UNREACHABLE
+	def_bool UBSAN_MISC
+	depends on $(cc-option,-fsanitize=unreachable)
+
+config UBSAN_SIGNED_OVERFLOW
+	def_bool UBSAN_MISC
+	depends on $(cc-option,-fsanitize=signed-integer-overflow)
+
+config UBSAN_UNSIGNED_OVERFLOW
+	def_bool UBSAN_MISC
+	depends on $(cc-option,-fsanitize=unsigned-integer-overflow)
+
+config UBSAN_OBJECT_SIZE
+	def_bool UBSAN_MISC
+	depends on $(cc-option,-fsanitize=object-size)
+
+config UBSAN_BOOL
+	def_bool UBSAN_MISC
+	depends on $(cc-option,-fsanitize=bool)
+
+config UBSAN_ENUM
+	def_bool UBSAN_MISC
+	depends on $(cc-option,-fsanitize=enum)
+
 config UBSAN_SANITIZE_ALL
 	bool "Enable instrumentation for the entire kernel"
 	depends on ARCH_HAS_UBSAN_SANITIZE_ALL
@@ -85,6 +139,7 @@ config UBSAN_ALIGNMENT
 	bool "Enable checks for pointers alignment"
 	default !HAVE_EFFICIENT_UNALIGNED_ACCESS
 	depends on !UBSAN_TRAP
+	depends on $(cc-option,-fsanitize=alignment)
 	help
 	  This option enables the check of unaligned memory accesses.
 	  Enabling this option on architectures that support unaligned
--- a/scripts/Makefile.ubsan~ubsan-move-cc-option-tests-into-kconfig
+++ a/scripts/Makefile.ubsan
@@ -1,33 +1,18 @@
 # SPDX-License-Identifier: GPL-2.0
 
-export CFLAGS_UBSAN :=
+# Enable available and selected UBSAN features.
+ubsan-cflags-$(CONFIG_UBSAN_ALIGNMENT)		+= -fsanitize=alignment
+ubsan-cflags-$(CONFIG_UBSAN_ONLY_BOUNDS)	+= -fsanitize=bounds
+ubsan-cflags-$(CONFIG_UBSAN_ARRAY_BOUNDS)	+= -fsanitize=array-bounds
+ubsan-cflags-$(CONFIG_UBSAN_LOCAL_BOUNDS)	+= -fsanitize=local-bounds
+ubsan-cflags-$(CONFIG_UBSAN_SHIFT)		+= -fsanitize=shift
+ubsan-cflags-$(CONFIG_UBSAN_DIV_ZERO)		+= -fsanitize=integer-divide-by-zero
+ubsan-cflags-$(CONFIG_UBSAN_UNREACHABLE)	+= -fsanitize=unreachable
+ubsan-cflags-$(CONFIG_UBSAN_SIGNED_OVERFLOW)	+= -fsanitize=signed-integer-overflow
+ubsan-cflags-$(CONFIG_UBSAN_UNSIGNED_OVERFLOW)	+= -fsanitize=unsigned-integer-overflow
+ubsan-cflags-$(CONFIG_UBSAN_OBJECT_SIZE)	+= -fsanitize=object-size
+ubsan-cflags-$(CONFIG_UBSAN_BOOL)		+= -fsanitize=bool
+ubsan-cflags-$(CONFIG_UBSAN_ENUM)		+= -fsanitize=enum
+ubsan-cflags-$(CONFIG_UBSAN_TRAP)		+= -fsanitize-undefined-trap-on-error
 
-ifdef CONFIG_UBSAN_ALIGNMENT
-      CFLAGS_UBSAN += $(call cc-option, -fsanitize=alignment)
-endif
-
-ifdef CONFIG_UBSAN_BOUNDS
-      ifdef CONFIG_CC_IS_CLANG
-            CFLAGS_UBSAN += -fsanitize=array-bounds
-      else
-            CFLAGS_UBSAN += $(call cc-option, -fsanitize=bounds)
-      endif
-endif
-
-ifdef CONFIG_UBSAN_LOCAL_BOUNDS
-      CFLAGS_UBSAN += -fsanitize=local-bounds
-endif
-
-ifdef CONFIG_UBSAN_MISC
-      CFLAGS_UBSAN += $(call cc-option, -fsanitize=shift)
-      CFLAGS_UBSAN += $(call cc-option, -fsanitize=integer-divide-by-zero)
-      CFLAGS_UBSAN += $(call cc-option, -fsanitize=unreachable)
-      CFLAGS_UBSAN += $(call cc-option, -fsanitize=signed-integer-overflow)
-      CFLAGS_UBSAN += $(call cc-option, -fsanitize=object-size)
-      CFLAGS_UBSAN += $(call cc-option, -fsanitize=bool)
-      CFLAGS_UBSAN += $(call cc-option, -fsanitize=enum)
-endif
-
-ifdef CONFIG_UBSAN_TRAP
-      CFLAGS_UBSAN += $(call cc-option, -fsanitize-undefined-trap-on-error)
-endif
+export CFLAGS_UBSAN := $(ubsan-cflags-y)
_

Patches currently in -mm which might be from keescook@chromium.org are

ubsan-remove-redundant-wno-maybe-uninitialized.patch
ubsan-move-cc-option-tests-into-kconfig.patch
ubsan-disable-object-size-sanitizer-under-gcc.patch
ubsan-disable-ubsan_trap-for-allconfig.patch
ubsan-enable-for-allconfig-builds.patch
ubsan-remove-ubsan_misc-in-favor-of-individual-options.patch
ubsan-expand-tests-and-reporting.patch

