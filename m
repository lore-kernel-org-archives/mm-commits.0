Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B76CBC4338F
	for <mm-commits@archiver.kernel.org>; Sat, 14 Aug 2021 22:17:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9923C60F92
	for <mm-commits@archiver.kernel.org>; Sat, 14 Aug 2021 22:17:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229532AbhHNWRm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 14 Aug 2021 18:17:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:57358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232919AbhHNWRl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 14 Aug 2021 18:17:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BB1C760F4B;
        Sat, 14 Aug 2021 22:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1628979433;
        bh=3tSdraFVvDycUjek35M7sppRrggG1Y8vrmRWDwodS9c=;
        h=Date:From:To:Subject:From;
        b=GonFwojrAcpSUYQF+9/37V9VWcLqru5mtXw8db9Rj78Y++cRUFrm09s/5BrX20YZW
         aYVGMIcC3LxltlQ73YysbmOewXH0PQbagnPkED5WNR4dgOWBpfNidZDhkkUOCCmszS
         Ir0IvhvW5k9/BqMRYjm3I8UKzG1LleoxWIhWTa2M=
Date:   Sat, 14 Aug 2021 15:17:12 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, wsa+renesas@sang-engineering.com,
        will@kernel.org, ulf.hansson@linaro.org, lkp@intel.com,
        jolsa@redhat.com, dennis@kernel.org,
        andriy.shevchenko@linux.intel.com, alobakin@pm.me,
        aklimov@redhat.com, yury.norov@gmail.com
Subject:  + include-move-findh-from-asm_generic-to-linux.patch added
 to -mm tree
Message-ID: <20210814221712.MRzoQ%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: include: move find.h from asm_generic to linux
has been added to the -mm tree.  Its filename is
     include-move-findh-from-asm_generic-to-linux.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/include-move-findh-from-asm_generic-to-linux.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/include-move-findh-from-asm_generic-to-linux.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
Cc: kernel test robot <lkp@intel.com>
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
 include/asm-generic/bitops/find.h  |  262 --------------------------
 include/linux/bitmap.h             |    1 
 include/linux/find.h               |  268 +++++++++++++++++++++++++++
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
--- a/include/asm-generic/bitops/find.h
+++ /dev/null
@@ -1,262 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#ifndef _ASM_GENERIC_BITOPS_FIND_H_
-#define _ASM_GENERIC_BITOPS_FIND_H_
-
-extern unsigned long _find_next_bit(const unsigned long *addr1,
-		const unsigned long *addr2, unsigned long nbits,
-		unsigned long start, unsigned long invert, unsigned long le);
-extern unsigned long _find_first_bit(const unsigned long *addr, unsigned long size);
-extern unsigned long _find_first_zero_bit(const unsigned long *addr, unsigned long size);
-extern unsigned long _find_last_bit(const unsigned long *addr, unsigned long size);
-
-#ifndef find_next_bit
-/**
- * find_next_bit - find the next set bit in a memory region
- * @addr: The address to base the search on
- * @offset: The bitnumber to start searching at
- * @size: The bitmap size in bits
- *
- * Returns the bit number for the next set bit
- * If no bits are set, returns @size.
- */
-static inline
-unsigned long find_next_bit(const unsigned long *addr, unsigned long size,
-			    unsigned long offset)
-{
-	if (small_const_nbits(size)) {
-		unsigned long val;
-
-		if (unlikely(offset >= size))
-			return size;
-
-		val = *addr & GENMASK(size - 1, offset);
-		return val ? __ffs(val) : size;
-	}
-
-	return _find_next_bit(addr, NULL, size, offset, 0UL, 0);
-}
-#endif
-
-#ifndef find_next_and_bit
-/**
- * find_next_and_bit - find the next set bit in both memory regions
- * @addr1: The first address to base the search on
- * @addr2: The second address to base the search on
- * @offset: The bitnumber to start searching at
- * @size: The bitmap size in bits
- *
- * Returns the bit number for the next set bit
- * If no bits are set, returns @size.
- */
-static inline
-unsigned long find_next_and_bit(const unsigned long *addr1,
-		const unsigned long *addr2, unsigned long size,
-		unsigned long offset)
-{
-	if (small_const_nbits(size)) {
-		unsigned long val;
-
-		if (unlikely(offset >= size))
-			return size;
-
-		val = *addr1 & *addr2 & GENMASK(size - 1, offset);
-		return val ? __ffs(val) : size;
-	}
-
-	return _find_next_bit(addr1, addr2, size, offset, 0UL, 0);
-}
-#endif
-
-#ifndef find_next_zero_bit
-/**
- * find_next_zero_bit - find the next cleared bit in a memory region
- * @addr: The address to base the search on
- * @offset: The bitnumber to start searching at
- * @size: The bitmap size in bits
- *
- * Returns the bit number of the next zero bit
- * If no bits are zero, returns @size.
- */
-static inline
-unsigned long find_next_zero_bit(const unsigned long *addr, unsigned long size,
-				 unsigned long offset)
-{
-	if (small_const_nbits(size)) {
-		unsigned long val;
-
-		if (unlikely(offset >= size))
-			return size;
-
-		val = *addr | ~GENMASK(size - 1, offset);
-		return val == ~0UL ? size : ffz(val);
-	}
-
-	return _find_next_bit(addr, NULL, size, offset, ~0UL, 0);
-}
-#endif
-
-#ifdef CONFIG_GENERIC_FIND_FIRST_BIT
-
-#ifndef find_first_bit
-/**
- * find_first_bit - find the first set bit in a memory region
- * @addr: The address to start the search at
- * @size: The maximum number of bits to search
- *
- * Returns the bit number of the first set bit.
- * If no bits are set, returns @size.
- */
-static inline
-unsigned long find_first_bit(const unsigned long *addr, unsigned long size)
-{
-	if (small_const_nbits(size)) {
-		unsigned long val = *addr & GENMASK(size - 1, 0);
-
-		return val ? __ffs(val) : size;
-	}
-
-	return _find_first_bit(addr, size);
-}
-#endif
-
-#ifndef find_first_zero_bit
-/**
- * find_first_zero_bit - find the first cleared bit in a memory region
- * @addr: The address to start the search at
- * @size: The maximum number of bits to search
- *
- * Returns the bit number of the first cleared bit.
- * If no bits are zero, returns @size.
- */
-static inline
-unsigned long find_first_zero_bit(const unsigned long *addr, unsigned long size)
-{
-	if (small_const_nbits(size)) {
-		unsigned long val = *addr | ~GENMASK(size - 1, 0);
-
-		return val == ~0UL ? size : ffz(val);
-	}
-
-	return _find_first_zero_bit(addr, size);
-}
-#endif
-
-#else /* CONFIG_GENERIC_FIND_FIRST_BIT */
-
-#ifndef find_first_bit
-#define find_first_bit(addr, size) find_next_bit((addr), (size), 0)
-#endif
-#ifndef find_first_zero_bit
-#define find_first_zero_bit(addr, size) find_next_zero_bit((addr), (size), 0)
-#endif
-
-#endif /* CONFIG_GENERIC_FIND_FIRST_BIT */
-
-#ifndef find_last_bit
-/**
- * find_last_bit - find the last set bit in a memory region
- * @addr: The address to start the search at
- * @size: The number of bits to search
- *
- * Returns the bit number of the last set bit, or size.
- */
-static inline
-unsigned long find_last_bit(const unsigned long *addr, unsigned long size)
-{
-	if (small_const_nbits(size)) {
-		unsigned long val = *addr & GENMASK(size - 1, 0);
-
-		return val ? __fls(val) : size;
-	}
-
-	return _find_last_bit(addr, size);
-}
-#endif
-
-/**
- * find_next_clump8 - find next 8-bit clump with set bits in a memory region
- * @clump: location to store copy of found clump
- * @addr: address to base the search on
- * @size: bitmap size in number of bits
- * @offset: bit offset at which to start searching
- *
- * Returns the bit offset for the next set clump; the found clump value is
- * copied to the location pointed by @clump. If no bits are set, returns @size.
- */
-extern unsigned long find_next_clump8(unsigned long *clump,
-				      const unsigned long *addr,
-				      unsigned long size, unsigned long offset);
-
-#define find_first_clump8(clump, bits, size) \
-	find_next_clump8((clump), (bits), (size), 0)
-
-#if defined(__LITTLE_ENDIAN)
-
-static inline unsigned long find_next_zero_bit_le(const void *addr,
-		unsigned long size, unsigned long offset)
-{
-	return find_next_zero_bit(addr, size, offset);
-}
-
-static inline unsigned long find_next_bit_le(const void *addr,
-		unsigned long size, unsigned long offset)
-{
-	return find_next_bit(addr, size, offset);
-}
-
-static inline unsigned long find_first_zero_bit_le(const void *addr,
-		unsigned long size)
-{
-	return find_first_zero_bit(addr, size);
-}
-
-#elif defined(__BIG_ENDIAN)
-
-#ifndef find_next_zero_bit_le
-static inline
-unsigned long find_next_zero_bit_le(const void *addr, unsigned
-		long size, unsigned long offset)
-{
-	if (small_const_nbits(size)) {
-		unsigned long val = *(const unsigned long *)addr;
-
-		if (unlikely(offset >= size))
-			return size;
-
-		val = swab(val) | ~GENMASK(size - 1, offset);
-		return val == ~0UL ? size : ffz(val);
-	}
-
-	return _find_next_bit(addr, NULL, size, offset, ~0UL, 1);
-}
-#endif
-
-#ifndef find_next_bit_le
-static inline
-unsigned long find_next_bit_le(const void *addr, unsigned
-		long size, unsigned long offset)
-{
-	if (small_const_nbits(size)) {
-		unsigned long val = *(const unsigned long *)addr;
-
-		if (unlikely(offset >= size))
-			return size;
-
-		val = swab(val) & GENMASK(size - 1, offset);
-		return val ? __ffs(val) : size;
-	}
-
-	return _find_next_bit(addr, NULL, size, offset, 0UL, 1);
-}
-#endif
-
-#ifndef find_first_zero_bit_le
-#define find_first_zero_bit_le(addr, size) \
-	find_next_zero_bit_le((addr), (size), 0)
-#endif
-
-#else
-#error "Please fix <asm/byteorder.h>"
-#endif
-
-#endif /*_ASM_GENERIC_BITOPS_FIND_H_ */
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
--- /dev/null
+++ a/include/linux/find.h
@@ -0,0 +1,268 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __LINUX_FIND_H_
+#define __LINUX_FIND_H_
+
+#ifndef __LINUX_BITMAP_H
+#error only <linux/bitmap.h> can be included directly
+#endif
+
+#include <linux/bitops.h>
+
+extern unsigned long _find_next_bit(const unsigned long *addr1,
+		const unsigned long *addr2, unsigned long nbits,
+		unsigned long start, unsigned long invert, unsigned long le);
+extern unsigned long _find_first_bit(const unsigned long *addr, unsigned long size);
+extern unsigned long _find_first_zero_bit(const unsigned long *addr, unsigned long size);
+extern unsigned long _find_last_bit(const unsigned long *addr, unsigned long size);
+
+#ifndef find_next_bit
+/**
+ * find_next_bit - find the next set bit in a memory region
+ * @addr: The address to base the search on
+ * @offset: The bitnumber to start searching at
+ * @size: The bitmap size in bits
+ *
+ * Returns the bit number for the next set bit
+ * If no bits are set, returns @size.
+ */
+static inline
+unsigned long find_next_bit(const unsigned long *addr, unsigned long size,
+			    unsigned long offset)
+{
+	if (small_const_nbits(size)) {
+		unsigned long val;
+
+		if (unlikely(offset >= size))
+			return size;
+
+		val = *addr & GENMASK(size - 1, offset);
+		return val ? __ffs(val) : size;
+	}
+
+	return _find_next_bit(addr, NULL, size, offset, 0UL, 0);
+}
+#endif
+
+#ifndef find_next_and_bit
+/**
+ * find_next_and_bit - find the next set bit in both memory regions
+ * @addr1: The first address to base the search on
+ * @addr2: The second address to base the search on
+ * @offset: The bitnumber to start searching at
+ * @size: The bitmap size in bits
+ *
+ * Returns the bit number for the next set bit
+ * If no bits are set, returns @size.
+ */
+static inline
+unsigned long find_next_and_bit(const unsigned long *addr1,
+		const unsigned long *addr2, unsigned long size,
+		unsigned long offset)
+{
+	if (small_const_nbits(size)) {
+		unsigned long val;
+
+		if (unlikely(offset >= size))
+			return size;
+
+		val = *addr1 & *addr2 & GENMASK(size - 1, offset);
+		return val ? __ffs(val) : size;
+	}
+
+	return _find_next_bit(addr1, addr2, size, offset, 0UL, 0);
+}
+#endif
+
+#ifndef find_next_zero_bit
+/**
+ * find_next_zero_bit - find the next cleared bit in a memory region
+ * @addr: The address to base the search on
+ * @offset: The bitnumber to start searching at
+ * @size: The bitmap size in bits
+ *
+ * Returns the bit number of the next zero bit
+ * If no bits are zero, returns @size.
+ */
+static inline
+unsigned long find_next_zero_bit(const unsigned long *addr, unsigned long size,
+				 unsigned long offset)
+{
+	if (small_const_nbits(size)) {
+		unsigned long val;
+
+		if (unlikely(offset >= size))
+			return size;
+
+		val = *addr | ~GENMASK(size - 1, offset);
+		return val == ~0UL ? size : ffz(val);
+	}
+
+	return _find_next_bit(addr, NULL, size, offset, ~0UL, 0);
+}
+#endif
+
+#ifdef CONFIG_GENERIC_FIND_FIRST_BIT
+
+#ifndef find_first_bit
+/**
+ * find_first_bit - find the first set bit in a memory region
+ * @addr: The address to start the search at
+ * @size: The maximum number of bits to search
+ *
+ * Returns the bit number of the first set bit.
+ * If no bits are set, returns @size.
+ */
+static inline
+unsigned long find_first_bit(const unsigned long *addr, unsigned long size)
+{
+	if (small_const_nbits(size)) {
+		unsigned long val = *addr & GENMASK(size - 1, 0);
+
+		return val ? __ffs(val) : size;
+	}
+
+	return _find_first_bit(addr, size);
+}
+#endif
+
+#ifndef find_first_zero_bit
+/**
+ * find_first_zero_bit - find the first cleared bit in a memory region
+ * @addr: The address to start the search at
+ * @size: The maximum number of bits to search
+ *
+ * Returns the bit number of the first cleared bit.
+ * If no bits are zero, returns @size.
+ */
+static inline
+unsigned long find_first_zero_bit(const unsigned long *addr, unsigned long size)
+{
+	if (small_const_nbits(size)) {
+		unsigned long val = *addr | ~GENMASK(size - 1, 0);
+
+		return val == ~0UL ? size : ffz(val);
+	}
+
+	return _find_first_zero_bit(addr, size);
+}
+#endif
+
+#else /* CONFIG_GENERIC_FIND_FIRST_BIT */
+
+#ifndef find_first_bit
+#define find_first_bit(addr, size) find_next_bit((addr), (size), 0)
+#endif
+#ifndef find_first_zero_bit
+#define find_first_zero_bit(addr, size) find_next_zero_bit((addr), (size), 0)
+#endif
+
+#endif /* CONFIG_GENERIC_FIND_FIRST_BIT */
+
+#ifndef find_last_bit
+/**
+ * find_last_bit - find the last set bit in a memory region
+ * @addr: The address to start the search at
+ * @size: The number of bits to search
+ *
+ * Returns the bit number of the last set bit, or size.
+ */
+static inline
+unsigned long find_last_bit(const unsigned long *addr, unsigned long size)
+{
+	if (small_const_nbits(size)) {
+		unsigned long val = *addr & GENMASK(size - 1, 0);
+
+		return val ? __fls(val) : size;
+	}
+
+	return _find_last_bit(addr, size);
+}
+#endif
+
+/**
+ * find_next_clump8 - find next 8-bit clump with set bits in a memory region
+ * @clump: location to store copy of found clump
+ * @addr: address to base the search on
+ * @size: bitmap size in number of bits
+ * @offset: bit offset at which to start searching
+ *
+ * Returns the bit offset for the next set clump; the found clump value is
+ * copied to the location pointed by @clump. If no bits are set, returns @size.
+ */
+extern unsigned long find_next_clump8(unsigned long *clump,
+				      const unsigned long *addr,
+				      unsigned long size, unsigned long offset);
+
+#define find_first_clump8(clump, bits, size) \
+	find_next_clump8((clump), (bits), (size), 0)
+
+#if defined(__LITTLE_ENDIAN)
+
+static inline unsigned long find_next_zero_bit_le(const void *addr,
+		unsigned long size, unsigned long offset)
+{
+	return find_next_zero_bit(addr, size, offset);
+}
+
+static inline unsigned long find_next_bit_le(const void *addr,
+		unsigned long size, unsigned long offset)
+{
+	return find_next_bit(addr, size, offset);
+}
+
+static inline unsigned long find_first_zero_bit_le(const void *addr,
+		unsigned long size)
+{
+	return find_first_zero_bit(addr, size);
+}
+
+#elif defined(__BIG_ENDIAN)
+
+#ifndef find_next_zero_bit_le
+static inline
+unsigned long find_next_zero_bit_le(const void *addr, unsigned
+		long size, unsigned long offset)
+{
+	if (small_const_nbits(size)) {
+		unsigned long val = *(const unsigned long *)addr;
+
+		if (unlikely(offset >= size))
+			return size;
+
+		val = swab(val) | ~GENMASK(size - 1, offset);
+		return val == ~0UL ? size : ffz(val);
+	}
+
+	return _find_next_bit(addr, NULL, size, offset, ~0UL, 1);
+}
+#endif
+
+#ifndef find_next_bit_le
+static inline
+unsigned long find_next_bit_le(const void *addr, unsigned
+		long size, unsigned long offset)
+{
+	if (small_const_nbits(size)) {
+		unsigned long val = *(const unsigned long *)addr;
+
+		if (unlikely(offset >= size))
+			return size;
+
+		val = swab(val) & GENMASK(size - 1, offset);
+		return val ? __ffs(val) : size;
+	}
+
+	return _find_next_bit(addr, NULL, size, offset, 0UL, 1);
+}
+#endif
+
+#ifndef find_first_zero_bit_le
+#define find_first_zero_bit_le(addr, size) \
+	find_next_zero_bit_le((addr), (size), 0)
+#endif
+
+#else
+#error "Please fix <asm/byteorder.h>"
+#endif
+
+#endif /*__LINUX_FIND_H_ */
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

Patches currently in -mm which might be from yury.norov@gmail.com are

bitops-protect-find_first_zero_bit-properly.patch
bitops-move-find_bit__le-functions-from-leh-to-findh.patch
include-move-findh-from-asm_generic-to-linux.patch
arch-remove-generic_find_first_bit-entirely.patch
lib-add-find_first_and_bit.patch
cpumask-use-find_first_and_bit.patch
all-replace-find_next_zero_bit-with-find_first_zero_bit-where-appropriate.patch
tools-sync-tools-bitmap-with-mother-linux.patch
cpumask-replace-cpumask_next_-with-cpumask_first_-where-appropriate.patch
include-linux-move-for_each_bit-macros-from-bitopsh-to-findh.patch
find-micro-optimize-for_each_setclear_bit.patch
replace-for_each__bit_from-with-for_each__bit-where-appropriate.patch
mm-percpu-micro-optimize-pcpu_is_populated.patch
bitmap-unify-find_bit-operations.patch
lib-bitmap-add-performance-test-for-bitmap_print_to_pagebuf.patch
vsprintf-rework-bitmap_list_string.patch

