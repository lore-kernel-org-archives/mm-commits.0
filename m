From: akpm@linux-foundation.org
Subject: [merged] change-all-uses-of-jobctl_-from-int-to-long.patch
 removed from -mm tree
Date: Mon, 11 May 2015 10:58:35 -0700
Message-ID: <5550edcb.dI04xxfbAtAyOF8e%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36745 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904AbbEKR6g (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 May 2015 13:58:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: palmer@dabbelt.com, bobby.prani@gmail.com, cmetcalf@ezchip.com, oleg@redhat.com, paulmck@linux.vnet.ibm.com, peterz@infradead.org, richard@nod.at, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/sched.h: change all uses of JOBCTL_* from int to long
has been removed from the -mm tree.  Its filename was
     change-all-uses-of-jobctl_-from-int-to-long.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Palmer Dabbelt <palmer@dabbelt.com>
Subject: include/linux/sched.h: change all uses of JOBCTL_* from int to long

c56fb6564dcd ("Fix a misaligned load inside ptrace_attach()") makes jobctl
an "unsigned long".  It makes sense to have the masks applied to it match
that type.  This is currently just a cosmetic change, but it will prevent
the mask from being unexpectedly truncated if we ever end up with masks
with more bits.

One instance of "signr" is an int, but I left this alone because the mask
ensures that it will never overflow.

Signed-off-by: Palmer Dabbelt <palmer@dabbelt.com>
Reviewed-by: Chris Metcalf <cmetcalf@ezchip.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Pranith Kumar <bobby.prani@gmail.com>
Cc: Vladimir Davydov <vdavydov@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |   18 +++++++++---------
 kernel/signal.c       |    6 +++---
 2 files changed, 12 insertions(+), 12 deletions(-)

diff -puN include/linux/sched.h~change-all-uses-of-jobctl_-from-int-to-long include/linux/sched.h
--- a/include/linux/sched.h~change-all-uses-of-jobctl_-from-int-to-long
+++ a/include/linux/sched.h
@@ -2077,22 +2077,22 @@ TASK_PFA_CLEAR(SPREAD_SLAB, spread_slab)
 #define JOBCTL_TRAPPING_BIT	21	/* switching to TRACED */
 #define JOBCTL_LISTENING_BIT	22	/* ptracer is listening for events */
 
-#define JOBCTL_STOP_DEQUEUED	(1 << JOBCTL_STOP_DEQUEUED_BIT)
-#define JOBCTL_STOP_PENDING	(1 << JOBCTL_STOP_PENDING_BIT)
-#define JOBCTL_STOP_CONSUME	(1 << JOBCTL_STOP_CONSUME_BIT)
-#define JOBCTL_TRAP_STOP	(1 << JOBCTL_TRAP_STOP_BIT)
-#define JOBCTL_TRAP_NOTIFY	(1 << JOBCTL_TRAP_NOTIFY_BIT)
-#define JOBCTL_TRAPPING		(1 << JOBCTL_TRAPPING_BIT)
-#define JOBCTL_LISTENING	(1 << JOBCTL_LISTENING_BIT)
+#define JOBCTL_STOP_DEQUEUED	(1UL << JOBCTL_STOP_DEQUEUED_BIT)
+#define JOBCTL_STOP_PENDING	(1UL << JOBCTL_STOP_PENDING_BIT)
+#define JOBCTL_STOP_CONSUME	(1UL << JOBCTL_STOP_CONSUME_BIT)
+#define JOBCTL_TRAP_STOP	(1UL << JOBCTL_TRAP_STOP_BIT)
+#define JOBCTL_TRAP_NOTIFY	(1UL << JOBCTL_TRAP_NOTIFY_BIT)
+#define JOBCTL_TRAPPING		(1UL << JOBCTL_TRAPPING_BIT)
+#define JOBCTL_LISTENING	(1UL << JOBCTL_LISTENING_BIT)
 
 #define JOBCTL_TRAP_MASK	(JOBCTL_TRAP_STOP | JOBCTL_TRAP_NOTIFY)
 #define JOBCTL_PENDING_MASK	(JOBCTL_STOP_PENDING | JOBCTL_TRAP_MASK)
 
 extern bool task_set_jobctl_pending(struct task_struct *task,
-				    unsigned int mask);
+				    unsigned long mask);
 extern void task_clear_jobctl_trapping(struct task_struct *task);
 extern void task_clear_jobctl_pending(struct task_struct *task,
-				      unsigned int mask);
+				      unsigned long mask);
 
 static inline void rcu_copy_process(struct task_struct *p)
 {
diff -puN kernel/signal.c~change-all-uses-of-jobctl_-from-int-to-long kernel/signal.c
--- a/kernel/signal.c~change-all-uses-of-jobctl_-from-int-to-long
+++ a/kernel/signal.c
@@ -245,7 +245,7 @@ static inline void print_dropped_signal(
  * RETURNS:
  * %true if @mask is set, %false if made noop because @task was dying.
  */
-bool task_set_jobctl_pending(struct task_struct *task, unsigned int mask)
+bool task_set_jobctl_pending(struct task_struct *task, unsigned long mask)
 {
 	BUG_ON(mask & ~(JOBCTL_PENDING_MASK | JOBCTL_STOP_CONSUME |
 			JOBCTL_STOP_SIGMASK | JOBCTL_TRAPPING));
@@ -297,7 +297,7 @@ void task_clear_jobctl_trapping(struct t
  * CONTEXT:
  * Must be called with @task->sighand->siglock held.
  */
-void task_clear_jobctl_pending(struct task_struct *task, unsigned int mask)
+void task_clear_jobctl_pending(struct task_struct *task, unsigned long mask)
 {
 	BUG_ON(mask & ~JOBCTL_PENDING_MASK);
 
@@ -1995,7 +1995,7 @@ static bool do_signal_stop(int signr)
 	struct signal_struct *sig = current->signal;
 
 	if (!(current->jobctl & JOBCTL_STOP_PENDING)) {
-		unsigned int gstop = JOBCTL_STOP_PENDING | JOBCTL_STOP_CONSUME;
+		unsigned long gstop = JOBCTL_STOP_PENDING | JOBCTL_STOP_CONSUME;
 		struct task_struct *t;
 
 		/* signr will be recorded in task->jobctl for retries */
_

Patches currently in -mm which might be from palmer@dabbelt.com are

linux-next.patch

