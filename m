From: akpm@linux-foundation.org
Subject: [folded-merged]
 x86-make-dma_alloc_coherent-return-zeroed-memory-if-cma-is-enabled-fix.patch removed from -mm tree
Date: Wed, 04 Jun 2014 15:22:26 -0700
Message-ID: <538f9c22.Hrpqn73VCP9sns8O%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38970 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752364AbaFDWW1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Jun 2014 18:22:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com, m.szyprowski@samsung.com, konrad.wilk@oracle.com, hpa@zytor.com, dwmw2@infradead.org, ddutile@redhat.com, andi@firstfloor.org, akinobu.mita@gmail.com

Subject: [folded-merged] x86-make-dma_alloc_coherent-return-zeroed-memory-if-cma-is-enabled-fix.patch removed from -mm tree
To: akinobu.mita@gmail.com,andi@firstfloor.org,ddutile@redhat.com,dwmw2@infradead.org,hpa@zytor.com,konrad.wilk@oracle.com,m.szyprowski@samsung.com,mingo@redhat.com,tglx@linutronix.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 04 Jun 2014 15:22:26 -0700


The patch titled
     Subject: arch/x86/kernel/pci-dma.c: avoid duplicated memset in dma_generic_alloc_coherent()
has been removed from the -mm tree.  Its filename was
     x86-make-dma_alloc_coherent-return-zeroed-memory-if-cma-is-enabled-fix.patch

This patch was dropped because it was folded into x86-make-dma_alloc_coherent-return-zeroed-memory-if-cma-is-enabled.patch

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: arch/x86/kernel/pci-dma.c: avoid duplicated memset in dma_generic_alloc_coherent()

Fix a duplicated memset that was introduced by the patch
x86-make-dma_alloc_coherent-return-zeroed-memory-if-cma-is-enabled.patch
in -mm tree, and this change should be folded into it.

If dma_generic_alloc_coherent() is called with __GFP_ZERO, it does a
duplicated memset to the memory area allocated by alloc_pages_node() with
__GFP_ZERO.  This change fixes that inefficiency by clearing __GFP_ZERO
bit in gfp flages before calling alloc_pages_node().  Note that
dma_generic_alloc_coherent() always returns zeroed memory.

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

 arch/x86/kernel/pci-dma.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/x86/kernel/pci-dma.c~x86-make-dma_alloc_coherent-return-zeroed-memory-if-cma-is-enabled-fix arch/x86/kernel/pci-dma.c
--- a/arch/x86/kernel/pci-dma.c~x86-make-dma_alloc_coherent-return-zeroed-memory-if-cma-is-enabled-fix
+++ a/arch/x86/kernel/pci-dma.c
@@ -97,6 +97,7 @@ void *dma_generic_alloc_coherent(struct
 
 	dma_mask = dma_alloc_coherent_mask(dev, flag);
 
+	flag &= ~__GFP_ZERO;
 again:
 	page = NULL;
 	/* CMA can be used only in the context which permits sleeping */
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
x86-make-dma_alloc_coherent-return-zeroed-memory-if-cma-is-enabled.patch
x86-enable-dma-cma-with-swiotlb.patch
intel-iommu-integrate-dma-cma.patch
intel-iommu-integrate-dma-cma-fix.patch
memblock-introduce-memblock_alloc_range.patch
cma-add-placement-specifier-for-cma=-kernel-parameter.patch
arch-x86-kernel-pci-dmac-fix-dma_generic_alloc_coherent-when-config_dma_cma-is-enabled.patch

