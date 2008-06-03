From: akpm@linux-foundation.org
Subject: + mpc83xx_wdt-convert-to-the-of-platform-driver.patch added to -mm tree
Date: Tue, 03 Jun 2008 16:40:48 -0700
Message-ID: <200806032340.m53NemAY025881@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59741 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750928AbYFCXn4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Jun 2008 19:43:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avorontsov@ru.mvista.com, galak@kernel.crashing.org, sfr@canb.auug.org.au, wim@iguana.be


The patch titled
     mpc83xx_wdt: convert to the OF platform driver
has been added to the -mm tree.  Its filename is
     mpc83xx_wdt-convert-to-the-of-platform-driver.patch

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
Subject: mpc83xx_wdt: convert to the OF platform driver
From: Anton Vorontsov <avorontsov@ru.mvista.com>

This patch simply converts mpc83xx_wdt to the OF platform driver so we can
directly work with the device tree without passing various stuff through
platform data.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
Acked-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: Wim Van Sebroeck <wim@iguana.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/mpc83xx_wdt.c |   61 +++++++++++++++----------------
 1 file changed, 30 insertions(+), 31 deletions(-)

diff -puN drivers/watchdog/mpc83xx_wdt.c~mpc83xx_wdt-convert-to-the-of-platform-driver drivers/watchdog/mpc83xx_wdt.c
--- a/drivers/watchdog/mpc83xx_wdt.c~mpc83xx_wdt-convert-to-the-of-platform-driver
+++ a/drivers/watchdog/mpc83xx_wdt.c
@@ -19,11 +19,12 @@
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/miscdevice.h>
-#include <linux/platform_device.h>
+#include <linux/of_platform.h>
 #include <linux/module.h>
 #include <linux/watchdog.h>
 #include <linux/io.h>
 #include <linux/uaccess.h>
+#include <sysdev/fsl_soc.h>
 
 struct mpc83xx_wdt {
 	__be32 res0;
@@ -149,52 +150,42 @@ static struct miscdevice mpc83xx_wdt_mis
 	.fops	= &mpc83xx_wdt_fops,
 };
 
-static int __devinit mpc83xx_wdt_probe(struct platform_device *dev)
+static int __devinit mpc83xx_wdt_probe(struct of_device *ofdev,
+				       const struct of_device_id *match)
 {
-	struct resource *r;
 	int ret;
-	unsigned int *freq = dev->dev.platform_data;
+	u32 freq = fsl_get_sys_freq();
 
-	/* get a pointer to the register memory */
-	r = platform_get_resource(dev, IORESOURCE_MEM, 0);
+	if (!freq || freq == -1)
+		return -EINVAL;
 
-	if (!r) {
-		ret = -ENODEV;
-		goto err_out;
-	}
-
-	wd_base = ioremap(r->start, sizeof(struct mpc83xx_wdt));
-	if (wd_base == NULL) {
-		ret = -ENOMEM;
-		goto err_out;
-	}
+	wd_base = of_iomap(ofdev->node, 0);
+	if (!wd_base)
+		return -ENOMEM;
 
 	ret = misc_register(&mpc83xx_wdt_miscdev);
 	if (ret) {
-		printk(KERN_ERR "cannot register miscdev on minor=%d "
-				"(err=%d)\n",
-				WATCHDOG_MINOR, ret);
+		pr_err("cannot register miscdev on minor=%d (err=%d)\n",
+			WATCHDOG_MINOR, ret);
 		goto err_unmap;
 	}
 
 	/* Calculate the timeout in seconds */
 	if (prescale)
-		timeout_sec = (timeout * 0x10000) / (*freq);
+		timeout_sec = (timeout * 0x10000) / freq;
 	else
-		timeout_sec = timeout / (*freq);
+		timeout_sec = timeout / freq;
 
-	printk(KERN_INFO "WDT driver for MPC83xx initialized. "
-		"mode:%s timeout=%d (%d seconds)\n",
-		reset ? "reset":"interrupt", timeout, timeout_sec);
+	pr_info("WDT driver for MPC83xx initialized. mode:%s timeout=%d "
+		"(%d seconds)\n", reset ? "reset" : "interrupt", timeout,
+		timeout_sec);
 	return 0;
-
 err_unmap:
 	iounmap(wd_base);
-err_out:
 	return ret;
 }
 
-static int __devexit mpc83xx_wdt_remove(struct platform_device *dev)
+static int __devexit mpc83xx_wdt_remove(struct of_device *ofdev)
 {
 	misc_deregister(&mpc83xx_wdt_miscdev);
 	iounmap(wd_base);
@@ -202,7 +193,16 @@ static int __devexit mpc83xx_wdt_remove(
 	return 0;
 }
 
-static struct platform_driver mpc83xx_wdt_driver = {
+static const struct of_device_id mpc83xx_wdt_match[] = {
+	{
+		.compatible = "mpc83xx_wdt",
+	},
+	{},
+};
+MODULE_DEVICE_TABLE(of, mpc83xx_wdt_match);
+
+static struct of_platform_driver mpc83xx_wdt_driver = {
+	.match_table	= mpc83xx_wdt_match,
 	.probe		= mpc83xx_wdt_probe,
 	.remove		= __devexit_p(mpc83xx_wdt_remove),
 	.driver		= {
@@ -213,12 +213,12 @@ static struct platform_driver mpc83xx_wd
 
 static int __init mpc83xx_wdt_init(void)
 {
-	return platform_driver_register(&mpc83xx_wdt_driver);
+	return of_register_platform_driver(&mpc83xx_wdt_driver);
 }
 
 static void __exit mpc83xx_wdt_exit(void)
 {
-	platform_driver_unregister(&mpc83xx_wdt_driver);
+	of_unregister_platform_driver(&mpc83xx_wdt_driver);
 }
 
 module_init(mpc83xx_wdt_init);
@@ -228,4 +228,3 @@ MODULE_AUTHOR("Dave Updegraff, Kumar Gal
 MODULE_DESCRIPTION("Driver for watchdog timer in MPC83xx uProcessor");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
-MODULE_ALIAS("platform:mpc83xx_wdt");
_

Patches currently in -mm which might be from avorontsov@ru.mvista.com are

origin.patch
serial-fix-driver_name-conflicts.patch
linux-next.patch
git-leds.patch
mpc83xx_wdt-convert-to-the-of-platform-driver.patch
mpc83xx_wdt-add-support-for-mpc86xx-cpus.patch
mpc83xx_wdt-rename-to-mpc8xxx_wdt.patch
mpc8xxx_wdt-various-renames-mostly-s-mpc83xx-mpc8xxx-g.patch
mpc8xxx_wdt-add-support-for-mpc8xx-watchdogs.patch
hgafb-fix-module-removal.patch
fsl_soc-remove-mpc83xx_wdt-code.patch
86xx-mpc8610_hpcd-add-watchdog-node.patch

