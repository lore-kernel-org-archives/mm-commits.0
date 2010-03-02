From: akpm@linux-foundation.org
Subject: + mmc-enable-dma-on-ricoh-sdhci-reader-by-default.patch added to -mm tree
Date: Tue, 02 Mar 2010 13:38:01 -0800
Message-ID: <201003022138.o22Lc1aT031023__3712.60745819217$1267565936$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53560 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752472Ab0CBVip (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Mar 2010 16:38:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: anarsoul@gmail.com, HaraldWelte@viatech.com, linux-mmc@vger.kernel.org, maximlevitsky@gmail.com, preining@logic.at


The patch titled
     mmc: enable DMA on Ricoh sdhci reader by default
has been added to the -mm tree.  Its filename is
     mmc-enable-dma-on-ricoh-sdhci-reader-by-default.patch

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
