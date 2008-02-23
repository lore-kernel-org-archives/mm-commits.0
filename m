From: akpm@linux-foundation.org
Subject: - kthread-synchronization-issues.patch removed from -mm tree
Date: Sat, 23 Feb 2008 12:24:07 -0800
Message-ID: <200802232024.m1NKO7id013611@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:54536 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761676AbYBWU33 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 15:29:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dmitry.adamushko@gmail.com, a.p.zijlstra@chello.nl, apw@shadowen.org, mingo@elte.hu, nickpiggin@yahoo.com.au, oleg@tv-sign.ru, paulmck@linux.vnet.ibm.com, rusty@rustcorp.com.au, mm-co


The patch titled
     softlockup: fix task state setting
has been removed from the -mm tree.  Its filename was
     kthread-synchronization-issues.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: softlockup: fix task state setting
From: Dmitry Adamushko <dmitry.adamushko@gmail.com>

kthread_stop() can be called when a 'watchdog' thread is executing after
kthread_should_stop() but before set_task_state(TASK_INTERRUPTIBLE).

Signed-off-by: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andy Whitcroft <apw@shadowen.org>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/softlockup.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff -puN kernel/softlockup.c~kthread-synchronization-issues kernel/softlockup.c
--- a/kernel/softlockup.c~kthread-synchronization-issues
+++ a/kernel/softlockup.c
@@ -216,26 +216,25 @@ static int watchdog(void *__bind_cpu)
 	/* initialize timestamp */
 	touch_softlockup_watchdog();
 
+	set_current_state(TASK_INTERRUPTIBLE);
 	/*
 	 * Run briefly once per second to reset the softlockup timestamp.
 	 * If this gets delayed for more than 60 seconds then the
 	 * debug-printout triggers in softlockup_tick().
 	 */
 	while (!kthread_should_stop()) {
-		set_current_state(TASK_INTERRUPTIBLE);
 		touch_softlockup_watchdog();
 		schedule();
 
 		if (kthread_should_stop())
 			break;
 
-		if (this_cpu != check_cpu)
-			continue;
-
-		if (sysctl_hung_task_timeout_secs)
+		if (this_cpu == check_cpu && sysctl_hung_task_timeout_secs)
 			check_hung_uninterruptible_tasks(this_cpu);
 
+		set_current_state(TASK_INTERRUPTIBLE);
 	}
+	__set_current_state(TASK_RUNNING);
 
 	return 0;
 }
_

Patches currently in -mm which might be from dmitry.adamushko@gmail.com are

git-sched.patch
kthread-add-a-missing-memory-barrier-to-kthread_stop.patch
kthread-call-wake_up_process-without-the-lock-being-held.patch
