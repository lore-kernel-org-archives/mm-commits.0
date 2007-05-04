From: akpm@linux-foundation.org
Subject: + sysdev-use-mutex-instead-of-semaphore.patch added to -mm tree
Date: Thu, 03 May 2007 22:50:20 -0700
Message-ID: <200705040550.l445oKkM030067@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:54053 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767694AbXEDFuZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 May 2007 01:50:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: matthias.kaehlcke@gmail.com


The patch titled
     sysdev: use mutex instead of semaphore
has been added to the -mm tree.  Its filename is
     sysdev-use-mutex-instead-of-semaphore.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sysdev: use mutex instead of semaphore
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

The sysdev code use a semaphore as mutex.  Use the mutex API instead of the
(binary) semaphore.

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/sys.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff -puN drivers/base/sys.c~sysdev-use-mutex-instead-of-semaphore drivers/base/sys.c
--- a/drivers/base/sys.c~sysdev-use-mutex-instead-of-semaphore
+++ a/drivers/base/sys.c
@@ -155,7 +155,7 @@ EXPORT_SYMBOL_GPL(sysdev_class_unregiste
 
 
 static LIST_HEAD(sysdev_drivers);
-static DECLARE_MUTEX(sysdev_drivers_lock);
+static DEFINE_MUTEX(sysdev_drivers_lock);
 
 /**
  *	sysdev_driver_register - Register auxillary driver
@@ -172,7 +172,7 @@ static DECLARE_MUTEX(sysdev_drivers_lock
 int sysdev_driver_register(struct sysdev_class * cls,
 			   struct sysdev_driver * drv)
 {
-	down(&sysdev_drivers_lock);
+	mutex_lock(&sysdev_drivers_lock);
 	if (cls && kset_get(&cls->kset)) {
 		list_add_tail(&drv->entry, &cls->drivers);
 
@@ -184,7 +184,7 @@ int sysdev_driver_register(struct sysdev
 		}
 	} else
 		list_add_tail(&drv->entry, &sysdev_drivers);
-	up(&sysdev_drivers_lock);
+	mutex_unlock(&sysdev_drivers_lock);
 	return 0;
 }
 
@@ -197,7 +197,7 @@ int sysdev_driver_register(struct sysdev
 void sysdev_driver_unregister(struct sysdev_class * cls,
 			      struct sysdev_driver * drv)
 {
-	down(&sysdev_drivers_lock);
+	mutex_lock(&sysdev_drivers_lock);
 	list_del_init(&drv->entry);
 	if (cls) {
 		if (drv->remove) {
@@ -207,7 +207,7 @@ void sysdev_driver_unregister(struct sys
 		}
 		kset_put(&cls->kset);
 	}
-	up(&sysdev_drivers_lock);
+	mutex_unlock(&sysdev_drivers_lock);
 }
 
 EXPORT_SYMBOL_GPL(sysdev_driver_register);
@@ -246,7 +246,7 @@ int sysdev_register(struct sys_device * 
 	if (!error) {
 		struct sysdev_driver * drv;
 
-		down(&sysdev_drivers_lock);
+		mutex_lock(&sysdev_drivers_lock);
 		/* Generic notification is implicit, because it's that
 		 * code that should have called us.
 		 */
@@ -262,7 +262,7 @@ int sysdev_register(struct sys_device * 
 			if (drv->add)
 				drv->add(sysdev);
 		}
-		up(&sysdev_drivers_lock);
+		mutex_unlock(&sysdev_drivers_lock);
 	}
 	return error;
 }
@@ -271,7 +271,7 @@ void sysdev_unregister(struct sys_device
 {
 	struct sysdev_driver * drv;
 
-	down(&sysdev_drivers_lock);
+	mutex_lock(&sysdev_drivers_lock);
 	list_for_each_entry(drv, &sysdev_drivers, entry) {
 		if (drv->remove)
 			drv->remove(sysdev);
@@ -281,7 +281,7 @@ void sysdev_unregister(struct sys_device
 		if (drv->remove)
 			drv->remove(sysdev);
 	}
-	up(&sysdev_drivers_lock);
+	mutex_unlock(&sysdev_drivers_lock);
 
 	kobject_unregister(&sysdev->kobj);
 }
@@ -308,7 +308,7 @@ void sysdev_shutdown(void)
 
 	pr_debug("Shutting Down System Devices\n");
 
-	down(&sysdev_drivers_lock);
+	mutex_lock(&sysdev_drivers_lock);
 	list_for_each_entry_reverse(cls, &system_subsys.kset.list,
 				    kset.kobj.entry) {
 		struct sys_device * sysdev;
@@ -337,7 +337,7 @@ void sysdev_shutdown(void)
 				cls->shutdown(sysdev);
 		}
 	}
-	up(&sysdev_drivers_lock);
+	mutex_unlock(&sysdev_drivers_lock);
 }
 
 static void __sysdev_resume(struct sys_device *dev)
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
