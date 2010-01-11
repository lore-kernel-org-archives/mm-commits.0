From: akpm@linux-foundation.org
Subject: [merged] mn10300-make-the-asb2305s-pcnet32-nic-work-by-using-the-pci-bridges-sram.patch removed from -mm tree
Date: Mon, 11 Jan 2010 12:19:37 -0800
Message-ID: <201001112019.o0BKJbWc025584@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36574 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754014Ab0AKUaW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Jan 2010 15:30:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     mn10300: make the ASB2305's PCnet32 NIC work by using the PCI bridge's SRAM
has been removed from the -mm tree.  Its filename was
     mn10300-make-the-asb2305s-pcnet32-nic-work-by-using-the-pci-bridges-sram.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mn10300: make the ASB2305's PCnet32 NIC work by using the PCI bridge's SRAM
From: David Howells <dhowells@redhat.com>

Access to the ASB2305's PCnet32 NIC doesn't work correctly because when
the NIC attempts to update the ring buffer flags by DMA, the change to RAM
crops up about 17uS after the interrupt line is asserted.  This is almost
certainly due to a bug in the PCI bridge FPGA on that board.

We can get around this by making dma_alloc_coherent() put the ring buffer
in the SRAM attached to the PCI bridge rather than in the SDRAM.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mn10300/mm/dma-alloc.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff -puN arch/mn10300/mm/dma-alloc.c~mn10300-make-the-asb2305s-pcnet32-nic-work-by-using-the-pci-bridges-sram arch/mn10300/mm/dma-alloc.c
--- a/arch/mn10300/mm/dma-alloc.c~mn10300-make-the-asb2305s-pcnet32-nic-work-by-using-the-pci-bridges-sram
+++ a/arch/mn10300/mm/dma-alloc.c
@@ -16,12 +16,24 @@
 #include <linux/pci.h>
 #include <asm/io.h>
 
+static unsigned long pci_sram_allocated = 0xbc000000;
+
 void *dma_alloc_coherent(struct device *dev, size_t size,
 			 dma_addr_t *dma_handle, int gfp)
 {
 	unsigned long addr;
 	void *ret;
 
+	printk("dma_alloc_coherent(%s,%zu,,%x)\n", dev_name(dev), size, gfp);
+
+	if (0xbe000000 - pci_sram_allocated >= size) {
+		size = (size + 255) & ~255;
+		addr = pci_sram_allocated;
+		pci_sram_allocated += size;
+		ret = (void *) addr;
+		goto done;
+	}
+
 	/* ignore region specifiers */
 	gfp &= ~(__GFP_DMA | __GFP_HIGHMEM);
 
@@ -41,7 +53,9 @@ void *dma_alloc_coherent(struct device *
 	/* write back and evict all cache lines covering this region */
 	mn10300_dcache_flush_inv_range2(virt_to_phys((void *) addr), PAGE_SIZE);
 
+done:
 	*dma_handle = virt_to_bus((void *) addr);
+	printk("dma_alloc_coherent() = %p [%x]\n", ret, *dma_handle);
 	return ret;
 }
 EXPORT_SYMBOL(dma_alloc_coherent);
@@ -51,6 +65,9 @@ void dma_free_coherent(struct device *de
 {
 	unsigned long addr = (unsigned long) vaddr & ~0x20000000;
 
+	if (addr >= 0x9c000000)
+		return;
+
 	free_pages(addr, get_order(size));
 }
 EXPORT_SYMBOL(dma_free_coherent);
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
kernel-credc-use-kmem_cache_free.patch
frv-duplicate-output_buffer-of-e03.patch
coredump-unify-dump_seek-implementations-for-each-binfmt_c.patch
coredump-move-dump_write-and-dump_seek-into-a-header-file.patch
elf-coredump-replace-elf_core_extra_-macros-by-functions.patch
elf-coredump-make-offset-calculation-process-and-writing-process-explicit.patch
elf-coredump-add-extended-numbering-support.patch
mutex-subsystem-synchro-test-module.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

