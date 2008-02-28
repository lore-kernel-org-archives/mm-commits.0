From: akpm@linux-foundation.org
Subject: + rcu-fix-hibernate-resume-in-presence-of-preempt_rcu-and-hotplug.patch added to -mm tree
Date: Wed, 27 Feb 2008 16:39:25 -0800
Message-ID: <200802280039.m1S0dP8n007209@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:51279 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753348AbYB1Aje (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Feb 2008 19:39:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: paulmck@linux.vnet.ibm.com, hidave.darkstar@gmail.com


The patch titled
     rcu: fix hibernate/resume in presence of PREEMPT_RCU and hotplug
has been added to the -mm tree.  Its filename is
     rcu-fix-hibernate-resume-in-presence-of-preempt_rcu-and-hotplug.patch

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

rcu-fix-hibernate-resume-in-presence-of-preempt_rcu-and-hotplug.patch
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
