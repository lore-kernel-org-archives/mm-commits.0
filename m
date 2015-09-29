From: akpm@linux-foundation.org
Subject: +
 watchdog-do-not-unpark-threads-in-watchdog_park_threads-on-error.patch
 added to -mm tree
Date: Tue, 29 Sep 2015 16:40:25 -0700
Message-ID: <560b2169.0kOZa4S2PB8nwG32%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47073 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309AbbI2Xk0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 29 Sep 2015 19:40:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: uobergfe@redhat.com, atomlin@redhat.com, dzickus@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: watchdog: do not unpark threads in watchdog_park_threads() on error
has been added to the -mm tree.  Its filename is
     watchdog-do-not-unpark-threads-in-watchdog_park_threads-on-error.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/watchdog-do-not-unpark-threads-in-watchdog_park_threads-on-error.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/watchdog-do-not-unpark-threads-in-watchdog_park_threads-on-error.patch

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
Subject: watchdog: do not unpark threads in watchdog_park_threads() on error

If kthread_park() returns an error, watchdog_park_threads() should not
blindly 'roll back' the already parked threads to the unparked state. 
Instead leave it up to the callers to handle such errors appropriately in
their context.  For example, it is redundant to unpark the threads if the
lockup detectors will soon be disabled by the callers anyway.

Signed-off-by: Ulrich Obergfell <uobergfe@redhat.com>
Reviewed-by: Aaron Tomlin <atomlin@redhat.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Ulrich Obergfell <uobergfe@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN kernel/watchdog.c~watchdog-do-not-unpark-threads-in-watchdog_park_threads-on-error kernel/watchdog.c
--- a/kernel/watchdog.c~watchdog-do-not-unpark-threads-in-watchdog_park_threads-on-error
+++ a/kernel/watchdog.c
@@ -654,6 +654,12 @@ static struct smp_hotplug_thread watchdo
 
 /*
  * park all watchdog threads that are specified in 'watchdog_cpumask'
+ *
+ * This function returns an error if kthread_park() of a watchdog thread
+ * fails. In this situation, the watchdog threads of some CPUs can already
+ * be parked and the watchdog threads of other CPUs can still be runnable.
+ * Callers are expected to handle this special condition as appropriate in
+ * their context.
  */
 static int watchdog_park_threads(void)
 {
@@ -665,10 +671,6 @@ static int watchdog_park_threads(void)
 		if (ret)
 			break;
 	}
-	if (ret) {
-		for_each_watchdog_cpu(cpu)
-			kthread_unpark(per_cpu(softlockup_watchdog, cpu));
-	}
 	put_online_cpus();
 
 	return ret;
_

Patches currently in -mm which might be from uobergfe@redhat.com are

watchdog-fix-error-handling-in-proc_watchdog_thresh.patch
watchdog-move-watchdog_disable_all_cpus-outside-of-ifdef.patch
watchdog-implement-error-handling-in-update_watchdog_all_cpus-and-callers.patch
watchdog-implement-error-handling-in-lockup_detector_suspend.patch
watchdog-do-not-unpark-threads-in-watchdog_park_threads-on-error.patch

