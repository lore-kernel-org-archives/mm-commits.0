From: akpm@linux-foundation.org
Subject: + usbnet-remove-ifdefed-out-call-to-dma_supported.patch added to
 -mm tree
Date: Mon, 05 Oct 2015 14:29:30 -0700
Message-ID: <5612ebba.5bhg4nAtwxoM9dHu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42860 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417AbbJEV3b (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Oct 2015 17:29:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, oneukum@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: usbnet: remove ifdefed out call to dma_supported
has been added to the -mm tree.  Its filename is
     usbnet-remove-ifdefed-out-call-to-dma_supported.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/usbnet-remove-ifdefed-out-call-to-dma_supported.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/usbnet-remove-ifdefed-out-call-to-dma_supported.patch

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
Subject: usbnet: remove ifdefed out call to dma_supported

Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Oliver Neukum <oneukum@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/usb/usbnet.c |    6 ------
 1 file changed, 6 deletions(-)

diff -puN drivers/net/usb/usbnet.c~usbnet-remove-ifdefed-out-call-to-dma_supported drivers/net/usb/usbnet.c
--- a/drivers/net/usb/usbnet.c~usbnet-remove-ifdefed-out-call-to-dma_supported
+++ a/drivers/net/usb/usbnet.c
@@ -1662,12 +1662,6 @@ usbnet_probe (struct usb_interface *udev
 	 * bind() should set rx_urb_size in that case.
 	 */
 	dev->hard_mtu = net->mtu + net->hard_header_len;
-#if 0
-// dma_supported() is deeply broken on almost all architectures
-	// possible with some EHCI controllers
-	if (dma_supported (&udev->dev, DMA_BIT_MASK(64)))
-		net->features |= NETIF_F_HIGHDMA;
-#endif
 
 	net->netdev_ops = &usbnet_netdev_ops;
 	net->watchdog_timeo = TX_TIMEOUT_JIFFIES;
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

