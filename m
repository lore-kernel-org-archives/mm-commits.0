From: akpm@linux-foundation.org
Subject: + revert-m68k-merge-mmu-and-non-mmu-bitopsh.patch added to -mm tree
Date: Wed, 25 May 2011 12:52:12 -0700
Message-ID: <201105251950.p4PJoZkG012627@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49284 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753794Ab1EYTum (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 May 2011 15:50:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, gerg@uclinux.org


The patch titled
     revert "m68k: merge mmu and non-mmu bitops.h"
has been added to the -mm tree.  Its filename is
     revert-m68k-merge-mmu-and-non-mmu-bitopsh.patch

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
Subject: revert "m68k: merge mmu and non-mmu bitops.h"
From: Andrew Morton <akpm@linux-foundation.org>

Please don't merge new stuff into linux-next before -rc1.  It screws me
up.

Cc: Greg Ungerer <gerg@uclinux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/Kconfig                 |    4 
 arch/m68k/include/asm/bitops.h    |  511 ----------------------------
 arch/m68k/include/asm/bitops_mm.h |  493 +++++++++++++++++++++++++++
 arch/m68k/include/asm/bitops_no.h |  329 ++++++++++++++++++
 4 files changed, 825 insertions(+), 512 deletions(-)

diff -puN arch/m68k/Kconfig~revert-m68k-merge-mmu-and-non-mmu-bitopsh arch/m68k/Kconfig
--- a/arch/m68k/Kconfig~revert-m68k-merge-mmu-and-non-mmu-bitopsh
+++ a/arch/m68k/Kconfig
@@ -24,10 +24,6 @@ config GENERIC_HWEIGHT
 	bool
 	default y
 
-config GENERIC_FIND_BIT_LE
-	bool
-	default y
-
 config GENERIC_CALIBRATE_DELAY
 	bool
 	default y
diff -puN arch/m68k/include/asm/bitops.h~revert-m68k-merge-mmu-and-non-mmu-bitopsh arch/m68k/include/asm/bitops.h
--- a/arch/m68k/include/asm/bitops.h~revert-m68k-merge-mmu-and-non-mmu-bitopsh
+++ a/arch/m68k/include/asm/bitops.h
@@ -1,510 +1,5 @@
-#ifndef _M68K_BITOPS_H
-#define _M68K_BITOPS_H
-/*
- * Copyright 1992, Linus Torvalds.
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file COPYING in the main directory of this archive
- * for more details.
- */
-
-#ifndef _LINUX_BITOPS_H
-#error only <linux/bitops.h> can be included directly
-#endif
-
-#include <linux/compiler.h>
-
-/*
- *	Bit access functions vary a across the ColdFire and 68k families.
- *	So we will break them out here, and then macro in the ones we want.
- *
- *	ColdFire - supports standard bset/bclr/bchg with register operand only
- *	68000    - supports standard bset/bclr/bchg with memory operand
- *      >= 68020 - also supports the bfset/bfclr/bfchg instructions 
- *
- *	Although it is possible to use only the bset/bclr/bchg with register
- *	operands on all platforms you end up with larger generated code.
- *	So we use the best form possible on a given platform.
- */
-
-static inline void bset_reg_set_bit(int nr, volatile unsigned long *vaddr)
-{
-        char *p = (char *)vaddr + (nr ^ 31) / 8;
-
-        __asm__ __volatile__ ("bset %1,(%0)"
-		:
-		: "a" (p), "di" (nr & 7)
-		: "memory");
-}
-
-static inline void bset_mem_set_bit(int nr, volatile unsigned long *vaddr)
-{
-	char *p = (char *)vaddr + (nr ^ 31) / 8;
-
-	__asm__ __volatile__ ("bset %1,%0"
-		: "+m" (*p)
-		: "di" (nr & 7));
-}
-
-static inline void bfset_mem_set_bit(int nr, volatile unsigned long *vaddr)
-{
-	__asm__ __volatile__ ("bfset %1{%0:#1}"
-		:
-		: "d" (nr ^ 31), "o" (*vaddr)
-		: "memory");
-}
-
-#if (defined(__mc68020__) || defined(__mc68030__) || \
-     defined(__mc68040__) || defined(__mc68060__)) && !defined(__mcpu32__)
-#define set_bit(nr,vaddr)	(__builtin_constant_p(nr) ? \
-				bset_mem_set_bit(nr,vaddr) : \
-				bfset_mem_set_bit(nr,vaddr))
-#elif defined(CONFIG_COLDFIRE)
-#define	set_bit(nr,vaddr)	bset_reg_set_bit(nr,vaddr)
-#else
-#define	set_bit(nr,vaddr)	bset_mem_set_bit(nr,vaddr)
-#endif
-
-#define __set_bit(nr,vaddr)	set_bit(nr,vaddr)
-
-
-/*
- * clear_bit() doesn't provide any barrier for the compiler.
- */
-#define smp_mb__before_clear_bit()	barrier()
-#define smp_mb__after_clear_bit()	barrier()
-
-static inline void bclr_reg_clear_bit(int nr, volatile unsigned long *vaddr)
-{
-        char *p = (char *)vaddr + (nr ^ 31) / 8;
-
-        __asm__ __volatile__ ("bclr %1,(%0)"
-		:
-		: "a" (p), "di" (nr & 7)
-		: "memory");
-}
-
-static inline void bclr_mem_clear_bit(int nr, volatile unsigned long *vaddr)
-{
-	char *p = (char *)vaddr + (nr ^ 31) / 8;
-
-	__asm__ __volatile__ ("bclr %1,%0"
-		: "+m" (*p)
-		: "di" (nr & 7));
-}
-
-static inline void bfclr_mem_clear_bit(int nr, volatile unsigned long *vaddr)
-{
-	__asm__ __volatile__ ("bfclr %1{%0:#1}"
-		:
-		: "d" (nr ^ 31), "o" (*vaddr)
-		: "memory");
-}
-
-#if (defined(__mc68020__) || defined(__mc68030__) || \
-     defined(__mc68040__) || defined(__mc68060__)) && !defined(__mcpu32__)
-#define clear_bit(nr,vaddr)	(__builtin_constant_p(nr) ? \
-				bclr_mem_clear_bit(nr, vaddr) : \
-				bfclr_mem_clear_bit(nr, vaddr))
-#elif defined(CONFIG_COLDFIRE)
-#define	clear_bit(nr,vaddr)	bclr_reg_clear_bit(nr,vaddr)
-#else
-#define	clear_bit(nr,vaddr)	bclr_mem_clear_bit(nr,vaddr)
-#endif
-
-#define __clear_bit(nr,vaddr)	clear_bit(nr,vaddr)
-
-
-static inline void bchg_reg_change_bit(int nr, volatile unsigned long *vaddr)
-{
-        char *p = (char *)vaddr + (nr ^ 31) / 8;
-
-        __asm__ __volatile__ ("bchg %1,(%0)"
-		:
-		: "a" (p), "di" (nr & 7)
-		: "memory");
-}
-
-static inline void bchg_mem_change_bit(int nr, volatile unsigned long *vaddr)
-{
-	char *p = (char *)vaddr + (nr ^ 31) / 8;
-
-	__asm__ __volatile__ ("bchg %1,%0"
-		: "+m" (*p)
-		: "di" (nr & 7));
-}
-
-static inline void bfchg_mem_change_bit(int nr, volatile unsigned long *vaddr)
-{
-	__asm__ __volatile__ ("bfchg %1{%0:#1}"
-		:
-		: "d" (nr ^ 31), "o" (*vaddr)
-		: "memory");
-}
-
-#if (defined(__mc68020__) || defined(__mc68030__) || \
-     defined(__mc68040__) || defined(__mc68060__)) && !defined(__mcpu32__)
-#define change_bit(nr,vaddr)	(__builtin_constant_p(nr) ? \
-				bchg_mem_change_bit(nr,vaddr) : \
-				bfchg_mem_change_bit(nr,vaddr))
-#elif defined(CONFIG_COLDFIRE)
-#define	change_bit(nr,vaddr)	bchg_reg_change_bit(nr,vaddr)
-#else
-#define	change_bit(nr,vaddr)	bchg_mem_change_bit(nr,vaddr)
-#endif
-
-#define __change_bit(nr,vaddr)	change_bit(nr,vaddr)
-
-
-static inline int test_bit(int nr, const unsigned long *vaddr)
-{
-	return (vaddr[nr >> 5] & (1UL << (nr & 31))) != 0;
-}
-
-
-static inline int bset_reg_test_and_set_bit(int nr, volatile unsigned long *vaddr)
-{
-        char *p = (char *)vaddr + (nr ^ 31) / 8;
-        char retval;
-
-        __asm__ __volatile__ ("bset %2,(%1); sne %0"
-		: "=d" (retval)
-		: "a" (p), "di" (nr & 7)
-		: "memory");
-        return retval;
-}
-
-static inline int bset_mem_test_and_set_bit(int nr, volatile unsigned long *vaddr)
-{
-	char *p = (char *)vaddr + (nr ^ 31) / 8;
-	char retval;
-
-	__asm__ __volatile__ ("bset %2,%1; sne %0"
-		: "=d" (retval), "+m" (*p)
-		: "di" (nr & 7));
-	return retval;
-}
-
-static inline int bfset_mem_test_and_set_bit(int nr, volatile unsigned long *vaddr)
-{
-	char retval;
-
-	__asm__ __volatile__ ("bfset %2{%1:#1}; sne %0"
-		: "=d" (retval)
-		: "d" (nr ^ 31), "o" (*vaddr)
-		: "memory");
-	return retval;
-}
-
-#if (defined(__mc68020__) || defined(__mc68030__) || \
-     defined(__mc68040__) || defined(__mc68060__)) && !defined(__mcpu32__)
-#define test_and_set_bit(nr,vaddr)	(__builtin_constant_p(nr) ? \
-					bset_mem_test_and_set_bit(nr,vaddr) : \
-					bfset_mem_test_and_set_bit(nr,vaddr))
-#elif defined(CONFIG_COLDFIRE)
-#define	test_and_set_bit(nr,vaddr)	bset_reg_test_and_set_bit(nr,vaddr)
-#else
-#define	test_and_set_bit(nr,vaddr)	bset_mem_test_and_set_bit(nr,vaddr)
-#endif
-
-#define __test_and_set_bit(nr,vaddr)	test_and_set_bit(nr,vaddr)
-
-
-static inline int bclr_reg_test_and_clear_bit(int nr, volatile unsigned long *vaddr)
-{
-        char *p = (char *)vaddr + (nr ^ 31) / 8;
-        char retval;
-
-        __asm__ __volatile__ ("bclr %2,(%1); sne %0"
-		: "=d" (retval)
-		: "a" (p), "di" (nr & 7)
-		: "memory");
-        return retval;
-}
-
-static inline int bclr_mem_test_and_clear_bit(int nr, volatile unsigned long *vaddr)
-{
-	char *p = (char *)vaddr + (nr ^ 31) / 8;
-	char retval;
-
-	__asm__ __volatile__ ("bclr %2,%1; sne %0"
-		: "=d" (retval), "+m" (*p)
-		: "di" (nr & 7));
-	return retval;
-}
-
-static inline int bfclr_mem_test_and_clear_bit(int nr, volatile unsigned long *vaddr)
-{
-	char retval;
-
-	__asm__ __volatile__ ("bfclr %2{%1:#1}; sne %0"
-		: "=d" (retval)
-		: "d" (nr ^ 31), "o" (*vaddr)
-		: "memory");
-	return retval;
-}
-
-#if (defined(__mc68020__) || defined(__mc68030__) || \
-     defined(__mc68040__) || defined(__mc68060__)) && !defined(__mcpu32__)
-#define test_and_clear_bit(nr,vaddr)	(__builtin_constant_p(nr) ? \
-					bclr_mem_test_and_clear_bit(nr,vaddr) : \
-					bfclr_mem_test_and_clear_bit(nr,vaddr))
-#elif defined(CONFIG_COLDFIRE)
-#define	test_and_clear_bit(nr,vaddr)	bclr_reg_test_and_clear_bit(nr,vaddr)
+#ifdef __uClinux__
+#include "bitops_no.h"
 #else
-#define	test_and_clear_bit(nr,vaddr)	bclr_mem_test_and_clear_bit(nr,vaddr)
-#endif
-
-#define __test_and_clear_bit(nr,vaddr)	test_and_clear_bit(nr,vaddr)
-
-
-static inline int bchg_reg_test_and_change_bit(int nr, volatile unsigned long *vaddr)
-{
-        char *p = (char *)vaddr + (nr ^ 31) / 8;
-        char retval;
-
-        __asm__ __volatile__ ("bchg %2,(%1); sne %0"
-		: "=d" (retval)
-		: "a" (p), "di" (nr & 7)
-		: "memory");
-        return retval;
-}
-
-static inline int bchg_mem_test_and_change_bit(int nr, volatile unsigned long *vaddr)
-{
-	char *p = (char *)vaddr + (nr ^ 31) / 8;
-	char retval;
-
-	__asm__ __volatile__ ("bchg %2,%1; sne %0"
-		: "=d" (retval), "+m" (*p)
-		: "di" (nr & 7));
-	return retval;
-}
-
-static inline int bfchg_mem_test_and_change_bit(int nr, volatile unsigned long *vaddr)
-{
-	char retval;
-
-	__asm__ __volatile__ ("bfchg %2{%1:#1}; sne %0"
-		: "=d" (retval)
-		: "d" (nr ^ 31), "o" (*vaddr)
-		: "memory");
-	return retval;
-}
-
-#if (defined(__mc68020__) || defined(__mc68030__) || \
-     defined(__mc68040__) || defined(__mc68060__)) && !defined(__mcpu32__)
-#define test_and_change_bit(nr,vaddr)	(__builtin_constant_p(nr) ? \
-					bchg_mem_test_and_change_bit(nr,vaddr) : \
-					bfchg_mem_test_and_change_bit(nr,vaddr))
-#elif defined(CONFIG_COLDFIRE)
-#define	test_and_change_bit(nr,vaddr)	bchg_reg_test_and_change_bit(nr,vaddr)
-#else
-#define	test_and_change_bit(nr,vaddr)	bchg_mem_test_and_change_bit(nr,vaddr)
-#endif
-
-#define __test_and_change_bit(nr,vaddr)	test_and_change_bit(nr,vaddr)
-
-
-/*
- *	The true 68020 and more advanced processors support the "bfffo"
- *	instruction for finding bits. ColdFire and simple 68000 parts
- *	(including CPU32) do not support this. They simply use the generic
- *	functions.
- */
-#if (defined(__mc68020__) || defined(__mc68030__) || \
-    defined(__mc68040__) || defined(__mc68060__)) && !defined(__mcpu32__)
-
-static inline int find_first_zero_bit(const unsigned long *vaddr,
-				      unsigned size)
-{
-	const unsigned long *p = vaddr;
-	int res = 32;
-	unsigned int words;
-	unsigned long num;
-
-	if (!size)
-		return 0;
-
-	words = (size + 31) >> 5;
-	while (!(num = ~*p++)) {
-		if (!--words)
-			goto out;
-	}
-
-	__asm__ __volatile__ ("bfffo %1{#0,#0},%0"
-			      : "=d" (res) : "d" (num & -num));
-	res ^= 31;
-out:
-	res += ((long)p - (long)vaddr - 4) * 8;
-	return res < size ? res : size;
-}
-
-static inline int find_next_zero_bit(const unsigned long *vaddr, int size,
-				     int offset)
-{
-	const unsigned long *p = vaddr + (offset >> 5);
-	int bit = offset & 31UL, res;
-
-	if (offset >= size)
-		return size;
-
-	if (bit) {
-		unsigned long num = ~*p++ & (~0UL << bit);
-		offset -= bit;
-
-		/* Look for zero in first longword */
-		__asm__ __volatile__ ("bfffo %1{#0,#0},%0"
-				      : "=d" (res) : "d" (num & -num));
-		if (res < 32) {
-			offset += res ^ 31;
-			return offset < size ? offset : size;
-		}
-		offset += 32;
-
-		if (offset >= size)
-			return size;
-	}
-	/* No zero yet, search remaining full bytes for a zero */
-	return offset + find_first_zero_bit(p, size - offset);
-}
-
-static inline int find_first_bit(const unsigned long *vaddr, unsigned size)
-{
-	const unsigned long *p = vaddr;
-	int res = 32;
-	unsigned int words;
-	unsigned long num;
-
-	if (!size)
-		return 0;
-
-	words = (size + 31) >> 5;
-	while (!(num = *p++)) {
-		if (!--words)
-			goto out;
-	}
-
-	__asm__ __volatile__ ("bfffo %1{#0,#0},%0"
-			      : "=d" (res) : "d" (num & -num));
-	res ^= 31;
-out:
-	res += ((long)p - (long)vaddr - 4) * 8;
-	return res < size ? res : size;
-}
-
-static inline int find_next_bit(const unsigned long *vaddr, int size,
-				int offset)
-{
-	const unsigned long *p = vaddr + (offset >> 5);
-	int bit = offset & 31UL, res;
-
-	if (offset >= size)
-		return size;
-
-	if (bit) {
-		unsigned long num = *p++ & (~0UL << bit);
-		offset -= bit;
-
-		/* Look for one in first longword */
-		__asm__ __volatile__ ("bfffo %1{#0,#0},%0"
-				      : "=d" (res) : "d" (num & -num));
-		if (res < 32) {
-			offset += res ^ 31;
-			return offset < size ? offset : size;
-		}
-		offset += 32;
-
-		if (offset >= size)
-			return size;
-	}
-	/* No one yet, search remaining full bytes for a one */
-	return offset + find_first_bit(p, size - offset);
-}
-
-#else
-#include <asm-generic/bitops/find.h>
-#include <asm-generic/bitops/ffz.h>
-#endif
-
-#ifdef __KERNEL__
-
-#if (defined(__mc68020__) || defined(__mc68030__) || \
-    defined(__mc68040__) || defined(__mc68060__)) && !defined(__mcpu32__)
-/*
- *	ffs: find first bit set. This is defined the same way as
- *	the libc and compiler builtin ffs routines, therefore
- *	differs in spirit from the above ffz (man ffs).
- */
-static inline int ffs(int x)
-{
-	int cnt;
-
-	__asm__ ("bfffo %1{#0:#0},%0"
-		: "=d" (cnt)
-		: "dm" (x & -x));
-	return 32 - cnt;
-}
-#define __ffs(x) (ffs(x) - 1)
-
-/*
- *	fls: find last bit set.
- */
-static inline int fls(int x)
-{
-	int cnt;
-
-	__asm__ ("bfffo %1{#0,#0},%0"
-		: "=d" (cnt)
-		: "dm" (x));
-	return 32 - cnt;
-}
-
-static inline int __fls(int x)
-{
-	return fls(x) - 1;
-}
-
-#else
-
-/*
- *	The newer ColdFire family members support a "bitrev" instruction
- *	and we can use that to implement a fast ffs. Older Coldfire parts,
- *	and normal 68000 parts don't have anything special, so we use the
- *	generic functions for those.
- */
-#if defined (__mcfisaaplus__) || defined (__mcfisac__)
-static inline int __ffs(int x)
-{
-        __asm__ __volatile__ ("bitrev %0; ff1 %0"
-		: "=d" (x)
-		: "0" (x));
-        return x;
-}
-
-static inline int ffs(int x)
-{
-        if (!x)
-                return 0;
-	return __ffs(x) + 1;
-}
-
-#else
-#include <asm-generic/bitops/ffs.h>
-#include <asm-generic/bitops/__ffs.h>
-#endif
-
-#include <asm-generic/bitops/fls.h>
-#include <asm-generic/bitops/__fls.h>
-
+#include "bitops_mm.h"
 #endif
-
-#include <asm-generic/bitops/ext2-atomic.h>
-#include <asm-generic/bitops/le.h>
-#include <asm-generic/bitops/fls64.h>
-#include <asm-generic/bitops/sched.h>
-#include <asm-generic/bitops/hweight.h>
-#include <asm-generic/bitops/lock.h>
-#endif /* __KERNEL__ */
-
-#endif /* _M68K_BITOPS_H */
diff -puN /dev/null arch/m68k/include/asm/bitops_mm.h
--- /dev/null
+++ a/arch/m68k/include/asm/bitops_mm.h
@@ -0,0 +1,493 @@
+#ifndef _M68K_BITOPS_H
+#define _M68K_BITOPS_H
+/*
+ * Copyright 1992, Linus Torvalds.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file COPYING in the main directory of this archive
+ * for more details.
+ */
+
+#ifndef _LINUX_BITOPS_H
+#error only <linux/bitops.h> can be included directly
+#endif
+
+#include <linux/compiler.h>
+
+/*
+ * Require 68020 or better.
+ *
+ * They use the standard big-endian m680x0 bit ordering.
+ */
+
+#define test_and_set_bit(nr,vaddr) \
+  (__builtin_constant_p(nr) ? \
+   __constant_test_and_set_bit(nr, vaddr) : \
+   __generic_test_and_set_bit(nr, vaddr))
+
+#define __test_and_set_bit(nr,vaddr) test_and_set_bit(nr,vaddr)
+
+static inline int __constant_test_and_set_bit(int nr, unsigned long *vaddr)
+{
+	char *p = (char *)vaddr + (nr ^ 31) / 8;
+	char retval;
+
+	__asm__ __volatile__ ("bset %2,%1; sne %0"
+			: "=d" (retval), "+m" (*p)
+			: "di" (nr & 7));
+
+	return retval;
+}
+
+static inline int __generic_test_and_set_bit(int nr, unsigned long *vaddr)
+{
+	char retval;
+
+	__asm__ __volatile__ ("bfset %2{%1:#1}; sne %0"
+			: "=d" (retval) : "d" (nr^31), "o" (*vaddr) : "memory");
+
+	return retval;
+}
+
+#define set_bit(nr,vaddr) \
+  (__builtin_constant_p(nr) ? \
+   __constant_set_bit(nr, vaddr) : \
+   __generic_set_bit(nr, vaddr))
+
+#define __set_bit(nr,vaddr) set_bit(nr,vaddr)
+
+static inline void __constant_set_bit(int nr, volatile unsigned long *vaddr)
+{
+	char *p = (char *)vaddr + (nr ^ 31) / 8;
+	__asm__ __volatile__ ("bset %1,%0"
+			: "+m" (*p) : "di" (nr & 7));
+}
+
+static inline void __generic_set_bit(int nr, volatile unsigned long *vaddr)
+{
+	__asm__ __volatile__ ("bfset %1{%0:#1}"
+			: : "d" (nr^31), "o" (*vaddr) : "memory");
+}
+
+#define test_and_clear_bit(nr,vaddr) \
+  (__builtin_constant_p(nr) ? \
+   __constant_test_and_clear_bit(nr, vaddr) : \
+   __generic_test_and_clear_bit(nr, vaddr))
+
+#define __test_and_clear_bit(nr,vaddr) test_and_clear_bit(nr,vaddr)
+
+static inline int __constant_test_and_clear_bit(int nr, unsigned long *vaddr)
+{
+	char *p = (char *)vaddr + (nr ^ 31) / 8;
+	char retval;
+
+	__asm__ __volatile__ ("bclr %2,%1; sne %0"
+			: "=d" (retval), "+m" (*p)
+			: "di" (nr & 7));
+
+	return retval;
+}
+
+static inline int __generic_test_and_clear_bit(int nr, unsigned long *vaddr)
+{
+	char retval;
+
+	__asm__ __volatile__ ("bfclr %2{%1:#1}; sne %0"
+			: "=d" (retval) : "d" (nr^31), "o" (*vaddr) : "memory");
+
+	return retval;
+}
+
+/*
+ * clear_bit() doesn't provide any barrier for the compiler.
+ */
+#define smp_mb__before_clear_bit()	barrier()
+#define smp_mb__after_clear_bit()	barrier()
+
+#define clear_bit(nr,vaddr) \
+  (__builtin_constant_p(nr) ? \
+   __constant_clear_bit(nr, vaddr) : \
+   __generic_clear_bit(nr, vaddr))
+#define __clear_bit(nr,vaddr) clear_bit(nr,vaddr)
+
+static inline void __constant_clear_bit(int nr, volatile unsigned long *vaddr)
+{
+	char *p = (char *)vaddr + (nr ^ 31) / 8;
+	__asm__ __volatile__ ("bclr %1,%0"
+			: "+m" (*p) : "di" (nr & 7));
+}
+
+static inline void __generic_clear_bit(int nr, volatile unsigned long *vaddr)
+{
+	__asm__ __volatile__ ("bfclr %1{%0:#1}"
+			: : "d" (nr^31), "o" (*vaddr) : "memory");
+}
+
+#define test_and_change_bit(nr,vaddr) \
+  (__builtin_constant_p(nr) ? \
+   __constant_test_and_change_bit(nr, vaddr) : \
+   __generic_test_and_change_bit(nr, vaddr))
+
+#define __test_and_change_bit(nr,vaddr) test_and_change_bit(nr,vaddr)
+#define __change_bit(nr,vaddr) change_bit(nr,vaddr)
+
+static inline int __constant_test_and_change_bit(int nr, unsigned long *vaddr)
+{
+	char *p = (char *)vaddr + (nr ^ 31) / 8;
+	char retval;
+
+	__asm__ __volatile__ ("bchg %2,%1; sne %0"
+			: "=d" (retval), "+m" (*p)
+			: "di" (nr & 7));
+
+	return retval;
+}
+
+static inline int __generic_test_and_change_bit(int nr, unsigned long *vaddr)
+{
+	char retval;
+
+	__asm__ __volatile__ ("bfchg %2{%1:#1}; sne %0"
+			: "=d" (retval) : "d" (nr^31), "o" (*vaddr) : "memory");
+
+	return retval;
+}
+
+#define change_bit(nr,vaddr) \
+  (__builtin_constant_p(nr) ? \
+   __constant_change_bit(nr, vaddr) : \
+   __generic_change_bit(nr, vaddr))
+
+static inline void __constant_change_bit(int nr, unsigned long *vaddr)
+{
+	char *p = (char *)vaddr + (nr ^ 31) / 8;
+	__asm__ __volatile__ ("bchg %1,%0"
+			: "+m" (*p) : "di" (nr & 7));
+}
+
+static inline void __generic_change_bit(int nr, unsigned long *vaddr)
+{
+	__asm__ __volatile__ ("bfchg %1{%0:#1}"
+			: : "d" (nr^31), "o" (*vaddr) : "memory");
+}
+
+static inline int test_bit(int nr, const unsigned long *vaddr)
+{
+	return (vaddr[nr >> 5] & (1UL << (nr & 31))) != 0;
+}
+
+static inline int find_first_zero_bit(const unsigned long *vaddr,
+				      unsigned size)
+{
+	const unsigned long *p = vaddr;
+	int res = 32;
+	unsigned int words;
+	unsigned long num;
+
+	if (!size)
+		return 0;
+
+	words = (size + 31) >> 5;
+	while (!(num = ~*p++)) {
+		if (!--words)
+			goto out;
+	}
+
+	__asm__ __volatile__ ("bfffo %1{#0,#0},%0"
+			      : "=d" (res) : "d" (num & -num));
+	res ^= 31;
+out:
+	res += ((long)p - (long)vaddr - 4) * 8;
+	return res < size ? res : size;
+}
+
+static inline int find_next_zero_bit(const unsigned long *vaddr, int size,
+				     int offset)
+{
+	const unsigned long *p = vaddr + (offset >> 5);
+	int bit = offset & 31UL, res;
+
+	if (offset >= size)
+		return size;
+
+	if (bit) {
+		unsigned long num = ~*p++ & (~0UL << bit);
+		offset -= bit;
+
+		/* Look for zero in first longword */
+		__asm__ __volatile__ ("bfffo %1{#0,#0},%0"
+				      : "=d" (res) : "d" (num & -num));
+		if (res < 32) {
+			offset += res ^ 31;
+			return offset < size ? offset : size;
+		}
+		offset += 32;
+
+		if (offset >= size)
+			return size;
+	}
+	/* No zero yet, search remaining full bytes for a zero */
+	return offset + find_first_zero_bit(p, size - offset);
+}
+
+static inline int find_first_bit(const unsigned long *vaddr, unsigned size)
+{
+	const unsigned long *p = vaddr;
+	int res = 32;
+	unsigned int words;
+	unsigned long num;
+
+	if (!size)
+		return 0;
+
+	words = (size + 31) >> 5;
+	while (!(num = *p++)) {
+		if (!--words)
+			goto out;
+	}
+
+	__asm__ __volatile__ ("bfffo %1{#0,#0},%0"
+			      : "=d" (res) : "d" (num & -num));
+	res ^= 31;
+out:
+	res += ((long)p - (long)vaddr - 4) * 8;
+	return res < size ? res : size;
+}
+
+static inline int find_next_bit(const unsigned long *vaddr, int size,
+				int offset)
+{
+	const unsigned long *p = vaddr + (offset >> 5);
+	int bit = offset & 31UL, res;
+
+	if (offset >= size)
+		return size;
+
+	if (bit) {
+		unsigned long num = *p++ & (~0UL << bit);
+		offset -= bit;
+
+		/* Look for one in first longword */
+		__asm__ __volatile__ ("bfffo %1{#0,#0},%0"
+				      : "=d" (res) : "d" (num & -num));
+		if (res < 32) {
+			offset += res ^ 31;
+			return offset < size ? offset : size;
+		}
+		offset += 32;
+
+		if (offset >= size)
+			return size;
+	}
+	/* No one yet, search remaining full bytes for a one */
+	return offset + find_first_bit(p, size - offset);
+}
+
+/*
+ * ffz = Find First Zero in word. Undefined if no zero exists,
+ * so code should check against ~0UL first..
+ */
+static inline unsigned long ffz(unsigned long word)
+{
+	int res;
+
+	__asm__ __volatile__ ("bfffo %1{#0,#0},%0"
+			      : "=d" (res) : "d" (~word & -~word));
+	return res ^ 31;
+}
+
+#ifdef __KERNEL__
+
+/*
+ * ffs: find first bit set. This is defined the same way as
+ * the libc and compiler builtin ffs routines, therefore
+ * differs in spirit from the above ffz (man ffs).
+ */
+
+static inline int ffs(int x)
+{
+	int cnt;
+
+	asm ("bfffo %1{#0:#0},%0" : "=d" (cnt) : "dm" (x & -x));
+
+	return 32 - cnt;
+}
+#define __ffs(x) (ffs(x) - 1)
+
+/*
+ * fls: find last bit set.
+ */
+
+static inline int fls(int x)
+{
+	int cnt;
+
+	asm ("bfffo %1{#0,#0},%0" : "=d" (cnt) : "dm" (x));
+
+	return 32 - cnt;
+}
+
+static inline int __fls(int x)
+{
+	return fls(x) - 1;
+}
+
+#include <asm-generic/bitops/fls64.h>
+#include <asm-generic/bitops/sched.h>
+#include <asm-generic/bitops/hweight.h>
+#include <asm-generic/bitops/lock.h>
+
+/* Bitmap functions for the little endian bitmap. */
+
+static inline void __set_bit_le(int nr, void *addr)
+{
+	__set_bit(nr ^ 24, addr);
+}
+
+static inline void __clear_bit_le(int nr, void *addr)
+{
+	__clear_bit(nr ^ 24, addr);
+}
+
+static inline int __test_and_set_bit_le(int nr, void *addr)
+{
+	return __test_and_set_bit(nr ^ 24, addr);
+}
+
+static inline int test_and_set_bit_le(int nr, void *addr)
+{
+	return test_and_set_bit(nr ^ 24, addr);
+}
+
+static inline int __test_and_clear_bit_le(int nr, void *addr)
+{
+	return __test_and_clear_bit(nr ^ 24, addr);
+}
+
+static inline int test_and_clear_bit_le(int nr, void *addr)
+{
+	return test_and_clear_bit(nr ^ 24, addr);
+}
+
+static inline int test_bit_le(int nr, const void *vaddr)
+{
+	const unsigned char *p = vaddr;
+	return (p[nr >> 3] & (1U << (nr & 7))) != 0;
+}
+
+static inline int find_first_zero_bit_le(const void *vaddr, unsigned size)
+{
+	const unsigned long *p = vaddr, *addr = vaddr;
+	int res = 0;
+	unsigned int words;
+
+	if (!size)
+		return 0;
+
+	words = (size >> 5) + ((size & 31) > 0);
+	while (*p++ == ~0UL) {
+		if (--words == 0)
+			goto out;
+	}
+
+	--p;
+	for (res = 0; res < 32; res++)
+		if (!test_bit_le(res, p))
+			break;
+out:
+	res += (p - addr) * 32;
+	return res < size ? res : size;
+}
+
+static inline unsigned long find_next_zero_bit_le(const void *addr,
+		unsigned long size, unsigned long offset)
+{
+	const unsigned long *p = addr;
+	int bit = offset & 31UL, res;
+
+	if (offset >= size)
+		return size;
+
+	p += offset >> 5;
+
+	if (bit) {
+		offset -= bit;
+		/* Look for zero in first longword */
+		for (res = bit; res < 32; res++)
+			if (!test_bit_le(res, p)) {
+				offset += res;
+				return offset < size ? offset : size;
+			}
+		p++;
+		offset += 32;
+
+		if (offset >= size)
+			return size;
+	}
+	/* No zero yet, search remaining full bytes for a zero */
+	return offset + find_first_zero_bit_le(p, size - offset);
+}
+
+static inline int find_first_bit_le(const void *vaddr, unsigned size)
+{
+	const unsigned long *p = vaddr, *addr = vaddr;
+	int res = 0;
+	unsigned int words;
+
+	if (!size)
+		return 0;
+
+	words = (size >> 5) + ((size & 31) > 0);
+	while (*p++ == 0UL) {
+		if (--words == 0)
+			goto out;
+	}
+
+	--p;
+	for (res = 0; res < 32; res++)
+		if (test_bit_le(res, p))
+			break;
+out:
+	res += (p - addr) * 32;
+	return res < size ? res : size;
+}
+
+static inline unsigned long find_next_bit_le(const void *addr,
+		unsigned long size, unsigned long offset)
+{
+	const unsigned long *p = addr;
+	int bit = offset & 31UL, res;
+
+	if (offset >= size)
+		return size;
+
+	p += offset >> 5;
+
+	if (bit) {
+		offset -= bit;
+		/* Look for one in first longword */
+		for (res = bit; res < 32; res++)
+			if (test_bit_le(res, p)) {
+				offset += res;
+				return offset < size ? offset : size;
+			}
+		p++;
+		offset += 32;
+
+		if (offset >= size)
+			return size;
+	}
+	/* No set bit yet, search remaining full bytes for a set bit */
+	return offset + find_first_bit_le(p, size - offset);
+}
+
+/* Bitmap functions for the ext2 filesystem. */
+
+#define ext2_set_bit_atomic(lock, nr, addr)	\
+	test_and_set_bit_le(nr, addr)
+#define ext2_clear_bit_atomic(lock, nr, addr)	\
+	test_and_clear_bit_le(nr, addr)
+
+#endif /* __KERNEL__ */
+
+#endif /* _M68K_BITOPS_H */
diff -puN /dev/null arch/m68k/include/asm/bitops_no.h
--- /dev/null
+++ a/arch/m68k/include/asm/bitops_no.h
@@ -0,0 +1,329 @@
+#ifndef _M68KNOMMU_BITOPS_H
+#define _M68KNOMMU_BITOPS_H
+
+/*
+ * Copyright 1992, Linus Torvalds.
+ */
+
+#include <linux/compiler.h>
+#include <asm/byteorder.h>	/* swab32 */
+
+#ifdef __KERNEL__
+
+#ifndef _LINUX_BITOPS_H
+#error only <linux/bitops.h> can be included directly
+#endif
+
+#if defined (__mcfisaaplus__) || defined (__mcfisac__)
+static inline int ffs(unsigned int val)
+{
+        if (!val)
+                return 0;
+
+        asm volatile(
+                        "bitrev %0\n\t"
+                        "ff1 %0\n\t"
+                        : "=d" (val)
+                        : "0" (val)
+		    );
+        val++;
+        return val;
+}
+
+static inline int __ffs(unsigned int val)
+{
+        asm volatile(
+                        "bitrev %0\n\t"
+                        "ff1 %0\n\t"
+                        : "=d" (val)
+                        : "0" (val)
+		    );
+        return val;
+}
+
+#else
+#include <asm-generic/bitops/ffs.h>
+#include <asm-generic/bitops/__ffs.h>
+#endif
+
+#include <asm-generic/bitops/sched.h>
+#include <asm-generic/bitops/ffz.h>
+
+static __inline__ void set_bit(int nr, volatile unsigned long * addr)
+{
+#ifdef CONFIG_COLDFIRE
+	__asm__ __volatile__ ("lea %0,%%a0; bset %1,(%%a0)"
+	     : "+m" (((volatile char *)addr)[(nr^31) >> 3])
+	     : "d" (nr)
+	     : "%a0", "cc");
+#else
+	__asm__ __volatile__ ("bset %1,%0"
+	     : "+m" (((volatile char *)addr)[(nr^31) >> 3])
+	     : "di" (nr)
+	     : "cc");
+#endif
+}
+
+#define __set_bit(nr, addr) set_bit(nr, addr)
+
+/*
+ * clear_bit() doesn't provide any barrier for the compiler.
+ */
+#define smp_mb__before_clear_bit()	barrier()
+#define smp_mb__after_clear_bit()	barrier()
+
+static __inline__ void clear_bit(int nr, volatile unsigned long * addr)
+{
+#ifdef CONFIG_COLDFIRE
+	__asm__ __volatile__ ("lea %0,%%a0; bclr %1,(%%a0)"
+	     : "+m" (((volatile char *)addr)[(nr^31) >> 3])
+	     : "d" (nr)
+	     : "%a0", "cc");
+#else
+	__asm__ __volatile__ ("bclr %1,%0"
+	     : "+m" (((volatile char *)addr)[(nr^31) >> 3])
+	     : "di" (nr)
+	     : "cc");
+#endif
+}
+
+#define __clear_bit(nr, addr) clear_bit(nr, addr)
+
+static __inline__ void change_bit(int nr, volatile unsigned long * addr)
+{
+#ifdef CONFIG_COLDFIRE
+	__asm__ __volatile__ ("lea %0,%%a0; bchg %1,(%%a0)"
+	     : "+m" (((volatile char *)addr)[(nr^31) >> 3])
+	     : "d" (nr)
+	     : "%a0", "cc");
+#else
+	__asm__ __volatile__ ("bchg %1,%0"
+	     : "+m" (((volatile char *)addr)[(nr^31) >> 3])
+	     : "di" (nr)
+	     : "cc");
+#endif
+}
+
+#define __change_bit(nr, addr) change_bit(nr, addr)
+
+static __inline__ int test_and_set_bit(int nr, volatile unsigned long * addr)
+{
+	char retval;
+
+#ifdef CONFIG_COLDFIRE
+	__asm__ __volatile__ ("lea %1,%%a0; bset %2,(%%a0); sne %0"
+	     : "=d" (retval), "+m" (((volatile char *)addr)[(nr^31) >> 3])
+	     : "d" (nr)
+	     : "%a0");
+#else
+	__asm__ __volatile__ ("bset %2,%1; sne %0"
+	     : "=d" (retval), "+m" (((volatile char *)addr)[(nr^31) >> 3])
+	     : "di" (nr)
+	     /* No clobber */);
+#endif
+
+	return retval;
+}
+
+#define __test_and_set_bit(nr, addr) test_and_set_bit(nr, addr)
+
+static __inline__ int test_and_clear_bit(int nr, volatile unsigned long * addr)
+{
+	char retval;
+
+#ifdef CONFIG_COLDFIRE
+	__asm__ __volatile__ ("lea %1,%%a0; bclr %2,(%%a0); sne %0"
+	     : "=d" (retval), "+m" (((volatile char *)addr)[(nr^31) >> 3])
+	     : "d" (nr)
+	     : "%a0");
+#else
+	__asm__ __volatile__ ("bclr %2,%1; sne %0"
+	     : "=d" (retval), "+m" (((volatile char *)addr)[(nr^31) >> 3])
+	     : "di" (nr)
+	     /* No clobber */);
+#endif
+
+	return retval;
+}
+
+#define __test_and_clear_bit(nr, addr) test_and_clear_bit(nr, addr)
+
+static __inline__ int test_and_change_bit(int nr, volatile unsigned long * addr)
+{
+	char retval;
+
+#ifdef CONFIG_COLDFIRE
+	__asm__ __volatile__ ("lea %1,%%a0\n\tbchg %2,(%%a0)\n\tsne %0"
+	     : "=d" (retval), "+m" (((volatile char *)addr)[(nr^31) >> 3])
+	     : "d" (nr)
+	     : "%a0");
+#else
+	__asm__ __volatile__ ("bchg %2,%1; sne %0"
+	     : "=d" (retval), "+m" (((volatile char *)addr)[(nr^31) >> 3])
+	     : "di" (nr)
+	     /* No clobber */);
+#endif
+
+	return retval;
+}
+
+#define __test_and_change_bit(nr, addr) test_and_change_bit(nr, addr)
+
+/*
+ * This routine doesn't need to be atomic.
+ */
+static __inline__ int __constant_test_bit(int nr, const volatile unsigned long * addr)
+{
+	return ((1UL << (nr & 31)) & (((const volatile unsigned int *) addr)[nr >> 5])) != 0;
+}
+
+static __inline__ int __test_bit(int nr, const volatile unsigned long * addr)
+{
+	int 	* a = (int *) addr;
+	int	mask;
+
+	a += nr >> 5;
+	mask = 1 << (nr & 0x1f);
+	return ((mask & *a) != 0);
+}
+
+#define test_bit(nr,addr) \
+(__builtin_constant_p(nr) ? \
+ __constant_test_bit((nr),(addr)) : \
+ __test_bit((nr),(addr)))
+
+#include <asm-generic/bitops/find.h>
+#include <asm-generic/bitops/hweight.h>
+#include <asm-generic/bitops/lock.h>
+
+#define BITOP_LE_SWIZZLE	((BITS_PER_LONG-1) & ~0x7)
+
+static inline void __set_bit_le(int nr, void *addr)
+{
+	__set_bit(nr ^ BITOP_LE_SWIZZLE, addr);
+}
+
+static inline void __clear_bit_le(int nr, void *addr)
+{
+	__clear_bit(nr ^ BITOP_LE_SWIZZLE, addr);
+}
+
+static inline int __test_and_set_bit_le(int nr, volatile void *addr)
+{
+	char retval;
+
+#ifdef CONFIG_COLDFIRE
+	__asm__ __volatile__ ("lea %1,%%a0; bset %2,(%%a0); sne %0"
+	     : "=d" (retval), "+m" (((volatile char *)addr)[nr >> 3])
+	     : "d" (nr)
+	     : "%a0");
+#else
+	__asm__ __volatile__ ("bset %2,%1; sne %0"
+	     : "=d" (retval), "+m" (((volatile char *)addr)[nr >> 3])
+	     : "di" (nr)
+	     /* No clobber */);
+#endif
+
+	return retval;
+}
+
+static inline int __test_and_clear_bit_le(int nr, volatile void *addr)
+{
+	char retval;
+
+#ifdef CONFIG_COLDFIRE
+	__asm__ __volatile__ ("lea %1,%%a0; bclr %2,(%%a0); sne %0"
+	     : "=d" (retval), "+m" (((volatile char *)addr)[nr >> 3])
+	     : "d" (nr)
+	     : "%a0");
+#else
+	__asm__ __volatile__ ("bclr %2,%1; sne %0"
+	     : "=d" (retval), "+m" (((volatile char *)addr)[nr >> 3])
+	     : "di" (nr)
+	     /* No clobber */);
+#endif
+
+	return retval;
+}
+
+#include <asm-generic/bitops/ext2-atomic.h>
+
+static inline int test_bit_le(int nr, const volatile void *addr)
+{
+	char retval;
+
+#ifdef CONFIG_COLDFIRE
+	__asm__ __volatile__ ("lea %1,%%a0; btst %2,(%%a0); sne %0"
+	     : "=d" (retval)
+	     : "m" (((const volatile char *)addr)[nr >> 3]), "d" (nr)
+	     : "%a0");
+#else
+	__asm__ __volatile__ ("btst %2,%1; sne %0"
+	     : "=d" (retval)
+	     : "m" (((const volatile char *)addr)[nr >> 3]), "di" (nr)
+	     /* No clobber */);
+#endif
+
+	return retval;
+}
+
+#define find_first_zero_bit_le(addr, size)	\
+	find_next_zero_bit_le((addr), (size), 0)
+
+static inline unsigned long find_next_zero_bit_le(void *addr, unsigned long size, unsigned long offset)
+{
+	unsigned long *p = ((unsigned long *) addr) + (offset >> 5);
+	unsigned long result = offset & ~31UL;
+	unsigned long tmp;
+
+	if (offset >= size)
+		return size;
+	size -= result;
+	offset &= 31UL;
+	if(offset) {
+		/* We hold the little endian value in tmp, but then the
+		 * shift is illegal. So we could keep a big endian value
+		 * in tmp, like this:
+		 *
+		 * tmp = __swab32(*(p++));
+		 * tmp |= ~0UL >> (32-offset);
+		 *
+		 * but this would decrease performance, so we change the
+		 * shift:
+		 */
+		tmp = *(p++);
+		tmp |= __swab32(~0UL >> (32-offset));
+		if(size < 32)
+			goto found_first;
+		if(~tmp)
+			goto found_middle;
+		size -= 32;
+		result += 32;
+	}
+	while(size & ~31UL) {
+		if(~(tmp = *(p++)))
+			goto found_middle;
+		result += 32;
+		size -= 32;
+	}
+	if(!size)
+		return result;
+	tmp = *p;
+
+found_first:
+	/* tmp is little endian, so we would have to swab the shift,
+	 * see above. But then we have to swab tmp below for ffz, so
+	 * we might as well do this here.
+	 */
+	return result + ffz(__swab32(tmp) | (~0UL << size));
+found_middle:
+	return result + ffz(__swab32(tmp));
+}
+
+#endif /* __KERNEL__ */
+
+#include <asm-generic/bitops/fls.h>
+#include <asm-generic/bitops/__fls.h>
+#include <asm-generic/bitops/fls64.h>
+
+#endif /* _M68KNOMMU_BITOPS_H */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
backlight-add-backlight-type-fix.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
revert-m68k-merge-mmu-and-non-mmu-bitopsh.patch
drivers-base-platformc-dont-mark-platform_device_register_resndata-as-__init_or_module.patch
arch-x86-include-asm-delayh-fix-udelay-and-ndelay-for-8-bit-args.patch
mtd-convert-to-seq_file-interface.patch
rfcomm-corec-avoid-dangling-pointer-check-session-exists-checkpatch-fixes.patch
drivers-bcma-host_pcic-needs-slabh.patch
slab-use-numa_no_node.patch
mm.patch
writeback-sync-expired-inodes-first-in-background-writeback-fix.patch
writeback-split-inode_wb_list_lock-into-bdi_writebacklist_lock-fix-fix.patch
writeback-split-inode_wb_list_lock-into-bdi_writebacklist_lock-fix-fix-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
arch-alpha-include-asm-ioh-s-extern-inline-static-inline.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
checkpatch-suggest-using-min_t-or-max_t.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
drivers-rtc-rtc-mrstc-use-release_mem_region-after-request_mem_region-fix.patch
rtc-driver-for-pt7c4338-chip-checkpatch-fixes.patch
rtc-driver-for-pt7c4338-chip-fix.patch
drivers-rtc-rtc-mxcc-remove-defines-already-included-in-rtch-fix.patch
documentation-accounting-getdelaysc-handle-sendto-failures.patch
documentation-configfs-examples-crash-fix-checkpatch-fixes.patch
mm-move-enum-vm_event_item-into-a-standalone-header-file.patch
memcg-reclaim-memory-from-nodes-in-round-robin-fix.patch
add-the-pagefault-count-into-memcg-stats.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily-fix.patch
fs-partitions-efic-corrupted-guid-partition-tables-can-cause-kernel-oops-fix.patch
kernel-profilec-remove-some-duplicate-code-from-profile_hits-fix.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
w1-add-maxim-dallas-ds2780-stand-alone-fuel-gauge-ic-support-v3-fix.patch
kexec-remove-kmsg_dump_kexec-fix.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

