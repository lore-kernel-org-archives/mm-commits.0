From: akpm@linux-foundation.org
Subject: +
 cpu-hotplug-smp-flush-any-pending-ipi-callbacks-before-cpu-offline.patch
 added to -mm tree
Date: Thu, 29 May 2014 14:34:29 -0700
Message-ID: <5387a7e5.au/h4w3x95Ei/xjC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45128 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753484AbaE2Veb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 29 May 2014 17:34:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, tglx@linutronix.de, rusty@rustcorp.com.au, rostedt@goodmis.org, rjw@rjwysocki.net, riel@redhat.com, peterz@infradead.org, paulmck@linux.vnet.ibm.com, oleg@redhat.com, mingo@kernel.org, mgorman@suse.de, mgalbraith@suse.de, hch@infradead.org, fweisbec@gmail.com, ego@linux.vnet.ibm.com, bp@suse.de, srivatsa.bhat@linux.vnet.ibm.com

Subject: + cpu-hotplug-smp-flush-any-pending-ipi-callbacks-before-cpu-offline.patch added to -mm tree
To: srivatsa.bhat@linux.vnet.ibm.com,bp@suse.de,ego@linux.vnet.ibm.com,fweisbec@gmail.com,hch@infradead.org,mgalbraith@suse.de,mgorman@suse.de,mingo@kernel.org,oleg@redhat.com,paulmck@linux.vnet.ibm.com,peterz@infradead.org,riel@redhat.com,rjw@rjwysocki.net,rostedt@goodmis.org,rusty@rustcorp.com.au,tglx@linutronix.de,tj@kernel.org
From: akpm@linux-foundation.org
Date: Thu, 29 May 2014 14:34:29 -0700


The patch titled
     Subject: CPU hotplug, smp: flush any pending IPI callbacks before CPU offline
has been added to the -mm tree.  Its filename is
     cpu-hotplug-smp-flush-any-pending-ipi-callbacks-before-cpu-offline.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/cpu-hotplug-smp-flush-any-pending-ipi-callbacks-before-cpu-offline.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/cpu-hotplug-smp-flush-any-pending-ipi-callbacks-before-cpu-offline.patch

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
Subject: CPU hotplug, smp: flush any pending IPI callbacks before CPU offline

During CPU offline, in stop-machine, we don't enforce any rule in the
_DISABLE_IRQ stage, regarding the order in which the outgoing CPU and the
other CPUs disable their local interrupts.  Hence, we can encounter a
scenario as depicted below, in which IPIs are sent by the other CPUs to
the CPU going offline (while it is *still* online), but the outgoing CPU
notices them only *after* it has gone offline.

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

This of course, makes the smp-call-function IPI handler code unhappy and
it complains about "receiving an IPI on an offline CPU".

However, if we look closely, we observe that the IPI was sent when CPU 2
was still online, and hence it was perfectly legal for CPU 1 to send the
IPI at that point.  Furthermore, receiving an IPI on an offline CPU is
terrible only if there were pending callbacks yet to be executed by that
CPU (in other words, it's a bug if the CPU went offline with work still
pending).

So, fix this by flushing all the queued smp-call-function callbacks on the
outgoing CPU in the CPU_DYING stage[1], including those callbacks for
which the source CPU's IPIs might not have been received on the outgoing
CPU yet.  This ensures that all pending IPI callbacks are run before the
CPU goes completely offline.  But note that the outgoing CPU can still get
IPIs from the other CPUs just after it exits stop-machine, due to the
scenario mentioned above.  But because we flush the callbacks before going
offline, this will be completely harmless.

Further, this solution also guarantees that there will be pending
callbacks on an offline CPU *only if* the source CPU initiated the
IPI-send-procedure *after* the target CPU went offline, which clearly
indicates a bug in the sender code.

So, considering all this, teach the smp-call-function IPI handler code to
complain only if an offline CPU received an IPI *and* it still had pending
callbacks to execute, since that is the only buggy scenario.

There is another case (somewhat theoretical though) where IPIs might
arrive late on the target CPU (possibly _after_ the CPU has gone offline):
due to IPI latencies in the hardware.  But with this patch, even this
scenario turns out to be harmless, since we explicitly loop through the
call_single_queue and flush out any pending callbacks without waiting for
the corresponding IPIs to arrive.

[1]. The CPU_DYING part needs a little more explanation: by the time we
execute the CPU_DYING notifier callbacks, the CPU would have already been
marked offline. But we want to flush out the pending callbacks at this stage,
ignoring the fact that the CPU is offline. So restructure the IPI handler
code so that we can by-pass the "is-cpu-offline?" check in this particular
case. (Of course, the right solution here is to fix CPU hotplug to mark the
CPU offline _after_ invoking the CPU_DYING notifiers, but this requires a
lot of audit to ensure that this change doesn't break any existing code;
hence lets go with the solution proposed above until that is done).

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Suggested-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Gautham R Shenoy <ego@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Mike Galbraith <mgalbraith@suse.de>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Rik van Riel <riel@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/smp.c |   56 ++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 48 insertions(+), 8 deletions(-)

diff -puN kernel/smp.c~cpu-hotplug-smp-flush-any-pending-ipi-callbacks-before-cpu-offline kernel/smp.c
--- a/kernel/smp.c~cpu-hotplug-smp-flush-any-pending-ipi-callbacks-before-cpu-offline
+++ a/kernel/smp.c
@@ -29,6 +29,8 @@ static DEFINE_PER_CPU_SHARED_ALIGNED(str
 
 static DEFINE_PER_CPU_SHARED_ALIGNED(struct llist_head, call_single_queue);
 
+static void flush_smp_call_function_queue(bool warn_cpu_offline);
+
 static int
 hotplug_cfd(struct notifier_block *nfb, unsigned long action, void *hcpu)
 {
@@ -52,6 +54,20 @@ hotplug_cfd(struct notifier_block *nfb,
 	case CPU_UP_CANCELED:
 	case CPU_UP_CANCELED_FROZEN:
 
+	case CPU_DYING:
+	case CPU_DYING_FROZEN:
+		/*
+		 * The IPIs for the smp-call-function callbacks queued by other
+		 * CPUs might arrive late, either due to hardware latencies or
+		 * because this CPU disabled interrupts (inside stop-machine)
+		 * before the IPIs were sent. So flush out any pending callbacks
+		 * explicitly (without waiting for the IPIs to arrive), to
+		 * ensure that the outgoing CPU doesn't go offline with work
+		 * still pending.
+		 */
+		flush_smp_call_function_queue(false);
+		break;
+
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
 		free_cpumask_var(cfd->cpumask);
@@ -177,23 +193,47 @@ static int generic_exec_single(int cpu,
 	return 0;
 }
 
-/*
- * Invoked by arch to handle an IPI for call function single. Must be
- * called from the arch with interrupts disabled.
+/**
+ * generic_smp_call_function_single_interrupt - Execute SMP IPI callbacks
+ *
+ * Invoked by arch to handle an IPI for call function single.
+ * Must be called with interrupts disabled.
  */
 void generic_smp_call_function_single_interrupt(void)
 {
+	flush_smp_call_function_queue(true);
+}
+
+/**
+ * flush_smp_call_function_queue - Flush pending smp-call-function callbacks
+ *
+ * @warn_cpu_offline: If set to 'true', warn if callbacks were queued on an
+ * 		      offline CPU. Skip this check if set to 'false'.
+ *
+ * Flush any pending smp-call-function callbacks queued on this CPU. This is
+ * invoked by the generic IPI handler, as well as by a CPU about to go offline,
+ * to ensure that all pending IPI functions are run before it goes completely
+ * offline.
+ *
+ * Loop through the call_single_queue and run all the queued functions.
+ * Must be called with interrupts disabled.
+ */
+static void flush_smp_call_function_queue(bool warn_cpu_offline)
+{
+	struct llist_head *head;
 	struct llist_node *entry;
 	struct call_single_data *csd, *csd_next;
 	static bool warned;
 
-	entry = llist_del_all(&__get_cpu_var(call_single_queue));
+	WARN_ON(!irqs_disabled());
+
+	head = &__get_cpu_var(call_single_queue);
+	entry = llist_del_all(head);
 	entry = llist_reverse_order(entry);
 
-	/*
-	 * Shouldn't receive this interrupt on a cpu that is not yet online.
-	 */
-	if (unlikely(!cpu_online(smp_processor_id()) && !warned)) {
+	/* There shouldn't be any pending callbacks on an offline CPU. */
+	if (unlikely(warn_cpu_offline && !cpu_online(smp_processor_id()) &&
+		     !warned && !llist_empty(head))) {
 		warned = true;
 		WARN(1, "IPI on offline CPU %d\n", smp_processor_id());
 
_

Patches currently in -mm which might be from srivatsa.bhat@linux.vnet.ibm.com are

origin.patch
smp-print-more-useful-debug-info-upon-receiving-ipi-on-an-offline-cpu.patch
smp-print-more-useful-debug-info-upon-receiving-ipi-on-an-offline-cpu-fix.patch
smp-print-more-useful-debug-info-upon-receiving-ipi-on-an-offline-cpu-v5.patch
cpu-hotplug-smp-flush-any-pending-ipi-callbacks-before-cpu-offline.patch
linux-next.patch

