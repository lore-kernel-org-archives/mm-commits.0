From: akpm@linux-foundation.org
Subject: [merged] lib-find__bit-reimplementation.patch removed from -mm
 tree
Date: Mon, 20 Apr 2015 12:16:06 -0700
Message-ID: <55355076.gBtD3N0Y1kqW7Vlh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39846 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752491AbbDTTJp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Apr 2015 15:09:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yury.norov@gmail.com, chris@chris-wilson.co.uk, davem@davemloft.net, dborkman@redhat.com, hannes@stressinduktion.org, klimov.linux@gmail.com, laijs@cn.fujitsu.com, linux@horizon.com, linux@rasmusvillemoes.dk, msalter@redhat.com, takahiro.akashi@linaro.org, tgraf@suug.ch, valentinrothberg@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib: find_*_bit reimplementation
has been removed from the -mm tree.  Its filename was
     lib-find__bit-reimplementation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yury Norov <yury.norov@gmail.com>
Subject: lib: find_*_bit reimplementation

This patchset does rework to find_bit function family to achieve better
performance, and decrease size of text.  All rework is done in patch 1. 
Patches 2 and 3 are about code moving and renaming.

It was boot-tested on x86_64 and MIPS (big-endian) machines.
Performance tests were ran on userspace with code like this:

	/* addr[] is filled from /dev/urandom */
	start = clock();
	while (ret < nbits)
		ret = find_next_bit(addr, nbits, ret + 1);

	end = clock();
	printf("%ld\t", (unsigned long) end - start);

On Intel(R) Core(TM) i7-3770 CPU @ 3.40GHz measurements are: (for
find_next_bit, nbits is 8M, for find_first_bit - 80K)

	find_next_bit:		find_first_bit:
	new	current		new	current
	26932	43151		14777	14925
	26947	43182		14521	15423
	26507	43824		15053	14705
	27329	43759		14473	14777
	26895	43367		14847	15023
	26990	43693		15103	15163
	26775	43299		15067	15232
	27282	42752		14544	15121
	27504	43088		14644	14858
	26761	43856		14699	15193
	26692	43075		14781	14681
	27137	42969		14451	15061
	...			...

find_next_bit performance gain is 35-40%;
find_first_bit - no measurable difference.

On ARM machine, there is arch-specific implementation for find_bit.

Thanks a lot to George Spelvin and Rasmus Villemoes for hints and
helpful discussions.


This patch (of 3):

New implementations takes less space in source file (see diffstat) and in
object.  For me it's 710 vs 453 bytes of text.  It also shows better
performance.

find_last_bit description fixed due to obvious typo.

[akpm@linux-foundation.org: include linux/bitmap.h, per Rasmus]
Signed-off-by: Yury Norov <yury.norov@gmail.com>
Reviewed-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Reviewed-by: George Spelvin <linux@horizon.com>
Cc: Alexey Klimov <klimov.linux@gmail.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Daniel Borkmann <dborkman@redhat.com>
Cc: Hannes Frederic Sowa <hannes@stressinduktion.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Mark Salter <msalter@redhat.com>
Cc: AKASHI Takahiro <takahiro.akashi@linaro.org>
Cc: Thomas Graf <tgraf@suug.ch>
Cc: Valentin Rothberg <valentinrothberg@gmail.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bitops.h |    4 
 lib/find_last_bit.c    |   38 ++---
 lib/find_next_bit.c    |  267 ++++++++++-----------------------------
 3 files changed, 92 insertions(+), 217 deletions(-)

diff -puN include/linux/bitops.h~lib-find__bit-reimplementation include/linux/bitops.h
--- a/include/linux/bitops.h~lib-find__bit-reimplementation
+++ a/include/linux/bitops.h
@@ -218,9 +218,9 @@ static inline unsigned long __ffs64(u64
 /**
  * find_last_bit - find the last set bit in a memory region
  * @addr: The address to start the search at
- * @size: The maximum size to search
+ * @size: The number of bits to search
  *
- * Returns the bit number of the first set bit, or size.
+ * Returns the bit number of the last set bit, or size.
  */
 extern unsigned long find_last_bit(const unsigned long *addr,
 				   unsigned long size);
diff -puN lib/find_last_bit.c~lib-find__bit-reimplementation lib/find_last_bit.c
--- a/lib/find_last_bit.c~lib-find__bit-reimplementation
+++ a/lib/find_last_bit.c
@@ -4,6 +4,9 @@
  * Written by Rusty Russell <rusty@rustcorp.com.au>
  * (Inspired by David Howell's find_next_bit implementation)
  *
+ * Rewritten by Yury Norov <yury.norov@gmail.com> to decrease
+ * size and improve performance, 2015.
+ *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
  * as published by the Free Software Foundation; either version
@@ -11,37 +14,26 @@
  */
 
 #include <linux/bitops.h>
+#include <linux/bitmap.h>
 #include <linux/export.h>
-#include <asm/types.h>
-#include <asm/byteorder.h>
+#include <linux/kernel.h>
 
 #ifndef find_last_bit
 
 unsigned long find_last_bit(const unsigned long *addr, unsigned long size)
 {
-	unsigned long words;
-	unsigned long tmp;
-
-	/* Start at final word. */
-	words = size / BITS_PER_LONG;
+	if (size) {
+		unsigned long val = BITMAP_LAST_WORD_MASK(size);
+		unsigned long idx = (size-1) / BITS_PER_LONG;
+
+		do {
+			val &= addr[idx];
+			if (val)
+				return idx * BITS_PER_LONG + __fls(val);
 
-	/* Partial final word? */
-	if (size & (BITS_PER_LONG-1)) {
-		tmp = (addr[words] & (~0UL >> (BITS_PER_LONG
-					 - (size & (BITS_PER_LONG-1)))));
-		if (tmp)
-			goto found;
+			val = ~0ul;
+		} while (idx--);
 	}
-
-	while (words) {
-		tmp = addr[--words];
-		if (tmp) {
-found:
-			return words * BITS_PER_LONG + __fls(tmp);
-		}
-	}
-
-	/* Not found */
 	return size;
 }
 EXPORT_SYMBOL(find_last_bit);
diff -puN lib/find_next_bit.c~lib-find__bit-reimplementation lib/find_next_bit.c
--- a/lib/find_next_bit.c~lib-find__bit-reimplementation
+++ a/lib/find_next_bit.c
@@ -3,6 +3,9 @@
  * Copyright (C) 2004 Red Hat, Inc. All Rights Reserved.
  * Written by David Howells (dhowells@redhat.com)
  *
+ * Rewritten by Yury Norov <yury.norov@gmail.com> to decrease
+ * size and improve performance, 2015.
+ *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
  * as published by the Free Software Foundation; either version
@@ -11,10 +14,40 @@
 
 #include <linux/bitops.h>
 #include <linux/export.h>
-#include <asm/types.h>
-#include <asm/byteorder.h>
+#include <linux/kernel.h>
+
+#if !defined(find_next_bit) || !defined(find_next_zero_bit)
+
+/*
+ * This is a common helper function for find_next_bit and
+ * find_next_zero_bit.  The difference is the "invert" argument, which
+ * is XORed with each fetched word before searching it for one bits.
+ */
+static unsigned long _find_next_bit(const unsigned long *addr,
+		unsigned long nbits, unsigned long start, unsigned long invert)
+{
+	unsigned long tmp;
 
-#define BITOP_WORD(nr)		((nr) / BITS_PER_LONG)
+	if (!nbits || start >= nbits)
+		return nbits;
+
+	tmp = addr[start / BITS_PER_LONG] ^ invert;
+
+	/* Handle 1st word. */
+	tmp &= BITMAP_FIRST_WORD_MASK(start);
+	start = round_down(start, BITS_PER_LONG);
+
+	while (!tmp) {
+		start += BITS_PER_LONG;
+		if (start >= nbits)
+			return nbits;
+
+		tmp = addr[start / BITS_PER_LONG] ^ invert;
+	}
+
+	return min(start + __ffs(tmp), nbits);
+}
+#endif
 
 #ifndef find_next_bit
 /*
@@ -23,86 +56,16 @@
 unsigned long find_next_bit(const unsigned long *addr, unsigned long size,
 			    unsigned long offset)
 {
-	const unsigned long *p = addr + BITOP_WORD(offset);
-	unsigned long result = offset & ~(BITS_PER_LONG-1);
-	unsigned long tmp;
-
-	if (offset >= size)
-		return size;
-	size -= result;
-	offset %= BITS_PER_LONG;
-	if (offset) {
-		tmp = *(p++);
-		tmp &= (~0UL << offset);
-		if (size < BITS_PER_LONG)
-			goto found_first;
-		if (tmp)
-			goto found_middle;
-		size -= BITS_PER_LONG;
-		result += BITS_PER_LONG;
-	}
-	while (size & ~(BITS_PER_LONG-1)) {
-		if ((tmp = *(p++)))
-			goto found_middle;
-		result += BITS_PER_LONG;
-		size -= BITS_PER_LONG;
-	}
-	if (!size)
-		return result;
-	tmp = *p;
-
-found_first:
-	tmp &= (~0UL >> (BITS_PER_LONG - size));
-	if (tmp == 0UL)		/* Are any bits set? */
-		return result + size;	/* Nope. */
-found_middle:
-	return result + __ffs(tmp);
+	return _find_next_bit(addr, size, offset, 0UL);
 }
 EXPORT_SYMBOL(find_next_bit);
 #endif
 
 #ifndef find_next_zero_bit
-/*
- * This implementation of find_{first,next}_zero_bit was stolen from
- * Linus' asm-alpha/bitops.h.
- */
 unsigned long find_next_zero_bit(const unsigned long *addr, unsigned long size,
 				 unsigned long offset)
 {
-	const unsigned long *p = addr + BITOP_WORD(offset);
-	unsigned long result = offset & ~(BITS_PER_LONG-1);
-	unsigned long tmp;
-
-	if (offset >= size)
-		return size;
-	size -= result;
-	offset %= BITS_PER_LONG;
-	if (offset) {
-		tmp = *(p++);
-		tmp |= ~0UL >> (BITS_PER_LONG - offset);
-		if (size < BITS_PER_LONG)
-			goto found_first;
-		if (~tmp)
-			goto found_middle;
-		size -= BITS_PER_LONG;
-		result += BITS_PER_LONG;
-	}
-	while (size & ~(BITS_PER_LONG-1)) {
-		if (~(tmp = *(p++)))
-			goto found_middle;
-		result += BITS_PER_LONG;
-		size -= BITS_PER_LONG;
-	}
-	if (!size)
-		return result;
-	tmp = *p;
-
-found_first:
-	tmp |= ~0UL << size;
-	if (tmp == ~0UL)	/* Are any bits zero? */
-		return result + size;	/* Nope. */
-found_middle:
-	return result + ffz(tmp);
+	return _find_next_bit(addr, size, offset, ~0UL);
 }
 EXPORT_SYMBOL(find_next_zero_bit);
 #endif
@@ -113,24 +76,14 @@ EXPORT_SYMBOL(find_next_zero_bit);
  */
 unsigned long find_first_bit(const unsigned long *addr, unsigned long size)
 {
-	const unsigned long *p = addr;
-	unsigned long result = 0;
-	unsigned long tmp;
+	unsigned long idx;
 
-	while (size & ~(BITS_PER_LONG-1)) {
-		if ((tmp = *(p++)))
-			goto found;
-		result += BITS_PER_LONG;
-		size -= BITS_PER_LONG;
+	for (idx = 0; idx * BITS_PER_LONG < size; idx++) {
+		if (addr[idx])
+			return min(idx * BITS_PER_LONG + __ffs(addr[idx]), size);
 	}
-	if (!size)
-		return result;
 
-	tmp = (*p) & (~0UL >> (BITS_PER_LONG - size));
-	if (tmp == 0UL)		/* Are any bits set? */
-		return result + size;	/* Nope. */
-found:
-	return result + __ffs(tmp);
+	return size;
 }
 EXPORT_SYMBOL(find_first_bit);
 #endif
@@ -141,24 +94,14 @@ EXPORT_SYMBOL(find_first_bit);
  */
 unsigned long find_first_zero_bit(const unsigned long *addr, unsigned long size)
 {
-	const unsigned long *p = addr;
-	unsigned long result = 0;
-	unsigned long tmp;
+	unsigned long idx;
 
-	while (size & ~(BITS_PER_LONG-1)) {
-		if (~(tmp = *(p++)))
-			goto found;
-		result += BITS_PER_LONG;
-		size -= BITS_PER_LONG;
+	for (idx = 0; idx * BITS_PER_LONG < size; idx++) {
+		if (addr[idx] != ~0UL)
+			return min(idx * BITS_PER_LONG + ffz(addr[idx]), size);
 	}
-	if (!size)
-		return result;
 
-	tmp = (*p) | (~0UL << size);
-	if (tmp == ~0UL)	/* Are any bits zero? */
-		return result + size;	/* Nope. */
-found:
-	return result + ffz(tmp);
+	return size;
 }
 EXPORT_SYMBOL(find_first_zero_bit);
 #endif
@@ -166,18 +109,6 @@ EXPORT_SYMBOL(find_first_zero_bit);
 #ifdef __BIG_ENDIAN
 
 /* include/linux/byteorder does not support "unsigned long" type */
-static inline unsigned long ext2_swabp(const unsigned long * x)
-{
-#if BITS_PER_LONG == 64
-	return (unsigned long) __swab64p((u64 *) x);
-#elif BITS_PER_LONG == 32
-	return (unsigned long) __swab32p((u32 *) x);
-#else
-#error BITS_PER_LONG not defined
-#endif
-}
-
-/* include/linux/byteorder doesn't support "unsigned long" type */
 static inline unsigned long ext2_swab(const unsigned long y)
 {
 #if BITS_PER_LONG == 64
@@ -189,48 +120,38 @@ static inline unsigned long ext2_swab(co
 #endif
 }
 
-#ifndef find_next_zero_bit_le
-unsigned long find_next_zero_bit_le(const void *addr, unsigned
-		long size, unsigned long offset)
+#if !defined(find_next_bit_le) || !defined(find_next_zero_bit_le)
+static unsigned long _find_next_bit_le(const unsigned long *addr,
+		unsigned long nbits, unsigned long start, unsigned long invert)
 {
-	const unsigned long *p = addr;
-	unsigned long result = offset & ~(BITS_PER_LONG - 1);
 	unsigned long tmp;
 
-	if (offset >= size)
-		return size;
-	p += BITOP_WORD(offset);
-	size -= result;
-	offset &= (BITS_PER_LONG - 1UL);
-	if (offset) {
-		tmp = ext2_swabp(p++);
-		tmp |= (~0UL >> (BITS_PER_LONG - offset));
-		if (size < BITS_PER_LONG)
-			goto found_first;
-		if (~tmp)
-			goto found_middle;
-		size -= BITS_PER_LONG;
-		result += BITS_PER_LONG;
-	}
+	if (!nbits || start >= nbits)
+		return nbits;
+
+	tmp = addr[start / BITS_PER_LONG] ^ invert;
+
+	/* Handle 1st word. */
+	tmp &= ext2_swab(BITMAP_FIRST_WORD_MASK(start));
+	start = round_down(start, BITS_PER_LONG);
+
+	while (!tmp) {
+		start += BITS_PER_LONG;
+		if (start >= nbits)
+			return nbits;
 
-	while (size & ~(BITS_PER_LONG - 1)) {
-		if (~(tmp = *(p++)))
-			goto found_middle_swap;
-		result += BITS_PER_LONG;
-		size -= BITS_PER_LONG;
+		tmp = addr[start / BITS_PER_LONG] ^ invert;
 	}
-	if (!size)
-		return result;
-	tmp = ext2_swabp(p);
-found_first:
-	tmp |= ~0UL << size;
-	if (tmp == ~0UL)	/* Are any bits zero? */
-		return result + size; /* Nope. Skip ffz */
-found_middle:
-	return result + ffz(tmp);
 
-found_middle_swap:
-	return result + ffz(ext2_swab(tmp));
+	return min(start + __ffs(ext2_swab(tmp)), nbits);
+}
+#endif
+
+#ifndef find_next_zero_bit_le
+unsigned long find_next_zero_bit_le(const void *addr, unsigned
+		long size, unsigned long offset)
+{
+	return _find_next_bit_le(addr, size, offset, ~0UL);
 }
 EXPORT_SYMBOL(find_next_zero_bit_le);
 #endif
@@ -239,45 +160,7 @@ EXPORT_SYMBOL(find_next_zero_bit_le);
 unsigned long find_next_bit_le(const void *addr, unsigned
 		long size, unsigned long offset)
 {
-	const unsigned long *p = addr;
-	unsigned long result = offset & ~(BITS_PER_LONG - 1);
-	unsigned long tmp;
-
-	if (offset >= size)
-		return size;
-	p += BITOP_WORD(offset);
-	size -= result;
-	offset &= (BITS_PER_LONG - 1UL);
-	if (offset) {
-		tmp = ext2_swabp(p++);
-		tmp &= (~0UL << offset);
-		if (size < BITS_PER_LONG)
-			goto found_first;
-		if (tmp)
-			goto found_middle;
-		size -= BITS_PER_LONG;
-		result += BITS_PER_LONG;
-	}
-
-	while (size & ~(BITS_PER_LONG - 1)) {
-		tmp = *(p++);
-		if (tmp)
-			goto found_middle_swap;
-		result += BITS_PER_LONG;
-		size -= BITS_PER_LONG;
-	}
-	if (!size)
-		return result;
-	tmp = ext2_swabp(p);
-found_first:
-	tmp &= (~0UL >> (BITS_PER_LONG - size));
-	if (tmp == 0UL)		/* Are any bits set? */
-		return result + size; /* Nope. */
-found_middle:
-	return result + __ffs(tmp);
