From: akpm@linux-foundation.org
Subject: [merged] timbgpio-add-support-for-interrupt-triggering-on-both-flanks.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:11:17 -0800
Message-ID: <201003091911.o29JBHLe031730@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53060 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755819Ab0CITMl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:12:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: richard.rojfors@pelagicore.com, david-b@pacbell.net, mm-commits@vger.kernel.org


The patch titled
     timbgpio: add support for interrupt triggering on both flanks
has been removed from the -mm tree.  Its filename was
     timbgpio-add-support-for-interrupt-triggering-on-both-flanks.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: timbgpio: add support for interrupt triggering on both flanks
=46rom: Richard R=F6jfors <richard.rojfors@pelagicore.com>

Introduce support for triggering interrupts on both rising and falling
edge.

This feature requires version 3 or newer of the IP, a version check is
done when triggering on both edges is requested.

Signed-off-by: Richard R=F6jfors <richard.rojfors@pelagicore.com>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/timbgpio.c |   32 +++++++++++++++++++++++---------
 1 file changed, 23 insertions(+), 9 deletions(-)

diff -puN drivers/gpio/timbgpio.c~timbgpio-add-support-for-interrupt-tr=
iggering-on-both-flanks drivers/gpio/timbgpio.c
--- a/drivers/gpio/timbgpio.c~timbgpio-add-support-for-interrupt-trigge=
ring-on-both-flanks
+++ a/drivers/gpio/timbgpio.c
@@ -38,6 +38,8 @@
 #define TGPIO_ICR	0x14
 #define TGPIO_FLR	0x18
 #define TGPIO_LVR	0x1c
+#define TGPIO_VER	0x20
+#define TGPIO_BFLR	0x24
=20
 struct timbgpio {
 	void __iomem		*membase;
@@ -126,17 +128,23 @@ static int timbgpio_irq_type(unsigned ir
 	struct timbgpio *tgpio =3D get_irq_chip_data(irq);
 	int offset =3D irq - tgpio->irq_base;
 	unsigned long flags;
-	u32 lvr, flr;
+	u32 lvr, flr, bflr =3D 0;
+	u32 ver;
=20
 	if (offset < 0 || offset > tgpio->gpio.ngpio)
 		return -EINVAL;
=20
+	ver =3D ioread32(tgpio->membase + TGPIO_VER);
+
 	spin_lock_irqsave(&tgpio->lock, flags);
=20
 	lvr =3D ioread32(tgpio->membase + TGPIO_LVR);
 	flr =3D ioread32(tgpio->membase + TGPIO_FLR);
+	if (ver > 2)
+		bflr =3D ioread32(tgpio->membase + TGPIO_BFLR);
=20
 	if (trigger & (IRQ_TYPE_LEVEL_HIGH | IRQ_TYPE_LEVEL_LOW)) {
+		bflr &=3D ~(1 << offset);
 		flr &=3D ~(1 << offset);
 		if (trigger & IRQ_TYPE_LEVEL_HIGH)
 			lvr |=3D 1 << offset;
@@ -144,21 +152,27 @@ static int timbgpio_irq_type(unsigned ir
 			lvr &=3D ~(1 << offset);
 	}
=20
-	if ((trigger & IRQ_TYPE_EDGE_BOTH) =3D=3D IRQ_TYPE_EDGE_BOTH)
-		return -EINVAL;
-	else {
+	if ((trigger & IRQ_TYPE_EDGE_BOTH) =3D=3D IRQ_TYPE_EDGE_BOTH) {
+		if (ver < 3)
+			return -EINVAL;
+		else {
+			flr |=3D 1 << offset;
+			bflr |=3D 1 << offset;
+		}
+	} else {
+		bflr &=3D ~(1 << offset);
 		flr |=3D 1 << offset;
-		/* opposite compared to the datasheet, but it mirrors the
-		 * reality
-		 */
 		if (trigger & IRQ_TYPE_EDGE_FALLING)
-			lvr |=3D 1 << offset;
-		else
 			lvr &=3D ~(1 << offset);
+		else
+			lvr |=3D 1 << offset;
 	}
=20
 	iowrite32(lvr, tgpio->membase + TGPIO_LVR);
 	iowrite32(flr, tgpio->membase + TGPIO_FLR);
+	if (ver > 2)
+		iowrite32(bflr, tgpio->membase + TGPIO_BFLR);
+
 	iowrite32(1 << offset, tgpio->membase + TGPIO_ICR);
 	spin_unlock_irqrestore(&tgpio->lock, flags);
=20
_

Patches currently in -mm which might be from richard.rojfors@pelagicore=
=2Ecom are

linux-next.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
