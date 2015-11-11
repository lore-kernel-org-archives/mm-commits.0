From: akpm@linux-foundation.org
Subject: [merged]
 cx88-use-pci_set_dma_mask-insted-of-pci_dma_supported.patch removed from
 -mm tree
Date: Wed, 11 Nov 2015 11:48:22 -0800
Message-ID: <56439b86.1052tknonrASlGbB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55444 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509AbbKKTsW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Nov 2015 14:48:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, hverkuil@xs4all.nl, mchehab@osg.samsung.com, sakari.ailus@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: cx88: use pci_set_dma_mask insted of pci_dma_supported
has been removed from the -mm tree.  Its filename was
     cx88-use-pci_set_dma_mask-insted-of-pci_dma_supported.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -1314,7 +1314,7 @@ static int cx8800_initdev(struct pci_dev
 	       dev->pci_lat,(unsigned long long)pci_resource_start(pci_dev,0));
 
 	pci_set_master(pci_dev);
-	if (!pci_dma_supported(pci_dev,DMA_BIT_MASK(32))) {
+	if (!pci_set_dma_mask(pci_dev,DMA_BIT_MASK(32))) {
 		printk("%s/0: Oops: no 32bit PCI DMA ???\n",core->name);
 		err = -EIO;
 		goto fail_core;
_

Patches currently in -mm which might be from hch@lst.de are


