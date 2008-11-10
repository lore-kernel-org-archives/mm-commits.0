From: akpm@linux-foundation.org
Subject: - dm1105-fix-the-misuse-of-pci_dma_mapping_error.patch removed from -mm tree
Date: Mon, 10 Nov 2008 12:34:28 -0800
Message-ID: <200811102034.mAAKYSxi025066@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46603 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753604AbYKJUfC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Nov 2008 15:35:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fujita.tomonori@lab.ntt.co.jp, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     dm1105: fix the misuse of pci_dma_mapping_error
has been removed from the -mm tree.  Its filename was
     dm1105-fix-the-misuse-of-pci_dma_mapping_error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dm1105: fix the misuse of pci_dma_mapping_error
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

pci_dma_mapping_error can't be used for pci_alloc_consistent
(pci_dma_mapping_error is for dma_map_single and dma_map_page). 
pci_alloc_consistent returns NULL if the allocation fails.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/dvb/dm1105/dm1105.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/media/dvb/dm1105/dm1105.c~dm1105-fix-the-misuse-of-pci_dma_mapping_error drivers/media/dvb/dm1105/dm1105.c
--- a/drivers/media/dvb/dm1105/dm1105.c~dm1105-fix-the-misuse-of-pci_dma_mapping_error
+++ a/drivers/media/dvb/dm1105/dm1105.c
@@ -367,7 +367,7 @@ static int __devinit dm1105dvb_dma_map(s
 {
 	dm1105dvb->ts_buf = pci_alloc_consistent(dm1105dvb->pdev, 6*DM1105_DMA_BYTES, &dm1105dvb->dma_addr);
 
-	return pci_dma_mapping_error(dm1105dvb->pdev, dm1105dvb->dma_addr);
+	return !dm1105dvb->ts_buf;
 }
 
 static void dm1105dvb_dma_unmap(struct dm1105dvb *dm1105dvb)
_

Patches currently in -mm which might be from fujita.tomonori@lab.ntt.co.jp are

linux-next.patch

