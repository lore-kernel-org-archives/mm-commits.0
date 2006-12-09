From: akpm@osdl.org
Subject: + xtensa-fix-irq-and-misc-fixes.patch added to -mm tree
Date: Fri, 08 Dec 2006 16:12:27 -0800
Message-ID: <200612090012.kB90CRSH010519@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:55833 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760157AbWLIAMh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 19:12:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: czankel@tensilica.com, chris@zankel.net


The patch titled
     xtensa: fix irq and misc fixes
has been added to the -mm tree.  Its filename is
     xtensa-fix-irq-and-misc-fixes.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: xtensa: fix irq and misc fixes
From: Chris Zankel <czankel@tensilica.com>

Update the architecture specific interrupt handling code for Xtensa to support
the new API.  Use generic BUG macros in bug.h, and some minor fixes.

Signed-off-by: Chris Zankel <chris@zankel.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/xtensa/kernel/irq.c                        |  107 ++++++--------
 arch/xtensa/kernel/time.c                       |    8 -
 arch/xtensa/kernel/vmlinux.lds.S                |    1 
 include/asm-xtensa/bug.h                        |   25 ---
 include/asm-xtensa/byteorder.h                  |    4 
 include/asm-xtensa/irq_regs.h                   |    1 
 include/asm-xtensa/unistd.h                     |    3 
 include/asm-xtensa/xtensa/config-linux_be/tie.h |    2 
 8 files changed, 65 insertions(+), 86 deletions(-)

diff -puN arch/xtensa/kernel/irq.c~xtensa-fix-irq-and-misc-fixes arch/xtensa/kernel/irq.c
--- a/arch/xtensa/kernel/irq.c~xtensa-fix-irq-and-misc-fixes
+++ a/arch/xtensa/kernel/irq.c
@@ -4,7 +4,7 @@
  * Xtensa built-in interrupt controller and some generic functions copied
  * from i386.
  *
- * Copyright (C) 2002 - 2005 Tensilica, Inc.
+ * Copyright (C) 2002 - 2006 Tensilica, Inc.
  * Copyright (C) 1992, 1998 Linus Torvalds, Ingo Molnar
  *
  *
@@ -22,11 +22,6 @@
 #include <asm/uaccess.h>
 #include <asm/platform.h>
 
-static void enable_xtensa_irq(unsigned int irq);
-static void disable_xtensa_irq(unsigned int irq);
-static void mask_and_ack_xtensa(unsigned int irq);
-static void end_xtensa_irq(unsigned int irq);
-
 static unsigned int cached_irq_mask;
 
 atomic_t irq_err_count;
@@ -46,8 +41,16 @@ void ack_bad_irq(unsigned int irq)
  * handlers).
  */
 
-unsigned int  do_IRQ(int irq, struct pt_regs *regs)
+asmlinkage void do_IRQ(int irq, struct pt_regs *regs)
 {
+	struct pt_regs *old_regs = set_irq_regs(regs);
+	struct irq_desc *desc = irq_desc + irq;
+
+	if (irq >= NR_IRQS) {
+		printk(KERN_EMERG "%s: cannot handle IRQ %d\n",
+				__FUNCTION__, irq);
+	}
+
 	irq_enter();
 
 #ifdef CONFIG_DEBUG_STACKOVERFLOW
@@ -63,12 +66,10 @@ unsigned int  do_IRQ(int irq, struct pt_
 			       sp - sizeof(struct thread_info));
 	}
 #endif
-
-	__do_IRQ(irq, regs);
+	desc->handle_irq(irq, desc);
 
 	irq_exit();
-
-	return 1;
+	set_irq_regs(old_regs);
 }
 
 /*
@@ -118,72 +119,68 @@ skip:
 	}
 	return 0;
 }
-/* shutdown is same as "disable" */
-#define shutdown_xtensa_irq disable_xtensa_irq
 
-static unsigned int startup_xtensa_irq(unsigned int irq)
-{
-	enable_xtensa_irq(irq);
-	return 0;               /* never anything pending */
-}
-
-static struct hw_interrupt_type xtensa_irq_type = {
-	"Xtensa-IRQ",
-	startup_xtensa_irq,
-	shutdown_xtensa_irq,
-	enable_xtensa_irq,
-	disable_xtensa_irq,
-	mask_and_ack_xtensa,
-	end_xtensa_irq
-};
-
-static inline void mask_irq(unsigned int irq)
+static void xtensa_irq_mask(unsigned int irq)
 {
 	cached_irq_mask &= ~(1 << irq);
 	set_sr (cached_irq_mask, INTENABLE);
 }
 
-static inline void unmask_irq(unsigned int irq)
+static void xtensa_irq_unmask(unsigned int irq)
 {
 	cached_irq_mask |= 1 << irq;
 	set_sr (cached_irq_mask, INTENABLE);
 }
 
-static void disable_xtensa_irq(unsigned int irq)
+static void xtensa_irq_ack(unsigned int irq)
 {
-	unsigned long flags;
-	local_save_flags(flags);
-	mask_irq(irq);
-	local_irq_restore(flags);
+	set_sr(1 << irq, INTCLEAR);
 }
 
-static void enable_xtensa_irq(unsigned int irq)
+static int xtensa_irq_retrigger(unsigned int irq)
 {
-	unsigned long flags;
-	local_save_flags(flags);
-	unmask_irq(irq);
-	local_irq_restore(flags);
-}
-
-static void mask_and_ack_xtensa(unsigned int irq)
-{
-        disable_xtensa_irq(irq);
+	set_sr (1 << irq, INTSET);
+	return 1;
 }
 
-static void end_xtensa_irq(unsigned int irq)
-{
-        enable_xtensa_irq(irq);
-}
 
+static struct irq_chip xtensa_irq_chip = {
+	.name		= "xtensa",
+	.mask		= xtensa_irq_mask,
+	.unmask		= xtensa_irq_unmask,
+	.ack		= xtensa_irq_ack,
+	.retrigger	= xtensa_irq_retrigger,
+};
 
 void __init init_IRQ(void)
 {
-	int i;
+	int index;
 
-	for (i=0; i < XTENSA_NR_IRQS; i++)
-		irq_desc[i].chip = &xtensa_irq_type;
+	for (index = 0; index < XTENSA_NR_IRQS; index++) {
+		int mask = 1 << index;
 
-	cached_irq_mask = 0;
+		if (mask & XCHAL_INTTYPE_MASK_SOFTWARE)
+			set_irq_chip_and_handler(index, &xtensa_irq_chip,
+						 handle_simple_irq);
 
-	platform_init_irq();
+		else if (mask & XCHAL_INTTYPE_MASK_EXTERN_EDGE)
+			set_irq_chip_and_handler(index, &xtensa_irq_chip,
+						 handle_edge_irq);
+
+		else if (mask & XCHAL_INTTYPE_MASK_EXTERN_LEVEL)
+			set_irq_chip_and_handler(index, &xtensa_irq_chip,
+						 handle_level_irq);
+
+		else if (mask & XCHAL_INTTYPE_MASK_TIMER)
+			set_irq_chip_and_handler(index, &xtensa_irq_chip,
+						 handle_edge_irq);
+
+		else	/* XCHAL_INTTYPE_MASK_WRITE_ERROR */
+			/* XCHAL_INTTYPE_MASK_NMI */
+
+			set_irq_chip_and_handler(index, &xtensa_irq_chip,
+						 handle_level_irq);
+	}
+
+	cached_irq_mask = 0;
 }
diff -puN arch/xtensa/kernel/time.c~xtensa-fix-irq-and-misc-fixes arch/xtensa/kernel/time.c
--- a/arch/xtensa/kernel/time.c~xtensa-fix-irq-and-misc-fixes
+++ a/arch/xtensa/kernel/time.c
@@ -47,7 +47,7 @@ unsigned long long sched_clock(void)
 	return (unsigned long long)jiffies * (1000000000 / HZ);
 }
 
-static irqreturn_t timer_interrupt(int irq, void *dev_id, struct pt_regs *regs);
+static irqreturn_t timer_interrupt(int irq, void *dev_id);
 static struct irqaction timer_irqaction = {
 	.handler =	timer_interrupt,
 	.flags =	IRQF_DISABLED,
@@ -150,7 +150,7 @@ EXPORT_SYMBOL(do_gettimeofday);
  * The timer interrupt is called HZ times per second.
  */
 
-irqreturn_t timer_interrupt (int irq, void *dev_id, struct pt_regs *regs)
+irqreturn_t timer_interrupt (int irq, void *dev_id)
 {
 
 	unsigned long next;
@@ -160,9 +160,9 @@ irqreturn_t timer_interrupt (int irq, vo
 again:
 	while ((signed long)(get_ccount() - next) > 0) {
 
-		profile_tick(CPU_PROFILING, regs);
+		profile_tick(CPU_PROFILING);
 #ifndef CONFIG_SMP
-		update_process_times(user_mode(regs));
+		update_process_times(user_mode(get_irq_regs()));
 #endif
 
 		write_seqlock(&xtime_lock);
diff -puN arch/xtensa/kernel/vmlinux.lds.S~xtensa-fix-irq-and-misc-fixes arch/xtensa/kernel/vmlinux.lds.S
--- a/arch/xtensa/kernel/vmlinux.lds.S~xtensa-fix-irq-and-misc-fixes
+++ a/arch/xtensa/kernel/vmlinux.lds.S
@@ -17,6 +17,7 @@
 #include <asm-generic/vmlinux.lds.h>
 
 #define _NOCLANGUAGE
+#undef __ASSEMBLER__
 #include <xtensa/config/core.h>
 #include <xtensa/config/system.h>
 OUTPUT_ARCH(xtensa)
diff -puN include/asm-xtensa/bug.h~xtensa-fix-irq-and-misc-fixes include/asm-xtensa/bug.h
--- a/include/asm-xtensa/bug.h~xtensa-fix-irq-and-misc-fixes
+++ a/include/asm-xtensa/bug.h
@@ -13,29 +13,6 @@
 #ifndef _XTENSA_BUG_H
 #define _XTENSA_BUG_H
 
-#include <linux/stringify.h>
-
-#define ILL	__asm__ __volatile__ (".byte 0,0,0\n")
-
-#ifdef CONFIG_KALLSYMS
-# define BUG() do {							\
-	printk("kernel BUG at %s:%d!\n", __FILE__, __LINE__);		\
-	ILL;								\
-} while (0)
-#else
-# define BUG() do {							\
-	printk("kernel BUG!\n");					\
-      	ILL;								\
-} while (0)
-#endif
-
-#define BUG_ON(condition) do { if (unlikely((condition)!=0)) BUG(); } while(0)
-#define PAGE_BUG(page) do {  BUG(); } while (0)
-#define WARN_ON(condition) do {						   \
-  if (unlikely((condition)!=0)) {					   \
-    printk ("Warning in %s at %s:%d\n", __FUNCTION__, __FILE__, __LINE__); \
-      dump_stack();							   \
-  }									   \
-} while (0)
+#include <asm-generic/bug.h>
 
 #endif	/* _XTENSA_BUG_H */
diff -puN include/asm-xtensa/byteorder.h~xtensa-fix-irq-and-misc-fixes include/asm-xtensa/byteorder.h
--- a/include/asm-xtensa/byteorder.h~xtensa-fix-irq-and-misc-fixes
+++ a/include/asm-xtensa/byteorder.h
@@ -14,7 +14,7 @@
 #include <asm/processor.h>
 #include <asm/types.h>
 
-static __inline__ __const__ __u32 ___arch__swab32(__u32 x)
+static __inline__ __attribute_const__ __u32 ___arch__swab32(__u32 x)
 {
     __u32 res;
     /* instruction sequence from Xtensa ISA release 2/2000 */
@@ -29,7 +29,7 @@ static __inline__ __const__ __u32 ___arc
     return res;
 }
 
-static __inline__ __const__ __u16 ___arch__swab16(__u16 x)
+static __inline__ __attribute_const__ __u16 ___arch__swab16(__u16 x)
 {
     /* Given that 'short' values are signed (i.e., can be negative),
      * we cannot assume that the upper 16-bits of the register are
diff -puN /dev/null include/asm-xtensa/irq_regs.h
--- /dev/null
+++ a/include/asm-xtensa/irq_regs.h
@@ -0,0 +1 @@
+#include <asm-generic/irq_regs.h>
diff -puN include/asm-xtensa/unistd.h~xtensa-fix-irq-and-misc-fixes include/asm-xtensa/unistd.h
--- a/include/asm-xtensa/unistd.h~xtensa-fix-irq-and-misc-fixes
+++ a/include/asm-xtensa/unistd.h
@@ -218,6 +218,8 @@
 
 #define SYSXTENSA_COUNT		   5	/* count of syscall0 functions*/
 
+#ifdef __KERNEL__
+
 /*
  * "Conditional" syscalls
  *
@@ -230,6 +232,7 @@
 #define __ARCH_WANT_SYS_UTIME
 #define __ARCH_WANT_SYS_LLSEEK
 #define __ARCH_WANT_SYS_RT_SIGACTION
+
 #endif /* __KERNEL__ */
 
 #endif	/* _XTENSA_UNISTD_H */
diff -puN include/asm-xtensa/xtensa/config-linux_be/tie.h~xtensa-fix-irq-and-misc-fixes include/asm-xtensa/xtensa/config-linux_be/tie.h
--- a/include/asm-xtensa/xtensa/config-linux_be/tie.h~xtensa-fix-irq-and-misc-fixes
+++ a/include/asm-xtensa/xtensa/config-linux_be/tie.h
@@ -115,7 +115,7 @@
 /* ... */
 
 
-#ifdef _ASMLANGUAGE
+#ifdef __ASSEMBLER__
 /*
  *  Assembly-language specific definitions (assembly macros, etc.).
  */
_

Patches currently in -mm which might be from czankel@tensilica.com are

xtensa-fix-irq-and-misc-fixes.patch

