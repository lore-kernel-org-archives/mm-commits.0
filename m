From: akpm@linux-foundation.org
Subject: [withdrawn]
 cpu-hotplug-stop-machine-plug-race-window-that-leads-to-ipi-to-offline-cpu-v3.patch removed from -mm tree
Date: Thu, 29 May 2014 14:31:49 -0700
Message-ID: <5387a745.eqaNOzMEuyNqeay5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45090 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755299AbaE2Vbu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 29 May 2014 17:31:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, tglx@linutronix.de, rusty@rustcorp.com.au, rostedt@goodmis.org, rjw@rjwysocki.net, riel@redhat.com, peterz@infradead.org, paulmck@linux.vnet.ibm.com, oleg@redhat.com, mingo@kernel.org, mgorman@suse.de, mgalbraith@suse.de, hch@infradead.org, fweisbec@gmail.com, ego@linux.vnet.ibm.com, bp@suse.de, srivatsa.bhat@linux.vnet.ibm.com

Subject: [withdrawn] cpu-hotplug-stop-machine-plug-race-window-that-leads-to-ipi-to-offline-cpu-v3.patch removed from -mm tree
To: srivatsa.bhat@linux.vnet.ibm.com,bp@suse.de,ego@linux.vnet.ibm.com,fweisbec@gmail.com,hch@infradead.org,mgalbraith@suse.de,mgorman@suse.de,mingo@kernel.org,oleg@redhat.com,paulmck@linux.vnet.ibm.com,peterz@infradead.org,riel@redhat.com,rjw@rjwysocki.net,rostedt@goodmis.org,rusty@rustcorp.com.au,tglx@linutronix.de,tj@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 29 May 2014 14:31:49 -0700


The patch titled
     Subject: cpu-hotplug-stop-machine-plug-race-window-that-leads-to-ipi-to-offline-cpu-v3
has been removed from the -mm tree.  Its filename was
     cpu-hotplug-stop-machine-plug-race-window-that-leads-to-ipi-to-offline-cpu-v3.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: cpu-hotplug-stop-machine-plug-race-window-that-leads-to-ipi-to-offline-cpu-v3

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

 kernel/stop_machine.c |   43 +++++++++++++++++-----------------------
 1 file changed, 19 insertions(+), 24 deletions(-)

diff -puN kernel/stop_machine.c~cpu-hotplug-stop-machine-plug-race-window-that-leads-to-ipi-to-offline-cpu-v3 kernel/stop_machine.c
--- a/kernel/stop_machine.c~cpu-hotplug-stop-machine-plug-race-window-that-leads-to-ipi-to-offline-cpu-v3
+++ a/kernel/stop_machine.c
@@ -130,8 +130,10 @@ enum multi_stop_state {
 	MULTI_STOP_NONE,
 	/* Awaiting everyone to be scheduled. */
 	MULTI_STOP_PREPARE,
-	/* Disable interrupts. */
-	MULTI_STOP_DISABLE_IRQ,
+	/* Disable interrupts on CPUs not in ->active_cpus mask. */
+	MULTI_STOP_DISABLE_IRQ_INACTIVE,
+	/* Disable interrupts on CPUs in ->active_cpus mask. */
+	MULTI_STOP_DISABLE_IRQ_ACTIVE,
 	/* Run the function */
 	MULTI_STOP_RUN,
 	/* Exit */
@@ -165,13 +167,12 @@ static void ack_state(struct multi_stop_
 		set_state(msdata, msdata->state + 1);
 }
 
-
 /* This is the cpu_stop function which stops the CPU. */
 static int multi_cpu_stop(void *data)
 {
 	struct multi_stop_data *msdata = data;
 	enum multi_stop_state curstate = MULTI_STOP_NONE;
-	int cpu = smp_processor_id(), num_active_cpus, err = 0;
+	int cpu = smp_processor_id(), err = 0;
 	unsigned long flags;
 	bool is_active;
 
@@ -181,13 +182,10 @@ static int multi_cpu_stop(void *data)
 	 */
 	local_save_flags(flags);
 
-	if (!msdata->active_cpus) {
+	if (!msdata->active_cpus)
 		is_active = cpu == cpumask_first(cpu_online_mask);
-		num_active_cpus = 1;
-	} else {
+	else
 		is_active = cpumask_test_cpu(cpu, msdata->active_cpus);
-		num_active_cpus = cpumask_weight(msdata->active_cpus);
-	}
 
 	/* Simple state machine */
 	do {
@@ -197,26 +195,23 @@ static int multi_cpu_stop(void *data)
 		/*
 		 * In the case of CPU offline, we don't want the other CPUs to
 		 * send IPIs to the active_cpu (the one going offline) after it
-		 * has entered the _DISABLE_IRQ state (because, then it will
-		 * notice the IPIs only after it goes offline). So ensure that
-		 * the active_cpu always follows the others while entering
-		 * each subsequent state in this state-machine.
-		 *
-		 * msdata->thread_ack tracks the number of CPUs that are yet to
-		 * move to the next state, during each transition. So make the
-		 * active_cpu(s) wait until ->thread_ack indicates that the
-		 * active_cpus are the only ones left to complete the transition.
+		 * has disabled interrupts in the _DISABLE_IRQ state (because,
+		 * then it will notice the IPIs only after it goes offline). So
+		 * we split this state into _INACTIVE and _ACTIVE, and thereby
+		 * ensure that the active_cpu disables interrupts only after
+		 * the other CPUs do the same thing.
 		 */
-		if (is_active) {
-			/* Wait until all the non-active threads ack the state */
-			while (atomic_read(&msdata->thread_ack) > num_active_cpus)
-				cpu_relax();
-		}
 
 		if (msdata->state != curstate) {
 			curstate = msdata->state;
 			switch (curstate) {
-			case MULTI_STOP_DISABLE_IRQ:
+			case MULTI_STOP_DISABLE_IRQ_INACTIVE:
+				if (is_active)
+					break;
+
+				/* Else, fall-through */
+
+			case MULTI_STOP_DISABLE_IRQ_ACTIVE:
 				local_irq_disable();
 				hard_irq_disable();
 				break;
_

Patches currently in -mm which might be from srivatsa.bhat@linux.vnet.ibm.com are

origin.patch
smp-print-more-useful-debug-info-upon-receiving-ipi-on-an-offline-cpu.patch
smp-print-more-useful-debug-info-upon-receiving-ipi-on-an-offline-cpu-fix.patch
smp-print-more-useful-debug-info-upon-receiving-ipi-on-an-offline-cpu-v5.patch
cpu-hotplug-stop-machine-plug-race-window-that-leads-to-ipi-to-offline-cpu-v5.patch
cpu-hotplug-smp-flush-any-pending-ipi-callbacks-before-cpu-offline-v5.patch
cpu-hotplug-smp-flush-any-pending-ipi-callbacks-before-cpu-offline-v5-checkpatch-fixes.patch
linux-next.patch

