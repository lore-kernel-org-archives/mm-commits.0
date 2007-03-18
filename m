From: akpm@linux-foundation.org
Subject: - swsusp-disable-nonboot-cpus-before-entering-platform-suspend.patch removed from -mm tree
Date: Sun, 18 Mar 2007 01:08:42 -0800
Message-ID: <200703180908.l2I98geg019962@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60384 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752221AbXCRJJH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 18 Mar 2007 05:09:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, pavel@ucw.cz, mm-commits@vger.kernel.org


The patch titled
     swsusp: disable nonboot CPUs before entering platform suspend
has been removed from the -mm tree.  Its filename was
     swsusp-disable-nonboot-cpus-before-entering-platform-suspend.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: swsusp: disable nonboot CPUs before entering platform suspend
From: Rafael J. Wysocki <rjw@sisk.pl>

Prevent the WARN_ON() in arch/x86_64/kernel/acpi/sleep.c:init_low_mapping()
from triggering by disabling nonboot CPUs before we finally enter the
platform suspend.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/power/disk.c |    1 +
 kernel/power/user.c |    3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff -puN kernel/power/disk.c~swsusp-disable-nonboot-cpus-before-entering-platform-suspend kernel/power/disk.c
--- a/kernel/power/disk.c~swsusp-disable-nonboot-cpus-before-entering-platform-suspend
+++ a/kernel/power/disk.c
@@ -58,6 +58,7 @@ static inline int platform_prepare(void)
 
 static void power_down(suspend_disk_method_t mode)
 {
+	disable_nonboot_cpus();
 	switch(mode) {
 	case PM_DISK_PLATFORM:
 		if (pm_ops && pm_ops->enter) {
diff -puN kernel/power/user.c~swsusp-disable-nonboot-cpus-before-entering-platform-suspend kernel/power/user.c
--- a/kernel/power/user.c~swsusp-disable-nonboot-cpus-before-entering-platform-suspend
+++ a/kernel/power/user.c
@@ -398,9 +398,10 @@ static int snapshot_ioctl(struct inode *
 
 		case PMOPS_ENTER:
 			if (data->platform_suspend) {
+				disable_nonboot_cpus();
 				kernel_shutdown_prepare(SYSTEM_SUSPEND_DISK);
 				error = pm_ops->enter(PM_SUSPEND_DISK);
-				error = 0;
+				enable_nonboot_cpus();
 			}
 			break;
 
_

Patches currently in -mm which might be from rjw@sisk.pl are

origin.patch
make-xfs-workqueues-nonfreezable.patch
swsusp-use-inline-functions-for-changing-page-flags.patch
swsusp-do-not-use-page-flags.patch
mm-remove-unused-page-flags.patch
fix-refrigerator-vs-thaw_process-race.patch
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
