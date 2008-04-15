From: akpm@linux-foundation.org
Subject: + rcu-add-call_rcu_sched-and-friends-to-rcutorture.patch added to -mm tree
Date: Mon, 14 Apr 2008 18:35:52 -0700
Message-ID: <200804150135.m3F1ZqL7004518@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36229 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758617AbYDOBhB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Apr 2008 21:37:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: paulmck@linux.vnet.ibm.com, josh@kernel.org, mathieu.desnoyers@polymtl.ca, mingo@elte.hu


The patch titled
     rcu: add call_rcu_sched() and friends to rcutorture
has been added to the -mm tree.  Its filename is
     rcu-add-call_rcu_sched-and-friends-to-rcutorture.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -191,6 +191,7 @@ struct rcu_torture_ops {
 	int (*completed)(void);
 	void (*deferredfree)(struct rcu_torture *p);
 	void (*sync)(void);
+	void (*cb_barrier)(void);
 	int (*stats)(char *page);
 	char *name;
 };
@@ -264,6 +265,7 @@ static struct rcu_torture_ops rcu_ops = 
 	.completed = rcu_torture_completed,
 	.deferredfree = rcu_torture_deferred_free,
 	.sync = synchronize_rcu,
+	.cb_barrier = rcu_barrier,
 	.stats = NULL,
 	.name = "rcu"
 };
@@ -303,6 +305,7 @@ static struct rcu_torture_ops rcu_sync_o
 	.completed = rcu_torture_completed,
 	.deferredfree = rcu_sync_torture_deferred_free,
 	.sync = synchronize_rcu,
+	.cb_barrier = NULL,
 	.stats = NULL,
 	.name = "rcu_sync"
 };
@@ -363,6 +366,7 @@ static struct rcu_torture_ops rcu_bh_ops
 	.completed = rcu_bh_torture_completed,
 	.deferredfree = rcu_bh_torture_deferred_free,
 	.sync = rcu_bh_torture_synchronize,
+	.cb_barrier = rcu_barrier_bh,
 	.stats = NULL,
 	.name = "rcu_bh"
 };
@@ -376,6 +380,7 @@ static struct rcu_torture_ops rcu_bh_syn
 	.completed = rcu_bh_torture_completed,
 	.deferredfree = rcu_sync_torture_deferred_free,
 	.sync = rcu_bh_torture_synchronize,
+	.cb_barrier = NULL,
 	.stats = NULL,
 	.name = "rcu_bh_sync"
 };
@@ -457,6 +462,7 @@ static struct rcu_torture_ops srcu_ops =
 	.completed = srcu_torture_completed,
 	.deferredfree = rcu_sync_torture_deferred_free,
 	.sync = srcu_torture_synchronize,
+	.cb_barrier = NULL,
 	.stats = srcu_torture_stats,
 	.name = "srcu"
 };
@@ -481,6 +487,11 @@ static int sched_torture_completed(void)
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
@@ -493,12 +504,27 @@ static struct rcu_torture_ops sched_ops 
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
@@ -844,7 +870,9 @@ rcu_torture_cleanup(void)
 	stats_task = NULL;
 
 	/* Wait for all RCU callbacks to fire.  */
-	rcu_barrier();
+
+	if (cur_ops->cb_barrier != NULL)
+		cur_ops->cb_barrier();
 
 	rcu_torture_stats_print();  /* -After- the stats thread is stopped! */
 
@@ -864,7 +892,7 @@ rcu_torture_init(void)
 	int firsterr = 0;
 	static struct rcu_torture_ops *torture_ops[] =
 		{ &rcu_ops, &rcu_sync_ops, &rcu_bh_ops, &rcu_bh_sync_ops,
-		  &srcu_ops, &sched_ops, };
+		  &srcu_ops, &sched_ops, &sched_ops_sync, };
 
 	/* Process args and tell the world that the torturer is on the job. */
 	for (i = 0; i < ARRAY_SIZE(torture_ops); i++) {
_

Patches currently in -mm which might be from paulmck@linux.vnet.ibm.com are

add-rcu_assign_index-if-ever-needed.patch
rcu-split-listh-and-move-rcu-protected-lists-into-rculisth.patch
rcu-fix-rcu_try_flip_waitack_needed-to-prevent-grace-period-stall.patch
rcu-add-call_rcu_sched.patch
rcu-add-memory-barriers-and-comments-to-rcu_check_callbacks.patch
rcu-add-rcu_barrier_sched-and-rcu_barrier_bh.patch
rcu-add-call_rcu_sched-and-friends-to-rcutorture.patch
rcu-1q08-rcu-doc-update-add-call_rcu_sched.patch
kthread-call-wake_up_process-without-the-lock-being-held.patch
isolate-ratelimit-from-printkc-for-other-use.patch
add-warn_on_secs-macro.patch
add-warn_on_secs-macro-simplification.patch
add-warn_on_secs-macro-simplification-fix.patch
add-warn_on_secs-macro-simplification-fix-fix.patch
use-warn_on_secs-in-rcupreempth.patch
lock_task_sighand-add-rcu-lock-unlock.patch
k_getrusage-dont-take-rcu_read_lock.patch
do_task_stat-dont-take-rcu_read_lock.patch

