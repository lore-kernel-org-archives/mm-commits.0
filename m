From: akpm@linux-foundation.org
Subject: [merged] bitops-introduce-little-endian-bitops-for-most-architectures.patch removed from -mm tree
Date: Fri, 25 Mar 2011 00:23:55 -0700
Message-ID: <201103250723.p2P7Nnap025761@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49085 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933874Ab1CYHZt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Mar 2011 03:25:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, chris@zankel.net, davem@davemloft.net, dhowells@redhat.com, grundler@parisc-linux.org, hans-christian.egtvedt@atmel.com, hpa@zytor.com, ink@jurassic.park.msu.r


The patch titled
     bitops: introduce little-endian bitops for most architectures
has been removed from the -mm tree.  Its filename was
     bitops-introduce-little-endian-bitops-for-most-architectures.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: bitops: introduce little-endian bitops for most architectures
From: Akinobu Mita <akinobu.mita@gmail.com>

Introduce little-endian bit operations to the big-endian architectures
which do not have native little-endian bit operations and the
little-endian architectures.  (alpha, avr32, blackfin, cris, frv, h8300,
ia64, m32r, mips, mn10300, parisc, sh, sparc, tile, x86, xtensa)

These architectures can just include generic implementation
(asm-generic/bitops/le.h).

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Mikael Starvik <starvik@axis.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Matthew Wilcox <willy@debian.org>
Cc: Grant Grundler <grundler@parisc-linux.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Kazumoto Kojima <kkojima@rr.iij4u.or.jp>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Chris Zankel <chris@zankel.net>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
Acked-by: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/bitops.h              |    1 +
 arch/avr32/include/asm/bitops.h              |    1 +
 arch/blackfin/include/asm/bitops.h           |    1 +
 arch/cris/include/asm/bitops.h               |    1 +
 arch/frv/include/asm/bitops.h                |    1 +
 arch/h8300/include/asm/bitops.h              |    1 +
 arch/ia64/include/asm/bitops.h               |    1 +
 arch/m32r/include/asm/bitops.h               |    1 +
 arch/mips/include/asm/bitops.h               |    1 +
 arch/mn10300/include/asm/bitops.h            |    1 +
 arch/parisc/include/asm/bitops.h             |    1 +
 arch/sh/include/asm/bitops.h                 |    1 +
 arch/sparc/include/asm/bitops_32.h           |    1 +
 arch/sparc/include/asm/bitops_64.h           |    1 +
 arch/tile/include/asm/bitops.h               |    1 +
 arch/x86/include/asm/bitops.h                |    1 +
 arch/xtensa/include/asm/bitops.h             |    1 +
 include/asm-generic/bitops.h                 |    1 +
 include/asm-generic/bitops/ext2-non-atomic.h |    2 --
 include/asm-generic/bitops/minix-le.h        |    2 --
 20 files changed, 18 insertions(+), 4 deletions(-)

diff -puN arch/alpha/include/asm/bitops.h~bitops-introduce-little-endian-bitops-for-most-architectures arch/alpha/include/asm/bitops.h
--- a/arch/alpha/include/asm/bitops.h~bitops-introduce-little-endian-bitops-for-most-architectures
+++ a/arch/alpha/include/asm/bitops.h
@@ -454,6 +454,7 @@ sched_find_first_bit(const unsigned long
 	return __ffs(tmp) + ofs;
 }
 
+#include <asm-generic/bitops/le.h>
 #include <asm-generic/bitops/ext2-non-atomic.h>
 
 #define ext2_set_bit_atomic(l,n,a)   test_and_set_bit(n,a)
diff -puN arch/avr32/include/asm/bitops.h~bitops-introduce-little-endian-bitops-for-most-architectures arch/avr32/include/asm/bitops.h
--- a/arch/avr32/include/asm/bitops.h~bitops-introduce-little-endian-bitops-for-most-architectures
+++ a/arch/avr32/include/asm/bitops.h
@@ -299,6 +299,7 @@ static inline int ffs(unsigned long word
 #include <asm-generic/bitops/hweight.h>
 #include <asm-generic/bitops/lock.h>
 
+#include <asm-generic/bitops/le.h>
 #include <asm-generic/bitops/ext2-non-atomic.h>
 #include <asm-generic/bitops/ext2-atomic.h>
 #include <asm-generic/bitops/minix-le.h>
diff -puN arch/blackfin/include/asm/bitops.h~bitops-introduce-little-endian-bitops-for-most-architectures arch/blackfin/include/asm/bitops.h
--- a/arch/blackfin/include/asm/bitops.h~bitops-introduce-little-endian-bitops-for-most-architectures
+++ a/arch/blackfin/include/asm/bitops.h
@@ -25,6 +25,7 @@
 #include <asm-generic/bitops/const_hweight.h>
 #include <asm-generic/bitops/lock.h>
 
+#include <asm-generic/bitops/le.h>
 #include <asm-generic/bitops/ext2-non-atomic.h>
 #include <asm-generic/bitops/ext2-atomic.h>
 #include <asm-generic/bitops/minix.h>
diff -puN arch/cris/include/asm/bitops.h~bitops-introduce-little-endian-bitops-for-most-architectures arch/cris/include/asm/bitops.h
--- a/arch/cris/include/asm/bitops.h~bitops-introduce-little-endian-bitops-for-most-architectures
+++ a/arch/cris/include/asm/bitops.h
@@ -154,6 +154,7 @@ static inline int test_and_change_bit(in
 #include <asm-generic/bitops/find.h>
 #include <asm-generic/bitops/lock.h>
 
+#include <asm-generic/bitops/le.h>
 #include <asm-generic/bitops/ext2-non-atomic.h>
 
 #define ext2_set_bit_atomic(l,n,a)   test_and_set_bit(n,a)
diff -puN arch/frv/include/asm/bitops.h~bitops-introduce-little-endian-bitops-for-most-architectures arch/frv/include/asm/bitops.h
--- a/arch/frv/include/asm/bitops.h~bitops-introduce-little-endian-bitops-for-most-architectures
+++ a/arch/frv/include/asm/bitops.h
@@ -401,6 +401,7 @@ int __ilog2_u64(u64 n)
 #include <asm-generic/bitops/hweight.h>
 #include <asm-generic/bitops/lock.h>
 
+#include <asm-generic/bitops/le.h>
 #include <asm-generic/bitops/ext2-non-atomic.h>
 
 #define ext2_set_bit_atomic(lock,nr,addr)	test_and_set_bit  ((nr) ^ 0x18, (addr))
diff -puN arch/h8300/include/asm/bitops.h~bitops-introduce-little-endian-bitops-for-most-architectures arch/h8300/include/asm/bitops.h
--- a/arch/h8300/include/asm/bitops.h~bitops-introduce-little-endian-bitops-for-most-architectures
+++ a/arch/h8300/include/asm/bitops.h
@@ -200,6 +200,7 @@ static __inline__ unsigned long __ffs(un
 #include <asm-generic/bitops/sched.h>
 #include <asm-generic/bitops/hweight.h>
 #include <asm-generic/bitops/lock.h>
+#include <asm-generic/bitops/le.h>
 #include <asm-generic/bitops/ext2-non-atomic.h>
 #include <asm-generic/bitops/ext2-atomic.h>
 #include <asm-generic/bitops/minix.h>
diff -puN arch/ia64/include/asm/bitops.h~bitops-introduce-little-endian-bitops-for-most-architectures arch/ia64/include/asm/bitops.h
--- a/arch/ia64/include/asm/bitops.h~bitops-introduce-little-endian-bitops-for-most-architectures
+++ a/arch/ia64/include/asm/bitops.h
@@ -456,6 +456,7 @@ static __inline__ unsigned long __arch_h
 
 #ifdef __KERNEL__
 
+#include <asm-generic/bitops/le.h>
 #include <asm-generic/bitops/ext2-non-atomic.h>
 
 #define ext2_set_bit_atomic(l,n,a)	test_and_set_bit(n,a)
diff -puN arch/m32r/include/asm/bitops.h~bitops-introduce-little-endian-bitops-for-most-architectures arch/m32r/include/asm/bitops.h
--- a/arch/m32r/include/asm/bitops.h~bitops-introduce-little-endian-bitops-for-most-architectures
+++ a/arch/m32r/include/asm/bitops.h
@@ -266,6 +266,7 @@ static __inline__ int test_and_change_bi
 
 #ifdef __KERNEL__
 
+#include <asm-generic/bitops/le.h>
 #include <asm-generic/bitops/ext2-non-atomic.h>
 #include <asm-generic/bitops/ext2-atomic.h>
 #include <asm-generic/bitops/minix.h>
diff -puN arch/mips/include/asm/bitops.h~bitops-introduce-little-endian-bitops-for-most-architectures arch/mips/include/asm/bitops.h
--- a/arch/mips/include/asm/bitops.h~bitops-introduce-little-endian-bitops-for-most-architectures
+++ a/arch/mips/include/asm/bitops.h
@@ -676,6 +676,7 @@ static inline int ffs(int word)
 #include <asm/arch_hweight.h>
 #include <asm-generic/bitops/const_hweight.h>
 
+#include <asm-generic/bitops/le.h>
 #include <asm-generic/bitops/ext2-non-atomic.h>
 #include <asm-generic/bitops/ext2-atomic.h>
 #include <asm-generic/bitops/minix.h>
diff -puN arch/mn10300/include/asm/bitops.h~bitops-introduce-little-endian-bitops-for-most-architectures arch/mn10300/include/asm/bitops.h
--- a/arch/mn10300/include/asm/bitops.h~bitops-introduce-little-endian-bitops-for-most-architectures
+++ a/arch/mn10300/include/asm/bitops.h
@@ -233,6 +233,7 @@ int ffs(int x)
 #define ext2_clear_bit_atomic(lock, nr, addr) \
 	test_and_clear_bit((nr), (addr))
 
+#include <asm-generic/bitops/le.h>
 #include <asm-generic/bitops/ext2-non-atomic.h>
 #include <asm-generic/bitops/minix-le.h>
 
diff -puN arch/parisc/include/asm/bitops.h~bitops-introduce-little-endian-bitops-for-most-architectures arch/parisc/include/asm/bitops.h
--- a/arch/parisc/include/asm/bitops.h~bitops-introduce-little-endian-bitops-for-most-architectures
+++ a/arch/parisc/include/asm/bitops.h
@@ -222,6 +222,7 @@ static __inline__ int fls(int x)
 
 #ifdef __KERNEL__
 
+#include <asm-generic/bitops/le.h>
 #include <asm-generic/bitops/ext2-non-atomic.h>
 
 /* '3' is bits per byte */
diff -puN arch/sh/include/asm/bitops.h~bitops-introduce-little-endian-bitops-for-most-architectures arch/sh/include/asm/bitops.h
--- a/arch/sh/include/asm/bitops.h~bitops-introduce-little-endian-bitops-for-most-architectures
+++ a/arch/sh/include/asm/bitops.h
@@ -94,6 +94,7 @@ static inline unsigned long ffz(unsigned
 #include <asm-generic/bitops/hweight.h>
 #include <asm-generic/bitops/lock.h>
 #include <asm-generic/bitops/sched.h>
+#include <asm-generic/bitops/le.h>
 #include <asm-generic/bitops/ext2-non-atomic.h>
 #include <asm-generic/bitops/ext2-atomic.h>
 #include <asm-generic/bitops/minix.h>
diff -puN arch/sparc/include/asm/bitops_32.h~bitops-introduce-little-endian-bitops-for-most-architectures arch/sparc/include/asm/bitops_32.h
--- a/arch/sparc/include/asm/bitops_32.h~bitops-introduce-little-endian-bitops-for-most-architectures
+++ a/arch/sparc/include/asm/bitops_32.h
@@ -103,6 +103,7 @@ static inline void change_bit(unsigned l
 #include <asm-generic/bitops/hweight.h>
 #include <asm-generic/bitops/lock.h>
 #include <asm-generic/bitops/find.h>
+#include <asm-generic/bitops/le.h>
 #include <asm-generic/bitops/ext2-non-atomic.h>
 #include <asm-generic/bitops/ext2-atomic.h>
 #include <asm-generic/bitops/minix.h>
diff -puN arch/sparc/include/asm/bitops_64.h~bitops-introduce-little-endian-bitops-for-most-architectures arch/sparc/include/asm/bitops_64.h
--- a/arch/sparc/include/asm/bitops_64.h~bitops-introduce-little-endian-bitops-for-most-architectures
+++ a/arch/sparc/include/asm/bitops_64.h
@@ -89,6 +89,7 @@ static inline unsigned int __arch_hweigh
 
 #ifdef __KERNEL__
 
+#include <asm-generic/bitops/le.h>
 #include <asm-generic/bitops/ext2-non-atomic.h>
 
 #define ext2_set_bit_atomic(lock,nr,addr) \
diff -puN arch/tile/include/asm/bitops.h~bitops-introduce-little-endian-bitops-for-most-architectures arch/tile/include/asm/bitops.h
--- a/arch/tile/include/asm/bitops.h~bitops-introduce-little-endian-bitops-for-most-architectures
+++ a/arch/tile/include/asm/bitops.h
@@ -122,6 +122,7 @@ static inline unsigned long __arch_hweig
 #include <asm-generic/bitops/lock.h>
 #include <asm-generic/bitops/find.h>
 #include <asm-generic/bitops/sched.h>
+#include <asm-generic/bitops/le.h>
 #include <asm-generic/bitops/ext2-non-atomic.h>
 #include <asm-generic/bitops/minix.h>
 
diff -puN arch/x86/include/asm/bitops.h~bitops-introduce-little-endian-bitops-for-most-architectures arch/x86/include/asm/bitops.h
--- a/arch/x86/include/asm/bitops.h~bitops-introduce-little-endian-bitops-for-most-architectures
+++ a/arch/x86/include/asm/bitops.h
@@ -456,6 +456,7 @@ static inline int fls(int x)
 
 #ifdef __KERNEL__
 
+#include <asm-generic/bitops/le.h>
 #include <asm-generic/bitops/ext2-non-atomic.h>
 
 #define ext2_set_bit_atomic(lock, nr, addr)			\
diff -puN arch/xtensa/include/asm/bitops.h~bitops-introduce-little-endian-bitops-for-most-architectures arch/xtensa/include/asm/bitops.h
--- a/arch/xtensa/include/asm/bitops.h~bitops-introduce-little-endian-bitops-for-most-architectures
+++ a/arch/xtensa/include/asm/bitops.h
@@ -106,6 +106,7 @@ static inline unsigned long __fls(unsign
 
 #include <asm-generic/bitops/fls64.h>
 #include <asm-generic/bitops/find.h>
+#include <asm-generic/bitops/le.h>
 #include <asm-generic/bitops/ext2-non-atomic.h>
 
 #ifdef __XTENSA_EL__
diff -puN include/asm-generic/bitops.h~bitops-introduce-little-endian-bitops-for-most-architectures include/asm-generic/bitops.h
--- a/include/asm-generic/bitops.h~bitops-introduce-little-endian-bitops-for-most-architectures
+++ a/include/asm-generic/bitops.h
@@ -38,6 +38,7 @@
 
 #include <asm-generic/bitops/atomic.h>
 #include <asm-generic/bitops/non-atomic.h>
+#include <asm-generic/bitops/le.h>
 #include <asm-generic/bitops/ext2-non-atomic.h>
 #include <asm-generic/bitops/ext2-atomic.h>
 #include <asm-generic/bitops/minix.h>
diff -puN include/asm-generic/bitops/ext2-non-atomic.h~bitops-introduce-little-endian-bitops-for-most-architectures include/asm-generic/bitops/ext2-non-atomic.h
--- a/include/asm-generic/bitops/ext2-non-atomic.h~bitops-introduce-little-endian-bitops-for-most-architectures
+++ a/include/asm-generic/bitops/ext2-non-atomic.h
@@ -1,8 +1,6 @@
 #ifndef _ASM_GENERIC_BITOPS_EXT2_NON_ATOMIC_H_
 #define _ASM_GENERIC_BITOPS_EXT2_NON_ATOMIC_H_
 
-#include <asm-generic/bitops/le.h>
-
 #define ext2_set_bit(nr,addr)	\
 	__test_and_set_bit_le((nr), (unsigned long *)(addr))
 #define ext2_clear_bit(nr,addr)	\
diff -puN include/asm-generic/bitops/minix-le.h~bitops-introduce-little-endian-bitops-for-most-architectures include/asm-generic/bitops/minix-le.h
--- a/include/asm-generic/bitops/minix-le.h~bitops-introduce-little-endian-bitops-for-most-architectures
+++ a/include/asm-generic/bitops/minix-le.h
@@ -1,8 +1,6 @@
 #ifndef _ASM_GENERIC_BITOPS_MINIX_LE_H_
 #define _ASM_GENERIC_BITOPS_MINIX_LE_H_
 
-#include <asm-generic/bitops/le.h>
