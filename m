From: akpm@linux-foundation.org
Subject: + pika-warp-appliance-watchdog-timer.patch added to -mm tree
Date: Wed, 27 Aug 2008 13:23:00 -0700
Message-ID: <200808272023.m7RKN0uR020427@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43878 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753292AbYH0UXm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Aug 2008 16:23:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: smaclennan@pikatech.com, wim@iguana.be


The patch titled
     Pika Warp appliance watchdog timer
has been added to the -mm tree.  Its filename is
     pika-warp-appliance-watchdog-timer.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -735,6 +735,14 @@ config BOOKE_WDT
 	  Please see Documentation/watchdog/watchdog-api.txt for
 	  more information.
 
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
@@ -110,6 +110,7 @@ obj-$(CONFIG_MPC5200_WDT) += mpc5200_wdt
 obj-$(CONFIG_8xxx_WDT) += mpc8xxx_wdt.o
 obj-$(CONFIG_MV64X60_WDT) += mv64x60_wdt.o
 obj-$(CONFIG_BOOKE_WDT) += booke_wdt.o
+obj-$(CONFIG_PIKA_WDT) += pika_wdt.o
 
 # PPC64 Architecture
 obj-$(CONFIG_WATCHDOG_RTAS) += wdrtas.o
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

mm-bootmem-silence-section-mismatch-warning-contig_page_data-bootmem_node_data.patch
linux-next.patch
pika-warp-appliance-watchdog-timer.patch

