From: akpm@linux-foundation.org
Subject: - swsusp-change-code-ordering-in-userc.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:47:21 -0800
Message-ID: <200702112247.l1BMlLXM015545@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59656 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932640AbXBKWr5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:47:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, greg@kroah.com, mochel@digitalimplant.org, nigel@suspend2.net, pavel@ucw.cz, mm-commits@vger.kernel.org


The patch titled
     swsusp: Change code ordering in user.c
has been removed from the -mm tree.  Its filename was
     swsusp-change-code-ordering-in-userc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: swsusp: Change code ordering in user.c
From: "Rafael J. Wysocki" <rjw@sisk.pl>

Change the ordering of code in kernel/power/user.c so that device_suspend() is
called before disable_nonboot_cpus() and device_resume() is called after
enable_nonboot_cpus().  This is needed to make the userland suspend call
pm_ops->finish() after enable_nonboot_cpus() and before device_resume(), as
indicated by the recent discussion on Linux-PM (cf. 
http://lists.osdl.org/pipermail/linux-pm/2006-November/004164.html).

The changes here only affect the userland interface of swsusp.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
Cc: Greg KH <greg@kroah.com>
Cc: Nigel Cunningham <nigel@suspend2.net>
Cc: Patrick Mochel <mochel@digitalimplant.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/power/user.c |   92 ++++++++++++++++++++++++++----------------
 1 file changed, 58 insertions(+), 34 deletions(-)

diff -puN kernel/power/user.c~swsusp-change-code-ordering-in-userc kernel/power/user.c
--- a/kernel/power/user.c~swsusp-change-code-ordering-in-userc
+++ a/kernel/power/user.c
@@ -122,6 +122,59 @@ static ssize_t snapshot_write(struct fil
 	return res;
 }
 
+static inline int snapshot_suspend(void)
+{
+	int error;
+
+	mutex_lock(&pm_mutex);
+	/* Free memory before shutting down devices. */
+	error = swsusp_shrink_memory();
+	if (error)
+		goto Finish;
+
+	suspend_console();
+	error = device_suspend(PMSG_FREEZE);
+	if (error)
+		goto Resume_devices;
+
+	error = disable_nonboot_cpus();
+	if (!error) {
+		in_suspend = 1;
+		error = swsusp_suspend();
+	}
+	enable_nonboot_cpus();
+ Resume_devices:
+	device_resume();
+	resume_console();
+ Finish:
+	mutex_unlock(&pm_mutex);
+	return error;
+}
+
+static inline int snapshot_restore(void)
+{
+	int error;
+
+	mutex_lock(&pm_mutex);
+	pm_prepare_console();
+	suspend_console();
+	error = device_suspend(PMSG_PRETHAW);
+	if (error)
+		goto Resume_devices;
+
+	error = disable_nonboot_cpus();
+	if (!error)
+		error = swsusp_resume();
+
+	enable_nonboot_cpus();
+ Resume_devices:
+	device_resume();
+	resume_console();
+	pm_restore_console();
+	mutex_unlock(&pm_mutex);
+	return error;
+}
+
 static int snapshot_ioctl(struct inode *inode, struct file *filp,
                           unsigned int cmd, unsigned long arg)
 {
@@ -145,14 +198,9 @@ static int snapshot_ioctl(struct inode *
 		if (data->frozen)
 			break;
 		mutex_lock(&pm_mutex);
-		error = disable_nonboot_cpus();
-		if (!error) {
-			error = freeze_processes();
-			if (error) {
-				thaw_processes();
-				enable_nonboot_cpus();
-				error = -EBUSY;
-			}
+		if (freeze_processes()) {
+			thaw_processes();
+			error = -EBUSY;
 		}
 		mutex_unlock(&pm_mutex);
 		if (!error)
@@ -164,7 +212,6 @@ static int snapshot_ioctl(struct inode *
 			break;
 		mutex_lock(&pm_mutex);
 		thaw_processes();
-		enable_nonboot_cpus();
 		mutex_unlock(&pm_mutex);
 		data->frozen = 0;
 		break;
@@ -174,20 +221,7 @@ static int snapshot_ioctl(struct inode *
 			error = -EPERM;
 			break;
 		}
-		mutex_lock(&pm_mutex);
-		/* Free memory before shutting down devices. */
-		error = swsusp_shrink_memory();
-		if (!error) {
-			suspend_console();
-			error = device_suspend(PMSG_FREEZE);
-			if (!error) {
-				in_suspend = 1;
-				error = swsusp_suspend();
-				device_resume();
-			}
-			resume_console();
-		}
-		mutex_unlock(&pm_mutex);
+		error = snapshot_suspend();
 		if (!error)
 			error = put_user(in_suspend, (unsigned int __user *)arg);
 		if (!error)
@@ -201,17 +235,7 @@ static int snapshot_ioctl(struct inode *
 			error = -EPERM;
 			break;
 		}
-		mutex_lock(&pm_mutex);
-		pm_prepare_console();
-		suspend_console();
-		error = device_suspend(PMSG_PRETHAW);
-		if (!error) {
-			error = swsusp_resume();
-			device_resume();
-		}
-		resume_console();
-		pm_restore_console();
-		mutex_unlock(&pm_mutex);
+		error = snapshot_restore();
 		break;
 
 	case SNAPSHOT_FREE:
_

Patches currently in -mm which might be from rjw@sisk.pl are

origin.patch
shrink_slab-handle-bad-shrinkers.patch
