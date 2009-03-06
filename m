From: akpm@linux-foundation.org
Subject: [merged] libata-fix-dma_unmap_sg-misuse.patch removed from -mm tree
Date: Fri, 06 Mar 2009 11:28:21 -0800
Message-ID: <200903061928.n26JSLpn022754@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52154 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755358AbZCFT3I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Mar 2009 14:29:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fujita.tomonori@lab.ntt.co.jp, bzolnier@gmail.com, jeff@garzik.org, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     libata: fix dma_unmap_sg misuse
has been removed from the -mm tree.  Its filename was
     libata-fix-dma_unmap_sg-misuse.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: libata: fix dma_unmap_sg misuse
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

libata passes the returned value of dma_map_sg() to dma_unmap_sg(),which
is the misuse of dma_unmap_sg().

DMA-mapping.txt says:

To unmap a scatterlist, just call:

	pci_unmap_sg(pdev, sglist, nents, direction);

Again, make sure DMA activity has already finished.

PLEASE NOTE:  The 'nents' argument to the pci_unmap_sg call must be
              the _same_ one you passed into the pci_map_sg call,
	      it should _NOT_ be the 'count' value _returned_ from the
              pci_map_sg call.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Acked-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/libata-core.c |    4 ++--
 include/linux/libata.h    |    1 +
 2 files changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/ata/libata-core.c~libata-fix-dma_unmap_sg-misuse drivers/ata/libata-core.c
--- a/drivers/ata/libata-core.c~libata-fix-dma_unmap_sg-misuse
+++ a/drivers/ata/libata-core.c
@@ -4612,7 +4612,7 @@ void ata_sg_clean(struct ata_queued_cmd 
 	VPRINTK("unmapping %u sg elements\n", qc->n_elem);
 
 	if (qc->n_elem)
-		dma_unmap_sg(ap->dev, sg, qc->n_elem, dir);
+		dma_unmap_sg(ap->dev, sg, qc->orig_n_elem, dir);
 
 	qc->flags &= ~ATA_QCFLAG_DMAMAP;
 	qc->sg = NULL;
@@ -4727,7 +4727,7 @@ static int ata_sg_setup(struct ata_queue
 		return -1;
 
 	DPRINTK("%d sg elements mapped\n", n_elem);
