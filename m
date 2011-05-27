From: akpm@linux-foundation.org
Subject: [merged] w1-add-1-wire-w1-ds2408-8-channel-addressable-switch-support.patch removed from -mm tree
Date: Fri, 27 May 2011 12:59:14 -0700
Message-ID: <201105271957.p4RJvJJ1017657@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58618 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932148Ab1E0T6Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 May 2011 15:58:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dagenaisj@sonatest.com, johnpol@2ka.mipt.ru, mreimer@vpop.net, randy.dunlap@oracle.com, szabolcs.gyurko@tlt.hu, mm-commits@vger.kernel.org


The patch titled
     w1: add 1-wire (w1) DS2408 8-Channel Addressable Switch support
has been removed from the -mm tree.  Its filename was
     w1-add-1-wire-w1-ds2408-8-channel-addressable-switch-support.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: w1: add 1-wire (w1) DS2408 8-Channel Addressable Switch suppor=
t
=46rom: Jean-Fran=E7ois Dagenais <dagenaisj@sonatest.com>

This DS2408 w1 slave driver is not complete for all the features of the
chip, but its sufficient if you use it as a simple IO expander.

[randy.dunlap@oracle.com: fix w1_ds2408.c printk formats]
Signed-off-by: Jean-Fran=E7ois Dagenais <dagenaisj@sonatest.com>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: Szabolcs Gyurko <szabolcs.gyurko@tlt.hu>
Cc: Matt Reimer <mreimer@vpop.net>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/slaves/Kconfig     |    7=20
 drivers/w1/slaves/Makefile    |    1=20
 drivers/w1/slaves/w1_ds2408.c |  402 ++++++++++++++++++++++++++++++++
 drivers/w1/w1_family.h        |    1=20
 4 files changed, 411 insertions(+)

diff -puN drivers/w1/slaves/Kconfig~w1-add-1-wire-w1-ds2408-8-channel-a=
ddressable-switch-support drivers/w1/slaves/Kconfig
--- a/drivers/w1/slaves/Kconfig~w1-add-1-wire-w1-ds2408-8-channel-addre=
ssable-switch-support
+++ a/drivers/w1/slaves/Kconfig
@@ -16,6 +16,13 @@ config W1_SLAVE_SMEM
 	  Say Y here if you want to connect 1-wire
 	  simple 64bit memory rom(ds2401/ds2411/ds1990*) to your wire.
=20
+config W1_SLAVE_DS2408
+        tristate "8-Channel Addressable Switch (IO Expander) 0x29 fami=
ly support (DS2408)"
+        help
+          Say Y here if you want to use a 1-wire
+
+		  DS2408 8-Channel Addressable Switch device support
+
 config W1_SLAVE_DS2423
 	tristate "Counter 1-wire device (DS2423)"
 	select CRC16
diff -puN drivers/w1/slaves/Makefile~w1-add-1-wire-w1-ds2408-8-channel-=
addressable-switch-support drivers/w1/slaves/Makefile
--- a/drivers/w1/slaves/Makefile~w1-add-1-wire-w1-ds2408-8-channel-addr=
essable-switch-support
+++ a/drivers/w1/slaves/Makefile
@@ -4,6 +4,7 @@
=20
 obj-$(CONFIG_W1_SLAVE_THERM)	+=3D w1_therm.o
 obj-$(CONFIG_W1_SLAVE_SMEM)	+=3D w1_smem.o
+obj-$(CONFIG_W1_SLAVE_DS2408)   +=3D w1_ds2408.o
 obj-$(CONFIG_W1_SLAVE_DS2423)	+=3D w1_ds2423.o
 obj-$(CONFIG_W1_SLAVE_DS2431)	+=3D w1_ds2431.o
 obj-$(CONFIG_W1_SLAVE_DS2433)	+=3D w1_ds2433.o
diff -puN /dev/null drivers/w1/slaves/w1_ds2408.c
--- /dev/null
+++ a/drivers/w1/slaves/w1_ds2408.c
@@ -0,0 +1,402 @@
+/*
+ *	w1_ds2408.c - w1 family 29 (DS2408) driver
+ *
+ * Copyright (c) 2010 Jean-Francois Dagenais <dagenaisj@sonatest.com>
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
+MODULE_AUTHOR("Jean-Francois Dagenais <dagenaisj@sonatest.com>");
+MODULE_DESCRIPTION("w1 family 29 driver for DS2408 8 Pin IO");
+
+
+#define W1_F29_RETRIES		3
+
+#define W1_F29_REG_LOGIG_STATE             0x88 /* R */
+#define W1_F29_REG_OUTPUT_LATCH_STATE      0x89 /* R */
+#define W1_F29_REG_ACTIVITY_LATCH_STATE    0x8A /* R */
+#define W1_F29_REG_COND_SEARCH_SELECT_MASK 0x8B /* RW */
+#define W1_F29_REG_COND_SEARCH_POL_SELECT  0x8C /* RW */
+#define W1_F29_REG_CONTROL_AND_STATUS      0x8D /* RW */
+
+#define W1_F29_FUNC_READ_PIO_REGS          0xF0
+#define W1_F29_FUNC_CHANN_ACCESS_READ      0xF5
+#define W1_F29_FUNC_CHANN_ACCESS_WRITE     0x5A
+/* also used to write the control/status reg (0x8D): */
+#define W1_F29_FUNC_WRITE_COND_SEARCH_REG  0xCC
+#define W1_F29_FUNC_RESET_ACTIVITY_LATCHES 0xC3
+
+#define W1_F29_SUCCESS_CONFIRM_BYTE        0xAA
+
+static int _read_reg(struct w1_slave *sl, u8 address, unsigned char* b=
uf)
+{
+	u8 wrbuf[3];
+	dev_dbg(&sl->dev,
+			"Reading with slave: %p, reg addr: %0#4x, buff addr: %p",
+			sl, (unsigned int)address, buf);
+
+	if (!buf)
+		return -EINVAL;
+
+	mutex_lock(&sl->master->mutex);
+	dev_dbg(&sl->dev, "mutex locked");
+
+	if (w1_reset_select_slave(sl)) {
+		mutex_unlock(&sl->master->mutex);
+		return -EIO;
+	}
+
+	wrbuf[0] =3D W1_F29_FUNC_READ_PIO_REGS;
+	wrbuf[1] =3D address;
+	wrbuf[2] =3D 0;
+	w1_write_block(sl->master, wrbuf, 3);
+	*buf =3D w1_read_8(sl->master);
+
+	mutex_unlock(&sl->master->mutex);
+	dev_dbg(&sl->dev, "mutex unlocked");
+	return 1;
+}
+
+static ssize_t w1_f29_read_state(
+	struct file *filp, struct kobject *kobj,
+	struct bin_attribute *bin_attr,
+	char *buf, loff_t off, size_t count)
+{
+	dev_dbg(&kobj_to_w1_slave(kobj)->dev,
+		"Reading %s kobj: %p, off: %0#10x, count: %zu, buff addr: %p",
+		bin_attr->attr.name, kobj, (unsigned int)off, count, buf);
+	if (count !=3D 1 || off !=3D 0)
+		return -EFAULT;
+	return _read_reg(kobj_to_w1_slave(kobj), W1_F29_REG_LOGIG_STATE, buf)=
;
+}
+
+static ssize_t w1_f29_read_output(
+	struct file *filp, struct kobject *kobj,
+	struct bin_attribute *bin_attr,
+	char *buf, loff_t off, size_t count)
+{
+	dev_dbg(&kobj_to_w1_slave(kobj)->dev,
+		"Reading %s kobj: %p, off: %0#10x, count: %zu, buff addr: %p",
+		bin_attr->attr.name, kobj, (unsigned int)off, count, buf);
+	if (count !=3D 1 || off !=3D 0)
+		return -EFAULT;
+	return _read_reg(kobj_to_w1_slave(kobj),
+					 W1_F29_REG_OUTPUT_LATCH_STATE, buf);
+}
+
+static ssize_t w1_f29_read_activity(
+	struct file *filp, struct kobject *kobj,
+	struct bin_attribute *bin_attr,
+	char *buf, loff_t off, size_t count)
+{
+	dev_dbg(&kobj_to_w1_slave(kobj)->dev,
+		"Reading %s kobj: %p, off: %0#10x, count: %zu, buff addr: %p",
+		bin_attr->attr.name, kobj, (unsigned int)off, count, buf);
+	if (count !=3D 1 || off !=3D 0)
+		return -EFAULT;
+	return _read_reg(kobj_to_w1_slave(kobj),
+					 W1_F29_REG_ACTIVITY_LATCH_STATE, buf);
+}
+
+static ssize_t w1_f29_read_cond_search_mask(
+	struct file *filp, struct kobject *kobj,
+	struct bin_attribute *bin_attr,
+	char *buf, loff_t off, size_t count)
+{
+	dev_dbg(&kobj_to_w1_slave(kobj)->dev,
+		"Reading %s kobj: %p, off: %0#10x, count: %zu, buff addr: %p",
+		bin_attr->attr.name, kobj, (unsigned int)off, count, buf);
+	if (count !=3D 1 || off !=3D 0)
+		return -EFAULT;
+	return _read_reg(kobj_to_w1_slave(kobj),
+		W1_F29_REG_COND_SEARCH_SELECT_MASK, buf);
+}
+
+static ssize_t w1_f29_read_cond_search_polarity(
+	struct file *filp, struct kobject *kobj,
+	struct bin_attribute *bin_attr,
+	char *buf, loff_t off, size_t count)
+{
+	if (count !=3D 1 || off !=3D 0)
+		return -EFAULT;
+	return _read_reg(kobj_to_w1_slave(kobj),
+		W1_F29_REG_COND_SEARCH_POL_SELECT, buf);
+}
+
+static ssize_t w1_f29_read_status_control(
+	struct file *filp, struct kobject *kobj,
+	struct bin_attribute *bin_attr,
+	char *buf, loff_t off, size_t count)
+{
+	if (count !=3D 1 || off !=3D 0)
+		return -EFAULT;
+	return _read_reg(kobj_to_w1_slave(kobj),
+		W1_F29_REG_CONTROL_AND_STATUS, buf);
+}
+
+
+
+
+static ssize_t w1_f29_write_output(
+	struct file *filp, struct kobject *kobj,
+	struct bin_attribute *bin_attr,
+	char *buf, loff_t off, size_t count)
+{
+	struct w1_slave *sl =3D kobj_to_w1_slave(kobj);
+	u8 w1_buf[3];
+	u8 readBack;
+	unsigned int retries =3D W1_F29_RETRIES;
+
+	if (count !=3D 1 || off !=3D 0)
+		return -EFAULT;
+
+	dev_dbg(&sl->dev, "locking mutex for write_output");
+	mutex_lock(&sl->master->mutex);
+	dev_dbg(&sl->dev, "mutex locked");
+
+	if (w1_reset_select_slave(sl))
+		goto error;
+
+	while (retries--) {
+		w1_buf[0] =3D W1_F29_FUNC_CHANN_ACCESS_WRITE;
+		w1_buf[1] =3D *buf;
+		w1_buf[2] =3D ~(*buf);
+		w1_write_block(sl->master, w1_buf, 3);
+
+		readBack =3D w1_read_8(sl->master);
+		/* here the master could read another byte which
+		   would be the PIO reg (the actual pin logic state)
+		   since in this driver we don't know which pins are
+		   in and outs, there's no value to read the state and
+		   compare. with (*buf) so end this command abruptly: */
+		if (w1_reset_resume_command(sl->master))
+			goto error;
+
+		if (readBack !=3D 0xAA) {
+			/* try again, the slave is ready for a command */
+			continue;
+		}
+
+		/* go read back the output latches */
+		/* (the direct effect of the write above) */
+		w1_buf[0] =3D W1_F29_FUNC_READ_PIO_REGS;
+		w1_buf[1] =3D W1_F29_REG_OUTPUT_LATCH_STATE;
+		w1_buf[2] =3D 0;
+		w1_write_block(sl->master, w1_buf, 3);
+		/* read the result of the READ_PIO_REGS command */
+		if (w1_read_8(sl->master) =3D=3D *buf) {
+			/* success! */
+			mutex_unlock(&sl->master->mutex);
+			dev_dbg(&sl->dev,
+				"mutex unlocked, retries:%d", retries);
+			return 1;
+		}
+	}
+error:
+	mutex_unlock(&sl->master->mutex);
+	dev_dbg(&sl->dev, "mutex unlocked in error, retries:%d", retries);
+
+	return -EIO;
+}
+
+
+/**
+ * Writing to the activity file resets the activity latches.
+ */
+static ssize_t w1_f29_write_activity(
+	struct file *filp, struct kobject *kobj,
+	struct bin_attribute *bin_attr,
+	char *buf, loff_t off, size_t count)
+{
+	struct w1_slave *sl =3D kobj_to_w1_slave(kobj);
+	unsigned int retries =3D W1_F29_RETRIES;
+
+	if (count !=3D 1 || off !=3D 0)
+		return -EFAULT;
+
+	mutex_lock(&sl->master->mutex);
+
+	if (w1_reset_select_slave(sl))
+		goto error;
+
+	while (retries--) {
+		w1_write_8(sl->master, W1_F29_FUNC_RESET_ACTIVITY_LATCHES);
+		if (w1_read_8(sl->master) =3D=3D W1_F29_SUCCESS_CONFIRM_BYTE) {
+			mutex_unlock(&sl->master->mutex);
+			return 1;
+		}
+		if (w1_reset_resume_command(sl->master))
+			goto error;
+	}
+
+error:
+	mutex_unlock(&sl->master->mutex);
+	return -EIO;
+}
+
+static ssize_t w1_f29_write_status_control(
+	struct file *filp,
+	struct kobject *kobj,
+	struct bin_attribute *bin_attr,
+	char *buf,
+	loff_t off,
+	size_t count)
+{
+	struct w1_slave *sl =3D kobj_to_w1_slave(kobj);
+	u8 w1_buf[4];
+	unsigned int retries =3D W1_F29_RETRIES;
+
+	if (count !=3D 1 || off !=3D 0)
+		return -EFAULT;
+
+	mutex_lock(&sl->master->mutex);
+
+	if (w1_reset_select_slave(sl))
+		goto error;
+
+	while (retries--) {
+		w1_buf[0] =3D W1_F29_FUNC_WRITE_COND_SEARCH_REG;
+		w1_buf[1] =3D W1_F29_REG_CONTROL_AND_STATUS;
+		w1_buf[2] =3D 0;
+		w1_buf[3] =3D *buf;
+
+		w1_write_block(sl->master, w1_buf, 4);
+		if (w1_reset_resume_command(sl->master))
+			goto error;
+
+		w1_buf[0] =3D W1_F29_FUNC_READ_PIO_REGS;
+		w1_buf[1] =3D W1_F29_REG_CONTROL_AND_STATUS;
+		w1_buf[2] =3D 0;
+
+		w1_write_block(sl->master, w1_buf, 3);
+		if (w1_read_8(sl->master) =3D=3D *buf) {
+			/* success! */
+			mutex_unlock(&sl->master->mutex);
+			return 1;
+		}
+	}
+error:
+	mutex_unlock(&sl->master->mutex);
+
+	return -EIO;
+}
+
+
+
+#define NB_SYSFS_BIN_FILES 6
+static struct bin_attribute w1_f29_sysfs_bin_files[NB_SYSFS_BIN_FILES]=
 =3D {
+	{
+		.attr =3D	{
+			.name =3D "state",
+			.mode =3D S_IRUGO,
+		},
+		.size =3D 1,
+		.read =3D w1_f29_read_state,
+	},
+	{
+		.attr =3D	{
+			.name =3D "output",
+			.mode =3D S_IRUGO | S_IWUSR | S_IWGRP,
+		},
+		.size =3D 1,
+		.read =3D w1_f29_read_output,
+		.write =3D w1_f29_write_output,
+	},
+	{
+		.attr =3D	{
+			.name =3D "activity",
+			.mode =3D S_IRUGO,
+		},
+		.size =3D 1,
+		.read =3D w1_f29_read_activity,
+		.write =3D w1_f29_write_activity,
+	},
+	{
+		.attr =3D	{
+			.name =3D "cond_search_mask",
+			.mode =3D S_IRUGO,
+		},
+		.size =3D 1,
+		.read =3D w1_f29_read_cond_search_mask,
+		.write =3D 0,
+	},
+	{
+		.attr =3D	{
+			.name =3D "cond_search_polarity",
+			.mode =3D S_IRUGO,
+		},
+		.size =3D 1,
+		.read =3D w1_f29_read_cond_search_polarity,
+		.write =3D 0,
+	},
+	{
+		.attr =3D	{
+			.name =3D "status_control",
+			.mode =3D S_IRUGO | S_IWUSR | S_IWGRP,
+		},
+		.size =3D 1,
+		.read =3D w1_f29_read_status_control,
+		.write =3D w1_f29_write_status_control,
+	}
+};
+
+static int w1_f29_add_slave(struct w1_slave *sl)
+{
+	int err =3D 0;
+	int i;
+
+	for (i =3D 0; i < NB_SYSFS_BIN_FILES && !err; ++i)
+		err =3D sysfs_create_bin_file(
+			&sl->dev.kobj,
+			&(w1_f29_sysfs_bin_files[i]));
+	if (err)
+		while (--i >=3D 0)
+			sysfs_remove_bin_file(&sl->dev.kobj,
+				&(w1_f29_sysfs_bin_files[i]));
+	return err;
+}
+
+static void w1_f29_remove_slave(struct w1_slave *sl)
+{
+	int i;
+	for (i =3D NB_SYSFS_BIN_FILES; i <=3D 0; --i)
+		sysfs_remove_bin_file(&sl->dev.kobj,
+			&(w1_f29_sysfs_bin_files[i]));
+}
+
+static struct w1_family_ops w1_f29_fops =3D {
+	.add_slave      =3D w1_f29_add_slave,
+	.remove_slave   =3D w1_f29_remove_slave,
+};
+
+static struct w1_family w1_family_29 =3D {
+	.fid =3D W1_FAMILY_DS2408,
+	.fops =3D &w1_f29_fops,
+};
+
+static int __init w1_f29_init(void)
+{
+	return w1_register_family(&w1_family_29);
+}
+
+static void __exit w1_f29_exit(void)
+{
+	w1_unregister_family(&w1_family_29);
+}
+
+module_init(w1_f29_init);
+module_exit(w1_f29_exit);
diff -puN drivers/w1/w1_family.h~w1-add-1-wire-w1-ds2408-8-channel-addr=
essable-switch-support drivers/w1/w1_family.h
--- a/drivers/w1/w1_family.h~w1-add-1-wire-w1-ds2408-8-channel-addressa=
ble-switch-support
+++ a/drivers/w1/w1_family.h
@@ -34,6 +34,7 @@
 #define W1_THERM_DS1822  	0x22
 #define W1_EEPROM_DS2433  	0x23
 #define W1_THERM_DS18B20 	0x28
+#define W1_FAMILY_DS2408	0x29
 #define W1_EEPROM_DS2431	0x2D
 #define W1_FAMILY_DS2760	0x30
=20
_

Patches currently in -mm which might be from dagenaisj@sonatest.com are

origin.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
