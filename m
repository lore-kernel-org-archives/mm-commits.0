From: akpm@linux-foundation.org
Subject: +
 kcov-unconditionally-add-fno-stack-protector-to-compiler-options.patch added
 to -mm tree
Date: Tue, 16 Jun 2020 12:05:07 -0700
Message-ID: <20200616190507.Bl9M4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728861AbgFPTFH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 16 Jun 2020 15:05:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ndesaulniers@google.com, glider@google.com, dvyukov@google.com, andreyknvl@google.com, elver@google.com


The patch titled
     Subject: kcov: unconditionally add -fno-stack-protector to compiler options
has been added to the -mm tree.  Its filename is
     kcov-unconditionally-add-fno-stack-protector-to-compiler-options.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kcov-unconditionally-add-fno-stack-protector-to-compiler-options.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kcov-unconditionally-add-fno-stack-protector-to-compiler-options.patch

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
Subject: kcov: unconditionally add -fno-stack-protector to compiler options

Unconditionally add -fno-stack-protector to KCOV's compiler options, as
all supported compilers support the option.  This saves a compiler
invocation to determine if the option is supported.

Because Clang does not support -fno-conserve-stack, and
-fno-stack-protector was wrapped in the same cc-option, we were missing
-fno-stack-protector with Clang. Unconditionally adding this option
fixes this for Clang.

Link: http://lkml.kernel.org/r/20200615184302.7591-1-elver@google.com
Signed-off-by: Marco Elver <elver@google.com>
Suggested-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Alexander Potapenko <glider@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/Makefile~kcov-unconditionally-add-fno-stack-protector-to-compiler-options
+++ a/kernel/Makefile
@@ -35,7 +35,7 @@ KCOV_INSTRUMENT_stacktrace.o := n
 KCOV_INSTRUMENT_kcov.o := n
 KASAN_SANITIZE_kcov.o := n
 KCSAN_SANITIZE_kcov.o := n
-CFLAGS_kcov.o := $(call cc-option, -fno-conserve-stack -fno-stack-protector)
+CFLAGS_kcov.o := $(call cc-option, -fno-conserve-stack) -fno-stack-protector
 
 # cond_syscall is currently not LTO compatible
 CFLAGS_sys_ni.o = $(DISABLE_LTO)
_

Patches currently in -mm which might be from elver@google.com are

mm-kcsan-instrument-slab-slub-free-with-assert_exclusive_access.patch
kcov-unconditionally-add-fno-stack-protector-to-compiler-options.patch
