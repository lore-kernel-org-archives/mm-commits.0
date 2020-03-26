From: akpm@linux-foundation.org
Subject: [merged] psi-move-pf_memstall-out-of-task-flags.patch
 removed from -mm tree
Date: Thu, 26 Mar 2020 11:16:22 -0700
Message-ID: <20200326181622.XTACDRyZb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:60134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727719AbgCZSQX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 26 Mar 2020 14:16:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, laoar.shao@gmail.com, mm-commits@vger.kernel.org, willy@infradead.org


The patch titled
     Subject: psi: move PF_MEMSTALL out of task->flags
has been removed from the -mm tree.  Its filename was
     psi-move-pf_memstall-out-of-task-flags.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yafang Shao <laoar.shao@gmail.com>
Subject: psi: move PF_MEMSTALL out of task->flags

The task->flags is a 32-bits flag, in which 31 bits have already been
consumed.  So it is hard to introduce other new per process flag. 
Currently there're still enough spaces in the bit-field section of
task_struct, so we can define the memstall state as a single bit in
task_struct instead.

This patch also removes an out-of-date comment pointed out by Matthew.

Link: http://lkml.kernel.org/r/1584408485-1921-1-git-send-email-laoar.shao@gmail.com
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    6 ++++--
 kernel/sched/psi.c    |   12 ++++++------
 kernel/sched/stats.h  |   10 +++++-----
 3 files changed, 15 insertions(+), 13 deletions(-)

--- a/include/linux/sched.h~psi-move-pf_memstall-out-of-task-flags
+++ a/include/linux/sched.h
@@ -794,9 +794,12 @@ struct task_struct {
 	unsigned			frozen:1;
 #endif
 #ifdef CONFIG_BLK_CGROUP
-	/* to be used once the psi infrastructure lands upstream. */
 	unsigned			use_memdelay:1;
 #endif
+#ifdef CONFIG_PSI
+	/* Stalled due to lack of memory */
+	unsigned			in_memstall:1;
+#endif
 
 	unsigned long			atomic_flags; /* Flags requiring atomic access. */
 
@@ -1503,7 +1506,6 @@ extern struct pid *cad_pid;
 #define PF_KTHREAD		0x00200000	/* I am a kernel thread */
 #define PF_RANDOMIZE		0x00400000	/* Randomize virtual address space */
 #define PF_SWAPWRITE		0x00800000	/* Allowed to write to swap */
-#define PF_MEMSTALL		0x01000000	/* Stalled due to lack of memory */
 #define PF_UMH			0x02000000	/* I'm an Usermodehelper process */
 #define PF_NO_SETAFFINITY	0x04000000	/* Userland is not allowed to meddle with cpus_mask */
 #define PF_MCE_EARLY		0x08000000      /* Early kill for mce process policy */
--- a/kernel/sched/psi.c~psi-move-pf_memstall-out-of-task-flags
+++ a/kernel/sched/psi.c
@@ -818,17 +818,17 @@ void psi_memstall_enter(unsigned long *f
 	if (static_branch_likely(&psi_disabled))
 		return;
 
-	*flags = current->flags & PF_MEMSTALL;
+	*flags = current->in_memstall;
 	if (*flags)
 		return;
 	/*
-	 * PF_MEMSTALL setting & accounting needs to be atomic wrt
+	 * in_memstall setting & accounting needs to be atomic wrt
 	 * changes to the task's scheduling state, otherwise we can
 	 * race with CPU migration.
 	 */
 	rq = this_rq_lock_irq(&rf);
 
-	current->flags |= PF_MEMSTALL;
+	current->in_memstall = 1;
 	psi_task_change(current, 0, TSK_MEMSTALL);
 
 	rq_unlock_irq(rq, &rf);
@@ -851,13 +851,13 @@ void psi_memstall_leave(unsigned long *f
 	if (*flags)
 		return;
 	/*
-	 * PF_MEMSTALL clearing & accounting needs to be atomic wrt
+	 * in_memstall clearing & accounting needs to be atomic wrt
 	 * changes to the task's scheduling state, otherwise we could
 	 * race with CPU migration.
 	 */
 	rq = this_rq_lock_irq(&rf);
 
-	current->flags &= ~PF_MEMSTALL;
+	current->in_memstall = 0;
 	psi_task_change(current, TSK_MEMSTALL, 0);
 
 	rq_unlock_irq(rq, &rf);
@@ -921,7 +921,7 @@ void cgroup_move_task(struct task_struct
 	else if (task->in_iowait)
 		task_flags = TSK_IOWAIT;
 
-	if (task->flags & PF_MEMSTALL)
+	if (task->in_memstall)
 		task_flags |= TSK_MEMSTALL;
 
 	if (task_flags)
--- a/kernel/sched/stats.h~psi-move-pf_memstall-out-of-task-flags
+++ a/kernel/sched/stats.h
@@ -70,7 +70,7 @@ static inline void psi_enqueue(struct ta
 		return;
 
 	if (!wakeup || p->sched_psi_wake_requeue) {
-		if (p->flags & PF_MEMSTALL)
+		if (p->in_memstall)
 			set |= TSK_MEMSTALL;
 		if (p->sched_psi_wake_requeue)
 			p->sched_psi_wake_requeue = 0;
@@ -90,7 +90,7 @@ static inline void psi_dequeue(struct ta
 		return;
 
 	if (!sleep) {
-		if (p->flags & PF_MEMSTALL)
+		if (p->in_memstall)
 			clear |= TSK_MEMSTALL;
 	} else {
 		if (p->in_iowait)
@@ -109,14 +109,14 @@ static inline void psi_ttwu_dequeue(stru
 	 * deregister its sleep-persistent psi states from the old
 	 * queue, and let psi_enqueue() know it has to requeue.
 	 */
-	if (unlikely(p->in_iowait || (p->flags & PF_MEMSTALL))) {
+	if (unlikely(p->in_iowait || p->in_memstall)) {
 		struct rq_flags rf;
 		struct rq *rq;
 		int clear = 0;
 
 		if (p->in_iowait)
 			clear |= TSK_IOWAIT;
-		if (p->flags & PF_MEMSTALL)
+		if (p->in_memstall)
 			clear |= TSK_MEMSTALL;
 
 		rq = __task_rq_lock(p, &rf);
@@ -131,7 +131,7 @@ static inline void psi_task_tick(struct
 	if (static_branch_likely(&psi_disabled))
 		return;
 
-	if (unlikely(rq->curr->flags & PF_MEMSTALL))
+	if (unlikely(rq->curr->in_memstall))
 		psi_memstall_tick(rq->curr, cpu_of(rq));
 }
 #else /* CONFIG_PSI */
_

Patches currently in -mm which might be from laoar.shao@gmail.com are

mm-memcg-fix-build-error-around-the-usage-of-kmem_caches.patch
