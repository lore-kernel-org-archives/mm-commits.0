From: akpm@linux-foundation.org
Subject: + gpio-timbgpio-use-a-copy-of-the-ier-register-to-avoid-it-being-trashed.patch added to -mm tree
Date: Thu, 07 Oct 2010 15:34:42 -0700
Message-ID: <201010072234.o97MYggf028396@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36103 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750764Ab0JGWes (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Oct 2010 18:34:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tomas.hallenberg@pelagicore.com, richard.rojfors@pelagicore.com


The patch titled
     gpio: timbgpio: use a copy of the IER register to avoid it being t=
rashed
has been added to the -mm tree.  Its filename is
     gpio-timbgpio-use-a-copy-of-the-ier-register-to-avoid-it-being-tra=
shed.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: gpio: timbgpio: use a copy of the IER register to avoid it bei=
ng trashed
=46rom: Tomas Hallenberg <tomas.hallenberg@pelagicore.com>

Some versions of the hardware can trash the IER register if simultaneou=
s
interrupts occur.  This patch works around it by using a local copy of =
the
register and restoring it after every interrupt.

Signed-off-by: Tomas Hallenberg <tomas.hallenberg@pelagicore.com>
Acked-by: Richard R=F6jfors <richard.rojfors@pelagicore.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/timbgpio.c |   21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff -puN drivers/gpio/timbgpio.c~gpio-timbgpio-use-a-copy-of-the-ier-r=
egister-to-avoid-it-being-trashed drivers/gpio/timbgpio.c
--- a/drivers/gpio/timbgpio.c~gpio-timbgpio-use-a-copy-of-the-ier-regis=
ter-to-avoid-it-being-trashed
+++ a/drivers/gpio/timbgpio.c
@@ -47,6 +47,7 @@ struct timbgpio {
 	spinlock_t		lock; /* mutual exclusion */
 	struct gpio_chip	gpio;
 	int			irq_base;
+	unsigned long		last_ier;
 };
=20
 static int timbgpio_update_bit(struct gpio_chip *gpio, unsigned index,
@@ -112,16 +113,24 @@ static void timbgpio_irq_disable(unsigne
 {
 	struct timbgpio *tgpio =3D get_irq_chip_data(irq);
 	int offset =3D irq - tgpio->irq_base;
+	unsigned long flags;
=20
-	timbgpio_update_bit(&tgpio->gpio, offset, TGPIO_IER, 0);
+	spin_lock_irqsave(&tgpio->lock, flags);
+	tgpio->last_ier &=3D ~(1 << offset);
+	iowrite32(tgpio->last_ier, tgpio->membase + TGPIO_IER);
+	spin_unlock_irqrestore(&tgpio->lock, flags);
 }
=20
 static void timbgpio_irq_enable(unsigned irq)
 {
 	struct timbgpio *tgpio =3D get_irq_chip_data(irq);
 	int offset =3D irq - tgpio->irq_base;
+	unsigned long flags;
=20
-	timbgpio_update_bit(&tgpio->gpio, offset, TGPIO_IER, 1);
+	spin_lock_irqsave(&tgpio->lock, flags);
+	tgpio->last_ier |=3D 1 << offset;
+	iowrite32(tgpio->last_ier, tgpio->membase + TGPIO_IER);
+	spin_unlock_irqrestore(&tgpio->lock, flags);
 }
=20
 static int timbgpio_irq_type(unsigned irq, unsigned trigger)
@@ -194,8 +203,16 @@ static void timbgpio_irq(unsigned int ir
 	ipr =3D ioread32(tgpio->membase + TGPIO_IPR);
 	iowrite32(ipr, tgpio->membase + TGPIO_ICR);
=20
+	/*
+	 * Some versions of the hardware trash the IER register if more than
+	 * one interrupt is received simultaneously.
+	 */
+	iowrite32(0, tgpio->membase + TGPIO_IER);
+
 	for_each_set_bit(offset, &ipr, tgpio->gpio.ngpio)
 		generic_handle_irq(timbgpio_to_irq(&tgpio->gpio, offset));
+
+	iowrite32(tgpio->last_ier, tgpio->membase + TGPIO_IER);
 }
=20
 static struct irq_chip timbgpio_irqchip =3D {
_

Patches currently in -mm which might be from tomas.hallenberg@pelagicor=
e.com are

gpio-timbgpio-use-a-copy-of-the-ier-register-to-avoid-it-being-trashed.=
patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
