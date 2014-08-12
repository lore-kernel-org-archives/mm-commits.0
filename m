From: akpm@linux-foundation.org
Subject: [merged] media-use-pci_zalloc_consistent.patch removed from -mm
 tree
Date: Tue, 12 Aug 2014 12:42:29 -0700
Message-ID: <53ea6e25.snXk3YqILfn6/YHG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:47287 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754606AbaHLTma (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:42:30 -0400
Received: by mail-yh0-f74.google.com with SMTP id 29so1308911yhl.3
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:42:29 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, hverkuil@xs4all.nl, m.chehab@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: media: use pci_zalloc_consistent
has been removed from the -mm tree.  Its filename was
     media-use-pci_zalloc_consistent.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: media: use pci_zalloc_consistent

Remove the now unnecessary memset too.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/common/saa7146/saa7146_core.c       |   15 ++++-------
 drivers/media/common/saa7146/saa7146_fops.c       |    5 ++-
 drivers/media/pci/bt8xx/bt878.c                   |   16 +++---------
 drivers/media/pci/ngene/ngene-core.c              |    7 ++---
 drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c |   11 ++------
 drivers/media/usb/ttusb-dec/ttusb_dec.c           |   11 ++------
 6 files changed, 22 insertions(+), 43 deletions(-)

diff -puN drivers/media/common/saa7146/saa7146_core.c~media-use-pci_zalloc_consistent drivers/media/common/saa7146/saa7146_core.c
--- a/drivers/media/common/saa7146/saa7146_core.c~media-use-pci_zalloc_consistent
+++ a/drivers/media/common/saa7146/saa7146_core.c
@@ -421,23 +421,20 @@ static int saa7146_init_one(struct pci_d
 	err = -ENOMEM;
 
 	/* get memory for various stuff */
-	dev->d_rps0.cpu_addr = pci_alloc_consistent(pci, SAA7146_RPS_MEM,
-						    &dev->d_rps0.dma_handle);
+	dev->d_rps0.cpu_addr = pci_zalloc_consistent(pci, SAA7146_RPS_MEM,
+						     &dev->d_rps0.dma_handle);
 	if (!dev->d_rps0.cpu_addr)
 		goto err_free_irq;
-	memset(dev->d_rps0.cpu_addr, 0x0, SAA7146_RPS_MEM);
 
-	dev->d_rps1.cpu_addr = pci_alloc_consistent(pci, SAA7146_RPS_MEM,
-						    &dev->d_rps1.dma_handle);
+	dev->d_rps1.cpu_addr = pci_zalloc_consistent(pci, SAA7146_RPS_MEM,
+						     &dev->d_rps1.dma_handle);
 	if (!dev->d_rps1.cpu_addr)
 		goto err_free_rps0;
-	memset(dev->d_rps1.cpu_addr, 0x0, SAA7146_RPS_MEM);
 
-	dev->d_i2c.cpu_addr = pci_alloc_consistent(pci, SAA7146_RPS_MEM,
-						   &dev->d_i2c.dma_handle);
+	dev->d_i2c.cpu_addr = pci_zalloc_consistent(pci, SAA7146_RPS_MEM,
+						    &dev->d_i2c.dma_handle);
 	if (!dev->d_i2c.cpu_addr)
 		goto err_free_rps1;
-	memset(dev->d_i2c.cpu_addr, 0x0, SAA7146_RPS_MEM);
 
 	/* the rest + print status message */
 
diff -puN drivers/media/common/saa7146/saa7146_fops.c~media-use-pci_zalloc_consistent drivers/media/common/saa7146/saa7146_fops.c
--- a/drivers/media/common/saa7146/saa7146_fops.c~media-use-pci_zalloc_consistent
+++ a/drivers/media/common/saa7146/saa7146_fops.c
@@ -520,14 +520,15 @@ int saa7146_vv_init(struct saa7146_dev*
 	   configuration data) */
 	dev->ext_vv_data = ext_vv;
 
-	vv->d_clipping.cpu_addr = pci_alloc_consistent(dev->pci, SAA7146_CLIPPING_MEM, &vv->d_clipping.dma_handle);
+	vv->d_clipping.cpu_addr =
+		pci_zalloc_consistent(dev->pci, SAA7146_CLIPPING_MEM,
+				      &vv->d_clipping.dma_handle);
 	if( NULL == vv->d_clipping.cpu_addr ) {
 		ERR("out of memory. aborting.\n");
 		kfree(vv);
 		v4l2_ctrl_handler_free(hdl);
 		return -1;
 	}
-	memset(vv->d_clipping.cpu_addr, 0x0, SAA7146_CLIPPING_MEM);
 
 	saa7146_video_uops.init(dev,vv);
 	if (dev->ext_vv_data->capabilities & V4L2_CAP_VBI_CAPTURE)
diff -puN drivers/media/pci/bt8xx/bt878.c~media-use-pci_zalloc_consistent drivers/media/pci/bt8xx/bt878.c
--- a/drivers/media/pci/bt8xx/bt878.c~media-use-pci_zalloc_consistent
+++ a/drivers/media/pci/bt8xx/bt878.c
@@ -101,28 +101,20 @@ static int bt878_mem_alloc(struct bt878
 	if (!bt->buf_cpu) {
 		bt->buf_size = 128 * 1024;
 
-		bt->buf_cpu =
-		    pci_alloc_consistent(bt->dev, bt->buf_size,
-					 &bt->buf_dma);
-
+		bt->buf_cpu = pci_zalloc_consistent(bt->dev, bt->buf_size,
+						    &bt->buf_dma);
 		if (!bt->buf_cpu)
 			return -ENOMEM;
-
-		memset(bt->buf_cpu, 0, bt->buf_size);
 	}
 
 	if (!bt->risc_cpu) {
 		bt->risc_size = PAGE_SIZE;
-		bt->risc_cpu =
-		    pci_alloc_consistent(bt->dev, bt->risc_size,
-					 &bt->risc_dma);
-
+		bt->risc_cpu = pci_zalloc_consistent(bt->dev, bt->risc_size,
+						     &bt->risc_dma);
 		if (!bt->risc_cpu) {
 			bt878_mem_free(bt);
 			return -ENOMEM;
 		}
-
-		memset(bt->risc_cpu, 0, bt->risc_size);
 	}
 
 	return 0;
diff -puN drivers/media/pci/ngene/ngene-core.c~media-use-pci_zalloc_consistent drivers/media/pci/ngene/ngene-core.c
--- a/drivers/media/pci/ngene/ngene-core.c~media-use-pci_zalloc_consistent
+++ a/drivers/media/pci/ngene/ngene-core.c
@@ -1075,12 +1075,11 @@ static int AllocCommonBuffers(struct nge
 	dev->ngenetohost = dev->FWInterfaceBuffer + 256;
 	dev->EventBuffer = dev->FWInterfaceBuffer + 512;
 
-	dev->OverflowBuffer = pci_alloc_consistent(dev->pci_dev,
-						   OVERFLOW_BUFFER_SIZE,
-						   &dev->PAOverflowBuffer);
+	dev->OverflowBuffer = pci_zalloc_consistent(dev->pci_dev,
+						    OVERFLOW_BUFFER_SIZE,
+						    &dev->PAOverflowBuffer);
 	if (!dev->OverflowBuffer)
 		return -ENOMEM;
-	memset(dev->OverflowBuffer, 0, OVERFLOW_BUFFER_SIZE);
 
 	for (i = STREAM_VIDEOIN1; i < MAX_STREAM; i++) {
 		int type = dev->card_info->io_type[i];
diff -puN drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c~media-use-pci_zalloc_consistent drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c
--- a/drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c~media-use-pci_zalloc_consistent
+++ a/drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c
@@ -803,11 +803,9 @@ static int ttusb_alloc_iso_urbs(struct t
 {
 	int i;
 
-	ttusb->iso_buffer = pci_alloc_consistent(NULL,
-						 ISO_FRAME_SIZE *
-						 FRAMES_PER_ISO_BUF *
-						 ISO_BUF_COUNT,
-						 &ttusb->iso_dma_handle);
+	ttusb->iso_buffer = pci_zalloc_consistent(NULL,
+						  ISO_FRAME_SIZE * FRAMES_PER_ISO_BUF * ISO_BUF_COUNT,
+						  &ttusb->iso_dma_handle);
 
 	if (!ttusb->iso_buffer) {
 		dprintk("%s: pci_alloc_consistent - not enough memory\n",
@@ -815,9 +813,6 @@ static int ttusb_alloc_iso_urbs(struct t
 		return -ENOMEM;
 	}
 
-	memset(ttusb->iso_buffer, 0,
-	       ISO_FRAME_SIZE * FRAMES_PER_ISO_BUF * ISO_BUF_COUNT);
-
 	for (i = 0; i < ISO_BUF_COUNT; i++) {
 		struct urb *urb;
 
diff -puN drivers/media/usb/ttusb-dec/ttusb_dec.c~media-use-pci_zalloc_consistent drivers/media/usb/ttusb-dec/ttusb_dec.c
--- a/drivers/media/usb/ttusb-dec/ttusb_dec.c~media-use-pci_zalloc_consistent
+++ a/drivers/media/usb/ttusb-dec/ttusb_dec.c
@@ -1151,11 +1151,9 @@ static int ttusb_dec_alloc_iso_urbs(stru
 
 	dprintk("%s\n", __func__);
 
-	dec->iso_buffer = pci_alloc_consistent(NULL,
-					       ISO_FRAME_SIZE *
-					       (FRAMES_PER_ISO_BUF *
-						ISO_BUF_COUNT),
-					       &dec->iso_dma_handle);
+	dec->iso_buffer = pci_zalloc_consistent(NULL,
+						ISO_FRAME_SIZE * (FRAMES_PER_ISO_BUF * ISO_BUF_COUNT),
+						&dec->iso_dma_handle);
 
 	if (!dec->iso_buffer) {
 		dprintk("%s: pci_alloc_consistent - not enough memory\n",
@@ -1163,9 +1161,6 @@ static int ttusb_dec_alloc_iso_urbs(stru
 		return -ENOMEM;
 	}
 
-	memset(dec->iso_buffer, 0,
-	       ISO_FRAME_SIZE * (FRAMES_PER_ISO_BUF * ISO_BUF_COUNT));
