From: akpm@linux-foundation.org
Subject: + swsusp-disable-nonboot-cpus-before-entering-platform-suspend.patch added to -mm tree
Date: Wed, 07 Mar 2007 13:15:58 -0800
Message-ID: <200703072115.l27LFw8a009311@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:58464 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992640AbXCGVQW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 7 Mar 2007 16:16:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rjw@sisk.pl, pavel@ucw.cz


The patch titled
     swsusp: disable nonboot CPUs before entering platform suspend
has been added to the -mm tree.  Its filename is
     swsusp-disable-nonboot-cpus-before-entering-platform-suspend.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: swsusp: disable nonboot CPUs before entering platform suspend
From: Rafael J. Wysocki <rjw@sisk.pl>

Prevent the WARN_ON() in arch/x86_64/kernel/acpi/sleep.c:init_low_mapping()
from triggering by disabling nonboot CPUs before we finally enter the
platform suspend.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/power/disk.c |    1 +
 kernel/power/user.c |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff -puN kernel/power/disk.c~swsusp-disable-nonboot-cpus-before-entering-platform-suspend kernel/power/disk.c
--- a/kernel/power/disk.c~swsusp-disable-nonboot-cpus-before-entering-platform-suspend
+++ a/kernel/power/disk.c
@@ -61,6 +61,7 @@ static void power_down(suspend_disk_meth
 	switch(mode) {
 	case PM_DISK_PLATFORM:
 		if (pm_ops && pm_ops->enter) {
+			disable_nonboot_cpus();
 			kernel_shutdown_prepare(SYSTEM_SUSPEND_DISK);
 			pm_ops->enter(PM_SUSPEND_DISK);
 			break;
diff -puN kernel/power/user.c~swsusp-disable-nonboot-cpus-before-entering-platform-suspend kernel/power/user.c
--- a/kernel/power/user.c~swsusp-disable-nonboot-cpus-before-entering-platform-suspend
+++ a/kernel/power/user.c
@@ -398,9 +398,9 @@ static int snapshot_ioctl(struct inode *
 
 		case PMOPS_ENTER:
 			if (data->platform_suspend) {
+				disable_nonboot_cpus();
 				kernel_shutdown_prepare(SYSTEM_SUSPEND_DISK);
 				error = pm_ops->enter(PM_SUSPEND_DISK);
-				error = 0;
 			}
 			break;
 
_

Patches currently in -mm which might be from rjw@sisk.pl are

swsusp-disable-nonboot-cpus-before-entering-platform-suspend.patch
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
