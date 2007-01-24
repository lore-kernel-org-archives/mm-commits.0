From: akpm@osdl.org
Subject: + rcu-fix-barriers.patch added to -mm tree
Date: Tue, 23 Jan 2007 16:38:49 -0800
Message-ID: <200701240038.l0O0cnGZ003953@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44693 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965458AbXAXAiy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Jan 2007 19:38:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dipankar@in.ibm.com, paulmck@in.ibm.com


The patch titled
     rcu: Fix barriers
has been added to the -mm tree.  Its filename is
     rcu-fix-barriers.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: rcu: Fix barriers
From: Dipankar Sarma <dipankar@in.ibm.com>

Fix rcu_barrier() to work properly in preemptive kernel environment.  Also,
the ordering of callback must be preserved while moving callbacks to another
CPU during CPU hotplug.

Signed-off-by: Dipankar Sarma <dipankar@in.ibm.com>
Acked-by: Paul E. McKenney <paulmck@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/rcuclassic.c |    2 +-
 kernel/rcupdate.c   |   11 +++++++++++
 2 files changed, 12 insertions(+), 1 deletion(-)

diff -puN kernel/rcuclassic.c~rcu-fix-barriers kernel/rcuclassic.c
--- a/kernel/rcuclassic.c~rcu-fix-barriers
+++ a/kernel/rcuclassic.c
@@ -350,9 +350,9 @@ static void __rcu_offline_cpu(struct rcu
 	if (rcp->cur != rcp->completed)
 		cpu_quiet(rdp->cpu, rcp);
 	spin_unlock_bh(&rcp->lock);
+	rcu_move_batch(this_rdp, rdp->donelist, rdp->donetail);
 	rcu_move_batch(this_rdp, rdp->curlist, rdp->curtail);
 	rcu_move_batch(this_rdp, rdp->nxtlist, rdp->nxttail);
-	rcu_move_batch(this_rdp, rdp->donelist, rdp->donetail);
 }
 
 static void rcu_offline_cpu(int cpu)
diff -puN kernel/rcupdate.c~rcu-fix-barriers kernel/rcupdate.c
--- a/kernel/rcupdate.c~rcu-fix-barriers
+++ a/kernel/rcupdate.c
@@ -117,7 +117,18 @@ void rcu_barrier(void)
 	mutex_lock(&rcu_barrier_mutex);
 	init_completion(&rcu_barrier_completion);
 	atomic_set(&rcu_barrier_cpu_count, 0);
+	/*
+	 * The queueing of callbacks in all CPUs must be
+	 * atomic with respect to RCU, otherwise one cpu may
+	 * queue a callback, wait for a grace period, decrement
+	 * barrier count and call complete(), while other CPUs
+	 * haven't yet queued anything. So, we need to make sure
+	 * that no grace period happens until all the callbacks
+	 * are queued.
+	 */
+	rcu_read_lock();
 	on_each_cpu(rcu_barrier_func, NULL, 0, 1);
+	rcu_read_unlock();
 	wait_for_completion(&rcu_barrier_completion);
 	mutex_unlock(&rcu_barrier_mutex);
 }
_

Patches currently in -mm which might be from dipankar@in.ibm.com are

rcu-split-classic-rcu.patch
rcu-softirq-for-rcu.patch
rcu-fix-barriers.patch
rcu-preemptible-rcu.patch
rcu-debug-trace-for-rcu.patch
rcu-trivial-fixes.patch
