From: akpm@linux-foundation.org
Subject: [merged] sdio-put-active-devices-into-1-bit-mode-during-suspend.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:08:21 -0800
Message-ID: <201003091908.o29J8LAn031438__21201.6495330774$1268162547$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59373 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755953Ab0CITWM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:22:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dsd@laptop.org, linux-mmc@vger.kernel.org, nico@marvell.com, mm-commits@vger.kernel.org


The patch titled
     sdio: put active devices into 1-bit mode during suspend
has been removed from the -mm tree.  Its filename was
     sdio-put-active-devices-into-1-bit-mode-during-suspend.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sdio: put active devices into 1-bit mode during suspend
From: Daniel Drake <dsd@laptop.org>

And bring them back to 4-bit mode during resume.

Signed-off-by: Daniel Drake <dsd@laptop.org>
Signed-off-by: Nicolas Pitre <nico@marvell.com>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/core/sdio.c  |   43 +++++++++++++++++++++++++++++++++++++
 include/linux/mmc/sdio.h |    2 +
 2 files changed, 45 insertions(+)

diff -puN drivers/mmc/core/sdio.c~sdio-put-active-devices-into-1-bit-mode-during-suspend drivers/mmc/core/sdio.c
--- a/drivers/mmc/core/sdio.c~sdio-put-active-devices-into-1-bit-mode-during-suspend
+++ a/drivers/mmc/core/sdio.c
@@ -188,6 +188,40 @@ static int sdio_disable_cd(struct mmc_ca
 }
 
 /*
+ * Devices that remain active during a system suspend are
+ * put back into 1-bit mode.
+ */
+static int sdio_disable_wide(struct mmc_card *card)
+{
+	int ret;
+	u8 ctrl;
+
+	if (!(card->host->caps & MMC_CAP_4_BIT_DATA))
+		return 0;
+
+	if (card->cccr.low_speed && !card->cccr.wide_bus)
+		return 0;
+
+	ret = mmc_io_rw_direct(card, 0, 0, SDIO_CCCR_IF, 0, &ctrl);
+	if (ret)
+		return ret;
+
+	if (!(ctrl & SDIO_BUS_WIDTH_4BIT))
+		return 0;
+
+	ctrl &= ~SDIO_BUS_WIDTH_4BIT;
+	ctrl |= SDIO_BUS_ASYNC_INT;
+
+	ret = mmc_io_rw_direct(card, 1, 0, SDIO_CCCR_IF, ctrl, NULL);
+	if (ret)
+		return ret;
+
+	mmc_set_bus_width(card->host, MMC_BUS_WIDTH_1);
+
+	return 0;
+}
+
+/*
  * Test if the card supports high-speed mode and, if so, switch to it.
  */
 static int sdio_enable_hs(struct mmc_card *card)
@@ -427,6 +461,12 @@ static int mmc_sdio_suspend(struct mmc_h
 		}
 	}
 
+	if (!err && host->pm_flags & MMC_PM_KEEP_POWER) {
+		mmc_claim_host(host);
+		sdio_disable_wide(host->card);
+		mmc_release_host(host);
+	}
+
 	return err;
 }
 
@@ -441,6 +481,9 @@ static int mmc_sdio_resume(struct mmc_ho
 	mmc_claim_host(host);
 	err = mmc_sdio_init_card(host, host->ocr, host->card,
 				 (host->pm_flags & MMC_PM_KEEP_POWER));
+	if (!err)
+		/* We may have switched to 1-bit mode during suspend. */
+		err = sdio_enable_wide(host->card);
 	if (!err && host->sdio_irqs)
 		mmc_signal_sdio_irq(host);
 	mmc_release_host(host);
diff -puN include/linux/mmc/sdio.h~sdio-put-active-devices-into-1-bit-mode-during-suspend include/linux/mmc/sdio.h
--- a/include/linux/mmc/sdio.h~sdio-put-active-devices-into-1-bit-mode-during-suspend
+++ a/include/linux/mmc/sdio.h
@@ -95,6 +95,8 @@
 #define  SDIO_BUS_WIDTH_1BIT	0x00
 #define  SDIO_BUS_WIDTH_4BIT	0x02
 
+#define  SDIO_BUS_ASYNC_INT	0x20
+
 #define  SDIO_BUS_CD_DISABLE     0x80	/* disable pull-up on DAT3 (pin 1) */
 
 #define SDIO_CCCR_CAPS		0x08
_

Patches currently in -mm which might be from dsd@laptop.org are


