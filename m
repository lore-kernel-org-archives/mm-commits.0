From: akpm@linux-foundation.org
Subject: [merged] crypto-use-pci_zalloc_consistent.patch removed from -mm
 tree
Date: Tue, 12 Aug 2014 12:42:23 -0700
Message-ID: <53ea6e1f.CxpkeMx5qH3IpQeY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pa0-f74.google.com ([209.85.220.74]:41845 "EHLO
	mail-pa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754606AbaHLTmX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:42:23 -0400
Received: by mail-pa0-f74.google.com with SMTP id lj1so2670855pab.1
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:42:23 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: crypto: use pci_zalloc_consistent
has been removed from the -mm tree.  Its filename was
     crypto-use-pci_zalloc_consistent.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: crypto: use pci_zalloc_consistent

Remove the now unnecessary memset too.

Signed-off-by: Joe Perches <joe@perches.com>
Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/crypto/hifn_795x.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN drivers/crypto/hifn_795x.c~crypto-use-pci_zalloc_consistent drivers/crypto/hifn_795x.c
--- a/drivers/crypto/hifn_795x.c~crypto-use-pci_zalloc_consistent
+++ a/drivers/crypto/hifn_795x.c
@@ -2617,14 +2617,13 @@ static int hifn_probe(struct pci_dev *pd
 		}
 	}
 
-	dev->desc_virt = pci_alloc_consistent(pdev, sizeof(struct hifn_dma),
-			&dev->desc_dma);
+	dev->desc_virt = pci_zalloc_consistent(pdev, sizeof(struct hifn_dma),
+					       &dev->desc_dma);
 	if (!dev->desc_virt) {
 		dprintk("Failed to allocate descriptor rings.\n");
 		err = -ENOMEM;
 		goto err_out_unmap_bars;
 	}
-	memset(dev->desc_virt, 0, sizeof(struct hifn_dma));
 
 	dev->pdev = pdev;
 	dev->irq = pdev->irq;
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
mm-utilc-add-kstrimdup.patch
fs-isofs-logging-clean-up.patch
linux-next.patch

