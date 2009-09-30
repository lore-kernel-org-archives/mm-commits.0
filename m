From: akpm@linux-foundation.org
Subject: + spi-imx-setup-mode_bits-we-can-handle.patch added to -mm tree
Date: Wed, 30 Sep 2009 16:53:11 -0700
Message-ID: <200909302353.n8UNrB7P011090@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58750 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754920AbZI3Xx4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Sep 2009 19:53:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: s.hauer@pengutronix.de, dbrownell@users.sourceforge.net, g.liakhovetski@gmx.de, u.kleine-koenig@pengutronix.de


The patch titled
     spi-imx: setup mode_bits we can handle
has been added to the -mm tree.  Its filename is
     spi-imx-setup-mode_bits-we-can-handle.patch

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
