From: akpm@linux-foundation.org
Subject: - sysdev-use-mutex-instead-of-semaphore.patch removed from -mm tree
Date: Tue, 05 Jun 2007 00:10:28 -0700
Message-ID: <200706050710.l557AQeh031268@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43127 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763189AbXFEHKh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Jun 2007 03:10:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matthias.kaehlcke@gmail.com, mm-commits@vger.kernel.org


The patch titled
     sysdev: use mutex instead of semaphore
has been removed from the -mm tree.  Its filename was
     sysdev-use-mutex-instead-of-semaphore.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sysdev: use mutex instead of semaphore
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

The sysdev code use a semaphore as mutex.  Use the mutex API instead of the
(binary) semaphore.

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/sys.c |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff -puN drivers/base/sys.c~sysdev-use-mutex-instead-of-semaphore drivers/base/sys.c
--- a/drivers/base/sys.c~sysdev-use-mutex-instead-of-semaphore
+++ a/drivers/base/sys.c
@@ -21,7 +21,7 @@
 #include <linux/string.h>
 #include <linux/pm.h>
 #include <linux/device.h>
-#include <asm/semaphore.h>
+#include <linux/mutex.h>
 
 #include "base.h"
 
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
 	list_for_each_entry_reverse(cls, &system_subsys.list,
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

kcopyd-use-mutex-instead-of-semaphore.patch
use-mutex-instead-of-semaphore-in-the-mtd-st-m25pxx-driver.patch
use-mutex-instead-of-semaphore-in-the-mtd-dataflash-driver.patch
git-netdev-all.patch
use-mutex-instead-of-binary-semaphore-in-cdu-31a-driver.patch
use-mutex-instead-of-semaphore-in-sbpcd-driver.patch
block-device-elevator-use-list_for_each_entry-instead-of-list_for_each.patch
drivers-block-ubc-use-list_for_each_entry.patch
use-list_for_each_entry-for-iteration-in-prism-54-driver.patch
use-mutexes-instead-of-semaphores-in-i2o-driver.patch
fs-block_devc-use-list_for_each_entry.patch
use-mutex-instead-of-semaphore-in-capi-20-driver.patch
