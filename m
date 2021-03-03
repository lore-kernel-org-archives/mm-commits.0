Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71B55C432C3
	for <mm-commits@archiver.kernel.org>; Wed,  3 Mar 2021 13:33:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4749064E02
	for <mm-commits@archiver.kernel.org>; Wed,  3 Mar 2021 13:33:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382055AbhCCNav (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 3 Mar 2021 08:30:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:39708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234767AbhCCB1N (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Mar 2021 20:27:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3AE5964FA9;
        Wed,  3 Mar 2021 01:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614734767;
        bh=5Ksgo4YL2zOPmpCopgoho+dnzH3zjnr+KXMkGjqVQfM=;
        h=Date:From:To:Subject:From;
        b=BLBPYXOk5+AOSlHvZdr/Gz2rDtJVh5EGZ3SXIe1aKno5USGmr4eb494rIpew/qQhW
         Hj/IBb1QkWyjRZa05ZKamxk7t1HtU00ZOYN5tbFnHicXmYsSxfdcoDIf9zu9jFXtCL
         kg7g/VMcpitFROM7JpsyyKwFuPIlF6hMq3uEMe2Q=
Date:   Tue, 02 Mar 2021 17:26:05 -0800
From:   akpm@linux-foundation.org
To:     aou@eecs.berkeley.edu, arnd@arndb.de, deanbo422@gmail.com,
        elver@google.com, green.hu@gmail.com, guoren@kernel.org,
        keescook@chromium.org, luc.vanoostenryck@gmail.com,
        masahiroy@kernel.org, mm-commits@vger.kernel.org,
        nathan@kernel.org, ndesaulniers@google.com, nickhu@andestech.com,
        nivedita@alum.mit.edu, ojeda@kernel.org, palmer@dabbelt.com,
        paul.walmsley@sifive.com, rdunlap@infradead.org,
        samitolvanen@google.com
Subject:  + linux-compiler-clangh-define-have_builtin_bswap.patch
 added to -mm tree
Message-ID: <20210303012605.0LczhH6dD%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: linux/compiler-clang.h: define HAVE_BUILTIN_BSWAP*
has been added to the -mm tree.  Its filename is
     linux-compiler-clangh-define-have_builtin_bswap.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/linux-compiler-clangh-define-have_builtin_bswap.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/linux-compiler-clangh-define-have_builtin_bswap.patch

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
Subject: linux/compiler-clang.h: define HAVE_BUILTIN_BSWAP*

Separating compiler-clang.h from compiler-gcc.h inadventently dropped the
definitions of the three HAVE_BUILTIN_BSWAP macros, which requires falling
back to the open-coded version and hoping that the compiler detects it.

Since all versions of clang support the __builtin_bswap interfaces, add
back the flags and have the headers pick these up automatically.

This results in a 4% improvement of compilation speed for arm defconfig.

Note: it might also be worth revisiting which architectures set
CONFIG_ARCH_USE_BUILTIN_BSWAP for one compiler or the other, today this is
set on six architectures (arm32, csky, mips, powerpc, s390, x86), while
another ten architectures define custom helpers (alpha, arc, ia64, m68k,
mips, nios2, parisc, sh, sparc, xtensa), and the rest (arm64, h8300,
hexagon, microblaze, nds32, openrisc, riscv) just get the unoptimized
version and rely on the compiler to detect it.

A long time ago, the compiler builtins were architecture specific, but
nowadays, all compilers that are able to build the kernel have correct
implementations of them, though some may not be as optimized as the inline
asm versions.

The patch that dropped the optimization landed in v4.19, so as discussed
it would be fairly safe to backport this revert to stable kernels to the
4.19/5.4/5.10 stable kernels, but there is a remaining risk for
regressions, and it has no known side-effects besides compile speed.

Link: https://lkml.kernel.org/r/20210226161151.2629097-1-arnd@kernel.org
Link: https://lore.kernel.org/lkml/20210225164513.3667778-1-arnd@kernel.org/
Fixes: 815f0ddb346c ("include/linux/compiler*.h: make compiler-*.h mutually exclusive")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Acked-by: Miguel Ojeda <ojeda@kernel.org>
Acked-by: Nick Desaulniers <ndesaulniers@google.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
Cc: Nick Hu <nickhu@andestech.com>
Cc: Greentime Hu <green.hu@gmail.com>
Cc: Vincent Chen <deanbo422@gmail.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Guo Ren <guoren@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Sami Tolvanen <samitolvanen@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Arvind Sankar <nivedita@alum.mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compiler-clang.h |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/include/linux/compiler-clang.h~linux-compiler-clangh-define-have_builtin_bswap
+++ a/include/linux/compiler-clang.h
@@ -31,6 +31,12 @@
 #define __no_sanitize_thread
 #endif
 
+#if defined(CONFIG_ARCH_USE_BUILTIN_BSWAP)
+#define __HAVE_BUILTIN_BSWAP32__
+#define __HAVE_BUILTIN_BSWAP64__
+#define __HAVE_BUILTIN_BSWAP16__
+#endif /* CONFIG_ARCH_USE_BUILTIN_BSWAP */
+
 #if __has_feature(undefined_behavior_sanitizer)
 /* GCC does not have __SANITIZE_UNDEFINED__ */
 #define __no_sanitize_undefined \
_

Patches currently in -mm which might be from arnd@arndb.de are

memblock-fix-section-mismatch-warning.patch
stop_machine-mark-helpers-__always_inline.patch
linux-compiler-clangh-define-have_builtin_bswap.patch

