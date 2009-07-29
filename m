From: akpm@linux-foundation.org
Subject: + mmc-add-host-capabilities-for-sd-only-and-mmc-only.patch added to -mm tree
Date: Wed, 29 Jul 2009 13:58:04 -0700
Message-ID: <200907292058.n6TKw4jM008649@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59611 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751833AbZG2U6o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 29 Jul 2009 16:58:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: matt@console-pimps.org, ext-denis.2.karpov@nokia.com, ian@mnementh.co.uk, jarkko.lavinen@nokia.com, philipl@overt.org, pierre@ossman.eu, roberto.foglietta@gmail.com


The patch titled
     mmc: add host capabilities for SD only and MMC only
has been added to the -mm tree.  Its filename is
     mmc-add-host-capabilities-for-sd-only-and-mmc-only.patch

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
Subject: mmc: add host capabilities for SD only and MMC only
From: Matt Fleming <matt@console-pimps.org>

Some hosts can accept only certain types of cards.  For example, an eMMC
is MMC only and a uSD slot may be SD only.  However the MMC card scanning
logic checks for all card types one by one.

Add host capabilities to specify which card types can be used, and amend
the card scanning logic to skip scanning for those types which cannot be
used.

Signed-off-by: Matt Fleming <matt@console-pimps.org>
Acked-by: Matt Fleming <matt@console-pimps.org>
Cc: Ian Molton <ian@mnementh.co.uk>
Cc: "Roberto A. Foglietta" <roberto.foglietta@gmail.com>
Cc: Jarkko Lavinen <jarkko.lavinen@nokia.com>
Cc: Denis Karpov <ext-denis.2.karpov@nokia.com>
Cc: Pierre Ossman <pierre@ossman.eu>
Cc: Philip Langdale <philipl@overt.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/core/core.c       |   16 +++++++++++++++-
 drivers/mmc/host/at91_mci.c   |    2 +-
 drivers/mmc/host/atmel-mci.c  |    1 +
 drivers/mmc/host/au1xmmc.c    |    3 ++-
 drivers/mmc/host/cb710-mmc.c  |    3 ++-
 drivers/mmc/host/imxmmc.c     |    3 ++-
 drivers/mmc/host/mmc_spi.c    |    2 +-
 drivers/mmc/host/mmci.c       |    2 ++
 drivers/mmc/host/mvsdio.c     |    3 ++-
 drivers/mmc/host/mxcmmc.c     |    3 ++-
 drivers/mmc/host/omap.c       |    2 +-
 drivers/mmc/host/omap_hsmmc.c |    2 ++
 drivers/mmc/host/pxamci.c     |    2 +-
 drivers/mmc/host/s3cmci.c     |    3 ++-
 drivers/mmc/host/sdhci.c      |    2 +-
 drivers/mmc/host/sdricoh_cs.c |    3 ++-
 drivers/mmc/host/tifm_sd.c    |    3 ++-
 drivers/mmc/host/tmio_mmc.c   |    3 ++-
 drivers/mmc/host/via-sdmmc.c  |    3 ++-
 drivers/mmc/host/wbsd.c       |    3 ++-
 include/linux/mmc/host.h      |    3 +++
 21 files changed, 50 insertions(+), 17 deletions(-)

diff -puN drivers/mmc/core/core.c~mmc-add-host-capabilities-for-sd-only-and-mmc-only drivers/mmc/core/core.c
--- a/drivers/mmc/core/core.c~mmc-add-host-capabilities-for-sd-only-and-mmc-only
+++ a/drivers/mmc/core/core.c
@@ -1075,7 +1075,11 @@ void mmc_rescan(struct work_struct *work
 	mmc_power_up(host);
 	mmc_go_idle(host);
 
-	mmc_send_if_cond(host, host->ocr_avail);
+	if ((host->caps & MMC_CAP_SDIO) || (host->caps & MMC_CAP_SD))
+		mmc_send_if_cond(host, host->ocr_avail);
+
+	if (!(host->caps & MMC_CAP_SDIO))
+		goto not_sdio;
 
 	/*
 	 * First we search for SDIO...
@@ -1087,6 +1091,10 @@ void mmc_rescan(struct work_struct *work
 		goto out;
 	}
 
+not_sdio:
+	if (!(host->caps & MMC_CAP_SD))
+		goto not_sd;
+
 	/*
 	 * ...then normal SD...
 	 */
@@ -1097,6 +1105,10 @@ void mmc_rescan(struct work_struct *work
 		goto out;
 	}
 
+not_sd:
+	if (!(host->caps & MMC_CAP_MMC))
+		goto not_mmc;
+
 	/*
 	 * ...and finally MMC.
 	 */
@@ -1107,6 +1119,8 @@ void mmc_rescan(struct work_struct *work
 		goto out;
 	}
 
+not_mmc:
+
 	mmc_release_host(host);
 	mmc_power_off(host);
 
diff -puN drivers/mmc/host/at91_mci.c~mmc-add-host-capabilities-for-sd-only-and-mmc-only drivers/mmc/host/at91_mci.c
--- a/drivers/mmc/host/at91_mci.c~mmc-add-host-capabilities-for-sd-only-and-mmc-only
+++ a/drivers/mmc/host/at91_mci.c
@@ -1007,7 +1007,7 @@ static int __init at91_mci_probe(struct 
 	mmc->f_min = 375000;
 	mmc->f_max = 25000000;
 	mmc->ocr_avail = MMC_VDD_32_33 | MMC_VDD_33_34;
-	mmc->caps = MMC_CAP_SDIO_IRQ;
+	mmc->caps = MMC_CAP_SDIO_IRQ | MMC_CAP_SDIO | MMC_CAP_SD | MMC_CAP_MMC;
 
 	mmc->max_blk_size = 4095;
 	mmc->max_blk_count = mmc->max_req_size;
diff -puN drivers/mmc/host/atmel-mci.c~mmc-add-host-capabilities-for-sd-only-and-mmc-only drivers/mmc/host/atmel-mci.c
--- a/drivers/mmc/host/atmel-mci.c~mmc-add-host-capabilities-for-sd-only-and-mmc-only
+++ a/drivers/mmc/host/atmel-mci.c
@@ -1467,6 +1467,7 @@ static int __init atmci_init_slot(struct
 	mmc->f_min = DIV_ROUND_UP(host->bus_hz, 512);
 	mmc->f_max = host->bus_hz / 2;
 	mmc->ocr_avail	= MMC_VDD_32_33 | MMC_VDD_33_34;
+	mmc->caps = MMC_CAP_SDIO | MMC_CAP_SD | MMC_CAP_MMC;
 	if (slot_data->bus_width >= 4)
 		mmc->caps |= MMC_CAP_4_BIT_DATA;
 
diff -puN drivers/mmc/host/au1xmmc.c~mmc-add-host-capabilities-for-sd-only-and-mmc-only drivers/mmc/host/au1xmmc.c
--- a/drivers/mmc/host/au1xmmc.c~mmc-add-host-capabilities-for-sd-only-and-mmc-only
+++ a/drivers/mmc/host/au1xmmc.c
@@ -1003,7 +1003,8 @@ static int __devinit au1xmmc_probe(struc
 	mmc->max_blk_count = 512;
 
 	mmc->ocr_avail = AU1XMMC_OCR;
-	mmc->caps = MMC_CAP_4_BIT_DATA | MMC_CAP_SDIO_IRQ;
+	mmc->caps = MMC_CAP_4_BIT_DATA | MMC_CAP_SDIO_IRQ |
+		MMC_CAP_SDIO | MMC_CAP_SD | MMC_CAP_MMC;
 
 	host->status = HOST_S_IDLE;
 
diff -puN drivers/mmc/host/cb710-mmc.c~mmc-add-host-capabilities-for-sd-only-and-mmc-only drivers/mmc/host/cb710-mmc.c
--- a/drivers/mmc/host/cb710-mmc.c~mmc-add-host-capabilities-for-sd-only-and-mmc-only
+++ a/drivers/mmc/host/cb710-mmc.c
@@ -721,7 +721,8 @@ static int __devinit cb710_mmc_init(stru
 	mmc->f_max = val;
 	mmc->f_min = val >> cb710_clock_divider_log2[CB710_MAX_DIVIDER_IDX];
 	mmc->ocr_avail = MMC_VDD_32_33|MMC_VDD_33_34;
-	mmc->caps = MMC_CAP_4_BIT_DATA;
+	mmc->caps = MMC_CAP_4_BIT_DATA | MMC_CAP_SDIO |
+		MMC_CAP_SD | MMC_CAP_MMC;
 
 	reader = mmc_priv(mmc);
 
diff -puN drivers/mmc/host/imxmmc.c~mmc-add-host-capabilities-for-sd-only-and-mmc-only drivers/mmc/host/imxmmc.c
--- a/drivers/mmc/host/imxmmc.c~mmc-add-host-capabilities-for-sd-only-and-mmc-only
+++ a/drivers/mmc/host/imxmmc.c
@@ -962,7 +962,8 @@ static int __init imxmci_probe(struct pl
 	mmc->f_min = 150000;
 	mmc->f_max = CLK_RATE/2;
 	mmc->ocr_avail = MMC_VDD_32_33;
-	mmc->caps = MMC_CAP_4_BIT_DATA;
+	mmc->caps = MMC_CAP_4_BIT_DATA | MMC_CAP_SDIO |
+		MMC_CAP_SD | MMC_CAP_MMC;
 
 	/* MMC core transfer sizes tunable parameters */
 	mmc->max_hw_segs = 64;
diff -puN drivers/mmc/host/mmc_spi.c~mmc-add-host-capabilities-for-sd-only-and-mmc-only drivers/mmc/host/mmc_spi.c
--- a/drivers/mmc/host/mmc_spi.c~mmc-add-host-capabilities-for-sd-only-and-mmc-only
+++ a/drivers/mmc/host/mmc_spi.c
@@ -1386,7 +1386,7 @@ static int mmc_spi_probe(struct spi_devi
 	mmc->max_req_size = MMC_SPI_BLOCKSATONCE * MMC_SPI_BLOCKSIZE;
 	mmc->max_blk_count = MMC_SPI_BLOCKSATONCE;
 
-	mmc->caps = MMC_CAP_SPI;
+	mmc->caps = MMC_CAP_SPI | MMC_CAP_SDIO | MMC_CAP_SD | MMC_CAP_MMC;
 
 	/* SPI doesn't need the lowspeed device identification thing for
 	 * MMC or SD cards, since it never comes up in open drain mode.
diff -puN drivers/mmc/host/mmci.c~mmc-add-host-capabilities-for-sd-only-and-mmc-only drivers/mmc/host/mmci.c
--- a/drivers/mmc/host/mmci.c~mmc-add-host-capabilities-for-sd-only-and-mmc-only
+++ a/drivers/mmc/host/mmci.c
@@ -585,6 +585,8 @@ static int __devinit mmci_probe(struct a
 	mmc->f_max = min(host->mclk, fmax);
 	mmc->ocr_avail = plat->ocr_mask;
 
+	mmc->caps = MMC_CAP_SDIO | MMC_CAP_SD | MMC_CAP_MMC;
+
 	/*
 	 * We can do SGIO
 	 */
diff -puN drivers/mmc/host/mvsdio.c~mmc-add-host-capabilities-for-sd-only-and-mmc-only drivers/mmc/host/mvsdio.c
--- a/drivers/mmc/host/mvsdio.c~mmc-add-host-capabilities-for-sd-only-and-mmc-only
+++ a/drivers/mmc/host/mvsdio.c
@@ -734,7 +734,8 @@ static int __init mvsd_probe(struct plat
 
 	mmc->ocr_avail = MMC_VDD_32_33 | MMC_VDD_33_34;
 	mmc->caps = MMC_CAP_4_BIT_DATA | MMC_CAP_SDIO_IRQ |
-		    MMC_CAP_SD_HIGHSPEED | MMC_CAP_MMC_HIGHSPEED;
+		    MMC_CAP_SD_HIGHSPEED | MMC_CAP_MMC_HIGHSPEED |
+		    MMC_CAP_SDIO | MMC_CAP_SD | MMC_CAP_MMC;
 
 	mmc->f_min = DIV_ROUND_UP(host->base_clock, MVSD_BASE_DIV_MAX);
 	mmc->f_max = maxfreq;
diff -puN drivers/mmc/host/mxcmmc.c~mmc-add-host-capabilities-for-sd-only-and-mmc-only drivers/mmc/host/mxcmmc.c
--- a/drivers/mmc/host/mxcmmc.c~mmc-add-host-capabilities-for-sd-only-and-mmc-only
+++ a/drivers/mmc/host/mxcmmc.c
@@ -700,7 +700,8 @@ static int mxcmci_probe(struct platform_
 	}
 
 	mmc->ops = &mxcmci_ops;
-	mmc->caps = MMC_CAP_4_BIT_DATA;
+	mmc->caps = MMC_CAP_4_BIT_DATA | MMC_CAP_MMC |
+		MMC_CAP_SD | MMC_CAP_SDIO;
 
 	/* MMC core transfer sizes tunable parameters */
 	mmc->max_hw_segs = 64;
diff -puN drivers/mmc/host/omap.c~mmc-add-host-capabilities-for-sd-only-and-mmc-only drivers/mmc/host/omap.c
--- a/drivers/mmc/host/omap.c~mmc-add-host-capabilities-for-sd-only-and-mmc-only
+++ a/drivers/mmc/host/omap.c
@@ -1314,7 +1314,7 @@ static int __init mmc_omap_new_slot(stru
 
 	host->slots[id] = slot;
 
-	mmc->caps = 0;
+	mmc->caps = MMC_CAP_SDIO | MMC_CAP_SD | MMC_CAP_MMC;
 	if (host->pdata->slots[id].wires >= 4)
 		mmc->caps |= MMC_CAP_4_BIT_DATA;
 
diff -puN drivers/mmc/host/omap_hsmmc.c~mmc-add-host-capabilities-for-sd-only-and-mmc-only drivers/mmc/host/omap_hsmmc.c
--- a/drivers/mmc/host/omap_hsmmc.c~mmc-add-host-capabilities-for-sd-only-and-mmc-only
+++ a/drivers/mmc/host/omap_hsmmc.c
@@ -1087,6 +1087,8 @@ static int __init omap_mmc_probe(struct 
 	else if (pdata->slots[host->slot_id].wires >= 4)
 		mmc->caps |= MMC_CAP_4_BIT_DATA;
 
+	mmc->caps |= MMC_CAP_SDIO | MMC_CAP_SD | MMC_CAP_MMC;
+
 	omap_hsmmc_init(host);
 
 	/* Select DMA lines */
diff -puN drivers/mmc/host/pxamci.c~mmc-add-host-capabilities-for-sd-only-and-mmc-only drivers/mmc/host/pxamci.c
--- a/drivers/mmc/host/pxamci.c~mmc-add-host-capabilities-for-sd-only-and-mmc-only
+++ a/drivers/mmc/host/pxamci.c
@@ -613,7 +613,7 @@ static int pxamci_probe(struct platform_
 
 	pxamci_init_ocr(host);
 
-	mmc->caps = 0;
+	mmc->caps = MMC_CAP_SDIO | MMC_CAP_SD | MMC_CAP_MMC;
 	host->cmdat = 0;
 	if (!cpu_is_pxa25x()) {
 		mmc->caps |= MMC_CAP_4_BIT_DATA | MMC_CAP_SDIO_IRQ;
diff -puN drivers/mmc/host/s3cmci.c~mmc-add-host-capabilities-for-sd-only-and-mmc-only drivers/mmc/host/s3cmci.c
--- a/drivers/mmc/host/s3cmci.c~mmc-add-host-capabilities-for-sd-only-and-mmc-only
+++ a/drivers/mmc/host/s3cmci.c
@@ -1376,7 +1376,8 @@ static int __devinit s3cmci_probe(struct
 
 	mmc->ops 	= &s3cmci_ops;
 	mmc->ocr_avail	= MMC_VDD_32_33 | MMC_VDD_33_34;
-	mmc->caps	= MMC_CAP_4_BIT_DATA;
+	mmc->caps	= MMC_CAP_4_BIT_DATA | MMC_CAP_SDIO |
+			  MMC_CAP_SD | MMC_CAP_MMC;
 	mmc->f_min 	= host->clk_rate / (host->clk_div * 256);
 	mmc->f_max 	= host->clk_rate / host->clk_div;
 
diff -puN drivers/mmc/host/sdhci.c~mmc-add-host-capabilities-for-sd-only-and-mmc-only drivers/mmc/host/sdhci.c
--- a/drivers/mmc/host/sdhci.c~mmc-add-host-capabilities-for-sd-only-and-mmc-only
+++ a/drivers/mmc/host/sdhci.c
@@ -1771,7 +1771,7 @@ int sdhci_add_host(struct sdhci_host *ho
 	else
 		mmc->f_min = host->max_clk / 256;
 	mmc->f_max = host->max_clk;
-	mmc->caps = MMC_CAP_SDIO_IRQ;
+	mmc->caps = MMC_CAP_SDIO_IRQ | MMC_CAP_SDIO | MMC_CAP_SD | MMC_CAP_MMC;
 
 	if (!(host->quirks & SDHCI_QUIRK_FORCE_1_BIT_DATA))
 		mmc->caps |= MMC_CAP_4_BIT_DATA;
diff -puN drivers/mmc/host/sdricoh_cs.c~mmc-add-host-capabilities-for-sd-only-and-mmc-only drivers/mmc/host/sdricoh_cs.c
--- a/drivers/mmc/host/sdricoh_cs.c~mmc-add-host-capabilities-for-sd-only-and-mmc-only
+++ a/drivers/mmc/host/sdricoh_cs.c
@@ -443,7 +443,8 @@ static int sdricoh_init_mmc(struct pci_d
 	mmc->f_min = 450000;
 	mmc->f_max = 24000000;
 	mmc->ocr_avail = MMC_VDD_32_33 | MMC_VDD_33_34;
-	mmc->caps |= MMC_CAP_4_BIT_DATA;
+	mmc->caps |= MMC_CAP_4_BIT_DATA | MMC_CAP_SDIO |
+		MMC_CAP_SD | MMC_CAP_MMC;
 
 	mmc->max_seg_size = 1024 * 512;
 	mmc->max_blk_size = 512;
diff -puN drivers/mmc/host/tifm_sd.c~mmc-add-host-capabilities-for-sd-only-and-mmc-only drivers/mmc/host/tifm_sd.c
--- a/drivers/mmc/host/tifm_sd.c~mmc-add-host-capabilities-for-sd-only-and-mmc-only
+++ a/drivers/mmc/host/tifm_sd.c
@@ -973,7 +973,8 @@ static int tifm_sd_probe(struct tifm_dev
 
 	mmc->ops = &tifm_sd_ops;
 	mmc->ocr_avail = MMC_VDD_32_33 | MMC_VDD_33_34;
-	mmc->caps = MMC_CAP_4_BIT_DATA;
+	mmc->caps = MMC_CAP_4_BIT_DATA | MMC_CAP_SDIO |
+		MMC_CAP_SD | MMC_CAP_MMC;
 	mmc->f_min = 20000000 / 60;
 	mmc->f_max = 24000000;
 
diff -puN drivers/mmc/host/tmio_mmc.c~mmc-add-host-capabilities-for-sd-only-and-mmc-only drivers/mmc/host/tmio_mmc.c
--- a/drivers/mmc/host/tmio_mmc.c~mmc-add-host-capabilities-for-sd-only-and-mmc-only
+++ a/drivers/mmc/host/tmio_mmc.c
@@ -564,7 +564,8 @@ static int __devinit tmio_mmc_probe(stru
 	}
 
 	mmc->ops = &tmio_mmc_ops;
-	mmc->caps = MMC_CAP_4_BIT_DATA;
+	mmc->caps = MMC_CAP_4_BIT_DATA | MMC_CAP_SDIO |
+		MMC_CAP_SD | MMC_CAP_MMC;
 	mmc->f_max = pdata->hclk;
 	mmc->f_min = mmc->f_max / 512;
 	mmc->ocr_avail = MMC_VDD_32_33 | MMC_VDD_33_34;
diff -puN drivers/mmc/host/via-sdmmc.c~mmc-add-host-capabilities-for-sd-only-and-mmc-only drivers/mmc/host/via-sdmmc.c
--- a/drivers/mmc/host/via-sdmmc.c~mmc-add-host-capabilities-for-sd-only-and-mmc-only
+++ a/drivers/mmc/host/via-sdmmc.c
@@ -1046,7 +1046,8 @@ static void via_init_mmc_host(struct via
 	mmc->f_min = VIA_CRDR_MIN_CLOCK;
 	mmc->f_max = VIA_CRDR_MAX_CLOCK;
 	mmc->ocr_avail = MMC_VDD_32_33 | MMC_VDD_33_34 | MMC_VDD_165_195;
-	mmc->caps = MMC_CAP_4_BIT_DATA | MMC_CAP_SD_HIGHSPEED;
+	mmc->caps = MMC_CAP_4_BIT_DATA | MMC_CAP_SD_HIGHSPEED |
+		MMC_CAP_SDIO | MMC_CAP_SD | MMC_CAP_MMC;
 	mmc->ops = &via_sdc_ops;
 
 	/*Hardware cannot do scatter lists*/
diff -puN drivers/mmc/host/wbsd.c~mmc-add-host-capabilities-for-sd-only-and-mmc-only drivers/mmc/host/wbsd.c
--- a/drivers/mmc/host/wbsd.c~mmc-add-host-capabilities-for-sd-only-and-mmc-only
+++ a/drivers/mmc/host/wbsd.c
@@ -1219,7 +1219,8 @@ static int __devinit wbsd_alloc_mmc(stru
 	mmc->f_min = 375000;
 	mmc->f_max = 24000000;
 	mmc->ocr_avail = MMC_VDD_32_33 | MMC_VDD_33_34;
-	mmc->caps = MMC_CAP_4_BIT_DATA;
+	mmc->caps = MMC_CAP_4_BIT_DATA | MMC_CAP_SDIO |
+		MMC_CAP_SD | MMC_CAP_MMC;
 
 	spin_lock_init(&host->lock);
 
diff -puN include/linux/mmc/host.h~mmc-add-host-capabilities-for-sd-only-and-mmc-only include/linux/mmc/host.h
--- a/include/linux/mmc/host.h~mmc-add-host-capabilities-for-sd-only-and-mmc-only
+++ a/include/linux/mmc/host.h
@@ -150,6 +150,9 @@ struct mmc_host {
 #define MMC_CAP_DISABLE		(1 << 7)	/* Can the host be disabled */
 #define MMC_CAP_NONREMOVABLE	(1 << 8)	/* Nonremovable e.g. eMMC */
 #define MMC_CAP_WAIT_WHILE_BUSY	(1 << 9)	/* Waits while card is busy */
+#define MMC_CAP_SDIO		(1 << 10)	/* Card can be SDIO */
+#define MMC_CAP_SD		(1 << 11)	/* Card can be SD */
+#define MMC_CAP_MMC		(1 << 12)	/* Card can be MMC */
 
 	/* host specific block data */
 	unsigned int		max_seg_size;	/* see blk_queue_max_segment_size */
_

Patches currently in -mm which might be from matt@console-pimps.org are

linux-next.patch
sdhci-get-rid-of-frequency-too-high-flood-when-using-esdhc.patch
mmc-in-mmc_power_up-use-previously-selected-ocr-if-available.patch
omap-hsmmc-do-not-enable-buffer-ready-interrupt-if-using-dma.patch
mmc-msm_sdccc-driver-for-htc-dream.patch
msm_sdccc-convert-printkkern_level-to-pr_level.patch
msm_sdccc-stylistic-cleaning.patch
msm_sdccc-move-overly-indented-code-to-separate-function.patch
mmc-register-mmci-omap-hs-using-platform_driver_probe.patch
sdio-do-not-ignore-mmc_vdd_165_195.patch
mmc-make-the-configuration-memory-resource-optional.patch
tmio_mmc-optionally-support-using-platform-clock.patch
sh-switch-migo-r-to-use-the-tmio-mmc-driver-instead-of-spi.patch
mmc-add-enable-and-disable-methods-to-mmc-host.patch
mmc-allow-host-claim-release-nesting.patch
mmc-add-mmc_cap_nonremovable-host-capability.patch
mmc-add-ability-to-save-power-by-powering-off-cards.patch
mmc-add-mmc-card-sleep-and-awake-support.patch
mmc-power-off-once-at-removal.patch
mmc-add-host-capabilities-for-sd-only-and-mmc-only.patch
mmc-check-status-after-mmc-switch-command.patch
omap_hsmmc-add-debugfs-entry-host-registers.patch
omap_hsmmc-make-use-of-new-enable-disable-interface.patch
arm-omap-mmc-twl4030-add-context-loss-counter-support.patch
omap_hsmmc-keep-track-of-power-mode.patch
omap_hsmmc-context-save-restore-support.patch
omap_hsmmc-set-open-drain-bit-correctly.patch
omap_hsmmc-ensure-workqueues-are-empty-before-suspend.patch
omap_hsmmc-fix-scatter-gather-list-sanity-checking.patch
omap_hsmmc-make-use-of-new-mmc_cap_nonremovable-host-capability.patch
omap_hsmmc-support-for-deeper-power-saving-states.patch
arm-omap-mmc-twl4030-add-regulator-sleep-wake-function.patch
omap_hsmmc-put-mmc-regulator-to-sleep.patch
omap_hsmmc-add-mmc-card-sleep-and-awake-support.patch
omap_hsmmc-fix-null-pointer-dereference.patch
omap_hsmmc-cleanup-macro-usage.patch
omap_hsmmc-clear-interrupt-status-after-init-sequence.patch
omap_hsmmc-cater-for-weird-cmd6-behaviour.patch
omap_hsmmc-prevent-races-with-irq-handler.patch
omap_hsmmc-pass-host-capabilities-for-sd-only-and-mmc-only.patch
omap_hsmmc-code-refactoring.patch
omap_hsmmc-protect-the-card-when-the-cover-is-open.patch
omap_hsmmc-ensure-all-clock-enables-and-disables-are-paired.patch
omap_hsmmc-set-a-large-data-timeout-for-commands-with-busy-signal.patch
arm-omap-rx51-set-mmc-capabilities-and-power-saving-flag.patch

