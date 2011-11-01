From: akpm@linux-foundation.org
Subject: [merged] stop_machine-make-stop_machine-safe-and-efficient-to-call-early.patch removed from -mm tree
Date: Tue, 01 Nov 2011 14:14:06 -0700
Message-ID: <201111012114.pA1LE6DA014531@wpaz24.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:16360 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436Ab1KAVOi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2011 17:14:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeremy.fitzhardinge@citrix.com, a.p.zijlstra@chello.nl, hpa@linux.intel.com, htejun@gmail.com, konrad.wilk@oracle.com, mingo@elte.hu, rostedt@goodmis.org, rusty@rustcorp.com.au, tj@ke


The patch titled
     Subject: stop_machine: make stop_machine safe and efficient to call early
has been removed from the -mm tree.  Its filename was
     stop_machine-make-stop_machine-safe-and-efficient-to-call-early.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: stop_machine: make stop_machine safe and efficient to call early

Make stop_machine() safe to call early in boot, before SMP has been set
up, by simply calling the callback function directly if there's only one
CPU online.

[ Fixes from AKPM:
   - add comment
   - local_irq_flags, not save_flags
   - also call hard_irq_disable() for systems which need it

  Tejun suggested using an explicit flag rather than just looking at
  the online cpu count. ]

Cc: Tejun Heo <tj@kernel.org>
Acked-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: H. Peter Anvin <hpa@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>
Acked-by: Tejun Heo <htejun@gmail.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/stop_machine.c |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff -puN kernel/stop_machine.c~stop_machine-make-stop_machine-safe-and-efficient-to-call-early kernel/stop_machine.c
--- a/kernel/stop_machine.c~stop_machine-make-stop_machine-safe-and-efficient-to-call-early
+++ a/kernel/stop_machine.c
@@ -41,6 +41,7 @@ struct cpu_stopper {
 };
 
 static DEFINE_PER_CPU(struct cpu_stopper, cpu_stopper);
+static bool stop_machine_initialized = false;
 
 static void cpu_stop_init_done(struct cpu_stop_done *done, unsigned int nr_todo)
 {
@@ -386,6 +387,8 @@ static int __init cpu_stop_init(void)
 	cpu_stop_cpu_callback(&cpu_stop_cpu_notifier, CPU_ONLINE, bcpu);
 	register_cpu_notifier(&cpu_stop_cpu_notifier);
 
+	stop_machine_initialized = true;
+
 	return 0;
 }
 early_initcall(cpu_stop_init);
@@ -485,6 +488,25 @@ int __stop_machine(int (*fn)(void *), vo
 					    .num_threads = num_online_cpus(),
 					    .active_cpus = cpus };
 
+	if (!stop_machine_initialized) {
+		/*
+		 * Handle the case where stop_machine() is called
+		 * early in boot before stop_machine() has been
+		 * initialized.
+		 */
+ 		unsigned long flags;
+		int ret;
+
+		WARN_ON_ONCE(smdata.num_threads != 1);
+
+		local_irq_save(flags);
+		hard_irq_disable();
+		ret = (*fn)(data);
+		local_irq_restore(flags);
+
+		return ret;
+	}
+
 	/* Set the initial state and stop all online cpus. */
 	set_state(&smdata, STOPMACHINE_PREPARE);
 	return stop_cpus(cpu_online_mask, stop_machine_cpu_stop, &smdata);
_

Patches currently in -mm which might be from jeremy.fitzhardinge@citrix.com are

origin.patch
linux-next.patch
x86-paravirt-pte-updates-in-kunmap_atomic-need-to-be-synchronous-regardless-of-lazy_mmu-mode.patch

