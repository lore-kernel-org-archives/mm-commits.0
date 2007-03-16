From: akpm@linux-foundation.org
Subject: + mmc-consolidate-voltage-definitions.patch added to -mm tree
Date: Thu, 15 Mar 2007 18:00:18 -0800
Message-ID: <200703160200.l2G20Ix4032502@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:48928 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750944AbXCPCA1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Mar 2007 22:00:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: philipl@overt.org


The patch titled
     MMC: consolidate voltage definitions
has been added to the -mm tree.  Its filename is
     mmc-consolidate-voltage-definitions.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: MMC: consolidate voltage definitions
From: Philip Langdale <philipl@overt.org>

Consolidate the list of available voltages.

Up until now, a separate set of defines has been used for host->vdd than
that used for the OCR voltage mask values.  Having two sets of defines
allows them to get out of sync and the current sets are already
inconsistent with one claiming to describe ranges and the other specific
voltages.

Only the SDHCI driver uses the host->vdd defines and it is easily fixed to
use the OCR defines.

Signed-off-by: Philip Langdale <philipl@overt.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/sdhci.c |   17 +++++++----------
 include/linux/mmc/host.h |   25 +------------------------
 2 files changed, 8 insertions(+), 34 deletions(-)

diff -puN drivers/mmc/host/sdhci.c~mmc-consolidate-voltage-definitions drivers/mmc/host/sdhci.c
--- a/drivers/mmc/host/sdhci.c~mmc-consolidate-voltage-definitions
+++ a/drivers/mmc/host/sdhci.c
@@ -668,20 +668,17 @@ static void sdhci_set_power(struct sdhci
 
 	pwr = SDHCI_POWER_ON;
 
-	switch (power) {
-	case MMC_VDD_170:
-	case MMC_VDD_180:
-	case MMC_VDD_190:
+	switch (1 << power) {
+	case MMC_VDD_17_18:
+	case MMC_VDD_18_19:
 		pwr |= SDHCI_POWER_180;
 		break;
-	case MMC_VDD_290:
-	case MMC_VDD_300:
-	case MMC_VDD_310:
+	case MMC_VDD_29_30:
+	case MMC_VDD_30_31:
 		pwr |= SDHCI_POWER_300;
 		break;
-	case MMC_VDD_320:
-	case MMC_VDD_330:
-	case MMC_VDD_340:
+	case MMC_VDD_32_33:
+	case MMC_VDD_33_34:
 		pwr |= SDHCI_POWER_330;
 		break;
 	default:
diff -puN include/linux/mmc/host.h~mmc-consolidate-voltage-definitions include/linux/mmc/host.h
--- a/include/linux/mmc/host.h~mmc-consolidate-voltage-definitions
+++ a/include/linux/mmc/host.h
@@ -16,30 +16,7 @@ struct mmc_ios {
 	unsigned int	clock;			/* clock rate */
 	unsigned short	vdd;
 
-#define	MMC_VDD_150	0
-#define	MMC_VDD_155	1
-#define	MMC_VDD_160	2
-#define	MMC_VDD_165	3
-#define	MMC_VDD_170	4
-#define	MMC_VDD_180	5
-#define	MMC_VDD_190	6
-#define	MMC_VDD_200	7
-#define	MMC_VDD_210	8
-#define	MMC_VDD_220	9
-#define	MMC_VDD_230	10
-#define	MMC_VDD_240	11
-#define	MMC_VDD_250	12
-#define	MMC_VDD_260	13
-#define	MMC_VDD_270	14
-#define	MMC_VDD_280	15
-#define	MMC_VDD_290	16
-#define	MMC_VDD_300	17
-#define	MMC_VDD_310	18
-#define	MMC_VDD_320	19
-#define	MMC_VDD_330	20
-#define	MMC_VDD_340	21
-#define	MMC_VDD_350	22
-#define	MMC_VDD_360	23
+/* vdd stores the bit number of the selected voltage range from below. */
 
 	unsigned char	bus_mode;		/* command output mode */
 
_

Patches currently in -mm which might be from philipl@overt.org are

mmc-consolidate-voltage-definitions.patch
mmc-fix-handling-of-low-voltage-cards.patch
