From: akpm@linux-foundation.org
Subject: [merged] kernel-watchdogc-always-return-notify_ok-during-cpu-up-down-events.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:39:15 -0700
Message-ID: <201103232042.p2NKgpxF028805@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36293 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933434Ab1CWUnb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:43:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dzickus@redhat.com, a.p.zijlstra@chello.nl, xiyou.wangcong@gmail.com, mm-commits@vger.kernel.org


The patch titled
     kernel/watchdog.c: always return NOTIFY_OK during cpu up/down events
has been removed from the -mm tree.  Its filename was
     kernel-watchdogc-always-return-notify_ok-during-cpu-up-down-events.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kernel/watchdog.c: always return NOTIFY_OK during cpu up/down events
From: Don Zickus <dzickus@redhat.com>

This patch addresses a couple of problems.  One was the case when the
hardlockup failed to start, it also failed to start the softlockup.  There
were valid cases when the hardlockup shouldn't start and that shouldn't
block the softlockup (no lapic, bios controls perf counters).

The second problem was when the hardlockup failed to start on boxes (from
a no lapic or bios controlled perf counter case), it reported failure to
the cpu notifier chain.  This blocked the notifier from continuing to
start other more critical pieces of cpu bring-up (in our case based on a
2.6.32 fork, it was the mce).  As a result, during soft cpu online/offline
testing, the system would panic when a cpu was offlined because the cpu
notifier would succeed in processing a watchdog disable cpu event and
would panic in the mce case as a result of un-initialized variables from a
never executed cpu up event.

I realized the hardlockup/softlockup cases are really just debugging aids
and should never impede the progress of a cpu up/down event.  Therefore I
modified the code to always return NOTIFY_OK and instead rely on printks
to inform the user of problems.

Signed-off-by: Don Zickus <dzickus@redhat.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |   22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff -puN kernel/watchdog.c~kernel-watchdogc-always-return-notify_ok-during-cpu-up-down-events kernel/watchdog.c
--- a/kernel/watchdog.c~kernel-watchdogc-always-return-notify_ok-during-cpu-up-down-events
+++ a/kernel/watchdog.c
@@ -418,19 +418,22 @@ static int watchdog_prepare_cpu(int cpu)
 static int watchdog_enable(int cpu)
 {
 	struct task_struct *p = per_cpu(softlockup_watchdog, cpu);
-	int err;
+	int err = 0;
 
 	/* enable the perf event */
 	err = watchdog_nmi_enable(cpu);
-	if (err)
-		return err;
+
+	/* Regardless of err above, fall through and start softlockup */
 
 	/* create the watchdog thread */
 	if (!p) {
 		p = kthread_create(watchdog, (void *)(unsigned long)cpu, "watchdog/%d", cpu);
 		if (IS_ERR(p)) {
 			printk(KERN_ERR "softlockup watchdog for %i failed\n", cpu);
-			return PTR_ERR(p);
+			if (!err)
+				/* if hardlockup hasn't already set this */
+				err = PTR_ERR(p);
+			goto out;
 		}
 		kthread_bind(p, cpu);
 		per_cpu(watchdog_touch_ts, cpu) = 0;
@@ -438,7 +441,8 @@ static int watchdog_enable(int cpu)
 		wake_up_process(p);
 	}
 
-	return 0;
+out:
+	return err;
 }
 
 static void watchdog_disable(int cpu)
@@ -550,7 +554,13 @@ cpu_callback(struct notifier_block *nfb,
 		break;
 #endif /* CONFIG_HOTPLUG_CPU */
 	}
-	return notifier_from_errno(err);
+
+	/*
+	 * hardlockup and softlockup are not important enough
+	 * to block cpu bring up.  Just always succeed and
+	 * rely on printk output to flag problems.
+	 */
+	return NOTIFY_OK;
 }
 
 static struct notifier_block __cpuinitdata cpu_nfb = {
_

Patches currently in -mm which might be from dzickus@redhat.com are

origin.patch
linux-next.patch

