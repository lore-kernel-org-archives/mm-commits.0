From: akpm@linux-foundation.org
Subject: - pm-new-suspend-and-hibernation-callbacks-for-platform-bus-type.patch removed from -mm tree
Date: Wed, 16 Apr 2008 15:55:34 -0700
Message-ID: <200804162255.m3GMtYHY011134@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48076 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753334AbYDPXBf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Apr 2008 19:01:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, greg@kroah.com, jbarnes@virtuousgeek.org, kay.sievers@vrfy.org, lenb@kernel.org, pavel@ucw.cz, stern@rowland.harvard.edu, mm-commits@vger.kernel.org


The patch titled
     pm: new suspend and hibernation callbacks for platform bus type
has been removed from the -mm tree.  Its filename was
     pm-new-suspend-and-hibernation-callbacks-for-platform-bus-type.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pm: new suspend and hibernation callbacks for platform bus type
From: Rafael J. Wysocki <rjw@sisk.pl>

Implement new suspend and hibernation callbacks for the platform bus type.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Greg KH <greg@kroah.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/platform.c         |  296 +++++++++++++++++++++++++++++-
 include/linux/platform_device.h |    1 
 2 files changed, 289 insertions(+), 8 deletions(-)

diff -puN drivers/base/platform.c~pm-new-suspend-and-hibernation-callbacks-for-platform-bus-type drivers/base/platform.c
--- a/drivers/base/platform.c~pm-new-suspend-and-hibernation-callbacks-for-platform-bus-type
+++ a/drivers/base/platform.c
@@ -453,6 +453,8 @@ int platform_driver_register(struct plat
 		drv->driver.suspend = platform_drv_suspend;
 	if (drv->resume)
 		drv->driver.resume = platform_drv_resume;
+	if (drv->pm)
+		drv->driver.pm = &drv->pm->base;
 	return driver_register(&drv->driver);
 }
 EXPORT_SYMBOL_GPL(platform_driver_register);
@@ -560,7 +562,9 @@ static int platform_match(struct device 
 	return (strncmp(pdev->name, drv->name, BUS_ID_SIZE) == 0);
 }
 
-static int platform_suspend(struct device *dev, pm_message_t mesg)
+#ifdef CONFIG_PM_SLEEP
+
+static int platform_legacy_suspend(struct device *dev, pm_message_t mesg)
 {
 	int ret = 0;
 
@@ -570,7 +574,7 @@ static int platform_suspend(struct devic
 	return ret;
 }
 
-static int platform_suspend_late(struct device *dev, pm_message_t mesg)
+static int platform_legacy_suspend_late(struct device *dev, pm_message_t mesg)
 {
 	struct platform_driver *drv = to_platform_driver(dev->driver);
 	struct platform_device *pdev;
@@ -583,7 +587,7 @@ static int platform_suspend_late(struct 
 	return ret;
 }
 
-static int platform_resume_early(struct device *dev)
+static int platform_legacy_resume_early(struct device *dev)
 {
 	struct platform_driver *drv = to_platform_driver(dev->driver);
 	struct platform_device *pdev;
@@ -596,7 +600,7 @@ static int platform_resume_early(struct 
 	return ret;
 }
 
-static int platform_resume(struct device *dev)
+static int platform_legacy_resume(struct device *dev)
 {
 	int ret = 0;
 
@@ -606,15 +610,291 @@ static int platform_resume(struct device
 	return ret;
 }
 
+static int platform_pm_prepare(struct device *dev)
+{
+	struct device_driver *drv = dev->driver;
+	int ret = 0;
+
+	if (drv && drv->pm && drv->pm->prepare)
+		ret = drv->pm->prepare(dev);
+
+	return ret;
+}
+
+static void platform_pm_complete(struct device *dev)
+{
+	struct device_driver *drv = dev->driver;
+
+	if (drv && drv->pm && drv->pm->complete)
+		drv->pm->complete(dev);
+}
+
+#ifdef CONFIG_SUSPEND
+
+static int platform_pm_suspend(struct device *dev)
+{
+	struct device_driver *drv = dev->driver;
+	int ret = 0;
+
+	if (drv && drv->pm) {
+		if (drv->pm->suspend)
+			ret = drv->pm->suspend(dev);
+	} else {
+		ret = platform_legacy_suspend(dev, PMSG_SUSPEND);
+	}
+
+	return ret;
+}
+
+static int platform_pm_suspend_noirq(struct device *dev)
+{
+	struct platform_driver *pdrv;
+	int ret = 0;
+
+	if (!dev->driver)
+		return 0;
+
+	pdrv = to_platform_driver(dev->driver);
+	if (pdrv->pm) {
+		if (pdrv->pm->suspend_noirq)
+			ret = pdrv->pm->suspend_noirq(dev);
+	} else {
+		ret = platform_legacy_suspend_late(dev, PMSG_SUSPEND);
+	}
+
+	return ret;
+}
+
+static int platform_pm_resume(struct device *dev)
+{
+	struct device_driver *drv = dev->driver;
+	int ret = 0;
+
+	if (drv && drv->pm) {
+		if (drv->pm->resume)
+			ret = drv->pm->resume(dev);
+	} else {
+		ret = platform_legacy_resume(dev);
+	}
+
+	return ret;
+}
+
+static int platform_pm_resume_noirq(struct device *dev)
+{
+	struct platform_driver *pdrv;
+	int ret = 0;
+
+	if (!dev->driver)
+		return 0;
+
+	pdrv = to_platform_driver(dev->driver);
+	if (pdrv->pm) {
+		if (pdrv->pm->resume_noirq)
+			ret = pdrv->pm->resume_noirq(dev);
+	} else {
+		ret = platform_legacy_resume_early(dev);
+	}
+
+	return ret;
+}
+
+#else /* !CONFIG_SUSPEND */
+
+#define platform_pm_suspend		NULL
+#define platform_pm_resume		NULL
+#define platform_pm_suspend_noirq	NULL
+#define platform_pm_resume_noirq	NULL
+
+#endif /* !CONFIG_SUSPEND */
+
+#ifdef CONFIG_HIBERNATION
+
+static int platform_pm_freeze(struct device *dev)
+{
+	struct device_driver *drv = dev->driver;
+	int ret = 0;
+
+	if (!drv)
+		return 0;
+
+	if (drv->pm) {
+		if (drv->pm->freeze)
+			ret = drv->pm->freeze(dev);
+	} else {
+		ret = platform_legacy_suspend(dev, PMSG_FREEZE);
+	}
+
+	return ret;
+}
+
+static int platform_pm_freeze_noirq(struct device *dev)
+{
+	struct platform_driver *pdrv;
+	int ret = 0;
+
+	if (!dev->driver)
+		return 0;
+
+	pdrv = to_platform_driver(dev->driver);
+	if (pdrv->pm) {
+		if (pdrv->pm->freeze_noirq)
+			ret = pdrv->pm->freeze_noirq(dev);
+	} else {
+		ret = platform_legacy_suspend_late(dev, PMSG_FREEZE);
+	}
+
+	return ret;
+}
+
+static int platform_pm_thaw(struct device *dev)
+{
+	struct device_driver *drv = dev->driver;
+	int ret = 0;
+
+	if (drv && drv->pm) {
+		if (drv->pm->thaw)
+			ret = drv->pm->thaw(dev);
+	} else {
+		ret = platform_legacy_resume(dev);
+	}
+
+	return ret;
+}
+
+static int platform_pm_thaw_noirq(struct device *dev)
+{
+	struct platform_driver *pdrv;
+	int ret = 0;
+
+	if (!dev->driver)
+		return 0;
+
+	pdrv = to_platform_driver(dev->driver);
+	if (pdrv->pm) {
+		if (pdrv->pm->thaw_noirq)
+			ret = pdrv->pm->thaw_noirq(dev);
+	} else {
+		ret = platform_legacy_resume_early(dev);
+	}
+
+	return ret;
+}
+
+static int platform_pm_poweroff(struct device *dev)
+{
+	struct device_driver *drv = dev->driver;
+	int ret = 0;
+
+	if (drv && drv->pm) {
+		if (drv->pm->poweroff)
+			ret = drv->pm->poweroff(dev);
+	} else {
+		ret = platform_legacy_suspend(dev, PMSG_HIBERNATE);
+	}
+
+	return ret;
+}
+
+static int platform_pm_poweroff_noirq(struct device *dev)
+{
+	struct platform_driver *pdrv;
+	int ret = 0;
+
+	if (!dev->driver)
+		return 0;
+
+	pdrv = to_platform_driver(dev->driver);
+	if (pdrv->pm) {
+		if (pdrv->pm->poweroff_noirq)
+			ret = pdrv->pm->poweroff_noirq(dev);
+	} else {
+		ret = platform_legacy_suspend_late(dev, PMSG_HIBERNATE);
+	}
+
+	return ret;
+}
+
+static int platform_pm_restore(struct device *dev)
+{
+	struct device_driver *drv = dev->driver;
+	int ret = 0;
+
+	if (drv && drv->pm) {
+		if (drv->pm->restore)
+			ret = drv->pm->restore(dev);
+	} else {
+		ret = platform_legacy_resume(dev);
+	}
+
+	return ret;
+}
+
+static int platform_pm_restore_noirq(struct device *dev)
+{
+	struct platform_driver *pdrv;
+	int ret = 0;
+
+	if (!dev->driver)
+		return 0;
+
+	pdrv = to_platform_driver(dev->driver);
+	if (pdrv->pm) {
+		if (pdrv->pm->restore_noirq)
+			ret = pdrv->pm->restore_noirq(dev);
+	} else {
+		ret = platform_legacy_resume_early(dev);
+	}
+
+	return ret;
+}
+
+#else /* !CONFIG_HIBERNATION */
+
+#define platform_pm_freeze		NULL
+#define platform_pm_thaw		NULL
+#define platform_pm_poweroff		NULL
+#define platform_pm_restore		NULL
+#define platform_pm_freeze_noirq	NULL
+#define platform_pm_thaw_noirq		NULL
+#define platform_pm_poweroff_noirq	NULL
+#define platform_pm_restore_noirq	NULL
+
+#endif /* !CONFIG_HIBERNATION */
+
+struct pm_ext_ops platform_pm_ops = {
+	.base = {
+		.prepare = platform_pm_prepare,
+		.complete = platform_pm_complete,
+		.suspend = platform_pm_suspend,
+		.resume = platform_pm_resume,
+		.freeze = platform_pm_freeze,
+		.thaw = platform_pm_thaw,
+		.poweroff = platform_pm_poweroff,
+		.restore = platform_pm_restore,
+	},
+	.suspend_noirq = platform_pm_suspend_noirq,
+	.resume_noirq = platform_pm_resume_noirq,
+	.freeze_noirq = platform_pm_freeze_noirq,
+	.thaw_noirq = platform_pm_thaw_noirq,
+	.poweroff_noirq = platform_pm_poweroff_noirq,
+	.restore_noirq = platform_pm_restore_noirq,
+};
+
+#define PLATFORM_PM_OPS_PTR	&platform_pm_ops
+
+#else /* !CONFIG_PM_SLEEP */
+
+#define PLATFORM_PM_OPS_PTR	NULL
+
+#endif /* !CONFIG_PM_SLEEP */
+
 struct bus_type platform_bus_type = {
 	.name		= "platform",
 	.dev_attrs	= platform_dev_attrs,
 	.match		= platform_match,
 	.uevent		= platform_uevent,
-	.suspend	= platform_suspend,
-	.suspend_late	= platform_suspend_late,
-	.resume_early	= platform_resume_early,
-	.resume		= platform_resume,
+	.pm		= PLATFORM_PM_OPS_PTR,
 };
 EXPORT_SYMBOL_GPL(platform_bus_type);
 
diff -puN include/linux/platform_device.h~pm-new-suspend-and-hibernation-callbacks-for-platform-bus-type include/linux/platform_device.h
--- a/include/linux/platform_device.h~pm-new-suspend-and-hibernation-callbacks-for-platform-bus-type
+++ a/include/linux/platform_device.h
@@ -53,6 +53,7 @@ struct platform_driver {
 	int (*suspend_late)(struct platform_device *, pm_message_t state);
 	int (*resume_early)(struct platform_device *);
 	int (*resume)(struct platform_device *);
+	struct pm_ext_ops *pm;
 	struct device_driver driver;
 };
 
_

Patches currently in -mm which might be from rjw@sisk.pl are

origin.patch
git-acpi.patch
power-replace-remaining-__function__-occurrences.patch
s2ram-warn-when-interrupts-should-be-disabled-but-are-not.patch
pm-gxfb-add-hook-to-pm-console-layer-that-allows-disabling-of-suspend-vt-switch.patch
pm-gxfb-add-hook-to-pm-console-layer-that-allows-disabling-of-suspend-vt-switch-fix.patch
proc-switch-proc-apm-to-seq_file-interface.patch
shrink_slab-handle-bad-shrinkers.patch

