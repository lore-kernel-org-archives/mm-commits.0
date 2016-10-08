From: akpm@linux-foundation.org
Subject: [patch 119/127] arch/tile: adopt the new nmi_backtrace framework
Date: Fri, 07 Oct 2016 17:02:52 -0700
Message-ID: <57f837ac.ssbkHx4bUSmZLKJT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39676 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932593AbcJHACx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Oct 2016 20:02:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, cmetcalf@mellanox.com, atomlin@redhat.com, daniel.thompson@linaro.org, linux@arm.linux.org.uk, mingo@elte.hu, peterz@infradead.org, pmladek@suse.com, rjw@rjwysocki.net, tglx@linutronix.de

From: Chris Metcalf <cmetcalf@mellanox.com>
Subject: arch/tile: adopt the new nmi_backtrace framework

Previously tile was rolling its own method of capturing backtrace data in
the NMI handlers, but it was relying on running printk() from the NMI
handler, which is not always safe.  So adopt the nmi_backtrace model (with
the new cpumask extension) instead.

So we can call the nmi_backtrace code directly from the nmi handler, move
the nmi_enter()/exit() into the top-level tile NMI handler.

The semantics of the routine change slightly since it is now synchronous
with the remote cores completing the backtraces.  Previously it was
asynchronous, but with protection to avoid starting a new remote backtrace
if the old one was still in progress.

Link: http://lkml.kernel.org/r/1472487169-14923-4-git-send-email-cmetcalf@mellanox.com
Signed-off-by: Chris Metcalf <cmetcalf@mellanox.com>
Cc: Daniel Thompson <daniel.thompson@linaro.org> [arm]
Cc: Petr Mladek <pmladek@suse.com>
Cc: Aaron Tomlin <atomlin@redhat.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/tile/include/asm/irq.h |    5 +-
 arch/tile/kernel/pmc.c      |    3 -
 arch/tile/kernel/process.c  |   73 +++++++---------------------------
 arch/tile/kernel/traps.c    |    9 +++-
 4 files changed, 27 insertions(+), 63 deletions(-)

diff -puN arch/tile/include/asm/irq.h~arch-tile-adopt-the-new-nmi_backtrace-framework arch/tile/include/asm/irq.h
--- a/arch/tile/include/asm/irq.h~arch-tile-adopt-the-new-nmi_backtrace-framework
+++ a/arch/tile/include/asm/irq.h
@@ -79,8 +79,9 @@ void tile_irq_activate(unsigned int irq,
 void setup_irq_regs(void);
 
 #ifdef __tilegx__
-void arch_trigger_all_cpu_backtrace(bool self);
-#define arch_trigger_all_cpu_backtrace arch_trigger_all_cpu_backtrace
+void arch_trigger_cpumask_backtrace(const struct cpumask *mask,
+				    bool exclude_self);
+#define arch_trigger_cpumask_backtrace arch_trigger_cpumask_backtrace
 #endif
 
 #endif /* _ASM_TILE_IRQ_H */
diff -puN arch/tile/kernel/pmc.c~arch-tile-adopt-the-new-nmi_backtrace-framework arch/tile/kernel/pmc.c
--- a/arch/tile/kernel/pmc.c~arch-tile-adopt-the-new-nmi_backtrace-framework
+++ a/arch/tile/kernel/pmc.c
@@ -16,7 +16,6 @@
 #include <linux/spinlock.h>
 #include <linux/module.h>
 #include <linux/atomic.h>
-#include <linux/interrupt.h>
 
 #include <asm/processor.h>
 #include <asm/pmc.h>
@@ -29,9 +28,7 @@ int handle_perf_interrupt(struct pt_regs
 	if (!perf_irq)
 		panic("Unexpected PERF_COUNT interrupt %d\n", fault);
 
-	nmi_enter();
 	retval = perf_irq(regs, fault);
-	nmi_exit();
 	return retval;
 }
 
diff -puN arch/tile/kernel/process.c~arch-tile-adopt-the-new-nmi_backtrace-framework arch/tile/kernel/process.c
--- a/arch/tile/kernel/process.c~arch-tile-adopt-the-new-nmi_backtrace-framework
+++ a/arch/tile/kernel/process.c
@@ -22,7 +22,7 @@
 #include <linux/init.h>
 #include <linux/mm.h>
 #include <linux/compat.h>
-#include <linux/hardirq.h>
+#include <linux/nmi.h>
 #include <linux/syscalls.h>
 #include <linux/kernel.h>
 #include <linux/tracehook.h>
@@ -594,66 +594,18 @@ void show_regs(struct pt_regs *regs)
 	tile_show_stack(&kbt);
 }
 
-/* To ensure stack dump on tiles occurs one by one. */
-static DEFINE_SPINLOCK(backtrace_lock);
-/* To ensure no backtrace occurs before all of the stack dump are done. */
-static atomic_t backtrace_cpus;
-/* The cpu mask to avoid reentrance. */
-static struct cpumask backtrace_mask;
-
-void do_nmi_dump_stack(struct pt_regs *regs)
-{
-	int is_idle = is_idle_task(current) && !in_interrupt();
-	int cpu;
-
-	nmi_enter();
-	cpu = smp_processor_id();
-	if (WARN_ON_ONCE(!cpumask_test_and_clear_cpu(cpu, &backtrace_mask)))
-		goto done;
-
-	spin_lock(&backtrace_lock);
-	if (is_idle)
-		pr_info("CPU: %d idle\n", cpu);
-	else
-		show_regs(regs);
-	spin_unlock(&backtrace_lock);
-	atomic_dec(&backtrace_cpus);
-done:
-	nmi_exit();
-}
-
 #ifdef __tilegx__
-void arch_trigger_all_cpu_backtrace(bool self)
+void nmi_raise_cpu_backtrace(struct cpumask *in_mask)
 {
 	struct cpumask mask;
 	HV_Coord tile;
 	unsigned int timeout;
 	int cpu;
-	int ongoing;
 	HV_NMI_Info info[NR_CPUS];
 
-	ongoing = atomic_cmpxchg(&backtrace_cpus, 0, num_online_cpus() - 1);
-	if (ongoing != 0) {
-		pr_err("Trying to do all-cpu backtrace.\n");
-		pr_err("But another all-cpu backtrace is ongoing (%d cpus left)\n",
-		       ongoing);
-		if (self) {
-			pr_err("Reporting the stack on this cpu only.\n");
-			dump_stack();
-		}
-		return;
-	}
-
-	cpumask_copy(&mask, cpu_online_mask);
-	cpumask_clear_cpu(smp_processor_id(), &mask);
-	cpumask_copy(&backtrace_mask, &mask);
-
-	/* Backtrace for myself first. */
-	if (self)
-		dump_stack();
-
 	/* Tentatively dump stack on remote tiles via NMI. */
 	timeout = 100;
+	cpumask_copy(&mask, in_mask);
 	while (!cpumask_empty(&mask) && timeout) {
 		for_each_cpu(cpu, &mask) {
 			tile.x = cpu_x(cpu);
@@ -664,12 +616,17 @@ void arch_trigger_all_cpu_backtrace(bool
 		}
 
 		mdelay(10);
+		touch_softlockup_watchdog();
 		timeout--;
 	}
 
-	/* Warn about cpus stuck in ICS and decrement their counts here. */
+	/* Warn about cpus stuck in ICS. */
 	if (!cpumask_empty(&mask)) {
 		for_each_cpu(cpu, &mask) {
+
+			/* Clear the bit as if nmi_cpu_backtrace() ran. */
+			cpumask_clear_cpu(cpu, in_mask);
+
 			switch (info[cpu].result) {
 			case HV_NMI_RESULT_FAIL_ICS:
 				pr_warn("Skipping stack dump of cpu %d in ICS at pc %#llx\n",
@@ -680,16 +637,20 @@ void arch_trigger_all_cpu_backtrace(bool
 					cpu);
 				break;
 			case HV_ENOSYS:
-				pr_warn("Hypervisor too old to allow remote stack dumps.\n");
-				goto skip_for_each;
+				WARN_ONCE(1, "Hypervisor too old to allow remote stack dumps.\n");
+				break;
 			default:  /* should not happen */
 				pr_warn("Skipping stack dump of cpu %d [%d,%#llx]\n",
 					cpu, info[cpu].result, info[cpu].pc);
 				break;
 			}
 		}
-skip_for_each:
-		atomic_sub(cpumask_weight(&mask), &backtrace_cpus);
 	}
 }
+
+void arch_trigger_cpumask_backtrace(const cpumask_t *mask, bool exclude_self)
+{
+	nmi_trigger_cpumask_backtrace(mask, exclude_self,
+				      nmi_raise_cpu_backtrace);
+}
 #endif /* __tilegx_ */
diff -puN arch/tile/kernel/traps.c~arch-tile-adopt-the-new-nmi_backtrace-framework arch/tile/kernel/traps.c
--- a/arch/tile/kernel/traps.c~arch-tile-adopt-the-new-nmi_backtrace-framework
+++ a/arch/tile/kernel/traps.c
@@ -20,6 +20,8 @@
 #include <linux/reboot.h>
 #include <linux/uaccess.h>
 #include <linux/ptrace.h>
+#include <linux/hardirq.h>
+#include <linux/nmi.h>
 #include <asm/stack.h>
 #include <asm/traps.h>
 #include <asm/setup.h>
@@ -392,14 +394,17 @@ void __kprobes do_trap(struct pt_regs *r
 
 void do_nmi(struct pt_regs *regs, int fault_num, unsigned long reason)
 {
+	nmi_enter();
 	switch (reason) {
+#ifdef arch_trigger_cpumask_backtrace
 	case TILE_NMI_DUMP_STACK:
-		do_nmi_dump_stack(regs);
+		nmi_cpu_backtrace(regs);
 		break;
+#endif
 	default:
 		panic("Unexpected do_nmi type %ld", reason);
-		return;
 	}
+	nmi_exit();
 }
 
 /* Deprecated function currently only used here. */
_
