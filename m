Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95F42C43470
	for <mm-commits@archiver.kernel.org>; Thu,  1 Apr 2021 00:54:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6CCBB610CB
	for <mm-commits@archiver.kernel.org>; Thu,  1 Apr 2021 00:54:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232585AbhDAAyS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 31 Mar 2021 20:54:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:33116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232718AbhDAAx6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 31 Mar 2021 20:53:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0E68D6108D;
        Thu,  1 Apr 2021 00:53:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1617238437;
        bh=x383cbHitXhB7l1M9gSaBlKxtx9z53zT2GrzA1bS7sk=;
        h=Date:From:To:Subject:From;
        b=EvYV4DYdJ4v77XZMVh/4e5c8M4c6TSfPZJ0dRBdaP4iDij2JHSmYQXrv56xaS4PEo
         LQf1pryL50u3eIzD0HpSHYFLxY6x36PeJ0I0wxWzzv+WsjqaYcazxlXv04g5LUrgDl
         gzRF+jCk/AHgzW3lEYFNjeDD3ezp+hMu9+ZMjXls=
Date:   Wed, 31 Mar 2021 17:53:56 -0700
From:   akpm@linux-foundation.org
To:     aklimov@redhat.com, andriy.shevchenko@linux.intel.com,
        arnd@arndb.de, dalias@libc.org, dennis@kernel.org,
        dsterba@suse.com, geert@linux-m68k.org,
        glaubitz@physik.fu-berlin.de, jianpeng.ma@intel.com,
        joe@perches.com, jpoimboe@redhat.com, linux@rasmusvillemoes.dk,
        mm-commits@vger.kernel.org, richard.weiyang@linux.alibaba.com,
        sbrivio@redhat.com, wsa+renesas@sang-engineering.com,
        ysato@users.osdn.me, yury.norov@gmail.com
Subject:  + lib-inline-_find_next_bit-wrappers.patch added to -mm
 tree
Message-ID: <20210401005356.HoCE39C9U%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib: inline _find_next_bit() wrappers
has been added to the -mm tree.  Its filename is
     lib-inline-_find_next_bit-wrappers.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/lib-inline-_find_next_bit-wrappers.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/lib-inline-_find_next_bit-wrappers.patch

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
Subject: lib: inline _find_next_bit() wrappers

lib/find_bit.c declares five single-line wrappers for _find_next_bit(). 
We may turn those wrappers to inline functions.  It eliminates unneeded
function calls and opens room for compile-time optimizations.

Link: https://lkml.kernel.org/r/20210401003153.97325-8-yury.norov@gmail.com
Signed-off-by: Yury Norov <yury.norov@gmail.com>
Acked-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Alexey Klimov <aklimov@redhat.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
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

 include/asm-generic/bitops/find.h |   28 +++++++++++---
 include/asm-generic/bitops/le.h   |   17 ++++++--
 lib/find_bit.c                    |   56 +---------------------------
 3 files changed, 37 insertions(+), 64 deletions(-)

--- a/include/asm-generic/bitops/find.h~lib-inline-_find_next_bit-wrappers
+++ a/include/asm-generic/bitops/find.h
@@ -2,6 +2,10 @@
 #ifndef _ASM_GENERIC_BITOPS_FIND_H_
 #define _ASM_GENERIC_BITOPS_FIND_H_
 
+extern unsigned long _find_next_bit(const unsigned long *addr1,
+		const unsigned long *addr2, unsigned long nbits,
+		unsigned long start, unsigned long invert, unsigned long le);
+
 #ifndef find_next_bit
 /**
  * find_next_bit - find the next set bit in a memory region
@@ -12,8 +16,12 @@
  * Returns the bit number for the next set bit
  * If no bits are set, returns @size.
  */
-extern unsigned long find_next_bit(const unsigned long *addr, unsigned long
-		size, unsigned long offset);
+static inline
+unsigned long find_next_bit(const unsigned long *addr, unsigned long size,
+			    unsigned long offset)
+{
+	return _find_next_bit(addr, NULL, size, offset, 0UL, 0);
+}
 #endif
 
 #ifndef find_next_and_bit
@@ -27,9 +35,13 @@ extern unsigned long find_next_bit(const
  * Returns the bit number for the next set bit
  * If no bits are set, returns @size.
  */
-extern unsigned long find_next_and_bit(const unsigned long *addr1,
+static inline
+unsigned long find_next_and_bit(const unsigned long *addr1,
 		const unsigned long *addr2, unsigned long size,
-		unsigned long offset);
+		unsigned long offset)
+{
+	return _find_next_bit(addr1, addr2, size, offset, 0UL, 0);
+}
 #endif
 
 #ifndef find_next_zero_bit
@@ -42,8 +54,12 @@ extern unsigned long find_next_and_bit(c
  * Returns the bit number of the next zero bit
  * If no bits are zero, returns @size.
  */
-extern unsigned long find_next_zero_bit(const unsigned long *addr, unsigned
-		long size, unsigned long offset);
+static inline
+unsigned long find_next_zero_bit(const unsigned long *addr, unsigned long size,
+				 unsigned long offset)
+{
+	return _find_next_bit(addr, NULL, size, offset, ~0UL, 0);
+}
 #endif
 
 #ifdef CONFIG_GENERIC_FIND_FIRST_BIT
--- a/include/asm-generic/bitops/le.h~lib-inline-_find_next_bit-wrappers
+++ a/include/asm-generic/bitops/le.h
@@ -2,6 +2,7 @@
 #ifndef _ASM_GENERIC_BITOPS_LE_H_
 #define _ASM_GENERIC_BITOPS_LE_H_
 
+#include <asm-generic/bitops/find.h>
 #include <asm/types.h>
 #include <asm/byteorder.h>
 
@@ -32,13 +33,21 @@ static inline unsigned long find_first_z
 #define BITOP_LE_SWIZZLE	((BITS_PER_LONG-1) & ~0x7)
 
 #ifndef find_next_zero_bit_le
-extern unsigned long find_next_zero_bit_le(const void *addr,
-		unsigned long size, unsigned long offset);
+static inline
+unsigned long find_next_zero_bit_le(const void *addr, unsigned
+		long size, unsigned long offset)
+{
+	return _find_next_bit(addr, NULL, size, offset, ~0UL, 1);
+}
 #endif
 
 #ifndef find_next_bit_le
-extern unsigned long find_next_bit_le(const void *addr,
-		unsigned long size, unsigned long offset);
+static inline
+unsigned long find_next_bit_le(const void *addr, unsigned
+		long size, unsigned long offset)
+{
+	return _find_next_bit(addr, NULL, size, offset, 0UL, 1);
+}
 #endif
 
 #ifndef find_first_zero_bit_le
--- a/lib/find_bit.c~lib-inline-_find_next_bit-wrappers
+++ a/lib/find_bit.c
@@ -29,7 +29,7 @@
  *    searching it for one bits.
  *  - The optional "addr2", which is anded with "addr1" if present.
  */
-static unsigned long _find_next_bit(const unsigned long *addr1,
+unsigned long _find_next_bit(const unsigned long *addr1,
 		const unsigned long *addr2, unsigned long nbits,
 		unsigned long start, unsigned long invert, unsigned long le)
 {
@@ -68,37 +68,7 @@ static unsigned long _find_next_bit(cons
 
 	return min(start + __ffs(tmp), nbits);
 }
-#endif
-
-#ifndef find_next_bit
-/*
- * Find the next set bit in a memory region.
- */
-unsigned long find_next_bit(const unsigned long *addr, unsigned long size,
-			    unsigned long offset)
-{
-	return _find_next_bit(addr, NULL, size, offset, 0UL, 0);
-}
-EXPORT_SYMBOL(find_next_bit);
-#endif
-
-#ifndef find_next_zero_bit
-unsigned long find_next_zero_bit(const unsigned long *addr, unsigned long size,
-				 unsigned long offset)
-{
-	return _find_next_bit(addr, NULL, size, offset, ~0UL, 0);
-}
-EXPORT_SYMBOL(find_next_zero_bit);
-#endif
-
-#if !defined(find_next_and_bit)
-unsigned long find_next_and_bit(const unsigned long *addr1,
-		const unsigned long *addr2, unsigned long size,
-		unsigned long offset)
-{
-	return _find_next_bit(addr1, addr2, size, offset, 0UL, 0);
-}
-EXPORT_SYMBOL(find_next_and_bit);
+EXPORT_SYMBOL(_find_next_bit);
 #endif
 
 #ifndef find_first_bit
@@ -157,28 +127,6 @@ unsigned long find_last_bit(const unsign
 EXPORT_SYMBOL(find_last_bit);
 #endif
 
-#ifdef __BIG_ENDIAN
-
-#ifndef find_next_zero_bit_le
-unsigned long find_next_zero_bit_le(const void *addr, unsigned
-		long size, unsigned long offset)
-{
-	return _find_next_bit(addr, NULL, size, offset, ~0UL, 1);
-}
-EXPORT_SYMBOL(find_next_zero_bit_le);
-#endif
-
-#ifndef find_next_bit_le
-unsigned long find_next_bit_le(const void *addr, unsigned
-		long size, unsigned long offset)
-{
-	return _find_next_bit(addr, NULL, size, offset, 0UL, 1);
-}
-EXPORT_SYMBOL(find_next_bit_le);
-#endif
-
-#endif /* __BIG_ENDIAN */
-
 unsigned long find_next_clump8(unsigned long *clump, const unsigned long *addr,
 			       unsigned long size, unsigned long offset)
 {
_

Patches currently in -mm which might be from yury.norov@gmail.com are

tools-disable-wno-type-limits.patch
tools-bitmap-sync-function-declarations-with-the-kernel.patch
tools-sync-bitmap_last_word_mask-macro-with-the-kernel.patch
arch-rearrange-headers-inclusion-order-in-asm-bitops-for-m68k-and-sh.patch
lib-extend-the-scope-of-small_const_nbits-macro.patch
tools-sync-small_const_nbits-macro-with-the-kernel.patch
lib-inline-_find_next_bit-wrappers.patch
tools-sync-find_next_bit-implementation.patch
lib-add-fast-path-for-find_next__bit.patch
lib-add-fast-path-for-find_first__bit-and-find_last_bit.patch
tools-sync-lib-find_bit-implementation.patch
maintainers-add-entry-for-the-bitmap-api.patch

