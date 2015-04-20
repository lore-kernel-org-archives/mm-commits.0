From: akpm@linux-foundation.org
Subject: [merged] lib-rename-lib-find_next_bitc-to-lib-find_bitc.patch
 removed from -mm tree
Date: Mon, 20 Apr 2015 12:16:12 -0700
Message-ID: <5535507c.o2KMltiy+O180RWR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39871 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752603AbbDTTJv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Apr 2015 15:09:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yury.norov@gmail.com, chris@chris-wilson.co.uk, davem@davemloft.net, dborkman@redhat.com, hannes@stressinduktion.org, klimov.linux@gmail.com, laijs@cn.fujitsu.com, linux@horizon.com, linux@rasmusvillemoes.dk, msalter@redhat.com, takahiro.akashi@linaro.org, tgraf@suug.ch, valentinrothberg@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib: rename lib/find_next_bit.c to lib/find_bit.c
has been removed from the -mm tree.  Its filename was
     lib-rename-lib-find_next_bitc-to-lib-find_bitc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yury Norov <yury.norov@gmail.com>
Subject: lib: rename lib/find_next_bit.c to lib/find_bit.c

This file contains implementation for all find_*_bit{,_le}
So giving it more generic name looks reasonable.

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

 lib/Makefile        |    2 
 lib/find_bit.c      |  193 ++++++++++++++++++++++++++++++++++++++++++
 lib/find_next_bit.c |  193 ------------------------------------------
 3 files changed, 194 insertions(+), 194 deletions(-)

diff -puN lib/Makefile~lib-rename-lib-find_next_bitc-to-lib-find_bitc lib/Makefile
--- a/lib/Makefile~lib-rename-lib-find_next_bitc-to-lib-find_bitc
+++ a/lib/Makefile
@@ -25,7 +25,7 @@ obj-y	+= lockref.o
 obj-y += bcd.o div64.o sort.o parser.o halfmd4.o debug_locks.o random32.o \
 	 bust_spinlocks.o kasprintf.o bitmap.o scatterlist.o \
 	 gcd.o lcm.o list_sort.o uuid.o flex_array.o iov_iter.o clz_ctz.o \
-	 bsearch.o find_next_bit.o llist.o memweight.o kfifo.o \
+	 bsearch.o find_bit.o llist.o memweight.o kfifo.o \
 	 percpu-refcount.o percpu_ida.o rhashtable.o reciprocal_div.o
 obj-y += string_helpers.o
 obj-$(CONFIG_TEST_STRING_HELPERS) += test-string_helpers.o
diff -puN /dev/null lib/find_bit.c
--- /dev/null
+++ a/lib/find_bit.c
@@ -0,0 +1,193 @@
+/* bit search implementation
+ *
+ * Copyright (C) 2004 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * Copyright (C) 2008 IBM Corporation
+ * 'find_last_bit' is written by Rusty Russell <rusty@rustcorp.com.au>
+ * (Inspired by David Howell's find_next_bit implementation)
+ *
+ * Rewritten by Yury Norov <yury.norov@gmail.com> to decrease
+ * size and improve performance, 2015.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#include <linux/bitops.h>
+#include <linux/bitmap.h>
+#include <linux/export.h>
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
+
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
+
+#ifndef find_next_bit
+/*
+ * Find the next set bit in a memory region.
+ */
+unsigned long find_next_bit(const unsigned long *addr, unsigned long size,
+			    unsigned long offset)
+{
+	return _find_next_bit(addr, size, offset, 0UL);
+}
+EXPORT_SYMBOL(find_next_bit);
+#endif
+
+#ifndef find_next_zero_bit
+unsigned long find_next_zero_bit(const unsigned long *addr, unsigned long size,
+				 unsigned long offset)
+{
+	return _find_next_bit(addr, size, offset, ~0UL);
+}
+EXPORT_SYMBOL(find_next_zero_bit);
+#endif
+
+#ifndef find_first_bit
+/*
+ * Find the first set bit in a memory region.
+ */
+unsigned long find_first_bit(const unsigned long *addr, unsigned long size)
+{
+	unsigned long idx;
+
+	for (idx = 0; idx * BITS_PER_LONG < size; idx++) {
+		if (addr[idx])
+			return min(idx * BITS_PER_LONG + __ffs(addr[idx]), size);
+	}
+
+	return size;
+}
+EXPORT_SYMBOL(find_first_bit);
+#endif
+
+#ifndef find_first_zero_bit
+/*
+ * Find the first cleared bit in a memory region.
+ */
+unsigned long find_first_zero_bit(const unsigned long *addr, unsigned long size)
+{
+	unsigned long idx;
+
+	for (idx = 0; idx * BITS_PER_LONG < size; idx++) {
+		if (addr[idx] != ~0UL)
+			return min(idx * BITS_PER_LONG + ffz(addr[idx]), size);
+	}
+
+	return size;
+}
+EXPORT_SYMBOL(find_first_zero_bit);
+#endif
+
+#ifndef find_last_bit
+unsigned long find_last_bit(const unsigned long *addr, unsigned long size)
+{
+	if (size) {
+		unsigned long val = BITMAP_LAST_WORD_MASK(size);
+		unsigned long idx = (size-1) / BITS_PER_LONG;
+
+		do {
+			val &= addr[idx];
+			if (val)
+				return idx * BITS_PER_LONG + __fls(val);
+
+			val = ~0ul;
+		} while (idx--);
+	}
+	return size;
+}
+EXPORT_SYMBOL(find_last_bit);
+#endif
+
+#ifdef __BIG_ENDIAN
+
+/* include/linux/byteorder does not support "unsigned long" type */
+static inline unsigned long ext2_swab(const unsigned long y)
+{
+#if BITS_PER_LONG == 64
+	return (unsigned long) __swab64((u64) y);
+#elif BITS_PER_LONG == 32
+	return (unsigned long) __swab32((u32) y);
+#else
+#error BITS_PER_LONG not defined
+#endif
+}
+
+#if !defined(find_next_bit_le) || !defined(find_next_zero_bit_le)
+static unsigned long _find_next_bit_le(const unsigned long *addr,
+		unsigned long nbits, unsigned long start, unsigned long invert)
+{
+	unsigned long tmp;
+
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
+
+		tmp = addr[start / BITS_PER_LONG] ^ invert;
+	}
+
+	return min(start + __ffs(ext2_swab(tmp)), nbits);
+}
+#endif
+
+#ifndef find_next_zero_bit_le
+unsigned long find_next_zero_bit_le(const void *addr, unsigned
+		long size, unsigned long offset)
+{
+	return _find_next_bit_le(addr, size, offset, ~0UL);
+}
+EXPORT_SYMBOL(find_next_zero_bit_le);
+#endif
+
+#ifndef find_next_bit_le
+unsigned long find_next_bit_le(const void *addr, unsigned
+		long size, unsigned long offset)
+{
+	return _find_next_bit_le(addr, size, offset, 0UL);
+}
+EXPORT_SYMBOL(find_next_bit_le);
+#endif
+
+#endif /* __BIG_ENDIAN */
diff -puN lib/find_next_bit.c~lib-rename-lib-find_next_bitc-to-lib-find_bitc /dev/null
--- a/lib/find_next_bit.c
+++ /dev/null
@@ -1,193 +0,0 @@
-/* bit search implementation
- *
- * Copyright (C) 2004 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- *
- * Copyright (C) 2008 IBM Corporation
- * 'find_last_bit' is written by Rusty Russell <rusty@rustcorp.com.au>
- * (Inspired by David Howell's find_next_bit implementation)
- *
- * Rewritten by Yury Norov <yury.norov@gmail.com> to decrease
- * size and improve performance, 2015.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version
- * 2 of the License, or (at your option) any later version.
- */
-
-#include <linux/bitops.h>
-#include <linux/bitmap.h>
-#include <linux/export.h>
-#include <linux/kernel.h>
-
-#if !defined(find_next_bit) || !defined(find_next_zero_bit)
-
-/*
- * This is a common helper function for find_next_bit and
- * find_next_zero_bit.  The difference is the "invert" argument, which
- * is XORed with each fetched word before searching it for one bits.
- */
-static unsigned long _find_next_bit(const unsigned long *addr,
-		unsigned long nbits, unsigned long start, unsigned long invert)
-{
-	unsigned long tmp;
-
-	if (!nbits || start >= nbits)
-		return nbits;
-
-	tmp = addr[start / BITS_PER_LONG] ^ invert;
-
-	/* Handle 1st word. */
-	tmp &= BITMAP_FIRST_WORD_MASK(start);
-	start = round_down(start, BITS_PER_LONG);
-
-	while (!tmp) {
-		start += BITS_PER_LONG;
-		if (start >= nbits)
-			return nbits;
-
-		tmp = addr[start / BITS_PER_LONG] ^ invert;
-	}
-
-	return min(start + __ffs(tmp), nbits);
-}
-#endif
-
-#ifndef find_next_bit
-/*
- * Find the next set bit in a memory region.
- */
-unsigned long find_next_bit(const unsigned long *addr, unsigned long size,
-			    unsigned long offset)
-{
-	return _find_next_bit(addr, size, offset, 0UL);
-}
-EXPORT_SYMBOL(find_next_bit);
-#endif
-
-#ifndef find_next_zero_bit
-unsigned long find_next_zero_bit(const unsigned long *addr, unsigned long size,
-				 unsigned long offset)
-{
-	return _find_next_bit(addr, size, offset, ~0UL);
-}
-EXPORT_SYMBOL(find_next_zero_bit);
-#endif
-
-#ifndef find_first_bit
-/*
- * Find the first set bit in a memory region.
- */
-unsigned long find_first_bit(const unsigned long *addr, unsigned long size)
-{
-	unsigned long idx;
-
-	for (idx = 0; idx * BITS_PER_LONG < size; idx++) {
-		if (addr[idx])
-			return min(idx * BITS_PER_LONG + __ffs(addr[idx]), size);
-	}
-
-	return size;
-}
-EXPORT_SYMBOL(find_first_bit);
-#endif
-
-#ifndef find_first_zero_bit
-/*
- * Find the first cleared bit in a memory region.
- */
-unsigned long find_first_zero_bit(const unsigned long *addr, unsigned long size)
-{
-	unsigned long idx;
-
-	for (idx = 0; idx * BITS_PER_LONG < size; idx++) {
-		if (addr[idx] != ~0UL)
-			return min(idx * BITS_PER_LONG + ffz(addr[idx]), size);
-	}
-
-	return size;
-}
-EXPORT_SYMBOL(find_first_zero_bit);
-#endif
-
-#ifndef find_last_bit
-unsigned long find_last_bit(const unsigned long *addr, unsigned long size)
-{
-	if (size) {
-		unsigned long val = BITMAP_LAST_WORD_MASK(size);
-		unsigned long idx = (size-1) / BITS_PER_LONG;
-
-		do {
-			val &= addr[idx];
-			if (val)
-				return idx * BITS_PER_LONG + __fls(val);
-
-			val = ~0ul;
-		} while (idx--);
-	}
-	return size;
-}
-EXPORT_SYMBOL(find_last_bit);
-#endif
-
-#ifdef __BIG_ENDIAN
-
-/* include/linux/byteorder does not support "unsigned long" type */
-static inline unsigned long ext2_swab(const unsigned long y)
-{
-#if BITS_PER_LONG == 64
-	return (unsigned long) __swab64((u64) y);
-#elif BITS_PER_LONG == 32
-	return (unsigned long) __swab32((u32) y);
-#else
-#error BITS_PER_LONG not defined
-#endif
-}
-
-#if !defined(find_next_bit_le) || !defined(find_next_zero_bit_le)
-static unsigned long _find_next_bit_le(const unsigned long *addr,
-		unsigned long nbits, unsigned long start, unsigned long invert)
-{
-	unsigned long tmp;
-
-	if (!nbits || start >= nbits)
-		return nbits;
-
-	tmp = addr[start / BITS_PER_LONG] ^ invert;
-
-	/* Handle 1st word. */
-	tmp &= ext2_swab(BITMAP_FIRST_WORD_MASK(start));
-	start = round_down(start, BITS_PER_LONG);
-
-	while (!tmp) {
-		start += BITS_PER_LONG;
-		if (start >= nbits)
-			return nbits;
-
-		tmp = addr[start / BITS_PER_LONG] ^ invert;
-	}
-
-	return min(start + __ffs(ext2_swab(tmp)), nbits);
-}
-#endif
-
-#ifndef find_next_zero_bit_le
-unsigned long find_next_zero_bit_le(const void *addr, unsigned
-		long size, unsigned long offset)
-{
-	return _find_next_bit_le(addr, size, offset, ~0UL);
-}
-EXPORT_SYMBOL(find_next_zero_bit_le);
-#endif
-
-#ifndef find_next_bit_le
-unsigned long find_next_bit_le(const void *addr, unsigned
-		long size, unsigned long offset)
-{
-	return _find_next_bit_le(addr, size, offset, 0UL);
-}
-EXPORT_SYMBOL(find_next_bit_le);
-#endif
