From: akpm@linux-foundation.org
Subject: [merged] spi-imx-fix-initial-chipselect-settings.patch removed from -mm tree
Date: Mon, 05 Oct 2009 11:39:40 -0700
Message-ID: <200910051839.n95Ided8019571@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59515 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754584AbZJESkt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Oct 2009 14:40:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: s.hauer@pengutronix.de, dbrownell@users.sourceforge.net, g.liakhovetski@gmx.de, u.kleine-koenig@pengutronix.de, mm-commits@vger.kernel.org


The patch titled
     spi-imx: fix initial chipselect settings
has been removed from the -mm tree.  Its filename was
     spi-imx-fix-initial-chipselect-settings.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: spi-imx: fix initial chipselect settings
=46rom: Sascha Hauer <s.hauer@pengutronix.de>

We can only setup the gpio pins in spi_setup time when we know the
SPI_CS_HIGH setting.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_imx.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN drivers/spi/spi_imx.c~spi-imx-fix-initial-chipselect-settings=
 drivers/spi/spi_imx.c
--- a/drivers/spi/spi_imx.c~spi-imx-fix-initial-chipselect-settings
+++ a/drivers/spi/spi_imx.c
@@ -478,12 +478,18 @@ static int spi_imx_transfer(struct spi_d
=20
 static int spi_imx_setup(struct spi_device *spi)
 {
+	struct spi_imx_data *spi_imx =3D spi_master_get_devdata(spi->master);
+	int gpio =3D spi_imx->chipselect[spi->chip_select];
+
 	if (!spi->bits_per_word)
 		spi->bits_per_word =3D 8;
=20
 	pr_debug("%s: mode %d, %u bpw, %d hz\n", __func__,
 		 spi->mode, spi->bits_per_word, spi->max_speed_hz);
=20
+	if (gpio >=3D 0)
+		gpio_direction_output(gpio, spi->mode & SPI_CS_HIGH ? 0 : 1);
+
 	spi_imx_chipselect(spi, BITBANG_CS_INACTIVE);
=20
 	return 0;
@@ -532,7 +538,6 @@ static int __init spi_imx_probe(struct p
 			dev_err(&pdev->dev, "can't get cs gpios");
 			goto out_master_put;
 		}
-		gpio_direction_output(spi_imx->chipselect[i], 1);
 	}
=20
 	spi_imx->bitbang.chipselect =3D spi_imx_chipselect;
_

Patches currently in -mm which might be from s.hauer@pengutronix.de are


--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
