From: akpm@linux-foundation.org
Subject: [merged] spi-imx-use-positive-logic-to-distinguish-cpu-variants.patch removed from -mm tree
Date: Mon, 14 Dec 2009 13:23:52 -0800
Message-ID: <200912142123.nBELNqEM017764@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60897 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932679AbZLNVYT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Dec 2009 16:24:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: u.kleine-koenig@pengutronix.de, daniel@caiaq.de, dbrownell@users.sourceforge.net, grant.likely@secretlab.ca, s.hauer@pengutronix.de, mm-commits@vger.kernel.org


The patch titled
     spi-imx: use positive logic to distinguish cpu variants
has been removed from the -mm tree.  Its filename was
     spi-imx-use-positive-logic-to-distinguish-cpu-variants.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

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
@@ -594,7 +594,7 @@ static int __init spi_imx_probe(struct p
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
