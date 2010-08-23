From: akpm@linux-foundation.org
Subject: + lockup_detector-convert-cpu-notifier-to-return-encapsulate-errno-value.patch added to -mm tree
Date: Mon, 23 Aug 2010 16:38:23 -0700
Message-ID: <201008232338.o7NNcNQU021372@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36679 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751397Ab0HWXjK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Aug 2010 19:39:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, dzickus@redhat.com, mingo@elte.hu


The patch titled
     lockup_detector: convert cpu notifier to return encapsulate errno value
has been added to the -mm tree.  Its filename is
     lockup_detector-convert-cpu-notifier-to-return-encapsulate-errno-value.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lockup_detector: convert cpu notifier to return encapsulate errno value
From: Akinobu Mita <akinobu.mita@gmail.com>

By the commit e6bde73b07edeb703d4c89c1daabc09c303de11f ("cpu-hotplug:
return better errno on cpu hotplug failure"), the cpu notifier can return
encapsulate errno value.

This converts the cpu notifier to return encapsulate errno value for
lockup_detector.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Acked-by: Don Zickus <dzickus@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |   21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff -puN kernel/watchdog.c~lockup_detector-convert-cpu-notifier-to-return-encapsulate-errno-value kernel/watchdog.c
--- a/kernel/watchdog.c~lockup_detector-convert-cpu-notifier-to-return-encapsulate-errno-value
+++ a/kernel/watchdog.c
@@ -371,7 +371,7 @@ static int watchdog_nmi_enable(int cpu)
 	}
 
 	printk(KERN_ERR "NMI watchdog failed to create perf event on cpu%i: %p\n", cpu, event);
-	return -1;
+	return PTR_ERR(event);
 
 	/* success path */
 out_save:
@@ -415,17 +415,19 @@ static int watchdog_prepare_cpu(int cpu)
 static int watchdog_enable(int cpu)
 {
 	struct task_struct *p = per_cpu(softlockup_watchdog, cpu);
+	int err;
 
 	/* enable the perf event */
-	if (watchdog_nmi_enable(cpu) != 0)
-		return -1;
+	err = watchdog_nmi_enable(cpu);
+	if (err)
+		return err;
 
 	/* create the watchdog thread */
 	if (!p) {
 		p = kthread_create(watchdog, (void *)(unsigned long)cpu, "watchdog/%d", cpu);
 		if (IS_ERR(p)) {
 			printk(KERN_ERR "softlockup watchdog for %i failed\n", cpu);
-			return -1;
+			return PTR_ERR(p);
 		}
 		kthread_bind(p, cpu);
 		per_cpu(watchdog_touch_ts, cpu) = 0;
@@ -519,17 +521,16 @@ static int __cpuinit
 cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
 {
 	int hotcpu = (unsigned long)hcpu;
+	int err = 0;
 
 	switch (action) {
 	case CPU_UP_PREPARE:
 	case CPU_UP_PREPARE_FROZEN:
-		if (watchdog_prepare_cpu(hotcpu))
-			return NOTIFY_BAD;
+		err = watchdog_prepare_cpu(hotcpu);
 		break;
 	case CPU_ONLINE:
 	case CPU_ONLINE_FROZEN:
-		if (watchdog_enable(hotcpu))
-			return NOTIFY_BAD;
+		err = watchdog_enable(hotcpu);
 		break;
 #ifdef CONFIG_HOTPLUG_CPU
 	case CPU_UP_CANCELED:
@@ -542,7 +543,7 @@ cpu_callback(struct notifier_block *nfb,
 		break;
 #endif /* CONFIG_HOTPLUG_CPU */
 	}
-	return NOTIFY_OK;
+	return notifier_from_errno(err);
 }
 
 static struct notifier_block __cpuinitdata cpu_nfb = {
@@ -558,7 +559,7 @@ static int __init spawn_watchdog_task(vo
 		return 0;
 
 	err = cpu_callback(&cpu_nfb, CPU_UP_PREPARE, cpu);
-	WARN_ON(err == NOTIFY_BAD);
+	WARN_ON(notifier_to_errno(err));
 
 	cpu_callback(&cpu_nfb, CPU_ONLINE, cpu);
 	register_cpu_notifier(&cpu_nfb);
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

stop_machine-convert-cpu-notifier-to-return-encapsulate-errno-value.patch
lockup_detector-convert-cpu-notifier-to-return-encapsulate-errno-value.patch
lockup_detector-remove-unnecessary-panic_notifier.patch

