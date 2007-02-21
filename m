From: akpm@linux-foundation.org
Subject: + sched-fix-idle-load-balancing-in-softirqd-context.patch added to -mm tree
Date: Wed, 21 Feb 2007 12:24:16 -0800
Message-ID: <200702212024.l1LKOGdp024814@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42457 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423089AbXBUUY2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 15:24:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: suresh.b.siddha@intel.com, mingo@elte.hu, nickpiggin@yahoo.com.au, tglx@linutronix.de


The patch titled
     sched: fix idle load balancing in softirqd context
has been added to the -mm tree.  Its filename is
     sched-fix-idle-load-balancing-in-softirqd-context.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sched: fix idle load balancing in softirqd context
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>

Periodic load balancing in recent kernels happen in the softirq.  In
certain -rt configurations, these softirqs are handled in softirqd context.
 And hence the check for idle processor was always returning busy (as
nr_running > 1).

This patch captures the idle information at the tick and passes this info
to softirq context through an element 'idle_at_tick' in rq.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched.c |   12 +++++-------
 1 files changed, 5 insertions(+), 7 deletions(-)

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
 
@@ -2944,12 +2945,7 @@ static void run_rebalance_domains(struct
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
 
@@ -3236,17 +3232,19 @@ void scheduler_tick(void)
 	unsigned long long now = sched_clock();
 	struct task_struct *p = current;
 	int cpu = smp_processor_id();
+	int idle_at_tick = idle_cpu(cpu);
 	struct rq *rq = cpu_rq(cpu);
 
 	update_cpu_clock(p, rq, now);
 
-	if (p == rq->idle)
+	if (idle_at_tick)
 		/* Task on the idle queue */
 		wake_priority_sleeper(rq);
 	else
 		task_running_tick(rq, p);
 #ifdef CONFIG_SMP
 	update_load(rq);
+	rq->idle_at_tick = idle_at_tick;
 	if (time_after_eq(jiffies, rq->next_balance))
 		raise_softirq(SCHED_SOFTIRQ);
 #endif
_

Patches currently in -mm which might be from suresh.b.siddha@intel.com are

sched-fix-idle-load-balancing-in-softirqd-context.patch
sched-dynticks-idle-load-balancing-v2.patch
mm-only-sched-add-a-few-scheduler-event-counters.patch
