From: akpm@linux-foundation.org
Subject: + softlockup-fix-a-potential-race-condition-in-watchdog.patch added to -mm tree
Date: Mon, 11 Feb 2008 15:49:29 -0800
Message-ID: <200802112349.m1BNnT9o008017@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47469 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755146AbYBKXuB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Feb 2008 18:50:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dmitry.adamushko@gmail.com, mingo@elte.hu


The patch titled
     softlockup: fix a potential race condition in watchdog()
has been added to the -mm tree.  Its filename is
     softlockup-fix-a-potential-race-condition-in-watchdog.patch

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
Subject: softlockup: fix a potential race condition in watchdog()
From: Dmitry Adamushko <dmitry.adamushko@gmail.com>

kthread_stop() can be called when a 'watchdog' thread is executing after
kthread_should_stop() but before set_task_state(TASK_INTERRUPTIBLE).

Signed-off-by: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/softlockup.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff -puN kernel/softlockup.c~softlockup-fix-a-potential-race-condition-in-watchdog kernel/softlockup.c
--- a/kernel/softlockup.c~softlockup-fix-a-potential-race-condition-in-watchdog
+++ a/kernel/softlockup.c
@@ -98,6 +98,7 @@ void softlockup_tick(void)
 		touch_softlockup_watchdog();
 		return;
 	}
+	printk(KERN_ERR "watchdog(cpu: %d) -- exit\n", this_cpu);
 
 	now = get_timestamp(this_cpu);
 
@@ -216,26 +217,25 @@ static int watchdog(void *__bind_cpu)
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
@@ -289,6 +289,7 @@ cpu_callback(struct notifier_block *nfb,
 	case CPU_DEAD_FROZEN:
 		p = per_cpu(watchdog_task, hotcpu);
 		per_cpu(watchdog_task, hotcpu) = NULL;
+		printk(KERN_ERR "kthread_stop(watchdog on cpu: %d)\n", hotcpu);
 		kthread_stop(p);
 		break;
 #endif /* CONFIG_HOTPLUG_CPU */
_

Patches currently in -mm which might be from dmitry.adamushko@gmail.com are

origin.patch
softlockup-fix-a-potential-race-condition-in-watchdog.patch
