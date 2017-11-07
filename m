From: akpm@linux-foundation.org
Subject: [failures] lib-optimize-cpumask_next_and.patch removed from -mm
 tree
Date: Mon, 06 Nov 2017 16:02:24 -0800
Message-ID: <5a00f810.N/2reb+o/cWKRxpx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39440 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932831AbdKGAC0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Nov 2017 19:02:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: courbet@google.com, adobriyan@gmail.com, arnd@arndb.de, linux@rasmusvillemoes.dk, mawilcox@microsoft.com, mingo@kernel.org, ynorov@caviumnetworks.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib: optimize cpumask_next_and()
has been removed from the -mm tree.  Its filename was
     lib-optimize-cpumask_next_and.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Clement Courbet <courbet@google.com>
Subject: lib: optimize cpumask_next_and()

We've measured that we spend ~0.6% of sys cpu time in cpumask_next_and(). 
It's essentially a joined iteration in search for a non-zero bit, which is
currently implemented as a lookup join (find a nonzero bit on the lhs,
lookup the rhs to see if it's set there).

Implement a direct join (find a nonzero bit on the incrementally built
join).  Direct benchmarking shows that it's 1.17x to 14x faster with a
geometric mean of 2.1 on 32 CPUs.  No impact on memory usage.

Approximate benchmark code:

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

Link: http://lkml.kernel.org/r/20171026160012.10129-1-courbet@google.com
Signed-off-by: Clement Courbet <courbet@google.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Cc: Yury Norov <ynorov@caviumnetworks.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/bitops/find.h       |   16 ++++++
 include/linux/bitmap.h                  |    3 -
 lib/cpumask.c                           |    9 ++-
 lib/find_bit.c                          |   55 ++++++++++++++++------
 tools/include/asm-generic/bitops/find.h |   16 ++++++
 tools/lib/find_bit.c                    |   40 ++++++++++++----
 6 files changed, 110 insertions(+), 29 deletions(-)

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
diff -puN include/linux/bitmap.h~lib-optimize-cpumask_next_and include/linux/bitmap.h
--- a/include/linux/bitmap.h~lib-optimize-cpumask_next_and
+++ a/include/linux/bitmap.h
@@ -85,7 +85,8 @@
  *  find_first_bit(addr, nbits)         Position first set bit in *addr
  *  find_next_zero_bit(addr, nbits, bit)  Position next zero bit in *addr >= bit
  *  find_next_bit(addr, nbits, bit)     Position next set bit in *addr >= bit
- *
+ *  find_next_and_bit(addr1, addr2, nbits, bit)	Same as find_first_bit, but in
+ *						(*addr1 & *addr2)
  */
 
 /**
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
+static unsigned long _find_next_bit_le(const unsigned long *addr1,
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


