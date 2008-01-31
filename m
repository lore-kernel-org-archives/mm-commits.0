From: akpm@linux-foundation.org
Subject: + spi_bfin-wait-for-tx-to-complete-on-write-paths.patch added to -mm tree
Date: Thu, 31 Jan 2008 13:27:04 -0800
Message-ID: <200801312127.m0VLR4Vd012159@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37266 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754981AbYAaV1T (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 31 Jan 2008 16:27:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sonic.zhang@analog.com, bryan.wu@analog.com, dbrownell@users.sourceforge.net


The patch titled
     spi_bfin: wait for tx to complete on write paths
has been added to the -mm tree.  Its filename is
     spi_bfin-wait-for-tx-to-complete-on-write-paths.patch

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
Subject: spi_bfin: wait for tx to complete on write paths
From: Sonic Zhang <sonic.zhang@analog.com>

SPI writes should also not return until the last bit is sent.

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_bfin5xx.c |   22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff -puN drivers/spi/spi_bfin5xx.c~spi_bfin-wait-for-tx-to-complete-on-write-paths drivers/spi/spi_bfin5xx.c
--- a/drivers/spi/spi_bfin5xx.c~spi_bfin-wait-for-tx-to-complete-on-write-paths
+++ a/drivers/spi/spi_bfin5xx.c
@@ -278,16 +278,16 @@ static void u8_writer(struct driver_data
 	dev_dbg(&drv_data->pdev->dev,
 		"cr8-s is 0x%x\n", read_STAT(drv_data));
 
-	/* poll for SPI completion before start */
-	while (!(read_STAT(drv_data) & BIT_STAT_SPIF))
-		cpu_relax();
-
 	while (drv_data->tx < drv_data->tx_end) {
 		write_TDBR(drv_data, (*(u8 *) (drv_data->tx)));
 		while (read_STAT(drv_data) & BIT_STAT_TXS)
 			cpu_relax();
 		++drv_data->tx;
 	}
+
+	/* poll for SPI completion before return */
+	while (!(read_STAT(drv_data) & BIT_STAT_SPIF))
+		cpu_relax();
 }
 
 static void u8_cs_chg_writer(struct driver_data *drv_data)
@@ -398,32 +398,30 @@ static void u16_writer(struct driver_dat
 	dev_dbg(&drv_data->pdev->dev,
 		"cr16 is 0x%x\n", read_STAT(drv_data));
 
-	/* poll for SPI completion before start */
-	while (!(read_STAT(drv_data) & BIT_STAT_SPIF))
-		cpu_relax();
-
 	while (drv_data->tx < drv_data->tx_end) {
 		write_TDBR(drv_data, (*(u16 *) (drv_data->tx)));
 		while ((read_STAT(drv_data) & BIT_STAT_TXS))
 			cpu_relax();
 		drv_data->tx += 2;
 	}
+
+	/* poll for SPI completion before return */
+	while (!(read_STAT(drv_data) & BIT_STAT_SPIF))
+		cpu_relax();
 }
 
 static void u16_cs_chg_writer(struct driver_data *drv_data)
 {
 	struct chip_data *chip = drv_data->cur_chip;
 
-	/* poll for SPI completion before start */
-	while (!(read_STAT(drv_data) & BIT_STAT_SPIF))
-		cpu_relax();
-
 	while (drv_data->tx < drv_data->tx_end) {
 		cs_active(drv_data, chip);
 
 		write_TDBR(drv_data, (*(u16 *) (drv_data->tx)));
 		while ((read_STAT(drv_data) & BIT_STAT_TXS))
 			cpu_relax();
+		while (!(read_STAT(drv_data) & BIT_STAT_SPIF))
+			cpu_relax();
 
 		cs_deactive(drv_data, chip);
 
_

Patches currently in -mm which might be from sonic.zhang@analog.com are

origin.patch
spi_bfin-wait-for-tx-to-complete-on-write-paths.patch
