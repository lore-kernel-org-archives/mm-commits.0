From: akpm@linux-foundation.org
Subject: + mn10300-make-the-asb2305s-pcnet32-nic-work-by-using-the-pci-bridges-sram.patch added to -mm tree
Date: Wed, 06 Jan 2010 16:28:35 -0800
Message-ID: <201001070028.o070SZit027667@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51895 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932469Ab0AGA2x (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Jan 2010 19:28:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com


The patch titled
     mn10300: make the ASB2305's PCnet32 NIC work by using the PCI bridge's SRAM
has been added to the -mm tree.  Its filename is
     mn10300-make-the-asb2305s-pcnet32-nic-work-by-using-the-pci-bridges-sram.patch

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

mm-make-totalhigh_pages-unsigned-long.patch
fdpic-respect-pt_gnu_stack-exec-protection-markings-when-creating-nommu-stack.patch
nommu-avoiding-duplicate-icache-flushes-of-shared-maps.patch
nommu-use-copy__user_page-in-access_process_vm.patch
mn10300-signal-stack-fix.patch
mn10300-objcopy-flags-fix.patch
mn10300-add-cc-clobbers-to-asm-statements.patch
mn10300-wire-up-missing-new-syscalls.patch
fix-several-bogus-includes-on-mn10300-abs2305.patch
mn10300-use-kern_err-not-kern_error.patch
mn10300-use-generic-pci_enable_resources.patch
mn10300-insert-pci-root-bus-resources-for-the-asb2305-devel-motherboard.patch
mn10300-make-the-asb2305s-pcnet32-nic-work-by-using-the-pci-bridges-sram.patch
mn10300-update-the-asb2303-defconfig.patch
kernel-credc-use-kmem_cache_free.patch
frv-duplicate-output_buffer-of-e03.patch
mutex-subsystem-synchro-test-module.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

