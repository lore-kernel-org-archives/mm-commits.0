From: akpm@linux-foundation.org
Subject: [withdrawn]
 cpu-hotplug-stop-machine-plug-race-window-that-leads-to-ipi-to-offline-cpu.patch removed from -mm tree
Date: Thu, 29 May 2014 14:31:47 -0700
Message-ID: <5387a743.dwOZV7JL2lKRs5vu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45073 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755299AbaE2Vbt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 29 May 2014 17:31:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, tglx@linutronix.de, rusty@rustcorp.com.au, rostedt@goodmis.org, rjw@rjwysocki.net, riel@redhat.com, peterz@infradead.org, paulmck@linux.vnet.ibm.com, oleg@redhat.com, mingo@kernel.org, mgorman@suse.de, mgalbraith@suse.de, hch@infradead.org, fweisbec@gmail.com, ego@linux.vnet.ibm.com, bp@suse.de, srivatsa.bhat@linux.vnet.ibm.com

Subject: [withdrawn] cpu-hotplug-stop-machine-plug-race-window-that-leads-to-ipi-to-offline-cpu.patch removed from -mm tree
To: srivatsa.bhat@linux.vnet.ibm.com,bp@suse.de,ego@linux.vnet.ibm.com,fweisbec@gmail.com,hch@infradead.org,mgalbraith@suse.de,mgorman@suse.de,mingo@kernel.org,oleg@redhat.com,paulmck@linux.vnet.ibm.com,peterz@infradead.org,riel@redhat.com,rjw@rjwysocki.net,rostedt@goodmis.org,rusty@rustcorp.com.au,tglx@linutronix.de,tj@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 29 May 2014 14:31:47 -0700


The patch titled
     Subject: CPU hotplug, stop-machine: plug race-window that leads to "IPI-to-offline-CPU"
has been removed from the -mm tree.  Its filename was
     cpu-hotplug-stop-machine-plug-race-window-that-leads-to-ipi-to-offline-cpu.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: CPU hotplug, stop-machine: plug race-window that leads to "IPI-to-offline-CPU"

During CPU offline, stop-machine is used to take control over all the
online CPUs (via the per-cpu stopper thread) and then run take_cpu_down()
on the CPU that is to be taken offline.

But stop-machine itself has several stages: _PREPARE, _DISABLE_IRQ, _RUN
etc.  The important thing to note here is that the _DISABLE_IRQ stage
comes much later after starting stop-machine, and hence there is a large
window where other CPUs can send IPIs to the CPU going offline.  As a
result, we can encounter a scenario as depicted below, which causes IPIs
to be sent to the CPU going offline, and that CPU notices them *after* it
has gone offline, triggering the "IPI-to-offline-CPU" warning from the
smp-call-function code.

              CPU 1                                         CPU 2
          (Online CPU)                               (CPU going offline)

       Enter _PREPARE stage                          Enter _PREPARE stage

                                                     Enter _DISABLE_IRQ stage

                                                   =
       Got a device interrupt,                     | Didn't notice the IPI
       and the interrupt handler                   | since interrupts were
       called smp_call_function()                  | disabled on this CPU.
       and sent an IPI to CPU 2.                   |
                                                   =

       Enter _DISABLE_IRQ stage

       Enter _RUN stage                              Enter _RUN stage

                                  =
       Busy loop with interrupts  |                  Invoke take_cpu_down()
       disabled.                  |                  and take CPU 2 offline
                                  =

       Enter _EXIT stage                             Enter _EXIT stage

       Re-enable interrupts                          Re-enable interrupts

                                                     The pending IPI is noted
                                                     immediately, but alas,
                                                     the CPU is offline at
                                                     this point.

So, as we can observe from this scenario, the IPI was sent when CPU 2 was
still online, and hence it was perfectly legal.  But unfortunately it was
noted only after CPU 2 went offline, resulting in the warning from the IPI
handling code.  In other words, the fault was not at the sender, but at
the receiver side - and if we look closely, the real bug is in the
stop-machine sequence itself.

The problem here is that the CPU going offline disabled its local
interrupts (by entering _DISABLE_IRQ phase) *before* the other CPUs.  And
that's the reason why it was not able to respond to the IPI before going
offline.

A simple solution to this problem is to ensure that the CPU going offline
disables its interrupts only *after* the other CPUs do the same thing.  To
achieve this, split the _DISABLE_IRQ state into 2 parts:

1st part: MULTI_STOP_DISABLE_IRQ_INACTIVE, where only the non-active CPUs
(i.e., the "other" CPUs) disable their interrupts.

2nd part: MULTI_STOP_DISABLE_IRQ_ACTIVE, where the active CPU (i.e., the
CPU going offline) disables its interrupts.

With this in place, the CPU going offline will always be the last one to
disable interrupts.  After this step, no further IPIs can be sent to the
outgoing CPU, since all the other CPUs would be executing the stop-machine
code with interrupts disabled.  And by the time stop-machine ends, the CPU
would have gone offline and disappeared from the cpu_online_mask, and
hence future invocations of smp_call_function() and friends will
automatically prune that CPU out.  Thus, we can guarantee that no CPU will
end up *inadvertently* sending IPIs to an offline CPU.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Tejun Heo <tj@kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Mike Galbraith <mgalbraith@suse.de>
Cc: Gautham R Shenoy <ego@linux.vnet.ibm.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/stop_machine.c |   30 +++++++++++++++++++++++++++---
 1 file changed, 27 insertions(+), 3 deletions(-)

diff -puN kernel/stop_machine.c~cpu-hotplug-stop-machine-plug-race-window-that-leads-to-ipi-to-offline-cpu kernel/stop_machine.c
--- a/kernel/stop_machine.c~cpu-hotplug-stop-machine-plug-race-window-that-leads-to-ipi-to-offline-cpu
+++ a/kernel/stop_machine.c
@@ -165,12 +165,13 @@ static void ack_state(struct multi_stop_
 		set_state(msdata, msdata->state + 1);
 }
 
+
 /* This is the cpu_stop function which stops the CPU. */
 static int multi_cpu_stop(void *data)
 {
 	struct multi_stop_data *msdata = data;
 	enum multi_stop_state curstate = MULTI_STOP_NONE;
-	int cpu = smp_processor_id(), err = 0;
+	int cpu = smp_processor_id(), num_active_cpus, err = 0;
 	unsigned long flags;
 	bool is_active;
 
@@ -180,15 +181,38 @@ static int multi_cpu_stop(void *data)
 	 */
 	local_save_flags(flags);
 
-	if (!msdata->active_cpus)
+	if (!msdata->active_cpus) {
 		is_active = cpu == cpumask_first(cpu_online_mask);
-	else
+		num_active_cpus = 1;
+	} else {
 		is_active = cpumask_test_cpu(cpu, msdata->active_cpus);
+		num_active_cpus = cpumask_weight(msdata->active_cpus);
+	}
 
 	/* Simple state machine */
 	do {
 		/* Chill out and ensure we re-read multi_stop_state. */
 		cpu_relax();
+
+		/*
+		 * In the case of CPU offline, we don't want the other CPUs to
+		 * send IPIs to the active_cpu (the one going offline) after it
+		 * has entered the _DISABLE_IRQ state (because, then it will
+		 * notice the IPIs only after it goes offline). So ensure that
+		 * the active_cpu always follows the others while entering
+		 * each subsequent state in this state-machine.
+		 *
+		 * msdata->thread_ack tracks the number of CPUs that are yet to
+		 * move to the next state, during each transition. So make the
+		 * active_cpu(s) wait until ->thread_ack indicates that the
+		 * active_cpus are the only ones left to complete the transition.
+		 */
+		if (is_active) {
+			/* Wait until all the non-active threads ack the state */
+			while (atomic_read(&msdata->thread_ack) > num_active_cpus)
+				cpu_relax();
+		}
+
 		if (msdata->state != curstate) {
 			curstate = msdata->state;
 			switch (curstate) {
_

Patches currently in -mm which might be from srivatsa.bhat@linux.vnet.ibm.com are

origin.patch
smp-print-more-useful-debug-info-upon-receiving-ipi-on-an-offline-cpu.patch
smp-print-more-useful-debug-info-upon-receiving-ipi-on-an-offline-cpu-fix.patch
smp-print-more-useful-debug-info-upon-receiving-ipi-on-an-offline-cpu-v5.patch
cpu-hotplug-stop-machine-plug-race-window-that-leads-to-ipi-to-offline-cpu-v3.patch
cpu-hotplug-stop-machine-plug-race-window-that-leads-to-ipi-to-offline-cpu-v5.patch
cpu-hotplug-smp-flush-any-pending-ipi-callbacks-before-cpu-offline-v5.patch
cpu-hotplug-smp-flush-any-pending-ipi-callbacks-before-cpu-offline-v5-checkpatch-fixes.patch
linux-next.patch

