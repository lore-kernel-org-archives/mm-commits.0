From: akpm@linux-foundation.org
Subject: [merged] radix-tree-test-suite-use-common-find-bit-code.patch
 removed from -mm tree
Date: Thu, 15 Dec 2016 10:48:30 -0800
Message-ID: <5852e57e.3shdIsX2knl9FJ1P%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49190 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932852AbcLOSsb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Dec 2016 13:48:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: willy@linux.intel.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com, mawilcox@microsoft.com, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: radix tree test suite: use common find-bit code
has been removed from the -mm tree.  Its filename was
     radix-tree-test-suite-use-common-find-bit-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Matthew Wilcox <willy@linux.intel.com>
Subject: radix tree test suite: use common find-bit code

Remove the old find_next_bit code in favour of linking in the find_bit
code from tools/lib.

Link: http://lkml.kernel.org/r/1480369871-5271-48-git-send-email-mawilcox@linuxonhyperv.com
Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Tested-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/radix-tree/Makefile                  |    7 +
 tools/testing/radix-tree/find_next_bit.c           |   57 -----------
 tools/testing/radix-tree/linux/bitops.h            |   42 +++++---
 tools/testing/radix-tree/linux/bitops/non-atomic.h |   13 +-
 tools/testing/radix-tree/linux/kernel.h            |   11 ++
 5 files changed, 49 insertions(+), 81 deletions(-)

diff -puN tools/testing/radix-tree/Makefile~radix-tree-test-suite-use-common-find-bit-code tools/testing/radix-tree/Makefile
--- a/tools/testing/radix-tree/Makefile~radix-tree-test-suite-use-common-find-bit-code
+++ a/tools/testing/radix-tree/Makefile
@@ -18,7 +18,12 @@ main:	$(OFILES)
 clean:
 	$(RM) -f $(TARGETS) *.o radix-tree.c
 
-$(OFILES): *.h */*.h ../../../include/linux/radix-tree.h ../../include/linux/*.h
+find_next_bit.o: ../../lib/find_bit.c
+	$(CC) $(CFLAGS) -c -o $@ $<
+
+$(OFILES): *.h */*.h \
+	../../include/linux/*.h \
+	../../../include/linux/radix-tree.h
 
 radix-tree.c: ../../../lib/radix-tree.c
 	sed -e 's/^static //' -e 's/__always_inline //' -e 's/inline //' < $< > $@
diff -puN tools/testing/radix-tree/find_next_bit.c~radix-tree-test-suite-use-common-find-bit-code /dev/null
--- a/tools/testing/radix-tree/find_next_bit.c
+++ /dev/null
@@ -1,57 +0,0 @@
-/* find_next_bit.c: fallback find next bit implementation
- *
- * Copyright (C) 2004 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version
- * 2 of the License, or (at your option) any later version.
- */
-
-#include <linux/types.h>
-#include <linux/bitops.h>
-
-#define BITOP_WORD(nr)		((nr) / BITS_PER_LONG)
-
-/*
- * Find the next set bit in a memory region.
- */
-unsigned long find_next_bit(const unsigned long *addr, unsigned long size,
-			    unsigned long offset)
-{
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
-}
diff -puN tools/testing/radix-tree/linux/bitops.h~radix-tree-test-suite-use-common-find-bit-code tools/testing/radix-tree/linux/bitops.h
--- a/tools/testing/radix-tree/linux/bitops.h~radix-tree-test-suite-use-common-find-bit-code
+++ a/tools/testing/radix-tree/linux/bitops.h
@@ -2,9 +2,14 @@
 #define _ASM_GENERIC_BITOPS_NON_ATOMIC_H_
 
 #include <linux/types.h>
-
-#define BITOP_MASK(nr)		(1UL << ((nr) % BITS_PER_LONG))
-#define BITOP_WORD(nr)		((nr) / BITS_PER_LONG)
+#include <linux/bitops/find.h>
+#include <linux/bitops/hweight.h>
+#include <linux/kernel.h>
+
+#define BIT_MASK(nr)		(1UL << ((nr) % BITS_PER_LONG))
+#define BIT_WORD(nr)		((nr) / BITS_PER_LONG)
+#define BITS_PER_BYTE		8
+#define BITS_TO_LONGS(nr)	DIV_ROUND_UP(nr, BITS_PER_BYTE * sizeof(long))
 
 /**
  * __set_bit - Set a bit in memory
@@ -17,16 +22,16 @@
  */
 static inline void __set_bit(int nr, volatile unsigned long *addr)
 {
-	unsigned long mask = BITOP_MASK(nr);
-	unsigned long *p = ((unsigned long *)addr) + BITOP_WORD(nr);
+	unsigned long mask = BIT_MASK(nr);
+	unsigned long *p = ((unsigned long *)addr) + BIT_WORD(nr);
 
 	*p  |= mask;
 }
 
 static inline void __clear_bit(int nr, volatile unsigned long *addr)
 {
-	unsigned long mask = BITOP_MASK(nr);
-	unsigned long *p = ((unsigned long *)addr) + BITOP_WORD(nr);
+	unsigned long mask = BIT_MASK(nr);
+	unsigned long *p = ((unsigned long *)addr) + BIT_WORD(nr);
 
 	*p &= ~mask;
 }
@@ -42,8 +47,8 @@ static inline void __clear_bit(int nr, v
  */
 static inline void __change_bit(int nr, volatile unsigned long *addr)
 {
-	unsigned long mask = BITOP_MASK(nr);
-	unsigned long *p = ((unsigned long *)addr) + BITOP_WORD(nr);
+	unsigned long mask = BIT_MASK(nr);
+	unsigned long *p = ((unsigned long *)addr) + BIT_WORD(nr);
 
 	*p ^= mask;
 }
@@ -59,8 +64,8 @@ static inline void __change_bit(int nr,
  */
 static inline int __test_and_set_bit(int nr, volatile unsigned long *addr)
 {
-	unsigned long mask = BITOP_MASK(nr);
-	unsigned long *p = ((unsigned long *)addr) + BITOP_WORD(nr);
+	unsigned long mask = BIT_MASK(nr);
+	unsigned long *p = ((unsigned long *)addr) + BIT_WORD(nr);
 	unsigned long old = *p;
 
 	*p = old | mask;
@@ -78,8 +83,8 @@ static inline int __test_and_set_bit(int
  */
 static inline int __test_and_clear_bit(int nr, volatile unsigned long *addr)
 {
-	unsigned long mask = BITOP_MASK(nr);
-	unsigned long *p = ((unsigned long *)addr) + BITOP_WORD(nr);
+	unsigned long mask = BIT_MASK(nr);
+	unsigned long *p = ((unsigned long *)addr) + BIT_WORD(nr);
 	unsigned long old = *p;
 
 	*p = old & ~mask;
@@ -90,8 +95,8 @@ static inline int __test_and_clear_bit(i
 static inline int __test_and_change_bit(int nr,
 					    volatile unsigned long *addr)
 {
-	unsigned long mask = BITOP_MASK(nr);
-	unsigned long *p = ((unsigned long *)addr) + BITOP_WORD(nr);
+	unsigned long mask = BIT_MASK(nr);
+	unsigned long *p = ((unsigned long *)addr) + BIT_WORD(nr);
 	unsigned long old = *p;
 
 	*p = old ^ mask;
@@ -105,7 +110,7 @@ static inline int __test_and_change_bit(
  */
 static inline int test_bit(int nr, const volatile unsigned long *addr)
 {
-	return 1UL & (addr[BITOP_WORD(nr)] >> (nr & (BITS_PER_LONG-1)));
+	return 1UL & (addr[BIT_WORD(nr)] >> (nr & (BITS_PER_LONG-1)));
 }
 
 /**
@@ -147,4 +152,9 @@ unsigned long find_next_bit(const unsign
 			    unsigned long size,
 			    unsigned long offset);
 
+static inline unsigned long hweight_long(unsigned long w)
+{
+	return sizeof(w) == 4 ? hweight32(w) : hweight64(w);
+}
+
 #endif /* _ASM_GENERIC_BITOPS_NON_ATOMIC_H_ */
diff -puN tools/testing/radix-tree/linux/bitops/non-atomic.h~radix-tree-test-suite-use-common-find-bit-code tools/testing/radix-tree/linux/bitops/non-atomic.h
--- a/tools/testing/radix-tree/linux/bitops/non-atomic.h~radix-tree-test-suite-use-common-find-bit-code
+++ a/tools/testing/radix-tree/linux/bitops/non-atomic.h
@@ -3,7 +3,6 @@
 
 #include <asm/types.h>
 
-#define BITOP_MASK(nr)		(1UL << ((nr) % BITS_PER_LONG))
 #define BITOP_WORD(nr)		((nr) / BITS_PER_LONG)
 
 /**
@@ -17,7 +16,7 @@
  */
 static inline void __set_bit(int nr, volatile unsigned long *addr)
 {
-	unsigned long mask = BITOP_MASK(nr);
+	unsigned long mask = BIT_MASK(nr);
 	unsigned long *p = ((unsigned long *)addr) + BITOP_WORD(nr);
 
 	*p  |= mask;
@@ -25,7 +24,7 @@ static inline void __set_bit(int nr, vol
 
 static inline void __clear_bit(int nr, volatile unsigned long *addr)
 {
-	unsigned long mask = BITOP_MASK(nr);
+	unsigned long mask = BIT_MASK(nr);
 	unsigned long *p = ((unsigned long *)addr) + BITOP_WORD(nr);
 
 	*p &= ~mask;
@@ -42,7 +41,7 @@ static inline void __clear_bit(int nr, v
  */
 static inline void __change_bit(int nr, volatile unsigned long *addr)
 {
-	unsigned long mask = BITOP_MASK(nr);
+	unsigned long mask = BIT_MASK(nr);
 	unsigned long *p = ((unsigned long *)addr) + BITOP_WORD(nr);
 
 	*p ^= mask;
@@ -59,7 +58,7 @@ static inline void __change_bit(int nr,
  */
 static inline int __test_and_set_bit(int nr, volatile unsigned long *addr)
 {
-	unsigned long mask = BITOP_MASK(nr);
+	unsigned long mask = BIT_MASK(nr);
 	unsigned long *p = ((unsigned long *)addr) + BITOP_WORD(nr);
 	unsigned long old = *p;
 
@@ -78,7 +77,7 @@ static inline int __test_and_set_bit(int
  */
 static inline int __test_and_clear_bit(int nr, volatile unsigned long *addr)
 {
-	unsigned long mask = BITOP_MASK(nr);
+	unsigned long mask = BIT_MASK(nr);
 	unsigned long *p = ((unsigned long *)addr) + BITOP_WORD(nr);
 	unsigned long old = *p;
 
@@ -90,7 +89,7 @@ static inline int __test_and_clear_bit(i
 static inline int __test_and_change_bit(int nr,
 					    volatile unsigned long *addr)
 {
-	unsigned long mask = BITOP_MASK(nr);
+	unsigned long mask = BIT_MASK(nr);
 	unsigned long *p = ((unsigned long *)addr) + BITOP_WORD(nr);
 	unsigned long old = *p;
 
diff -puN tools/testing/radix-tree/linux/kernel.h~radix-tree-test-suite-use-common-find-bit-code tools/testing/radix-tree/linux/kernel.h
--- a/tools/testing/radix-tree/linux/kernel.h~radix-tree-test-suite-use-common-find-bit-code
+++ a/tools/testing/radix-tree/linux/kernel.h
@@ -47,4 +47,15 @@ static inline int in_interrupt(void)
 {
 	return 0;
 }
+
+/*
+ * This looks more complex than it should be. But we need to
+ * get the type for the ~ right in round_down (it needs to be
+ * as wide as the result!), and we want to evaluate the macro
+ * arguments just once each.
+ */
+#define __round_mask(x, y) ((__typeof__(x))((y)-1))
+#define round_up(x, y) ((((x)-1) | __round_mask(x, y))+1)
+#define round_down(x, y) ((x) & ~__round_mask(x, y))
+
 #endif /* _KERNEL_H */
_

Patches currently in -mm which might be from willy@linux.intel.com are

reimplement-idr-and-ida-using-the-radix-tree.patch

