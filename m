From: akpm@linux-foundation.org
Subject: - sched-fix-idle-load-balancing-in-softirqd-context.patch removed from -mm tree
Date: Tue, 08 May 2007 19:53:31 -0700
Message-ID: <200705090253.l492rVaR009709@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:34257 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032062AbXEICxk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:53:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: suresh.b.siddha@intel.com, mingo@elte.hu, nickpiggin@yahoo.com.au, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     sched: fix idle load balancing in softirqd context
has been removed from the -mm tree.  Its filename was
     sched-fix-idle-load-balancing-in-softirqd-context.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sched: fix idle load balancing in softirqd context
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>

Periodic load balancing in recent kernels happen in the softirq.  In
certain -rt configurations, these softirqs are handled in softirqd context.
 And hence the check for idle processor was always returning busy (as
nr_running > 1).

This patch captures the idle information at the tick and passes this info
to softirq context through an element 'idle_at_tick' in rq.

[kernel@kolivas.org: Fix reverse idle at tick logic]
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff -puN kernel/sched.c~sched-fix-idle-load-balancing-in-softirqd-context kernel/sched.c
--- a/kernel/sched.c~sched-fix-idle-load-balancing-in-softirqd-context
+++ a/kernel/sched.c
@@ -223,6 +223,7 @@ struct rq {
 	unsigned long raw_weighted_load;
 #ifdef CONFIG_SMP
 	unsigned long cpu_load[3];
+	unsigned char idle_at_tick;
 #endif
 	unsigned long long nr_switches;
 
@@ -2943,12 +2944,7 @@ static void run_rebalance_domains(struct
 	struct rq *this_rq = cpu_rq(this_cpu);
 	unsigned long interval;
 	struct sched_domain *sd;
-	/*
-	 * We are idle if there are no processes running. This
-	 * is valid even if we are the idle process (SMT).
-	 */
-	enum idle_type idle = !this_rq->nr_running ?
-				SCHED_IDLE : NOT_IDLE;
+	enum idle_type idle = this_rq->idle_at_tick ? SCHED_IDLE : NOT_IDLE;
 	/* Earliest time when we have to call run_rebalance_domains again */
 	unsigned long next_balance = jiffies + 60*HZ;
 
@@ -3218,14 +3214,16 @@ void scheduler_tick(void)
 	unsigned long long now = sched_clock();
 	struct task_struct *p = current;
 	int cpu = smp_processor_id();
+	int idle_at_tick = idle_cpu(cpu);
 	struct rq *rq = cpu_rq(cpu);
 
 	update_cpu_clock(p, rq, now);
 
-	if (p != rq->idle)
+	if (!idle_at_tick)
 		task_running_tick(rq, p);
 #ifdef CONFIG_SMP
 	update_load(rq);
+	rq->idle_at_tick = idle_at_tick;
 	if (time_after_eq(jiffies, rq->next_balance))
 		raise_softirq(SCHED_SOFTIRQ);
 #endif
_

Patches currently in -mm which might be from suresh.b.siddha@intel.com are

origin.patch
git-ia64.patch
