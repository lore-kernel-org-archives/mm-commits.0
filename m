From: akpm@linux-foundation.org
Subject: [merged] sdhci-add-no-card-no-reset-quirk-for-ricoh-r5c822-sony-z11.patch removed from -mm tree
Date: Wed, 23 Sep 2009 12:56:09 -0700
Message-ID: <200909231956.n8NJu98h004278@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44171 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751914AbZIWT4o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 15:56:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cjb@laptop.org, linux-mmc@vger.kernel.org, preining@logic.at, mm-commits@vger.kernel.org


The patch titled
     sdhci: add no-card-no-reset quirk for Ricoh R5C822/Sony Z11
has been removed from the -mm tree.  Its filename was
     sdhci-add-no-card-no-reset-quirk-for-ricoh-r5c822-sony-z11.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sdhci: add no-card-no-reset quirk for Ricoh R5C822/Sony Z11
From: Chris Ball <cjb@laptop.org>

Card insertion detection is broken without this quirk on a Sony Vaio
Z11, as discussed on linux-mmc here: http://marc.info/?t=125017355000008

Signed-off-by: Chris Ball <cjb@laptop.org>
Tested-by: Norbert Preining <preining@logic.at>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/sdhci-pci.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/mmc/host/sdhci-pci.c~sdhci-add-no-card-no-reset-quirk-for-ricoh-r5c822-sony-z11 drivers/mmc/host/sdhci-pci.c
--- a/drivers/mmc/host/sdhci-pci.c~sdhci-add-no-card-no-reset-quirk-for-ricoh-r5c822-sony-z11
+++ a/drivers/mmc/host/sdhci-pci.c
@@ -83,7 +83,8 @@ static int ricoh_probe(struct sdhci_pci_
 	if (chip->pdev->subsystem_vendor == PCI_VENDOR_ID_IBM)
 		chip->quirks |= SDHCI_QUIRK_CLOCK_BEFORE_RESET;
 
-	if (chip->pdev->subsystem_vendor == PCI_VENDOR_ID_SAMSUNG)
+	if (chip->pdev->subsystem_vendor == PCI_VENDOR_ID_SAMSUNG ||
+	    chip->pdev->subsystem_vendor == PCI_VENDOR_ID_SONY)
 		chip->quirks |= SDHCI_QUIRK_NO_CARD_NO_RESET;
 
 	return 0;
_

Patches currently in -mm which might be from cjb@laptop.org are

origin.patch

