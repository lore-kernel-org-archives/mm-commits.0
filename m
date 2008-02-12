From: akpm@linux-foundation.org
Subject: - softlockup-fix-a-potential-race-condition-in-watchdog-2.patch removed from -mm tree
Date: Mon, 11 Feb 2008 16:39:49 -0800
Message-ID: <200802120048.m1C0mjTh010158@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53128 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751461AbYBLAtc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Feb 2008 19:49:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dmitry.adamushko@gmail.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     softlockup: fix a potential race condition in watchdog()
has been removed from the -mm tree.  Its filename was
     softlockup-fix-a-potential-race-condition-in-watchdog-2.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: softlockup: fix a potential race condition in watchdog()
From: Dmitry Adamushko <dmitry.adamushko@gmail.com>

kthread_stop() can be called when a 'watchdog' thread is executing after
kthread_should_stop() but before set_task_state(TASK_INTERRUPTIBLE).

Signed-off-by: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/softlockup.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff -puN kernel/softlockup.c~softlockup-fix-a-potential-race-condition-in-watchdog-2 kernel/softlockup.c
--- a/kernel/softlockup.c~softlockup-fix-a-potential-race-condition-in-watchdog-2
+++ a/kernel/softlockup.c
@@ -217,26 +217,25 @@ static int watchdog(void *__bind_cpu)
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

origin.patch
softlockup-fix-a-potential-race-condition-in-watchdog-2.patch
