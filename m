From: akpm@linux-foundation.org
Subject: + various-fix-pci_set_dma_mask-return-value-checking.patch added
 to -mm tree
Date: Tue, 17 Nov 2015 14:47:17 -0800
Message-ID: <564bae75.ptMjYGNrFXf6kc3H%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47160 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163AbbKQWrS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Nov 2015 17:47:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, crope@iki.fi, hverkuil@xs4all.nl, jongman.heo@samsung.com, mchehab@osg.samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: various: fix pci_set_dma_mask return value checking
has been added to the -mm tree.  Its filename is
     various-fix-pci_set_dma_mask-return-value-checking.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/various-fix-pci_set_dma_mask-return-value-checking.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/various-fix-pci_set_dma_mask-return-value-checking.patch

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
Subject: various: fix pci_set_dma_mask return value checking

pci_set_dma_mask returns a negative errno value, not a bool like
pci_dma_supported.  This of course was just a giant test for attention :)

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reported-by: Jongman Heo <jongman.heo@samsung.com>
Tested-by: Jongman Heo <jongman.heo@samsung.com>	[pcnet32]
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Antti Palosaari <crope@iki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/pci/cx23885/cx23885-core.c           |    4 ++--
 drivers/media/pci/cx25821/cx25821-core.c           |    3 ++-
 drivers/media/pci/cx88/cx88-alsa.c                 |    4 ++--
 drivers/media/pci/cx88/cx88-mpeg.c                 |    3 ++-
 drivers/media/pci/cx88/cx88-video.c                |    4 ++--
 drivers/media/pci/netup_unidvb/netup_unidvb_core.c |    2 +-
 drivers/media/pci/saa7134/saa7134-core.c           |    4 ++--
 drivers/media/pci/saa7164/saa7164-core.c           |    4 ++--
 drivers/media/pci/tw68/tw68-core.c                 |    4 ++--
 drivers/net/ethernet/amd/pcnet32.c                 |    5 +++--
 10 files changed, 20 insertions(+), 17 deletions(-)

diff -puN drivers/media/pci/cx23885/cx23885-core.c~various-fix-pci_set_dma_mask-return-value-checking drivers/media/pci/cx23885/cx23885-core.c
--- a/drivers/media/pci/cx23885/cx23885-core.c~various-fix-pci_set_dma_mask-return-value-checking
+++ a/drivers/media/pci/cx23885/cx23885-core.c
@@ -1992,9 +1992,9 @@ static int cx23885_initdev(struct pci_de
 		(unsigned long long)pci_resource_start(pci_dev, 0));
 
 	pci_set_master(pci_dev);
-	if (!pci_set_dma_mask(pci_dev, 0xffffffff)) {
+	err = pci_set_dma_mask(pci_dev, 0xffffffff);
+	if (err) {
 		printk("%s/0: Oops: no 32bit PCI DMA ???\n", dev->name);
-		err = -EIO;
 		goto fail_context;
 	}
 
diff -puN drivers/media/pci/cx25821/cx25821-core.c~various-fix-pci_set_dma_mask-return-value-checking drivers/media/pci/cx25821/cx25821-core.c
--- a/drivers/media/pci/cx25821/cx25821-core.c~various-fix-pci_set_dma_mask-return-value-checking
+++ a/drivers/media/pci/cx25821/cx25821-core.c
@@ -1319,7 +1319,8 @@ static int cx25821_initdev(struct pci_de
 		dev->pci_lat, (unsigned long long)dev->base_io_addr);
 
 	pci_set_master(pci_dev);
-	if (!pci_set_dma_mask(pci_dev, 0xffffffff)) {
+	err = pci_set_dma_mask(pci_dev, 0xffffffff);
+	if (err) {
 		pr_err("%s/0: Oops: no 32bit PCI DMA ???\n", dev->name);
 		err = -EIO;
 		goto fail_irq;
diff -puN drivers/media/pci/cx88/cx88-alsa.c~various-fix-pci_set_dma_mask-return-value-checking drivers/media/pci/cx88/cx88-alsa.c
--- a/drivers/media/pci/cx88/cx88-alsa.c~various-fix-pci_set_dma_mask-return-value-checking
+++ a/drivers/media/pci/cx88/cx88-alsa.c
@@ -890,9 +890,9 @@ static int snd_cx88_create(struct snd_ca
 		return err;
 	}
 
-	if (!pci_set_dma_mask(pci,DMA_BIT_MASK(32))) {
+	err = pci_set_dma_mask(pci,DMA_BIT_MASK(32));
+	if (err) {
 		dprintk(0, "%s/1: Oops: no 32bit PCI DMA ???\n",core->name);
-		err = -EIO;
 		cx88_core_put(core, pci);
 		return err;
 	}
diff -puN drivers/media/pci/cx88/cx88-mpeg.c~various-fix-pci_set_dma_mask-return-value-checking drivers/media/pci/cx88/cx88-mpeg.c
--- a/drivers/media/pci/cx88/cx88-mpeg.c~various-fix-pci_set_dma_mask-return-value-checking
+++ a/drivers/media/pci/cx88/cx88-mpeg.c
@@ -393,7 +393,8 @@ static int cx8802_init_common(struct cx8
 	if (pci_enable_device(dev->pci))
 		return -EIO;
 	pci_set_master(dev->pci);
-	if (!pci_set_dma_mask(dev->pci,DMA_BIT_MASK(32))) {
+	err = pci_set_dma_mask(dev->pci,DMA_BIT_MASK(32));
+	if (err) {
 		printk("%s/2: Oops: no 32bit PCI DMA ???\n",dev->core->name);
 		return -EIO;
 	}
diff -puN drivers/media/pci/cx88/cx88-video.c~various-fix-pci_set_dma_mask-return-value-checking drivers/media/pci/cx88/cx88-video.c
--- a/drivers/media/pci/cx88/cx88-video.c~various-fix-pci_set_dma_mask-return-value-checking
+++ a/drivers/media/pci/cx88/cx88-video.c
@@ -1314,9 +1314,9 @@ static int cx8800_initdev(struct pci_dev
 	       dev->pci_lat,(unsigned long long)pci_resource_start(pci_dev,0));
 
 	pci_set_master(pci_dev);
-	if (!pci_set_dma_mask(pci_dev,DMA_BIT_MASK(32))) {
+	err = pci_set_dma_mask(pci_dev,DMA_BIT_MASK(32));
+	if (err) {
 		printk("%s/0: Oops: no 32bit PCI DMA ???\n",core->name);
-		err = -EIO;
 		goto fail_core;
 	}
 	dev->alloc_ctx = vb2_dma_sg_init_ctx(&pci_dev->dev);
diff -puN drivers/media/pci/netup_unidvb/netup_unidvb_core.c~various-fix-pci_set_dma_mask-return-value-checking drivers/media/pci/netup_unidvb/netup_unidvb_core.c
--- a/drivers/media/pci/netup_unidvb/netup_unidvb_core.c~various-fix-pci_set_dma_mask-return-value-checking
+++ a/drivers/media/pci/netup_unidvb/netup_unidvb_core.c
@@ -810,7 +810,7 @@ static int netup_unidvb_initdev(struct p
 		"%s(): board vendor 0x%x, revision 0x%x\n",
 		__func__, board_vendor, board_revision);
 	pci_set_master(pci_dev);
-	if (!pci_set_dma_mask(pci_dev, 0xffffffff)) {
+	if (pci_set_dma_mask(pci_dev, 0xffffffff) < 0) {
 		dev_err(&pci_dev->dev,
 			"%s(): 32bit PCI DMA is not supported\n", __func__);
 		goto pci_detect_err;
diff -puN drivers/media/pci/saa7134/saa7134-core.c~various-fix-pci_set_dma_mask-return-value-checking drivers/media/pci/saa7134/saa7134-core.c
--- a/drivers/media/pci/saa7134/saa7134-core.c~various-fix-pci_set_dma_mask-return-value-checking
+++ a/drivers/media/pci/saa7134/saa7134-core.c
@@ -951,9 +951,9 @@ static int saa7134_initdev(struct pci_de
 	       pci_name(pci_dev), dev->pci_rev, pci_dev->irq,
 	       dev->pci_lat,(unsigned long long)pci_resource_start(pci_dev,0));
 	pci_set_master(pci_dev);
-	if (!pci_set_dma_mask(pci_dev, DMA_BIT_MASK(32))) {
+	err = pci_set_dma_mask(pci_dev, DMA_BIT_MASK(32));
+	if (err) {
 		pr_warn("%s: Oops: no 32bit PCI DMA ???\n", dev->name);
-		err = -EIO;
 		goto fail1;
 	}
 
diff -puN drivers/media/pci/saa7164/saa7164-core.c~various-fix-pci_set_dma_mask-return-value-checking drivers/media/pci/saa7164/saa7164-core.c
--- a/drivers/media/pci/saa7164/saa7164-core.c~various-fix-pci_set_dma_mask-return-value-checking
+++ a/drivers/media/pci/saa7164/saa7164-core.c
@@ -1264,9 +1264,9 @@ static int saa7164_initdev(struct pci_de
 
 	pci_set_master(pci_dev);
 	/* TODO */
-	if (!pci_set_dma_mask(pci_dev, 0xffffffff)) {
+	err = pci_set_dma_mask(pci_dev, 0xffffffff);
+	if (err) {
 		printk("%s/0: Oops: no 32bit PCI DMA ???\n", dev->name);
-		err = -EIO;
 		goto fail_irq;
 	}
 
diff -puN drivers/media/pci/tw68/tw68-core.c~various-fix-pci_set_dma_mask-return-value-checking drivers/media/pci/tw68/tw68-core.c
--- a/drivers/media/pci/tw68/tw68-core.c~various-fix-pci_set_dma_mask-return-value-checking
+++ a/drivers/media/pci/tw68/tw68-core.c
@@ -257,9 +257,9 @@ static int tw68_initdev(struct pci_dev *
 		dev->name, pci_name(pci_dev), dev->pci_rev, pci_dev->irq,
 		dev->pci_lat, (u64)pci_resource_start(pci_dev, 0));
 	pci_set_master(pci_dev);
-	if (!pci_set_dma_mask(pci_dev, DMA_BIT_MASK(32))) {
+	err = pci_set_dma_mask(pci_dev, DMA_BIT_MASK(32));
+	if (err) {
 		pr_info("%s: Oops: no 32bit PCI DMA ???\n", dev->name);
-		err = -EIO;
 		goto fail1;
 	}
 
diff -puN drivers/net/ethernet/amd/pcnet32.c~various-fix-pci_set_dma_mask-return-value-checking drivers/net/ethernet/amd/pcnet32.c
--- a/drivers/net/ethernet/amd/pcnet32.c~various-fix-pci_set_dma_mask-return-value-checking
+++ a/drivers/net/ethernet/amd/pcnet32.c
@@ -1500,10 +1500,11 @@ pcnet32_probe_pci(struct pci_dev *pdev,
 		return -ENODEV;
 	}
 
-	if (!pci_set_dma_mask(pdev, PCNET32_DMA_MASK)) {
+	err = pci_set_dma_mask(pdev, PCNET32_DMA_MASK);
+	if (err) {
 		if (pcnet32_debug & NETIF_MSG_PROBE)
 			pr_err("architecture does not support 32bit PCI busmaster DMA\n");
-		return -ENODEV;
+		return err;
 	}
 	if (!request_region(ioaddr, PCNET32_TOTAL_SIZE, "pcnet32_probe_pci")) {
 		if (pcnet32_debug & NETIF_MSG_PROBE)
_

Patches currently in -mm which might be from hch@lst.de are

various-fix-pci_set_dma_mask-return-value-checking.patch
dma-mapping-make-the-generic-coherent-dma-mmap-implementation-optional.patch
arc-convert-to-dma_map_ops.patch
avr32-convert-to-dma_map_ops.patch
blackfin-convert-to-dma_map_ops.patch
c6x-convert-to-dma_map_ops.patch
cris-convert-to-dma_map_ops.patch
nios2-convert-to-dma_map_ops.patch
frv-convert-to-dma_map_ops.patch
parisc-convert-to-dma_map_ops.patch
mn10300-convert-to-dma_map_ops.patch
m68k-convert-to-dma_map_ops.patch
metag-convert-to-dma_map_ops.patch
sparc-use-generic-dma_set_mask.patch
tile-uninline-dma_set_mask.patch
dma-mapping-always-provide-the-dma_map_ops-based-implementation.patch
dma-mapping-remove-asm-generic-dma-coherenth.patch

