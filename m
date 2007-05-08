From: akpm@linux-foundation.org
Subject: - h8300-generic-irq.patch removed from -mm tree
Date: Mon, 07 May 2007 17:04:58 -0700
Message-ID: <200705080004.l4804w2g009054@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:56139 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967374AbXEHAFo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:05:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ysato@users.sourceforge.jp, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     h8300 generic irq
has been removed from the -mm tree.  Its filename was
     h8300-generic-irq.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: h8300 generic irq
From: Yoshinori Sato <ysato@users.sourceforge.jp>

h8300 using generic irq handler patch.

Signed-off-by: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/h8300/Kconfig                          |    4 
 arch/h8300/Makefile                         |    2 
 arch/h8300/kernel/Makefile                  |    6 
 arch/h8300/kernel/irq.c                     |  211 ++++++++++++++++++
 arch/h8300/kernel/setup.c                   |    3 
 arch/h8300/kernel/time.c                    |    2 
 arch/h8300/mm/kmap.c                        |    4 
 arch/h8300/platform/h8300h/Makefile         |    2 
 arch/h8300/platform/h8300h/entry.S          |    4 
 arch/h8300/platform/h8300h/generic/Makefile |    2 
 arch/h8300/platform/h8300h/ints_h8300h.c    |   85 -------
 arch/h8300/platform/h8s/entry.S             |   17 -
 include/asm-h8300/irq.h                     |    1 
 include/asm-h8300/irq_regs.h                |    1 
 include/asm-h8300/pgtable.h                 |    1 
 15 files changed, 237 insertions(+), 108 deletions(-)

diff -puN arch/h8300/Kconfig~h8300-generic-irq arch/h8300/Kconfig
--- a/arch/h8300/Kconfig~h8300-generic-irq
+++ a/arch/h8300/Kconfig
@@ -49,6 +49,10 @@ config GENERIC_HWEIGHT
 	bool
 	default y
 
+config GENERIC_HARDIRQS
+	bool
+	default y
+
 config GENERIC_CALIBRATE_DELAY
 	bool
 	default y
diff -puN arch/h8300/Makefile~h8300-generic-irq arch/h8300/Makefile
--- a/arch/h8300/Makefile~h8300-generic-irq
+++ a/arch/h8300/Makefile
@@ -41,7 +41,7 @@ LDFLAGS += $(ldflags-y)
 CROSS_COMPILE = h8300-elf-
 LIBGCC := $(shell $(CROSS-COMPILE)$(CC) $(CFLAGS) -print-libgcc-file-name)
 
-head-y := arch/$(ARCH)/platform/$(platform-y)/$(board-y)/crt0_$(model-y).o
+head-y := arch/$(ARCH)/platform/$(PLATFORM)/$(BOARD)/crt0_$(MODEL).o
 
 core-y	+= arch/$(ARCH)/kernel/ \
 	   arch/$(ARCH)/mm/
diff -puN arch/h8300/kernel/Makefile~h8300-generic-irq arch/h8300/kernel/Makefile
--- a/arch/h8300/kernel/Makefile~h8300-generic-irq
+++ a/arch/h8300/kernel/Makefile
@@ -4,10 +4,8 @@
 
 extra-y := vmlinux.lds
 
-obj-y := process.o traps.o ptrace.o ints.o \
+obj-y := process.o traps.o ptrace.o irq.o \
 	 sys_h8300.o time.o semaphore.o signal.o \
-         setup.o gpio.o init_task.o syscalls.o devres.o
-
-devres-y = ../../../kernel/irq/devres.o
+         setup.o gpio.o init_task.o syscalls.o
 
 obj-$(CONFIG_MODULES) += module.o h8300_ksyms.o 
diff -puN /dev/null arch/h8300/kernel/irq.c
--- /dev/null
+++ a/arch/h8300/kernel/irq.c
@@ -0,0 +1,211 @@
+/*
+ * linux/arch/h8300/kernel/irq.c
+ *
+ * Copyright 2007 Yoshinori Sato <ysato@users.sourceforge.jp>
+ */
+
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/sched.h>
+#include <linux/kernel_stat.h>
+#include <linux/seq_file.h>
+#include <linux/init.h>
+#include <linux/random.h>
+#include <linux/bootmem.h>
+#include <linux/irq.h>
+
+#include <asm/system.h>
+#include <asm/traps.h>
+#include <asm/io.h>
+#include <asm/setup.h>
+#include <asm/errno.h>
+
+/*#define DEBUG*/
+
+extern unsigned long *interrupt_redirect_table;
+extern const int h8300_saved_vectors[];
+extern const unsigned long h8300_trap_table[];
+int h8300_enable_irq_pin(unsigned int irq);
+void h8300_disable_irq_pin(unsigned int irq);
+
+#define CPU_VECTOR ((unsigned long *)0x000000)
+#define ADDR_MASK (0xffffff)
+
+static inline int is_ext_irq(unsigned int irq)
+{
+	return (irq >= EXT_IRQ0 && irq <= (EXT_IRQ0 + EXT_IRQS));
+}
+
+static void h8300_enable_irq(unsigned int irq)
+{
+	if (is_ext_irq(irq))
+		IER_REGS |= 1 << (irq - EXT_IRQ0);
+}
+
+static void h8300_disable_irq(unsigned int irq)
+{
+	if (is_ext_irq(irq))
+		IER_REGS &= ~(1 << (irq - EXT_IRQ0));
+}
+
+static void h8300_end_irq(unsigned int irq)
+{
+}
+
+static unsigned int h8300_startup_irq(unsigned int irq)
+{
+	if (is_ext_irq(irq))
+		return h8300_enable_irq_pin(irq);
+	else
+		return 0;
+}
+
+static void h8300_shutdown_irq(unsigned int irq)
+{
+	if (is_ext_irq(irq))
+		h8300_disable_irq_pin(irq);
+}
+
+/*
+ * h8300 interrupt controler implementation
+ */
+struct irq_chip h8300irq_chip = {
+	.name		= "H8300-INTC",
+	.startup	= h8300_startup_irq,
+	.shutdown	= h8300_shutdown_irq,
+	.enable		= h8300_enable_irq,
+	.disable	= h8300_disable_irq,
+	.ack		= NULL,
+	.end		= h8300_end_irq,
+};
+
+void ack_bad_irq(unsigned int irq)
+{
+	printk("unexpected IRQ trap at vector %02x\n", irq);
+}
+
+#if defined(CONFIG_RAMKERNEL)
+static unsigned long __init *get_vector_address(void)
+{
+	unsigned long *rom_vector = CPU_VECTOR;
+	unsigned long base,tmp;
+	int vec_no;
+
+	base = rom_vector[EXT_IRQ0] & ADDR_MASK;
+
+	/* check romvector format */
+	for (vec_no = EXT_IRQ1; vec_no <= EXT_IRQ0+EXT_IRQS; vec_no++) {
+		if ((base+(vec_no - EXT_IRQ0)*4) != (rom_vector[vec_no] & ADDR_MASK))
+			return NULL;
+	}
+
+	/* ramvector base address */
+	base -= EXT_IRQ0*4;
+
+	/* writerble check */
+	tmp = ~(*(volatile unsigned long *)base);
+	(*(volatile unsigned long *)base) = tmp;
+	if ((*(volatile unsigned long *)base) != tmp)
+		return NULL;
+	return (unsigned long *)base;
+}
+
+static void __init setup_vector(void)
+{
+	int i;
+	unsigned long *ramvec,*ramvec_p;
+	const unsigned long *trap_entry;
+	const int *saved_vector;
+
+	ramvec = get_vector_address();
+	if (ramvec == NULL)
+		panic("interrupt vector serup failed.");
+	else
+		printk(KERN_INFO "virtual vector at 0x%08lx\n",(unsigned long)ramvec);
+
+	/* create redirect table */
+	ramvec_p = ramvec;
+	trap_entry = h8300_trap_table;
+	saved_vector = h8300_saved_vectors;
+	for ( i = 0; i < NR_IRQS; i++) {
+		if (i == *saved_vector) {
+			ramvec_p++;
+			saved_vector++;
+		} else {
+			if ( i < NR_TRAPS ) {
+				if (*trap_entry)
+					*ramvec_p = VECTOR(*trap_entry);
+				ramvec_p++;
+				trap_entry++;
+			} else
+				*ramvec_p++ = REDIRECT(interrupt_entry);
+		}
+	}
+	interrupt_redirect_table = ramvec;
+#ifdef DEBUG
+	ramvec_p = ramvec;
+	for (i = 0; i < NR_IRQS; i++) {
+		if ((i % 8) == 0)
+			printk(KERN_DEBUG "\n%p: ",ramvec_p);
+		printk(KERN_DEBUG "%p ",*ramvec_p);
+		ramvec_p++;
+	}
+	printk(KERN_DEBUG "\n");
+#endif
+}
+#else
+#define setup_vector() do { } while(0)
+#endif
+
+void __init init_IRQ(void)
+{
+	int c;
+
+	setup_vector();
+
+	for (c = 0; c < NR_IRQS; c++) {
+		irq_desc[c].status = IRQ_DISABLED;
+		irq_desc[c].action = NULL;
+		irq_desc[c].depth = 1;
+		irq_desc[c].chip = &h8300irq_chip;
+	}
+}
+
+asmlinkage void do_IRQ(int irq)
+{
+	irq_enter();
+	__do_IRQ(irq);
+	irq_exit();
+}
+
+#if defined(CONFIG_PROC_FS)
+int show_interrupts(struct seq_file *p, void *v)
+{
+	int i = *(loff_t *) v, j;
+	struct irqaction * action;
+	unsigned long flags;
+
+	if (i == 0)
+		seq_puts(p, "           CPU0");
+
+	if (i < NR_IRQS) {
+		spin_lock_irqsave(&irq_desc[i].lock, flags);
+		action = irq_desc[i].action;
+		if (!action)
+			goto unlock;
+		seq_printf(p, "%3d: ",i);
+		seq_printf(p, "%10u ", kstat_cpu(j).irqs[i]);
+		seq_printf(p, " %14s", irq_desc[i].chip->name);
+		seq_printf(p, "-%-8s", irq_desc[i].name);
+		seq_printf(p, "  %s", action->name);
+
+		for (action=action->next; action; action = action->next)
+			seq_printf(p, ", %s", action->name);
+		seq_putc(p, '\n');
+unlock:
+		spin_unlock_irqrestore(&irq_desc[i].lock, flags);
+	}
+	return 0;
+}
+#endif
diff -puN arch/h8300/kernel/setup.c~h8300-generic-irq arch/h8300/kernel/setup.c
--- a/arch/h8300/kernel/setup.c~h8300-generic-irq
+++ a/arch/h8300/kernel/setup.c
@@ -33,10 +33,7 @@
 
 #include <asm/setup.h>
 #include <asm/irq.h>
-
-#ifdef CONFIG_BLK_DEV_INITRD
 #include <asm/pgtable.h>
-#endif
 
 #if defined(__H8300H__)
 #define CPU "H8/300H"
diff -puN arch/h8300/kernel/time.c~h8300-generic-irq arch/h8300/kernel/time.c
--- a/arch/h8300/kernel/time.c~h8300-generic-irq
+++ a/arch/h8300/kernel/time.c
@@ -44,7 +44,7 @@ static void timer_interrupt(int irq, voi
 #ifndef CONFIG_SMP
 	update_process_times(user_mode(regs));
 #endif
-	profile_tick(CPU_PROFILING, regs);
+	profile_tick(CPU_PROFILING);
 }
 
 void time_init(void)
diff -puN arch/h8300/mm/kmap.c~h8300-generic-irq arch/h8300/mm/kmap.c
--- a/arch/h8300/mm/kmap.c~h8300-generic-irq
+++ a/arch/h8300/mm/kmap.c
@@ -24,12 +24,14 @@
 
 #undef DEBUG
 
+#define VIRT_OFFSET (0x01000000)
+
 /*
  * Map some physical address range into the kernel address space.
  */
 void *__ioremap(unsigned long physaddr, unsigned long size, int cacheflag)
 {
-	return (void *)physaddr;
+	return (void *)(physaddr + VIRT_OFFSET);
 }
 
 /*
diff -puN arch/h8300/platform/h8300h/Makefile~h8300-generic-irq arch/h8300/platform/h8300h/Makefile
--- a/arch/h8300/platform/h8300h/Makefile~h8300-generic-irq
+++ a/arch/h8300/platform/h8300h/Makefile
@@ -4,4 +4,4 @@
 # Reuse any files we can from the H8/300H
 #
 
-obj-y := entry.o ints_h8300h.o ptrace_h8300h.o
+obj-y := entry.o irq_pin.o ptrace_h8300h.o
diff -puN arch/h8300/platform/h8300h/entry.S~h8300-generic-irq arch/h8300/platform/h8300h/entry.S
--- a/arch/h8300/platform/h8300h/entry.S~h8300-generic-irq
+++ a/arch/h8300/platform/h8300h/entry.S
@@ -30,12 +30,12 @@
 	mov.l	er0,@-sp
 
 	stc	ccr,r0l				/* check kernel mode */
-	orc	#0x10,ccr
 	btst	#4,r0l
 	bne	5f
 
 	mov.l	sp,@SYMBOL_NAME(sw_usp)		/* user mode */
 	mov.l	@sp,er0
+	orc	#0x10,ccr
 	mov.l	@SYMBOL_NAME(sw_ksp),sp
 	sub.l	#(LRET-LORIG),sp		/* allocate LORIG - LRET */ 
 	mov.l	er0,@-sp
@@ -165,7 +165,7 @@ SYMBOL_NAME_LABEL(interrupt_entry)
 	dec.l	#1,er0
 	mov.l	sp,er1
 	subs	#4,er1				/* adjust ret_pc */
-	jsr	@SYMBOL_NAME(process_int)
+	jsr	@SYMBOL_NAME(do_IRQ)
 	mov.l	@SYMBOL_NAME(irq_stat)+CPUSTAT_SOFTIRQ_PENDING,er0
 	beq	1f
 	jsr	@SYMBOL_NAME(do_softirq)
diff -puN arch/h8300/platform/h8300h/generic/Makefile~h8300-generic-irq arch/h8300/platform/h8300h/generic/Makefile
--- a/arch/h8300/platform/h8300h/generic/Makefile~h8300-generic-irq
+++ a/arch/h8300/platform/h8300h/generic/Makefile
@@ -2,5 +2,5 @@
 # Makefile for the linux kernel.
 #
 
+extra-y :=  crt0_$(MODEL).o
 obj-y := timer.o
-extra-y =  crt0_$(MODEL).o
diff -puN arch/h8300/platform/h8300h/ints_h8300h.c~h8300-generic-irq /dev/null
--- a/arch/h8300/platform/h8300h/ints_h8300h.c
+++ /dev/null
@@ -1,85 +0,0 @@
-/*
- * linux/arch/h8300/platform/h8300h/ints_h8300h.c
- * Interrupt handling CPU variants
- *
- * Yoshinori Sato <ysato@users.sourceforge.jp>
- *
- */
-
-#include <linux/init.h>
-#include <linux/errno.h>
-
-#include <asm/ptrace.h>
-#include <asm/traps.h>
-#include <asm/irq.h>
-#include <asm/io.h>
-#include <asm/gpio.h>
-#include <asm/regs306x.h>
-
-/* saved vector list */
-const int __initdata h8300_saved_vectors[]={
-#if defined(CONFIG_GDB_DEBUG)
-	TRAP3_VEC,
-#endif
-	-1
-};
-
-/* trap entry table */
-const unsigned long __initdata h8300_trap_table[NR_TRAPS]={
-	0,0,0,0,0,0,0,0,
-	(unsigned long)system_call,  /* TRAPA #0 */
-	0,0,
-	(unsigned long)trace_break,  /* TRAPA #3 */
-};
-
-int h8300_enable_irq_pin(unsigned int irq)
-{
-	int bitmask;
-	if (irq < EXT_IRQ0 || irq > EXT_IRQ5)
-		return 0;
-
-	/* initialize IRQ pin */
-	bitmask = 1 << (irq - EXT_IRQ0);
-	switch(irq) {
-	case EXT_IRQ0:
-	case EXT_IRQ1:
-	case EXT_IRQ2:
-	case EXT_IRQ3:
-		if (H8300_GPIO_RESERVE(H8300_GPIO_P8, bitmask) == 0)
-			return -EBUSY;
-		H8300_GPIO_DDR(H8300_GPIO_P8, bitmask, H8300_GPIO_INPUT);
-		break;
-	case EXT_IRQ4:
-	case EXT_IRQ5:
-		if (H8300_GPIO_RESERVE(H8300_GPIO_P9, bitmask) == 0)
-			return -EBUSY;
-		H8300_GPIO_DDR(H8300_GPIO_P9, bitmask, H8300_GPIO_INPUT);
-		break;
-	}
-
-	return 0;
-}
-
-void h8300_disable_irq_pin(unsigned int irq)
-{
-	int bitmask;
-	if (irq < EXT_IRQ0 || irq > EXT_IRQ5)
-		return;
-
-	/* disable interrupt & release IRQ pin */
-	bitmask = 1 << (irq - EXT_IRQ0);
-	switch(irq) {
-	case EXT_IRQ0:
-	case EXT_IRQ1:
-	case EXT_IRQ2:
-	case EXT_IRQ3:
-		*(volatile unsigned char *)IER &= ~bitmask;
-		H8300_GPIO_FREE(H8300_GPIO_P8, bitmask);
-		break ;
-	case EXT_IRQ4:
-	case EXT_IRQ5:
-		*(volatile unsigned char *)IER &= ~bitmask;
-		H8300_GPIO_FREE(H8300_GPIO_P9, bitmask);
-		break;
-	}
-}
diff -puN arch/h8300/platform/h8s/entry.S~h8300-generic-irq arch/h8300/platform/h8s/entry.S
--- a/arch/h8300/platform/h8s/entry.S~h8300-generic-irq
+++ a/arch/h8300/platform/h8s/entry.S
@@ -31,12 +31,13 @@
 	mov.l	er0,@-sp
 
 	stc	ccr,r0l				/* check kernel mode */
-	orc	#0x10,ccr
 	btst	#4,r0l
 	bne	5f
 
-	mov.l	sp,@SYMBOL_NAME(sw_usp)		/* user mode */
-	mov.l	@sp,er0
+	/* user mode */
+	mov.l	sp,@SYMBOL_NAME(sw_usp)
+	mov.l	@sp,er0				/* restore saved er0 */
+	orc	#0x10,ccr			/* switch kernel stack */
 	mov.l	@SYMBOL_NAME(sw_ksp),sp
 	sub.l	#(LRET-LORIG),sp		/* allocate LORIG - LRET */ 
 	stm.l	er0-er3,@-sp
@@ -55,8 +56,9 @@
 	mov.l	er0,@(LER0-LER3:16,sp)		/* copy ER0 */
 	bra	6f
 5:
-	mov.l	@sp,er0				/* kernel mode */
-	subs	#2,sp				/* dummy ccr */
+	/* kernel mode */
+	mov.l	@sp,er0				/* restore saved er0 */
+	subs	#2,sp				/* set dummy ccr */
 	stm.l	er0-er3,@-sp
 	mov.w	@(LRET-LER3:16,sp),r1		/* copy old ccr */
 	mov.b	r1h,r1l
@@ -94,6 +96,7 @@
 	mov.l	@sp+,er1
 	add.l	#(LRET-LER1),sp			/* remove LORIG - LRET */ 
 	mov.l	sp,@SYMBOL_NAME(sw_ksp)
+	andc	#0xef,ccr			/* switch to user mode */
 	mov.l	er0,sp
 	bra	8f
 7:
@@ -173,9 +176,6 @@ SYMBOL_NAME_LABEL(interrupt_entry)
 SYMBOL_NAME_LABEL(system_call)
 	subs	#4,sp				/* dummy LVEC */
 	SAVE_ALL
-	mov.w	@(LCCR:16,sp),r1
-	bset	#4,r1l
-	ldc	r1l,ccr				/* restore ccr */
 	mov.l	er0,er4
 	mov.l	#-ENOSYS,er0
 	mov.l	er0,@(LER0:16,sp)
@@ -198,6 +198,7 @@ SYMBOL_NAME_LABEL(system_call)
 	mov.l	@(LER1:16,sp),er0
 	mov.l	@(LER2:16,sp),er1
 	mov.l	@(LER3:16,sp),er2
+	andc	#0x7f,ccr
 	jsr	@er4
 	mov.l	er0,@(LER0:16,sp)			/* save the return value */
 #if defined(CONFIG_SYSCALL_PRINT)
diff -puN include/asm-h8300/irq.h~h8300-generic-irq include/asm-h8300/irq.h
--- a/include/asm-h8300/irq.h~h8300-generic-irq
+++ a/include/asm-h8300/irq.h
@@ -61,6 +61,5 @@ static __inline__ int irq_canonicalize(i
 
 extern void enable_irq(unsigned int);
 extern void disable_irq(unsigned int);
-#define disable_irq_nosync(x)	disable_irq(x)
 
 #endif /* _H8300_IRQ_H_ */
diff -puN /dev/null include/asm-h8300/irq_regs.h
--- /dev/null
+++ a/include/asm-h8300/irq_regs.h
@@ -0,0 +1 @@
+#include <asm-generic/irq_regs.h>
diff -puN include/asm-h8300/pgtable.h~h8300-generic-irq include/asm-h8300/pgtable.h
--- a/include/asm-h8300/pgtable.h~h8300-generic-irq
+++ a/include/asm-h8300/pgtable.h
@@ -73,4 +73,5 @@ extern int is_in_rom(unsigned long);
 #define	VMALLOC_START	0
 #define	VMALLOC_END	0xffffffff
 
+#define arch_enter_lazy_cpu_mode()    do {} while (0)
 #endif /* _H8300_PGTABLE_H */
_

Patches currently in -mm which might be from ysato@users.sourceforge.jp are

origin.patch
