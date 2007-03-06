From: akpm@linux-foundation.org
Subject: - sched-dynticks-idle-load-balancing-v3-fix.patch removed from -mm tree
Date: Mon, 05 Mar 2007 17:18:05 -0800
Message-ID: <200703060118.l261I7vw007421@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44711 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932876AbXCFBSN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 20:18:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: suresh.b.siddha@intel.com, mm-commits@vger.kernel.org


The patch titled
     sched-dynticks-idle-load-balancing-v3 fix
has been removed from the -mm tree.  Its filename was
     sched-dynticks-idle-load-balancing-v3-fix.patch

This patch was dropped because it was folded into sched-dynticks-idle-load-balancing-v3.patch

------------------------------------------------------
Subject: sched-dynticks-idle-load-balancing-v3 fix
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>

Move trigger_load_balance() under ifdef CONFIG_SMP.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched.c |  124 +++++++++++++++++++++++------------------------
 1 files changed, 62 insertions(+), 62 deletions(-)

diff -puN kernel/sched.c~sched-dynticks-idle-load-balancing-v3-fix kernel/sched.c
--- a/kernel/sched.c~sched-dynticks-idle-load-balancing-v3-fix
+++ a/kernel/sched.c
@@ -3130,6 +3130,68 @@ static void run_rebalance_domains(struct
 	}
 #endif
 }
+
+/*
+ * Trigger the SCHED_SOFTIRQ if it is time to do periodic load balancing.
+ *
+ * In case of CONFIG_NO_HZ, this is the place where we nominate a new
+ * idle load balancing owner or decide to stop the periodic load balancing,
+ * if the whole system is idle.
+ */
+static inline void trigger_load_balance(int cpu)
+{
+	struct rq *rq = cpu_rq(cpu);
+#ifdef CONFIG_NO_HZ
+	/*
+	 * If we were in the nohz mode recently and busy at the current
+	 * scheduler tick, then check if we need to nominate new idle
+	 * load balancer.
+	 */
+	if (rq->in_nohz_recently && !rq->idle_at_tick) {
+		rq->in_nohz_recently = 0;
+
+		if (atomic_read(&nohz.load_balancer) == cpu) {
+			cpu_clear(cpu, nohz.cpu_mask);
+			atomic_set(&nohz.load_balancer, -1);
+		}
+
+		if (atomic_read(&nohz.load_balancer) == -1) {
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
+
+	/*
+	 * If this cpu is idle and doing idle load balancing for all the
+	 * cpus with ticks stopped, is it time for that to stop?
+	 */
+	if (rq->idle_at_tick && atomic_read(&nohz.load_balancer) == cpu &&
+	    cpus_weight(nohz.cpu_mask) == num_online_cpus()) {
+		resched_cpu(cpu);
+		return;
+	}
+
+	/*
+	 * If this cpu is idle and the idle load balancing is done by
+	 * someone else, then no need raise the SCHED_SOFTIRQ
+	 */
+	if (rq->idle_at_tick && atomic_read(&nohz.load_balancer) != cpu &&
+	    cpu_isset(cpu, nohz.cpu_mask))
+		return;
+#endif
+	if (time_after_eq(jiffies, rq->next_balance))
+		raise_softirq(SCHED_SOFTIRQ);
+}
 #else
 /*
  * on UP we do not need to balance between CPUs:
@@ -3340,68 +3402,6 @@ out_unlock:
 }
 
 /*
- * Trigger the SCHED_SOFTIRQ if it is time to do periodic load balancing.
- *
- * In case of CONFIG_NO_HZ, this is the place where we nominate a new
- * idle load balancing owner or decide to stop the periodic load balancing,
- * if the whole system is idle.
- */
-static inline void trigger_load_balance(int cpu)
-{
-	struct rq *rq = cpu_rq(cpu);
-#ifdef CONFIG_NO_HZ
-	/*
-	 * If we were in the nohz mode recently and busy at the current
-	 * scheduler tick, then check if we need to nominate new idle
-	 * load balancer.
-	 */
-	if (rq->in_nohz_recently && !rq->idle_at_tick) {
-		rq->in_nohz_recently = 0;
-
-		if (atomic_read(&nohz.load_balancer) == cpu) {
-			cpu_clear(cpu, nohz.cpu_mask);
-			atomic_set(&nohz.load_balancer, -1);
-		}
-
-		if (atomic_read(&nohz.load_balancer) == -1) {
-			/*
-			 * simple selection for now: Nominate the
-			 * first cpu in the nohz list to be the next
-			 * ilb owner.
-			 *
-			 * TBD: Traverse the sched domains and nominate
-			 * the nearest cpu in the nohz.cpu_mask.
-			 */
-			int ilb = first_cpu(nohz.cpu_mask);
-
-			if (ilb != NR_CPUS)
-				resched_cpu(ilb);
-		}
-	}
-
-	/*
-	 * If this cpu is idle and doing idle load balancing for all the
-	 * cpus with ticks stopped, is it time for that to stop?
-	 */
-	if (rq->idle_at_tick && atomic_read(&nohz.load_balancer) == cpu &&
-	    cpus_weight(nohz.cpu_mask) == num_online_cpus()) {
-		resched_cpu(cpu);
-		return;
-	}
-
-	/*
-	 * If this cpu is idle and the idle load balancing is done by
-	 * someone else, then no need raise the SCHED_SOFTIRQ
-	 */
-	if (rq->idle_at_tick && atomic_read(&nohz.load_balancer) != cpu &&
-	    cpu_isset(cpu, nohz.cpu_mask))
-		return;
-#endif
-	if (time_after_eq(jiffies, rq->next_balance))
-		raise_softirq(SCHED_SOFTIRQ);
-}
-
-/*
  * This function gets called by the timer code, with HZ frequency.
  * We call it with interrupts disabled.
  *
_

Patches currently in -mm which might be from suresh.b.siddha@intel.com are

sched-fix-idle-load-balancing-in-softirqd-context.patch
sched-dynticks-idle-load-balancing-v3.patch
sched-dynticks-idle-load-balancing-v3-fix.patch
