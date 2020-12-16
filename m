Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2746BC0018C
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:47:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F42192333E
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:47:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725976AbgLPErV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 23:47:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:52446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725889AbgLPErV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 23:47:21 -0500
Date:   Tue, 15 Dec 2020 20:46:39 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608094000;
        bh=rLoI2A3ELodc0LPoTdnMsANDrVqT0FbHfRSmYRSSfNE=;
        h=From:To:Subject:In-Reply-To:From;
        b=hPOWH1LHY4Oo1+1Wjevv3Pbmi/LBIHatdUqruSbBBdeTiHIV0AUQDPDnnTy+HqPAM
         JMf3/LHOww9s6k7z+YTl2JUUEi8YfoVpLwH3McnSZjb08w3K2hjpo8vhn1H0I9QbS3
         bP7uzZUa8Jcj8pxtR6rGxQzBarET6vG+u1YgrjWc=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, ardb@kernel.org, arnd@arndb.de,
        aryabinin@virtuozzo.com, dvyukov@google.com, elver@google.com,
        georgepope@android.com, herbert@gondor.apana.org.au,
        keescook@chromium.org, linux-mm@kvack.org, masahiroy@kernel.org,
        michal.lkml@markovi.net, mm-commits@vger.kernel.org,
        natechancellor@gmail.com, ndesaulniers@google.com,
        oberpar@linux.ibm.com, rdunlap@infradead.org,
        torvalds@linux-foundation.org
Subject:  [patch 79/95] ubsan: remove UBSAN_MISC in favor of
 individual options
Message-ID: <20201216044639.-BpWNfx1s%akpm@linux-foundation.org>
In-Reply-To: <20201215204156.f05ec694b907845bcfab5c44@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Kees Cook <keescook@chromium.org>
Subject: ubsan: remove UBSAN_MISC in favor of individual options

Make each UBSAN option individually selectable and remove UBSAN_MISC which
no longer has any purpose.  Add help text for each Kconfig, and include a
reference to the Clang sanitizer documentation.  Disable unsigned overflow
by default (not available with GCC and makes x86 unbootable with Clang). 
Disable unreachable when objtool is in use (redundant and confuses things:
instrumentation appears at unreachable locations).

Link: https://lkml.kernel.org/r/20201203004437.389959-7-keescook@chromium.org
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

 Documentation/dev-tools/ubsan.rst |    1 
 lib/Kconfig.ubsan                 |   82 +++++++++++++++++++---------
 2 files changed, 57 insertions(+), 26 deletions(-)

--- a/Documentation/dev-tools/ubsan.rst~ubsan-remove-ubsan_misc-in-favor-of-individual-options
+++ a/Documentation/dev-tools/ubsan.rst
@@ -86,3 +86,4 @@ References
 
 .. _1: https://gcc.gnu.org/onlinedocs/gcc-4.9.0/gcc/Debugging-Options.html
 .. _2: https://gcc.gnu.org/onlinedocs/gcc/Debugging-Options.html
+.. _3: https://clang.llvm.org/docs/UndefinedBehaviorSanitizer.html
--- a/lib/Kconfig.ubsan~ubsan-remove-ubsan_misc-in-favor-of-individual-options
+++ a/lib/Kconfig.ubsan
@@ -84,48 +84,88 @@ config UBSAN_LOCAL_BOUNDS
 	  where an added offset (which may not be known statically) is
 	  out-of-bounds.
 
-config UBSAN_MISC
-	bool "Enable all other Undefined Behavior sanity checks"
-	default UBSAN
-	help
-	  This option enables all sanity checks that don't have their
-	  own Kconfig options. Disable this if you only want to have
-	  individually selected checks.
-
 config UBSAN_SHIFT
-	def_bool UBSAN_MISC
+	bool "Perform checking for bit-shift overflows"
+	default UBSAN
 	depends on $(cc-option,-fsanitize=shift)
+	help
+	  This option enables -fsanitize=shift which checks for bit-shift
+	  operations that overflow to the left or go switch to negative
+	  for signed types.
 
 config UBSAN_DIV_ZERO
-	def_bool UBSAN_MISC
+	bool "Perform checking for integer divide-by-zero"
 	depends on $(cc-option,-fsanitize=integer-divide-by-zero)
+	help
+	  This option enables -fsanitize=integer-divide-by-zero which checks
+	  for integer division by zero. This is effectively redundant with the
+	  kernel's existing exception handling, though it can provide greater
+	  debugging information under CONFIG_UBSAN_REPORT_FULL.
 
 config UBSAN_UNREACHABLE
-	def_bool UBSAN_MISC
+	bool "Perform checking for unreachable code"
+	# objtool already handles unreachable checking and gets angry about
+	# seeing UBSan instrumentation located in unreachable places.
+	depends on !STACK_VALIDATION
 	depends on $(cc-option,-fsanitize=unreachable)
+	help
+	  This option enables -fsanitize=unreachable which checks for control
+	  flow reaching an expected-to-be-unreachable position.
 
 config UBSAN_SIGNED_OVERFLOW
-	def_bool UBSAN_MISC
+	bool "Perform checking for signed arithmetic overflow"
+	default UBSAN
 	depends on $(cc-option,-fsanitize=signed-integer-overflow)
+	help
+	  This option enables -fsanitize=signed-integer-overflow which checks
+	  for overflow of any arithmetic operations with signed integers.
 
 config UBSAN_UNSIGNED_OVERFLOW
-	def_bool UBSAN_MISC
+	bool "Perform checking for unsigned arithmetic overflow"
 	depends on $(cc-option,-fsanitize=unsigned-integer-overflow)
+	help
+	  This option enables -fsanitize=unsigned-integer-overflow which checks
+	  for overflow of any arithmetic operations with unsigned integers. This
+	  currently causes x86 to fail to boot.
 
 config UBSAN_OBJECT_SIZE
-	def_bool UBSAN_MISC
+	bool "Perform checking for accesses beyond the end of objects"
+	default UBSAN
 	# gcc hugely expands stack usage with -fsanitize=object-size
 	# https://lore.kernel.org/lkml/CAHk-=wjPasyJrDuwDnpHJS2TuQfExwe=px-SzLeN8GFMAQJPmQ@mail.gmail.com/
 	depends on !CC_IS_GCC
 	depends on $(cc-option,-fsanitize=object-size)
+	help
+	  This option enables -fsanitize=object-size which checks for accesses
+	  beyond the end of objects where the optimizer can determine both the
+	  object being operated on and its size, usually seen with bad downcasts,
+	  or access to struct members from NULL pointers.
 
 config UBSAN_BOOL
-	def_bool UBSAN_MISC
+	bool "Perform checking for non-boolean values used as boolean"
+	default UBSAN
 	depends on $(cc-option,-fsanitize=bool)
+	help
+	  This option enables -fsanitize=bool which checks for boolean values being
+	  loaded that are neither 0 nor 1.
 
 config UBSAN_ENUM
-	def_bool UBSAN_MISC
+	bool "Perform checking for out of bounds enum values"
+	default UBSAN
 	depends on $(cc-option,-fsanitize=enum)
+	help
+	  This option enables -fsanitize=enum which checks for values being loaded
+	  into an enum that are outside the range of given values for the given enum.
+
+config UBSAN_ALIGNMENT
+	bool "Perform checking for misaligned pointer usage"
+	default !HAVE_EFFICIENT_UNALIGNED_ACCESS
+	depends on !UBSAN_TRAP && !COMPILE_TEST
+	depends on $(cc-option,-fsanitize=alignment)
+	help
+	  This option enables the check of unaligned memory accesses.
+	  Enabling this option on architectures that support unaligned
+	  accesses may produce a lot of false positives.
 
 config UBSAN_SANITIZE_ALL
 	bool "Enable instrumentation for the entire kernel"
@@ -138,16 +178,6 @@ config UBSAN_SANITIZE_ALL
 	  Enabling this option will get kernel image size increased
 	  significantly.
 
-config UBSAN_ALIGNMENT
-	bool "Enable checks for pointers alignment"
-	default !HAVE_EFFICIENT_UNALIGNED_ACCESS
-	depends on !UBSAN_TRAP && !COMPILE_TEST
-	depends on $(cc-option,-fsanitize=alignment)
-	help
-	  This option enables the check of unaligned memory accesses.
-	  Enabling this option on architectures that support unaligned
-	  accesses may produce a lot of false positives.
-
 config TEST_UBSAN
 	tristate "Module for testing for undefined behavior detection"
 	depends on m
_
