From: akpm@linux-foundation.org
Subject: [merged] spi-imx-initialize-complete-config-struct.patch removed from -mm tree
Date: Mon, 05 Oct 2009 11:39:49 -0700
Message-ID: <200910051839.n95IdnrQ019868@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53117 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754606AbZJESku (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Oct 2009 14:40:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: u.kleine-koenig@pengutronix.de, dbrownell@users.sourceforge.net, g.liakhovetski@gmx.de, s.hauer@pengutronix.de, mm-commits@vger.kernel.org


The patch titled
     spi-imx: initialize complete config struct
has been removed from the -mm tree.  Its filename was
     spi-imx-initialize-complete-config-struct.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: spi-imx: initialize complete config struct
=46rom: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>

Otherwise the config function uses random data from the stack.  This
didn't stick out because config is called once more in the chipselect
function with correct parameters.

Signed-off-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
Acked-by: Sascha Hauer <s.hauer@pengutronix.de>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_imx.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/spi/spi_imx.c~spi-imx-initialize-complete-config-stru=
ct drivers/spi/spi_imx.c
--- a/drivers/spi/spi_imx.c~spi-imx-initialize-complete-config-struct
+++ a/drivers/spi/spi_imx.c
@@ -442,6 +442,7 @@ static int spi_imx_setupxfer(struct spi_
 	config.bpw =3D t ? t->bits_per_word : spi->bits_per_word;
 	config.speed_hz  =3D t ? t->speed_hz : spi->max_speed_hz;
 	config.mode =3D spi->mode;
+	config.cs =3D spi_imx->chipselect[spi->chip_select];
=20
 	if (!config.speed_hz)
 		config.speed_hz =3D spi->max_speed_hz;
_

Patches currently in -mm which might be from u.kleine-koenig@pengutroni=
x.de are

linux-next.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
