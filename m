From: akpm@linux-foundation.org
Subject: + blackfin-spi-driver-fix-bug-spi-controller-driver-does-not-assert-deassert-cs-correctly.patch added to -mm tree
Date: Mon, 09 Feb 2009 14:15:19 -0800
Message-ID: <200902092215.n19MFJki009150@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60385 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752969AbZBIWQC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Feb 2009 17:16:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yi.li@analog.com, cooloney@kernel.org, david-b@pacbell.net, dbrownell@users.sourceforge.net


The patch titled
     Blackfin SPI Driver: fix bug - spi controller driver does not assert/deassert CS correctly
has been added to the -mm tree.  Its filename is
     blackfin-spi-driver-fix-bug-spi-controller-driver-does-not-assert-deassert-cs-correctly.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Blackfin SPI Driver: fix bug - spi controller driver does not assert/deassert CS correctly
From: Yi Li <yi.li@analog.com>

This bug can be observed when two SPI devices are sharing the spi bus: One
device is set as SPI CS 7, another one is using SPI CS 4.

In spi_bfin5xx.c: cs_active(), cs_deactive() are used to control SPI_FLG
register.  From the debug bellow:

cs_active: flag: 0x7f91, chip->flag: 0x7f80, cs: 7
cs_active: flag: 0xef91, chip->flag: 0xef10, cs: 4

When device A (cs_7) activate CS 7, SPI_FLG is set as 0x7f91 (however,
SPI_FLG should be set as 0x7f80, or 0x6f91 if in broadcast mode).

Due to some HW bug (very possibly), if SPI_FLG is set as 0x7f91, SPISSEL7
is asserted, however SPISSEL4 will be asserted too (I can see this using
the scope).  This is unreasonable according to HRM.

Signed-off-by: Yi Li <yi.li@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Acked-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_bfin5xx.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN drivers/spi/spi_bfin5xx.c~blackfin-spi-driver-fix-bug-spi-controller-driver-does-not-assert-deassert-cs-correctly drivers/spi/spi_bfin5xx.c
--- a/drivers/spi/spi_bfin5xx.c~blackfin-spi-driver-fix-bug-spi-controller-driver-does-not-assert-deassert-cs-correctly
+++ a/drivers/spi/spi_bfin5xx.c
@@ -189,6 +189,7 @@ static void cs_deactive(struct driver_da
 {
 	u16 flag = read_FLAG(drv_data);
 
+	flag &= ~chip->flag;
 	flag |= (chip->flag << 8);
 
 	write_FLAG(drv_data, flag);
@@ -1036,7 +1037,6 @@ static int setup(struct spi_device *spi)
 	struct bfin5xx_spi_chip *chip_info = NULL;
 	struct chip_data *chip;
 	struct driver_data *drv_data = spi_master_get_devdata(spi->master);
-	u8 spi_flg;
 
 	/* Abort device setup if requested features are not supported */
 	if (spi->mode & ~(SPI_CPOL | SPI_CPHA | SPI_LSB_FIRST)) {
@@ -1119,8 +1119,7 @@ static int setup(struct spi_device *spi)
 	 * SPI_BAUD, not the real baudrate
 	 */
 	chip->baud = hz_to_spi_baud(spi->max_speed_hz);
-	spi_flg = ~(1 << (spi->chip_select));
-	chip->flag = ((u16) spi_flg << 8) | (1 << (spi->chip_select));
+	chip->flag = 1 << (spi->chip_select);
 	chip->chip_select_num = spi->chip_select;
 
 	switch (chip->bits_per_word) {
_

Patches currently in -mm which might be from yi.li@analog.com are

blackfin-spi-driver-fix-bug-spi-controller-driver-does-not-assert-deassert-cs-correctly.patch
blackfin-spi-driver-fix-bug-correct-usage-of-struct-spi_transfercs_change.patch
blackfin-spi-driver-make-mmc_spi-driver-work-on-blackfin.patch

