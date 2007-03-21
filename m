From: akpm@linux-foundation.org
Subject: + swsusp-fix-snapshot_s2ram-ioctl.patch added to -mm tree
Date: Wed, 21 Mar 2007 15:25:33 -0700
Message-ID: <200703212225.l2LMPXj5005412@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:56575 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965397AbXCUWZp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Mar 2007 18:25:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rjw@sisk.pl, pavel@ucw.cz


The patch titled
     swsusp: Fix SNAPSHOT_S2RAM ioctl
has been added to the -mm tree.  Its filename is
     swsusp-fix-snapshot_s2ram-ioctl.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 6 insertions(+), 3 deletions(-)

diff -puN kernel/power/user.c~swsusp-fix-snapshot_s2ram-ioctl kernel/power/user.c
--- a/kernel/power/user.c~swsusp-fix-snapshot_s2ram-ioctl
+++ a/kernel/power/user.c
@@ -374,9 +374,12 @@ static int snapshot_ioctl(struct inode *
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

origin.patch
swsusp-fix-snapshot_s2ram-ioctl.patch
make-xfs-workqueues-nonfreezable.patch
fix-refrigerator-vs-thaw_process-race.patch
swsusp-use-inline-functions-for-changing-page-flags.patch
swsusp-do-not-use-page-flags.patch
mm-remove-unused-page-flags.patch
swsusp-fix-error-paths-in-snapshot_open.patch
swsusp-use-gfp_kernel-for-creating-basic-data-structures.patch
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
