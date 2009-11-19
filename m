From: akpm@linux-foundation.org
Subject: + spi-drain-mxc-spi-transfer-buffer-when-probing-device.patch added to -mm tree
Date: Thu, 19 Nov 2009 14:46:05 -0800
Message-ID: <200911192246.nAJMk5SO031998@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47553 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756250AbZKSWqi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Nov 2009 17:46:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: daniel@caiaq.de, dbrownell@users.sourceforge.net, s.hauer@pengutronix.de, u.kleine-koenig@pengutronix.de


The patch titled
     spi: drain MXC SPI transfer buffer when probing device
has been added to the -mm tree.  Its filename is
     spi-drain-mxc-spi-transfer-buffer-when-probing-device.patch

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
Subject: spi: drain MXC SPI transfer buffer when probing device
=46rom: Daniel Mack <daniel@caiaq.de>

On the MX31litekit, the bootloader seems to communicate with the MC1378=
3
PMIC chip before booting Linux.  However, it does not flush all the
buffers properly after that, which makes the imx-spi driver read bogus
data when probing the MC13783.

=46ix that by draining the SPI receive buffer on startup.

Signed-off-by: Daniel Mack <daniel@caiaq.de>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Acked-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_imx.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN drivers/spi/spi_imx.c~spi-drain-mxc-spi-transfer-buffer-when-=
probing-device drivers/spi/spi_imx.c
--- a/drivers/spi/spi_imx.c~spi-drain-mxc-spi-transfer-buffer-when-prob=
ing-device
+++ a/drivers/spi/spi_imx.c
@@ -44,6 +44,9 @@
 #define MXC_CSPIINT		0x0c
 #define MXC_RESET		0x1c
=20
+#define MX3_CSPISTAT		0x14
+#define MX3_CSPISTAT_RR		(1 << 3)
+
 /* generic defines to abstract from the different register layouts */
 #define MXC_INT_RR	(1 << 0) /* Receive data ready interrupt */
 #define MXC_INT_TE	(1 << 1) /* Transmit FIFO empty interrupt */
@@ -593,6 +596,11 @@ static int __init spi_imx_probe(struct p
 	if (!cpu_is_mx31() || !cpu_is_mx35())
 		writel(1, spi_imx->base + MXC_RESET);
=20
+	/* drain receive buffer */
+	if (cpu_is_mx31() || cpu_is_mx35())
+		while (readl(spi_imx->base + MX3_CSPISTAT) & MX3_CSPISTAT_RR)
+			readl(spi_imx->base + MXC_CSPIRXDATA);
+
 	spi_imx->intctrl(spi_imx, 0);
=20
 	ret =3D spi_bitbang_start(&spi_imx->bitbang);
_

Patches currently in -mm which might be from daniel@caiaq.de are

linux-next.patch
drivers-misc-add-driver-for-texas-instruments-dac7512.patch
drivers-misc-add-driver-for-texas-instruments-dac7512-update.patch
spi-drain-mxc-spi-transfer-buffer-when-probing-device.patch
vt-make-the-default-cursor-shape-configurable.patch
drivers-video-move-dereference-after-null-test.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
