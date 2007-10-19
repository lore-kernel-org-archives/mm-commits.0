From: akpm@linux-foundation.org
Subject: - bitops-introduce-lock-ops.patch removed from -mm tree
Date: Thu, 18 Oct 2007 20:45:05 -0700
Message-ID: <200710190345.l9J3j5oO013199@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50169 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750713AbXJSEAU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 00:00:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, ak@muc.de, benh@kernel.crashing.org, blaisorblade@yahoo.it, bryan.wu@analog.com, chris@zankel.net, davem@davemloft.net, dhowells@redhat.com, geert@linux-m68k.org, ger


The patch titled
     bitops: introduce lock ops
has been removed from the -mm tree.  Its filename was
     bitops-introduce-lock-ops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: bitops: introduce lock ops
From: Nick Piggin <npiggin@suse.de>

Introduce test_and_set_bit_lock / clear_bit_unlock bitops with lock semantics.
Convert all architectures to use the generic implementation.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Acked-By: David Howells <dhowells@redhat.com>

Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Bryan Wu <bryan.wu@analog.com>
Cc: Mikael Starvik <starvik@axis.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: Greg Ungerer <gerg@uclinux.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Matthew Wilcox <willy@debian.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Kazumoto Kojima <kkojima@rr.iij4u.or.jp>
Cc: Richard Curnow <rc@rc0.org.uk>
Cc: William Lee Irwin III <wli@holomorphy.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Cc: Miles Bader <uclinux-v850@lsi.nec.co.jp>
Cc: Andi Kleen <ak@muc.de>
Cc: Chris Zankel <chris@zankel.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/atomic_ops.txt      |   14 ++++++++
 Documentation/memory-barriers.txt |   14 +++++++-
 include/asm-alpha/bitops.h        |    1 
 include/asm-arm/bitops.h          |    1 
 include/asm-avr32/bitops.h        |    1 
 include/asm-blackfin/bitops.h     |    1 
 include/asm-cris/bitops.h         |    1 
 include/asm-frv/bitops.h          |    1 
 include/asm-generic/bitops.h      |    1 
 include/asm-generic/bitops/lock.h |   45 ++++++++++++++++++++++++++++
 include/asm-h8300/bitops.h        |    1 
 include/asm-ia64/bitops.h         |    2 +
 include/asm-m32r/bitops.h         |    1 
 include/asm-m68k/bitops.h         |    1 
 include/asm-m68knommu/bitops.h    |    1 
 include/asm-mips/bitops.h         |    1 
 include/asm-parisc/bitops.h       |    1 
 include/asm-powerpc/bitops.h      |    1 
 include/asm-s390/bitops.h         |    1 
 include/asm-sh/bitops.h           |    1 
 include/asm-sh64/bitops.h         |    1 
 include/asm-sparc/bitops.h        |    1 
 include/asm-sparc64/bitops.h      |    1 
 include/asm-v850/bitops.h         |    1 
 include/asm-x86/bitops_32.h       |    1 
 include/asm-x86/bitops_64.h       |    1 
 include/asm-xtensa/bitops.h       |    1 
 27 files changed, 96 insertions(+), 2 deletions(-)

diff -puN Documentation/atomic_ops.txt~bitops-introduce-lock-ops Documentation/atomic_ops.txt
--- a/Documentation/atomic_ops.txt~bitops-introduce-lock-ops
+++ a/Documentation/atomic_ops.txt
@@ -418,6 +418,20 @@ brothers:
 	 */
 	 smp_mb__after_clear_bit();
 
+There are two special bitops with lock barrier semantics (acquire/release,
+same as spinlocks). These operate in the same way as their non-_lock/unlock
+postfixed variants, except that they are to provide acquire/release semantics,
+respectively. This means they can be used for bit_spin_trylock and
+bit_spin_unlock type operations without specifying any more barriers.
+
+	int test_and_set_bit_lock(unsigned long nr, unsigned long *addr);
+	void clear_bit_unlock(unsigned long nr, unsigned long *addr);
+	void __clear_bit_unlock(unsigned long nr, unsigned long *addr);
+
+The __clear_bit_unlock version is non-atomic, however it still implements
+unlock barrier semantics. This can be useful if the lock itself is protecting
+the other bits in the word.
+
 Finally, there are non-atomic versions of the bitmask operations
 provided.  They are used in contexts where some other higher-level SMP
 locking scheme is being used to protect the bitmask, and thus less
diff -puN Documentation/memory-barriers.txt~bitops-introduce-lock-ops Documentation/memory-barriers.txt
--- a/Documentation/memory-barriers.txt~bitops-introduce-lock-ops
+++ a/Documentation/memory-barriers.txt
@@ -1479,7 +1479,8 @@ kernel.
 
 Any atomic operation that modifies some state in memory and returns information
 about the state (old or new) implies an SMP-conditional general memory barrier
-(smp_mb()) on each side of the actual operation.  These include:
+(smp_mb()) on each side of the actual operation (with the exception of
+explicit lock operations, described later).  These include:
 
 	xchg();
 	cmpxchg();
@@ -1536,10 +1537,19 @@ If they're used for constructing a lock 
 do need memory barriers as a lock primitive generally has to do things in a
 specific order.
 
-
 Basically, each usage case has to be carefully considered as to whether memory
 barriers are needed or not.
 
+The following operations are special locking primitives:
+
+	test_and_set_bit_lock();
+	clear_bit_unlock();
+	__clear_bit_unlock();
+
+These implement LOCK-class and UNLOCK-class operations. These should be used in
+preference to other operations when implementing locking primitives, because
+their implementations can be optimised on many architectures.
+
 [!] Note that special memory barrier primitives are available for these
 situations because on some CPUs the atomic instructions used imply full memory
 barriers, and so barrier instructions are superfluous in conjunction with them,
diff -puN include/asm-alpha/bitops.h~bitops-introduce-lock-ops include/asm-alpha/bitops.h
--- a/include/asm-alpha/bitops.h~bitops-introduce-lock-ops
+++ a/include/asm-alpha/bitops.h
@@ -367,6 +367,7 @@ static inline unsigned int hweight8(unsi
 #else
 #include <asm-generic/bitops/hweight.h>
 #endif
+#include <asm-generic/bitops/lock.h>
 
 #endif /* __KERNEL__ */
 
diff -puN include/asm-arm/bitops.h~bitops-introduce-lock-ops include/asm-arm/bitops.h
--- a/include/asm-arm/bitops.h~bitops-introduce-lock-ops
+++ a/include/asm-arm/bitops.h
@@ -286,6 +286,7 @@ static inline int constant_fls(int x)
 
 #include <asm-generic/bitops/sched.h>
 #include <asm-generic/bitops/hweight.h>
+#include <asm-generic/bitops/lock.h>
 
 /*
  * Ext2 is defined to use little-endian byte ordering.
diff -puN include/asm-avr32/bitops.h~bitops-introduce-lock-ops include/asm-avr32/bitops.h
--- a/include/asm-avr32/bitops.h~bitops-introduce-lock-ops
+++ a/include/asm-avr32/bitops.h
@@ -288,6 +288,7 @@ static inline int ffs(unsigned long word
 #include <asm-generic/bitops/fls64.h>
 #include <asm-generic/bitops/sched.h>
 #include <asm-generic/bitops/hweight.h>
+#include <asm-generic/bitops/lock.h>
 
 #include <asm-generic/bitops/ext2-non-atomic.h>
 #include <asm-generic/bitops/ext2-atomic.h>
diff -puN include/asm-blackfin/bitops.h~bitops-introduce-lock-ops include/asm-blackfin/bitops.h
--- a/include/asm-blackfin/bitops.h~bitops-introduce-lock-ops
+++ a/include/asm-blackfin/bitops.h
@@ -199,6 +199,7 @@ static __inline__ int __test_bit(int nr,
 
 #include <asm-generic/bitops/find.h>
 #include <asm-generic/bitops/hweight.h>
+#include <asm-generic/bitops/lock.h>
 
 #include <asm-generic/bitops/ext2-atomic.h>
 #include <asm-generic/bitops/ext2-non-atomic.h>
diff -puN include/asm-cris/bitops.h~bitops-introduce-lock-ops include/asm-cris/bitops.h
--- a/include/asm-cris/bitops.h~bitops-introduce-lock-ops
+++ a/include/asm-cris/bitops.h
@@ -154,6 +154,7 @@ static inline int test_and_change_bit(in
 #include <asm-generic/bitops/fls64.h>
 #include <asm-generic/bitops/hweight.h>
 #include <asm-generic/bitops/find.h>
+#include <asm-generic/bitops/lock.h>
 
 #include <asm-generic/bitops/ext2-non-atomic.h>
 
diff -puN include/asm-frv/bitops.h~bitops-introduce-lock-ops include/asm-frv/bitops.h
--- a/include/asm-frv/bitops.h~bitops-introduce-lock-ops
+++ a/include/asm-frv/bitops.h
@@ -302,6 +302,7 @@ int __ilog2_u64(u64 n)
 
 #include <asm-generic/bitops/sched.h>
 #include <asm-generic/bitops/hweight.h>
+#include <asm-generic/bitops/lock.h>
 
 #include <asm-generic/bitops/ext2-non-atomic.h>
 
diff -puN include/asm-generic/bitops.h~bitops-introduce-lock-ops include/asm-generic/bitops.h
--- a/include/asm-generic/bitops.h~bitops-introduce-lock-ops
+++ a/include/asm-generic/bitops.h
@@ -22,6 +22,7 @@
 #include <asm-generic/bitops/sched.h>
 #include <asm-generic/bitops/ffs.h>
 #include <asm-generic/bitops/hweight.h>
+#include <asm-generic/bitops/lock.h>
 
 #include <asm-generic/bitops/ext2-non-atomic.h>
 #include <asm-generic/bitops/ext2-atomic.h>
diff -puN /dev/null include/asm-generic/bitops/lock.h
--- /dev/null
+++ a/include/asm-generic/bitops/lock.h
@@ -0,0 +1,45 @@
+#ifndef _ASM_GENERIC_BITOPS_LOCK_H_
+#define _ASM_GENERIC_BITOPS_LOCK_H_
+
+/**
+ * test_and_set_bit_lock - Set a bit and return its old value, for lock
+ * @nr: Bit to set
+ * @addr: Address to count from
+ *
+ * This operation is atomic and provides acquire barrier semantics.
+ * It can be used to implement bit locks.
+ */
+#define test_and_set_bit_lock(nr, addr)	test_and_set_bit(nr, addr)
+
+/**
+ * clear_bit_unlock - Clear a bit in memory, for unlock
+ * @nr: the bit to set
+ * @addr: the address to start counting from
+ *
+ * This operation is atomic and provides release barrier semantics.
+ */
+#define clear_bit_unlock(nr, addr)	\
+do {					\
+	smp_mb__before_clear_bit();	\
+	clear_bit(nr, addr);		\
+} while (0)
+
+/**
+ * __clear_bit_unlock - Clear a bit in memory, for unlock
+ * @nr: the bit to set
+ * @addr: the address to start counting from
+ *
+ * This operation is like clear_bit_unlock, however it is not atomic.
+ * It does provide release barrier semantics so it can be used to unlock
+ * a bit lock, however it would only be used if no other CPU can modify
+ * any bits in the memory until the lock is released (a good example is
+ * if the bit lock itself protects access to the other bits in the word).
+ */
+#define __clear_bit_unlock(nr, addr)	\
+do {					\
+	smp_mb();			\
+	__clear_bit(nr, addr);		\
+} while (0)
+
+#endif /* _ASM_GENERIC_BITOPS_LOCK_H_ */
+
diff -puN include/asm-h8300/bitops.h~bitops-introduce-lock-ops include/asm-h8300/bitops.h
--- a/include/asm-h8300/bitops.h~bitops-introduce-lock-ops
+++ a/include/asm-h8300/bitops.h
@@ -194,6 +194,7 @@ static __inline__ unsigned long __ffs(un
 #include <asm-generic/bitops/find.h>
 #include <asm-generic/bitops/sched.h>
 #include <asm-generic/bitops/hweight.h>
+#include <asm-generic/bitops/lock.h>
 #include <asm-generic/bitops/ext2-non-atomic.h>
 #include <asm-generic/bitops/ext2-atomic.h>
 #include <asm-generic/bitops/minix.h>
diff -puN include/asm-ia64/bitops.h~bitops-introduce-lock-ops include/asm-ia64/bitops.h
--- a/include/asm-ia64/bitops.h~bitops-introduce-lock-ops
+++ a/include/asm-ia64/bitops.h
@@ -371,6 +371,8 @@ hweight64 (unsigned long x)
 #define hweight16(x)	(unsigned int) hweight64((x) & 0xfffful)
 #define hweight8(x)	(unsigned int) hweight64((x) & 0xfful)
 
+#include <asm-generic/bitops/lock.h>
+
 #endif /* __KERNEL__ */
 
 #include <asm-generic/bitops/find.h>
diff -puN include/asm-m32r/bitops.h~bitops-introduce-lock-ops include/asm-m32r/bitops.h
--- a/include/asm-m32r/bitops.h~bitops-introduce-lock-ops
+++ a/include/asm-m32r/bitops.h
@@ -255,6 +255,7 @@ static __inline__ int test_and_change_bi
 #include <asm-generic/bitops/find.h>
 #include <asm-generic/bitops/ffs.h>
 #include <asm-generic/bitops/hweight.h>
+#include <asm-generic/bitops/lock.h>
 
 #endif /* __KERNEL__ */
 
diff -puN include/asm-m68k/bitops.h~bitops-introduce-lock-ops include/asm-m68k/bitops.h
--- a/include/asm-m68k/bitops.h~bitops-introduce-lock-ops
+++ a/include/asm-m68k/bitops.h
@@ -314,6 +314,7 @@ static inline int fls(int x)
 #include <asm-generic/bitops/fls64.h>
 #include <asm-generic/bitops/sched.h>
 #include <asm-generic/bitops/hweight.h>
+#include <asm-generic/bitops/lock.h>
 
 /* Bitmap functions for the minix filesystem */
 
diff -puN include/asm-m68knommu/bitops.h~bitops-introduce-lock-ops include/asm-m68knommu/bitops.h
--- a/include/asm-m68knommu/bitops.h~bitops-introduce-lock-ops
+++ a/include/asm-m68knommu/bitops.h
@@ -160,6 +160,7 @@ static __inline__ int __test_bit(int nr,
 
 #include <asm-generic/bitops/find.h>
 #include <asm-generic/bitops/hweight.h>
+#include <asm-generic/bitops/lock.h>
 
 static __inline__ int ext2_set_bit(int nr, volatile void * addr)
 {
diff -puN include/asm-mips/bitops.h~bitops-introduce-lock-ops include/asm-mips/bitops.h
--- a/include/asm-mips/bitops.h~bitops-introduce-lock-ops
+++ a/include/asm-mips/bitops.h
@@ -556,6 +556,7 @@ static inline int ffs(int word)
 
 #include <asm-generic/bitops/sched.h>
 #include <asm-generic/bitops/hweight.h>
+#include <asm-generic/bitops/lock.h>
 #include <asm-generic/bitops/ext2-non-atomic.h>
 #include <asm-generic/bitops/ext2-atomic.h>
 #include <asm-generic/bitops/minix.h>
diff -puN include/asm-parisc/bitops.h~bitops-introduce-lock-ops include/asm-parisc/bitops.h
--- a/include/asm-parisc/bitops.h~bitops-introduce-lock-ops
+++ a/include/asm-parisc/bitops.h
@@ -208,6 +208,7 @@ static __inline__ int fls(int x)
 
 #include <asm-generic/bitops/fls64.h>
 #include <asm-generic/bitops/hweight.h>
+#include <asm-generic/bitops/lock.h>
 #include <asm-generic/bitops/sched.h>
 
 #endif /* __KERNEL__ */
diff -puN include/asm-powerpc/bitops.h~bitops-introduce-lock-ops include/asm-powerpc/bitops.h
--- a/include/asm-powerpc/bitops.h~bitops-introduce-lock-ops
+++ a/include/asm-powerpc/bitops.h
@@ -266,6 +266,7 @@ static __inline__ int fls(unsigned int x
 #include <asm-generic/bitops/fls64.h>
 
 #include <asm-generic/bitops/hweight.h>
+#include <asm-generic/bitops/lock.h>
 
 #define find_first_zero_bit(addr, size) find_next_zero_bit((addr), (size), 0)
 unsigned long find_next_zero_bit(const unsigned long *addr,
diff -puN include/asm-s390/bitops.h~bitops-introduce-lock-ops include/asm-s390/bitops.h
--- a/include/asm-s390/bitops.h~bitops-introduce-lock-ops
+++ a/include/asm-s390/bitops.h
@@ -746,6 +746,7 @@ static inline int sched_find_first_bit(u
 #include <asm-generic/bitops/fls64.h>
 
 #include <asm-generic/bitops/hweight.h>
+#include <asm-generic/bitops/lock.h>
 
 /*
  * ATTENTION: intel byte ordering convention for ext2 and minix !!
diff -puN include/asm-sh/bitops.h~bitops-introduce-lock-ops include/asm-sh/bitops.h
--- a/include/asm-sh/bitops.h~bitops-introduce-lock-ops
+++ a/include/asm-sh/bitops.h
@@ -137,6 +137,7 @@ static inline unsigned long __ffs(unsign
 #include <asm-generic/bitops/find.h>
 #include <asm-generic/bitops/ffs.h>
 #include <asm-generic/bitops/hweight.h>
+#include <asm-generic/bitops/lock.h>
 #include <asm-generic/bitops/sched.h>
 #include <asm-generic/bitops/ext2-non-atomic.h>
 #include <asm-generic/bitops/ext2-atomic.h>
diff -puN include/asm-sh64/bitops.h~bitops-introduce-lock-ops include/asm-sh64/bitops.h
--- a/include/asm-sh64/bitops.h~bitops-introduce-lock-ops
+++ a/include/asm-sh64/bitops.h
@@ -136,6 +136,7 @@ static __inline__ unsigned long ffz(unsi
 #include <asm-generic/bitops/__ffs.h>
 #include <asm-generic/bitops/find.h>
 #include <asm-generic/bitops/hweight.h>
+#include <asm-generic/bitops/lock.h>
 #include <asm-generic/bitops/sched.h>
 #include <asm-generic/bitops/ffs.h>
 #include <asm-generic/bitops/ext2-non-atomic.h>
diff -puN include/asm-sparc/bitops.h~bitops-introduce-lock-ops include/asm-sparc/bitops.h
--- a/include/asm-sparc/bitops.h~bitops-introduce-lock-ops
+++ a/include/asm-sparc/bitops.h
@@ -96,6 +96,7 @@ static inline void change_bit(unsigned l
 #include <asm-generic/bitops/fls.h>
 #include <asm-generic/bitops/fls64.h>
 #include <asm-generic/bitops/hweight.h>
+#include <asm-generic/bitops/lock.h>
 #include <asm-generic/bitops/find.h>
 #include <asm-generic/bitops/ext2-non-atomic.h>
 #include <asm-generic/bitops/ext2-atomic.h>
diff -puN include/asm-sparc64/bitops.h~bitops-introduce-lock-ops include/asm-sparc64/bitops.h
--- a/include/asm-sparc64/bitops.h~bitops-introduce-lock-ops
+++ a/include/asm-sparc64/bitops.h
@@ -81,6 +81,7 @@ static inline unsigned int hweight8(unsi
 #include <asm-generic/bitops/hweight.h>
 
 #endif
+#include <asm-generic/bitops/lock.h>
 #endif /* __KERNEL__ */
 
 #include <asm-generic/bitops/find.h>
diff -puN include/asm-v850/bitops.h~bitops-introduce-lock-ops include/asm-v850/bitops.h
--- a/include/asm-v850/bitops.h~bitops-introduce-lock-ops
+++ a/include/asm-v850/bitops.h
@@ -145,6 +145,7 @@ static inline int __test_bit (int nr, co
 #include <asm-generic/bitops/find.h>
 #include <asm-generic/bitops/sched.h>
 #include <asm-generic/bitops/hweight.h>
+#include <asm-generic/bitops/lock.h>
 
 #include <asm-generic/bitops/ext2-non-atomic.h>
 #define ext2_set_bit_atomic(l,n,a)      test_and_set_bit(n,a)
diff -puN include/asm-x86/bitops_32.h~bitops-introduce-lock-ops include/asm-x86/bitops_32.h
--- a/include/asm-x86/bitops_32.h~bitops-introduce-lock-ops
+++ a/include/asm-x86/bitops_32.h
@@ -402,6 +402,7 @@ static inline int fls(int x)
 }
 
 #include <asm-generic/bitops/hweight.h>
+#include <asm-generic/bitops/lock.h>
 
 #endif /* __KERNEL__ */
 
diff -puN include/asm-x86/bitops_64.h~bitops-introduce-lock-ops include/asm-x86/bitops_64.h
--- a/include/asm-x86/bitops_64.h~bitops-introduce-lock-ops
+++ a/include/asm-x86/bitops_64.h
@@ -408,6 +408,7 @@ static __inline__ int fls(int x)
 #define ARCH_HAS_FAST_MULTIPLIER 1
 
 #include <asm-generic/bitops/hweight.h>
+#include <asm-generic/bitops/lock.h>
 
 #endif /* __KERNEL__ */
 
diff -puN include/asm-xtensa/bitops.h~bitops-introduce-lock-ops include/asm-xtensa/bitops.h
--- a/include/asm-xtensa/bitops.h~bitops-introduce-lock-ops
+++ a/include/asm-xtensa/bitops.h
@@ -108,6 +108,7 @@ static inline int fls (unsigned int x)
 #endif
 
 #include <asm-generic/bitops/hweight.h>
+#include <asm-generic/bitops/lock.h>
 #include <asm-generic/bitops/sched.h>
 #include <asm-generic/bitops/minix.h>
 
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-revoke.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-revoke-fix.patch
reiser4-fix-for-new-aops-patches.patch
