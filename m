From: akpm@linux-foundation.org
Subject: [merged] spi-imx-add-mx25-support.patch removed from -mm tree
Date: Mon, 14 Dec 2009 13:23:55 -0800
Message-ID: <200912142123.nBELNtJh017952@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60612 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932679AbZLNVYW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Dec 2009 16:24:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: s.hauer@pengutronix.de, daniel@caiaq.de, dbrownell@users.sourceforge.net, grant.likely@secretlab.ca, u.kleine-koenig@pengutronix.de, mm-commits@vger.kernel.org


The patch titled
     spi-imx: add mx25 support
has been removed from the -mm tree.  Its filename was
     spi-imx-add-mx25-support.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: spi-imx: add mx25 support
=46rom: Sascha Hauer <s.hauer@pengutronix.de>

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Daniel Mack <daniel@caiaq.de>
Cc: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_imx.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/spi/spi_imx.c~spi-imx-add-mx25-support drivers/spi/sp=
i_imx.c
--- a/drivers/spi/spi_imx.c~spi-imx-add-mx25-support
+++ a/drivers/spi/spi_imx.c
@@ -208,7 +208,7 @@ static int mx31_config(struct spi_imx_da
=20
 	if (cpu_is_mx31())
 		reg |=3D (config->bpw - 1) << MX31_CSPICTRL_BC_SHIFT;
-	else if (cpu_is_mx35()) {
+	else if (cpu_is_mx25() || cpu_is_mx35()) {
 		reg |=3D (config->bpw - 1) << MX35_CSPICTRL_BL_SHIFT;
 		reg |=3D MX31_CSPICTRL_SSCTL;
 	}
@@ -222,7 +222,7 @@ static int mx31_config(struct spi_imx_da
 	if (config->cs < 0) {
 		if (cpu_is_mx31())
 			reg |=3D (config->cs + 32) << MX31_CSPICTRL_CS_SHIFT;
-		else if (cpu_is_mx35())
+		else if (cpu_is_mx25() || cpu_is_mx35())
 			reg |=3D (config->cs + 32) << MX35_CSPICTRL_CS_SHIFT;
 	}
=20
@@ -566,7 +566,7 @@ static int __init spi_imx_probe(struct p
 		goto out_iounmap;
 	}
=20
-	if (cpu_is_mx31() || cpu_is_mx35()) {
+	if (cpu_is_mx25() || cpu_is_mx31() || cpu_is_mx35()) {
 		spi_imx->intctrl =3D mx31_intctrl;
 		spi_imx->config =3D mx31_config;
 		spi_imx->trigger =3D mx31_trigger;
@@ -598,7 +598,7 @@ static int __init spi_imx_probe(struct p
 		writel(1, spi_imx->base + MXC_RESET);
=20
 	/* drain receive buffer */
-	if (cpu_is_mx31() || cpu_is_mx35())
+	if (cpu_is_mx25() || cpu_is_mx31() || cpu_is_mx35())
 		while (readl(spi_imx->base + MX3_CSPISTAT) & MX3_CSPISTAT_RR)
 			readl(spi_imx->base + MXC_CSPIRXDATA);
=20
_

Patches currently in -mm which might be from s.hauer@pengutronix.de are

origin.patch
linux-next.patch
imx-bit-confusion.patch
mxcmmc-fix-error-path-in-mxcmci_probe.patch
spi-imx-use-platform_driver_probe-as-probe-lives-in-inittext.patch
rtc-add-freescale-mc13783-rtc-driver.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
