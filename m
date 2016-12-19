From: akpm@linux-foundation.org
Subject: +
 kernel-watchdog-prevent-false-hardlockup-on-overloaded-system.patch added
 to -mm tree
Date: Mon, 19 Dec 2016 11:54:38 -0800
Message-ID: <58583afe.lSNPqqbbh2p2Lvg2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35982 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756305AbcLSTxo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Dec 2016 14:53:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dzickus@redhat.com, atomlin@redhat.com, uobergfe@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/watchdog: prevent false hardlockup on overloaded system
has been added to the -mm tree.  Its filename is
     kernel-watchdog-prevent-false-hardlockup-on-overloaded-system.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-watchdog-prevent-false-hardlockup-on-overloaded-system.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-watchdog-prevent-false-hardlockup-on-overloaded-system.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Don Zickus <dzickus@redhat.com>
Subject: kernel/watchdog: prevent false hardlockup on overloaded system

On an overloaded system, it is possible that a change in the watchdog
threshold can be delayed long enough to trigger a false positive.

This can easily be achieved by having a cpu spinning indefinitely on a
task, while another cpu updates watchdog threshold.

What happens is while trying to park the watchdog threads, the hrtimers on
the other cpus trigger and reprogram themselves with the new slower
watchdog threshold.  Meanwhile, the nmi watchdog is still programmed with
the old faster threshold.

Because the one cpu is blocked, it prevents the thread parking on the
other cpus from completing, which is needed to shutdown the nmi watchdog
and reprogram it correctly.  As a result, a false positive from the nmi
watchdog is reported.

Fix this by setting a park_in_progress flag to block all lockups until the
parking is complete.

Fix provided by Ulrich Obergfell.

Link: http://lkml.kernel.org/r/1481041033-192236-1-git-send-email-dzickus@redhat.com
Signed-off-by: Don Zickus <dzickus@redhat.com>
Reviewed-by: Aaron Tomlin <atomlin@redhat.com>
Cc: Ulrich Obergfell <uobergfe@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/nmi.h   |    1 +
 kernel/watchdog.c     |    9 +++++++++
 kernel/watchdog_hld.c |    3 +++
 3 files changed, 13 insertions(+)

diff -puN include/linux/nmi.h~kernel-watchdog-prevent-false-hardlockup-on-overloaded-system include/linux/nmi.h
--- a/include/linux/nmi.h~kernel-watchdog-prevent-false-hardlockup-on-overloaded-system
+++ a/include/linux/nmi.h
@@ -110,6 +110,7 @@ extern int watchdog_user_enabled;
 extern int watchdog_thresh;
 extern unsigned long watchdog_enabled;
 extern unsigned long *watchdog_cpumask_bits;
+extern atomic_t park_in_progress;
 #ifdef CONFIG_SMP
 extern int sysctl_softlockup_all_cpu_backtrace;
 extern int sysctl_hardlockup_all_cpu_backtrace;
diff -puN kernel/watchdog.c~kernel-watchdog-prevent-false-hardlockup-on-overloaded-system kernel/watchdog.c
--- a/kernel/watchdog.c~kernel-watchdog-prevent-false-hardlockup-on-overloaded-system
+++ a/kernel/watchdog.c
@@ -49,6 +49,8 @@ unsigned long *watchdog_cpumask_bits = c
 #define for_each_watchdog_cpu(cpu) \
 	for_each_cpu_and((cpu), cpu_online_mask, &watchdog_cpumask)
 
+atomic_t park_in_progress = ATOMIC_INIT(0);
+
 /*
  * The 'watchdog_running' variable is set to 1 when the watchdog threads
  * are registered/started and is set to 0 when the watchdog threads are
@@ -260,6 +262,9 @@ static enum hrtimer_restart watchdog_tim
 	int duration;
 	int softlockup_all_cpu_backtrace = sysctl_softlockup_all_cpu_backtrace;
 
+	if (atomic_read(&park_in_progress) != 0)
+		return HRTIMER_NORESTART;
+
 	/* kick the hardlockup detector */
 	watchdog_interrupt_count();
 
@@ -467,12 +472,16 @@ static int watchdog_park_threads(void)
 {
 	int cpu, ret = 0;
 
+	atomic_set(&park_in_progress, 1);
+
 	for_each_watchdog_cpu(cpu) {
 		ret = kthread_park(per_cpu(softlockup_watchdog, cpu));
 		if (ret)
 			break;
 	}
 
+	atomic_set(&park_in_progress, 0);
+
 	return ret;
 }
 
diff -puN kernel/watchdog_hld.c~kernel-watchdog-prevent-false-hardlockup-on-overloaded-system kernel/watchdog_hld.c
--- a/kernel/watchdog_hld.c~kernel-watchdog-prevent-false-hardlockup-on-overloaded-system
+++ a/kernel/watchdog_hld.c
@@ -84,6 +84,9 @@ static void watchdog_overflow_callback(s
 	/* Ensure the watchdog never gets throttled */
 	event->hw.interrupts = 0;
 
+	if (atomic_read(&park_in_progress) != 0)
+		return;
+
 	if (__this_cpu_read(watchdog_nmi_touch) == true) {
 		__this_cpu_write(watchdog_nmi_touch, false);
 		return;
_

Patches currently in -mm which might be from dzickus@redhat.com are

kernel-watchdog-prevent-false-hardlockup-on-overloaded-system.patch

