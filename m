From: akpm@linux-foundation.org
Subject: - create-sys-power-when-config_pm-is-set.patch removed from -mm tree
Date: Mon, 26 Nov 2007 13:48:23 -0800
Message-ID: <200711262148.lAQLmNnH024593@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50236 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755021AbXKZVt0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Nov 2007 16:49:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dsd@gentoo.org, greg@kroah.com, kay.sievers@vrfy.org, rjw@sisk.pl, stable@kernel.org, stern@rowland.harvard.edu, mm-commits@vger.kernel.org


The patch titled
     create /sys/.../power when CONFIG_PM is set
has been removed from the -mm tree.  Its filename was
     create-sys-power-when-config_pm-is-set.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: create /sys/.../power when CONFIG_PM is set
From: Daniel Drake <dsd@gentoo.org>

The CONFIG_SUSPEND changes in 2.6.23 caused a regression under certain
configuration conditions (SUSPEND=n, USB_AUTOSUSPEND=y) where all USB
device attributes in sysfs (idVendor, idProduct, ...) silently disappeared,
causing udev breakage and more.

The cause of this is that the /sys/.../power subdirectory is now only
created when CONFIG_PM_SLEEP is set, however, it should be created whenever
CONFIG_PM is set to handle the above situation.  The following patch fixes
the regression.

Signed-off-by: Daniel Drake <dsd@gentoo.org>
Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <greg@kroah.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/core.c         |    4 ++-
 drivers/base/power/Makefile |    3 +-
 drivers/base/power/main.c   |    8 ------
 drivers/base/power/power.h  |   40 ++++++++++++++++++++++------------
 4 files changed, 33 insertions(+), 22 deletions(-)

diff -puN drivers/base/core.c~create-sys-power-when-config_pm-is-set drivers/base/core.c
--- a/drivers/base/core.c~create-sys-power-when-config_pm-is-set
+++ a/drivers/base/core.c
@@ -785,9 +785,10 @@ int device_add(struct device *dev)
 	error = device_add_attrs(dev);
 	if (error)
 		goto AttrsError;
-	error = device_pm_add(dev);
+	error = dpm_sysfs_add(dev);
 	if (error)
 		goto PMError;
+	device_pm_add(dev);
 	error = bus_add_device(dev);
 	if (error)
 		goto BusError;
@@ -813,6 +814,7 @@ int device_add(struct device *dev)
 	return error;
  BusError:
 	device_pm_remove(dev);
+	dpm_sysfs_remove(dev);
  PMError:
 	if (dev->bus)
 		blocking_notifier_call_chain(&dev->bus->p->bus_notifier,
diff -puN drivers/base/power/Makefile~create-sys-power-when-config_pm-is-set drivers/base/power/Makefile
--- a/drivers/base/power/Makefile~create-sys-power-when-config_pm-is-set
+++ a/drivers/base/power/Makefile
@@ -1,5 +1,6 @@
 obj-y			:= shutdown.o
-obj-$(CONFIG_PM_SLEEP)	+= main.o sysfs.o
+obj-$(CONFIG_PM)	+= sysfs.o
+obj-$(CONFIG_PM_SLEEP)	+= main.o
 obj-$(CONFIG_PM_TRACE_RTC)	+= trace.o
 
 ifeq ($(CONFIG_DEBUG_DRIVER),y)
diff -puN drivers/base/power/main.c~create-sys-power-when-config_pm-is-set drivers/base/power/main.c
--- a/drivers/base/power/main.c~create-sys-power-when-config_pm-is-set
+++ a/drivers/base/power/main.c
@@ -59,20 +59,14 @@ static DECLARE_RWSEM(pm_sleep_rwsem);
 int (*platform_enable_wakeup)(struct device *dev, int is_on);
 
 
-int device_pm_add(struct device *dev)
+void device_pm_add(struct device *dev)
 {
-	int error;
-
 	pr_debug("PM: Adding info for %s:%s\n",
 		 dev->bus ? dev->bus->name : "No Bus",
 		 kobject_name(&dev->kobj));
 	mutex_lock(&dpm_list_mtx);
 	list_add_tail(&dev->power.entry, &dpm_active);
-	error = dpm_sysfs_add(dev);
-	if (error)
-		list_del(&dev->power.entry);
 	mutex_unlock(&dpm_list_mtx);
-	return error;
 }
 
 void device_pm_remove(struct device *dev)
diff -puN drivers/base/power/power.h~create-sys-power-when-config_pm-is-set drivers/base/power/power.h
--- a/drivers/base/power/power.h~create-sys-power-when-config_pm-is-set
+++ a/drivers/base/power/power.h
@@ -13,31 +13,23 @@ extern void device_shutdown(void);
 
 extern struct list_head dpm_active;	/* The active device list */
 
-static inline struct device * to_device(struct list_head * entry)
+static inline struct device *to_device(struct list_head *entry)
 {
 	return container_of(entry, struct device, power.entry);
 }
 
-extern int device_pm_add(struct device *);
+extern void device_pm_add(struct device *);
 extern void device_pm_remove(struct device *);
 extern int pm_sleep_lock(void);
 extern void pm_sleep_unlock(void);
 
-/*
- * sysfs.c
- */
-
-extern int dpm_sysfs_add(struct device *);
-extern void dpm_sysfs_remove(struct device *);
-
 #else /* CONFIG_PM_SLEEP */
 
-
-static inline int device_pm_add(struct device * dev)
+static inline void device_pm_add(struct device *dev)
 {
-	return 0;
 }
-static inline void device_pm_remove(struct device * dev)
+
+static inline void device_pm_remove(struct device *dev)
 {
 }
 
@@ -51,3 +43,25 @@ static inline void pm_sleep_unlock(void)
 }
 
 #endif
+
+#ifdef CONFIG_PM
+
+/*
+ * sysfs.c
+ */
+
+extern int dpm_sysfs_add(struct device *);
+extern void dpm_sysfs_remove(struct device *);
+
+#else /* CONFIG_PM */
+
+static inline int dpm_sysfs_add(struct device *dev)
+{
+	return 0;
+}
+
+static inline void dpm_sysfs_remove(struct device *dev)
+{
+}
+
+#endif
_

Patches currently in -mm which might be from dsd@gentoo.org are

git-wireless.patch
