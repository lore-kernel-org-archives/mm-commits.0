From: akpm@linux-foundation.org
Subject: + watchdog-add-sbc-fitpc2-watchdog-driver.patch added to -mm tree
Date: Mon, 27 Jul 2009 14:09:13 -0700
Message-ID: <200907272109.n6RL9Dns006692@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54767 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753997AbZG0VJy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Jul 2009 17:09:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: denis@compulab.co.il, mike@compulab.co.il, wim@iguana.be


The patch titled
     watchdog: add SBC-FITPC2 watchdog driver
has been added to the -mm tree.  Its filename is
     watchdog-add-sbc-fitpc2-watchdog-driver.patch

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
Subject: watchdog: add SBC-FITPC2 watchdog driver
From: Denis Turischev <denis@compulab.co.il>

Add support for watchdog found on SBC-FITPC2 board.

Signed-off-by: Denis Turischev <denis@compulab.co.il>
Signed-off-by: Mike Rapoport <mike@compulab.co.il>
Cc: Wim Van Sebroeck <wim@iguana.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/Kconfig          |   22 ++
 drivers/watchdog/Makefile         |    1 
 drivers/watchdog/sbc_fitpc2_wdt.c |  259 ++++++++++++++++++++++++++++
 3 files changed, 282 insertions(+)

diff -puN drivers/watchdog/Kconfig~watchdog-add-sbc-fitpc2-watchdog-driver drivers/watchdog/Kconfig
--- a/drivers/watchdog/Kconfig~watchdog-add-sbc-fitpc2-watchdog-driver
+++ a/drivers/watchdog/Kconfig
@@ -721,6 +721,28 @@ config SBC_EPX_C3_WATCHDOG
 	  To compile this driver as a module, choose M here: the
 	  module will be called sbc_epx_c3.
 
+config SBC_FITPC2_WATCHDOG
+	tristate "Compulab SBC-FITPC2 watchdog"
+	depends on X86
+	---help---
+	  This is the driver for the built-in watchdog timer on the fit-PC2
+	  Single-board computer made by Compulab.
+
+	  It`s possible to enable watchdog timer either from BIOS (F2) or from booted Linux.
+	  When "Watchdog Timer Value" enabled one can set 31-255 s operational range.
+
+	  Entering BIOS setup temporary disables watchdog operation regardless to current state,
+	  so system will not be restarted while user in BIOS setup.
+
+	  Once watchdog was enabled the system will be restarted every
+	  "Watchdog Timer Value" period, so to prevent it user can restart or
+	  disable the watchdog.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called sbc_fitpc2_wdt.
+
+	  Most people will say N.
+
 # M32R Architecture
 
 # M68K Architecture
diff -puN drivers/watchdog/Makefile~watchdog-add-sbc-fitpc2-watchdog-driver drivers/watchdog/Makefile
--- a/drivers/watchdog/Makefile~watchdog-add-sbc-fitpc2-watchdog-driver
+++ a/drivers/watchdog/Makefile
@@ -93,6 +93,7 @@ obj-$(CONFIG_W83877F_WDT) += w83877f_wdt
 obj-$(CONFIG_W83977F_WDT) += w83977f_wdt.o
 obj-$(CONFIG_MACHZ_WDT) += machzwd.o
 obj-$(CONFIG_SBC_EPX_C3_WATCHDOG) += sbc_epx_c3.o
+obj-$(CONFIG_SBC_FITPC2_WATCHDOG) += sbc_fitpc2_wdt.o
 
 # M32R Architecture
 
diff -puN /dev/null drivers/watchdog/sbc_fitpc2_wdt.c
--- /dev/null
+++ a/drivers/watchdog/sbc_fitpc2_wdt.c
@@ -0,0 +1,259 @@
+/*
+ * Watchdog driver for SBC-FITPC2 board
+ *
+ * Author: Denis Turischev <denis@compulab.co.il>
+ *
+ * Adapted from the IXP2000 watchdog driver by Deepak Saxena.
+ *
+ * This file is licensed under  the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME " WATCHDOG: " fmt
+
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/miscdevice.h>
+#include <linux/watchdog.h>
+#include <linux/ioport.h>
+#include <linux/delay.h>
+#include <linux/notifier.h>
+#include <linux/fs.h>
+#include <linux/reboot.h>
+#include <linux/init.h>
+#include <linux/moduleparam.h>
+#include <linux/dmi.h>
+
+#include <linux/io.h>
+#include <linux/uaccess.h>
+#include <asm/system.h>
+
+static int nowayout = WATCHDOG_NOWAYOUT;
+static unsigned int margin = 60;	/* (secs) Default is 1 minute */
+static unsigned long wdt_status;
+static spinlock_t wdt_lock;
+
+#define	WDT_IN_USE		0
+#define	WDT_OK_TO_CLOSE		1
+
+#define COMMAND_PORT		0x4c
+#define DATA_PORT		0x48
+
+#define IFACE_ON_COMMAND	1
+#define REBOOT_COMMAND		2
+
+#define WATCHDOG_NAME 		"SBC-FITPC2 Watchdog"
+
+static void wdt_send_data(unsigned char command, unsigned char data)
+{
+	outb(command, COMMAND_PORT);
+	mdelay(100);
+	outb(data, DATA_PORT);
+	mdelay(200);
+}
+
+static void wdt_enable(void)
+{
+	spin_lock(&wdt_lock);
+	wdt_send_data(IFACE_ON_COMMAND, 1);
+	wdt_send_data(REBOOT_COMMAND, margin);
+	spin_unlock(&wdt_lock);
+}
+
+static void wdt_disable(void)
+{
+	spin_lock(&wdt_lock);
+	wdt_send_data(IFACE_ON_COMMAND, 0);
+	wdt_send_data(REBOOT_COMMAND, 0);
+	spin_unlock(&wdt_lock);
+}
+
+static int fitpc2_wdt_open(struct inode *inode, struct file *file)
+{
+	if (test_and_set_bit(WDT_IN_USE, &wdt_status))
+		return -EBUSY;
+
+	clear_bit(WDT_OK_TO_CLOSE, &wdt_status);
+
+	wdt_enable();
+
+	return nonseekable_open(inode, file);
+}
+
+static ssize_t
+fitpc2_wdt_write(struct file *file, const char *data, size_t len, loff_t *ppos)
+{
+	size_t i;
+
+	if (!len)
+		return 0;
+
+	if (nowayout) {
+		len = 0;
+		goto out;
+	}
+
+	clear_bit(WDT_OK_TO_CLOSE, &wdt_status);
+
+	for (i = 0; i != len; i++) {
+		char c;
+
+		if (get_user(c, data + i))
+			return -EFAULT;
+
+		if (c == 'V')
+			set_bit(WDT_OK_TO_CLOSE, &wdt_status);
+	}
+
+out:
+	wdt_enable();
+
+	return len;
+}
+
+
+static struct watchdog_info ident = {
+	.options	= WDIOF_MAGICCLOSE | WDIOF_SETTIMEOUT |
+				WDIOF_KEEPALIVEPING,
+	.identity	= WATCHDOG_NAME,
+};
+
+
+static long
+fitpc2_wdt_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	int ret = -ENOTTY;
+	int time;
+
+	switch (cmd) {
+	case WDIOC_GETSUPPORT:
+		ret = copy_to_user((struct watchdog_info *)arg, &ident,
+				   sizeof(ident)) ? -EFAULT : 0;
+		break;
+
+	case WDIOC_GETSTATUS:
+		ret = put_user(0, (int *)arg);
+		break;
+
+	case WDIOC_GETBOOTSTATUS:
+		ret = put_user(0, (int *)arg);
+		break;
+
+	case WDIOC_KEEPALIVE:
+		wdt_enable();
+		ret = 0;
+		break;
+
+	case WDIOC_SETTIMEOUT:
+		ret = get_user(time, (int *)arg);
+		if (ret)
+			break;
+
+		if (time < 31 || time > 255) {
+			ret = -EINVAL;
+			break;
+		}
+
+		margin = time;
+		wdt_enable();
+		/* Fall through */
+
+	case WDIOC_GETTIMEOUT:
+		ret = put_user(margin, (int *)arg);
+		break;
+	}
+
+	return ret;
+}
+
+static int fitpc2_wdt_release(struct inode *inode, struct file *file)
+{
+	if (test_bit(WDT_OK_TO_CLOSE, &wdt_status)) {
+		wdt_disable();
+		pr_info("Device disabled\n");
+	} else {
+		pr_warning("Device closed unexpectedly -"
+			" timer will not stop\n");
+	}
+
+	clear_bit(WDT_IN_USE, &wdt_status);
+	clear_bit(WDT_OK_TO_CLOSE, &wdt_status);
+
+	return 0;
+}
+
+
+static const struct file_operations fitpc2_wdt_fops = {
+	.owner		= THIS_MODULE,
+	.llseek		= no_llseek,
+	.write		= fitpc2_wdt_write,
+	.unlocked_ioctl	= fitpc2_wdt_ioctl,
+	.open		= fitpc2_wdt_open,
+	.release	= fitpc2_wdt_release,
+};
+
+static struct miscdevice fitpc2_wdt_miscdev = {
+	.minor		= WATCHDOG_MINOR,
+	.name		= "watchdog",
+	.fops		= &fitpc2_wdt_fops,
+};
+
+static int __init fitpc2_wdt_init(void)
+{
+	int err;
+
+	if (strcmp("SBC-FITPC2", dmi_get_system_info(DMI_BOARD_NAME))) {
+		pr_info("board name is: %s. Should be SBC-FITPC2\n",
+			dmi_get_system_info(DMI_BOARD_NAME));
+		return -ENODEV;
+	}
+
+	if (!request_region(COMMAND_PORT, 1, WATCHDOG_NAME)) {
+		pr_err("I/O address 0x%04x already in use\n", COMMAND_PORT);
+		return -EIO;
+	}
+
+	if (!request_region(DATA_PORT, 1, WATCHDOG_NAME)) {
+		pr_err("I/O address 0x%04x already in use\n", DATA_PORT);
+		err = -EIO;
+		goto err_data_port;
+	}
+
+	if (margin < 31 || margin > 255) {
+		pr_err("margin must be in range 31 - 255"
+		       " seconds, you tried to set %d\n", margin);
+		err = -EINVAL;
+		goto err_margin;
+	}
+
+	return misc_register(&fitpc2_wdt_miscdev);
+
+err_margin:
+	release_region(DATA_PORT, 1);
+err_data_port:
+	release_region(COMMAND_PORT, 1);
+
+	return err;
+}
+
+static void __exit fitpc2_wdt_exit(void)
+{
+	misc_deregister(&fitpc2_wdt_miscdev);
+}
+
+module_init(fitpc2_wdt_init);
+module_exit(fitpc2_wdt_exit);
+
+MODULE_AUTHOR("Denis Turischev <denis@compulab.co.il>");
+MODULE_DESCRIPTION("SBC-FITPC2 Watchdog");
+
+module_param(margin, int, 0);
+MODULE_PARM_DESC(margin, "Watchdog margin in seconds (default 60s)");
+
+module_param(nowayout, int, 0);
+MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started");
+
+MODULE_LICENSE("GPL");
+MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
+
_

Patches currently in -mm which might be from denis@compulab.co.il are

origin.patch
x86-add-reboot-fixup-for-compulab-sbc-fitpc2-board.patch
x86-add-reboot-fixup-for-compulab-sbc-fitpc2-board-cleanup.patch
watchdog-add-sbc-fitpc2-watchdog-driver.patch

