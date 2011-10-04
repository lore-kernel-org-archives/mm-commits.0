From: akpm@google.com
Subject: + stop_machine-make-stop_machine-safe-and-efficient-to-call-early.patch added to -mm tree
Date: Tue, 04 Oct 2011 14:05:01 -0700
Message-ID: <201110042105.p94L53vw032264@hpaq14.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:37574 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933618Ab1JDVF2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Oct 2011 17:05:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeremy.fitzhardinge@citrix.com, a.p.zijlstra@chello.nl, hpa@linux.intel.com, htejun@gmail.com, konrad.wilk@oracle.com, mingo@elte.hu, rostedt@goodmis.org, rusty@rustcorp.com.au, tj@kernel.org


The patch titled
     Subject: stop_machine: make stop_machine safe and efficient to call early
has been added to the -mm tree.  Its filename is
     stop_machine-make-stop_machine-safe-and-efficient-to-call-early.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: H. Peter Anvin <hpa@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: Tejun Heo <htejun@gmail.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Signed-off-by: Andrew Morton <akpm@google.com>
---

 kernel/stop_machine.c |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

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
@@ -485,6 +488,24 @@ int __stop_machine(int (*fn)(void *), vo
 					    .num_threads = num_online_cpus(),
 					    .active_cpus = cpus };
 
+	if (!stop_machine_initialized) {
+		/*
+		 * Handle the case where stop_machine() is called early in boot
+		 * before SMP startup.
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
Subject: Subject: stop_machine: make stop_machine safe and efficient to call early

Patches currently in -mm which might be from jeremy.fitzhardinge@citrix.com are

origin.patch
linux-next.patch
x86-paravirt-pte-updates-in-kunmap_atomic-need-to-be-synchronous-regardless-of-lazy_mmu-mode.patch
mm-avoid-null-pointer-access-in-vm_struct-via-proc-vmallocinfo.patch
stop_machine-make-stop_machine-safe-and-efficient-to-call-early.patch

