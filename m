From: akpm@linux-foundation.org
Subject: [merged] lib-optimize-cpumask_next_and.patch removed from
 -mm tree
Date: Wed, 07 Feb 2018 11:57:17 -0800
Message-ID: <20180207195717.E3cl8mg3O%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59564 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754349AbeBGT5S (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 7 Feb 2018 14:57:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, courbet@google.com, geert@linux-m68k.org, linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org, ynorov@caviumnetworks.com


The patch titled
     Subject: lib: optimize cpumask_next_and()
has been removed from the -mm tree.  Its filename was
     lib-optimize-cpumask_next_and.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Clement Courbet <courbet@google.com>
Subject: lib: optimize cpumask_next_and()

We've measured that we spend ~0.6% of sys cpu time in cpumask_next_and(). 
It's essentially a joined iteration in search for a non-zero bit, which is
currently implemented as a lookup join (find a nonzero bit on the lhs,
lookup the rhs to see if it's set there).

Implement a direct join (find a nonzero bit on the incrementally built
join).  Also add generic bitmap benchmarks in the new `test_find_bit`
module for new function (see `find_next_and_bit` in [2] and [3] below).

For cpumask_next_and, direct benchmarking shows that it's 1.17x to 14x
faster with a geometric mean of 2.1 on 32 CPUs [1].  No impact on memory
usage.  Note that on Arm, the new pure-C implementation still outperforms
the old one that uses a mix of C and asm (`find_next_bit`) [3].

[1] Approximate benchmark code:

```
  unsigned long src1p[nr_cpumask_longs] = {pattern1};
  unsigned long src2p[nr_cpumask_longs] = {pattern2};
  for (/*a bunch of repetitions*/) {
    for (int n = -1; n <= nr_cpu_ids; ++n) {
      asm volatile("" : "+rm"(src1p)); // prevent any optimization
      asm volatile("" : "+rm"(src2p));
      unsigned long result = cpumask_next_and(n, src1p, src2p);
      asm volatile("" : "+rm"(result));
    }
  }
```

Results:
pattern1    pattern2     time_before/time_after
0x0000ffff  0x0000ffff   1.65
0x0000ffff  0x00005555   2.24
0x0000ffff  0x00001111   2.94
0x0000ffff  0x00000000   14.0
0x00005555  0x0000ffff   1.67
0x00005555  0x00005555   1.71
0x00005555  0x00001111   1.90
0x00005555  0x00000000   6.58
0x00001111  0x0000ffff   1.46
0x00001111  0x00005555   1.49
0x00001111  0x00001111   1.45
0x00001111  0x00000000   3.10
0x00000000  0x0000ffff   1.18
0x00000000  0x00005555   1.18
0x00000000  0x00001111   1.17
0x00000000  0x00000000   1.25
-----------------------------
               geo.mean  2.06

[2] test_find_next_bit, X86 (skylake)

 [ 3913.477422] Start testing find_bit() with random-filled bitmap
 [ 3913.477847] find_next_bit: 160868 cycles, 16484 iterations
 [ 3913.477933] find_next_zero_bit: 169542 cycles, 16285 iterations
 [ 3913.478036] find_last_bit: 201638 cycles, 16483 iterations
 [ 3913.480214] find_first_bit: 4353244 cycles, 16484 iterations
 [ 3913.480216] Start testing find_next_and_bit() with random-filled
 bitmap
 [ 3913.481074] find_next_and_bit: 89604 cycles, 8216 iterations
 [ 3913.481075] Start testing find_bit() with sparse bitmap
 [ 3913.481078] find_next_bit: 2536 cycles, 66 iterations
 [ 3913.481252] find_next_zero_bit: 344404 cycles, 32703 iterations
 [ 3913.481255] find_last_bit: 2006 cycles, 66 iterations
 [ 3913.481265] find_first_bit: 17488 cycles, 66 iterations
 [ 3913.481266] Start testing find_next_and_bit() with sparse bitmap
 [ 3913.481272] find_next_and_bit: 764 cycles, 1 iterations

[3] test_find_next_bit, arm (v7 odroid XU3).

[  267.206928] Start testing find_bit() with random-filled bitmap
[  267.214752] find_next_bit: 4474 cycles, 16419 iterations
[  267.221850] find_next_zero_bit: 5976 cycles, 16350 iterations
[  267.229294] find_last_bit: 4209 cycles, 16419 iterations
[  267.279131] find_first_bit: 1032991 cycles, 16420 iterations
[  267.286265] Start testing find_next_and_bit() with random-filled
bitmap
[  267.302386] find_next_and_bit: 2290 cycles, 8140 iterations
[  267.309422] Start testing find_bit() with sparse bitmap
[  267.316054] find_next_bit: 191 cycles, 66 iterations
[  267.322726] find_next_zero_bit: 8758 cycles, 32703 iterations
[  267.329803] find_last_bit: 84 cycles, 66 iterations
[  267.336169] find_first_bit: 4118 cycles, 66 iterations
[  267.342627] Start testing find_next_and_bit() with sparse bitmap
[  267.356919] find_next_and_bit: 91 cycles, 1 iterations

[courbet@google.com: v6]
  Link: http://lkml.kernel.org/r/20171129095715.23430-1-courbet@google.com
[geert@linux-m68k.org: m68k/bitops: always include <asm-generic/bitops/find.h>]
  Link: http://lkml.kernel.org/r/1512556816-28627-1-git-send-email-geert@linux-m68k.org
Link: http://lkml.kernel.org/r/20171128131334.23491-1-courbet@google.com
Signed-off-by: Clement Courbet <courbet@google.com>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Yury Norov <ynorov@caviumnetworks.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/include/asm/bitops.h           |    1 
 arch/m68k/include/asm/bitops.h          |    3 -
 arch/unicore32/include/asm/bitops.h     |    2 
 include/asm-generic/bitops/find.h       |   20 +++++++
 include/linux/bitmap.h                  |    6 +-
 lib/cpumask.c                           |    9 +--
 lib/find_bit.c                          |   59 ++++++++++++++++------
 lib/find_bit_benchmark.c                |   25 ++++++++-
 tools/include/asm-generic/bitops/find.h |   16 +++++
 tools/lib/find_bit.c                    |   40 +++++++++++---
 10 files changed, 148 insertions(+), 33 deletions(-)

diff -puN arch/arm/include/asm/bitops.h~lib-optimize-cpumask_next_and arch/arm/include/asm/bitops.h
--- a/arch/arm/include/asm/bitops.h~lib-optimize-cpumask_next_and
+++ a/arch/arm/include/asm/bitops.h
@@ -338,6 +338,7 @@ static inline int find_next_bit_le(const
 
 #endif
 
+#include <asm-generic/bitops/find.h>
 #include <asm-generic/bitops/le.h>
 
 /*
diff -puN arch/m68k/include/asm/bitops.h~lib-optimize-cpumask_next_and arch/m68k/include/asm/bitops.h
--- a/arch/m68k/include/asm/bitops.h~lib-optimize-cpumask_next_and
+++ a/arch/m68k/include/asm/bitops.h
@@ -311,7 +311,6 @@ static inline int bfchg_mem_test_and_cha
  *	functions.
  */
 #if defined(CONFIG_CPU_HAS_NO_BITFIELDS)
-#include <asm-generic/bitops/find.h>
 #include <asm-generic/bitops/ffz.h>
 #else
 
@@ -441,6 +440,8 @@ static inline unsigned long ffz(unsigned
 
 #endif
 
+#include <asm-generic/bitops/find.h>
+
 #ifdef __KERNEL__
 
 #if defined(CONFIG_CPU_HAS_NO_BITFIELDS)
diff -puN arch/unicore32/include/asm/bitops.h~lib-optimize-cpumask_next_and arch/unicore32/include/asm/bitops.h
--- a/arch/unicore32/include/asm/bitops.h~lib-optimize-cpumask_next_and
+++ a/arch/unicore32/include/asm/bitops.h
@@ -44,4 +44,6 @@ static inline int fls(int x)
 #define find_first_bit		find_first_bit
 #define find_first_zero_bit	find_first_zero_bit
 
+#include <asm-generic/bitops/find.h>
+
 #endif /* __UNICORE_BITOPS_H__ */
diff -puN include/asm-generic/bitops/find.h~lib-optimize-cpumask_next_and include/asm-generic/bitops/find.h
--- a/include/asm-generic/bitops/find.h~lib-optimize-cpumask_next_and
+++ a/include/asm-generic/bitops/find.h
@@ -16,6 +16,22 @@ extern unsigned long find_next_bit(const
 		size, unsigned long offset);
 #endif
 
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
+extern unsigned long find_next_and_bit(const unsigned long *addr1,
+		const unsigned long *addr2, unsigned long size,
+		unsigned long offset);
+#endif
+
 #ifndef find_next_zero_bit
 /**
  * find_next_zero_bit - find the next cleared bit in a memory region
@@ -55,8 +71,12 @@ extern unsigned long find_first_zero_bit
 					 unsigned long size);
 #else /* CONFIG_GENERIC_FIND_FIRST_BIT */
 
+#ifndef find_first_bit
 #define find_first_bit(addr, size) find_next_bit((addr), (size), 0)
+#endif
+#ifndef find_first_zero_bit
 #define find_first_zero_bit(addr, size) find_next_zero_bit((addr), (size), 0)
+#endif
 
 #endif /* CONFIG_GENERIC_FIND_FIRST_BIT */
 
diff -puN include/linux/bitmap.h~lib-optimize-cpumask_next_and include/linux/bitmap.h
--- a/include/linux/bitmap.h~lib-optimize-cpumask_next_and
+++ a/include/linux/bitmap.h
@@ -88,8 +88,12 @@
  *  test_and_change_bit(bit, addr)      Change bit and return old value
  *  find_first_zero_bit(addr, nbits)    Position first zero bit in *addr
  *  find_first_bit(addr, nbits)         Position first set bit in *addr
- *  find_next_zero_bit(addr, nbits, bit)  Position next zero bit in *addr >= bit
+ *  find_next_zero_bit(addr, nbits, bit)
+ *                                      Position next zero bit in *addr >= bit
  *  find_next_bit(addr, nbits, bit)     Position next set bit in *addr >= bit
+ *  find_next_and_bit(addr1, addr2, nbits, bit)
+ *                                      Same as find_next_bit, but in
+ *                                      (*addr1 & *addr2)
  *
  */
 
diff -puN lib/cpumask.c~lib-optimize-cpumask_next_and lib/cpumask.c
--- a/lib/cpumask.c~lib-optimize-cpumask_next_and
+++ a/lib/cpumask.c
@@ -33,10 +33,11 @@ EXPORT_SYMBOL(cpumask_next);
 int cpumask_next_and(int n, const struct cpumask *src1p,
 		     const struct cpumask *src2p)
 {
-	while ((n = cpumask_next(n, src1p)) < nr_cpu_ids)
-		if (cpumask_test_cpu(n, src2p))
-			break;
-	return n;
+	/* -1 is a legal arg here. */
+	if (n != -1)
+		cpumask_check(n);
+	return find_next_and_bit(cpumask_bits(src1p), cpumask_bits(src2p),
+		nr_cpumask_bits, n + 1);
 }
 EXPORT_SYMBOL(cpumask_next_and);
 
diff -puN lib/find_bit_benchmark.c~lib-optimize-cpumask_next_and lib/find_bit_benchmark.c
--- a/lib/find_bit_benchmark.c~lib-optimize-cpumask_next_and
+++ a/lib/find_bit_benchmark.c
@@ -35,6 +35,7 @@
 #define SPARSE		500
 
 static DECLARE_BITMAP(bitmap, BITMAP_LEN) __initdata;
+static DECLARE_BITMAP(bitmap2, BITMAP_LEN) __initdata;
 
 /*
  * This is Schlemiel the Painter's algorithm. It should be called after
@@ -103,6 +104,22 @@ static int __init test_find_last_bit(con
 	return 0;
 }
 
+static int __init test_find_next_and_bit(const void *bitmap,
+		const void *bitmap2, unsigned long len)
+{
+	unsigned long i, cnt;
+	cycles_t cycles;
+
+	cycles = get_cycles();
+	for (cnt = i = 0; i < BITMAP_LEN; cnt++)
+		i = find_next_and_bit(bitmap, bitmap2, BITMAP_LEN, i+1);
+	cycles = get_cycles() - cycles;
+	pr_err("find_next_and_bit:\t\t%llu cycles, %ld iterations\n",
+		(u64)cycles, cnt);
+
+	return 0;
+}
+
 static int __init find_bit_test(void)
 {
 	unsigned long nbits = BITMAP_LEN / SPARSE;
@@ -110,23 +127,29 @@ static int __init find_bit_test(void)
 	pr_err("\nStart testing find_bit() with random-filled bitmap\n");
 
 	get_random_bytes(bitmap, sizeof(bitmap));
+	get_random_bytes(bitmap2, sizeof(bitmap2));
 
 	test_find_next_bit(bitmap, BITMAP_LEN);
 	test_find_next_zero_bit(bitmap, BITMAP_LEN);
 	test_find_last_bit(bitmap, BITMAP_LEN);
 	test_find_first_bit(bitmap, BITMAP_LEN);
+	test_find_next_and_bit(bitmap, bitmap2, BITMAP_LEN);
 
 	pr_err("\nStart testing find_bit() with sparse bitmap\n");
 
 	bitmap_zero(bitmap, BITMAP_LEN);
+	bitmap_zero(bitmap2, BITMAP_LEN);
 
-	while (nbits--)
+	while (nbits--) {
 		__set_bit(prandom_u32() % BITMAP_LEN, bitmap);
+		__set_bit(prandom_u32() % BITMAP_LEN, bitmap2);
+	}
 
 	test_find_next_bit(bitmap, BITMAP_LEN);
 	test_find_next_zero_bit(bitmap, BITMAP_LEN);
 	test_find_last_bit(bitmap, BITMAP_LEN);
 	test_find_first_bit(bitmap, BITMAP_LEN);
+	test_find_next_and_bit(bitmap, bitmap2, BITMAP_LEN);
 
 	/*
 	 * Everything is OK. Return error just to let user run benchmark
diff -puN lib/find_bit.c~lib-optimize-cpumask_next_and lib/find_bit.c
--- a/lib/find_bit.c~lib-optimize-cpumask_next_and
+++ a/lib/find_bit.c
@@ -21,22 +21,29 @@
 #include <linux/export.h>
 #include <linux/kernel.h>
 
-#if !defined(find_next_bit) || !defined(find_next_zero_bit)
+#if !defined(find_next_bit) || !defined(find_next_zero_bit) || \
+		!defined(find_next_and_bit)
 
 /*
- * This is a common helper function for find_next_bit and
- * find_next_zero_bit.  The difference is the "invert" argument, which
- * is XORed with each fetched word before searching it for one bits.
+ * This is a common helper function for find_next_bit, find_next_zero_bit, and
+ * find_next_and_bit. The differences are:
+ *  - The "invert" argument, which is XORed with each fetched word before
+ *    searching it for one bits.
+ *  - The optional "addr2", which is anded with "addr1" if present.
  */
-static unsigned long _find_next_bit(const unsigned long *addr,
-		unsigned long nbits, unsigned long start, unsigned long invert)
+static inline unsigned long _find_next_bit(const unsigned long *addr1,
+		const unsigned long *addr2, unsigned long nbits,
+		unsigned long start, unsigned long invert)
 {
 	unsigned long tmp;
 
 	if (unlikely(start >= nbits))
 		return nbits;
 
-	tmp = addr[start / BITS_PER_LONG] ^ invert;
+	tmp = addr1[start / BITS_PER_LONG];
+	if (addr2)
+		tmp &= addr2[start / BITS_PER_LONG];
+	tmp ^= invert;
 
 	/* Handle 1st word. */
 	tmp &= BITMAP_FIRST_WORD_MASK(start);
@@ -47,7 +54,10 @@ static unsigned long _find_next_bit(cons
 		if (start >= nbits)
 			return nbits;
 
-		tmp = addr[start / BITS_PER_LONG] ^ invert;
+		tmp = addr1[start / BITS_PER_LONG];
+		if (addr2)
+			tmp &= addr2[start / BITS_PER_LONG];
+		tmp ^= invert;
 	}
 
 	return min(start + __ffs(tmp), nbits);
@@ -61,7 +71,7 @@ static unsigned long _find_next_bit(cons
 unsigned long find_next_bit(const unsigned long *addr, unsigned long size,
 			    unsigned long offset)
 {
-	return _find_next_bit(addr, size, offset, 0UL);
+	return _find_next_bit(addr, NULL, size, offset, 0UL);
 }
 EXPORT_SYMBOL(find_next_bit);
 #endif
@@ -70,11 +80,21 @@ EXPORT_SYMBOL(find_next_bit);
 unsigned long find_next_zero_bit(const unsigned long *addr, unsigned long size,
 				 unsigned long offset)
 {
-	return _find_next_bit(addr, size, offset, ~0UL);
+	return _find_next_bit(addr, NULL, size, offset, ~0UL);
 }
 EXPORT_SYMBOL(find_next_zero_bit);
 #endif
 
+#if !defined(find_next_and_bit)
+unsigned long find_next_and_bit(const unsigned long *addr1,
+		const unsigned long *addr2, unsigned long size,
+		unsigned long offset)
+{
+	return _find_next_bit(addr1, addr2, size, offset, 0UL);
+}
+EXPORT_SYMBOL(find_next_and_bit);
+#endif
+
 #ifndef find_first_bit
 /*
  * Find the first set bit in a memory region.
@@ -146,15 +166,19 @@ static inline unsigned long ext2_swab(co
 }
 
 #if !defined(find_next_bit_le) || !defined(find_next_zero_bit_le)
-static unsigned long _find_next_bit_le(const unsigned long *addr,
-		unsigned long nbits, unsigned long start, unsigned long invert)
+static inline unsigned long _find_next_bit_le(const unsigned long *addr1,
+		const unsigned long *addr2, unsigned long nbits,
+		unsigned long start, unsigned long invert)
 {
 	unsigned long tmp;
 
 	if (unlikely(start >= nbits))
 		return nbits;
 
-	tmp = addr[start / BITS_PER_LONG] ^ invert;
+	tmp = addr1[start / BITS_PER_LONG];
+	if (addr2)
+		tmp &= addr2[start / BITS_PER_LONG];
+	tmp ^= invert;
 
 	/* Handle 1st word. */
 	tmp &= ext2_swab(BITMAP_FIRST_WORD_MASK(start));
@@ -165,7 +189,10 @@ static unsigned long _find_next_bit_le(c
 		if (start >= nbits)
 			return nbits;
 
-		tmp = addr[start / BITS_PER_LONG] ^ invert;
+		tmp = addr1[start / BITS_PER_LONG];
+		if (addr2)
+			tmp &= addr2[start / BITS_PER_LONG];
+		tmp ^= invert;
 	}
 
 	return min(start + __ffs(ext2_swab(tmp)), nbits);
@@ -176,7 +203,7 @@ static unsigned long _find_next_bit_le(c
 unsigned long find_next_zero_bit_le(const void *addr, unsigned
 		long size, unsigned long offset)
 {
-	return _find_next_bit_le(addr, size, offset, ~0UL);
+	return _find_next_bit_le(addr, NULL, size, offset, ~0UL);
 }
 EXPORT_SYMBOL(find_next_zero_bit_le);
 #endif
@@ -185,7 +212,7 @@ EXPORT_SYMBOL(find_next_zero_bit_le);
 unsigned long find_next_bit_le(const void *addr, unsigned
 		long size, unsigned long offset)
 {
-	return _find_next_bit_le(addr, size, offset, 0UL);
+	return _find_next_bit_le(addr, NULL, size, offset, 0UL);
 }
 EXPORT_SYMBOL(find_next_bit_le);
 #endif
diff -puN tools/include/asm-generic/bitops/find.h~lib-optimize-cpumask_next_and tools/include/asm-generic/bitops/find.h
--- a/tools/include/asm-generic/bitops/find.h~lib-optimize-cpumask_next_and
+++ a/tools/include/asm-generic/bitops/find.h
@@ -16,6 +16,22 @@ extern unsigned long find_next_bit(const
 		size, unsigned long offset);
 #endif
 
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
+extern unsigned long find_next_and_bit(const unsigned long *addr1,
+		const unsigned long *addr2, unsigned long size,
+		unsigned long offset);
+#endif
+
 #ifndef find_next_zero_bit
 
 /**
diff -puN tools/lib/find_bit.c~lib-optimize-cpumask_next_and tools/lib/find_bit.c
--- a/tools/lib/find_bit.c~lib-optimize-cpumask_next_and
+++ a/tools/lib/find_bit.c
@@ -22,22 +22,29 @@
 #include <linux/bitmap.h>
 #include <linux/kernel.h>
 
-#if !defined(find_next_bit)
+#if !defined(find_next_bit) || !defined(find_next_zero_bit) || \
+		!defined(find_next_and_bit)
 
 /*
- * This is a common helper function for find_next_bit and
- * find_next_zero_bit.  The difference is the "invert" argument, which
- * is XORed with each fetched word before searching it for one bits.
+ * This is a common helper function for find_next_bit, find_next_zero_bit, and
+ * find_next_and_bit. The differences are:
+ *  - The "invert" argument, which is XORed with each fetched word before
+ *    searching it for one bits.
+ *  - The optional "addr2", which is anded with "addr1" if present.
  */
-static unsigned long _find_next_bit(const unsigned long *addr,
-		unsigned long nbits, unsigned long start, unsigned long invert)
+static inline unsigned long _find_next_bit(const unsigned long *addr1,
+		const unsigned long *addr2, unsigned long nbits,
+		unsigned long start, unsigned long invert)
 {
 	unsigned long tmp;
 
 	if (unlikely(start >= nbits))
 		return nbits;
 
-	tmp = addr[start / BITS_PER_LONG] ^ invert;
+	tmp = addr1[start / BITS_PER_LONG];
+	if (addr2)
+		tmp &= addr2[start / BITS_PER_LONG];
+	tmp ^= invert;
 
 	/* Handle 1st word. */
 	tmp &= BITMAP_FIRST_WORD_MASK(start);
@@ -48,7 +55,10 @@ static unsigned long _find_next_bit(cons
 		if (start >= nbits)
 			return nbits;
 
-		tmp = addr[start / BITS_PER_LONG] ^ invert;
+		tmp = addr1[start / BITS_PER_LONG];
+		if (addr2)
+			tmp &= addr2[start / BITS_PER_LONG];
+		tmp ^= invert;
 	}
 
 	return min(start + __ffs(tmp), nbits);
@@ -62,7 +72,7 @@ static unsigned long _find_next_bit(cons
 unsigned long find_next_bit(const unsigned long *addr, unsigned long size,
 			    unsigned long offset)
 {
-	return _find_next_bit(addr, size, offset, 0UL);
+	return _find_next_bit(addr, NULL, size, offset, 0UL);
 }
 #endif
 
@@ -104,6 +114,16 @@ unsigned long find_first_zero_bit(const
 unsigned long find_next_zero_bit(const unsigned long *addr, unsigned long size,
 				 unsigned long offset)
 {
-	return _find_next_bit(addr, size, offset, ~0UL);
+	return _find_next_bit(addr, NULL, size, offset, ~0UL);
 }
 #endif
+
+#ifndef find_next_and_bit
+unsigned long find_next_and_bit(const unsigned long *addr1,
+		const unsigned long *addr2, unsigned long size,
+		unsigned long offset)
+{
+	return _find_next_bit(addr1, addr2, size, offset, 0UL);
+}
+#endif
+
_

Patches currently in -mm which might be from courbet@google.com are


