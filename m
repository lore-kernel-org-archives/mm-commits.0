From: akpm@linux-foundation.org
Subject: - rcu-add-call_rcu_sched-and-friends-to-rcutorture.patch removed from -mm tree
Date: Fri, 02 May 2008 15:20:27 -0700
Message-ID: <200805022220.m42MKRld017841@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54010 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757175AbYEBW0P (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 May 2008 18:26:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: paulmck@linux.vnet.ibm.com, josh@kernel.org, mathieu.desnoyers@polymtl.ca, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     rcu: add call_rcu_sched() and friends to rcutorture
has been removed from the -mm tree.  Its filename was
     rcu-add-call_rcu_sched-and-friends-to-rcutorture.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rcu: add call_rcu_sched() and friends to rcutorture
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Add entry to rcu_torture_ops allowing the correct barrier function to be used
upon exit from rcutorture.  Also add torture options for the new
call_rcu_sched() API.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Josh Triplett <josh@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/rcutorture.c |   34 +++++++++++++++++++++++++++++++---
 1 file changed, 31 insertions(+), 3 deletions(-)

diff -puN kernel/rcutorture.c~rcu-add-call_rcu_sched-and-friends-to-rcutorture kernel/rcutorture.c
--- a/kernel/rcutorture.c~rcu-add-call_rcu_sched-and-friends-to-rcutorture
+++ a/kernel/rcutorture.c
@@ -192,6 +192,7 @@ struct rcu_torture_ops {
 	int (*completed)(void);
 	void (*deferredfree)(struct rcu_torture *p);
 	void (*sync)(void);
+	void (*cb_barrier)(void);
 	int (*stats)(char *page);
 	char *name;
 };
@@ -265,6 +266,7 @@ static struct rcu_torture_ops rcu_ops = 
 	.completed = rcu_torture_completed,
 	.deferredfree = rcu_torture_deferred_free,
 	.sync = synchronize_rcu,
+	.cb_barrier = rcu_barrier,
 	.stats = NULL,
 	.name = "rcu"
 };
@@ -304,6 +306,7 @@ static struct rcu_torture_ops rcu_sync_o
 	.completed = rcu_torture_completed,
 	.deferredfree = rcu_sync_torture_deferred_free,
 	.sync = synchronize_rcu,
+	.cb_barrier = NULL,
 	.stats = NULL,
 	.name = "rcu_sync"
 };
@@ -364,6 +367,7 @@ static struct rcu_torture_ops rcu_bh_ops
 	.completed = rcu_bh_torture_completed,
 	.deferredfree = rcu_bh_torture_deferred_free,
 	.sync = rcu_bh_torture_synchronize,
+	.cb_barrier = rcu_barrier_bh,
 	.stats = NULL,
 	.name = "rcu_bh"
 };
@@ -377,6 +381,7 @@ static struct rcu_torture_ops rcu_bh_syn
 	.completed = rcu_bh_torture_completed,
 	.deferredfree = rcu_sync_torture_deferred_free,
 	.sync = rcu_bh_torture_synchronize,
+	.cb_barrier = NULL,
 	.stats = NULL,
 	.name = "rcu_bh_sync"
 };
@@ -458,6 +463,7 @@ static struct rcu_torture_ops srcu_ops =
 	.completed = srcu_torture_completed,
 	.deferredfree = rcu_sync_torture_deferred_free,
 	.sync = srcu_torture_synchronize,
+	.cb_barrier = NULL,
 	.stats = srcu_torture_stats,
 	.name = "srcu"
 };
@@ -482,6 +488,11 @@ static int sched_torture_completed(void)
 	return 0;
 }
 
+static void rcu_sched_torture_deferred_free(struct rcu_torture *p)
+{
+	call_rcu_sched(&p->rtort_rcu, rcu_torture_cb);
+}
+
 static void sched_torture_synchronize(void)
 {
 	synchronize_sched();
@@ -494,12 +505,27 @@ static struct rcu_torture_ops sched_ops 
 	.readdelay = rcu_read_delay,  /* just reuse rcu's version. */
 	.readunlock = sched_torture_read_unlock,
 	.completed = sched_torture_completed,
-	.deferredfree = rcu_sync_torture_deferred_free,
+	.deferredfree = rcu_sched_torture_deferred_free,
 	.sync = sched_torture_synchronize,
+	.cb_barrier = rcu_barrier_sched,
 	.stats = NULL,
 	.name = "sched"
 };
 
+static struct rcu_torture_ops sched_ops_sync = {
+	.init = rcu_sync_torture_init,
+	.cleanup = NULL,
+	.readlock = sched_torture_read_lock,
+	.readdelay = rcu_read_delay,  /* just reuse rcu's version. */
+	.readunlock = sched_torture_read_unlock,
+	.completed = sched_torture_completed,
+	.deferredfree = rcu_sync_torture_deferred_free,
+	.sync = sched_torture_synchronize,
+	.cb_barrier = NULL,
+	.stats = NULL,
+	.name = "sched_sync"
+};
+
 /*
  * RCU torture writer kthread.  Repeatedly substitutes a new structure
  * for that pointed to by rcu_torture_current, freeing the old structure
@@ -848,7 +874,9 @@ rcu_torture_cleanup(void)
 	stats_task = NULL;
 
 	/* Wait for all RCU callbacks to fire.  */
-	rcu_barrier();
+
+	if (cur_ops->cb_barrier != NULL)
+		cur_ops->cb_barrier();
 
 	rcu_torture_stats_print();  /* -After- the stats thread is stopped! */
 
@@ -868,7 +896,7 @@ rcu_torture_init(void)
 	int firsterr = 0;
 	static struct rcu_torture_ops *torture_ops[] =
 		{ &rcu_ops, &rcu_sync_ops, &rcu_bh_ops, &rcu_bh_sync_ops,
-		  &srcu_ops, &sched_ops, };
+		  &srcu_ops, &sched_ops, &sched_ops_sync, };
 
 	/* Process args and tell the world that the torturer is on the job. */
 	for (i = 0; i < ARRAY_SIZE(torture_ops); i++) {
_

Patches currently in -mm which might be from paulmck@linux.vnet.ibm.com are

origin.patch
linux-next.patch
add-rcu_assign_index-if-ever-needed.patch
rcu-fix-rcu_try_flip_waitack_needed-to-prevent-grace-period-stall.patch
add-warn_on_secs-macro.patch
use-warn_on_secs-in-rcupreempth.patch

