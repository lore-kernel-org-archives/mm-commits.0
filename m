From: akpm@linux-foundation.org
Subject: + acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type-fix.patch added to -mm tree
Date: Wed, 10 Sep 2008 17:31:15 -0700
Message-ID: <200809110031.m8B0VFaH002280@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34273 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752297AbYIKAcB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Sep 2008 20:32:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, hare@suse.de, lenb@kernel.org, pavel@suse.cz


The patch titled
     acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type-fix
has been added to the -mm tree.  Its filename is
     acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Hannes Reinecke <hare@suse.de>
Cc: Len Brown <lenb@kernel.org>
Cc: Pavel Machek <pavel@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/ac.c             |    2 +-
 drivers/acpi/asus_acpi.c      |    2 +-
 drivers/acpi/battery.c        |    2 +-
 drivers/acpi/button.c         |    2 +-
 drivers/acpi/container.c      |    2 +-
 drivers/acpi/ec.c             |    4 ++--
 drivers/acpi/fan.c            |    2 +-
 drivers/acpi/pcc_acpi.c       |    2 +-
 drivers/acpi/pci_link.c       |    2 +-
 drivers/acpi/pci_root.c       |    2 +-
 drivers/acpi/power.c          |    4 ++--
 drivers/acpi/processor_core.c |    2 +-
 drivers/acpi/sbs.c            |    2 +-
 drivers/acpi/sbshc.c          |    4 ++--
 drivers/acpi/scan.c           |    4 ++--
 drivers/acpi/thermal.c        |    2 +-
 drivers/acpi/video.c          |    6 +++---
 include/acpi/acpi_bus.h       |    6 +++++-
 18 files changed, 28 insertions(+), 24 deletions(-)

diff -puN drivers/acpi/ac.c~acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type-fix drivers/acpi/ac.c
--- a/drivers/acpi/ac.c~acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type-fix
+++ a/drivers/acpi/ac.c
@@ -269,7 +269,7 @@ static int acpi_ac_add(struct acpi_devic
 	ac->device = device;
 	strcpy(acpi_device_name(device), ACPI_AC_DEVICE_NAME);
 	strcpy(acpi_device_class(device), ACPI_AC_CLASS);
-	acpi_driver_data(device) = ac;
+	device->driver_data = ac;
 
 	result = acpi_ac_get_state(ac);
 	if (result)
diff -puN drivers/acpi/asus_acpi.c~acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type-fix drivers/acpi/asus_acpi.c
--- a/drivers/acpi/asus_acpi.c~acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type-fix
+++ a/drivers/acpi/asus_acpi.c
@@ -1321,7 +1321,7 @@ static int asus_hotk_add(struct acpi_dev
 	hotk->handle = device->handle;
 	strcpy(acpi_device_name(device), ACPI_HOTK_DEVICE_NAME);
 	strcpy(acpi_device_class(device), ACPI_HOTK_CLASS);
-	acpi_driver_data(device) = hotk;
+	device->driver_data = hotk;
 	hotk->device = device;
 
 	result = asus_hotk_check();
diff -puN drivers/acpi/battery.c~acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type-fix drivers/acpi/battery.c
--- a/drivers/acpi/battery.c~acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type-fix
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
diff -puN drivers/acpi/button.c~acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type-fix drivers/acpi/button.c
--- a/drivers/acpi/button.c~acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type-fix
+++ a/drivers/acpi/button.c
@@ -384,7 +384,7 @@ static int acpi_button_add(struct acpi_d
 		return -ENOMEM;
 
 	button->device = device;
-	acpi_driver_data(device) = button;
+	device->driver_data = button;
 
 	button->input = input = input_allocate_device();
 	if (!input) {
diff -puN drivers/acpi/container.c~acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type-fix drivers/acpi/container.c
--- a/drivers/acpi/container.c~acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type-fix
+++ a/drivers/acpi/container.c
@@ -108,7 +108,7 @@ static int acpi_container_add(struct acp
 	container->handle = device->handle;
 	strcpy(acpi_device_name(device), ACPI_CONTAINER_DEVICE_NAME);
 	strcpy(acpi_device_class(device), ACPI_CONTAINER_CLASS);
-	acpi_driver_data(device) = container;
+	device->driver_data = container;
 
 	ACPI_DEBUG_PRINT((ACPI_DB_INFO, "Device <%s> bid <%s>\n",
 			  acpi_device_name(device), acpi_device_bid(device)));
diff -puN drivers/acpi/ec.c~acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type-fix drivers/acpi/ec.c
--- a/drivers/acpi/ec.c~acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type-fix
+++ a/drivers/acpi/ec.c
@@ -792,7 +792,7 @@ static int acpi_ec_add(struct acpi_devic
 
 	if (!first_ec)
 		first_ec = ec;
-	acpi_driver_data(device) = ec;
+	device->driver_data = ec;
 	acpi_ec_add_fs(device);
 	pr_info(PREFIX "GPE = 0x%lx, I/O: command/status = 0x%lx, data = 0x%lx\n",
 			  ec->gpe, ec->command_addr, ec->data_addr);
@@ -817,7 +817,7 @@ static int acpi_ec_remove(struct acpi_de
 	}
 	mutex_unlock(&ec->lock);
 	acpi_ec_remove_fs(device);
-	acpi_driver_data(device) = NULL;
+	device->driver_data = NULL;
 	if (ec == first_ec)
 		first_ec = NULL;
 	kfree(ec);
diff -puN drivers/acpi/fan.c~acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type-fix drivers/acpi/fan.c
--- a/drivers/acpi/fan.c~acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type-fix
+++ a/drivers/acpi/fan.c
@@ -265,7 +265,7 @@ static int acpi_fan_add(struct acpi_devi
 
 	dev_info(&device->dev, "registered as cooling_device%d\n", cdev->id);
 
-	acpi_driver_data(device) = cdev;
+	device->driver_data = cdev;
 	result = sysfs_create_link(&device->dev.kobj,
 				   &cdev->device.kobj,
 				   "thermal_cooling");
diff -puN drivers/acpi/pcc_acpi.c~acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type-fix drivers/acpi/pcc_acpi.c
--- a/drivers/acpi/pcc_acpi.c~acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type-fix
+++ a/drivers/acpi/pcc_acpi.c
@@ -657,7 +657,7 @@ static int acpi_pcc_hotkey_add(struct ac
 	pcc->device = device;
 	pcc->handle = device->handle;
 	pcc->num_sifr = num_sifr;
-	acpi_driver_data(device) = pcc;
+	device->driver_data = pcc;
 	strcpy(acpi_device_name(device), ACPI_PCC_DEVICE_NAME);
 	strcpy(acpi_device_class(device), ACPI_PCC_CLASS);
 
diff -puN drivers/acpi/pci_link.c~acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type-fix drivers/acpi/pci_link.c
--- a/drivers/acpi/pci_link.c~acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type-fix
+++ a/drivers/acpi/pci_link.c
@@ -737,7 +737,7 @@ static int acpi_pci_link_add(struct acpi
 	link->device = device;
 	strcpy(acpi_device_name(device), ACPI_PCI_LINK_DEVICE_NAME);
 	strcpy(acpi_device_class(device), ACPI_PCI_LINK_CLASS);
-	acpi_driver_data(device) = link;
+	device->driver_data = link;
 
 	mutex_lock(&acpi_link_lock);
 	result = acpi_pci_link_get_possible(link);
diff -puN drivers/acpi/pci_root.c~acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type-fix drivers/acpi/pci_root.c
--- a/drivers/acpi/pci_root.c~acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type-fix
+++ a/drivers/acpi/pci_root.c
@@ -206,7 +206,7 @@ static int __devinit acpi_pci_root_add(s
 	root->device = device;
 	strcpy(acpi_device_name(device), ACPI_PCI_ROOT_DEVICE_NAME);
 	strcpy(acpi_device_class(device), ACPI_PCI_ROOT_CLASS);
-	acpi_driver_data(device) = root;
+	device->driver_data = root;
 
 	device->ops.bind = acpi_pci_bind;
 
diff -puN drivers/acpi/power.c~acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type-fix drivers/acpi/power.c
--- a/drivers/acpi/power.c~acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type-fix
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
diff -puN drivers/acpi/processor_core.c~acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type-fix drivers/acpi/processor_core.c
--- a/drivers/acpi/processor_core.c~acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type-fix
+++ a/drivers/acpi/processor_core.c
@@ -818,7 +818,7 @@ static int acpi_processor_add(struct acp
 	pr->handle = device->handle;
 	strcpy(acpi_device_name(device), ACPI_PROCESSOR_DEVICE_NAME);
 	strcpy(acpi_device_class(device), ACPI_PROCESSOR_CLASS);
-	acpi_driver_data(device) = pr;
+	device->driver_data = pr;
 
 	return 0;
 }
diff -puN drivers/acpi/sbs.c~acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type-fix drivers/acpi/sbs.c
--- a/drivers/acpi/sbs.c~acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type-fix
+++ a/drivers/acpi/sbs.c
@@ -931,7 +931,7 @@ static int acpi_sbs_add(struct acpi_devi
 	sbs->device = device;
 	strcpy(acpi_device_name(device), ACPI_SBS_DEVICE_NAME);
 	strcpy(acpi_device_class(device), ACPI_SBS_CLASS);
-	acpi_driver_data(device) = sbs;
+	device->driver_data = sbs;
 
 	result = acpi_charger_add(sbs);
 	if (result)
diff -puN drivers/acpi/sbshc.c~acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type-fix drivers/acpi/sbshc.c
--- a/drivers/acpi/sbshc.c~acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type-fix
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
 
diff -puN drivers/acpi/scan.c~acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type-fix drivers/acpi/scan.c
--- a/drivers/acpi/scan.c~acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type-fix
+++ a/drivers/acpi/scan.c
@@ -391,7 +391,7 @@ static int acpi_device_remove(struct dev
 			acpi_drv->ops.remove(acpi_dev, acpi_dev->removal_type);
 	}
 	acpi_dev->driver = NULL;
-	acpi_driver_data(dev) = NULL;
+	dev->driver_data = NULL;
 
 	put_device(dev);
 	return 0;
@@ -545,7 +545,7 @@ acpi_bus_driver_init(struct acpi_device 
 	result = driver->ops.add(device);
 	if (result) {
 		device->driver = NULL;
-		acpi_driver_data(device) = NULL;
+		device->driver_data = NULL;
 		return result;
 	}
 
diff -puN drivers/acpi/thermal.c~acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type-fix drivers/acpi/thermal.c
--- a/drivers/acpi/thermal.c~acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type-fix
+++ a/drivers/acpi/thermal.c
@@ -1647,7 +1647,7 @@ static int acpi_thermal_add(struct acpi_
 	strcpy(tz->name, device->pnp.bus_id);
 	strcpy(acpi_device_name(device), ACPI_THERMAL_DEVICE_NAME);
 	strcpy(acpi_device_class(device), ACPI_THERMAL_CLASS);
-	acpi_driver_data(device) = tz;
+	device->driver_data = tz;
 	mutex_init(&tz->lock);
 
 
diff -puN drivers/acpi/video.c~acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type-fix drivers/acpi/video.c
--- a/drivers/acpi/video.c~acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type-fix
+++ a/drivers/acpi/video.c
@@ -1500,7 +1500,7 @@ acpi_video_bus_get_one_device(struct acp
 
 		strcpy(acpi_device_name(device), ACPI_VIDEO_DEVICE_NAME);
 		strcpy(acpi_device_class(device), ACPI_VIDEO_CLASS);
-		acpi_driver_data(device) = data;
+		device->driver_data = data;
 
 		data->device_id = device_id;
 		data->video = video;
@@ -1990,7 +1990,7 @@ static int acpi_video_bus_add(struct acp
 	video->device = device;
 	strcpy(acpi_device_name(device), ACPI_VIDEO_BUS_NAME);
 	strcpy(acpi_device_class(device), ACPI_VIDEO_CLASS);
-	acpi_driver_data(device) = video;
+	device->driver_data = video;
 
 	acpi_video_bus_find_cap(video);
 	error = acpi_video_bus_check(video);
@@ -2066,7 +2066,7 @@ static int acpi_video_bus_add(struct acp
 	acpi_video_bus_remove_fs(device);
  err_free_video:
 	kfree(video);
-	acpi_driver_data(device) = NULL;
+	device->driver_data = NULL;
 
 	return error;
 }
diff -puN include/acpi/acpi_bus.h~acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type-fix include/acpi/acpi_bus.h
--- a/include/acpi/acpi_bus.h~acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type-fix
+++ a/include/acpi/acpi_bus.h
@@ -300,7 +300,11 @@ struct acpi_device {
 	enum acpi_bus_removal_type removal_type;	/* indicate for different removal type */
 };
 
-#define acpi_driver_data(d)	((void) (d == (struct acpi_device *) 0), d)->driver_data
+static inline void *acpi_driver_data(struct acpi_device *d)
+{
+	return d->driver_data;
+}
+
 #define to_acpi_device(d)	container_of(d, struct acpi_device, dev)
 #define to_acpi_driver(d)	container_of(d, struct acpi_driver, drv)
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
include-linux-ioporth-add-missing-macro-argument-for-devm_release_-family-checkpatch-fixes.patch
linux-next.patch
next-remove-localversion.patch
linux-next-git-rejects.patch
security-selinux-include-netlabelh-fix-two-build-errors.patch
drivers-mfd-ucb1400_corec-needs-gpio.patch
drivers-mfd-ucb1400_corec-further-unbork.patch
kbuild-ftrace-dont-assume-that-scripts-recordmcountpl-is-executable.patch
toshiba_acpi-add-support-for-bluetooth-toggling-through-rfkill-v7-fix.patch
toshiba_acpi-add-support-for-bluetooth-toggling-through-rfkill-v7-fix-fix.patch
revert-acpi-ec-do-transaction-from-interrupt-context.patch
acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type-fix.patch
zero-based-percpu-use-vmlinux_symbol-in-include-asm-generic-vmlinuxldsh.patch
x86-make-poll_idle-behave-more-like-the-other-idle-methods-checkpatch-fixes.patch
arch-x86-kernel-early_printkc-remove-unused-enable_debug_console.patch
fs-sysfs-dirc-remove-unused-__sysfs_get_dentry.patch
fs-dlm-configc-choose-better-identifiers.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
drivers-input-touchscreen-ucb1400_tsc-needs-gpio.patch
git-jg-misc.patch
led-driver-for-leds-on-pcengines-alix2-and-alix3-boards.patch
libata-blackfin-pata-driver-add-proper-pm-operation-into-atapi-driver-fix.patch
sundance-set-carrier-status-on-link-change-events.patch
cassini-use-request_firmware.patch
e1000e-avoid-duplicated-output-of-device-name-in-kernel-warning-checkpatch-fixes.patch
e1000e-avoid-duplicated-output-of-device-name-in-kernel-warning-fix.patch
backlight-driver-for-tabletkiosk-sahara-touchit-213-tablet-pc.patch
backlight-driver-for-tabletkiosk-sahara-touchit-213-tablet-pc-update-2-checkpatch-fixes.patch
pci-tidy-pme-support-messages-checkpatch-fixes.patch
arch-s390-kernel-ptracec-fix-build.patch
sched-clarify-ifdef-tangle.patch
scsi-gdthc-use-unaligned-access-helpers.patch
drivers-scsi-device_handler-scsi_dh_emcc-suppress-warning.patch
drivers-rtc-kconfig-dont-build-rtc-cmoso-on-sparc32.patch
drivers-usb-musb-disable-it-on-superh.patch
git-xtensa.patch
modules-remove-stop_machine-during-module-load-checkpatch-fixes.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
drivers-media-video-cafe_ccicc-needs-mmh.patch
e1000e-prevent-corruption-of-eeprom-nvm.patch
drivers-net-mlx4-allocc-needs-mmh.patch
net-forcedeth-call-restore-mac-addr-in-nv_shutdown-path-v2.patch
mm-page_allocc-free_area_init_nodes-fix-inappropriate-use-of-enum.patch
mm-cleanup-to-make-remove_memory-arch-neutral-fix.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
vmscan-move-isolate_lru_page-to-vmscanc.patch
define-page_file_cache-function.patch
vmscan-split-lru-lists-into-anon-file-sets.patch
unevictable-lru-infrastructure.patch
unevictable-lru-page-statistics.patch
mlock-mlocked-pages-are-unevictable.patch
mlock-mlocked-pages-are-unevictable-fix.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-mlock-resubmit-locked_vm-adjustment-as-separate-patch-fix.patch
vmscan-unevictable-lru-scan-sysctl.patch
mlock-make-mlock-error-return-posixly-correct-fix.patch
mm-rewrite-vmap-layer-fix.patch
mm-rewrite-vmap-layer-fix-fix.patch
mm-rewrite-vmap-layer-fix-fix-fix.patch
h8300-generic_bug-support-checkpatch-fixes.patch
pm-rework-disabling-of-user-mode-helpers-during-suspend-hibernation-cleanup.patch
container-freezer-add-tif_freeze-flag-to-all-architectures-fix.patch
container-freezer-implement-freezer-cgroup-subsystem-checkpatch-fixes.patch
container-freezer-implement-freezer-cgroup-subsystem-uninline-thaw_process-fix.patch
separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh-fix.patch
separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh-fix-fix.patch
fix-a-race-condtion-of-oops_in_progress-fix.patch
vsprintf-use-new-vsprintf-symbolic-function-pointer-format-cleanup.patch
make-taint-bit-reliable-v3-fix.patch
compat-generic-compat-get-settimeofday-checkpatch-fixes.patch
hwmon-pc87360-separate-alarm-files-add-in-min-max-alarms-cleanup.patch
hwmon-pc87360-separate-alarm-files-add-temp-min-max-crit-fault-alarms-cleanup.patch
hwmon-pc87360-separate-alarm-files-add-therm-min-max-crit-alarms-cleanup.patch
allow-recursion-in-binfmt_script-and-binfmt_misc-fix.patch
autofs4-track-uid-and-gid-of-last-mount-requester-fix.patch
autofs4-add-miscellaneous-device-for-ioctls-fix.patch
autofs4-add-miscellaneous-device-for-ioctls-fix-2.patch
autofs4-add-miscellaneous-device-for-ioctls-fix-fix-3.patch
rtc-add-device-driver-for-dallas-ds3234-spi-rtc-chip-fix.patch
fb-push-down-the-bkl-in-the-ioctl-handler-checkpatch-fixes.patch
viafb-viafbmodes-viafbtxt-fix-fix.patch
viafb-accelc-accelh-checkpatch-fixes.patch
viafb-dvic-dvih-globalc-and-globalh-checkpatch-fixes.patch
viafb-hwc-hwh-checkpatch-fixes.patch
viafb-viafbdevc-viafbdevh-checkpatch-fixes.patch
fbdev-kconfig-update-fix.patch
eink_apollofb-new-driver-for-apollo-eink-controller.patch
cgroups-fix-probable-race-with-put_css_set-and-find_css_set-fix.patch
memrlimit-add-memrlimit-controller-accounting-and-control-mm_owner-fix-checkpatch-fixes.patch
message-queues-increase-range-limits-checkpatch-fixes.patch
tty-fix-echo-tab-erase-and-locking-fix.patch
applicomc-fix-apparently-broken-code-in-do_ac_read.patch
drivers-char-tpm-tpmc-fix-error-patch-memory-leak.patch
w1-be-able-to-manually-add-and-remove-slaves-fix.patch
gru-driver-minor-updates-fix.patch
gcov-architecture-specific-compile-flag-adjustments-powerpc-moved-stuff.patch
drivers-rtc-rtc-bq4802c-dont-use-bin_2_bcd-and-bcd_2_bin.patch
x86-sysfs-kill-owner-field-from-attribute-fix.patch
nilfs2-continuous-snapshotting-file-system-fix.patch
nilfs2-continuous-snapshotting-file-system-fix-fix-2.patch
reiser4.patch
reiser4-tree_lock-fixes.patch
reiser4-tree_lock-fixes-fix.patch
reiser4-semaphore-fix.patch
slb-drop-kmem-cache-argument-from-constructor-reiser4.patch
reiser4-suid.patch
reiser4-track-upstream-changes.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
profile-likely-unlikely-macros.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

