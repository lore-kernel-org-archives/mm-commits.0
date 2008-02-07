From: akpm@linux-foundation.org
Subject: - spi_bfin-wait-for-tx-to-complete-on-some-cs_chg-paths.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:26:03 -0800
Message-ID: <200802070025.m170PiXt006744@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59729 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933933AbYBGAo6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:44:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bryan.wu@analog.com, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     spi_bfin: wait for tx to complete on some cs_chg paths
has been removed from the -mm tree.  Its filename was
     spi_bfin-wait-for-tx-to-complete-on-some-cs_chg-paths.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: spi_bfin: wait for tx to complete on some cs_chg paths
From: Bryan Wu <bryan.wu@analog.com>

PBX 2 SPI devices need the nonstandard "cs change per word" mechanism.

This patch is one of three updating this driver to make the last data bits get
sent before advancing the transfer ...  in this case, before the chipselect
gets deactivated.

Signed-off-by: Bryan Wu <bryan.wu@analog.com>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_bfin5xx.c |   40 ++++++++++--------------------------
 1 file changed, 12 insertions(+), 28 deletions(-)

diff -puN drivers/spi/spi_bfin5xx.c~spi_bfin-wait-for-tx-to-complete-on-some-cs_chg-paths drivers/spi/spi_bfin5xx.c
--- a/drivers/spi/spi_bfin5xx.c~spi_bfin-wait-for-tx-to-complete-on-some-cs_chg-paths
+++ a/drivers/spi/spi_bfin5xx.c
@@ -294,16 +294,14 @@ static void u8_cs_chg_writer(struct driv
 {
 	struct chip_data *chip = drv_data->cur_chip;
 
-	/* poll for SPI completion before start */
-	while (!(read_STAT(drv_data) & BIT_STAT_SPIF))
-		cpu_relax();
-
 	while (drv_data->tx < drv_data->tx_end) {
 		cs_active(drv_data, chip);
 
 		write_TDBR(drv_data, (*(u8 *) (drv_data->tx)));
 		while (read_STAT(drv_data) & BIT_STAT_TXS)
 			cpu_relax();
+		while (!(read_STAT(drv_data) & BIT_STAT_SPIF))
+			cpu_relax();
 
 		cs_deactive(drv_data, chip);
 
@@ -342,31 +340,20 @@ static void u8_cs_chg_reader(struct driv
 {
 	struct chip_data *chip = drv_data->cur_chip;
 
-	/* poll for SPI completion before start */
-	while (!(read_STAT(drv_data) & BIT_STAT_SPIF))
-		cpu_relax();
-
-	/* clear TDBR buffer before read(else it will be shifted out) */
-	write_TDBR(drv_data, 0xFFFF);
+	while (drv_data->rx < drv_data->rx_end) {
+		cs_active(drv_data, chip);
+		read_RDBR(drv_data);	/* kick off */
 
-	cs_active(drv_data, chip);
-	dummy_read(drv_data);
+		while (!(read_STAT(drv_data) & BIT_STAT_RXS))
+			cpu_relax();
+		while (!(read_STAT(drv_data) & BIT_STAT_SPIF))
+			cpu_relax();
 
-	while (drv_data->rx < drv_data->rx_end - 1) {
+		*(u8 *) (drv_data->rx) = read_SHAW(drv_data);
 		cs_deactive(drv_data, chip);
 
-		while (!(read_STAT(drv_data) & BIT_STAT_RXS))
-			cpu_relax();
-		cs_active(drv_data, chip);
-		*(u8 *) (drv_data->rx) = read_RDBR(drv_data);
 		++drv_data->rx;
 	}
-	cs_deactive(drv_data, chip);
-
-	while (!(read_STAT(drv_data) & BIT_STAT_RXS))
-		cpu_relax();
-	*(u8 *) (drv_data->rx) = read_SHAW(drv_data);
-	++drv_data->rx;
 }
 
 static void u8_duplex(struct driver_data *drv_data)
@@ -392,15 +379,12 @@ static void u8_cs_chg_duplex(struct driv
 {
 	struct chip_data *chip = drv_data->cur_chip;
 
-	/* poll for SPI completion before start */
-	while (!(read_STAT(drv_data) & BIT_STAT_SPIF))
-		cpu_relax();
-
 	while (drv_data->rx < drv_data->rx_end) {
 		cs_active(drv_data, chip);
 
 		write_TDBR(drv_data, (*(u8 *) (drv_data->tx)));
-		while (read_STAT(drv_data) & BIT_STAT_TXS)
+
+		while (!(read_STAT(drv_data) & BIT_STAT_SPIF))
 			cpu_relax();
 		while (!(read_STAT(drv_data) & BIT_STAT_RXS))
 			cpu_relax();
_

Patches currently in -mm which might be from bryan.wu@analog.com are

origin.patch
git-mtd.patch
blackfin-serial-driver-this-driver-enable-sports-on-blackfin-emulate-uart.patch
git-watchdog.patch
sanitize-the-type-of-struct-useru_ar0.patch
add-cmpxchg_local-to-blackfin-replace-__cmpxchg-by-generic-cmpxchg.patch
d_path-make-d_path-use-a-struct-path.patch
d_path-make-d_path-use-a-struct-path-fix.patch
procfs-constify-function-pointer-tables.patch
