Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8E05C433FE
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:59:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AFA986115A
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:59:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347404AbhIHDAQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Sep 2021 23:00:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:58120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234389AbhIHDAM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Sep 2021 23:00:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 995C261131;
        Wed,  8 Sep 2021 02:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631069945;
        bh=4MUyZ5fBTCXqA9qz3u3fXepw/nu66zAxnZ8Deg/oivg=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=cCbkLKqfN8g8VMEhz0iBWyV8BNDHb/FEg30eTGWKoJEdzG7/0uv0ItK9viI+7H0n5
         hsQhPej8QJqlJUkHgq+Sp5e0dDQ8RxV1tk4S6ngY2YXn+xIuOyy8tP1VPDvaWTUfqD
         GLxVEshu842vbYQ0loN09shAfCtCoKwHsn1LUJSM=
Date:   Tue, 07 Sep 2021 19:59:04 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     aklimov@redhat.com, akpm@linux-foundation.org, alobakin@pm.me,
        andriy.shevchenko@linux.intel.com, dennis@kernel.org,
        jolsa@redhat.com, linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, ulf.hansson@linaro.org,
        will@kernel.org, wsa+renesas@sang-engineering.com,
        yury.norov@gmail.com
Subject:  [patch 109/147] include: move find.h from asm_generic to
 linux
Message-ID: <20210908025904.mie2fTUKk%akpm@linux-foundation.org>
In-Reply-To: <20210907195226.14b1d22a07c085b22968b933@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Yury Norov <yury.norov@gmail.com>
Subject: include: move find.h from asm_generic to linux

find_bit API and bitmap API are closely related, but inclusion paths are
different - include/asm-generic and include/linux, correspondingly.  In
the past it made a lot of troubles due to circular dependencies and/or
undefined symbols.  Fix this by moving find.h under include/linux.

Link: https://lkml.kernel.org/r/20210814211713.180533-4-yury.norov@gmail.com
Signed-off-by: Yury Norov <yury.norov@gmail.com>
Tested-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Cc: Alexander Lobakin <alobakin@pm.me>
Cc: Alexey Klimov <aklimov@redhat.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS                        |    2 
 arch/alpha/include/asm/bitops.h    |    2 
 arch/arc/include/asm/bitops.h      |    1 
 arch/arm/include/asm/bitops.h      |    1 
 arch/arm64/include/asm/bitops.h    |    1 
 arch/csky/include/asm/bitops.h     |    1 
 arch/h8300/include/asm/bitops.h    |    1 
 arch/hexagon/include/asm/bitops.h  |    1 
 arch/ia64/include/asm/bitops.h     |    2 
 arch/m68k/include/asm/bitops.h     |    2 
 arch/mips/include/asm/bitops.h     |    1 
 arch/openrisc/include/asm/bitops.h |    1 
 arch/parisc/include/asm/bitops.h   |    2 
 arch/powerpc/include/asm/bitops.h  |    2 
 arch/riscv/include/asm/bitops.h    |    1 
 arch/s390/include/asm/bitops.h     |    1 
 arch/sh/include/asm/bitops.h       |    1 
 arch/sparc/include/asm/bitops_32.h |    1 
 arch/sparc/include/asm/bitops_64.h |    2 
 arch/x86/include/asm/bitops.h      |    2 
 arch/xtensa/include/asm/bitops.h   |    1 
 include/asm-generic/bitops.h       |    1 
 include/linux/bitmap.h             |    1 
 include/{asm-generic/bitops => linux}/find.h | 12 +++++++++---
 25 files changed, 270 insertions(+), 291 deletions(-)

--- a/arch/alpha/include/asm/bitops.h~include-move-findh-from-asm_generic-to-linux
+++ a/arch/alpha/include/asm/bitops.h
@@ -430,8 +430,6 @@ static inline unsigned int __arch_hweigh
 
 #endif /* __KERNEL__ */
 
-#include <asm-generic/bitops/find.h>
-
 #ifdef __KERNEL__
 
 /*
--- a/arch/arc/include/asm/bitops.h~include-move-findh-from-asm_generic-to-linux
+++ a/arch/arc/include/asm/bitops.h
@@ -369,7 +369,6 @@ static inline __attribute__ ((const)) un
 #include <asm-generic/bitops/sched.h>
 #include <asm-generic/bitops/lock.h>
 
-#include <asm-generic/bitops/find.h>
 #include <asm-generic/bitops/le.h>
 #include <asm-generic/bitops/ext2-atomic-setbit.h>
 
--- a/arch/arm64/include/asm/bitops.h~include-move-findh-from-asm_generic-to-linux
+++ a/arch/arm64/include/asm/bitops.h
@@ -18,7 +18,6 @@
 
 #include <asm-generic/bitops/ffz.h>
 #include <asm-generic/bitops/fls64.h>
-#include <asm-generic/bitops/find.h>
 
 #include <asm-generic/bitops/sched.h>
 #include <asm-generic/bitops/hweight.h>
--- a/arch/arm/include/asm/bitops.h~include-move-findh-from-asm_generic-to-linux
+++ a/arch/arm/include/asm/bitops.h
@@ -264,7 +264,6 @@ static inline int find_next_bit_le(const
 
 #endif
 
-#include <asm-generic/bitops/find.h>
 #include <asm-generic/bitops/le.h>
 
 /*
--- a/arch/csky/include/asm/bitops.h~include-move-findh-from-asm_generic-to-linux
+++ a/arch/csky/include/asm/bitops.h
@@ -59,7 +59,6 @@ static __always_inline unsigned long __f
 
 #include <asm-generic/bitops/ffz.h>
 #include <asm-generic/bitops/fls64.h>
-#include <asm-generic/bitops/find.h>
 
 #ifndef _LINUX_BITOPS_H
 #error only <linux/bitops.h> can be included directly
--- a/arch/h8300/include/asm/bitops.h~include-move-findh-from-asm_generic-to-linux
+++ a/arch/h8300/include/asm/bitops.h
@@ -168,7 +168,6 @@ static inline unsigned long __ffs(unsign
 	return result;
 }
 
-#include <asm-generic/bitops/find.h>
 #include <asm-generic/bitops/sched.h>
 #include <asm-generic/bitops/hweight.h>
 #include <asm-generic/bitops/lock.h>
--- a/arch/hexagon/include/asm/bitops.h~include-move-findh-from-asm_generic-to-linux
+++ a/arch/hexagon/include/asm/bitops.h
@@ -271,7 +271,6 @@ static inline unsigned long __fls(unsign
 }
 
 #include <asm-generic/bitops/lock.h>
-#include <asm-generic/bitops/find.h>
 
 #include <asm-generic/bitops/fls64.h>
 #include <asm-generic/bitops/sched.h>
--- a/arch/ia64/include/asm/bitops.h~include-move-findh-from-asm_generic-to-linux
+++ a/arch/ia64/include/asm/bitops.h
@@ -441,8 +441,6 @@ static __inline__ unsigned long __arch_h
 
 #endif /* __KERNEL__ */
 
-#include <asm-generic/bitops/find.h>
-
 #ifdef __KERNEL__
 
 #include <asm-generic/bitops/le.h>
--- a/arch/m68k/include/asm/bitops.h~include-move-findh-from-asm_generic-to-linux
+++ a/arch/m68k/include/asm/bitops.h
@@ -529,6 +529,4 @@ static inline int __fls(int x)
 #include <asm-generic/bitops/le.h>
 #endif /* __KERNEL__ */
 
-#include <asm-generic/bitops/find.h>
-
 #endif /* _M68K_BITOPS_H */
--- a/arch/mips/include/asm/bitops.h~include-move-findh-from-asm_generic-to-linux
+++ a/arch/mips/include/asm/bitops.h
@@ -446,7 +446,6 @@ static inline int ffs(int word)
 }
 
 #include <asm-generic/bitops/ffz.h>
-#include <asm-generic/bitops/find.h>
 
 #ifdef __KERNEL__
 
--- a/arch/openrisc/include/asm/bitops.h~include-move-findh-from-asm_generic-to-linux
+++ a/arch/openrisc/include/asm/bitops.h
@@ -30,7 +30,6 @@
 #include <asm/bitops/fls.h>
 #include <asm/bitops/__fls.h>
 #include <asm-generic/bitops/fls64.h>
-#include <asm-generic/bitops/find.h>
 
 #ifndef _LINUX_BITOPS_H
 #error only <linux/bitops.h> can be included directly
--- a/arch/parisc/include/asm/bitops.h~include-move-findh-from-asm_generic-to-linux
+++ a/arch/parisc/include/asm/bitops.h
@@ -208,8 +208,6 @@ static __inline__ int fls(unsigned int x
 
 #endif /* __KERNEL__ */
 
-#include <asm-generic/bitops/find.h>
-
 #ifdef __KERNEL__
 
 #include <asm-generic/bitops/le.h>
--- a/arch/powerpc/include/asm/bitops.h~include-move-findh-from-asm_generic-to-linux
+++ a/arch/powerpc/include/asm/bitops.h
@@ -255,8 +255,6 @@ unsigned long __arch_hweight64(__u64 w);
 #include <asm-generic/bitops/hweight.h>
 #endif
 
-#include <asm-generic/bitops/find.h>
-
 /* wrappers that deal with KASAN instrumentation */
 #include <asm-generic/bitops/instrumented-atomic.h>
 #include <asm-generic/bitops/instrumented-lock.h>
--- a/arch/riscv/include/asm/bitops.h~include-move-findh-from-asm_generic-to-linux
+++ a/arch/riscv/include/asm/bitops.h
@@ -20,7 +20,6 @@
 #include <asm-generic/bitops/fls.h>
 #include <asm-generic/bitops/__fls.h>
 #include <asm-generic/bitops/fls64.h>
-#include <asm-generic/bitops/find.h>
 #include <asm-generic/bitops/sched.h>
 #include <asm-generic/bitops/ffs.h>
 
--- a/arch/s390/include/asm/bitops.h~include-move-findh-from-asm_generic-to-linux
+++ a/arch/s390/include/asm/bitops.h
@@ -387,7 +387,6 @@ static inline int fls(unsigned int word)
 #endif /* CONFIG_HAVE_MARCH_Z9_109_FEATURES */
 
 #include <asm-generic/bitops/ffz.h>
-#include <asm-generic/bitops/find.h>
 #include <asm-generic/bitops/hweight.h>
 #include <asm-generic/bitops/sched.h>
 #include <asm-generic/bitops/le.h>
--- a/arch/sh/include/asm/bitops.h~include-move-findh-from-asm_generic-to-linux
+++ a/arch/sh/include/asm/bitops.h
@@ -68,6 +68,5 @@ static inline unsigned long __ffs(unsign
 #include <asm-generic/bitops/fls64.h>
 
 #include <asm-generic/bitops/le.h>
-#include <asm-generic/bitops/find.h>
 
 #endif /* __ASM_SH_BITOPS_H */
--- a/arch/sparc/include/asm/bitops_32.h~include-move-findh-from-asm_generic-to-linux
+++ a/arch/sparc/include/asm/bitops_32.h
@@ -100,7 +100,6 @@ static inline void change_bit(unsigned l
 #include <asm-generic/bitops/fls64.h>
 #include <asm-generic/bitops/hweight.h>
 #include <asm-generic/bitops/lock.h>
-#include <asm-generic/bitops/find.h>
 #include <asm-generic/bitops/le.h>
 #include <asm-generic/bitops/ext2-atomic.h>
 
--- a/arch/sparc/include/asm/bitops_64.h~include-move-findh-from-asm_generic-to-linux
+++ a/arch/sparc/include/asm/bitops_64.h
@@ -52,8 +52,6 @@ unsigned int __arch_hweight8(unsigned in
 #include <asm-generic/bitops/lock.h>
 #endif /* __KERNEL__ */
 
-#include <asm-generic/bitops/find.h>
-
 #ifdef __KERNEL__
 
 #include <asm-generic/bitops/le.h>
--- a/arch/x86/include/asm/bitops.h~include-move-findh-from-asm_generic-to-linux
+++ a/arch/x86/include/asm/bitops.h
@@ -380,8 +380,6 @@ static __always_inline int fls64(__u64 x
 #include <asm-generic/bitops/fls64.h>
 #endif
 
-#include <asm-generic/bitops/find.h>
-
 #include <asm-generic/bitops/sched.h>
 
 #include <asm/arch_hweight.h>
--- a/arch/xtensa/include/asm/bitops.h~include-move-findh-from-asm_generic-to-linux
+++ a/arch/xtensa/include/asm/bitops.h
@@ -205,7 +205,6 @@ BIT_OPS(change, "xor", )
 #undef BIT_OP
 #undef TEST_AND_BIT_OP
 
-#include <asm-generic/bitops/find.h>
 #include <asm-generic/bitops/le.h>
 
 #include <asm-generic/bitops/ext2-atomic-setbit.h>
--- a/include/asm-generic/bitops.h~include-move-findh-from-asm_generic-to-linux
+++ a/include/asm-generic/bitops.h
@@ -20,7 +20,6 @@
 #include <asm-generic/bitops/fls.h>
 #include <asm-generic/bitops/__fls.h>
 #include <asm-generic/bitops/fls64.h>
-#include <asm-generic/bitops/find.h>
 
 #ifndef _LINUX_BITOPS_H
 #error only <linux/bitops.h> can be included directly
--- a/include/linux/bitmap.h~include-move-findh-from-asm_generic-to-linux
+++ a/include/linux/bitmap.h
@@ -6,6 +6,7 @@
 
 #include <linux/align.h>
 #include <linux/bitops.h>
+#include <linux/find.h>
 #include <linux/limits.h>
 #include <linux/string.h>
 #include <linux/types.h>
--- a/MAINTAINERS~include-move-findh-from-asm_generic-to-linux
+++ a/MAINTAINERS
@@ -3262,8 +3262,8 @@ M:	Yury Norov <yury.norov@gmail.com>
 R:	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
 R:	Rasmus Villemoes <linux@rasmusvillemoes.dk>
 S:	Maintained
-F:	include/asm-generic/bitops/find.h
 F:	include/linux/bitmap.h
+F:	include/linux/find.h
 F:	lib/bitmap.c
 F:	lib/find_bit.c
 F:	lib/find_bit_benchmark.c
_
