From: akpm@linux-foundation.org
Subject: [merged]
 pcnet32-use-pci_set_dma_mask-insted-of-pci_dma_supported.patch removed from -mm tree
Date: Wed, 11 Nov 2015 11:48:13 -0800
Message-ID: <56439b7d.fJpdltY7wZeH1LiC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55417 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752046AbbKKTsP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Nov 2015 14:48:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, acourbot@nvidia.com, airlied@linux.ie, airlied@redhat.com, bskeggs@redhat.com, daniel.vetter@ffwll.ch, davem@davemloft.net, deller@gmx.de, gregkh@linuxfoundation.org, hverkuil@xs4all.nl, jejb@parisc-linux.org, jslaby@suse.com, khoroshilov@ispras.ru, linux-net-drivers@solarflare.com, mchehab@osg.samsung.com, pawel@osciak.com, pcnet32@frontier.com, sakari.ailus@linux.intel.com, serjk@netup.ru, sshah@solarflare.com, stern@rowland.harvard.edu, stoth@kernellabs.com, treding@nvidia.com, mm-commits@vger.kernel.org


The patch titled
     Subject: pcnet32: use pci_set_dma_mask insted of pci_dma_supported
has been removed from the -mm tree.  Its filename was
     pcnet32-use-pci_set_dma_mask-insted-of-pci_dma_supported.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: pcnet32: use pci_set_dma_mask insted of pci_dma_supported

All drivers should be using dma_set_mask / pci_set_dma_mask to try
to set the dma mask instead of just querying it.  Without that some
iommu implementations may not work.

pci_dma_supported is removed entirely, but dma_supported stays for
dma_ops implementations for now.

This patch (of 15):

This ensures the dma mask that is supported by the driver is recorded
in the device structure.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Don Fry <pcnet32@frontier.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Alexandre Courbot <acourbot@nvidia.com>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc: Ben Skeggs <bskeggs@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Dave Airlie <airlied@redhat.com>
Cc: David Airlie <airlied@linux.ie>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Helge Deller <deller@gmx.de>
Cc: Jiri Slaby <jslaby@suse.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Pawel Osciak <pawel@osciak.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Sergey Kozlov <serjk@netup.ru>
Cc: Shradha Shah <sshah@solarflare.com>
Cc: Solarflare linux maintainers <linux-net-drivers@solarflare.com>
Cc: Steven Toth <stoth@kernellabs.com>
Cc: Thierry Reding <treding@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ethernet/amd/pcnet32.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/ethernet/amd/pcnet32.c~pcnet32-use-pci_set_dma_mask-insted-of-pci_dma_supported drivers/net/ethernet/amd/pcnet32.c
--- a/drivers/net/ethernet/amd/pcnet32.c~pcnet32-use-pci_set_dma_mask-insted-of-pci_dma_supported
+++ a/drivers/net/ethernet/amd/pcnet32.c
@@ -1500,7 +1500,7 @@ pcnet32_probe_pci(struct pci_dev *pdev,
 		return -ENODEV;
 	}
 
-	if (!pci_dma_supported(pdev, PCNET32_DMA_MASK)) {
+	if (!pci_set_dma_mask(pdev, PCNET32_DMA_MASK)) {
 		if (pcnet32_debug & NETIF_MSG_PROBE)
 			pr_err("architecture does not support 32bit PCI busmaster DMA\n");
 		return -ENODEV;
_

Patches currently in -mm which might be from hch@lst.de are


