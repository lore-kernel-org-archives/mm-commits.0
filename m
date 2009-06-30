From: akpm@linux-foundation.org
Subject: [merged] mn10300-pci-remove-pci_dac_dma_-apis.patch removed from -mm tree
Date: Tue, 30 Jun 2009 10:53:44 -0700
Message-ID: <200906301753.n5UHrjiB014087@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57910 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752786AbZF3RyT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Jun 2009 13:54:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fernando@oss.ntt.co.jp, dhowells@redhat.com, jbarnes@virtuousgeek.org, mm-commits@vger.kernel.org


The patch titled
     mn10300: pci: remove pci_dac_dma_... APIs
has been removed from the -mm tree.  Its filename was
     mn10300-pci-remove-pci_dac_dma_-apis.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mn10300: pci: remove pci_dac_dma_... APIs
From: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>

It seems that mn10300 made it upstream after Jan Beulich's pci_dac_dma_*
cleanup work and still defines pci_dac_dma_supported().  This API is not
required by the PCI subsystem anymore, so remove it.

Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mn10300/include/asm/pci.h |    4 ----
 1 file changed, 4 deletions(-)

diff -puN arch/mn10300/include/asm/pci.h~mn10300-pci-remove-pci_dac_dma_-apis arch/mn10300/include/asm/pci.h
--- a/arch/mn10300/include/asm/pci.h~mn10300-pci-remove-pci_dac_dma_-apis
+++ a/arch/mn10300/include/asm/pci.h
@@ -70,10 +70,6 @@ struct pci_dev;
  */
 #define PCI_DMA_BUS_IS_PHYS	(1)
 
-
-/* This is always fine. */
-#define pci_dac_dma_supported(pci_dev, mask)	(0)
