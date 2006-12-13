From: akpm@osdl.org
Subject: - sched-decrease-number-of-load-balances.patch removed from -mm tree
Date: Tue, 12 Dec 2006 22:54:37 -0800
Message-ID: <200612130654.kBD6sbMC030561@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57646 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965009AbWLMGyn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 01:54:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: suresh.b.siddha@intel.com, clameter@engr.sgi.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     sched: decrease number of load balances
has been removed from the -mm tree.  Its filename was
     sched-decrease-number-of-load-balances.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sched: decrease number of load balances
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>

Currently at a particular domain, each cpu in the sched group will do a
load balance at the frequency of balance_interval.  More the cores and
threads, more the cpus will be in each sched group at SMP and NUMA domain. 
And we endup spending quite a bit of time doing load balancing in those
domains.

Fix this by making only one cpu(first idle cpu or first cpu in the group if
all the cpus are busy) in the sched group do the load balance at that
particular sched domain and this load will slowly percolate down to the
other cpus with in that group(when they do load balancing at lower
domains).

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Christoph Lameter <clameter@engr.sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/sched.h |    1 
 kernel/sched.c        |   59 +++++++++++++++++++++++++++++++---------
 2 files changed, 48 insertions(+), 12 deletions(-)

diff -puN include/linux/sched.h~sched-decrease-number-of-load-balances include/linux/sched.h
--- a/include/linux/sched.h~sched-decrease-number-of-load-balances
+++ a/include/linux/sched.h
@@ -707,6 +707,7 @@ struct sched_domain {
 	unsigned long lb_hot_gained[MAX_IDLE_TYPES];
 	unsigned long lb_nobusyg[MAX_IDLE_TYPES];
 	unsigned long lb_nobusyq[MAX_IDLE_TYPES];
+	unsigned long lb_stopbalance[MAX_IDLE_TYPES];
 
 	/* Active load balancing */
 	unsigned long alb_cnt;
diff -puN kernel/sched.c~sched-decrease-number-of-load-balances kernel/sched.c
--- a/kernel/sched.c~sched-decrease-number-of-load-balances
+++ a/kernel/sched.c
@@ -428,7 +428,7 @@ static inline void task_rq_unlock(struct
  * bump this up when changing the output format or the meaning of an existing
  * format, so that tools can adapt (or abort)
  */
-#define SCHEDSTAT_VERSION 12
+#define SCHEDSTAT_VERSION 13
 
 static int show_schedstat(struct seq_file *seq, void *v)
 {
@@ -466,7 +466,7 @@ static int show_schedstat(struct seq_fil
 			seq_printf(seq, "domain%d %s", dcnt++, mask_str);
 			for (itype = SCHED_IDLE; itype < MAX_IDLE_TYPES;
 					itype++) {
-				seq_printf(seq, " %lu %lu %lu %lu %lu %lu %lu %lu",
+				seq_printf(seq, " %lu %lu %lu %lu %lu %lu %lu %lu %lu",
 				    sd->lb_cnt[itype],
 				    sd->lb_balanced[itype],
 				    sd->lb_failed[itype],
@@ -474,7 +474,8 @@ static int show_schedstat(struct seq_fil
 				    sd->lb_gained[itype],
 				    sd->lb_hot_gained[itype],
 				    sd->lb_nobusyq[itype],
-				    sd->lb_nobusyg[itype]);
+				    sd->lb_nobusyg[itype],
+				    sd->lb_stopbalance[itype]);
 			}
 			seq_printf(seq, " %lu %lu %lu %lu %lu %lu %lu %lu %lu %lu %lu %lu\n",
 			    sd->alb_cnt, sd->alb_failed, sd->alb_pushed,
@@ -2249,7 +2250,7 @@ out:
 static struct sched_group *
 find_busiest_group(struct sched_domain *sd, int this_cpu,
 		   unsigned long *imbalance, enum idle_type idle, int *sd_idle,
-		   cpumask_t *cpus)
+		   cpumask_t *cpus, int *balance)
 {
 	struct sched_group *busiest = NULL, *this = NULL, *group = sd->groups;
 	unsigned long max_load, avg_load, total_load, this_load, total_pwr;
@@ -2278,10 +2279,14 @@ find_busiest_group(struct sched_domain *
 		unsigned long load, group_capacity;
 		int local_group;
 		int i;
+		unsigned int balance_cpu = -1, first_idle_cpu = 0;
 		unsigned long sum_nr_running, sum_weighted_load;
 
 		local_group = cpu_isset(this_cpu, group->cpumask);
 
+		if (local_group)
+			balance_cpu = first_cpu(group->cpumask);
+
 		/* Tally up the load of all CPUs in the group */
 		sum_weighted_load = sum_nr_running = avg_load = 0;
 
@@ -2297,9 +2302,14 @@ find_busiest_group(struct sched_domain *
 				*sd_idle = 0;
 
 			/* Bias balancing toward cpus of our domain */
-			if (local_group)
+			if (local_group) {
+				if (idle_cpu(i) && !first_idle_cpu) {
+					first_idle_cpu = 1;
+					balance_cpu = i;
+				}
+
 				load = target_load(i, load_idx);
-			else
+			} else
 				load = source_load(i, load_idx);
 
 			avg_load += load;
@@ -2307,6 +2317,16 @@ find_busiest_group(struct sched_domain *
 			sum_weighted_load += rq->raw_weighted_load;
 		}
 
+		/*
+		 * First idle cpu or the first cpu(busiest) in this sched group
+		 * is eligible for doing load balancing at this and above
+		 * domains.
+		 */
+		if (local_group && balance_cpu != this_cpu && balance) {
+			*balance = 0;
+			goto ret;
+		}
+
 		total_load += avg_load;
 		total_pwr += group->cpu_power;
 
@@ -2498,8 +2518,8 @@ out_balanced:
 		*imbalance = min_load_per_task;
 		return group_min;
 	}
-ret:
 #endif
+ret:
 	*imbalance = 0;
 	return NULL;
 }
@@ -2550,7 +2570,8 @@ static inline unsigned long minus_1_or_z
  * tasks if there is an imbalance.
  */
 static int load_balance(int this_cpu, struct rq *this_rq,
-			struct sched_domain *sd, enum idle_type idle)
+			struct sched_domain *sd, enum idle_type idle,
+			int *balance)
 {
 	int nr_moved, all_pinned = 0, active_balance = 0, sd_idle = 0;
 	struct sched_group *group;
@@ -2573,7 +2594,13 @@ static int load_balance(int this_cpu, st
 
 redo:
 	group = find_busiest_group(sd, this_cpu, &imbalance, idle, &sd_idle,
-							&cpus);
+				   &cpus, balance);
+
+	if (*balance == 0) {
+		schedstat_inc(sd, lb_stopbalance[idle]);
+		goto out_balanced;
+	}
+
 	if (!group) {
 		schedstat_inc(sd, lb_nobusyg[idle]);
 		goto out_balanced;
@@ -2715,7 +2742,7 @@ load_balance_newidle(int this_cpu, struc
 	schedstat_inc(sd, lb_cnt[NEWLY_IDLE]);
 redo:
 	group = find_busiest_group(sd, this_cpu, &imbalance, NEWLY_IDLE,
-				&sd_idle, &cpus);
+				   &sd_idle, &cpus, NULL);
 	if (!group) {
 		schedstat_inc(sd, lb_nobusyg[NEWLY_IDLE]);
 		goto out_balanced;
@@ -2885,7 +2912,7 @@ static DEFINE_SPINLOCK(balancing);
 
 static void run_rebalance_domains(struct softirq_action *h)
 {
-	int this_cpu = smp_processor_id();
+	int this_cpu = smp_processor_id(), balance = 1;
 	struct rq *this_rq = cpu_rq(this_cpu);
 	unsigned long interval;
 	struct sched_domain *sd;
@@ -2917,7 +2944,7 @@ static void run_rebalance_domains(struct
 		}
 
 		if (time_after_eq(jiffies, sd->last_balance + interval)) {
-			if (load_balance(this_cpu, this_rq, sd, idle)) {
+			if (load_balance(this_cpu, this_rq, sd, idle, &balance)) {
 				/*
 				 * We've pulled tasks over so either we're no
 				 * longer idle, or one of our SMT siblings is
@@ -2932,6 +2959,14 @@ static void run_rebalance_domains(struct
 out:
 		if (time_after(next_balance, sd->last_balance + interval))
 			next_balance = sd->last_balance + interval;
+
+		/*
+		 * Stop the load balance at this level. There is another
+		 * CPU in our sched group which is doing load balancing more
+		 * actively.
+		 */
+		if (!balance)
+			break;
 	}
 	this_rq->next_balance = next_balance;
 }
_

Patches currently in -mm which might be from suresh.b.siddha@intel.com are

origin.patch
revert-i386-fix-the-verify_quirk_intel_irqbalance.patch
revert-x86_64-mm-add-genapic_force.patch
revert-x86_64-mm-fix-the-irqbalance-quirk-for-e7320-e7520-e7525.patch
genapic-optimize-fix-apic-mode-setup-2.patch
genapic-always-use-physical-delivery-mode-on-8-cpus.patch
genapic-remove-es7000-workaround.patch
genapic-remove-clustered-apic-mode.patch
genapic-default-to-physical-mode-on-hotplug-cpu-kernels.patch
optimize-calc_load.patch
mm-only-sched-add-a-few-scheduler-event-counters.patch

