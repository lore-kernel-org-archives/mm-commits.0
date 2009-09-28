From: akpm@linux-foundation.org
Subject: + sdio-add-mmc_cap_vdd_165_195-host-capability.patch added to -mm tree
Date: Mon, 28 Sep 2009 16:00:07 -0700
Message-ID: <200909282300.n8SN07qk025068__979.834065265273$1254178829$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48602 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753410AbZI1XAO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Sep 2009 19:00:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ohad@wizery.com, linux-mmc@vger.kernel.org


The patch titled
     sdio: add MMC_CAP_VDD_165_195 host capability
has been added to the -mm tree.  Its filename is
     sdio-add-mmc_cap_vdd_165_195-host-capability.patch

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

