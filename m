From: akpm@linux-foundation.org
Subject: - kernel-move-arches-to-use-common-unaligned-access.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:49:08 -0700
Message-ID: <200804300549.m3U5n8pT029972__29891.1606813364$1209534661$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56285 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758802AbYD3Fto (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:49:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, linux-arch@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     kernel: Move arches to use common unaligned access
has been removed from the -mm tree.  Its filename was
     kernel-move-arches-to-use-common-unaligned-access.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kernel: Move arches to use common unaligned access
From: Harvey Harrison <harvey.harrison@gmail.com>

Unaligned access is ok for the following arches:
cris, m68k, mn10300, powerpc, s390, x86

Arches that use the memmove implementation for native endian, and
the byteshifting for the opposite endianness.
h8300, m32r, xtensa

Packed struct for native endian, byteshifting for other endian:
alpha, blackfin, ia64, parisc, sparc, sparc64, mips, sh

m86knommu is generic_be for Coldfire, otherwise unaligned access is ok.

frv, arm chooses endianness based on compiler settings, uses the byteshifting
versions.  Remove the unaligned trap handler from frv as it is now unused.

v850 is le, uses the byteshifting versions for both be and le.

Remove the now unused asm-generic implementation.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: <linux-arch@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/frv/kernel/traps.c           |    7 
 arch/frv/mm/unaligned.c           |  217 ----------------------------
 include/asm-alpha/unaligned.h     |   13 +
 include/asm-arm/unaligned.h       |  174 ----------------------
 include/asm-avr32/unaligned.h     |   13 +
 include/asm-blackfin/unaligned.h  |   13 +
 include/asm-cris/unaligned.h      |   17 --
 include/asm-frv/unaligned.h       |  196 +------------------------
 include/asm-generic/unaligned.h   |  124 ----------------
 include/asm-h8300/unaligned.h     |   20 +-
 include/asm-ia64/unaligned.h      |    7 
 include/asm-m32r/unaligned.h      |   27 +--
 include/asm-m68k/unaligned.h      |   17 --
 include/asm-m68knommu/unaligned.h |   22 +-
 include/asm-mips/unaligned.h      |   37 ++--
 include/asm-mn10300/unaligned.h   |  130 ----------------
 include/asm-parisc/unaligned.h    |   12 +
 include/asm-powerpc/unaligned.h   |   11 -
 include/asm-s390/unaligned.h      |   25 ---
 include/asm-sh/unaligned.h        |   20 ++
 include/asm-sparc/unaligned.h     |   10 -
 include/asm-sparc64/unaligned.h   |   10 -
 include/asm-um/unaligned.h        |    6 
 include/asm-v850/unaligned.h      |  124 +---------------
 include/asm-x86/unaligned.h       |   31 ----
 include/asm-xtensa/unaligned.h    |   35 ++--
 26 files changed, 203 insertions(+), 1115 deletions(-)

diff -puN arch/frv/kernel/traps.c~kernel-move-arches-to-use-common-unaligned-access arch/frv/kernel/traps.c
--- a/arch/frv/kernel/traps.c~kernel-move-arches-to-use-common-unaligned-access
+++ a/arch/frv/kernel/traps.c
@@ -362,11 +362,8 @@ asmlinkage void memory_access_exception(
 #ifdef CONFIG_MMU
 	unsigned long fixup;
 
-	if ((esr0 & ESRx_EC) == ESRx_EC_DATA_ACCESS)
-		if (handle_misalignment(esr0, ear0, epcr0) == 0)
-			return;
-
-	if ((fixup = search_exception_table(__frame->pc)) != 0) {
+	fixup = search_exception_table(__frame->pc);
+	if (fixup) {
 		__frame->pc = fixup;
 		return;
 	}
diff -puN arch/frv/mm/unaligned.c~kernel-move-arches-to-use-common-unaligned-access /dev/null
--- a/arch/frv/mm/unaligned.c
+++ /dev/null
@@ -1,217 +0,0 @@
-/* unaligned.c: unalignment fixup handler for CPUs on which it is supported (FR451 only)
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
-#include <linux/sched.h>
-#include <linux/signal.h>
-#include <linux/kernel.h>
-#include <linux/mm.h>
-#include <linux/types.h>
-#include <linux/user.h>
-#include <linux/string.h>
-#include <linux/linkage.h>
-#include <linux/init.h>
-
-#include <asm/setup.h>
-#include <asm/system.h>
-#include <asm/uaccess.h>
-
-#if 0
-#define kdebug(fmt, ...) printk("FDPIC "fmt"\n" ,##__VA_ARGS__ )
-#else
-#define kdebug(fmt, ...) do {} while(0)
-#endif
-
-#define _MA_SIGNED	0x01
-#define _MA_HALF	0x02
-#define _MA_WORD	0x04
-#define _MA_DWORD	0x08
-#define _MA_SZ_MASK	0x0e
-#define _MA_LOAD	0x10
-#define _MA_STORE	0x20
-#define _MA_UPDATE	0x40
-#define _MA_IMM		0x80
-
-#define _MA_LDxU	_MA_LOAD | _MA_UPDATE
-#define _MA_LDxI	_MA_LOAD | _MA_IMM
-#define _MA_STxU	_MA_STORE | _MA_UPDATE
-#define _MA_STxI	_MA_STORE | _MA_IMM
-
-static const uint8_t tbl_LDGRk_reg[0x40] = {
-	[0x02] = _MA_LOAD | _MA_HALF | _MA_SIGNED,	/* LDSH  @(GRi,GRj),GRk */
-	[0x03] = _MA_LOAD | _MA_HALF,			/* LDUH  @(GRi,GRj),GRk */
-	[0x04] = _MA_LOAD | _MA_WORD,			/* LD	 @(GRi,GRj),GRk */
-	[0x05] = _MA_LOAD | _MA_DWORD,			/* LDD	 @(GRi,GRj),GRk */
-	[0x12] = _MA_LDxU | _MA_HALF | _MA_SIGNED,	/* LDSHU @(GRi,GRj),GRk */
-	[0x13] = _MA_LDxU | _MA_HALF,			/* LDUHU @(GRi,GRj),GRk */
-	[0x14] = _MA_LDxU | _MA_WORD,			/* LDU	 @(GRi,GRj),GRk */
-	[0x15] = _MA_LDxU | _MA_DWORD,			/* LDDU	 @(GRi,GRj),GRk */
-};
-
-static const uint8_t tbl_STGRk_reg[0x40] = {
-	[0x01] = _MA_STORE | _MA_HALF,			/* STH   @(GRi,GRj),GRk */
-	[0x02] = _MA_STORE | _MA_WORD,			/* ST	 @(GRi,GRj),GRk */
-	[0x03] = _MA_STORE | _MA_DWORD,			/* STD	 @(GRi,GRj),GRk */
-	[0x11] = _MA_STxU  | _MA_HALF,			/* STHU  @(GRi,GRj),GRk */
-	[0x12] = _MA_STxU  | _MA_WORD,			/* STU	 @(GRi,GRj),GRk */
-	[0x13] = _MA_STxU  | _MA_DWORD,			/* STDU	 @(GRi,GRj),GRk */
-};
-
-static const uint8_t tbl_LDSTGRk_imm[0x80] = {
-	[0x31] = _MA_LDxI | _MA_HALF | _MA_SIGNED,	/* LDSHI @(GRi,d12),GRk */
-	[0x32] = _MA_LDxI | _MA_WORD,			/* LDI   @(GRi,d12),GRk */
-	[0x33] = _MA_LDxI | _MA_DWORD,			/* LDDI  @(GRi,d12),GRk */
-	[0x36] = _MA_LDxI | _MA_HALF,			/* LDUHI @(GRi,d12),GRk */
-	[0x51] = _MA_STxI | _MA_HALF,			/* STHI  @(GRi,d12),GRk */
-	[0x52] = _MA_STxI | _MA_WORD,			/* STI   @(GRi,d12),GRk */
-	[0x53] = _MA_STxI | _MA_DWORD,			/* STDI  @(GRi,d12),GRk */
-};
-
-
-/*****************************************************************************/
-/*
- * see if we can handle the exception by fixing up a misaligned memory access
- */
-int handle_misalignment(unsigned long esr0, unsigned long ear0, unsigned long epcr0)
-{
-	unsigned long insn, addr, *greg;
-	int GRi, GRj, GRk, D12, op;
-
-	union {
-		uint64_t _64;
-		uint32_t _32[2];
-		uint16_t _16;
-		uint8_t _8[8];
-	} x;
-
-	if (!(esr0 & ESR0_EAV) || !(epcr0 & EPCR0_V) || !(ear0 & 7))
-		return -EAGAIN;
-
-	epcr0 &= EPCR0_PC;
-
-	if (__frame->pc != epcr0) {
-		kdebug("MISALIGN: Execution not halted on excepting instruction\n");
-		BUG();
-	}
-
-	if (__get_user(insn, (unsigned long *) epcr0) < 0)
-		return -EFAULT;
-
-	/* determine the instruction type first */
-	switch ((insn >> 18) & 0x7f) {
-	case 0x2:
-		/* LDx @(GRi,GRj),GRk */
-		op = tbl_LDGRk_reg[(insn >> 6) & 0x3f];
-		break;
-
-	case 0x3:
-		/* STx GRk,@(GRi,GRj) */
-		op = tbl_STGRk_reg[(insn >> 6) & 0x3f];
-		break;
-
-	default:
-		op = tbl_LDSTGRk_imm[(insn >> 18) & 0x7f];
-		break;
-	}
-
-	if (!op)
-		return -EAGAIN;
-
-	kdebug("MISALIGN: pc=%08lx insn=%08lx ad=%08lx op=%02x\n", epcr0, insn, ear0, op);
-
-	memset(&x, 0xba, 8);
-
-	/* validate the instruction parameters */
-	greg = (unsigned long *) &__frame->tbr;
-
-	GRi = (insn >> 12) & 0x3f;
-	GRk = (insn >> 25) & 0x3f;
-
-	if (GRi > 31 || GRk > 31)
-		return -ENOENT;
-
-	if (op & _MA_DWORD && GRk & 1)
-		return -EINVAL;
-
-	if (op & _MA_IMM) {
-		D12 = insn & 0xfff;
-		asm ("slli %0,#20,%0 ! srai %0,#20,%0" : "=r"(D12) : "0"(D12)); /* sign extend */
-		addr = (GRi ? greg[GRi] : 0) + D12;
-	}
-	else {
-		GRj = (insn >>  0) & 0x3f;
-		if (GRj > 31)
-			return -ENOENT;
-		addr = (GRi ? greg[GRi] : 0) + (GRj ? greg[GRj] : 0);
-	}
-
-	if (addr != ear0) {
-		kdebug("MISALIGN: Calculated addr (%08lx) does not match EAR0 (%08lx)\n",
-		       addr, ear0);
-		return -EFAULT;
-	}
-
-	/* check the address is okay */
-	if (user_mode(__frame) && ___range_ok(ear0, 8) < 0)
-		return -EFAULT;
-
-	/* perform the memory op */
-	if (op & _MA_STORE) {
-		/* perform a store */
-		x._32[0] = 0;
-		if (GRk != 0) {
-			if (op & _MA_HALF) {
-				x._16 = greg[GRk];
-			}
-			else {
-				x._32[0] = greg[GRk];
-			}
-		}
-		if (op & _MA_DWORD)
-			x._32[1] = greg[GRk + 1];
-
-		kdebug("MISALIGN: Store GR%d { %08x:%08x } -> %08lx (%dB)\n",
-		       GRk, x._32[1], x._32[0], addr, op & _MA_SZ_MASK);
-
-		if (__memcpy_user((void *) addr, &x, op & _MA_SZ_MASK) != 0)
-			return -EFAULT;
-	}
-	else {
-		/* perform a load */
-		if (__memcpy_user(&x, (void *) addr, op & _MA_SZ_MASK) != 0)
-			return -EFAULT;
-
-		if (op & _MA_HALF) {
-			if (op & _MA_SIGNED)
-				asm ("slli %0,#16,%0 ! srai %0,#16,%0"
-				     : "=r"(x._32[0]) : "0"(x._16));
-			else
-				asm ("sethi #0,%0"
-				     : "=r"(x._32[0]) : "0"(x._16));
-		}
-
-		kdebug("MISALIGN: Load %08lx (%dB) -> GR%d, { %08x:%08x }\n",
-		       addr, op & _MA_SZ_MASK, GRk, x._32[1], x._32[0]);
-
-		if (GRk != 0)
-			greg[GRk] = x._32[0];
-		if (op & _MA_DWORD)
-			greg[GRk + 1] = x._32[1];
-	}
-
-	/* update the base pointer if required */
-	if (op & _MA_UPDATE)
-		greg[GRi] = addr;
-
-	/* well... we've done that insn */
-	__frame->pc = __frame->pc + 4;
-
-	return 0;
-} /* end handle_misalignment() */
diff -puN include/asm-alpha/unaligned.h~kernel-move-arches-to-use-common-unaligned-access include/asm-alpha/unaligned.h
--- a/include/asm-alpha/unaligned.h~kernel-move-arches-to-use-common-unaligned-access
+++ a/include/asm-alpha/unaligned.h
@@ -1,6 +1,11 @@
-#ifndef __ALPHA_UNALIGNED_H
-#define __ALPHA_UNALIGNED_H
+#ifndef _ASM_ALPHA_UNALIGNED_H
+#define _ASM_ALPHA_UNALIGNED_H
 
-#include <asm-generic/unaligned.h>
+#include <linux/unaligned/le_struct.h>
+#include <linux/unaligned/be_byteshift.h>
+#include <linux/unaligned/generic.h>
 
-#endif
+#define get_unaligned __get_unaligned_le
+#define put_unaligned __put_unaligned_le
+
+#endif /* _ASM_ALPHA_UNALIGNED_H */
diff -puN include/asm-arm/unaligned.h~kernel-move-arches-to-use-common-unaligned-access include/asm-arm/unaligned.h
--- a/include/asm-arm/unaligned.h~kernel-move-arches-to-use-common-unaligned-access
+++ a/include/asm-arm/unaligned.h
@@ -1,171 +1,9 @@
-#ifndef __ASM_ARM_UNALIGNED_H
-#define __ASM_ARM_UNALIGNED_H
+#ifndef _ASM_ARM_UNALIGNED_H
+#define _ASM_ARM_UNALIGNED_H
 
-#include <asm/types.h>
-
-extern int __bug_unaligned_x(const void *ptr);
-
-/*
- * What is the most efficient way of loading/storing an unaligned value?
- *
- * That is the subject of this file.  Efficiency here is defined as
- * minimum code size with minimum register usage for the common cases.
- * It is currently not believed that long longs are common, so we
- * trade efficiency for the chars, shorts and longs against the long
- * longs.
- *
- * Current stats with gcc 2.7.2.2 for these functions:
- *
- *	ptrsize	get:	code	regs	put:	code	regs
- *	1		1	1		1	2
- *	2		3	2		3	2
- *	4		7	3		7	3
- *	8		20	6		16	6
- *
- * gcc 2.95.1 seems to code differently:
- *
- *	ptrsize	get:	code	regs	put:	code	regs
- *	1		1	1		1	2
- *	2		3	2		3	2
- *	4		7	4		7	4
- *	8		19	8		15	6
- *
- * which may or may not be more efficient (depending upon whether
- * you can afford the extra registers).  Hopefully the gcc 2.95
- * is inteligent enough to decide if it is better to use the
- * extra register, but evidence so far seems to suggest otherwise.
- *
- * Unfortunately, gcc is not able to optimise the high word
- * out of long long >> 32, or the low word from long long << 32
- */
-
-#define __get_unaligned_2_le(__p)					\
-	(unsigned int)(__p[0] | __p[1] << 8)
-
-#define __get_unaligned_2_be(__p)					\
-	(unsigned int)(__p[0] << 8 | __p[1])
-
-#define __get_unaligned_4_le(__p)					\
-	(unsigned int)(__p[0] | __p[1] << 8 | __p[2] << 16 | __p[3] << 24)
-
-#define __get_unaligned_4_be(__p)					\
-	(unsigned int)(__p[0] << 24 | __p[1] << 16 | __p[2] << 8 | __p[3])
-
-#define __get_unaligned_8_le(__p)					\
-	((unsigned long long)__get_unaligned_4_le((__p+4)) << 32 |	\
-		__get_unaligned_4_le(__p))
-
-#define __get_unaligned_8_be(__p)					\
-	((unsigned long long)__get_unaligned_4_be(__p) << 32 |		\
-		__get_unaligned_4_be((__p+4)))
-
-#define __get_unaligned_le(ptr)						\
-	((__force typeof(*(ptr)))({					\
-		const __u8 *__p = (const __u8 *)(ptr);			\
-		__builtin_choose_expr(sizeof(*(ptr)) == 1, *__p,	\
-		  __builtin_choose_expr(sizeof(*(ptr)) == 2, __get_unaligned_2_le(__p),	\
-		  __builtin_choose_expr(sizeof(*(ptr)) == 4, __get_unaligned_4_le(__p),	\
-		  __builtin_choose_expr(sizeof(*(ptr)) == 8, __get_unaligned_8_le(__p),	\
-		    (void)__bug_unaligned_x(__p)))));			\
-	}))
-
-#define __get_unaligned_be(ptr)						\
-	((__force typeof(*(ptr)))({					\
-		const __u8 *__p = (const __u8 *)(ptr);			\
-		__builtin_choose_expr(sizeof(*(ptr)) == 1, *__p,	\
-		  __builtin_choose_expr(sizeof(*(ptr)) == 2, __get_unaligned_2_be(__p),	\
-		  __builtin_choose_expr(sizeof(*(ptr)) == 4, __get_unaligned_4_be(__p),	\
-		  __builtin_choose_expr(sizeof(*(ptr)) == 8, __get_unaligned_8_be(__p),	\
-		    (void)__bug_unaligned_x(__p)))));			\
-	}))
-
-
-static inline void __put_unaligned_2_le(__u32 __v, register __u8 *__p)
-{
-	*__p++ = __v;
-	*__p++ = __v >> 8;
-}
-
-static inline void __put_unaligned_2_be(__u32 __v, register __u8 *__p)
-{
-	*__p++ = __v >> 8;
-	*__p++ = __v;
-}
-
-static inline void __put_unaligned_4_le(__u32 __v, register __u8 *__p)
-{
-	__put_unaligned_2_le(__v >> 16, __p + 2);
-	__put_unaligned_2_le(__v, __p);
-}
-
-static inline void __put_unaligned_4_be(__u32 __v, register __u8 *__p)
-{
-	__put_unaligned_2_be(__v >> 16, __p);
-	__put_unaligned_2_be(__v, __p + 2);
-}
-
-static inline void __put_unaligned_8_le(const unsigned long long __v, register __u8 *__p)
-{
-	/*
-	 * tradeoff: 8 bytes of stack for all unaligned puts (2
-	 * instructions), or an extra register in the long long
-	 * case - go for the extra register.
-	 */
-	__put_unaligned_4_le(__v >> 32, __p+4);
-	__put_unaligned_4_le(__v, __p);
-}
-
-static inline void __put_unaligned_8_be(const unsigned long long __v, register __u8 *__p)
-{
-	/*
-	 * tradeoff: 8 bytes of stack for all unaligned puts (2
-	 * instructions), or an extra register in the long long
-	 * case - go for the extra register.
-	 */
-	__put_unaligned_4_be(__v >> 32, __p);
-	__put_unaligned_4_be(__v, __p+4);
-}
-
-/*
- * Try to store an unaligned value as efficiently as possible.
- */
-#define __put_unaligned_le(val,ptr)					\
-	({							\
-		(void)sizeof(*(ptr) = (val));			\
-		switch (sizeof(*(ptr))) {			\
-		case 1:						\
-			*(ptr) = (val);				\
-			break;					\
-		case 2: __put_unaligned_2_le((__force u16)(val),(__u8 *)(ptr));	\
-			break;					\
-		case 4:	__put_unaligned_4_le((__force u32)(val),(__u8 *)(ptr));	\
-			break;					\
-		case 8:	__put_unaligned_8_le((__force u64)(val),(__u8 *)(ptr)); \
-			break;					\
-		default: __bug_unaligned_x(ptr);		\
-			break;					\
-		}						\
-		(void) 0;					\
-	})
-
-#define __put_unaligned_be(val,ptr)					\
-	({							\
-		(void)sizeof(*(ptr) = (val));			\
-		switch (sizeof(*(ptr))) {			\
-		case 1:						\
-			*(ptr) = (val);				\
-			break;					\
-		case 2: __put_unaligned_2_be((__force u16)(val),(__u8 *)(ptr));	\
-			break;					\
-		case 4:	__put_unaligned_4_be((__force u32)(val),(__u8 *)(ptr));	\
-			break;					\
-		case 8:	__put_unaligned_8_be((__force u64)(val),(__u8 *)(ptr)); \
-			break;					\
-		default: __bug_unaligned_x(ptr);		\
-			break;					\
-		}						\
-		(void) 0;					\
-	})
+#include <linux/unaligned/le_byteshift.h>
+#include <linux/unaligned/be_byteshift.h>
+#include <linux/unaligned/generic.h>
 
 /*
  * Select endianness
@@ -178,4 +16,4 @@ static inline void __put_unaligned_8_be(
 #define put_unaligned	__put_unaligned_be
 #endif
 
-#endif
+#endif /* _ASM_ARM_UNALIGNED_H */
diff -puN include/asm-avr32/unaligned.h~kernel-move-arches-to-use-common-unaligned-access include/asm-avr32/unaligned.h
--- a/include/asm-avr32/unaligned.h~kernel-move-arches-to-use-common-unaligned-access
+++ a/include/asm-avr32/unaligned.h
@@ -1,5 +1,5 @@
-#ifndef __ASM_AVR32_UNALIGNED_H
-#define __ASM_AVR32_UNALIGNED_H
+#ifndef _ASM_AVR32_UNALIGNED_H
+#define _ASM_AVR32_UNALIGNED_H
 
 /*
  * AVR32 can handle some unaligned accesses, depending on the
@@ -11,6 +11,11 @@
  * optimize word loads in general.
  */
 
-#include <asm-generic/unaligned.h>
+#include <linux/unaligned/be_struct.h>
+#include <linux/unaligned/le_byteshift.h>
+#include <linux/unaligned/generic.h>
 
-#endif /* __ASM_AVR32_UNALIGNED_H */
+#define get_unaligned	__get_unaligned_be
+#define put_unaligned	__put_unaligned_be
+
+#endif /* _ASM_AVR32_UNALIGNED_H */
diff -puN include/asm-blackfin/unaligned.h~kernel-move-arches-to-use-common-unaligned-access include/asm-blackfin/unaligned.h
--- a/include/asm-blackfin/unaligned.h~kernel-move-arches-to-use-common-unaligned-access
+++ a/include/asm-blackfin/unaligned.h
@@ -1,6 +1,11 @@
-#ifndef __BFIN_UNALIGNED_H
-#define __BFIN_UNALIGNED_H
+#ifndef _ASM_BLACKFIN_UNALIGNED_H
+#define _ASM_BLACKFIN_UNALIGNED_H
 
-#include <asm-generic/unaligned.h>
+#include <linux/unaligned/le_struct.h>
+#include <linux/unaligned/be_byteshift.h>
+#include <linux/unaligned/generic.h>
 
-#endif				/* __BFIN_UNALIGNED_H */
+#define get_unaligned	__get_unaligned_le
+#define put_unaligned	__put_unaligned_le
+
+#endif /* _ASM_BLACKFIN_UNALIGNED_H */
diff -puN include/asm-cris/unaligned.h~kernel-move-arches-to-use-common-unaligned-access include/asm-cris/unaligned.h
--- a/include/asm-cris/unaligned.h~kernel-move-arches-to-use-common-unaligned-access
+++ a/include/asm-cris/unaligned.h
@@ -1,16 +1,13 @@
-#ifndef __CRIS_UNALIGNED_H
-#define __CRIS_UNALIGNED_H
+#ifndef _ASM_CRIS_UNALIGNED_H
+#define _ASM_CRIS_UNALIGNED_H
 
 /*
  * CRIS can do unaligned accesses itself. 
- *
- * The strange macros are there to make sure these can't
- * be misused in a way that makes them not work on other
- * architectures where unaligned accesses aren't as simple.
  */
+#include <linux/unaligned/access_ok.h>
+#include <linux/unaligned/generic.h>
 
-#define get_unaligned(ptr) (*(ptr))
+#define get_unaligned	__get_unaligned_le
+#define put_unaligned	__put_unaligned_le
 
-#define put_unaligned(val, ptr) ((void)( *(ptr) = (val) ))
-
-#endif
+#endif /* _ASM_CRIS_UNALIGNED_H */
diff -puN include/asm-frv/unaligned.h~kernel-move-arches-to-use-common-unaligned-access include/asm-frv/unaligned.h
--- a/include/asm-frv/unaligned.h~kernel-move-arches-to-use-common-unaligned-access
+++ a/include/asm-frv/unaligned.h
@@ -9,194 +9,14 @@
  * 2 of the License, or (at your option) any later version.
  */
 
-#ifndef _ASM_UNALIGNED_H
-#define _ASM_UNALIGNED_H
+#ifndef _ASM_FRV_UNALIGNED_H
+#define _ASM_FRV_UNALIGNED_H
 
+#include <linux/unaligned/le_byteshift.h>
+#include <linux/unaligned/be_byteshift.h>
+#include <linux/unaligned/generic.h>
 
-/*
- * Unaligned accesses on uClinux can't be performed in a fault handler - the
- * CPU detects them as imprecise exceptions making this impossible.
- *
- * With the FR451, however, they are precise, and so we used to fix them up in
- * the memory access fault handler.  However, instruction bundling make this
- * impractical.  So, now we fall back to using memcpy.
- */
-#ifdef CONFIG_MMU
-
-/*
- * The asm statement in the macros below is a way to get GCC to copy a
- * value from one variable to another without having any clue it's
- * actually doing so, so that it won't have any idea that the values
- * in the two variables are related.
- */
-
-#define get_unaligned(ptr) ({				\
-	typeof((*(ptr))) __x;				\
-	void *__ptrcopy;				\
-	asm("" : "=r" (__ptrcopy) : "0" (ptr));		\
-	memcpy(&__x, __ptrcopy, sizeof(*(ptr)));	\
-	__x;						\
-})
-
-#define put_unaligned(val, ptr) ({			\
-	typeof((*(ptr))) __x = (val);			\
-	void *__ptrcopy;				\
-	asm("" : "=r" (__ptrcopy) : "0" (ptr));		\
-	memcpy(__ptrcopy, &__x, sizeof(*(ptr)));	\
-})
-
-extern int handle_misalignment(unsigned long esr0, unsigned long ear0, unsigned long epcr0);
-
-#else
-
-#define get_unaligned(ptr)							\
-({										\
-	typeof(*(ptr)) x;							\
-	const char *__p = (const char *) (ptr);					\
-										\
-	switch (sizeof(x)) {							\
-	case 1:									\
-		x = *(ptr);							\
-		break;								\
-	case 2:									\
-	{									\
-		uint8_t a;							\
-		asm("	ldub%I2		%M2,%0		\n"			\
-		    "	ldub%I3.p	%M3,%1		\n"			\
-		    "	slli		%0,#8,%0	\n"			\
-		    "	or		%0,%1,%0	\n"			\
-		    : "=&r"(x), "=&r"(a)					\
-		    : "m"(__p[0]),  "m"(__p[1])					\
-		    );								\
-		break;								\
-	}									\
-										\
-	case 4:									\
-	{									\
-		uint8_t a;							\
-		asm("	ldub%I2		%M2,%0		\n"			\
-		    "	ldub%I3.p	%M3,%1		\n"			\
-		    "	slli		%0,#8,%0	\n"			\
-		    "	or		%0,%1,%0	\n"			\
-		    "	ldub%I4.p	%M4,%1		\n"			\
-		    "	slli		%0,#8,%0	\n"			\
-		    "	or		%0,%1,%0	\n"			\
-		    "	ldub%I5.p	%M5,%1		\n"			\
-		    "	slli		%0,#8,%0	\n"			\
-		    "	or		%0,%1,%0	\n"			\
-		    : "=&r"(x), "=&r"(a)					\
-		    : "m"(__p[0]),  "m"(__p[1]), "m"(__p[2]), "m"(__p[3])	\
-		    );								\
-		break;								\
-	}									\
-										\
-	case 8:									\
-	{									\
-		union { uint64_t x; u32 y[2]; } z;				\
-		uint8_t a;							\
-		asm("	ldub%I3		%M3,%0		\n"			\
-		    "	ldub%I4.p	%M4,%2		\n"			\
-		    "	slli		%0,#8,%0	\n"			\
-		    "	or		%0,%2,%0	\n"			\
-		    "	ldub%I5.p	%M5,%2		\n"			\
-		    "	slli		%0,#8,%0	\n"			\
-		    "	or		%0,%2,%0	\n"			\
-		    "	ldub%I6.p	%M6,%2		\n"			\
-		    "	slli		%0,#8,%0	\n"			\
-		    "	or		%0,%2,%0	\n"			\
-		    "	ldub%I7		%M7,%1		\n"			\
-		    "	ldub%I8.p	%M8,%2		\n"			\
-		    "	slli		%1,#8,%1	\n"			\
-		    "	or		%1,%2,%1	\n"			\
-		    "	ldub%I9.p	%M9,%2		\n"			\
-		    "	slli		%1,#8,%1	\n"			\
-		    "	or		%1,%2,%1	\n"			\
-		    "	ldub%I10.p	%M10,%2		\n"			\
-		    "	slli		%1,#8,%1	\n"			\
-		    "	or		%1,%2,%1	\n"			\
-		    : "=&r"(z.y[0]), "=&r"(z.y[1]), "=&r"(a)			\
-		    : "m"(__p[0]), "m"(__p[1]), "m"(__p[2]), "m"(__p[3]),	\
-		      "m"(__p[4]), "m"(__p[5]), "m"(__p[6]), "m"(__p[7])	\
-		    );								\
-		x = z.x;							\
-		break;								\
-	}									\
-										\
-	default:								\
-		x = 0;								\
-		BUG();								\
-		break;								\
-	}									\
-										\
-	x;									\
-})
-
-#define put_unaligned(val, ptr)								\
-do {											\
-	char *__p = (char *) (ptr);							\
-	int x;										\
-											\
-	switch (sizeof(*ptr)) {								\
-	case 2:										\
-	{										\
-		asm("	stb%I1.p	%0,%M1		\n"				\
-		    "	srli		%0,#8,%0	\n"				\
-		    "	stb%I2		%0,%M2		\n"				\
-		    : "=r"(x), "=m"(__p[1]),  "=m"(__p[0])				\
-		    : "0"(val)								\
-		    );									\
-		break;									\
-	}										\
-											\
-	case 4:										\
-	{										\
-		asm("	stb%I1.p	%0,%M1		\n"				\
-		    "	srli		%0,#8,%0	\n"				\
-		    "	stb%I2.p	%0,%M2		\n"				\
-		    "	srli		%0,#8,%0	\n"				\
-		    "	stb%I3.p	%0,%M3		\n"				\
-		    "	srli		%0,#8,%0	\n"				\
-		    "	stb%I4		%0,%M4		\n"				\
-		    : "=r"(x), "=m"(__p[3]),  "=m"(__p[2]), "=m"(__p[1]), "=m"(__p[0])	\
-		    : "0"(val)								\
-		    );									\
-		break;									\
-	}										\
-											\
-	case 8:										\
-	{										\
-		uint32_t __high, __low;							\
-		__high = (uint64_t)val >> 32;						\
-		__low = val & 0xffffffff;						\
-		asm("	stb%I2.p	%0,%M2		\n"				\
-		    "	srli		%0,#8,%0	\n"				\
-		    "	stb%I3.p	%0,%M3		\n"				\
-		    "	srli		%0,#8,%0	\n"				\
-		    "	stb%I4.p	%0,%M4		\n"				\
-		    "	srli		%0,#8,%0	\n"				\
-		    "	stb%I5.p	%0,%M5		\n"				\
-		    "	srli		%0,#8,%0	\n"				\
-		    "	stb%I6.p	%1,%M6		\n"				\
-		    "	srli		%1,#8,%1	\n"				\
-		    "	stb%I7.p	%1,%M7		\n"				\
-		    "	srli		%1,#8,%1	\n"				\
-		    "	stb%I8.p	%1,%M8		\n"				\
-		    "	srli		%1,#8,%1	\n"				\
-		    "	stb%I9		%1,%M9		\n"				\
-		    : "=&r"(__low), "=&r"(__high), "=m"(__p[7]), "=m"(__p[6]), 		\
-		      "=m"(__p[5]), "=m"(__p[4]), "=m"(__p[3]), "=m"(__p[2]), 		\
-		      "=m"(__p[1]), "=m"(__p[0])					\
-		    : "0"(__low), "1"(__high)						\
-		    );									\
-		break;									\
-	}										\
-											\
-        default:									\
-		*(ptr) = (val);								\
-		break;									\
-	}										\
-} while(0)
-
-#endif
+#define get_unaligned	__get_unaligned_be
+#define put_unaligned	__put_unaligned_be
 
-#endif
+#endif /* _ASM_FRV_UNALIGNED_H */
diff -puN include/asm-generic/unaligned.h~kernel-move-arches-to-use-common-unaligned-access /dev/null
--- a/include/asm-generic/unaligned.h
+++ /dev/null
@@ -1,124 +0,0 @@
-#ifndef _ASM_GENERIC_UNALIGNED_H_
-#define _ASM_GENERIC_UNALIGNED_H_
-
-/*
- * For the benefit of those who are trying to port Linux to another
- * architecture, here are some C-language equivalents. 
- *
- * This is based almost entirely upon Richard Henderson's
- * asm-alpha/unaligned.h implementation.  Some comments were
- * taken from David Mosberger's asm-ia64/unaligned.h header.
- */
-
-#include <linux/types.h>
-
-/* 
- * The main single-value unaligned transfer routines.
- */
-#define get_unaligned(ptr) \
-	__get_unaligned((ptr), sizeof(*(ptr)))
-#define put_unaligned(x,ptr) \
-	((void)sizeof(*(ptr)=(x)),\
-	__put_unaligned((__force __u64)(x), (ptr), sizeof(*(ptr))))
-
-/*
- * This function doesn't actually exist.  The idea is that when
- * someone uses the macros below with an unsupported size (datatype),
- * the linker will alert us to the problem via an unresolved reference
- * error.
- */
-extern void bad_unaligned_access_length(void) __attribute__((noreturn));
-
-struct __una_u64 { __u64 x __attribute__((packed)); };
-struct __una_u32 { __u32 x __attribute__((packed)); };
-struct __una_u16 { __u16 x __attribute__((packed)); };
-
-/*
- * Elemental unaligned loads 
- */
-
-static inline __u64 __uldq(const __u64 *addr)
-{
-	const struct __una_u64 *ptr = (const struct __una_u64 *) addr;
-	return ptr->x;
-}
-
-static inline __u32 __uldl(const __u32 *addr)
-{
-	const struct __una_u32 *ptr = (const struct __una_u32 *) addr;
-	return ptr->x;
-}
-
-static inline __u16 __uldw(const __u16 *addr)
-{
-	const struct __una_u16 *ptr = (const struct __una_u16 *) addr;
-	return ptr->x;
-}
-
-/*
- * Elemental unaligned stores 
- */
-
-static inline void __ustq(__u64 val, __u64 *addr)
-{
-	struct __una_u64 *ptr = (struct __una_u64 *) addr;
-	ptr->x = val;
-}
-
-static inline void __ustl(__u32 val, __u32 *addr)
-{
-	struct __una_u32 *ptr = (struct __una_u32 *) addr;
-	ptr->x = val;
-}
-
-static inline void __ustw(__u16 val, __u16 *addr)
-{
-	struct __una_u16 *ptr = (struct __una_u16 *) addr;
-	ptr->x = val;
-}
-
-#define __get_unaligned(ptr, size) ({		\
-	const void *__gu_p = ptr;		\
-	__u64 __val;				\
-	switch (size) {				\
-	case 1:					\
-		__val = *(const __u8 *)__gu_p;	\
-		break;				\
-	case 2:					\
-		__val = __uldw(__gu_p);		\
-		break;				\
-	case 4:					\
-		__val = __uldl(__gu_p);		\
-		break;				\
-	case 8:					\
-		__val = __uldq(__gu_p);		\
-		break;				\
-	default:				\
-		bad_unaligned_access_length();	\
-	};					\
-	(__force __typeof__(*(ptr)))__val;	\
-})
-
-#define __put_unaligned(val, ptr, size)		\
-({						\
-	void *__gu_p = ptr;			\
-	switch (size) {				\
-	case 1:					\
-		*(__u8 *)__gu_p = (__force __u8)val;		\
-	        break;				\
-	case 2:					\
-		__ustw((__force __u16)val, __gu_p);		\
-		break;				\
-	case 4:					\
-		__ustl((__force __u32)val, __gu_p);		\
-		break;				\
-	case 8:					\
-		__ustq(val, __gu_p);		\
-		break;				\
-	default:				\
-	    	bad_unaligned_access_length();	\
-	};					\
-	(void)0;				\
-})
-
-#endif /* _ASM_GENERIC_UNALIGNED_H */
diff -puN include/asm-h8300/unaligned.h~kernel-move-arches-to-use-common-unaligned-access include/asm-h8300/unaligned.h
--- a/include/asm-h8300/unaligned.h~kernel-move-arches-to-use-common-unaligned-access
+++ a/include/asm-h8300/unaligned.h
@@ -1,15 +1,11 @@
-#ifndef __H8300_UNALIGNED_H
-#define __H8300_UNALIGNED_H
+#ifndef _ASM_H8300_UNALIGNED_H
+#define _ASM_H8300_UNALIGNED_H
 
+#include <linux/unaligned/be_memmove.h>
+#include <linux/unaligned/le_byteshift.h>
+#include <linux/unaligned/generic.h>
 
-/* Use memmove here, so gcc does not insert a __builtin_memcpy. */
+#define get_unaligned	__get_unaligned_be
+#define put_unaligned	__put_unaligned_be
 
-#define get_unaligned(ptr) \
-  ({ __typeof__(*(ptr)) __tmp; memmove(&__tmp, (ptr), sizeof(*(ptr))); __tmp; })
-
-#define put_unaligned(val, ptr)				\
-  ({ __typeof__(*(ptr)) __tmp = (val);			\
-     memmove((ptr), &__tmp, sizeof(*(ptr)));		\
-     (void)0; })
-
-#endif
+#endif /* _ASM_H8300_UNALIGNED_H */
diff -puN include/asm-ia64/unaligned.h~kernel-move-arches-to-use-common-unaligned-access include/asm-ia64/unaligned.h
--- a/include/asm-ia64/unaligned.h~kernel-move-arches-to-use-common-unaligned-access
+++ a/include/asm-ia64/unaligned.h
@@ -1,6 +1,11 @@
 #ifndef _ASM_IA64_UNALIGNED_H
 #define _ASM_IA64_UNALIGNED_H
 
-#include <asm-generic/unaligned.h>
+#include <linux/unaligned/le_struct.h>
+#include <linux/unaligned/be_byteshift.h>
+#include <linux/unaligned/generic.h>
+
+#define get_unaligned	__get_unaligned_le
+#define put_unaligned	__put_unaligned_le
 
 #endif /* _ASM_IA64_UNALIGNED_H */
diff -puN include/asm-m32r/unaligned.h~kernel-move-arches-to-use-common-unaligned-access include/asm-m32r/unaligned.h
--- a/include/asm-m32r/unaligned.h~kernel-move-arches-to-use-common-unaligned-access
+++ a/include/asm-m32r/unaligned.h
@@ -1,19 +1,18 @@
 #ifndef _ASM_M32R_UNALIGNED_H
 #define _ASM_M32R_UNALIGNED_H
 
-/*
- * For the benefit of those who are trying to port Linux to another
- * architecture, here are some C-language equivalents.
- */
-
-#include <asm/string.h>
-
-#define get_unaligned(ptr) \
-  ({ __typeof__(*(ptr)) __tmp; memmove(&__tmp, (ptr), sizeof(*(ptr))); __tmp; })
-
-#define put_unaligned(val, ptr)				\
-  ({ __typeof__(*(ptr)) __tmp = (val);			\
-     memmove((ptr), &__tmp, sizeof(*(ptr)));		\
-     (void)0; })
+#if defined(__LITTLE_ENDIAN__)
+# include <linux/unaligned/le_memmove.h>
+# include <linux/unaligned/be_byteshift.h>
+# include <linux/unaligned/generic.h>
+# define get_unaligned	__get_unaligned_le
+# define put_unaligned	__put_unaligned_le
+#else
+# include <linux/unaligned/be_memmove.h>
+# include <linux/unaligned/le_byteshift.h>
+# include <linux/unaligned/generic.h>
+# define get_unaligned	__get_unaligned_be
+# define put_unaligned	__put_unaligned_be
+#endif
 
 #endif /* _ASM_M32R_UNALIGNED_H */
diff -puN include/asm-m68k/unaligned.h~kernel-move-arches-to-use-common-unaligned-access include/asm-m68k/unaligned.h
--- a/include/asm-m68k/unaligned.h~kernel-move-arches-to-use-common-unaligned-access
+++ a/include/asm-m68k/unaligned.h
@@ -1,16 +1,13 @@
-#ifndef __M68K_UNALIGNED_H
-#define __M68K_UNALIGNED_H
+#ifndef _ASM_M68K_UNALIGNED_H
+#define _ASM_M68K_UNALIGNED_H
 
 /*
  * The m68k can do unaligned accesses itself.
- *
- * The strange macros are there to make sure these can't
- * be misused in a way that makes them not work on other
- * architectures where unaligned accesses aren't as simple.
  */
+#include <linux/unaligned/access_ok.h>
+#include <linux/unaligned/generic.h>
 
-#define get_unaligned(ptr) (*(ptr))
+#define get_unaligned	__get_unaligned_be
+#define put_unaligned	__put_unaligned_be
 
-#define put_unaligned(val, ptr) ((void)( *(ptr) = (val) ))
-
-#endif
+#endif /* _ASM_M68K_UNALIGNED_H */
diff -puN include/asm-m68knommu/unaligned.h~kernel-move-arches-to-use-common-unaligned-access include/asm-m68knommu/unaligned.h
--- a/include/asm-m68knommu/unaligned.h~kernel-move-arches-to-use-common-unaligned-access
+++ a/include/asm-m68knommu/unaligned.h
@@ -1,23 +1,25 @@
-#ifndef __M68K_UNALIGNED_H
-#define __M68K_UNALIGNED_H
+#ifndef _ASM_M68KNOMMU_UNALIGNED_H
+#define _ASM_M68KNOMMU_UNALIGNED_H
 
 
 #ifdef CONFIG_COLDFIRE
+#include <linux/unaligned/be_struct.h>
+#include <linux/unaligned/le_byteshift.h>
+#include <linux/unaligned/generic.h>
 
-#include <asm-generic/unaligned.h>
+#define get_unaligned	__get_unaligned_be
+#define put_unaligned	__put_unaligned_be
 
 #else
 /*
  * The m68k can do unaligned accesses itself. 
- *
- * The strange macros are there to make sure these can't
- * be misused in a way that makes them not work on other
- * architectures where unaligned accesses aren't as simple.
  */
+#include <linux/unaligned/access_ok.h>
+#include <linux/unaligned/generic.h>
 
-#define get_unaligned(ptr) (*(ptr))
-#define put_unaligned(val, ptr) ((void)( *(ptr) = (val) ))
+#define get_unaligned	__get_unaligned_be
+#define put_unaligned	__put_unaligned_be
 
 #endif
 
-#endif
+#endif /* _ASM_M68KNOMMU_UNALIGNED_H */
diff -puN include/asm-mips/unaligned.h~kernel-move-arches-to-use-common-unaligned-access include/asm-mips/unaligned.h
--- a/include/asm-mips/unaligned.h~kernel-move-arches-to-use-common-unaligned-access
+++ a/include/asm-mips/unaligned.h
@@ -5,25 +5,24 @@
  *
  * Copyright (C) 2007 Ralf Baechle (ralf@linux-mips.org)
  */
-#ifndef __ASM_GENERIC_UNALIGNED_H
-#define __ASM_GENERIC_UNALIGNED_H
+#ifndef _ASM_MIPS_UNALIGNED_H
+#define _ASM_MIPS_UNALIGNED_H
 
 #include <linux/compiler.h>
+#if defined(__MIPSEB__)
+# include <linux/unaligned/be_struct.h>
+# include <linux/unaligned/le_byteshift.h>
+# include <linux/unaligned/generic.h>
+# define get_unaligned	__get_unaligned_be
+# define put_unaligned	__put_unaligned_be
+#elif defined(__MIPSEL__)
+# include <linux/unaligned/le_struct.h>
+# include <linux/unaligned/be_byteshift.h>
+# include <linux/unaligned/generic.h>
+# define get_unaligned	__get_unaligned_le
+# define put_unaligned	__put_unaligned_le
+#else
+#  error "MIPS, but neither __MIPSEB__, nor __MIPSEL__???"
+#endif
 
-#define get_unaligned(ptr)					\
-({								\
-	struct __packed {					\
-		typeof(*(ptr)) __v;				\
-	} *__p = (void *) (ptr);				\
-	__p->__v;						\
-})
-
-#define put_unaligned(val, ptr)					\
-do {								\
-	struct __packed {					\
-		typeof(*(ptr)) __v;				\
-	} *__p = (void *) (ptr);				\
-	__p->__v = (val);					\
-} while(0)
-
-#endif /* __ASM_GENERIC_UNALIGNED_H */
+#endif /* _ASM_MIPS_UNALIGNED_H */
diff -puN include/asm-mn10300/unaligned.h~kernel-move-arches-to-use-common-unaligned-access include/asm-mn10300/unaligned.h
--- a/include/asm-mn10300/unaligned.h~kernel-move-arches-to-use-common-unaligned-access
+++ a/include/asm-mn10300/unaligned.h
@@ -8,129 +8,13 @@
  * as published by the Free Software Foundation; either version
  * 2 of the Licence, or (at your option) any later version.
  */
-#ifndef _ASM_UNALIGNED_H
-#define _ASM_UNALIGNED_H
+#ifndef _ASM_MN10300_UNALIGNED_H
+#define _ASM_MN10300_UNALIGNED_H
 
-#include <asm/types.h>
+#include <linux/unaligned/access_ok.h>
+#include <linux/unaligned/generic.h>
 
-#if 0
-extern int __bug_unaligned_x(void *ptr);
+#define get_unaligned	__get_unaligned_le
+#define put_unaligned	__put_unaligned_le
 
-/*
- * What is the most efficient way of loading/storing an unaligned value?
- *
- * That is the subject of this file.  Efficiency here is defined as
- * minimum code size with minimum register usage for the common cases.
- * It is currently not believed that long longs are common, so we
- * trade efficiency for the chars, shorts and longs against the long
- * longs.
- *
- * Current stats with gcc 2.7.2.2 for these functions:
- *
- *	ptrsize	get:	code	regs	put:	code	regs
- *	1		1	1		1	2
- *	2		3	2		3	2
- *	4		7	3		7	3
- *	8		20	6		16	6
- *
- * gcc 2.95.1 seems to code differently:
- *
- *	ptrsize	get:	code	regs	put:	code	regs
- *	1		1	1		1	2
- *	2		3	2		3	2
- *	4		7	4		7	4
- *	8		19	8		15	6
- *
- * which may or may not be more efficient (depending upon whether
- * you can afford the extra registers).  Hopefully the gcc 2.95
- * is inteligent enough to decide if it is better to use the
- * extra register, but evidence so far seems to suggest otherwise.
- *
- * Unfortunately, gcc is not able to optimise the high word
- * out of long long >> 32, or the low word from long long << 32
- */
-
-#define __get_unaligned_2(__p)					\
-	(__p[0] | __p[1] << 8)
-
-#define __get_unaligned_4(__p)					\
-	(__p[0] | __p[1] << 8 | __p[2] << 16 | __p[3] << 24)
-
-#define get_unaligned(ptr)					\
-({								\
-	unsigned int __v1, __v2;				\
-	__typeof__(*(ptr)) __v;					\
-	__u8 *__p = (__u8 *)(ptr);				\
-								\
-	switch (sizeof(*(ptr))) {				\
-	case 1:	__v = *(ptr);			break;		\
-	case 2: __v = __get_unaligned_2(__p);	break;		\
-	case 4: __v = __get_unaligned_4(__p);	break;		\
-	case 8:							\
-		__v2 = __get_unaligned_4((__p+4));		\
-		__v1 = __get_unaligned_4(__p);			\
-		__v = ((unsigned long long)__v2 << 32 | __v1);	\
-		break;						\
-	default: __v = __bug_unaligned_x(__p);	break;		\
-	}							\
-	__v;							\
-})
-
-
-static inline void __put_unaligned_2(__u32 __v, register __u8 *__p)
-{
-	*__p++ = __v;
-	*__p++ = __v >> 8;
-}
-
-static inline void __put_unaligned_4(__u32 __v, register __u8 *__p)
-{
-	__put_unaligned_2(__v >> 16, __p + 2);
-	__put_unaligned_2(__v, __p);
-}
-
-static inline void __put_unaligned_8(const unsigned long long __v, __u8 *__p)
-{
-	/*
-	 * tradeoff: 8 bytes of stack for all unaligned puts (2
-	 * instructions), or an extra register in the long long
-	 * case - go for the extra register.
-	 */
-	__put_unaligned_4(__v >> 32, __p + 4);
-	__put_unaligned_4(__v, __p);
-}
-
-/*
- * Try to store an unaligned value as efficiently as possible.
- */
-#define put_unaligned(val, ptr)						\
-	({								\
-		switch (sizeof(*(ptr))) {				\
-		case 1:							\
-			*(ptr) = (val);					\
-			break;						\
-		case 2:							\
-			__put_unaligned_2((val), (__u8 *)(ptr));	\
-			break;						\
-		case 4:							\
-			__put_unaligned_4((val), (__u8 *)(ptr));	\
-			break;						\
-		case 8:							\
-			__put_unaligned_8((val), (__u8 *)(ptr));	\
-			break;						\
-		default:						\
-			__bug_unaligned_x(ptr);				\
-			break;						\
-		}							\
-		(void) 0;						\
-	})
-
-
-#else
-
-#define get_unaligned(ptr) (*(ptr))
-#define put_unaligned(val, ptr) ({ *(ptr) = (val); (void) 0; })
-
-#endif
-
-#endif
+#endif /* _ASM_MN10300_UNALIGNED_H */
diff -puN include/asm-parisc/unaligned.h~kernel-move-arches-to-use-common-unaligned-access include/asm-parisc/unaligned.h
--- a/include/asm-parisc/unaligned.h~kernel-move-arches-to-use-common-unaligned-access
+++ a/include/asm-parisc/unaligned.h
@@ -1,7 +1,11 @@
-#ifndef _ASM_PARISC_UNALIGNED_H_
-#define _ASM_PARISC_UNALIGNED_H_
+#ifndef _ASM_PARISC_UNALIGNED_H
+#define _ASM_PARISC_UNALIGNED_H
 
-#include <asm-generic/unaligned.h>
+#include <linux/unaligned/be_struct.h>
+#include <linux/unaligned/le_byteshift.h>
+#include <linux/unaligned/generic.h>
+#define get_unaligned	__get_unaligned_be
+#define put_unaligned	__put_unaligned_be
 
 #ifdef __KERNEL__
 struct pt_regs;
@@ -9,4 +13,4 @@ void handle_unaligned(struct pt_regs *re
 int check_unaligned(struct pt_regs *regs);
 #endif
 
-#endif /* _ASM_PARISC_UNALIGNED_H_ */
+#endif /* _ASM_PARISC_UNALIGNED_H */
diff -puN include/asm-powerpc/unaligned.h~kernel-move-arches-to-use-common-unaligned-access include/asm-powerpc/unaligned.h
--- a/include/asm-powerpc/unaligned.h~kernel-move-arches-to-use-common-unaligned-access
+++ a/include/asm-powerpc/unaligned.h
@@ -5,15 +5,12 @@
 
 /*
  * The PowerPC can do unaligned accesses itself in big endian mode.
- *
- * The strange macros are there to make sure these can't
- * be misused in a way that makes them not work on other
- * architectures where unaligned accesses aren't as simple.
  */
+#include <linux/unaligned/access_ok.h>
+#include <linux/unaligned/generic.h>
 
-#define get_unaligned(ptr) (*(ptr))
-
-#define put_unaligned(val, ptr) ((void)( *(ptr) = (val) ))
+#define get_unaligned	__get_unaligned_be
+#define put_unaligned	__put_unaligned_be
 
 #endif	/* __KERNEL__ */
 #endif	/* _ASM_POWERPC_UNALIGNED_H */
diff -puN include/asm-s390/unaligned.h~kernel-move-arches-to-use-common-unaligned-access include/asm-s390/unaligned.h
--- a/include/asm-s390/unaligned.h~kernel-move-arches-to-use-common-unaligned-access
+++ a/include/asm-s390/unaligned.h
@@ -1,24 +1,13 @@
-/*
- *  include/asm-s390/unaligned.h
- *
- *  S390 version
- *
- *  Derived from "include/asm-i386/unaligned.h"
- */
-
-#ifndef __S390_UNALIGNED_H
-#define __S390_UNALIGNED_H
+#ifndef _ASM_S390_UNALIGNED_H
+#define _ASM_S390_UNALIGNED_H
 
 /*
  * The S390 can do unaligned accesses itself. 
- *
- * The strange macros are there to make sure these can't
- * be misused in a way that makes them not work on other
- * architectures where unaligned accesses aren't as simple.
  */
+#include <linux/unaligned/access_ok.h>
+#include <linux/unaligned/generic.h>
 
-#define get_unaligned(ptr) (*(ptr))
-
-#define put_unaligned(val, ptr) ((void)( *(ptr) = (val) ))
+#define get_unaligned	__get_unaligned_be
+#define put_unaligned	__put_unaligned_be
 
-#endif
+#endif /* _ASM_S390_UNALIGNED_H */
diff -puN include/asm-sh/unaligned.h~kernel-move-arches-to-use-common-unaligned-access include/asm-sh/unaligned.h
--- a/include/asm-sh/unaligned.h~kernel-move-arches-to-use-common-unaligned-access
+++ a/include/asm-sh/unaligned.h
@@ -1,7 +1,19 @@
-#ifndef __ASM_SH_UNALIGNED_H
-#define __ASM_SH_UNALIGNED_H
+#ifndef _ASM_SH_UNALIGNED_H
+#define _ASM_SH_UNALIGNED_H
 
 /* SH can't handle unaligned accesses. */
-#include <asm-generic/unaligned.h>
+#ifdef __LITTLE_ENDIAN__
+# include <linux/unaligned/le_struct.h>
+# include <linux/unaligned/be_byteshift.h>
+# include <linux/unaligned/generic.h>
+# define get_unaligned	__get_unaligned_le
+# define put_unaligned	__put_unaligned_le
+#else
+# include <linux/unaligned/be_struct.h>
+# include <linux/unaligned/le_byteshift.h>
+# include <linux/unaligned/generic.h>
+# define get_unaligned	__get_unaligned_be
+# define put_unaligned	__put_unaligned_be
+#endif
 
-#endif /* __ASM_SH_UNALIGNED_H */
+#endif /* _ASM_SH_UNALIGNED_H */
diff -puN include/asm-sparc/unaligned.h~kernel-move-arches-to-use-common-unaligned-access include/asm-sparc/unaligned.h
--- a/include/asm-sparc/unaligned.h~kernel-move-arches-to-use-common-unaligned-access
+++ a/include/asm-sparc/unaligned.h
@@ -1,6 +1,10 @@
-#ifndef _ASM_SPARC_UNALIGNED_H_
-#define _ASM_SPARC_UNALIGNED_H_
+#ifndef _ASM_SPARC_UNALIGNED_H
+#define _ASM_SPARC_UNALIGNED_H
 
-#include <asm-generic/unaligned.h>
+#include <linux/unaligned/be_struct.h>
+#include <linux/unaligned/le_byteshift.h>
+#include <linux/unaligned/generic.h>
+#define get_unaligned	__get_unaligned_be
+#define put_unaligned	__put_unaligned_be
 
 #endif /* _ASM_SPARC_UNALIGNED_H */
diff -puN include/asm-sparc64/unaligned.h~kernel-move-arches-to-use-common-unaligned-access include/asm-sparc64/unaligned.h
--- a/include/asm-sparc64/unaligned.h~kernel-move-arches-to-use-common-unaligned-access
+++ a/include/asm-sparc64/unaligned.h
@@ -1,6 +1,10 @@
-#ifndef _ASM_SPARC64_UNALIGNED_H_
-#define _ASM_SPARC64_UNALIGNED_H_
+#ifndef _ASM_SPARC64_UNALIGNED_H
+#define _ASM_SPARC64_UNALIGNED_H
 
-#include <asm-generic/unaligned.h>
+#include <linux/unaligned/be_struct.h>
+#include <linux/unaligned/le_byteshift.h>
+#include <linux/unaligned/generic.h>
+#define get_unaligned	__get_unaligned_be
+#define put_unaligned	__put_unaligned_be
 
 #endif /* _ASM_SPARC64_UNALIGNED_H */
diff -puN include/asm-um/unaligned.h~kernel-move-arches-to-use-common-unaligned-access include/asm-um/unaligned.h
--- a/include/asm-um/unaligned.h~kernel-move-arches-to-use-common-unaligned-access
+++ a/include/asm-um/unaligned.h
@@ -1,6 +1,6 @@
-#ifndef __UM_UNALIGNED_H
-#define __UM_UNALIGNED_H
+#ifndef _ASM_UM_UNALIGNED_H
+#define _ASM_UM_UNALIGNED_H
 
 #include "asm/arch/unaligned.h"
 
-#endif
+#endif /* _ASM_UM_UNALIGNED_H */
diff -puN include/asm-v850/unaligned.h~kernel-move-arches-to-use-common-unaligned-access include/asm-v850/unaligned.h
--- a/include/asm-v850/unaligned.h~kernel-move-arches-to-use-common-unaligned-access
+++ a/include/asm-v850/unaligned.h
@@ -1,6 +1,4 @@
 /*
- * include/asm-v850/unaligned.h -- Unaligned memory access
- *
  *  Copyright (C) 2001  NEC Corporation
  *  Copyright (C) 2001  Miles Bader <miles@gnu.org>
  *
@@ -8,123 +6,17 @@
  * Public License.  See the file COPYING in the main directory of this
  * archive for more details.
  *
- * This file is a copy of the arm version, include/asm-arm/unaligned.h
- *
  * Note that some v850 chips support unaligned access, but it seems too
  * annoying to use.
  */
+#ifndef _ASM_V850_UNALIGNED_H
+#define _ASM_V850_UNALIGNED_H
 
-#ifndef __V850_UNALIGNED_H__
-#define __V850_UNALIGNED_H__
-
-#include <asm/types.h>
-
-extern int __bug_unaligned_x(void *ptr);
-
-/*
- * What is the most efficient way of loading/storing an unaligned value?
- *
- * That is the subject of this file.  Efficiency here is defined as
- * minimum code size with minimum register usage for the common cases.
- * It is currently not believed that long longs are common, so we
- * trade efficiency for the chars, shorts and longs against the long
- * longs.
- *
- * Current stats with gcc 2.7.2.2 for these functions:
- *
- *	ptrsize	get:	code	regs	put:	code	regs
- *	1		1	1		1	2
- *	2		3	2		3	2
- *	4		7	3		7	3
- *	8		20	6		16	6
- *
- * gcc 2.95.1 seems to code differently:
- *
- *	ptrsize	get:	code	regs	put:	code	regs
- *	1		1	1		1	2
- *	2		3	2		3	2
- *	4		7	4		7	4
- *	8		19	8		15	6
- *
- * which may or may not be more efficient (depending upon whether
- * you can afford the extra registers).  Hopefully the gcc 2.95
- * is inteligent enough to decide if it is better to use the
- * extra register, but evidence so far seems to suggest otherwise.
- *
- * Unfortunately, gcc is not able to optimise the high word
- * out of long long >> 32, or the low word from long long << 32
- */
-
-#define __get_unaligned_2(__p)					\
-	(__p[0] | __p[1] << 8)
-
-#define __get_unaligned_4(__p)					\
-	(__p[0] | __p[1] << 8 | __p[2] << 16 | __p[3] << 24)
-
-#define get_unaligned(ptr)					\
-	({							\
-		__typeof__(*(ptr)) __v;				\
-		__u8 *__p = (__u8 *)(ptr);			\
-		switch (sizeof(*(ptr))) {			\
-		case 1:	__v = *(ptr);			break;	\
-		case 2: __v = __get_unaligned_2(__p);	break;	\
-		case 4: __v = __get_unaligned_4(__p);	break;	\
-		case 8: {					\
-				unsigned int __v1, __v2;	\
-				__v2 = __get_unaligned_4((__p+4)); \
-				__v1 = __get_unaligned_4(__p);	\
-				__v = ((unsigned long long)__v2 << 32 | __v1);	\
-			}					\
-			break;					\
-		default: __v = __bug_unaligned_x(__p);	break;	\
-		}						\
-		__v;						\
-	})
-
-
-static inline void __put_unaligned_2(__u32 __v, register __u8 *__p)
-{
-	*__p++ = __v;
-	*__p++ = __v >> 8;
-}
-
-static inline void __put_unaligned_4(__u32 __v, register __u8 *__p)
-{
-	__put_unaligned_2(__v >> 16, __p + 2);
-	__put_unaligned_2(__v, __p);
-}
-
-static inline void __put_unaligned_8(const unsigned long long __v, register __u8 *__p)
-{
-	/*
-	 * tradeoff: 8 bytes of stack for all unaligned puts (2
-	 * instructions), or an extra register in the long long
-	 * case - go for the extra register.
-	 */
-	__put_unaligned_4(__v >> 32, __p+4);
-	__put_unaligned_4(__v, __p);
-}
-
-/*
- * Try to store an unaligned value as efficiently as possible.
- */
-#define put_unaligned(val,ptr)					\
-	({							\
-		switch (sizeof(*(ptr))) {			\
-		case 1:						\
-			*(ptr) = (val);				\
-			break;					\
-		case 2: __put_unaligned_2((val),(__u8 *)(ptr));	\
-			break;					\
-		case 4:	__put_unaligned_4((val),(__u8 *)(ptr));	\
-			break;					\
-		case 8:	__put_unaligned_8((val),(__u8 *)(ptr)); \
-			break;					\
-		default: __bug_unaligned_x(ptr);		\
-			break;					\
-		}						\
-		(void) 0;					\
-	})
+#include <linux/unaligned/be_byteshift.h>
+#include <linux/unaligned/le_byteshift.h>
+#include <linux/unaligned/generic.h>
 
+#define get_unaligned	__get_unaligned_le
+#define put_unaligned	__put_unaligned_le
 
-#endif /* __V850_UNALIGNED_H__ */
+#endif /* _ASM_V850_UNALIGNED_H */
diff -puN include/asm-x86/unaligned.h~kernel-move-arches-to-use-common-unaligned-access include/asm-x86/unaligned.h
--- a/include/asm-x86/unaligned.h~kernel-move-arches-to-use-common-unaligned-access
+++ a/include/asm-x86/unaligned.h
@@ -3,35 +3,12 @@
 
 /*
  * The x86 can do unaligned accesses itself.
- *
- * The strange macros are there to make sure these can't
- * be misused in a way that makes them not work on other
- * architectures where unaligned accesses aren't as simple.
  */
 
-/**
- * get_unaligned - get value from possibly mis-aligned location
- * @ptr: pointer to value
- *
- * This macro should be used for accessing values larger in size than
- * single bytes at locations that are expected to be improperly aligned,
- * e.g. retrieving a u16 value from a location not u16-aligned.
- *
- * Note that unaligned accesses can be very expensive on some architectures.
- */
-#define get_unaligned(ptr) (*(ptr))
+#include <linux/unaligned/access_ok.h>
+#include <linux/unaligned/generic.h>
 
-/**
- * put_unaligned - put value to a possibly mis-aligned location
- * @val: value to place
- * @ptr: pointer to location
- *
- * This macro should be used for placing values larger in size than
- * single bytes at locations that are expected to be improperly aligned,
- * e.g. writing a u16 value to a location not u16-aligned.
- *
- * Note that unaligned accesses can be very expensive on some architectures.
- */
-#define put_unaligned(val, ptr) ((void)(*(ptr) = (val)))
+#define get_unaligned __get_unaligned_le
+#define put_unaligned __put_unaligned_le
 
 #endif /* _ASM_X86_UNALIGNED_H */
diff -puN include/asm-xtensa/unaligned.h~kernel-move-arches-to-use-common-unaligned-access include/asm-xtensa/unaligned.h
--- a/include/asm-xtensa/unaligned.h~kernel-move-arches-to-use-common-unaligned-access
+++ a/include/asm-xtensa/unaligned.h
@@ -1,6 +1,4 @@
 /*
- * include/asm-xtensa/unaligned.h
- *
  * Xtensa doesn't handle unaligned accesses efficiently.
  *
  * This file is subject to the terms and conditions of the GNU General Public
@@ -9,20 +7,23 @@
  *
  * Copyright (C) 2001 - 2005 Tensilica Inc.
  */
+#ifndef _ASM_XTENSA_UNALIGNED_H
+#define _ASM_XTENSA_UNALIGNED_H
 
-#ifndef _XTENSA_UNALIGNED_H
-#define _XTENSA_UNALIGNED_H
-
-#include <linux/string.h>
-
-/* Use memmove here, so gcc does not insert a __builtin_memcpy. */
-
-#define get_unaligned(ptr) \
-  ({ __typeof__(*(ptr)) __tmp; memmove(&__tmp, (ptr), sizeof(*(ptr))); __tmp; })
-
-#define put_unaligned(val, ptr)				\
-  ({ __typeof__(*(ptr)) __tmp = (val);			\
-     memmove((ptr), &__tmp, sizeof(*(ptr)));		\
-     (void)0; })
+#ifdef __XTENSA_EL__
+# include <linux/unaligned/le_memmove.h>
+# include <linux/unaligned/be_byteshift.h>
+# include <linux/unaligned/generic.h>
+# define get_unaligned	__get_unaligned_le
+# define put_unaligned	__put_unaligned_le
+#elif defined(__XTENSA_EB__)
+# include <linux/unaligned/be_memmove.h>
+# include <linux/unaligned/le_byteshift.h>
+# include <linux/unaligned/generic.h>
+# define get_unaligned	__get_unaligned_be
+# define put_unaligned	__put_unaligned_be
+#else
+# error processor byte order undefined!
+#endif
 
-#endif	/* _XTENSA_UNALIGNED_H */
+#endif	/* _ASM_XTENSA_UNALIGNED_H */
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
frv-fix-arch-frv-mm-unalignedo-build-error.patch
cifs-remove-global_extern-macro.patch
input-replace-remaining-__function__-occurrences.patch
git-kvm.patch
git-mips.patch
nfs-replace-remaining-__function__-occurrences.patch
parisc-replace-remaining-__function__-occurences.patch
drivers-parisc-replace-remaining-__function__-occurrences.patch
pcmcia-replace-remaining-__function__-occurrences.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
git-watchdog.patch
git-xfs.patch
xtensa-replace-remaining-__function__-occurences.patch
char-fix-sparse-shadowed-variable-warnings-in-espc.patch
char-espc-fix-possible-double-unlock.patch
char-rocketc-fix-sparse-variable-shadowing-and-int-as-null-pointer.patch
cycladesc-fix-sparse-shadowed-variable-warnings.patch
epcac-static-functions-and-integer-as-null-pointer-fixes.patch
epcac-static-functions-and-integer-as-null-pointer-fixes-checkpatch-fixes.patch
add-macros-similar-to-min-max-min_t-max_t.patch
add-macros-similar-to-min-max-min_t-max_t-doc.patch
ide-eliminate-fit-macro.patch
ata-remove-fit-macro.patch
b43-replace-limit_value-macro-with-clamp_val.patch
b43legacy-replace-limit_value-macro-with-clamp_val.patch
fuse-use-clamp-rather-than-nested-min-max.patch
ide-tape-use-clamp_t-rather-than-nested-min_t-max_t.patch
input-ff-memlessc-use-clamp_val-macro.patch
dccp-ccid2c-ccid3c-use-clamp-clamp_t.patch
drivers-replace-remaining-__function__-occurrences.patch
mm-remove-remaining-__function__-occurances.patch
block-remove-remaining-__function__-occurances.patch
kernel-replace-remaining-__function__-occurances.patch
lib-replace-remaining-__function__-occurances.patch
afs-replace-remaining-__function__-occurrences.patch
fs-replace-remaining-__function__-occurrences.patch
drivers-char-replace-remaining-__function__-occurrences.patch
serial-replace-remaining-__function__-occurrences.patch

