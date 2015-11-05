From: akpm@linux-foundation.org
Subject: +
 watchdog-remove-getput_online_cpus-from-watchdog_parkunpark_threads.patch
 added to -mm tree
Date: Thu, 05 Nov 2015 02:30:47 -0800
Message-ID: <563b2fd7.S96qUtLoH8W1jWLi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57018 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031089AbbKEKas (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Nov 2015 05:30:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: uobergfe@redhat.com, atomlin@redhat.com, dzickus@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/watchdog.c: remove {get|put}_online_cpus() from watchdog_{park|unpark}_threads()
has been added to the -mm tree.  Its filename is
     watchdog-remove-getput_online_cpus-from-watchdog_parkunpark_threads.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/watchdog-remove-getput_online_cpus-from-watchdog_parkunpark_threads.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/watchdog-remove-getput_online_cpus-from-watchdog_parkunpark_threads.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ulrich Obergfell <uobergfe@redhat.com>
Subject: kernel/watchdog.c: remove {get|put}_online_cpus() from watchdog_{park|unpark}_threads()

watchdog_{park|unpark}_threads() are now called in code paths that protect
themselves against CPU hotplug, so {get|put}_online_cpus() calls are
redundant and can be removed.

Signed-off-by: Ulrich Obergfell <uobergfe@redhat.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Aaron Tomlin <atomlin@redhat.com>
Cc: Ulrich Obergfell <uobergfe@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN kernel/watchdog.c~watchdog-remove-getput_online_cpus-from-watchdog_parkunpark_threads kernel/watchdog.c
--- a/kernel/watchdog.c~watchdog-remove-getput_online_cpus-from-watchdog_parkunpark_threads
+++ a/kernel/watchdog.c
@@ -683,33 +683,35 @@ static struct smp_hotplug_thread watchdo
  * be parked and the watchdog threads of other CPUs can still be runnable.
  * Callers are expected to handle this special condition as appropriate in
  * their context.
+ *
+ * This function may only be called in a context that is protected against
+ * races with CPU hotplug - for example, via get_online_cpus().
  */
 static int watchdog_park_threads(void)
 {
 	int cpu, ret = 0;
 
-	get_online_cpus();
 	for_each_watchdog_cpu(cpu) {
 		ret = kthread_park(per_cpu(softlockup_watchdog, cpu));
 		if (ret)
 			break;
 	}
-	put_online_cpus();
 
 	return ret;
 }
 
 /*
  * unpark all watchdog threads that are specified in 'watchdog_cpumask'
+ *
+ * This function may only be called in a context that is protected against
+ * races with CPU hotplug - for example, via get_online_cpus().
  */
 static void watchdog_unpark_threads(void)
 {
 	int cpu;
 
-	get_online_cpus();
 	for_each_watchdog_cpu(cpu)
 		kthread_unpark(per_cpu(softlockup_watchdog, cpu));
-	put_online_cpus();
 }
 
 /*
_

Patches currently in -mm which might be from uobergfe@redhat.com are

watchdog-fix-error-handling-in-proc_watchdog_thresh.patch
watchdog-move-watchdog_disable_all_cpus-outside-of-ifdef.patch
watchdog-implement-error-handling-in-update_watchdog_all_cpus-and-callers.patch
watchdog-implement-error-handling-in-lockup_detector_suspend.patch
watchdog-do-not-unpark-threads-in-watchdog_park_threads-on-error.patch
watchdog-avoid-race-between-lockup-detector-suspend-resume-and-cpu-hotplug.patch
watchdog-avoid-races-between-proc-handlers-and-cpu-hotplug.patch
watchdog-remove-getput_online_cpus-from-watchdog_parkunpark_threads.patch
watchdog-fix-race-between-proc_watchdog_thresh-and-watchdog_timer_fn.patch

