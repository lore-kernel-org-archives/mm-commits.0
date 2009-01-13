From: akpm@linux-foundation.org
Subject: [merged] pika-warp-appliance-watchdog-timer.patch removed from -mm tree
Date: Tue, 13 Jan 2009 12:13:32 -0800
Message-ID: <200901132013.n0DKDW11012671@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54563 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754895AbZAMUNt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Jan 2009 15:13:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: smaclennan@pikatech.com, wim@iguana.be, mm-commits@vger.kernel.org


The patch titled
     Pika Warp appliance watchdog timer
has been removed from the -mm tree.  Its filename was
     pika-warp-appliance-watchdog-timer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Pika Warp appliance watchdog timer
From: Sean MacLennan <smaclennan@pikatech.com>

The FPGA based watchdog timer used by the Pika Warp appliance.

Signed-off-by: Sean MacLennan <smaclennan@pikatech.com>
Cc: Wim Van Sebroeck <wim@iguana.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/Kconfig    |    8 ++
 drivers/watchdog/Makefile   |    1 
 drivers/watchdog/pika_wdt.c |  113 ++++++++++++++++++++++++++++++++++
 3 files changed, 122 insertions(+)

diff -puN drivers/watchdog/Kconfig~pika-warp-appliance-watchdog-timer drivers/watchdog/Kconfig
--- a/drivers/watchdog/Kconfig~pika-warp-appliance-watchdog-timer
+++ a/drivers/watchdog/Kconfig
@@ -803,6 +803,14 @@ config GEF_WDT
 	---help---
 	  Watchdog timer found in a number of GE Fanuc single board computers.
 
+config PIKA_WDT
+	tristate "PIKA FPGA Watchdog"
+	depends on WARP
+	default y
+	help
+	 This enables the watchdog in the PIKA FPGA. Currently used on
+	 the Warp platform.
+
 # PPC64 Architecture
 
 config WATCHDOG_RTAS
diff -puN drivers/watchdog/Makefile~pika-warp-appliance-watchdog-timer drivers/watchdog/Makefile
--- a/drivers/watchdog/Makefile~pika-warp-appliance-watchdog-timer
+++ a/drivers/watchdog/Makefile
@@ -112,6 +112,7 @@ obj-$(CONFIG_TXX9_WDT) += txx9wdt.o
 
 # POWERPC Architecture
 obj-$(CONFIG_MPC5200_WDT) += mpc5200_wdt.o
+obj-$(CONFIG_PIKA_WDT) += pika_wdt.o
 obj-$(CONFIG_8xxx_WDT) += mpc8xxx_wdt.o
 obj-$(CONFIG_MV64X60_WDT) += mv64x60_wdt.o
 obj-$(CONFIG_BOOKE_WDT) += booke_wdt.o
diff -puN /dev/null drivers/watchdog/pika_wdt.c
--- /dev/null
+++ a/drivers/watchdog/pika_wdt.c
@@ -0,0 +1,113 @@
+/*
+ * PIKA FPGA based Watchdog Timer
+ *
+ * Copyright (c) 2008 PIKA Technologies
+ *   Sean MacLennan <smaclennan@pikatech.com>
+ */
+
+#include <linux/module.h>
+#include <linux/fs.h>
+#include <linux/miscdevice.h>
+#include <linux/reboot.h>
+#include <linux/uaccess.h>
+#include <linux/io.h>
+#include <linux/of_platform.h>
+#include <linux/watchdog.h>
+
+
+static void __iomem *pikawdt_fpga;
+
+
+static inline void pikawdt_ping(void)
+{
+	unsigned reset = in_be32(pikawdt_fpga + 0x14);
+	reset |= 0xf80; /* enable with max timeout - 15 seconds */
+	out_be32(pikawdt_fpga + 0x14, reset);
+}
+
+static int pikawdt_open(struct inode *inode, struct file *file)
+{
+	printk(KERN_INFO "PIKA WDT started...\n");
+
+	pikawdt_ping();
+
+	return 0;
+}
+
+static int pikawdt_release(struct inode *inode, struct file *file)
+{
+	pikawdt_ping(); /* one last time */
+	return 0;
+}
+
+static ssize_t pikawdt_write(struct file *file, const char __user *buf,
+			     size_t count, loff_t *ppos)
+{
+	pikawdt_ping();
+	return count;
+}
+
+/* We support the bare minimum to be conformant. */
+static int pikawdt_ioctl(struct inode *inode, struct file *file,
+			 unsigned int cmd, unsigned long arg)
+{
+	if (cmd == WDIOC_KEEPALIVE) {
+		pikawdt_ping();
+		return 0;
+	} else
+		return -EINVAL;
+}
+
+static const struct file_operations pikawdt_fops = {
+	.owner		= THIS_MODULE,
+	.open		= pikawdt_open,
+	.release	= pikawdt_release,
+	.write		= pikawdt_write,
+	.ioctl		= pikawdt_ioctl,
+};
+
+static struct miscdevice pikawdt_miscdev = {
+	.minor	= WATCHDOG_MINOR,
+	.name	= "watchdog",
+	.fops	= &pikawdt_fops,
+};
+
+static int __init pikawdt_init(void)
+{
+	struct device_node *np;
+	int ret;
+
+	np = of_find_compatible_node(NULL, NULL, "pika,fpga");
+	if (np == NULL) {
+		printk(KERN_ERR "pikawdt: Unable to find fpga.\n");
+		return -ENOENT;
+	}
+
+	pikawdt_fpga = of_iomap(np, 0);
+
+	of_node_put(np);
+
+	if (pikawdt_fpga == NULL) {
+		printk(KERN_ERR "pikawdt: Unable to map fpga.\n");
+		return -ENOENT;
+	}
+
+	ret = misc_register(&pikawdt_miscdev);
+	if (ret) {
+		iounmap(pikawdt_fpga);
+		printk(KERN_ERR "pikawdt: Unable to register miscdev.\n");
+		return ret;
+	}
+
+	return 0;
+}
+module_init(pikawdt_init);
+
+
+static void __exit pikawdt_exit(void)
+{
+	misc_deregister(&pikawdt_miscdev);
+
+	iounmap(pikawdt_fpga);
+}
+module_exit(pikawdt_exit);
_

Patches currently in -mm which might be from smaclennan@pikatech.com are

origin.patch
linux-next.patch

