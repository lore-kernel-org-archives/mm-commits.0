From: akpm@linux-foundation.org
Subject: [to-be-updated] cmpc_acpi-add-support-for-classmate-pc-acpi-devices.patch removed from -mm tree
Date: Thu, 19 Nov 2009 16:08:51 -0800
Message-ID: <200911200008.nAK08p5I004257@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42864 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757923AbZKTAJ2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Nov 2009 19:09:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cascardo@holoscopio.com, lenb@kernel.org, mm-commits@vger.kernel.org


The patch titled
     cmpc_acpi: add support for Classmate PC ACPI devices
has been removed from the -mm tree.  Its filename was
     cmpc_acpi-add-support-for-classmate-pc-acpi-devices.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cmpc_acpi: add support for Classmate PC ACPI devices
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>

This add supports for devices like keyboard, backlight, tablet and
accelerometer.

This work is supported by International Syst S/A.

[randy.dunlap@oracle.com: cmpc_acpi: depends on ACPI]
[akpm@linux-foundation.org: readability tweaks]
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS                      |    6 
 drivers/platform/x86/Kconfig     |   12 
 drivers/platform/x86/Makefile    |    1 
 drivers/platform/x86/cmpc_acpi.c |  543 +++++++++++++++++++++++++++++
 4 files changed, 562 insertions(+)

diff -puN MAINTAINERS~cmpc_acpi-add-support-for-classmate-pc-acpi-devices MAINTAINERS
--- a/MAINTAINERS~cmpc_acpi-add-support-for-classmate-pc-acpi-devices
+++ a/MAINTAINERS
@@ -1427,6 +1427,12 @@ L:	linux-scsi@vger.kernel.org
 S:	Supported
 F:	drivers/scsi/fnic/
 
+CMPC ACPI DRIVER
+M:	Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
+M:	Daniel Oliveira Nascimento <don@syst.com.br>
+S:	Supported
+F:	drivers/platform/x86/cmpc_acpi.c
+
 CODA FILE SYSTEM
 M:	Jan Harkes <jaharkes@cs.cmu.edu>
 M:	coda@cs.cmu.edu
diff -puN drivers/platform/x86/Kconfig~cmpc_acpi-add-support-for-classmate-pc-acpi-devices drivers/platform/x86/Kconfig
--- a/drivers/platform/x86/Kconfig~cmpc_acpi-add-support-for-classmate-pc-acpi-devices
+++ a/drivers/platform/x86/Kconfig
@@ -435,4 +435,16 @@ config ACPI_TOSHIBA
 
 	  If you have a legacy free Toshiba laptop (such as the Libretto L1
 	  series), say Y.
+
+config ACPI_CMPC
+	tristate "CMPC Laptop Extras"
+	depends on X86 && ACPI
+	select INPUT
+	select BACKLIGHT_CLASS_DEVICE
+	default n
+	help
+	  Support for Intel Classmate PC ACPI devices, including some
+	  keys as input device, backlight device, tablet and accelerometer
+	  devices.
+
 endif # X86_PLATFORM_DEVICES
diff -puN drivers/platform/x86/Makefile~cmpc_acpi-add-support-for-classmate-pc-acpi-devices drivers/platform/x86/Makefile
--- a/drivers/platform/x86/Makefile~cmpc_acpi-add-support-for-classmate-pc-acpi-devices
+++ a/drivers/platform/x86/Makefile
@@ -21,3 +21,4 @@ obj-$(CONFIG_ACPI_WMI)		+= wmi.o
 obj-$(CONFIG_ACPI_ASUS)		+= asus_acpi.o
 obj-$(CONFIG_TOPSTAR_LAPTOP)	+= topstar-laptop.o
 obj-$(CONFIG_ACPI_TOSHIBA)	+= toshiba_acpi.o
+obj-$(CONFIG_ACPI_CMPC)		+= cmpc_acpi.o
diff -puN /dev/null drivers/platform/x86/cmpc_acpi.c
--- /dev/null
+++ a/drivers/platform/x86/cmpc_acpi.c
@@ -0,0 +1,543 @@
+/*
+ *  Copyright (C) 2009  Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License along
+ *  with this program; if not, write to the Free Software Foundation, Inc.,
+ *  51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
+ */
+
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/workqueue.h>
+#include <acpi/acpi_drivers.h>
+#include <linux/backlight.h>
+#include <linux/input.h>
+
+MODULE_LICENSE("GPL");
+
+
+/*
+ * Generic input device code.
+ */
+
+typedef void (*input_device_init)(struct input_dev *dev);
+
+static int cmpc_add_acpi_notify_device(struct acpi_device *acpi, char *name,
+				       acpi_notify_handler handler,
+				       input_device_init idev_init)
+{
+	struct input_dev *inputdev;
+	acpi_status status;
+	int error;
+
+	inputdev = input_allocate_device();
+	if (!inputdev) {
+		error = -ENOMEM;
+		goto out;
+	}
+	inputdev->name = name;
+	inputdev->dev.parent = &acpi->dev;
+	idev_init(inputdev);
+	error = input_register_device(inputdev);
+	if (error)
+		goto err_reg;
+	dev_set_drvdata(&acpi->dev, inputdev);
+	status = acpi_install_notify_handler(acpi->handle, ACPI_DEVICE_NOTIFY,
+					     handler, inputdev);
+	if (ACPI_FAILURE(status)) {
+		error = -ENODEV;
+		goto err_acpi;
+	}
+	return 0;
+err_acpi:
+	input_unregister_device(inputdev);
+err_reg:
+	input_free_device(inputdev);
+out:
+	return error;
+}
+
+static int cmpc_remove_acpi_notify_device(struct acpi_device *acpi,
+					  acpi_notify_handler handler)
+{
+	struct input_dev *inputdev;
+	acpi_status status;
+
+	status = acpi_remove_notify_handler(acpi->handle, ACPI_DEVICE_NOTIFY,
+					    handler);
+	inputdev = dev_get_drvdata(&acpi->dev);
+	input_unregister_device(inputdev);
+	input_free_device(inputdev);
+	return 0;
+}
+
+/*
+ * Accelerometer code.
+ */
+static acpi_status cmpc_start_accel(acpi_handle handle)
+{
+	union acpi_object param[2];
+	struct acpi_object_list input;
+	acpi_status status;
+
+	param[0].type = ACPI_TYPE_INTEGER;
+	param[0].integer.value = 0x3;
+	param[1].type = ACPI_TYPE_INTEGER;
+	input.count = 2;
+	input.pointer = param;
+	status = acpi_evaluate_object(handle, "ACMD", &input, NULL);
+	return status;
+}
+
+static acpi_status cmpc_stop_accel(acpi_handle handle)
+{
+	union acpi_object param[2];
+	struct acpi_object_list input;
+	acpi_status status;
+
+	param[0].type = ACPI_TYPE_INTEGER;
+	param[0].integer.value = 0x4;
+	param[1].type = ACPI_TYPE_INTEGER;
+	input.count = 2;
+	input.pointer = param;
+	status = acpi_evaluate_object(handle, "ACMD", &input, NULL);
+	return status;
+}
+
+static acpi_status cmpc_accel_set_sense(acpi_handle handle, int val)
+{
+	union acpi_object param[2];
+	struct acpi_object_list input;
+
+	param[0].type = ACPI_TYPE_INTEGER;
+	param[0].integer.value = 0x02;
+	param[1].type = ACPI_TYPE_INTEGER;
+	param[1].integer.value = val;
+	input.count = 2;
+	input.pointer = param;
+	return acpi_evaluate_object(handle, "ACMD", &input, NULL);
+}
+
+static acpi_status cmpc_get_accel(acpi_handle handle,
+				  unsigned char *x,
+				  unsigned char *y,
+				  unsigned char *z)
+{
+	union acpi_object param[2];
+	struct acpi_object_list input;
+	struct acpi_buffer output = { ACPI_ALLOCATE_BUFFER, 0 };
+	unsigned char *locs;
+	acpi_status status;
+
+	param[0].type = ACPI_TYPE_INTEGER;
+	param[0].integer.value = 0x01;
+	param[1].type = ACPI_TYPE_INTEGER;
+	input.count = 2;
+	input.pointer = param;
+	status = acpi_evaluate_object(handle, "ACMD", &input, &output);
+	if (ACPI_SUCCESS(status)) {
+		union acpi_object *obj;
+		obj = output.pointer;
+		locs = obj->buffer.pointer;
+		*x = locs[0];
+		*y = locs[1];
+		*z = locs[2];
+		kfree(output.pointer);
+	}
+	return status;
+}
+
+static void cmpc_accel_handler(acpi_handle handle, u32 event, void *ctx)
+{
+	if (event == 0x81) {
+		unsigned char x, y, z;
+		acpi_status status;
+
+		status = cmpc_get_accel(handle, &x, &y, &z);
+		if (ACPI_SUCCESS(status)) {
+			struct input_dev *inputdev = ctx;
+
+			input_report_abs(inputdev, ABS_X, x);
+			input_report_abs(inputdev, ABS_Y, y);
+			input_report_abs(inputdev, ABS_Z, z);
+			input_sync(inputdev);
+		}
+	}
+}
+
+static ssize_t cmpc_accel_sense_store(struct device *dev,
+				      struct device_attribute *attr,
+				      const char *buf, size_t count)
+{
+	struct acpi_device *acpi;
+	int sense;
+
+	acpi = to_acpi_device(dev);
+	if (sscanf(buf, "%d", &sense) <= 0)
+		return -EINVAL;
+	cmpc_accel_set_sense(acpi->handle, sense);
+	return strnlen(buf, count);
+}
+
+struct device_attribute cmpc_accel_sense_attr = {
+	.attr = { .name = "sense", .mode = 0220 },
+	.store = cmpc_accel_sense_store
+};
+
+static int cmpc_accel_open(struct input_dev *input)
+{
+	struct acpi_device *acpi;
+
+	acpi = to_acpi_device(input->dev.parent);
+	if (ACPI_SUCCESS(cmpc_start_accel(acpi->handle)))
+		return 0;
+	return -EIO;
+}
+
+static void cmpc_accel_close(struct input_dev *input)
+{
+	struct acpi_device *acpi;
+
+	acpi = to_acpi_device(input->dev.parent);
+	cmpc_stop_accel(acpi->handle);
+}
+
+static void cmpc_accel_idev_init(struct input_dev *inputdev)
+{
+	set_bit(EV_ABS, inputdev->evbit);
+	input_set_abs_params(inputdev, ABS_X, 0, 255, 8, 0);
+	input_set_abs_params(inputdev, ABS_Y, 0, 255, 8, 0);
+	input_set_abs_params(inputdev, ABS_Z, 0, 255, 8, 0);
+	inputdev->open = cmpc_accel_open;
+	inputdev->close = cmpc_accel_close;
+}
+
+static int cmpc_accel_add(struct acpi_device *acpi)
+{
+	int error;
+
+	error = device_create_file(&acpi->dev, &cmpc_accel_sense_attr);
+	if (error)
+		return error;
+	return cmpc_add_acpi_notify_device(acpi, "cmpc_accel",
+					   cmpc_accel_handler,
+					   cmpc_accel_idev_init);
+}
+
+static int cmpc_accel_remove(struct acpi_device *acpi, int type)
+{
+	device_remove_file(&acpi->dev, &cmpc_accel_sense_attr);
+	return cmpc_remove_acpi_notify_device(acpi, cmpc_accel_handler);
+}
+
+static const struct acpi_device_id cmpc_accel_device_ids[] = {
+	{"ACCE0000", 0},
+	{"", 0}
+};
+MODULE_DEVICE_TABLE(acpi, cmpc_accel_device_ids);
+
+static struct acpi_driver cmpc_accel_acpi_driver = {
+	.name = "cmpc_accel",
+	.class = "cmpc_accel",
+	.ids = cmpc_accel_device_ids,
+	.ops = {
+		.add = cmpc_accel_add,
+		.remove = cmpc_accel_remove
+	}
+};
+
+static bool cmpc_accel_driver_registered;
+
+
+/*
+ * Tablet mode code.
+ */
+static acpi_status cmpc_get_tablet(acpi_handle handle,
+				   unsigned long long *value)
+{
+	union acpi_object param;
+	struct acpi_object_list input;
+	unsigned long long output;
+	acpi_status status;
+
+	param.type = ACPI_TYPE_INTEGER;
+	param.integer.value = 0x01;
+	input.count = 1;
+	input.pointer = &param;
+	status = acpi_evaluate_integer(handle, "TCMD", &input, &output);
+	if (ACPI_SUCCESS(status))
+		*value = output;
+	return status;
+}
+
+static void cmpc_tablet_handler(acpi_handle handle, u32 event, void *ctx)
+{
+	unsigned long long val = 0;
+	struct input_dev *inputdev = ctx;
+
+	if (event == 0x81) {
+		if (ACPI_SUCCESS(cmpc_get_tablet(handle, &val)))
+			input_report_switch(inputdev, SW_TABLET_MODE, !val);
+	}
+}
+
+static void cmpc_tablet_idev_init(struct input_dev *inputdev)
+{
+	set_bit(EV_SW, inputdev->evbit);
+	set_bit(SW_TABLET_MODE, inputdev->swbit);
+}
+
+static int cmpc_tablet_add(struct acpi_device *acpi)
+{
+	return cmpc_add_acpi_notify_device(acpi, "cmpc_tablet",
+					   cmpc_tablet_handler,
+					   cmpc_tablet_idev_init);
+}
+
+static int cmpc_tablet_remove(struct acpi_device *acpi, int type)
+{
+	return cmpc_remove_acpi_notify_device(acpi, cmpc_tablet_handler);
+}
+
+static const struct acpi_device_id cmpc_tablet_device_ids[] = {
+	{"TBLT0000", 0},
+	{"", 0}
+};
+MODULE_DEVICE_TABLE(acpi, cmpc_tablet_device_ids);
+
+static struct acpi_driver cmpc_tablet_acpi_driver = {
+	.name = "cmpc_tablet",
+	.class = "cmpc_tablet",
+	.ids = cmpc_tablet_device_ids,
+	.ops = {
+		.add = cmpc_tablet_add,
+		.remove = cmpc_tablet_remove
+	}
+};
+
+static bool cmpc_tablet_driver_registered;
+
+
+/*
+ * Backlight code.
+ */
+
+static acpi_status cmpc_get_brightness(acpi_handle handle,
+				       unsigned long long *value)
+{
+	union acpi_object param;
+	struct acpi_object_list input;
+	unsigned long long output;
+	acpi_status status;
+
+	param.type = ACPI_TYPE_INTEGER;
+	param.integer.value = 0xC0;
+	input.count = 1;
+	input.pointer = &param;
+	status = acpi_evaluate_integer(handle, "GRDI", &input, &output);
+	if (ACPI_SUCCESS(status))
+		*value = output;
+	return status;
+}
+
+static acpi_status cmpc_set_brightness(acpi_handle handle,
+				       unsigned long long value)
+{
+	union acpi_object param[2];
+	struct acpi_object_list input;
+	acpi_status status;
+	unsigned long long output;
+
+	param[0].type = ACPI_TYPE_INTEGER;
+	param[0].integer.value = 0xC0;
+	param[1].type = ACPI_TYPE_INTEGER;
+	param[1].integer.value = value;
+	input.count = 2;
+	input.pointer = param;
+	status = acpi_evaluate_integer(handle, "GWRI", &input, &output);
+	return status;
+}
+
+static int cmpc_bl_get_brightness(struct backlight_device *bd)
+{
+	acpi_status status;
+	acpi_handle handle;
+	unsigned long long brightness;
+
+	handle = bl_get_data(bd);
+	status = cmpc_get_brightness(handle, &brightness);
+	if (ACPI_SUCCESS(status))
+		return brightness;
+	else
+		return -1;
+}
+
+static int cmpc_bl_update_status(struct backlight_device *bd)
+{
+	acpi_status status;
+	acpi_handle handle;
+
+	handle = bl_get_data(bd);
+	status = cmpc_set_brightness(handle, bd->props.brightness);
+	if (ACPI_SUCCESS(status))
+		return 0;
+	else
+		return -1;
+}
+
+static struct backlight_ops cmpc_bl_ops = {
+	.get_brightness = cmpc_bl_get_brightness,
+	.update_status = cmpc_bl_update_status
+};
+
+static int cmpc_bl_add(struct acpi_device *acpi)
+{
+	struct backlight_device *bd;
+
+	bd = backlight_device_register("cmpc_bl", &acpi->dev,
+				       acpi->handle, &cmpc_bl_ops);
+	bd->props.max_brightness = 7;
+	dev_set_drvdata(&acpi->dev, bd);
+	return 0;
+}
+
+static int cmpc_bl_remove(struct acpi_device *acpi, int type)
+{
+	struct backlight_device *bd;
+
+	bd = dev_get_drvdata(&acpi->dev);
+	backlight_device_unregister(bd);
+	return 0;
+}
+
+static const struct acpi_device_id cmpc_device_ids[] = {
+	{"IPML200", 0},
+	{"", 0}
+};
+MODULE_DEVICE_TABLE(acpi, cmpc_device_ids);
+
+static struct acpi_driver cmpc_bl_acpi_driver = {
+	.name = "cmpc",
+	.class = "cmpc",
+	.ids = cmpc_device_ids,
+	.ops = {
+		.add = cmpc_bl_add,
+		.remove = cmpc_bl_remove
+	}
+};
+
+static bool cmpc_bl_driver_registered;
+
+
+/*
+ * Extra keys code.
+ */
+static int cmpc_keys_codes[] = {
+	KEY_UNKNOWN,
+	KEY_WLAN,
+	KEY_SWITCHVIDEOMODE,
+	KEY_BRIGHTNESSDOWN,
+	KEY_BRIGHTNESSUP,
+	KEY_VENDOR,
+	KEY_MAX
+};
+
+static void cmpc_keys_handler(acpi_handle handle, u32 event, void *ctx)
+{
+	struct input_dev *inputdev;
+	int code = KEY_MAX;
+
+	if ((event & 0x0F) < ARRAY_SIZE(cmpc_keys_codes))
+		code = cmpc_keys_codes[event & 0x0F];
+	inputdev = ctx;
+	input_report_key(inputdev, code, !(event & 0x10));
+}
+
+static void cmpc_keys_idev_init(struct input_dev *inputdev)
+{
+	int i;
+
+	set_bit(EV_KEY, inputdev->evbit);
+	for (i = 0; cmpc_keys_codes[i] != KEY_MAX; i++)
+		set_bit(cmpc_keys_codes[i], inputdev->keybit);
+}
+
+static int cmpc_keys_add(struct acpi_device *acpi)
+{
+	return cmpc_add_acpi_notify_device(acpi, "cmpc_keys",
+					   cmpc_keys_handler,
+					   cmpc_keys_idev_init);
+}
+
+static int cmpc_keys_remove(struct acpi_device *acpi, int type)
+{
+	return cmpc_remove_acpi_notify_device(acpi, cmpc_keys_handler);
+}
+
+static const struct acpi_device_id cmpc_keys_device_ids[] = {
+	{"FnBT0000", 0},
+	{"", 0}
+};
+MODULE_DEVICE_TABLE(acpi, cmpc_keys_device_ids);
+
+static struct acpi_driver cmpc_keys_acpi_driver = {
+	.name = "cmpc_keys",
+	.class = "cmpc_keys",
+	.ids = cmpc_keys_device_ids,
+	.ops = {
+		.add = cmpc_keys_add,
+		.remove = cmpc_keys_remove
+	}
+};
+
+static bool cmpc_keys_driver_registered;
+
+
+/*
+ * General init/exit code.
+ */
+
+static int cmpc_init(void)
+{
+	int result;
+
+	result = acpi_bus_register_driver(&cmpc_keys_acpi_driver);
+	cmpc_keys_driver_registered = !!result;
+	result = acpi_bus_register_driver(&cmpc_bl_acpi_driver);
+	cmpc_bl_driver_registered = !!result;
+	result = acpi_bus_register_driver(&cmpc_tablet_acpi_driver);
+	cmpc_tablet_driver_registered = !!result;
+	result = acpi_bus_register_driver(&cmpc_accel_acpi_driver);
+	cmpc_accel_driver_registered = !!result;
+	/*
+	 * Not every CMPC has every ACPI device supported here. So always return
+	 * success.
+	 */
+	return 0;
+}
+
+static void cmpc_exit(void)
+{
+	if (cmpc_accel_driver_registered)
+		acpi_bus_unregister_driver(&cmpc_accel_acpi_driver);
+	if (cmpc_tablet_driver_registered)
+		acpi_bus_unregister_driver(&cmpc_tablet_acpi_driver);
+	if (cmpc_bl_driver_registered)
+		acpi_bus_unregister_driver(&cmpc_bl_acpi_driver);
+	if (cmpc_keys_driver_registered)
+		acpi_bus_unregister_driver(&cmpc_keys_acpi_driver);
+}
+
+module_init(cmpc_init);
+module_exit(cmpc_exit);
_

Patches currently in -mm which might be from cascardo@holoscopio.com are

linux-next.patch
cmpc_acpi-add-support-for-classmate-pc-acpi-devices.patch
misc-remove-mac-pmu-function-declaration-from-misc-device-class.patch
drivers-char-miscc-clear-allocation-bit-in-minor-bitmap-when-device-register-fails.patch
drivers-char-miscc-use-bitmap-bitops-functions-for-dynamic-minor-number-allocation.patch
drivers-char-miscc-use-a-proper-range-for-minor-number-dynamic-allocation.patch
spidev-use-declare_bitmap-instead-of-declaring-the-array.patch
spidev-use-declare_bitmap-instead-of-declaring-the-array-checkpatch-fixes.patch

