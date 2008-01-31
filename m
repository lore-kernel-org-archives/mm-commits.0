From: akpm@linux-foundation.org
Subject: + spi_bfin-wait-for-tx-to-complete-on-some-cs_chg-paths.patch added to -mm tree
Date: Thu, 31 Jan 2008 13:26:59 -0800
Message-ID: <200801312127.m0VLR0qf012147@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36072 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756882AbYAaV1O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 31 Jan 2008 16:27:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bryan.wu@analog.com, dbrownell@users.sourceforge.net


The patch titled
     spi_bfin: wait for tx to complete on some cs_chg paths
has been added to the -mm tree.  Its filename is
     spi_bfin-wait-for-tx-to-complete-on-some-cs_chg-paths.patch

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
kernel-printkc-concerns-about-the-console-handover.patch
remove-mm_ptovvtop.patch
spi_bfin-remove-useless-fault-path.patch
spi_bfin-use-more-useful-gpio-labels.patch
spi_bfin-wait-for-tx-to-complete-on-some-cs_chg-paths.patch
spi_bfin-wait-for-tx-to-complete-on-full-duplex-paths.patch
spi_bfin-wait-for-tx-to-complete-on-write-paths.patch
spi_bfin-headers-are-not-for-changelogs.patch
blackfin-rtc-driver-the-frequency-function-is-in-units-of-hz-not-units-of-seconds-so-lock-our-driver-down-to-1-hz.patch
blackfin-rtc-driver-we-pass-in-a-struct-device-to-the-irq-handler-not-a-struct-platform_device-so-fix-the-irq-handler.patch
blackfin-rtc-driver-cleanup-proc-handler-we-dont-need-rtc-reg-dump-now-that-we-have-mmr-filesystem-in-sysfs.patch
blackfin-rtc-driver-use-dev_dbg-rather-than-pr_stamp.patch
blackfin-rtc-driver-read_alarm-checks-the-enabled-field-not-the-pending-field.patch
blackfin-rtc-driver-shave-off-another-memcpy-by-using-assignment.patch
blackfin-rtc-driver-convert-sync-wait-to-use-the-irq-write-complete-notice.patch
sanitize-the-type-of-struct-useru_ar0.patch
add-cmpxchg_local-to-blackfin-replace-__cmpxchg-by-generic-cmpxchg.patch
d_path-make-d_path-use-a-struct-path.patch
procfs-constify-function-pointer-tables.patch
