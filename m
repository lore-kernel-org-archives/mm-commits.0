From: akpm@linux-foundation.org
Subject: + spi-imx-no-need-to-assert-bits_per_word-being-initialized.patch added to -mm tree
Date: Wed, 30 Sep 2009 16:53:13 -0700
Message-ID: <200909302353.n8UNrDxY011172@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44791 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755070AbZI3Xxi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Sep 2009 19:53:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: u.kleine-koenig@pengutronix.de, dbrownell@users.sourceforge.net, g.liakhovetski@gmx.de, s.hauer@pengutronix.de


The patch titled
     spi-imx: no need to assert bits_per_word being initialized
has been added to the -mm tree.  Its filename is
     spi-imx-no-need-to-assert-bits_per_word-being-initialized.patch

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
