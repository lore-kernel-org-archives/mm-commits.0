From: akpm@linux-foundation.org
Subject: + pcnet32-use-pci_set_dma_mask-insted-of-pci_dma_supported.patch
 added to -mm tree
Date: Mon, 05 Oct 2015 14:29:05 -0700
Message-ID: <5612eba1.43i0ymFd9ilcQlc0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42784 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241AbbJEV3H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Oct 2015 17:29:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, acourbot@nvidia.com, airlied@linux.ie, airlied@redhat.com, bskeggs@redhat.com, daniel.vetter@ffwll.ch, davem@davemloft.net, deller@gmx.de, gregkh@linuxfoundation.org, hans.verkuil@cisco.com, hverkuil@xs4all.nl, jejb@parisc-linux.org, jslaby@suse.com, khoroshilov@ispras.ru, linux-net-drivers@solarflare.com, mchehab@osg.samsung.com, pawel@osciak.com, sakari.ailus@linux.intel.com, serjk@netup.ru, sshah@solarflare.com, stern@rowland.harvard.edu, stoth@kernellabs.com, treding@nvidia.com, mm-commits@vger.kernel.org


The patch titled
     Subject: pcnet32: use pci_set_dma_mask insted of pci_dma_supported
has been added to the -mm tree.  Its filename is
     pcnet32-use-pci_set_dma_mask-insted-of-pci_dma_supported.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/pcnet32-use-pci_set_dma_mask-insted-of-pci_dma_supported.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/pcnet32-use-pci_set_dma_mask-insted-of-pci_dma_supported.patch

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
Cc: Hans Verkuil <hans.verkuil@cisco.com>
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

