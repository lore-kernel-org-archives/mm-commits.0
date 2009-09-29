From: akpm@linux-foundation.org
Subject: [nacked] sdio-add-mmc_cap_vdd_165_195-host-capability.patch removed from -mm tree
Date: Tue, 29 Sep 2009 12:03:58 -0700
Message-ID: <200909291903.n8TJ3woW011062__40189.6519972526$1254251054$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34809 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753462AbZI2TD4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Sep 2009 15:03:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ohad@wizery.com, linux-mmc@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     sdio: add MMC_CAP_VDD_165_195 host capability
has been removed from the -mm tree.  Its filename was
     sdio-add-mmc_cap_vdd_165_195-host-capability.patch

This patch was dropped because it was nacked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sdio: add MMC_CAP_VDD_165_195 host capability
From: Ohad Ben-Cohen <ohad@wizery.com>

To allow the usage of MMC_VDD_165_195, host capability MMC_CAP_VDD_165_195
is introduced.  This is necessary because MMC_VDD_165_195 is currently
reserved/undefined.

Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/core/sdio.c  |    7 +++++++
 include/linux/mmc/host.h |    1 +
 2 files changed, 8 insertions(+)

diff -puN drivers/mmc/core/sdio.c~sdio-add-mmc_cap_vdd_165_195-host-capability drivers/mmc/core/sdio.c
--- a/drivers/mmc/core/sdio.c~sdio-add-mmc_cap_vdd_165_195-host-capability
+++ a/drivers/mmc/core/sdio.c
@@ -494,6 +494,13 @@ int mmc_attach_sdio(struct mmc_host *hos
 		ocr &= ~0x7F;
 	}
 
+	if ((ocr & MMC_VDD_165_195) && !(host->caps & MMC_CAP_VDD_165_195)) {
+		printk(KERN_WARNING "%s: SDIO card claims to support the "
+			"incompletely defined 'low voltage range'. This "
+			"will be ignored.\n", mmc_hostname(host));
+		ocr &= ~MMC_VDD_165_195;
+	}
+
 	host->ocr = mmc_select_voltage(host, ocr);
 
 	/*
diff -puN include/linux/mmc/host.h~sdio-add-mmc_cap_vdd_165_195-host-capability include/linux/mmc/host.h
--- a/include/linux/mmc/host.h~sdio-add-mmc_cap_vdd_165_195-host-capability
+++ a/include/linux/mmc/host.h
@@ -150,6 +150,7 @@ struct mmc_host {
 #define MMC_CAP_DISABLE		(1 << 7)	/* Can the host be disabled */
 #define MMC_CAP_NONREMOVABLE	(1 << 8)	/* Nonremovable e.g. eMMC */
 #define MMC_CAP_WAIT_WHILE_BUSY	(1 << 9)	/* Waits while card is busy */
+#define MMC_CAP_VDD_165_195	(1 << 10)	/* Accepts MMC_VDD_165_195 */
 
 	/* host specific block data */
 	unsigned int		max_seg_size;	/* see blk_queue_max_segment_size */
_

Patches currently in -mm which might be from ohad@wizery.com are

sdio-add-mmc_cap_vdd_165_195-host-capability.patch

