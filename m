From: akpm@linux-foundation.org
Subject: - firmware-move-firmware_class-from-documentation-to-samples.patch removed from -mm tree
Date: Sat, 23 Feb 2008 12:11:00 -0800
Message-ID: <200802232011.m1NKB0vl012960@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:56884 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752723AbYBWULR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 15:11:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, marcel@holtmann.org, mm-commits@vger.kernel.org


The patch titled
     firmware: move firmware_class from Documentation/ to samples/
has been removed from the -mm tree.  Its filename was
     firmware-move-firmware_class-from-documentation-to-samples.patch

This patch was dropped because greg merged something smiliar-but-different

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: firmware: move firmware_class from Documentation/ to samples/
From: Randy Dunlap <randy.dunlap@oracle.com>

Move the firmware_class sample drivers to samples/ so that they are
buildable and can be maintained.  Add Kconfig entry for firmware_class.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/firmware_class/firmware_sample_driver.c         |  115 -----
 Documentation/firmware_class/firmware_sample_firmware_class.c |  207 ----------
 samples/Kconfig                                               |    8 
 samples/Makefile                                              |    2 
 samples/firmware_class/Makefile                               |    1 
 samples/firmware_class/firmware_sample_driver.c               |  115 +++++
 samples/firmware_class/firmware_sample_firmware_class.c       |  207 ++++++++++
 7 files changed, 332 insertions(+), 323 deletions(-)

diff -puN Documentation/firmware_class/firmware_sample_driver.c~firmware-move-firmware_class-from-documentation-to-samples /dev/null
--- a/Documentation/firmware_class/firmware_sample_driver.c
+++ /dev/null
@@ -1,115 +0,0 @@
-/*
- * firmware_sample_driver.c -
- *
- * Copyright (c) 2003 Manuel Estrada Sainz
- *
- * Sample code on how to use request_firmware() from drivers.
- *
- */
-
-#include <linux/module.h>
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/device.h>
-#include <linux/string.h>
-
-#include "linux/firmware.h"
-
-static struct device ghost_device = {
-	.bus_id    = "ghost0",
-};
-
-
-static void sample_firmware_load(char *firmware, int size)
-{
-	u8 buf[size+1];
-	memcpy(buf, firmware, size);
-	buf[size] = '\0';
-	printk(KERN_INFO "firmware_sample_driver: firmware: %s\n", buf);
-}
-
-static void sample_probe_default(void)
-{
-	/* uses the default method to get the firmware */
-        const struct firmware *fw_entry;
-	printk(KERN_INFO "firmware_sample_driver: a ghost device got inserted :)\n");
-
-        if(request_firmware(&fw_entry, "sample_driver_fw", &ghost_device)!=0)
-	{
-		printk(KERN_ERR
-		       "firmware_sample_driver: Firmware not available\n");
-		return;
-	}
-	
-	sample_firmware_load(fw_entry->data, fw_entry->size);
-
-	release_firmware(fw_entry);
-
-	/* finish setting up the device */
-}
-static void sample_probe_specific(void)
-{
-	/* Uses some specific hotplug support to get the firmware from
-	 * userspace  directly into the hardware, or via some sysfs file */
-
-	/* NOTE: This currently doesn't work */
-
-	printk(KERN_INFO "firmware_sample_driver: a ghost device got inserted :)\n");
-
-        if(request_firmware(NULL, "sample_driver_fw", &ghost_device)!=0)
-	{
-		printk(KERN_ERR
-		       "firmware_sample_driver: Firmware load failed\n");
-		return;
-	}
-	
-	/* request_firmware blocks until userspace finished, so at
-	 * this point the firmware should be already in the device */
-
-	/* finish setting up the device */
-}
-static void sample_probe_async_cont(const struct firmware *fw, void *context)
-{
-	if(!fw){
-		printk(KERN_ERR
-		       "firmware_sample_driver: firmware load failed\n");
-		return;
-	}
-
-	printk(KERN_INFO "firmware_sample_driver: device pointer \"%s\"\n",
-	       (char *)context);
-	sample_firmware_load(fw->data, fw->size);
-}
-static void sample_probe_async(void)
-{
-	/* Let's say that I can't sleep */
-	int error;
-	error = request_firmware_nowait (THIS_MODULE, FW_ACTION_NOHOTPLUG,
-					 "sample_driver_fw", &ghost_device,
-					 "my device pointer",
-					 sample_probe_async_cont);
-	if(error){
-		printk(KERN_ERR 
-		       "firmware_sample_driver:"
-		       " request_firmware_nowait failed\n");
-	}
-}
-
-static int sample_init(void)
-{
-	device_initialize(&ghost_device);
-	/* since there is no real hardware insertion I just call the
-	 * sample probe functions here */
-	sample_probe_specific();
-	sample_probe_default();
-	sample_probe_async();
-	return 0;
-}
-static void __exit sample_exit(void)
-{
-}
-
-module_init (sample_init);
-module_exit (sample_exit);
-
-MODULE_LICENSE("GPL");
diff -puN Documentation/firmware_class/firmware_sample_firmware_class.c~firmware-move-firmware_class-from-documentation-to-samples /dev/null
--- a/Documentation/firmware_class/firmware_sample_firmware_class.c
+++ /dev/null
@@ -1,207 +0,0 @@
-/*
- * firmware_sample_firmware_class.c -
- *
- * Copyright (c) 2003 Manuel Estrada Sainz
- *
- * NOTE: This is just a probe of concept, if you think that your driver would
- * be well served by this mechanism please contact me first.
- *
- * DON'T USE THIS CODE AS IS
- *
- */
-
-#include <linux/device.h>
-#include <linux/module.h>
-#include <linux/init.h>
-#include <linux/timer.h>
-#include <linux/slab.h>
-#include <linux/string.h>
-#include <linux/firmware.h>
-
-
-MODULE_AUTHOR("Manuel Estrada Sainz");
-MODULE_DESCRIPTION("Hackish sample for using firmware class directly");
-MODULE_LICENSE("GPL");
-
-static inline struct class_device *to_class_dev(struct kobject *obj)
-{
-	return container_of(obj,struct class_device,kobj);
-}
-static inline
-struct class_device_attribute *to_class_dev_attr(struct attribute *_attr)
-{
-	return container_of(_attr,struct class_device_attribute,attr);
-}
-
-int sysfs_create_bin_file(struct kobject * kobj, struct bin_attribute * attr);
-int sysfs_remove_bin_file(struct kobject * kobj, struct bin_attribute * attr);
-
-struct firmware_priv {
-	char fw_id[FIRMWARE_NAME_MAX];
-	s32 loading:2;
-	u32 abort:1;
-};
-
-extern struct class firmware_class;
-
-static ssize_t firmware_loading_show(struct class_device *class_dev, char *buf)
-{
-	struct firmware_priv *fw_priv = class_get_devdata(class_dev);
-	return sprintf(buf, "%d\n", fw_priv->loading);
-}
-static ssize_t firmware_loading_store(struct class_device *class_dev,
-				      const char *buf, size_t count)
-{
-	struct firmware_priv *fw_priv = class_get_devdata(class_dev);
-	int prev_loading = fw_priv->loading;
-
-	fw_priv->loading = simple_strtol(buf, NULL, 10);
-	
-	switch(fw_priv->loading){
-	case -1:
-		/* abort load an panic */
-		break;
-	case 1:
-		/* setup load */
-		break;
-	case 0:
-		if(prev_loading==1){
-			/* finish load and get the device back to working
-			 * state */
-		}
-		break;
-	}
-
-	return count;
-}
-static CLASS_DEVICE_ATTR(loading, 0644,
-			 firmware_loading_show, firmware_loading_store);
-
-static ssize_t firmware_data_read(struct kobject *kobj,
-				  struct bin_attribute *bin_attr,
-				  char *buffer, loff_t offset, size_t count)
-{
-	struct class_device *class_dev = to_class_dev(kobj);
-	struct firmware_priv *fw_priv = class_get_devdata(class_dev);
-
-	/* read from the devices firmware memory */
-
-	return count;
-}
-static ssize_t firmware_data_write(struct kobject *kobj,
-				   struct bin_attribute *bin_attr,
-				   char *buffer, loff_t offset, size_t count)
-{
-	struct class_device *class_dev = to_class_dev(kobj);
-	struct firmware_priv *fw_priv = class_get_devdata(class_dev);
-
-	/* write to the devices firmware memory */
-
-	return count;
-}
-static struct bin_attribute firmware_attr_data = {
-	.attr = {.name = "data", .mode = 0644},
-	.size = 0,
-	.read = firmware_data_read,
-	.write = firmware_data_write,
-};
-static int fw_setup_class_device(struct class_device *class_dev,
-				 const char *fw_name,
-				 struct device *device)
-{
-	int retval;
-	struct firmware_priv *fw_priv;
-
-	fw_priv = kzalloc(sizeof(struct firmware_priv),	GFP_KERNEL);
-	if (!fw_priv) {
-		retval = -ENOMEM;
-		goto out;
-	}
-
-	memset(class_dev, 0, sizeof(*class_dev));
-
-	strncpy(fw_priv->fw_id, fw_name, FIRMWARE_NAME_MAX);
-	fw_priv->fw_id[FIRMWARE_NAME_MAX-1] = '\0';
-
-	strncpy(class_dev->class_id, device->bus_id, BUS_ID_SIZE);
-	class_dev->class_id[BUS_ID_SIZE-1] = '\0';
-	class_dev->dev = device;
-
-	class_dev->class = &firmware_class,
-	class_set_devdata(class_dev, fw_priv);
-	retval = class_device_register(class_dev);
-	if (retval){
-		printk(KERN_ERR "%s: class_device_register failed\n",
-		       __FUNCTION__);
-		goto error_free_fw_priv;
-	}
-
-	retval = sysfs_create_bin_file(&class_dev->kobj, &firmware_attr_data);
-	if (retval){
-		printk(KERN_ERR "%s: sysfs_create_bin_file failed\n",
-		       __FUNCTION__);
-		goto error_unreg_class_dev;
-	}
-
-	retval = class_device_create_file(class_dev,
-					  &class_device_attr_loading);
-	if (retval){
-		printk(KERN_ERR "%s: class_device_create_file failed\n",
-		       __FUNCTION__);
-		goto error_remove_data;
-	}
-
-	goto out;
-	
-error_remove_data:
-	sysfs_remove_bin_file(&class_dev->kobj, &firmware_attr_data);
-error_unreg_class_dev:
-	class_device_unregister(class_dev);
-error_free_fw_priv:
-	kfree(fw_priv);
-out:
-	return retval;
-}
-static void fw_remove_class_device(struct class_device *class_dev)
-{
-	struct firmware_priv *fw_priv = class_get_devdata(class_dev);
-
-	class_device_remove_file(class_dev, &class_device_attr_loading);
-	sysfs_remove_bin_file(&class_dev->kobj, &firmware_attr_data);
-	class_device_unregister(class_dev);
-}
-
-static struct class_device *class_dev;
-
-static struct device my_device = {
-	.bus_id    = "my_dev0",
-};
-
-static int __init firmware_sample_init(void)
-{
-	int error;
-
-	device_initialize(&my_device);
-	class_dev = kmalloc(sizeof(struct class_device), GFP_KERNEL);
-	if(!class_dev)
-		return -ENOMEM;
-
-	error = fw_setup_class_device(class_dev, "my_firmware_image",
-				      &my_device);
-	if(error){
-		kfree(class_dev);
-		return error;
-	}
-        return 0;
-
-}
-static void __exit firmware_sample_exit(void)
-{
-	struct firmware_priv *fw_priv = class_get_devdata(class_dev);
-	fw_remove_class_device(class_dev);
-	kfree(fw_priv);
-	kfree(class_dev);
-}
-module_init(firmware_sample_init);
-module_exit(firmware_sample_exit);
-
diff -puN samples/Kconfig~firmware-move-firmware_class-from-documentation-to-samples samples/Kconfig
--- a/samples/Kconfig~firmware-move-firmware_class-from-documentation-to-samples
+++ a/samples/Kconfig
@@ -22,5 +22,13 @@ config SAMPLE_KOBJECT
 
 	  If in doubt, say "N" here.
 
+config SAMPLE_FIRMWARE_CLASS
+	tristate "Build firmware_class examples -- loadable modules only"
+	depends on FW_LOADER && m
+	help
+	  This build firmware_class example modules.
+
+	  If in doubt, say "N" here.
+
 endif # SAMPLES
 
diff -puN samples/Makefile~firmware-move-firmware_class-from-documentation-to-samples samples/Makefile
--- a/samples/Makefile~firmware-move-firmware_class-from-documentation-to-samples
+++ a/samples/Makefile
@@ -1,3 +1,3 @@
 # Makefile for Linux samples code
 
-obj-$(CONFIG_SAMPLES)	+= markers/ kobject/
+obj-$(CONFIG_SAMPLES)	+= markers/ kobject/ firmware_class/
diff -puN /dev/null samples/firmware_class/Makefile
--- /dev/null
+++ a/samples/firmware_class/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_SAMPLE_FIRMWARE_CLASS) += firmware_sample_driver.o firmware_sample_firmware_class.o
diff -puN /dev/null samples/firmware_class/firmware_sample_driver.c
--- /dev/null
+++ a/samples/firmware_class/firmware_sample_driver.c
@@ -0,0 +1,115 @@
+/*
+ * firmware_sample_driver.c -
+ *
+ * Copyright (c) 2003 Manuel Estrada Sainz
+ *
+ * Sample code on how to use request_firmware() from drivers.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/device.h>
+#include <linux/string.h>
+
+#include "linux/firmware.h"
+
+static struct device ghost_device = {
+	.bus_id    = "ghost0",
+};
+
+
+static void sample_firmware_load(char *firmware, int size)
+{
+	u8 buf[size+1];
+	memcpy(buf, firmware, size);
+	buf[size] = '\0';
+	printk(KERN_INFO "firmware_sample_driver: firmware: %s\n", buf);
+}
+
+static void sample_probe_default(void)
+{
+	/* uses the default method to get the firmware */
+        const struct firmware *fw_entry;
+	printk(KERN_INFO "firmware_sample_driver: a ghost device got inserted :)\n");
+
+        if(request_firmware(&fw_entry, "sample_driver_fw", &ghost_device)!=0)
+	{
+		printk(KERN_ERR
+		       "firmware_sample_driver: Firmware not available\n");
+		return;
+	}
+
+	sample_firmware_load(fw_entry->data, fw_entry->size);
+
+	release_firmware(fw_entry);
+
+	/* finish setting up the device */
+}
+static void sample_probe_specific(void)
+{
+	/* Uses some specific hotplug support to get the firmware from
+	 * userspace  directly into the hardware, or via some sysfs file */
+
+	/* NOTE: This currently doesn't work */
+
+	printk(KERN_INFO "firmware_sample_driver: a ghost device got inserted :)\n");
+
+        if(request_firmware(NULL, "sample_driver_fw", &ghost_device)!=0)
+	{
+		printk(KERN_ERR
+		       "firmware_sample_driver: Firmware load failed\n");
+		return;
+	}
+
+	/* request_firmware blocks until userspace finished, so at
+	 * this point the firmware should be already in the device */
+
+	/* finish setting up the device */
+}
+static void sample_probe_async_cont(const struct firmware *fw, void *context)
+{
+	if(!fw){
+		printk(KERN_ERR
+		       "firmware_sample_driver: firmware load failed\n");
+		return;
+	}
+
+	printk(KERN_INFO "firmware_sample_driver: device pointer \"%s\"\n",
+	       (char *)context);
+	sample_firmware_load(fw->data, fw->size);
+}
+static void sample_probe_async(void)
+{
+	/* Let's say that I can't sleep */
+	int error;
+	error = request_firmware_nowait (THIS_MODULE, FW_ACTION_NOHOTPLUG,
+					 "sample_driver_fw", &ghost_device,
+					 "my device pointer",
+					 sample_probe_async_cont);
+	if(error){
+		printk(KERN_ERR
+		       "firmware_sample_driver:"
+		       " request_firmware_nowait failed\n");
+	}
+}
+
+static int sample_init(void)
+{
+	device_initialize(&ghost_device);
+	/* since there is no real hardware insertion I just call the
+	 * sample probe functions here */
+	sample_probe_specific();
+	sample_probe_default();
+	sample_probe_async();
+	return 0;
+}
+static void __exit sample_exit(void)
+{
+}
+
+module_init (sample_init);
+module_exit (sample_exit);
+
+MODULE_LICENSE("GPL");
diff -puN /dev/null samples/firmware_class/firmware_sample_firmware_class.c
--- /dev/null
+++ a/samples/firmware_class/firmware_sample_firmware_class.c
@@ -0,0 +1,207 @@
+/*
+ * firmware_sample_firmware_class.c -
+ *
+ * Copyright (c) 2003 Manuel Estrada Sainz
+ *
+ * NOTE: This is just a probe of concept, if you think that your driver would
+ * be well served by this mechanism please contact me first.
+ *
+ * DON'T USE THIS CODE AS IS
+ *
+ */
+
+#include <linux/device.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/timer.h>
+#include <linux/slab.h>
+#include <linux/string.h>
+#include <linux/firmware.h>
+
+
+MODULE_AUTHOR("Manuel Estrada Sainz");
+MODULE_DESCRIPTION("Hackish sample for using firmware class directly");
+MODULE_LICENSE("GPL");
+
+static inline struct class_device *to_class_dev(struct kobject *obj)
+{
+	return container_of(obj,struct class_device,kobj);
+}
+static inline
+struct class_device_attribute *to_class_dev_attr(struct attribute *_attr)
+{
+	return container_of(_attr,struct class_device_attribute,attr);
+}
+
+int sysfs_create_bin_file(struct kobject * kobj, struct bin_attribute * attr);
+int sysfs_remove_bin_file(struct kobject * kobj, struct bin_attribute * attr);
+
+struct firmware_priv {
+	char fw_id[FIRMWARE_NAME_MAX];
+	s32 loading:2;
+	u32 abort:1;
+};
+
+extern struct class firmware_class;
+
+static ssize_t firmware_loading_show(struct class_device *class_dev, char *buf)
+{
+	struct firmware_priv *fw_priv = class_get_devdata(class_dev);
+	return sprintf(buf, "%d\n", fw_priv->loading);
+}
+static ssize_t firmware_loading_store(struct class_device *class_dev,
+				      const char *buf, size_t count)
+{
+	struct firmware_priv *fw_priv = class_get_devdata(class_dev);
+	int prev_loading = fw_priv->loading;
+
+	fw_priv->loading = simple_strtol(buf, NULL, 10);
+
+	switch(fw_priv->loading){
+	case -1:
+		/* abort load an panic */
+		break;
+	case 1:
+		/* setup load */
+		break;
+	case 0:
+		if(prev_loading==1){
+			/* finish load and get the device back to working
+			 * state */
+		}
+		break;
+	}
+
+	return count;
+}
+static CLASS_DEVICE_ATTR(loading, 0644,
+			 firmware_loading_show, firmware_loading_store);
+
+static ssize_t firmware_data_read(struct kobject *kobj,
+				  struct bin_attribute *bin_attr,
+				  char *buffer, loff_t offset, size_t count)
+{
+	struct class_device *class_dev = to_class_dev(kobj);
+	struct firmware_priv *fw_priv = class_get_devdata(class_dev);
+
+	/* read from the devices firmware memory */
+
+	return count;
+}
+static ssize_t firmware_data_write(struct kobject *kobj,
+				   struct bin_attribute *bin_attr,
+				   char *buffer, loff_t offset, size_t count)
+{
+	struct class_device *class_dev = to_class_dev(kobj);
+	struct firmware_priv *fw_priv = class_get_devdata(class_dev);
+
+	/* write to the devices firmware memory */
+
+	return count;
+}
+static struct bin_attribute firmware_attr_data = {
+	.attr = {.name = "data", .mode = 0644},
+	.size = 0,
+	.read = firmware_data_read,
+	.write = firmware_data_write,
+};
+static int fw_setup_class_device(struct class_device *class_dev,
+				 const char *fw_name,
+				 struct device *device)
+{
+	int retval;
+	struct firmware_priv *fw_priv;
+
+	fw_priv = kzalloc(sizeof(struct firmware_priv),	GFP_KERNEL);
+	if (!fw_priv) {
+		retval = -ENOMEM;
+		goto out;
+	}
+
+	memset(class_dev, 0, sizeof(*class_dev));
+
+	strncpy(fw_priv->fw_id, fw_name, FIRMWARE_NAME_MAX);
+	fw_priv->fw_id[FIRMWARE_NAME_MAX-1] = '\0';
+
+	strncpy(class_dev->class_id, device->bus_id, BUS_ID_SIZE);
+	class_dev->class_id[BUS_ID_SIZE-1] = '\0';
+	class_dev->dev = device;
+
+	class_dev->class = &firmware_class,
+	class_set_devdata(class_dev, fw_priv);
+	retval = class_device_register(class_dev);
+	if (retval){
+		printk(KERN_ERR "%s: class_device_register failed\n",
+		       __FUNCTION__);
+		goto error_free_fw_priv;
+	}
+
+	retval = sysfs_create_bin_file(&class_dev->kobj, &firmware_attr_data);
+	if (retval){
+		printk(KERN_ERR "%s: sysfs_create_bin_file failed\n",
+		       __FUNCTION__);
+		goto error_unreg_class_dev;
+	}
+
+	retval = class_device_create_file(class_dev,
+					  &class_device_attr_loading);
+	if (retval){
+		printk(KERN_ERR "%s: class_device_create_file failed\n",
+		       __FUNCTION__);
+		goto error_remove_data;
+	}
+
+	goto out;
+
+error_remove_data:
+	sysfs_remove_bin_file(&class_dev->kobj, &firmware_attr_data);
+error_unreg_class_dev:
+	class_device_unregister(class_dev);
+error_free_fw_priv:
+	kfree(fw_priv);
+out:
+	return retval;
+}
+static void fw_remove_class_device(struct class_device *class_dev)
+{
+	struct firmware_priv *fw_priv = class_get_devdata(class_dev);
+
+	class_device_remove_file(class_dev, &class_device_attr_loading);
+	sysfs_remove_bin_file(&class_dev->kobj, &firmware_attr_data);
+	class_device_unregister(class_dev);
+}
+
+static struct class_device *class_dev;
+
+static struct device my_device = {
+	.bus_id    = "my_dev0",
+};
+
+static int __init firmware_sample_init(void)
+{
+	int error;
+
+	device_initialize(&my_device);
+	class_dev = kmalloc(sizeof(struct class_device), GFP_KERNEL);
+	if(!class_dev)
+		return -ENOMEM;
+
+	error = fw_setup_class_device(class_dev, "my_firmware_image",
+				      &my_device);
+	if(error){
+		kfree(class_dev);
+		return error;
+	}
+        return 0;
+
+}
+static void __exit firmware_sample_exit(void)
+{
+	struct firmware_priv *fw_priv = class_get_devdata(class_dev);
+	fw_remove_class_device(class_dev);
+	kfree(fw_priv);
+	kfree(class_dev);
+}
+
+module_init(firmware_sample_init);
+module_exit(firmware_sample_exit);
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
make-lkdtm-depend-on-block.patch
git-acpi.patch
apanel-fix-kconfig-dependencies.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
git-unionfs.patch
wireless-rt2x00-fix-driver-menu-indenting.patch
x86-visws-fix-printk-format-warnings.patch
kernel-doc-fix-function-pointer-parameter-parsing.patch
let-log_buf_shift-default-to-17.patch
documentation-move-spidev_fdx-example-to-its-own-source-file.patch
firmware-move-firmware_class-from-documentation-to-samples.patch
profile-likely-unlikely-macros.patch
