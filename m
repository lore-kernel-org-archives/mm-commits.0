From: akpm@linux-foundation.org
Subject: + sdhci-spear-st-spear-based-sdhci-controller-glue-update.patch added to -mm tree
Date: Tue, 25 May 2010 16:21:36 -0700
Message-ID: <201005252321.o4PNLaIx021229@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58055 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932617Ab0EYXVl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 May 2010 19:21:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: viresh.kumar@st.com


The patch titled
     sdhci-spear-st-spear-based-sdhci-controller-glue-update
has been added to the -mm tree.  Its filename is
     sdhci-spear-st-spear-based-sdhci-controller-glue-update.patch

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
Subject: sdhci-spear-st-spear-based-sdhci-controller-glue-update
From: Viresh KUMAR <viresh.kumar@st.com>

- dev_get_platdata is used to get dev->platform_data

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/sdhci-spear.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff -puN drivers/mmc/host/sdhci-spear.c~sdhci-spear-st-spear-based-sdhci-controller-glue-update drivers/mmc/host/sdhci-spear.c
--- a/drivers/mmc/host/sdhci-spear.c~sdhci-spear-st-spear-based-sdhci-controller-glue-update
+++ a/drivers/mmc/host/sdhci-spear.c
@@ -41,8 +41,7 @@ static irqreturn_t sdhci_gpio_irq(int ir
 {
 	struct platform_device *pdev = dev_id;
 	struct sdhci_host *host = platform_get_drvdata(pdev);
-	struct spear_sdhci *sdhci =
-		(struct spear_sdhci *)(pdev->dev.platform_data);
+	struct spear_sdhci *sdhci = dev_get_platdata(&pdev->dev);
 	unsigned long gpio_irq_type;
 	int val;
 
@@ -112,7 +111,7 @@ static int __devinit sdhci_probe(struct 
 	}
 
 	/* overwrite platform_data */
-	sdhci->data = (struct sdhci_plat_data *)(pdev->dev.platform_data);
+	sdhci->data = dev_get_platdata(&pdev->dev);
 	pdev->dev.platform_data = sdhci;
 
 	if (pdev->dev.parent)
@@ -241,8 +240,7 @@ static int __devexit sdhci_remove(struct
 {
 	struct sdhci_host *host = platform_get_drvdata(pdev);
 	struct resource *iomem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	struct spear_sdhci *sdhci =
-		(struct spear_sdhci *)(pdev->dev.platform_data);
+	struct spear_sdhci *sdhci = dev_get_platdata(&pdev->dev);
 	int dead;
 	u32 scratch;
 
_

Patches currently in -mm which might be from viresh.kumar@st.com are

origin.patch
sdhci-spear-st-spear-based-sdhci-controller-glue.patch
sdhci-spear-st-spear-based-sdhci-controller-glue-update.patch

