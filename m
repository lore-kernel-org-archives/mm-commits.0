From: akpm@linux-foundation.org
Subject: + gpio-add-intel-moorestown-platform-langwell-chip-gpio-driver-fix.patch added to -mm tree
Date: Fri, 31 Jul 2009 16:12:23 -0700
Message-ID: <200907312312.n6VNCNOE006310@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54242 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751246AbZGaXM4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 31 Jul 2009 19:12:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alek.du@intel.com, david-b@pacbell.net


The patch titled
     gpio-add-intel-moorestown-platform-langwell-chip-gpio-driver-fix
has been added to the -mm tree.  Its filename is
     gpio-add-intel-moorestown-platform-langwell-chip-gpio-driver-fix.patch

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
Subject: gpio-add-intel-moorestown-platform-langwell-chip-gpio-driver-fix
From: Alek Du <alek.du@intel.com>

1. remove module support.
2. add a mask handler to irqchip.

Signed-off-by: Alek Du <alek.du@intel.com>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/Kconfig         |    2 -
 drivers/gpio/langwell_gpio.c |   34 +++++----------------------------
 2 files changed, 7 insertions(+), 29 deletions(-)

diff -puN drivers/gpio/Kconfig~gpio-add-intel-moorestown-platform-langwell-chip-gpio-driver-fix drivers/gpio/Kconfig
--- a/drivers/gpio/Kconfig~gpio-add-intel-moorestown-platform-langwell-chip-gpio-driver-fix
+++ a/drivers/gpio/Kconfig
@@ -174,7 +174,7 @@ config GPIO_BT8XX
 	  If unsure, say N.
 
 config GPIO_LANGWELL
-	tristate "Intel Moorestown Platform Langwell GPIO support"
+	bool "Intel Moorestown Platform Langwell GPIO support"
 	depends on PCI
 	help
 	  Say Y here to support Intel Moorestown platform GPIO.
diff -puN drivers/gpio/langwell_gpio.c~gpio-add-intel-moorestown-platform-langwell-chip-gpio-driver-fix drivers/gpio/langwell_gpio.c
--- a/drivers/gpio/langwell_gpio.c~gpio-add-intel-moorestown-platform-langwell-chip-gpio-driver-fix
+++ a/drivers/gpio/langwell_gpio.c
@@ -152,8 +152,13 @@ static void lnw_irq_unmask(unsigned irq)
 	writel(BIT(gpio % 32), gedr);
 };
 
+static void lnw_irq_mask(unsigned irq)
+{
+};
+
 static struct irq_chip lnw_irqchip = {
 	.name		= "LNW-GPIO",
+	.mask		= lnw_irq_mask,
 	.unmask		= lnw_irq_unmask,
 	.set_type	= lnw_irq_type,
 };
@@ -277,27 +282,10 @@ done:
 	return retval;
 }
 
-static void __devexit lnw_gpio_remove(struct pci_dev *pdev)
-{
-	struct lnw_gpio *lnw = (struct lnw_gpio *)pci_get_drvdata(pdev);
-
-	if (gpiochip_remove(&lnw->chip)) {
-		dev_err(&pdev->dev, "langwell gpio driver remove error\n");
-		return;
-	}
-	pci_disable_device(pdev);
-	set_irq_chained_handler(pdev->irq, NULL);
-	pci_release_regions(pdev);
-	iounmap(lnw->reg_base);
-	pci_set_drvdata(pdev, NULL);
-	kfree(lnw);
-}
-
 static struct pci_driver lnw_gpio_driver = {
 	.name		= "langwell_gpio",
 	.id_table	= lnw_gpio_ids,
 	.probe		= lnw_gpio_probe,
-	.remove		= lnw_gpio_remove,
 };
 
 static int __init lnw_gpio_init(void)
@@ -305,14 +293,4 @@ static int __init lnw_gpio_init(void)
 	return pci_register_driver(&lnw_gpio_driver);
 }
 
-static void __exit lnw_gpio_exit(void)
-{
-	pci_unregister_driver(&lnw_gpio_driver);
-}
-
-MODULE_AUTHOR("Alek Du <alek.du@intel.com>");
-MODULE_DESCRIPTION("Intel Moorestown Platform Langwell chip GPIO driver");
-MODULE_LICENSE("GPL v2");
