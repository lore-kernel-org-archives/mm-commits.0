Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	URIBL_RED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB443C433ED
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:43:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BDC3B613C5
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:43:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229641AbhEHWoU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:44:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:51666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229559AbhEHWoT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:44:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8ECC3613EA;
        Sat,  8 May 2021 22:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620513797;
        bh=Da6T/17LIWsnTH9F0VN1xycVm4HAKfTSrz3K+WLgxn8=;
        h=Date:From:To:Subject:From;
        b=l1UOwtiup3sfVC3wT+yy8cnd22/ky4LAM8qqnaiUpGn+1bWIFeFv7g7NHbq1UToke
         Xqiw5o1VeAncaMi0BQNoKM/lbF1XfhXIWWCushvBIuO6eRpFLbA2c/pcVyZNwTHyGg
         ma64CEzd0n6mGqWo5S/w/yPB3/fp093W1sijGyM0=
Date:   Sat, 08 May 2021 15:43:17 -0700
From:   akpm@linux-foundation.org
To:     clg@kaod.org, hch@lst.de, mm-commits@vger.kernel.org,
        npiggin@gmail.com, urezki@gmail.com
Subject:  [merged] mm-vmalloc-remove-unmap_kernel_range.patch
 removed from -mm tree
Message-ID: <20210508224317.uQTDQVAFv%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc: remove unmap_kernel_range
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-remove-unmap_kernel_range.patch

This patch was dropped because it was merged into mainline or a subsystem t=
ree

------------------------------------------------------
=46rom: Nicholas Piggin <npiggin@gmail.com>
Subject: mm/vmalloc: remove unmap_kernel_range

This is a shim around vunmap_range, get rid of it.

Move the main API comment from the _noflush variant to the normal
variant, and make _noflush internal to mm/.

[npiggin@gmail.com: fix nommu builds and a comment bug per sfr]
  Link: https://lkml.kernel.org/r/1617292598.m6g0knx24s.astroid@bobo.none
[akpm@linux-foundation.org: move vunmap_range_noflush() stub inside !CONFIG=
_MMU, not !CONFIG_NUMA]
[npiggin@gmail.com: fix nommu builds]
  Link: https://lkml.kernel.org/r/1617292497.o1uhq5ipxp.astroid@bobo.none
Link: https://lkml.kernel.org/r/20210322021806.892164-5-npiggin@gmail.com
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: C=C3=A9dric Le Goater <clg@kaod.org>
Cc: Uladzislau Rezki <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/core-api/cachetlb.rst |    2=20
 arch/arm64/mm/init.c                |    2=20
 arch/powerpc/kernel/isa-bridge.c    |    4 -
 arch/powerpc/kernel/pci_64.c        |    2=20
 arch/powerpc/mm/ioremap.c           |    2=20
 drivers/pci/pci.c                   |    2=20
 include/linux/vmalloc.h             |    8 ---
 mm/internal.h                       |   15 ++++++
 mm/percpu-vm.c                      |    2=20
 mm/vmalloc.c                        |   59 ++++++++++++--------------
 10 files changed, 51 insertions(+), 47 deletions(-)

--- a/arch/arm64/mm/init.c~mm-vmalloc-remove-unmap_kernel_range
+++ a/arch/arm64/mm/init.c
@@ -521,7 +521,7 @@ void free_initmem(void)
 	 * prevents the region from being reused for kernel modules, which
 	 * is not supported by kallsyms.
 	 */
-	unmap_kernel_range((u64)__init_begin, (u64)(__init_end - __init_begin));
+	vunmap_range((u64)__init_begin, (u64)__init_end);
 }
=20
 void dump_mem_limit(void)
--- a/arch/powerpc/kernel/isa-bridge.c~mm-vmalloc-remove-unmap_kernel_range
+++ a/arch/powerpc/kernel/isa-bridge.c
@@ -48,7 +48,7 @@ static void remap_isa_base(phys_addr_t p
 	if (slab_is_available()) {
 		if (ioremap_page_range(ISA_IO_BASE, ISA_IO_BASE + size, pa,
 				pgprot_noncached(PAGE_KERNEL)))
-			unmap_kernel_range(ISA_IO_BASE, size);
+			vunmap_range(ISA_IO_BASE, ISA_IO_BASE + size);
 	} else {
 		early_ioremap_range(ISA_IO_BASE, pa, size,
 				pgprot_noncached(PAGE_KERNEL));
@@ -311,7 +311,7 @@ static void isa_bridge_remove(void)
 	isa_bridge_pcidev =3D NULL;
=20
 	/* Unmap the ISA area */
-	unmap_kernel_range(ISA_IO_BASE, 0x10000);
+	vunmap_range(ISA_IO_BASE, ISA_IO_BASE + 0x10000);
 }
=20
 /**
--- a/arch/powerpc/kernel/pci_64.c~mm-vmalloc-remove-unmap_kernel_range
+++ a/arch/powerpc/kernel/pci_64.c
@@ -140,7 +140,7 @@ void __iomem *ioremap_phb(phys_addr_t pa
 	addr =3D (unsigned long)area->addr;
 	if (ioremap_page_range(addr, addr + size, paddr,
 			pgprot_noncached(PAGE_KERNEL))) {
-		unmap_kernel_range(addr, size);
+		vunmap_range(addr, addr + size);
 		return NULL;
 	}
=20
--- a/arch/powerpc/mm/ioremap.c~mm-vmalloc-remove-unmap_kernel_range
+++ a/arch/powerpc/mm/ioremap.c
@@ -93,7 +93,7 @@ void __iomem *do_ioremap(phys_addr_t pa,
 	if (!ret)
 		return (void __iomem *)area->addr + offset;
=20
-	unmap_kernel_range(va, size);
+	vunmap_range(va, va + size);
 	free_vm_area(area);
=20
 	return NULL;
--- a/Documentation/core-api/cachetlb.rst~mm-vmalloc-remove-unmap_kernel_ra=
nge
+++ a/Documentation/core-api/cachetlb.rst
@@ -215,7 +215,7 @@ Here are the routines, one by one:
=20
 	The first of these two routines is invoked after vmap_range()
 	has installed the page table entries.  The second is invoked
-	before unmap_kernel_range() deletes the page table entries.
+	before vunmap_range() deletes the page table entries.
=20
 There exists another whole class of cpu cache issues which currently
 require a whole different set of interfaces to handle properly.
--- a/drivers/pci/pci.c~mm-vmalloc-remove-unmap_kernel_range
+++ a/drivers/pci/pci.c
@@ -4102,7 +4102,7 @@ void pci_unmap_iospace(struct resource *
 #if defined(PCI_IOBASE) && defined(CONFIG_MMU)
 	unsigned long vaddr =3D (unsigned long)PCI_IOBASE + res->start;
=20
-	unmap_kernel_range(vaddr, resource_size(res));
+	vunmap_range(vaddr, vaddr + resource_size(res));
 #endif
 }
 EXPORT_SYMBOL(pci_unmap_iospace);
--- a/include/linux/vmalloc.h~mm-vmalloc-remove-unmap_kernel_range
+++ a/include/linux/vmalloc.h
@@ -212,8 +212,7 @@ static inline bool is_vm_area_hugepages(
 int vmap_range(unsigned long addr, unsigned long end,
 			phys_addr_t phys_addr, pgprot_t prot,
 			unsigned int max_page_shift);
-extern void unmap_kernel_range_noflush(unsigned long addr, unsigned long s=
ize);
-extern void unmap_kernel_range(unsigned long addr, unsigned long size);
+void vunmap_range(unsigned long addr, unsigned long end);
 static inline void set_vm_flush_reset_perms(void *addr)
 {
 	struct vm_struct *vm =3D find_vm_area(addr);
@@ -223,11 +222,6 @@ static inline void set_vm_flush_reset_pe
 }
=20
 #else
-static inline void
-unmap_kernel_range_noflush(unsigned long addr, unsigned long size)
-{
-}
-#define unmap_kernel_range unmap_kernel_range_noflush
 static inline void set_vm_flush_reset_perms(void *addr)
 {
 }
--- a/mm/internal.h~mm-vmalloc-remove-unmap_kernel_range
+++ a/mm/internal.h
@@ -446,7 +446,9 @@ static inline struct file *maybe_unlock_
 static inline void clear_page_mlock(struct page *page) { }
 static inline void mlock_vma_page(struct page *page) { }
 static inline void mlock_migrate_page(struct page *new, struct page *old) =
{ }
-
+static inline void vunmap_range_noflush(unsigned long start, unsigned long=
 end)
+{
+}
 #endif /* !CONFIG_MMU */
=20
 /*
@@ -640,7 +642,18 @@ struct migration_target_control {
 /*
  * mm/vmalloc.c
  */
+#ifdef CONFIG_MMU
 int vmap_pages_range_noflush(unsigned long addr, unsigned long end,
                 pgprot_t prot, struct page **pages, unsigned int page_shif=
t);
+#else
+static inline
+int vmap_pages_range_noflush(unsigned long addr, unsigned long end,
+                pgprot_t prot, struct page **pages, unsigned int page_shif=
t)
+{
+	return -EINVAL;
+}
+#endif
+
+void vunmap_range_noflush(unsigned long start, unsigned long end);
=20
 #endif	/* __MM_INTERNAL_H */
--- a/mm/percpu-vm.c~mm-vmalloc-remove-unmap_kernel_range
+++ a/mm/percpu-vm.c
@@ -134,7 +134,7 @@ static void pcpu_pre_unmap_flush(struct
=20
 static void __pcpu_unmap_pages(unsigned long addr, int nr_pages)
 {
-	unmap_kernel_range_noflush(addr, nr_pages << PAGE_SHIFT);
+	vunmap_range_noflush(addr, addr + (nr_pages << PAGE_SHIFT));
 }
=20
 /**
--- a/mm/vmalloc.c~mm-vmalloc-remove-unmap_kernel_range
+++ a/mm/vmalloc.c
@@ -378,22 +378,20 @@ static void vunmap_p4d_range(pgd_t *pgd,
 	} while (p4d++, addr =3D next, addr !=3D end);
 }
=20
-/**
- * unmap_kernel_range_noflush - unmap kernel VM area
- * @start: start of the VM area to unmap
- * @size: size of the VM area to unmap
+/*
+ * vunmap_range_noflush is similar to vunmap_range, but does not
+ * flush caches or TLBs.
  *
- * Unmap PFN_UP(@size) pages at @addr.  The VM area @addr and @size specify
- * should have been allocated using get_vm_area() and its friends.
+ * The caller is responsible for calling flush_cache_vmap() before calling
+ * this function, and flush_tlb_kernel_range after it has returned
+ * successfully (and before the addresses are expected to cause a page fau=
lt
+ * or be re-mapped for something else, if TLB flushes are being delayed or
+ * coalesced).
  *
- * NOTE:
- * This function does NOT do any cache flushing.  The caller is responsible
- * for calling flush_cache_vunmap() on to-be-mapped areas before calling t=
his
- * function and flush_tlb_kernel_range() after.
+ * This is an internal function only. Do not use outside mm/.
  */
-void unmap_kernel_range_noflush(unsigned long start, unsigned long size)
+void vunmap_range_noflush(unsigned long start, unsigned long end)
 {
-	unsigned long end =3D start + size;
 	unsigned long next;
 	pgd_t *pgd;
 	unsigned long addr =3D start;
@@ -414,6 +412,22 @@ void unmap_kernel_range_noflush(unsigned
 		arch_sync_kernel_mappings(start, end);
 }
=20
+/**
+ * vunmap_range - unmap kernel virtual addresses
+ * @addr: start of the VM area to unmap
+ * @end: end of the VM area to unmap (non-inclusive)
+ *
+ * Clears any present PTEs in the virtual address range, flushes TLBs and
+ * caches. Any subsequent access to the address before it has been re-mapp=
ed
+ * is a kernel bug.
+ */
+void vunmap_range(unsigned long addr, unsigned long end)
+{
+	flush_cache_vunmap(addr, end);
+	vunmap_range_noflush(addr, end);
+	flush_tlb_kernel_range(addr, end);
+}
+
 static int vmap_pages_pte_range(pmd_t *pmd, unsigned long addr,
 		unsigned long end, pgprot_t prot, struct page **pages, int *nr,
 		pgtbl_mod_mask *mask)
@@ -1712,7 +1726,7 @@ static void free_vmap_area_noflush(struc
 static void free_unmap_vmap_area(struct vmap_area *va)
 {
 	flush_cache_vunmap(va->va_start, va->va_end);
-	unmap_kernel_range_noflush(va->va_start, va->va_end - va->va_start);
+	vunmap_range_noflush(va->va_start, va->va_end);
 	if (debug_pagealloc_enabled_static())
 		flush_tlb_kernel_range(va->va_start, va->va_end);
=20
@@ -1990,7 +2004,7 @@ static void vb_free(unsigned long addr,
 	offset =3D (addr & (VMAP_BLOCK_SIZE - 1)) >> PAGE_SHIFT;
 	vb =3D xa_load(&vmap_blocks, addr_to_vb_idx(addr));
=20
-	unmap_kernel_range_noflush(addr, size);
+	vunmap_range_noflush(addr, addr + size);
=20
 	if (debug_pagealloc_enabled_static())
 		flush_tlb_kernel_range(addr, addr + size);
@@ -2307,23 +2321,6 @@ void __init vmalloc_init(void)
 	vmap_initialized =3D true;
 }
=20
-/**
- * unmap_kernel_range - unmap kernel VM area and flush cache and TLB
- * @addr: start of the VM area to unmap
- * @size: size of the VM area to unmap
- *
- * Similar to unmap_kernel_range_noflush() but flushes vcache before
- * the unmapping and tlb after.
- */
-void unmap_kernel_range(unsigned long addr, unsigned long size)
-{
-	unsigned long end =3D addr + size;
-
-	flush_cache_vunmap(addr, end);
-	unmap_kernel_range_noflush(addr, size);
-	flush_tlb_kernel_range(addr, end);
-}
-
 static inline void setup_vmalloc_vm_locked(struct vm_struct *vm,
 	struct vmap_area *va, unsigned long flags, const void *caller)
 {
_

Patches currently in -mm which might be from npiggin@gmail.com are


