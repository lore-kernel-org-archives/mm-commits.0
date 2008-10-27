From: akpm@linux-foundation.org
Subject: + add-c2-port-support.patch added to -mm tree
Date: Sun, 26 Oct 2008 23:26:33 -0700
Message-ID: <200810270626.m9R6QX7Y021339@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49012 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751346AbYJ0G0o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Oct 2008 02:26:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: giometti@linux.it, greg@kroah.com


The patch titled
     Add c2 port support
has been added to the -mm tree.  Its filename is
     add-c2-port-support.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Add c2 port support
From: Rodolfo Giometti <giometti@linux.it>

C2port implements a two wire serial communication protocol (bit
banging) designed to enable in-system programming, debugging, and
boundary-scan testing on low pin-count Silicon Labs devices.

Currently this code supports only flash programming through sysfs
interface but extensions shoud be easy to add.

Signed-off-by: Rodolfo Giometti <giometti@linux.it>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-c2port |   88 ++
 Documentation/c2port.txt               |   90 ++
 drivers/misc/Kconfig                   |    2 
 drivers/misc/Makefile                  |    1 
 drivers/misc/c2port/Kconfig            |   24 
 drivers/misc/c2port/Makefile           |    1 
 drivers/misc/c2port/core.c             | 1002 +++++++++++++++++++++++
 include/linux/c2port.h                 |   65 +
 8 files changed, 1273 insertions(+)

diff -puN /dev/null Documentation/ABI/testing/sysfs-c2port
--- /dev/null
+++ a/Documentation/ABI/testing/sysfs-c2port
@@ -0,0 +1,88 @@
+What:		/sys/class/c2port/
+Date:		October 2008
+Contact:	Rodolfo Giometti <giometti@linux.it>
+Description:
+		The /sys/class/c2port/ directory will contain files and
+		directories that will provide a unified interface to
+		the C2 port interface.
+
+What:		/sys/class/c2port/c2portX
+Date:		October 2008
+Contact:	Rodolfo Giometti <giometti@linux.it>
+Description:
+		The /sys/class/c2port/c2portX/ directory is related to X-th
+		C2 port into the system. Each directory will contain files to
+		manage and control its C2 port.
+
+What:		/sys/class/c2port/c2portX/access
+Date:		October 2008
+Contact:	Rodolfo Giometti <giometti@linux.it>
+Description:
+		The /sys/class/c2port/c2portX/access file enable the access
+		to the C2 port from the system. No commands can be sent
+		till this entry is set to 0.
+
+What:		/sys/class/c2port/c2portX/dev_id
+Date:		October 2008
+Contact:	Rodolfo Giometti <giometti@linux.it>
+Description:
+		The /sys/class/c2port/c2portX/dev_id file show the device ID
+		of the connected micro.
+
+What:		/sys/class/c2port/c2portX/flash_access
+Date:		October 2008
+Contact:	Rodolfo Giometti <giometti@linux.it>
+Description:
+		The /sys/class/c2port/c2portX/flash_access file enable the
+		access to the on-board flash of the connected micro.
+		No commands can be sent till this entry is set to 0.
+
+What:		/sys/class/c2port/c2portX/flash_block_size
+Date:		October 2008
+Contact:	Rodolfo Giometti <giometti@linux.it>
+Description:
+		The /sys/class/c2port/c2portX/flash_block_size file show
+		the on-board flash block size of the connected micro.
+
+What:		/sys/class/c2port/c2portX/flash_blocks_num
+Date:		October 2008
+Contact:	Rodolfo Giometti <giometti@linux.it>
+Description:
+		The /sys/class/c2port/c2portX/flash_blocks_num file show
+		the on-board flash blocks number of the connected micro.
+
+What:		/sys/class/c2port/c2portX/flash_data
+Date:		October 2008
+Contact:	Rodolfo Giometti <giometti@linux.it>
+Description:
+		The /sys/class/c2port/c2portX/flash_data file export
+		the content of the on-board flash of the connected micro.
+
+What:		/sys/class/c2port/c2portX/flash_erase
+Date:		October 2008
+Contact:	Rodolfo Giometti <giometti@linux.it>
+Description:
+		The /sys/class/c2port/c2portX/flash_erase file execute
+		the "erase" command on the on-board flash of the connected
+		micro.
+
+What:		/sys/class/c2port/c2portX/flash_erase
+Date:		October 2008
+Contact:	Rodolfo Giometti <giometti@linux.it>
+Description:
+		The /sys/class/c2port/c2portX/flash_erase file show the
+		on-board flash size of the connected micro.
+
+What:		/sys/class/c2port/c2portX/reset
+Date:		October 2008
+Contact:	Rodolfo Giometti <giometti@linux.it>
+Description:
+		The /sys/class/c2port/c2portX/reset file execute a "reset"
+		command on the connected micro.
+
+What:		/sys/class/c2port/c2portX/rev_id
+Date:		October 2008
+Contact:	Rodolfo Giometti <giometti@linux.it>
+Description:
+		The /sys/class/c2port/c2portX/rev_id file show the revision ID
+		of the connected micro.
diff -puN /dev/null Documentation/c2port.txt
--- /dev/null
+++ a/Documentation/c2port.txt
@@ -0,0 +1,90 @@
+			C2 port support
+			---------------
+
+(C) Copyright 2007 Rodolfo Giometti <giometti@enneenne.com>
+
+This program is free software; you can redistribute it and/or modify
+it under the terms of the GNU General Public License as published by
+the Free Software Foundation; either version 2 of the License, or
+(at your option) any later version.
+
+This program is distributed in the hope that it will be useful,
+but WITHOUT ANY WARRANTY; without even the implied warranty of
+MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+GNU General Public License for more details.
+
+
+
+Overview
+--------
+
+This driver implements the support for Linux of Silicon Labs (Silabs)
+C2 Interface used for in-system programming of micro controllers.
+
+By using this driver you can reprogram the in-system flash without EC2
+or EC3 debug adapter. This solution is also useful in those systems
+where the micro controller is connected via special GPIOs pins.
+
+References
+----------
+
+The C2 Interface main references are at (http://www.silabs.com)
+Silicon Laboratories site], see:
+
+- AN127: FLASH Programming via the C2 Interface at
+http://www.silabs.com/public/documents/tpub_doc/anote/Microcontrollers/Small_Form_Factor/en/an127.pdf, and
+
+- C2 Specification at
+http://www.silabs.com/public/documents/tpub_doc/spec/Microcontrollers/en/C2spec.pdf,
+
+however it implements a two wire serial communication protocol (bit
+banging) designed to enable in-system programming, debugging, and
+boundary-scan testing on low pin-count Silicon Labs devices. Currently
+this code supports only flash programming but extensions are easy to
+add.
+
+Using the driver
+----------------
+
+Once the driver is loaded you can use sysfs support to get C2port's
+info or read/write in-system flash.
+
+# ls /sys/class/c2port/c2port0/
+access            flash_block_size  flash_erase       rev_id
+dev_id            flash_blocks_num  flash_size        subsystem/
+flash_access      flash_data        reset             uevent
+
+Initially the C2port access is disabled since you hardware may have
+such lines multiplexed with other devices so, to get access to the
+C2port, you need the command:
+
+# echo 1 > /sys/class/c2port/c2port0/access
+
+after that you should read the device ID and revision ID of the
+connected micro controller:
+
+# cat /sys/class/c2port/c2port0/dev_id
+8
+# cat /sys/class/c2port/c2port0/rev_id
+1
+
+However, for security reasons, the in-system flash access in not
+enabled yet, to do so you need the command:
+
+# echo 1 > /sys/class/c2port/c2port0/flash_access
+
+After that you can read the whole flash:
+
+# cat /sys/class/c2port/c2port0/flash_data > image
+
+erase it:
+
+# echo 1 > /sys/class/c2port/c2port0/flash_erase
+
+and write it:
+
+# cat image > /sys/class/c2port/c2port0/flash_data
+
+after writing you have to reset the device to execute the new code:
+
+# echo 1 > /sys/class/c2port/c2port0/reset
diff -puN drivers/misc/Kconfig~add-c2-port-support drivers/misc/Kconfig
--- a/drivers/misc/Kconfig~add-c2-port-support
+++ a/drivers/misc/Kconfig
@@ -490,4 +490,6 @@ config SGI_GRU_DEBUG
 	This option enables addition debugging code for the SGI GRU driver. If
 	you are unsure, say N.
 
+source "drivers/misc/c2port/Kconfig"
+
 endif # MISC_DEVICES
diff -puN drivers/misc/Makefile~add-c2-port-support drivers/misc/Makefile
--- a/drivers/misc/Makefile~add-c2-port-support
+++ a/drivers/misc/Makefile
@@ -30,3 +30,4 @@ obj-$(CONFIG_KGDB_TESTS)	+= kgdbts.o
 obj-$(CONFIG_SGI_XP)		+= sgi-xp/
 obj-$(CONFIG_SGI_GRU)		+= sgi-gru/
 obj-$(CONFIG_HP_ILO)		+= hpilo.o
+obj-$(CONFIG_C2PORT)		+= c2port/
diff -puN /dev/null drivers/misc/c2port/Kconfig
--- /dev/null
+++ a/drivers/misc/c2port/Kconfig
@@ -0,0 +1,24 @@
+#
+# C2 port devices
+#
+
+menuconfig C2PORT
+	tristate "Silicon Labs C2 port support (EXPERIMENTAL)"
+	depends on EXPERIMENTAL
+	default no
+	help
+	  This option enables support for Silicon Labs C2 port used to
+	  program Silicon micro controller chips (and other 8051 compatible).
+
+	  If your board have no such micro controllers you don't need this
+	  interface at all.
+
+	  To compile this driver as a module, choose M here: the module will
+	  be called c2port_core. Note that you also need a client module
+	  usually called c2port-*.
+
+	  If you are not sure, say N here.
+
+if C2PORT
+
+endif # C2PORT
diff -puN /dev/null drivers/misc/c2port/Makefile
--- /dev/null
+++ a/drivers/misc/c2port/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_C2PORT)		+= core.o
diff -puN /dev/null drivers/misc/c2port/core.c
--- /dev/null
+++ a/drivers/misc/c2port/core.c
@@ -0,0 +1,1002 @@
+/*
+ *  Silicon Labs C2 port core Linux support
+ *
+ *  Copyright (c) 2007 Rodolfo Giometti <giometti@linux.it>
+ *  Copyright (c) 2007 Eurotech S.p.A. <info@eurotech.it>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/device.h>
+#include <linux/errno.h>
+#include <linux/err.h>
+#include <linux/kernel.h>
+#include <linux/ctype.h>
+#include <linux/delay.h>
+#include <linux/idr.h>
+
+#include <linux/c2port.h>
+
+#define DRIVER_NAME             "c2port"
+#define DRIVER_VERSION          "0.51.0"
+
+static DEFINE_SPINLOCK(c2port_idr_lock);
+static DEFINE_IDR(c2port_idr);
+
+/*
+ * Local variables
+ */
+
+static struct class *c2port_class;
+
+/*
+ * C2 registers & commands defines
+ */
+
+/* C2 registers */
+#define C2PORT_DEVICEID		0x00
+#define C2PORT_REVID		0x01
+#define C2PORT_FPCTL		0x02
+#define C2PORT_FPDAT		0xB4
+
+/* C2 interface commands */
+#define C2PORT_GET_VERSION	0x01
+#define C2PORT_DEVICE_ERASE	0x03
+#define C2PORT_BLOCK_READ	0x06
+#define C2PORT_BLOCK_WRITE	0x07
+#define C2PORT_PAGE_ERASE	0x08
+
+/* C2 status return codes */
+#define C2PORT_INVALID_COMMAND	0x00
+#define C2PORT_COMMAND_FAILED	0x02
+#define C2PORT_COMMAND_OK	0x0d
+
+/*
+ * C2 port low level signal managements
+ */
+
+static void c2port_reset(struct c2port_device *dev)
+{
+	struct c2port_ops *ops = dev->ops;
+
+	/* To reset the device we have to keep clock line low for at least
+	 * 20us.
+	 */
+	local_irq_disable();
+	ops->c2ck_set(dev, 0);
+	udelay(25);
+	ops->c2ck_set(dev, 1);
+	local_irq_enable();
+
+	udelay(1);
+}
+
+static void c2port_strobe_ck(struct c2port_device *dev)
+{
+	struct c2port_ops *ops = dev->ops;
+
+	/* During hi-low-hi transition we disable local IRQs to avoid
+	 * interructions since C2 port specification says that it must be
+	 * shorter than 5us, otherwise the microcontroller may consider
+	 * it as a reset signal!
+	 */
+	local_irq_disable();
+	ops->c2ck_set(dev, 0);
+	udelay(1);
+	ops->c2ck_set(dev, 1);
+	local_irq_enable();
+
+	udelay(1);
+}
+
+/*
+ * C2 port basic functions
+ */
+
+static void c2port_write_ar(struct c2port_device *dev, u8 addr)
+{
+	struct c2port_ops *ops = dev->ops;
+	int i;
+
+	/* START field */
+	c2port_strobe_ck(dev);
+
+	/* INS field (11b, LSB first) */
+	ops->c2d_dir(dev, 0);
+	ops->c2d_set(dev, 1);
+	c2port_strobe_ck(dev);
+	ops->c2d_set(dev, 1);
+	c2port_strobe_ck(dev);
+
+	/* ADDRESS field */
+	for (i = 0; i < 8; i++) {
+		ops->c2d_set(dev, addr & 0x01);
+		c2port_strobe_ck(dev);
+
+		addr >>= 1;
+	}
+
+	/* STOP field */
+	ops->c2d_dir(dev, 1);
+	c2port_strobe_ck(dev);
+}
+
+static int c2port_read_ar(struct c2port_device *dev, u8 *addr)
+{
+	struct c2port_ops *ops = dev->ops;
+	int i;
+
+	/* START field */
+	c2port_strobe_ck(dev);
+
+	/* INS field (10b, LSB first) */
+	ops->c2d_dir(dev, 0);
+	ops->c2d_set(dev, 0);
+	c2port_strobe_ck(dev);
+	ops->c2d_set(dev, 1);
+	c2port_strobe_ck(dev);
+
+	/* ADDRESS field */
+	ops->c2d_dir(dev, 1);
+	*addr = 0;
+	for (i = 0; i < 8; i++) {
+		*addr >>= 1;	/* shift in 8-bit ADDRESS field LSB first */
+
+		c2port_strobe_ck(dev);
+		if (ops->c2d_get(dev))
+			*addr |= 0x80;
+	}
+
+	/* STOP field */
+	c2port_strobe_ck(dev);
+
+	return 0;
+}
+
+static int c2port_write_dr(struct c2port_device *dev, u8 data)
+{
+	struct c2port_ops *ops = dev->ops;
+	int timeout, i;
+
+	/* START field */
+	c2port_strobe_ck(dev);
+
+	/* INS field (01b, LSB first) */
+	ops->c2d_dir(dev, 0);
+	ops->c2d_set(dev, 1);
+	c2port_strobe_ck(dev);
+	ops->c2d_set(dev, 0);
+	c2port_strobe_ck(dev);
+
+	/* LENGTH field (00b, LSB first -> 1 byte) */
+	ops->c2d_set(dev, 0);
+	c2port_strobe_ck(dev);
+	ops->c2d_set(dev, 0);
+	c2port_strobe_ck(dev);
+
+	/* DATA field */
+	for (i = 0; i < 8; i++) {
+		ops->c2d_set(dev, data & 0x01);
+		c2port_strobe_ck(dev);
+
+		data >>= 1;
+	}
+
+	/* WAIT field */
+	ops->c2d_dir(dev, 1);
+	timeout = 20;
+	do {
+		c2port_strobe_ck(dev);
+		if (ops->c2d_get(dev))
+			break;
+
+		udelay(1);
+	} while (--timeout > 0);
+	if (timeout == 0)
+		return -EIO;
+
+	/* STOP field */
+	c2port_strobe_ck(dev);
+
+	return 0;
+}
+
+static int c2port_read_dr(struct c2port_device *dev, u8 *data)
+{
+	struct c2port_ops *ops = dev->ops;
+	int timeout, i;
+
+	/* START field */
+	c2port_strobe_ck(dev);
+
+	/* INS field (00b, LSB first) */
+	ops->c2d_dir(dev, 0);
+	ops->c2d_set(dev, 0);
+	c2port_strobe_ck(dev);
+	ops->c2d_set(dev, 0);
+	c2port_strobe_ck(dev);
+
+	/* LENGTH field (00b, LSB first -> 1 byte) */
+	ops->c2d_set(dev, 0);
+	c2port_strobe_ck(dev);
+	ops->c2d_set(dev, 0);
+	c2port_strobe_ck(dev);
+
+	/* WAIT field */
+	ops->c2d_dir(dev, 1);
+	timeout = 20;
+	do {
+		c2port_strobe_ck(dev);
+		if (ops->c2d_get(dev))
+			break;
+
+		udelay(1);
+	} while (--timeout > 0);
+	if (timeout == 0)
+		return -EIO;
+
+	/* DATA field */
+	*data = 0;
+	for (i = 0; i < 8; i++) {
+		*data >>= 1;	/* shift in 8-bit DATA field LSB first */
+
+		c2port_strobe_ck(dev);
+		if (ops->c2d_get(dev))
+			*data |= 0x80;
+	}
+
+	/* STOP field */
+	c2port_strobe_ck(dev);
+
+	return 0;
+}
+
+static int c2port_poll_in_busy(struct c2port_device *dev)
+{
+	u8 addr;
+	int ret, timeout = 20;
+
+	do {
+		ret = (c2port_read_ar(dev, &addr));
+		if (ret < 0)
+			return -EIO;
+
+		if (!(addr & 0x02))
+			break;
+
+		udelay(1);
+	} while (--timeout > 0);
+	if (timeout == 0)
+		return -EIO;
+
+	return 0;
+}
+
+static int c2port_poll_out_ready(struct c2port_device *dev)
+{
+	u8 addr;
+	int ret, timeout = 10000; /* erase flash needs long time... */
+
+	do {
+		ret = (c2port_read_ar(dev, &addr));
+		if (ret < 0)
+			return -EIO;
+
+		if (addr & 0x01)
+			break;
+
+		udelay(1);
+	} while (--timeout > 0);
+	if (timeout == 0)
+		return -EIO;
+
+	return 0;
+}
+
+/*
+ * sysfs methods
+ */
+
+static ssize_t c2port_show_name(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct c2port_device *c2dev = dev_get_drvdata(dev);
+
+	return sprintf(buf, "%s\n", c2dev->name);
+}
+
+static ssize_t c2port_show_flash_blocks_num(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct c2port_device *c2dev = dev_get_drvdata(dev);
+	struct c2port_ops *ops = c2dev->ops;
+
+	return sprintf(buf, "%d\n", ops->blocks_num);
+}
+
+static ssize_t c2port_show_flash_block_size(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct c2port_device *c2dev = dev_get_drvdata(dev);
+	struct c2port_ops *ops = c2dev->ops;
+
+	return sprintf(buf, "%d\n", ops->block_size);
+}
+
+static ssize_t c2port_show_flash_size(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct c2port_device *c2dev = dev_get_drvdata(dev);
+	struct c2port_ops *ops = c2dev->ops;
+
+	return sprintf(buf, "%d\n", ops->blocks_num * ops->block_size);
+}
+
+static ssize_t c2port_show_access(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct c2port_device *c2dev = dev_get_drvdata(dev);
+
+	return sprintf(buf, "%d\n", c2dev->access);
+}
+
+static ssize_t c2port_store_access(struct device *dev,
+				struct device_attribute *attr,
+				const char *buf, size_t count)
+{
+	struct c2port_device *c2dev = dev_get_drvdata(dev);
+	struct c2port_ops *ops = c2dev->ops;
+	int status, ret;
+
+	ret = sscanf(buf, "%d", &status);
+	if (ret != 1)
+		return -EINVAL;
+
+	mutex_lock(&c2dev->mutex);
+
+	c2dev->access = !!status;
+
+	/* If access is "on" clock should be HIGH _before_ setting the line
+	 * as output and data line should be set as INPUT anyway */
+	if (c2dev->access)
+		ops->c2ck_set(c2dev, 1);
+	ops->access(c2dev, c2dev->access);
+	if (c2dev->access)
+		ops->c2d_dir(c2dev, 1);
+
+	mutex_unlock(&c2dev->mutex);
+
+	return count;
+}
+
+static ssize_t c2port_store_reset(struct device *dev,
+				struct device_attribute *attr,
+				const char *buf, size_t count)
+{
+	struct c2port_device *c2dev = dev_get_drvdata(dev);
+
+	/* Check the device access status */
+	if (!c2dev->access)
+		return -EBUSY;
+
+	mutex_lock(&c2dev->mutex);
+
+	c2port_reset(c2dev);
+	c2dev->flash_access = 0;
+
+	mutex_unlock(&c2dev->mutex);
+
+	return count;
+}
+
+static ssize_t __c2port_show_dev_id(struct c2port_device *dev, char *buf)
+{
+	u8 data;
+	int ret;
+
+	/* Select DEVICEID register for C2 data register accesses */
+	c2port_write_ar(dev, C2PORT_DEVICEID);
+
+	/* Read and return the device ID register */
+	ret = c2port_read_dr(dev, &data);
+	if (ret < 0)
+		return ret;
+
+	return sprintf(buf, "%d\n", data);
+}
+
+static ssize_t c2port_show_dev_id(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct c2port_device *c2dev = dev_get_drvdata(dev);
+	ssize_t ret;
+
+	/* Check the device access status */
+	if (!c2dev->access)
+		return -EBUSY;
+
+	mutex_lock(&c2dev->mutex);
+	ret = __c2port_show_dev_id(c2dev, buf);
+	mutex_unlock(&c2dev->mutex);
+
+	if (ret < 0)
+		dev_err(dev, "cannot read from %s\n", c2dev->name);
+
+	return ret;
+}
+
+static ssize_t __c2port_show_rev_id(struct c2port_device *dev, char *buf)
+{
+	u8 data;
+	int ret;
+
+	/* Select REVID register for C2 data register accesses */
+	c2port_write_ar(dev, C2PORT_REVID);
+
+	/* Read and return the revision ID register */
+	ret = c2port_read_dr(dev, &data);
+	if (ret < 0)
+		return ret;
+
+	return sprintf(buf, "%d\n", data);
+}
+
+static ssize_t c2port_show_rev_id(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct c2port_device *c2dev = dev_get_drvdata(dev);
+	ssize_t ret;
+
+	/* Check the device access status */
+	if (!c2dev->access)
+		return -EBUSY;
+
+	mutex_lock(&c2dev->mutex);
+	ret = __c2port_show_rev_id(c2dev, buf);
+	mutex_unlock(&c2dev->mutex);
+
+	if (ret < 0)
+		dev_err(c2dev->dev, "cannot read from %s\n", c2dev->name);
+
+	return ret;
+}
+
+static ssize_t c2port_show_flash_access(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct c2port_device *c2dev = dev_get_drvdata(dev);
+
+	return sprintf(buf, "%d\n", c2dev->flash_access);
+}
+
+static ssize_t __c2port_store_flash_access(struct c2port_device *dev,
+						int status)
+{
+	int ret;
+
+	/* Check the device access status */
+	if (!dev->access)
+		return -EBUSY;
+
+	dev->flash_access = !!status;
+
+	/* If flash_access is off we have nothing to do... */
+	if (dev->flash_access == 0)
+		return 0;
+
+	/* Target the C2 flash programming control register for C2 data
+	 * register access */
+	c2port_write_ar(dev, C2PORT_FPCTL);
+
+	/* Write the first keycode to enable C2 Flash programming */
+	ret = c2port_write_dr(dev, 0x02);
+	if (ret < 0)
+		return ret;
+
+	/* Write the second keycode to enable C2 Flash programming */
+	ret = c2port_write_dr(dev, 0x01);
+	if (ret < 0)
+		return ret;
+
+	/* Delay for at least 20ms to ensure the target is ready for
+	 * C2 flash programming */
+	mdelay(25);
+
+	return 0;
+}
+
+static ssize_t c2port_store_flash_access(struct device *dev,
+				struct device_attribute *attr,
+				const char *buf, size_t count)
+{
+	struct c2port_device *c2dev = dev_get_drvdata(dev);
+	int status;
+	ssize_t ret;
+
+	ret = sscanf(buf, "%d", &status);
+	if (ret != 1)
+		return -EINVAL;
+
+	mutex_lock(&c2dev->mutex);
+	ret = __c2port_store_flash_access(c2dev, status);
+	mutex_unlock(&c2dev->mutex);
+
+	if (ret < 0) {
+		dev_err(c2dev->dev, "cannot enable %s flash programming\n",
+			c2dev->name);
+		return ret;
+	}
+
+	return count;
+}
+
+static ssize_t __c2port_write_flash_erase(struct c2port_device *dev)
+{
+	u8 status;
+	int ret;
+
+	/* Target the C2 flash programming data register for C2 data register
+	 * access.
+	 */
+	c2port_write_ar(dev, C2PORT_FPDAT);
+
+	/* Send device erase command */
+	c2port_write_dr(dev, C2PORT_DEVICE_ERASE);
+
+	/* Wait for input acknowledge */
+	ret = c2port_poll_in_busy(dev);
+	if (ret < 0)
+		return ret;
+
+	/* Should check status before starting FLASH access sequence */
+
+	/* Wait for status information */
+	ret = c2port_poll_out_ready(dev);
+	if (ret < 0)
+		return ret;
+
+	/* Read flash programming interface status */
+	ret = c2port_read_dr(dev, &status);
+	if (ret < 0)
+		return ret;
+	if (status != C2PORT_COMMAND_OK)
+		return -EBUSY;
+
+	/* Send a three-byte arming sequence to enable the device erase.
+	 * If the sequence is not received correctly, the command will be
+	 * ignored.
+	 * Sequence is: 0xde, 0xad, 0xa5.
+	 */
+	c2port_write_dr(dev, 0xde);
+	ret = c2port_poll_in_busy(dev);
+	if (ret < 0)
+		return ret;
+	c2port_write_dr(dev, 0xad);
+	ret = c2port_poll_in_busy(dev);
+	if (ret < 0)
+		return ret;
+	c2port_write_dr(dev, 0xa5);
+	ret = c2port_poll_in_busy(dev);
+	if (ret < 0)
+		return ret;
+
+	ret = c2port_poll_out_ready(dev);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+static ssize_t c2port_store_flash_erase(struct device *dev,
+				struct device_attribute *attr,
+				const char *buf, size_t count)
+{
+	struct c2port_device *c2dev = dev_get_drvdata(dev);
+	int ret;
+
+	/* Check the device and flash access status */
+	if (!c2dev->access || !c2dev->flash_access)
+		return -EBUSY;
+
+	mutex_lock(&c2dev->mutex);
+	ret = __c2port_write_flash_erase(c2dev);
+	mutex_unlock(&c2dev->mutex);
+
+	if (ret < 0) {
+		dev_err(c2dev->dev, "cannot erase %s flash\n", c2dev->name);
+		return ret;
+	}
+
+	return count;
+}
+
+static ssize_t __c2port_read_flash_data(struct c2port_device *dev,
+				char *buffer, loff_t offset, size_t count)
+{
+	struct c2port_ops *ops = dev->ops;
+	u8 status, nread = 128;
+	int i, ret;
+
+	/* Check for flash end */
+	if (offset >= ops->block_size * ops->blocks_num)
+		return 0;
+
+	if (ops->block_size * ops->blocks_num - offset < nread)
+		nread = ops->block_size * ops->blocks_num - offset;
+	if (count < nread)
+		nread = count;
+	if (nread == 0)
+		return nread;
+
+	/* Target the C2 flash programming data register for C2 data register
+	 * access */
+	c2port_write_ar(dev, C2PORT_FPDAT);
+
+	/* Send flash block read command */
+	c2port_write_dr(dev, C2PORT_BLOCK_READ);
+
+	/* Wait for input acknowledge */
+	ret = c2port_poll_in_busy(dev);
+	if (ret < 0)
+		return ret;
+
+	/* Should check status before starting FLASH access sequence */
+
+	/* Wait for status information */
+	ret = c2port_poll_out_ready(dev);
+	if (ret < 0)
+		return ret;
+
+	/* Read flash programming interface status */
+	ret = c2port_read_dr(dev, &status);
+	if (ret < 0)
+		return ret;
+	if (status != C2PORT_COMMAND_OK)
+		return -EBUSY;
+
+	/* Send address high byte */
+	c2port_write_dr(dev, offset >> 8);
+	ret = c2port_poll_in_busy(dev);
+	if (ret < 0)
+		return ret;
+
+	/* Send address low byte */
+	c2port_write_dr(dev, offset & 0x00ff);
+	ret = c2port_poll_in_busy(dev);
+	if (ret < 0)
+		return ret;
+
+	/* Send address block size */
+	c2port_write_dr(dev, nread);
+	ret = c2port_poll_in_busy(dev);
+	if (ret < 0)
+		return ret;
+
+	/* Should check status before reading FLASH block */
+
+	/* Wait for status information */
+	ret = c2port_poll_out_ready(dev);
+	if (ret < 0)
+		return ret;
+
+	/* Read flash programming interface status */
+	ret = c2port_read_dr(dev, &status);
+	if (ret < 0)
+		return ret;
+	if (status != C2PORT_COMMAND_OK)
+		return -EBUSY;
+
+	/* Read flash block */
+	for (i = 0; i < nread; i++) {
+		ret = c2port_poll_out_ready(dev);
+		if (ret < 0)
+			return ret;
+
+		ret = c2port_read_dr(dev, buffer+i);
+		if (ret < 0)
+			return ret;
+	}
+
+	return nread;
+}
+
+static ssize_t c2port_read_flash_data(struct kobject *kobj,
+				struct bin_attribute *attr,
+				char *buffer, loff_t offset, size_t count)
+{
+	struct c2port_device *c2dev =
+			dev_get_drvdata(container_of(kobj,
+						struct device, kobj));
+	ssize_t ret;
+
+	/* Check the device and flash access status */
+	if (!c2dev->access || !c2dev->flash_access)
+		return -EBUSY;
+
+	mutex_lock(&c2dev->mutex);
+	ret = __c2port_read_flash_data(c2dev, buffer, offset, count);
+	mutex_unlock(&c2dev->mutex);
+
+	if (ret < 0)
+		dev_err(c2dev->dev, "cannot read %s flash\n", c2dev->name);
+
+	return ret;
+}
+
+static ssize_t __c2port_write_flash_data(struct c2port_device *dev,
+				char *buffer, loff_t offset, size_t count)
+{
+	struct c2port_ops *ops = dev->ops;
+	u8 status, nwrite = 128;
+	int i, ret;
+
+	if (nwrite > count)
+		nwrite = count;
+	if (ops->block_size * ops->blocks_num - offset < nwrite)
+		nwrite = ops->block_size * ops->blocks_num - offset;
+
+	/* Check for flash end */
+	if (offset >= ops->block_size * ops->blocks_num)
+		return -EINVAL;
+
+	/* Target the C2 flash programming data register for C2 data register
+	 * access */
+	c2port_write_ar(dev, C2PORT_FPDAT);
+
+	/* Send flash block write command */
+	c2port_write_dr(dev, C2PORT_BLOCK_WRITE);
+
+	/* Wait for input acknowledge */
+	ret = c2port_poll_in_busy(dev);
+	if (ret < 0)
+		return ret;
+
+	/* Should check status before starting FLASH access sequence */
+
+	/* Wait for status information */
+	ret = c2port_poll_out_ready(dev);
+	if (ret < 0)
+		return ret;
+
+	/* Read flash programming interface status */
+	ret = c2port_read_dr(dev, &status);
+	if (ret < 0)
+		return ret;
+	if (status != C2PORT_COMMAND_OK)
+		return -EBUSY;
+
+	/* Send address high byte */
+	c2port_write_dr(dev, offset >> 8);
+	ret = c2port_poll_in_busy(dev);
+	if (ret < 0)
+		return ret;
+
+	/* Send address low byte */
+	c2port_write_dr(dev, offset & 0x00ff);
+	ret = c2port_poll_in_busy(dev);
+	if (ret < 0)
+		return ret;
+
+	/* Send address block size */
+	c2port_write_dr(dev, nwrite);
+	ret = c2port_poll_in_busy(dev);
+	if (ret < 0)
+		return ret;
+
+	/* Should check status before writing FLASH block */
+
+	/* Wait for status information */
+	ret = c2port_poll_out_ready(dev);
+	if (ret < 0)
+		return ret;
+
+	/* Read flash programming interface status */
+	ret = c2port_read_dr(dev, &status);
+	if (ret < 0)
+		return ret;
+	if (status != C2PORT_COMMAND_OK)
+		return -EBUSY;
+
+	/* Write flash block */
+	for (i = 0; i < nwrite; i++) {
+		ret = c2port_write_dr(dev, *(buffer+i));
+		if (ret < 0)
+			return ret;
+
+		ret = c2port_poll_in_busy(dev);
+		if (ret < 0)
+			return ret;
+
+	}
+
+	/* Wait for last flash write to complete */
+	ret = c2port_poll_out_ready(dev);
+	if (ret < 0)
+		return ret;
+
+	return nwrite;
+}
+
+static ssize_t c2port_write_flash_data(struct kobject *kobj,
+				struct bin_attribute *attr,
+				char *buffer, loff_t offset, size_t count)
+{
+	struct c2port_device *c2dev =
+			dev_get_drvdata(container_of(kobj,
+						struct device, kobj));
+	int ret;
+
+	/* Check the device access status */
+	if (!c2dev->access || !c2dev->flash_access)
+		return -EBUSY;
+
+	mutex_lock(&c2dev->mutex);
+	ret = __c2port_write_flash_data(c2dev, buffer, offset, count);
+	mutex_unlock(&c2dev->mutex);
+
+	if (ret < 0)
+		dev_err(c2dev->dev, "cannot write %s flash\n", c2dev->name);
+
+	return ret;
+}
+
+/*
+ * Class attributes
+ */
+
+static struct device_attribute c2port_attrs[] = {
+	__ATTR(name, 0444, c2port_show_name, NULL),
+	__ATTR(flash_blocks_num, 0444, c2port_show_flash_blocks_num, NULL),
+	__ATTR(flash_block_size, 0444, c2port_show_flash_block_size, NULL),
+	__ATTR(flash_size, 0444, c2port_show_flash_size, NULL),
+	__ATTR(access, 0644, c2port_show_access, c2port_store_access),
+	__ATTR(reset, 0200, NULL, c2port_store_reset),
+	__ATTR(dev_id, 0444, c2port_show_dev_id, NULL),
+	__ATTR(rev_id, 0444, c2port_show_rev_id, NULL),
+
+	__ATTR(flash_access, 0644, c2port_show_flash_access,
+					c2port_store_flash_access),
+	__ATTR(flash_erase, 0200, NULL, c2port_store_flash_erase),
+	__ATTR_NULL,
+};
+
+static struct bin_attribute c2port_bin_attrs = {
+	.attr	= {
+		.name	= "flash_data",
+		.mode	= 0644
+	},
+	.read	= c2port_read_flash_data,
+	.write	= c2port_write_flash_data,
+	/* .size is computed at run-time */
+};
+
+/*
+ * Exported functions
+ */
+
+struct c2port_device *c2port_device_register(char *name,
+					struct c2port_ops *ops, void *devdata)
+{
+	struct c2port_device *c2dev;
+	int id, ret;
+
+	if (unlikely(!ops) || unlikely(!ops->access) || \
+		unlikely(!ops->c2d_dir) || unlikely(!ops->c2ck_set) || \
+		unlikely(!ops->c2d_get) || unlikely(!ops->c2d_set))
+		return ERR_PTR(-EINVAL);
+
+	c2dev = kmalloc(sizeof(struct c2port_device), GFP_KERNEL);
+	if (unlikely(!c2dev))
+		return ERR_PTR(-ENOMEM);
+
+	ret = idr_pre_get(&c2port_idr, GFP_KERNEL);
+	if (!ret) {
+		ret = -ENOMEM;
+		goto error_idr_get_new;
+	}
+
+	spin_lock_irq(&c2port_idr_lock);
+	ret = idr_get_new(&c2port_idr, c2dev, &id);
+	spin_unlock_irq(&c2port_idr_lock);
+
+	if (ret < 0)
+		goto error_idr_get_new;
+	c2dev->id = id;
+
+	c2dev->dev = device_create(c2port_class, NULL, 0, c2dev,
+					"c2port%d", id);
+	if (unlikely(!c2dev->dev)) {
+		ret = -ENOMEM;
+		goto error_device_create;
+	}
+	dev_set_drvdata(c2dev->dev, c2dev);
+
+	strncpy(c2dev->name, name, C2PORT_NAME_LEN);
+	c2dev->ops = ops;
+	mutex_init(&c2dev->mutex);
+
+	/* Create binary file */
+	c2port_bin_attrs.size = ops->blocks_num * ops->block_size;
+	ret = device_create_bin_file(c2dev->dev, &c2port_bin_attrs);
+	if (unlikely(ret))
+		goto error_device_create_bin_file;
+
+	/* By default C2 port access is off */
+	c2dev->access = c2dev->flash_access = 0;
+	ops->access(c2dev, 0);
+
+	dev_info(c2dev->dev, "C2 port %s added\n", name);
+	dev_info(c2dev->dev, "%s flash has %d blocks x %d bytes "
+				"(%d bytes total)\n",
+				name, ops->blocks_num, ops->block_size,
+				ops->blocks_num * ops->block_size);
+
+	return c2dev;
+
+error_device_create_bin_file:
+	device_destroy(c2port_class, 0);
+
+error_device_create:
+	spin_lock_irq(&c2port_idr_lock);
+	idr_remove(&c2port_idr, id);
+	spin_unlock_irq(&c2port_idr_lock);
+
+error_idr_get_new:
+	kfree(c2dev);
+
+	return ERR_PTR(ret);
+}
+EXPORT_SYMBOL(c2port_device_register);
+
+void c2port_device_unregister(struct c2port_device *c2dev)
+{
+	if (!c2dev)
+		return;
+
+	dev_info(c2dev->dev, "C2 port %s removed\n", c2dev->name);
+
+	device_remove_bin_file(c2dev->dev, &c2port_bin_attrs);
+	spin_lock_irq(&c2port_idr_lock);
+	idr_remove(&c2port_idr, c2dev->id);
+	spin_unlock_irq(&c2port_idr_lock);
+
+	device_destroy(c2port_class, c2dev->id);
+
+	kfree(c2dev);
+}
+EXPORT_SYMBOL(c2port_device_unregister);
+
+/*
+ * Module stuff
+ */
+
+static int __init c2port_init(void)
+{
+	printk(KERN_INFO "Silicon Labs C2 port support v. " DRIVER_VERSION
+		" - (C) 2007 Rodolfo Giometti\n");
+
+	c2port_class = class_create(THIS_MODULE, "c2port");
+	if (!c2port_class) {
+		printk(KERN_ERR "c2port: failed to allocate class\n");
+		return -ENOMEM;
+	}
+	c2port_class->dev_attrs = c2port_attrs;
+
+	return 0;
+}
+
+static void __exit c2port_exit(void)
+{
+	class_destroy(c2port_class);
+}
+
+module_init(c2port_init);
+module_exit(c2port_exit);
+
+MODULE_AUTHOR("Rodolfo Giometti <giometti@linux.it>");
+MODULE_DESCRIPTION("Silicon Labs C2 port support v. " DRIVER_VERSION);
+MODULE_LICENSE("GPL");
diff -puN /dev/null include/linux/c2port.h
--- /dev/null
+++ a/include/linux/c2port.h
@@ -0,0 +1,65 @@
+/*
+ *  Silicon Labs C2 port Linux support
+ *
+ *  Copyright (c) 2007 Rodolfo Giometti <giometti@linux.it>
+ *  Copyright (c) 2007 Eurotech S.p.A. <info@eurotech.it>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation
+ */
+
+#include <linux/device.h>
+
+#define C2PORT_NAME_LEN			32
+
+/*
+ * C2 port basic structs
+ */
+
+/* Main struct */
+struct c2port_ops;
+struct c2port_device {
+	unsigned int access:1;
+	unsigned int flash_access:1;
+
+	int id;
+	char name[C2PORT_NAME_LEN];
+	struct c2port_ops *ops;
+	struct mutex mutex;		/* prevent races during read/write */
+
+	struct device *dev;
+
+	void *private_data;
+};
+
+/* Basic operations */
+struct c2port_ops {
+	/* Flash layout */
+	unsigned short block_size;	/* flash block size in bytes */
+	unsigned short blocks_num;	/* flash blocks number */
+
+	/* Enable or disable the access to C2 port */
+	void (*access)(struct c2port_device *dev, int status);
+
+	/* Set C2D data line as input/output */
+	void (*c2d_dir)(struct c2port_device *dev, int dir);
+
+	/* Read/write C2D data line */
+	int (*c2d_get)(struct c2port_device *dev);
+	void (*c2d_set)(struct c2port_device *dev, int status);
+
+	/* Write C2CK clock line */
+	void (*c2ck_set)(struct c2port_device *dev, int status);
+};
+
+/*
+ * Exported functions
+ */
+
+#define to_class_dev(obj) container_of((obj), struct class_device, kobj)
+#define to_c2port_device(obj) container_of((obj), struct c2port_device, class)
+
+extern struct c2port_device *c2port_device_register(char *name,
+					struct c2port_ops *ops, void *devdata);
+extern void c2port_device_unregister(struct c2port_device *dev);
_

Patches currently in -mm which might be from giometti@linux.it are

add-c2-port-support.patch
c2port-add-c2port-support-for-eurotech-duramar-2150.patch

