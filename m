From: akpm@linux-foundation.org
Subject: + spi-imx-strip-down-chipselect-function-to-only-drive-the-chipselect.patch added to -mm tree
Date: Wed, 30 Sep 2009 16:53:17 -0700
Message-ID: <200909302353.n8UNrHX9011324@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48568 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755138AbZI3Xxm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Sep 2009 19:53:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: u.kleine-koenig@pengutronix.de, dbrownell@users.sourceforge.net, g.liakhovetski@gmx.de, s.hauer@pengutronix.de


The patch titled
     spi-imx: strip down chipselect function to only drive the chipsele=
ct
has been added to the -mm tree.  Its filename is
     spi-imx-strip-down-chipselect-function-to-only-drive-the-chipselec=
t.patch

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
Subject: spi-imx: strip down chipselect function to only drive the chip=
select
=46rom: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>

spi_imx_chipselect() made things that should be (and mostly are) done b=
y
spi_imx_setupxfer.  Only setting the tx and rx functions was missing.

Signed-off-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
Acked-by: Sascha Hauer <s.hauer@pengutronix.de>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_imx.c |   50 +++++++++++++---------------------------
 1 file changed, 17 insertions(+), 33 deletions(-)

diff -puN drivers/spi/spi_imx.c~spi-imx-strip-down-chipselect-function-=
to-only-drive-the-chipselect drivers/spi/spi_imx.c
--- a/drivers/spi/spi_imx.c~spi-imx-strip-down-chipselect-function-to-o=
nly-drive-the-chipselect
+++ a/drivers/spi/spi_imx.c
@@ -354,43 +354,14 @@ static int mx1_rx_available(struct spi_i
 static void spi_imx_chipselect(struct spi_device *spi, int is_active)
 {
 	struct spi_imx_data *spi_imx =3D spi_master_get_devdata(spi->master);
-	unsigned int cs =3D 0;
 	int gpio =3D spi_imx->chipselect[spi->chip_select];
-	struct spi_imx_config config;
-
-	if (spi->mode & SPI_CS_HIGH)
-		cs =3D 1;
+	int active =3D is_active !=3D BITBANG_CS_INACTIVE;
+	int dev_is_lowactive =3D !(spi->mode & SPI_CS_HIGH);
=20
-	if (is_active =3D=3D BITBANG_CS_INACTIVE) {
-		if (gpio >=3D 0)
-			gpio_set_value(gpio, !cs);
+	if (gpio < 0)
 		return;
-	}
-
-	config.bpw =3D spi->bits_per_word;
-	config.speed_hz =3D spi->max_speed_hz;
-	config.mode =3D spi->mode;
-	config.cs =3D spi_imx->chipselect[spi->chip_select];
-
-	spi_imx->config(spi_imx, &config);
-
-	/* Initialize the functions for transfer */
-	if (config.bpw <=3D 8) {
-		spi_imx->rx =3D spi_imx_buf_rx_u8;
-		spi_imx->tx =3D spi_imx_buf_tx_u8;
-	} else if (config.bpw <=3D 16) {
-		spi_imx->rx =3D spi_imx_buf_rx_u16;
-		spi_imx->tx =3D spi_imx_buf_tx_u16;
-	} else if (config.bpw <=3D 32) {
-		spi_imx->rx =3D spi_imx_buf_rx_u32;
-		spi_imx->tx =3D spi_imx_buf_tx_u32;
-	} else
-		BUG();
-
-	if (gpio >=3D 0)
-		gpio_set_value(gpio, cs);
=20
-	return;
+	gpio_set_value(gpio, dev_is_lowactive ^ active);
 }
=20
 static void spi_imx_push(struct spi_imx_data *spi_imx)
@@ -451,6 +422,19 @@ static int spi_imx_setupxfer(struct spi_
 	if (!config.speed_hz)
 		config.speed_hz =3D spi->max_speed_hz;
=20
+	/* Initialize the functions for transfer */
+	if (config.bpw <=3D 8) {
+		spi_imx->rx =3D spi_imx_buf_rx_u8;
+		spi_imx->tx =3D spi_imx_buf_tx_u8;
+	} else if (config.bpw <=3D 16) {
+		spi_imx->rx =3D spi_imx_buf_rx_u16;
+		spi_imx->tx =3D spi_imx_buf_tx_u16;
+	} else if (config.bpw <=3D 32) {
+		spi_imx->rx =3D spi_imx_buf_rx_u32;
+		spi_imx->tx =3D spi_imx_buf_tx_u32;
+	} else
+		BUG();
+
 	spi_imx->config(spi_imx, &config);
=20
 	return 0;
_

Patches currently in -mm which might be from u.kleine-koenig@pengutroni=
x.de are

linux-next.patch
spi-imx-rename-source-file-to-spi_imxc.patch
spi-imx-update-state-correctly.patch
spi-imx-fix-initial-chipselect-settings.patch
spi-imx-setup-mode_bits-we-can-handle.patch
spi-imx-no-need-to-assert-bits_per_word-being-initialized.patch
spi-imx-initialize-complete-config-struct.patch
spi-imx-strip-down-chipselect-function-to-only-drive-the-chipselect.pat=
ch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
