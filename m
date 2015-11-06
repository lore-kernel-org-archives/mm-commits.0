From: akpm@linux-foundation.org
Subject: [merged]
 watchdog-do-not-unpark-threads-in-watchdog_park_threads-on-error.patch
 removed from -mm tree
Date: Fri, 06 Nov 2015 12:06:14 -0800
Message-ID: <563d0836.AMfjQrYou2dJqIW9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48494 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1033432AbbKFUGO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 15:06:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: uobergfe@redhat.com, atomlin@redhat.com, dzickus@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: watchdog: do not unpark threads in watchdog_park_threads() on error
has been removed from the -mm tree.  Its filename was
     watchdog-do-not-unpark-threads-in-watchdog_park_threads-on-error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Acked-by: Don Zickus <dzickus@redhat.com>
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


