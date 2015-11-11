From: akpm@linux-foundation.org
Subject: [merged] sfc-dont-call-dma_supported.patch removed from -mm tree
Date: Wed, 11 Nov 2015 11:48:33 -0800
Message-ID: <56439b91.ZKHbg2Ds1OhVTMkl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55468 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752416AbbKKTsd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Nov 2015 14:48:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, linux-net-drivers@solarflare.com, sshah@solarflare.com, mm-commits@vger.kernel.org


The patch titled
     Subject: sfc: don't call dma_supported
has been removed from the -mm tree.  Its filename was
     sfc-dont-call-dma_supported.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: sfc: don't call dma_supported

dma_set_mask already checks for a supported DMA mask before updating it,
the call to dma_supported is redundant.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Solarflare linux maintainers <linux-net-drivers@solarflare.com>
Cc: Shradha Shah <sshah@solarflare.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ethernet/sfc/efx.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff -puN drivers/net/ethernet/sfc/efx.c~sfc-dont-call-dma_supported drivers/net/ethernet/sfc/efx.c
--- a/drivers/net/ethernet/sfc/efx.c~sfc-dont-call-dma_supported
+++ a/drivers/net/ethernet/sfc/efx.c
@@ -1247,11 +1247,9 @@ static int efx_init_io(struct efx_nic *e
 	 * masks event though they reject 46 bit masks.
 	 */
 	while (dma_mask > 0x7fffffffUL) {
-		if (dma_supported(&pci_dev->dev, dma_mask)) {
-			rc = dma_set_mask_and_coherent(&pci_dev->dev, dma_mask);
-			if (rc == 0)
-				break;
-		}
+		rc = dma_set_mask_and_coherent(&pci_dev->dev, dma_mask);
+		if (rc == 0)
+			break;
 		dma_mask >>= 1;
 	}
 	if (rc) {
_

Patches currently in -mm which might be from hch@lst.de are


