From: akpm@linux-foundation.org
Subject: - pci-use-pci_ioremap_bar-in-drivers-mmc.patch removed from -mm tree
Date: Mon, 10 Nov 2008 12:34:04 -0800
Message-ID: <200811102034.mAAKY4dK024841@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34469 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752484AbYKJUit (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Nov 2008 15:38:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arjan@linux.intel.com, drzeus@drzeus.cx, mm-commits@vger.kernel.org


The patch titled
     pci: use pci_ioremap_bar() in drivers/mmc
has been removed from the -mm tree.  Its filename was
     pci-use-pci_ioremap_bar-in-drivers-mmc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

linux-next.patch
scripts-improve-the-decodecode-script.patch
pci-uninline-pci_ioremap_bar.patch
pci-use-pci_ioremap_bar-in-drivers-misc.patch
pci-use-pci_ioremap_bar-in-drivers-serial.patch
pci-use-pci_ioremap_bar-in-drivers-video.patch
pci-use-pci_ioremap_bar-in-drivers-edac.patch

