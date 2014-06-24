From: akpm@linux-foundation.org
Subject: [merged]
 nmi-provide-the-option-to-issue-an-nmi-back-trace-to-every-cpu-but-current.patch removed from -mm tree
Date: Tue, 24 Jun 2014 12:02:31 -0700
Message-ID: <53a9cb47.40fwoKVyXzQ9yiM1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35597 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752686AbaFXTCc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Jun 2014 15:02:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: atomlin@redhat.com, davem@davemloft.net, dzickus@redhat.com, mguzik@redhat.com, oleg@redhat.com, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: nmi: provide the option to issue an NMI back trace to every cpu but current
has been removed from the -mm tree.  Its filename was
     nmi-provide-the-option-to-issue-an-nmi-back-trace-to-every-cpu-but-current.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Aaron Tomlin <atomlin@redhat.com>
Subject: nmi: provide the option to issue an NMI back trace to every cpu but current

Sometimes it is preferred not to use the trigger_all_cpu_backtrace()
routine when one wants to avoid capturing a back trace for current.  For
instance if one was previously captured recently.

This patch provides a new routine namely
trigger_allbutself_cpu_backtrace() which offers the flexibility to issue
an NMI to every cpu but current and capture a back trace accordingly.

Patch x86 and sparc to support new routine.

[dzickus@redhat.com: add stub in #else clause]
[dzickus@redhat.com: don't print message in single processor case, wrap with get/put_cpu based on Oleg's suggestion]
[sfr@canb.auug.org.au: undo C99ism]
Signed-off-by: Aaron Tomlin <atomlin@redhat.com>
Signed-off-by: Don Zickus <dzickus@redhat.com>
Acked-by: David S. Miller <davem@davemloft.net>
Cc: Mateusz Guzik <mguzik@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/include/asm/irq_64.h |    2 +-
 arch/sparc/kernel/process_64.c  |   18 ++++++++++++------
 arch/x86/include/asm/irq.h      |    2 +-
 arch/x86/kernel/apic/hw_nmi.c   |   18 ++++++++++++++----
 include/linux/nmi.h             |   11 ++++++++++-
 5 files changed, 38 insertions(+), 13 deletions(-)

diff -puN arch/sparc/include/asm/irq_64.h~nmi-provide-the-option-to-issue-an-nmi-back-trace-to-every-cpu-but-current arch/sparc/include/asm/irq_64.h
--- a/arch/sparc/include/asm/irq_64.h~nmi-provide-the-option-to-issue-an-nmi-back-trace-to-every-cpu-but-current
+++ a/arch/sparc/include/asm/irq_64.h
@@ -89,7 +89,7 @@ static inline unsigned long get_softint(
 	return retval;
 }
 
-void arch_trigger_all_cpu_backtrace(void);
+void arch_trigger_all_cpu_backtrace(bool);
 #define arch_trigger_all_cpu_backtrace arch_trigger_all_cpu_backtrace
 
 extern void *hardirq_stack[NR_CPUS];
diff -puN arch/sparc/kernel/process_64.c~nmi-provide-the-option-to-issue-an-nmi-back-trace-to-every-cpu-but-current arch/sparc/kernel/process_64.c
--- a/arch/sparc/kernel/process_64.c~nmi-provide-the-option-to-issue-an-nmi-back-trace-to-every-cpu-but-current
+++ a/arch/sparc/kernel/process_64.c
@@ -239,7 +239,7 @@ static void __global_reg_poll(struct glo
 	}
 }
 
-void arch_trigger_all_cpu_backtrace(void)
+void arch_trigger_all_cpu_backtrace(bool include_self)
 {
 	struct thread_info *tp = current_thread_info();
 	struct pt_regs *regs = get_irq_regs();
@@ -251,16 +251,22 @@ void arch_trigger_all_cpu_backtrace(void
 
 	spin_lock_irqsave(&global_cpu_snapshot_lock, flags);
 
-	memset(global_cpu_snapshot, 0, sizeof(global_cpu_snapshot));
-
 	this_cpu = raw_smp_processor_id();
 
-	__global_reg_self(tp, regs, this_cpu);
+	memset(global_cpu_snapshot, 0, sizeof(global_cpu_snapshot));
+
+	if (include_self)
+		__global_reg_self(tp, regs, this_cpu);
 
 	smp_fetch_global_regs();
 
 	for_each_online_cpu(cpu) {
-		struct global_reg_snapshot *gp = &global_cpu_snapshot[cpu].reg;
+		struct global_reg_snapshot *gp;
+
+		if (!include_self && cpu == this_cpu)
+			continue;
+
+		gp = &global_cpu_snapshot[cpu].reg;
 
 		__global_reg_poll(gp);
 
@@ -292,7 +298,7 @@ void arch_trigger_all_cpu_backtrace(void
 
 static void sysrq_handle_globreg(int key)
 {
-	arch_trigger_all_cpu_backtrace();
+	arch_trigger_all_cpu_backtrace(true);
 }
 
 static struct sysrq_key_op sparc_globalreg_op = {
diff -puN arch/x86/include/asm/irq.h~nmi-provide-the-option-to-issue-an-nmi-back-trace-to-every-cpu-but-current arch/x86/include/asm/irq.h
--- a/arch/x86/include/asm/irq.h~nmi-provide-the-option-to-issue-an-nmi-back-trace-to-every-cpu-but-current
+++ a/arch/x86/include/asm/irq.h
@@ -43,7 +43,7 @@ extern int vector_used_by_percpu_irq(uns
 extern void init_ISA_irqs(void);
 
 #ifdef CONFIG_X86_LOCAL_APIC
-void arch_trigger_all_cpu_backtrace(void);
+void arch_trigger_all_cpu_backtrace(bool);
 #define arch_trigger_all_cpu_backtrace arch_trigger_all_cpu_backtrace
 #endif
 
diff -puN arch/x86/kernel/apic/hw_nmi.c~nmi-provide-the-option-to-issue-an-nmi-back-trace-to-every-cpu-but-current arch/x86/kernel/apic/hw_nmi.c
--- a/arch/x86/kernel/apic/hw_nmi.c~nmi-provide-the-option-to-issue-an-nmi-back-trace-to-every-cpu-but-current
+++ a/arch/x86/kernel/apic/hw_nmi.c
@@ -33,31 +33,41 @@ static DECLARE_BITMAP(backtrace_mask, NR
 /* "in progress" flag of arch_trigger_all_cpu_backtrace */
 static unsigned long backtrace_flag;
 
-void arch_trigger_all_cpu_backtrace(void)
+void arch_trigger_all_cpu_backtrace(bool include_self)
 {
 	int i;
+	int cpu = get_cpu();
 
-	if (test_and_set_bit(0, &backtrace_flag))
+	if (test_and_set_bit(0, &backtrace_flag)) {
 		/*
 		 * If there is already a trigger_all_cpu_backtrace() in progress
 		 * (backtrace_flag == 1), don't output double cpu dump infos.
 		 */
+		put_cpu();
 		return;
+	}
 
 	cpumask_copy(to_cpumask(backtrace_mask), cpu_online_mask);
+	if (!include_self)
+		cpumask_clear_cpu(cpu, to_cpumask(backtrace_mask));
 
-	printk(KERN_INFO "sending NMI to all CPUs:\n");
-	apic->send_IPI_all(NMI_VECTOR);
+	if (!cpumask_empty(to_cpumask(backtrace_mask))) {
+		pr_info("sending NMI to %s CPUs:\n",
+			(include_self ? "all" : "other"));
+		apic->send_IPI_mask(to_cpumask(backtrace_mask), NMI_VECTOR);
+	}
 
 	/* Wait for up to 10 seconds for all CPUs to do the backtrace */
 	for (i = 0; i < 10 * 1000; i++) {
 		if (cpumask_empty(to_cpumask(backtrace_mask)))
 			break;
 		mdelay(1);
+		touch_softlockup_watchdog();
 	}
 
 	clear_bit(0, &backtrace_flag);
 	smp_mb__after_atomic();
+	put_cpu();
 }
 
 static int
diff -puN include/linux/nmi.h~nmi-provide-the-option-to-issue-an-nmi-back-trace-to-every-cpu-but-current include/linux/nmi.h
--- a/include/linux/nmi.h~nmi-provide-the-option-to-issue-an-nmi-back-trace-to-every-cpu-but-current
+++ a/include/linux/nmi.h
@@ -32,15 +32,24 @@ static inline void touch_nmi_watchdog(vo
 #ifdef arch_trigger_all_cpu_backtrace
 static inline bool trigger_all_cpu_backtrace(void)
 {
-	arch_trigger_all_cpu_backtrace();
+	arch_trigger_all_cpu_backtrace(true);
 
 	return true;
 }
+static inline bool trigger_allbutself_cpu_backtrace(void)
+{
+	arch_trigger_all_cpu_backtrace(false);
+	return true;
+}
 #else
 static inline bool trigger_all_cpu_backtrace(void)
 {
 	return false;
 }
+static inline bool trigger_allbutself_cpu_backtrace(void)
+{
+	return false;
+}
 #endif
 
 #ifdef CONFIG_LOCKUP_DETECTOR
_

Patches currently in -mm which might be from atomlin@redhat.com are

origin.patch

