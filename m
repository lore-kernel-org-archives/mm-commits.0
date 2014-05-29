From: akpm@linux-foundation.org
Subject: [to-be-updated]
 cpu-hotplug-smp-flush-any-pending-ipi-callbacks-before-cpu-offline-v5.patch removed from -mm tree
Date: Thu, 29 May 2014 14:32:37 -0700
Message-ID: <5387a775.jpYZFONn9Kbmhm9v%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45109 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753484AbaE2Vci (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 29 May 2014 17:32:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, peterz@infradead.org, oleg@redhat.com, fweisbec@gmail.com, srivatsa.bhat@linux.vnet.ibm.com

Subject: [to-be-updated] cpu-hotplug-smp-flush-any-pending-ipi-callbacks-before-cpu-offline-v5.patch removed from -mm tree
To: srivatsa.bhat@linux.vnet.ibm.com,fweisbec@gmail.com,oleg@redhat.com,peterz@infradead.org,tj@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 29 May 2014 14:32:37 -0700


The patch titled
     Subject: CPU hotplug, smp: Flush any pending IPI callbacks before CPU offline
has been removed from the -mm tree.  Its filename was
     cpu-hotplug-smp-flush-any-pending-ipi-callbacks-before-cpu-offline-v5.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Subject: CPU hotplug, smp: Flush any pending IPI callbacks before CPU offline

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
after disabling interrupts on the active CPU.  This can be trivially
achieved by invoking the generic_smp_call_function_single_interrupt()
function itself (and since the outgoing CPU is still online at this point,
we won't trigger the "IPI to offline CPU" warning in this function; so we
are safe to call it here).

This way, we would have handled all the queued callbacks before going
offline, and also, no new IPIs can be sent by the other CPUs to the
outgoing CPU at that point, because they will all be executing the
stop-machine code with interrupts disabled.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Suggested-by: Frederic Weisbecker <fweisbec@gmail.com>
Reviewed-by: Tejun Heo <tj@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/smp.h   |    2 ++
 kernel/smp.c          |   17 ++++++++++++++---
 kernel/stop_machine.c |   11 +++++++++++
 3 files changed, 27 insertions(+), 3 deletions(-)

diff -puN include/linux/smp.h~cpu-hotplug-smp-flush-any-pending-ipi-callbacks-before-cpu-offline-v5 include/linux/smp.h
--- a/include/linux/smp.h~cpu-hotplug-smp-flush-any-pending-ipi-callbacks-before-cpu-offline-v5
+++ a/include/linux/smp.h
@@ -151,6 +151,8 @@ smp_call_function_any(const struct cpuma
 
 static inline void kick_all_cpus_sync(void) {  }
 
+static inline void generic_smp_call_function_single_interrupt(void) { }
+
 #endif /* !SMP */
 
 /*
diff -puN kernel/smp.c~cpu-hotplug-smp-flush-any-pending-ipi-callbacks-before-cpu-offline-v5 kernel/smp.c
--- a/kernel/smp.c~cpu-hotplug-smp-flush-any-pending-ipi-callbacks-before-cpu-offline-v5
+++ a/kernel/smp.c
@@ -177,9 +177,18 @@ static int generic_exec_single(int cpu,
 	return 0;
 }
 
-/*
- * Invoked by arch to handle an IPI for call function single. Must be
- * called from the arch with interrupts disabled.
+/**
+ * generic_smp_call_function_single_interrupt - Execute SMP IPI callbacks
+ *
+ * Invoked by arch to handle an IPI for call function single.
+ *
+ * This is also invoked by a CPU about to go offline, to flush any pending
+ * smp-call-function callbacks queued on this CPU (including those for which
+ * the source CPU's IPIs might not have been received on this CPU yet).
+ * This ensures that all pending IPI callbacks are run before the CPU goes
+ * completely offline.
+ *
+ * Must be called with interrupts disabled.
  */
 void generic_smp_call_function_single_interrupt(void)
 {
@@ -187,6 +196,8 @@ void generic_smp_call_function_single_in
 	struct call_single_data *csd, *csd_next;
 	static bool warned;
 
+	WARN_ON(!irqs_disabled());
+
 	entry = llist_del_all(&__get_cpu_var(call_single_queue));
 	entry = llist_reverse_order(entry);
 
diff -puN kernel/stop_machine.c~cpu-hotplug-smp-flush-any-pending-ipi-callbacks-before-cpu-offline-v5 kernel/stop_machine.c
--- a/kernel/stop_machine.c~cpu-hotplug-smp-flush-any-pending-ipi-callbacks-before-cpu-offline-v5
+++ a/kernel/stop_machine.c
@@ -21,6 +21,7 @@
 #include <linux/smpboot.h>
 #include <linux/atomic.h>
 #include <linux/lglock.h>
+#include <linux/smp.h>
 
 /*
  * Structure to determine completion condition and record errors.  May
@@ -223,6 +224,16 @@ static int multi_cpu_stop(void *data)
 				if (is_active) {
 					local_irq_disable();
 					hard_irq_disable();
+
+					/*
+					 * IPIs (from the inactive CPUs) might
+					 * arrive late due to hardware latencies.
+					 * So flush out any pending IPI callbacks
+					 * explicitly, to ensure that the outgoing
+					 * CPU doesn't go offline with work still
+					 * pending (during CPU hotplug).
+					 */
+					generic_smp_call_function_single_interrupt();
 				}
 				break;
 			case MULTI_STOP_RUN:
_

Patches currently in -mm which might be from srivatsa.bhat@linux.vnet.ibm.com are

origin.patch
smp-print-more-useful-debug-info-upon-receiving-ipi-on-an-offline-cpu.patch
smp-print-more-useful-debug-info-upon-receiving-ipi-on-an-offline-cpu-fix.patch
smp-print-more-useful-debug-info-upon-receiving-ipi-on-an-offline-cpu-v5.patch
cpu-hotplug-smp-flush-any-pending-ipi-callbacks-before-cpu-offline-v5-checkpatch-fixes.patch
linux-next.patch

