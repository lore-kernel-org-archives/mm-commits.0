From: akpm@linux-foundation.org
Subject: + txx9dmac-use-dma_unmap_single-if-dma_compl_srcdest_unmap_single-was-set.patch added to -mm tree
Date: Thu, 28 May 2009 00:09:02 -0700
Message-ID: <200905280709.n4S792tp032677@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50303 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751728AbZE1HJV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 May 2009 03:09:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: anemo@mba.ocn.ne.jp, dan.j.williams@intel.com, ralf@linux-mips.org


The patch titled
     txx9dmac: use dma_unmap_single if DMA_COMPL_{SRC,DEST}_UNMAP_SINGLE was set
has been added to the -mm tree.  Its filename is
     txx9dmac-use-dma_unmap_single-if-dma_compl_srcdest_unmap_single-was-set.patch

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
Subject: txx9dmac: use dma_unmap_single if DMA_COMPL_{SRC,DEST}_UNMAP_SINGLE was set
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

This patch does not change actual behaviour since dma_unmap_page is just
an alias of dma_unmap_single on MIPS.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dma/txx9dmac.c |   20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff -puN drivers/dma/txx9dmac.c~txx9dmac-use-dma_unmap_single-if-dma_compl_srcdest_unmap_single-was-set drivers/dma/txx9dmac.c
--- a/drivers/dma/txx9dmac.c~txx9dmac-use-dma_unmap_single-if-dma_compl_srcdest_unmap_single-was-set
+++ a/drivers/dma/txx9dmac.c
@@ -432,23 +432,27 @@ txx9dmac_descriptor_complete(struct txx9
 	list_splice_init(&txd->tx_list, &dc->free_list);
 	list_move(&desc->desc_node, &dc->free_list);
 
-	/*
-	 * We use dma_unmap_page() regardless of how the buffers were
-	 * mapped before they were submitted...
-	 */
 	if (!ds) {
 		dma_addr_t dmaaddr;
 		if (!(txd->flags & DMA_COMPL_SKIP_DEST_UNMAP)) {
 			dmaaddr = is_dmac64(dc) ?
 				desc->hwdesc.DAR : desc->hwdesc32.DAR;
-			dma_unmap_page(chan2parent(&dc->chan), dmaaddr,
-				       desc->len, DMA_FROM_DEVICE);
+			if (txd->flags & DMA_COMPL_DEST_UNMAP_SINGLE)
+				dma_unmap_single(chan2parent(&dc->chan),
+					dmaaddr, desc->len, DMA_FROM_DEVICE);
+			else
+				dma_unmap_page(chan2parent(&dc->chan),
+					dmaaddr, desc->len, DMA_FROM_DEVICE);
 		}
 		if (!(txd->flags & DMA_COMPL_SKIP_SRC_UNMAP)) {
 			dmaaddr = is_dmac64(dc) ?
 				desc->hwdesc.SAR : desc->hwdesc32.SAR;
-			dma_unmap_page(chan2parent(&dc->chan), dmaaddr,
-				       desc->len, DMA_TO_DEVICE);
+			if (txd->flags & DMA_COMPL_SRC_UNMAP_SINGLE)
+				dma_unmap_single(chan2parent(&dc->chan),
+					dmaaddr, desc->len, DMA_TO_DEVICE);
+			else
+				dma_unmap_page(chan2parent(&dc->chan),
+					dmaaddr, desc->len, DMA_TO_DEVICE);
 		}
 	}
 
_

Patches currently in -mm which might be from anemo@mba.ocn.ne.jp are

linux-next.patch
txx9dmac-use-dma_unmap_single-if-dma_compl_srcdest_unmap_single-was-set.patch
kgdb-kgdboc-console-poll-hooks-for-serial_txx9-uart.patch
serial_txx9-use-container_of-instead-of-direct-cast.patch
rtc-rtc-ds1742-nvram-attribute-fix.patch
rtc-tx4939-drop-irqf_shared.patch
rtc-ds1553-drop-irqf_shared.patch
rtc-make-rtc_update_irq-callable-with-irqs-enabled-v2.patch

