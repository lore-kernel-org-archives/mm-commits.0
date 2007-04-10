From: akpm@linux-foundation.org
Subject: + freezer-fix-racy-usage-of-try_to_freeze-in-kswapd.patch added to -mm tree
Date: Tue, 10 Apr 2007 16:22:04 -0700
Message-ID: <200704102322.l3ANM4QU022822@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51430 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753398AbXDJXWj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Apr 2007 19:22:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rjw@sisk.pl, pavel@ucw.cz


The patch titled
     freezer: fix racy usage of try_to_freeze in kswapd
has been added to the -mm tree.  Its filename is
     freezer-fix-racy-usage-of-try_to_freeze-in-kswapd.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 9 insertions(+), 4 deletions(-)

diff -puN mm/vmscan.c~freezer-fix-racy-usage-of-try_to_freeze-in-kswapd mm/vmscan.c
--- a/mm/vmscan.c~freezer-fix-racy-usage-of-try_to_freeze-in-kswapd
+++ a/mm/vmscan.c
@@ -1393,8 +1393,6 @@ static int kswapd(void *p)
 	for ( ; ; ) {
 		unsigned long new_order;
 
-		try_to_freeze();
-
 		prepare_to_wait(&pgdat->kswapd_wait, &wait, TASK_INTERRUPTIBLE);
 		new_order = pgdat->kswapd_max_order;
 		pgdat->kswapd_max_order = 0;
@@ -1405,12 +1403,19 @@ static int kswapd(void *p)
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

pktgen-add-try_to_freeze.patch
fix-refrigerator-vs-thaw_process-race.patch
swsusp-use-inline-functions-for-changing-page-flags.patch
swsusp-do-not-use-page-flags.patch
mm-remove-unused-page-flags.patch
swsusp-fix-error-paths-in-snapshot_open.patch
swsusp-use-gfp_kernel-for-creating-basic-data-structures.patch
rework-pm_ops-pm_disk_mode-kill-misuse.patch
power-management-remove-firmware-disk-mode.patch
power-management-implement-pm_opsvalid-for-everybody.patch
power-management-force-pm_opsvalid-callback-to-be.patch
freezer-remove-pf_nofreeze-from-handle_initrd.patch
swsusp-use-rbtree-for-tracking-allocated-swap.patch
freezer-fix-racy-usage-of-try_to_freeze-in-kswapd.patch
freezer-task-exit_state-should-be-treated-as-bolean.patch
documentation-ask-driver-writers-to-provide-pm-support.patch
freezer-read-pf_borrowed_mm-in-a-nonracy-way.patch
freezer-close-theoretical-race-between-refrigerator-and-thaw_tasks.patch
freezer-remove-pf_nofreeze-from-rcutorture-thread.patch
freezer-remove-pf_nofreeze-from-bluetooth-threads.patch
freezer-add-try_to_freeze-calls-to-all-kernel-threads.patch
freezer-fix-vfork-problem.patch
freezer-take-kernel_execve-into-consideration.patch
shrink_slab-handle-bad-shrinkers.patch
