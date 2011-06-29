From: akpm@linux-foundation.org
Subject: + x86-mtrr-use-stop_machine-apis-for-doing-mtrr-rendezvous.patch added to -mm tree
Date: Wed, 29 Jun 2011 14:41:20 -0700
Message-ID: <201106292141.p5TLfKOO013681@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43130 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753292Ab1F2VmE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 29 Jun 2011 17:42:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: suresh.b.siddha@intel.com, a.p.zijlstra@chello.nl, mingo@elte.hu, tj@kernel.org


The patch titled
     x86, mtrr: use stop_machine APIs for doing MTRR rendezvous
has been added to the -mm tree.  Its filename is
     x86-mtrr-use-stop_machine-apis-for-doing-mtrr-rendezvous.patch

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
Subject: x86, mtrr: use stop_machine APIs for doing MTRR rendezvous
From: Suresh Siddha <suresh.b.siddha@intel.com>

MTRR rendezvous sequence is not implemened using stop_machine() before, as
this gets called both from the process context aswell as the cpu online
paths (where the cpu has not come online and the interrupts are disabled
etc).

Now that we have a new stop_machine_from_inactive_cpu() API, use it for
rendezvous during mtrr init of a logical processor that is coming online.

For the rest (runtime MTRR modification, system boot, resume paths), use
stop_machine() to implement the rendezvous sequence.  This will
consolidate and cleanup the code.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/cpu/mtrr/main.c |  194 ++++++------------------------
 include/linux/stop_machine.h    |    2 
 kernel/stop_machine.c           |    2 
 3 files changed, 43 insertions(+), 155 deletions(-)

diff -puN arch/x86/kernel/cpu/mtrr/main.c~x86-mtrr-use-stop_machine-apis-for-doing-mtrr-rendezvous arch/x86/kernel/cpu/mtrr/main.c
--- a/arch/x86/kernel/cpu/mtrr/main.c~x86-mtrr-use-stop_machine-apis-for-doing-mtrr-rendezvous
+++ a/arch/x86/kernel/cpu/mtrr/main.c
@@ -137,55 +137,43 @@ static void __init init_table(void)
 }
 
 struct set_mtrr_data {
-	atomic_t	count;
-	atomic_t	gate;
 	unsigned long	smp_base;
 	unsigned long	smp_size;
 	unsigned int	smp_reg;
 	mtrr_type	smp_type;
 };
 
-static DEFINE_PER_CPU(struct cpu_stop_work, mtrr_work);
-
 /**
- * mtrr_work_handler - Synchronisation handler. Executed by "other" CPUs.
+ * mtrr_rendezvous_handler - Work done in the synchronization handler. Executed
+ * by all the CPUs.
  * @info: pointer to mtrr configuration data
  *
  * Returns nothing.
  */
-static int mtrr_work_handler(void *info)
+static int mtrr_rendezvous_handler(void *info)
 {
 #ifdef CONFIG_SMP
 	struct set_mtrr_data *data = info;
-	unsigned long flags;
-
-	atomic_dec(&data->count);
-	while (!atomic_read(&data->gate))
-		cpu_relax();
-
-	local_irq_save(flags);
-
-	atomic_dec(&data->count);
-	while (atomic_read(&data->gate))
-		cpu_relax();
 
-	/*  The master has cleared me to execute  */
+	/*
+	 * We use this same function to initialize the mtrrs during boot,
+	 * resume, runtime cpu online and on an explicit request to set a
+	 * specific MTRR.
+	 *
+	 * During boot or suspend, the state of the boot cpu's mtrrs has been
+	 * saved, and we want to replicate that across all the cpus that come
+	 * online (either at the end of boot or resume or during a runtime cpu
+	 * online). If we're doing that, @reg is set to something special and on
+	 * all the cpu's we do mtrr_if->set_all() (On the logical cpu that
+	 * started the boot/resume sequence, this might be a duplicate
+	 * set_all()).
+	 */
 	if (data->smp_reg != ~0U) {
 		mtrr_if->set(data->smp_reg, data->smp_base,
 			     data->smp_size, data->smp_type);
-	} else if (mtrr_aps_delayed_init) {
-		/*
-		 * Initialize the MTRRs inaddition to the synchronisation.
-		 */
+	} else if (mtrr_aps_delayed_init || !cpu_online(smp_processor_id())) {
 		mtrr_if->set_all();
 	}
-
-	atomic_dec(&data->count);
-	while (!atomic_read(&data->gate))
-		cpu_relax();
-
-	atomic_dec(&data->count);
-	local_irq_restore(flags);
 #endif
 	return 0;
 }
@@ -223,20 +211,11 @@ static inline int types_compatible(mtrr_
  * 14. Wait for buddies to catch up
  * 15. Enable interrupts.
  *
- * What does that mean for us? Well, first we set data.count to the number
- * of CPUs. As each CPU announces that it started the rendezvous handler by
- * decrementing the count, We reset data.count and set the data.gate flag
- * allowing all the cpu's to proceed with the work. As each cpu disables
- * interrupts, it'll decrement data.count once. We wait until it hits 0 and
- * proceed. We clear the data.gate flag and reset data.count. Meanwhile, they
- * are waiting for that flag to be cleared. Once it's cleared, each
- * CPU goes through the transition of updating MTRRs.
- * The CPU vendors may each do it differently,
- * so we call mtrr_if->set() callback and let them take care of it.
- * When they're done, they again decrement data->count and wait for data.gate
- * to be set.
- * When we finish, we wait for data.count to hit 0 and toggle the data.gate flag
- * Everyone then enables interrupts and we all continue on.
+ * What does that mean for us? Well, stop_machine() will ensure that
+ * the rendezvous handler is started on each CPU. And in lockstep they
+ * do the state transition of disabling interrupts, updating MTRR's
+ * (the CPU vendors may each do it differently, so we call mtrr_if->set()
+ * callback and let them take care of it.) and enabling interrupts.
  *
  * Note that the mechanism is the same for UP systems, too; all the SMP stuff
  * becomes nops.
@@ -244,115 +223,26 @@ static inline int types_compatible(mtrr_
 static void
 set_mtrr(unsigned int reg, unsigned long base, unsigned long size, mtrr_type type)
 {
-	struct set_mtrr_data data;
-	unsigned long flags;
-	int cpu;
-
-#ifdef CONFIG_SMP
-	/*
-	 * If this cpu is not yet active, we are in the cpu online path. There
-	 * can be no stop_machine() in parallel, as stop machine ensures this
-	 * by using get_online_cpus(). We can skip taking the stop_cpus_mutex,
-	 * as we don't need it and also we can't afford to block while waiting
-	 * for the mutex.
-	 *
-	 * If this cpu is active, we need to prevent stop_machine() happening
-	 * in parallel by taking the stop cpus mutex.
-	 *
-	 * Also, this is called in the context of cpu online path or in the
-	 * context where cpu hotplug is prevented. So checking the active status
-	 * of the raw_smp_processor_id() is safe.
-	 */
-	if (cpu_active(raw_smp_processor_id()))
-		mutex_lock(&stop_cpus_mutex);
-#endif
-
-	preempt_disable();
-
-	data.smp_reg = reg;
-	data.smp_base = base;
-	data.smp_size = size;
-	data.smp_type = type;
-	atomic_set(&data.count, num_booting_cpus() - 1);
-
-	/* Make sure data.count is visible before unleashing other CPUs */
-	smp_wmb();
-	atomic_set(&data.gate, 0);
-
-	/* Start the ball rolling on other CPUs */
-	for_each_online_cpu(cpu) {
-		struct cpu_stop_work *work = &per_cpu(mtrr_work, cpu);
-
-		if (cpu == smp_processor_id())
-			continue;
+	struct set_mtrr_data data = { .smp_reg = reg,
+				      .smp_base = base,
+				      .smp_size = size,
+				      .smp_type = type
+				    };
+
+	stop_machine(mtrr_rendezvous_handler, &data, cpu_online_mask);
+}
+
+static void set_mtrr_from_inactive_cpu(unsigned int reg, unsigned long base,
+				      unsigned long size, mtrr_type type)
+{
+	struct set_mtrr_data data = { .smp_reg = reg,
+				      .smp_base = base,
+				      .smp_size = size,
+				      .smp_type = type
+				    };
 
-		stop_one_cpu_nowait(cpu, mtrr_work_handler, &data, work);
-	}
-
-
-	while (atomic_read(&data.count))
-		cpu_relax();
-
-	/* Ok, reset count and toggle gate */
-	atomic_set(&data.count, num_booting_cpus() - 1);
-	smp_wmb();
-	atomic_set(&data.gate, 1);
-
-	local_irq_save(flags);
-
-	while (atomic_read(&data.count))
-		cpu_relax();
-
-	/* Ok, reset count and toggle gate */
-	atomic_set(&data.count, num_booting_cpus() - 1);
-	smp_wmb();
-	atomic_set(&data.gate, 0);
-
-	/* Do our MTRR business */
-
-	/*
-	 * HACK!
-	 *
-	 * We use this same function to initialize the mtrrs during boot,
-	 * resume, runtime cpu online and on an explicit request to set a
-	 * specific MTRR.
-	 *
-	 * During boot or suspend, the state of the boot cpu's mtrrs has been
-	 * saved, and we want to replicate that across all the cpus that come
-	 * online (either at the end of boot or resume or during a runtime cpu
-	 * online). If we're doing that, @reg is set to something special and on
-	 * this cpu we still do mtrr_if->set_all(). During boot/resume, this
-	 * is unnecessary if at this point we are still on the cpu that started
-	 * the boot/resume sequence. But there is no guarantee that we are still
-	 * on the same cpu. So we do mtrr_if->set_all() on this cpu aswell to be
-	 * sure that we are in sync with everyone else.
-	 */
-	if (reg != ~0U)
-		mtrr_if->set(reg, base, size, type);
-	else
-		mtrr_if->set_all();
-
-	/* Wait for the others */
-	while (atomic_read(&data.count))
-		cpu_relax();
-
-	atomic_set(&data.count, num_booting_cpus() - 1);
-	smp_wmb();
-	atomic_set(&data.gate, 1);
-
-	/*
-	 * Wait here for everyone to have seen the gate change
-	 * So we're the last ones to touch 'data'
-	 */
-	while (atomic_read(&data.count))
-		cpu_relax();
-
-	local_irq_restore(flags);
-	preempt_enable();
-#ifdef CONFIG_SMP
-	if (cpu_active(raw_smp_processor_id()))
-		mutex_unlock(&stop_cpus_mutex);
-#endif
+	stop_machine_from_inactive_cpu(mtrr_rendezvous_handler, &data,
+				       cpu_callout_mask);
 }
 
 /**
@@ -806,7 +696,7 @@ void mtrr_ap_init(void)
 	 *   2. cpu hotadd time. We let mtrr_add/del_page hold cpuhotplug
 	 *      lock to prevent mtrr entry changes
 	 */
-	set_mtrr(~0U, 0, 0, 0);
+	set_mtrr_from_inactive_cpu(~0U, 0, 0, 0);
 }
 
 /**
diff -puN include/linux/stop_machine.h~x86-mtrr-use-stop_machine-apis-for-doing-mtrr-rendezvous include/linux/stop_machine.h
--- a/include/linux/stop_machine.h~x86-mtrr-use-stop_machine-apis-for-doing-mtrr-rendezvous
+++ a/include/linux/stop_machine.h
@@ -27,8 +27,6 @@ struct cpu_stop_work {
 	struct cpu_stop_done	*done;
 };
 
-extern struct mutex stop_cpus_mutex;
-
 int stop_one_cpu(unsigned int cpu, cpu_stop_fn_t fn, void *arg);
 void stop_one_cpu_nowait(unsigned int cpu, cpu_stop_fn_t fn, void *arg,
 			 struct cpu_stop_work *work_buf);
diff -puN kernel/stop_machine.c~x86-mtrr-use-stop_machine-apis-for-doing-mtrr-rendezvous kernel/stop_machine.c
--- a/kernel/stop_machine.c~x86-mtrr-use-stop_machine-apis-for-doing-mtrr-rendezvous
+++ a/kernel/stop_machine.c
@@ -132,8 +132,8 @@ void stop_one_cpu_nowait(unsigned int cp
 	cpu_stop_queue_work(&per_cpu(cpu_stopper, cpu), work_buf);
 }
 
-DEFINE_MUTEX(stop_cpus_mutex);
 /* static data for stop_cpus */
+static DEFINE_MUTEX(stop_cpus_mutex);
 static DEFINE_PER_CPU(struct cpu_stop_work, stop_cpus_work);
 
 static void queue_stop_cpus_work(const struct cpumask *cpumask,
_

Patches currently in -mm which might be from suresh.b.siddha@intel.com are

x86-mtrr-lock-stop-machine-during-mtrr-rendezvous-sequence.patch
stop_machine-reorganize-stop_cpus-implementation.patch
stop_machine-implement-stop_machine_from_inactive_cpu.patch
x86-mtrr-use-stop_machine-apis-for-doing-mtrr-rendezvous.patch

