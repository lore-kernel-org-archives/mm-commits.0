Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EED56C433ED
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:52:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D52CD60233
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:52:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbhEHWxi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:53:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:41046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229559AbhEHWxi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:53:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E271560E0B;
        Sat,  8 May 2021 22:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514356;
        bh=IK/IFuDSr7n903Nd0W/r9PrTypEZgsjS4LBWKC10yi4=;
        h=Date:From:To:Subject:From;
        b=i9iMK1m9Cg3g5T2UIuPSzI6uACh4wp4ZW79WFiS32y8o+IFJA2WtydG3Q8ICYci3A
         4scdPpAyGhP48V/qAR4qdEr9HfkTD8PU/c32VoL7VMMgc03vFcWta11B2nIIfjzr91
         t0igAivYWbShrPcWPnwjJN9q/8O2X2JrLQdotxzw=
Date:   Sat, 08 May 2021 15:52:35 -0700
From:   akpm@linux-foundation.org
To:     aklimov@redhat.com, andy.shevchenko@gmail.com, arnd@arndb.de,
        dalias@libc.org, dennis@kernel.org, dsterba@suse.com,
        geert@linux-m68k.org, glaubitz@physik.fu-berlin.de,
        jianpeng.ma@intel.com, joe@perches.com, jpoimboe@redhat.com,
        linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org,
        richard.weiyang@linux.alibaba.com, sbrivio@redhat.com,
        wsa+renesas@sang-engineering.com, ysato@users.osdn.me,
        yury.norov@gmail.com
Subject:  [merged] lib-add-fast-path-for-find_next__bit.patch
 removed from -mm tree
Message-ID: <20210508225235.lk5BgHBy-%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib: add fast path for find_next_*_bit()
has been removed from the -mm tree.  Its filename was
     lib-add-fast-path-for-find_next__bit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yury Norov <yury.norov@gmail.com>
Subject: lib: add fast path for find_next_*_bit()

Similarly to bitmap functions, find_next_*_bit() users will benefit if
we'll handle a case of bitmaps that fit into a single word inline.  In the
very best case, the compiler may replace a function call with a few
instructions.

This is the quite typical find_next_bit() user:

	unsigned int cpumask_next(int n, const struct cpumask *srcp)
	{
		/* -1 is a legal arg here. */
		if (n != -1)
			cpumask_check(n);
		return find_next_bit(cpumask_bits(srcp), nr_cpumask_bits, n + 1);
	}
	EXPORT_SYMBOL(cpumask_next);

Currently, on ARM64 the generated code looks like this:
	0000000000000000 <cpumask_next>:
	   0:   a9bf7bfd        stp     x29, x30, [sp, #-16]!
	   4:   11000402        add     w2, w0, #0x1
	   8:   aa0103e0        mov     x0, x1
	   c:   d2800401        mov     x1, #0x40                       // #64
	  10:   910003fd        mov     x29, sp
	  14:   93407c42        sxtw    x2, w2
	  18:   94000000        bl      0 <find_next_bit>
	  1c:   a8c17bfd        ldp     x29, x30, [sp], #16
	  20:   d65f03c0        ret
	  24:   d503201f        nop

After applying this patch:
	0000000000000140 <cpumask_next>:
	 140:   11000400        add     w0, w0, #0x1
	 144:   93407c00        sxtw    x0, w0
	 148:   f100fc1f        cmp     x0, #0x3f
	 14c:   54000168        b.hi    178 <cpumask_next+0x38>  // b.pmore
	 150:   f9400023        ldr     x3, [x1]
	 154:   92800001        mov     x1, #0xffffffffffffffff         // #-1
	 158:   9ac02020        lsl     x0, x1, x0
	 15c:   52800802        mov     w2, #0x40                       // #64
	 160:   8a030001        and     x1, x0, x3
	 164:   dac00020        rbit    x0, x1
	 168:   f100003f        cmp     x1, #0x0
	 16c:   dac01000        clz     x0, x0
	 170:   1a800040        csel    w0, w2, w0, eq  // eq = none
	 174:   d65f03c0        ret
	 178:   52800800        mov     w0, #0x40                       // #64
	 17c:   d65f03c0        ret

find_next_bit() call is replaced with 6 instructions.  find_next_bit()
itself is 41 instructions plus function call overhead.

Despite inlining, the scripts/bloat-o-meter report smaller .text size
after applying the series:
	add/remove: 11/9 grow/shrink: 233/176 up/down: 5780/-6768 (-988)

Link: https://lkml.kernel.org/r/20210401003153.97325-10-yury.norov@gmail.com
Signed-off-by: Yury Norov <yury.norov@gmail.com>
Acked-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Acked-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Alexey Klimov <aklimov@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: David Sterba <dsterba@suse.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Jianpeng Ma <jianpeng.ma@intel.com>
Cc: Joe Perches <joe@perches.com>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Rich Felker <dalias@libc.org>
Cc: Stefano Brivio <sbrivio@redhat.com>
Cc: Wei Yang <richard.weiyang@linux.alibaba.com>
Cc: Wolfram Sang <wsa+renesas@sang-engineering.com>
Cc: Yoshinori Sato <ysato@users.osdn.me>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/bitops/find.h |   30 ++++++++++++++++++++++++++++
 include/asm-generic/bitops/le.h   |   21 +++++++++++++++++++
 2 files changed, 51 insertions(+)

--- a/include/asm-generic/bitops/find.h~lib-add-fast-path-for-find_next__bit
+++ a/include/asm-generic/bitops/find.h
@@ -20,6 +20,16 @@ static inline
 unsigned long find_next_bit(const unsigned long *addr, unsigned long size,
 			    unsigned long offset)
 {
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
 	return _find_next_bit(addr, NULL, size, offset, 0UL, 0);
 }
 #endif
@@ -40,6 +50,16 @@ unsigned long find_next_and_bit(const un
 		const unsigned long *addr2, unsigned long size,
 		unsigned long offset)
 {
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
 	return _find_next_bit(addr1, addr2, size, offset, 0UL, 0);
 }
 #endif
@@ -58,6 +78,16 @@ static inline
 unsigned long find_next_zero_bit(const unsigned long *addr, unsigned long size,
 				 unsigned long offset)
 {
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
 	return _find_next_bit(addr, NULL, size, offset, ~0UL, 0);
 }
 #endif
--- a/include/asm-generic/bitops/le.h~lib-add-fast-path-for-find_next__bit
+++ a/include/asm-generic/bitops/le.h
@@ -5,6 +5,7 @@
 #include <asm-generic/bitops/find.h>
 #include <asm/types.h>
 #include <asm/byteorder.h>
+#include <linux/swab.h>
 
 #if defined(__LITTLE_ENDIAN)
 
@@ -37,6 +38,16 @@ static inline
 unsigned long find_next_zero_bit_le(const void *addr, unsigned
 		long size, unsigned long offset)
 {
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
 	return _find_next_bit(addr, NULL, size, offset, ~0UL, 1);
 }
 #endif
@@ -46,6 +57,16 @@ static inline
 unsigned long find_next_bit_le(const void *addr, unsigned
 		long size, unsigned long offset)
 {
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
 	return _find_next_bit(addr, NULL, size, offset, 0UL, 1);
 }
 #endif
_

Patches currently in -mm which might be from yury.norov@gmail.com are


