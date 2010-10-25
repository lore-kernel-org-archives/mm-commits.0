From: akpm@linux-foundation.org
Subject: + langwell_gpio-add-support-for-whitney-point.patch added to -mm tree
Date: Mon, 25 Oct 2010 16:49:41 -0700
Message-ID: <201010252349.o9PNnfnE023406@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37737 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757394Ab0JYXuK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Oct 2010 19:50:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@linux.intel.com, alek.du@intel.com, kangkai.yin@intel.com


The patch titled
     langwell_gpio: add support for whitney point
has been added to the -mm tree.  Its filename is
     langwell_gpio-add-support-for-whitney-point.patch

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
Subject: langwell_gpio: add support for whitney point
From: Alan Cox <alan@linux.intel.com>

In this case the logic is very similar but the IRQs are not exposed and
the device is not picked up via PCI

Based on a separate internal whitney point driver by Yin Kangkai.

Signed-off-by: Alan Cox <alan@linux.intel.com>
Cc: Yin Kangkai <kangkai.yin@intel.com>
Cc: Alek Du <alek.du@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/langwell_gpio.c |   83 ++++++++++++++++++++++++++++++++-
 1 file changed, 82 insertions(+), 1 deletion(-)

diff -puN drivers/gpio/langwell_gpio.c~langwell_gpio-add-support-for-whitney-point drivers/gpio/langwell_gpio.c
--- a/drivers/gpio/langwell_gpio.c~langwell_gpio-add-support-for-whitney-point
+++ a/drivers/gpio/langwell_gpio.c
@@ -18,10 +18,12 @@
 /* Supports:
  * Moorestown platform Langwell chip.
  * Medfield platform Penwell chip.
+ * Whitney point.
  */
 
 #include <linux/module.h>
 #include <linux/pci.h>
+#include <linux/platform_device.h>
 #include <linux/kernel.h>
 #include <linux/delay.h>
 #include <linux/stddef.h>
@@ -300,9 +302,88 @@ static struct pci_driver lnw_gpio_driver
 	.probe		= lnw_gpio_probe,
 };
 
+
+static int __devinit wp_gpio_probe(struct platform_device *pdev)
+{
+	struct lnw_gpio *lnw;
+	struct gpio_chip *gc;
+	struct resource *rc;
+	int retval = 0;
+
+	rc = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!rc)
+		return -EINVAL;
+
+	lnw = kzalloc(sizeof(struct lnw_gpio), GFP_KERNEL);
+	if (!lnw) {
+		dev_err(&pdev->dev,
+			"can't allocate whitneypoint_gpio chip data\n");
+		return -ENOMEM;
+	}
+	lnw->reg_base = ioremap_nocache(rc->start, resource_size(rc));
+	if (lnw->reg_base == NULL) {
+		retval = -EINVAL;
+		goto err_kmalloc;
+	}
+	spin_lock_init(&lnw->lock);
+	gc = &lnw->chip;
+	gc->label = dev_name(&pdev->dev);
+	gc->owner = THIS_MODULE;
+	gc->direction_input = lnw_gpio_direction_input;
+	gc->direction_output = lnw_gpio_direction_output;
+	gc->get = lnw_gpio_get;
+	gc->set = lnw_gpio_set;
+	gc->to_irq = NULL;
+	gc->base = 0;
+	gc->ngpio = 64;
+	gc->can_sleep = 0;
+	retval = gpiochip_add(gc);
+	if (retval) {
+		dev_err(&pdev->dev, "whitneypoint gpiochip_add error %d\n",
+								retval);
+		goto err_ioremap;
+	}
+	platform_set_drvdata(pdev, lnw);
+	return 0;
+err_ioremap:
+	iounmap(lnw->reg_base);
+err_kmalloc:
+	kfree(lnw);
+	return retval;
+}
+
+static int __devexit wp_gpio_remove(struct platform_device *pdev)
+{
+	struct lnw_gpio *lnw = platform_get_drvdata(pdev);
+	int err;
+	err = gpiochip_remove(&lnw->chip);
+	if (err)
+		dev_err(&pdev->dev, "failed to remove gpio_chip.\n");
+	iounmap(lnw->reg_base);
+	kfree(lnw);
+	platform_set_drvdata(pdev, NULL);
+	return 0;
+}
+
+static struct platform_driver wp_gpio_driver = {
+	.probe		= wp_gpio_probe,
+	.remove		= __devexit_p(wp_gpio_remove),
+	.driver		= {
+		.name	= "wp_gpio",
+		.owner	= THIS_MODULE,
+	},
+};
+
 static int __init lnw_gpio_init(void)
 {
-	return pci_register_driver(&lnw_gpio_driver);
+	int ret;
+	ret =  pci_register_driver(&lnw_gpio_driver);
+	if (ret < 0)
+		return ret;
+	ret = platform_driver_register(&wp_gpio_driver);
+	if (ret < 0)
+		pci_unregister_driver(&lnw_gpio_driver);
+	return ret;
 }
 
 device_initcall(lnw_gpio_init);
_

Patches currently in -mm which might be from alan@linux.intel.com are

origin.patch
linux-next.patch
mtd-maps-gpio-addr-flash-fix-warnings-and-make-more-portable.patch
isl29020-ambient-light-sensor.patch
isl29020-ambient-light-sensor-fix.patch
pca953x-pca953x-driver-fixes-for-x86-mrst.patch
drivers-misc-apds9802alsc-als-drivers-for-the-apds9802als.patch
drivers-misc-apds9802alsc-add-runtime-pm-support.patch
drivers-misc-apds9802alsc-add-runtime-pm-support-fix.patch
vcs-add-poll-fasync-support-fix-fix.patch
langwell_gpio-add-support-for-whitney-point.patch

