From: akpm@linux-foundation.org
Subject: [merged] treewide-replace-obsolete-_refok-by-__ref.patch removed
 from -mm tree
Date: Wed, 03 Aug 2016 11:11:44 -0700
Message-ID: <57a233e0.IlkjHeeGXHQTjj74%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33452 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755571AbcHCSN0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Aug 2016 14:13:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, mingo@redhat.com, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     Subject: treewide: replace obsolete _refok by __ref
has been removed from the -mm tree.  Its filename was
     treewide-replace-obsolete-_refok-by-__ref.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: treewide: replace obsolete _refok by __ref

There was only one use of __initdata_refok and __exit_refok
__init_refok was used 46 times against 82 for __ref.

Those definitions are obsolete since

commit 312b1485fb50
("Introduce new section reference annotations tags: __ref,
__refdata, __refconst")

This patch removes the following compatibility definitions
and replaces them treewide.

/* compatibility defines */
#define __init_refok     __ref
#define __initdata_refok __refdata
#define __exit_refok     __ref

I can also provide separate patches if necessary.
(One patch per tree and check in 1 month or 2 to remove old definitions)

[akpm@linux-foundation.org: coding-style fixes]
Link: http://lkml.kernel.org/r/1466796271-3043-1-git-send-email-fabf@skynet.be
Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/kernel/machvec_impl.h         |    2 +-
 arch/arc/mm/init.c                       |    2 +-
 arch/arm/mach-integrator/impd1.c         |    4 ++--
 arch/arm/mach-mv78xx0/common.c           |    2 +-
 arch/blackfin/mm/init.c                  |    2 +-
 arch/hexagon/mm/init.c                   |    2 +-
 arch/ia64/kernel/mca.c                   |    2 +-
 arch/microblaze/mm/init.c                |    4 ++--
 arch/microblaze/mm/pgtable.c             |    2 +-
 arch/mips/mm/init.c                      |    2 +-
 arch/mips/txx9/generic/pci.c             |    2 +-
 arch/nios2/mm/init.c                     |    2 +-
 arch/openrisc/mm/ioremap.c               |    4 ++--
 arch/powerpc/lib/alloc.c                 |    2 +-
 arch/powerpc/mm/pgtable_32.c             |    2 +-
 arch/powerpc/platforms/powermac/setup.c  |    4 ++--
 arch/powerpc/platforms/ps3/device-init.c |    2 +-
 arch/powerpc/sysdev/msi_bitmap.c         |    2 +-
 arch/score/mm/init.c                     |    2 +-
 arch/sh/drivers/pci/pci.c                |    4 ++--
 arch/sh/mm/ioremap.c                     |    2 +-
 arch/x86/mm/init.c                       |    4 ++--
 arch/x86/platform/efi/early_printk.c     |    4 ++--
 drivers/acpi/osl.c                       |    5 ++---
 drivers/base/node.c                      |    2 +-
 drivers/clk/clkdev.c                     |    4 ++--
 drivers/pci/xen-pcifront.c               |    2 +-
 drivers/video/logo/logo.c                |    4 ++--
 include/acpi/acpi_io.h                   |    2 +-
 include/linux/init.h                     |    6 ------
 include/net/net_namespace.h              |    2 +-
 init/main.c                              |    2 +-
 mm/page_alloc.c                          |    4 ++--
 mm/slab.c                                |    2 +-
 mm/sparse-vmemmap.c                      |    2 +-
 mm/sparse.c                              |    2 +-
 36 files changed, 46 insertions(+), 53 deletions(-)

diff -puN arch/alpha/kernel/machvec_impl.h~treewide-replace-obsolete-_refok-by-__ref arch/alpha/kernel/machvec_impl.h
--- a/arch/alpha/kernel/machvec_impl.h~treewide-replace-obsolete-_refok-by-__ref
+++ a/arch/alpha/kernel/machvec_impl.h
@@ -137,7 +137,7 @@
 #define __initmv __initdata
 #define ALIAS_MV(x)
 #else
-#define __initmv __initdata_refok
+#define __initmv __refdata
 
 /* GCC actually has a syntax for defining aliases, but is under some
    delusion that you shouldn't be able to declare it extern somewhere
diff -puN arch/arc/mm/init.c~treewide-replace-obsolete-_refok-by-__ref arch/arc/mm/init.c
--- a/arch/arc/mm/init.c~treewide-replace-obsolete-_refok-by-__ref
+++ a/arch/arc/mm/init.c
@@ -220,7 +220,7 @@ void __init mem_init(void)
 /*
  * free_initmem: Free all the __init memory.
  */
-void __init_refok free_initmem(void)
+void __ref free_initmem(void)
 {
 	free_initmem_default(-1);
 }
diff -puN arch/arm/mach-integrator/impd1.c~treewide-replace-obsolete-_refok-by-__ref arch/arm/mach-integrator/impd1.c
--- a/arch/arm/mach-integrator/impd1.c~treewide-replace-obsolete-_refok-by-__ref
+++ a/arch/arm/mach-integrator/impd1.c
@@ -320,11 +320,11 @@ static struct impd1_device impd1_devs[]
 #define IMPD1_VALID_IRQS 0x00000bffU
 
 /*
- * As this module is bool, it is OK to have this as __init_refok() - no
+ * As this module is bool, it is OK to have this as __ref() - no
  * probe calls will be done after the initial system bootup, as devices
  * are discovered as part of the machine startup.
  */
-static int __init_refok impd1_probe(struct lm_device *dev)
+static int __ref impd1_probe(struct lm_device *dev)
 {
 	struct impd1_module *impd1;
 	int irq_base;
diff -puN arch/arm/mach-mv78xx0/common.c~treewide-replace-obsolete-_refok-by-__ref arch/arm/mach-mv78xx0/common.c
--- a/arch/arm/mach-mv78xx0/common.c~treewide-replace-obsolete-_refok-by-__ref
+++ a/arch/arm/mach-mv78xx0/common.c
@@ -343,7 +343,7 @@ void __init mv78xx0_init_early(void)
 				DDR_WINDOW_CPU1_BASE, DDR_WINDOW_CPU_SZ);
 }
 
-void __init_refok mv78xx0_timer_init(void)
+void __ref mv78xx0_timer_init(void)
 {
 	orion_time_init(BRIDGE_VIRT_BASE, BRIDGE_INT_TIMER1_CLR,
 			IRQ_MV78XX0_TIMER_1, get_tclk());
diff -puN arch/blackfin/mm/init.c~treewide-replace-obsolete-_refok-by-__ref arch/blackfin/mm/init.c
--- a/arch/blackfin/mm/init.c~treewide-replace-obsolete-_refok-by-__ref
+++ a/arch/blackfin/mm/init.c
@@ -112,7 +112,7 @@ void __init free_initrd_mem(unsigned lon
 }
 #endif
 
-void __init_refok free_initmem(void)
+void __ref free_initmem(void)
 {
 #if defined CONFIG_RAMKERNEL && !defined CONFIG_MPU
 	free_initmem_default(-1);
diff -puN arch/hexagon/mm/init.c~treewide-replace-obsolete-_refok-by-__ref arch/hexagon/mm/init.c
--- a/arch/hexagon/mm/init.c~treewide-replace-obsolete-_refok-by-__ref
+++ a/arch/hexagon/mm/init.c
@@ -93,7 +93,7 @@ void __init mem_init(void)
  * Todo:  free pages between __init_begin and __init_end; possibly
  * some devtree related stuff as well.
  */
-void __init_refok free_initmem(void)
+void __ref free_initmem(void)
 {
 }
 
diff -puN arch/ia64/kernel/mca.c~treewide-replace-obsolete-_refok-by-__ref arch/ia64/kernel/mca.c
--- a/arch/ia64/kernel/mca.c~treewide-replace-obsolete-_refok-by-__ref
+++ a/arch/ia64/kernel/mca.c
@@ -1831,7 +1831,7 @@ format_mca_init_stack(void *mca_data, un
 }
 
 /* Caller prevents this from being called after init */
-static void * __init_refok mca_bootmem(void)
+static void * __ref mca_bootmem(void)
 {
 	return __alloc_bootmem(sizeof(struct ia64_mca_cpu),
 	                    KERNEL_STACK_SIZE, 0);
diff -puN arch/microblaze/mm/init.c~treewide-replace-obsolete-_refok-by-__ref arch/microblaze/mm/init.c
--- a/arch/microblaze/mm/init.c~treewide-replace-obsolete-_refok-by-__ref
+++ a/arch/microblaze/mm/init.c
@@ -414,7 +414,7 @@ void __init *early_get_page(void)
 
 #endif /* CONFIG_MMU */
 
-void * __init_refok alloc_maybe_bootmem(size_t size, gfp_t mask)
+void * __ref alloc_maybe_bootmem(size_t size, gfp_t mask)
 {
 	if (mem_init_done)
 		return kmalloc(size, mask);
@@ -422,7 +422,7 @@ void * __init_refok alloc_maybe_bootmem(
 		return alloc_bootmem(size);
 }
 
-void * __init_refok zalloc_maybe_bootmem(size_t size, gfp_t mask)
+void * __ref zalloc_maybe_bootmem(size_t size, gfp_t mask)
 {
 	void *p;
 
diff -puN arch/microblaze/mm/pgtable.c~treewide-replace-obsolete-_refok-by-__ref arch/microblaze/mm/pgtable.c
--- a/arch/microblaze/mm/pgtable.c~treewide-replace-obsolete-_refok-by-__ref
+++ a/arch/microblaze/mm/pgtable.c
@@ -234,7 +234,7 @@ unsigned long iopa(unsigned long addr)
 	return pa;
 }
 
-__init_refok pte_t *pte_alloc_one_kernel(struct mm_struct *mm,
+__ref pte_t *pte_alloc_one_kernel(struct mm_struct *mm,
 		unsigned long address)
 {
 	pte_t *pte;
diff -puN arch/mips/mm/init.c~treewide-replace-obsolete-_refok-by-__ref arch/mips/mm/init.c
--- a/arch/mips/mm/init.c~treewide-replace-obsolete-_refok-by-__ref
+++ a/arch/mips/mm/init.c
@@ -504,7 +504,7 @@ void free_initrd_mem(unsigned long start
 
 void (*free_init_pages_eva)(void *begin, void *end) = NULL;
 
-void __init_refok free_initmem(void)
+void __ref free_initmem(void)
 {
 	prom_free_prom_memory();
 	/*
diff -puN arch/mips/txx9/generic/pci.c~treewide-replace-obsolete-_refok-by-__ref arch/mips/txx9/generic/pci.c
--- a/arch/mips/txx9/generic/pci.c~treewide-replace-obsolete-_refok-by-__ref
+++ a/arch/mips/txx9/generic/pci.c
@@ -268,7 +268,7 @@ static int txx9_i8259_irq_setup(int irq)
 	return err;
 }
 
-static void __init_refok quirk_slc90e66_bridge(struct pci_dev *dev)
+static void __ref quirk_slc90e66_bridge(struct pci_dev *dev)
 {
 	int irq;	/* PCI/ISA Bridge interrupt */
 	u8 reg_64;
diff -puN arch/nios2/mm/init.c~treewide-replace-obsolete-_refok-by-__ref arch/nios2/mm/init.c
--- a/arch/nios2/mm/init.c~treewide-replace-obsolete-_refok-by-__ref
+++ a/arch/nios2/mm/init.c
@@ -89,7 +89,7 @@ void __init free_initrd_mem(unsigned lon
 }
 #endif
 
-void __init_refok free_initmem(void)
+void __ref free_initmem(void)
 {
 	free_initmem_default(-1);
 }
diff -puN arch/openrisc/mm/ioremap.c~treewide-replace-obsolete-_refok-by-__ref arch/openrisc/mm/ioremap.c
--- a/arch/openrisc/mm/ioremap.c~treewide-replace-obsolete-_refok-by-__ref
+++ a/arch/openrisc/mm/ioremap.c
@@ -38,7 +38,7 @@ static unsigned int fixmaps_used __initd
  * have to convert them into an offset in a page-aligned mapping, but the
  * caller shouldn't need to know that small detail.
  */
-void __iomem *__init_refok
+void __iomem *__ref
 __ioremap(phys_addr_t addr, unsigned long size, pgprot_t prot)
 {
 	phys_addr_t p;
@@ -116,7 +116,7 @@ void iounmap(void *addr)
  * the memblock infrastructure.
  */
 
-pte_t __init_refok *pte_alloc_one_kernel(struct mm_struct *mm,
+pte_t __ref *pte_alloc_one_kernel(struct mm_struct *mm,
 					 unsigned long address)
 {
 	pte_t *pte;
diff -puN arch/powerpc/lib/alloc.c~treewide-replace-obsolete-_refok-by-__ref arch/powerpc/lib/alloc.c
--- a/arch/powerpc/lib/alloc.c~treewide-replace-obsolete-_refok-by-__ref
+++ a/arch/powerpc/lib/alloc.c
@@ -6,7 +6,7 @@
 #include <asm/setup.h>
 
 
-void * __init_refok zalloc_maybe_bootmem(size_t size, gfp_t mask)
+void * __ref zalloc_maybe_bootmem(size_t size, gfp_t mask)
 {
 	void *p;
 
diff -puN arch/powerpc/mm/pgtable_32.c~treewide-replace-obsolete-_refok-by-__ref arch/powerpc/mm/pgtable_32.c
--- a/arch/powerpc/mm/pgtable_32.c~treewide-replace-obsolete-_refok-by-__ref
+++ a/arch/powerpc/mm/pgtable_32.c
@@ -79,7 +79,7 @@ void pgd_free(struct mm_struct *mm, pgd_
 #endif
 }
 
-__init_refok pte_t *pte_alloc_one_kernel(struct mm_struct *mm, unsigned long address)
+__ref pte_t *pte_alloc_one_kernel(struct mm_struct *mm, unsigned long address)
 {
 	pte_t *pte;
 
diff -puN arch/powerpc/platforms/powermac/setup.c~treewide-replace-obsolete-_refok-by-__ref arch/powerpc/platforms/powermac/setup.c
--- a/arch/powerpc/platforms/powermac/setup.c~treewide-replace-obsolete-_refok-by-__ref
+++ a/arch/powerpc/platforms/powermac/setup.c
@@ -353,12 +353,12 @@ static int pmac_late_init(void)
 machine_late_initcall(powermac, pmac_late_init);
 
 /*
- * This is __init_refok because we check for "initializing" before
+ * This is __ref because we check for "initializing" before
  * touching any of the __init sensitive things and "initializing"
  * will be false after __init time. This can't be __init because it
  * can be called whenever a disk is first accessed.
  */
-void __init_refok note_bootable_part(dev_t dev, int part, int goodness)
+void __ref note_bootable_part(dev_t dev, int part, int goodness)
 {
 	char *p;
 
diff -puN arch/powerpc/platforms/ps3/device-init.c~treewide-replace-obsolete-_refok-by-__ref arch/powerpc/platforms/ps3/device-init.c
--- a/arch/powerpc/platforms/ps3/device-init.c~treewide-replace-obsolete-_refok-by-__ref
+++ a/arch/powerpc/platforms/ps3/device-init.c
@@ -189,7 +189,7 @@ fail_malloc:
 	return result;
 }
 
-static int __init_refok ps3_setup_uhc_device(
+static int __ref ps3_setup_uhc_device(
 	const struct ps3_repository_device *repo, enum ps3_match_id match_id,
 	enum ps3_interrupt_type interrupt_type, enum ps3_reg_type reg_type)
 {
diff -puN arch/powerpc/sysdev/msi_bitmap.c~treewide-replace-obsolete-_refok-by-__ref arch/powerpc/sysdev/msi_bitmap.c
--- a/arch/powerpc/sysdev/msi_bitmap.c~treewide-replace-obsolete-_refok-by-__ref
+++ a/arch/powerpc/sysdev/msi_bitmap.c
@@ -112,7 +112,7 @@ int msi_bitmap_reserve_dt_hwirqs(struct
 	return 0;
 }
 
-int __init_refok msi_bitmap_alloc(struct msi_bitmap *bmp, unsigned int irq_count,
+int __ref msi_bitmap_alloc(struct msi_bitmap *bmp, unsigned int irq_count,
 		     struct device_node *of_node)
 {
 	int size;
diff -puN arch/score/mm/init.c~treewide-replace-obsolete-_refok-by-__ref arch/score/mm/init.c
--- a/arch/score/mm/init.c~treewide-replace-obsolete-_refok-by-__ref
+++ a/arch/score/mm/init.c
@@ -91,7 +91,7 @@ void free_initrd_mem(unsigned long start
 }
 #endif
 
-void __init_refok free_initmem(void)
+void __ref free_initmem(void)
 {
 	free_initmem_default(POISON_FREE_INITMEM);
 }
diff -puN arch/sh/drivers/pci/pci.c~treewide-replace-obsolete-_refok-by-__ref arch/sh/drivers/pci/pci.c
--- a/arch/sh/drivers/pci/pci.c~treewide-replace-obsolete-_refok-by-__ref
+++ a/arch/sh/drivers/pci/pci.c
@@ -221,7 +221,7 @@ pcibios_bus_report_status_early(struct p
  * We can't use pci_find_device() here since we are
  * called from interrupt context.
  */
-static void __init_refok
+static void __ref
 pcibios_bus_report_status(struct pci_bus *bus, unsigned int status_mask,
 			  int warn)
 {
@@ -256,7 +256,7 @@ pcibios_bus_report_status(struct pci_bus
 			pcibios_bus_report_status(dev->subordinate, status_mask, warn);
 }
 
-void __init_refok pcibios_report_status(unsigned int status_mask, int warn)
+void __ref pcibios_report_status(unsigned int status_mask, int warn)
 {
 	struct pci_channel *hose;
 
diff -puN arch/sh/mm/ioremap.c~treewide-replace-obsolete-_refok-by-__ref arch/sh/mm/ioremap.c
--- a/arch/sh/mm/ioremap.c~treewide-replace-obsolete-_refok-by-__ref
+++ a/arch/sh/mm/ioremap.c
@@ -34,7 +34,7 @@
  * have to convert them into an offset in a page-aligned mapping, but the
  * caller shouldn't need to know that small detail.
  */
-void __iomem * __init_refok
+void __iomem * __ref
 __ioremap_caller(phys_addr_t phys_addr, unsigned long size,
 		 pgprot_t pgprot, void *caller)
 {
diff -puN arch/x86/mm/init.c~treewide-replace-obsolete-_refok-by-__ref arch/x86/mm/init.c
--- a/arch/x86/mm/init.c~treewide-replace-obsolete-_refok-by-__ref
+++ a/arch/x86/mm/init.c
@@ -208,7 +208,7 @@ static int __meminit save_mr(struct map_
  * adjust the page_size_mask for small range to go with
  *	big page size instead small one if nearby are ram too.
  */
-static void __init_refok adjust_range_page_size_mask(struct map_range *mr,
+static void __ref adjust_range_page_size_mask(struct map_range *mr,
 							 int nr_range)
 {
 	int i;
@@ -396,7 +396,7 @@ bool pfn_range_is_mapped(unsigned long s
  * This runs before bootmem is initialized and gets pages directly from
  * the physical memory. To access them they are temporarily mapped.
  */
-unsigned long __init_refok init_memory_mapping(unsigned long start,
+unsigned long __ref init_memory_mapping(unsigned long start,
 					       unsigned long end)
 {
 	struct map_range mr[NR_RANGE_MR];
diff -puN arch/x86/platform/efi/early_printk.c~treewide-replace-obsolete-_refok-by-__ref arch/x86/platform/efi/early_printk.c
--- a/arch/x86/platform/efi/early_printk.c~treewide-replace-obsolete-_refok-by-__ref
+++ a/arch/x86/platform/efi/early_printk.c
@@ -44,7 +44,7 @@ early_initcall(early_efi_map_fb);
  * In case earlyprintk=efi,keep we have the whole framebuffer mapped already
  * so just return the offset efi_fb + start.
  */
-static __init_refok void *early_efi_map(unsigned long start, unsigned long len)
+static __ref void *early_efi_map(unsigned long start, unsigned long len)
 {
 	unsigned long base;
 
@@ -56,7 +56,7 @@ static __init_refok void *early_efi_map(
 		return early_ioremap(base + start, len);
 }
 
-static __init_refok void early_efi_unmap(void *addr, unsigned long len)
+static __ref void early_efi_unmap(void *addr, unsigned long len)
 {
 	if (!efi_fb)
 		early_iounmap(addr, len);
diff -puN drivers/acpi/osl.c~treewide-replace-obsolete-_refok-by-__ref drivers/acpi/osl.c
--- a/drivers/acpi/osl.c~treewide-replace-obsolete-_refok-by-__ref
+++ a/drivers/acpi/osl.c
@@ -309,7 +309,7 @@ static void acpi_unmap(acpi_physical_add
  * During early init (when acpi_gbl_permanent_mmap has not been set yet) this
  * routine simply calls __acpi_map_table() to get the job done.
  */
-void __iomem *__init_refok
+void __iomem *__ref
 acpi_os_map_iomem(acpi_physical_address phys, acpi_size size)
 {
 	struct acpi_ioremap *map;
@@ -362,8 +362,7 @@ out:
 }
 EXPORT_SYMBOL_GPL(acpi_os_map_iomem);
 
-void *__init_refok
-acpi_os_map_memory(acpi_physical_address phys, acpi_size size)
+void *__ref acpi_os_map_memory(acpi_physical_address phys, acpi_size size)
 {
 	return (void *)acpi_os_map_iomem(phys, size);
 }
diff -puN drivers/base/node.c~treewide-replace-obsolete-_refok-by-__ref drivers/base/node.c
--- a/drivers/base/node.c~treewide-replace-obsolete-_refok-by-__ref
+++ a/drivers/base/node.c
@@ -370,7 +370,7 @@ int unregister_cpu_under_node(unsigned i
 #ifdef CONFIG_MEMORY_HOTPLUG_SPARSE
 #define page_initialized(page)  (page->lru.next)
 
-static int __init_refok get_nid_for_pfn(unsigned long pfn)
+static int __ref get_nid_for_pfn(unsigned long pfn)
 {
 	struct page *page;
 
diff -puN drivers/clk/clkdev.c~treewide-replace-obsolete-_refok-by-__ref drivers/clk/clkdev.c
--- a/drivers/clk/clkdev.c~treewide-replace-obsolete-_refok-by-__ref
+++ a/drivers/clk/clkdev.c
@@ -250,7 +250,7 @@ struct clk_lookup_alloc {
 	char	con_id[MAX_CON_ID];
 };
 
-static struct clk_lookup * __init_refok
+static struct clk_lookup * __ref
 vclkdev_alloc(struct clk_hw *hw, const char *con_id, const char *dev_fmt,
 	va_list ap)
 {
@@ -287,7 +287,7 @@ vclkdev_create(struct clk_hw *hw, const
 	return cl;
 }
 
-struct clk_lookup * __init_refok
+struct clk_lookup * __ref
 clkdev_alloc(struct clk *clk, const char *con_id, const char *dev_fmt, ...)
 {
 	struct clk_lookup *cl;
diff -puN drivers/pci/xen-pcifront.c~treewide-replace-obsolete-_refok-by-__ref drivers/pci/xen-pcifront.c
--- a/drivers/pci/xen-pcifront.c~treewide-replace-obsolete-_refok-by-__ref
+++ a/drivers/pci/xen-pcifront.c
@@ -1086,7 +1086,7 @@ out:
 	return err;
 }
 
-static void __init_refok pcifront_backend_changed(struct xenbus_device *xdev,
+static void __ref pcifront_backend_changed(struct xenbus_device *xdev,
 						  enum xenbus_state be_state)
 {
 	struct pcifront_device *pdev = dev_get_drvdata(&xdev->dev);
diff -puN drivers/video/logo/logo.c~treewide-replace-obsolete-_refok-by-__ref drivers/video/logo/logo.c
--- a/drivers/video/logo/logo.c~treewide-replace-obsolete-_refok-by-__ref
+++ a/drivers/video/logo/logo.c
@@ -36,11 +36,11 @@ static int __init fb_logo_late_init(void
 
 late_initcall(fb_logo_late_init);
 
-/* logo's are marked __initdata. Use __init_refok to tell
+/* logo's are marked __initdata. Use __ref to tell
  * modpost that it is intended that this function uses data
  * marked __initdata.
  */
-const struct linux_logo * __init_refok fb_find_logo(int depth)
+const struct linux_logo * __ref fb_find_logo(int depth)
 {
 	const struct linux_logo *logo = NULL;
 
diff -puN include/acpi/acpi_io.h~treewide-replace-obsolete-_refok-by-__ref include/acpi/acpi_io.h
--- a/include/acpi/acpi_io.h~treewide-replace-obsolete-_refok-by-__ref
+++ a/include/acpi/acpi_io.h
@@ -13,7 +13,7 @@ static inline void __iomem *acpi_os_iore
 }
 #endif
 
-void __iomem *__init_refok
+void __iomem *__ref
 acpi_os_map_iomem(acpi_physical_address phys, acpi_size size);
 void __ref acpi_os_unmap_iomem(void __iomem *virt, acpi_size size);
 void __iomem *acpi_os_get_iomem(acpi_physical_address phys, unsigned int size);
diff -puN include/linux/init.h~treewide-replace-obsolete-_refok-by-__ref include/linux/init.h
--- a/include/linux/init.h~treewide-replace-obsolete-_refok-by-__ref
+++ a/include/linux/init.h
@@ -77,12 +77,6 @@
 #define __refdata        __section(.ref.data)
 #define __refconst       __constsection(.ref.rodata)
 
-/* compatibility defines */
-#define __init_refok     __ref
-#define __initdata_refok __refdata
-#define __exit_refok     __ref
-
-
 #ifdef MODULE
 #define __exitused
 #else
diff -puN include/net/net_namespace.h~treewide-replace-obsolete-_refok-by-__ref include/net/net_namespace.h
--- a/include/net/net_namespace.h~treewide-replace-obsolete-_refok-by-__ref
+++ a/include/net/net_namespace.h
@@ -275,7 +275,7 @@ static inline struct net *read_pnet(cons
 #define __net_initconst
 #else
 #define __net_init	__init
-#define __net_exit	__exit_refok
+#define __net_exit	__ref
 #define __net_initdata	__initdata
 #define __net_initconst	__initconst
 #endif
diff -puN init/main.c~treewide-replace-obsolete-_refok-by-__ref init/main.c
--- a/init/main.c~treewide-replace-obsolete-_refok-by-__ref
+++ a/init/main.c
@@ -380,7 +380,7 @@ static void __init setup_command_line(ch
 
 static __initdata DECLARE_COMPLETION(kthreadd_done);
 
-static noinline void __init_refok rest_init(void)
+static noinline void __ref rest_init(void)
 {
 	int pid;
 
diff -puN mm/page_alloc.c~treewide-replace-obsolete-_refok-by-__ref mm/page_alloc.c
--- a/mm/page_alloc.c~treewide-replace-obsolete-_refok-by-__ref
+++ a/mm/page_alloc.c
@@ -5276,7 +5276,7 @@ void __init setup_per_cpu_pageset(void)
 		setup_zone_pageset(zone);
 }
 
-static noinline __init_refok
+static noinline __ref
 int zone_wait_table_init(struct zone *zone, unsigned long zone_size_pages)
 {
 	int i;
@@ -5903,7 +5903,7 @@ static void __paginginit free_area_init_
 	}
 }
 
-static void __init_refok alloc_node_mem_map(struct pglist_data *pgdat)
+static void __ref alloc_node_mem_map(struct pglist_data *pgdat)
 {
 	unsigned long __maybe_unused start = 0;
 	unsigned long __maybe_unused offset = 0;
diff -puN mm/slab.c~treewide-replace-obsolete-_refok-by-__ref mm/slab.c
--- a/mm/slab.c~treewide-replace-obsolete-_refok-by-__ref
+++ a/mm/slab.c
@@ -1877,7 +1877,7 @@ static struct array_cache __percpu *allo
 	return cpu_cache;
 }
 
-static int __init_refok setup_cpu_cache(struct kmem_cache *cachep, gfp_t gfp)
+static int __ref setup_cpu_cache(struct kmem_cache *cachep, gfp_t gfp)
 {
 	if (slab_state >= FULL)
 		return enable_cpucache(cachep, gfp);
diff -puN mm/sparse-vmemmap.c~treewide-replace-obsolete-_refok-by-__ref mm/sparse-vmemmap.c
--- a/mm/sparse-vmemmap.c~treewide-replace-obsolete-_refok-by-__ref
+++ a/mm/sparse-vmemmap.c
@@ -36,7 +36,7 @@
  * Uses the main allocators if they are available, else bootmem.
  */
 
-static void * __init_refok __earlyonly_bootmem_alloc(int node,
+static void * __ref __earlyonly_bootmem_alloc(int node,
 				unsigned long size,
 				unsigned long align,
 				unsigned long goal)
diff -puN mm/sparse.c~treewide-replace-obsolete-_refok-by-__ref mm/sparse.c
--- a/mm/sparse.c~treewide-replace-obsolete-_refok-by-__ref
+++ a/mm/sparse.c
@@ -59,7 +59,7 @@ static inline void set_section_nid(unsig
 #endif
 
 #ifdef CONFIG_SPARSEMEM_EXTREME
-static struct mem_section noinline __init_refok *sparse_index_alloc(int nid)
+static noinline struct mem_section __ref *sparse_index_alloc(int nid)
 {
 	struct mem_section *section = NULL;
 	unsigned long array_size = SECTIONS_PER_ROOT *
_

Patches currently in -mm which might be from fabf@skynet.be are


