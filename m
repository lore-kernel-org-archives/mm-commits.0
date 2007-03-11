From: akpm@linux-foundation.org
Subject: + swsusp-disable-nonboot-cpus-before-entering-platform-suspend-update.patch added to -mm tree
Date: Sat, 10 Mar 2007 23:34:55 -0800
Message-ID: <200703110734.l2B7YtUm007082@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:38839 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751276AbXCKHfD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Mar 2007 03:35:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rjw@sisk.pl, pavel@ucw.cz


The patch titled
     swsusp-disable-nonboot-cpus-before-entering-platform-suspend update
has been added to the -mm tree.  Its filename is
     swsusp-disable-nonboot-cpus-before-entering-platform-suspend-update.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: swsusp-disable-nonboot-cpus-before-entering-platform-suspend update
From: "Rafael J. Wysocki" <rjw@sisk.pl>

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/power/disk.c |    2 +-
 kernel/power/user.c |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff -puN kernel/power/disk.c~swsusp-disable-nonboot-cpus-before-entering-platform-suspend-update kernel/power/disk.c
--- a/kernel/power/disk.c~swsusp-disable-nonboot-cpus-before-entering-platform-suspend-update
+++ a/kernel/power/disk.c
@@ -58,10 +58,10 @@ static inline int platform_prepare(void)
 
 static void power_down(suspend_disk_method_t mode)
 {
+	disable_nonboot_cpus();
 	switch(mode) {
 	case PM_DISK_PLATFORM:
 		if (pm_ops && pm_ops->enter) {
-			disable_nonboot_cpus();
 			kernel_shutdown_prepare(SYSTEM_SUSPEND_DISK);
 			pm_ops->enter(PM_SUSPEND_DISK);
 			break;
diff -puN kernel/power/user.c~swsusp-disable-nonboot-cpus-before-entering-platform-suspend-update kernel/power/user.c
--- a/kernel/power/user.c~swsusp-disable-nonboot-cpus-before-entering-platform-suspend-update
+++ a/kernel/power/user.c
@@ -401,6 +401,7 @@ static int snapshot_ioctl(struct inode *
 				disable_nonboot_cpus();
 				kernel_shutdown_prepare(SYSTEM_SUSPEND_DISK);
 				error = pm_ops->enter(PM_SUSPEND_DISK);
+				enable_nonboot_cpus();
 			}
 			break;
 
_

Patches currently in -mm which might be from rjw@sisk.pl are

swsusp-fix-resume-error-path-in-platform-mode.patch
swsusp-disable-nonboot-cpus-before-entering-platform-suspend.patch
swsusp-disable-nonboot-cpus-before-entering-platform-suspend-update.patch
make-xfs-workqueues-nonfreezable.patch
fix-refrigerator-vs-thaw_process-race.patch
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
