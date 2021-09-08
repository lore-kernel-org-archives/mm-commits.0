Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0C51C433FE
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:59:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DAE1861152
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:59:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347409AbhIHDAJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Sep 2021 23:00:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:58060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347404AbhIHDAI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Sep 2021 23:00:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6BE2161100;
        Wed,  8 Sep 2021 02:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631069941;
        bh=rt/0LEDS94KR6JnUFpZ6oPyGeOIHftPXZZdBPwQxRko=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ETS6K4/uAIww3BNmovZgmTX8b+T0G0j0A3O4ihkv+i1qmevZkTrPoGt+Tbl4Q993U
         lmegARfycALyt9T6SpLqeZAjymqiJqpiI3IS7u19YmhiGSAkHOvRrQEPcSPyXP94OS
         krDCd0t3OhLUj+kqXAQHbQ+mhrT0UYcct3R6cTTU=
Date:   Tue, 07 Sep 2021 19:59:01 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     aklimov@redhat.com, akpm@linux-foundation.org, alobakin@pm.me,
        andriy.shevchenko@linux.intel.com, dennis@kernel.org,
        jolsa@redhat.com, linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, ulf.hansson@linaro.org,
        will@kernel.org, wsa+renesas@sang-engineering.com,
        yury.norov@gmail.com
Subject:  [patch 108/147] bitops: move find_bit_*_le functions from
 le.h to find.h
Message-ID: <20210908025901.gV9fu4cei%akpm@linux-foundation.org>
In-Reply-To: <20210907195226.14b1d22a07c085b22968b933@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Yury Norov <yury.norov@gmail.com>
Subject: bitops: move find_bit_*_le functions from le.h to find.h

It's convenient to have all find_bit declarations in one place.

Link: https://lkml.kernel.org/r/20210814211713.180533-3-yury.norov@gmail.com
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

 include/asm-generic/bitops/find.h |  193 ----------------------------
 include/asm-generic/bitops/le.h   |   64 ---------
 2 files changed, 257 deletions(-)

--- a/include/asm-generic/bitops/find.h
+++ /dev/null
@@ -1,193 +0,0 @@
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
-#endif /*_ASM_GENERIC_BITOPS_FIND_H_ */
--- a/include/asm-generic/bitops/le.h~bitops-move-find_bit__le-functions-from-leh-to-findh
+++ a/include/asm-generic/bitops/le.h
@@ -2,83 +2,19 @@
 #ifndef _ASM_GENERIC_BITOPS_LE_H_
 #define _ASM_GENERIC_BITOPS_LE_H_
 
-#include <asm-generic/bitops/find.h>
 #include <asm/types.h>
 #include <asm/byteorder.h>
-#include <linux/swab.h>
 
 #if defined(__LITTLE_ENDIAN)
 
 #define BITOP_LE_SWIZZLE	0
 
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
 #elif defined(__BIG_ENDIAN)
 
 #define BITOP_LE_SWIZZLE	((BITS_PER_LONG-1) & ~0x7)
 
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
 #endif
 
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
 
 static inline int test_bit_le(int nr, const void *addr)
 {
_
