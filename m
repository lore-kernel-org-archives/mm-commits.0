From: akpm@linux-foundation.org
Subject: - freezer-fix-racy-usage-of-try_to_freeze-in-kswapd.patch removed from -mm tree
Date: Mon, 07 May 2007 17:05:29 -0700
Message-ID: <200705080005.l4805T77009099@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:46311 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755262AbXEHAGI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:06:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, pavel@ucw.cz, mm-commits@vger.kernel.org


The patch titled
     freezer: fix racy usage of try_to_freeze in kswapd
has been removed from the -mm tree.  Its filename was
     freezer-fix-racy-usage-of-try_to_freeze-in-kswapd.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: freezer: fix racy usage of try_to_freeze in kswapd
From: Rafael J. Wysocki <rjw@sisk.pl>

Currently we can miss freeze_process()->signal_wake_up() in kswapd() if it
happens between try_to_freeze() and prepare_to_wait().  To prevent this
from happening we should check freezing(current) before calling schedule().

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff -puN mm/vmscan.c~freezer-fix-racy-usage-of-try_to_freeze-in-kswapd mm/vmscan.c
--- a/mm/vmscan.c~freezer-fix-racy-usage-of-try_to_freeze-in-kswapd
+++ a/mm/vmscan.c
@@ -1323,8 +1323,6 @@ static int kswapd(void *p)
 	for ( ; ; ) {
 		unsigned long new_order;
 
-		try_to_freeze();
-
 		prepare_to_wait(&pgdat->kswapd_wait, &wait, TASK_INTERRUPTIBLE);
 		new_order = pgdat->kswapd_max_order;
 		pgdat->kswapd_max_order = 0;
@@ -1335,12 +1333,19 @@ static int kswapd(void *p)
 			 */
 			order = new_order;
 		} else {
-			schedule();
+			if (!freezing(current))
+				schedule();
+
 			order = pgdat->kswapd_max_order;
 		}
 		finish_wait(&pgdat->kswapd_wait, &wait);
 
-		balance_pgdat(pgdat, order);
+		if (!try_to_freeze()) {
+			/* We can speed up thawing tasks if we don't call
+			 * balance_pgdat after returning from the refrigerator
+			 */
+			balance_pgdat(pgdat, order);
+		}
 	}
 	return 0;
 }
_

Patches currently in -mm which might be from rjw@sisk.pl are

origin.patch
swsusp-clean-up-print.patch
pm-separate-hibernation-code-from-suspend-code.patch
freezer-task-exit_state-should-be-treated-as-bolean.patch
documentation-ask-driver-writers-to-provide-pm-support.patch
workqueues-shift-kthread_bind-from-cpu_up_prepare-to-cpu_online.patch
freezer-read-pf_borrowed_mm-in-a-nonracy-way.patch
freezer-close-theoretical-race-between-refrigerator-and-thaw_tasks.patch
freezer-remove-pf_nofreeze-from-rcutorture-thread.patch
freezer-remove-pf_nofreeze-from-bluetooth-threads.patch
freezer-add-try_to_freeze-calls-to-all-kernel-threads.patch
freezer-fix-vfork-problem.patch
freezer-take-kernel_execve-into-consideration.patch
fix-pf_nofreeze-and-freezeable-race-2.patch
freezer-document-task_lock-in-thaw_process.patch
move-frozen_process-to-kernel-power-processc.patch
remvoe-kthread_bind-call-from-_cpu_down.patch
separate-freezer-from-pm-code-rev-2.patch
introduce-freezer-flags-rev-2.patch
add-suspend-related-notifications-for-cpu-hotplug.patch
add-suspend-related-notifications-for-cpu-hotplug-cleanup.patch
microcode-use-suspend-related-cpu-hotplug-notifications.patch
add-suspend-related-notifications-for-cpu-hotplug-statistics.patch
shrink_slab-handle-bad-shrinkers.patch
