From: akpm@osdl.org
Subject: + spi-controller-driver-for-omap-microwire-update.patch added to -mm tree
Date: Thu, 28 Dec 2006 16:03:44 -0800
Message-ID: <200612290003.kBT03jEg016836@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:43985 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753924AbWL2ADs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Dec 2006 19:03:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david-b@pacbell.net


The patch titled
     SPI controller driver for OMAP Microwire (update)
has been added to the -mm tree.  Its filename is
     spi-controller-driver-for-omap-microwire-update.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to =
find
out what to do about this

------------------------------------------------------
Subject: SPI controller driver for OMAP Microwire (update)
=46rom: David Brownell <david-b@pacbell.net>



Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/spi/omap_uwire.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/spi/omap_uwire.c~spi-controller-driver-for-omap-micro=
wire-update drivers/spi/omap_uwire.c
--- a/drivers/spi/omap_uwire.c~spi-controller-driver-for-omap-microwire=
-update
+++ a/drivers/spi/omap_uwire.c
@@ -6,7 +6,7 @@
  * Ported to 2.6 OMAP uwire interface.
  * Copyright (C) 2004 Texas Instruments.
  *
- * Generalization patches by Juha Yrj=C3=B6l=C3=A4 <juha.yrjola@nokia.=
com>
+ * Generalization patches by Juha Yrj=F6l=E4 <juha.yrjola@nokia.com>
  *
  * Copyright (C) 2005 David Brownell (ported to 2.6 SPI interface)
  * Copyright (C) 2006 Nokia
@@ -403,8 +403,8 @@ static int uwire_setup_transfer(struct s
 	if (div1_idx =3D=3D 4) {
 		pr_debug("%s: lowest clock %ld, need %d\n",
 			spi->dev.bus_id, rate / 10 / 8, hz);
-		status =3D -EDOM;
-		goto done;
+			status =3D -EDOM;
+			goto done;
 	}
=20
 	/* we have to cache this and reset in uwire_chipselect as this is a
@@ -480,7 +480,7 @@ static int uwire_probe(struct platform_d
=20
 	master =3D spi_alloc_master(&pdev->dev, sizeof *uwire);
 	if (!master)
-		return -ENOMEM;
+		return -ENODEV;
=20
 	uwire =3D spi_master_get_devdata(master);
 	dev_set_drvdata(&pdev->dev, uwire);
_

Patches currently in -mm which might be from david-b@pacbell.net are

spi-define-null-tx_buf-to-mean-shift-out-zeroes.patch
m25p80-build-fixes-with-mtd-debug.patch
spi-mtd-mtd_dataflash-oops-prevention.patch
spi-kconfig-fix.patch
spi-controller-driver-for-omap-microwire.patch
spi-controller-driver-for-omap-microwire-update.patch
pnp-export-pnp_bus_type.patch
gpio-core.patch
omap-gpio-wrappers.patch
at91-gpio-wrappers.patch

-
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
