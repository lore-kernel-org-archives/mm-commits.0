From: akpm@linux-foundation.org
Subject: + dma-mapping-fix-off-by-one-error-in-dma_capable.patch added to -mm tree
Date: Thu, 15 Oct 2009 15:48:55 -0700
Message-ID: <200910152248.n9FMmuGb019310@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42509 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763240AbZJOWu3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Oct 2009 18:50:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: JBeulich@novell.com, beckyb@kernel.crashing.org, benh@kernel.crashing.org, fujita.tomonori@lab.ntt.co.jp, hpa@zytor.com, jbeulich@novell.com, mingo@elte.hu, tglx@linutronix.de, tony.luck@intel.com


The patch titled
     dma-mapping: fix off-by-one error in dma_capable()
has been added to the -mm tree.  Its filename is
     dma-mapping-fix-off-by-one-error-in-dma_capable.patch

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
@@ -60,7 +60,7 @@ static inline bool dma_capable(struct de
 	if (!dev->dma_mask)
 		return 0;
 
-	return addr + size <= *dev->dma_mask;
+	return addr + size - 1 <= *dev->dma_mask;
 }
 
 static inline dma_addr_t phys_to_dma(struct device *dev, phys_addr_t paddr)
diff -puN lib/swiotlb.c~dma-mapping-fix-off-by-one-error-in-dma_capable lib/swiotlb.c
--- a/lib/swiotlb.c~dma-mapping-fix-off-by-one-error-in-dma_capable
+++ a/lib/swiotlb.c
@@ -517,7 +517,7 @@ swiotlb_alloc_coherent(struct device *hw
 		dma_mask = hwdev->coherent_dma_mask;
 
 	ret = (void *)__get_free_pages(flags, order);
-	if (ret && swiotlb_virt_to_bus(hwdev, ret) + size > dma_mask) {
+	if (ret && swiotlb_virt_to_bus(hwdev, ret) + size - 1 > dma_mask) {
 		/*
 		 * The allocated memory isn't reachable by the device.
 		 */
@@ -539,7 +539,7 @@ swiotlb_alloc_coherent(struct device *hw
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
kbuild-generate-modulesbuiltin.patch
kbuild-rebuild-fix-for-makefilemodbuiltin.patch
drm-make-sure-page-protections-are-updated-after-changing-vm_flags.patch
vmalloc-adjust-gfp-mask-passed-on-nested-vmalloc-invocation.patch
dma-mapping-fix-off-by-one-error-in-dma_capable.patch

