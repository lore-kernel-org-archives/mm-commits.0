From: akpm@linux-foundation.org
Subject: + mmc-implement-sd-combo-iomem-support.patch added to -mm tree
Date: Mon, 07 Jun 2010 13:38:13 -0700
Message-ID: <201006072038.o57KcDMF026956@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48217 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751406Ab0FGUi1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jun 2010 16:38:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mirq-linux@rere.qmqm.pl, adrian.hunter@nokia.com, cjb@laptop.org, linux-mmc@vger.kernel.org


The patch titled
     mmc: implement SD-combo (IO+mem) support
has been added to the -mm tree.  Its filename is
     mmc-implement-sd-combo-iomem-support.patch

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
Subject: mmc: implement SD-combo (IO+mem) support
From: Michal Miroslaw <mirq-linux@rere.qmqm.pl>

Signed-off-by: Michal Miroslaw <mirq-linux@rere.qmqm.pl>
Cc: Adrian Hunter <adrian.hunter@nokia.com>
Cc: Chris Ball <cjb@laptop.org>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/core/bus.c   |    9 ++
 drivers/mmc/core/core.c  |   12 ++-
 drivers/mmc/core/sdio.c  |  135 +++++++++++++++++++++++++++++++------
 include/linux/mmc/card.h |    1 
 4 files changed, 134 insertions(+), 23 deletions(-)

diff -puN drivers/mmc/core/bus.c~mmc-implement-sd-combo-iomem-support drivers/mmc/core/bus.c
--- a/drivers/mmc/core/bus.c~mmc-implement-sd-combo-iomem-support
+++ a/drivers/mmc/core/bus.c
@@ -37,6 +37,8 @@ static ssize_t mmc_type_show(struct devi
 		return sprintf(buf, "SD\n");
 	case MMC_TYPE_SDIO:
 		return sprintf(buf, "SDIO\n");
+	case MMC_TYPE_SD_COMBO:
+		return sprintf(buf, "SDcombo\n");
 	default:
 		return -EFAULT;
 	}
@@ -74,6 +76,9 @@ mmc_bus_uevent(struct device *dev, struc
 	case MMC_TYPE_SDIO:
 		type = "SDIO";
 		break;
+	case MMC_TYPE_SD_COMBO:
+		type = "SDcombo";
+		break;
 	default:
 		type = NULL;
 	}
@@ -239,6 +244,10 @@ int mmc_add_card(struct mmc_card *card)
 	case MMC_TYPE_SDIO:
 		type = "SDIO";
 		break;
+	case MMC_TYPE_SD_COMBO:
+		type = "SD-combo";
+		if (mmc_card_blockaddr(card))
+			type = "SDHC-combo";
 	default:
 		type = "?";
 		break;
diff -puN drivers/mmc/core/core.c~mmc-implement-sd-combo-iomem-support drivers/mmc/core/core.c
--- a/drivers/mmc/core/core.c~mmc-implement-sd-combo-iomem-support
+++ a/drivers/mmc/core/core.c
@@ -1099,8 +1099,15 @@ void mmc_rescan(struct work_struct *work
 	 */
 	err = mmc_send_io_op_cond(host, 0, &ocr);
 	if (!err) {
-		if (mmc_attach_sdio(host, ocr))
-			mmc_power_off(host);
+		if (mmc_attach_sdio(host, ocr)) {
+			mmc_claim_host(host);
+			/* try SDMEM (but not MMC) even if SDIO is broken */
+			if (mmc_send_app_op_cond(host, 0, &ocr))
+				goto out_fail;
+
+			if (mmc_attach_sd(host, ocr))
+				mmc_power_off(host);
+		}
 		goto out;
 	}
 
@@ -1124,6 +1131,7 @@ void mmc_rescan(struct work_struct *work
 		goto out;
 	}
 
+out_fail:
 	mmc_release_host(host);
 	mmc_power_off(host);
 
diff -puN drivers/mmc/core/sdio.c~mmc-implement-sd-combo-iomem-support drivers/mmc/core/sdio.c
--- a/drivers/mmc/core/sdio.c~mmc-implement-sd-combo-iomem-support
+++ a/drivers/mmc/core/sdio.c
@@ -160,9 +160,7 @@ static int sdio_enable_wide(struct mmc_c
 	if (ret)
 		return ret;
 
-	mmc_set_bus_width(card->host, MMC_BUS_WIDTH_4);
-
-	return 0;
+	return 1;
 }
 
 /*
@@ -222,10 +220,34 @@ static int sdio_disable_wide(struct mmc_
 	return 0;
 }
 
+
+static int sdio_enable_4bit_bus(struct mmc_card *card)
+{
+	int err;
+
+	if (card->type == MMC_TYPE_SDIO)
+		return sdio_enable_wide(card);
+
+	if ((card->host->caps & MMC_CAP_4_BIT_DATA) &&
+		(card->scr.bus_widths & SD_SCR_BUS_WIDTH_4)) {
+		err = mmc_app_set_bus_width(card, MMC_BUS_WIDTH_4);
+		if (err)
+			return err;
+	} else
+		return 0;
+
+	err = sdio_enable_wide(card);
+	if (err <= 0)
+		mmc_app_set_bus_width(card, MMC_BUS_WIDTH_1);
+
+	return err;
+}
+
+
 /*
  * Test if the card supports high-speed mode and, if so, switch to it.
  */
-static int sdio_enable_hs(struct mmc_card *card)
+static int mmc_sdio_switch_hs(struct mmc_card *card, int enable)
 {
 	int ret;
 	u8 speed;
@@ -240,7 +262,10 @@ static int sdio_enable_hs(struct mmc_car
 	if (ret)
 		return ret;
 
-	speed |= SDIO_SPEED_EHS;
+	if (enable)
+		speed |= SDIO_SPEED_EHS;
+	else
+		speed &= ~SDIO_SPEED_EHS;
 
 	ret = mmc_io_rw_direct(card, 1, 0, SDIO_CCCR_SPEED, speed, NULL);
 	if (ret)
@@ -249,6 +274,24 @@ static int sdio_enable_hs(struct mmc_car
 	return 1;
 }
 
+/*
+ * Enable SDIO/combo card's high-speed mode. Return 0/1 if [not]supported.
+ */
+static int sdio_enable_hs(struct mmc_card *card)
+{
+	int ret;
+
+	ret = mmc_sdio_switch_hs(card, true);
+	if (ret <= 0 || card->type == MMC_TYPE_SDIO)
+		return ret;
+
+	ret = mmc_sd_switch_hs(card);
+	if (ret <= 0)
+		mmc_sdio_switch_hs(card, false);
+
+	return ret;
+}
+
 static unsigned mmc_sdio_get_max_clock(struct mmc_card *card)
 {
 	unsigned max_dtr;
@@ -265,6 +308,9 @@ static unsigned mmc_sdio_get_max_clock(s
 		max_dtr = card->cis.max_dtr;
 	}
 
+	if (card->type == MMC_TYPE_SD_COMBO)
+		max_dtr = min(max_dtr, mmc_sd_get_max_clock(card));
+
 	return max_dtr;
 }
 
@@ -310,7 +356,24 @@ static int mmc_sdio_init_card(struct mmc
 		goto err;
 	}
 
-	card->type = MMC_TYPE_SDIO;
+	err = mmc_sd_get_cid(host, host->ocr & ocr, card->raw_cid);
+
+	if (!err) {
+		card->type = MMC_TYPE_SD_COMBO;
+
+		if (oldcard && (oldcard->type != MMC_TYPE_SD_COMBO ||
+		    memcmp(card->raw_cid, oldcard->raw_cid, sizeof(card->raw_cid)) != 0)) {
+			mmc_remove_card(card);
+			return -ENOENT;
+		}
+	} else {
+		card->type = MMC_TYPE_SDIO;
+
+		if (oldcard && oldcard->type != MMC_TYPE_SDIO) {
+			mmc_remove_card(card);
+			return -ENOENT;
+		}
+	}
 
 	/*
 	 * Call the optional HC's init_card function to handle quirks.
@@ -330,6 +393,17 @@ static int mmc_sdio_init_card(struct mmc
 	}
 
 	/*
+	 * Read CSD, before selecting the card
+	 */
+	if (!oldcard && card->type == MMC_TYPE_SD_COMBO) {
+		err = mmc_sd_get_csd(host, card);
+		if (err)
+			return err;
+
+		mmc_decode_cid(card);
+	}
+
+	/*
 	 * Select card, as all following commands rely on that.
 	 */
 	if (!powered_resume && !mmc_host_is_spi(host)) {
@@ -356,14 +430,33 @@ static int mmc_sdio_init_card(struct mmc
 		int same = (card->cis.vendor == oldcard->cis.vendor &&
 			    card->cis.device == oldcard->cis.device);
 		mmc_remove_card(card);
-		if (!same) {
-			err = -ENOENT;
-			goto err;
-		}
+		if (!same)
+			return -ENOENT;
+
 		card = oldcard;
 		return 0;
 	}
 
+	if (card->type == MMC_TYPE_SD_COMBO) {
+		err = mmc_sd_setup_card(host, card, oldcard != NULL);
+		/* handle as SDIO-only card if memory init failed */
+		if (err) {
+			mmc_go_idle(host);
+			if (mmc_host_is_spi(host))
+				/* should not fail, as it worked previously */
+				mmc_spi_set_crc(host, use_spi_crc);
+			card->type = MMC_TYPE_SDIO;
+		} else
+			card->dev.type = &sd_type;
+	}
+
+	/*
+	 * If needed, disconnect card detection pull-up resistor.
+	 */
+	err = sdio_disable_cd(card);
+	if (err)
+		goto remove;
+
 	/*
 	 * Switch to high-speed (if supported).
 	 */
@@ -381,8 +474,10 @@ static int mmc_sdio_init_card(struct mmc
 	/*
 	 * Switch to wider bus (if supported).
 	 */
-	err = sdio_enable_wide(card);
-	if (err)
+	err = sdio_enable_4bit_bus(card);
+	if (err > 0)
+		mmc_set_bus_width(card->host, MMC_BUS_WIDTH_4);
+	else if (err)
 		goto remove;
 
 	if (!oldcard)
@@ -496,9 +591,14 @@ static int mmc_sdio_resume(struct mmc_ho
 	mmc_claim_host(host);
 	err = mmc_sdio_init_card(host, host->ocr, host->card,
 				 (host->pm_flags & MMC_PM_KEEP_POWER));
-	if (!err)
+	if (!err) {
 		/* We may have switched to 1-bit mode during suspend. */
-		err = sdio_enable_wide(host->card);
+		err = sdio_enable_4bit_bus(host->card);
+		if (err > 0) {
+			mmc_set_bus_width(host, MMC_BUS_WIDTH_4);
+			err = 0;
+		}
+	}
 	if (!err && host->sdio_irqs)
 		mmc_signal_sdio_irq(host);
 	mmc_release_host(host);
@@ -583,13 +683,6 @@ int mmc_attach_sdio(struct mmc_host *hos
 	card->sdio_funcs = 0;
 
 	/*
-	 * If needed, disconnect card detection pull-up resistor.
-	 */
-	err = sdio_disable_cd(card);
-	if (err)
-		goto remove;
