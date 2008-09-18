From: akpm@linux-foundation.org
Subject: + documentation-dma-mappingtxt-update-for-pci_dma_mapping_error-changes.patch added to -mm tree
Date: Wed, 17 Sep 2008 23:33:30 -0700
Message-ID: <200809180633.m8I6XULg018326@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34288 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752028AbYIRGdx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Sep 2008 02:33:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mitov@issp.bas.bg, fujita.tomonori@lab.ntt.co.jp, mitov@ispp.bas.bg


The patch titled
     Documentation/DMA-mapping.txt: update for pci_dma_mapping_error() changes
has been added to the -mm tree.  Its filename is
     documentation-dma-mappingtxt-update-for-pci_dma_mapping_error-changes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Documentation/DMA-mapping.txt: update for pci_dma_mapping_error() changes
From: Marin Mitov <mitov@issp.bas.bg>

Make the example code consistent with changed API.

Signed-off-by: Marin Mitov <mitov@ispp.bas.bg>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DMA-mapping.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/DMA-mapping.txt~documentation-dma-mappingtxt-update-for-pci_dma_mapping_error-changes Documentation/DMA-mapping.txt
--- a/Documentation/DMA-mapping.txt~documentation-dma-mappingtxt-update-for-pci_dma_mapping_error-changes
+++ a/Documentation/DMA-mapping.txt
@@ -740,7 +740,7 @@ failure can be determined by:
 	dma_addr_t dma_handle;
 
 	dma_handle = pci_map_single(pdev, addr, size, direction);
-	if (pci_dma_mapping_error(dma_handle)) {
+	if (pci_dma_mapping_error(pdev, dma_handle)) {
 		/*
 		 * reduce current DMA mapping usage,
 		 * delay and try again later or
_

Patches currently in -mm which might be from mitov@issp.bas.bg are

documentation-dma-mappingtxt-update-for-pci_dma_mapping_error-changes.patch

