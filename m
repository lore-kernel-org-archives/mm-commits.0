From: akpm@linux-foundation.org
Subject: - vmi-timer-fixes-round-two.patch removed from -mm tree
Date: Mon, 05 Mar 2007 15:55:09 -0800
Message-ID: <200703052355.l25Nt9Cr005167@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41911 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932515AbXCEXzL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 18:55:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zach@vmware.com, dhecht@vmware.com, mm-commits@vger.kernel.org


The patch titled
     vmi: timer fixes round two
has been removed from the -mm tree.  Its filename was
     vmi-timer-fixes-round-two.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: vmi: timer fixes round two
From: Zachary Amsden <zach@vmware.com>

Critical bugfixes for the VMI-Timer code.

1) Do not setup a one shot alarm if we are keeping the periodic alarm
   armed.  Additionally, since the periodic alarm can be run at a lower rate
   than HZ, let's fixup the guard to the no-idle-hz mode appropriately.  This
   fixes the bug where the no-idle-hz mode might have a higher interrupt rate
   than the non-idle case.

2) The interrupt handler can no longer adjust xtime due to nested lock
   acquisition.  Drop this.  We don't need to check for wallclock time at
   every tick, it can be done in userspace instead.

3) Add a bypass to disable noidle operation.  This is useful as a last
   minute workaround, or testing measure.

4) The code to skip the IO_APIC timer testing (no_timer_check) should be
   conditional on IO_APIC, not SMP, since UP kernels can have this configured
   in as well.

Signed-off-by: Dan Hecht <dhecht@vmware.com>
Signed-off-by: Zachary Amsden <zach@vmware.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/vmi.c     |   23 +++++++++++++----------
 arch/i386/kernel/vmitime.c |   30 +++++++++++-------------------
 2 files changed, 24 insertions(+), 29 deletions(-)

diff -puN arch/i386/kernel/vmi.c~vmi-timer-fixes-round-two arch/i386/kernel/vmi.c
--- a/arch/i386/kernel/vmi.c~vmi-timer-fixes-round-two
+++ a/arch/i386/kernel/vmi.c
@@ -54,6 +54,7 @@ static int disable_pse;
 static int disable_sep;
 static int disable_tsc;
 static int disable_mtrr;
+static int disable_noidle;
 
 /* Cached VMI operations */
 struct {
@@ -255,7 +256,6 @@ static void vmi_nop(void)
 }
 
 /* For NO_IDLE_HZ, we stop the clock when halting the kernel */
-#ifdef CONFIG_NO_IDLE_HZ
 static fastcall void vmi_safe_halt(void)
 {
 	int idle = vmi_stop_hz_timer();
@@ -266,7 +266,6 @@ static fastcall void vmi_safe_halt(void)
 		local_irq_enable();
 	}
 }
-#endif
 
 #ifdef CONFIG_DEBUG_PAGE_TYPE
 
@@ -742,12 +741,7 @@ static inline int __init activate_vmi(vo
 		     (char *)paravirt_ops.save_fl);
 	patch_offset(&irq_save_disable_callout[IRQ_PATCH_DISABLE],
 		     (char *)paravirt_ops.irq_disable);
-#ifndef CONFIG_NO_IDLE_HZ
-	para_fill(safe_halt, Halt);
-#else
-	vmi_ops.halt = vmi_get_function(VMI_CALL_Halt);
-	paravirt_ops.safe_halt = vmi_safe_halt;
-#endif
+
 	para_fill(wbinvd, WBINVD);
 	/* paravirt_ops.read_msr = vmi_rdmsr */
 	/* paravirt_ops.write_msr = vmi_wrmsr */
@@ -881,6 +875,12 @@ static inline int __init activate_vmi(vo
 #endif
 		custom_sched_clock = vmi_sched_clock;
 	}
+	if (!disable_noidle)
+		para_fill(safe_halt, Halt);
+	else {
+		vmi_ops.halt = vmi_get_function(VMI_CALL_Halt);
+		paravirt_ops.safe_halt = vmi_safe_halt;
+	}
 
 	/*
 	 * Alternative instruction rewriting doesn't happen soon enough
@@ -914,9 +914,11 @@ void __init vmi_init(void)
 
 	local_irq_save(flags);
 	activate_vmi();
-#ifdef CONFIG_SMP
+
+#ifdef CONFIG_X86_IO_APIC
 	no_timer_check = 1;
 #endif
+
 	local_irq_restore(flags & X86_EFLAGS_IF);
 }
 
@@ -942,7 +944,8 @@ static int __init parse_vmi(char *arg)
 	} else if (!strcmp(arg, "disable_mtrr")) {
 		clear_bit(X86_FEATURE_MTRR, boot_cpu_data.x86_capability);
 		disable_mtrr = 1;
-	}
+	} else if (!strcmp(arg, "disable_noidle"))
+		disable_noidle = 1;
 	return 0;
 }
 
diff -puN arch/i386/kernel/vmitime.c~vmi-timer-fixes-round-two arch/i386/kernel/vmitime.c
--- a/arch/i386/kernel/vmitime.c~vmi-timer-fixes-round-two
+++ a/arch/i386/kernel/vmitime.c
@@ -276,16 +276,13 @@ static void vmi_account_real_cycles(unsi
 
 	cycles_not_accounted = cur_real_cycles - real_cycles_accounted_system;
 	while (cycles_not_accounted >= cycles_per_jiffy) {
-		/* systems wide jiffies and wallclock. */
+		/* systems wide jiffies. */
 		do_timer(1);
 
 		cycles_not_accounted -= cycles_per_jiffy;
 		real_cycles_accounted_system += cycles_per_jiffy;
 	}
 
-	if (vmi_timer_ops.wallclock_updated())
-		update_xtime_from_wallclock();
-
 	write_sequnlock(&xtime_lock);
 }
 
@@ -380,7 +377,6 @@ int vmi_stop_hz_timer(void)
 	unsigned long seq, next;
 	unsigned long long real_cycles_expiry;
 	int cpu = smp_processor_id();
-	int idle;
 
 	BUG_ON(!irqs_disabled());
 	if (sysctl_hz_timer != 0)
@@ -388,13 +384,13 @@ int vmi_stop_hz_timer(void)
 
 	cpu_set(cpu, nohz_cpu_mask);
 	smp_mb();
+
 	if (rcu_needs_cpu(cpu) || local_softirq_pending() ||
-	    (next = next_timer_interrupt(), time_before_eq(next, jiffies))) {
+	    (next = next_timer_interrupt(),
+	     time_before_eq(next, jiffies + HZ/CONFIG_VMI_ALARM_HZ))) {
 		cpu_clear(cpu, nohz_cpu_mask);
-		next = jiffies;
-		idle = 0;
-	} else
-		idle = 1;
+		return 0;
+	}
 
 	/* Convert jiffies to the real cycle counter. */
 	do {
@@ -404,17 +400,13 @@ int vmi_stop_hz_timer(void)
 	} while (read_seqretry(&xtime_lock, seq));
 
 	/* This cpu is going idle. Disable the periodic alarm. */
-	if (idle) {
-		vmi_timer_ops.cancel_alarm(VMI_CYCLES_AVAILABLE);
-		per_cpu(idle_start_jiffies, cpu) = jiffies;
-	}
-
+	vmi_timer_ops.cancel_alarm(VMI_CYCLES_AVAILABLE);
+	per_cpu(idle_start_jiffies, cpu) = jiffies;
 	/* Set the real time alarm to expire at the next event. */
 	vmi_timer_ops.set_alarm(
-		      VMI_ALARM_WIRING | VMI_ALARM_IS_ONESHOT | VMI_CYCLES_REAL,
-		      real_cycles_expiry, 0);
-
-	return idle;
+		VMI_ALARM_WIRING | VMI_ALARM_IS_ONESHOT | VMI_CYCLES_REAL,
+		real_cycles_expiry, 0);
+	return 1;
 }
 
 static void vmi_reenable_hz_timer(int cpu)
_

Patches currently in -mm which might be from zach@vmware.com are

origin.patch
make-struct-vmi_ops-static.patch
