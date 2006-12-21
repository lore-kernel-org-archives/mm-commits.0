From: akpm@osdl.org
Subject: + swsusp-change-pm_ops-handling-by-userland-interface.patch added to -mm tree
Date: Wed, 20 Dec 2006 22:20:18 -0800
Message-ID: <200612210620.kBL6KIpM017552@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:41983 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422757AbWLUGUo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Dec 2006 01:20:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rjw@sisk.pl, greg@kroah.com, mochel@digitalimplant.org, nigel@suspend2.net, pavel@ucw.cz


The patch titled
     swsusp: Change pm_ops handling by userland interface
has been added to the -mm tree.  Its filename is
     swsusp-change-pm_ops-handling-by-userland-interface.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: swsusp: Change pm_ops handling by userland interface
From: "Rafael J. Wysocki" <rjw@sisk.pl>

Make the userland interface of swsusp call pm_ops->finish() after
enable_nonboot_cpus() and before resume_device(), as indicated by the recent
discussion on Linux-PM (cf. 
http://lists.osdl.org/pipermail/linux-pm/2006-November/004164.html).

This patch changes the SNAPSHOT_PMOPS ioctl so that its first function,
PMOPS_PREPARE, only sets a switch turning the platform suspend mode on, and
its last function, PMOPS_FINISH, only checks if the platform mode is enabled. 
This should allow the older userland tools to work with new kernels without
any modifications.

The changes here only affect the userland interface of swsusp.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
Cc: Greg KH <greg@kroah.com>
Cc: Nigel Cunningham <nigel@suspend2.net>
Cc: Patrick Mochel <mochel@digitalimplant.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/power/user.c |   39 ++++++++++++++++++++++++++++-----------
 1 file changed, 28 insertions(+), 11 deletions(-)

diff -puN kernel/power/user.c~swsusp-change-pm_ops-handling-by-userland-interface kernel/power/user.c
--- a/kernel/power/user.c~swsusp-change-pm_ops-handling-by-userland-interface
+++ a/kernel/power/user.c
@@ -37,6 +37,7 @@ static struct snapshot_data {
 	int mode;
 	char frozen;
 	char ready;
+	char platform_suspend;
 } snapshot_state;
 
 static atomic_t device_available = ATOMIC_INIT(1);
@@ -66,6 +67,7 @@ static int snapshot_open(struct inode *i
 	data->bitmap = NULL;
 	data->frozen = 0;
 	data->ready = 0;
+	data->platform_suspend = 0;
 
 	return 0;
 }
@@ -132,6 +134,11 @@ static int snapshot_suspend(void)
 	if (error)
 		goto Finish;
 
+	if (platform_suspend) {
+		error = platform_prepare();
+		if (error)
+			goto Finish;
+	}
 	suspend_console();
 	error = device_suspend(PMSG_FREEZE);
 	if (error)
@@ -144,6 +151,9 @@ static int snapshot_suspend(void)
 	}
 	enable_nonboot_cpus();
  Resume_devices:
+	if (platform_suspend)
+		platform_finish();
+
 	device_resume();
 	resume_console();
  Finish:
@@ -168,8 +178,12 @@ static int snapshot_restore(void)
 
 	enable_nonboot_cpus();
  Resume_devices:
+	if (platform_suspend)
+		platform_finish();
+
 	device_resume();
 	resume_console();
+ Finish:
 	pm_restore_console();
 	mutex_unlock(&pm_mutex);
 	return error;
@@ -221,7 +235,7 @@ static int snapshot_ioctl(struct inode *
 			error = -EPERM;
 			break;
 		}
-		error = snapshot_suspend();
+		error = snapshot_suspend(data->platform_suspend);
 		if (!error)
 			error = put_user(in_suspend, (unsigned int __user *)arg);
 		if (!error)
@@ -235,7 +249,7 @@ static int snapshot_ioctl(struct inode *
 			error = -EPERM;
 			break;
 		}
-		error = snapshot_restore();
+		error = snapshot_restore(data->platform_suspend);
 		break;
 
 	case SNAPSHOT_FREE:
@@ -342,28 +356,31 @@ static int snapshot_ioctl(struct inode *
 		break;
 
 	case SNAPSHOT_PMOPS:
+		error = -EINVAL;
+
 		switch (arg) {
 
 		case PMOPS_PREPARE:
-			if (pm_ops->prepare) {
-				error = pm_ops->prepare(PM_SUSPEND_DISK);
-			}
+			data->platform_suspend = 1;
+			error = 0;
 			break;
 
 		case PMOPS_ENTER:
-			kernel_shutdown_prepare(SYSTEM_SUSPEND_DISK);
-			error = pm_ops->enter(PM_SUSPEND_DISK);
+			if (data->platform_suspend) {
+				kernel_shutdown_prepare(SYSTEM_SUSPEND_DISK);
+				error = pm_ops->enter(PM_SUSPEND_DISK);
+				error = 0;
+			}
 			break;
 
 		case PMOPS_FINISH:
-			if (pm_ops && pm_ops->finish) {
-				pm_ops->finish(PM_SUSPEND_DISK);
-			}
+			if (data->platform_suspend)
+				error = 0;
+
 			break;
 
 		default:
 			printk(KERN_ERR "SNAPSHOT_PMOPS: invalid argument %ld\n", arg);
-			error = -EINVAL;
 
 		}
 		break;
_

Patches currently in -mm which might be from rjw@sisk.pl are

fix-swapped-parameters-in-mm-vmscanc.patch
shrink_all_memory-fix-lru_pages-handling.patch
git-acpi.patch
pm-change-code-ordering-in-mainc.patch
swsusp-change-code-ordering-in-diskc.patch
swsusp-change-code-ordering-in-userc.patch
swsusp-change-code-ordering-in-userc-sanity.patch
swsusp-change-pm_ops-handling-by-userland-interface.patch
shrink_slab-handle-bad-shrinkers.patch

