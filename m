From: akpm@linux-foundation.org
Subject: [merged]
 rapidio-tsi721-use-pci_enable_msix_exact-instead-of-pci_enable_msix.patch
 removed from -mm tree
Date: Mon, 09 Jun 2014 12:35:32 -0700
Message-ID: <53960c84.36sMDzWt2B/AWlGH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54146 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904AbaFITfd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 15:35:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mporter@kernel.crashing.org, alexandre.bounine@idt.com, agordeev@redhat.com

Subject: [merged] rapidio-tsi721-use-pci_enable_msix_exact-instead-of-pci_enable_msix.patch removed from -mm tree
To: agordeev@redhat.com,alexandre.bounine@idt.com,mporter@kernel.crashing.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 12:35:32 -0700


The patch titled
     Subject: rapidio/tsi721: use pci_enable_msix_exact() instead of pci_enable_msix()
has been removed from the -mm tree.  Its filename was
     rapidio-tsi721-use-pci_enable_msix_exact-instead-of-pci_enable_msix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexander Gordeev <agordeev@redhat.com>
Subject: rapidio/tsi721: use pci_enable_msix_exact() instead of pci_enable_msix()

As result of deprecation of MSI-X/MSI enablement functions
pci_enable_msix() and pci_enable_msi_block() all drivers using these two
interfaces need to be updated to use the new pci_enable_msi_range() or
pci_enable_msi_exact() and pci_enable_msix_range() or
pci_enable_msix_exact() interfaces.

The patch has no runtime effect.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Acked-by: Alexandre Bounine <alexandre.bounine@idt.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/devices/tsi721.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff -puN drivers/rapidio/devices/tsi721.c~rapidio-tsi721-use-pci_enable_msix_exact-instead-of-pci_enable_msix drivers/rapidio/devices/tsi721.c
--- a/drivers/rapidio/devices/tsi721.c~rapidio-tsi721-use-pci_enable_msix_exact-instead-of-pci_enable_msix
+++ a/drivers/rapidio/devices/tsi721.c
@@ -768,15 +768,10 @@ static int tsi721_enable_msix(struct tsi
 	}
 #endif /* CONFIG_RAPIDIO_DMA_ENGINE */
 
-	err = pci_enable_msix(priv->pdev, entries, ARRAY_SIZE(entries));
+	err = pci_enable_msix_exact(priv->pdev, entries, ARRAY_SIZE(entries));
 	if (err) {
-		if (err > 0)
-			dev_info(&priv->pdev->dev,
-				 "Only %d MSI-X vectors available, "
-				 "not using MSI-X\n", err);
-		else
-			dev_err(&priv->pdev->dev,
-				"Failed to enable MSI-X (err=%d)\n", err);
+		dev_err(&priv->pdev->dev,
+			"Failed to enable MSI-X (err=%d)\n", err);
 		return err;
 	}
 
_

Patches currently in -mm which might be from agordeev@redhat.com are

origin.patch
linux-next.patch

