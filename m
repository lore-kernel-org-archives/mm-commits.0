From: akpm@linux-foundation.org
Subject: [merged] spi-mpc8xxx-dont-check-platform_get_irqs-return-value-against-zero.patch removed from -mm tree
Date: Mon, 25 Jan 2010 13:46:26 -0800
Message-ID: <201001252146.o0PLkQpF012682@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38525 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751892Ab0AYVra (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jan 2010 16:47:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: u.kleine-koenig@pengutronix.de, avorontsov@ru.mvista.com, dbrownell@users.sourceforge.net, dvrabel@arcom.com, galak@kernel.crashing.org, grant.likely@secretlab.ca, gregkh@suse.de, mm-


The patch titled
     spi/mpc8xxx: don't check platform_get_irq's return value against z=
ero
has been removed from the -mm tree.  Its filename was
     spi-mpc8xxx-dont-check-platform_get_irqs-return-value-against-zero=
=2Epatch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: spi/mpc8xxx: don't check platform_get_irq's return value again=
st zero
=46rom: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>

platform_get_irq returns -ENXIO on failure, so !irq was probably always
true.  Make irq a signed variable and compare irq <=3D 0.  Note that a
return value of zero is still handled as error even though this could m=
ean
irq0.

This is a followup to 305b3228f9ff4d59f49e6d34a7034d44ee8ce2f0 ("driver
core: platform_get_irq*(): return -ENXIO on error") which changed the
return value of platform_get_irq from 0 to -ENXIO on error.

Signed-off-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
Cc: David Vrabel <dvrabel@arcom.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: Anton Vorontsov <avorontsov@ru.mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_mpc8xxx.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/spi/spi_mpc8xxx.c~spi-mpc8xxx-dont-check-platform_get=
_irqs-return-value-against-zero drivers/spi/spi_mpc8xxx.c
--- a/drivers/spi/spi_mpc8xxx.c~spi-mpc8xxx-dont-check-platform_get_irq=
s-return-value-against-zero
+++ a/drivers/spi/spi_mpc8xxx.c
@@ -1328,7 +1328,7 @@ static struct of_platform_driver of_mpc8
 static int __devinit plat_mpc8xxx_spi_probe(struct platform_device *pd=
ev)
 {
 	struct resource *mem;
-	unsigned int irq;
+	int irq;
 	struct spi_master *master;
=20
 	if (!pdev->dev.platform_data)
@@ -1339,7 +1339,7 @@ static int __devinit plat_mpc8xxx_spi_pr
 		return -EINVAL;
=20
 	irq =3D platform_get_irq(pdev, 0);
-	if (!irq)
+	if (irq <=3D 0)
 		return -EINVAL;
=20
 	master =3D mpc8xxx_spi_probe(&pdev->dev, mem, irq);
_

Patches currently in -mm which might be from u.kleine-koenig@pengutroni=
x.de are

origin.patch
linux-next.patch
mtd-nand-fix-build-failure-caused-by-typo.patch
hrtimer-correct-a-few-numbers-in-comments.patch
clockevents-ensure-taht-min_delta_ns-is-increased-in-error-path.patch
genirq-warn-about-irqf_sharedirqf_disabled-at-the-right-place.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
