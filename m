From: akpm@linux-foundation.org
Subject: + gpio-pca953x-irq_data-conversion.patch added to -mm tree
Date: Mon, 13 Dec 2010 15:51:12 -0800
Message-ID: <201012132351.oBDNpCmZ019668@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56318 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756767Ab0LMXvs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 13 Dec 2010 18:51:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: buytenh@wantstofly.org, alan@linux.intel.com, alek.du@intel.com, buytenh@secretlab.ca


The patch titled
     gpio: pca953x: irq_data conversion
has been added to the -mm tree.  Its filename is
     gpio-pca953x-irq_data-conversion.patch

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
Subject: gpio: pca953x: irq_data conversion
From: Lennert Buytenhek <buytenh@wantstofly.org>

Signed-off-by: Lennert Buytenhek <buytenh@secretlab.ca>
Cc: Alek Du <alek.du@intel.com>
Cc: Alan Cox <alan@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/pca953x.c |   38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff -puN drivers/gpio/pca953x.c~gpio-pca953x-irq_data-conversion drivers/gpio/pca953x.c
--- a/drivers/gpio/pca953x.c~gpio-pca953x-irq_data-conversion
+++ a/drivers/gpio/pca953x.c
@@ -228,30 +228,30 @@ static int pca953x_gpio_to_irq(struct gp
 	return chip->irq_base + off;
 }
 
-static void pca953x_irq_mask(unsigned int irq)
+static void pca953x_irq_mask(struct irq_data *d)
 {
-	struct pca953x_chip *chip = get_irq_chip_data(irq);
+	struct pca953x_chip *chip = irq_data_get_irq_chip_data(d);
 
-	chip->irq_mask &= ~(1 << (irq - chip->irq_base));
+	chip->irq_mask &= ~(1 << (d->irq - chip->irq_base));
 }
 
-static void pca953x_irq_unmask(unsigned int irq)
+static void pca953x_irq_unmask(struct irq_data *d)
 {
-	struct pca953x_chip *chip = get_irq_chip_data(irq);
+	struct pca953x_chip *chip = irq_data_get_irq_chip_data(d);
 
-	chip->irq_mask |= 1 << (irq - chip->irq_base);
+	chip->irq_mask |= 1 << (d->irq - chip->irq_base);
 }
 
-static void pca953x_irq_bus_lock(unsigned int irq)
+static void pca953x_irq_bus_lock(struct irq_data *d)
 {
-	struct pca953x_chip *chip = get_irq_chip_data(irq);
+	struct pca953x_chip *chip = irq_data_get_irq_chip_data(d);
 
 	mutex_lock(&chip->irq_lock);
 }
 
-static void pca953x_irq_bus_sync_unlock(unsigned int irq)
+static void pca953x_irq_bus_sync_unlock(struct irq_data *d)
 {
-	struct pca953x_chip *chip = get_irq_chip_data(irq);
+	struct pca953x_chip *chip = irq_data_get_irq_chip_data(d);
 	uint16_t new_irqs;
 	uint16_t level;
 
@@ -268,15 +268,15 @@ static void pca953x_irq_bus_sync_unlock(
 	mutex_unlock(&chip->irq_lock);
 }
 
-static int pca953x_irq_set_type(unsigned int irq, unsigned int type)
+static int pca953x_irq_set_type(struct irq_data *d, unsigned int type)
 {
-	struct pca953x_chip *chip = get_irq_chip_data(irq);
-	uint16_t level = irq - chip->irq_base;
+	struct pca953x_chip *chip = irq_data_get_irq_chip_data(d);
+	uint16_t level = d->irq - chip->irq_base;
 	uint16_t mask = 1 << level;
 
 	if (!(type & IRQ_TYPE_EDGE_BOTH)) {
 		dev_err(&chip->client->dev, "irq %d: unsupported type %d\n",
-			irq, type);
+			d->irq, type);
 		return -EINVAL;
 	}
 
@@ -295,11 +295,11 @@ static int pca953x_irq_set_type(unsigned
 
 static struct irq_chip pca953x_irq_chip = {
 	.name			= "pca953x",
-	.mask			= pca953x_irq_mask,
-	.unmask			= pca953x_irq_unmask,
-	.bus_lock		= pca953x_irq_bus_lock,
-	.bus_sync_unlock	= pca953x_irq_bus_sync_unlock,
-	.set_type		= pca953x_irq_set_type,
+	.irq_mask		= pca953x_irq_mask,
+	.irq_unmask		= pca953x_irq_unmask,
+	.irq_bus_lock		= pca953x_irq_bus_lock,
+	.irq_bus_sync_unlock	= pca953x_irq_bus_sync_unlock,
+	.irq_set_type		= pca953x_irq_set_type,
 };
 
 static uint16_t pca953x_irq_pending(struct pca953x_chip *chip)
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

