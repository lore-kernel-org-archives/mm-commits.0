From: akpm@linux-foundation.org
Subject: - dma_free_coherent-needs-irqs-enabled-sigh.patch removed from -mm tree
Date: Mon, 20 Aug 2007 12:13:55 -0700
Message-ID: <200708201913.l7KJDtvK018494@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48780 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762076AbXHTT1Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Aug 2007 15:27:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david-b@pacbell.net, ak@suse.de, davem@davemloft.net, dbrownell@users.sourceforge.net, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     dma_free_coherent() needs irqs enabled (sigh)
has been removed from the -mm tree.  Its filename was
     dma_free_coherent-needs-irqs-enabled-sigh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: dma_free_coherent() needs irqs enabled (sigh)
From: David Brownell <david-b@pacbell.net>

On at least ARM (and I'm told MIPS too) dma_free_coherent() has a newish
call context requirement: unlike its dma_alloc_coherent() sibling, it may
not be called with IRQs disabled.  (This was new behavior on ARM as of late
2005, caused by ARM SMP updates.) This little surprise can be annoyingly
driver-visible.

Since it looks like that restriction won't be removed, this patch changes
the definition of the API to include that requirement.  Also, to help catch
nonportable drivers, it updates the x86 and swiotlb versions to include the
relevant warnings.  (I already observed that it trips on the
bus_reset_tasklet of the new firewire_ohci driver.)

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: David Miller <davem@davemloft.net>
Acked-by: Russell King <rmk@arm.linux.org.uk>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DMA-API.txt    |    3 +++
 arch/i386/kernel/pci-dma.c   |    3 ++-
 arch/x86_64/kernel/pci-dma.c |    1 +
 lib/swiotlb.c                |    1 +
 4 files changed, 7 insertions(+), 1 deletion(-)

diff -puN Documentation/DMA-API.txt~dma_free_coherent-needs-irqs-enabled-sigh Documentation/DMA-API.txt
--- a/Documentation/DMA-API.txt~dma_free_coherent-needs-irqs-enabled-sigh
+++ a/Documentation/DMA-API.txt
@@ -68,6 +68,9 @@ size and dma_handle must all be the same
 consistent allocate.  cpu_addr must be the virtual address returned by
 the consistent allocate.
 
+Note that unlike their sibling allocation calls, these routines
+may only be called with IRQs enabled.
+
 
 Part Ib - Using small dma-coherent buffers
 ------------------------------------------
diff -puN arch/i386/kernel/pci-dma.c~dma_free_coherent-needs-irqs-enabled-sigh arch/i386/kernel/pci-dma.c
--- a/arch/i386/kernel/pci-dma.c~dma_free_coherent-needs-irqs-enabled-sigh
+++ a/arch/i386/kernel/pci-dma.c
@@ -62,7 +62,8 @@ void dma_free_coherent(struct device *de
 {
 	struct dma_coherent_mem *mem = dev ? dev->dma_mem : NULL;
 	int order = get_order(size);
-	
+
+	WARN_ON(irqs_disabled());	/* for portability */
 	if (mem && vaddr >= mem->virt_base && vaddr < (mem->virt_base + (mem->size << PAGE_SHIFT))) {
 		int page = (vaddr - mem->virt_base) >> PAGE_SHIFT;
 
diff -puN arch/x86_64/kernel/pci-dma.c~dma_free_coherent-needs-irqs-enabled-sigh arch/x86_64/kernel/pci-dma.c
--- a/arch/x86_64/kernel/pci-dma.c~dma_free_coherent-needs-irqs-enabled-sigh
+++ a/arch/x86_64/kernel/pci-dma.c
@@ -161,6 +161,7 @@ EXPORT_SYMBOL(dma_alloc_coherent);
 void dma_free_coherent(struct device *dev, size_t size,
 			 void *vaddr, dma_addr_t bus)
 {
+	WARN_ON(irqs_disabled());	/* for portability */
 	if (dma_ops->unmap_single)
 		dma_ops->unmap_single(dev, bus, size, 0);
 	free_pages((unsigned long)vaddr, get_order(size));
diff -puN lib/swiotlb.c~dma_free_coherent-needs-irqs-enabled-sigh lib/swiotlb.c
--- a/lib/swiotlb.c~dma_free_coherent-needs-irqs-enabled-sigh
+++ a/lib/swiotlb.c
@@ -497,6 +497,7 @@ void
 swiotlb_free_coherent(struct device *hwdev, size_t size, void *vaddr,
 		      dma_addr_t dma_handle)
 {
+	WARN_ON(irqs_disabled());
 	if (!(vaddr >= (void *)io_tlb_start
                     && vaddr < (void *)io_tlb_end))
 		free_pages((unsigned long) vaddr, get_order(size));
_

Patches currently in -mm which might be from david-b@pacbell.net are

origin.patch
correct-name-for-rtc-m41t80.patch
mips-add-gpio-support-to-the-bcm947xx-platform.patch
mips-gpio-led-driver-for-the-wgt634u-machine.patch
git-mmc.patch
git-mtd.patch
drivers-pmc-msp71xx-gpio-char-driver.patch
driver-for-the-atmel-on-chip-ssc-on-at32ap-and-at91.patch
clean-up-duplicate-includes-in-drivers-spi.patch
rtc-periodic-irq-fix.patch
rtc_irq_set_freq-requires-power-of-two-and-associated-kerneldoc.patch
add-missing-newlines-to-some-uses-of-dev_level-messages.patch
