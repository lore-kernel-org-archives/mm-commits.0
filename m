From: akpm@linux-foundation.org
Subject: +
 cpu-hotplug-stop-machine-plug-race-window-that-leads-to-ipi-to-offline-cpu.patch added to -mm tree
Date: Tue, 06 May 2014 13:41:16 -0700
Message-ID: <536948ec.wZfYrhaixM5xvdJa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40647 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755540AbaEFUlR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 May 2014 16:41:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, tglx@linutronix.de, rusty@rustcorp.com.au, rostedt@goodmis.org, rjw@rjwysocki.net, riel@redhat.com, peterz@infradead.org, paulmck@linux.vnet.ibm.com, oleg@redhat.com, mingo@kernel.org, mgorman@suse.de, mgalbraith@suse.de, hch@infradead.org, fweisbec@gmail.com, ego@linux.vnet.ibm.com, bp@suse.de, srivatsa.bhat@linux.vnet.ibm.com

Subject: + cpu-hotplug-stop-machine-plug-race-window-that-leads-to-ipi-to-offline-cpu.patch added to -mm tree
To: srivatsa.bhat@linux.vnet.ibm.com,bp@suse.de,ego@linux.vnet.ibm.com,fweisbec@gmail.com,hch@infradead.org,mgalbraith@suse.de,mgorman@suse.de,mingo@kernel.org,oleg@redhat.com,paulmck@linux.vnet.ibm.com,peterz@infradead.org,riel@redhat.com,rjw@rjwysocki.net,rostedt@goodmis.org,rusty@rustcorp.com.au,tglx@linutronix.de,tj@kernel.org
From: akpm@linux-foundation.org
Date: Tue, 06 May 2014 13:41:16 -0700


The patch titled
     Subject: CPU hotplug, stop-machine: plug race-window that leads to "IPI-to-offline-CPU"
has been added to the -mm tree.  Its filename is
     cpu-hotplug-stop-machine-plug-race-window-that-leads-to-ipi-to-offline-cpu.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/cpu-hotplug-stop-machine-plug-race-window-that-leads-to-ipi-to-offline-cpu.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/cpu-hotplug-stop-machine-plug-race-window-that-leads-to-ipi-to-offline-cpu.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
*follows* all other CPUs while entering each subsequent phase within
stop-machine.  In particular, all other CPUs will enter the _DISABLE_IRQ
phase and disable their local interrupts, and only *then*, the CPU going
offline will follow suit.  Since the other CPUs are executing the
stop-machine code with interrupts disabled, they won't send any IPIs at
all, at that point.  And by the time stop-machine ends, the CPU would have
gone offline and disappeared from the cpu_online_mask, and hence future
invocations of smp_call_function() and friends will automatically prune
that CPU out.  Thus, we can guarantee that no CPU will end up
*inadvertently* sending IPIs to an offline CPU.

We can implement this by introducing a "holding area" for the CPUs marked
as 'active_cpus', and use this infrastructure to let the other CPUs
progress from one stage to the next, before allowing the active_cpus to do
the same thing.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
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

 kernel/stop_machine.c |   22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff -puN kernel/stop_machine.c~cpu-hotplug-stop-machine-plug-race-window-that-leads-to-ipi-to-offline-cpu kernel/stop_machine.c
--- a/kernel/stop_machine.c~cpu-hotplug-stop-machine-plug-race-window-that-leads-to-ipi-to-offline-cpu
+++ a/kernel/stop_machine.c
@@ -165,12 +165,21 @@ static void ack_state(struct multi_stop_
 		set_state(msdata, msdata->state + 1);
 }
 
+/* Holding area for active CPUs, to let all the non-active CPUs go first */
+static void hold_active_cpus(struct multi_stop_data *msdata,
+			     int num_active_cpus)
+{
+	/* Wait until all the non-active threads ack the state */
+	while (atomic_read(&msdata->thread_ack) > num_active_cpus)
+		cpu_relax();
+}
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
 
@@ -180,15 +189,22 @@ static int multi_cpu_stop(void *data)
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
+		if (is_active)
+			hold_active_cpus(msdata, num_active_cpus);
+
 		if (msdata->state != curstate) {
 			curstate = msdata->state;
 			switch (curstate) {
_

Patches currently in -mm which might be from srivatsa.bhat@linux.vnet.ibm.com are

smp-print-more-useful-debug-info-upon-receiving-ipi-on-an-offline-cpu.patch
smp-print-more-useful-debug-info-upon-receiving-ipi-on-an-offline-cpu-fix.patch
cpu-hotplug-stop-machine-plug-race-window-that-leads-to-ipi-to-offline-cpu.patch

