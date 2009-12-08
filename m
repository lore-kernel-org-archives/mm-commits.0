From: akpm@linux-foundation.org
Subject: + spi-imx-add-mx25-support.patch added to -mm tree
Date: Tue, 08 Dec 2009 15:30:08 -0800
Message-ID: <200912082330.nB8NU8Pi016371@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45660 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S937000AbZLHXbD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Dec 2009 18:31:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: s.hauer@pengutronix.de, daniel@caiaq.de, dbrownell@users.sourceforge.net, grant.likely@secretlab.ca, u.kleine-koenig@pengutronix.de


The patch titled
     spi-imx: add mx25 support
has been added to the -mm tree.  Its filename is
     spi-imx-add-mx25-support.patch

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
@@ -565,7 +565,7 @@ static int __init spi_imx_probe(struct p
 		goto out_iounmap;
 	}
=20
-	if (cpu_is_mx31() || cpu_is_mx35()) {
+	if (cpu_is_mx25() || cpu_is_mx31() || cpu_is_mx35()) {
 		spi_imx->intctrl =3D mx31_intctrl;
 		spi_imx->config =3D mx31_config;
 		spi_imx->trigger =3D mx31_trigger;
@@ -597,7 +597,7 @@ static int __init spi_imx_probe(struct p
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
