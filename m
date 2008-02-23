From: akpm@linux-foundation.org
Subject: + kthread-synchronization-issues.patch added to -mm tree
Date: Fri, 22 Feb 2008 23:32:57 -0800
Message-ID: <200802230733.m1N7Xktp018250@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:52334 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762793AbYBWIFM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 03:05:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dmitry.adamushko@gmail.com, a.p.zijlstra@chello.nl, apw@shadowen.org, mingo@elte.hu, nickpiggin@yahoo.com.au, oleg@tv-sign.ru, paulmck@linux.vnet.ibm.com, rusty@rustcorp.com.au


The patch titled
     softlockup: fix task state setting
has been added to the -mm tree.  Its filename is
     kthread-synchronization-issues.patch

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

kthread-synchronization-issues.patch
kthread-add-a-missing-memory-barrier-to-kthread_stop.patch
kthread-call-wake_up_process-without-the-lock-being-held.patch
