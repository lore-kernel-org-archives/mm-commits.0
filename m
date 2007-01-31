From: akpm@osdl.org
Subject: - fix-sys-device-power-state-regression.patch removed from -mm tree
Date: Tue, 30 Jan 2007 18:37:29 -0800
Message-ID: <200701310237.l0V2bTwu005157@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:34315 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932417AbXAaCiw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Jan 2007 21:38:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mjg59@srcf.ucam.org, david-b@pacbell.net, greg@kroah.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Fix /sys/device/.../power/state regression
has been removed from the -mm tree.  Its filename was
     fix-sys-device-power-state-regression.patch

This patch was dropped because it was nacked by the maintainer

------------------------------------------------------
Subject: Fix /sys/device/.../power/state regression
From: Matthew Garrett <mjg59@srcf.ucam.org>

In 2.6.19, support for splitting driver suspend and resume callbacks into
interrupt and non-interrupt contexts was added.  Unfortunately, this broke
/sys/device/.../power/state support for all devices.  In the long run, this
should be obsoleted by power management support in the individual drivers -
however, in the case of network drivers (for example), currently only three
drivers implement any sort of useful run-time power management.

This patch allows the bus driver to check whether a specific driver
requires the split.  If not, the 2.6.18 functionality is restored.  It also
alters feature-removals.txt to note that the deprecated functionality
should not be removed until a replacement actually exists.

Signed-off-by: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Greg KH <greg@kroah.com>
Cc: David Brownell <david-b@pacbell.net>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 Documentation/feature-removal-schedule.txt |    3 ++-
 Documentation/power/devices.txt            |    9 ++++++++-
 drivers/base/platform.c                    |   11 +++++++++++
 drivers/base/power/sysfs.c                 |    3 ++-
 drivers/pci/pci-driver.c                   |   12 ++++++++++++
 include/linux/device.h                     |    1 +
 6 files changed, 36 insertions(+), 3 deletions(-)

diff -puN Documentation/feature-removal-schedule.txt~fix-sys-device-power-state-regression Documentation/feature-removal-schedule.txt
--- a/Documentation/feature-removal-schedule.txt~fix-sys-device-power-state-regression
+++ a/Documentation/feature-removal-schedule.txt
@@ -9,7 +9,8 @@ be removed from this file.
 What:	/sys/devices/.../power/state
 	dev->power.power_state
 	dpm_runtime_{suspend,resume)()
-When:	July 2007
+	bus->pm_has_noirq_stage()
+When:	Once alternative functionality has been implemented
 Why:	Broken design for runtime control over driver power states, confusing
 	driver-internal runtime power management with:  mechanisms to support
 	system-wide sleep state transitions; event codes that distinguish
diff -puN Documentation/power/devices.txt~fix-sys-device-power-state-regression Documentation/power/devices.txt
--- a/Documentation/power/devices.txt~fix-sys-device-power-state-regression
+++ a/Documentation/power/devices.txt
@@ -79,6 +79,7 @@ struct bus_type {
 
 	int  (*resume_early)(struct device *dev);
 	int  (*resume)(struct device *dev);
+	int  (*pm_has_noirq_stage)(struct device *dev);
 };
 
 Bus drivers implement those methods as appropriate for the hardware and
@@ -236,6 +237,10 @@ The phases are seen by driver notificati
 	may stay partly usable until this late.  This "late" call may also
 	help when coping with hardware that behaves badly.
 
+	If a bus implements the suspend_late method, it must also provide a
+	pm_has_noirq_stage function in order to determine whether devices
+	may be suspended during runtime.
+
 The pm_message_t parameter is currently used to refine those semantics
 (described later).
 
@@ -348,7 +353,9 @@ The phases are seen by driver notificati
 	won't be supported on busses that require IRQs in order to
 	interact with devices.
 
-	This reverses the effects of bus.suspend_late().
+	This reverses the effects of bus.suspend_late(). As with suspend_late,
+	if a bus implements this function it must provide a pm_has_noirq_stage
+	function.
 
    2	bus.resume(dev) is called next.  This may be morphed into a device
    	driver call with bus-specific parameters; implementations may sleep.
diff -puN drivers/base/platform.c~fix-sys-device-power-state-regression drivers/base/platform.c
--- a/drivers/base/platform.c~fix-sys-device-power-state-regression
+++ a/drivers/base/platform.c
@@ -597,6 +597,16 @@ static int platform_resume(struct device
 	return ret;
 }
 
+static int platform_pm_has_noirq_stage(struct device * dev)
+{
+	int ret = 0;
+	struct platform_driver *drv = to_platform_driver(dev->driver);
+
+	if (dev->driver && (drv->resume_early || drv->suspend_late))
+		ret = 1;
+	return ret;
+}
+
 struct bus_type platform_bus_type = {
 	.name		= "platform",
 	.dev_attrs	= platform_dev_attrs,
@@ -606,6 +616,7 @@ struct bus_type platform_bus_type = {
 	.suspend_late	= platform_suspend_late,
 	.resume_early	= platform_resume_early,
 	.resume		= platform_resume,
+	.pm_has_noirq_stage = platform_pm_has_noirq_stage,
 };
 EXPORT_SYMBOL_GPL(platform_bus_type);
 
diff -puN drivers/base/power/sysfs.c~fix-sys-device-power-state-regression drivers/base/power/sysfs.c
--- a/drivers/base/power/sysfs.c~fix-sys-device-power-state-regression
+++ a/drivers/base/power/sysfs.c
@@ -46,7 +46,8 @@ static ssize_t state_store(struct device
 	int error = -EINVAL;
 
 	/* disallow incomplete suspend sequences */
-	if (dev->bus && (dev->bus->suspend_late || dev->bus->resume_early))
+	if (dev->bus && dev->bus->pm_has_noirq_stage
+			&& dev->bus->pm_has_noirq_stage(dev))
 		return error;
 
 	state.event = PM_EVENT_SUSPEND;
diff -puN drivers/pci/pci-driver.c~fix-sys-device-power-state-regression drivers/pci/pci-driver.c
--- a/drivers/pci/pci-driver.c~fix-sys-device-power-state-regression
+++ a/drivers/pci/pci-driver.c
@@ -346,6 +346,17 @@ static int pci_device_resume(struct devi
 	return error;
 }
 
+static int pci_device_pm_has_noirq_stage(struct device * dev)
+{
+	int error = 0;
+	struct pci_dev * pci_dev = to_pci_dev(dev);
+	struct pci_driver * drv = pci_dev->driver;
+
+	if (drv && (drv->resume_early || drv->suspend_late))
+		error = 1;
+	return error;
+}
+
 static int pci_device_resume_early(struct device * dev)
 {
 	int error = 0;
@@ -566,6 +577,7 @@ struct bus_type pci_bus_type = {
 	.suspend_late	= pci_device_suspend_late,
 	.resume_early	= pci_device_resume_early,
 	.resume		= pci_device_resume,
+	.pm_has_noirq_stage = pci_device_pm_has_noirq_stage,
 	.shutdown	= pci_device_shutdown,
 	.dev_attrs	= pci_dev_attrs,
 };
diff -puN include/linux/device.h~fix-sys-device-power-state-regression include/linux/device.h
--- a/include/linux/device.h~fix-sys-device-power-state-regression
+++ a/include/linux/device.h
@@ -59,6 +59,7 @@ struct bus_type {
 	int (*suspend)(struct device * dev, pm_message_t state);
 	int (*suspend_late)(struct device * dev, pm_message_t state);
 	int (*resume_early)(struct device * dev);
+	int (*pm_has_noirq_stage)(struct device * dev);
 	int (*resume)(struct device * dev);
 };
 
_

Patches currently in -mm which might be from mjg59@srcf.ucam.org are

fix-sys-device-power-state-regression.patch
2.6-sony_acpi4.patch
