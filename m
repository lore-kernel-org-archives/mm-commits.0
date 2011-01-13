From: akpm@linux-foundation.org
Subject: [merged] gpio-vr41xx_giu-irq_data-conversion.patch removed from -mm tree
Date: Thu, 13 Jan 2011 12:07:57 -0800
Message-ID: <201101132010.p0DKAc1S030079@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32935 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933746Ab1AMUW0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 15:22:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: buytenh@wantstofly.org, buytenh@secretlab.ca, yuasa@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     gpio: vr41xx_giu: irq_data conversion
has been removed from the -mm tree.  Its filename was
     gpio-vr41xx_giu-irq_data-conversion.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gpio: vr41xx_giu: irq_data conversion
From: Lennert Buytenhek <buytenh@wantstofly.org>

Converts irq_chips and flow handlers over to the new struct irq_data based
irq_chip functions.

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

origin.patch
linux-next.patch

