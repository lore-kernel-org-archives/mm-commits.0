From: akpm@linux-foundation.org
Subject: + saa7164-use-pci_set_dma_mask-insted-of-pci_dma_supported.patch
 added to -mm tree
Date: Mon, 05 Oct 2015 14:29:10 -0700
Message-ID: <5612eba6.DsxC6ZH31/MExR2e%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42805 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241AbbJEV3L (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Oct 2015 17:29:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, hverkuil@xs4all.nl, mchehab@osg.samsung.com, stoth@kernellabs.com, mm-commits@vger.kernel.org


The patch titled
     Subject: saa7164: use pci_set_dma_mask insted of pci_dma_supported
has been added to the -mm tree.  Its filename is
     saa7164-use-pci_set_dma_mask-insted-of-pci_dma_supported.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/saa7164-use-pci_set_dma_mask-insted-of-pci_dma_supported.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/saa7164-use-pci_set_dma_mask-insted-of-pci_dma_supported.patch

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
Subject: saa7164: use pci_set_dma_mask insted of pci_dma_supported

This ensures the dma mask that is supported by the driver is recorded
in the device structure.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Steven Toth <stoth@kernellabs.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/pci/saa7164/saa7164-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/media/pci/saa7164/saa7164-core.c~saa7164-use-pci_set_dma_mask-insted-of-pci_dma_supported drivers/media/pci/saa7164/saa7164-core.c
--- a/drivers/media/pci/saa7164/saa7164-core.c~saa7164-use-pci_set_dma_mask-insted-of-pci_dma_supported
+++ a/drivers/media/pci/saa7164/saa7164-core.c
@@ -1264,7 +1264,7 @@ static int saa7164_initdev(struct pci_de
 
 	pci_set_master(pci_dev);
 	/* TODO */
-	if (!pci_dma_supported(pci_dev, 0xffffffff)) {
+	if (!pci_set_dma_mask(pci_dev, 0xffffffff)) {
 		printk("%s/0: Oops: no 32bit PCI DMA ???\n", dev->name);
 		err = -EIO;
 		goto fail_irq;
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

