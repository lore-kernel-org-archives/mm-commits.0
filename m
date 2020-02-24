From: Andrew Morton <akpm@linux-foundation.org>
Subject: [nacked]
 psi-move-pf_memstall-into-psi-specific-psi_flags.patch removed from -mm
 tree
Date: Mon, 24 Feb 2020 13:45:06 -0800
Message-ID: <20200224214506.113INYIxn%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726980AbgBXVpI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 24 Feb 2020 16:45:08 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bsegall@google.com, dietmar.eggemann@arm.com, hannes@cmpxchg.org, juri.lelli@redhat.com, laoar.shao@gmail.com, mgorman@suse.de, mingo@redhat.com, mm-commits@vger.kernel.org, peterz@infradead.org, rostedt@goodmis.org, vincent.guittot@linaro.org


The patch titled
     Subject: psi: move PF_MEMSTALL into psi specific psi_flags
has been removed from the -mm tree.  Its filename was
     psi-move-pf_memstall-into-psi-specific-psi_flags.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Yafang Shao <laoar.shao@gmail.com>
Subject: psi: move PF_MEMSTALL into psi specific psi_flags

The task->flags is a 32-bits flag, in which 31 bits have already been
consumed.  So it is hard to introduce other new per process flags.  As
there's a psi specific flag psi_flags, move the psi specific per process
flag PF_MEMSTALL into it.

Link: http://lkml.kernel.org/r/20200222144647.10120-1-laoar.shao@gmail.com
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ben Segall <bsegall@google.com>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/psi_types.h |   12 +++++++++++-
 include/linux/sched.h     |    7 +++++--
 kernel/sched/psi.c        |   15 ++++++++-------
 kernel/sched/stats.h      |   10 +++++-----
 4 files changed, 29 insertions(+), 15 deletions(-)

--- a/include/linux/psi_types.h~psi-move-pf_memstall-into-psi-specific-psi_flags
+++ a/include/linux/psi_types.h
@@ -17,11 +17,21 @@ enum psi_task_count {
 	NR_PSI_TASK_COUNTS = 3,
 };
 
-/* Task state bitmasks */
+/*
+ * Task state bitmasks:
+ * These flags are stored in the lower PSI_TSK_BITS bits of
+ * task->psi_flags, and the higher bits are set with per process flag which
+ * persists across sleeps.
+ */
+#define PSI_TSK_STATE_BITS 16
+#define PSI_TSK_STATE_MASK ((1 << PSI_TSK_STATE_BITS) - 1)
 #define TSK_IOWAIT	(1 << NR_IOWAIT)
 #define TSK_MEMSTALL	(1 << NR_MEMSTALL)
 #define TSK_RUNNING	(1 << NR_RUNNING)
 
+/* Stalled due to lack of memory, that's per process flag. */
+#define PSI_PF_MEMSTALL (1 << PSI_TSK_STATE_BITS)
+
 /* Resources that workloads could be stalled on */
 enum psi_res {
 	PSI_IO,
--- a/include/linux/sched.h~psi-move-pf_memstall-into-psi-specific-psi_flags
+++ a/include/linux/sched.h
@@ -1023,7 +1023,11 @@ struct task_struct {
 
 	struct task_io_accounting	ioac;
 #ifdef CONFIG_PSI
-	/* Pressure stall state */
+	/*
+	 * Pressure stall state:
+	 * Bits 0 ~ PSI_TSK_STATE_BITS-1: PSI task states
+	 * Bits PSI_TSK_STATE_BITS ~ 31: Per process flags
+	 */
 	unsigned int			psi_flags;
 #endif
 #ifdef CONFIG_TASK_XACCT
@@ -1477,7 +1481,6 @@ extern struct pid *cad_pid;
 #define PF_KTHREAD		0x00200000	/* I am a kernel thread */
 #define PF_RANDOMIZE		0x00400000	/* Randomize virtual address space */
 #define PF_SWAPWRITE		0x00800000	/* Allowed to write to swap */
-#define PF_MEMSTALL		0x01000000	/* Stalled due to lack of memory */
 #define PF_UMH			0x02000000	/* I'm an Usermodehelper process */
 #define PF_NO_SETAFFINITY	0x04000000	/* Userland is not allowed to meddle with cpus_mask */
 #define PF_MCE_EARLY		0x08000000      /* Early kill for mce process policy */
--- a/kernel/sched/psi.c~psi-move-pf_memstall-into-psi-specific-psi_flags
+++ a/kernel/sched/psi.c
@@ -759,7 +759,8 @@ void psi_task_change(struct task_struct
 	    !psi_bug) {
 		printk_deferred(KERN_ERR "psi: inconsistent task state! task=%d:%s cpu=%d psi_flags=%x clear=%x set=%x\n",
 				task->pid, task->comm, cpu,
-				task->psi_flags, clear, set);
+				task->psi_flags & PSI_TSK_STATE_MASK,
+				clear, set);
 		psi_bug = 1;
 	}
 
@@ -818,17 +819,17 @@ void psi_memstall_enter(unsigned long *f
 	if (static_branch_likely(&psi_disabled))
 		return;
 
-	*flags = current->flags & PF_MEMSTALL;
+	*flags = current->psi_flags & PSI_PF_MEMSTALL;
 	if (*flags)
 		return;
 	/*
-	 * PF_MEMSTALL setting & accounting needs to be atomic wrt
+	 * PSI_PF_MEMSTALL setting & accounting needs to be atomic wrt
 	 * changes to the task's scheduling state, otherwise we can
 	 * race with CPU migration.
 	 */
 	rq = this_rq_lock_irq(&rf);
 
-	current->flags |= PF_MEMSTALL;
+	current->psi_flags |= PSI_PF_MEMSTALL;
 	psi_task_change(current, 0, TSK_MEMSTALL);
 
 	rq_unlock_irq(rq, &rf);
@@ -851,13 +852,13 @@ void psi_memstall_leave(unsigned long *f
 	if (*flags)
 		return;
 	/*
-	 * PF_MEMSTALL clearing & accounting needs to be atomic wrt
+	 * PSI_PF_MEMSTALL clearing & accounting needs to be atomic wrt
 	 * changes to the task's scheduling state, otherwise we could
 	 * race with CPU migration.
 	 */
 	rq = this_rq_lock_irq(&rf);
 
-	current->flags &= ~PF_MEMSTALL;
+	current->psi_flags &= ~PSI_PF_MEMSTALL;
 	psi_task_change(current, TSK_MEMSTALL, 0);
 
 	rq_unlock_irq(rq, &rf);
@@ -921,7 +922,7 @@ void cgroup_move_task(struct task_struct
 	else if (task->in_iowait)
 		task_flags = TSK_IOWAIT;
 
-	if (task->flags & PF_MEMSTALL)
+	if (task->psi_flags & PSI_PF_MEMSTALL)
 		task_flags |= TSK_MEMSTALL;
 
 	if (task_flags)
--- a/kernel/sched/stats.h~psi-move-pf_memstall-into-psi-specific-psi_flags
+++ a/kernel/sched/stats.h
@@ -70,7 +70,7 @@ static inline void psi_enqueue(struct ta
 		return;
 
 	if (!wakeup || p->sched_psi_wake_requeue) {
-		if (p->flags & PF_MEMSTALL)
+		if (p->psi_flags & PSI_PF_MEMSTALL)
 			set |= TSK_MEMSTALL;
 		if (p->sched_psi_wake_requeue)
 			p->sched_psi_wake_requeue = 0;
@@ -90,7 +90,7 @@ static inline void psi_dequeue(struct ta
 		return;
 
 	if (!sleep) {
-		if (p->flags & PF_MEMSTALL)
+		if (p->psi_flags & PSI_PF_MEMSTALL)
 			clear |= TSK_MEMSTALL;
 	} else {
 		if (p->in_iowait)
@@ -109,14 +109,14 @@ static inline void psi_ttwu_dequeue(stru
 	 * deregister its sleep-persistent psi states from the old
 	 * queue, and let psi_enqueue() know it has to requeue.
 	 */
-	if (unlikely(p->in_iowait || (p->flags & PF_MEMSTALL))) {
+	if (unlikely(p->in_iowait || (p->psi_flags & PSI_PF_MEMSTALL))) {
 		struct rq_flags rf;
 		struct rq *rq;
 		int clear = 0;
 
 		if (p->in_iowait)
 			clear |= TSK_IOWAIT;
-		if (p->flags & PF_MEMSTALL)
+		if (p->psi_flags & PSI_PF_MEMSTALL)
 			clear |= TSK_MEMSTALL;
 
 		rq = __task_rq_lock(p, &rf);
@@ -131,7 +131,7 @@ static inline void psi_task_tick(struct
 	if (static_branch_likely(&psi_disabled))
 		return;
 
-	if (unlikely(rq->curr->flags & PF_MEMSTALL))
+	if (unlikely(rq->curr->psi_flags & PSI_PF_MEMSTALL))
 		psi_memstall_tick(rq->curr, cpu_of(rq));
 }
 #else /* CONFIG_PSI */
_

Patches currently in -mm which might be from laoar.shao@gmail.com are

mm-memcg-fix-build-error-around-the-usage-of-kmem_caches.patch
