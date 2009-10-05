From: akpm@linux-foundation.org
Subject: [merged] spi-imx-no-need-to-assert-bits_per_word-being-initialized.patch removed from -mm tree
Date: Mon, 05 Oct 2009 11:39:46 -0700
Message-ID: <200910051839.n95Idk6x019780@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32782 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754593AbZJESkt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Oct 2009 14:40:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: u.kleine-koenig@pengutronix.de, dbrownell@users.sourceforge.net, g.liakhovetski@gmx.de, s.hauer@pengutronix.de, mm-commits@vger.kernel.org


The patch titled
     spi-imx: no need to assert bits_per_word being initialized
has been removed from the -mm tree.  Its filename was
     spi-imx-no-need-to-assert-bits_per_word-being-initialized.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: spi-imx: no need to assert bits_per_word being initialized
=46rom: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>

spi_imx_setup() is only called by spi_setup().  The latter does the
initialization already.

Signed-off-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
Acked-by: Sascha Hauer <s.hauer@pengutronix.de>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_imx.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN drivers/spi/spi_imx.c~spi-imx-no-need-to-assert-bits_per_word=
-being-initialized drivers/spi/spi_imx.c
--- a/drivers/spi/spi_imx.c~spi-imx-no-need-to-assert-bits_per_word-bei=
ng-initialized
+++ a/drivers/spi/spi_imx.c
@@ -481,9 +481,6 @@ static int spi_imx_setup(struct spi_devi
 	struct spi_imx_data *spi_imx =3D spi_master_get_devdata(spi->master);
 	int gpio =3D spi_imx->chipselect[spi->chip_select];
=20
-	if (!spi->bits_per_word)
-		spi->bits_per_word =3D 8;
