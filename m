From: akpm@linux-foundation.org
Subject: - swsusp-fix-snapshot_s2ram-ioctl.patch removed from -mm tree
Date: Sun, 25 Mar 2007 17:04:53 -0800
Message-ID: <200703260104.l2Q14rnW008671@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:38500 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933314AbXCZBF1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 25 Mar 2007 21:05:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, pavel@ucw.cz, mm-commits@vger.kernel.org


The patch titled
     swsusp: Fix SNAPSHOT_S2RAM ioctl
has been removed from the -mm tree.  Its filename was
     swsusp-fix-snapshot_s2ram-ioctl.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: swsusp: Fix SNAPSHOT_S2RAM ioctl
From: Rafael J. Wysocki <rjw@sisk.pl>

The SNAPSHOT_S2RAM ioctl does not disable the nonboot CPUs before entering
the suspend, although it should do this.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/power/user.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff -puN kernel/power/user.c~swsusp-fix-snapshot_s2ram-ioctl kernel/power/user.c
--- a/kernel/power/user.c~swsusp-fix-snapshot_s2ram-ioctl
+++ a/kernel/power/user.c
@@ -368,9 +368,12 @@ static int snapshot_ioctl(struct inode *
 		if (error) {
 			printk(KERN_ERR "Failed to suspend some devices.\n");
 		} else {
-			/* Enter S3, system is already frozen */
-			suspend_enter(PM_SUSPEND_MEM);
-
+			error = disable_nonboot_cpus();
+			if (!error) {
+				/* Enter S3, system is already frozen */
+				suspend_enter(PM_SUSPEND_MEM);
+				enable_nonboot_cpus();
+			}
 			/* Wake up devices */
 			device_resume();
 		}
_

Patches currently in -mm which might be from rjw@sisk.pl are

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
