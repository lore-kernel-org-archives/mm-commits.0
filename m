From: akpm@linux-foundation.org
Subject: + dma-apitxt-fix-description-of-pci_map_sg-dma_map_sg-scatterlists-handling.patch added to -mm tree
Date: Thu, 20 Nov 2008 13:32:28 -0800
Message-ID: <200811202132.mAKLWSoR000673@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52174 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757455AbYKTVcl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Nov 2008 16:32:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp, James.Bottomley@HansenPartnership.com, htejun@gmail.com, jens.axboe@oracle.com


The patch titled
     DMA-API.txt: fix description of pci_map_sg/dma_map_sg scatterlists handling
has been added to the -mm tree.  Its filename is
     dma-apitxt-fix-description-of-pci_map_sg-dma_map_sg-scatterlists-handling.patch

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
Subject: DMA-API.txt: fix description of pci_map_sg/dma_map_sg scatterlists handling
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

- pci_map_sg/dma_map_sg are used with a scatter gather list that doesn't
  come from the block layer (e.g.  some network drivers do).

- how IOMMUs merge adjacent elements of the scatter/gather list is
  independent of how the block layer determines sees elements.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Tejun Heo <htejun@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DMA-API.txt |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff -puN Documentation/DMA-API.txt~dma-apitxt-fix-description-of-pci_map_sg-dma_map_sg-scatterlists-handling Documentation/DMA-API.txt
--- a/Documentation/DMA-API.txt~dma-apitxt-fix-description-of-pci_map_sg-dma_map_sg-scatterlists-handling
+++ a/Documentation/DMA-API.txt
@@ -316,12 +316,10 @@ reduce current DMA mapping usage or dela
 	pci_map_sg(struct pci_dev *hwdev, struct scatterlist *sg,
 		int nents, int direction)
 
-Maps a scatter gather list from the block layer.
