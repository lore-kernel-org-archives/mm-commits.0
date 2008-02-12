From: akpm@linux-foundation.org
Subject: - softlockup-fix-a-potential-race-condition-in-watchdog.patch removed from -mm tree
Date: Mon, 11 Feb 2008 16:39:43 -0800
Message-ID: <200802120048.m1C0mfBD010153@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45883 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751430AbYBLAt2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Feb 2008 19:49:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dmitry.adamushko@gmail.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     softlockup: fix a potential race condition in watchdog()
has been removed from the -mm tree.  Its filename was
     softlockup-fix-a-potential-race-condition-in-watchdog.patch

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

 kernel/softlockup.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN kernel/softlockup.c~softlockup-fix-a-potential-race-condition-in-watchdog kernel/softlockup.c
--- a/kernel/softlockup.c~softlockup-fix-a-potential-race-condition-in-watchdog
+++ a/kernel/softlockup.c
@@ -98,6 +98,7 @@ void softlockup_tick(void)
 		touch_softlockup_watchdog();
 		return;
 	}
+	printk(KERN_ERR "watchdog(cpu: %d) -- exit\n", this_cpu);
 
 	now = get_timestamp(this_cpu);
 
@@ -289,6 +290,7 @@ cpu_callback(struct notifier_block *nfb,
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
softlockup-fix-a-potential-race-condition-in-watchdog-2.patch
