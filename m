From: akpm@linux-foundation.org
Subject: + x86-mtrr-lock-stop-machine-during-mtrr-rendezvous-sequence.patch added to -mm tree
Date: Wed, 29 Jun 2011 14:41:13 -0700
Message-ID: <201106292141.p5TLfEhs013672@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36305 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753292Ab1F2VmC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 29 Jun 2011 17:42:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: suresh.b.siddha@intel.com, a.p.zijlstra@chello.nl, mingo@elte.hu, stable@kernel.org, tj@kernel.org, vadimuzzz@inbox.ru


The patch titled
     x86, mtrr: lock stop machine during MTRR rendezvous sequence
has been added to the -mm tree.  Its filename is
     x86-mtrr-lock-stop-machine-during-mtrr-rendezvous-sequence.patch

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
Subject: x86, mtrr: lock stop machine during MTRR rendezvous sequence
From: Suresh Siddha <suresh.b.siddha@intel.com>

MTRR rendezvous sequence using stop_one_cpu_nowait() can potentially
happen in parallel with another system wide rendezvous using
stop_machine().  This can lead to deadlock (The order in which works are
queued can be different on different cpu's.  Some cpu's will be running
the first rendezvous handler and others will be running the second
rendezvous handler.  Each set waiting for the other set to join for the
system wide rendezvous, leading to a deadlock).

MTRR rendezvous sequence is not implemented using stop_machine() as this
gets called both from the process context aswell as the cpu online paths
(where the cpu has not come online and the interrupts are disabled etc). 
stop_machine() works with only online cpus.

For now, take the stop_machine mutex in the MTRR rendezvous sequence that
gets called from an online cpu (here we are in the process context and can
potentially sleep while taking the mutex).  And the MTRR rendezvous that
gets triggered during cpu online doesn't need to take this stop_machine
lock (as the stop_machine() already ensures that there is no cpu hotplug
going on in parallel by doing get_online_cpus())

    TBD: Pursue a cleaner solution of extending the stop_machine()
         infrastructure to handle the case where the calling cpu is
         still not online and use this for MTRR rendezvous sequence.

Addresses https://bugzilla.novell.com/show_bug.cgi?id=672008

Reported-by: Vadim Kotelnikov <vadimuzzz@inbox.ru>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: <stable@kernel.org>	[2.6.35+, backport a week or two after this gets more testing in mainline]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/cpu/mtrr/main.c |   23 +++++++++++++++++++++++
 include/linux/stop_machine.h    |    2 ++
 kernel/stop_machine.c           |    2 +-
 3 files changed, 26 insertions(+), 1 deletion(-)

diff -puN arch/x86/kernel/cpu/mtrr/main.c~x86-mtrr-lock-stop-machine-during-mtrr-rendezvous-sequence arch/x86/kernel/cpu/mtrr/main.c
--- a/arch/x86/kernel/cpu/mtrr/main.c~x86-mtrr-lock-stop-machine-during-mtrr-rendezvous-sequence
+++ a/arch/x86/kernel/cpu/mtrr/main.c
@@ -248,6 +248,25 @@ set_mtrr(unsigned int reg, unsigned long
 	unsigned long flags;
 	int cpu;
 
+#ifdef CONFIG_SMP
+	/*
+	 * If this cpu is not yet active, we are in the cpu online path. There
+	 * can be no stop_machine() in parallel, as stop machine ensures this
+	 * by using get_online_cpus(). We can skip taking the stop_cpus_mutex,
+	 * as we don't need it and also we can't afford to block while waiting
+	 * for the mutex.
+	 *
+	 * If this cpu is active, we need to prevent stop_machine() happening
+	 * in parallel by taking the stop cpus mutex.
+	 *
+	 * Also, this is called in the context of cpu online path or in the
+	 * context where cpu hotplug is prevented. So checking the active status
+	 * of the raw_smp_processor_id() is safe.
+	 */
+	if (cpu_active(raw_smp_processor_id()))
+		mutex_lock(&stop_cpus_mutex);
+#endif
+
 	preempt_disable();
 
 	data.smp_reg = reg;
@@ -330,6 +349,10 @@ set_mtrr(unsigned int reg, unsigned long
 
 	local_irq_restore(flags);
 	preempt_enable();
+#ifdef CONFIG_SMP
+	if (cpu_active(raw_smp_processor_id()))
+		mutex_unlock(&stop_cpus_mutex);
+#endif
 }
 
 /**
diff -puN include/linux/stop_machine.h~x86-mtrr-lock-stop-machine-during-mtrr-rendezvous-sequence include/linux/stop_machine.h
--- a/include/linux/stop_machine.h~x86-mtrr-lock-stop-machine-during-mtrr-rendezvous-sequence
+++ a/include/linux/stop_machine.h
@@ -27,6 +27,8 @@ struct cpu_stop_work {
 	struct cpu_stop_done	*done;
 };
 
+extern struct mutex stop_cpus_mutex;
+
 int stop_one_cpu(unsigned int cpu, cpu_stop_fn_t fn, void *arg);
 void stop_one_cpu_nowait(unsigned int cpu, cpu_stop_fn_t fn, void *arg,
 			 struct cpu_stop_work *work_buf);
diff -puN kernel/stop_machine.c~x86-mtrr-lock-stop-machine-during-mtrr-rendezvous-sequence kernel/stop_machine.c
--- a/kernel/stop_machine.c~x86-mtrr-lock-stop-machine-during-mtrr-rendezvous-sequence
+++ a/kernel/stop_machine.c
@@ -132,8 +132,8 @@ void stop_one_cpu_nowait(unsigned int cp
 	cpu_stop_queue_work(&per_cpu(cpu_stopper, cpu), work_buf);
 }
 
+DEFINE_MUTEX(stop_cpus_mutex);
 /* static data for stop_cpus */
-static DEFINE_MUTEX(stop_cpus_mutex);
 static DEFINE_PER_CPU(struct cpu_stop_work, stop_cpus_work);
 
 int __stop_cpus(const struct cpumask *cpumask, cpu_stop_fn_t fn, void *arg)
_

Patches currently in -mm which might be from suresh.b.siddha@intel.com are

x86-mtrr-lock-stop-machine-during-mtrr-rendezvous-sequence.patch
stop_machine-reorganize-stop_cpus-implementation.patch
stop_machine-implement-stop_machine_from_inactive_cpu.patch
x86-mtrr-use-stop_machine-apis-for-doing-mtrr-rendezvous.patch

