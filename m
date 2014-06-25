From: akpm@linux-foundation.org
Subject: + media-use-pci_zalloc_consistent.patch added to -mm tree
Date: Wed, 25 Jun 2014 12:30:11 -0700
Message-ID: <53ab2343.C3Waf1P15tq7A4Py%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46885 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754072AbaFYTaM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 25 Jun 2014 15:30:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, hverkuil@xs4all.nl, m.chehab@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: media: use pci_zalloc_consistent
has been added to the -mm tree.  Its filename is
     media-use-pci_zalloc_consistent.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/media-use-pci_zalloc_consistent.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/media-use-pci_zalloc_consistent.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1078,12 +1078,11 @@ static int AllocCommonBuffers(struct nge
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
@@ -804,11 +804,9 @@ static int ttusb_alloc_iso_urbs(struct t
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
@@ -816,9 +814,6 @@ static int ttusb_alloc_iso_urbs(struct t
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
-
 	for (i = 0; i < ISO_BUF_COUNT; i++) {
 		struct urb *urb;
 
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
checkpatch-check-git-commit-descriptions.patch
fs-squashfs-file_directc-replace-countsize-kmalloc-by-kmalloc_array.patch
printk-make-dynamic-kernel-ring-buffer-alignment-explicit.patch
printk-move-power-of-2-practice-of-ring-buffer-size-to-a-helper.patch
printk-make-dynamic-units-clear-for-the-kernel-ring-buffer.patch
printk-allow-increasing-the-ring-buffer-depending-on-the-number-of-cpus.patch
mm-utilc-add-kstrimdup.patch
kernelh-remove-deprecated-pack_hex_byte.patch
checkpatch-attempt-to-find-unnecessary-out-of-memory-messages.patch
checkpatch-warn-on-unnecessary-else-after-return-or-break.patch
checkpatch-fix-complex-macro-false-positive-for-escaped-constant-char.patch
checkpatch-fix-function-pointers-in-blank-line-needed-after-declarations-test.patch
checkpatch-ignore-email-headers-better.patch
checkpatchpl-also-suggest-else-if-when-if-follows-brace.patch
checkpatch-add-test-for-blank-lines-after-function-struct-union-enum.patch
checkpatch-add-a-multiple-blank-lines-test.patch
checkpatch-change-blank-line-after-declaration-type-to-line_spacing.patch
checkpatch-quiet-kconfig-help-message-checking.patch
fs-isofs-logging-clean-up.patch
sysctl-remove-now-unused-typedef-ctl_table.patch
sysctl-remove-now-unused-typedef-ctl_table-fix.patch
fs-qnx6-convert-printk-to-pr_foo.patch
fs-qnx6-use-pr_fmt-and-__func__-in-logging.patch
fs-qnx6-update-debugging-to-current-functions.patch
linux-next.patch
pci-dma-compat-add-pci_zalloc_consistent-helper.patch
atm-use-pci_zalloc_consistent.patch
block-use-pci_zalloc_consistent.patch
crypto-use-pci_zalloc_consistent.patch
infiniband-use-pci_zalloc_consistent.patch
i810-use-pci_zalloc_consistent.patch
media-use-pci_zalloc_consistent.patch
amd-use-pci_zalloc_consistent.patch
atl1e-use-pci_zalloc_consistent.patch
enic-use-pci_zalloc_consistent.patch
sky2-use-pci_zalloc_consistent.patch
micrel-use-pci_zalloc_consistent.patch
qlogic-use-pci_zalloc_consistent.patch
irda-use-pci_zalloc_consistent.patch
ipw2100-use-pci_zalloc_consistent.patch
mwl8k-use-pci_zalloc_consistent.patch
rtl818x-use-pci_zalloc_consistent.patch
rtlwifi-use-pci_zalloc_consistent.patch
scsi-use-pci_zalloc_consistent.patch
staging-use-pci_zalloc_consistent.patch
synclink_gt-use-pci_zalloc_consistent.patch
vme-bridges-use-pci_zalloc_consistent.patch
amd-neaten-and-remove-unnecessary-oom-messages.patch

