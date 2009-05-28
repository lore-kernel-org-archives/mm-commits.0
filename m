From: akpm@linux-foundation.org
Subject: + usb-replace-dma_sync_single-and-dma_sync_sg-with-dma_sync_single_for_cpu-and-dma_sync_sg_for_cpu.patch added to -mm tree
Date: Wed, 27 May 2009 22:35:35 -0700
Message-ID: <200905280535.n4S5ZZWk032026@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49691 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756723AbZE1Ffg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 May 2009 01:35:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp, greg@kroah.com


The patch titled
     usb: replace dma_sync_single and dma_sync_sg with dma_sync_single_for_cpu and dma_sync_sg_for_cpu
has been added to the -mm tree.  Its filename is
     usb-replace-dma_sync_single-and-dma_sync_sg-with-dma_sync_single_for_cpu-and-dma_sync_sg_for_cpu.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
sg_io-dont-perform-unneeded-copy-in-compat-code.patch
dma-mapping-mark-dma_nbits_mask-as-deprecated.patch
net-replace-dma_sync_single-with-dma_sync_single_for_cpu.patch
vino-replace-dma_sync_single-with-dma_sync_single_for_cpu.patch
ib-mthca-replace-dma_sync_single-with-dma_sync_single_for_cpu.patch
usb-replace-dma_sync_single-and-dma_sync_sg-with-dma_sync_single_for_cpu-and-dma_sync_sg_for_cpu.patch

