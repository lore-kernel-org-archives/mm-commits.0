From: akpm@osdl.org
Subject: + rcu-softirq-for-rcu.patch added to -mm tree
Date: Tue, 23 Jan 2007 16:38:47 -0800
Message-ID: <200701240038.l0O0cl90003950@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44691 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965454AbXAXAix (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Jan 2007 19:38:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dipankar@in.ibm.com, paulmck@in.ibm.com


The patch titled
     rcu: softirq for RCU
has been added to the -mm tree.  Its filename is
     rcu-softirq-for-rcu.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: rcu: softirq for RCU
From: Dipankar Sarma <dipankar@in.ibm.com>

Finally, RCU gets its own softirq.  With it being used extensively, the
per-cpu tasklet used earlier was just a softirq with overheads.  This makes
things more efficient.

Signed-off-by: Dipankar Sarma <dipankar@in.ibm.com>
Acked-by: Paul E. McKenney <paulmck@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/interrupt.h |    1 +
 kernel/rcuclassic.c       |   12 +++++-------
 2 files changed, 6 insertions(+), 7 deletions(-)

diff -puN include/linux/interrupt.h~rcu-softirq-for-rcu include/linux/interrupt.h
--- a/include/linux/interrupt.h~rcu-softirq-for-rcu
+++ a/include/linux/interrupt.h
@@ -236,6 +236,7 @@ enum
 #ifdef CONFIG_HIGH_RES_TIMERS
 	HRTIMER_SOFTIRQ,
 #endif
+	RCU_SOFTIRQ,
 };
 
 /* softirq mask and active fields moved to irq_cpustat_t in
diff -puN kernel/rcuclassic.c~rcu-softirq-for-rcu kernel/rcuclassic.c
--- a/kernel/rcuclassic.c~rcu-softirq-for-rcu
+++ a/kernel/rcuclassic.c
@@ -69,7 +69,6 @@ DEFINE_PER_CPU(struct rcu_data, rcu_data
 DEFINE_PER_CPU(struct rcu_data, rcu_bh_data) = { 0L };
 
 /* Fake initialization required by compiler */
-static DEFINE_PER_CPU(struct tasklet_struct, rcu_tasklet) = {NULL};
 static int blimit = 10;
 static int qhimark = 10000;
 static int qlowmark = 100;
@@ -215,7 +214,7 @@ static void rcu_do_batch(struct rcu_data
 	if (!rdp->donelist)
 		rdp->donetail = &rdp->donelist;
 	else
-		tasklet_schedule(&per_cpu(rcu_tasklet, rdp->cpu));
+		raise_softirq(RCU_SOFTIRQ);
 }
 
 /*
@@ -367,7 +366,6 @@ static void rcu_offline_cpu(int cpu)
 					&per_cpu(rcu_bh_data, cpu));
 	put_cpu_var(rcu_data);
 	put_cpu_var(rcu_bh_data);
-	tasklet_kill_immediate(&per_cpu(rcu_tasklet, cpu), cpu);
 }
 
 #else
@@ -379,7 +377,7 @@ static void rcu_offline_cpu(int cpu)
 #endif
 
 /*
- * This does the RCU processing work from tasklet context.
+ * This does the RCU processing work from softirq context.
  */
 static void __rcu_process_callbacks(struct rcu_ctrlblk *rcp,
 					struct rcu_data *rdp)
@@ -424,7 +422,7 @@ static void __rcu_process_callbacks(stru
 		rcu_do_batch(rdp);
 }
 
-static void rcu_process_callbacks(unsigned long unused)
+static void rcu_process_callbacks(struct softirq_action *unused)
 {
 	__rcu_process_callbacks(&rcu_ctrlblk, &__get_cpu_var(rcu_data));
 	__rcu_process_callbacks(&rcu_bh_ctrlblk, &__get_cpu_var(rcu_bh_data));
@@ -488,7 +486,7 @@ void rcu_check_callbacks(int cpu, int us
 		rcu_bh_qsctr_inc(cpu);
 	} else if (!in_softirq())
 		rcu_bh_qsctr_inc(cpu);
-	tasklet_schedule(&per_cpu(rcu_tasklet, cpu));
+	raise_softirq(RCU_SOFTIRQ);
 }
 
 static void rcu_init_percpu_data(int cpu, struct rcu_ctrlblk *rcp,
@@ -511,7 +509,7 @@ static void __devinit rcu_online_cpu(int
 
 	rcu_init_percpu_data(cpu, &rcu_ctrlblk, rdp);
 	rcu_init_percpu_data(cpu, &rcu_bh_ctrlblk, bh_rdp);
-	tasklet_init(&per_cpu(rcu_tasklet, cpu), rcu_process_callbacks, 0UL);
+	open_softirq(RCU_SOFTIRQ, rcu_process_callbacks, NULL);
 }
 
 static int __cpuinit rcu_cpu_notify(struct notifier_block *self,
_

Patches currently in -mm which might be from dipankar@in.ibm.com are

rcu-split-classic-rcu.patch
rcu-softirq-for-rcu.patch
rcu-fix-barriers.patch
rcu-preemptible-rcu.patch
rcu-debug-trace-for-rcu.patch
rcu-trivial-fixes.patch
