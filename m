From: akpm@linux-foundation.org
Subject: + spi-imx-initialize-complete-config-struct.patch added to -mm tree
Date: Wed, 30 Sep 2009 16:53:15 -0700
Message-ID: <200909302353.n8UNrFpp011213@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59247 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754920AbZI3XyC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Sep 2009 19:54:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: u.kleine-koenig@pengutronix.de, dbrownell@users.sourceforge.net, g.liakhovetski@gmx.de, s.hauer@pengutronix.de


The patch titled
     spi-imx: initialize complete config struct
has been added to the -mm tree.  Its filename is
     spi-imx-initialize-complete-config-struct.patch

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
