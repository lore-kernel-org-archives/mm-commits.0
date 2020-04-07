From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 103/166] sparc,x86: vdso: remove meaningless
 undefining CONFIG_OPTIMIZE_INLINING
Date: Mon, 06 Apr 2020 20:09:30 -0700
Message-ID: <20200407030930.A7AaTPhN_%akpm@linux-foundation.org>
References: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726396AbgDGDJc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 6 Apr 2020 23:09:32 -0400
In-Reply-To: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, arnd@arndb.de, bp@alien8.de, davem@davemloft.net, hpa@zytor.com, linux-mm@kvack.org, masahiroy@kernel.org, miguel.ojeda.sandonis@gmail.com, mingo@redhat.com, mm-commits@vger.kernel.org, natechancellor@gmail.com, tglx@linutronix.de, torvalds@linux-foundation.org

From: Masahiro Yamada <masahiroy@kernel.org>
Subject: sparc,x86: vdso: remove meaningless undefining CONFIG_OPTIMIZE_INLINING

The code, #undef CONFIG_OPTIMIZE_INLINING, is not working as expected
because <linux/compiler_types.h> is parsed before vclock_gettime.c since
28128c61e08e ("kconfig.h: Include compiler types to avoid missed struct
attributes").

Since then, <linux/compiler_types.h> is included really early by using the
'-include' option.  So, you cannot negate the decision of
<linux/compiler_types.h> in this way.

You can confirm it by checking the pre-processed code, like this:

  $ make arch/x86/entry/vdso/vdso32/vclock_gettime.i

There is no difference with/without CONFIG_CC_OPTIMIZE_FOR_SIZE.

It is about two years since 28128c61e08e.  Nobody has reported a problem
(or, nobody has even noticed the fact that this code is not working).

It is ugly and unreliable to attempt to undefine a CONFIG option from C
files, and anyway the inlining heuristic is up to the compiler.

Just remove the broken code.

Link: http://lkml.kernel.org/r/20200220110807.32534-1-masahiroy@kernel.org
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Acked-by: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/vdso/vdso32/vclock_gettime.c     |    4 ----
 arch/x86/entry/vdso/vdso32/vclock_gettime.c |    4 ----
 2 files changed, 8 deletions(-)

--- a/arch/sparc/vdso/vdso32/vclock_gettime.c~sparcx86-vdso-remove-meaningless-undefining-config_optimize_inlining
+++ a/arch/sparc/vdso/vdso32/vclock_gettime.c
@@ -4,10 +4,6 @@
 
 #define	BUILD_VDSO32
 
-#ifndef	CONFIG_CC_OPTIMIZE_FOR_SIZE
-#undef	CONFIG_OPTIMIZE_INLINING
-#endif
-
 #ifdef	CONFIG_SPARC64
 
 /*
--- a/arch/x86/entry/vdso/vdso32/vclock_gettime.c~sparcx86-vdso-remove-meaningless-undefining-config_optimize_inlining
+++ a/arch/x86/entry/vdso/vdso32/vclock_gettime.c
@@ -1,10 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 #define BUILD_VDSO32
 
-#ifndef CONFIG_CC_OPTIMIZE_FOR_SIZE
-#undef CONFIG_OPTIMIZE_INLINING
-#endif
