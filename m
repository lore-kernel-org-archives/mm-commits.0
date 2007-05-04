From: akpm@linux-foundation.org
Subject: + power-management-use-mutexes-instead-of-semaphores.patch added to -mm tree
Date: Thu, 03 May 2007 22:50:14 -0700
Message-ID: <200705040550.l445oErR030063@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:41031 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767694AbXEDFuS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 May 2007 01:50:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: matthias.kaehlcke@gmail.com


The patch titled
     Power Management: use mutexes instead of semaphores
has been added to the -mm tree.  Its filename is
     power-management-use-mutexes-instead-of-semaphores.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Power Management: use mutexes instead of semaphores
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

The Power Management code uses semaphores as mutexes.  Use the mutex API
instead of the (binary) semaphores.

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/power/main.c    |   12 ++++++------
 drivers/base/power/power.h   |    4 ++--
 drivers/base/power/resume.c  |   12 ++++++------
 drivers/base/power/runtime.c |   12 ++++++------
 drivers/base/power/suspend.c |   14 +++++++-------
 5 files changed, 27 insertions(+), 27 deletions(-)

diff -puN drivers/base/power/main.c~power-management-use-mutexes-instead-of-semaphores drivers/base/power/main.c
--- a/drivers/base/power/main.c~power-management-use-mutexes-instead-of-semaphores
+++ a/drivers/base/power/main.c
@@ -26,8 +26,8 @@ LIST_HEAD(dpm_active);
 LIST_HEAD(dpm_off);
 LIST_HEAD(dpm_off_irq);
 
-DECLARE_MUTEX(dpm_sem);
-DECLARE_MUTEX(dpm_list_sem);
+DEFINE_MUTEX(dpm_mtx);
+DEFINE_MUTEX(dpm_list_mtx);
 
 int (*platform_enable_wakeup)(struct device *dev, int is_on);
 
@@ -59,12 +59,12 @@ int device_pm_add(struct device * dev)
 	pr_debug("PM: Adding info for %s:%s\n",
 		 dev->bus ? dev->bus->name : "No Bus",
 		 kobject_name(&dev->kobj));
-	down(&dpm_list_sem);
+	mutex_lock(&dpm_list_mtx);
 	list_add_tail(&dev->power.entry, &dpm_active);
 	device_pm_set_parent(dev, dev->parent);
 	if ((error = dpm_sysfs_add(dev)))
 		list_del(&dev->power.entry);
-	up(&dpm_list_sem);
+	mutex_unlock(&dpm_list_mtx);
 	return error;
 }
 
@@ -73,11 +73,11 @@ void device_pm_remove(struct device * de
 	pr_debug("PM: Removing info for %s:%s\n",
 		 dev->bus ? dev->bus->name : "No Bus",
 		 kobject_name(&dev->kobj));
-	down(&dpm_list_sem);
+	mutex_lock(&dpm_list_mtx);
 	dpm_sysfs_remove(dev);
 	put_device(dev->power.pm_parent);
 	list_del_init(&dev->power.entry);
-	up(&dpm_list_sem);
+	mutex_unlock(&dpm_list_mtx);
 }
 
 
diff -puN drivers/base/power/power.h~power-management-use-mutexes-instead-of-semaphores drivers/base/power/power.h
--- a/drivers/base/power/power.h~power-management-use-mutexes-instead-of-semaphores
+++ a/drivers/base/power/power.h
@@ -14,12 +14,12 @@ extern void device_shutdown(void);
 /*
  * Used to synchronize global power management operations.
  */
-extern struct semaphore dpm_sem;
+extern struct mutex dpm_mtx;
 
 /*
  * Used to serialize changes to the dpm_* lists.
  */
-extern struct semaphore dpm_list_sem;
+extern struct mutex dpm_list_mtx;
 
 /*
  * The PM lists.
diff -puN drivers/base/power/resume.c~power-management-use-mutexes-instead-of-semaphores drivers/base/power/resume.c
--- a/drivers/base/power/resume.c~power-management-use-mutexes-instead-of-semaphores
+++ a/drivers/base/power/resume.c
@@ -80,7 +80,7 @@ static int resume_device_early(struct de
  */
 void dpm_resume(void)
 {
-	down(&dpm_list_sem);
+	mutex_lock(&dpm_list_mtx);
 	while(!list_empty(&dpm_off)) {
 		struct list_head * entry = dpm_off.next;
 		struct device * dev = to_device(entry);
@@ -88,13 +88,13 @@ void dpm_resume(void)
 		get_device(dev);
 		list_move_tail(entry, &dpm_active);
 
-		up(&dpm_list_sem);
+		mutex_unlock(&dpm_list_mtx);
 		if (!dev->power.prev_state.event)
 			resume_device(dev);
-		down(&dpm_list_sem);
+		mutex_lock(&dpm_list_mtx);
 		put_device(dev);
 	}
-	up(&dpm_list_sem);
+	mutex_unlock(&dpm_list_mtx);
 }
 
 
@@ -108,9 +108,9 @@ void dpm_resume(void)
 void device_resume(void)
 {
 	might_sleep();
-	down(&dpm_sem);
+	mutex_lock(&dpm_mtx);
 	dpm_resume();
-	up(&dpm_sem);
+	mutex_unlock(&dpm_mtx);
 }
 
 EXPORT_SYMBOL_GPL(device_resume);
diff -puN drivers/base/power/runtime.c~power-management-use-mutexes-instead-of-semaphores drivers/base/power/runtime.c
--- a/drivers/base/power/runtime.c~power-management-use-mutexes-instead-of-semaphores
+++ a/drivers/base/power/runtime.c
@@ -32,9 +32,9 @@ static void runtime_resume(struct device
 
 void dpm_runtime_resume(struct device * dev)
 {
-	down(&dpm_sem);
+	mutex_lock(&dpm_mtx);
 	runtime_resume(dev);
-	up(&dpm_sem);
+	mutex_unlock(&dpm_mtx);
 }
 EXPORT_SYMBOL(dpm_runtime_resume);
 
@@ -49,7 +49,7 @@ int dpm_runtime_suspend(struct device * 
 {
 	int error = 0;
 
-	down(&dpm_sem);
+	mutex_lock(&dpm_mtx);
 	if (dev->power.power_state.event == state.event)
 		goto Done;
 
@@ -59,7 +59,7 @@ int dpm_runtime_suspend(struct device * 
 	if (!(error = suspend_device(dev, state)))
 		dev->power.power_state = state;
  Done:
-	up(&dpm_sem);
+	mutex_unlock(&dpm_mtx);
 	return error;
 }
 EXPORT_SYMBOL(dpm_runtime_suspend);
@@ -78,8 +78,8 @@ EXPORT_SYMBOL(dpm_runtime_suspend);
  */
 void dpm_set_power_state(struct device * dev, pm_message_t state)
 {
-	down(&dpm_sem);
+	mutex_lock(&dpm_mtx);
 	dev->power.power_state = state;
-	up(&dpm_sem);
+	mutex_unlock(&dpm_mtx);
 }
 #endif  /*  0  */
diff -puN drivers/base/power/suspend.c~power-management-use-mutexes-instead-of-semaphores drivers/base/power/suspend.c
--- a/drivers/base/power/suspend.c~power-management-use-mutexes-instead-of-semaphores
+++ a/drivers/base/power/suspend.c
@@ -108,7 +108,7 @@ int suspend_device(struct device * dev, 
 
 /*
  * This is called with interrupts off, only a single CPU
- * running. We can't do down() on a semaphore (and we don't
+ * running. We can't acquire a mutex or semaphore (and we don't
  * need the protection)
  */
 static int suspend_device_late(struct device *dev, pm_message_t state)
@@ -153,18 +153,18 @@ int device_suspend(pm_message_t state)
 	int error = 0;
 
 	might_sleep();
-	down(&dpm_sem);
-	down(&dpm_list_sem);
+	mutex_lock(&dpm_mtx);
+	mutex_lock(&dpm_list_mtx);
 	while (!list_empty(&dpm_active) && error == 0) {
 		struct list_head * entry = dpm_active.prev;
 		struct device * dev = to_device(entry);
 
 		get_device(dev);
-		up(&dpm_list_sem);
+		mutex_unlock(&dpm_list_mtx);
 
 		error = suspend_device(dev, state);
 
-		down(&dpm_list_sem);
+		mutex_lock(&dpm_list_mtx);
 
 		/* Check if the device got removed */
 		if (!list_empty(&dev->power.entry)) {
@@ -179,11 +179,11 @@ int device_suspend(pm_message_t state)
 				error == -EAGAIN ? " (please convert to suspend_late)" : "");
 		put_device(dev);
 	}
-	up(&dpm_list_sem);
+	mutex_unlock(&dpm_list_mtx);
 	if (error)
 		dpm_resume();
 
-	up(&dpm_sem);
+	mutex_unlock(&dpm_mtx);
 	return error;
 }
 
_

Patches currently in -mm which might be from matthias.kaehlcke@gmail.com are

origin.patch
include-kern_-constant-in-printk-calls-in-mm-slabc.patch
srmcons-fix-kmallocgfp_kernel-inside-spinlock.patch
power-management-use-mutexes-instead-of-semaphores.patch
sysdev-use-mutex-instead-of-semaphore.patch
git-dvb.patch
use-mutex-instead-of-binary-semaphore-in-idt77252-driver.patch
qla1280-use-dma_64bit_mask-instead-of-0ull.patch
use-mutex-instead-of-binary-semaphore-in-cdu-31a-driver.patch
use-mutex-instead-of-semaphore-in-sbpcd-driver.patch
use-mutex-instead-of-semaphore-in-berkshire-usb-pc-watchdog-driver.patch
use-mutex-instead-of-semaphore-in-rocketport-driver.patch
use-mutex-instead-of-semaphore-in-tpm-driver.patch
use-mutex-instead-of-semaphore-in-hdaps-driver.patch
use-mutex-instead-of-semaphore-for-misc-char-devices.patch
fix-spinlock-usage-in-hysdn_log_close.patch
use-mutex-instead-of-semaphore-in-capi-20-interface.patch
use-mutex-instead-of-semaphore-in-virtual-console-driver.patch
kcopyd-use-mutex-instead-of-semaphore.patch
pvrusb2-use-mutex-instead-of-semaphore.patch
scx200-use-mutex-instead-of-semaphore.patch
