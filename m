From: akpm@linux-foundation.org
Subject: + gpio-adp5588-gpio-support-interrupt-controller-update.patch added to -mm tree
Date: Tue, 19 Oct 2010 13:46:07 -0700
Message-ID: <201010192046.o9JKk7Ge032586@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41837 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757145Ab0JSUqi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 19 Oct 2010 16:46:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: michael.hennerich@analog.com, vapier@gentoo.org


The patch titled
     gpio-adp5588-gpio-support-interrupt-controller-update
has been added to the -mm tree.  Its filename is
     gpio-adp5588-gpio-support-interrupt-controller-update.patch

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
Subject: gpio-adp5588-gpio-support-interrupt-controller-update
From: Michael Hennerich <michael.hennerich@analog.com>

v2 - update feedback from akpm

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/adp5588-gpio.c |   79 ++++++++++++++++------------------
 include/linux/i2c/adp5588.h |   14 ++++++
 2 files changed, 52 insertions(+), 41 deletions(-)

diff -puN drivers/gpio/adp5588-gpio.c~gpio-adp5588-gpio-support-interrupt-controller-update drivers/gpio/adp5588-gpio.c
--- a/drivers/gpio/adp5588-gpio.c~gpio-adp5588-gpio-support-interrupt-controller-update
+++ a/drivers/gpio/adp5588-gpio.c
@@ -18,37 +18,21 @@
 
 #include <linux/i2c/adp5588.h>
 
- /* Configuration Register1 */
-#define AUTO_INC	(1 << 7)
-#define GPIEM_CFG	(1 << 6)
-#define OVR_FLOW_M	(1 << 5)
-#define INT_CFG		(1 << 4)
-#define OVR_FLOW_IEN	(1 << 3)
-#define K_LCK_IM	(1 << 2)
-#define GPI_IEN		(1 << 1)
-#define KE_IEN		(1 << 0)
-
-/* Interrupt Status Register */
-#define GPI_INT		(1 << 1)
-#define KE_INT		(1 << 0)
-
-#define DRV_NAME		"adp5588-gpio"
-#define MAXGPIO			18
-#define ADP_BANK(offs)		((offs) >> 3)
-#define ADP_BIT(offs)		(1u << ((offs) & 0x7))
+#define DRV_NAME	"adp5588-gpio"
 
 /*
  * Early pre 4.0 Silicon required to delay readout by at least 25ms,
  * since the Event Counter Register updated 25ms after the interrupt
  * asserted.
  */
-#define WA_DELAYED_READOUT_REVID(rev)		((rev) < 4)
+#define WA_DELAYED_READOUT_REVID(rev)	((rev) < 4)
 
 struct adp5588_gpio {
 	struct i2c_client *client;
 	struct gpio_chip gpio_chip;
 	struct mutex lock;	/* protect cached dir, dat_out */
-	struct mutex irq_lock;	/* P: IRQ */
+	/* protect serialized access to the interrupt controller bus */
+	struct mutex irq_lock;
 	unsigned gpio_start;
 	unsigned irq_base;
 	uint8_t dat_out[3];
@@ -84,8 +68,8 @@ static int adp5588_gpio_get_value(struct
 	struct adp5588_gpio *dev =
 	    container_of(chip, struct adp5588_gpio, gpio_chip);
 
-	return !!(adp5588_gpio_read(dev->client, GPIO_DAT_STAT1 + ADP_BANK(off))
-		  & ADP_BIT(off));
+	return !!(adp5588_gpio_read(dev->client,
+		  GPIO_DAT_STAT1 + ADP5588_BANK(off)) & ADP5588_BIT(off));
 }
 
 static void adp5588_gpio_set_value(struct gpio_chip *chip,
@@ -95,8 +79,8 @@ static void adp5588_gpio_set_value(struc
 	struct adp5588_gpio *dev =
 	    container_of(chip, struct adp5588_gpio, gpio_chip);
 
-	bank = ADP_BANK(off);
-	bit = ADP_BIT(off);
+	bank = ADP5588_BANK(off);
+	bit = ADP5588_BIT(off);
 
 	mutex_lock(&dev->lock);
 	if (val)
@@ -116,10 +100,10 @@ static int adp5588_gpio_direction_input(
 	struct adp5588_gpio *dev =
 	    container_of(chip, struct adp5588_gpio, gpio_chip);
 
-	bank = ADP_BANK(off);
+	bank = ADP5588_BANK(off);
 
 	mutex_lock(&dev->lock);
-	dev->dir[bank] &= ~ADP_BIT(off);
+	dev->dir[bank] &= ~ADP5588_BIT(off);
 	ret = adp5588_gpio_write(dev->client, GPIO_DIR1 + bank, dev->dir[bank]);
 	mutex_unlock(&dev->lock);
 
@@ -134,8 +118,8 @@ static int adp5588_gpio_direction_output
 	struct adp5588_gpio *dev =
 	    container_of(chip, struct adp5588_gpio, gpio_chip);
 
-	bank = ADP_BANK(off);
-	bit = ADP_BIT(off);
+	bank = ADP5588_BANK(off);
+	bit = ADP5588_BIT(off);
 
 	mutex_lock(&dev->lock);
 	dev->dir[bank] |= bit;
@@ -168,12 +152,20 @@ static void adp5588_irq_bus_lock(unsigne
 	mutex_lock(&dev->irq_lock);
 }
 
+ /*
+  * genirq core code can issue chip->mask/unmask from atomic context.
+  * This doesn't work for slow busses where an access needs to sleep.
+  * bus_sync_unlock() is therefore called outside the atomic context,
+  * syncs the current irq mask state with the slow external controller
+  * and unlocks the bus.
+  */
+
 static void adp5588_irq_bus_sync_unlock(unsigned int irq)
 {
 	struct adp5588_gpio *dev = get_irq_chip_data(irq);
 	int i;
 
-	for (i = 0; i <= ADP_BANK(MAXGPIO); i++)
+	for (i = 0; i <= ADP5588_BANK(ADP5588_MAXGPIO); i++)
 		if (dev->int_en[i] ^ dev->irq_mask[i]) {
 			dev->int_en[i] = dev->irq_mask[i];
 			adp5588_gpio_write(dev->client, GPIO_INT_EN1 + i,
@@ -188,7 +180,7 @@ static void adp5588_irq_mask(unsigned in
 	struct adp5588_gpio *dev = get_irq_chip_data(irq);
 	unsigned gpio = irq - dev->irq_base;
 
-	dev->irq_mask[ADP_BANK(gpio)] &= ~ADP_BIT(gpio);
+	dev->irq_mask[ADP5588_BANK(gpio)] &= ~ADP5588_BIT(gpio);
 }
 
 static void adp5588_irq_unmask(unsigned int irq)
@@ -196,7 +188,7 @@ static void adp5588_irq_unmask(unsigned 
 	struct adp5588_gpio *dev = get_irq_chip_data(irq);
 	unsigned gpio = irq - dev->irq_base;
 
-	dev->irq_mask[ADP_BANK(gpio)] |= ADP_BIT(gpio);
+	dev->irq_mask[ADP5588_BANK(gpio)] |= ADP5588_BIT(gpio);
 }
 
 static int adp5588_irq_set_type(unsigned int irq, unsigned int type)
@@ -211,8 +203,8 @@ static int adp5588_irq_set_type(unsigned
 		return -EINVAL;
 	}
 
-	bank = ADP_BANK(gpio);
-	bit = ADP_BIT(gpio);
+	bank = ADP5588_BANK(gpio);
+	bit = ADP5588_BIT(gpio);
 
 	if (type & IRQ_TYPE_LEVEL_HIGH)
 		dev->int_lvl[bank] |= bit;
@@ -221,8 +213,6 @@ static int adp5588_irq_set_type(unsigned
 	else
 		return -EINVAL;
 
-	might_sleep();
-
 	adp5588_gpio_direction_input(&dev->gpio_chip, gpio);
 	adp5588_gpio_write(dev->client, GPIO_INT_LVL1 + bank,
 			   dev->int_lvl[bank]);
@@ -256,12 +246,13 @@ static irqreturn_t adp5588_irq_handler(i
 	int ret;
 	status = adp5588_gpio_read(dev->client, INT_STAT);
 
-	if (status & GPI_INT) {
+	if (status & ADP5588_GPI_INT) {
 		ret = adp5588_gpio_read_intstat(dev->client, dev->irq_stat);
 		if (ret < 0)
 			memset(dev->irq_stat, 0, ARRAY_SIZE(dev->irq_stat));
 
-		for (bank = 0; bank <= ADP_BANK(MAXGPIO); bank++, bit = 0) {
+		for (bank = 0; bank <= ADP5588_BANK(ADP5588_MAXGPIO);
+			bank++, bit = 0) {
 			pending = dev->irq_stat[bank] & dev->irq_mask[bank];
 
 			while (pending) {
@@ -288,7 +279,7 @@ static int adp5588_irq_setup(struct adp5
 	unsigned gpio;
 	int ret;
 
-	adp5588_gpio_write(client, CFG, AUTO_INC);
+	adp5588_gpio_write(client, CFG, ADP5588_AUTO_INC);
 	adp5588_gpio_write(client, INT_STAT, -1); /* status is W1C */
 	adp5588_gpio_read_intstat(client, dev->irq_stat); /* read to clear */
 
@@ -302,6 +293,10 @@ static int adp5588_irq_setup(struct adp5
 					 handle_level_irq);
 		set_irq_nested_thread(irq, 1);
 #ifdef CONFIG_ARM
+		/*
+		 * ARM needs us to explicitly flag the IRQ as VALID,
+		 * once we do so, it will also set the noprobe.
+		 */
 		set_irq_flags(irq, IRQF_VALID);
 #else
 		set_irq_noprobe(irq);
@@ -320,7 +315,8 @@ static int adp5588_irq_setup(struct adp5
 	}
 
 	dev->gpio_chip.to_irq = adp5588_gpio_to_irq;
-	adp5588_gpio_write(client, CFG, AUTO_INC | INT_CFG | GPI_INT);
+	adp5588_gpio_write(client, CFG,
+		ADP5588_AUTO_INC | ADP5588_INT_CFG | ADP5588_GPI_INT);
 
 	return 0;
 
@@ -328,6 +324,7 @@ out:
 	dev->irq_base = 0;
 	return ret;
 }
+
 static void adp5588_irq_teardown(struct adp5588_gpio *dev)
 {
 	if (dev->irq_base)
@@ -383,7 +380,7 @@ static int __devinit adp5588_gpio_probe(
 	gc->can_sleep = 1;
 
 	gc->base = pdata->gpio_start;
-	gc->ngpio = MAXGPIO;
+	gc->ngpio = ADP5588_MAXGPIO;
 	gc->label = client->name;
 	gc->owner = THIS_MODULE;
 
@@ -395,7 +392,7 @@ static int __devinit adp5588_gpio_probe(
 
 	revid = ret & ADP5588_DEVICE_ID_MASK;
 
-	for (i = 0, ret = 0; i <= ADP_BANK(MAXGPIO); i++) {
+	for (i = 0, ret = 0; i <= ADP5588_BANK(ADP5588_MAXGPIO); i++) {
 		dev->dat_out[i] = adp5588_gpio_read(client, GPIO_DAT_OUT1 + i);
 		dev->dir[i] = adp5588_gpio_read(client, GPIO_DIR1 + i);
 		ret |= adp5588_gpio_write(client, KP_GPIO1 + i, 0);
diff -puN include/linux/i2c/adp5588.h~gpio-adp5588-gpio-support-interrupt-controller-update include/linux/i2c/adp5588.h
--- a/include/linux/i2c/adp5588.h~gpio-adp5588-gpio-support-interrupt-controller-update
+++ a/include/linux/i2c/adp5588.h
@@ -74,6 +74,20 @@
 
 #define ADP5588_DEVICE_ID_MASK	0xF
 
+ /* Configuration Register1 */
+#define ADP5588_AUTO_INC	(1 << 7)
+#define ADP5588_GPIEM_CFG	(1 << 6)
+#define ADP5588_INT_CFG		(1 << 4)
+#define ADP5588_GPI_IEN		(1 << 1)
+
+/* Interrupt Status Register */
+#define ADP5588_GPI_INT		(1 << 1)
+#define ADP5588_KE_INT		(1 << 0)
+
+#define ADP5588_MAXGPIO		18
+#define ADP5588_BANK(offs)	((offs) >> 3)
+#define ADP5588_BIT(offs)	(1u << ((offs) & 0x7))
+
 /* Put one of these structures in i2c_board_info platform_data */
 
 #define ADP5588_KEYMAPSIZE	80
_

Patches currently in -mm which might be from michael.hennerich@analog.com are

drivers-misc-ad525x_dpot-fix-typo-in-spi-write16-and-write24-transfer-counts.patch
linux-next.patch
drivers-misc-ad525x_dpot-fix-part-name-typos-in-defines.patch
drivers-misc-ad525x_dpot-new-features.patch
misc-devices-do-not-enable-by-default.patch
gpio-adp5588-gpio-support-interrupt-controller.patch
gpio-adp5588-gpio-support-interrupt-controller-update.patch
gpio-adp5588-gpio-gpio_start-must-be-signed.patch

