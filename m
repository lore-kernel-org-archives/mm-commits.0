From: akpm@osdl.org
Subject: - convert-pm_sem-to-a-mutex.patch removed from -mm tree
Date: Thu, 07 Dec 2006 14:59:42 -0800
Message-ID: <200612072259.kB7Mxgdk029543@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51069 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163695AbWLGW7w (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 17:59:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shemminger@osdl.org, mingo@elte.hu, pavel@ucw.cz, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     convert pm_sem to a mutex
has been removed from the -mm tree.  Its filename was
     convert-pm_sem-to-a-mutex.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: convert pm_sem to a mutex
From: Stephen Hemminger <shemminger@osdl.org>

The power management semaphore is only used as mutex, so convert it.

[akpm@osdl.org: fix rotten bug]
Signed-off-by: Stephen Hemminger <shemminger@osdl.org>
Acked-by: Ingo Molnar <mingo@elte.hu>
Acked-by: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/power/disk.c  |   16 ++++++++--------
 kernel/power/main.c  |   10 +++++-----
 kernel/power/power.h |    4 +++-
 kernel/power/user.c  |   24 ++++++++++++------------
 4 files changed, 28 insertions(+), 26 deletions(-)

diff -puN kernel/power/disk.c~convert-pm_sem-to-a-mutex kernel/power/disk.c
--- a/kernel/power/disk.c~convert-pm_sem-to-a-mutex
+++ a/kernel/power/disk.c
@@ -213,10 +213,10 @@ static int software_resume(void)
 {
 	int error;
 
-	down(&pm_sem);
+	mutex_lock(&pm_mutex);
 	if (!swsusp_resume_device) {
 		if (!strlen(resume_file)) {
-			up(&pm_sem);
+			mutex_unlock(&pm_mutex);
 			return -ENOENT;
 		}
 		swsusp_resume_device = name_to_dev_t(resume_file);
@@ -231,7 +231,7 @@ static int software_resume(void)
 		 * FIXME: If noresume is specified, we need to find the partition
 		 * and reset it back to normal swap space.
 		 */
-		up(&pm_sem);
+		mutex_unlock(&pm_mutex);
 		return 0;
 	}
 
@@ -275,7 +275,7 @@ static int software_resume(void)
 	unprepare_processes();
  Done:
 	/* For success case, the suspend path will release the lock */
-	up(&pm_sem);
+	mutex_unlock(&pm_mutex);
 	pr_debug("PM: Resume from disk failed.\n");
 	return 0;
 }
@@ -336,7 +336,7 @@ static ssize_t disk_store(struct subsyst
 	p = memchr(buf, '\n', n);
 	len = p ? p - buf : n;
 
-	down(&pm_sem);
+	mutex_lock(&pm_mutex);
 	for (i = PM_DISK_FIRMWARE; i < PM_DISK_MAX; i++) {
 		if (!strncmp(buf, pm_disk_modes[i], len)) {
 			mode = i;
@@ -360,7 +360,7 @@ static ssize_t disk_store(struct subsyst
 
 	pr_debug("PM: suspend-to-disk mode set to '%s'\n",
 		 pm_disk_modes[mode]);
-	up(&pm_sem);
+	mutex_unlock(&pm_mutex);
 	return error ? error : n;
 }
 
@@ -385,9 +385,9 @@ static ssize_t resume_store(struct subsy
 	if (maj != MAJOR(res) || min != MINOR(res))
 		goto out;
 
-	down(&pm_sem);
+	mutex_lock(&pm_mutex);
 	swsusp_resume_device = res;
-	up(&pm_sem);
+	mutex_unlock(&pm_mutex);
 	printk("Attempting manual resume\n");
 	noresume = 0;
 	software_resume();
diff -puN kernel/power/main.c~convert-pm_sem-to-a-mutex kernel/power/main.c
--- a/kernel/power/main.c~convert-pm_sem-to-a-mutex
+++ a/kernel/power/main.c
@@ -25,7 +25,7 @@
 /*This is just an arbitrary number */
 #define FREE_PAGE_NUMBER (100)
 
-DECLARE_MUTEX(pm_sem);
+DEFINE_MUTEX(pm_mutex);
 
 struct pm_ops *pm_ops;
 suspend_disk_method_t pm_disk_mode = PM_DISK_SHUTDOWN;
@@ -37,9 +37,9 @@ suspend_disk_method_t pm_disk_mode = PM_
 
 void pm_set_ops(struct pm_ops * ops)
 {
-	down(&pm_sem);
+	mutex_lock(&pm_mutex);
 	pm_ops = ops;
-	up(&pm_sem);
+	mutex_unlock(&pm_mutex);
 }
 
 
@@ -183,7 +183,7 @@ static int enter_state(suspend_state_t s
 
 	if (!valid_state(state))
 		return -ENODEV;
-	if (down_trylock(&pm_sem))
+	if (!mutex_trylock(&pm_mutex))
 		return -EBUSY;
 
 	if (state == PM_SUSPEND_DISK) {
@@ -201,7 +201,7 @@ static int enter_state(suspend_state_t s
 	pr_debug("PM: Finishing wakeup.\n");
 	suspend_finish(state);
  Unlock:
-	up(&pm_sem);
+	mutex_unlock(&pm_mutex);
 	return error;
 }
 
diff -puN kernel/power/power.h~convert-pm_sem-to-a-mutex kernel/power/power.h
--- a/kernel/power/power.h~convert-pm_sem-to-a-mutex
+++ a/kernel/power/power.h
@@ -22,7 +22,9 @@ static inline int pm_suspend_disk(void)
 	return -EPERM;
 }
 #endif
-extern struct semaphore pm_sem;
+
+extern struct mutex pm_mutex;
+
 #define power_attr(_name) \
 static struct subsys_attribute _name##_attr = {	\
 	.attr	= {				\
diff -puN kernel/power/user.c~convert-pm_sem-to-a-mutex kernel/power/user.c
--- a/kernel/power/user.c~convert-pm_sem-to-a-mutex
+++ a/kernel/power/user.c
@@ -79,10 +79,10 @@ static int snapshot_release(struct inode
 	free_all_swap_pages(data->swap, data->bitmap);
 	free_bitmap(data->bitmap);
 	if (data->frozen) {
-		down(&pm_sem);
+		mutex_lock(&pm_mutex);
 		thaw_processes();
 		enable_nonboot_cpus();
-		up(&pm_sem);
+		mutex_unlock(&pm_mutex);
 	}
 	atomic_inc(&device_available);
 	return 0;
@@ -144,7 +144,7 @@ static int snapshot_ioctl(struct inode *
 	case SNAPSHOT_FREEZE:
 		if (data->frozen)
 			break;
-		down(&pm_sem);
+		mutex_lock(&pm_mutex);
 		error = disable_nonboot_cpus();
 		if (!error) {
 			error = freeze_processes();
@@ -154,7 +154,7 @@ static int snapshot_ioctl(struct inode *
 				error = -EBUSY;
 			}
 		}
-		up(&pm_sem);
+		mutex_unlock(&pm_mutex);
 		if (!error)
 			data->frozen = 1;
 		break;
@@ -162,10 +162,10 @@ static int snapshot_ioctl(struct inode *
 	case SNAPSHOT_UNFREEZE:
 		if (!data->frozen)
 			break;
-		down(&pm_sem);
+		mutex_lock(&pm_mutex);
 		thaw_processes();
 		enable_nonboot_cpus();
-		up(&pm_sem);
+		mutex_unlock(&pm_mutex);
 		data->frozen = 0;
 		break;
 
@@ -174,7 +174,7 @@ static int snapshot_ioctl(struct inode *
 			error = -EPERM;
 			break;
 		}
-		down(&pm_sem);
+		mutex_lock(&pm_mutex);
 		/* Free memory before shutting down devices. */
 		error = swsusp_shrink_memory();
 		if (!error) {
@@ -187,7 +187,7 @@ static int snapshot_ioctl(struct inode *
 			}
 			resume_console();
 		}
-		up(&pm_sem);
+		mutex_unlock(&pm_mutex);
 		if (!error)
 			error = put_user(in_suspend, (unsigned int __user *)arg);
 		if (!error)
@@ -201,7 +201,7 @@ static int snapshot_ioctl(struct inode *
 			error = -EPERM;
 			break;
 		}
-		down(&pm_sem);
+		mutex_lock(&pm_mutex);
 		pm_prepare_console();
 		suspend_console();
 		error = device_suspend(PMSG_PRETHAW);
@@ -211,7 +211,7 @@ static int snapshot_ioctl(struct inode *
 		}
 		resume_console();
 		pm_restore_console();
-		up(&pm_sem);
+		mutex_unlock(&pm_mutex);
 		break;
 
 	case SNAPSHOT_FREE:
@@ -286,7 +286,7 @@ static int snapshot_ioctl(struct inode *
 			break;
 		}
 
-		if (down_trylock(&pm_sem)) {
+		if (!mutex_trylock(&pm_mutex)) {
 			error = -EBUSY;
 			break;
 		}
@@ -314,7 +314,7 @@ static int snapshot_ioctl(struct inode *
 			pm_ops->finish(PM_SUSPEND_MEM);
 
 OutS3:
-		up(&pm_sem);
+		mutex_unlock(&pm_mutex);
 		break;
 
 	case SNAPSHOT_PMOPS:
_

Patches currently in -mm which might be from shemminger@osdl.org are

origin.patch

