From: akpm@linux-foundation.org
Subject: [merged] ia64-fix-pci-dma-flag-propagation-on-sn-altix-with-pics.patch removed from -mm tree
Date: Mon, 09 Mar 2009 11:27:34 -0700
Message-ID: <200903091827.n29IRYJ6024844@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58699 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754088AbZCIS2J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Mar 2009 14:28:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeremy@sgi.com, habeck@sgi.com, jbarnes@virtuousgeek.org, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     ia64: fix PCI DMA flag propagation on SN (Altix) with PICs
has been removed from the -mm tree.  Its filename was
     ia64-fix-pci-dma-flag-propagation-on-sn-altix-with-pics.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ia64: fix PCI DMA flag propagation on SN (Altix) with PICs
From: Jeremy Higdon <jeremy@sgi.com>

We recently discovered a problem with passing of DMA attributes on SN
systems with the older PIC chips.

[akpm@linux-foundation.org: coding-style fixes]
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
+				PHYS_TO_TIODMA(paddr);
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

origin.patch

