From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Thu, 29 Mar 2012 12:11:44 -0700
Message-ID: <20120329191145.AD0D9A01E3@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:40950 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755422Ab2C2TLs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 29 Mar 2012 15:11:48 -0400
Received: by wgbdt11 with SMTP id dt11so111382wgb.1
        for <mm-commits@vger.kernel.org>; Thu, 29 Mar 2012 12:11:47 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/include/asm/cp15.h      |    4 
 arch/arm/include/asm/system.h    |  477 -----------------------------
 arch/arm/mach-integrator/core.c  |    4 
 arch/arm/mach-integrator/pci.c   |    4 
 arch/arm/mach-shmobile/cpuidle.c |    4 
 arch/arm/mach-vexpress/hotplug.c |    4 
 arch/arm/mm/alignment.c          |    4 
 arch/x86/kernel/process_32.c     |    5 
 arch/x86/kernel/process_64.c     |    5 
 include/linux/dma-buf.h          |   19 -
 10 files changed, 530 deletions(-)

diff -puN arch/arm/include/asm/cp15.h~linux-next-git-rejects arch/arm/include/asm/cp15.h
--- a/arch/arm/include/asm/cp15.h~linux-next-git-rejects
+++ a/arch/arm/include/asm/cp15.h
@@ -1,11 +1,7 @@
 #ifndef __ASM_ARM_CP15_H
 #define __ASM_ARM_CP15_H
 
-<<<<<<< HEAD
 #include <asm/barrier.h>
-=======
-#include <asm/system.h>
->>>>>>> linux-next/akpm-end
 
 /*
  * CR1 bits (CP#15 CR1)
diff -puN arch/arm/include/asm/system.h~linux-next-git-rejects arch/arm/include/asm/system.h
--- a/arch/arm/include/asm/system.h~linux-next-git-rejects
+++ a/arch/arm/include/asm/system.h
@@ -1,478 +1 @@
-<<<<<<< HEAD
-/* FILE TO BE DELETED. DO NOT ADD STUFF HERE! */
-#include <asm/barrier.h>
-#include <asm/compiler.h>
-#include <asm/cmpxchg.h>
-#include <asm/exec.h>
-#include <asm/switch_to.h>
-#include <asm/system_info.h>
-#include <asm/system_misc.h>
-=======
-#ifndef __ASM_ARM_SYSTEM_H
-#define __ASM_ARM_SYSTEM_H
 
-#ifdef __KERNEL__
-
-#define CPU_ARCH_UNKNOWN	0
-#define CPU_ARCH_ARMv3		1
-#define CPU_ARCH_ARMv4		2
-#define CPU_ARCH_ARMv4T		3
-#define CPU_ARCH_ARMv5		4
-#define CPU_ARCH_ARMv5T		5
-#define CPU_ARCH_ARMv5TE	6
-#define CPU_ARCH_ARMv5TEJ	7
-#define CPU_ARCH_ARMv6		8
-#define CPU_ARCH_ARMv7		9
-
-/*
- * This is used to ensure the compiler did actually allocate the register we
- * asked it for some inline assembly sequences.  Apparently we can't trust
- * the compiler from one version to another so a bit of paranoia won't hurt.
- * This string is meant to be concatenated with the inline asm string and
- * will cause compilation to stop on mismatch.
- * (for details, see gcc PR 15089)
- */
-#define __asmeq(x, y)  ".ifnc " x "," y " ; .err ; .endif\n\t"
-
-#ifndef __ASSEMBLY__
-
-#include <linux/compiler.h>
-#include <linux/linkage.h>
-#include <linux/irqflags.h>
-
-#include <asm/outercache.h>
-
-struct thread_info;
-struct task_struct;
-
-/* information about the system we're running on */
-extern unsigned int system_rev;
-extern unsigned int system_serial_low;
-extern unsigned int system_serial_high;
-extern unsigned int mem_fclk_21285;
-
-struct pt_regs;
-
-void die(const char *msg, struct pt_regs *regs, int err);
-
-struct siginfo;
-void arm_notify_die(const char *str, struct pt_regs *regs, struct siginfo *info,
-		unsigned long err, unsigned long trap);
-
-#ifdef CONFIG_ARM_LPAE
-#define FAULT_CODE_ALIGNMENT	33
-#define FAULT_CODE_DEBUG	34
-#else
-#define FAULT_CODE_ALIGNMENT	1
-#define FAULT_CODE_DEBUG	2
-#endif
-
-void hook_fault_code(int nr, int (*fn)(unsigned long, unsigned int,
-				       struct pt_regs *),
-		     int sig, int code, const char *name);
-
-void hook_ifault_code(int nr, int (*fn)(unsigned long, unsigned int,
-				       struct pt_regs *),
-		     int sig, int code, const char *name);
-
-#define xchg(ptr,x) \
-	((__typeof__(*(ptr)))__xchg((unsigned long)(x),(ptr),sizeof(*(ptr))))
-
-extern asmlinkage void c_backtrace(unsigned long fp, int pmode);
-
-struct mm_struct;
-extern void show_pte(struct mm_struct *mm, unsigned long addr);
-extern void __show_regs(struct pt_regs *);
-
-extern int __pure cpu_architecture(void);
-extern void cpu_init(void);
-
-void soft_restart(unsigned long);
-extern void (*arm_pm_restart)(char str, const char *cmd);
-extern void (*arm_pm_idle)(void);
-
-#define UDBG_UNDEFINED	(1 << 0)
-#define UDBG_SYSCALL	(1 << 1)
-#define UDBG_BADABORT	(1 << 2)
-#define UDBG_SEGV	(1 << 3)
-#define UDBG_BUS	(1 << 4)
-
-extern unsigned int user_debug;
-
-#if __LINUX_ARM_ARCH__ >= 7 ||		\
-	(__LINUX_ARM_ARCH__ == 6 && defined(CONFIG_CPU_32v6K))
-#define sev()	__asm__ __volatile__ ("sev" : : : "memory")
-#define wfe()	__asm__ __volatile__ ("wfe" : : : "memory")
-#define wfi()	__asm__ __volatile__ ("wfi" : : : "memory")
-#endif
-
-#if __LINUX_ARM_ARCH__ >= 7
-#define isb() __asm__ __volatile__ ("isb" : : : "memory")
-#define dsb() __asm__ __volatile__ ("dsb" : : : "memory")
-#define dmb() __asm__ __volatile__ ("dmb" : : : "memory")
-#elif defined(CONFIG_CPU_XSC3) || __LINUX_ARM_ARCH__ == 6
-#define isb() __asm__ __volatile__ ("mcr p15, 0, %0, c7, c5, 4" \
-				    : : "r" (0) : "memory")
-#define dsb() __asm__ __volatile__ ("mcr p15, 0, %0, c7, c10, 4" \
-				    : : "r" (0) : "memory")
-#define dmb() __asm__ __volatile__ ("mcr p15, 0, %0, c7, c10, 5" \
-				    : : "r" (0) : "memory")
-#elif defined(CONFIG_CPU_FA526)
-#define isb() __asm__ __volatile__ ("mcr p15, 0, %0, c7, c5, 4" \
-				    : : "r" (0) : "memory")
-#define dsb() __asm__ __volatile__ ("mcr p15, 0, %0, c7, c10, 4" \
-				    : : "r" (0) : "memory")
-#define dmb() __asm__ __volatile__ ("" : : : "memory")
-#else
-#define isb() __asm__ __volatile__ ("" : : : "memory")
-#define dsb() __asm__ __volatile__ ("mcr p15, 0, %0, c7, c10, 4" \
-				    : : "r" (0) : "memory")
-#define dmb() __asm__ __volatile__ ("" : : : "memory")
-#endif
-
-#ifdef CONFIG_ARCH_HAS_BARRIERS
-#include <mach/barriers.h>
-#elif defined(CONFIG_ARM_DMA_MEM_BUFFERABLE) || defined(CONFIG_SMP)
-#define mb()		do { dsb(); outer_sync(); } while (0)
-#define rmb()		dsb()
-#define wmb()		mb()
-#else
-#include <asm/memory.h>
-#define mb()	do { if (arch_is_coherent()) dmb(); else barrier(); } while (0)
-#define rmb()	do { if (arch_is_coherent()) dmb(); else barrier(); } while (0)
-#define wmb()	do { if (arch_is_coherent()) dmb(); else barrier(); } while (0)
-#endif
-
-#ifndef CONFIG_SMP
-#define smp_mb()	barrier()
-#define smp_rmb()	barrier()
-#define smp_wmb()	barrier()
-#else
-#define smp_mb()	dmb()
-#define smp_rmb()	dmb()
-#define smp_wmb()	dmb()
-#endif
-
-#define read_barrier_depends()		do { } while(0)
-#define smp_read_barrier_depends()	do { } while(0)
-
-#define set_mb(var, value)	do { var = value; smp_mb(); } while (0)
-#define nop() __asm__ __volatile__("mov\tr0,r0\t@ nop\n\t");
-
-/*
- * switch_mm() may do a full cache flush over the context switch,
- * so enable interrupts over the context switch to avoid high
- * latency.
- */
-#define __ARCH_WANT_INTERRUPTS_ON_CTXSW
-
-/*
- * switch_to(prev, next) should switch from task `prev' to `next'
- * `prev' will never be the same as `next'.  schedule() itself
- * contains the memory barrier to tell GCC not to cache `current'.
- */
-extern struct task_struct *__switch_to(struct task_struct *, struct thread_info *, struct thread_info *);
-
-#define switch_to(prev,next,last)					\
-do {									\
-	last = __switch_to(prev,task_thread_info(prev), task_thread_info(next));	\
-} while (0)
-
-#if defined(CONFIG_CPU_SA1100) || defined(CONFIG_CPU_SA110)
-/*
- * On the StrongARM, "swp" is terminally broken since it bypasses the
- * cache totally.  This means that the cache becomes inconsistent, and,
- * since we use normal loads/stores as well, this is really bad.
- * Typically, this causes oopsen in filp_close, but could have other,
- * more disastrous effects.  There are two work-arounds:
- *  1. Disable interrupts and emulate the atomic swap
- *  2. Clean the cache, perform atomic swap, flush the cache
- *
- * We choose (1) since its the "easiest" to achieve here and is not
- * dependent on the processor type.
- *
- * NOTE that this solution won't work on an SMP system, so explcitly
- * forbid it here.
- */
-#define swp_is_buggy
-#endif
-
-static inline unsigned long __xchg(unsigned long x, volatile void *ptr, int size)
-{
-	extern void __bad_xchg(volatile void *, int);
-	unsigned long ret;
-#ifdef swp_is_buggy
-	unsigned long flags;
-#endif
-#if __LINUX_ARM_ARCH__ >= 6
-	unsigned int tmp;
-#endif
-
-	smp_mb();
-
-	switch (size) {
-#if __LINUX_ARM_ARCH__ >= 6
-	case 1:
-		asm volatile("@	__xchg1\n"
-		"1:	ldrexb	%0, [%3]\n"
-		"	strexb	%1, %2, [%3]\n"
-		"	teq	%1, #0\n"
-		"	bne	1b"
-			: "=&r" (ret), "=&r" (tmp)
-			: "r" (x), "r" (ptr)
-			: "memory", "cc");
-		break;
-	case 4:
-		asm volatile("@	__xchg4\n"
-		"1:	ldrex	%0, [%3]\n"
-		"	strex	%1, %2, [%3]\n"
-		"	teq	%1, #0\n"
-		"	bne	1b"
-			: "=&r" (ret), "=&r" (tmp)
-			: "r" (x), "r" (ptr)
-			: "memory", "cc");
-		break;
-#elif defined(swp_is_buggy)
-#ifdef CONFIG_SMP
-#error SMP is not supported on this platform
-#endif
-	case 1:
-		raw_local_irq_save(flags);
-		ret = *(volatile unsigned char *)ptr;
-		*(volatile unsigned char *)ptr = x;
-		raw_local_irq_restore(flags);
-		break;
-
-	case 4:
-		raw_local_irq_save(flags);
-		ret = *(volatile unsigned long *)ptr;
-		*(volatile unsigned long *)ptr = x;
-		raw_local_irq_restore(flags);
-		break;
-#else
-	case 1:
-		asm volatile("@	__xchg1\n"
-		"	swpb	%0, %1, [%2]"
-			: "=&r" (ret)
-			: "r" (x), "r" (ptr)
-			: "memory", "cc");
-		break;
-	case 4:
-		asm volatile("@	__xchg4\n"
-		"	swp	%0, %1, [%2]"
-			: "=&r" (ret)
-			: "r" (x), "r" (ptr)
-			: "memory", "cc");
-		break;
-#endif
-	default:
-		__bad_xchg(ptr, size), ret = 0;
-		break;
-	}
-	smp_mb();
-
-	return ret;
-}
-
-extern void disable_hlt(void);
-extern void enable_hlt(void);
-
-void cpu_idle_wait(void);
-
-#include <asm-generic/cmpxchg-local.h>
-
-#if __LINUX_ARM_ARCH__ < 6
-/* min ARCH < ARMv6 */
-
-#ifdef CONFIG_SMP
-#error "SMP is not supported on this platform"
-#endif
-
-/*
- * cmpxchg_local and cmpxchg64_local are atomic wrt current CPU. Always make
- * them available.
- */
-#define cmpxchg_local(ptr, o, n)				  	       \
-	((__typeof__(*(ptr)))__cmpxchg_local_generic((ptr), (unsigned long)(o),\
-			(unsigned long)(n), sizeof(*(ptr))))
-#define cmpxchg64_local(ptr, o, n) __cmpxchg64_local_generic((ptr), (o), (n))
-
-#ifndef CONFIG_SMP
-#include <asm-generic/cmpxchg.h>
-#endif
-
-#else	/* min ARCH >= ARMv6 */
-
-extern void __bad_cmpxchg(volatile void *ptr, int size);
-
-/*
- * cmpxchg only support 32-bits operands on ARMv6.
- */
-
-static inline unsigned long __cmpxchg(volatile void *ptr, unsigned long old,
-				      unsigned long new, int size)
-{
-	unsigned long oldval, res;
-
-	switch (size) {
-#ifndef CONFIG_CPU_V6	/* min ARCH >= ARMv6K */
-	case 1:
-		do {
-			asm volatile("@ __cmpxchg1\n"
-			"	ldrexb	%1, [%2]\n"
-			"	mov	%0, #0\n"
-			"	teq	%1, %3\n"
-			"	strexbeq %0, %4, [%2]\n"
-				: "=&r" (res), "=&r" (oldval)
-				: "r" (ptr), "Ir" (old), "r" (new)
-				: "memory", "cc");
-		} while (res);
-		break;
-	case 2:
-		do {
-			asm volatile("@ __cmpxchg1\n"
-			"	ldrexh	%1, [%2]\n"
-			"	mov	%0, #0\n"
-			"	teq	%1, %3\n"
-			"	strexheq %0, %4, [%2]\n"
-				: "=&r" (res), "=&r" (oldval)
-				: "r" (ptr), "Ir" (old), "r" (new)
-				: "memory", "cc");
-		} while (res);
-		break;
-#endif
-	case 4:
-		do {
-			asm volatile("@ __cmpxchg4\n"
-			"	ldrex	%1, [%2]\n"
-			"	mov	%0, #0\n"
-			"	teq	%1, %3\n"
-			"	strexeq %0, %4, [%2]\n"
-				: "=&r" (res), "=&r" (oldval)
-				: "r" (ptr), "Ir" (old), "r" (new)
-				: "memory", "cc");
-		} while (res);
-		break;
-	default:
-		__bad_cmpxchg(ptr, size);
-		oldval = 0;
-	}
-
-	return oldval;
-}
-
-static inline unsigned long __cmpxchg_mb(volatile void *ptr, unsigned long old,
-					 unsigned long new, int size)
-{
-	unsigned long ret;
-
-	smp_mb();
-	ret = __cmpxchg(ptr, old, new, size);
-	smp_mb();
-
-	return ret;
-}
-
-#define cmpxchg(ptr,o,n)						\
-	((__typeof__(*(ptr)))__cmpxchg_mb((ptr),			\
-					  (unsigned long)(o),		\
-					  (unsigned long)(n),		\
-					  sizeof(*(ptr))))
-
-static inline unsigned long __cmpxchg_local(volatile void *ptr,
-					    unsigned long old,
-					    unsigned long new, int size)
-{
-	unsigned long ret;
-
-	switch (size) {
-#ifdef CONFIG_CPU_V6	/* min ARCH == ARMv6 */
-	case 1:
-	case 2:
-		ret = __cmpxchg_local_generic(ptr, old, new, size);
-		break;
-#endif
-	default:
-		ret = __cmpxchg(ptr, old, new, size);
-	}
-
-	return ret;
-}
-
-#define cmpxchg_local(ptr,o,n)						\
-	((__typeof__(*(ptr)))__cmpxchg_local((ptr),			\
-				       (unsigned long)(o),		\
-				       (unsigned long)(n),		\
-				       sizeof(*(ptr))))
-
-#ifndef CONFIG_CPU_V6	/* min ARCH >= ARMv6K */
-
-/*
- * Note : ARMv7-M (currently unsupported by Linux) does not support
- * ldrexd/strexd. If ARMv7-M is ever supported by the Linux kernel, it should
- * not be allowed to use __cmpxchg64.
- */
-static inline unsigned long long __cmpxchg64(volatile void *ptr,
-					     unsigned long long old,
-					     unsigned long long new)
-{
-	register unsigned long long oldval asm("r0");
-	register unsigned long long __old asm("r2") = old;
-	register unsigned long long __new asm("r4") = new;
-	unsigned long res;
-
-	do {
-		asm volatile(
-		"	@ __cmpxchg8\n"
-		"	ldrexd	%1, %H1, [%2]\n"
-		"	mov	%0, #0\n"
-		"	teq	%1, %3\n"
-		"	teqeq	%H1, %H3\n"
-		"	strexdeq %0, %4, %H4, [%2]\n"
-			: "=&r" (res), "=&r" (oldval)
-			: "r" (ptr), "Ir" (__old), "r" (__new)
-			: "memory", "cc");
-	} while (res);
-
-	return oldval;
-}
-
-static inline unsigned long long __cmpxchg64_mb(volatile void *ptr,
-						unsigned long long old,
-						unsigned long long new)
-{
-	unsigned long long ret;
-
-	smp_mb();
-	ret = __cmpxchg64(ptr, old, new);
-	smp_mb();
-
-	return ret;
-}
-
-#define cmpxchg64(ptr,o,n)						\
-	((__typeof__(*(ptr)))__cmpxchg64_mb((ptr),			\
-					    (unsigned long long)(o),	\
-					    (unsigned long long)(n)))
-
-#define cmpxchg64_local(ptr,o,n)					\
-	((__typeof__(*(ptr)))__cmpxchg64((ptr),				\
-					 (unsigned long long)(o),	\
-					 (unsigned long long)(n)))
-
-#else /* min ARCH = ARMv6 */
-
-#define cmpxchg64_local(ptr, o, n) __cmpxchg64_local_generic((ptr), (o), (n))
-
-#endif
-
-#endif	/* __LINUX_ARM_ARCH__ >= 6 */
-
-#endif /* __ASSEMBLY__ */
-
-#define arch_align_stack(x) (x)
-
-#endif /* __KERNEL__ */
-
-#endif
->>>>>>> linux-next/akpm-end
diff -puN arch/arm/mach-integrator/core.c~linux-next-git-rejects arch/arm/mach-integrator/core.c
--- a/arch/arm/mach-integrator/core.c~linux-next-git-rejects
+++ a/arch/arm/mach-integrator/core.c
@@ -26,12 +26,8 @@
 #include <mach/hardware.h>
 #include <mach/platform.h>
 #include <mach/cm.h>
-<<<<<<< HEAD
-=======
 #include <mach/irqs.h>
 
-#include <asm/system.h>
->>>>>>> linux-next/akpm-end
 #include <asm/leds.h>
 #include <asm/mach-types.h>
 #include <asm/mach/time.h>
diff -puN arch/arm/mach-integrator/pci.c~linux-next-git-rejects arch/arm/mach-integrator/pci.c
--- a/arch/arm/mach-integrator/pci.c~linux-next-git-rejects
+++ a/arch/arm/mach-integrator/pci.c
@@ -26,11 +26,7 @@
 #include <linux/interrupt.h>
 #include <linux/init.h>
 
-<<<<<<< HEAD
 #include <asm/irq.h>
-=======
-#include <asm/system.h>
->>>>>>> linux-next/akpm-end
 #include <asm/mach/pci.h>
 #include <asm/mach-types.h>
 
diff -puN arch/arm/mach-shmobile/cpuidle.c~linux-next-git-rejects arch/arm/mach-shmobile/cpuidle.c
--- a/arch/arm/mach-shmobile/cpuidle.c~linux-next-git-rejects
+++ a/arch/arm/mach-shmobile/cpuidle.c
@@ -13,11 +13,7 @@
 #include <linux/suspend.h>
 #include <linux/module.h>
 #include <linux/err.h>
-<<<<<<< HEAD
-=======
-#include <asm/system.h>
 #include <asm/cpuidle.h>
->>>>>>> linux-next/akpm-end
 #include <asm/io.h>
 
 static void shmobile_enter_wfi(void)
diff -puN arch/arm/mach-vexpress/hotplug.c~linux-next-git-rejects arch/arm/mach-vexpress/hotplug.c
--- a/arch/arm/mach-vexpress/hotplug.c~linux-next-git-rejects
+++ a/arch/arm/mach-vexpress/hotplug.c
@@ -15,10 +15,6 @@
 #include <asm/cacheflush.h>
 #include <asm/cp15.h>
 #include <asm/smp_plat.h>
-<<<<<<< HEAD
-#include <asm/cp15.h>
-=======
->>>>>>> linux-next/akpm-end
 
 extern volatile int pen_release;
 
diff -puN arch/arm/mm/alignment.c~linux-next-git-rejects arch/arm/mm/alignment.c
--- a/arch/arm/mm/alignment.c~linux-next-git-rejects
+++ a/arch/arm/mm/alignment.c
@@ -23,10 +23,6 @@
 #include <linux/uaccess.h>
 
 #include <asm/cp15.h>
-<<<<<<< HEAD
-#include <asm/system_info.h>
-=======
->>>>>>> linux-next/akpm-end
 #include <asm/unaligned.h>
 
 #include "fault.h"
diff -puN arch/x86/kernel/process_32.c~linux-next-git-rejects arch/x86/kernel/process_32.c
--- a/arch/x86/kernel/process_32.c~linux-next-git-rejects
+++ a/arch/x86/kernel/process_32.c
@@ -54,11 +54,6 @@
 #include <asm/idle.h>
 #include <asm/syscalls.h>
 #include <asm/debugreg.h>
-<<<<<<< HEAD
-#include <asm/nmi.h>
-#include <asm/switch_to.h>
-=======
->>>>>>> linux-next/akpm-end
 
 asmlinkage void ret_from_fork(void) __asm__("ret_from_fork");
 
diff -puN arch/x86/kernel/process_64.c~linux-next-git-rejects arch/x86/kernel/process_64.c
--- a/arch/x86/kernel/process_64.c~linux-next-git-rejects
+++ a/arch/x86/kernel/process_64.c
@@ -48,11 +48,6 @@
 #include <asm/idle.h>
 #include <asm/syscalls.h>
 #include <asm/debugreg.h>
-<<<<<<< HEAD
-#include <asm/nmi.h>
-#include <asm/switch_to.h>
-=======
->>>>>>> linux-next/akpm-end
 
 asmlinkage extern void ret_from_fork(void);
 
diff -puN include/linux/dma-buf.h~linux-next-git-rejects include/linux/dma-buf.h
--- a/include/linux/dma-buf.h~linux-next-git-rejects
+++ a/include/linux/dma-buf.h
@@ -228,42 +228,23 @@ static inline void dma_buf_end_cpu_acces
 {
 }
 
-<<<<<<< HEAD
-static inline void *dma_buf_kmap_atomic(struct dma_buf *dmabuf,
-					unsigned long pnum)
-=======
 static inline void *dma_buf_kmap_atomic(struct dma_buf *db, unsigned long pnum)
->>>>>>> linux-next/akpm-end
 {
 	return NULL;
 }
 
-<<<<<<< HEAD
-static inline void dma_buf_kunmap_atomic(struct dma_buf *dmabuf,
-					 unsigned long pnum, void *vaddr)
-{
-}
-
-static inline void *dma_buf_kmap(struct dma_buf *dmabuf, unsigned long pnum)
-=======
 static inline void dma_buf_kunmap_atomic(struct dma_buf *db, unsigned long pnum,
 					 void *vaddr)
 {
 }
 
 static inline void *dma_buf_kmap(struct dma_buf *db, unsigned long pnum)
->>>>>>> linux-next/akpm-end
 {
 	return NULL;
 }
 
-<<<<<<< HEAD
-static inline void dma_buf_kunmap(struct dma_buf *dmabuf,
-				  unsigned long pnum, void *vaddr)
-=======
 static inline void dma_buf_kunmap(struct dma_buf *db, unsigned long pnum,
 				  void *vaddr)
->>>>>>> linux-next/akpm-end
 {
 }
 #endif /* CONFIG_DMA_SHARED_BUFFER */
_
Subject: Subject: linux-next-git-rejects

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
drivers-staging-zsmalloc-zsmalloc-mainc-unbork.patch
fs-xattrc-listxattr-fall-back-to-vmalloc-if-kmalloc-failed.patch
fs-xattrc-setxattr-improve-handling-of-allocation-failures.patch
simple_open-automatically-convert-to-simple_open-checkpatch-fixes.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
drivers-xen-kconfig-fix-kconfig-layout.patch
cpuidle-add-a-sysfs-entry-to-disable-specific-c-state-for-debug-purpose.patch
x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs.patch
percpu-remove-percpu_xxx-functions-fix.patch
net-netfilter-nfnetlink_acctc-use-linux-atomich.patch
fs-symlink-restrictions-on-sticky-directories.patch
fs-hardlink-creation-restrictions.patch
brlocks-lglocks-cleanups.patch
mm.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
mm-push-lru-index-into-shrink_active_list-fix.patch
arch-powerpc-platforms-pseries-eeh_eventc-slightly-fix-set_current_state-wart.patch
vsprintf-further-optimize-decimal-conversion-checkpatch-fixes.patch
kmod-avoid-deadlock-by-recursive-kmod-call.patch
syscalls-x86-add-__nr_kcmp-syscall-v8.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-fix.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-fix-2.patch
c-r-prctl-add-ability-to-get-clear_tid_address-fix.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

