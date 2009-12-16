From: akpm@linux-foundation.org
Subject: [merged] dma-mapping-fix-off-by-one-error-in-dma_capable.patch removed from -mm tree
Date: Wed, 16 Dec 2009 12:39:21 -0800
Message-ID: <200912162039.nBGKdLu4013529@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56167 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964995AbZLPUjw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 15:39:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: JBeulich@novell.com, beckyb@kernel.crashing.org, benh@kernel.crashing.org, fujita.tomonori@lab.ntt.co.jp, hpa@zytor.com, jbeulich@novell.com, mingo@elte.hu, tglx@linutronix.de, tony.l


The patch titled
     dma-mapping: fix off-by-one error in dma_capable()
has been removed from the -mm tree.  Its filename was
     dma-mapping-fix-off-by-one-error-in-dma_capable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dma-mapping: fix off-by-one error in dma_capable()
From: "Jan Beulich" <JBeulich@novell.com>

dma_mask is, when interpreted as address, the last valid byte, and hence
comparison msut also be done using the last valid of the buffer in
question.

Also fix the open-coded instances in lib/swiotlb.c.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Becky Bruce <beckyb@kernel.crashing.org>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/include/asm/dma-mapping.h    |    2 +-
 arch/powerpc/include/asm/dma-mapping.h |    2 +-
 arch/x86/include/asm/dma-mapping.h     |    2 +-
 lib/swiotlb.c                          |    4 ++--
 4 files changed, 5 insertions(+), 5 deletions(-)

diff -puN arch/ia64/include/asm/dma-mapping.h~dma-mapping-fix-off-by-one-error-in-dma_capable arch/ia64/include/asm/dma-mapping.h
--- a/arch/ia64/include/asm/dma-mapping.h~dma-mapping-fix-off-by-one-error-in-dma_capable
+++ a/arch/ia64/include/asm/dma-mapping.h
@@ -73,7 +73,7 @@ static inline bool dma_capable(struct de
 	if (!dev->dma_mask)
 		return 0;
 
-	return addr + size <= *dev->dma_mask;
+	return addr + size - 1 <= *dev->dma_mask;
 }
 
 static inline dma_addr_t phys_to_dma(struct device *dev, phys_addr_t paddr)
diff -puN arch/powerpc/include/asm/dma-mapping.h~dma-mapping-fix-off-by-one-error-in-dma_capable arch/powerpc/include/asm/dma-mapping.h
--- a/arch/powerpc/include/asm/dma-mapping.h~dma-mapping-fix-off-by-one-error-in-dma_capable
+++ a/arch/powerpc/include/asm/dma-mapping.h
@@ -197,7 +197,7 @@ static inline bool dma_capable(struct de
 	if (!dev->dma_mask)
 		return 0;
 
-	return addr + size <= *dev->dma_mask;
+	return addr + size - 1 <= *dev->dma_mask;
 }
 
 static inline dma_addr_t phys_to_dma(struct device *dev, phys_addr_t paddr)
diff -puN arch/x86/include/asm/dma-mapping.h~dma-mapping-fix-off-by-one-error-in-dma_capable arch/x86/include/asm/dma-mapping.h
--- a/arch/x86/include/asm/dma-mapping.h~dma-mapping-fix-off-by-one-error-in-dma_capable
+++ a/arch/x86/include/asm/dma-mapping.h
@@ -67,7 +67,7 @@ static inline bool dma_capable(struct de
 	if (!dev->dma_mask)
 		return 0;
 
-	return addr + size <= *dev->dma_mask;
+	return addr + size - 1 <= *dev->dma_mask;
 }
 
 static inline dma_addr_t phys_to_dma(struct device *dev, phys_addr_t paddr)
diff -puN lib/swiotlb.c~dma-mapping-fix-off-by-one-error-in-dma_capable lib/swiotlb.c
--- a/lib/swiotlb.c~dma-mapping-fix-off-by-one-error-in-dma_capable
+++ a/lib/swiotlb.c
@@ -549,7 +549,7 @@ swiotlb_alloc_coherent(struct device *hw
 		dma_mask = hwdev->coherent_dma_mask;
 
 	ret = (void *)__get_free_pages(flags, order);
-	if (ret && swiotlb_virt_to_bus(hwdev, ret) + size > dma_mask) {
+	if (ret && swiotlb_virt_to_bus(hwdev, ret) + size - 1 > dma_mask) {
 		/*
 		 * The allocated memory isn't reachable by the device.
 		 */
@@ -571,7 +571,7 @@ swiotlb_alloc_coherent(struct device *hw
 	dev_addr = swiotlb_virt_to_bus(hwdev, ret);
 
 	/* Confirm address can be DMA'd by device */
-	if (dev_addr + size > dma_mask) {
+	if (dev_addr + size - 1 > dma_mask) {
 		printk("hwdev DMA mask = 0x%016Lx, dev_addr = 0x%016Lx\n",
 		       (unsigned long long)dma_mask,
 		       (unsigned long long)dev_addr);
_

Patches currently in -mm which might be from JBeulich@novell.com are

origin.patch
linux-next.patch
mm-vmallocc-dont-use-vmalloc_end.patch
fix-section-mismatch-in-early-ehci-dbgp.patch

