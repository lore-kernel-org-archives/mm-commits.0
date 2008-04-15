From: akpm@linux-foundation.org
Subject: + rcu-add-memory-barriers-and-comments-to-rcu_check_callbacks.patch added to -mm tree
Date: Mon, 14 Apr 2008 18:35:48 -0700
Message-ID: <200804150135.m3F1ZmjT004512@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54017 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758363AbYDOBg7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Apr 2008 21:36:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: paulmck@linux.vnet.ibm.com, jamesclhuang@yahoo.com, josh@kernel.org, mathieu.desnoyers@polymtl.ca, mingo@elte.hu


The patch titled
     rcu: add memory barriers and comments to rcu_check_callbacks()
has been added to the -mm tree.  Its filename is
     rcu-add-memory-barriers-and-comments-to-rcu_check_callbacks.patch

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
Subject: rcu: add memory barriers and comments to rcu_check_callbacks()
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Add comments to the logic that infers quiescent states when interrupting from
either user mode or the idle loop.  Also add a memory barrier: it appears that
James Huang was in fact onto something, as the scheduler is much less
synchronization happy than it once was, so we can no longer rely on its memory
barriers in all cases.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Reported-by: James Huang <jamesclhuang@yahoo.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Josh Triplett <josh@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/rcuclassic.c |   30 +++++++++++++++++++++++++++++-
 1 file changed, 29 insertions(+), 1 deletion(-)

diff -puN kernel/rcuclassic.c~rcu-add-memory-barriers-and-comments-to-rcu_check_callbacks kernel/rcuclassic.c
--- a/kernel/rcuclassic.c~rcu-add-memory-barriers-and-comments-to-rcu_check_callbacks
+++ a/kernel/rcuclassic.c
@@ -502,10 +502,38 @@ void rcu_check_callbacks(int cpu, int us
 	if (user ||
 	    (idle_cpu(cpu) && !in_softirq() &&
 				hardirq_count() <= (1 << HARDIRQ_SHIFT))) {
+
+		/*
+		 * Get here if this CPU took its interrupt from user
+		 * mode or from the idle loop, and if this is not a
+		 * nested interrupt.  In this case, the CPU is in
+		 * a quiescent state, so count it.
+		 *
+		 * Also do a memory barrier.  This is needed to handle
+		 * the case where writes from a preempt-disable section
+		 * of code get reordered into schedule() by this CPU's
+		 * write buffer.  The memory barrier makes sure that
+		 * the rcu_qsctr_inc() and rcu_bh_qsctr_inc() are see
+		 * by other CPUs to happen after any such write.
+		 */
+
+		smp_mb();  /* See above block comment. */
 		rcu_qsctr_inc(cpu);
 		rcu_bh_qsctr_inc(cpu);
-	} else if (!in_softirq())
+
+	} else if (!in_softirq()) {
+
+		/*
+		 * Get here if this CPU did not take its interrupt from
+		 * softirq, in other words, if it is not interrupting
+		 * a rcu_bh read-side critical section.  This is an _bh
+		 * critical section, so count it.  The memory barrier
+		 * is needed for the same reason as is the above one.
+		 */
+
+		smp_mb();  /* See above block comment. */
 		rcu_bh_qsctr_inc(cpu);
+	}
 	raise_rcu_softirq();
 }
 
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

