From: akpm@linux-foundation.org
Subject: + spi-imx-use-platform_driver_probe-as-probe-lives-in-inittext.patch added to -mm tree
Date: Tue, 08 Dec 2009 15:30:01 -0800
Message-ID: <200912082330.nB8NU1Ud016093@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44024 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S937005AbZLHXaf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Dec 2009 18:30:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: u.kleine-koenig@pengutronix.de, daniel@caiaq.de, dbrownell@users.sourceforge.net, grant.likely@secretlab.ca, s.hauer@pengutronix.de


The patch titled
     spi-imx: use platform_driver_probe as probe lives in .init.text
has been added to the -mm tree.  Its filename is
     spi-imx-use-platform_driver_probe-as-probe-lives-in-inittext.patch

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
@@ -666,13 +666,12 @@ static struct platform_driver spi_imx_dr
 		   .name =3D DRIVER_NAME,
 		   .owner =3D THIS_MODULE,
 		   },
-	.probe =3D spi_imx_probe,
 	.remove =3D __exit_p(spi_imx_remove),
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
linux-next.patch
sysfs-deprecated-features-are-to-help-old-tools-not-to-confuse-them.pat=
ch
hrtimer-correct-a-few-numbers-in-comments.patch
clockevents-ensure-taht-min_delta_ns-is-increased-in-error-path.patch
mxcmmc-fix-error-path-in-mxcmci_probe.patch
spi-drain-mxc-spi-transfer-buffer-when-probing-device.patch
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
