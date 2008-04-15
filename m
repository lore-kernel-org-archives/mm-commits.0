From: akpm@linux-foundation.org
Subject: - spi-spi_s3c24xx-must-initialize-num_chipselect.patch removed from -mm tree
Date: Tue, 15 Apr 2008 12:31:04 -0700
Message-ID: <200804151931.m3FJV4rQ011563@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42255 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750982AbYDOTcR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Apr 2008 15:32:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ben-linux@fluff.org, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     spi: spi_s3c24xx must initialize num_chipselect
has been removed from the -mm tree.  Its filename was
     spi-spi_s3c24xx-must-initialize-num_chipselect.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: spi: spi_s3c24xx must initialize num_chipselect
From: Ben Dooks <ben-linux@fluff.org>

The s3c24xx_spi_txrx() function should initialise the completion each time
before using it, otherwise we end up with the possibility of returning success
before the interrupt handler has processed all the data.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_s3c24xx.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN drivers/spi/spi_s3c24xx.c~spi-spi_s3c24xx-must-initialize-num_chipselect drivers/spi/spi_s3c24xx.c
--- a/drivers/spi/spi_s3c24xx.c~spi-spi_s3c24xx-must-initialize-num_chipselect
+++ a/drivers/spi/spi_s3c24xx.c
@@ -192,8 +192,11 @@ static int s3c24xx_spi_txrx(struct spi_d
 	hw->len = t->len;
 	hw->count = 0;
 
+	init_completion(&hw->done);
+
 	/* send the first byte */
 	writeb(hw_txbyte(hw, 0), hw->regs + S3C2410_SPTDAT);
+
 	wait_for_completion(&hw->done);
 
 	return hw->count;
_

Patches currently in -mm which might be from ben-linux@fluff.org are

spi-spi_s3c24xx-driver-must-init-completion.patch
spi-spi_s3c24xx-must-initialize-bus_num.patch
spi-spi_s3c24xx-must-initialize-num_chipselect.patch
net-drivers-fix-platform-driver-hotplug-coldplug.patch
sm501-add-uart-support.patch
video-replace-remaining-__function__-occurrences.patch
drivers-replace-remaining-__function__-occurrences.patch

