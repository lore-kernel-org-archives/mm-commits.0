From: akpm@linux-foundation.org
Subject: [merged] dma-remove-external-references-to-dma_supported.patch
 removed from -mm tree
Date: Tue, 10 Nov 2015 12:33:12 -0800
Message-ID: <56425488.SLn6i9fSHDJufM3u%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34044 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109AbbKJUdM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Nov 2015 15:33:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, gregkh@linuxfoundation.org, stern@rowland.harvard.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: dma: remove external references to dma_supported
has been removed from the -mm tree.  Its filename was
     dma-remove-external-references-to-dma_supported.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: dma: remove external references to dma_supported

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DMA-API.txt       |   13 -------------
 drivers/usb/host/ehci-hcd.c     |    2 +-
 drivers/usb/host/fotg210-hcd.c  |    2 +-
 drivers/usb/host/oxu210hp-hcd.c |    2 +-
 4 files changed, 3 insertions(+), 16 deletions(-)

diff -puN Documentation/DMA-API.txt~dma-remove-external-references-to-dma_supported Documentation/DMA-API.txt
--- a/Documentation/DMA-API.txt~dma-remove-external-references-to-dma_supported
+++ a/Documentation/DMA-API.txt
@@ -142,19 +142,6 @@ Part Ic - DMA addressing limitations
 ------------------------------------
 
 int
-dma_supported(struct device *dev, u64 mask)
-
-Checks to see if the device can support DMA to the memory described by
-mask.
-
-Returns: 1 if it can and 0 if it can't.
-
-Notes: This routine merely tests to see if the mask is possible.  It
-won't change the current mask settings.  It is more intended as an
-internal API for use by the platform than an external API for use by
-driver writers.
-
-int
 dma_set_mask_and_coherent(struct device *dev, u64 mask)
 
 Checks to see if the mask is possible and updates the device
diff -puN drivers/usb/host/ehci-hcd.c~dma-remove-external-references-to-dma_supported drivers/usb/host/ehci-hcd.c
--- a/drivers/usb/host/ehci-hcd.c~dma-remove-external-references-to-dma_supported
+++ a/drivers/usb/host/ehci-hcd.c
@@ -589,7 +589,7 @@ static int ehci_run (struct usb_hcd *hcd
 	 * streaming mappings for I/O buffers, like pci_map_single(),
 	 * can return segments above 4GB, if the device allows.
 	 *
-	 * NOTE:  the dma mask is visible through dma_supported(), so
+	 * NOTE:  the dma mask is visible through dev->dma_mask, so
 	 * drivers can pass this info along ... like NETIF_F_HIGHDMA,
 	 * Scsi_Host.highmem_io, and so forth.  It's readonly to all
 	 * host side drivers though.
diff -puN drivers/usb/host/fotg210-hcd.c~dma-remove-external-references-to-dma_supported drivers/usb/host/fotg210-hcd.c
--- a/drivers/usb/host/fotg210-hcd.c~dma-remove-external-references-to-dma_supported
+++ a/drivers/usb/host/fotg210-hcd.c
@@ -5063,7 +5063,7 @@ static int fotg210_run(struct usb_hcd *h
 	 * streaming mappings for I/O buffers, like pci_map_single(),
 	 * can return segments above 4GB, if the device allows.
 	 *
-	 * NOTE:  the dma mask is visible through dma_supported(), so
+	 * NOTE:  the dma mask is visible through dev->dma_mask, so
 	 * drivers can pass this info along ... like NETIF_F_HIGHDMA,
 	 * Scsi_Host.highmem_io, and so forth.  It's readonly to all
 	 * host side drivers though.
diff -puN drivers/usb/host/oxu210hp-hcd.c~dma-remove-external-references-to-dma_supported drivers/usb/host/oxu210hp-hcd.c
--- a/drivers/usb/host/oxu210hp-hcd.c~dma-remove-external-references-to-dma_supported
+++ a/drivers/usb/host/oxu210hp-hcd.c
@@ -2721,7 +2721,7 @@ static int oxu_run(struct usb_hcd *hcd)
 	 * streaming mappings for I/O buffers, like pci_map_single(),
 	 * can return segments above 4GB, if the device allows.
 	 *
-	 * NOTE:  the dma mask is visible through dma_supported(), so
+	 * NOTE:  the dma mask is visible through dev->dma_mask, so
 	 * drivers can pass this info along ... like NETIF_F_HIGHDMA,
 	 * Scsi_Host.highmem_io, and so forth.  It's readonly to all
 	 * host side drivers though.
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
nouveau-dont-call-pci_dma_supported.patch
sfc-dont-call-dma_supported.patch
kaweth-remove-ifdefed-out-call-to-dma_supported.patch
usbnet-remove-ifdefed-out-call-to-dma_supported.patch
pci-remove-pci_dma_supported.patch

