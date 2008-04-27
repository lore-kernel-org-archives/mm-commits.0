From: akpm@linux-foundation.org
Subject: - implement-__fls-on-all-64-bit-archs.patch removed from -mm tree
Date: Sun, 27 Apr 2008 11:36:49 -0700
Message-ID: <200804271836.m3RIanFl019365@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48898 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758107AbYD0Sj3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 27 Apr 2008 14:39:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: heukelum@mailshack.com, benh@kernel.crashing.org, davem@davemloft.net, grundler@parisc-linux.org, heiko.carstens@de.ibm.com, heukelum@fastmail.fm, ink@jurassic.park.msu.ru, kyle@mcmar


The patch titled
     Implement __fls on all 64-bit archs
has been removed from the -mm tree.  Its filename was
     implement-__fls-on-all-64-bit-archs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Implement __fls on all 64-bit archs
From: Alexander van Heukelum <heukelum@mailshack.com>

Implement __fls on all 64-bit archs:

alpha has an implementation of fls64.
	Added __fls(x) = fls64(x) - 1.

ia64 has fls, but not __fls.
	Added __fls based on code of fls.

mips and powerpc have __ilog2, which is the same as __fls.
	Added __fls = __ilog2.

parisc, s390, sh and sparc64:
	Include generic __fls.

x86_64 already has __fls.

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Grant Grundler <grundler@parisc-linux.org>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-alpha/bitops.h   |    5 +++++
 include/asm-ia64/bitops.h    |   16 ++++++++++++++++
 include/asm-mips/bitops.h    |    5 +++++
 include/asm-parisc/bitops.h  |    1 +
 include/asm-powerpc/bitops.h |    5 +++++
 include/asm-s390/bitops.h    |    1 +
 include/asm-sh/bitops.h      |    1 +
 include/asm-sparc64/bitops.h |    1 +
 8 files changed, 35 insertions(+)

diff -puN include/asm-alpha/bitops.h~implement-__fls-on-all-64-bit-archs include/asm-alpha/bitops.h
--- a/include/asm-alpha/bitops.h~implement-__fls-on-all-64-bit-archs
+++ a/include/asm-alpha/bitops.h
@@ -388,6 +388,11 @@ static inline int fls64(unsigned long x)
 }
 #endif
 
+static inline unsigned long __fls(unsigned long x)
+{
+	return fls64(x) - 1;
+}
+
 static inline int fls(int x)
 {
 	return fls64((unsigned int) x);
diff -puN include/asm-ia64/bitops.h~implement-__fls-on-all-64-bit-archs include/asm-ia64/bitops.h
--- a/include/asm-ia64/bitops.h~implement-__fls-on-all-64-bit-archs
+++ a/include/asm-ia64/bitops.h
@@ -407,6 +407,22 @@ fls (int t)
 	return ia64_popcnt(x);
 }
 
+/*
+ * Find the last (most significant) bit set.  Undefined for x==0.
+ * Bits are numbered from 0..63 (e.g., __fls(9) == 3).
+ */
+static inline unsigned long
+__fls (unsigned long x)
+{
+	x |= x >> 1;
+	x |= x >> 2;
+	x |= x >> 4;
+	x |= x >> 8;
+	x |= x >> 16;
+	x |= x >> 32;
+	return ia64_popcnt(x) - 1;
+}
+
 #include <asm-generic/bitops/fls64.h>
 
 /*
diff -puN include/asm-mips/bitops.h~implement-__fls-on-all-64-bit-archs include/asm-mips/bitops.h
--- a/include/asm-mips/bitops.h~implement-__fls-on-all-64-bit-archs
+++ a/include/asm-mips/bitops.h
@@ -591,6 +591,11 @@ static inline int __ilog2(unsigned long 
 	return 63 - lz;
 }
 
+static inline unsigned long __fls(unsigned long x)
+{
+	return __ilog2(x);
+}
+
 #if defined(CONFIG_CPU_MIPS32) || defined(CONFIG_CPU_MIPS64)
 
 /*
diff -puN include/asm-parisc/bitops.h~implement-__fls-on-all-64-bit-archs include/asm-parisc/bitops.h
--- a/include/asm-parisc/bitops.h~implement-__fls-on-all-64-bit-archs
+++ a/include/asm-parisc/bitops.h
@@ -210,6 +210,7 @@ static __inline__ int fls(int x)
 	return ret;
 }
 
+#include <asm-generic/bitops/__fls.h>
 #include <asm-generic/bitops/fls64.h>
 #include <asm-generic/bitops/hweight.h>
 #include <asm-generic/bitops/lock.h>
diff -puN include/asm-powerpc/bitops.h~implement-__fls-on-all-64-bit-archs include/asm-powerpc/bitops.h
--- a/include/asm-powerpc/bitops.h~implement-__fls-on-all-64-bit-archs
+++ a/include/asm-powerpc/bitops.h
@@ -313,6 +313,11 @@ static __inline__ int fls(unsigned int x
 	return 32 - lz;
 }
 
+static inline unsigned long __fls(unsigned long x)
+{
+	return __ilog2(x);
+}
+
 /*
  * 64-bit can do this using one cntlzd (count leading zeroes doubleword)
  * instruction; for 32-bit we use the generic version, which does two
diff -puN include/asm-s390/bitops.h~implement-__fls-on-all-64-bit-archs include/asm-s390/bitops.h
--- a/include/asm-s390/bitops.h~implement-__fls-on-all-64-bit-archs
+++ a/include/asm-s390/bitops.h
@@ -769,6 +769,7 @@ static inline int sched_find_first_bit(u
 }
 
 #include <asm-generic/bitops/fls.h>
+#include <asm-generic/bitops/__fls.h>
 #include <asm-generic/bitops/fls64.h>
 
 #include <asm-generic/bitops/hweight.h>
diff -puN include/asm-sh/bitops.h~implement-__fls-on-all-64-bit-archs include/asm-sh/bitops.h
--- a/include/asm-sh/bitops.h~implement-__fls-on-all-64-bit-archs
+++ a/include/asm-sh/bitops.h
@@ -95,6 +95,7 @@ static inline unsigned long ffz(unsigned
 #include <asm-generic/bitops/ext2-atomic.h>
 #include <asm-generic/bitops/minix.h>
 #include <asm-generic/bitops/fls.h>
+#include <asm-generic/bitops/__fls.h>
 #include <asm-generic/bitops/fls64.h>
 
 #endif /* __KERNEL__ */
diff -puN include/asm-sparc64/bitops.h~implement-__fls-on-all-64-bit-archs include/asm-sparc64/bitops.h
--- a/include/asm-sparc64/bitops.h~implement-__fls-on-all-64-bit-archs
+++ a/include/asm-sparc64/bitops.h
@@ -34,6 +34,7 @@ extern void change_bit(unsigned long nr,
 #include <asm-generic/bitops/ffz.h>
 #include <asm-generic/bitops/__ffs.h>
 #include <asm-generic/bitops/fls.h>
+#include <asm-generic/bitops/__fls.h>
 #include <asm-generic/bitops/fls64.h>
 
 #ifdef __KERNEL__
_

Patches currently in -mm which might be from heukelum@mailshack.com are

origin.patch

