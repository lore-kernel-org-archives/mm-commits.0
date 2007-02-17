From: akpm@linux-foundation.org
Subject: - add-a-functions-to-handle-interrupt-affinity-setting.patch removed from -mm tree
Date: Fri, 16 Feb 2007 23:13:23 -0800
Message-ID: <200702170713.l1H7DNax021449@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51324 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946584AbXBQHUC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 17 Feb 2007 02:20:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, johnstul@us.ibm.com, mingo@elte.hu, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     Add a function to handle interrupt affinity setting
has been removed from the -mm tree.  Its filename was
     add-a-functions-to-handle-interrupt-affinity-setting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Add a function to handle interrupt affinity setting
From: Thomas Gleixner <tglx@linutronix.de>

Provide funtions to:
 - check, whether an interrupt can set the affinity
 - pin the interrupt to a given cpu

Necessary for the ability to setup clocksources more flexible (e.g.  use the
different HPET channels per CPU)

[akpm@osdl.org: alpha build fix]
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/irq.h |   10 ++++++++++
 kernel/irq/manage.c |   40 ++++++++++++++++++++++++++++++++++++++++
 kernel/irq/proc.c   |   22 +---------------------
 3 files changed, 51 insertions(+), 21 deletions(-)

diff -puN include/linux/irq.h~add-a-functions-to-handle-interrupt-affinity-setting include/linux/irq.h
--- a/include/linux/irq.h~add-a-functions-to-handle-interrupt-affinity-setting
+++ a/include/linux/irq.h
@@ -238,11 +238,21 @@ static inline void set_pending_irq(unsig
 
 #endif /* CONFIG_GENERIC_PENDING_IRQ */
 
+extern int irq_set_affinity(unsigned int irq, cpumask_t cpumask);
+extern int irq_can_set_affinity(unsigned int irq);
+
 #else /* CONFIG_SMP */
 
 #define move_native_irq(x)
 #define move_masked_irq(x)
 
+static inline int irq_set_affinity(unsigned int irq, cpumask_t cpumask)
+{
+	return -EINVAL;
+}
+
+static inline int irq_can_set_affinity(unsigned int irq) { return 0; }
+
 #endif /* CONFIG_SMP */
 
 #ifdef CONFIG_IRQBALANCE
diff -puN kernel/irq/manage.c~add-a-functions-to-handle-interrupt-affinity-setting kernel/irq/manage.c
--- a/kernel/irq/manage.c~add-a-functions-to-handle-interrupt-affinity-setting
+++ a/kernel/irq/manage.c
@@ -38,6 +38,46 @@ void synchronize_irq(unsigned int irq)
 }
 EXPORT_SYMBOL(synchronize_irq);
 
+/**
+ *	irq_can_set_affinity - Check if the affinity of a given irq can be set
+ *	@irq:		Interrupt to check
+ *
+ */
+int irq_can_set_affinity(unsigned int irq)
+{
+	struct irq_desc *desc = irq_desc + irq;
+
+	if (CHECK_IRQ_PER_CPU(desc->status) || !desc->chip ||
+	    !desc->chip->set_affinity)
+		return 0;
+
+	return 1;
+}
+
+/**
+ *	irq_set_affinity - Set the irq affinity of a given irq
+ *	@irq:		Interrupt to set affinity
+ *	@cpumask:	cpumask
+ *
+ */
+int irq_set_affinity(unsigned int irq, cpumask_t cpumask)
+{
+	struct irq_desc *desc = irq_desc + irq;
+
+	if (!desc->chip->set_affinity)
+		return -EINVAL;
+
+	set_balance_irq_affinity(irq, cpumask);
+
+#ifdef CONFIG_GENERIC_PENDING_IRQ
+	set_pending_irq(irq, cpumask);
+#else
+	desc->affinity = cpumask;
+	desc->chip->set_affinity(irq, cpumask);
+#endif
+	return 0;
+}
+
 #endif
 
 /**
diff -puN kernel/irq/proc.c~add-a-functions-to-handle-interrupt-affinity-setting kernel/irq/proc.c
--- a/kernel/irq/proc.c~add-a-functions-to-handle-interrupt-affinity-setting
+++ a/kernel/irq/proc.c
@@ -16,26 +16,6 @@ static struct proc_dir_entry *root_irq_d
 
 #ifdef CONFIG_SMP
 
-#ifdef CONFIG_GENERIC_PENDING_IRQ
-void proc_set_irq_affinity(unsigned int irq, cpumask_t mask_val)
-{
-	set_balance_irq_affinity(irq, mask_val);
-
-	/*
-	 * Save these away for later use. Re-progam when the
-	 * interrupt is pending
-	 */
-	set_pending_irq(irq, mask_val);
-}
-#else
-void proc_set_irq_affinity(unsigned int irq, cpumask_t mask_val)
-{
-	set_balance_irq_affinity(irq, mask_val);
-	irq_desc[irq].affinity = mask_val;
-	irq_desc[irq].chip->set_affinity(irq, mask_val);
-}
-#endif
-
 static int irq_affinity_read_proc(char *page, char **start, off_t off,
 				  int count, int *eof, void *data)
 {
@@ -73,7 +53,7 @@ static int irq_affinity_write_proc(struc
 		   code to set default SMP affinity. */
 		return select_smp_affinity(irq) ? -EINVAL : full_count;
 
-	proc_set_irq_affinity(irq, new_value);
+	irq_set_affinity(irq, new_value);
 
 	return full_count;
 }
_

Patches currently in -mm which might be from tglx@linutronix.de are

origin.patch
git-acpi.patch
git-block.patch
scheduled-removal-of-sa_xxx-interrupt-flags-fixups-3.patch
