From: akpm@linux-foundation.org
Subject: - platform-add-new-device-registration-helper.patch removed from -mm tree
Date: Fri, 03 Oct 2008 14:29:02 -0700
Message-ID: <200810032129.m93LT2uL016659@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45819 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753212AbYJCV3F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Oct 2008 17:29:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dbaryshkov@gmail.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     platform: add new device registration helper
has been removed from the -mm tree.  Its filename was
     platform-add-new-device-registration-helper.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: platform: add new device registration helper
From: Dmitry Baryshkov <dbaryshkov@gmail.com>

Add a helper that registers simple platform_device w/o resources but with
parent and device data.

This is usefull to cleanup platform code from code that registers such
simple devices as leds-gpio, generic-bl, etc.

Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/platform.c         |   47 ++++++++++++++++++++++++++++++
 include/linux/platform_device.h |    2 +
 2 files changed, 49 insertions(+)

diff -puN drivers/base/platform.c~platform-add-new-device-registration-helper drivers/base/platform.c
--- a/drivers/base/platform.c~platform-add-new-device-registration-helper
+++ a/drivers/base/platform.c
@@ -391,6 +391,53 @@ error:
 }
 EXPORT_SYMBOL_GPL(platform_device_register_simple);
 
+/**
+ * platform_device_register_data
+ * @parent: parent device for the device we're adding
+ * @name: base name of the device we're adding
+ * @id: instance id
+ * @data: platform specific data for this platform device
+ * @size: size of platform specific data
+ *
+ * This function creates a simple platform device that requires minimal
+ * resource and memory management. Canned release function freeing memory
+ * allocated for the device allows drivers using such devices to be
+ * unloaded without waiting for the last reference to the device to be
+ * dropped.
+ */
+struct platform_device *platform_device_register_data(
+		struct device *parent,
+		const char *name, int id,
+		const void *data, size_t size)
+{
+	struct platform_device *pdev;
+	int retval;
+
+	pdev = platform_device_alloc(name, id);
+	if (!pdev) {
+		retval = -ENOMEM;
+		goto error;
+	}
+
+	pdev->dev.parent = parent;
+
+	if (size) {
+		retval = platform_device_add_data(pdev, data, size);
+		if (retval)
+			goto error;
+	}
+
+	retval = platform_device_add(pdev);
+	if (retval)
+		goto error;
+
+	return pdev;
+
+error:
+	platform_device_put(pdev);
+	return ERR_PTR(retval);
+}
+
 static int platform_drv_probe(struct device *_dev)
 {
 	struct platform_driver *drv = to_platform_driver(_dev->driver);
diff -puN include/linux/platform_device.h~platform-add-new-device-registration-helper include/linux/platform_device.h
--- a/include/linux/platform_device.h~platform-add-new-device-registration-helper
+++ a/include/linux/platform_device.h
@@ -37,6 +37,8 @@ extern int platform_add_devices(struct p
 
 extern struct platform_device *platform_device_register_simple(const char *, int id,
 					struct resource *, unsigned int);
+extern struct platform_device *platform_device_register_data(struct device *,
+		const char *, int, const void *, size_t);
 
 extern struct platform_device *platform_device_alloc(const char *name, int id);
 extern int platform_device_add_resources(struct platform_device *pdev, struct resource *res, unsigned int num);
_

Patches currently in -mm which might be from dbaryshkov@gmail.com are

fbdev-fix-recursive-notifier-and-locking-when-fbdev-console-is-blanked.patch
git-arm.patch
git-sound.patch
git-mmc.patch
git-battery.patch
git-mfd.patch
make-gpiochip-label-const.patch
gpio-max7301-fix-the-race-between-chip-addition-and-pins-reconfiguration.patch

