From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 094/128] powerpc: add an ioremap_phb helper
Date: Mon, 01 Jun 2020 21:50:37 -0700
Message-ID: <20200602045037._6QEURref%akpm@linux-foundation.org>
References: <20200601214457.919c35648e96a2b46b573fe1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:42588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726122AbgFBEuk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Jun 2020 00:50:40 -0400
In-Reply-To: <20200601214457.919c35648e96a2b46b573fe1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: airlied@linux.ie, akpm@linux-foundation.org, benh@kernel.crashing.org, borntraeger@de.ibm.com, catalin.marinas@arm.com, christophe.leroy@c-s.fr, daniel.vetter@ffwll.ch, daniel@ffwll.ch, gor@linux.ibm.com, gregkh@linuxfoundation.org, haiyangz@microsoft.com, hannes@cmpxchg.org, hch@lst.de, heiko.carstens@de.ibm.com, kys@microsoft.com, labbott@redhat.com, linux-mm@kvack.org, mark.rutland@arm.com, mikelley@microsoft.com, minchan@kernel.org, mm-commits@vger.kernel.org, ngupta@vflare.org, paulus@ozlabs.org, peterz@infradead.org, robin.murphy@arm.com, sakari.ailus@linux.intel.com, sthemmin@microsoft.com, sumit.semwal@linaro.org, torvalds@linux-foundation.org, wei.liu@kernel.org, will@kernel.org, xiang@kernel.org

From: Christoph Hellwig <hch@lst.de>
Subject: powerpc: add an ioremap_phb helper

Factor code shared between pci_64 and electra_cf into a ioremap_pbh helper
that follows the normal ioremap semantics, and returns a useful __iomem
pointer.  Note that it opencodes __ioremap_at as we know from the callers
the slab is available.  Switch pci_64 to also store the result as __iomem
pointer, and unmap the result using iounmap instead of force casting and
using vmalloc APIs.

Link: http://lkml.kernel.org/r/20200414131348.444715-7-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Christophe Leroy <christophe.leroy@c-s.fr>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: David Airlie <airlied@linux.ie>
Cc: Gao Xiang <xiang@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: Laura Abbott <labbott@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Michael Kelley <mikelley@microsoft.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Stephen Hemminger <sthemmin@microsoft.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Cc: Wei Liu <wei.liu@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Paul Mackerras <paulus@ozlabs.org>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/io.h         |    2 
 arch/powerpc/include/asm/pci-bridge.h |    2 
 arch/powerpc/kernel/pci_64.c          |   53 +++++++++++++++---------
 drivers/pcmcia/electra_cf.c           |   45 +++++++-------------
 4 files changed, 54 insertions(+), 48 deletions(-)

--- a/arch/powerpc/include/asm/io.h~powerpc-add-an-ioremap_phb-helper
+++ a/arch/powerpc/include/asm/io.h
@@ -719,6 +719,8 @@ void __iomem *ioremap_coherent(phys_addr
 
 extern void iounmap(volatile void __iomem *addr);
 
+void __iomem *ioremap_phb(phys_addr_t paddr, unsigned long size);
+
 int early_ioremap_range(unsigned long ea, phys_addr_t pa,
 			unsigned long size, pgprot_t prot);
 void __iomem *do_ioremap(phys_addr_t pa, phys_addr_t offset, unsigned long size,
--- a/arch/powerpc/include/asm/pci-bridge.h~powerpc-add-an-ioremap_phb-helper
+++ a/arch/powerpc/include/asm/pci-bridge.h
@@ -66,7 +66,7 @@ struct pci_controller {
 
 	void __iomem *io_base_virt;
 #ifdef CONFIG_PPC64
-	void *io_base_alloc;
+	void __iomem *io_base_alloc;
 #endif
 	resource_size_t io_base_phys;
 	resource_size_t pci_io_size;
--- a/arch/powerpc/kernel/pci_64.c~powerpc-add-an-ioremap_phb-helper
+++ a/arch/powerpc/kernel/pci_64.c
@@ -109,23 +109,46 @@ int pcibios_unmap_io_space(struct pci_bu
 	/* Get the host bridge */
 	hose = pci_bus_to_host(bus);
 
-	/* Check if we have IOs allocated */
-	if (hose->io_base_alloc == NULL)
-		return 0;
-
 	pr_debug("IO unmapping for PHB %pOF\n", hose->dn);
 	pr_debug("  alloc=0x%p\n", hose->io_base_alloc);
 
-	/* This is a PHB, we fully unmap the IO area */
-	vunmap(hose->io_base_alloc);
-
+	iounmap(hose->io_base_alloc);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(pcibios_unmap_io_space);
 
-static int pcibios_map_phb_io_space(struct pci_controller *hose)
+void __iomem *ioremap_phb(phys_addr_t paddr, unsigned long size)
 {
 	struct vm_struct *area;
+	unsigned long addr;
+
+	WARN_ON_ONCE(paddr & ~PAGE_MASK);
+	WARN_ON_ONCE(size & ~PAGE_MASK);
+
+	/*
+	 * Let's allocate some IO space for that guy. We don't pass VM_IOREMAP
+	 * because we don't care about alignment tricks that the core does in
+	 * that case.  Maybe we should due to stupid card with incomplete
+	 * address decoding but I'd rather not deal with those outside of the
+	 * reserved 64K legacy region.
+	 */
+	area = __get_vm_area(size, 0, PHB_IO_BASE, PHB_IO_END);
+	if (!area)
+		return NULL;
+
+	addr = (unsigned long)area->addr;
+	if (ioremap_page_range(addr, addr + size, paddr,
+			pgprot_noncached(PAGE_KERNEL))) {
+		unmap_kernel_range(addr, size);
+		return NULL;
+	}
+
+	return (void __iomem *)addr;
+}
+EXPORT_SYMBOL_GPL(ioremap_phb);
+
+static int pcibios_map_phb_io_space(struct pci_controller *hose)
+{
 	unsigned long phys_page;
 	unsigned long size_page;
 	unsigned long io_virt_offset;
@@ -146,12 +169,11 @@ static int pcibios_map_phb_io_space(stru
 	 * with incomplete address decoding but I'd rather not deal with
 	 * those outside of the reserved 64K legacy region.
 	 */
-	area = __get_vm_area(size_page, 0, PHB_IO_BASE, PHB_IO_END);
-	if (area == NULL)
+	hose->io_base_alloc = ioremap_phb(phys_page, size_page);
+	if (!hose->io_base_alloc)
 		return -ENOMEM;
-	hose->io_base_alloc = area->addr;
-	hose->io_base_virt = (void __iomem *)(area->addr +
-					      hose->io_base_phys - phys_page);
+	hose->io_base_virt = hose->io_base_alloc +
+				hose->io_base_phys - phys_page;
 
 	pr_debug("IO mapping for PHB %pOF\n", hose->dn);
 	pr_debug("  phys=0x%016llx, virt=0x%p (alloc=0x%p)\n",
@@ -159,11 +181,6 @@ static int pcibios_map_phb_io_space(stru
 	pr_debug("  size=0x%016llx (alloc=0x%016lx)\n",
 		 hose->pci_io_size, size_page);
 
-	/* Establish the mapping */
-	if (__ioremap_at(phys_page, area->addr, size_page,
-			 pgprot_noncached(PAGE_KERNEL)) == NULL)
-		return -ENOMEM;
-
 	/* Fixup hose IO resource */
 	io_virt_offset = pcibios_io_space_offset(hose);
 	hose->io_resource.start += io_virt_offset;
--- a/drivers/pcmcia/electra_cf.c~powerpc-add-an-ioremap_phb-helper
+++ a/drivers/pcmcia/electra_cf.c
@@ -178,10 +178,9 @@ static int electra_cf_probe(struct platf
 	struct device_node *np = ofdev->dev.of_node;
 	struct electra_cf_socket   *cf;
 	struct resource mem, io;
-	int status;
+	int status = -ENOMEM;
 	const unsigned int *prop;
 	int err;
-	struct vm_struct *area;
 
 	err = of_address_to_resource(np, 0, &mem);
 	if (err)
@@ -202,30 +201,19 @@ static int electra_cf_probe(struct platf
 	cf->mem_phys = mem.start;
 	cf->mem_size = PAGE_ALIGN(resource_size(&mem));
 	cf->mem_base = ioremap(cf->mem_phys, cf->mem_size);
+	if (!cf->mem_base)
+		goto out_free_cf;
 	cf->io_size = PAGE_ALIGN(resource_size(&io));
-
-	area = __get_vm_area(cf->io_size, 0, PHB_IO_BASE, PHB_IO_END);
-	if (area == NULL) {
-		status = -ENOMEM;
-		goto fail1;
-	}
-
-	cf->io_virt = (void __iomem *)(area->addr);
+	cf->io_virt = ioremap_phb(io.start, cf->io_size);
+	if (!cf->io_virt)
+		goto out_unmap_mem;
 
 	cf->gpio_base = ioremap(0xfc103000, 0x1000);
+	if (!cf->gpio_base)
+		goto out_unmap_virt;
 	dev_set_drvdata(device, cf);
 
-	if (!cf->mem_base || !cf->io_virt || !cf->gpio_base ||
-	    (__ioremap_at(io.start, cf->io_virt, cf->io_size,
-			  pgprot_noncached(PAGE_KERNEL)) == NULL)) {
-		dev_err(device, "can't ioremap ranges\n");
-		status = -ENOMEM;
-		goto fail1;
-	}
-
-
 	cf->io_base = (unsigned long)cf->io_virt - VMALLOC_END;
-
 	cf->iomem.start = (unsigned long)cf->mem_base;
 	cf->iomem.end = (unsigned long)cf->mem_base + (mem.end - mem.start);
 	cf->iomem.flags = IORESOURCE_MEM;
@@ -305,14 +293,13 @@ fail1:
 	if (cf->irq)
 		free_irq(cf->irq, cf);
 
-	if (cf->io_virt)
-		__iounmap_at(cf->io_virt, cf->io_size);
-	if (cf->mem_base)
-		iounmap(cf->mem_base);
-	if (cf->gpio_base)
-		iounmap(cf->gpio_base);
-	if (area)
-		device_init_wakeup(&ofdev->dev, 0);
+	iounmap(cf->gpio_base);
+out_unmap_virt:
+	device_init_wakeup(&ofdev->dev, 0);
+	iounmap(cf->io_virt);
+out_unmap_mem:
+	iounmap(cf->mem_base);
+out_free_cf:
 	kfree(cf);
 	return status;
 
@@ -330,7 +317,7 @@ static int electra_cf_remove(struct plat
 	free_irq(cf->irq, cf);
 	del_timer_sync(&cf->timer);
 
-	__iounmap_at(cf->io_virt, cf->io_size);
+	iounmap(cf->io_virt);
 	iounmap(cf->mem_base);
 	iounmap(cf->gpio_base);
 	release_mem_region(cf->mem_phys, cf->mem_size);
_
