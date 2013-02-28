From: akpm@linux-foundation.org
Subject: [merged] w1-add-support-for-ds2413-dual-channel-addressable-switch.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:17:45 -0800
Message-ID: <20130228201745.AB1E35A4242@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:52870 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759441Ab3B1URq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:17:46 -0500
Received: by mail-ye0-f201.google.com with SMTP id m12so245408yen.4
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:17:46 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: manio@skyboo.net, zbr@ioremap.net, mm-commits@vger.kernel.org


The patch titled
     Subject: w1: add support for DS2413 Dual Channel Addressable Switch
has been removed from the -mm tree.  Its filename was
     w1-add-support-for-ds2413-dual-channel-addressable-switch.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mariusz Bialonczyk <manio@skyboo.net>
Subject: w1: add support for DS2413 Dual Channel Addressable Switch

Also fixes some whitespace inconsistency in Kconfig and w1_family.h when
DS2408 chip support was added.

Signed-off-by: Mariusz Bialonczyk <manio@skyboo.net>
Acked-by: Evgeniy Polyakov <zbr@ioremap.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/slaves/Kconfig     |   13 +-
 drivers/w1/slaves/Makefile    |    3 
 drivers/w1/slaves/w1_ds2413.c |  177 ++++++++++++++++++++++++++++++++
 drivers/w1/w1_family.h        |    1 
 4 files changed, 189 insertions(+), 5 deletions(-)

diff -puN drivers/w1/slaves/Kconfig~w1-add-support-for-ds2413-dual-channel-addressable-switch drivers/w1/slaves/Kconfig
--- a/drivers/w1/slaves/Kconfig~w1-add-support-for-ds2413-dual-channel-addressable-switch
+++ a/drivers/w1/slaves/Kconfig
@@ -17,11 +17,16 @@ config W1_SLAVE_SMEM
 	  simple 64bit memory rom(ds2401/ds2411/ds1990*) to your wire.
 
 config W1_SLAVE_DS2408
-        tristate "8-Channel Addressable Switch (IO Expander) 0x29 family support (DS2408)"
-        help
-          Say Y here if you want to use a 1-wire
+	tristate "8-Channel Addressable Switch (IO Expander) 0x29 family support (DS2408)"
+	help
+	  Say Y here if you want to use a 1-wire
+	  DS2408 8-Channel Addressable Switch device support
 
-		  DS2408 8-Channel Addressable Switch device support
+config W1_SLAVE_DS2413
+	tristate "Dual Channel Addressable Switch 0x3a family support (DS2413)"
+	help
+	  Say Y here if you want to use a 1-wire
+	  DS2413 Dual Channel Addressable Switch device support
 
 config W1_SLAVE_DS2423
 	tristate "Counter 1-wire device (DS2423)"
diff -puN drivers/w1/slaves/Makefile~w1-add-support-for-ds2413-dual-channel-addressable-switch drivers/w1/slaves/Makefile
--- a/drivers/w1/slaves/Makefile~w1-add-support-for-ds2413-dual-channel-addressable-switch
+++ a/drivers/w1/slaves/Makefile
@@ -4,7 +4,8 @@
 
 obj-$(CONFIG_W1_SLAVE_THERM)	+= w1_therm.o
 obj-$(CONFIG_W1_SLAVE_SMEM)	+= w1_smem.o
-obj-$(CONFIG_W1_SLAVE_DS2408)   += w1_ds2408.o
+obj-$(CONFIG_W1_SLAVE_DS2408)	+= w1_ds2408.o
+obj-$(CONFIG_W1_SLAVE_DS2413)	+= w1_ds2413.o
 obj-$(CONFIG_W1_SLAVE_DS2423)	+= w1_ds2423.o
 obj-$(CONFIG_W1_SLAVE_DS2431)	+= w1_ds2431.o
 obj-$(CONFIG_W1_SLAVE_DS2433)	+= w1_ds2433.o
diff -puN /dev/null drivers/w1/slaves/w1_ds2413.c
--- /dev/null
+++ a/drivers/w1/slaves/w1_ds2413.c
@@ -0,0 +1,177 @@
+/*
+ * w1_ds2413.c - w1 family 3a (DS2413) driver
+ * based on w1_ds2408.c by Jean-Francois Dagenais <dagenaisj@sonatest.com>
+ *
+ * Copyright (c) 2013 Mariusz Bialonczyk <manio@skyboo.net>
+ *
+ * This source code is licensed under the GNU General Public License,
+ * Version 2. See the file COPYING for more details.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/device.h>
+#include <linux/types.h>
+#include <linux/delay.h>
+#include <linux/slab.h>
+
+#include "../w1.h"
+#include "../w1_int.h"
+#include "../w1_family.h"
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Mariusz Bialonczyk <manio@skyboo.net>");
+MODULE_DESCRIPTION("w1 family 3a driver for DS2413 2 Pin IO");
+
+#define W1_F3A_RETRIES                     3
+#define W1_F3A_FUNC_PIO_ACCESS_READ        0xF5
+#define W1_F3A_FUNC_PIO_ACCESS_WRITE       0x5A
+#define W1_F3A_SUCCESS_CONFIRM_BYTE        0xAA
+
+static ssize_t w1_f3a_read_state(
+	struct file *filp, struct kobject *kobj,
+	struct bin_attribute *bin_attr,
+	char *buf, loff_t off, size_t count)
+{
+	struct w1_slave *sl = kobj_to_w1_slave(kobj);
+	dev_dbg(&sl->dev,
+		"Reading %s kobj: %p, off: %0#10x, count: %zu, buff addr: %p",
+		bin_attr->attr.name, kobj, (unsigned int)off, count, buf);
+
+	if (off != 0)
+		return 0;
+	if (!buf)
+		return -EINVAL;
+
+	mutex_lock(&sl->master->bus_mutex);
+	dev_dbg(&sl->dev, "mutex locked");
+
+	if (w1_reset_select_slave(sl)) {
+		mutex_unlock(&sl->master->bus_mutex);
+		return -EIO;
+	}
+
+	w1_write_8(sl->master, W1_F3A_FUNC_PIO_ACCESS_READ);
+	*buf = w1_read_8(sl->master);
+
+	mutex_unlock(&sl->master->bus_mutex);
+	dev_dbg(&sl->dev, "mutex unlocked");
+
+	/* check for correct complement */
+	if ((*buf & 0x0F) != ((~*buf >> 4) & 0x0F))
+		return -EIO;
+	else
+		return 1;
+}
+
+static ssize_t w1_f3a_write_output(
+	struct file *filp, struct kobject *kobj,
+	struct bin_attribute *bin_attr,
+	char *buf, loff_t off, size_t count)
+{
+	struct w1_slave *sl = kobj_to_w1_slave(kobj);
+	u8 w1_buf[3];
+	unsigned int retries = W1_F3A_RETRIES;
+
+	if (count != 1 || off != 0)
+		return -EFAULT;
+
+	dev_dbg(&sl->dev, "locking mutex for write_output");
+	mutex_lock(&sl->master->bus_mutex);
+	dev_dbg(&sl->dev, "mutex locked");
+
+	if (w1_reset_select_slave(sl))
+		goto error;
+
+	/* according to the DS2413 datasheet the most significant 6 bits
+	   should be set to "1"s, so do it now */
+	*buf = *buf | 0xFC;
+
+	while (retries--) {
+		w1_buf[0] = W1_F3A_FUNC_PIO_ACCESS_WRITE;
+		w1_buf[1] = *buf;
+		w1_buf[2] = ~(*buf);
+		w1_write_block(sl->master, w1_buf, 3);
+
+		if (w1_read_8(sl->master) == W1_F3A_SUCCESS_CONFIRM_BYTE) {
+			mutex_unlock(&sl->master->bus_mutex);
+			dev_dbg(&sl->dev, "mutex unlocked, retries:%d", retries);
+			return 1;
+		}
+		if (w1_reset_resume_command(sl->master))
+			goto error;
+	}
+
+error:
+	mutex_unlock(&sl->master->bus_mutex);
+	dev_dbg(&sl->dev, "mutex unlocked in error, retries:%d", retries);
+	return -EIO;
+}
+
+#define NB_SYSFS_BIN_FILES 2
+static struct bin_attribute w1_f3a_sysfs_bin_files[NB_SYSFS_BIN_FILES] = {
+	{
+		.attr = {
+			.name = "state",
+			.mode = S_IRUGO,
+		},
+		.size = 1,
+		.read = w1_f3a_read_state,
+	},
+	{
+		.attr = {
+			.name = "output",
+			.mode = S_IRUGO | S_IWUSR | S_IWGRP,
+		},
+		.size = 1,
+		.write = w1_f3a_write_output,
+	}
+};
+
+static int w1_f3a_add_slave(struct w1_slave *sl)
+{
+	int err = 0;
+	int i;
+
+	for (i = 0; i < NB_SYSFS_BIN_FILES && !err; ++i)
+		err = sysfs_create_bin_file(
+			&sl->dev.kobj,
+			&(w1_f3a_sysfs_bin_files[i]));
+	if (err)
+		while (--i >= 0)
+			sysfs_remove_bin_file(&sl->dev.kobj,
+				&(w1_f3a_sysfs_bin_files[i]));
+	return err;
+}
+
+static void w1_f3a_remove_slave(struct w1_slave *sl)
+{
+	int i;
+	for (i = NB_SYSFS_BIN_FILES - 1; i >= 0; --i)
+		sysfs_remove_bin_file(&sl->dev.kobj,
+			&(w1_f3a_sysfs_bin_files[i]));
+}
+
+static struct w1_family_ops w1_f3a_fops = {
+	.add_slave      = w1_f3a_add_slave,
+	.remove_slave   = w1_f3a_remove_slave,
+};
+
+static struct w1_family w1_family_3a = {
+	.fid = W1_FAMILY_DS2413,
+	.fops = &w1_f3a_fops,
+};
+
+static int __init w1_f3a_init(void)
+{
+	return w1_register_family(&w1_family_3a);
+}
+
+static void __exit w1_f3a_exit(void)
+{
+	w1_unregister_family(&w1_family_3a);
+}
+
+module_init(w1_f3a_init);
+module_exit(w1_f3a_exit);
diff -puN drivers/w1/w1_family.h~w1-add-support-for-ds2413-dual-channel-addressable-switch drivers/w1/w1_family.h
--- a/drivers/w1/w1_family.h~w1-add-support-for-ds2413-dual-channel-addressable-switch
+++ a/drivers/w1/w1_family.h
@@ -39,6 +39,7 @@
 #define W1_EEPROM_DS2431	0x2D
 #define W1_FAMILY_DS2760	0x30
 #define W1_FAMILY_DS2780	0x32
+#define W1_FAMILY_DS2413	0x3A
 #define W1_THERM_DS1825		0x3B
 #define W1_FAMILY_DS2781	0x3D
 #define W1_THERM_DS28EA00	0x42
_

Patches currently in -mm which might be from manio@skyboo.net are

origin.patch

