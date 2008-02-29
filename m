From: akpm@linux-foundation.org
Subject: - rcu-fix-hibernate-resume-in-presence-of-preempt_rcu-and-hotplug.patch removed from -mm tree
Date: Fri, 29 Feb 2008 00:37:51 -0800
Message-ID: <200802290837.m1T8bp47013706@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:49212 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753454AbYB2Iio (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 Feb 2008 03:38:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: paulmck@linux.vnet.ibm.com, ego@in.ibm.com, hidave.darkstar@gmail.com, mm-commits@vger.kernel.org


The patch titled
     rcu: fix hibernate/resume in presence of PREEMPT_RCU and hotplug
has been removed from the -mm tree.  Its filename was
     rcu-fix-hibernate-resume-in-presence-of-preempt_rcu-and-hotplug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rcu: fix hibernate/resume in presence of PREEMPT_RCU and hotplug
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

This fixes a WARN_ON() encountered when doing hibernate/resume in presence of
PREEMPT_RCU.  The problem was that the code failed to disable preemption when
accessing a per-CPU variable.  This is OK when called from code that already
has preemption disabled, but such is not the case from the suspend/resume code
path.

Reported-by: Dave Young <hidave.darkstar@gmail.com>
Tested-by: Dave Young <hidave.darkstar@gmail.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/rcupreempt.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN kernel/rcupreempt.c~rcu-fix-hibernate-resume-in-presence-of-preempt_rcu-and-hotplug kernel/rcupreempt.c
--- a/kernel/rcupreempt.c~rcu-fix-hibernate-resume-in-presence-of-preempt_rcu-and-hotplug
+++ a/kernel/rcupreempt.c
@@ -702,8 +702,9 @@ void rcu_offline_cpu(int cpu)
 	 * fix.
 	 */
 
+	local_irq_save(flags);
 	rdp = RCU_DATA_ME();
-	spin_lock_irqsave(&rdp->lock, flags);
+	spin_lock(&rdp->lock);
 	*rdp->nexttail = list;
 	if (list)
 		rdp->nexttail = tail;
_

Patches currently in -mm which might be from paulmck@linux.vnet.ibm.com are

git-sched.patch
kthread-add-a-missing-memory-barrier-to-kthread_stop.patch
kthread-call-wake_up_process-without-the-lock-being-held.patch
remove-rcu_assign_pointernull-penalty-with-type-macro-safety.patch
add-rcu_assign_index-if-ever-needed.patch
add-rcu_assign_index-if-ever-needed-fix.patch
rcu-split-listh-and-move-rcu-protected-lists-into-rculisth.patch
lock_task_sighand-add-rcu-lock-unlock.patch
k_getrusage-dont-take-rcu_read_lock.patch
do_task_stat-dont-take-rcu_read_lock.patch

