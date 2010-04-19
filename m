From: akpm@linux-foundation.org
Subject: + mmc-atmel-mci-enable-sd-high-speed-support.patch added to -mm tree
Date: Mon, 19 Apr 2010 16:33:30 -0700
Message-ID: <201004192333.o3JNXU4c016233@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43432 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753140Ab0DSXdh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 Apr 2010 19:33:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nicolas.ferre@atmel.com, haavard.skinnemoen@atmel.com, linux-mmc@vger.kernel.org, maciej.sosnowski@intel.com


The patch titled
     mmc: atmel-mci: enable SD high speed support
has been added to the -mm tree.  Its filename is
     mmc-atmel-mci-enable-sd-high-speed-support.patch

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
Subject: mmc: atmel-mci: enable SD high speed support
From: Nicolas Ferre <nicolas.ferre@atmel.com>

Enable high speed support for atmel-mci driver.  This support is dependent
of the revision of the IP and, of course, the capacity of the SD card
used.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Reviewed-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Cc: Maciej Sosnowski <maciej.sosnowski@intel.com>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/atmel-mci.c |   22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff -puN drivers/mmc/host/atmel-mci.c~mmc-atmel-mci-enable-sd-high-speed-support drivers/mmc/host/atmel-mci.c
--- a/drivers/mmc/host/atmel-mci.c~mmc-atmel-mci-enable-sd-high-speed-support
+++ a/drivers/mmc/host/atmel-mci.c
@@ -951,10 +951,21 @@ static void atmci_set_ios(struct mmc_hos
 		if (mci_has_rwproof())
 			host->mode_reg |= (MCI_MR_WRPROOF | MCI_MR_RDPROOF);
 
-		if (list_empty(&host->queue))
+		if (atmci_is_mci2()) {
+			/* setup High Speed mode in relation with card capacity */
+			if (ios->timing == MMC_TIMING_SD_HS)
+				host->cfg_reg |= MCI_CFG_HSMODE;
+			else
+				host->cfg_reg &= ~MCI_CFG_HSMODE;
+		}
+
+		if (list_empty(&host->queue)) {
 			mci_writel(host, MR, host->mode_reg);
-		else
+			if (atmci_is_mci2())
+				mci_writel(host, CFG, host->cfg_reg);
+		} else {
 			host->need_clock_update = true;
+		}
 
 		spin_unlock_bh(&host->lock);
 	} else {
@@ -1051,8 +1062,11 @@ static void atmci_request_end(struct atm
 	 * necessary if set_ios() is called when a different slot is
 	 * busy transfering data.
 	 */
-	if (host->need_clock_update)
+	if (host->need_clock_update) {
 		mci_writel(host, MR, host->mode_reg);
+		if (atmci_is_mci2())
+			mci_writel(host, CFG, host->cfg_reg);
+	}
 
 	host->cur_slot->mrq = NULL;
 	host->mrq = NULL;
@@ -1563,6 +1577,8 @@ static int __init atmci_init_slot(struct
 	mmc->f_min = DIV_ROUND_UP(host->bus_hz, 512);
 	mmc->f_max = host->bus_hz / 2;
 	mmc->ocr_avail	= MMC_VDD_32_33 | MMC_VDD_33_34;
+	if (atmci_is_mci2())
+		mmc->caps |= MMC_CAP_SD_HIGHSPEED;
 	if (slot_data->bus_width >= 4)
 		mmc->caps |= MMC_CAP_4_BIT_DATA;
 
_

Patches currently in -mm which might be from nicolas.ferre@atmel.com are

linux-next.patch
mmc-atmel-mci-enable-sd-high-speed-support.patch

