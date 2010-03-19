From: akpm@linux-foundation.org
Subject: [to-be-updated] watchdog-convert-rdc321x_wdt-to-use-southbridge-accessors.patch removed from -mm tree
Date: Fri, 19 Mar 2010 14:43:55 -0700
Message-ID: <201003192143.o2JLhtaV013989@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32773 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752676Ab0CSVoq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Mar 2010 17:44:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: florian@openwrt.org, david-b@pacbell.net, mingo@elte.hu, sameo@linux.intel.com, wim@iguana.be, mm-commits@vger.kernel.org


The patch titled
     watchdog: convert rdc321x_wdt to use southbridge accessors
has been removed from the -mm tree.  Its filename was
     watchdog-convert-rdc321x_wdt-to-use-southbridge-accessors.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: watchdog: convert rdc321x_wdt to use southbridge accessors
From: Florian Fainelli <florian@openwrt.org>

With the introduction of the MFD driver which abstracts access to the PCI
device configuration space the watchdog driver must be converted to use
these accessors and provide safe register read/write.  As a result we now
use the memory resource which comes with the platform device.

Signed-off-by: Florian Fainelli <florian@openwrt.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Wim Van Sebroeck <wim@iguana.be>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/rdc321x_wdt.c |   38 ++++++++++++++++++++-----------
 1 file changed, 25 insertions(+), 13 deletions(-)

diff -puN drivers/watchdog/rdc321x_wdt.c~watchdog-convert-rdc321x_wdt-to-use-southbridge-accessors drivers/watchdog/rdc321x_wdt.c
--- a/drivers/watchdog/rdc321x_wdt.c~watchdog-convert-rdc321x_wdt-to-use-southbridge-accessors
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
@@ -63,6 +62,7 @@ static struct {
 	int default_ticks;
 	unsigned long inuse;
 	spinlock_t lock;
+	int base_reg;
 } rdc321x_wdt_device;
 
 /* generic helper functions */
@@ -70,14 +70,16 @@ static struct {
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
+	rdc321x_pci_read(rdc321x_wdt_device.base_reg, &val);
+	val |= RDC_WDT_EN;
+	rdc321x_pci_write(rdc321x_wdt_device.base_reg, val);
 	spin_unlock_irqrestore(&rdc321x_wdt_device.lock, flags);
 
 	/* requeue?? */
@@ -105,10 +107,11 @@ static void rdc321x_wdt_start(void)
 
 		/* Clear the timer */
 		spin_lock_irqsave(&rdc321x_wdt_device.lock, flags);
-		outl(RDC_CLS_TMR, RDC3210_CFGREG_ADDR);
+		rdc321x_pci_write(rdc321x_wdt_device.base_reg, RDC_CLS_TMR);
 
 		/* Enable watchdog and set the timeout to 81.92 us */
-		outl(RDC_WDT_EN | RDC_WDT_CNT, RDC3210_CFGREG_DATA);
+		rdc321x_pci_write(rdc321x_wdt_device.base_reg,
+					RDC_WDT_EN | RDC_WDT_CNT);
 		spin_unlock_irqrestore(&rdc321x_wdt_device.lock, flags);
 
 		mod_timer(&rdc321x_wdt_device.timer,
@@ -148,7 +151,7 @@ static long rdc321x_wdt_ioctl(struct fil
 				unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
-	unsigned int value;
+	u32 value;
 	static const struct watchdog_info ident = {
 		.options = WDIOF_CARDRESET,
 		.identity = "RDC321x WDT",
@@ -162,9 +165,9 @@ static long rdc321x_wdt_ioctl(struct fil
 	case WDIOC_GETSTATUS:
 		/* Read the value from the DATA register */
 		spin_lock_irqsave(&rdc321x_wdt_device.lock, flags);
-		value = inl(RDC3210_CFGREG_DATA);
+		rdc321x_pci_read(rdc321x_wdt_device.base_reg, &value);
 		spin_unlock_irqrestore(&rdc321x_wdt_device.lock, flags);
-		if (copy_to_user(argp, &value, sizeof(int)))
+		if (copy_to_user(argp, &value, sizeof(u32)))
 			return -EFAULT;
 		break;
 	case WDIOC_GETSUPPORT:
@@ -219,17 +222,26 @@ static struct miscdevice rdc321x_wdt_mis
 static int __devinit rdc321x_wdt_probe(struct platform_device *pdev)
 {
 	int err;
+	struct resource *r;
+
+	r = platform_get_resource_byname(pdev, IORESOURCE_MEM, "wdt-reg");
+	if (!r) {
+		dev_err(&pdev->dev, "failed to get wdt-reg resource\n");
+		return -ENODEV;
+	}
+
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
+	rdc321x_pci_write(rdc321x_wdt_device.base_reg, RDC_WDT_RST);
 
 	init_completion(&rdc321x_wdt_device.stop);
 	rdc321x_wdt_device.queue = 0;
@@ -240,7 +252,7 @@ static int __devinit rdc321x_wdt_probe(s
 
 	rdc321x_wdt_device.default_ticks = ticks;
 
-	printk(KERN_INFO PFX "watchdog init success\n");
+	dev_info(&pdev->dev, "watchdog init success\n");
 
 	return 0;
 }
_

Patches currently in -mm which might be from florian@openwrt.org are

origin.patch
watchdog-convert-rdc321x_wdt-to-use-southbridge-accessors.patch

