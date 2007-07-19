From: akpm@linux-foundation.org
Subject: - swsusp-remove-incorrect-code-from-userc.patch removed from -mm tree
Date: Thu, 19 Jul 2007 12:59:58 -0700
Message-ID: <200707191959.l6JJxw5h019387@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42024 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754824AbXGSUAt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:00:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, nigel@nigel.suspend2.net, pavel@ucw.cz, mm-commits@vger.kernel.org


The patch titled
     swsusp: remove incorrect code from user.c
has been removed from the -mm tree.  Its filename was
     swsusp-remove-incorrect-code-from-userc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: swsusp: remove incorrect code from user.c
From: Rafael J. Wysocki <rjw@sisk.pl>

In the face of the recent change of suspend code ordering (cf. 
http://marc.info/?l=linux-acpi&m=117938245931603&w=2) we should also modify
the code ordering in swsusp so that hibernation_ops->prepare() is executed
after device_suspend().

However, for this purpose it seems reasonable to eliminate the code
duplication between kernel/power/disk.c and kernel/power/user.c first.  By
eliminating it we can reduce the size of user.c quite substantially and remove
the maintenance difficulty with making essentially the same changes in two
different places.

Moreover, we should also remove the calls to "platform" functions from the
restore code path, since it doesn't carry out any power transition of the
system, but we generally need to disable the GPEs before the restore if the
'platform' hibernation mode has been used.  To do this, we can introduce two
new hibernation_ops to be used in the restore code.


This patch:

Make the code hibernation code in kernel/power/user.c be functionally
equivalent to the corresponding code in kernel/power/disk.c , as it should be.

The calls to the platform functions removed by this patch are incorrect.  They
should be replaced with some other "platform" invocations that will be
introduced in one of the subsequent patches.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
Cc: Nigel Cunningham <nigel@nigel.suspend2.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/power/user.c |   17 ++++-------------
 1 file changed, 4 insertions(+), 13 deletions(-)

diff -puN kernel/power/user.c~swsusp-remove-incorrect-code-from-userc kernel/power/user.c
--- a/kernel/power/user.c~swsusp-remove-incorrect-code-from-userc
+++ a/kernel/power/user.c
@@ -181,34 +181,25 @@ static inline int snapshot_suspend(int p
 	return error;
 }
 
-static inline int snapshot_restore(int platform_suspend)
+static inline int snapshot_restore(void)
 {
 	int error;
 
 	mutex_lock(&pm_mutex);
 	pm_prepare_console();
-	if (platform_suspend) {
-		error = platform_prepare();
-		if (error)
-			goto Finish;
-	}
 	suspend_console();
 	error = device_suspend(PMSG_PRETHAW);
 	if (error)
-		goto Resume_devices;
+		goto Finish;
 
 	error = disable_nonboot_cpus();
 	if (!error)
 		error = swsusp_resume();
 
 	enable_nonboot_cpus();
- Resume_devices:
-	if (platform_suspend)
-		platform_finish();
-
+ Finish:
 	device_resume();
 	resume_console();
- Finish:
 	pm_restore_console();
 	mutex_unlock(&pm_mutex);
 	return error;
@@ -274,7 +265,7 @@ static int snapshot_ioctl(struct inode *
 			error = -EPERM;
 			break;
 		}
-		error = snapshot_restore(data->platform_suspend);
+		error = snapshot_restore();
 		break;
 
 	case SNAPSHOT_FREE:
_

Patches currently in -mm which might be from rjw@sisk.pl are

origin.patch
acpi-implement-the-set_target-callback-from-pm_ops.patch
acpi-add-acpi_pm_device_sleep_state-helper-routine.patch
pm-move-definition-of-struct-pm_ops-to-suspendh.patch
pm-rename-struct-pm_ops-and-related-things.patch
pm-rework-struct-platform_suspend_ops.patch
pm-fix-compilation-of-suspend-code-if-config_pm-is-unset.patch
pm-make-suspend_ops-static.patch
pm-rework-struct-hibernation_ops.patch
pm-rename-hibernation_ops-to-platform_hibernation_ops.patch
shrink_slab-handle-bad-shrinkers.patch
