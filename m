From: akpm@linux-foundation.org
Subject: [merged] gpio-timbgpio-irq_data-conversion.patch removed from -mm tree
Date: Thu, 13 Jan 2011 12:07:54 -0800
Message-ID: <201101132010.p0DKAZfV030075@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54555 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933670Ab1AMULK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 15:11:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: buytenh@wantstofly.org, buytenh@secretlab.ca, richard.rojfors@mocean-labs.com, mm-commits@vger.kernel.org


The patch titled
     gpio: timbgpio: irq_data conversion
has been removed from the -mm tree.  Its filename was
     gpio-timbgpio-irq_data-conversion.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: gpio: timbgpio: irq_data conversion
=46rom: Lennert Buytenhek <buytenh@wantstofly.org>

Converts irq_chips and flow handlers over to the new struct irq_data ba=
sed
irq_chip functions.

Signed-off-by: Lennert Buytenhek <buytenh@secretlab.ca>
Cc: Richard R=F6jfors <richard.rojfors@mocean-labs.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/timbgpio.c |   30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff -puN drivers/gpio/timbgpio.c~gpio-timbgpio-irq_data-conversion dri=
vers/gpio/timbgpio.c
--- a/drivers/gpio/timbgpio.c~gpio-timbgpio-irq_data-conversion
+++ a/drivers/gpio/timbgpio.c
@@ -109,10 +109,10 @@ static int timbgpio_to_irq(struct gpio_c
 /*
  * GPIO IRQ
  */
-static void timbgpio_irq_disable(unsigned irq)
+static void timbgpio_irq_disable(struct irq_data *d)
 {
-	struct timbgpio *tgpio =3D get_irq_chip_data(irq);
-	int offset =3D irq - tgpio->irq_base;
+	struct timbgpio *tgpio =3D irq_data_get_irq_chip_data(d);
+	int offset =3D d->irq - tgpio->irq_base;
 	unsigned long flags;
=20
 	spin_lock_irqsave(&tgpio->lock, flags);
@@ -121,10 +121,10 @@ static void timbgpio_irq_disable(unsigne
 	spin_unlock_irqrestore(&tgpio->lock, flags);
 }
=20
-static void timbgpio_irq_enable(unsigned irq)
+static void timbgpio_irq_enable(struct irq_data *d)
 {
-	struct timbgpio *tgpio =3D get_irq_chip_data(irq);
-	int offset =3D irq - tgpio->irq_base;
+	struct timbgpio *tgpio =3D irq_data_get_irq_chip_data(d);
+	int offset =3D d->irq - tgpio->irq_base;
 	unsigned long flags;
=20
 	spin_lock_irqsave(&tgpio->lock, flags);
@@ -133,10 +133,10 @@ static void timbgpio_irq_enable(unsigned
 	spin_unlock_irqrestore(&tgpio->lock, flags);
 }
=20
-static int timbgpio_irq_type(unsigned irq, unsigned trigger)
+static int timbgpio_irq_type(struct irq_data *d, unsigned trigger)
 {
-	struct timbgpio *tgpio =3D get_irq_chip_data(irq);
-	int offset =3D irq - tgpio->irq_base;
+	struct timbgpio *tgpio =3D irq_data_get_irq_chip_data(d);
+	int offset =3D d->irq - tgpio->irq_base;
 	unsigned long flags;
 	u32 lvr, flr, bflr =3D 0;
 	u32 ver;
@@ -193,13 +193,13 @@ out:
 	return ret;
 }
=20
-static void timbgpio_irq(unsigned int irq, struct irq_desc *desc)
+static void timbgpio_irq(struct irq_data *d, struct irq_desc *desc)
 {
-	struct timbgpio *tgpio =3D get_irq_data(irq);
+	struct timbgpio *tgpio =3D irq_data_get_irq_data(d);
 	unsigned long ipr;
 	int offset;
=20
-	desc->chip->ack(irq);
+	desc->irq_data.chip->ack(irq_get_irq_data(d));
 	ipr =3D ioread32(tgpio->membase + TGPIO_IPR);
 	iowrite32(ipr, tgpio->membase + TGPIO_ICR);
=20
@@ -217,9 +217,9 @@ static void timbgpio_irq(unsigned int ir
=20
 static struct irq_chip timbgpio_irqchip =3D {
 	.name		=3D "GPIO",
-	.enable		=3D timbgpio_irq_enable,
-	.disable	=3D timbgpio_irq_disable,
-	.set_type	=3D timbgpio_irq_type,
+	.irq_enable	=3D timbgpio_irq_enable,
+	.irq_disable	=3D timbgpio_irq_disable,
+	.irq_set_type	=3D timbgpio_irq_type,
 };
=20
 static int __devinit timbgpio_probe(struct platform_device *pdev)
_

Patches currently in -mm which might be from buytenh@wantstofly.org are

origin.patch
linux-next.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
