From: akpm@linux-foundation.org
Subject: + asm-generic-add-another-generic-ext2-atomic-bitops.patch added to -mm tree
Date: Tue, 21 Jun 2011 15:08:56 -0700
Message-ID: <201106212208.p5LM8vwN027396@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38628 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756474Ab1FUWJ2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Jun 2011 18:09:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, adilger@dilger.ca, arnd@arndb.de


The patch titled
     asm-generic: add another generic ext2 atomic bitops
has been added to the -mm tree.  Its filename is
     asm-generic-add-another-generic-ext2-atomic-bitops.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: asm-generic: add another generic ext2 atomic bitops
From: Akinobu Mita <akinobu.mita@gmail.com>

The majority of architectures implement ext2 atomic bitops as
test_and_{set,clear}_bit() without spinlock.

This adds this type of generic implementation in ext2-atomic-setbit.h and
use it wherever possible.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Suggested-by: Andreas Dilger <adilger@dilger.ca>
Suggested-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/bitops.h                 |    3 +--
 arch/arm/include/asm/bitops.h                   |    5 +----
 arch/cris/include/asm/bitops.h                  |    3 +--
 arch/frv/include/asm/bitops.h                   |    3 +--
 arch/ia64/include/asm/bitops.h                  |    3 +--
 arch/mn10300/include/asm/bitops.h               |    7 +------
 arch/parisc/include/asm/bitops.h                |    9 +--------
 arch/powerpc/include/asm/bitops.h               |    5 +----
 arch/s390/include/asm/bitops.h                  |    5 +----
 arch/sparc/include/asm/bitops_64.h              |    5 +----
 arch/tile/include/asm/bitops_64.h               |    5 +----
 arch/x86/include/asm/bitops.h                   |    5 +----
 arch/xtensa/include/asm/bitops.h                |   14 +-------------
 include/asm-generic/bitops/ext2-atomic-setbit.h |   11 +++++++++++
 include/asm-generic/bitops/ext2-atomic.h        |    4 ++++
 15 files changed, 28 insertions(+), 59 deletions(-)

diff -puN arch/alpha/include/asm/bitops.h~asm-generic-add-another-generic-ext2-atomic-bitops arch/alpha/include/asm/bitops.h
--- a/arch/alpha/include/asm/bitops.h~asm-generic-add-another-generic-ext2-atomic-bitops
+++ a/arch/alpha/include/asm/bitops.h
@@ -456,8 +456,7 @@ sched_find_first_bit(const unsigned long
 
 #include <asm-generic/bitops/le.h>
 
-#define ext2_set_bit_atomic(l,n,a)   test_and_set_bit(n,a)
-#define ext2_clear_bit_atomic(l,n,a) test_and_clear_bit(n,a)
+#include <asm-generic/bitops/ext2-atomic-setbit.h>
 
 #endif /* __KERNEL__ */
 
diff -puN arch/arm/include/asm/bitops.h~asm-generic-add-another-generic-ext2-atomic-bitops arch/arm/include/asm/bitops.h
--- a/arch/arm/include/asm/bitops.h~asm-generic-add-another-generic-ext2-atomic-bitops
+++ a/arch/arm/include/asm/bitops.h
@@ -310,10 +310,7 @@ static inline int find_next_bit_le(const
 /*
  * Ext2 is defined to use little-endian byte ordering.
  */
-#define ext2_set_bit_atomic(lock, nr, p)	\
-		test_and_set_bit_le(nr, p)
-#define ext2_clear_bit_atomic(lock, nr, p)	\
-		test_and_clear_bit_le(nr, p)
+#include <asm-generic/bitops/ext2-atomic-setbit.h>
 
 #endif /* __KERNEL__ */
 
diff -puN arch/cris/include/asm/bitops.h~asm-generic-add-another-generic-ext2-atomic-bitops arch/cris/include/asm/bitops.h
--- a/arch/cris/include/asm/bitops.h~asm-generic-add-another-generic-ext2-atomic-bitops
+++ a/arch/cris/include/asm/bitops.h
@@ -156,8 +156,7 @@ static inline int test_and_change_bit(in
 
 #include <asm-generic/bitops/le.h>
 
-#define ext2_set_bit_atomic(l,n,a)   test_and_set_bit(n,a)
-#define ext2_clear_bit_atomic(l,n,a) test_and_clear_bit(n,a)
+#include <asm-generic/bitops/ext2-atomic-setbit.h>
 
 #include <asm-generic/bitops/sched.h>
 
diff -puN arch/frv/include/asm/bitops.h~asm-generic-add-another-generic-ext2-atomic-bitops arch/frv/include/asm/bitops.h
--- a/arch/frv/include/asm/bitops.h~asm-generic-add-another-generic-ext2-atomic-bitops
+++ a/arch/frv/include/asm/bitops.h
@@ -403,8 +403,7 @@ int __ilog2_u64(u64 n)
 
 #include <asm-generic/bitops/le.h>
 
-#define ext2_set_bit_atomic(lock,nr,addr)	test_and_set_bit  ((nr) ^ 0x18, (addr))
-#define ext2_clear_bit_atomic(lock,nr,addr)	test_and_clear_bit((nr) ^ 0x18, (addr))
+#include <asm-generic/bitops/ext2-atomic-setbit.h>
 
 #endif /* __KERNEL__ */
 
diff -puN arch/ia64/include/asm/bitops.h~asm-generic-add-another-generic-ext2-atomic-bitops arch/ia64/include/asm/bitops.h
--- a/arch/ia64/include/asm/bitops.h~asm-generic-add-another-generic-ext2-atomic-bitops
+++ a/arch/ia64/include/asm/bitops.h
@@ -458,8 +458,7 @@ static __inline__ unsigned long __arch_h
 
 #include <asm-generic/bitops/le.h>
 
-#define ext2_set_bit_atomic(l,n,a)	test_and_set_bit(n,a)
-#define ext2_clear_bit_atomic(l,n,a)	test_and_clear_bit(n,a)
+#include <asm-generic/bitops/ext2-atomic-setbit.h>
 
 #include <asm-generic/bitops/sched.h>
 
diff -puN arch/mn10300/include/asm/bitops.h~asm-generic-add-another-generic-ext2-atomic-bitops arch/mn10300/include/asm/bitops.h
--- a/arch/mn10300/include/asm/bitops.h~asm-generic-add-another-generic-ext2-atomic-bitops
+++ a/arch/mn10300/include/asm/bitops.h
@@ -227,12 +227,7 @@ int ffs(int x)
 #include <asm-generic/bitops/find.h>
 #include <asm-generic/bitops/sched.h>
 #include <asm-generic/bitops/hweight.h>
-
-#define ext2_set_bit_atomic(lock, nr, addr) \
-	test_and_set_bit((nr), (addr))
-#define ext2_clear_bit_atomic(lock, nr, addr) \
-	test_and_clear_bit((nr), (addr))
-
+#include <asm-generic/bitops/ext2-atomic-setbit.h>
 #include <asm-generic/bitops/le.h>
 
 #endif /* __KERNEL__ */
diff -puN arch/parisc/include/asm/bitops.h~asm-generic-add-another-generic-ext2-atomic-bitops arch/parisc/include/asm/bitops.h
--- a/arch/parisc/include/asm/bitops.h~asm-generic-add-another-generic-ext2-atomic-bitops
+++ a/arch/parisc/include/asm/bitops.h
@@ -223,14 +223,7 @@ static __inline__ int fls(int x)
 #ifdef __KERNEL__
 
 #include <asm-generic/bitops/le.h>
-
-/* '3' is bits per byte */
-#define LE_BYTE_ADDR ((sizeof(unsigned long) - 1) << 3)
-
-#define ext2_set_bit_atomic(l,nr,addr) \
-		test_and_set_bit((nr)   ^ LE_BYTE_ADDR, (unsigned long *)addr)
-#define ext2_clear_bit_atomic(l,nr,addr) \
-		test_and_clear_bit( (nr) ^ LE_BYTE_ADDR, (unsigned long *)addr)
+#include <asm-generic/bitops/ext2-atomic-setbit.h>
 
 #endif	/* __KERNEL__ */
 
diff -puN arch/powerpc/include/asm/bitops.h~asm-generic-add-another-generic-ext2-atomic-bitops arch/powerpc/include/asm/bitops.h
--- a/arch/powerpc/include/asm/bitops.h~asm-generic-add-another-generic-ext2-atomic-bitops
+++ a/arch/powerpc/include/asm/bitops.h
@@ -327,10 +327,7 @@ unsigned long find_next_bit_le(const voi
 				    unsigned long size, unsigned long offset);
 /* Bitmap functions for the ext2 filesystem */
 
-#define ext2_set_bit_atomic(lock, nr, addr) \
-	test_and_set_bit_le((nr), (unsigned long*)addr)
-#define ext2_clear_bit_atomic(lock, nr, addr) \
-	test_and_clear_bit_le((nr), (unsigned long*)addr)
+#include <asm-generic/bitops/ext2-atomic-setbit.h>
 
 #include <asm-generic/bitops/sched.h>
 
diff -puN arch/s390/include/asm/bitops.h~asm-generic-add-another-generic-ext2-atomic-bitops arch/s390/include/asm/bitops.h
--- a/arch/s390/include/asm/bitops.h~asm-generic-add-another-generic-ext2-atomic-bitops
+++ a/arch/s390/include/asm/bitops.h
@@ -832,10 +832,7 @@ static inline int find_next_bit_le(void 
 
 #include <asm-generic/bitops/le.h>
 
-#define ext2_set_bit_atomic(lock, nr, addr)	\
-	test_and_set_bit_le(nr, addr)
-#define ext2_clear_bit_atomic(lock, nr, addr)	\
-	test_and_clear_bit_le(nr, addr)
+#include <asm-generic/bitops/ext2-atomic-setbit.h>
 
 
 #endif /* __KERNEL__ */
diff -puN arch/sparc/include/asm/bitops_64.h~asm-generic-add-another-generic-ext2-atomic-bitops arch/sparc/include/asm/bitops_64.h
--- a/arch/sparc/include/asm/bitops_64.h~asm-generic-add-another-generic-ext2-atomic-bitops
+++ a/arch/sparc/include/asm/bitops_64.h
@@ -91,10 +91,7 @@ static inline unsigned int __arch_hweigh
 
 #include <asm-generic/bitops/le.h>
 
-#define ext2_set_bit_atomic(lock,nr,addr) \
-	test_and_set_bit((nr) ^ 0x38,(unsigned long *)(addr))
-#define ext2_clear_bit_atomic(lock,nr,addr) \
-	test_and_clear_bit((nr) ^ 0x38,(unsigned long *)(addr))
+#include <asm-generic/bitops/ext2-atomic-setbit.h>
 
 #endif /* __KERNEL__ */
 
diff -puN arch/tile/include/asm/bitops_64.h~asm-generic-add-another-generic-ext2-atomic-bitops arch/tile/include/asm/bitops_64.h
--- a/arch/tile/include/asm/bitops_64.h~asm-generic-add-another-generic-ext2-atomic-bitops
+++ a/arch/tile/include/asm/bitops_64.h
@@ -97,9 +97,6 @@ static inline int test_and_change_bit(un
 	return (oldval & mask) != 0;
 }
 
-#define ext2_set_bit_atomic(lock, nr, addr)			\
-	test_and_set_bit((nr), (unsigned long *)(addr))
-#define ext2_clear_bit_atomic(lock, nr, addr)			\
-	test_and_clear_bit((nr), (unsigned long *)(addr))
+#include <asm-generic/bitops/ext2-atomic-setbit.h>
 
 #endif /* _ASM_TILE_BITOPS_64_H */
diff -puN arch/x86/include/asm/bitops.h~asm-generic-add-another-generic-ext2-atomic-bitops arch/x86/include/asm/bitops.h
--- a/arch/x86/include/asm/bitops.h~asm-generic-add-another-generic-ext2-atomic-bitops
+++ a/arch/x86/include/asm/bitops.h
@@ -458,10 +458,7 @@ static inline int fls(int x)
 
 #include <asm-generic/bitops/le.h>
 
-#define ext2_set_bit_atomic(lock, nr, addr)			\
-	test_and_set_bit((nr), (unsigned long *)(addr))
-#define ext2_clear_bit_atomic(lock, nr, addr)			\
-	test_and_clear_bit((nr), (unsigned long *)(addr))
+#include <asm-generic/bitops/ext2-atomic-setbit.h>
 
 #endif /* __KERNEL__ */
 #endif /* _ASM_X86_BITOPS_H */
diff -puN arch/xtensa/include/asm/bitops.h~asm-generic-add-another-generic-ext2-atomic-bitops arch/xtensa/include/asm/bitops.h
--- a/arch/xtensa/include/asm/bitops.h~asm-generic-add-another-generic-ext2-atomic-bitops
+++ a/arch/xtensa/include/asm/bitops.h
@@ -108,19 +108,7 @@ static inline unsigned long __fls(unsign
 #include <asm-generic/bitops/find.h>
 #include <asm-generic/bitops/le.h>
 
-#ifdef __XTENSA_EL__
-# define ext2_set_bit_atomic(lock,nr,addr)				\
-	test_and_set_bit((nr), (unsigned long*)(addr))
-# define ext2_clear_bit_atomic(lock,nr,addr)				\
-	test_and_clear_bit((nr), (unsigned long*)(addr))
-#elif defined(__XTENSA_EB__)
-# define ext2_set_bit_atomic(lock,nr,addr)				\
-	test_and_set_bit((nr) ^ 0x18, (unsigned long*)(addr))
-# define ext2_clear_bit_atomic(lock,nr,addr)				\
-	test_and_clear_bit((nr) ^ 0x18, (unsigned long*)(addr))
-#else
-# error processor byte order undefined!
-#endif
+#include <asm-generic/bitops/ext2-atomic-setbit.h>
 
 #include <asm-generic/bitops/hweight.h>
 #include <asm-generic/bitops/lock.h>
diff -puN /dev/null include/asm-generic/bitops/ext2-atomic-setbit.h
--- /dev/null
+++ a/include/asm-generic/bitops/ext2-atomic-setbit.h
@@ -0,0 +1,11 @@
+#ifndef _ASM_GENERIC_BITOPS_EXT2_ATOMIC_SETBIT_H_
+#define _ASM_GENERIC_BITOPS_EXT2_ATOMIC_SETBIT_H_
+
+/*
+ * Atomic bitops based version of ext2 atomic bitops
+ */
+
+#define ext2_set_bit_atomic(l, nr, addr)	test_and_set_bit_le(nr, addr)
+#define ext2_clear_bit_atomic(l, nr, addr)	test_and_clear_bit_le(nr, addr)
+
+#endif /* _ASM_GENERIC_BITOPS_EXT2_ATOMIC_SETBIT_H_ */
diff -puN include/asm-generic/bitops/ext2-atomic.h~asm-generic-add-another-generic-ext2-atomic-bitops include/asm-generic/bitops/ext2-atomic.h
--- a/include/asm-generic/bitops/ext2-atomic.h~asm-generic-add-another-generic-ext2-atomic-bitops
+++ a/include/asm-generic/bitops/ext2-atomic.h
@@ -1,6 +1,10 @@
 #ifndef _ASM_GENERIC_BITOPS_EXT2_ATOMIC_H_
 #define _ASM_GENERIC_BITOPS_EXT2_ATOMIC_H_
 
+/*
+ * Spinlock based version of ext2 atomic bitops
+ */
+
 #define ext2_set_bit_atomic(lock, nr, addr)		\
 	({						\
 		int ret;				\
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

linux-next.patch
asm-generic-add-another-generic-ext2-atomic-bitops.patch

