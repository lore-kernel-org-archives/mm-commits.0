From: akpm@linux-foundation.org
Subject: +
 smp-print-more-useful-debug-info-upon-receiving-ipi-on-an-offline-cpu-v5.patch added to -mm tree
Date: Thu, 15 May 2014 14:59:35 -0700
Message-ID: <537538c7.QZK8AL/85lO2LocH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38768 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287AbaEOV7h (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 15 May 2014 17:59:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, tglx@linutronix.de, rusty@rustcorp.com.au, rostedt@goodmis.org, rjw@rjwysocki.net, riel@redhat.com, peterz@infradead.org, paulmck@linux.vnet.ibm.com, oleg@redhat.com, mingo@kernel.org, mgorman@suse.de, mgalbraith@suse.de, hch@infradead.org, fweisbec@gmail.com, ego@linux.vnet.ibm.com, bp@suse.de, srivatsa.bhat@linux.vnet.ibm.com

Subject: + smp-print-more-useful-debug-info-upon-receiving-ipi-on-an-offline-cpu-v5.patch added to -mm tree
To: srivatsa.bhat@linux.vnet.ibm.com,bp@suse.de,ego@linux.vnet.ibm.com,fweisbec@gmail.com,hch@infradead.org,mgalbraith@suse.de,mgorman@suse.de,mingo@kernel.org,oleg@redhat.com,paulmck@linux.vnet.ibm.com,peterz@infradead.org,riel@redhat.com,rjw@rjwysocki.net,rostedt@goodmis.org,rusty@rustcorp.com.au,tglx@linutronix.de,tj@kernel.org
From: akpm@linux-foundation.org
Date: Thu, 15 May 2014 14:59:35 -0700


The patch titled
     Subject: smp-print-more-useful-debug-info-upon-receiving-ipi-on-an-offline-cpu-v5
has been added to the -mm tree.  Its filename is
     smp-print-more-useful-debug-info-upon-receiving-ipi-on-an-offline-cpu-v5.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/smp-print-more-useful-debug-info-upon-receiving-ipi-on-an-offline-cpu-v5.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/smp-print-more-useful-debug-info-upon-receiving-ipi-on-an-offline-cpu-v5.patch

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
Subject: smp-print-more-useful-debug-info-upon-receiving-ipi-on-an-offline-cpu-v5

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

 kernel/smp.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN kernel/smp.c~smp-print-more-useful-debug-info-upon-receiving-ipi-on-an-offline-cpu-v5 kernel/smp.c
--- a/kernel/smp.c~smp-print-more-useful-debug-info-upon-receiving-ipi-on-an-offline-cpu-v5
+++ a/kernel/smp.c
@@ -195,13 +195,15 @@ void generic_smp_call_function_single_in
 	 */
 	if (unlikely(!cpu_online(smp_processor_id()) && !warned)) {
 		warned = true;
-		WARN_ON(1);
+		WARN(1, "IPI on offline CPU %d\n", smp_processor_id());
+
 		/*
 		 * We don't have to use the _safe() variant here
 		 * because we are not invoking the IPI handlers yet.
 		 */
 		llist_for_each_entry(csd, entry, llist)
-			pr_warn("SMP IPI Payload: %pS \n", csd->func);
+			pr_warn("IPI callback %pS sent to offline CPU\n",
+				csd->func);
 	}
 
 	llist_for_each_entry_safe(csd, csd_next, entry, llist) {
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

