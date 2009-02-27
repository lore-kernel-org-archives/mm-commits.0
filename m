From: akpm@linux-foundation.org
Subject: + ia64-fix-pci-dma-flag-propagation-on-sn-altix-with-pics.patch added to -mm tree
Date: Fri, 27 Feb 2009 12:06:39 -0800
Message-ID: <200902272006.n1RK6dW5029799@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43653 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756830AbZB0UHU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Feb 2009 15:07:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeremy@sgi.com, habeck@sgi.com, jbarnes@virtuousgeek.org, tony.luck@intel.com


The patch titled
     ia64: fix PCI DMA flag propagation on SN (Altix) with PICs
has been added to the -mm tree.  Its filename is
     ia64-fix-pci-dma-flag-propagation-on-sn-altix-with-pics.patch

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
Subject: ia64: fix PCI DMA flag propagation on SN (Altix) with PICs
From: Jeremy Higdon <jeremy@sgi.com>

We recently discovered a problem with passing of DMA attributes on SN
systems with the older PIC chips.

Signed-off-by: Jeremy Higdon <jeremy@sgi.com>
Cc: <habeck@sgi.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/sn/pci/pcibr/pcibr_dma.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN arch/ia64/sn/pci/pcibr/pcibr_dma.c~ia64-fix-pci-dma-flag-propagation-on-sn-altix-with-pics arch/ia64/sn/pci/pcibr/pcibr_dma.c
--- a/arch/ia64/sn/pci/pcibr/pcibr_dma.c~ia64-fix-pci-dma-flag-propagation-on-sn-altix-with-pics
+++ a/arch/ia64/sn/pci/pcibr/pcibr_dma.c
@@ -135,11 +135,10 @@ pcibr_dmatrans_direct64(struct pcidev_in
 	if (SN_DMA_ADDRTYPE(dma_flags) == SN_DMA_ADDR_PHYS)
 		pci_addr = IS_PIC_SOFT(pcibus_info) ?
 				PHYS_TO_DMA(paddr) :
-		    		PHYS_TO_TIODMA(paddr) | dma_attributes;
+		    		PHYS_TO_TIODMA(paddr);
 	else
-		pci_addr = IS_PIC_SOFT(pcibus_info) ?
-				paddr :
-				paddr | dma_attributes;
+		pci_addr = paddr;
+	pci_addr |= dma_attributes;
 
 	/* Handle Bus mode */
 	if (IS_PCIX(pcibus_info))
_

Patches currently in -mm which might be from jeremy@sgi.com are

ia64-fix-pci-dma-flag-propagation-on-sn-altix-with-pics.patch

