From: akpm@linux-foundation.org
Subject: [merged] cs5535-gpio-request-function-mask-names-added.patch removed from -mm tree
Date: Tue, 15 Dec 2009 13:56:20 -0800
Message-ID: <200912152156.nBFLuKwL015561@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41951 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758501AbZLOV5I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 16:57:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Tobias_Mueller@twam.info, alessandro.zummo@towertech.it, david-b@pacbell.net, dilinger@collabora.co.uk, jordan@cosmicpenguin.net, tiwai@suse.de, mm-commits@vger.kernel.org


The patch titled
     cs5535-gpio: request function, mask & names added
has been removed from the -mm tree.  Its filename was
     cs5535-gpio-request-function-mask-names-added.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cs5535-gpio: request function, mask & names added
From: Tobias Mueller <Tobias_Mueller@twam.info>

Changed number of gpio pins to 32 (according to datasheet)

Added mask to disable some pins

Added gpio_request for checking mask and disabling special pin functions

Added pin names

[dilinger@collabora.co.uk: make printk usage consistent]
Signed-off-by: Tobias Mueller <Tobias_Mueller@twam.info>
Signed-off-by: Andres Salomon <dilinger@collabora.co.uk>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Jordan Crouse <jordan@cosmicpenguin.net>
Cc: David Brownell <david-b@pacbell.net>
Cc: Alessandro Zummo <alessandro.zummo@towertech.it>
Signed-off-by: Andres Salomon <dilinger@collabora.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/cs5535-gpio.c |   83 ++++++++++++++++++++++++++++++++---
 1 file changed, 78 insertions(+), 5 deletions(-)

diff -puN drivers/gpio/cs5535-gpio.c~cs5535-gpio-request-function-mask-names-added drivers/gpio/cs5535-gpio.c
--- a/drivers/gpio/cs5535-gpio.c~cs5535-gpio-request-function-mask-names-added
+++ a/drivers/gpio/cs5535-gpio.c
@@ -19,6 +19,29 @@
 #define DRV_NAME "cs5535-gpio"
 #define GPIO_BAR 1
 
+/*
+ * Some GPIO pins
+ *  31-29,23 : reserved (always mask out)
+ *  28       : Power Button
+ *  26       : PME#
+ *  22-16    : LPC
+ *  14,15    : SMBus
+ *  9,8      : UART1
+ *  7        : PCI INTB
+ *  3,4      : UART2/DDC
+ *  2        : IDE_IRQ0
+ *  1        : AC_BEEP
+ *  0        : PCI INTA
+ *
+ * If a mask was not specified, allow all except
+ * reserved and Power Button
+ */
+#define GPIO_DEFAULT_MASK 0x0F7FFFFF
+
+static ulong mask = GPIO_DEFAULT_MASK;
+module_param_named(mask, mask, ulong, 0444);
+MODULE_PARM_DESC(mask, "GPIO channel mask.");
+
 static struct cs5535_gpio_chip {
 	struct gpio_chip chip;
 	resource_size_t base;
@@ -102,6 +125,33 @@ EXPORT_SYMBOL_GPL(cs5535_gpio_isset);
  * Generic gpio_chip API support.
  */
 
+static int chip_gpio_request(struct gpio_chip *c, unsigned offset)
+{
+	struct cs5535_gpio_chip *chip = (struct cs5535_gpio_chip *) c;
+	unsigned long flags;
+
+	spin_lock_irqsave(&chip->lock, flags);
+
+	/* check if this pin is available */
+	if ((mask & (1 << offset)) == 0) {
+		dev_info(&chip->pdev->dev,
+			"pin %u is not available (check mask)\n", offset);
+		spin_unlock_irqrestore(&chip->lock, flags);
+		return -EINVAL;
+	}
+
+	/* disable output aux 1 & 2 on this pin */
+	__cs5535_gpio_clear(chip, offset, GPIO_OUTPUT_AUX1);
+	__cs5535_gpio_clear(chip, offset, GPIO_OUTPUT_AUX2);
+
+	/* disable input aux 1 on this pin */
+	__cs5535_gpio_clear(chip, offset, GPIO_INPUT_AUX1);
+
+	spin_unlock_irqrestore(&chip->lock, flags);
+
+	return 0;
+}
+
 static int chip_gpio_get(struct gpio_chip *chip, unsigned offset)
 {
 	return cs5535_gpio_isset(offset, GPIO_OUTPUT_VAL);
@@ -145,13 +195,26 @@ static int chip_direction_output(struct 
 	return 0;
 }
 
+static char *cs5535_gpio_names[] = {
+	"GPIO0", "GPIO1", "GPIO2", "GPIO3",
+	"GPIO4", "GPIO5", "GPIO6", "GPIO7",
+	"GPIO8", "GPIO9", "GPIO10", "GPIO11",
+	"GPIO12", "GPIO13", "GPIO14", "GPIO15",
+	"GPIO16", "GPIO17", "GPIO18", "GPIO19",
+	"GPIO20", "GPIO21", "GPIO22", NULL,
+	"GPIO24", "GPIO25", "GPIO26", "GPIO27",
+	"GPIO28", NULL, NULL, NULL,
+};
+
 static struct cs5535_gpio_chip cs5535_gpio_chip = {
 	.chip = {
 		.owner = THIS_MODULE,
 		.label = DRV_NAME,
 
 		.base = 0,
-		.ngpio = 28,
+		.ngpio = 32,
+		.names = cs5535_gpio_names,
+		.request = chip_gpio_request,
 
 		.get = chip_gpio_get,
 		.set = chip_gpio_set,
@@ -165,6 +228,7 @@ static int __init cs5535_gpio_probe(stru
 		const struct pci_device_id *pci_id)
 {
 	int err;
+	ulong mask_orig = mask;
 
 	/* There are two ways to get the GPIO base address; one is by
 	 * fetching it from MSR_LBAR_GPIO, the other is by reading the
@@ -193,14 +257,23 @@ static int __init cs5535_gpio_probe(stru
 	dev_info(&pdev->dev, "allocated PCI BAR #%d: base 0x%llx\n", GPIO_BAR,
 			(unsigned long long) cs5535_gpio_chip.base);
 
+	/* mask out reserved pins */
+	mask &= 0x1F7FFFFF;
+
+	/* do not allow pin 28, Power Button, as there's special handling
+	 * in the PMC needed. (note 12, p. 48) */
+	mask &= ~(1 << 28);
+
+	if (mask_orig != mask)
+		dev_info(&pdev->dev, "mask changed from 0x%08lX to 0x%08lX\n",
+				mask_orig, mask);
+
 	/* finally, register with the generic GPIO API */
 	err = gpiochip_add(&cs5535_gpio_chip.chip);
-	if (err) {
-		dev_err(&pdev->dev, "failed to register gpio chip\n");
+	if (err)
 		goto release_region;
-	}
 
-	printk(KERN_INFO DRV_NAME ": GPIO support successfully loaded.\n");
+	dev_info(&pdev->dev, DRV_NAME ": GPIO support successfully loaded.\n");
 	return 0;
 
 release_region:
_

Patches currently in -mm which might be from Tobias_Mueller@twam.info are

origin.patch

