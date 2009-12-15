From: akpm@linux-foundation.org
Subject: [obsolete] spi-imx-use-platform_driver_probe-as-probe-lives-in-inittext.patch removed from -mm tree
Date: Mon, 14 Dec 2009 23:50:02 -0800
Message-ID: <200912150750.nBF7o2Jq007698@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45373 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751692AbZLOHvA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 02:51:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: u.kleine-koenig@pengutronix.de, daniel@caiaq.de, dbrownell@users.sourceforge.net, grant.likely@secretlab.ca, s.hauer@pengutronix.de, mm-commits@vger.kernel.org


The patch titled
     spi-imx: use platform_driver_probe as probe lives in .init.text
has been removed from the -mm tree.  Its filename was
     spi-imx-use-platform_driver_probe-as-probe-lives-in-inittext.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: spi-imx: use platform_driver_probe as probe lives in .init.tex=
t
=46rom: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>

Using platform_driver_register with a probe function defined using __in=
it
is wrong.

This fixes an oops after:

	cd /sys/bus/platform/drivers/spi_imx
	echo -n spi_imx.0 > unbind
	echo -n spi_imx.0 > bind

Signed-off-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Daniel Mack <daniel@caiaq.de>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_imx.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/spi/spi_imx.c~spi-imx-use-platform_driver_probe-as-pr=
obe-lives-in-inittext drivers/spi/spi_imx.c
--- a/drivers/spi/spi_imx.c~spi-imx-use-platform_driver_probe-as-probe-=
lives-in-inittext
+++ a/drivers/spi/spi_imx.c
@@ -667,13 +667,12 @@ static struct platform_driver spi_imx_dr
 		   .name =3D DRIVER_NAME,
 		   .owner =3D THIS_MODULE,
 		   },
-	.probe =3D spi_imx_probe,
 	.remove =3D __devexit_p(spi_imx_remove),
 };
=20
 static int __init spi_imx_init(void)
 {
-	return platform_driver_register(&spi_imx_driver);
+	return platform_driver_probe(&spi_imx_driver, spi_imx_probe);
 }
=20
 static void __exit spi_imx_exit(void)
_

Patches currently in -mm which might be from u.kleine-koenig@pengutroni=
x.de are

origin.patch
mxcmmc-fix-error-path-in-mxcmci_probe.patch
linux-next.patch
hrtimer-correct-a-few-numbers-in-comments.patch
clockevents-ensure-taht-min_delta_ns-is-increased-in-error-path.patch
spi-imx-use-platform_driver_probe-as-probe-lives-in-inittext.patch
rtc-add-freescale-mc13783-rtc-driver.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
