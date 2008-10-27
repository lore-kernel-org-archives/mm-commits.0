From: akpm@linux-foundation.org
Subject: + c2port-add-c2port-support-for-eurotech-duramar-2150.patch added to -mm tree
Date: Sun, 26 Oct 2008 23:26:36 -0700
Message-ID: <200810270626.m9R6Qah5021368@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39344 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751180AbYJ0G0n (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Oct 2008 02:26:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: giometti@linux.it, greg@kroah.com


The patch titled
     c2port: add c2port support for Eurotech Duramar 2150
has been added to the -mm tree.  Its filename is
     c2port-add-c2port-support-for-eurotech-duramar-2150.patch

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
Subject: c2port: add c2port support for Eurotech Duramar 2150
From: Rodolfo Giometti <giometti@linux.it>

Signed-off-by: Rodolfo Giometti <giometti@linux.it>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/c2port/Kconfig              |   11 +
 drivers/misc/c2port/Makefile             |    2 
 drivers/misc/c2port/c2port-duramar2150.c |  158 +++++++++++++++++++++
 3 files changed, 171 insertions(+)

diff -puN drivers/misc/c2port/Kconfig~c2port-add-c2port-support-for-eurotech-duramar-2150 drivers/misc/c2port/Kconfig
--- a/drivers/misc/c2port/Kconfig~c2port-add-c2port-support-for-eurotech-duramar-2150
+++ a/drivers/misc/c2port/Kconfig
@@ -21,4 +21,15 @@ menuconfig C2PORT
 
 if C2PORT
 
+config C2PORT_DURAMAR_2150
+	tristate "C2 port support for Eurotech's Duramar 2150 (EXPERIMENTAL)"
+	depends on X86 && C2PORT
+	default no
+	help
+	  This option enables C2 support for the Eurotech's Duramar 2150
+	  on board micro controller.
+
+	  To compile this driver as a module, choose M here: the module will
+	  be called c2port-duramar2150.
+
 endif # C2PORT
diff -puN drivers/misc/c2port/Makefile~c2port-add-c2port-support-for-eurotech-duramar-2150 drivers/misc/c2port/Makefile
--- a/drivers/misc/c2port/Makefile~c2port-add-c2port-support-for-eurotech-duramar-2150
+++ a/drivers/misc/c2port/Makefile
@@ -1 +1,3 @@
 obj-$(CONFIG_C2PORT)		+= core.o
+
+obj-$(CONFIG_C2PORT_DURAMAR_2150)	+= c2port-duramar2150.o
diff -puN /dev/null drivers/misc/c2port/c2port-duramar2150.c
--- /dev/null
+++ a/drivers/misc/c2port/c2port-duramar2150.c
@@ -0,0 +1,158 @@
+/*
+ *  Silicon Labs C2 port Linux support for Eurotech Duramar 2150
+ *
+ *  Copyright (c) 2008 Rodolfo Giometti <giometti@linux.it>
+ *  Copyright (c) 2008 Eurotech S.p.A. <info@eurotech.it>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation
+ */
+
+#include <linux/errno.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/delay.h>
+#include <linux/io.h>
+#include <linux/c2port.h>
+
+#define DATA_PORT	0x325
+#define DIR_PORT	0x326
+#define    C2D		   (1 << 0)
+#define    C2CK		   (1 << 1)
+
+static DEFINE_MUTEX(update_lock);
+
+/*
+ * C2 port operations
+ */
+
+static void duramar2150_c2port_access(struct c2port_device *dev, int status)
+{
+	u8 v;
+
+	mutex_lock(&update_lock);
+
+	v = inb(DIR_PORT);
+
+	/* 0 = input, 1 = output */
+	if (status)
+		outb(v | (C2D | C2CK), DIR_PORT);
+	else
+		/* When access is "off" is important that both lines are set
+		 * as inputs or hi-impedence */
+		outb(v & ~(C2D | C2CK), DIR_PORT);
+
+	mutex_unlock(&update_lock);
+}
+
+static void duramar2150_c2port_c2d_dir(struct c2port_device *dev, int dir)
+{
+	u8 v;
+
+	mutex_lock(&update_lock);
+
+	v = inb(DIR_PORT);
+
+	if (dir)
+		outb(v & ~C2D, DIR_PORT);
+	else
+		outb(v | C2D, DIR_PORT);
+
+	mutex_unlock(&update_lock);
+}
+
+static int duramar2150_c2port_c2d_get(struct c2port_device *dev)
+{
+	return inb(DATA_PORT) & C2D;
+}
+
+static void duramar2150_c2port_c2d_set(struct c2port_device *dev, int status)
+{
+	u8 v;
+
+	mutex_lock(&update_lock);
+
+	v = inb(DATA_PORT);
+
+	if (status)
+		outb(v | C2D, DATA_PORT);
+	else
+		outb(v & ~C2D, DATA_PORT);
+
+	mutex_unlock(&update_lock);
+}
+
+static void duramar2150_c2port_c2ck_set(struct c2port_device *dev, int status)
+{
+	u8 v;
+
+	mutex_lock(&update_lock);
+
+	v = inb(DATA_PORT);
+
+	if (status)
+		outb(v | C2CK, DATA_PORT);
+	else
+		outb(v & ~C2CK, DATA_PORT);
+
+	mutex_unlock(&update_lock);
+}
+
+static struct c2port_ops duramar2150_c2port_ops = {
+	.block_size	= 512,	/* bytes */
+	.blocks_num	= 30,	/* total flash size: 15360 bytes */
+
+	.access		= duramar2150_c2port_access,
+	.c2d_dir	= duramar2150_c2port_c2d_dir,
+	.c2d_get	= duramar2150_c2port_c2d_get,
+	.c2d_set	= duramar2150_c2port_c2d_set,
+	.c2ck_set	= duramar2150_c2port_c2ck_set,
+};
+
+static struct c2port_device *duramar2150_c2port_dev;
+
+/*
+ * Module stuff
+ */
+
+static int __init duramar2150_c2port_init(void)
+{
+	struct resource *res;
+	int ret = 0;
+
+	res = request_region(0x325, 2, "c2port");
+	if (!res)
+		return -EBUSY;
+
+	duramar2150_c2port_dev = c2port_device_register("uc",
+					&duramar2150_c2port_ops, NULL);
+	if (!duramar2150_c2port_dev) {
+		ret = -ENODEV;
+		goto free_region;
+	}
+
+	return 0;
+
+free_region:
+	release_region(0x325, 2);
+	return ret;
+}
+
+static void __exit duramar2150_c2port_exit(void)
+{
+	/* Setup the GPIOs as input by default (access = 0) */
+	duramar2150_c2port_access(duramar2150_c2port_dev, 0);
+
+	c2port_device_unregister(duramar2150_c2port_dev);
+
+	release_region(0x325, 2);
+}
+
+module_init(duramar2150_c2port_init);
+module_exit(duramar2150_c2port_exit);
+
+MODULE_AUTHOR("Rodolfo Giometti <giometti@linux.it>");
+MODULE_DESCRIPTION("Silicon Labs C2 port Linux support for Duramar 2150");
+MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from giometti@linux.it are

add-c2-port-support.patch
c2port-add-c2port-support-for-eurotech-duramar-2150.patch

