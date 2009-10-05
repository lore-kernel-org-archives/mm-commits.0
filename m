From: akpm@linux-foundation.org
Subject: [merged] s3cmci-add-better-support-for-no-card-detect-or-write-protect-available.patch removed from -mm tree
Date: Mon, 05 Oct 2009 11:39:11 -0700
Message-ID: <200910051839.n95IdBrj018602__36455.1870887682$1254768054$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58173 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754679AbZJESju (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Oct 2009 14:39:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ben@simtec.co.uk, linux-mmc@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     s3cmci: add better support for no card detect or write protect available
has been removed from the -mm tree.  Its filename was
     s3cmci-add-better-support-for-no-card-detect-or-write-protect-available.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: s3cmci: add better support for no card detect or write protect available
From: Ben Dooks <ben@simtec.co.uk>

Add better support for omitting either the card detect or the write
protect GPIOs if the board does not support it.  Add the fields
no_wprotect and no_detect to the platform data which when set indicate the
absence of the respective GPIOs.

Note, this also fixes a minor bug where it tries to free IRQ0 if there is
no detect gpio available.

Signed-off-by: Ben Dooks <ben@simtec.co.uk>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/plat-s3c24xx/include/plat/mci.h |    2 
 drivers/mmc/host/s3cmci.c                |   44 +++++++++++----------
 2 files changed, 26 insertions(+), 20 deletions(-)

diff -puN arch/arm/plat-s3c24xx/include/plat/mci.h~s3cmci-add-better-support-for-no-card-detect-or-write-protect-available arch/arm/plat-s3c24xx/include/plat/mci.h
--- a/arch/arm/plat-s3c24xx/include/plat/mci.h~s3cmci-add-better-support-for-no-card-detect-or-write-protect-available
+++ a/arch/arm/plat-s3c24xx/include/plat/mci.h
@@ -2,6 +2,8 @@
 #define _ARCH_MCI_H
 
 struct s3c24xx_mci_pdata {
+	unsigned int	no_wprotect : 1;
+	unsigned int	no_detect : 1;
 	unsigned int	wprotect_invert : 1;
 	unsigned int	detect_invert : 1;   /* set => detect active high. */
 	unsigned int	use_dma : 1;
diff -puN drivers/mmc/host/s3cmci.c~s3cmci-add-better-support-for-no-card-detect-or-write-protect-available drivers/mmc/host/s3cmci.c
--- a/drivers/mmc/host/s3cmci.c~s3cmci-add-better-support-for-no-card-detect-or-write-protect-available
+++ a/drivers/mmc/host/s3cmci.c
@@ -1299,7 +1299,7 @@ static int s3cmci_get_ro(struct mmc_host
 	struct s3c24xx_mci_pdata *pdata = host->pdata;
 	int ret;
 
-	if (pdata->gpio_wprotect == 0)
+	if (pdata->no_wprotect)
 		return 0;
 
 	ret = s3c2410_gpio_getpin(pdata->gpio_wprotect);
@@ -1647,30 +1647,34 @@ static int __devinit s3cmci_probe(struct
 	disable_irq(host->irq);
 	host->irq_state = false;
 
-	if (host->pdata->gpio_detect) {
+	if (!host->pdata->no_detect) {
 		ret = gpio_request(host->pdata->gpio_detect, "s3cmci detect");
 		if (ret) {
 			dev_err(&pdev->dev, "failed to get detect gpio\n");
 			goto probe_free_irq;
 		}
-	}
 
-	host->irq_cd = s3c2410_gpio_getirq(host->pdata->gpio_detect);
+		host->irq_cd = s3c2410_gpio_getirq(host->pdata->gpio_detect);
 
-	if (host->irq_cd >= 0) {
-		if (request_irq(host->irq_cd, s3cmci_irq_cd,
-				IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING,
-				DRIVER_NAME, host)) {
-			dev_err(&pdev->dev, "can't get card detect irq.\n");
-			ret = -ENOENT;
-			goto probe_free_gpio_cd;
+		if (host->irq_cd >= 0) {
+			if (request_irq(host->irq_cd, s3cmci_irq_cd,
+					IRQF_TRIGGER_RISING |
+					IRQF_TRIGGER_FALLING,
+					DRIVER_NAME, host)) {
+				dev_err(&pdev->dev,
+					"can't get card detect irq.\n");
+				ret = -ENOENT;
+				goto probe_free_gpio_cd;
+			}
+		} else {
+			dev_warn(&pdev->dev,
+				 "host detect has no irq available\n");
+			gpio_direction_input(host->pdata->gpio_detect);
 		}
-	} else {
-		dev_warn(&pdev->dev, "host detect has no irq available\n");
-		gpio_direction_input(host->pdata->gpio_detect);
-	}
+	} else
+		host->irq_cd = -1;
 
-	if (host->pdata->gpio_wprotect) {
+	if (!host->pdata->no_wprotect) {
 		ret = gpio_request(host->pdata->gpio_wprotect, "s3cmci wp");
 		if (ret) {
 			dev_err(&pdev->dev, "failed to get writeprotect\n");
@@ -1774,11 +1778,11 @@ static int __devinit s3cmci_probe(struct
 		s3c2410_dma_free(host->dma, &s3cmci_dma_client);
 
  probe_free_gpio_wp:
-	if (host->pdata->gpio_wprotect)
+	if (!host->pdata->no_wprotect)
 		gpio_free(host->pdata->gpio_wprotect);
 
  probe_free_gpio_cd:
-	if (host->pdata->gpio_detect)
+	if (!host->pdata->no_detect)
 		gpio_free(host->pdata->gpio_detect);
 
  probe_free_irq_cd:
@@ -1837,10 +1841,10 @@ static int __devexit s3cmci_remove(struc
 
 	free_irq(host->irq, host);
 
-	if (pd->gpio_wprotect)
+	if (!pd->no_wprotect)
 		gpio_free(pd->gpio_wprotect);
 
-	if (pd->gpio_detect)
+	if (!pd->no_detect)
 		gpio_free(pd->gpio_detect);
 
 	for (i = S3C2410_GPE(5); i <= S3C2410_GPE(10); i++)
_

Patches currently in -mm which might be from ben@simtec.co.uk are

gpiolib-add-names-file-in-gpio-chip-sysfs.patch

