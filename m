From: akpm@linux-foundation.org
Subject: - pm-export-device_pm_schedule_removal.patch removed from -mm tree
Date: Mon, 28 Jan 2008 17:50:25 -0800
Message-ID: <200801290150.m0T1oPCx027568@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33660 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756715AbYA2CBS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Jan 2008 21:01:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, greg@kroah.com, kay.sievers@vrfy.org, lenb@kernel.org, linville@tuxdriver.com, mb@bu3sch.de, pavel@ucw.cz, rpurdie@rpsys.net, stern@rowland.harvard.edu, mm-commits@vger.kernel.org


The patch titled
     PM: export device_pm_schedule_removal
has been removed from the -mm tree.  Its filename was
     pm-export-device_pm_schedule_removal.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: PM: export device_pm_schedule_removal
From: Rafael J. Wysocki <rjw@sisk.pl>

The following series of patches is intended to fix the suspend/resume deadlock
occuring as a result of unregistering device objects, locked by the PM core,
during suspend/resume cycles by the b43 driver.

In short, the b43 driver is modified to avoid unregistering device objects
during suspend/resume cycles except for the resume code path, in which the
devices are unregistered using the recently introduced suspend-safe method. 
For this purpose, it is necessary to introduce the possibility to safely
remove misc devices, leds classdevs and hwrng devices during suspend/resume
cycles (patches 2/5, 4/5, 3/5, respectively).


This patch:

Move the declaration of device_pm_schedule_removal() to device.h and make it
exported, as it will be used directly by some drivers for unregistering device
objects during suspend/resume cycles in a safe way.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Michael Buesch <mb@bu3sch.de>
Acked-by: Pavel Machek <pavel@ucw.cz>
Cc: "John W. Linville" <linville@tuxdriver.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Len Brown <lenb@kernel.org>
Cc: Greg KH <greg@kroah.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/power/main.c  |    1 +
 drivers/base/power/power.h |    1 -
 include/linux/device.h     |    6 ++++++
 3 files changed, 7 insertions(+), 1 deletion(-)

diff -puN drivers/base/power/main.c~pm-export-device_pm_schedule_removal drivers/base/power/main.c
--- a/drivers/base/power/main.c~pm-export-device_pm_schedule_removal
+++ a/drivers/base/power/main.c
@@ -129,6 +129,7 @@ void device_pm_schedule_removal(struct d
 	list_move_tail(&dev->power.entry, &dpm_destroy);
 	mutex_unlock(&dpm_list_mtx);
 }
+EXPORT_SYMBOL_GPL(device_pm_schedule_removal);
 
 /**
  *	pm_sleep_lock - mutual exclusion for registration and suspend
diff -puN drivers/base/power/power.h~pm-export-device_pm_schedule_removal drivers/base/power/power.h
--- a/drivers/base/power/power.h~pm-export-device_pm_schedule_removal
+++ a/drivers/base/power/power.h
@@ -13,7 +13,6 @@ static inline struct device *to_device(s
 
 extern void device_pm_add(struct device *);
 extern void device_pm_remove(struct device *);
-extern void device_pm_schedule_removal(struct device *);
 extern int pm_sleep_lock(void);
 extern void pm_sleep_unlock(void);
 
diff -puN include/linux/device.h~pm-export-device_pm_schedule_removal include/linux/device.h
--- a/include/linux/device.h~pm-export-device_pm_schedule_removal
+++ a/include/linux/device.h
@@ -532,11 +532,17 @@ extern struct device *device_create(stru
 extern void device_destroy(struct class *cls, dev_t devt);
 #ifdef CONFIG_PM_SLEEP
 extern void destroy_suspended_device(struct class *cls, dev_t devt);
+extern void device_pm_schedule_removal(struct device *);
 #else /* !CONFIG_PM_SLEEP */
 static inline void destroy_suspended_device(struct class *cls, dev_t devt)
 {
 	device_destroy(cls, devt);
 }
+
+static inline void device_pm_schedule_removal(struct device *dev)
+{
+	device_unregister(dev);
+}
 #endif /* !CONFIG_PM_SLEEP */
 
 /*
_

Patches currently in -mm which might be from rjw@sisk.pl are

origin.patch
git-acpi.patch
gregkh-driver-kset-convert-to-kobj_sysfs_ops-vs-git-acpi.patch
git-x86.patch
git-x86-vs-pm-acquire-device-locks-on-suspend-rev-3.patch
git-xfs.patch
page-allocator-clean-up-pcp-draining-functions.patch
page-allocator-clean-up-pcp-draining-functions-swsusp-fix.patch
page-allocator-clean-up-pcp-draining-functions-swsusp-fix-fix.patch
kernel-power-diskc-make-code-static.patch
make-kernel_shutdown_prepare-static.patch
misc-add-possibility-to-remove-misc-devices-during-suspend-resume.patch
hwrng-add-possibility-to-remove-hwrng-devices-during-suspend-resume.patch
leds-add-possibility-to-remove-leds-classdevs-during-suspend-resume.patch
b43-avoid-unregistering-device-objects-during-suspend.patch
proc-fix-the-threaded-proc-self.patch
shrink_slab-handle-bad-shrinkers.patch
