From: akpm@linux-foundation.org
Subject: + sched-dynticks-idle-load-balancing-v2.patch added to -mm tree
Date: Wed, 21 Feb 2007 12:24:18 -0800
Message-ID: <200702212024.l1LKOIQG024817@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42462 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423090AbXBUUYb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 15:24:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: suresh.b.siddha@intel.com, mingo@elte.hu, nickpiggin@yahoo.com.au, tglx@linutronix.de


The patch titled
     sched: dynticks idle load balancing
has been added to the -mm tree.  Its filename is
     sched-dynticks-idle-load-balancing-v2.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sched: dynticks idle load balancing
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>

Fix the process idle load balancing in the presence of dynticks.  cpus for
which ticks are stopped will sleep till the next event wakes it up. 
Potentially these sleeps can be for large durations and during which today,
there is no periodic idle load balancing being done.

This patch nominates an owner among the idle cpus, which does the idle load
balancing on behalf of the other idle cpus.  And once all the cpus are
completely idle, then we can stop this idle load balancing too.  Checks
added in fast path are minimized.  Whenever there are busy cpus in the
system, there will be an owner(idle cpu) doing the system wide idle load
balancing.

Open items:
1. Intelligent owner selection (like an idle core in a busy package).
2. Merge with rcu's nohz_cpu_mask?

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h    |    8 +
 kernel/sched.c           |  188 +++++++++++++++++++++++++++++++++++--
 kernel/time/tick-sched.c |    6 +
 3 files changed, 194 insertions(+), 8 deletions(-)

diff -puN include/linux/sched.h~sched-dynticks-idle-load-balancing-v2 include/linux/sched.h
--- a/include/linux/sched.h~sched-dynticks-idle-load-balancing-v2
+++ a/include/linux/sched.h
@@ -194,6 +194,14 @@ extern void sched_init_smp(void);
 extern void init_idle(struct task_struct *idle, int cpu);
 
 extern cpumask_t nohz_cpu_mask;
+#if defined(CONFIG_SMP) && defined(CONFIG_NO_HZ)
+extern int select_nohz_load_balancer(int cpu);
+#else
+static inline int select_nohz_load_balancer(int cpu)
+{
+	return 0;
+}
+#endif
 
 /*
  * Only dump TASK_* tasks. (-1 for all tasks)
diff -puN kernel/sched.c~sched-dynticks-idle-load-balancing-v2 kernel/sched.c
--- a/kernel/sched.c~sched-dynticks-idle-load-balancing-v2
+++ a/kernel/sched.c
@@ -224,6 +224,9 @@ struct rq {
 #ifdef CONFIG_SMP
 	unsigned long cpu_load[3];
 	unsigned char idle_at_tick;
+#ifdef CONFIG_NO_HZ
+	unsigned char in_nohz_recently;
+#endif
 #endif
 	unsigned long long nr_switches;
 
@@ -1051,6 +1054,17 @@ static void resched_task(struct task_str
 	if (!tsk_is_polling(p))
 		smp_send_reschedule(cpu);
 }
+
+static void resched_cpu(int cpu)
+{
+	struct rq *rq = cpu_rq(cpu);
+	unsigned long flags;
+
+	if (!spin_trylock_irqsave(&rq->lock, flags))
+		return;
+	resched_task(cpu_curr(cpu));
+	spin_unlock_irqrestore(&rq->lock, flags);
+}
 #else
 static inline void resched_task(struct task_struct *p)
 {
@@ -2659,6 +2673,9 @@ redo:
 		double_rq_unlock(this_rq, busiest);
 		local_irq_restore(flags);
 
+		if (nr_moved && this_cpu != smp_processor_id())
+			resched_cpu(this_cpu);
+
 		/* All tasks on this runqueue were pinned by CPU affinity */
 		if (unlikely(all_pinned)) {
 			cpu_clear(cpu_of(busiest), cpus);
@@ -2929,6 +2946,79 @@ static void update_load(struct rq *this_
 	}
 }
 
+#ifdef CONFIG_NO_HZ
+static struct {
+	int load_balancer;
+	cpumask_t  cpu_mask;
+} nohz ____cacheline_aligned = {
+	.load_balancer = -1,
+	.cpu_mask = CPU_MASK_NONE,
+};
+
+/*
+ * This routine will try to nominate the ilb (idle load balancing)
+ * owner among the cpus whose ticks are stopped. ilb owner will do the idle
+ * load balancing on behalf of all those cpus. If all the cpus in the system
+ * go into this tickless mode, then there will be no ilb owner (as there is
+ * no need for one) and all the cpus will sleep till the next wakeup event
+ * arrives...
+ *
+ * For the ilb owner, tick is not stopped. And this tick will be used
+ * for idle load balancing. ilb owner will still be part of
+ * nohz.cpu_mask..
+ *
+ * While stopping the tick, this cpu will become the ilb owner if there
+ * is no other owner. And will be the owner till that cpu becomes busy
+ * or if all cpus in the system stop their ticks at which point
+ * there is no need for ilb owner.
+ *
+ * When the ilb owner becomes busy, it nominates another owner, during the
+ * next busy scheduler_tick()
+ */
+int select_nohz_load_balancer(int stop_tick)
+{
+	int cpu = smp_processor_id();
+
+	if (stop_tick) {
+		cpu_set(cpu, nohz.cpu_mask);
+		cpu_rq(cpu)->in_nohz_recently = 1;
+
+		/*
+		 * If we are going offline and still the leader, give up!
+		 */
+		if (cpu_is_offline(cpu) && nohz.load_balancer == cpu) {
+			if (cmpxchg(&nohz.load_balancer,  cpu, -1) != cpu)
+				BUG();
+			return 0;
+		}
+
+		/* time for ilb owner also to sleep */
+		if (cpus_weight(nohz.cpu_mask) == num_online_cpus()) {
+			if (nohz.load_balancer == cpu)
+				nohz.load_balancer = -1;
+			return 0;
+		}
+
+		if (nohz.load_balancer == -1) {
+			/* make me the ilb owner */
+			if (cmpxchg(&nohz.load_balancer, -1, cpu) == -1)
+				return 1;
+		} else if (nohz.load_balancer == cpu)
+			return 1;
+	} else {
+		if (!cpu_isset(cpu, nohz.cpu_mask))
+			return 0;
+
+		cpu_clear(cpu, nohz.cpu_mask);
+
+		if (nohz.load_balancer == cpu)
+			if (cmpxchg(&nohz.load_balancer,  cpu, -1) != cpu)
+				BUG();
+	}
+	return 0;
+}
+#endif
+
 /*
  * run_rebalance_domains is triggered when needed from the scheduler tick.
  *
@@ -2941,15 +3031,46 @@ static DEFINE_SPINLOCK(balancing);
 
 static void run_rebalance_domains(struct softirq_action *h)
 {
-	int this_cpu = smp_processor_id(), balance = 1;
-	struct rq *this_rq = cpu_rq(this_cpu);
-	unsigned long interval;
+	int balance_cpu = smp_processor_id(), balance;
+	struct rq *balance_rq = cpu_rq(balance_cpu);
+	unsigned long interval, next_balance;
 	struct sched_domain *sd;
-	enum idle_type idle = this_rq->idle_at_tick ? SCHED_IDLE : NOT_IDLE;
+	enum idle_type idle;
+
+#ifdef CONFIG_NO_HZ
+	cpumask_t cpus = nohz.cpu_mask;
+	int local_cpu = balance_cpu;
+	struct rq *local_rq = balance_rq;
+
+restart:
+
+	if (local_rq->idle_at_tick && nohz.load_balancer == local_cpu) {
+		if (need_resched())
+			return;
+
+		balance_cpu = first_cpu(cpus);
+		if (unlikely(balance_cpu >= NR_CPUS))
+			return;
+		balance_rq = cpu_rq(balance_cpu);
+		cpu_clear(balance_cpu, cpus);
+	}
+
+	/*
+	 * We must be doing idle load balancing for some other idle cpu
+	 */
+	if (local_cpu != balance_cpu)
+		idle = SCHED_IDLE;
+	else
+#endif
+		idle = balance_rq->idle_at_tick ? SCHED_IDLE : NOT_IDLE;
+
+	balance = 1;
+
 	/* Earliest time when we have to call run_rebalance_domains again */
-	unsigned long next_balance = jiffies + 60*HZ;
+	next_balance = jiffies + 60*HZ;
+
+	for_each_domain(balance_cpu, sd) {
 
-	for_each_domain(this_cpu, sd) {
 		if (!(sd->flags & SD_LOAD_BALANCE))
 			continue;
 
@@ -2968,7 +3089,7 @@ static void run_rebalance_domains(struct
 		}
 
 		if (time_after_eq(jiffies, sd->last_balance + interval)) {
-			if (load_balance(this_cpu, this_rq, sd, idle, &balance)) {
+			if (load_balance(balance_cpu, balance_rq, sd, idle, &balance)) {
 				/*
 				 * We've pulled tasks over so either we're no
 				 * longer idle, or one of our SMT siblings is
@@ -2992,7 +3113,16 @@ out:
 		if (!balance)
 			break;
 	}
-	this_rq->next_balance = next_balance;
+	balance_rq->next_balance = next_balance;
+
+#ifdef CONFIG_NO_HZ
+	if (local_rq->idle_at_tick && nohz.load_balancer == local_cpu) {
+		if (time_after(next_balance, local_rq->next_balance))
+			local_rq->next_balance = next_balance;
+	    	if (!cpus_empty(cpus))
+			goto restart;
+	}
+#endif
 }
 #else
 /*
@@ -3244,7 +3374,49 @@ void scheduler_tick(void)
 		task_running_tick(rq, p);
 #ifdef CONFIG_SMP
 	update_load(rq);
+#ifdef CONFIG_NO_HZ
+	/*
+	 * If we were in the nohz mode recently and busy at the
+	 * current scheduler tick, then check if we need to nominate idle
+	 * load balancer.
+	 */
+	if (rq->in_nohz_recently && !idle_at_tick) {
+		rq->in_nohz_recently = 0;
+
+		if (nohz.load_balancer == cpu) {
+			cpu_clear(cpu, nohz.cpu_mask);
+			nohz.load_balancer = -1;
+		}
+
+		if (nohz.load_balancer == -1) {
+			/*
+			 * simple selection for now: Nominate the
+			 * first cpu in the nohz list to be the next
+			 * ilb owner.
+			 *
+			 * TBD: Traverse the sched domains and nominate
+			 * the nearest cpu in the nohz.cpu_mask.
+			 */
+			int ilb = first_cpu(nohz.cpu_mask);
+
+			if (ilb != NR_CPUS)
+				resched_cpu(ilb);
+		}
+	}
+#endif
 	rq->idle_at_tick = idle_at_tick;
+#ifdef CONFIG_NO_HZ
+	if (rq->idle_at_tick && nohz.load_balancer == cpu &&
+	    cpus_weight(nohz.cpu_mask) == num_online_cpus()) {
+		resched_cpu(cpu);
+		return;
+	}
+
+	if (rq->idle_at_tick && nohz.load_balancer != cpu &&
+	    cpu_isset(cpu, nohz.cpu_mask))
+		return;
+#endif
+
 	if (time_after_eq(jiffies, rq->next_balance))
 		raise_softirq(SCHED_SOFTIRQ);
 #endif
diff -puN kernel/time/tick-sched.c~sched-dynticks-idle-load-balancing-v2 kernel/time/tick-sched.c
--- a/kernel/time/tick-sched.c~sched-dynticks-idle-load-balancing-v2
+++ a/kernel/time/tick-sched.c
@@ -215,6 +215,11 @@ void tick_nohz_stop_sched_tick(void)
 		 * the scheduler tick in nohz_restart_sched_tick.
 		 */
 		if (!ts->tick_stopped) {
+			if (select_nohz_load_balancer(1)) {
+				cpu_clear(cpu, nohz_cpu_mask);
+				goto out;
+			}
+
 			ts->idle_tick = ts->sched_timer.expires;
 			ts->tick_stopped = 1;
 			ts->idle_jiffies = last_jiffies;
@@ -271,6 +276,7 @@ void tick_nohz_restart_sched_tick(void)
 	now = ktime_get();
 
 	local_irq_disable();
+	select_nohz_load_balancer(0);
 	tick_do_update_jiffies64(now);
 	cpu_clear(cpu, nohz_cpu_mask);
 
_

Patches currently in -mm which might be from suresh.b.siddha@intel.com are

sched-fix-idle-load-balancing-in-softirqd-context.patch
sched-dynticks-idle-load-balancing-v2.patch
mm-only-sched-add-a-few-scheduler-event-counters.patch
