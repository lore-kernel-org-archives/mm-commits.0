From: akpm@linux-foundation.org
Subject: + h8300-irq-handling-update.patch added to -mm tree
Date: Fri, 15 Feb 2008 22:44:13 -0800
Message-ID: <200802160644.m1G6iDnV012842@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57179 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752685AbYBPGob (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 16 Feb 2008 01:44:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ysato@users.sourceforge.jp


The patch titled
     h8300: IRQ handling update
has been added to the -mm tree.  Its filename is
     h8300-irq-handling-update.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: h8300: IRQ handling update
From: Yoshinori Sato <ysato@users.sourceforge.jp>

- add missing file and declare.
- remove unused file and macros.
- some cleanup.

Signed-off-by: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/h8300/kernel/irq.c             |    4 
 arch/h8300/platform/h8300h/Makefile |    2 
 arch/h8300/platform/h8300h/irq.c    |   82 +++++++
 arch/h8300/platform/h8s/ints.c      |  304 --------------------------
 arch/h8300/platform/h8s/ints_h8s.c  |  104 --------
 arch/h8300/platform/h8s/irq.c       |  104 ++++++++
 include/asm-h8300/hardirq.h         |    2 
 include/asm-h8300/irq.h             |   19 -
 8 files changed, 194 insertions(+), 427 deletions(-)

diff -puN arch/h8300/kernel/irq.c~h8300-irq-handling-update arch/h8300/kernel/irq.c
--- a/arch/h8300/kernel/irq.c~h8300-irq-handling-update
+++ a/arch/h8300/kernel/irq.c
@@ -26,7 +26,7 @@
 
 extern unsigned long *interrupt_redirect_table;
 extern const int h8300_saved_vectors[];
-extern const unsigned long h8300_trap_table[];
+extern const h8300_vector h8300_trap_table[];
 int h8300_enable_irq_pin(unsigned int irq);
 void h8300_disable_irq_pin(unsigned int irq);
 
@@ -116,7 +116,7 @@ static void __init setup_vector(void)
 {
 	int i;
 	unsigned long *ramvec,*ramvec_p;
-	const unsigned long *trap_entry;
+	const h8300_vector *trap_entry;
 	const int *saved_vector;
 
 	ramvec = get_vector_address();
diff -puN arch/h8300/platform/h8300h/Makefile~h8300-irq-handling-update arch/h8300/platform/h8300h/Makefile
--- a/arch/h8300/platform/h8300h/Makefile~h8300-irq-handling-update
+++ a/arch/h8300/platform/h8300h/Makefile
@@ -4,4 +4,4 @@
 # Reuse any files we can from the H8/300H
 #
 
-obj-y := irq_pin.o ptrace_h8300h.o
+obj-y := irq.o ptrace_h8300h.o
diff -puN /dev/null arch/h8300/platform/h8300h/irq.c
--- /dev/null
+++ a/arch/h8300/platform/h8300h/irq.c
@@ -0,0 +1,82 @@
+/*
+ * Interrupt handling H8/300H depend.
+ * Yoshinori Sato <ysato@users.sourceforge.jp>
+ *
+ */
+
+#include <linux/init.h>
+#include <linux/errno.h>
+
+#include <asm/ptrace.h>
+#include <asm/traps.h>
+#include <asm/irq.h>
+#include <asm/io.h>
+#include <asm/gpio.h>
+#include <asm/regs306x.h>
+
+const int __initdata h8300_saved_vectors[] = {
+#if defined(CONFIG_GDB_DEBUG)
+	TRAP3_VEC,	/* TRAPA #3 is GDB breakpoint */
+#endif
+	-1,
+};
+
+const h8300_vector __initdata h8300_trap_table[] = {
+	0, 0, 0, 0, 0, 0, 0, 0,
+	system_call,
+	0,
+	0,
+	trace_break,
+};
+
+int h8300_enable_irq_pin(unsigned int irq)
+{
+	int bitmask;
+	if (irq < EXT_IRQ0 || irq > EXT_IRQ5)
+		return 0;
+
+	/* initialize IRQ pin */
+	bitmask = 1 << (irq - EXT_IRQ0);
+	switch(irq) {
+	case EXT_IRQ0:
+	case EXT_IRQ1:
+	case EXT_IRQ2:
+	case EXT_IRQ3:
+		if (H8300_GPIO_RESERVE(H8300_GPIO_P8, bitmask) == 0)
+			return -EBUSY;
+		H8300_GPIO_DDR(H8300_GPIO_P8, bitmask, H8300_GPIO_INPUT);
+		break;
+	case EXT_IRQ4:
+	case EXT_IRQ5:
+		if (H8300_GPIO_RESERVE(H8300_GPIO_P9, bitmask) == 0)
+			return -EBUSY;
+		H8300_GPIO_DDR(H8300_GPIO_P9, bitmask, H8300_GPIO_INPUT);
+		break;
+	}
+
+	return 0;
+}
+
+void h8300_disable_irq_pin(unsigned int irq)
+{
+	int bitmask;
+	if (irq < EXT_IRQ0 || irq > EXT_IRQ5)
+		return;
+
+	/* disable interrupt & release IRQ pin */
+	bitmask = 1 << (irq - EXT_IRQ0);
+	switch(irq) {
+	case EXT_IRQ0:
+	case EXT_IRQ1:
+	case EXT_IRQ2:
+	case EXT_IRQ3:
+		*(volatile unsigned char *)IER &= ~bitmask;
+		H8300_GPIO_FREE(H8300_GPIO_P8, bitmask);
+		break ;
+	case EXT_IRQ4:
+	case EXT_IRQ5:
+		*(volatile unsigned char *)IER &= ~bitmask;
+		H8300_GPIO_FREE(H8300_GPIO_P9, bitmask);
+		break;
+	}
+}
diff -puN arch/h8300/platform/h8s/ints.c~h8300-irq-handling-update /dev/null
--- a/arch/h8300/platform/h8s/ints.c
+++ /dev/null
@@ -1,304 +0,0 @@
-/*
- * linux/arch/h8300/platform/h8s/ints.c
- *
- * Yoshinori Sato <ysato@users.sourceforge.jp>
- *
- * Based on linux/arch/$(ARCH)/platform/$(PLATFORM)/ints.c
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file COPYING in the main directory of this archive
- * for more details.
- *
- * Copyright 1996 Roman Zippel
- * Copyright 1999 D. Jeff Dionne <jeff@rt-control.com>
- */
-
-#include <linux/module.h>
-#include <linux/types.h>
-#include <linux/kernel.h>
-#include <linux/sched.h>
-#include <linux/kernel_stat.h>
-#include <linux/seq_file.h>
-#include <linux/init.h>
-#include <linux/interrupt.h>
-#include <linux/bootmem.h>
-#include <linux/random.h>
-#include <linux/hardirq.h>
-
-#include <asm/system.h>
-#include <asm/irq.h>
-#include <asm/traps.h>
-#include <asm/io.h>
-#include <asm/setup.h>
-#include <asm/gpio.h>
-#include <asm/regs267x.h>
-#include <asm/errno.h>
-
-/*
- * This structure has only 4 elements for speed reasons
- */
-typedef struct irq_handler {
-	irqreturn_t (*handler)(int, void *, struct pt_regs *);
-	int         flags;
-	int         count;
-	void	    *dev_id;
-	const char  *devname;
-} irq_handler_t;
-
-static irq_handler_t *irq_list[NR_IRQS];
-
-/* IRQ pin assignment */
-struct irq_pins {
-	unsigned char port_no;
-	unsigned char bit_no;
-};
-/* ISTR = 0 */
-static const struct irq_pins irq_assign_table0[16]={
-        {H8300_GPIO_P5,H8300_GPIO_B0},{H8300_GPIO_P5,H8300_GPIO_B1},
-	{H8300_GPIO_P5,H8300_GPIO_B2},{H8300_GPIO_P5,H8300_GPIO_B3},
-	{H8300_GPIO_P5,H8300_GPIO_B4},{H8300_GPIO_P5,H8300_GPIO_B5},
-	{H8300_GPIO_P5,H8300_GPIO_B6},{H8300_GPIO_P5,H8300_GPIO_B7},
-	{H8300_GPIO_P6,H8300_GPIO_B0},{H8300_GPIO_P6,H8300_GPIO_B1},
-	{H8300_GPIO_P6,H8300_GPIO_B2},{H8300_GPIO_P6,H8300_GPIO_B3},
-	{H8300_GPIO_P6,H8300_GPIO_B4},{H8300_GPIO_P6,H8300_GPIO_B5},
-	{H8300_GPIO_PF,H8300_GPIO_B1},{H8300_GPIO_PF,H8300_GPIO_B2},
-};
-/* ISTR = 1 */
-static const struct irq_pins irq_assign_table1[16]={
-	{H8300_GPIO_P8,H8300_GPIO_B0},{H8300_GPIO_P8,H8300_GPIO_B1},
-	{H8300_GPIO_P8,H8300_GPIO_B2},{H8300_GPIO_P8,H8300_GPIO_B3},
-	{H8300_GPIO_P8,H8300_GPIO_B4},{H8300_GPIO_P8,H8300_GPIO_B5},
-	{H8300_GPIO_PH,H8300_GPIO_B2},{H8300_GPIO_PH,H8300_GPIO_B3},
-	{H8300_GPIO_P2,H8300_GPIO_B0},{H8300_GPIO_P2,H8300_GPIO_B1},
-	{H8300_GPIO_P2,H8300_GPIO_B2},{H8300_GPIO_P2,H8300_GPIO_B3},
-	{H8300_GPIO_P2,H8300_GPIO_B4},{H8300_GPIO_P2,H8300_GPIO_B5},
-	{H8300_GPIO_P2,H8300_GPIO_B6},{H8300_GPIO_P2,H8300_GPIO_B7},
-};
-
-static short use_kmalloc = 0;
-
-extern unsigned long *interrupt_redirect_table;
-
-#define CPU_VECTOR ((unsigned long *)0x000000)
-#define ADDR_MASK (0xffffff)
-
-static inline unsigned long *get_vector_address(void)
-{
-	volatile unsigned long *rom_vector = CPU_VECTOR;
-	unsigned long base,tmp;
-	int vec_no;
-
-	base = rom_vector[EXT_IRQ0] & ADDR_MASK;
-	
-	/* check romvector format */
-	for (vec_no = EXT_IRQ1; vec_no <= EXT_IRQ15; vec_no++) {
-		if ((base+(vec_no - EXT_IRQ0)*4) != (rom_vector[vec_no] & ADDR_MASK))
-			return NULL;
-	}
-
-	/* ramvector base address */
-	base -= EXT_IRQ0*4;
-
-	/* writerble check */
-	tmp = ~(*(unsigned long *)base);
-	(*(unsigned long *)base) = tmp;
-	if ((*(unsigned long *)base) != tmp)
-		return NULL;
-	return (unsigned long *)base;
-}
-
-void __init init_IRQ(void)
-{
-#if defined(CONFIG_RAMKERNEL)
-	int i;
-	unsigned long *ramvec,*ramvec_p;
-	unsigned long break_vec;
-
-	ramvec = get_vector_address();
-	if (ramvec == NULL)
-		panic("interrupt vector serup failed.");
-	else
-		printk("virtual vector at 0x%08lx\n",(unsigned long)ramvec);
-
-#if defined(CONFIG_GDB_DEBUG)
-	/* save original break vector */
-	break_vec = ramvec[TRAP3_VEC];
-#else
-	break_vec = VECTOR(trace_break);
-#endif
-
-	/* create redirect table */
-	for (ramvec_p = ramvec, i = 0; i < NR_IRQS; i++)
-		*ramvec_p++ = REDIRECT(interrupt_entry);
-
-	/* set special vector */
-	ramvec[TRAP0_VEC] = VECTOR(system_call);
-	ramvec[TRAP3_VEC] = break_vec;
-	interrupt_redirect_table = ramvec;
-#ifdef DUMP_VECTOR
-	ramvec_p = ramvec;
-	for (i = 0; i < NR_IRQS; i++) {
-		if ((i % 8) == 0)
-			printk("\n%p: ",ramvec_p);
-		printk("%p ",*ramvec_p);
-		ramvec_p++;
-	}
-	printk("\n");
-#endif
-#endif
-}
-
-int request_irq(unsigned int irq,
-		irqreturn_t (*handler)(int, void *, struct pt_regs *),
-                unsigned long flags, const char *devname, void *dev_id)
-{
-	unsigned short ptn = 1 << (irq - EXT_IRQ0);
-	irq_handler_t *irq_handle;
-	if (irq < 0 || irq >= NR_IRQS) {
-		printk("Incorrect IRQ %d from %s\n", irq, devname);
-		return -EINVAL;
-	}
-	if (irq_list[irq])
-		return -EBUSY; /* already used */
-	if (irq >= EXT_IRQ0 && irq <= EXT_IRQ15) {
-		/* initialize IRQ pin */
-		unsigned int port_no,bit_no;
-		if (*(volatile unsigned short *)ITSR & ptn) {
-			port_no = irq_assign_table1[irq - EXT_IRQ0].port_no;
-			bit_no = irq_assign_table1[irq - EXT_IRQ0].bit_no;
-		} else {
-			port_no = irq_assign_table0[irq - EXT_IRQ0].port_no;
-			bit_no = irq_assign_table0[irq - EXT_IRQ0].bit_no;
-		}
-		if (H8300_GPIO_RESERVE(port_no, bit_no) == 0)
-			return -EBUSY;                   /* pin already use */
-		H8300_GPIO_DDR(port_no, bit_no, H8300_GPIO_INPUT);
-		*(volatile unsigned short *)ISR &= ~ptn; /* ISR clear */
-	}		
-
-	if (use_kmalloc)
-		irq_handle = kmalloc(sizeof(irq_handler_t), GFP_ATOMIC);
-	else {
-		/* use bootmem allocator */
-		irq_handle = (irq_handler_t *)alloc_bootmem(sizeof(irq_handler_t));
-		irq_handle = (irq_handler_t *)((unsigned long)irq_handle | 0x80000000);
-	}
-
-	if (irq_handle == NULL)
-		return -ENOMEM;
-
-	irq_handle->handler = handler;
-	irq_handle->flags   = flags;
-	irq_handle->count   = 0;
-	irq_handle->dev_id  = dev_id;
-	irq_handle->devname = devname;
-	irq_list[irq] = irq_handle;
-	if (irq_handle->flags & IRQF_SAMPLE_RANDOM)
-		rand_initialize_irq(irq);
-	
-	/* enable interrupt */
-	/* compatible i386  */
-	if (irq >= EXT_IRQ0 && irq <= EXT_IRQ15)
-		*(volatile unsigned short *)IER |= ptn;
-	return 0;
-}
-
-EXPORT_SYMBOL(request_irq);
-
-void free_irq(unsigned int irq, void *dev_id)
-{
-	if (irq >= NR_IRQS)
-		return;
-	if (irq_list[irq]->dev_id != dev_id)
-		printk("%s: Removing probably wrong IRQ %d from %s\n",
-		       __FUNCTION__, irq, irq_list[irq]->devname);
-	if (irq >= EXT_IRQ0 && irq <= EXT_IRQ15) {
-		/* disable interrupt & release IRQ pin */
-		unsigned short port_no,bit_no;
-		*(volatile unsigned short *)ISR &= ~(1 << (irq - EXT_IRQ0));
-		*(volatile unsigned short *)IER |= 1 << (irq - EXT_IRQ0);
-		if (*(volatile unsigned short *)ITSR & (1 << (irq - EXT_IRQ0))) {
-			port_no = irq_assign_table1[irq - EXT_IRQ0].port_no;
-			bit_no = irq_assign_table1[irq - EXT_IRQ0].bit_no;
-		} else {
-			port_no = irq_assign_table0[irq - EXT_IRQ0].port_no;
-			bit_no = irq_assign_table0[irq - EXT_IRQ0].bit_no;
-		}
-		H8300_GPIO_FREE(port_no, bit_no);
-	}
-	if (((unsigned long)irq_list[irq] & 0x80000000) == 0) {
-		kfree(irq_list[irq]);
-		irq_list[irq] = NULL;
-	}
-}
-
-EXPORT_SYMBOL(free_irq);
-
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
-void enable_irq(unsigned int irq)
-{
-	if (irq >= EXT_IRQ0 && irq <= EXT_IRQ15)
-		*(volatile unsigned short *)IER |= 1 << (irq - EXT_IRQ0);
-}
-
-void disable_irq(unsigned int irq)
-{
-	if (irq >= EXT_IRQ0 && irq <= EXT_IRQ15)
-		*(volatile unsigned short *)IER &= ~(1 << (irq - EXT_IRQ0));
-}
-
-asmlinkage void process_int(unsigned long vec, struct pt_regs *fp)
-{
-	irq_enter();
-	/* ISR clear       */
-	/* compatible i386 */
-	if (vec >= EXT_IRQ0 && vec <= EXT_IRQ15)
-		*(volatile unsigned short *)ISR &= ~(1 << (vec - EXT_IRQ0));
-	if (vec < NR_IRQS) {
-		if (irq_list[vec]) {
-			irq_list[vec]->handler(vec, irq_list[vec]->dev_id, fp);
-			irq_list[vec]->count++;
-			if (irq_list[vec]->flags & IRQF_SAMPLE_RANDOM)
-				add_interrupt_randomness(vec);
-		}
-	} else {
-		BUG();
-	}
-	irq_exit();
-}
-
-int show_interrupts(struct seq_file *p, void *v)
-{
-	int i = *(loff_t *) v;
-
-	if ((i < NR_IRQS) && (irq_list[i] !=NULL)) {
-		seq_printf(p, "%3d: %10u ",i,irq_list[i]->count);
-		seq_printf(p, "%s\n", irq_list[i]->devname);
-	}
-
-	return 0;
-}
-
-void init_irq_proc(void)
-{
-}
-
-static int __init enable_kmalloc(void)
-{
-	use_kmalloc = 1;
-	return 0;
-}
-core_initcall(enable_kmalloc);
diff -puN arch/h8300/platform/h8s/ints_h8s.c~h8300-irq-handling-update /dev/null
--- a/arch/h8300/platform/h8s/ints_h8s.c
+++ /dev/null
@@ -1,104 +0,0 @@
-/*
- * linux/arch/h8300/platform/h8s/ints_h8s.c
- * Interrupt handling CPU variants
- *
- * Yoshinori Sato <ysato@users.sourceforge.jp>
- *
- */
-
-#include <linux/init.h>
-#include <linux/errno.h>
-#include <linux/kernel.h>
-
-#include <asm/ptrace.h>
-#include <asm/traps.h>
-#include <asm/irq.h>
-#include <asm/io.h>
-#include <asm/gpio.h>
-#include <asm/regs267x.h>
-
-/* saved vector list */
-const int __initdata h8300_saved_vectors[]={
-#if defined(CONFIG_GDB_DEBUG)
-	TRACE_VEC,
-	TRAP3_VEC,
-#endif
-	-1
-};
-
-/* trap entry table */
-const unsigned long __initdata h8300_trap_table[NR_TRAPS]={
-	0,0,0,0,0,
-	(unsigned long)trace_break,  /* TRACE */
-	0,0,
-	(unsigned long)system_call,  /* TRAPA #0 */
-	0,0,0,0,0,0,0
-};
-
-/* IRQ pin assignment */
-struct irq_pins {
-	unsigned char port_no;
-	unsigned char bit_no;
-} __attribute__((aligned(1),packed));
-/* ISTR = 0 */
-static const struct irq_pins irq_assign_table0[16]={
-        {H8300_GPIO_P5,H8300_GPIO_B0},{H8300_GPIO_P5,H8300_GPIO_B1},
-	{H8300_GPIO_P5,H8300_GPIO_B2},{H8300_GPIO_P5,H8300_GPIO_B3},
-	{H8300_GPIO_P5,H8300_GPIO_B4},{H8300_GPIO_P5,H8300_GPIO_B5},
-	{H8300_GPIO_P5,H8300_GPIO_B6},{H8300_GPIO_P5,H8300_GPIO_B7},
-	{H8300_GPIO_P6,H8300_GPIO_B0},{H8300_GPIO_P6,H8300_GPIO_B1},
-	{H8300_GPIO_P6,H8300_GPIO_B2},{H8300_GPIO_P6,H8300_GPIO_B3},
-	{H8300_GPIO_P6,H8300_GPIO_B4},{H8300_GPIO_P6,H8300_GPIO_B5},
-	{H8300_GPIO_PF,H8300_GPIO_B1},{H8300_GPIO_PF,H8300_GPIO_B2},
-}; 
-/* ISTR = 1 */
-static const struct irq_pins irq_assign_table1[16]={
-	{H8300_GPIO_P8,H8300_GPIO_B0},{H8300_GPIO_P8,H8300_GPIO_B1},
-	{H8300_GPIO_P8,H8300_GPIO_B2},{H8300_GPIO_P8,H8300_GPIO_B3},
-	{H8300_GPIO_P8,H8300_GPIO_B4},{H8300_GPIO_P8,H8300_GPIO_B5},
-	{H8300_GPIO_PH,H8300_GPIO_B2},{H8300_GPIO_PH,H8300_GPIO_B3},
-	{H8300_GPIO_P2,H8300_GPIO_B0},{H8300_GPIO_P2,H8300_GPIO_B1},
-	{H8300_GPIO_P2,H8300_GPIO_B2},{H8300_GPIO_P2,H8300_GPIO_B3},
-	{H8300_GPIO_P2,H8300_GPIO_B4},{H8300_GPIO_P2,H8300_GPIO_B5},
-	{H8300_GPIO_P2,H8300_GPIO_B6},{H8300_GPIO_P2,H8300_GPIO_B7},
-};
-
-/* IRQ to GPIO pin translation */
-#define IRQ_GPIO_MAP(irqbit,irq,port,bit)			  \
-do {								  \
-	if (*(volatile unsigned short *)ITSR & irqbit) {	  \
-		port = irq_assign_table1[irq - EXT_IRQ0].port_no; \
-		bit  = irq_assign_table1[irq - EXT_IRQ0].bit_no;  \
-	} else {						  \
-		port = irq_assign_table0[irq - EXT_IRQ0].port_no; \
-		bit  = irq_assign_table0[irq - EXT_IRQ0].bit_no;  \
-	}							  \
-} while(0)
-
-int h8300_enable_irq_pin(unsigned int irq)
-{
-	if (irq >= EXT_IRQ0 && irq <= EXT_IRQ15) {
-		unsigned short ptn = 1 << (irq - EXT_IRQ0);
-		unsigned int port_no,bit_no;
-		IRQ_GPIO_MAP(ptn, irq, port_no, bit_no);
-		if (H8300_GPIO_RESERVE(port_no, bit_no) == 0)
-			return -EBUSY;                   /* pin already use */
-		H8300_GPIO_DDR(port_no, bit_no, H8300_GPIO_INPUT);
-		*(volatile unsigned short *)ISR &= ~ptn; /* ISR clear */
-	}
-
-	return 0;
-}
-
-void h8300_disable_irq_pin(unsigned int irq)
-{
-	if (irq >= EXT_IRQ0 && irq <= EXT_IRQ15) {
-		/* disable interrupt & release IRQ pin */
-		unsigned short ptn = 1 << (irq - EXT_IRQ0);
-		unsigned short port_no,bit_no;
-		*(volatile unsigned short *)ISR &= ~ptn;
-		*(volatile unsigned short *)IER &= ~ptn;
-		IRQ_GPIO_MAP(ptn, irq, port_no, bit_no);
-		H8300_GPIO_FREE(port_no, bit_no);
-	}
-}
diff -puN /dev/null arch/h8300/platform/h8s/irq.c
--- /dev/null
+++ a/arch/h8300/platform/h8s/irq.c
@@ -0,0 +1,104 @@
+/*
+ * linux/arch/h8300/platform/h8s/ints_h8s.c
+ * Interrupt handling CPU variants
+ *
+ * Yoshinori Sato <ysato@users.sourceforge.jp>
+ *
+ */
+
+#include <linux/init.h>
+#include <linux/errno.h>
+#include <linux/kernel.h>
+
+#include <asm/ptrace.h>
+#include <asm/traps.h>
+#include <asm/irq.h>
+#include <asm/io.h>
+#include <asm/gpio.h>
+#include <asm/regs267x.h>
+
+/* saved vector list */
+const int __initdata h8300_saved_vectors[]={
+#if defined(CONFIG_GDB_DEBUG)
+	TRACE_VEC,
+	TRAP3_VEC,
+#endif
+	-1
+};
+
+/* trap entry table */
+const H8300_VECTOR __initdata h8300_trap_table[] = {
+	0,0,0,0,0,
+	trace_break,  /* TRACE */
+	0,0,
+	system_call,  /* TRAPA #0 */
+	0,0,0,0,0,0,0
+};
+
+/* IRQ pin assignment */
+struct irq_pins {
+	unsigned char port_no;
+	unsigned char bit_no;
+} __attribute__((aligned(1),packed));
+/* ISTR = 0 */
+static const struct irq_pins irq_assign_table0[16]={
+        {H8300_GPIO_P5,H8300_GPIO_B0},{H8300_GPIO_P5,H8300_GPIO_B1},
+	{H8300_GPIO_P5,H8300_GPIO_B2},{H8300_GPIO_P5,H8300_GPIO_B3},
+	{H8300_GPIO_P5,H8300_GPIO_B4},{H8300_GPIO_P5,H8300_GPIO_B5},
+	{H8300_GPIO_P5,H8300_GPIO_B6},{H8300_GPIO_P5,H8300_GPIO_B7},
+	{H8300_GPIO_P6,H8300_GPIO_B0},{H8300_GPIO_P6,H8300_GPIO_B1},
+	{H8300_GPIO_P6,H8300_GPIO_B2},{H8300_GPIO_P6,H8300_GPIO_B3},
+	{H8300_GPIO_P6,H8300_GPIO_B4},{H8300_GPIO_P6,H8300_GPIO_B5},
+	{H8300_GPIO_PF,H8300_GPIO_B1},{H8300_GPIO_PF,H8300_GPIO_B2},
+};
+/* ISTR = 1 */
+static const struct irq_pins irq_assign_table1[16]={
+	{H8300_GPIO_P8,H8300_GPIO_B0},{H8300_GPIO_P8,H8300_GPIO_B1},
+	{H8300_GPIO_P8,H8300_GPIO_B2},{H8300_GPIO_P8,H8300_GPIO_B3},
+	{H8300_GPIO_P8,H8300_GPIO_B4},{H8300_GPIO_P8,H8300_GPIO_B5},
+	{H8300_GPIO_PH,H8300_GPIO_B2},{H8300_GPIO_PH,H8300_GPIO_B3},
+	{H8300_GPIO_P2,H8300_GPIO_B0},{H8300_GPIO_P2,H8300_GPIO_B1},
+	{H8300_GPIO_P2,H8300_GPIO_B2},{H8300_GPIO_P2,H8300_GPIO_B3},
+	{H8300_GPIO_P2,H8300_GPIO_B4},{H8300_GPIO_P2,H8300_GPIO_B5},
+	{H8300_GPIO_P2,H8300_GPIO_B6},{H8300_GPIO_P2,H8300_GPIO_B7},
+};
+
+/* IRQ to GPIO pin translation */
+#define IRQ_GPIO_MAP(irqbit,irq,port,bit)			  \
+do {								  \
+	if (*(volatile unsigned short *)ITSR & irqbit) {	  \
+		port = irq_assign_table1[irq - EXT_IRQ0].port_no; \
+		bit  = irq_assign_table1[irq - EXT_IRQ0].bit_no;  \
+	} else {						  \
+		port = irq_assign_table0[irq - EXT_IRQ0].port_no; \
+		bit  = irq_assign_table0[irq - EXT_IRQ0].bit_no;  \
+	}							  \
+} while(0)
+
+int h8300_enable_irq_pin(unsigned int irq)
+{
+	if (irq >= EXT_IRQ0 && irq <= EXT_IRQ15) {
+		unsigned short ptn = 1 << (irq - EXT_IRQ0);
+		unsigned int port_no,bit_no;
+		IRQ_GPIO_MAP(ptn, irq, port_no, bit_no);
+		if (H8300_GPIO_RESERVE(port_no, bit_no) == 0)
+			return -EBUSY;                   /* pin already use */
+		H8300_GPIO_DDR(port_no, bit_no, H8300_GPIO_INPUT);
+		*(volatile unsigned short *)ISR &= ~ptn; /* ISR clear */
+	}
+
+	return 0;
+}
+
+void h8300_disable_irq_pin(unsigned int irq)
+{
+	if (irq >= EXT_IRQ0 && irq <= EXT_IRQ15) {
+		/* disable interrupt & release IRQ pin */
+		unsigned short ptn = 1 << (irq - EXT_IRQ0);
+		unsigned short port_no,bit_no;
+		*(volatile unsigned short *)ISR &= ~ptn;
+		*(volatile unsigned short *)IER &= ~ptn;
+		IRQ_GPIO_MAP(ptn, irq, port_no, bit_no);
+		H8300_GPIO_FREE(port_no, bit_no);
+	}
+}
diff -puN include/asm-h8300/hardirq.h~h8300-irq-handling-update include/asm-h8300/hardirq.h
--- a/include/asm-h8300/hardirq.h~h8300-irq-handling-update
+++ a/include/asm-h8300/hardirq.h
@@ -12,6 +12,8 @@ typedef struct {
 
 #include <linux/irq_cpustat.h>	/* Standard mappings for irq_cpustat_t above */
 
+extern void ack_bad_irq(unsigned int irq);
+
 #define HARDIRQ_BITS	8
 
 /*
diff -puN include/asm-h8300/irq.h~h8300-irq-handling-update include/asm-h8300/irq.h
--- a/include/asm-h8300/irq.h~h8300-irq-handling-update
+++ a/include/asm-h8300/irq.h
@@ -3,7 +3,7 @@
 
 #include <asm/ptrace.h>
 
-#if defined(__H8300H__)
+#if defined(CONFIG_CPU_H8300H)
 #define NR_IRQS 64
 #define EXT_IRQ0 12
 #define EXT_IRQ1 13
@@ -14,14 +14,6 @@
 #define EXT_IRQ6 18
 #define EXT_IRQ7 19
 #define EXT_IRQS 5
-
-#include <asm/regs306x.h>
-#define h8300_clear_isr(irq)                                                \
-do {                                                                        \
-	if (irq >= EXT_IRQ0 && irq <= EXT_IRQ5)                             \
-		*(volatile unsigned char *)ISR &= ~(1 << (irq - EXT_IRQ0)); \
-} while(0)
-
 #define IER_REGS *(volatile unsigned char *)IER
 #endif
 #if defined(CONFIG_CPU_H8S)
@@ -44,13 +36,6 @@ do {                                    
 #define EXT_IRQ15 31
 #define EXT_IRQS 15
 
-#include <asm/regs267x.h>
-#define h8300_clear_isr(irq)                                                 \
-do {                                                                         \
-	if (irq >= EXT_IRQ0 && irq <= EXT_IRQ15)                             \
-		*(volatile unsigned short *)ISR &= ~(1 << (irq - EXT_IRQ0)); \
-} while(0)
-
 #define IER_REGS *(volatile unsigned short *)IER
 #endif
 
@@ -59,4 +44,6 @@ static __inline__ int irq_canonicalize(i
 	return irq;
 }
 
+typedef void (*h8300_vector)(void);
+
 #endif /* _H8300_IRQ_H_ */
_

Patches currently in -mm which might be from ysato@users.sourceforge.jp are

h8300-signalc-typo-fix.patch
h8300-uaccessh-update.patch
h8300-config_kallsyms-fix.patch
h8300-irq-handling-update.patch
h8300-defconfig-update.patch
inflate-refactor-inflate-malloc-code.patch
elf-use-elf_core_eflags-for-kcore-elf-header-flags.patch
