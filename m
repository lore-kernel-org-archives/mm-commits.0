From: akpm@linux-foundation.org
Subject: [merged] rcu-increment-quiescent-state-counter-in-ksoftirqd.patch removed from -mm tree
Date: Fri, 06 Mar 2009 11:28:33 -0800
Message-ID: <200903061928.n26JSX57022780@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48244 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754048AbZCFT3I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Mar 2009 14:29:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dada1@cosmosbay.com, mingo@elte.hu, paulmck@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     rcu: increment quiescent state counter in ksoftirqd()
has been removed from the -mm tree.  Its filename was
     rcu-increment-quiescent-state-counter-in-ksoftirqd.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rcu: increment quiescent state counter in ksoftirqd()
From: Eric Dumazet <dada1@cosmosbay.com>

If a machine is flooded by network frames, a cpu can loop 100% of its time
inside ksoftirqd() without calling schedule().  This can delay RCU grace
period to insane values.

Adding rcu_qsctr_inc() call in ksoftirqd() solves this problem.

Paul: "This regression was a result of the recent change from "schedule()"
to "cond_resched()", which got rid of that quiescent state in the common
case where a reschedule is not needed".

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/softirq.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN kernel/softirq.c~rcu-increment-quiescent-state-counter-in-ksoftirqd kernel/softirq.c
--- a/kernel/softirq.c~rcu-increment-quiescent-state-counter-in-ksoftirqd
+++ a/kernel/softirq.c
@@ -648,6 +648,7 @@ static int ksoftirqd(void * __bind_cpu)
 			preempt_enable_no_resched();
 			cond_resched();
 			preempt_disable();
+			rcu_qsctr_inc((long)__bind_cpu);
 		}
 		preempt_enable();
 		set_current_state(TASK_INTERRUPTIBLE);
_

Patches currently in -mm which might be from dada1@cosmosbay.com are

linux-next.patch
softirq-introduce-statistics-for-softirq.patch
proc-export-statistics-for-softirq-to-proc.patch
proc-export-statistics-for-softirq-to-proc-fix.patch
proc-update-document-for-proc-softirqs-and-proc-stat.patch
workqueue-avoid-recursion-in-run_workqueue.patch

