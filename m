From: akpm@linux-foundation.org
Subject: + sdhci-add-no-card-no-reset-quirk-for-ricoh-r5c822-sony-z11.patch added to -mm tree
Date: Wed, 02 Sep 2009 16:42:53 -0700
Message-ID: <200909022342.n82NgrVW025860__15541.3826033056$1251935000$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50689 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753817AbZIBXnE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Sep 2009 19:43:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cjb@laptop.org, linux-mmc@vger.kernel.org, preining@logic.at


The patch titled
     sdhci: add no-card-no-reset quirk for Ricoh R5C822/Sony Z11
has been added to the -mm tree.  Its filename is
     sdhci-add-no-card-no-reset-quirk-for-ricoh-r5c822-sony-z11.patch

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

sdhci-add-no-card-no-reset-quirk-for-ricoh-r5c822-sony-z11.patch

