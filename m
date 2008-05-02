From: akpm@linux-foundation.org
Subject: - rcu-add-memory-barriers-and-comments-to-rcu_check_callbacks.patch removed from -mm tree
Date: Fri, 02 May 2008 15:20:25 -0700
Message-ID: <200805022220.m42MKPQv017838@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46434 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758629AbYEBWVJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 May 2008 18:21:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: paulmck@linux.vnet.ibm.com, jamesclhuang@yahoo.com, josh@kernel.org, mathieu.desnoyers@polymtl.ca, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     rcu: add memory barriers and comments to rcu_check_callbacks()
has been removed from the -mm tree.  Its filename was
     rcu-add-memory-barriers-and-comments-to-rcu_check_callbacks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch
add-rcu_assign_index-if-ever-needed.patch
rcu-fix-rcu_try_flip_waitack_needed-to-prevent-grace-period-stall.patch
add-warn_on_secs-macro.patch
use-warn_on_secs-in-rcupreempth.patch

