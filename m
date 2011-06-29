From: akpm@linux-foundation.org
Subject: + stop_machine-implement-stop_machine_from_inactive_cpu.patch added to -mm tree
Date: Wed, 29 Jun 2011 14:41:18 -0700
Message-ID: <201106292141.p5TLfIrx013678@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33509 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753292Ab1F2Vl5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 29 Jun 2011 17:41:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tj@kernel.org, a.p.zijlstra@chello.nl, mingo@elte.hu, suresh.b.siddha@intel.com


The patch titled
     stop_machine: implement stop_machine_from_inactive_cpu()
has been added to the -mm tree.  Its filename is
     stop_machine-implement-stop_machine_from_inactive_cpu.patch

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
Subject: stop_machine: implement stop_machine_from_inactive_cpu()
From: Tejun Heo <tj@kernel.org>

Currently, mtrr wants stop_machine functionality while a CPU is being
brought up.  As stop_machine() requires the calling CPU to be active, mtrr
implements its own stop_machine using stop_one_cpu() on each online CPU. 
This doesn't only unnecessarily duplicate complex logic but also
introduces a possibility of deadlock when it races against the generic
stop_machine().

This patch implements stop_machine_from_inactive_cpu() to serve such use
cases.  Its functionality is basically the same as stop_machine();
however, it should be called from a CPU which isn't active and doesn't
depend on working scheduling on the calling CPU.

This is achieved by using busy loops for synchronization and open-coding
stop_cpus queuing and waiting with direct invocation of fn() for local CPU
inbetween.

Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/stop_machine.h |   14 ++++++-
 kernel/stop_machine.c        |   62 ++++++++++++++++++++++++++++++++-
 2 files changed, 73 insertions(+), 3 deletions(-)

diff -puN include/linux/stop_machine.h~stop_machine-implement-stop_machine_from_inactive_cpu include/linux/stop_machine.h
--- a/include/linux/stop_machine.h~stop_machine-implement-stop_machine_from_inactive_cpu
+++ a/include/linux/stop_machine.h
@@ -126,15 +126,19 @@ int stop_machine(int (*fn)(void *), void
  */
 int __stop_machine(int (*fn)(void *), void *data, const struct cpumask *cpus);
 
+int stop_machine_from_inactive_cpu(int (*fn)(void *), void *data,
+				   const struct cpumask *cpus);
+
 #else	 /* CONFIG_STOP_MACHINE && CONFIG_SMP */
 
 static inline int __stop_machine(int (*fn)(void *), void *data,
 				 const struct cpumask *cpus)
 {
+	unsigned long flags;
 	int ret;
-	local_irq_disable();
+	local_irq_save(flags);
 	ret = fn(data);
-	local_irq_enable();
+	local_irq_restore(flags);
 	return ret;
 }
 
@@ -144,5 +148,11 @@ static inline int stop_machine(int (*fn)
 	return __stop_machine(fn, data, cpus);
 }
 
+static inline int stop_machine_from_inactive_cpu(int (*fn)(void *), void *data,
+						 const struct cpumask *cpus)
+{
+	return __stop_machine(fn, data, cpus);
+}
+
 #endif	/* CONFIG_STOP_MACHINE && CONFIG_SMP */
 #endif	/* _LINUX_STOP_MACHINE */
diff -puN kernel/stop_machine.c~stop_machine-implement-stop_machine_from_inactive_cpu kernel/stop_machine.c
--- a/kernel/stop_machine.c~stop_machine-implement-stop_machine_from_inactive_cpu
+++ a/kernel/stop_machine.c
@@ -439,8 +439,15 @@ static int stop_machine_cpu_stop(void *d
 	struct stop_machine_data *smdata = data;
 	enum stopmachine_state curstate = STOPMACHINE_NONE;
 	int cpu = smp_processor_id(), err = 0;
+	unsigned long flags;
 	bool is_active;
 
+	/*
+	 * When called from stop_machine_from_inactive_cpu(), irq might
+	 * already be disabled.  Save the state and restore it on exit.
+	 */
+	local_save_flags(flags);
+
 	if (!smdata->active_cpus)
 		is_active = cpu == cpumask_first(cpu_online_mask);
 	else
@@ -468,7 +475,7 @@ static int stop_machine_cpu_stop(void *d
 		}
 	} while (curstate != STOPMACHINE_EXIT);
 
-	local_irq_enable();
+	local_irq_restore(flags);
 	return err;
 }
 
@@ -495,4 +502,57 @@ int stop_machine(int (*fn)(void *), void
 }
 EXPORT_SYMBOL_GPL(stop_machine);
 
+/**
+ * stop_machine_from_inactive_cpu - stop_machine() from inactive CPU
+ * @fn: the function to run
+ * @data: the data ptr for the @fn()
+ * @cpus: the cpus to run the @fn() on (NULL = any online cpu)
+ *
+ * This is identical to stop_machine() but can be called from a CPU which
+ * is not active.  The local CPU is in the process of hotplug (so no other
+ * CPU hotplug can start) and not marked active and doesn't have enough
+ * context to sleep.
+ *
+ * This function provides stop_machine() functionality for such state by
+ * using busy-wait for synchronization and executing @fn directly for local
+ * CPU.
+ *
+ * CONTEXT:
+ * Local CPU is inactive.  Temporarily stops all active CPUs.
+ *
+ * RETURNS:
+ * 0 if all executions of @fn returned 0, any non zero return value if any
+ * returned non zero.
+ */
+int stop_machine_from_inactive_cpu(int (*fn)(void *), void *data,
+				  const struct cpumask *cpus)
+{
+	struct stop_machine_data smdata = { .fn = fn, .data = data,
+					    .active_cpus = cpus };
+	struct cpu_stop_done done;
+	int ret;
+
+	/* Local CPU must be inactive and CPU hotplug in progress. */
+	BUG_ON(cpu_active(raw_smp_processor_id()));
+	smdata.num_threads = num_active_cpus() + 1;	/* +1 for local */
+
+	/* No proper task established and can't sleep - busy wait for lock. */
+	while (!mutex_trylock(&stop_cpus_mutex))
+		cpu_relax();
+
+	/* Schedule work on other CPUs and execute directly for local CPU */
+	set_state(&smdata, STOPMACHINE_PREPARE);
+	cpu_stop_init_done(&done, num_active_cpus());
+	queue_stop_cpus_work(cpu_active_mask, stop_machine_cpu_stop, &smdata,
+			     &done);
+	ret = stop_machine_cpu_stop(&smdata);
+
+	/* Busy wait for completion. */
+	while (!completion_done(&done.completion))
+		cpu_relax();
+
+	mutex_unlock(&stop_cpus_mutex);
+	return ret ?: done.ret;
+}
+
 #endif	/* CONFIG_STOP_MACHINE */
_

Patches currently in -mm which might be from tj@kernel.org are

linux-next.patch
x86-mtrr-lock-stop-machine-during-mtrr-rendezvous-sequence.patch
stop_machine-reorganize-stop_cpus-implementation.patch
stop_machine-implement-stop_machine_from_inactive_cpu.patch
x86-mtrr-use-stop_machine-apis-for-doing-mtrr-rendezvous.patch
drivers-use-kzalloc-kcalloc-instead-of-kmallocmemset-where-possible.patch
devres-fix-possible-use-after-free.patch
ptrace-unify-show_regs-prototype.patch
ptrace-unify-show_regs-prototype-fix.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update.patch
scatterlist-new-helper-functions-update-fix.patch

