From: akpm@linux-foundation.org
Subject: [merged] spi-imx-dont-access-struct-device-directly-but-use-dev_get_platdata.patch removed from -mm tree
Date: Mon, 14 Dec 2009 13:23:58 -0800
Message-ID: <200912142123.nBELNwWN018046@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54426 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933075AbZLNVYX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Dec 2009 16:24:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: u.kleine-koenig@pengutronix.de, daniel@caiaq.de, dbrownell@users.sourceforge.net, grant.likely@secretlab.ca, s.hauer@pengutronix.de, mm-commits@vger.kernel.org


The patch titled
     spi-imx: don't access struct device directly but use dev_get_platd=
ata
has been removed from the -mm tree.  Its filename was
     spi-imx-dont-access-struct-device-directly-but-use-dev_get_platdat=
a.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: spi-imx: don't access struct device directly but use dev_get_p=
latdata
=46rom: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>

Also there is no casting needed to assign a void pointer.

Signed-off-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Daniel Mack <daniel@caiaq.de>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_imx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/spi/spi_imx.c~spi-imx-dont-access-struct-device-direc=
tly-but-use-dev_get_platdata drivers/spi/spi_imx.c
--- a/drivers/spi/spi_imx.c~spi-imx-dont-access-struct-device-directly-=
but-use-dev_get_platdata
+++ a/drivers/spi/spi_imx.c
@@ -492,7 +492,7 @@ static int __init spi_imx_probe(struct p
 	struct resource *res;
 	int i, ret;
=20
-	mxc_platform_info =3D (struct spi_imx_master *)pdev->dev.platform_dat=
a;
+	mxc_platform_info =3D dev_get_platdata(&pdev->dev);
 	if (!mxc_platform_info) {
 		dev_err(&pdev->dev, "can't get the platform data\n");
 		return -EINVAL;
_

Patches currently in -mm which might be from u.kleine-koenig@pengutroni=
x.de are

origin.patch
linux-next.patch
hrtimer-correct-a-few-numbers-in-comments.patch
clockevents-ensure-taht-min_delta_ns-is-increased-in-error-path.patch
mxcmmc-fix-error-path-in-mxcmci_probe.patch
spi-imx-use-platform_driver_probe-as-probe-lives-in-inittext.patch
rtc-add-freescale-mc13783-rtc-driver.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
