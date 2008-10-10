From: akpm@linux-foundation.org
Subject: - acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type.patch removed from -mm tree
Date: Fri, 10 Oct 2008 11:06:15 -0700
Message-ID: <200810101806.m9AI6F1a018661@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52130 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932095AbYJJSGg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 10 Oct 2008 14:06:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pavel@suse.cz, hare@suse.de, lenb@kernel.org, mm-commits@vger.kernel.org


The patch titled
     acpi: catch calls of acpi_driver_data on pointer of wrong type
has been removed from the -mm tree.  Its filename was
     acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type.patch

This patch was dropped because it was withdrawn

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: acpi: catch calls of acpi_driver_data on pointer of wrong type
From: Pavel Machek <pavel@suse.cz>

Catch attempts to use of acpi_driver_data on pointers of wrong type.

akpm: rewritten to use proper C typechecking and remove the
"function"-used-as-lvalue thing.

Signed-off-by: Pavel Machek <pavel@suse.cz>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/ac.c               |    2 +-
 drivers/acpi/acpi_memhotplug.c  |    2 +-
 drivers/acpi/asus_acpi.c        |    2 +-
 drivers/acpi/battery.c          |    2 +-
 drivers/acpi/button.c           |    2 +-
 drivers/acpi/container.c        |    2 +-
 drivers/acpi/ec.c               |    4 ++--
 drivers/acpi/fan.c              |    2 +-
 drivers/acpi/pci_link.c         |    2 +-
 drivers/acpi/pci_root.c         |    2 +-
 drivers/acpi/power.c            |    4 ++--
 drivers/acpi/processor_core.c   |    2 +-
 drivers/acpi/sbs.c              |    2 +-
 drivers/acpi/sbshc.c            |    4 ++--
 drivers/acpi/scan.c             |    4 ++--
 drivers/acpi/thermal.c          |    2 +-
 drivers/acpi/video.c            |    6 +++---
 drivers/misc/asus-laptop.c      |    2 +-
 drivers/misc/fujitsu-laptop.c   |    4 ++--
 drivers/misc/intel_menlow.c     |    2 +-
 drivers/misc/panasonic-laptop.c |    2 +-
 drivers/misc/thinkpad_acpi.c    |    2 +-
 include/acpi/acpi_bus.h         |    6 +++++-
 23 files changed, 34 insertions(+), 30 deletions(-)

diff -puN drivers/acpi/ac.c~acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type drivers/acpi/ac.c
--- a/drivers/acpi/ac.c~acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type
+++ a/drivers/acpi/ac.c
@@ -269,7 +269,7 @@ static int acpi_ac_add(struct acpi_devic
 	ac->device = device;
 	strcpy(acpi_device_name(device), ACPI_AC_DEVICE_NAME);
 	strcpy(acpi_device_class(device), ACPI_AC_CLASS);
-	acpi_driver_data(device) = ac;
+	device->driver_data = ac;
 
 	result = acpi_ac_get_state(ac);
 	if (result)
diff -puN drivers/acpi/acpi_memhotplug.c~acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type drivers/acpi/acpi_memhotplug.c
--- a/drivers/acpi/acpi_memhotplug.c~acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type
+++ a/drivers/acpi/acpi_memhotplug.c
@@ -403,7 +403,7 @@ static int acpi_memory_device_add(struct
 	mem_device->device = device;
 	sprintf(acpi_device_name(device), "%s", ACPI_MEMORY_DEVICE_NAME);
 	sprintf(acpi_device_class(device), "%s", ACPI_MEMORY_DEVICE_CLASS);
-	acpi_driver_data(device) = mem_device;
+	device->driver_data = mem_device;
 
 	/* Get the range from the _CRS */
 	result = acpi_memory_get_device_resources(mem_device);
diff -puN drivers/acpi/asus_acpi.c~acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type drivers/acpi/asus_acpi.c
--- a/drivers/acpi/asus_acpi.c~acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type
+++ a/drivers/acpi/asus_acpi.c
@@ -1321,7 +1321,7 @@ static int asus_hotk_add(struct acpi_dev
 	hotk->handle = device->handle;
 	strcpy(acpi_device_name(device), ACPI_HOTK_DEVICE_NAME);
 	strcpy(acpi_device_class(device), ACPI_HOTK_CLASS);
-	acpi_driver_data(device) = hotk;
+	device->driver_data = hotk;
 	hotk->device = device;
 
 	result = asus_hotk_check();
diff -puN drivers/acpi/battery.c~acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type drivers/acpi/battery.c
--- a/drivers/acpi/battery.c~acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type
+++ a/drivers/acpi/battery.c
@@ -804,7 +804,7 @@ static int acpi_battery_add(struct acpi_
 	battery->device = device;
 	strcpy(acpi_device_name(device), ACPI_BATTERY_DEVICE_NAME);
 	strcpy(acpi_device_class(device), ACPI_BATTERY_CLASS);
-	acpi_driver_data(device) = battery;
+	device->driver_data = battery;
 	mutex_init(&battery->lock);
 	acpi_battery_update(battery);
 #ifdef CONFIG_ACPI_PROCFS_POWER
diff -puN drivers/acpi/button.c~acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type drivers/acpi/button.c
--- a/drivers/acpi/button.c~acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type
+++ a/drivers/acpi/button.c
@@ -384,7 +384,7 @@ static int acpi_button_add(struct acpi_d
 		return -ENOMEM;
 
 	button->device = device;
-	acpi_driver_data(device) = button;
+	device->driver_data = button;
 
 	button->input = input = input_allocate_device();
 	if (!input) {
diff -puN drivers/acpi/container.c~acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type drivers/acpi/container.c
--- a/drivers/acpi/container.c~acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type
+++ a/drivers/acpi/container.c
@@ -108,7 +108,7 @@ static int acpi_container_add(struct acp
 	container->handle = device->handle;
 	strcpy(acpi_device_name(device), ACPI_CONTAINER_DEVICE_NAME);
 	strcpy(acpi_device_class(device), ACPI_CONTAINER_CLASS);
-	acpi_driver_data(device) = container;
+	device->driver_data = container;
 
 	ACPI_DEBUG_PRINT((ACPI_DB_INFO, "Device <%s> bid <%s>\n",
 			  acpi_device_name(device), acpi_device_bid(device)));
diff -puN drivers/acpi/ec.c~acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type drivers/acpi/ec.c
--- a/drivers/acpi/ec.c~acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type
+++ a/drivers/acpi/ec.c
@@ -788,7 +788,7 @@ static int acpi_ec_add(struct acpi_devic
 
 	if (!first_ec)
 		first_ec = ec;
-	acpi_driver_data(device) = ec;
+	device->driver_data = ec;
 	acpi_ec_add_fs(device);
 	pr_info(PREFIX "GPE = 0x%lx, I/O: command/status = 0x%lx, data = 0x%lx\n",
 			  ec->gpe, ec->command_addr, ec->data_addr);
@@ -813,7 +813,7 @@ static int acpi_ec_remove(struct acpi_de
 	}
 	mutex_unlock(&ec->lock);
 	acpi_ec_remove_fs(device);
-	acpi_driver_data(device) = NULL;
+	device->driver_data = NULL;
 	if (ec == first_ec)
 		first_ec = NULL;
 	kfree(ec);
diff -puN drivers/acpi/fan.c~acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type drivers/acpi/fan.c
--- a/drivers/acpi/fan.c~acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type
+++ a/drivers/acpi/fan.c
@@ -265,7 +265,7 @@ static int acpi_fan_add(struct acpi_devi
 
 	dev_info(&device->dev, "registered as cooling_device%d\n", cdev->id);
 
-	acpi_driver_data(device) = cdev;
+	device->driver_data = cdev;
 	result = sysfs_create_link(&device->dev.kobj,
 				   &cdev->device.kobj,
 				   "thermal_cooling");
diff -puN /dev/null /dev/null
diff -puN drivers/acpi/pci_link.c~acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type drivers/acpi/pci_link.c
--- a/drivers/acpi/pci_link.c~acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type
+++ a/drivers/acpi/pci_link.c
@@ -737,7 +737,7 @@ static int acpi_pci_link_add(struct acpi
 	link->device = device;
 	strcpy(acpi_device_name(device), ACPI_PCI_LINK_DEVICE_NAME);
 	strcpy(acpi_device_class(device), ACPI_PCI_LINK_CLASS);
-	acpi_driver_data(device) = link;
+	device->driver_data = link;
 
 	mutex_lock(&acpi_link_lock);
 	result = acpi_pci_link_get_possible(link);
diff -puN drivers/acpi/pci_root.c~acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type drivers/acpi/pci_root.c
--- a/drivers/acpi/pci_root.c~acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type
+++ a/drivers/acpi/pci_root.c
@@ -206,7 +206,7 @@ static int __devinit acpi_pci_root_add(s
 	root->device = device;
 	strcpy(acpi_device_name(device), ACPI_PCI_ROOT_DEVICE_NAME);
 	strcpy(acpi_device_class(device), ACPI_PCI_ROOT_CLASS);
-	acpi_driver_data(device) = root;
+	device->driver_data = root;
 
 	device->ops.bind = acpi_pci_bind;
 
diff -puN drivers/acpi/power.c~acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type drivers/acpi/power.c
--- a/drivers/acpi/power.c~acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type
+++ a/drivers/acpi/power.c
@@ -679,7 +679,7 @@ static int acpi_power_add(struct acpi_de
 	strcpy(resource->name, device->pnp.bus_id);
 	strcpy(acpi_device_name(device), ACPI_POWER_DEVICE_NAME);
 	strcpy(acpi_device_class(device), ACPI_POWER_CLASS);
-	acpi_driver_data(device) = resource;
+	device->driver_data = resource;
 
 	/* Evalute the object to get the system level and resource order. */
 	status = acpi_evaluate_object(device->handle, NULL, NULL, &buffer);
@@ -755,7 +755,7 @@ static int acpi_power_resume(struct acpi
 	if (!device || !acpi_driver_data(device))
 		return -EINVAL;
 
-	resource = (struct acpi_power_resource *)acpi_driver_data(device);
+	resource = acpi_driver_data(device);
 
 	result = acpi_power_get_state(device->handle, &state);
 	if (result)
diff -puN drivers/acpi/processor_core.c~acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type drivers/acpi/processor_core.c
--- a/drivers/acpi/processor_core.c~acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type
+++ a/drivers/acpi/processor_core.c
@@ -818,7 +818,7 @@ static int acpi_processor_add(struct acp
 	pr->handle = device->handle;
 	strcpy(acpi_device_name(device), ACPI_PROCESSOR_DEVICE_NAME);
 	strcpy(acpi_device_class(device), ACPI_PROCESSOR_CLASS);
-	acpi_driver_data(device) = pr;
+	device->driver_data = pr;
 
 	return 0;
 }
diff -puN drivers/acpi/sbs.c~acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type drivers/acpi/sbs.c
--- a/drivers/acpi/sbs.c~acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type
+++ a/drivers/acpi/sbs.c
@@ -931,7 +931,7 @@ static int acpi_sbs_add(struct acpi_devi
 	sbs->device = device;
 	strcpy(acpi_device_name(device), ACPI_SBS_DEVICE_NAME);
 	strcpy(acpi_device_class(device), ACPI_SBS_CLASS);
-	acpi_driver_data(device) = sbs;
+	device->driver_data = sbs;
 
 	result = acpi_charger_add(sbs);
 	if (result)
diff -puN drivers/acpi/sbshc.c~acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type drivers/acpi/sbshc.c
--- a/drivers/acpi/sbshc.c~acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type
+++ a/drivers/acpi/sbshc.c
@@ -282,7 +282,7 @@ static int acpi_smbus_hc_add(struct acpi
 	hc->ec = acpi_driver_data(device->parent);
 	hc->offset = (val >> 8) & 0xff;
 	hc->query_bit = val & 0xff;
-	acpi_driver_data(device) = hc;
+	device->driver_data = hc;
 
 	acpi_ec_add_query_handler(hc->ec, hc->query_bit, NULL, smbus_alarm, hc);
 	printk(KERN_INFO PREFIX "SBS HC: EC = 0x%p, offset = 0x%0x, query_bit = 0x%0x\n",
@@ -303,7 +303,7 @@ static int acpi_smbus_hc_remove(struct a
 	hc = acpi_driver_data(device);
 	acpi_ec_remove_query_handler(hc->ec, hc->query_bit);
 	kfree(hc);
-	acpi_driver_data(device) = NULL;
+	device->driver_data = NULL;
 	return 0;
 }
 
diff -puN drivers/acpi/scan.c~acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type drivers/acpi/scan.c
--- a/drivers/acpi/scan.c~acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type
+++ a/drivers/acpi/scan.c
@@ -391,7 +391,7 @@ static int acpi_device_remove(struct dev
 			acpi_drv->ops.remove(acpi_dev, acpi_dev->removal_type);
 	}
 	acpi_dev->driver = NULL;
-	acpi_driver_data(acpi_dev) = NULL;
+	acpi_dev->driver_data = NULL;
 
 	put_device(dev);
 	return 0;
@@ -544,7 +544,7 @@ acpi_bus_driver_init(struct acpi_device 
 	result = driver->ops.add(device);
 	if (result) {
 		device->driver = NULL;
-		acpi_driver_data(device) = NULL;
+		device->driver_data = NULL;
 		return result;
 	}
 
diff -puN drivers/acpi/thermal.c~acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type drivers/acpi/thermal.c
--- a/drivers/acpi/thermal.c~acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type
+++ a/drivers/acpi/thermal.c
@@ -1647,7 +1647,7 @@ static int acpi_thermal_add(struct acpi_
 	strcpy(tz->name, device->pnp.bus_id);
 	strcpy(acpi_device_name(device), ACPI_THERMAL_DEVICE_NAME);
 	strcpy(acpi_device_class(device), ACPI_THERMAL_CLASS);
-	acpi_driver_data(device) = tz;
+	device->driver_data = tz;
 	mutex_init(&tz->lock);
 
 
diff -puN drivers/acpi/video.c~acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type drivers/acpi/video.c
--- a/drivers/acpi/video.c~acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type
+++ a/drivers/acpi/video.c
@@ -1491,7 +1491,7 @@ acpi_video_bus_get_one_device(struct acp
 
 		strcpy(acpi_device_name(device), ACPI_VIDEO_DEVICE_NAME);
 		strcpy(acpi_device_class(device), ACPI_VIDEO_CLASS);
-		acpi_driver_data(device) = data;
+		device->driver_data = data;
 
 		data->device_id = device_id;
 		data->video = video;
@@ -1982,7 +1982,7 @@ static int acpi_video_bus_add(struct acp
 	video->device = device;
 	strcpy(acpi_device_name(device), ACPI_VIDEO_BUS_NAME);
 	strcpy(acpi_device_class(device), ACPI_VIDEO_CLASS);
-	acpi_driver_data(device) = video;
+	device->driver_data = video;
 
 	acpi_video_bus_find_cap(video);
 	error = acpi_video_bus_check(video);
@@ -2058,7 +2058,7 @@ static int acpi_video_bus_add(struct acp
 	acpi_video_bus_remove_fs(device);
  err_free_video:
 	kfree(video);
-	acpi_driver_data(device) = NULL;
+	device->driver_data = NULL;
 
 	return error;
 }
diff -puN drivers/misc/asus-laptop.c~acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type drivers/misc/asus-laptop.c
--- a/drivers/misc/asus-laptop.c~acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type
+++ a/drivers/misc/asus-laptop.c
@@ -996,7 +996,7 @@ static int asus_hotk_add(struct acpi_dev
 	hotk->handle = device->handle;
 	strcpy(acpi_device_name(device), ASUS_HOTK_DEVICE_NAME);
 	strcpy(acpi_device_class(device), ASUS_HOTK_CLASS);
-	acpi_driver_data(device) = hotk;
+	device->driver_data = hotk;
 	hotk->device = device;
 
 	result = asus_hotk_check();
diff -puN drivers/misc/fujitsu-laptop.c~acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type drivers/misc/fujitsu-laptop.c
--- a/drivers/misc/fujitsu-laptop.c~acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type
+++ a/drivers/misc/fujitsu-laptop.c
@@ -490,7 +490,7 @@ static int acpi_fujitsu_add(struct acpi_
 	fujitsu->acpi_handle = device->handle;
 	sprintf(acpi_device_name(device), "%s", ACPI_FUJITSU_DEVICE_NAME);
 	sprintf(acpi_device_class(device), "%s", ACPI_FUJITSU_CLASS);
-	acpi_driver_data(device) = fujitsu;
+	device->driver_data = fujitsu;
 
 	status = acpi_install_notify_handler(device->handle,
 					     ACPI_DEVICE_NOTIFY,
@@ -703,7 +703,7 @@ static int acpi_fujitsu_hotkey_add(struc
 	sprintf(acpi_device_name(device), "%s",
 		ACPI_FUJITSU_HOTKEY_DEVICE_NAME);
 	sprintf(acpi_device_class(device), "%s", ACPI_FUJITSU_CLASS);
-	acpi_driver_data(device) = fujitsu_hotkey;
+	device->driver_data = fujitsu_hotkey;
 
 	status = acpi_install_notify_handler(device->handle,
 					     ACPI_DEVICE_NOTIFY,
diff -puN drivers/misc/intel_menlow.c~acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type drivers/misc/intel_menlow.c
--- a/drivers/misc/intel_menlow.c~acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type
+++ a/drivers/misc/intel_menlow.c
@@ -175,7 +175,7 @@ static int intel_menlow_memory_add(struc
 		goto end;
 	}
 
-	acpi_driver_data(device) = cdev;
+	device->driver_data = cdev;
 	result = sysfs_create_link(&device->dev.kobj,
 				&cdev->device.kobj, "thermal_cooling");
 	if (result)
diff -puN drivers/misc/thinkpad_acpi.c~acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type drivers/misc/thinkpad_acpi.c
--- a/drivers/misc/thinkpad_acpi.c~acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type
+++ a/drivers/misc/thinkpad_acpi.c
@@ -543,7 +543,7 @@ static int __init setup_acpi_notify(stru
 		return -ENODEV;
 	}
 
-	acpi_driver_data(ibm->acpi->device) = ibm;
+	ibm->acpi->device->driver_data = ibm;
 	sprintf(acpi_device_class(ibm->acpi->device), "%s/%s",
 		TPACPI_ACPI_EVENT_PREFIX,
 		ibm->name);
diff -puN include/acpi/acpi_bus.h~acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type include/acpi/acpi_bus.h
--- a/include/acpi/acpi_bus.h~acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type
+++ a/include/acpi/acpi_bus.h
@@ -300,7 +300,11 @@ struct acpi_device {
 	enum acpi_bus_removal_type removal_type;	/* indicate for different removal type */
 };
 
-#define acpi_driver_data(d)	((d)->driver_data)
+static inline void *acpi_driver_data(struct acpi_device *d)
+{
+	return d->driver_data;
+}
+
 #define to_acpi_device(d)	container_of(d, struct acpi_device, dev)
 #define to_acpi_driver(d)	container_of(d, struct acpi_driver, drv)
 
diff -puN drivers/misc/panasonic-laptop.c~acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type drivers/misc/panasonic-laptop.c
--- a/drivers/misc/panasonic-laptop.c~acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type
+++ a/drivers/misc/panasonic-laptop.c
@@ -645,7 +645,7 @@ static int acpi_pcc_hotkey_add(struct ac
 	pcc->device = device;
 	pcc->handle = device->handle;
 	pcc->num_sifr = num_sifr;
-	acpi_driver_data(device) = pcc;
+	device->driver_data = pcc;
 	strcpy(acpi_device_name(device), ACPI_PCC_DEVICE_NAME);
 	strcpy(acpi_device_class(device), ACPI_PCC_CLASS);
 
_

Patches currently in -mm which might be from pavel@suse.cz are

git-tip.patch
git-pci.patch
acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type.patch
pm-rework-disabling-of-user-mode-helpers-during-suspend-hibernation.patch
pm-rework-disabling-of-user-mode-helpers-during-suspend-hibernation-cleanup.patch
container-freezer-add-tif_freeze-flag-to-all-architectures.patch
container-freezer-add-tif_freeze-flag-to-all-architectures-fix.patch
container-freezer-implement-freezer-cgroup-subsystem-fix-freezer-kconfig.patch
container-freezer-implement-freezer-cgroup-subsystem-uninline-thaw_process.patch
container-freezer-implement-freezer-cgroup-subsystem-uninline-thaw_process-fix.patch
container-freezer-implement-freezer-cgroup-subsystem-cleanup-comment.patch
pm-document-use-of-rtc-in-pm_trace.patch

