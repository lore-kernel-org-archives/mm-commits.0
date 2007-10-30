From: akpm@linux-foundation.org
Subject: + spi-spi_bfin-bugfix-for-816-bit-word-sizes.patch added to -mm tree
Date: Tue, 30 Oct 2007 15:50:23 -0700
Message-ID: <200710302250.l9UMoN4T032058@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33264 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754000AbXJ3Wuc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Oct 2007 18:50:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bryan.wu@analog.com, dbrownell@users.sourceforge.net


The patch titled
     spi: spi_bfin: bugfix for 8..16 bit word sizes
has been added to the -mm tree.  Its filename is
     spi-spi_bfin-bugfix-for-816-bit-word-sizes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: spi: spi_bfin: bugfix for 8..16 bit word sizes
From: Bryan Wu <bryan.wu@analog.com>

Fix bug in u16_cs_chg_reader to read data_len-2 bytes data firstly, then read
out the last 2 bytes data

Signed-off-by: Bryan Wu <bryan.wu@analog.com>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_bfin5xx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/spi/spi_bfin5xx.c~spi-spi_bfin-bugfix-for-816-bit-word-sizes drivers/spi/spi_bfin5xx.c
--- a/drivers/spi/spi_bfin5xx.c~spi-spi_bfin-bugfix-for-816-bit-word-sizes
+++ a/drivers/spi/spi_bfin5xx.c
@@ -501,7 +501,7 @@ static void u16_cs_chg_reader(struct dri
 	cs_active(drv_data, chip);
 	dummy_read(drv_data);
 
-	while (drv_data->rx < drv_data->rx_end) {
+	while (drv_data->rx < drv_data->rx_end - 2) {
 		cs_deactive(drv_data, chip);
 
 		if (chip->cs_chg_udelay)
_

Patches currently in -mm which might be from bryan.wu@analog.com are

origin.patch
git-mtd.patch
blackfin-serial-driver-this-driver-enable-sports-on-blackfin-emulate-uart.patch
kernel-printkc-concerns-about-the-console-handover.patch
spi-initial-bf54x-spi-support.patch
spi-bfin-spi-uses-portmux-calls.patch
spi-spi_bfin-cleanups-error-handling.patch
spi-spi_bfin-handles-spi_transfercs_change.patch
spi-spi_bfin-dont-bypass-spi-framework.patch
spi-spi_bfin-uses-platform-device-resources.patch
spi-spi_bfin-uses-portmux-for-additional-busses.patch
spi-spi_bfin-rearrange-portmux-calls.patch
spi-spi_bfin-change-handling-of-communication-parameters.patch
spi-spi_bfin-relocate-spin-waits.patch
spi-spi_bfin-handle-multiple-spi_masters.patch
spi-spi_bfin-bugfix-for-816-bit-word-sizes.patch
spi-spi_bfin-update-handling-of-delay-after-deselect.patch
spi-spi_bfin-resequence-dma-start-stop.patch
