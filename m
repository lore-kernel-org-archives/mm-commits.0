From: akpm@linux-foundation.org
Subject: + gpio-langwell_gpio-irq_data-conversion.patch added to -mm tree
Date: Mon, 13 Dec 2010 15:51:07 -0800
Message-ID: <201012132351.oBDNp7md019662@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54652 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756584Ab0LMXvp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 13 Dec 2010 18:51:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: buytenh@wantstofly.org, alan@linux.intel.com, alek.du@intel.com, buytenh@secretlab.ca, kangkai.yin@intel.com


The patch titled
     gpio: langwell_gpio: irq_data conversion
has been added to the -mm tree.  Its filename is
     gpio-langwell_gpio-irq_data-conversion.patch

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
Subject: gpio: langwell_gpio: irq_data conversion
From: Lennert Buytenhek <buytenh@wantstofly.org>

Signed-off-by: Lennert Buytenhek <buytenh@secretlab.ca>
Cc: Alan Cox <alan@linux.intel.com>
Cc: Yin Kangkai <kangkai.yin@intel.com>
Cc: Alek Du <alek.du@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/langwell_gpio.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN drivers/gpio/langwell_gpio.c~gpio-langwell_gpio-irq_data-conversion drivers/gpio/langwell_gpio.c
--- a/drivers/gpio/langwell_gpio.c~gpio-langwell_gpio-irq_data-conversion
+++ a/drivers/gpio/langwell_gpio.c
@@ -134,10 +134,10 @@ static int lnw_gpio_to_irq(struct gpio_c
 	return lnw->irq_base + offset;
 }
 
-static int lnw_irq_type(unsigned irq, unsigned type)
+static int lnw_irq_type(struct irq_data *d, unsigned type)
 {
-	struct lnw_gpio *lnw = get_irq_chip_data(irq);
-	u32 gpio = irq - lnw->irq_base;
+	struct lnw_gpio *lnw = irq_data_get_irq_chip_data(d);
+	u32 gpio = d->irq - lnw->irq_base;
 	unsigned long flags;
 	u32 value;
 	void __iomem *grer = gpio_reg(&lnw->chip, gpio, GRER);
@@ -162,19 +162,19 @@ static int lnw_irq_type(unsigned irq, un
 	return 0;
 }
 
-static void lnw_irq_unmask(unsigned irq)
+static void lnw_irq_unmask(struct irq_data *d)
 {
 }
 
-static void lnw_irq_mask(unsigned irq)
+static void lnw_irq_mask(struct irq_data *d)
 {
 }
 
 static struct irq_chip lnw_irqchip = {
 	.name		= "LNW-GPIO",
-	.mask		= lnw_irq_mask,
-	.unmask		= lnw_irq_unmask,
-	.set_type	= lnw_irq_type,
+	.irq_mask	= lnw_irq_mask,
+	.irq_unmask	= lnw_irq_unmask,
+	.irq_set_type	= lnw_irq_type,
 };
 
 static DEFINE_PCI_DEVICE_TABLE(lnw_gpio_ids) = {   /* pin number */
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

