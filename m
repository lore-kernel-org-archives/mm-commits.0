From: akpm@linux-foundation.org
Subject: - mn10300-remove-pci_dac_dma_-apis.patch removed from -mm tree
Date: Thu, 11 Dec 2008 11:15:10 -0800
Message-ID: <200812111915.mBBJFAvC008281@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33185 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757262AbYLKTQ5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 11 Dec 2008 14:16:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fernando@oss.ntt.co.jp, dhowells@redhat.com, jbarnes@virtuousgeek.org, jbeulich@novell.com, mm-commits@vger.kernel.org


The patch titled
     mn10300: remove pci_dac_dma_... APIs
has been removed from the -mm tree.  Its filename was
     mn10300-remove-pci_dac_dma_-apis.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mn10300: remove pci_dac_dma_... APIs
From: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>

It seems that mn10300 made it upstream after Jan Beulich's pci_dac_dma_*
cleanup work and still defines pci_dac_dma_supported().  This API is not
required by the PCI subsystem anymore, so remove it.

Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
Cc: Jan Beulich <jbeulich@novell.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-mn10300/pci.h |    4 ----
 1 file changed, 4 deletions(-)

diff -puN include/asm-mn10300/pci.h~mn10300-remove-pci_dac_dma_-apis include/asm-mn10300/pci.h
--- a/include/asm-mn10300/pci.h~mn10300-remove-pci_dac_dma_-apis
+++ a/include/asm-mn10300/pci.h
@@ -70,10 +70,6 @@ struct pci_dev;
  */
 #define PCI_DMA_BUS_IS_PHYS	(1)
 
-
-/* This is always fine. */
-#define pci_dac_dma_supported(pci_dev, mask)	(0)
