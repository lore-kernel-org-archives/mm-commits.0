From: akpm@linux-foundation.org
Subject: +
 cpu-hotplug-stop-machine-plug-race-window-that-leads-to-ipi-to-offline-cpu-v5.patch added to -mm tree
Date: Thu, 15 May 2014 14:59:37 -0700
Message-ID: <537538c9.vCKMnnFFIzA46af3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38783 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752799AbaEOV7j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 15 May 2014 17:59:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, tglx@linutronix.de, rusty@rustcorp.com.au, rostedt@goodmis.org, rjw@rjwysocki.net, riel@redhat.com, peterz@infradead.org, paulmck@linux.vnet.ibm.com, oleg@redhat.com, mingo@kernel.org, mgorman@suse.de, mgalbraith@suse.de, hch@infradead.org, fweisbec@gmail.com, ego@linux.vnet.ibm.com, bp@suse.de, srivatsa.bhat@linux.vnet.ibm.com

Subject: + cpu-hotplug-stop-machine-plug-race-window-that-leads-to-ipi-to-offline-cpu-v5.patch added to -mm tree
To: srivatsa.bhat@linux.vnet.ibm.com,bp@suse.de,ego@linux.vnet.ibm.com,fweisbec@gmail.com,hch@infradead.org,mgalbraith@suse.de,mgorman@suse.de,mingo@kernel.org,oleg@redhat.com,paulmck@linux.vnet.ibm.com,peterz@infradead.org,riel@redhat.com,rjw@rjwysocki.net,rostedt@goodmis.org,rusty@rustcorp.com.au,tglx@linutronix.de,tj@kernel.org
From: akpm@linux-foundation.org
Date: Thu, 15 May 2014 14:59:37 -0700


The patch titled
     Subject: cpu-hotplug-stop-machine-plug-race-window-that-leads-to-ipi-to-offline-cpu-v5
has been added to the -mm tree.  Its filename is
     cpu-hotplug-stop-machine-plug-race-window-that-leads-to-ipi-to-offline-cpu-v5.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/cpu-hotplug-stop-machine-plug-race-window-that-leads-to-ipi-to-offline-cpu-v5.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/cpu-hotplug-stop-machine-plug-race-window-that-leads-to-ipi-to-offline-cpu-v5.patch

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
Subject: cpu-hotplug-stop-machine-plug-race-window-that-leads-to-ipi-to-offline-cpu-v5

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

 kernel/stop_machine.c |   38 ++++++++++++++++++++++++--------------
 1 file changed, 24 insertions(+), 14 deletions(-)

diff -puN kernel/stop_machine.c~cpu-hotplug-stop-machine-plug-race-window-that-leads-to-ipi-to-offline-cpu-v5 kernel/stop_machine.c
--- a/kernel/stop_machine.c~cpu-hotplug-stop-machine-plug-race-window-that-leads-to-ipi-to-offline-cpu-v5
+++ a/kernel/stop_machine.c
@@ -193,27 +193,37 @@ static int multi_cpu_stop(void *data)
 		cpu_relax();
 
 		/*
-		 * In the case of CPU offline, we don't want the other CPUs to
-		 * send IPIs to the active_cpu (the one going offline) after it
-		 * has disabled interrupts in the _DISABLE_IRQ state (because,
-		 * then it will notice the IPIs only after it goes offline). So
-		 * we split this state into _INACTIVE and _ACTIVE, and thereby
-		 * ensure that the active_cpu disables interrupts only after
-		 * the other CPUs do the same thing.
+		 * We use 2 separate stages to disable interrupts, namely
+		 * _INACTIVE and _ACTIVE, to ensure that the inactive CPUs
+		 * disable their interrupts first, followed by the active CPUs.
+		 *
+		 * This is done to avoid a race in the CPU offline path, which
+		 * can lead to receiving IPIs on the outgoing CPU *after* it
+		 * has gone offline.
+		 *
+		 * During CPU offline, we don't want the other CPUs to send
+		 * IPIs to the active_cpu (the outgoing CPU) *after* it has
+		 * disabled interrupts (because, then it will notice the IPIs
+		 * only after it has gone offline). We can prevent this by
+		 * making the other CPUs disable their interrupts first - that
+		 * way, they will run the stop-machine code with interrupts
+		 * disabled, and hence won't send IPIs after that point.
 		 */
 
 		if (msdata->state != curstate) {
 			curstate = msdata->state;
 			switch (curstate) {
 			case MULTI_STOP_DISABLE_IRQ_INACTIVE:
-				if (is_active)
-					break;
-
-				/* Else, fall-through */
-
+				if (!is_active) {
+					local_irq_disable();
+					hard_irq_disable();
+				}
+				break;
 			case MULTI_STOP_DISABLE_IRQ_ACTIVE:
-				local_irq_disable();
-				hard_irq_disable();
+				if (is_active) {
+					local_irq_disable();
+					hard_irq_disable();
+				}
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
cpu-hotplug-smp-flush-any-pending-ipi-callbacks-before-cpu-offline.patch
linux-next.patch

