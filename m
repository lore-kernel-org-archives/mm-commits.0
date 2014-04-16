From: akpm@linux-foundation.org
Subject: +
 x86-make-dma_alloc_coherent-return-zeroed-memory-if-cma-is-enabled.patch
 added to -mm tree
Date: Wed, 16 Apr 2014 12:44:44 -0700
Message-ID: <534eddac.TVHfwLv5D72cjeLX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45416 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756083AbaDPTop (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Apr 2014 15:44:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yinghai@kernel.org, tglx@linutronix.de, mingo@redhat.com, m.szyprowski@samsung.com, konrad.wilk@oracle.com, hpa@zytor.com, dwmw2@infradead.org, ddutile@redhat.com, andi@firstfloor.org, akinobu.mita@gmail.com

Subject: + x86-make-dma_alloc_coherent-return-zeroed-memory-if-cma-is-enabled.patch added to -mm tree
To: akinobu.mita@gmail.com,andi@firstfloor.org,ddutile@redhat.com,dwmw2@infradead.org,hpa@zytor.com,konrad.wilk@oracle.com,m.szyprowski@samsung.com,mingo@redhat.com,tglx@linutronix.de,yinghai@kernel.org
From: akpm@linux-foundation.org
Date: Wed, 16 Apr 2014 12:44:44 -0700


The patch titled
     Subject: x86: make dma_alloc_coherent() return zeroed memory if CMA is enabled
has been added to the -mm tree.  Its filename is
     x86-make-dma_alloc_coherent-return-zeroed-memory-if-cma-is-enabled.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/x86-make-dma_alloc_coherent-return-zeroed-memory-if-cma-is-enabled.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/x86-make-dma_alloc_coherent-return-zeroed-memory-if-cma-is-enabled.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: x86: make dma_alloc_coherent() return zeroed memory if CMA is enabled

This patchset enhances the DMA Contiguous Memory Allocator on x86.

Currently the DMA CMA is only supported with pci-nommu dma_map_ops and
furthermore it can't be enabled on x86_64.  But I would like to allocate
big contiguous memory with dma_alloc_coherent() and tell it to the device
that requires it, regardless of which dma mapping implementation is
actually used in the system.

So this makes it work with swiotlb and intel-iommu dma_map_ops, too.  And
this also extends "cma=" kernel parameter to specify placement constraint
by the physical address range of memory allocations.  For example, CMA
allocates memory below 4GB by "cma=64M@0-4G", it is required for the
devices only supporting 32-bit addressing on 64-bit systems without iommu.


This patch (of 5):

Calling dma_alloc_coherent() with __GFP_ZERO must return zeroed memory.

But when the contiguous memory allocator (CMA) is enabled on x86 and the
memory region is allocated by dma_alloc_from_contiguous(), it doesn't
return zeroed memory.  Because dma_generic_alloc_coherent() forgot to fill
the memory region with zero if it was allocated by
dma_alloc_from_contiguous()

Most implementations of dma_alloc_coherent() return zeroed memory
regardless of whether __GFP_ZERO is specified.  So this fixes it by
unconditionally zeroing the allocated memory region.

Alternatively, we could fix dma_alloc_from_contiguous() to return zeroed
out memory and remove memset() from all caller of it.  But we can't simply
remove the memset on arm because __dma_clear_buffer() is used there for
ensuring cache flushing and it is used in many places.  Of course we can
do redundant memset in dma_alloc_from_contiguous(), but I think this patch
is less impact for fixing this problem.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Don Dutile <ddutile@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/pci-dma.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN arch/x86/kernel/pci-dma.c~x86-make-dma_alloc_coherent-return-zeroed-memory-if-cma-is-enabled arch/x86/kernel/pci-dma.c
--- a/arch/x86/kernel/pci-dma.c~x86-make-dma_alloc_coherent-return-zeroed-memory-if-cma-is-enabled
+++ a/arch/x86/kernel/pci-dma.c
@@ -97,7 +97,6 @@ void *dma_generic_alloc_coherent(struct
 
 	dma_mask = dma_alloc_coherent_mask(dev, flag);
 
-	flag |= __GFP_ZERO;
 again:
 	page = NULL;
 	/* CMA can be used only in the context which permits sleeping */
@@ -120,7 +119,7 @@ again:
 
 		return NULL;
 	}
