From: akpm@linux-foundation.org
Subject: - m68knommu-generic-irq-handling.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:04:19 -0700
Message-ID: <200707192004.l6JK4J1o019941@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34272 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761882AbXGSU1X (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:27:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gerg@snapgear.com, gerg@uclinux.org, mm-commits@vger.kernel.org


The patch titled
     m68knommu: generic irq handling
has been removed from the -mm tree.  Its filename was
     m68knommu-generic-irq-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: m68knommu: generic irq handling
From: Greg Ungerer <gerg@snapgear.com>

Change the m68knommu irq handling to use the generic irq framework.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68knommu/Kconfig                 |    4 
 arch/m68knommu/kernel/Makefile         |    4 
 arch/m68knommu/kernel/asm-offsets.c    |    5 
 arch/m68knommu/kernel/irq.c            |   82 ++++++
 arch/m68knommu/kernel/traps.c          |    2 
 arch/m68knommu/platform/5307/Makefile  |    2 
 arch/m68knommu/platform/5307/entry.S   |   42 ---
 arch/m68knommu/platform/5307/ints.c    |  279 -----------------------
 arch/m68knommu/platform/5307/vectors.c |   29 +-
 arch/m68knommu/platform/68328/entry.S  |   10 
 arch/m68knommu/platform/68328/ints.c   |  130 +---------
 arch/m68knommu/platform/68360/entry.S  |    6 
 arch/m68knommu/platform/68360/ints.c   |  233 +------------------
 include/asm-m68knommu/irq.h            |   75 ------
 include/asm-m68knommu/irqnode.h        |   36 --
 include/asm-m68knommu/m68360.h         |    8 
 include/asm-m68knommu/traps.h          |    4 
 17 files changed, 172 insertions(+), 779 deletions(-)

diff -puN arch/m68knommu/Kconfig~m68knommu-generic-irq-handling arch/m68knommu/Kconfig
--- a/arch/m68knommu/Kconfig~m68knommu-generic-irq-handling
+++ a/arch/m68knommu/Kconfig
@@ -45,6 +45,10 @@ config GENERIC_HWEIGHT
 	bool
 	default y
 
+config GENERIC_HARDIRQS
+	bool
+	default y
+
 config GENERIC_CALIBRATE_DELAY
 	bool
 	default y
diff -puN arch/m68knommu/kernel/Makefile~m68knommu-generic-irq-handling arch/m68knommu/kernel/Makefile
--- a/arch/m68knommu/kernel/Makefile~m68knommu-generic-irq-handling
+++ a/arch/m68knommu/kernel/Makefile
@@ -4,8 +4,8 @@
 
 extra-y := vmlinux.lds
 
-obj-y += dma.o entry.o init_task.o m68k_ksyms.o process.o ptrace.o semaphore.o \
-	 setup.o signal.o syscalltable.o sys_m68k.o time.o traps.o
+obj-y += dma.o entry.o init_task.o irq.o m68k_ksyms.o process.o ptrace.o \
+	 semaphore.o setup.o signal.o syscalltable.o sys_m68k.o time.o traps.o
 
 obj-$(CONFIG_MODULES)	+= module.o
 obj-$(CONFIG_COMEMPCI)	+= comempci.o
diff -puN arch/m68knommu/kernel/asm-offsets.c~m68knommu-generic-irq-handling arch/m68knommu/kernel/asm-offsets.c
--- a/arch/m68knommu/kernel/asm-offsets.c~m68knommu-generic-irq-handling
+++ a/arch/m68knommu/kernel/asm-offsets.c
@@ -15,7 +15,6 @@
 #include <linux/hardirq.h>
 #include <asm/bootinfo.h>
 #include <asm/irq.h>
-#include <asm/irqnode.h>
 #include <asm/thread_info.h>
 
 #define DEFINE(sym, val) \
@@ -72,10 +71,6 @@ int main(void)
 #else
 	/* bitfields are a bit difficult */
 	DEFINE(PT_VECTOR, offsetof(struct pt_regs, pc) + 4);
-	/* offsets into the irq_handler struct */
-	DEFINE(IRQ_HANDLER, offsetof(struct irq_node, handler));
-	DEFINE(IRQ_DEVID, offsetof(struct irq_node, dev_id));
-	DEFINE(IRQ_NEXT, offsetof(struct irq_node, next));
 #endif
 
 	/* offsets into the kernel_stat struct */
diff -puN /dev/null arch/m68knommu/kernel/irq.c
--- /dev/null
+++ a/arch/m68knommu/kernel/irq.c
@@ -0,0 +1,82 @@
+/*
+ * irq.c
+ *
+ * (C) Copyright 2007, Greg Ungerer <gerg@snapgear.com>
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file COPYING in the main directory of this archive
+ * for more details.
+ */
+
+#include <linux/types.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/kernel_stat.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <linux/seq_file.h>
+#include <asm/system.h>
+#include <asm/traps.h>
+
+asmlinkage void do_IRQ(int irq, struct pt_regs *regs)
+{
+	struct pt_regs *oldregs = set_irq_regs(regs);
+
+	irq_enter();
+	__do_IRQ(irq);
+	irq_exit();
+
+	set_irq_regs(oldregs);
+}
+
+void ack_bad_irq(unsigned int irq)
+{
+	printk(KERN_ERR "IRQ: unexpected irq=%d\n", irq);
+}
+
+static struct irq_chip m_irq_chip = {
+	.name		= "M68K-INTC",
+	.enable		= enable_vector,
+	.disable	= disable_vector,
+	.ack		= ack_vector,
+};
+
+void __init init_IRQ(void)
+{
+	int irq;
+
+	init_vectors();
+
+	for (irq = 0; (irq < NR_IRQS); irq++) {
+		irq_desc[irq].status = IRQ_DISABLED;
+		irq_desc[irq].action = NULL;
+		irq_desc[irq].depth = 1;
+		irq_desc[irq].chip = &m_irq_chip;
+	}
+}
+
+int show_interrupts(struct seq_file *p, void *v)
+{
+	struct irqaction *ap;
+	int irq = *((loff_t *) v);
+
+	if (irq == 0)
+		seq_puts(p, "           CPU0\n");
+
+	if (irq < NR_IRQS) {
+		ap = irq_desc[irq].action;
+		if (ap) {
+			seq_printf(p, "%3d: ", irq);
+			seq_printf(p, "%10u ", kstat_irqs(irq));
+			seq_printf(p, "%14s  ", irq_desc[irq].chip->name);
+
+			seq_printf(p, "%s", ap->name);
+			for (ap = ap->next; ap; ap = ap->next)
+				seq_printf(p, ", %s", ap->name);
+			seq_putc(p, '\n');
+		}
+	}
+
+	return 0;
+}
+
diff -puN arch/m68knommu/kernel/traps.c~m68knommu-generic-irq-handling arch/m68knommu/kernel/traps.c
--- a/arch/m68knommu/kernel/traps.c~m68knommu-generic-irq-handling
+++ a/arch/m68knommu/kernel/traps.c
@@ -62,8 +62,6 @@ static char const * const vec_names[] = 
 
 void __init trap_init(void)
 {
-	if (mach_trap_init)
-		mach_trap_init();
 }
 
 void die_if_kernel(char *str, struct pt_regs *fp, int nr)
diff -puN arch/m68knommu/platform/5307/Makefile~m68knommu-generic-irq-handling arch/m68knommu/platform/5307/Makefile
--- a/arch/m68knommu/platform/5307/Makefile~m68knommu-generic-irq-handling
+++ a/arch/m68knommu/platform/5307/Makefile
@@ -16,7 +16,7 @@ ifdef CONFIG_FULLDEBUG
 AFLAGS += -DDEBUGGER_COMPATIBLE_CACHE=1
 endif
 
-obj-$(CONFIG_COLDFIRE)	+= entry.o vectors.o ints.o
+obj-$(CONFIG_COLDFIRE)	+= entry.o vectors.o
 obj-$(CONFIG_M5206)	+= timers.o
 obj-$(CONFIG_M5206e)	+= timers.o
 obj-$(CONFIG_M520x)	+= pit.o
diff -puN arch/m68knommu/platform/5307/entry.S~m68knommu-generic-irq-handling arch/m68knommu/platform/5307/entry.S
--- a/arch/m68knommu/platform/5307/entry.S~m68knommu-generic-irq-handling
+++ a/arch/m68knommu/platform/5307/entry.S
@@ -1,7 +1,7 @@
 /*
  *  linux/arch/m68knommu/platform/5307/entry.S
  *
- *  Copyright (C) 1999-2002, Greg Ungerer (gerg@snapgear.com)
+ *  Copyright (C) 1999-2007, Greg Ungerer (gerg@snapgear.com)
  *  Copyright (C) 1998  D. Jeff Dionne <jeff@lineo.ca>,
  *                      Kenneth Albanowski <kjahds@kjahds.com>,
  *  Copyright (C) 2000  Lineo Inc. (www.lineo.com)
@@ -155,34 +155,21 @@ Lsignal_return:
 
 /*
  * This is the generic interrupt handler (for all hardware interrupt
- * sources). It figures out the vector number and calls the appropriate
- * interrupt service routine directly.
+ * sources). Calls upto high level code to do all the work.
  */
 ENTRY(inthandler)
 	SAVE_ALL
 	moveq	#-1,%d0
 	movel	%d0,%sp@(PT_ORIG_D0)
-	addql	#1,local_irq_count
 
 	movew	%sp@(PT_FORMATVEC),%d0	/* put exception # in d0 */
 	andl	#0x03fc,%d0		/* mask out vector only */
 
-	leal	per_cpu__kstat+STAT_IRQ,%a0
-	addql	#1,%a0@(%d0)
-
+	movel	%sp,%sp@-		/* push regs arg */
 	lsrl	#2,%d0			/* calculate real vector # */
-	movel	%d0,%d1			/* calculate array offset */
-	lsll	#4,%d1
-	lea	irq_list,%a0
-	addl	%d1,%a0			/* pointer to array struct */
-
-	movel	%sp,%sp@-		/* push regs arg onto stack */
-	movel	%a0@(8),%sp@-		/* push devid arg */
-	movel	%d0,%sp@-		/* push vector # on stack */
-
-	movel	%a0@,%a0		/* get function to call */
-	jbsr	%a0@			/* call vector handler */
-	lea	%sp@(12),%sp		/* pop parameters off stack */
+	movel	%d0,%sp@-		/* push vector number */
+	jbsr	do_IRQ			/* call high level irq handler */
+	lea	%sp@(8),%sp		/* pop args off stack */
 
 	bra	ret_from_interrupt	/* this was fallthrough */
 
@@ -198,24 +185,15 @@ ENTRY(fasthandler)
 	movew	%sp@(PT_FORMATVEC),%d0
 	andl	#0x03fc,%d0		/* mask out vector only */
 
-	leal	per_cpu__kstat+STAT_IRQ,%a0
-	addql	#1,%a0@(%d0)
-
-	movel	%sp,%sp@-		/* push regs arg onto stack */
-	clrl	%sp@-			/* push devid arg */
+	movel	%sp,%sp@-		/* push regs arg */
 	lsrl	#2,%d0			/* calculate real vector # */
-	movel	%d0,%sp@-		/* push vector # on stack */
-
-	lsll	#4,%d0			/* adjust for array offset */
-	lea	irq_list,%a0
-	movel	%a0@(%d0),%a0		/* get function to call */
-	jbsr	%a0@			/* call vector handler */
-	lea	%sp@(12),%sp		/* pop parameters off stack */
+	movel	%d0,%sp@-		/* push vector number */
+	jbsr	do_IRQ			/* call high level irq handler */
+	lea	%sp@(8),%sp		/* pop args off stack */
 
 	RESTORE_LOCAL
 
 ENTRY(ret_from_interrupt)
-	subql	#1,local_irq_count
 	jeq	2f
 1:
 	RESTORE_ALL
diff -puN arch/m68knommu/platform/5307/ints.c~m68knommu-generic-irq-handling /dev/null
--- a/arch/m68knommu/platform/5307/ints.c
+++ /dev/null
@@ -1,279 +0,0 @@
-/*
- * linux/arch/m68knommu/kernel/ints.c -- General interrupt handling code
- *
- * Copyright (C) 1999-2002  Greg Ungerer (gerg@snapgear.com)
- * Copyright (C) 1998  D. Jeff Dionne <jeff@lineo.ca>,
- *                     Kenneth Albanowski <kjahds@kjahds.com>,
- * Copyright (C) 2000  Lineo Inc. (www.lineo.com) 
- *
- * Based on:
- *
- * linux/arch/m68k/kernel/ints.c -- Linux/m68k general interrupt handling code
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file COPYING in the main directory of this archive
- * for more details.
- */
-
-#include <linux/module.h>
-#include <linux/types.h>
-#include <linux/init.h>
-#include <linux/sched.h>
-#include <linux/interrupt.h>
-#include <linux/kernel_stat.h>
-#include <linux/errno.h>
-#include <linux/seq_file.h>
-
-#include <asm/system.h>
-#include <asm/irq.h>
-#include <asm/irqnode.h>
-#include <asm/traps.h>
-#include <asm/page.h>
-#include <asm/machdep.h>
-
-/*
- *	This table stores the address info for each vector handler.
- */
-struct irq_entry irq_list[SYS_IRQS];
-
-#define NUM_IRQ_NODES 16
-static irq_node_t nodes[NUM_IRQ_NODES];
-
-/* The number of spurious interrupts */
-volatile unsigned int num_spurious;
-
-unsigned int local_irq_count[NR_CPUS];
-
-static irqreturn_t default_irq_handler(int irq, void *ptr)
-{
-#if 1
-	printk(KERN_INFO "%s(%d): default irq handler vec=%d [0x%x]\n",
-		__FILE__, __LINE__, irq, irq);
-#endif
-	return(IRQ_HANDLED);
-}
-
-/*
- * void init_IRQ(void)
- *
- * Parameters:	None
- *
- * Returns:	Nothing
- *
- * This function should be called during kernel startup to initialize
- * the IRQ handling routines.
- */
-
-void __init init_IRQ(void)
-{
-	int i;
-
-	for (i = 0; i < SYS_IRQS; i++) {
-		if (mach_default_handler)
-			irq_list[i].handler = mach_default_handler;
-		else
-			irq_list[i].handler = default_irq_handler;
-		irq_list[i].flags   = IRQ_FLG_STD;
-		irq_list[i].dev_id  = NULL;
-		irq_list[i].devname = NULL;
-	}
-
-	for (i = 0; i < NUM_IRQ_NODES; i++)
-		nodes[i].handler = NULL;
-
-	if (mach_init_IRQ)
-		mach_init_IRQ();
-}
-
-irq_node_t *new_irq_node(void)
-{
-	irq_node_t *node;
-	short i;
-
-	for (node = nodes, i = NUM_IRQ_NODES-1; i >= 0; node++, i--)
-		if (!node->handler)
-			return node;
-
-	printk(KERN_INFO "new_irq_node: out of nodes\n");
-	return NULL;
-}
-
-int request_irq(
-	unsigned int irq,
-	irq_handler_t handler,
-	unsigned long flags,
-	const char *devname,
-	void *dev_id)
-{
-	if (irq < 0 || irq >= NR_IRQS) {
-		printk(KERN_WARNING "%s: Incorrect IRQ %d from %s\n", __FUNCTION__,
-			irq, devname);
-		return -ENXIO;
-	}
-
-	if (!(irq_list[irq].flags & IRQ_FLG_STD)) {
-		if (irq_list[irq].flags & IRQ_FLG_LOCK) {
-			printk(KERN_WARNING "%s: IRQ %d from %s is not replaceable\n",
-			       __FUNCTION__, irq, irq_list[irq].devname);
-			return -EBUSY;
-		}
-		if (flags & IRQ_FLG_REPLACE) {
-			printk(KERN_WARNING "%s: %s can't replace IRQ %d from %s\n",
-			       __FUNCTION__, devname, irq, irq_list[irq].devname);
-			return -EBUSY;
-		}
-	}
-
-	if (flags & IRQ_FLG_FAST) {
-		extern asmlinkage void fasthandler(void);
-		extern void set_evector(int vecnum, void (*handler)(void));
-		set_evector(irq, fasthandler);
-	}
-
-	irq_list[irq].handler = handler;
-	irq_list[irq].flags   = flags;
-	irq_list[irq].dev_id  = dev_id;
-	irq_list[irq].devname = devname;
-	return 0;
-}
-
-EXPORT_SYMBOL(request_irq);
-
-void free_irq(unsigned int irq, void *dev_id)
-{
-	if (irq >= NR_IRQS) {
-		printk(KERN_WARNING "%s: Incorrect IRQ %d\n", __FUNCTION__, irq);
-		return;
-	}
-
-	if (irq_list[irq].dev_id != dev_id)
-		printk(KERN_WARNING "%s: Removing probably wrong IRQ %d from %s\n",
-		       __FUNCTION__, irq, irq_list[irq].devname);
-
-	if (irq_list[irq].flags & IRQ_FLG_FAST) {
-		extern asmlinkage void inthandler(void);
-		extern void set_evector(int vecnum, void (*handler)(void));
-		set_evector(irq, inthandler);
-	}
-
-	if (mach_default_handler)
-		irq_list[irq].handler = mach_default_handler;
-	else
-		irq_list[irq].handler = default_irq_handler;
-	irq_list[irq].flags   = IRQ_FLG_STD;
-	irq_list[irq].dev_id  = NULL;
-	irq_list[irq].devname = NULL;
-}
-
-EXPORT_SYMBOL(free_irq);
-
-
-int sys_request_irq(unsigned int irq, irq_handler_t handler, 
-                    unsigned long flags, const char *devname, void *dev_id)
-{
-	if (irq > IRQ7) {
-		printk(KERN_WARNING "%s: Incorrect IRQ %d from %s\n",
-		       __FUNCTION__, irq, devname);
-		return -ENXIO;
-	}
-
-#if 0
-	if (!(irq_list[irq].flags & IRQ_FLG_STD)) {
-		if (irq_list[irq].flags & IRQ_FLG_LOCK) {
-			printk(KERN_WARNING "%s: IRQ %d from %s is not replaceable\n",
-			       __FUNCTION__, irq, irq_list[irq].devname);
-			return -EBUSY;
-		}
-		if (!(flags & IRQ_FLG_REPLACE)) {
-			printk(KERN_WARNING "%s: %s can't replace IRQ %d from %s\n",
-			       __FUNCTION__, devname, irq, irq_list[irq].devname);
-			return -EBUSY;
-		}
-	}
-#endif
-
-	irq_list[irq].handler = handler;
-	irq_list[irq].flags   = flags;
-	irq_list[irq].dev_id  = dev_id;
-	irq_list[irq].devname = devname;
-	return 0;
-}
-
-void sys_free_irq(unsigned int irq, void *dev_id)
-{
-	if (irq > IRQ7) {
-		printk(KERN_WARNING "%s: Incorrect IRQ %d\n", __FUNCTION__, irq);
-		return;
-	}
-
-	if (irq_list[irq].dev_id != dev_id)
-		printk(KERN_WARNING "%s: Removing probably wrong IRQ %d from %s\n",
-		       __FUNCTION__, irq, irq_list[irq].devname);
-
-	irq_list[irq].handler = mach_default_handler;
-	irq_list[irq].flags   = 0;
-	irq_list[irq].dev_id  = NULL;
-	irq_list[irq].devname = NULL;
-}
-
-/*
- * Do we need these probe functions on the m68k?
- *
- *  ... may be useful with ISA devices
- */
-unsigned long probe_irq_on (void)
-{
-	return 0;
-}
-
-EXPORT_SYMBOL(probe_irq_on);
-
-int probe_irq_off (unsigned long irqs)
-{
-	return 0;
-}
-
-EXPORT_SYMBOL(probe_irq_off);
-
-asmlinkage void process_int(unsigned long vec, struct pt_regs *fp)
-{
-	if (vec >= VEC_INT1 && vec <= VEC_INT7) {
-		vec -= VEC_SPUR;
-		kstat_cpu(0).irqs[vec]++;
-		irq_list[vec].handler(vec, irq_list[vec].dev_id);
-	} else {
-		if (mach_process_int)
-			mach_process_int(vec, fp);
-		else
-			panic("Can't process interrupt vector %ld\n", vec);
-		return;
-	}
-}
-
-
-int show_interrupts(struct seq_file *p, void *v)
-{
-	int i = *(loff_t *) v;
-
-	if (i < NR_IRQS) {
-		if (! (irq_list[i].flags & IRQ_FLG_STD)) {
-			seq_printf(p, "%3d: %10u ", i,
-				(i ? kstat_cpu(0).irqs[i] : num_spurious));
-			if (irq_list[i].flags & IRQ_FLG_LOCK)
-				seq_printf(p, "L ");
-			else
-				seq_printf(p, "  ");
-			seq_printf(p, "%s\n", irq_list[i].devname);
-		}
-	}
-
-	if (i == NR_IRQS && mach_get_irq_list)
-		mach_get_irq_list(p, v);
-	return 0;
-}
-
-void init_irq_proc(void)
-{
-	/* Insert /proc/irq driver here */
-}
-
diff -puN arch/m68knommu/platform/5307/vectors.c~m68knommu-generic-irq-handling arch/m68knommu/platform/5307/vectors.c
--- a/arch/m68knommu/platform/5307/vectors.c~m68knommu-generic-irq-handling
+++ a/arch/m68knommu/platform/5307/vectors.c
@@ -3,23 +3,17 @@
 /*
  *	linux/arch/m68knommu/platform/5307/vectors.c
  *
- *	Copyright (C) 1999-2003, Greg Ungerer <gerg@snapgear.com>
+ *	Copyright (C) 1999-2007, Greg Ungerer <gerg@snapgear.com>
  */
 
 /***************************************************************************/
 
 #include <linux/kernel.h>
-#include <linux/sched.h>
-#include <linux/param.h>
 #include <linux/init.h>
-#include <linux/unistd.h>
-#include <linux/delay.h>
-#include <asm/irq.h>
-#include <asm/dma.h>
+#include <linux/irq.h>
 #include <asm/traps.h>
 #include <asm/machdep.h>
 #include <asm/coldfire.h>
-#include <asm/mcftimer.h>
 #include <asm/mcfsim.h>
 #include <asm/mcfdma.h>
 #include <asm/mcfwdebug.h>
@@ -56,7 +50,7 @@ asmlinkage void trap(void);
 asmlinkage void system_call(void);
 asmlinkage void inthandler(void);
 
-void __init coldfire_trap_init(void)
+void __init init_vectors(void)
 {
 	int i;
 
@@ -86,6 +80,23 @@ void __init coldfire_trap_init(void)
 
 /***************************************************************************/
 
+void enable_vector(unsigned int irq)
+{
+	/* Currently no action on ColdFire */
+}
+
+void disable_vector(unsigned int irq)
+{
+	/* Currently no action on ColdFire */
+}
+
+void ack_vector(unsigned int irq)
+{
+	/* Currently no action on ColdFire */
+}
+
+/***************************************************************************/
+
 void coldfire_reset(void)
 {
 	HARD_RESET_NOW();
diff -puN arch/m68knommu/platform/68328/entry.S~m68knommu-generic-irq-handling arch/m68knommu/platform/68328/entry.S
--- a/arch/m68knommu/platform/68328/entry.S~m68knommu-generic-irq-handling
+++ a/arch/m68knommu/platform/68328/entry.S
@@ -133,7 +133,6 @@ Lreturn:
  */
 inthandler1:
 	SAVE_ALL
-	addql	#1,local_irq_count	/*  put exception # in d0*/
 	movew	%sp@(PT_VECTOR), %d0
 	and	#0x3ff, %d0
 
@@ -145,7 +144,6 @@ inthandler1:
 
 inthandler2:
 	SAVE_ALL
-	addql	#1,local_irq_count	/*  put exception # in d0*/
 	movew	%sp@(PT_VECTOR), %d0
 	and	#0x3ff, %d0
 
@@ -157,7 +155,6 @@ inthandler2:
 
 inthandler3:
 	SAVE_ALL
-	addql	#1,local_irq_count	/*  put exception # in d0*/
 	movew	%sp@(PT_VECTOR), %d0
 	and	#0x3ff, %d0
 
@@ -169,7 +166,6 @@ inthandler3:
 
 inthandler4:
 	SAVE_ALL
-	addql	#1,local_irq_count	/*  put exception # in d0*/
 	movew	%sp@(PT_VECTOR), %d0
 	and	#0x3ff, %d0
 
@@ -181,7 +177,6 @@ inthandler4:
 
 inthandler5:
 	SAVE_ALL
-	addql	#1,local_irq_count	/*  put exception # in d0*/
 	movew	%sp@(PT_VECTOR), %d0
 	and	#0x3ff, %d0
 
@@ -193,7 +188,6 @@ inthandler5:
 
 inthandler6:
 	SAVE_ALL
-	addql	#1,local_irq_count	/*  put exception # in d0*/
 	movew	%sp@(PT_VECTOR), %d0
 	and	#0x3ff, %d0
 
@@ -205,7 +199,6 @@ inthandler6:
 
 inthandler7:
 	SAVE_ALL
-	addql	#1,local_irq_count	/*  put exception # in d0*/
 	movew	%sp@(PT_VECTOR), %d0
 	and	#0x3ff, %d0
 
@@ -217,7 +210,6 @@ inthandler7:
 
 inthandler:
 	SAVE_ALL
-	addql	#1,local_irq_count	/*  put exception # in d0*/
 	movew	%sp@(PT_VECTOR), %d0
 	and	#0x3ff, %d0
 
@@ -228,7 +220,6 @@ inthandler:
 	bra	ret_from_interrupt
 
 ret_from_interrupt:
-	subql	#1,local_irq_count
 	jeq	1f
 2:
 	RESTORE_ALL
@@ -238,7 +229,6 @@ ret_from_interrupt:
 	jhi	2b
 
 	/* check if we need to do software interrupts */
-	movel	local_irq_count,%d0
 	jeq	ret_from_exception
 
 	pea	ret_from_exception
diff -puN arch/m68knommu/platform/68328/ints.c~m68knommu-generic-irq-handling arch/m68knommu/platform/68328/ints.c
--- a/arch/m68knommu/platform/68328/ints.c~m68knommu-generic-irq-handling
+++ a/arch/m68knommu/platform/68328/ints.c
@@ -9,21 +9,14 @@
  * Copyright 1999 D. Jeff Dionne <jeff@rt-control.com>
  */
 
-#include <linux/module.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
-#include <linux/kernel_stat.h>
-#include <linux/errno.h>
+#include <linux/init.h>
 #include <linux/interrupt.h>
-
-#include <asm/system.h>
-#include <asm/irq.h>
-#include <asm/irqnode.h>
+#include <linux/irq.h>
 #include <asm/traps.h>
 #include <asm/io.h>
 #include <asm/machdep.h>
-#include <asm/setup.h>
 
 #if defined(CONFIG_M68328)
 #include <asm/MC68328.h>
@@ -79,16 +72,12 @@ extern e_vector *_ramvec;
 
 /* The number of spurious interrupts */
 volatile unsigned int num_spurious;
-unsigned int local_irq_count[NR_CPUS];
-
-/* irq node variables for the 32 (potential) on chip sources */
-static irq_node_t int_irq_list[NR_IRQS];
 
 /*
  * This function should be called during kernel startup to initialize
- * the IRQ handling routines.
+ * the machine vector table.
  */
-void init_IRQ(void)
+void __init init_vectors(void)
 {
 	int i;
 
@@ -108,96 +97,10 @@ void init_IRQ(void)
  
 	IVR = 0x40; /* Set DragonBall IVR (interrupt base) to 64 */
 
-	/* initialize handlers */
-	for (i = 0; i < NR_IRQS; i++) {
-		int_irq_list[i].handler = bad_interrupt;
-		int_irq_list[i].flags   = IRQ_FLG_STD;
-		int_irq_list[i].dev_id  = NULL;
-		int_irq_list[i].devname = NULL;
-	}
-
 	/* turn off all interrupts */
 	IMR = ~0;
 }
 
-int request_irq(
-	unsigned int irq,
-	irq_handler_t handler,
-	unsigned long flags,
-	const char *devname,
-	void *dev_id)
-{
-	if (irq >= NR_IRQS) {
-		printk (KERN_ERR "%s: Unknown IRQ %d from %s\n", __FUNCTION__, irq, devname);
-		return -ENXIO;
-	}
-
-	if (!(int_irq_list[irq].flags & IRQ_FLG_STD)) {
-		if (int_irq_list[irq].flags & IRQ_FLG_LOCK) {
-			printk(KERN_ERR "%s: IRQ %d from %s is not replaceable\n",
-			       __FUNCTION__, irq, int_irq_list[irq].devname);
-			return -EBUSY;
-		}
-		if (flags & IRQ_FLG_REPLACE) {
-			printk(KERN_ERR "%s: %s can't replace IRQ %d from %s\n",
-			       __FUNCTION__, devname, irq, int_irq_list[irq].devname);
-			return -EBUSY;
-		}
-	}
-
-	int_irq_list[irq].handler = handler;
-	int_irq_list[irq].flags   = flags;
-	int_irq_list[irq].dev_id  = dev_id;
-	int_irq_list[irq].devname = devname;
-
-	IMR &= ~(1<<irq);
-
-	return 0;
-}
-
-EXPORT_SYMBOL(request_irq);
-
-void free_irq(unsigned int irq, void *dev_id)
-{
-	if (irq >= NR_IRQS) {
-		printk (KERN_ERR "%s: Unknown IRQ %d\n", __FUNCTION__, irq);
-		return;
-	}
-
-	if (int_irq_list[irq].dev_id != dev_id)
-		printk(KERN_INFO "%s: removing probably wrong IRQ %d from %s\n",
-		       __FUNCTION__, irq, int_irq_list[irq].devname);
-
-	int_irq_list[irq].handler = bad_interrupt;
-	int_irq_list[irq].flags   = IRQ_FLG_STD;
-	int_irq_list[irq].dev_id  = NULL;
-	int_irq_list[irq].devname = NULL;
-
-	IMR |= 1<<irq;
-}
-
-EXPORT_SYMBOL(free_irq);
-
-int show_interrupts(struct seq_file *p, void *v)
-{
-	int i = *(loff_t *) v;
-
-	if (i < NR_IRQS) {
-		if (int_irq_list[i].devname) {
-			seq_printf(p, "%3d: %10u ", i, kstat_cpu(0).irqs[i]);
-			if (int_irq_list[i].flags & IRQ_FLG_LOCK)
-				seq_printf(p, "L ");
-			else
-				seq_printf(p, "  ");
-			seq_printf(p, "%s\n", int_irq_list[i].devname);
-		}
-	}
-	if (i == NR_IRQS)
-		seq_printf(p, "   : %10u   spurious\n", num_spurious);
-
-	return 0;
-}
-
 /* The 68k family did not have a good way to determine the source
  * of interrupts until later in the family.  The EC000 core does
  * not provide the vector number on the stack, we vector everything
@@ -255,14 +158,23 @@ void process_int(int vec, struct pt_regs
 			irq++;
 		}
 
-		kstat_cpu(0).irqs[irq]++;
-
-		if (int_irq_list[irq].handler) {
-			int_irq_list[irq].handler(irq, int_irq_list[irq].dev_id, fp);
-		} else {
-			printk(KERN_ERR "unregistered interrupt %d!\nTurning it off in the IMR...\n", irq);
-			IMR |= mask;
-		}
+		do_IRQ(irq, fp);
 		pend &= ~mask;
 	}
 }
+
+void enable_vector(unsigned int irq)
+{
+	IMR &= ~(1<<irq);
+}
+
+void disable_vector(unsigned int irq)
+{
+	IMR |= (1<<irq);
+}
+
+void ack_vector(unsigned int irq)
+{
+	/* Nothing needed */
+}
+
diff -puN arch/m68knommu/platform/68360/entry.S~m68knommu-generic-irq-handling arch/m68knommu/platform/68360/entry.S
--- a/arch/m68knommu/platform/68360/entry.S~m68knommu-generic-irq-handling
+++ a/arch/m68knommu/platform/68360/entry.S
@@ -120,23 +120,21 @@ Lreturn:
 	RESTORE_ALL
 
 /*
- * This is the main interrupt handler, responsible for calling process_int()
+ * This is the main interrupt handler, responsible for calling do_IRQ()
  */
 inthandler:
 	SAVE_ALL
-	addql	#1,local_irq_count	/*  put exception # in d0*/
 	movew	%sp@(PT_VECTOR), %d0
 	and.l	#0x3ff, %d0
 	lsr.l   #0x02,  %d0
 
 	movel	%sp,%sp@-
 	movel	%d0,%sp@- 		/*  put vector # on stack*/
-	jbsr	process_int		/*  process the IRQ*/
+	jbsr	do_IRQ			/*  process the IRQ*/
 3:     	addql	#8,%sp			/*  pop parameters off stack*/
 	bra	ret_from_interrupt
 
 ret_from_interrupt:
-	subql	#1,local_irq_count
 	jeq	1f
 2:
 	RESTORE_ALL
diff -puN arch/m68knommu/platform/68360/ints.c~m68knommu-generic-irq-handling arch/m68knommu/platform/68360/ints.c
--- a/arch/m68knommu/platform/68360/ints.c~m68knommu-generic-irq-handling
+++ a/arch/m68knommu/platform/68360/ints.c
@@ -10,20 +10,13 @@
  * Copyright (c) 1999 D. Jeff Dionne <jeff@uclinux.org>
  */
 
-#include <linux/module.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
-#include <linux/kernel_stat.h>
-#include <linux/errno.h>
-
-#include <asm/system.h>
-#include <asm/irq.h>
-#include <asm/irqnode.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
 #include <asm/traps.h>
-#include <asm/io.h>
 #include <asm/machdep.h>
-#include <asm/setup.h>
 #include <asm/m68360.h>
 
 /* from quicc/commproc.c: */
@@ -36,26 +29,19 @@ extern void cpm_interrupt_init(void);
 asmlinkage void system_call(void);
 asmlinkage void buserr(void);
 asmlinkage void trap(void);
-asmlinkage irqreturn_t bad_interrupt(void);
-asmlinkage irqreturn_t inthandler(void);
+asmlinkage void bad_interrupt(void);
+asmlinkage void inthandler(void);
 
 extern void *_ramvec[];
 
 /* The number of spurious interrupts */
 volatile unsigned int num_spurious;
-unsigned int local_irq_count[NR_CPUS];
-
-/* irq node variables for the 32 (potential) on chip sources */
-static irq_node_t int_irq_list[INTERNAL_IRQS];
-
-static short int_irq_ablecount[INTERNAL_IRQS];
 
 /*
  * This function should be called during kernel startup to initialize
- * IRQ handling routines.
+ * the vector table.
  */
-
-void init_IRQ(void)
+void init_vectors(void)
 {
 	int i;
 	int vba = (CPM_VECTOR_BASE<<4);
@@ -79,7 +65,6 @@ void init_IRQ(void)
 	_ramvec[32] = system_call;
 	_ramvec[33] = trap;
 
-
 	cpm_interrupt_init();
 
 	/* set up CICR for vector base address and irq level */
@@ -124,212 +109,20 @@ void init_IRQ(void)
 
 	/* turn off all CPM interrupts */
 	pquicc->intr_cimr = 0x00000000;
-
-	/* initialize handlers */
-	for (i = 0; i < INTERNAL_IRQS; i++) {
-		int_irq_list[i].handler = NULL;
-		int_irq_list[i].flags   = IRQ_FLG_STD;
-		int_irq_list[i].dev_id  = NULL;
-		int_irq_list[i].devname = NULL;
-	}
 }
 
-#if 0
-void M68360_insert_irq(irq_node_t **list, irq_node_t *node)
+void enable_vector(unsigned int irq)
 {
-	unsigned long flags;
-	irq_node_t *cur;
-
-	if (!node->dev_id)
-		printk(KERN_INFO "%s: Warning: dev_id of %s is zero\n",
-		       __FUNCTION__, node->devname);
-
-	local_irq_save(flags);
-
-	cur = *list;
-
-	while (cur) {
-		list = &cur->next;
-		cur = cur->next;
-	}
-
-	node->next = cur;
-	*list = node;
-
-	local_irq_restore(flags);
+	pquicc->intr_cimr |= (1 << irq);
 }
 
-void M68360_delete_irq(irq_node_t **list, void *dev_id)
+void disable_vector(unsigned int irq)
 {
-	unsigned long flags;
-	irq_node_t *node;
-
-	local_irq_save(flags);
-
-	for (node = *list; node; list = &node->next, node = *list) {
-		if (node->dev_id == dev_id) {
-			*list = node->next;
-			/* Mark it as free. */
-			node->handler = NULL;
-			local_irq_restore(flags);
-			return;
-		}
-	}
-	local_irq_restore(flags);
-	printk (KERN_INFO "%s: tried to remove invalid irq\n", __FUNCTION__);
+	pquicc->intr_cimr &= ~(1 << irq);
 }
-#endif
 
-int request_irq(
-	unsigned int irq,
-	irqreturn_t (*handler)(int, void *, struct pt_regs *),
-	unsigned long flags,
-	const char *devname,
-	void *dev_id)
+void ack_vector(unsigned int irq)
 {
-	int mask = (1<<irq);
-
-	irq += (CPM_VECTOR_BASE<<4);
-
-	if (irq >= INTERNAL_IRQS) {
-		printk (KERN_ERR "%s: Unknown IRQ %d from %s\n", __FUNCTION__, irq, devname);
-		return -ENXIO;
-	}
-
-	if (!(int_irq_list[irq].flags & IRQ_FLG_STD)) {
-		if (int_irq_list[irq].flags & IRQ_FLG_LOCK) {
-			printk(KERN_ERR "%s: IRQ %d from %s is not replaceable\n",
-			       __FUNCTION__, irq, int_irq_list[irq].devname);
-			return -EBUSY;
-		}
-		if (flags & IRQ_FLG_REPLACE) {
-			printk(KERN_ERR "%s: %s can't replace IRQ %d from %s\n",
-			       __FUNCTION__, devname, irq, int_irq_list[irq].devname);
-			return -EBUSY;
-		}
-	}
-	int_irq_list[irq].handler = handler;
-	int_irq_list[irq].flags   = flags;
-	int_irq_list[irq].dev_id  = dev_id;
-	int_irq_list[irq].devname = devname;
-
-	/* enable in the CIMR */
-	if (!int_irq_ablecount[irq])
-		pquicc->intr_cimr |= mask;
-	/*      *(volatile unsigned long *)0xfffff304 &= ~(1<<irq); */
-
-	return 0;
+	pquicc->intr_cisr = (1 << irq);
 }
 
-EXPORT_SYMBOL(request_irq);
-
-void free_irq(unsigned int irq, void *dev_id)
-{
-	if (irq >= INTERNAL_IRQS) {
-		printk (KERN_ERR "%s: Unknown IRQ %d\n", __FUNCTION__, irq);
-		return;
-	}
-
-	if (int_irq_list[irq].dev_id != dev_id)
-		printk(KERN_INFO "%s: removing probably wrong IRQ %d from %s\n",
-		       __FUNCTION__, irq, int_irq_list[irq].devname);
-	int_irq_list[irq].handler = NULL;
-	int_irq_list[irq].flags   = IRQ_FLG_STD;
-	int_irq_list[irq].dev_id  = NULL;
-	int_irq_list[irq].devname = NULL;
-
-	*(volatile unsigned long *)0xfffff304 |= 1<<irq;
-}
-
-EXPORT_SYMBOL(free_irq);
-
-#if 0
-/*
- * Enable/disable a particular machine specific interrupt source.
- * Note that this may affect other interrupts in case of a shared interrupt.
- * This function should only be called for a _very_ short time to change some
- * internal data, that may not be changed by the interrupt at the same time.
- * int_(enable|disable)_irq calls may also be nested.
- */
-void M68360_enable_irq(unsigned int irq)
-{
-	if (irq >= INTERNAL_IRQS) {
-		printk(KERN_ERR "%s: Unknown IRQ %d\n", __FUNCTION__, irq);
-		return;
-	}
-
-	if (--int_irq_ablecount[irq])
-		return;
-
-	/* enable the interrupt */
-	*(volatile unsigned long *)0xfffff304 &= ~(1<<irq);
-}
-
-void M68360_disable_irq(unsigned int irq)
-{
-	if (irq >= INTERNAL_IRQS) {
-		printk(KERN_ERR "%s: Unknown IRQ %d\n", __FUNCTION__, irq);
-		return;
-	}
-
-	if (int_irq_ablecount[irq]++)
-		return;
-
-	/* disable the interrupt */
-	*(volatile unsigned long *)0xfffff304 |= 1<<irq;
-}
-#endif
-
-int show_interrupts(struct seq_file *p, void *v)
-{
-	int i = *(loff_t *) v;
-
-	if (i < NR_IRQS) {
-		if (int_irq_list[i].devname) {
-			seq_printf(p, "%3d: %10u ", i, kstat_cpu(0).irqs[i]);
-			if (int_irq_list[i].flags & IRQ_FLG_LOCK)
-				seq_printf(p, "L ");
-			else
-				seq_printf(p, "  ");
-			seq_printf(p, "%s\n", int_irq_list[i].devname);
-		}
-	}
-	if (i == NR_IRQS)
-		seq_printf(p, "   : %10u   spurious\n", num_spurious);
-
-	return 0;
-}
-
-/* The 68k family did not have a good way to determine the source
- * of interrupts until later in the family.  The EC000 core does
- * not provide the vector number on the stack, we vector everything
- * into one vector and look in the blasted mask register...
- * This code is designed to be fast, almost constant time, not clean!
- */
-void process_int(int vec, struct pt_regs *fp)
-{
-	int irq;
-	int mask;
-
-	/* unsigned long pend = *(volatile unsigned long *)0xfffff30c; */
-
-	/* irq = vec + (CPM_VECTOR_BASE<<4); */
-	irq = vec;
-
-	/* unsigned long pend = *(volatile unsigned long *)pquicc->intr_cipr; */
-
-	/* Bugger all that weirdness. For the moment, I seem to know where I came from;
-	 * vec is passed from a specific ISR, so I'll use it. */
-
-	if (int_irq_list[irq].handler) {
-		int_irq_list[irq].handler(irq , int_irq_list[irq].dev_id, fp);
-		kstat_cpu(0).irqs[irq]++;
-		pquicc->intr_cisr = (1 << vec); /* indicate that irq has been serviced */
-	} else {
-		printk(KERN_ERR "unregistered interrupt %d!\nTurning it off in the CIMR...\n", irq);
-		/* *(volatile unsigned long *)0xfffff304 |= mask; */
-		pquicc->intr_cimr &= ~(1 << vec);
-		num_spurious += 1;
-	}
-	return(IRQ_HANDLED);
-}
diff -puN include/asm-m68knommu/irq.h~m68knommu-generic-irq-handling include/asm-m68knommu/irq.h
--- a/include/asm-m68knommu/irq.h~m68knommu-generic-irq-handling
+++ a/include/asm-m68knommu/irq.h
@@ -1,7 +1,5 @@
-#ifndef _M68K_IRQ_H_
-#define _M68K_IRQ_H_
-
-#include <asm/ptrace.h>
+#ifndef _M68KNOMMU_IRQ_H_
+#define _M68KNOMMU_IRQ_H_
 
 #ifdef CONFIG_COLDFIRE
 /*
@@ -17,75 +15,12 @@
 /*
  * # of m68k interrupts
  */
-#define SYS_IRQS 8
-#define NR_IRQS (24+SYS_IRQS)
+#define SYS_IRQS	8
+#define NR_IRQS		(24 + SYS_IRQS)
 
 #endif /* CONFIG_COLDFIRE */
 
-/*
- * Interrupt source definitions
- * General interrupt sources are the level 1-7.
- * Adding an interrupt service routine for one of these sources
- * results in the addition of that routine to a chain of routines.
- * Each one is called in succession.  Each individual interrupt
- * service routine should determine if the device associated with
- * that routine requires service.
- */
 
-#define IRQ1		(1)	/* level 1 interrupt */
-#define IRQ2		(2)	/* level 2 interrupt */
-#define IRQ3		(3)	/* level 3 interrupt */
-#define IRQ4		(4)	/* level 4 interrupt */
-#define IRQ5		(5)	/* level 5 interrupt */
-#define IRQ6		(6)	/* level 6 interrupt */
-#define IRQ7		(7)	/* level 7 interrupt (non-maskable) */
-
-/*
- * Machine specific interrupt sources.
- *
- * Adding an interrupt service routine for a source with this bit
- * set indicates a special machine specific interrupt source.
- * The machine specific files define these sources.
- *
- * The IRQ_MACHSPEC bit is now gone - the only thing it did was to
- * introduce unnecessary overhead.
- *
- * All interrupt handling is actually machine specific so it is better
- * to use function pointers, as used by the Sparc port, and select the
- * interrupt handling functions when initializing the kernel. This way
- * we save some unnecessary overhead at run-time. 
- *                                                      01/11/97 - Jes
- */
-
-extern void (*mach_enable_irq)(unsigned int);
-extern void (*mach_disable_irq)(unsigned int);
-
-/*
- * various flags for request_irq() - the Amiga now uses the standard
- * mechanism like all other architectures - IRQF_DISABLED and
- * IRQF_SHARED are your friends.
- */
-#define IRQ_FLG_LOCK	(0x0001)	/* handler is not replaceable	*/
-#define IRQ_FLG_REPLACE	(0x0002)	/* replace existing handler	*/
-#define IRQ_FLG_FAST	(0x0004)
-#define IRQ_FLG_SLOW	(0x0008)
-#define IRQ_FLG_STD	(0x8000)	/* internally used		*/
-
-#ifdef CONFIG_M68360
-
-#define CPM_INTERRUPT    IRQ4
-
-/* see MC68360 User's Manual, p. 7-377  */
-#define CPM_VECTOR_BASE  0x04           /* 3 MSbits of CPM vector */
-
-#endif /* CONFIG_M68360 */
-
-/*
- * Some drivers want these entry points
- */
-#define enable_irq(x)	do { } while (0)
-#define disable_irq(x)	do { } while (0)
-#define disable_irq_nosync(x)	disable_irq(x)
 #define irq_canonicalize(irq)	(irq)
 
-#endif /* _M68K_IRQ_H_ */
+#endif /* _M68KNOMMU_IRQ_H_ */
diff -puN include/asm-m68knommu/irqnode.h~m68knommu-generic-irq-handling /dev/null
--- a/include/asm-m68knommu/irqnode.h
+++ /dev/null
@@ -1,36 +0,0 @@
-#ifndef _M68K_IRQNODE_H_
-#define _M68K_IRQNODE_H_
-
-#include <linux/interrupt.h>
-
-/*
- * This structure is used to chain together the ISRs for a particular
- * interrupt source (if it supports chaining).
- */
-typedef struct irq_node {
-	irq_handler_t	handler;
-	unsigned long	flags;
-	void		*dev_id;
-	const char	*devname;
-	struct irq_node *next;
-} irq_node_t;
-
-/*
- * This structure has only 4 elements for speed reasons
- */
-struct irq_entry {
-	irq_handler_t	handler;
-	unsigned long	flags;
-	void		*dev_id;
-	const char	*devname;
-};
-
-/* count of spurious interrupts */
-extern volatile unsigned int num_spurious;
-
-/*
- * This function returns a new irq_node_t
- */
-extern irq_node_t *new_irq_node(void);
-
-#endif /* _M68K_IRQNODE_H_ */
diff -puN include/asm-m68knommu/m68360.h~m68knommu-generic-irq-handling include/asm-m68knommu/m68360.h
--- a/include/asm-m68knommu/m68360.h~m68knommu-generic-irq-handling
+++ a/include/asm-m68knommu/m68360.h
@@ -3,3 +3,11 @@
 #include "m68360_quicc.h"
 #include "m68360_enet.h"
 
+#ifdef CONFIG_M68360
+
+#define CPM_INTERRUPT    4
+
+/* see MC68360 User's Manual, p. 7-377  */
+#define CPM_VECTOR_BASE  0x04           /* 3 MSbits of CPM vector */
+
+#endif /* CONFIG_M68360 */
diff -puN include/asm-m68knommu/traps.h~m68knommu-generic-irq-handling include/asm-m68knommu/traps.h
--- a/include/asm-m68knommu/traps.h~m68knommu-generic-irq-handling
+++ a/include/asm-m68knommu/traps.h
@@ -16,6 +16,10 @@
 typedef void (*e_vector)(void);
 
 extern e_vector vectors[];
+extern void init_vectors(void);
+extern void enable_vector(unsigned int irq);
+extern void disable_vector(unsigned int irq);
+extern void ack_vector(unsigned int irq);
 
 #endif
 
_

Patches currently in -mm which might be from gerg@snapgear.com are

origin.patch
git-mtd.patch
