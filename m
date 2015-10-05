From: akpm@linux-foundation.org
Subject: + cx88-use-pci_set_dma_mask-insted-of-pci_dma_supported.patch
 added to -mm tree
Date: Mon, 05 Oct 2015 14:29:14 -0700
Message-ID: <5612ebaa.8Vff+AdhSgq9mkD5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42820 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241AbbJEV3P (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Oct 2015 17:29:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, hverkuil@xs4all.nl, mchehab@osg.samsung.com, sakari.ailus@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: cx88: use pci_set_dma_mask insted of pci_dma_supported
has been added to the -mm tree.  Its filename is
     cx88-use-pci_set_dma_mask-insted-of-pci_dma_supported.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/cx88-use-pci_set_dma_mask-insted-of-pci_dma_supported.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/cx88-use-pci_set_dma_mask-insted-of-pci_dma_supported.patch

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
Subject: cx88: use pci_set_dma_mask insted of pci_dma_supported

This ensures the dma mask that is supported by the driver is recorded
in the device structure.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/pci/cx88/cx88-alsa.c  |    2 +-
 drivers/media/pci/cx88/cx88-mpeg.c  |    2 +-
 drivers/media/pci/cx88/cx88-video.c |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/media/pci/cx88/cx88-alsa.c~cx88-use-pci_set_dma_mask-insted-of-pci_dma_supported drivers/media/pci/cx88/cx88-alsa.c
--- a/drivers/media/pci/cx88/cx88-alsa.c~cx88-use-pci_set_dma_mask-insted-of-pci_dma_supported
+++ a/drivers/media/pci/cx88/cx88-alsa.c
@@ -890,7 +890,7 @@ static int snd_cx88_create(struct snd_ca
 		return err;
 	}
 
-	if (!pci_dma_supported(pci,DMA_BIT_MASK(32))) {
+	if (!pci_set_dma_mask(pci,DMA_BIT_MASK(32))) {
 		dprintk(0, "%s/1: Oops: no 32bit PCI DMA ???\n",core->name);
 		err = -EIO;
 		cx88_core_put(core, pci);
diff -puN drivers/media/pci/cx88/cx88-mpeg.c~cx88-use-pci_set_dma_mask-insted-of-pci_dma_supported drivers/media/pci/cx88/cx88-mpeg.c
--- a/drivers/media/pci/cx88/cx88-mpeg.c~cx88-use-pci_set_dma_mask-insted-of-pci_dma_supported
+++ a/drivers/media/pci/cx88/cx88-mpeg.c
@@ -393,7 +393,7 @@ static int cx8802_init_common(struct cx8
 	if (pci_enable_device(dev->pci))
 		return -EIO;
 	pci_set_master(dev->pci);
-	if (!pci_dma_supported(dev->pci,DMA_BIT_MASK(32))) {
+	if (!pci_set_dma_mask(dev->pci,DMA_BIT_MASK(32))) {
 		printk("%s/2: Oops: no 32bit PCI DMA ???\n",dev->core->name);
 		return -EIO;
 	}
diff -puN drivers/media/pci/cx88/cx88-video.c~cx88-use-pci_set_dma_mask-insted-of-pci_dma_supported drivers/media/pci/cx88/cx88-video.c
--- a/drivers/media/pci/cx88/cx88-video.c~cx88-use-pci_set_dma_mask-insted-of-pci_dma_supported
+++ a/drivers/media/pci/cx88/cx88-video.c
@@ -1311,7 +1311,7 @@ static int cx8800_initdev(struct pci_dev
 	       dev->pci_lat,(unsigned long long)pci_resource_start(pci_dev,0));
 
 	pci_set_master(pci_dev);
-	if (!pci_dma_supported(pci_dev,DMA_BIT_MASK(32))) {
+	if (!pci_set_dma_mask(pci_dev,DMA_BIT_MASK(32))) {
 		printk("%s/0: Oops: no 32bit PCI DMA ???\n",core->name);
 		err = -EIO;
 		goto fail_core;
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

