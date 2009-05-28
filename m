From: akpm@linux-foundation.org
Subject: + vino-replace-dma_sync_single-with-dma_sync_single_for_cpu.patch added to -mm tree
Date: Wed, 27 May 2009 22:35:31 -0700
Message-ID: <200905280535.n4S5ZVdx031986@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54917 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758000AbZE1Ffl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 May 2009 01:35:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp, mchehab@infradead.org


The patch titled
     vino: replace dma_sync_single with dma_sync_single_for_cpu
has been added to the -mm tree.  Its filename is
     vino-replace-dma_sync_single-with-dma_sync_single_for_cpu.patch

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
Subject: vino: replace dma_sync_single with dma_sync_single_for_cpu
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

This replaces dma_sync_single() with dma_sync_single_for_cpu() because
dma_sync_single() is an obsolete API; include/linux/dma-mapping.h says:

/* Backwards compat, remove in 2.7.x */
#define dma_sync_single		dma_sync_single_for_cpu
#define dma_sync_sg		dma_sync_sg_for_cpu

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/vino.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/media/video/vino.c~vino-replace-dma_sync_single-with-dma_sync_single_for_cpu drivers/media/video/vino.c
--- a/drivers/media/video/vino.c~vino-replace-dma_sync_single-with-dma_sync_single_for_cpu
+++ a/drivers/media/video/vino.c
@@ -868,9 +868,9 @@ static void vino_sync_buffer(struct vino
 	dprintk("vino_sync_buffer():\n");
 
 	for (i = 0; i < fb->desc_table.page_count; i++)
-		dma_sync_single(NULL,
-				fb->desc_table.dma_cpu[VINO_PAGE_RATIO * i],
-				PAGE_SIZE, DMA_FROM_DEVICE);
+		dma_sync_single_for_cpu(NULL,
+					fb->desc_table.dma_cpu[VINO_PAGE_RATIO * i],
+					PAGE_SIZE, DMA_FROM_DEVICE);
 }
 
 /* Framebuffer fifo functions (need to be locked externally) */
_

Patches currently in -mm which might be from fujita.tomonori@lab.ntt.co.jp are

linux-next.patch
sg_io-dont-perform-unneeded-copy-in-compat-code.patch
dma-mapping-mark-dma_nbits_mask-as-deprecated.patch
net-replace-dma_sync_single-with-dma_sync_single_for_cpu.patch
vino-replace-dma_sync_single-with-dma_sync_single_for_cpu.patch
ib-mthca-replace-dma_sync_single-with-dma_sync_single_for_cpu.patch
usb-replace-dma_sync_single-and-dma_sync_sg-with-dma_sync_single_for_cpu-and-dma_sync_sg_for_cpu.patch

