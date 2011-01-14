From: akpm@linux-foundation.org
Subject: + gpio-timbgpio-fix-up-irq_data-conversion-breakage.patch added to -mm tree
Date: Fri, 14 Jan 2011 01:18:24 -0800
Message-ID: <201101140921.p0E9L9ME001942@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45735 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753461Ab1ANJVs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Jan 2011 04:21:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: buytenh@wantstofly.org, buytenh@secretlab.ca, richard.rojfors@mocean-labs.com


The patch titled
     gpio: timbgpio: Fix up irq_data conversion breakage.
has been added to the -mm tree.  Its filename is
     gpio-timbgpio-fix-up-irq_data-conversion-breakage.patch

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
Subject: gpio: timbgpio: Fix up irq_data conversion breakage.
=46rom: Lennert Buytenhek <buytenh@wantstofly.org>

a1f5f22adc3 ("gpio: timbgpio: irq_data conversion") was slightly too
enthusiastic in converting timbgpio_irq() over to take an irq_data *
argument instead of an unsigned int irq argument, as it is a flow handl=
er,
which still take IRQ numbers for now.  (And on top of that, it was usin=
g
the wrong accessors.)

This fixes it up, and seems to build without warnings.

Signed-off-by: Lennert Buytenhek <buytenh@secretlab.ca>
Cc: Richard R=F6jfors <richard.rojfors@mocean-labs.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/timbgpio.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/gpio/timbgpio.c~gpio-timbgpio-fix-up-irq_data-convers=
ion-breakage drivers/gpio/timbgpio.c
--- a/drivers/gpio/timbgpio.c~gpio-timbgpio-fix-up-irq_data-conversion-=
breakage
+++ a/drivers/gpio/timbgpio.c
@@ -193,13 +193,13 @@ out:
 	return ret;
 }
=20
-static void timbgpio_irq(struct irq_data *d, struct irq_desc *desc)
+static void timbgpio_irq(unsigned int irq, struct irq_desc *desc)
 {
-	struct timbgpio *tgpio =3D irq_data_get_irq_data(d);
+	struct timbgpio *tgpio =3D get_irq_data(irq);
 	unsigned long ipr;
 	int offset;
=20
-	desc->irq_data.chip->ack(irq_get_irq_data(d));
+	desc->irq_data.chip->irq_ack(irq_get_irq_data(irq));
 	ipr =3D ioread32(tgpio->membase + TGPIO_IPR);
 	iowrite32(ipr, tgpio->membase + TGPIO_ICR);
=20
_

Patches currently in -mm which might be from buytenh@wantstofly.org are

origin.patch
gpio-timbgpio-fix-up-irq_data-conversion-breakage.patch
linux-next.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
