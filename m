From: akpm@linux-foundation.org
Subject: [merged] rapidio-add-udev-notification.patch removed from -mm
 tree
Date: Mon, 08 Jul 2013 12:36:45 -0700
Message-ID: <51db14cd.8S6+sSCqPI6sG6ka%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51710 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613Ab3GHTgq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:36:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stef.van.os@Prodrive.nl, mporter@kernel.crashing.org, micha.nelissen@Prodrive.nl, leoli@freescale.com, jdelvare@suse.de, galak@kernel.crashing.org, andre.van.herk@Prodrive.nl, alexandre.bounine@idt.com

Subject: [merged] rapidio-add-udev-notification.patch removed from -mm tree
To: alexandre.bounine@idt.com,andre.van.herk@Prodrive.nl,galak@kernel.crashing.org,jdelvare@suse.de,leoli@freescale.com,micha.nelissen@Prodrive.nl,mporter@kernel.crashing.org,stef.van.os@Prodrive.nl,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:36:45 -0700


The patch titled
     Subject: rapidio: add udev notification
has been removed from the -mm tree.  Its filename was
     rapidio-add-udev-notification.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexandre Bounine <alexandre.bounine@idt.com>
Subject: rapidio: add udev notification

Add RapidIO-specific modalias generation to enable udev notifications
about RapidIO-specific events.

The RapidIO modalias string format is shown below:

"rapidio:vNNNNdNNNNavNNNNadNNNN"

Where:
v  - Device Vendor ID (16 bit),
d  - Device ID (16 bit),
av - Assembly Vendor ID (16 bit),
ad - Assembly ID (16 bit),

as they are reported in corresponding Capability Registers (CARs)
of each RapidIO device.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Li Yang <leoli@freescale.com>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: Andre van Herk <andre.van.herk@Prodrive.nl>
Cc: Micha Nelissen <micha.nelissen@Prodrive.nl>
Cc: Stef van Os <stef.van.os@Prodrive.nl>
Cc: Jean Delvare <jdelvare@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/rio-driver.c      |   18 ++++++++++++++++++
 drivers/rapidio/rio-sysfs.c       |   10 ++++++++++
 include/linux/mod_devicetable.h   |   19 +++++++++++++++++++
 include/linux/rio.h               |   16 +---------------
 include/linux/rio_ids.h           |    2 --
 scripts/mod/devicetable-offsets.c |    6 ++++++
 scripts/mod/file2alias.c          |   20 ++++++++++++++++++++
 7 files changed, 74 insertions(+), 17 deletions(-)

diff -puN drivers/rapidio/rio-driver.c~rapidio-add-udev-notification drivers/rapidio/rio-driver.c
--- a/drivers/rapidio/rio-driver.c~rapidio-add-udev-notification
+++ a/drivers/rapidio/rio-driver.c
@@ -199,6 +199,23 @@ static int rio_match_bus(struct device *
       out:return 0;
 }
 
+static int rio_uevent(struct device *dev, struct kobj_uevent_env *env)
+{
+	struct rio_dev *rdev;
+
+	if (!dev)
+		return -ENODEV;
+
+	rdev = to_rio_dev(dev);
+	if (!rdev)
+		return -ENODEV;
+
+	if (add_uevent_var(env, "MODALIAS=rapidio:v%04Xd%04Xav%04Xad%04X",
+			   rdev->vid, rdev->did, rdev->asm_vid, rdev->asm_did))
+		return -ENOMEM;
+	return 0;
+}
+
 struct device rio_bus = {
 	.init_name = "rapidio",
 };
@@ -210,6 +227,7 @@ struct bus_type rio_bus_type = {
 	.bus_attrs = rio_bus_attrs,
 	.probe = rio_device_probe,
 	.remove = rio_device_remove,
+	.uevent	= rio_uevent,
 };
 
 /**
diff -puN drivers/rapidio/rio-sysfs.c~rapidio-add-udev-notification drivers/rapidio/rio-sysfs.c
--- a/drivers/rapidio/rio-sysfs.c~rapidio-add-udev-notification
+++ a/drivers/rapidio/rio-sysfs.c
@@ -84,6 +84,15 @@ static ssize_t lnext_show(struct device
 	return str - buf;
 }
 
+static ssize_t modalias_show(struct device *dev,
+			     struct device_attribute *attr, char *buf)
+{
+	struct rio_dev *rdev = to_rio_dev(dev);
+
+	return sprintf(buf, "rapidio:v%04Xd%04Xav%04Xad%04X\n",
+		       rdev->vid, rdev->did, rdev->asm_vid, rdev->asm_did);
+}
+
 struct device_attribute rio_dev_attrs[] = {
 	__ATTR_RO(did),
 	__ATTR_RO(vid),
@@ -93,6 +102,7 @@ struct device_attribute rio_dev_attrs[]
 	__ATTR_RO(asm_rev),
 	__ATTR_RO(lprev),
 	__ATTR_RO(destid),
+	__ATTR_RO(modalias),
 	__ATTR_NULL,
 };
 
diff -puN include/linux/mod_devicetable.h~rapidio-add-udev-notification include/linux/mod_devicetable.h
--- a/include/linux/mod_devicetable.h~rapidio-add-udev-notification
+++ a/include/linux/mod_devicetable.h
@@ -579,4 +579,23 @@ struct mei_cl_device_id {
 	kernel_ulong_t driver_info;
 };
 
+/* RapidIO */
+
+#define RIO_ANY_ID	0xffff
+
+/**
+ * struct rio_device_id - RIO device identifier
+ * @did: RapidIO device ID
+ * @vid: RapidIO vendor ID
+ * @asm_did: RapidIO assembly device ID
+ * @asm_vid: RapidIO assembly vendor ID
+ *
+ * Identifies a RapidIO device based on both the device/vendor IDs and
+ * the assembly device/vendor IDs.
+ */
+struct rio_device_id {
+	__u16 did, vid;
+	__u16 asm_did, asm_vid;
+};
+
 #endif /* LINUX_MOD_DEVICETABLE_H */
diff -puN include/linux/rio.h~rapidio-add-udev-notification include/linux/rio.h
--- a/include/linux/rio.h~rapidio-add-udev-notification
+++ a/include/linux/rio.h
@@ -20,6 +20,7 @@
 #include <linux/errno.h>
 #include <linux/device.h>
 #include <linux/rio_regs.h>
+#include <linux/mod_devicetable.h>
 #ifdef CONFIG_RAPIDIO_DMA_ENGINE
 #include <linux/dmaengine.h>
 #endif
@@ -396,21 +397,6 @@ struct rio_driver {
 
 #define	to_rio_driver(drv) container_of(drv,struct rio_driver, driver)
 
-/**
- * struct rio_device_id - RIO device identifier
- * @did: RIO device ID
- * @vid: RIO vendor ID
- * @asm_did: RIO assembly device ID
- * @asm_vid: RIO assembly vendor ID
- *
- * Identifies a RIO device based on both the device/vendor IDs and
- * the assembly device/vendor IDs.
- */
-struct rio_device_id {
-	u16 did, vid;
-	u16 asm_did, asm_vid;
-};
-
 union rio_pw_msg {
 	struct {
 		u32 comptag;	/* Component Tag CSR */
diff -puN include/linux/rio_ids.h~rapidio-add-udev-notification include/linux/rio_ids.h
--- a/include/linux/rio_ids.h~rapidio-add-udev-notification
+++ a/include/linux/rio_ids.h
@@ -13,8 +13,6 @@
 #ifndef LINUX_RIO_IDS_H
 #define LINUX_RIO_IDS_H
 
-#define RIO_ANY_ID			0xffff
-
 #define RIO_VID_FREESCALE		0x0002
 #define RIO_DID_MPC8560			0x0003
 
diff -puN scripts/mod/devicetable-offsets.c~rapidio-add-udev-notification scripts/mod/devicetable-offsets.c
--- a/scripts/mod/devicetable-offsets.c~rapidio-add-udev-notification
+++ a/scripts/mod/devicetable-offsets.c
@@ -177,5 +177,11 @@ int main(void)
 	DEVID(mei_cl_device_id);
 	DEVID_FIELD(mei_cl_device_id, name);
 
+	DEVID(rio_device_id);
+	DEVID_FIELD(rio_device_id, did);
+	DEVID_FIELD(rio_device_id, vid);
+	DEVID_FIELD(rio_device_id, asm_did);
+	DEVID_FIELD(rio_device_id, asm_vid);
+
 	return 0;
 }
diff -puN scripts/mod/file2alias.c~rapidio-add-udev-notification scripts/mod/file2alias.c
--- a/scripts/mod/file2alias.c~rapidio-add-udev-notification
+++ a/scripts/mod/file2alias.c
@@ -1145,6 +1145,26 @@ static int do_mei_entry(const char *file
 }
 ADD_TO_DEVTABLE("mei", mei_cl_device_id, do_mei_entry);
 
+/* Looks like: rapidio:vNdNavNadN */
+static int do_rio_entry(const char *filename,
+			void *symval, char *alias)
+{
+	DEF_FIELD(symval, rio_device_id, did);
+	DEF_FIELD(symval, rio_device_id, vid);
+	DEF_FIELD(symval, rio_device_id, asm_did);
+	DEF_FIELD(symval, rio_device_id, asm_vid);
+
+	strcpy(alias, "rapidio:");
+	ADD(alias, "v", vid != RIO_ANY_ID, vid);
+	ADD(alias, "d", did != RIO_ANY_ID, did);
+	ADD(alias, "av", asm_vid != RIO_ANY_ID, asm_vid);
+	ADD(alias, "ad", asm_did != RIO_ANY_ID, asm_did);
+
+	add_wildcard(alias);
+	return 1;
+}
+ADD_TO_DEVTABLE("rapidio", rio_device_id, do_rio_entry);
+
 /* Does namelen bytes of name exactly match the symbol? */
 static bool sym_is(const char *name, unsigned namelen, const char *symbol)
 {
_

Patches currently in -mm which might be from alexandre.bounine@idt.com are

origin.patch
linux-next.patch

