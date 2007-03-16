From: akpm@linux-foundation.org
Subject: + mmc-fix-handling-of-low-voltage-cards.patch added to -mm tree
Date: Thu, 15 Mar 2007 18:00:21 -0800
Message-ID: <200703160200.l2G20L9O032505@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:48929 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752361AbXCPCA2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Mar 2007 22:00:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: philipl@overt.org


The patch titled
     MMC: fix handling of low-voltage cards
has been added to the -mm tree.  Its filename is
     mmc-fix-handling-of-low-voltage-cards.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: MMC: fix handling of low-voltage cards
From: Philip Langdale <philipl@overt.org>

Fix handling of low voltage MMC cards.

The latest MMC and SD specs both agree that support for low-voltage
operations is indicated by bit 7 in the OCR.  The MMC spec states that the
low voltage range is 1.65-1.95V while the SD spec leaves the actual voltage
range undefined - meaning that there is still no such thing as a low
voltage SD card.

However, an old Sandisk spec implied that bits 7.0 represented voltages
below 2.0V in 1V or 0.5V increments, and the code was accordingly written
with that expectation.

This confusion meant that host drivers attempting to support the typical
low voltage (1.8V) would set the wrong bits in the host OCR mask (usually
bits 5 and/or 6) resulting in the the low voltage mode never being used.

This change corrects the low voltage range and adds sanity checks on the
reserved bits (0-6) and for SD cards that claim to support low-voltage
operations.

Signed-off-by: Philip Langdale <philipl@overt.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/core/core.c  |   18 ++++++++++++++++++
 drivers/mmc/host/sdhci.c |    5 ++---
 include/linux/mmc/host.h |    9 +--------
 3 files changed, 21 insertions(+), 11 deletions(-)

diff -puN drivers/mmc/core/core.c~mmc-fix-handling-of-low-voltage-cards drivers/mmc/core/core.c
--- a/drivers/mmc/core/core.c~mmc-fix-handling-of-low-voltage-cards
+++ a/drivers/mmc/core/core.c
@@ -329,6 +329,24 @@ u32 mmc_select_voltage(struct mmc_host *
 {
 	int bit;
 
+	/*
+	 * Sanity check the voltages that the card claims to
+	 * support.
+	 */
+	if (ocr & 0x7F) {
+		printk("%s: card claims to support voltages below "
+		       "the defined range. These will be ignored.\n",
+		       mmc_hostname(host));
+		ocr &= ~0x7F;
+	}
+
+	if (host->mode == MMC_MODE_SD && (ocr & MMC_VDD_165_195)) {
+		printk("%s: SD card claims to support the incompletely "
+		       "defined 'low voltage range'. This will be ignored.\n",
+		       mmc_hostname(host));
+		ocr &= ~MMC_VDD_165_195;
+	}
+
 	ocr &= host->ocr_avail;
 
 	bit = ffs(ocr);
diff -puN drivers/mmc/host/sdhci.c~mmc-fix-handling-of-low-voltage-cards drivers/mmc/host/sdhci.c
--- a/drivers/mmc/host/sdhci.c~mmc-fix-handling-of-low-voltage-cards
+++ a/drivers/mmc/host/sdhci.c
@@ -669,8 +669,7 @@ static void sdhci_set_power(struct sdhci
 	pwr = SDHCI_POWER_ON;
 
 	switch (1 << power) {
-	case MMC_VDD_17_18:
-	case MMC_VDD_18_19:
+	case MMC_VDD_165_195:
 		pwr |= SDHCI_POWER_180;
 		break;
 	case MMC_VDD_29_30:
@@ -1290,7 +1289,7 @@ static int __devinit sdhci_probe_slot(st
 	if (caps & SDHCI_CAN_VDD_300)
 		mmc->ocr_avail |= MMC_VDD_29_30|MMC_VDD_30_31;
 	if (caps & SDHCI_CAN_VDD_180)
-		mmc->ocr_avail |= MMC_VDD_17_18|MMC_VDD_18_19;
+		mmc->ocr_avail |= MMC_VDD_165_195;
 
 	if (mmc->ocr_avail == 0) {
 		printk(KERN_ERR "%s: Hardware doesn't report any "
diff -puN include/linux/mmc/host.h~mmc-fix-handling-of-low-voltage-cards include/linux/mmc/host.h
--- a/include/linux/mmc/host.h~mmc-fix-handling-of-low-voltage-cards
+++ a/include/linux/mmc/host.h
@@ -65,14 +65,7 @@ struct mmc_host {
 	unsigned int		f_max;
 	u32			ocr_avail;
 
-#define MMC_VDD_145_150		0x00000001	/* VDD voltage 1.45 - 1.50 */
-#define MMC_VDD_150_155		0x00000002	/* VDD voltage 1.50 - 1.55 */
-#define MMC_VDD_155_160		0x00000004	/* VDD voltage 1.55 - 1.60 */
-#define MMC_VDD_160_165		0x00000008	/* VDD voltage 1.60 - 1.65 */
-#define MMC_VDD_165_170		0x00000010	/* VDD voltage 1.65 - 1.70 */
-#define MMC_VDD_17_18		0x00000020	/* VDD voltage 1.7 - 1.8 */
-#define MMC_VDD_18_19		0x00000040	/* VDD voltage 1.8 - 1.9 */
-#define MMC_VDD_19_20		0x00000080	/* VDD voltage 1.9 - 2.0 */
+#define MMC_VDD_165_195		0x00000080	/* VDD voltage 1.65 - 1.95 */
 #define MMC_VDD_20_21		0x00000100	/* VDD voltage 2.0 ~ 2.1 */
 #define MMC_VDD_21_22		0x00000200	/* VDD voltage 2.1 ~ 2.2 */
 #define MMC_VDD_22_23		0x00000400	/* VDD voltage 2.2 ~ 2.3 */
_

Patches currently in -mm which might be from philipl@overt.org are

mmc-consolidate-voltage-definitions.patch
mmc-fix-handling-of-low-voltage-cards.patch
