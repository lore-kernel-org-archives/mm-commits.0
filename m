From: akpm@linux-foundation.org
Subject: [folded] cmpc_acpi-add-support-for-classmate-pc-acpi-devices-fix.patch removed from -mm tree
Date: Tue, 17 Nov 2009 14:19:39 -0800
Message-ID: <200911172219.nAHMJdkg004338@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43456 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756200AbZKQWUr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Nov 2009 17:20:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, cascardo@holoscopio.com, lenb@kernel.org, mm-commits@vger.kernel.org


The patch titled
     cmpc_acpi-add-support-for-classmate-pc-acpi-devices-fix
has been removed from the -mm tree.  Its filename was
     cmpc_acpi-add-support-for-classmate-pc-acpi-devices-fix.patch

This patch was dropped because it was folded into cmpc_acpi-add-support-for-classmate-pc-acpi-devices.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cmpc_acpi-add-support-for-classmate-pc-acpi-devices-fix
From: Andrew Morton <akpm@linux-foundation.org>

readability tweaks

Cc: Len Brown <lenb@kernel.org>
Cc: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/x86/cmpc_acpi.c |   31 ++++++++++++++++++++++++-----
 1 file changed, 26 insertions(+), 5 deletions(-)

diff -puN drivers/platform/x86/cmpc_acpi.c~cmpc_acpi-add-support-for-classmate-pc-acpi-devices-fix drivers/platform/x86/cmpc_acpi.c
--- a/drivers/platform/x86/cmpc_acpi.c~cmpc_acpi-add-support-for-classmate-pc-acpi-devices-fix
+++ a/drivers/platform/x86/cmpc_acpi.c
@@ -40,6 +40,7 @@ static int cmpc_add_acpi_notify_device(s
 	struct input_dev *inputdev;
 	acpi_status status;
 	int error;
+
 	inputdev = input_allocate_device();
 	if (!inputdev) {
 		error = -ENOMEM;
@@ -72,6 +73,7 @@ static int cmpc_remove_acpi_notify_devic
 {
 	struct input_dev *inputdev;
 	acpi_status status;
+
 	status = acpi_remove_notify_handler(acpi->handle, ACPI_DEVICE_NOTIFY,
 					    handler);
 	inputdev = dev_get_drvdata(&acpi->dev);
@@ -80,16 +82,15 @@ static int cmpc_remove_acpi_notify_devic
 	return 0;
 }
 
-
 /*
  * Accelerometer code.
  */
-
 static acpi_status cmpc_start_accel(acpi_handle handle)
 {
 	union acpi_object param[2];
 	struct acpi_object_list input;
 	acpi_status status;
+
 	param[0].type = ACPI_TYPE_INTEGER;
 	param[0].integer.value = 0x3;
 	param[1].type = ACPI_TYPE_INTEGER;
@@ -104,6 +105,7 @@ static acpi_status cmpc_stop_accel(acpi_
 	union acpi_object param[2];
 	struct acpi_object_list input;
 	acpi_status status;
+
 	param[0].type = ACPI_TYPE_INTEGER;
 	param[0].integer.value = 0x4;
 	param[1].type = ACPI_TYPE_INTEGER;
@@ -117,6 +119,7 @@ static acpi_status cmpc_accel_set_sense(
 {
 	union acpi_object param[2];
 	struct acpi_object_list input;
+
 	param[0].type = ACPI_TYPE_INTEGER;
 	param[0].integer.value = 0x02;
 	param[1].type = ACPI_TYPE_INTEGER;
@@ -136,6 +139,7 @@ static acpi_status cmpc_get_accel(acpi_h
 	struct acpi_buffer output = { ACPI_ALLOCATE_BUFFER, 0 };
 	unsigned char *locs;
 	acpi_status status;
+
 	param[0].type = ACPI_TYPE_INTEGER;
 	param[0].integer.value = 0x01;
 	param[1].type = ACPI_TYPE_INTEGER;
@@ -156,12 +160,14 @@ static acpi_status cmpc_get_accel(acpi_h
 
 static void cmpc_accel_handler(acpi_handle handle, u32 event, void *ctx)
 {
-	struct input_dev *inputdev = ctx;
-	acpi_status status;
-	unsigned char x, y, z;
 	if (event == 0x81) {
+		unsigned char x, y, z;
+		acpi_status status;
+
 		status = cmpc_get_accel(handle, &x, &y, &z);
 		if (ACPI_SUCCESS(status)) {
+			struct input_dev *inputdev = ctx;
+
 			input_report_abs(inputdev, ABS_X, x);
 			input_report_abs(inputdev, ABS_Y, y);
 			input_report_abs(inputdev, ABS_Z, z);
@@ -176,6 +182,7 @@ static ssize_t cmpc_accel_sense_store(st
 {
 	struct acpi_device *acpi;
 	int sense;
+
 	acpi = to_acpi_device(dev);
 	if (sscanf(buf, "%d", &sense) <= 0)
 		return -EINVAL;
@@ -191,6 +198,7 @@ struct device_attribute cmpc_accel_sense
 static int cmpc_accel_open(struct input_dev *input)
 {
 	struct acpi_device *acpi;
+
 	acpi = to_acpi_device(input->dev.parent);
 	if (ACPI_SUCCESS(cmpc_start_accel(acpi->handle)))
 		return 0;
@@ -200,6 +208,7 @@ static int cmpc_accel_open(struct input_
 static void cmpc_accel_close(struct input_dev *input)
 {
 	struct acpi_device *acpi;
+
 	acpi = to_acpi_device(input->dev.parent);
 	cmpc_stop_accel(acpi->handle);
 }
@@ -217,6 +226,7 @@ static void cmpc_accel_idev_init(struct 
 static int cmpc_accel_add(struct acpi_device *acpi)
 {
 	int error;
+
 	error = device_create_file(&acpi->dev, &cmpc_accel_sense_attr);
 	if (error)
 		return error;
@@ -260,6 +270,7 @@ static acpi_status cmpc_get_tablet(acpi_
 	struct acpi_object_list input;
 	unsigned long long output;
 	acpi_status status;
+
 	param.type = ACPI_TYPE_INTEGER;
 	param.integer.value = 0x01;
 	input.count = 1;
@@ -274,6 +285,7 @@ static void cmpc_tablet_handler(acpi_han
 {
 	unsigned long long val = 0;
 	struct input_dev *inputdev = ctx;
+
 	if (event == 0x81) {
 		if (ACPI_SUCCESS(cmpc_get_tablet(handle, &val)))
 			input_report_switch(inputdev, SW_TABLET_MODE, !val);
@@ -328,6 +340,7 @@ static acpi_status cmpc_get_brightness(a
 	struct acpi_object_list input;
 	unsigned long long output;
 	acpi_status status;
+
 	param.type = ACPI_TYPE_INTEGER;
 	param.integer.value = 0xC0;
 	input.count = 1;
@@ -345,6 +358,7 @@ static acpi_status cmpc_set_brightness(a
 	struct acpi_object_list input;
 	acpi_status status;
 	unsigned long long output;
+
 	param[0].type = ACPI_TYPE_INTEGER;
 	param[0].integer.value = 0xC0;
 	param[1].type = ACPI_TYPE_INTEGER;
@@ -360,6 +374,7 @@ static int cmpc_bl_get_brightness(struct
 	acpi_status status;
 	acpi_handle handle;
 	unsigned long long brightness;
+
 	handle = bl_get_data(bd);
 	status = cmpc_get_brightness(handle, &brightness);
 	if (ACPI_SUCCESS(status))
@@ -372,6 +387,7 @@ static int cmpc_bl_update_status(struct 
 {
 	acpi_status status;
 	acpi_handle handle;
+
 	handle = bl_get_data(bd);
 	status = cmpc_set_brightness(handle, bd->props.brightness);
 	if (ACPI_SUCCESS(status))
@@ -388,6 +404,7 @@ static struct backlight_ops cmpc_bl_ops 
 static int cmpc_bl_add(struct acpi_device *acpi)
 {
 	struct backlight_device *bd;
+
 	bd = backlight_device_register("cmpc_bl", &acpi->dev,
 				       acpi->handle, &cmpc_bl_ops);
 	bd->props.max_brightness = 7;
@@ -398,6 +415,7 @@ static int cmpc_bl_add(struct acpi_devic
 static int cmpc_bl_remove(struct acpi_device *acpi, int type)
 {
 	struct backlight_device *bd;
+
 	bd = dev_get_drvdata(&acpi->dev);
 	backlight_device_unregister(bd);
 	return 0;
@@ -439,6 +457,7 @@ static void cmpc_keys_handler(acpi_handl
 {
 	struct input_dev *inputdev;
 	int code = KEY_MAX;
+
 	if ((event & 0x0F) < ARRAY_SIZE(cmpc_keys_codes))
 		code = cmpc_keys_codes[event & 0x0F];
 	inputdev = ctx;
@@ -448,6 +467,7 @@ static void cmpc_keys_handler(acpi_handl
 static void cmpc_keys_idev_init(struct input_dev *inputdev)
 {
 	int i;
+
 	set_bit(EV_KEY, inputdev->evbit);
 	for (i = 0; cmpc_keys_codes[i] != KEY_MAX; i++)
 		set_bit(cmpc_keys_codes[i], inputdev->keybit);
@@ -491,6 +511,7 @@ static bool cmpc_keys_driver_registered;
 static int cmpc_init(void)
 {
 	int result;
+
 	result = acpi_bus_register_driver(&cmpc_keys_acpi_driver);
 	cmpc_keys_driver_registered = !!result;
 	result = acpi_bus_register_driver(&cmpc_bl_acpi_driver);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
recordmcount-stfu.patch
include-linux-compiler-gcc4h-gcc-402-doesnt-understand-__builtin_object_size.patch
drivers-char-cycladesc-fix-used-uninitialised-bug.patch
drivers-gpu-drm-i915-i915_dmac-fix-unused-var.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
cmpc_acpi-add-support-for-classmate-pc-acpi-devices.patch
cmpc_acpi-add-support-for-classmate-pc-acpi-devices-fix.patch
acpi-remove-nid_inval-checkpatch-fixes.patch
drivers-acpi-acpi_padc-squish-warning.patch
drivers-char-agp-amd64-agpc-squish-warning.patch
drm-kill-more-unused-drm-macros-fix.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
drivers-leds-leds-ss4200c-fix-return-statement.patch
drivers-atm-solos-pcic-fix-warning-bug-clean-up-code.patch
3x59x-fix-pci-resource-management.patch
bluetooth-fix-for-acer-bluetooth-optical-rechargeable-mouse.patch
atmel_serial-add-poll_get_char-and-poll_put_char-uart_ops-fix.patch
st-fix-test-of-value-range-in-st_set_options.patch
scsi-add-hpsa-driver-for-hp-smart-array-controllers.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
fs-improve-remountro-vs-buffercache-coherency.patch
percpu-avoid-calling-__pcpu_ptr_to_addrnull.patch
readahead-add-blk_run_backing_dev.patch
mmap-dont-return-enomem-when-mapcount-is-temporarily-exceeded-in-munmap-checkpatch-fixes.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix-fix.patch
oom-kill-show-virtual-size-and-rss-information-of-the-killed-process-fix.patch
oom-kill-fix-numa-consraint-check-with-nodemask-v42-checkpatch-fixes.patch
mm-memory_hotplug-make-offline_pages-static.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
floppy-add-an-extra-bound-check-on-ioctl-arguments-fix.patch
drivers-misc-add-driver-for-texas-instruments-dac7512-update.patch
rwsem-fix-rwsem_is_locked-bugs-fix.patch
kernelh-add-printk_ratelimited-and-pr_level_rl-checkpatch-fixes.patch
kernelh-add-printk_ratelimited-and-pr_level_rl-rename.patch
errh-add-helper-function-to-simplify-pointer-error-checking-fix.patch
msm_sdccc-add-missing-include-fix-compilation-checkpatch-fixes.patch
crc32-minor-optimizations-and-cleanup-checkpatch-fixes.patch
hwmon-w83627ehf-updates-checkpatch-fixes.patch
spi-controller-driver-for-designware-spi-core-fix.patch
spidev-use-declare_bitmap-instead-of-declaring-the-array-checkpatch-fixes.patch
gpiolib-add-names-file-in-gpio-chip-sysfs.patch
mb862xxfb-add-acceleration-support-for-coral-p-coral-pa-imageblt-copyarea-fillrect-fix.patch
mb862xxfb-add-acceleration-support-for-coral-p-coral-pa-imageblt-copyarea-fillrect-fix2.patch
mb862xxfb-add-acceleration-support-for-coral-p-coral-pa-imageblt-copyarea-fillrect-fix2-fix-3.patch
ext2-avoid-warn-messages-when-failing-to-write-to-the-superblock-checkpatch-fixes.patch
memcg-coalesce-charging-via-percpu-storage-fix.patch
aio-dont-zero-out-the-pages-array-inside-struct-dio-fix.patch
direct-io-cleanup-blockdev_direct_io-locking-checkpatch-fixes.patch
zlib-optimize-inffast-when-copying-direct-from-output-checkpatch-fixes.patch
lib-add-support-for-lzo-compressed-kernels-checkpatch-fixes.patch
lib-add-support-for-lzo-compressed-kernels-checkpatch-fixes-cleanup.patch
net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
fs-reiser4-contextc-current_is_pdflush-got-removed.patch
reiser4-fix.patch
reiser4-disable.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch

