From: akpm@linux-foundation.org
Subject: [merged]
 arch-x86-kernel-pci-dmac-fix-dma_generic_alloc_coherent-when-config_dma_cma-is-enabled.patch removed from -mm tree
Date: Thu, 05 Jun 2014 12:49:13 -0700
Message-ID: <5390c9b9.OusGq3CiJaPb3T98%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55785 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752117AbaFETtO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 15:49:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com, m.szyprowski@samsung.com, konrad.wilk@oracle.com, hpa@zytor.com, dwmw2@infradead.org, ddutile@redhat.com, andi@firstfloor.org, akinobu.mita@gmail.com

Subject: [merged] arch-x86-kernel-pci-dmac-fix-dma_generic_alloc_coherent-when-config_dma_cma-is-enabled.patch removed from -mm tree
To: akinobu.mita@gmail.com,andi@firstfloor.org,ddutile@redhat.com,dwmw2@infradead.org,hpa@zytor.com,konrad.wilk@oracle.com,m.szyprowski@samsung.com,mingo@redhat.com,tglx@linutronix.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 12:49:13 -0700


The patch titled
     Subject: arch/x86/kernel/pci-dma.c: fix dma_generic_alloc_coherent() when CONFIG_DMA_CMA is enabled
has been removed from the -mm tree.  Its filename was
     arch-x86-kernel-pci-dmac-fix-dma_generic_alloc_coherent-when-config_dma_cma-is-enabled.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: arch/x86/kernel/pci-dma.c: fix dma_generic_alloc_coherent() when CONFIG_DMA_CMA is enabled

dma_generic_alloc_coherent() firstly attempts to allocate by
dma_alloc_from_contiguous() if CONFIG_DMA_CMA is enabled.  But the memory
region allocated by it may not fit within the device's DMA mask.  This
change makes it fall back to usual alloc_pages_node() allocation for such
cases.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Don Dutile <ddutile@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/pci-dma.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN arch/x86/kernel/pci-dma.c~arch-x86-kernel-pci-dmac-fix-dma_generic_alloc_coherent-when-config_dma_cma-is-enabled arch/x86/kernel/pci-dma.c
--- a/arch/x86/kernel/pci-dma.c~arch-x86-kernel-pci-dmac-fix-dma_generic_alloc_coherent-when-config_dma_cma-is-enabled
+++ a/arch/x86/kernel/pci-dma.c
@@ -101,8 +101,13 @@ void *dma_generic_alloc_coherent(struct
 again:
 	page = NULL;
 	/* CMA can be used only in the context which permits sleeping */
-	if (flag & __GFP_WAIT)
+	if (flag & __GFP_WAIT) {
 		page = dma_alloc_from_contiguous(dev, count, get_order(size));
+		if (page && page_to_phys(page) + size > dma_mask) {
+			dma_release_from_contiguous(dev, page, count);
+			page = NULL;
+		}
+	}
 	/* fallback */
 	if (!page)
 		page = alloc_pages_node(dev_to_node(dev), flag, get_order(size));
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
linux-next.patch

