From: akpm@linux-foundation.org
Subject: + gpio-vr41xx_giu-irq_data-conversion.patch added to -mm tree
Date: Mon, 13 Dec 2010 15:51:26 -0800
Message-ID: <201012132351.oBDNpQ5O019689@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47477 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756584Ab0LMXww (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 13 Dec 2010 18:52:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: buytenh@wantstofly.org, buytenh@secretlab.ca, yuasa@linux-mips.org


The patch titled
     gpio: vr41xx_giu: irq_data conversion
has been added to the -mm tree.  Its filename is
     gpio-vr41xx_giu-irq_data-conversion.patch

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
Subject: gpio: vr41xx_giu: irq_data conversion
From: Lennert Buytenhek <buytenh@wantstofly.org>

Signed-off-by: Lennert Buytenhek <buytenh@secretlab.ca>
Cc: Yoichi Yuasa <yuasa@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/vr41xx_giu.c |   48 ++++++++++++++++++------------------
 1 file changed, 24 insertions(+), 24 deletions(-)

diff -puN drivers/gpio/vr41xx_giu.c~gpio-vr41xx_giu-irq_data-conversion drivers/gpio/vr41xx_giu.c
--- a/drivers/gpio/vr41xx_giu.c~gpio-vr41xx_giu-irq_data-conversion
+++ a/drivers/gpio/vr41xx_giu.c
@@ -111,69 +111,69 @@ static inline u16 giu_clear(u16 offset, 
 	return data;
 }
 
-static void ack_giuint_low(unsigned int irq)
+static void ack_giuint_low(struct irq_data *d)
 {
-	giu_write(GIUINTSTATL, 1 << GPIO_PIN_OF_IRQ(irq));
+	giu_write(GIUINTSTATL, 1 << GPIO_PIN_OF_IRQ(d->irq));
 }
 
-static void mask_giuint_low(unsigned int irq)
+static void mask_giuint_low(struct irq_data *d)
 {
-	giu_clear(GIUINTENL, 1 << GPIO_PIN_OF_IRQ(irq));
+	giu_clear(GIUINTENL, 1 << GPIO_PIN_OF_IRQ(d->irq));
 }
 
-static void mask_ack_giuint_low(unsigned int irq)
+static void mask_ack_giuint_low(struct irq_data *d)
 {
 	unsigned int pin;
 
-	pin = GPIO_PIN_OF_IRQ(irq);
+	pin = GPIO_PIN_OF_IRQ(d->irq);
 	giu_clear(GIUINTENL, 1 << pin);
 	giu_write(GIUINTSTATL, 1 << pin);
 }
 
-static void unmask_giuint_low(unsigned int irq)
+static void unmask_giuint_low(struct irq_data *d)
 {
-	giu_set(GIUINTENL, 1 << GPIO_PIN_OF_IRQ(irq));
+	giu_set(GIUINTENL, 1 << GPIO_PIN_OF_IRQ(d->irq));
 }
 
 static struct irq_chip giuint_low_irq_chip = {
 	.name		= "GIUINTL",
-	.ack		= ack_giuint_low,
-	.mask		= mask_giuint_low,
-	.mask_ack	= mask_ack_giuint_low,
-	.unmask		= unmask_giuint_low,
+	.irq_ack	= ack_giuint_low,
+	.irq_mask	= mask_giuint_low,
+	.irq_mask_ack	= mask_ack_giuint_low,
+	.irq_unmask	= unmask_giuint_low,
 };
 
-static void ack_giuint_high(unsigned int irq)
+static void ack_giuint_high(struct irq_data *d)
 {
 	giu_write(GIUINTSTATH,
-		  1 << (GPIO_PIN_OF_IRQ(irq) - GIUINT_HIGH_OFFSET));
+		  1 << (GPIO_PIN_OF_IRQ(d->irq) - GIUINT_HIGH_OFFSET));
 }
 
-static void mask_giuint_high(unsigned int irq)
+static void mask_giuint_high(struct irq_data *d)
 {
-	giu_clear(GIUINTENH, 1 << (GPIO_PIN_OF_IRQ(irq) - GIUINT_HIGH_OFFSET));
+	giu_clear(GIUINTENH, 1 << (GPIO_PIN_OF_IRQ(d->irq) - GIUINT_HIGH_OFFSET));
 }
 
-static void mask_ack_giuint_high(unsigned int irq)
+static void mask_ack_giuint_high(struct irq_data *d)
 {
 	unsigned int pin;
 
-	pin = GPIO_PIN_OF_IRQ(irq) - GIUINT_HIGH_OFFSET;
+	pin = GPIO_PIN_OF_IRQ(d->irq) - GIUINT_HIGH_OFFSET;
 	giu_clear(GIUINTENH, 1 << pin);
 	giu_write(GIUINTSTATH, 1 << pin);
 }
 
-static void unmask_giuint_high(unsigned int irq)
+static void unmask_giuint_high(struct irq_data *d)
 {
-	giu_set(GIUINTENH, 1 << (GPIO_PIN_OF_IRQ(irq) - GIUINT_HIGH_OFFSET));
+	giu_set(GIUINTENH, 1 << (GPIO_PIN_OF_IRQ(d->irq) - GIUINT_HIGH_OFFSET));
 }
 
 static struct irq_chip giuint_high_irq_chip = {
 	.name		= "GIUINTH",
-	.ack		= ack_giuint_high,
-	.mask		= mask_giuint_high,
-	.mask_ack	= mask_ack_giuint_high,
-	.unmask		= unmask_giuint_high,
+	.irq_ack	= ack_giuint_high,
+	.irq_mask	= mask_giuint_high,
+	.irq_mask_ack	= mask_ack_giuint_high,
+	.irq_unmask	= unmask_giuint_high,
 };
 
 static int giu_get_irq(unsigned int irq)
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

