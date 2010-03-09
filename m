From: akpm@linux-foundation.org
Subject: [merged] mmc-enable-dma-on-ricoh-sdhci-reader-by-default.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:08:56 -0800
Message-ID: <201003091908.o29J8uPO031483__9634.44970916516$1268162583$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59490 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756018Ab0CITW3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:22:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anarsoul@gmail.com, HaraldWelte@viatech.com, linux-mmc@vger.kernel.org, maximlevitsky@gmail.com, preining@logic.at, mm-commits@vger.kernel.org


The patch titled
     mmc: enable DMA on Ricoh sdhci reader by default
has been removed from the -mm tree.  Its filename was
     mmc-enable-dma-on-ricoh-sdhci-reader-by-default.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mmc: enable DMA on Ricoh sdhci reader by default
From: Vasily Khoruzhick <anarsoul@gmail.com>

This card reader doesn't advertise, however DMA works well.  Probably
windows SDHCI driver assumes that all readers support DMA and thus we see
that bug.

Signed-off-by: Vasily Khoruzhick <anarsoul@gmail.com>
Tested-by: Maxim Levitsky <maximlevitsky@gmail.com>
Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Harald Welte <HaraldWelte@viatech.com>
Cc: Norbert Preining <preining@logic.at>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/sdhci-pci.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN drivers/mmc/host/sdhci-pci.c~mmc-enable-dma-on-ricoh-sdhci-reader-by-default drivers/mmc/host/sdhci-pci.c
--- a/drivers/mmc/host/sdhci-pci.c~mmc-enable-dma-on-ricoh-sdhci-reader-by-default
+++ a/drivers/mmc/host/sdhci-pci.c
@@ -80,9 +80,6 @@ struct sdhci_pci_chip {
 
 static int ricoh_probe(struct sdhci_pci_chip *chip)
 {
-	if (chip->pdev->subsystem_vendor == PCI_VENDOR_ID_IBM)
-		chip->quirks |= SDHCI_QUIRK_CLOCK_BEFORE_RESET;
