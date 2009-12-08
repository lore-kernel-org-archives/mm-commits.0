From: akpm@linux-foundation.org
Subject: + spi-imx-use-positive-logic-to-distinguish-cpu-variants.patch added to -mm tree
Date: Tue, 08 Dec 2009 15:30:06 -0800
Message-ID: <200912082330.nB8NU6hn016248@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52125 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S937012AbZLHXah (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Dec 2009 18:30:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: u.kleine-koenig@pengutronix.de, daniel@caiaq.de, dbrownell@users.sourceforge.net, grant.likely@secretlab.ca, s.hauer@pengutronix.de


The patch titled
     spi-imx: use positive logic to distinguish cpu variants
has been added to the -mm tree.  Its filename is
     spi-imx-use-positive-logic-to-distinguish-cpu-variants.patch

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
Subject: spi-imx: use positive logic to distinguish cpu variants
=46rom: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>

This is much safer when support for new variants is added.

Signed-off-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Daniel Mack <daniel@caiaq.de>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_imx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/spi/spi_imx.c~spi-imx-use-positive-logic-to-distingui=
sh-cpu-variants drivers/spi/spi_imx.c
--- a/drivers/spi/spi_imx.c~spi-imx-use-positive-logic-to-distinguish-c=
pu-variants
+++ a/drivers/spi/spi_imx.c
@@ -593,7 +593,7 @@ static int __init spi_imx_probe(struct p
 	clk_enable(spi_imx->clk);
 	spi_imx->spi_clk =3D clk_get_rate(spi_imx->clk);
=20
-	if (!cpu_is_mx31() || !cpu_is_mx35())
+	if (cpu_is_mx1() || cpu_is_mx21() || cpu_is_mx27())
 		writel(1, spi_imx->base + MXC_RESET);
=20
 	/* drain receive buffer */
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
