From: akpm@linux-foundation.org
Subject: [merged] usbnet-remove-ifdefed-out-call-to-dma_supported.patch
 removed from -mm tree
Date: Wed, 11 Nov 2015 11:48:37 -0800
Message-ID: <56439b95.eESwv04yd7PILbk2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55475 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752416AbbKKTsh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Nov 2015 14:48:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, oneukum@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: usbnet: remove ifdefed out call to dma_supported
has been removed from the -mm tree.  Its filename was
     usbnet-remove-ifdefed-out-call-to-dma_supported.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


