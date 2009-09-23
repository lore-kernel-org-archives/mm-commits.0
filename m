From: akpm@linux-foundation.org
Subject: [merged] mmc-core-sdio-suspend-resume-support.patch removed from -mm tree
Date: Wed, 23 Sep 2009 12:56:18 -0700
Message-ID: <200909231956.n8NJuIdR004613__13452.1440756091$1253735837$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54675 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752491AbZIWT4r (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 15:56:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nico@fluxnic.net, linux-mmc@vger.kernel.org, nico@marvell.com, mm-commits@vger.kernel.org


The patch titled
     mmc: core SDIO suspend/resume support
has been removed from the -mm tree.  Its filename was
     mmc-core-sdio-suspend-resume-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mmc: core SDIO suspend/resume support
From: Nicolas Pitre <nico@fluxnic.net>

Currently, all SDIO cards are virtually removed upon a suspend, and
completely reprobed upon a resume.  This adds the suspend and resume
methods to the SDIO bus driver so to be able to dispatch those events to
the actual SDIO function drivers for real suspend/resume instead.

All active functions on a card must have a driver with both a suspend and
a resume method though.  Failing that, we fall back to the current
behavior of simply "removing" the card when suspending.

When resuming, we make sure the same card is still inserted by comparing
the vendor and product IDs.  If there is a mismatch, or if there is simply
no card anymore in the slot, then the previous card is "removed" and the
new card is detected.  This is further enhanced with the next patch.

[akpm@linux-foundation.org: fix warnings]
Signed-off-by: Nicolas Pitre <nico@marvell.com>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/core/sdio.c |  285 ++++++++++++++++++++++++++------------
 1 file changed, 196 insertions(+), 89 deletions(-)

diff -puN drivers/mmc/core/sdio.c~mmc-core-sdio-suspend-resume-support drivers/mmc/core/sdio.c
--- a/drivers/mmc/core/sdio.c~mmc-core-sdio-suspend-resume-support
+++ a/drivers/mmc/core/sdio.c
@@ -218,6 +218,134 @@ static int sdio_enable_hs(struct mmc_car
 }
 
 /*
+ * Handle the detection and initialisation of a card.
+ *
+ * In the case of a resume, "oldcard" will contain the card
+ * we're trying to reinitialise.
+ */
+static int mmc_sdio_init_card(struct mmc_host *host, u32 ocr,
+			      struct mmc_card *oldcard)
+{
+	struct mmc_card *card;
+	int err;
+
+	BUG_ON(!host);
+	WARN_ON(!host->claimed);
+
+	/*
+	 * Inform the card of the voltage
+	 */
+	err = mmc_send_io_op_cond(host, host->ocr, &ocr);
+	if (err)
+		goto err;
+
+	/*
+	 * For SPI, enable CRC as appropriate.
+	 */
+	if (mmc_host_is_spi(host)) {
+		err = mmc_spi_set_crc(host, use_spi_crc);
+		if (err)
+			goto err;
+	}
+
+	/*
+	 * Allocate card structure.
+	 */
+	card = mmc_alloc_card(host, NULL);
+	if (IS_ERR(card)) {
+		err = PTR_ERR(card);
+		goto err;
+	}
+
+	card->type = MMC_TYPE_SDIO;
+
+	/*
+	 * For native busses:  set card RCA and quit open drain mode.
+	 */
+	if (!mmc_host_is_spi(host)) {
+		err = mmc_send_relative_addr(host, &card->rca);
+		if (err)
+			goto remove;
+
+		mmc_set_bus_mode(host, MMC_BUSMODE_PUSHPULL);
+	}
+
+	/*
+	 * Select card, as all following commands rely on that.
+	 */
+	if (!mmc_host_is_spi(host)) {
+		err = mmc_select_card(card);
+		if (err)
+			goto remove;
+	}
+
+	/*
+	 * Read the common registers.
+	 */
+	err = sdio_read_cccr(card);
+	if (err)
+		goto remove;
+
+	/*
+	 * Read the common CIS tuples.
+	 */
+	err = sdio_read_common_cis(card);
+	if (err)
+		goto remove;
+
+	if (oldcard) {
+		int same = (card->cis.vendor == oldcard->cis.vendor &&
+			    card->cis.device == oldcard->cis.device);
+		mmc_remove_card(card);
+		if (!same) {
+			err = -ENOENT;
+			goto err;
+		}
+		card = oldcard;
+	}
+
+	/*
+	 * Switch to high-speed (if supported).
+	 */
+	err = sdio_enable_hs(card);
+	if (err)
+		goto remove;
+
+	/*
+	 * Change to the card's maximum speed.
+	 */
+	if (mmc_card_highspeed(card)) {
+		/*
+		 * The SDIO specification doesn't mention how
+		 * the CIS transfer speed register relates to
+		 * high-speed, but it seems that 50 MHz is
+		 * mandatory.
+		 */
+		mmc_set_clock(host, 50000000);
+	} else {
+		mmc_set_clock(host, card->cis.max_dtr);
+	}
+
+	/*
+	 * Switch to wider bus (if supported).
+	 */
+	err = sdio_enable_wide(card);
+	if (err)
+		goto remove;
+
+	if (!oldcard)
+		host->card = card;
+	return 0;
+
+remove:
+	if (!oldcard)
+		mmc_remove_card(card);
+
+err:
+	return err;
+}
+
+/*
  * Host is being removed. Free up the current card.
  */
 static void mmc_sdio_remove(struct mmc_host *host)
@@ -266,10 +394,74 @@ static void mmc_sdio_detect(struct mmc_h
 	}
 }
 
+/*
+ * SDIO suspend.  We need to suspend all functions separately.
+ * Therefore all registered functions must have drivers with suspend
+ * and resume methods.  Failing that we simply remove the whole card.
+ */
+static void mmc_sdio_suspend(struct mmc_host *host)
+{
+	int i;
+
+	/* make sure all registered functions can suspend/resume */
+	for (i = 0; i < host->card->sdio_funcs; i++) {
+		struct sdio_func *func = host->card->sdio_func[i];
+		if (func && sdio_func_present(func) && func->dev.driver) {
+			const struct dev_pm_ops *pmops = func->dev.driver->pm;
+			if (!pmops || !pmops->suspend || !pmops->resume) {
+				/* just remove the entire card in that case */
+				mmc_sdio_remove(host);
+				mmc_claim_host(host);
+				mmc_detach_bus(host);
+				mmc_release_host(host);
+				return;
+			}
+		}
+	}
+
+	/* now suspend them */
+	for (i = 0; i < host->card->sdio_funcs; i++) {
+		struct sdio_func *func = host->card->sdio_func[i];
+		if (func && sdio_func_present(func) && func->dev.driver) {
+			const struct dev_pm_ops *pmops = func->dev.driver->pm;
+			pmops->suspend(&func->dev);
+		}
+	}
+}
+
+static void mmc_sdio_resume(struct mmc_host *host)
+{
+	int i, err;
+
+	BUG_ON(!host);
+	BUG_ON(!host->card);
+
+	mmc_claim_host(host);
+	err = mmc_sdio_init_card(host, host->ocr, host->card);
+	mmc_release_host(host);
+	if (err) {
+		mmc_sdio_remove(host);
+		mmc_claim_host(host);
+		mmc_detach_bus(host);
+		mmc_release_host(host);
+		return;
+	}
+
+	/* resume all functions */
+	for (i = 0; i < host->card->sdio_funcs; i++) {
+		struct sdio_func *func = host->card->sdio_func[i];
+		if (func && sdio_func_present(func) && func->dev.driver) {
+			const struct dev_pm_ops *pmops = func->dev.driver->pm;
+			pmops->resume(&func->dev);
+		}
+	}
+}
 
 static const struct mmc_bus_ops mmc_sdio_ops = {
 	.remove = mmc_sdio_remove,
 	.detect = mmc_sdio_detect,
+	.suspend = mmc_sdio_suspend,
+	.resume = mmc_sdio_resume,
 };
 
 
@@ -309,103 +501,18 @@ int mmc_attach_sdio(struct mmc_host *hos
 	}
 
 	/*
-	 * Inform the card of the voltage
+	 * Detect and init the card.
 	 */
-	err = mmc_send_io_op_cond(host, host->ocr, &ocr);
+	err = mmc_sdio_init_card(host, host->ocr, NULL);
 	if (err)
 		goto err;
-
-	/*
-	 * For SPI, enable CRC as appropriate.
-	 */
-	if (mmc_host_is_spi(host)) {
-		err = mmc_spi_set_crc(host, use_spi_crc);
-		if (err)
-			goto err;
-	}
+	card = host->card;
 
 	/*
 	 * The number of functions on the card is encoded inside
 	 * the ocr.
 	 */
-	funcs = (ocr & 0x70000000) >> 28;
-
-	/*
-	 * Allocate card structure.
-	 */
-	card = mmc_alloc_card(host, NULL);
-	if (IS_ERR(card)) {
-		err = PTR_ERR(card);
-		goto err;
-	}
-
-	card->type = MMC_TYPE_SDIO;
-	card->sdio_funcs = funcs;
-
-	host->card = card;
-
-	/*
-	 * For native busses:  set card RCA and quit open drain mode.
-	 */
-	if (!mmc_host_is_spi(host)) {
-		err = mmc_send_relative_addr(host, &card->rca);
-		if (err)
-			goto remove;
-
-		mmc_set_bus_mode(host, MMC_BUSMODE_PUSHPULL);
-	}
-
-	/*
-	 * Select card, as all following commands rely on that.
-	 */
-	if (!mmc_host_is_spi(host)) {
-		err = mmc_select_card(card);
-		if (err)
-			goto remove;
-	}
-
-	/*
-	 * Read the common registers.
-	 */
-	err = sdio_read_cccr(card);
-	if (err)
-		goto remove;
-
-	/*
-	 * Read the common CIS tuples.
-	 */
-	err = sdio_read_common_cis(card);
-	if (err)
-		goto remove;
-
-	/*
-	 * Switch to high-speed (if supported).
-	 */
-	err = sdio_enable_hs(card);
-	if (err)
-		goto remove;
-
-	/*
-	 * Change to the card's maximum speed.
-	 */
-	if (mmc_card_highspeed(card)) {
-		/*
-		 * The SDIO specification doesn't mention how
-		 * the CIS transfer speed register relates to
-		 * high-speed, but it seems that 50 MHz is
-		 * mandatory.
-		 */
-		mmc_set_clock(host, 50000000);
-	} else {
-		mmc_set_clock(host, card->cis.max_dtr);
-	}
