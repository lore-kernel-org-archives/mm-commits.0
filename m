From: akpm@linux-foundation.org
Subject: + sfc-dont-call-dma_supported.patch added to -mm tree
Date: Mon, 05 Oct 2015 14:29:26 -0700
Message-ID: <5612ebb6.vDTowxCrm5nJN/14%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42852 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722AbbJEV31 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Oct 2015 17:29:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, linux-net-drivers@solarflare.com, sshah@solarflare.com, mm-commits@vger.kernel.org


The patch titled
     Subject: sfc: don't call dma_supported
has been added to the -mm tree.  Its filename is
     sfc-dont-call-dma_supported.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/sfc-dont-call-dma_supported.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/sfc-dont-call-dma_supported.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

pcnet32-use-pci_set_dma_mask-insted-of-pci_dma_supported.patch
tw68-core-use-pci_set_dma_mask-insted-of-pci_dma_supported.patch
saa7164-use-pci_set_dma_mask-insted-of-pci_dma_supported.patch
saa7134-use-pci_set_dma_mask-insted-of-pci_dma_supported.patch
cx88-use-pci_set_dma_mask-insted-of-pci_dma_supported.patch
cx25821-use-pci_set_dma_mask-insted-of-pci_dma_supported.patch
cx23885-use-pci_set_dma_mask-insted-of-pci_dma_supported.patch
netup_unidvb-use-pci_set_dma_mask-insted-of-pci_dma_supported.patch
mpsc-use-dma_set_mask-insted-of-dma_supported.patch
nouveau-dont-call-pci_dma_supported.patch
sfc-dont-call-dma_supported.patch
kaweth-remove-ifdefed-out-call-to-dma_supported.patch
usbnet-remove-ifdefed-out-call-to-dma_supported.patch
pci-remove-pci_dma_supported.patch
dma-remove-external-references-to-dma_supported.patch

