From: akpm@linux-foundation.org
Subject: + mpc5200-fix-build-error-on-mpc52xx_psc_spi-device-driver.patch added to -mm tree
Date: Mon, 25 Feb 2008 12:43:17 -0800
Message-ID: <200802252044.m1PKi9K0018720@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:53716 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758315AbYBYUoz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Feb 2008 15:44:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: grant.likely@secretlab.ca, benh@kernel.crashing.org, david-b@pacbell.net, galak@gate.crashing.org, paulus@samba.org


The patch titled
     powerpc: mpc5200: fix build error on mpc52xx_psc_spi device driver
has been added to the -mm tree.  Its filename is
     mpc5200-fix-build-error-on-mpc52xx_psc_spi-device-driver.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: powerpc: mpc5200: fix build error on mpc52xx_psc_spi device driver
From: Grant Likely <grant.likely@secretlab.ca>

Commit id 94f389485e27641348c1951ab8d65157122a8939 (Separate MPC52xx PSC FIOF
regsiters from the rest of PSC) split the PSC fifo registers away from the
core PSC regs.  Doing so broke the mpc52xx_psc_spi driver.

This patch teaches the mpc52xx_psc_spi driver about the new PSC fifo
register definitions.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Cc: David Brownell <david-b@pacbell.net>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Kumar Gala <galak@gate.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/mpc52xx_psc_spi.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff -puN drivers/spi/mpc52xx_psc_spi.c~mpc5200-fix-build-error-on-mpc52xx_psc_spi-device-driver drivers/spi/mpc52xx_psc_spi.c
--- a/drivers/spi/mpc52xx_psc_spi.c~mpc5200-fix-build-error-on-mpc52xx_psc_spi-device-driver
+++ a/drivers/spi/mpc52xx_psc_spi.c
@@ -42,6 +42,7 @@ struct mpc52xx_psc_spi {
 
 	/* driver internal data */
 	struct mpc52xx_psc __iomem *psc;
+	struct mpc52xx_psc_fifo __iomem *fifo;
 	unsigned int irq;
 	u8 bits_per_word;
 	u8 busy;
@@ -139,6 +140,7 @@ static int mpc52xx_psc_spi_transfer_rxtx
 {
 	struct mpc52xx_psc_spi *mps = spi_master_get_devdata(spi->master);
 	struct mpc52xx_psc __iomem *psc = mps->psc;
+	struct mpc52xx_psc_fifo __iomem *fifo = mps->fifo;
 	unsigned rb = 0;	/* number of bytes receieved */
 	unsigned sb = 0;	/* number of bytes sent */
 	unsigned char *rx_buf = (unsigned char *)t->rx_buf;
@@ -190,11 +192,11 @@ static int mpc52xx_psc_spi_transfer_rxtx
 			out_8(&psc->mode, 0);
 		} else {
 			out_8(&psc->mode, MPC52xx_PSC_MODE_FFULL);
-			out_be16(&psc->rfalarm, rfalarm);
+			out_be16(&fifo->rfalarm, rfalarm);
 		}
 		out_be16(&psc->mpc52xx_psc_imr, MPC52xx_PSC_IMR_RXRDY);
 		wait_for_completion(&mps->done);
-		recv_at_once = in_be16(&psc->rfnum);
+		recv_at_once = in_be16(&fifo->rfnum);
 		dev_dbg(&spi->dev, "%d bytes received\n", recv_at_once);
 
 		send_at_once = recv_at_once;
@@ -331,6 +333,7 @@ static void mpc52xx_psc_spi_cleanup(stru
 static int mpc52xx_psc_spi_port_config(int psc_id, struct mpc52xx_psc_spi *mps)
 {
 	struct mpc52xx_psc __iomem *psc = mps->psc;
+	struct mpc52xx_psc_fifo __iomem *fifo = mps->fifo;
 	u32 mclken_div;
 	int ret = 0;
 
@@ -346,7 +349,7 @@ static int mpc52xx_psc_spi_port_config(i
 	/* Disable interrupts, interrupts are based on alarm level */
 	out_be16(&psc->mpc52xx_psc_imr, 0);
 	out_8(&psc->command, MPC52xx_PSC_SEL_MODE_REG_1);
-	out_8(&psc->rfcntl, 0);
+	out_8(&fifo->rfcntl, 0);
 	out_8(&psc->mode, MPC52xx_PSC_MODE_FFULL);
 
 	/* Configure 8bit codec mode as a SPI master and use EOF flags */
@@ -419,6 +422,8 @@ static int __init mpc52xx_psc_spi_do_pro
 		ret = -EFAULT;
 		goto free_master;
 	}
+	/* On the 5200, fifo regs are immediately ajacent to the psc regs */
+	mps->fifo = ((void __iomem *)mps->psc) + sizeof(struct mpc52xx_psc);
 
 	ret = request_irq(mps->irq, mpc52xx_psc_spi_isr, 0, "mpc52xx-psc-spi",
 				mps);
_

Patches currently in -mm which might be from grant.likely@secretlab.ca are

mpc5200-fix-build-error-on-mpc52xx_psc_spi-device-driver.patch
