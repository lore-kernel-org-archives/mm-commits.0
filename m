Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE6E9C433FE
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 22:18:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D8EA361181
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 22:18:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236059AbhIHWTj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 8 Sep 2021 18:19:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:42198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234941AbhIHWTi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 8 Sep 2021 18:19:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 835826113A;
        Wed,  8 Sep 2021 22:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631139510;
        bh=DQfyYMHOUaqfLNkTnkJxom20tGSik2ImEQWdhMQxMIo=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=n9Qf7BhnmU/3WWXEos0ascDs7X7GcHxWYiMU+Y0o72o8Lz9F9wz1xfEjnnaChQhE6
         cu4qeyCr6apnzMUVACY0JocdzA8W0CUuOiJJZn2jldQq1dTuKFRtNZa+QKsxinvhC0
         +idd9SuiYofbf11MymEqCiw5NFUPWs+aABUQSWY8=
Date:   Wed, 08 Sep 2021 15:18:29 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, arnd@arndb.de, benh@kernel.crashing.org,
        borntraeger@de.ibm.com, bp@alien8.de, catalin.marinas@arm.com,
        davem@davemloft.net, deller@gmx.de, ebiederm@xmission.com,
        feng.tang@intel.com, gor@linux.ibm.com, hca@linux.ibm.com,
        hch@infradead.org, hch@lst.de, hpa@zytor.com,
        James.Bottomley@HansenPartnership.com, linux-mm@kvack.org,
        mingo@redhat.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au,
        paulus@samba.org, tglx@linutronix.de,
        torvalds@linux-foundation.org, tsbogend@alpha.franken.de,
        viro@zeniv.linux.org.uk, will@kernel.org
Subject:  [patch 10/10] arch: remove compat_alloc_user_space
Message-ID: <20210908221829.poLvXdiKm%akpm@linux-foundation.org>
In-Reply-To: <20210908151729.c9a15a9508ba0aed22289c76@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>
Subject: arch: remove compat_alloc_user_space

All users of compat_alloc_user_space() and copy_in_user() have been
removed from the kernel, only a few functions in sparc remain that can be
changed to calling arch_copy_in_user() instead.

Link: https://lkml.kernel.org/r/20210727144859.4150043-7-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Feng Tang <feng.tang@intel.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Helge Deller <deller@gmx.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/compat.h         |    5 -
 arch/arm64/include/asm/uaccess.h        |   11 ---
 arch/arm64/lib/Makefile                 |    2 
 arch/arm64/lib/copy_in_user.S           |   77 ----------------------
 arch/mips/cavium-octeon/octeon-memcpy.S |    2 
 arch/mips/include/asm/compat.h          |    8 --
 arch/mips/include/asm/uaccess.h         |   26 -------
 arch/mips/lib/memcpy.S                  |   11 ---
 arch/parisc/include/asm/compat.h        |    6 -
 arch/parisc/include/asm/uaccess.h       |    2 
 arch/parisc/lib/memcpy.c                |    9 --
 arch/powerpc/include/asm/compat.h       |   16 ----
 arch/s390/include/asm/compat.h          |   10 --
 arch/s390/include/asm/uaccess.h         |    3 
 arch/s390/lib/uaccess.c                 |   63 ------------------
 arch/sparc/include/asm/compat.h         |   19 -----
 arch/sparc/kernel/process_64.c          |    2 
 arch/sparc/kernel/signal32.c            |   12 +--
 arch/sparc/kernel/signal_64.c           |    8 +-
 arch/x86/include/asm/compat.h           |   13 ---
 arch/x86/include/asm/uaccess_64.h       |    7 --
 include/linux/compat.h                  |    2 
 include/linux/uaccess.h                 |   10 --
 kernel/compat.c                         |   21 ------
 24 files changed, 12 insertions(+), 333 deletions(-)

--- a/arch/arm64/include/asm/compat.h~arch-remove-compat_alloc_user_space
+++ a/arch/arm64/include/asm/compat.h
@@ -107,11 +107,6 @@ struct compat_statfs {
 #define compat_user_stack_pointer() (user_stack_pointer(task_pt_regs(current)))
 #define COMPAT_MINSIGSTKSZ	2048
 
-static inline void __user *arch_compat_alloc_user_space(long len)
-{
-	return (void __user *)compat_user_stack_pointer() - len;
-}
-
 struct compat_ipc64_perm {
 	compat_key_t key;
 	__compat_uid32_t uid;
--- a/arch/arm64/include/asm/uaccess.h~arch-remove-compat_alloc_user_space
+++ a/arch/arm64/include/asm/uaccess.h
@@ -430,17 +430,6 @@ extern unsigned long __must_check __arch
 	__actu_ret;							\
 })
 
-extern unsigned long __must_check __arch_copy_in_user(void __user *to, const void __user *from, unsigned long n);
-#define raw_copy_in_user(to, from, n)					\
-({									\
-	unsigned long __aciu_ret;					\
-	uaccess_ttbr0_enable();						\
-	__aciu_ret = __arch_copy_in_user(__uaccess_mask_ptr(to),	\
-				    __uaccess_mask_ptr(from), (n));	\
-	uaccess_ttbr0_disable();					\
-	__aciu_ret;							\
-})
-
 #define INLINE_COPY_TO_USER
 #define INLINE_COPY_FROM_USER
 
--- a/arch/arm64/lib/copy_in_user.S
+++ /dev/null
@@ -1,77 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-only */
-/*
- * Copy from user space to user space
- *
- * Copyright (C) 2012 ARM Ltd.
- */
-
-#include <linux/linkage.h>
-
-#include <asm/asm-uaccess.h>
-#include <asm/assembler.h>
-#include <asm/cache.h>
-
-/*
- * Copy from user space to user space (alignment handled by the hardware)
- *
- * Parameters:
- *	x0 - to
- *	x1 - from
- *	x2 - n
- * Returns:
- *	x0 - bytes not copied
- */
-	.macro ldrb1 reg, ptr, val
-	user_ldst 9998f, ldtrb, \reg, \ptr, \val
-	.endm
-
-	.macro strb1 reg, ptr, val
-	user_ldst 9998f, sttrb, \reg, \ptr, \val
-	.endm
-
-	.macro ldrh1 reg, ptr, val
-	user_ldst 9997f, ldtrh, \reg, \ptr, \val
-	.endm
-
-	.macro strh1 reg, ptr, val
-	user_ldst 9997f, sttrh, \reg, \ptr, \val
-	.endm
-
-	.macro ldr1 reg, ptr, val
-	user_ldst 9997f, ldtr, \reg, \ptr, \val
-	.endm
-
-	.macro str1 reg, ptr, val
-	user_ldst 9997f, sttr, \reg, \ptr, \val
-	.endm
-
-	.macro ldp1 reg1, reg2, ptr, val
-	user_ldp 9997f, \reg1, \reg2, \ptr, \val
-	.endm
-
-	.macro stp1 reg1, reg2, ptr, val
-	user_stp 9997f, \reg1, \reg2, \ptr, \val
-	.endm
-
-end	.req	x5
-srcin	.req	x15
-SYM_FUNC_START(__arch_copy_in_user)
-	add	end, x0, x2
-	mov	srcin, x1
-#include "copy_template.S"
-	mov	x0, #0
-	ret
-SYM_FUNC_END(__arch_copy_in_user)
-EXPORT_SYMBOL(__arch_copy_in_user)
-
-	.section .fixup,"ax"
-	.align	2
-9997:	cmp	dst, dstin
-	b.ne	9998f
-	// Before being absolutely sure we couldn't copy anything, try harder
-USER(9998f, ldtrb tmp1w, [srcin])
-USER(9998f, sttrb tmp1w, [dst])
-	add	dst, dst, #1
-9998:	sub	x0, end, dst			// bytes not copied
-	ret
-	.previous
--- a/arch/arm64/lib/Makefile~arch-remove-compat_alloc_user_space
+++ a/arch/arm64/lib/Makefile
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 lib-y		:= clear_user.o delay.o copy_from_user.o		\
-		   copy_to_user.o copy_in_user.o copy_page.o		\
+		   copy_to_user.o copy_page.o				\
 		   clear_page.o csum.o insn.o memchr.o memcpy.o		\
 		   memset.o memcmp.o strcmp.o strncmp.o strlen.o	\
 		   strnlen.o strchr.o strrchr.o tishift.o
--- a/arch/mips/cavium-octeon/octeon-memcpy.S~arch-remove-compat_alloc_user_space
+++ a/arch/mips/cavium-octeon/octeon-memcpy.S
@@ -154,8 +154,6 @@ FEXPORT(__raw_copy_from_user)
 EXPORT_SYMBOL(__raw_copy_from_user)
 FEXPORT(__raw_copy_to_user)
 EXPORT_SYMBOL(__raw_copy_to_user)
-FEXPORT(__raw_copy_in_user)
-EXPORT_SYMBOL(__raw_copy_in_user)
 	/*
 	 * Note: dst & src may be unaligned, len may be 0
 	 * Temps
--- a/arch/mips/include/asm/compat.h~arch-remove-compat_alloc_user_space
+++ a/arch/mips/include/asm/compat.h
@@ -96,14 +96,6 @@ struct compat_statfs {
 
 #define COMPAT_OFF_T_MAX	0x7fffffff
 
-static inline void __user *arch_compat_alloc_user_space(long len)
-{
-	struct pt_regs *regs = (struct pt_regs *)
-		((unsigned long) current_thread_info() + THREAD_SIZE - 32) - 1;
-
-	return (void __user *) (regs->regs[29] - len);
-}
-
 struct compat_ipc64_perm {
 	compat_key_t key;
 	__compat_uid32_t uid;
--- a/arch/mips/include/asm/uaccess.h~arch-remove-compat_alloc_user_space
+++ a/arch/mips/include/asm/uaccess.h
@@ -428,7 +428,6 @@ do {									\
 
 extern size_t __raw_copy_from_user(void *__to, const void *__from, size_t __n);
 extern size_t __raw_copy_to_user(void *__to, const void *__from, size_t __n);
-extern size_t __raw_copy_in_user(void *__to, const void *__from, size_t __n);
 
 static inline unsigned long
 raw_copy_from_user(void *to, const void __user *from, unsigned long n)
@@ -480,31 +479,6 @@ raw_copy_to_user(void __user *to, const
 #define INLINE_COPY_FROM_USER
 #define INLINE_COPY_TO_USER
 
-static inline unsigned long
-raw_copy_in_user(void __user *to, const void __user *from, unsigned long n)
-{
-	register void __user *__cu_to_r __asm__("$4");
-	register const void __user *__cu_from_r __asm__("$5");
-	register long __cu_len_r __asm__("$6");
-
-	__cu_to_r = to;
-	__cu_from_r = from;
-	__cu_len_r = n;
-
-	__asm__ __volatile__(
-		".set\tnoreorder\n\t"
-		__MODULE_JAL(__raw_copy_in_user)
-		".set\tnoat\n\t"
-		__UA_ADDU "\t$1, %1, %2\n\t"
-		".set\tat\n\t"
-		".set\treorder"
-		: "+r" (__cu_to_r), "+r" (__cu_from_r), "+r" (__cu_len_r)
-		:
-		: "$8", "$9", "$10", "$11", "$12", "$14", "$15", "$24", "$31",
-		  DADDI_SCRATCH, "memory");
-	return __cu_len_r;
-}
-
 extern __kernel_size_t __bzero(void __user *addr, __kernel_size_t size);
 
 /*
--- a/arch/mips/lib/memcpy.S~arch-remove-compat_alloc_user_space
+++ a/arch/mips/lib/memcpy.S
@@ -666,8 +666,6 @@ FEXPORT(__raw_copy_from_user)
 EXPORT_SYMBOL(__raw_copy_from_user)
 FEXPORT(__raw_copy_to_user)
 EXPORT_SYMBOL(__raw_copy_to_user)
-FEXPORT(__raw_copy_in_user)
-EXPORT_SYMBOL(__raw_copy_in_user)
 #endif
 	/* Legacy Mode, user <-> user */
 	__BUILD_COPY_USER LEGACY_MODE USEROP USEROP
@@ -703,13 +701,4 @@ EXPORT_SYMBOL(__raw_copy_to_user)
 __BUILD_COPY_USER EVA_MODE KERNELOP USEROP
 END(__raw_copy_to_user)
 
-/*
- * __copy_in_user (EVA)
- */
-
-LEAF(__raw_copy_in_user)
-EXPORT_SYMBOL(__raw_copy_in_user)
-__BUILD_COPY_USER EVA_MODE USEROP USEROP
-END(__raw_copy_in_user)
-
 #endif
--- a/arch/parisc/include/asm/compat.h~arch-remove-compat_alloc_user_space
+++ a/arch/parisc/include/asm/compat.h
@@ -163,12 +163,6 @@ struct compat_shmid64_ds {
 #define COMPAT_ELF_NGREG 80
 typedef compat_ulong_t compat_elf_gregset_t[COMPAT_ELF_NGREG];
 
-static __inline__ void __user *arch_compat_alloc_user_space(long len)
-{
-	struct pt_regs *regs = &current->thread.regs;
-	return (void __user *)regs->gr[30];
-}
-
 static inline int __is_compat_task(struct task_struct *t)
 {
 	return test_tsk_thread_flag(t, TIF_32BIT);
--- a/arch/parisc/include/asm/uaccess.h~arch-remove-compat_alloc_user_space
+++ a/arch/parisc/include/asm/uaccess.h
@@ -215,8 +215,6 @@ unsigned long __must_check raw_copy_to_u
 					    unsigned long len);
 unsigned long __must_check raw_copy_from_user(void *dst, const void __user *src,
 					    unsigned long len);
-unsigned long __must_check raw_copy_in_user(void __user *dst, const void __user *src,
-					    unsigned long len);
 #define INLINE_COPY_TO_USER
 #define INLINE_COPY_FROM_USER
 
--- a/arch/parisc/lib/memcpy.c~arch-remove-compat_alloc_user_space
+++ a/arch/parisc/lib/memcpy.c
@@ -38,14 +38,6 @@ unsigned long raw_copy_from_user(void *d
 }
 EXPORT_SYMBOL(raw_copy_from_user);
 
-unsigned long raw_copy_in_user(void __user *dst, const void __user *src, unsigned long len)
-{
-	mtsp(get_user_space(), 1);
-	mtsp(get_user_space(), 2);
-	return pa_memcpy((void __force *)dst, (void __force *)src, len);
-}
-
-
 void * memcpy(void * dst,const void *src, size_t count)
 {
 	mtsp(get_kernel_space(), 1);
@@ -54,7 +46,6 @@ void * memcpy(void * dst,const void *src
 	return dst;
 }
 
-EXPORT_SYMBOL(raw_copy_in_user);
 EXPORT_SYMBOL(memcpy);
 
 bool copy_from_kernel_nofault_allowed(const void *unsafe_src, size_t size)
--- a/arch/powerpc/include/asm/compat.h~arch-remove-compat_alloc_user_space
+++ a/arch/powerpc/include/asm/compat.h
@@ -83,22 +83,6 @@ struct compat_statfs {
 
 #define COMPAT_OFF_T_MAX	0x7fffffff
 
-static inline void __user *arch_compat_alloc_user_space(long len)
-{
-	struct pt_regs *regs = current->thread.regs;
-	unsigned long usp = regs->gpr[1];
-
-	/*
-	 * We can't access below the stack pointer in the 32bit ABI and
-	 * can access 288 bytes in the 64bit big-endian ABI,
-	 * or 512 bytes with the new ELFv2 little-endian ABI.
-	 */
-	if (!is_32bit_task())
-		usp -= USER_REDZONE_SIZE;
-
-	return (void __user *) (usp - len);
-}
-
 /*
  * ipc64_perm is actually 32/64bit clean but since the compat layer refers to
  * it we may as well define it.
--- a/arch/s390/include/asm/compat.h~arch-remove-compat_alloc_user_space
+++ a/arch/s390/include/asm/compat.h
@@ -176,16 +176,6 @@ static inline int is_compat_task(void)
 	return test_thread_flag(TIF_31BIT);
 }
 
-static inline void __user *arch_compat_alloc_user_space(long len)
-{
-	unsigned long stack;
-
-	stack = KSTK_ESP(current);
-	if (is_compat_task())
-		stack &= 0x7fffffffUL;
-	return (void __user *) (stack - len);
-}
-
 #endif
 
 struct compat_ipc64_perm {
--- a/arch/s390/include/asm/uaccess.h~arch-remove-compat_alloc_user_space
+++ a/arch/s390/include/asm/uaccess.h
@@ -227,9 +227,6 @@ static inline int __get_user_fn(void *x,
 	__get_user(x, ptr);					\
 })
 
-unsigned long __must_check
-raw_copy_in_user(void __user *to, const void __user *from, unsigned long n);
-
 /*
  * Copy a null terminated string from userspace.
  */
--- a/arch/s390/lib/uaccess.c~arch-remove-compat_alloc_user_space
+++ a/arch/s390/lib/uaccess.c
@@ -204,69 +204,6 @@ unsigned long raw_copy_to_user(void __us
 }
 EXPORT_SYMBOL(raw_copy_to_user);
 
-static inline unsigned long copy_in_user_mvcos(void __user *to, const void __user *from,
-					       unsigned long size)
-{
-	unsigned long tmp1, tmp2;
-
-	tmp1 = -4096UL;
-	/* FIXME: copy with reduced length. */
-	asm volatile(
-		"   lgr	  0,%[spec]\n"
-		"0: .insn ss,0xc80000000000,0(%0,%1),0(%2),0\n"
-		"   jz	  2f\n"
-		"1: algr  %0,%3\n"
-		"   slgr  %1,%3\n"
-		"   slgr  %2,%3\n"
-		"   j	  0b\n"
-		"2:slgr  %0,%0\n"
-		"3: \n"
-		EX_TABLE(0b,3b)
-		: "+a" (size), "+a" (to), "+a" (from), "+a" (tmp1), "=a" (tmp2)
-		: [spec] "d" (0x810081UL)
-		: "cc", "memory", "0");
-	return size;
-}
-
-static inline unsigned long copy_in_user_mvc(void __user *to, const void __user *from,
-					     unsigned long size)
-{
-	unsigned long tmp1;
-
-	asm volatile(
-		"   sacf  256\n"
-		"   aghi  %0,-1\n"
-		"   jo	  5f\n"
-		"   bras  %3,3f\n"
-		"0: aghi  %0,257\n"
-		"1: mvc	  0(1,%1),0(%2)\n"
-		"   la	  %1,1(%1)\n"
-		"   la	  %2,1(%2)\n"
-		"   aghi  %0,-1\n"
-		"   jnz	  1b\n"
-		"   j	  5f\n"
-		"2: mvc	  0(256,%1),0(%2)\n"
-		"   la	  %1,256(%1)\n"
-		"   la	  %2,256(%2)\n"
-		"3: aghi  %0,-256\n"
-		"   jnm	  2b\n"
-		"4: ex	  %0,1b-0b(%3)\n"
-		"5: slgr  %0,%0\n"
-		"6: sacf  768\n"
-		EX_TABLE(1b,6b) EX_TABLE(2b,0b) EX_TABLE(4b,0b)
-		: "+a" (size), "+a" (to), "+a" (from), "=a" (tmp1)
-		: : "cc", "memory");
-	return size;
-}
-
-unsigned long raw_copy_in_user(void __user *to, const void __user *from, unsigned long n)
-{
-	if (copy_with_mvcos())
-		return copy_in_user_mvcos(to, from, n);
-	return copy_in_user_mvc(to, from, n);
-}
-EXPORT_SYMBOL(raw_copy_in_user);
-
 static inline unsigned long clear_user_mvcos(void __user *to, unsigned long size)
 {
 	unsigned long tmp1, tmp2;
--- a/arch/sparc/include/asm/compat.h~arch-remove-compat_alloc_user_space
+++ a/arch/sparc/include/asm/compat.h
@@ -116,25 +116,6 @@ struct compat_statfs {
 
 #define COMPAT_OFF_T_MAX	0x7fffffff
 
-#ifdef CONFIG_COMPAT
-static inline void __user *arch_compat_alloc_user_space(long len)
-{
-	struct pt_regs *regs = current_thread_info()->kregs;
-	unsigned long usp = regs->u_regs[UREG_I6];
-
-	if (test_thread_64bit_stack(usp))
-		usp += STACK_BIAS;
-
-	if (test_thread_flag(TIF_32BIT))
-		usp &= 0xffffffffUL;
-
-	usp -= len;
-	usp &= ~0x7UL;
-
-	return (void __user *) usp;
-}
-#endif
-
 struct compat_ipc64_perm {
 	compat_key_t key;
 	__compat_uid32_t uid;
--- a/arch/sparc/kernel/process_64.c~arch-remove-compat_alloc_user_space
+++ a/arch/sparc/kernel/process_64.c
@@ -455,7 +455,7 @@ static unsigned long clone_stackframe(un
 
 	distance = fp - psp;
 	rval = (csp - distance);
-	if (copy_in_user((void __user *) rval, (void __user *) psp, distance))
+	if (raw_copy_in_user((void __user *)rval, (void __user *)psp, distance))
 		rval = 0;
 	else if (!stack_64bit) {
 		if (put_user(((u32)csp),
--- a/arch/sparc/kernel/signal32.c~arch-remove-compat_alloc_user_space
+++ a/arch/sparc/kernel/signal32.c
@@ -435,9 +435,9 @@ static int setup_frame32(struct ksignal
 			      (_COMPAT_NSIG_WORDS - 1) * sizeof(unsigned int));
 
 	if (!wsaved) {
-		err |= copy_in_user((u32 __user *)sf,
-				    (u32 __user *)(regs->u_regs[UREG_FP]),
-				    sizeof(struct reg_window32));
+		err |= raw_copy_in_user((u32 __user *)sf,
+					(u32 __user *)(regs->u_regs[UREG_FP]),
+					sizeof(struct reg_window32));
 	} else {
 		struct reg_window *rp;
 
@@ -567,9 +567,9 @@ static int setup_rt_frame32(struct ksign
 	err |= put_compat_sigset(&sf->mask, oldset, sizeof(compat_sigset_t));
 
 	if (!wsaved) {
-		err |= copy_in_user((u32 __user *)sf,
-				    (u32 __user *)(regs->u_regs[UREG_FP]),
-				    sizeof(struct reg_window32));
+		err |= raw_copy_in_user((u32 __user *)sf,
+					(u32 __user *)(regs->u_regs[UREG_FP]),
+					sizeof(struct reg_window32));
 	} else {
 		struct reg_window *rp;
 
--- a/arch/sparc/kernel/signal_64.c~arch-remove-compat_alloc_user_space
+++ a/arch/sparc/kernel/signal_64.c
@@ -406,10 +406,10 @@ setup_rt_frame(struct ksignal *ksig, str
 	err |= copy_to_user(&sf->mask, sigmask_to_save(), sizeof(sigset_t));
 
 	if (!wsaved) {
-		err |= copy_in_user((u64 __user *)sf,
-				    (u64 __user *)(regs->u_regs[UREG_FP] +
-						   STACK_BIAS),
-				    sizeof(struct reg_window));
+		err |= raw_copy_in_user((u64 __user *)sf,
+					(u64 __user *)(regs->u_regs[UREG_FP] +
+					   STACK_BIAS),
+					sizeof(struct reg_window));
 	} else {
 		struct reg_window *rp;
 
--- a/arch/x86/include/asm/compat.h~arch-remove-compat_alloc_user_space
+++ a/arch/x86/include/asm/compat.h
@@ -156,19 +156,6 @@ struct compat_shmid64_ds {
 	(!!(task_pt_regs(current)->orig_ax & __X32_SYSCALL_BIT))
 #endif
 
-static inline void __user *arch_compat_alloc_user_space(long len)
-{
-	compat_uptr_t sp = task_pt_regs(current)->sp;
-
-	/*
-	 * -128 for the x32 ABI redzone.  For IA32, it is not strictly
-	 * necessary, but not harmful.
-	 */
-	sp -= 128;
-
-	return (void __user *)round_down(sp - len, 16);
-}
-
 static inline bool in_x32_syscall(void)
 {
 #ifdef CONFIG_X86_X32_ABI
--- a/arch/x86/include/asm/uaccess_64.h~arch-remove-compat_alloc_user_space
+++ a/arch/x86/include/asm/uaccess_64.h
@@ -58,13 +58,6 @@ raw_copy_to_user(void __user *dst, const
 	return copy_user_generic((__force void *)dst, src, size);
 }
 
-static __always_inline __must_check
-unsigned long raw_copy_in_user(void __user *dst, const void __user *src, unsigned long size)
-{
-	return copy_user_generic((__force void *)dst,
-				 (__force void *)src, size);
-}
-
 extern long __copy_user_nocache(void *dst, const void __user *src,
 				unsigned size, int zerorest);
 
--- a/include/linux/compat.h~arch-remove-compat_alloc_user_space
+++ a/include/linux/compat.h
@@ -511,8 +511,6 @@ extern long compat_arch_ptrace(struct ta
 
 struct epoll_event;	/* fortunately, this one is fixed-layout */
 
-extern void __user *compat_alloc_user_space(unsigned long len);
-
 int compat_restore_altstack(const compat_stack_t __user *uss);
 int __compat_save_altstack(compat_stack_t __user *, unsigned long);
 #define unsafe_compat_save_altstack(uss, sp, label) do { \
--- a/include/linux/uaccess.h~arch-remove-compat_alloc_user_space
+++ a/include/linux/uaccess.h
@@ -200,16 +200,6 @@ copy_to_user(void __user *to, const void
 		n = _copy_to_user(to, from, n);
 	return n;
 }
-#ifdef CONFIG_COMPAT
-static __always_inline unsigned long __must_check
-copy_in_user(void __user *to, const void __user *from, unsigned long n)
-{
-	might_fault();
-	if (access_ok(to, n) && access_ok(from, n))
-		n = raw_copy_in_user(to, from, n);
-	return n;
-}
-#endif
 
 #ifndef copy_mc_to_kernel
 /*
--- a/kernel/compat.c~arch-remove-compat_alloc_user_space
+++ a/kernel/compat.c
@@ -269,24 +269,3 @@ get_compat_sigset(sigset_t *set, const c
 	return 0;
 }
 EXPORT_SYMBOL_GPL(get_compat_sigset);
-
-/*
- * Allocate user-space memory for the duration of a single system call,
- * in order to marshall parameters inside a compat thunk.
- */
-void __user *compat_alloc_user_space(unsigned long len)
-{
-	void __user *ptr;
-
-	/* If len would occupy more than half of the entire compat space... */
-	if (unlikely(len > (((compat_uptr_t)~0) >> 1)))
-		return NULL;
-
-	ptr = arch_compat_alloc_user_space(len);
-
-	if (unlikely(!access_ok(ptr, len)))
-		return NULL;
-
-	return ptr;
-}
-EXPORT_SYMBOL_GPL(compat_alloc_user_space);
_
