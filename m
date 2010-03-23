From: akpm@linux-foundation.org
Subject: + watchdog-convert-rdc321x_wdt-to-use-southbridge-pci-device.patch added to -mm tree
Date: Mon, 22 Mar 2010 22:56:24 -0400
Message-ID: <201003230557.o2N5vFnk017031@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57504 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751721Ab0CWF6M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Mar 2010 01:58:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: florian@openwrt.org, david-b@pacbell.net, hpa@zytor.com, mingo@elte.hu, sameo@linux.intel.com, tglx@linutronix.de, wim@iguana.be


The patch titled
     watchdog: convert rdc321x_wdt to use southbridge pci device
has been added to the -mm tree.  Its filename is
     watchdog-convert-rdc321x_wdt-to-use-southbridge-pci-device.patch

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
Subject: watchdog: convert rdc321x_wdt to use southbridge pci device
From: Florian Fainelli <florian@openwrt.org>

The RDC321x MFD southbridge driver will pass a reference to the
southbridge PCI device which should be used by the watchdog driver for its
operations.  This patch converts the watchdog driver to use the pci_dev
pointer and make use of the base register resource which is passed along
with the platform device.

Signed-off-by: Florian Fainelli <florian@openwrt.org>
Acked-by: Wim Van Sebroeck <wim@iguana.be>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: David Brownell <david-b@pacbell.net>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/rdc321x_wdt.c |   53 +++++++++++++++++++++++--------
 1 file changed, 40 insertions(+), 13 deletions(-)

diff -puN drivers/watchdog/rdc321x_wdt.c~watchdog-convert-rdc321x_wdt-to-use-southbridge-pci-device drivers/watchdog/rdc321x_wdt.c
--- a/drivers/watchdog/rdc321x_wdt.c~watchdog-convert-rdc321x_wdt-to-use-southbridge-pci-device
+++ a/drivers/watchdog/rdc321x_wdt.c
@@ -1,7 +1,7 @@
 /*
  * RDC321x watchdog driver
  *
- * Copyright (C) 2007 Florian Fainelli <florian@openwrt.org>
+ * Copyright (C) 2007-2010 Florian Fainelli <florian@openwrt.org>
  *
  * This driver is highly inspired from the cpu5_wdt driver
  *
@@ -36,8 +36,7 @@
 #include <linux/watchdog.h>
 #include <linux/io.h>
 #include <linux/uaccess.h>
-
-#include <asm/rdc321x_defs.h>
+#include <linux/mfd/rdc321x.h>
 
 #define RDC_WDT_MASK	0x80000000 /* Mask */
 #define RDC_WDT_EN	0x00800000 /* Enable bit */
@@ -63,6 +62,8 @@ static struct {
 	int default_ticks;
 	unsigned long inuse;
 	spinlock_t lock;
+	struct pci_dev *sb_pdev;
+	int base_reg;
 } rdc321x_wdt_device;
 
 /* generic helper functions */
@@ -70,14 +71,18 @@ static struct {
 static void rdc321x_wdt_trigger(unsigned long unused)
 {
 	unsigned long flags;
+	u32 val;
 
 	if (rdc321x_wdt_device.running)
 		ticks--;
 
 	/* keep watchdog alive */
 	spin_lock_irqsave(&rdc321x_wdt_device.lock, flags);
-	outl(RDC_WDT_EN | inl(RDC3210_CFGREG_DATA),
-		RDC3210_CFGREG_DATA);
+	pci_read_config_dword(rdc321x_wdt_device.sb_pdev,
+					rdc321x_wdt_device.base_reg, &val);
+	val |= RDC_WDT_EN;
+	pci_write_config_dword(rdc321x_wdt_device.sb_pdev,
+					rdc321x_wdt_device.base_reg, val);
 	spin_unlock_irqrestore(&rdc321x_wdt_device.lock, flags);
 
 	/* requeue?? */
@@ -105,10 +110,13 @@ static void rdc321x_wdt_start(void)
 
 		/* Clear the timer */
 		spin_lock_irqsave(&rdc321x_wdt_device.lock, flags);
-		outl(RDC_CLS_TMR, RDC3210_CFGREG_ADDR);
+		pci_write_config_dword(rdc321x_wdt_device.sb_pdev,
+				rdc321x_wdt_device.base_reg, RDC_CLS_TMR);
 
 		/* Enable watchdog and set the timeout to 81.92 us */
-		outl(RDC_WDT_EN | RDC_WDT_CNT, RDC3210_CFGREG_DATA);
+		pci_write_config_dword(rdc321x_wdt_device.sb_pdev,
+					rdc321x_wdt_device.base_reg,
+					RDC_WDT_EN | RDC_WDT_CNT);
 		spin_unlock_irqrestore(&rdc321x_wdt_device.lock, flags);
 
 		mod_timer(&rdc321x_wdt_device.timer,
@@ -148,7 +156,7 @@ static long rdc321x_wdt_ioctl(struct fil
 				unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
-	unsigned int value;
+	u32 value;
 	static const struct watchdog_info ident = {
 		.options = WDIOF_CARDRESET,
 		.identity = "RDC321x WDT",
@@ -162,9 +170,10 @@ static long rdc321x_wdt_ioctl(struct fil
 	case WDIOC_GETSTATUS:
 		/* Read the value from the DATA register */
 		spin_lock_irqsave(&rdc321x_wdt_device.lock, flags);
-		value = inl(RDC3210_CFGREG_DATA);
+		pci_read_config_dword(rdc321x_wdt_device.sb_pdev,
+					rdc321x_wdt_device.base_reg, &value);
 		spin_unlock_irqrestore(&rdc321x_wdt_device.lock, flags);
-		if (copy_to_user(argp, &value, sizeof(int)))
+		if (copy_to_user(argp, &value, sizeof(u32)))
 			return -EFAULT;
 		break;
 	case WDIOC_GETSUPPORT:
@@ -219,17 +228,35 @@ static struct miscdevice rdc321x_wdt_mis
 static int __devinit rdc321x_wdt_probe(struct platform_device *pdev)
 {
 	int err;
+	struct resource *r;
+	struct rdc321x_wdt_pdata *pdata;
+
+	pdata = pdev->dev.platform_data;
+	if (!pdata) {
+		dev_err(&pdev->dev, "no platform data supplied\n");
+		return -ENODEV;
+	}
+
+	r = platform_get_resource_byname(pdev, IORESOURCE_MEM, "wdt-reg");
+	if (!r) {
+		dev_err(&pdev->dev, "failed to get wdt-reg resource\n");
+		return -ENODEV;
+	}
+
+	rdc321x_wdt_device.sb_pdev = pdata->sb_pdev;
+	rdc321x_wdt_device.base_reg = r->start;
 
 	err = misc_register(&rdc321x_wdt_misc);
 	if (err < 0) {
-		printk(KERN_ERR PFX "watchdog misc_register failed\n");
+		dev_err(&pdev->dev, "misc_register failed\n");
 		return err;
 	}
 
 	spin_lock_init(&rdc321x_wdt_device.lock);
 
 	/* Reset the watchdog */
-	outl(RDC_WDT_RST, RDC3210_CFGREG_DATA);
+	pci_write_config_dword(rdc321x_wdt_device.sb_pdev,
+				rdc321x_wdt_device.base_reg, RDC_WDT_RST);
 
 	init_completion(&rdc321x_wdt_device.stop);
 	rdc321x_wdt_device.queue = 0;
@@ -240,7 +267,7 @@ static int __devinit rdc321x_wdt_probe(s
 
 	rdc321x_wdt_device.default_ticks = ticks;
 
-	printk(KERN_INFO PFX "watchdog init success\n");
+	dev_info(&pdev->dev, "watchdog init success\n");
 
 	return 0;
 }
_

Patches currently in -mm which might be from florian@openwrt.org are

mfd-add-support-for-the-rdc321x-southbridge.patch
gpio-add-support-for-rdc321x-gpio-controller.patch
watchdog-convert-rdc321x_wdt-to-use-southbridge-pci-device.patch
x86-remove-rdc321x_defsh.patch

