From: akpm@linux-foundation.org
Subject: + pci-use-pci_ioremap_bar-in-drivers-mmc.patch added to -mm tree
Date: Tue, 21 Oct 2008 14:16:41 -0700
Message-ID: <200810212116.m9LLGfJm021668@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34001 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752466AbYJUVQv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Oct 2008 17:16:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arjan@linux.intel.com, drzeus@drzeus.cx


The patch titled
     pci: use pci_ioremap_bar() in drivers/mmc
has been added to the -mm tree.  Its filename is
     pci-use-pci_ioremap_bar-in-drivers-mmc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pci: use pci_ioremap_bar() in drivers/mmc
From: Arjan van de Ven <arjan@linux.intel.com>

Use the new pci_ioremap_bar() function in drivers/mmc.  pci_ioremap_bar()
just takes a pci device and a bar number, with the goal of making it
really hard to get wrong, while also having a central place to stick
sanity checks.

Cc: Pierre Ossman <drzeus@drzeus.cx>
Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/sdhci-pci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/mmc/host/sdhci-pci.c~pci-use-pci_ioremap_bar-in-drivers-mmc drivers/mmc/host/sdhci-pci.c
--- a/drivers/mmc/host/sdhci-pci.c~pci-use-pci_ioremap_bar-in-drivers-mmc
+++ a/drivers/mmc/host/sdhci-pci.c
@@ -545,7 +545,7 @@ static struct sdhci_pci_slot * __devinit
 	}
 
 	addr = pci_resource_start(pdev, bar);
-	host->ioaddr = ioremap_nocache(addr, pci_resource_len(pdev, bar));
+	host->ioaddr = pci_ioremap_bar(pdev, bar);
 	if (!host->ioaddr) {
 		dev_err(&pdev->dev, "failed to remap registers\n");
 		goto release;
_

Patches currently in -mm which might be from arjan@linux.intel.com are

origin.patch
linux-next.patch
mutex-improve-header-comment-to-be-actually-informative-about-the-api.patch
pci-use-pci_ioremap_bar-in-drivers-misc.patch
pci-use-pci_ioremap_bar-in-drivers-mmc.patch
pci-use-pci_ioremap_bar-in-drivers-edac.patch
pci-use-pci_ioremap_bar-in-drivers-video.patch
pci-use-pci_ioremap_bar-in-drivers-serial.patch

