From: akpm@linux-foundation.org
Subject: + gpio-tc35892-gpio-irq_data-conversion.patch added to -mm tree
Date: Mon, 13 Dec 2010 15:51:21 -0800
Message-ID: <201012132351.oBDNpLYO019683@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40573 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756584Ab0LMXxP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 13 Dec 2010 18:53:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: buytenh@wantstofly.org, buytenh@secretlab.ca, rabin.vincent@stericsson.com


The patch titled
     gpio: tc35892-gpio: irq_data conversion
has been added to the -mm tree.  Its filename is
     gpio-tc35892-gpio-irq_data-conversion.patch

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
Subject: gpio: tc35892-gpio: irq_data conversion
From: Lennert Buytenhek <buytenh@wantstofly.org>

Signed-off-by: Lennert Buytenhek <buytenh@secretlab.ca>
Acked-by: Rabin Vincent <rabin.vincent@stericsson.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/tc35892-gpio.c |   36 +++++++++++++++++-----------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff -puN drivers/gpio/tc35892-gpio.c~gpio-tc35892-gpio-irq_data-conversion drivers/gpio/tc35892-gpio.c
--- a/drivers/gpio/tc35892-gpio.c~gpio-tc35892-gpio-irq_data-conversion
+++ a/drivers/gpio/tc35892-gpio.c
@@ -110,10 +110,10 @@ static struct gpio_chip template_chip = 
 	.can_sleep		= 1,
 };
 
-static int tc35892_gpio_irq_set_type(unsigned int irq, unsigned int type)
+static int tc35892_gpio_irq_set_type(struct irq_data *d, unsigned int type)
 {
-	struct tc35892_gpio *tc35892_gpio = get_irq_chip_data(irq);
-	int offset = irq - tc35892_gpio->irq_base;
+	struct tc35892_gpio *tc35892_gpio = irq_data_get_irq_chip_data(d);
+	int offset = d->irq - tc35892_gpio->irq_base;
 	int regoffset = offset / 8;
 	int mask = 1 << (offset % 8);
 
@@ -137,16 +137,16 @@ static int tc35892_gpio_irq_set_type(uns
 	return 0;
 }
 
-static void tc35892_gpio_irq_lock(unsigned int irq)
+static void tc35892_gpio_irq_lock(struct irq_data *d)
 {
-	struct tc35892_gpio *tc35892_gpio = get_irq_chip_data(irq);
+	struct tc35892_gpio *tc35892_gpio = irq_data_get_irq_chip_data(d);
 
 	mutex_lock(&tc35892_gpio->irq_lock);
 }
 
-static void tc35892_gpio_irq_sync_unlock(unsigned int irq)
+static void tc35892_gpio_irq_sync_unlock(struct irq_data *d)
 {
-	struct tc35892_gpio *tc35892_gpio = get_irq_chip_data(irq);
+	struct tc35892_gpio *tc35892_gpio = irq_data_get_irq_chip_data(d);
 	struct tc35892 *tc35892 = tc35892_gpio->tc35892;
 	static const u8 regmap[] = {
 		[REG_IBE]	= TC35892_GPIOIBE0,
@@ -172,20 +172,20 @@ static void tc35892_gpio_irq_sync_unlock
 	mutex_unlock(&tc35892_gpio->irq_lock);
 }
 
-static void tc35892_gpio_irq_mask(unsigned int irq)
+static void tc35892_gpio_irq_mask(struct irq_data *d)
 {
-	struct tc35892_gpio *tc35892_gpio = get_irq_chip_data(irq);
-	int offset = irq - tc35892_gpio->irq_base;
+	struct tc35892_gpio *tc35892_gpio = irq_data_get_irq_chip_data(d);
+	int offset = d->irq - tc35892_gpio->irq_base;
 	int regoffset = offset / 8;
 	int mask = 1 << (offset % 8);
 
 	tc35892_gpio->regs[REG_IE][regoffset] &= ~mask;
 }
 
-static void tc35892_gpio_irq_unmask(unsigned int irq)
+static void tc35892_gpio_irq_unmask(struct irq_data *d)
 {
-	struct tc35892_gpio *tc35892_gpio = get_irq_chip_data(irq);
-	int offset = irq - tc35892_gpio->irq_base;
+	struct tc35892_gpio *tc35892_gpio = irq_data_get_irq_chip_data(d);
+	int offset = d->irq - tc35892_gpio->irq_base;
 	int regoffset = offset / 8;
 	int mask = 1 << (offset % 8);
 
@@ -194,11 +194,11 @@ static void tc35892_gpio_irq_unmask(unsi
 
 static struct irq_chip tc35892_gpio_irq_chip = {
 	.name			= "tc35892-gpio",
-	.bus_lock		= tc35892_gpio_irq_lock,
-	.bus_sync_unlock	= tc35892_gpio_irq_sync_unlock,
-	.mask			= tc35892_gpio_irq_mask,
-	.unmask			= tc35892_gpio_irq_unmask,
-	.set_type		= tc35892_gpio_irq_set_type,
+	.irq_bus_lock		= tc35892_gpio_irq_lock,
+	.irq_bus_sync_unlock	= tc35892_gpio_irq_sync_unlock,
+	.irq_mask		= tc35892_gpio_irq_mask,
+	.irq_unmask		= tc35892_gpio_irq_unmask,
+	.irq_set_type		= tc35892_gpio_irq_set_type,
 };
 
 static irqreturn_t tc35892_gpio_irq(int irq, void *dev)
_

Patches currently in -mm which might be from buytenh@wantstofly.org are

linux-next.patch
maintainers-openwrt-devel-is-subscribers-only.patch
gpio-adp5588-gpio-irq_data-conversion.patch
gpio-langwell_gpio-irq_data-conversion.patch
gpio-max732x-irq_data-conversion.patch
gpio-pca953x-irq_data-conversion.patch
gpio-pl061-irq_data-conversion.patch
gpio-stmpe-gpio-irq_data-conversion.patch
gpio-sx150x-irq_data-conversion.patch
gpio-tc35892-gpio-irq_data-conversion.patch
gpio-timbgpio-irq_data-conversion.patch
gpio-vr41xx_giu-irq_data-conversion.patch

