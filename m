From: akpm@linux-foundation.org
Subject: [merged] spi-imx-setup-mode_bits-we-can-handle.patch removed from -mm tree
Date: Mon, 05 Oct 2009 11:39:43 -0700
Message-ID: <200910051839.n95Idh9n019712@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47420 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754641AbZJESlH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Oct 2009 14:41:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: s.hauer@pengutronix.de, dbrownell@users.sourceforge.net, g.liakhovetski@gmx.de, u.kleine-koenig@pengutronix.de, mm-commits@vger.kernel.org


The patch titled
     spi-imx: setup mode_bits we can handle
has been removed from the -mm tree.  Its filename was
     spi-imx-setup-mode_bits-we-can-handle.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: spi-imx: setup mode_bits we can handle
=46rom: Sascha Hauer <s.hauer@pengutronix.de>

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_imx.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/spi/spi_imx.c~spi-imx-setup-mode_bits-we-can-handle d=
rivers/spi/spi_imx.c
--- a/drivers/spi/spi_imx.c~spi-imx-setup-mode_bits-we-can-handle
+++ a/drivers/spi/spi_imx.c
@@ -545,6 +545,7 @@ static int __init spi_imx_probe(struct p
 	spi_imx->bitbang.txrx_bufs =3D spi_imx_transfer;
 	spi_imx->bitbang.master->setup =3D spi_imx_setup;
 	spi_imx->bitbang.master->cleanup =3D spi_imx_cleanup;
+	spi_imx->bitbang.master->mode_bits =3D SPI_CPOL | SPI_CPHA | SPI_CS_H=
IGH;
=20
 	init_completion(&spi_imx->xfer_done);
=20
_

Patches currently in -mm which might be from s.hauer@pengutronix.de are


--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
