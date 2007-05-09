From: akpm@linux-foundation.org
Subject: - fix-hotplug-for-legacy-platform-drivers.patch removed from -mm tree
Date: Tue, 08 May 2007 19:49:47 -0700
Message-ID: <200705090249.l492nlBZ009262@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:36556 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S969989AbXEICum (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:50:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david-b@pacbell.net, dbrownell@users.sourceforge.net, dilinger@debian.org, gregkh@suse.de, linux@dominikbrodowski.net, mm-commits@vger.kernel.org


The patch titled
     fix hotplug for legacy platform drivers
has been removed from the -mm tree.  Its filename was
     fix-hotplug-for-legacy-platform-drivers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fix hotplug for legacy platform drivers
From: David Brownell <david-b@pacbell.net>

We've had various reports of some legacy "probe the hardware" style
platform drivers having nasty problems with hotplug support.

The core issue is that those legacy drivers don't fully conform to the
driver model.  They assume a role that should be the responsibility of
infrastructure code: creating device nodes.

The "modprobe" step in hotplugging relies on drivers to have split those
roles into different modules.  The lack of this split causes the problems. 
When a driver creates nodes for devices that don't exist (sending a hotplug
event), then exits (aborting one modprobe) before the "modprobe $MODALIAS"
step completes (by failing, since it's in the middle of a modprobe), the
result can be an endless loop of modprobe invocations ...  badness.

This fix uses the newish per-device flag controlling issuance of "add"
events.  (A previous version of this patch used a per-device "driver can
hotplug" flag, which only scrubbed $MODALIAS from the environment rather
than suppressing the entire hotplug event.) It also shrinks that flag to
one bit, saving a word in "struct device".

So the net of this patch is removing some nasty failures with legacy
drivers, while retaining hotplug capability for the majority of platform
drivers.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Greg KH <gregkh@suse.de>
Cc: Andres Salomon <dilinger@debian.org>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/platform.c           |   18 ++++++++++++++++++
 drivers/pcmcia/pxa2xx_mainstone.c |    1 +
 drivers/pcmcia/pxa2xx_sharpsl.c   |    1 +
 include/linux/device.h            |    4 ++--
 4 files changed, 22 insertions(+), 2 deletions(-)

diff -puN drivers/base/platform.c~fix-hotplug-for-legacy-platform-drivers drivers/base/platform.c
--- a/drivers/base/platform.c~fix-hotplug-for-legacy-platform-drivers
+++ a/drivers/base/platform.c
@@ -160,6 +160,11 @@ static void platform_device_release(stru
  *
  *	Create a platform device object which can have other objects attached
  *	to it, and which will have attached objects freed when it is released.
+ *
+ *	This device will be marked as not supporting hotpluggable drivers; no
+ *	device add/remove uevents will be generated.  In the unusual case that
+ *	the device isn't being dynamically allocated as a legacy "probe the
+ *	hardware" driver, infrastructure code should reverse this marking.
  */
 struct platform_device *platform_device_alloc(const char *name, unsigned int id)
 {
@@ -172,6 +177,12 @@ struct platform_device *platform_device_
 		pa->pdev.id = id;
 		device_initialize(&pa->pdev.dev);
 		pa->pdev.dev.release = platform_device_release;
+
+		/* prevent hotplug "modprobe $(MODALIAS)" from causing trouble in
+		 * legacy probe-the-hardware drivers, which don't properly split
+		 * out device enumeration logic from drivers.
+		 */
+		pa->pdev.dev.uevent_suppress = 1;
 	}
 
 	return pa ? &pa->pdev : NULL;
@@ -351,6 +362,13 @@ EXPORT_SYMBOL_GPL(platform_device_unregi
  *	memory allocated for the device allows drivers using such devices
  *	to be unloaded iwithout waiting for the last reference to the device
  *	to be dropped.
+ *
+ *	This interface is primarily intended for use with legacy drivers
+ *	which probe hardware directly.  Because such drivers create sysfs
+ *	device nodes themselves, rather than letting system infrastructure
+ *	handle such device enumeration tasks, they don't fully conform to
+ *	the Linux driver model.  In particular, when such drivers are built
+ *	as modules, they can't be "hotplugged".
  */
 struct platform_device *platform_device_register_simple(char *name, unsigned int id,
 							struct resource *res, unsigned int num)
diff -puN drivers/pcmcia/pxa2xx_mainstone.c~fix-hotplug-for-legacy-platform-drivers drivers/pcmcia/pxa2xx_mainstone.c
--- a/drivers/pcmcia/pxa2xx_mainstone.c~fix-hotplug-for-legacy-platform-drivers
+++ a/drivers/pcmcia/pxa2xx_mainstone.c
@@ -175,6 +175,7 @@ static int __init mst_pcmcia_init(void)
 	if (!mst_pcmcia_device)
 		return -ENOMEM;
 
+	mst_pcmcia_device->dev.uevent_suppress = 0;
 	mst_pcmcia_device->dev.platform_data = &mst_pcmcia_ops;
 
 	ret = platform_device_add(mst_pcmcia_device);
diff -puN drivers/pcmcia/pxa2xx_sharpsl.c~fix-hotplug-for-legacy-platform-drivers drivers/pcmcia/pxa2xx_sharpsl.c
--- a/drivers/pcmcia/pxa2xx_sharpsl.c~fix-hotplug-for-legacy-platform-drivers
+++ a/drivers/pcmcia/pxa2xx_sharpsl.c
@@ -261,6 +261,7 @@ static int __init sharpsl_pcmcia_init(vo
 	if (!sharpsl_pcmcia_device)
 		return -ENOMEM;
 
+	sharpsl_pcmcia_device->dev.uevent_suppress = 0;
 	sharpsl_pcmcia_device->dev.platform_data = &sharpsl_pcmcia_ops;
 	sharpsl_pcmcia_device->dev.parent = platform_scoop_config->devs[0].dev;
 
diff -puN include/linux/device.h~fix-hotplug-for-legacy-platform-drivers include/linux/device.h
--- a/include/linux/device.h~fix-hotplug-for-legacy-platform-drivers
+++ a/include/linux/device.h
@@ -412,12 +412,13 @@ struct device {
 	struct klist_node	knode_parent;		/* node in sibling list */
 	struct klist_node	knode_driver;
 	struct klist_node	knode_bus;
-	struct device 	* parent;
+	struct device		*parent;
 
 	struct kobject kobj;
 	char	bus_id[BUS_ID_SIZE];	/* position on parent bus */
 	struct device_type	*type;
 	unsigned		is_registered:1;
+	unsigned		uevent_suppress:1;
 	struct device_attribute uevent_attr;
 	struct device_attribute *devt_attr;
 
@@ -458,7 +459,6 @@ struct device {
 	struct class		*class;
 	dev_t			devt;		/* dev_t, creates the sysfs "dev" */
 	struct attribute_group	**groups;	/* optional groups */
-	int			uevent_suppress;
 
 	void	(*release)(struct device * dev);
 };
_

Patches currently in -mm which might be from david-b@pacbell.net are

origin.patch
acpi-driver-model-flags-and-platform_enable_wake.patch
update-documentation-driver-model-platformtxt.patch
use-common-cpu_is_xxx-macros-on-at91-and-avr32.patch
atmel_spi-remove-unnecessary-and-wrong-ifdefs.patch
