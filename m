From: akpm@linux-foundation.org
Subject: [merged] usb-replace-dma_sync_single-and-dma_sync_sg-with-dma_sync_single_for_cpu-and-dma_sync_sg_for_cpu.patch removed from -mm tree
Date: Wed, 03 Jun 2009 13:02:29 -0700
Message-ID: <200906032002.n53K2TBu001827@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34128 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753965AbZFCUCb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Jun 2009 16:02:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fujita.tomonori@lab.ntt.co.jp, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     usb: replace dma_sync_single and dma_sync_sg with dma_sync_single_for_cpu and dma_sync_sg_for_cpu
has been removed from the -mm tree.  Its filename was
     usb-replace-dma_sync_single-and-dma_sync_sg-with-dma_sync_single_for_cpu-and-dma_sync_sg_for_cpu.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: usb: replace dma_sync_single and dma_sync_sg with dma_sync_single_for_cpu and dma_sync_sg_for_cpu
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

This replaces dma_sync_single() and dma_sync_sg() with
dma_sync_single_for_cpu() and dma_sync_sg_for_cpu() respectively because
they is an obsolete API; include/linux/dma-mapping.h says:

/* Backwards compat, remove in 2.7.x */
#define dma_sync_single		dma_sync_single_for_cpu
#define dma_sync_sg		dma_sync_sg_for_cpu

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/core/usb.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/usb/core/usb.c~usb-replace-dma_sync_single-and-dma_sync_sg-with-dma_sync_single_for_cpu-and-dma_sync_sg_for_cpu drivers/usb/core/usb.c
--- a/drivers/usb/core/usb.c~usb-replace-dma_sync_single-and-dma_sync_sg-with-dma_sync_single_for_cpu-and-dma_sync_sg_for_cpu
+++ a/drivers/usb/core/usb.c
@@ -829,12 +829,12 @@ void usb_buffer_dmasync(struct urb *urb)
 		return;
 
 	if (controller->dma_mask) {
-		dma_sync_single(controller,
+		dma_sync_single_for_cpu(controller,
 			urb->transfer_dma, urb->transfer_buffer_length,
 			usb_pipein(urb->pipe)
 				? DMA_FROM_DEVICE : DMA_TO_DEVICE);
 		if (usb_pipecontrol(urb->pipe))
-			dma_sync_single(controller,
+			dma_sync_single_for_cpu(controller,
 					urb->setup_dma,
 					sizeof(struct usb_ctrlrequest),
 					DMA_TO_DEVICE);
@@ -952,8 +952,8 @@ void usb_buffer_dmasync_sg(const struct 
 			|| !controller->dma_mask)
 		return;
 
-	dma_sync_sg(controller, sg, n_hw_ents,
-			is_in ? DMA_FROM_DEVICE : DMA_TO_DEVICE);
+	dma_sync_sg_for_cpu(controller, sg, n_hw_ents,
+			    is_in ? DMA_FROM_DEVICE : DMA_TO_DEVICE);
 }
 EXPORT_SYMBOL_GPL(usb_buffer_dmasync_sg);
 #endif
_

Patches currently in -mm which might be from fujita.tomonori@lab.ntt.co.jp are

linux-next.patch
vino-replace-dma_sync_single-with-dma_sync_single_for_cpu.patch
ib-mthca-replace-dma_sync_single-with-dma_sync_single_for_cpu.patch
sg_io-dont-perform-unneeded-copy-in-compat-code.patch
sparc-move-the-duplication-in-dma-mapping_3264h-to-dma-mappingh.patch
sparc-add-sync_single_for_device-and-sync_sg_for_device-to-struct-dma_ops.patch
sparc-use-dma_map_page-instead-of-dma_map_single.patch
sparc-remove-dma-mapping_3264h.patch
dma-mapping-mark-dma_nbits_mask-as-deprecated.patch
dma-mapping-mark-dma_sync_single-and-dma_sync_sg-as-deprecated.patch
dma-mapping-add-asm-generic-dma-mapping-commonh.patch
dma-mapping-x86-use-asm-generic-dma-mapping-commonh.patch
dma-mapping-ia64-use-asm-generic-dma-mapping-commonh.patch
dma-mapping-ia64-add-config_dma_api_debug-support.patch
dma-mapping-dma-debug-fix-compiler-warnings-on-ia64.patch

