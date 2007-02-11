From: akpm@linux-foundation.org
Subject: - swsusp-change-pm_ops-handling-by-userland-interface.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:47:27 -0800
Message-ID: <200702112247.l1BMlRfa015551@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59654 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932636AbXBKWr5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:47:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, greg@kroah.com, mochel@digitalimplant.org, nigel@suspend2.net, pavel@ucw.cz, mm-commits@vger.kernel.org


The patch titled
     swsusp: Change pm_ops handling by userland interface
has been removed from the -mm tree.  Its filename was
     swsusp-change-pm_ops-handling-by-userland-interface.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/power/user.c |   71 ++++++++++++++++++++++++++++++++++--------
 1 file changed, 59 insertions(+), 12 deletions(-)

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
@@ -122,7 +124,23 @@ static ssize_t snapshot_write(struct fil
 	return res;
 }
 
-static int snapshot_suspend(void)
+static inline int platform_prepare(void)
+{
+	int error = 0;
+
+	if (pm_ops && pm_ops->prepare)
+		error = pm_ops->prepare(PM_SUSPEND_DISK);
+
+	return error;
+}
+
+static inline void platform_finish(void)
+{
+	if (pm_ops && pm_ops->finish)
+		pm_ops->finish(PM_SUSPEND_DISK);
+}
+
+static inline int snapshot_suspend(int platform_suspend)
 {
 	int error;
 
@@ -132,6 +150,11 @@ static int snapshot_suspend(void)
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
@@ -144,6 +167,9 @@ static int snapshot_suspend(void)
 	}
 	enable_nonboot_cpus();
  Resume_devices:
+	if (platform_suspend)
+		platform_finish();
+
 	device_resume();
 	resume_console();
  Finish:
@@ -151,12 +177,17 @@ static int snapshot_suspend(void)
 	return error;
 }
 
-static int snapshot_restore(void)
+static inline int snapshot_restore(int platform_suspend)
 {
 	int error;
 
 	mutex_lock(&pm_mutex);
 	pm_prepare_console();
+	if (platform_suspend) {
+		error = platform_prepare();
+		if (error)
+			goto Finish;
+	}
 	suspend_console();
 	error = device_suspend(PMSG_PRETHAW);
 	if (error)
@@ -168,8 +199,12 @@ static int snapshot_restore(void)
 
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
@@ -221,7 +256,7 @@ static int snapshot_ioctl(struct inode *
 			error = -EPERM;
 			break;
 		}
-		error = snapshot_suspend();
+		error = snapshot_suspend(data->platform_suspend);
 		if (!error)
 			error = put_user(in_suspend, (unsigned int __user *)arg);
 		if (!error)
@@ -235,7 +270,7 @@ static int snapshot_ioctl(struct inode *
 			error = -EPERM;
 			break;
 		}
-		error = snapshot_restore();
+		error = snapshot_restore(data->platform_suspend);
 		break;
 
 	case SNAPSHOT_FREE:
@@ -306,6 +341,11 @@ static int snapshot_ioctl(struct inode *
 		break;
 
 	case SNAPSHOT_S2RAM:
+		if (!pm_ops) {
+			error = -ENOSYS;
+			break;
+		}
+
 		if (!data->frozen) {
 			error = -EPERM;
 			break;
@@ -343,28 +383,35 @@ static int snapshot_ioctl(struct inode *
 		break;
 
 	case SNAPSHOT_PMOPS:
+		error = -EINVAL;
+
 		switch (arg) {
 
 		case PMOPS_PREPARE:
-			if (pm_ops->prepare) {
-				error = pm_ops->prepare(PM_SUSPEND_DISK);
+			if (pm_ops && pm_ops->enter) {
+				data->platform_suspend = 1;
+				error = 0;
+			} else {
+				error = -ENOSYS;
 			}
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

origin.patch
shrink_slab-handle-bad-shrinkers.patch
