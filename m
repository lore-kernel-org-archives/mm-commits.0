From: akpm@linux-foundation.org
Subject: [to-be-updated]
 cpu-hotplug-smp-flush-any-pending-ipi-callbacks-before-cpu-offline.patch
 removed from -mm tree
Date: Tue, 20 May 2014 13:22:36 -0700
Message-ID: <537bb98c.75RpXj17HX1rizEe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34407 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093AbaETUWi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 20 May 2014 16:22:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, tglx@linutronix.de, rusty@rustcorp.com.au, rostedt@goodmis.org, rjw@rjwysocki.net, riel@redhat.com, peterz@infradead.org, paulmck@linux.vnet.ibm.com, oleg@redhat.com, mingo@kernel.org, mgorman@suse.de, mgalbraith@suse.de, hch@infradead.org, fweisbec@gmail.com, ego@linux.vnet.ibm.com, bp@suse.de, srivatsa.bhat@linux.vnet.ibm.com

Subject: [to-be-updated] cpu-hotplug-smp-flush-any-pending-ipi-callbacks-before-cpu-offline.patch removed from -mm tree
To: srivatsa.bhat@linux.vnet.ibm.com,bp@suse.de,ego@linux.vnet.ibm.com,fweisbec@gmail.com,hch@infradead.org,mgalbraith@suse.de,mgorman@suse.de,mingo@kernel.org,oleg@redhat.com,paulmck@linux.vnet.ibm.com,peterz@infradead.org,riel@redhat.com,rjw@rjwysocki.net,rostedt@goodmis.org,rusty@rustcorp.com.au,tglx@linutronix.de,tj@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 20 May 2014 13:22:36 -0700


The patch titled
     Subject: CPU hotplug, smp: flush any pending IPI callbacks before CPU offline
has been removed from the -mm tree.  Its filename was
     cpu-hotplug-smp-flush-any-pending-ipi-callbacks-before-cpu-offline.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: CPU hotplug, smp: flush any pending IPI callbacks before CPU offline

During CPU offline, in the stop-machine loop, we use 2 separate stages to
disable interrupts, to ensure that the CPU going offline doesn't get any
new IPIs from the other CPUs after it has gone offline.

However, an IPI sent much earlier might arrive late on the target CPU
(possibly _after_ the CPU has gone offline) due to hardware latencies, and
due to this, the smp-call-function callbacks queued on the outgoing CPU
might not get noticed (and hence not executed) at all.

This is somewhat theoretical, but in any case, it makes sense to
explicitly loop through the call_single_queue and flush any pending
callbacks before the CPU goes completely offline.  So, flush the queued
smp-call-function callbacks in the MULTI_STOP_DISABLE_IRQ_ACTIVE stage,
after disabling interrupts on the active CPU.  That way, we would have
handled all the queued callbacks before going offline, and also, no new
IPIs can be sent by the other CPUs to the outgoing CPU at that point,
because they will all be executing the stop-machine code with interrupts
disabled.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Suggested-by: Frederic Weisbecker <fweisbec@gmail.com>
Reviewed-by: Tejun Heo <tj@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
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

 include/linux/smp.h   |    2 ++
 kernel/smp.c          |   33 +++++++++++++++++++++++++++++++++
 kernel/stop_machine.c |   11 +++++++++++
 3 files changed, 46 insertions(+)

diff -puN include/linux/smp.h~cpu-hotplug-smp-flush-any-pending-ipi-callbacks-before-cpu-offline include/linux/smp.h
--- a/include/linux/smp.h~cpu-hotplug-smp-flush-any-pending-ipi-callbacks-before-cpu-offline
+++ a/include/linux/smp.h
@@ -52,6 +52,8 @@ void on_each_cpu_cond(bool (*cond_func)(
 
 int smp_call_function_single_async(int cpu, struct call_single_data *csd);
 
+void flush_smp_call_function_queue(void);
+
 #ifdef CONFIG_SMP
 
 #include <linux/preempt.h>
diff -puN kernel/smp.c~cpu-hotplug-smp-flush-any-pending-ipi-callbacks-before-cpu-offline kernel/smp.c
--- a/kernel/smp.c~cpu-hotplug-smp-flush-any-pending-ipi-callbacks-before-cpu-offline
+++ a/kernel/smp.c
@@ -212,6 +212,39 @@ void generic_smp_call_function_single_in
 	}
 }
 
+/**
+ * flush_smp_call_function_queue - Flush pending smp-call-function callbacks
+ *
+ * Flush any pending smp-call-function callbacks queued on this CPU (including
+ * those for which the source CPU's IPIs might not have been received on this
+ * CPU yet). This is invoked by a CPU about to go offline, to ensure that all
+ * pending IPI functions are run before it goes completely offline.
+ *
+ * Loop through the call_single_queue and run all the queued functions.
+ * Must be called with interrupts disabled.
+ */
+void flush_smp_call_function_queue(void)
+{
+	struct llist_head *head;
+	struct llist_node *entry;
+	struct call_single_data *csd, *csd_next;
+
+	WARN_ON(!irqs_disabled());
+
+	head = &__get_cpu_var(call_single_queue);
+
+	if (likely(llist_empty(head)))
+		return;
+
+	entry = llist_del_all(head);
+	entry = llist_reverse_order(entry);
+
+	llist_for_each_entry_safe(csd, csd_next, entry, llist) {
+		csd->func(csd->info);
+		csd_unlock(csd);
+	}
+}
+
 /*
  * smp_call_function_single - Run a function on a specific CPU
  * @func: The function to run. This must be fast and non-blocking.
diff -puN kernel/stop_machine.c~cpu-hotplug-smp-flush-any-pending-ipi-callbacks-before-cpu-offline kernel/stop_machine.c
--- a/kernel/stop_machine.c~cpu-hotplug-smp-flush-any-pending-ipi-callbacks-before-cpu-offline
+++ a/kernel/stop_machine.c
@@ -21,6 +21,7 @@
 #include <linux/smpboot.h>
 #include <linux/atomic.h>
 #include <linux/lglock.h>
+#include <linux/smp.h>
 
 /*
  * Structure to determine completion condition and record errors.  May
@@ -224,6 +225,16 @@ static int multi_cpu_stop(void *data)
 					local_irq_disable();
 					hard_irq_disable();
 				}
+
+				/*
+				 * IPIs (from the inactive CPUs) might arrive
+				 * late due to hardware latencies. So flush
+				 * out any pending IPI callbacks explicitly,
+				 * to ensure that the outgoing CPU doesn't go
+				 * offline with work still pending (during
+				 * CPU hotplug).
+				 */
+				flush_smp_call_function_queue();
 				break;
 			case MULTI_STOP_RUN:
 				if (is_active)
_

Patches currently in -mm which might be from srivatsa.bhat@linux.vnet.ibm.com are

smp-print-more-useful-debug-info-upon-receiving-ipi-on-an-offline-cpu.patch
smp-print-more-useful-debug-info-upon-receiving-ipi-on-an-offline-cpu-fix.patch
smp-print-more-useful-debug-info-upon-receiving-ipi-on-an-offline-cpu-v5.patch
cpu-hotplug-stop-machine-plug-race-window-that-leads-to-ipi-to-offline-cpu.patch
cpu-hotplug-stop-machine-plug-race-window-that-leads-to-ipi-to-offline-cpu-v3.patch
cpu-hotplug-stop-machine-plug-race-window-that-leads-to-ipi-to-offline-cpu-v5.patch
linux-next.patch

