From: akpm@linux-foundation.org
Subject: [merged] spi-imx-update-state-correctly.patch removed from -mm tree
Date: Mon, 05 Oct 2009 11:39:37 -0700
Message-ID: <200910051839.n95IdbgK019436@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39672 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754523AbZJESkq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Oct 2009 14:40:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: s.hauer@pengutronix.de, dbrownell@users.sourceforge.net, g.liakhovetski@gmx.de, u.kleine-koenig@pengutronix.de, mm-commits@vger.kernel.org


The patch titled
     spi-imx: update state correctly
has been removed from the -mm tree.  Its filename was
     spi-imx-update-state-correctly.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: spi-imx: update state correctly
=46rom: Sascha Hauer <s.hauer@pengutronix.de>

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_imx.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN drivers/spi/spi_imx.c~spi-imx-update-state-correctly drivers/=
spi/spi_imx.c
--- a/drivers/spi/spi_imx.c~spi-imx-update-state-correctly
+++ a/drivers/spi/spi_imx.c
@@ -443,6 +443,13 @@ static int spi_imx_setupxfer(struct spi_
 	config.speed_hz  =3D t ? t->speed_hz : spi->max_speed_hz;
 	config.mode =3D spi->mode;
=20
+	if (!config.speed_hz)
+		config.speed_hz =3D spi->max_speed_hz;
+	if (!config.bpw)
+		config.bpw =3D spi->bits_per_word;
+	if (!config.speed_hz)
+		config.speed_hz =3D spi->max_speed_hz;
+
 	spi_imx->config(spi_imx, &config);
=20
 	return 0;
_

Patches currently in -mm which might be from s.hauer@pengutronix.de are


--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
