From: akpm@linux-foundation.org
Subject: - add-irq-flag-to-disable-balancing-for-an-interrupt.patch removed from -mm tree
Date: Fri, 16 Feb 2007 23:13:18 -0800
Message-ID: <200702170713.l1H7DIXv021446@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51196 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946526AbXBQHRB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 17 Feb 2007 02:17:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, johnstul@us.ibm.com, mingo@elte.hu, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     Add irq flag to disable balancing for an interrupt
has been removed from the -mm tree.  Its filename was
     add-irq-flag-to-disable-balancing-for-an-interrupt.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Add irq flag to disable balancing for an interrupt
From: Thomas Gleixner <tglx@linutronix.de>

Add a flag so we can prevent the irq balancing of an interrupt.  Move the
bits, so we have room for more :)

Necessary for the ability to setup clocksources more flexible (e.g.  use the
different HPET channels per CPU)

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/io_apic.c |    4 +--
 include/linux/interrupt.h  |    3 ++
 include/linux/irq.h        |   42 ++++++++++++++++++++---------------
 kernel/irq/manage.c        |    4 +++
 kernel/irq/proc.c          |    2 -
 5 files changed, 35 insertions(+), 20 deletions(-)

diff -puN arch/i386/kernel/io_apic.c~add-irq-flag-to-disable-balancing-for-an-interrupt arch/i386/kernel/io_apic.c
--- a/arch/i386/kernel/io_apic.c~add-irq-flag-to-disable-balancing-for-an-interrupt
+++ a/arch/i386/kernel/io_apic.c
@@ -482,8 +482,8 @@ static void do_irq_balance(void)
 		package_index = CPU_TO_PACKAGEINDEX(i);
 		for (j = 0; j < NR_IRQS; j++) {
 			unsigned long value_now, delta;
-			/* Is this an active IRQ? */
-			if (!irq_desc[j].action)
+			/* Is this an active IRQ or balancing disabled ? */
+			if (!irq_desc[j].action || irq_balancing_disabled(j))
 				continue;
 			if ( package_index == i )
 				IRQ_DELTA(package_index,j) = 0;
diff -puN include/linux/interrupt.h~add-irq-flag-to-disable-balancing-for-an-interrupt include/linux/interrupt.h
--- a/include/linux/interrupt.h~add-irq-flag-to-disable-balancing-for-an-interrupt
+++ a/include/linux/interrupt.h
@@ -42,6 +42,8 @@
  * IRQF_SHARED - allow sharing the irq among several devices
  * IRQF_PROBE_SHARED - set by callers when they expect sharing mismatches to occur
  * IRQF_TIMER - Flag to mark this interrupt as timer interrupt
+ * IRQF_PERCPU - Interrupt is per cpu
+ * IRQF_NOBALANCING - Flag to exclude this interrupt from irq balancing
  */
 #define IRQF_DISABLED		0x00000020
 #define IRQF_SAMPLE_RANDOM	0x00000040
@@ -49,6 +51,7 @@
 #define IRQF_PROBE_SHARED	0x00000100
 #define IRQF_TIMER		0x00000200
 #define IRQF_PERCPU		0x00000400
+#define IRQF_NOBALANCING	0x00000800
 
 /*
  * Migration helpers. Scheduled for removal in 1/2007
diff -puN include/linux/irq.h~add-irq-flag-to-disable-balancing-for-an-interrupt include/linux/irq.h
--- a/include/linux/irq.h~add-irq-flag-to-disable-balancing-for-an-interrupt
+++ a/include/linux/irq.h
@@ -31,7 +31,7 @@ typedef	void fastcall (*irq_flow_handler
 /*
  * IRQ line status.
  *
- * Bits 0-16 are reserved for the IRQF_* bits in linux/interrupt.h
+ * Bits 0-7 are reserved for the IRQF_* bits in linux/interrupt.h
  *
  * IRQ types
  */
@@ -45,28 +45,31 @@ typedef	void fastcall (*irq_flow_handler
 #define IRQ_TYPE_PROBE		0x00000010	/* Probing in progress */
 
 /* Internal flags */
-#define IRQ_INPROGRESS		0x00010000	/* IRQ handler active - do not enter! */
-#define IRQ_DISABLED		0x00020000	/* IRQ disabled - do not enter! */
-#define IRQ_PENDING		0x00040000	/* IRQ pending - replay on enable */
-#define IRQ_REPLAY		0x00080000	/* IRQ has been replayed but not acked yet */
-#define IRQ_AUTODETECT		0x00100000	/* IRQ is being autodetected */
-#define IRQ_WAITING		0x00200000	/* IRQ not yet seen - for autodetection */
-#define IRQ_LEVEL		0x00400000	/* IRQ level triggered */
-#define IRQ_MASKED		0x00800000	/* IRQ masked - shouldn't be seen again */
-#define IRQ_PER_CPU		0x01000000	/* IRQ is per CPU */
+#define IRQ_INPROGRESS		0x00000100	/* IRQ handler active - do not enter! */
+#define IRQ_DISABLED		0x00000200	/* IRQ disabled - do not enter! */
+#define IRQ_PENDING		0x00000400	/* IRQ pending - replay on enable */
+#define IRQ_REPLAY		0x00000800	/* IRQ has been replayed but not acked yet */
+#define IRQ_AUTODETECT		0x00001000	/* IRQ is being autodetected */
+#define IRQ_WAITING		0x00002000	/* IRQ not yet seen - for autodetection */
+#define IRQ_LEVEL		0x00004000	/* IRQ level triggered */
+#define IRQ_MASKED		0x00008000	/* IRQ masked - shouldn't be seen again */
+#define IRQ_PER_CPU		0x00010000	/* IRQ is per CPU */
+#define IRQ_NOPROBE		0x00020000	/* IRQ is not valid for probing */
+#define IRQ_NOREQUEST		0x00040000	/* IRQ cannot be requested */
+#define IRQ_NOAUTOEN		0x00080000	/* IRQ will not be enabled on request irq */
+#define IRQ_DELAYED_DISABLE	0x00100000	/* IRQ disable (masking) happens delayed. */
+#define IRQ_WAKEUP		0x00200000	/* IRQ triggers system wakeup */
+#define IRQ_MOVE_PENDING	0x00400000	/* need to re-target IRQ destination */
+#define IRQ_NO_BALANCING	0x00800000	/* IRQ is excluded from balancing */
+
 #ifdef CONFIG_IRQ_PER_CPU
 # define CHECK_IRQ_PER_CPU(var) ((var) & IRQ_PER_CPU)
+# define IRQ_NO_BALANCING_MASK	(IRQ_PER_CPU | IRQ_NO_BALANCING)
 #else
 # define CHECK_IRQ_PER_CPU(var) 0
+# define IRQ_NO_BALANCING_MASK	IRQ_NO_BALANCING
 #endif
 
-#define IRQ_NOPROBE		0x02000000	/* IRQ is not valid for probing */
-#define IRQ_NOREQUEST		0x04000000	/* IRQ cannot be requested */
-#define IRQ_NOAUTOEN		0x08000000	/* IRQ will not be enabled on request irq */
-#define IRQ_DELAYED_DISABLE	0x10000000	/* IRQ disable (masking) happens delayed. */
-#define IRQ_WAKEUP		0x20000000	/* IRQ triggers system wakeup */
-#define IRQ_MOVE_PENDING	0x40000000	/* need to re-target IRQ destination */
-
 struct proc_dir_entry;
 struct msi_desc;
 
@@ -261,6 +264,11 @@ static inline int select_smp_affinity(un
 
 extern int no_irq_affinity;
 
+static inline int irq_balancing_disabled(unsigned int irq)
+{
+	return irq_desc[irq].status & IRQ_NO_BALANCING_MASK;
+}
+
 /* Handle irq action chains: */
 extern int handle_IRQ_event(unsigned int irq, struct irqaction *action);
 
diff -puN kernel/irq/manage.c~add-irq-flag-to-disable-balancing-for-an-interrupt kernel/irq/manage.c
--- a/kernel/irq/manage.c~add-irq-flag-to-disable-balancing-for-an-interrupt
+++ a/kernel/irq/manage.c
@@ -281,6 +281,10 @@ int setup_irq(unsigned int irq, struct i
 	if (new->flags & IRQF_PERCPU)
 		desc->status |= IRQ_PER_CPU;
 #endif
+	/* Exclude IRQ from balancing */
+	if (new->flags & IRQF_NOBALANCING)
+		desc->status |= IRQ_NO_BALANCING;
+
 	if (!shared) {
 		irq_chip_set_defaults(desc->chip);
 
diff -puN kernel/irq/proc.c~add-irq-flag-to-disable-balancing-for-an-interrupt kernel/irq/proc.c
--- a/kernel/irq/proc.c~add-irq-flag-to-disable-balancing-for-an-interrupt
+++ a/kernel/irq/proc.c
@@ -55,7 +55,7 @@ static int irq_affinity_write_proc(struc
 	cpumask_t new_value, tmp;
 
 	if (!irq_desc[irq].chip->set_affinity || no_irq_affinity ||
-				CHECK_IRQ_PER_CPU(irq_desc[irq].status))
+	    irq_balancing_disabled(irq))
 		return -EIO;
 
 	err = cpumask_parse_user(buffer, count, new_value);
_

Patches currently in -mm which might be from tglx@linutronix.de are

origin.patch
git-acpi.patch
git-block.patch
scheduled-removal-of-sa_xxx-interrupt-flags-fixups-3.patch
