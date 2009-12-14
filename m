From: akpm@linux-foundation.org
Subject: [wrecked] spi-imx-correct-check-for-platform_get_irq-failing.patch removed from -mm tree
Date: Mon, 14 Dec 2009 13:18:00 -0800
Message-ID: <200912142118.nBELI0No002559@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57410 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933013AbZLNVSj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Dec 2009 16:18:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: u.kleine-koenig@pengutronix.de, daniel@caiaq.de, dbrownell@users.sourceforge.net, grant.likely@secretlab.ca, s.hauer@pengutronix.de, mm-commits@vger.kernel.org


The patch titled
     spi-imx: correct check for platform_get_irq failing
has been removed from the -mm tree.  Its filename was
     spi-imx-correct-check-for-platform_get_irq-failing.patch

This patch was dropped because other changes were merged, which wrecked=
 this patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: spi-imx: correct check for platform_get_irq failing
=46rom: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>

platform_get_irq() returns -ENXIO if there is no entry.  So don't check
return value being nonzero but greater or equal to zero.

Signed-off-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Daniel Mack <daniel@caiaq.de>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_imx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/spi/spi_imx.c~spi-imx-correct-check-for-platform_get_=
irq-failing drivers/spi/spi_imx.c
--- a/drivers/spi/spi_imx.c~spi-imx-correct-check-for-platform_get_irq-=
failing
+++ a/drivers/spi/spi_imx.c
@@ -555,7 +555,7 @@ static int __init spi_imx_probe(struct p
 	}
=20
 	spi_imx->irq =3D platform_get_irq(pdev, 0);
-	if (!spi_imx->irq) {
+	if (spi_imx->irq < 0) {
 		ret =3D -EINVAL;
 		goto out_iounmap;
 	}
_

Patches currently in -mm which might be from u.kleine-koenig@pengutroni=
x.de are

origin.patch
linux-next.patch
hrtimer-correct-a-few-numbers-in-comments.patch
clockevents-ensure-taht-min_delta_ns-is-increased-in-error-path.patch
mxcmmc-fix-error-path-in-mxcmci_probe.patch
spi-imx-use-platform_driver_probe-as-probe-lives-in-inittext.patch
spi-imx-correct-check-for-platform_get_irq-failing.patch
spi-imx-use-positive-logic-to-distinguish-cpu-variants.patch
spi-imx-add-mx25-support.patch
spi-imx-dont-access-struct-device-directly-but-use-dev_get_platdata.pat=
ch
rtc-add-freescale-mc13783-rtc-driver.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
