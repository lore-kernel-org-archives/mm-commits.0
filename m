From: akpm@linux-foundation.org
Subject: + rcu-add-rcu_barrier_sched-and-rcu_barrier_bh.patch added to -mm tree
Date: Mon, 14 Apr 2008 18:35:50 -0700
Message-ID: <200804150135.m3F1Zovr004515@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39442 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758303AbYDOBgz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Apr 2008 21:36:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: paulmck@linux.vnet.ibm.com, josh@kernel.org, mathieu.desnoyers@polymtl.ca, mingo@elte.hu


The patch titled
     rcu: add rcu_barrier_sched() and rcu_barrier_bh()
has been added to the -mm tree.  Its filename is
     rcu-add-rcu_barrier_sched-and-rcu_barrier_bh.patch

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
Subject: rcu: add rcu_barrier_sched() and rcu_barrier_bh()
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Add rcu_barrier_sched() and rcu_barrier_bh().  With these in place, rcutorture
no longer gives the occasional oops when repeatedly starting and stopping
torturing rcu_bh.  Also adds the API needed to flush out pre-existing
call_rcu_sched() callbacks.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Josh Triplett <josh@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rcupdate.h |    2 +
 kernel/rcupdate.c        |   55 ++++++++++++++++++++++++++++++++-----
 2 files changed, 51 insertions(+), 6 deletions(-)

diff -puN include/linux/rcupdate.h~rcu-add-rcu_barrier_sched-and-rcu_barrier_bh include/linux/rcupdate.h
--- a/include/linux/rcupdate.h~rcu-add-rcu_barrier_sched-and-rcu_barrier_bh
+++ a/include/linux/rcupdate.h
@@ -278,6 +278,8 @@ extern void call_rcu_bh(struct rcu_head 
 /* Exported common interfaces */
 extern void synchronize_rcu(void);
 extern void rcu_barrier(void);
+extern void rcu_barrier_bh(void);
+extern void rcu_barrier_sched(void);
 
 /* Internal to kernel */
 extern void rcu_init(void);
diff -puN kernel/rcupdate.c~rcu-add-rcu_barrier_sched-and-rcu_barrier_bh kernel/rcupdate.c
--- a/kernel/rcupdate.c~rcu-add-rcu_barrier_sched-and-rcu_barrier_bh
+++ a/kernel/rcupdate.c
@@ -45,6 +45,12 @@
 #include <linux/mutex.h>
 #include <linux/module.h>
 
+enum rcu_barrier {
+	RCU_BARRIER_STD,
+	RCU_BARRIER_BH,
+	RCU_BARRIER_SCHED,
+};
+
 static DEFINE_PER_CPU(struct rcu_head, rcu_barrier_head) = {NULL};
 static atomic_t rcu_barrier_cpu_count;
 static DEFINE_MUTEX(rcu_barrier_mutex);
@@ -83,19 +89,30 @@ static void rcu_barrier_callback(struct 
 /*
  * Called with preemption disabled, and from cross-cpu IRQ context.
  */
-static void rcu_barrier_func(void *notused)
+static void rcu_barrier_func(void *type)
 {
 	int cpu = smp_processor_id();
 	struct rcu_head *head = &per_cpu(rcu_barrier_head, cpu);
 
 	atomic_inc(&rcu_barrier_cpu_count);
-	call_rcu(head, rcu_barrier_callback);
+	switch ((enum rcu_barrier)type) {
+	case RCU_BARRIER_STD:
+		call_rcu(head, rcu_barrier_callback);
+		break;
+	case RCU_BARRIER_BH:
+		call_rcu_bh(head, rcu_barrier_callback);
+		break;
+	case RCU_BARRIER_SCHED:
+		call_rcu_sched(head, rcu_barrier_callback);
+		break;
+	}
 }
 
-/**
- * rcu_barrier - Wait until all the in-flight RCUs are complete.
+/*
+ * Orchestrate the specified type of RCU barrier, waiting for all
+ * RCU callbacks of the specified type to complete.
  */
-void rcu_barrier(void)
+static void _rcu_barrier(enum rcu_barrier type)
 {
 	BUG_ON(in_interrupt());
 	/* Take cpucontrol mutex to protect against CPU hotplug */
@@ -111,13 +128,39 @@ void rcu_barrier(void)
 	 * until all the callbacks are queued.
 	 */
 	rcu_read_lock();
-	on_each_cpu(rcu_barrier_func, NULL, 0, 1);
+	on_each_cpu(rcu_barrier_func, (void *)type, 0, 1);
 	rcu_read_unlock();
 	wait_for_completion(&rcu_barrier_completion);
 	mutex_unlock(&rcu_barrier_mutex);
 }
+
+/**
+ * rcu_barrier - Wait until all in-flight call_rcu() callbacks complete.
+ */
+void rcu_barrier(void)
+{
+	_rcu_barrier(RCU_BARRIER_STD);
+}
 EXPORT_SYMBOL_GPL(rcu_barrier);
 
+/**
+ * rcu_barrier_bh - Wait until all in-flight call_rcu_bh() callbacks complete.
+ */
+void rcu_barrier_bh(void)
+{
+	_rcu_barrier(RCU_BARRIER_BH);
+}
+EXPORT_SYMBOL_GPL(rcu_barrier_bh);
+
+/**
+ * rcu_barrier_sched - Wait for in-flight call_rcu_sched() callbacks.
+ */
+void rcu_barrier_sched(void)
+{
+	_rcu_barrier(RCU_BARRIER_SCHED);
+}
+EXPORT_SYMBOL_GPL(rcu_barrier_sched);
+
 void __init rcu_init(void)
 {
 	__rcu_init();
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

