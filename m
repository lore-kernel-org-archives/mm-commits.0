From: akpm@linux-foundation.org
Subject: - hdq-bq27000-hdq-slave-interface-driver.patch removed from -mm tree
Date: Thu, 13 Nov 2008 13:27:42 -0800
Message-ID: <200811132127.mADLRgMK028063@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53982 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753928AbYKMV16 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Nov 2008 16:27:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: madhu.cr@ti.com, johnpol@2ka.mipt.ru, mm-commits@vger.kernel.org


The patch titled
     hdq: bQ27000 HDQ Slave Interface Driver
has been removed from the -mm tree.  Its filename was
     hdq-bq27000-hdq-slave-interface-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hdq: bQ27000 HDQ Slave Interface Driver
From: Madhusudhan Chikkature <madhu.cr@ti.com>

Provide the BQ27000 slave interface driver.

Signed-off-by: Madhusudhan Chikkature<madhu.cr@ti.com>
Acked-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/slaves/Kconfig      |    7 +
 drivers/w1/slaves/Makefile     |    2 
 drivers/w1/slaves/w1_bq27000.c |  123 +++++++++++++++++++++++++++++++
 3 files changed, 131 insertions(+), 1 deletion(-)

diff -puN drivers/w1/slaves/Kconfig~hdq-bq27000-hdq-slave-interface-driver drivers/w1/slaves/Kconfig
--- a/drivers/w1/slaves/Kconfig~hdq-bq27000-hdq-slave-interface-driver
+++ a/drivers/w1/slaves/Kconfig
@@ -44,4 +44,11 @@ config W1_SLAVE_DS2760
 
 	  If you are unsure, say N.
 
+config W1_SLAVE_BQ27000
+	tristate "BQ27000 slave support"
+	depends on W1
+	help
+	  Say Y here if you want to use a hdq
+	  bq27000 slave support.
+
 endmenu
diff -puN drivers/w1/slaves/Makefile~hdq-bq27000-hdq-slave-interface-driver drivers/w1/slaves/Makefile
--- a/drivers/w1/slaves/Makefile~hdq-bq27000-hdq-slave-interface-driver
+++ a/drivers/w1/slaves/Makefile
@@ -6,4 +6,4 @@ obj-$(CONFIG_W1_SLAVE_THERM)	+= w1_therm
 obj-$(CONFIG_W1_SLAVE_SMEM)	+= w1_smem.o
 obj-$(CONFIG_W1_SLAVE_DS2433)	+= w1_ds2433.o
 obj-$(CONFIG_W1_SLAVE_DS2760)	+= w1_ds2760.o
-
+obj-$(CONFIG_W1_SLAVE_BQ27000)	+= w1_bq27000.o
diff -puN /dev/null drivers/w1/slaves/w1_bq27000.c
--- /dev/null
+++ a/drivers/w1/slaves/w1_bq27000.c
@@ -0,0 +1,123 @@
+/*
+ * drivers/w1/slaves/w1_bq27000.c
+ *
+ * Copyright (C) 2007 Texas Instruments, Inc.
+ *
+ * This file is licensed under the terms of the GNU General Public License
+ * version 2. This program is licensed "as is" without any warranty of any
+ * kind, whether express or implied.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/device.h>
+#include <linux/types.h>
+#include <linux/platform_device.h>
+#include <linux/mutex.h>
+
+#include "../w1.h"
+#include "../w1_int.h"
+#include "../w1_family.h"
+
+#define HDQ_CMD_READ	(0)
+#define HDQ_CMD_WRITE	(1<<7)
+
+static int F_ID;
+
+void w1_bq27000_write(struct device *dev, u8 buf, u8 reg)
+{
+	struct w1_slave *sl = container_of(dev, struct w1_slave, dev);
+
+	if (!dev) {
+		pr_info("Could not obtain slave dev ptr\n");
+		return;
+	}
+
+	w1_write_8(sl->master, HDQ_CMD_WRITE | reg);
+	w1_write_8(sl->master, buf);
+}
+EXPORT_SYMBOL(w1_bq27000_write);
+
+int w1_bq27000_read(struct device *dev, u8 reg)
+{
+	u8 val;
+	struct w1_slave *sl = container_of(dev, struct w1_slave, dev);
+
+	if (!dev)
+		return 0;
+
+	w1_write_8(sl->master, HDQ_CMD_READ | reg);
+	val = w1_read_8(sl->master);
+
+	return val;
+}
+EXPORT_SYMBOL(w1_bq27000_read);
+
+static int w1_bq27000_add_slave(struct w1_slave *sl)
+{
+	int ret;
+	int id = 1;
+	struct platform_device *pdev;
+
+	pdev = platform_device_alloc("bq27000-battery", id);
+	if (!pdev) {
+		ret = -ENOMEM;
+		return ret;
+	}
+	pdev->dev.parent = &sl->dev;
+
+	ret = platform_device_add(pdev);
+	if (ret)
+		goto pdev_add_failed;
+
+	dev_set_drvdata(&sl->dev, pdev);
+
+	goto success;
+
+pdev_add_failed:
+	platform_device_unregister(pdev);
+success:
+	return ret;
+}
+
+static void w1_bq27000_remove_slave(struct w1_slave *sl)
+{
+	struct platform_device *pdev = dev_get_drvdata(&sl->dev);
+
+	platform_device_unregister(pdev);
+}
+
+static struct w1_family_ops w1_bq27000_fops = {
+	.add_slave	= w1_bq27000_add_slave,
+	.remove_slave	= w1_bq27000_remove_slave,
+};
+
+static struct w1_family w1_bq27000_family = {
+	.fid = 1,
+	.fops = &w1_bq27000_fops,
+};
+
+static int __init w1_bq27000_init(void)
+{
+	if (F_ID)
+		w1_bq27000_family.fid = F_ID;
+
+	return w1_register_family(&w1_bq27000_family);
+}
+
+static void __exit w1_bq27000_exit(void)
+{
+	w1_unregister_family(&w1_bq27000_family);
+}
+
+
+module_init(w1_bq27000_init);
+module_exit(w1_bq27000_exit);
+
+module_param(F_ID, int, S_IRUSR);
+MODULE_PARM_DESC(F_ID, "1-wire slave FID for BQ device");
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Texas Instruments Ltd");
+MODULE_DESCRIPTION("HDQ/1-wire slave driver bq27000 battery monitor chip");
_

Patches currently in -mm which might be from madhu.cr@ti.com are

origin.patch

