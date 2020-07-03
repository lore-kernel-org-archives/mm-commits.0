From: akpm@linux-foundation.org
Subject: + mm-remove-unneeded-includes-of-asm-pgalloch.patch added
 to -mm tree
Date: Thu, 02 Jul 2020 21:21:09 -0700
Message-ID: <20200703042109.FjpSLgU2P%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725294AbgGCEVO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Jul 2020 00:21:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: abdhalee@linux.vnet.ibm.com, arnd@arndb.de, christophe.leroy@csgroup.eu, geert@linux-m68k.org, jcmvbkbc@gmail.com, joro@8bytes.org, jroedel@suse.de, luto@kernel.org, mm-commits@vger.kernel.org, peterz@infradead.org, rostedt@goodmis.org, rppt@linux.ibm.com, sathnaga@linux.vnet.ibm.com, sfr@canb.auug.org.au, shorne@gmail.com, willy@infradead.org


The patch titled
     Subject: mm: remove unneeded includes of <asm/pgalloc.h>
has been added to the -mm tree.  Its filename is
     mm-remove-unneeded-includes-of-asm-pgalloch.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-remove-unneeded-includes-of-asm-pgalloch.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-remove-unneeded-includes-of-asm-pgalloch.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mike Rapoport <rppt@linux.ibm.com>
Subject: mm: remove unneeded includes of <asm/pgalloc.h>

Patch series "mm: cleanup usage of <asm/pgalloc.h>"

Most architectures have very similar versions of pXd_alloc_one() and
pXd_free_one() for intermediate levels of page table.  These patches add
generic versions of these functions in <asm-generic/pgalloc.h> and enable
use of the generic functions where appropriate.

In addition, functions declared and defined in <asm/pgalloc.h> headers are
used mostly by core mm and early mm initialization in arch and there is no
actual reason to have the <asm/pgalloc.h> included all over the place. 
The first patch in this series removes unneeded includes of
<asm/pgalloc.h>

In the end it didn't work out as neatly as I hoped and moving
pXd_alloc_track() definitions to <asm-generic/pgalloc.h> would require
unnecessary changes to arches that have custom page table allocations, so
I've decided to move lib/ioremap.c to mm/ and make pgalloc-track.h local
to mm/.


This patch (of 8):

In most cases <asm/pgalloc.h> header is required only for allocations of
page table memory.  Most of the .c files that include that header do not
use symbols declared in <asm/pgalloc.h> and do not require that header.

As for the other header files that used to include <asm/pgalloc.h>, it is
possible to move that include into the .c file that actually uses symbols
from <asm/pgalloc.h> and drop the include from the header file.

The process was somewhat automated using

	sed -i -E '/[<"]asm\/pgalloc\.h/d' \
                $(grep -L -w -f /tmp/xx \
                        $(git grep -E -l '[<"]asm/pgalloc\.h'))

where /tmp/xx contains all the symbols defined in
arch/*/include/asm/pgalloc.h.

Link: http://lkml.kernel.org/r/20200627143453.31835-1-rppt@kernel.org
Link: http://lkml.kernel.org/r/20200627143453.31835-2-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>	[m68k]
Cc: Abdul Haleem <abdhalee@linux.vnet.ibm.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Satheesh Rajendran <sathnaga@linux.vnet.ibm.com>
Cc: Stafford Horne <shorne@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Joerg Roedel <jroedel@suse.de>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/tlbflush.h            |    1 -
 arch/alpha/kernel/core_irongate.c            |    1 -
 arch/alpha/kernel/core_marvel.c              |    1 -
 arch/alpha/kernel/core_titan.c               |    1 -
 arch/alpha/kernel/machvec_impl.h             |    2 --
 arch/alpha/kernel/smp.c                      |    1 -
 arch/alpha/mm/numa.c                         |    1 -
 arch/arc/mm/fault.c                          |    1 -
 arch/arc/mm/init.c                           |    1 -
 arch/arm/include/asm/tlb.h                   |    1 -
 arch/arm/kernel/machine_kexec.c              |    1 -
 arch/arm/kernel/smp.c                        |    1 -
 arch/arm/kernel/suspend.c                    |    1 -
 arch/arm/mach-omap2/omap-mpuss-lowpower.c    |    1 -
 arch/arm/mm/hugetlbpage.c                    |    1 -
 arch/arm/mm/mmu.c                            |    1 +
 arch/arm64/kernel/smp.c                      |    1 -
 arch/arm64/mm/hugetlbpage.c                  |    1 -
 arch/arm64/mm/ioremap.c                      |    1 -
 arch/arm64/mm/mmu.c                          |    1 +
 arch/csky/kernel/smp.c                       |    1 -
 arch/ia64/include/asm/tlb.h                  |    1 -
 arch/ia64/kernel/process.c                   |    1 -
 arch/ia64/kernel/smp.c                       |    1 -
 arch/ia64/kernel/smpboot.c                   |    1 -
 arch/ia64/mm/contig.c                        |    1 -
 arch/ia64/mm/discontig.c                     |    1 -
 arch/ia64/mm/hugetlbpage.c                   |    1 -
 arch/ia64/mm/tlb.c                           |    1 -
 arch/m68k/include/asm/mmu_context.h          |    2 +-
 arch/m68k/kernel/dma.c                       |    2 +-
 arch/m68k/kernel/traps.c                     |    3 +--
 arch/m68k/mm/cache.c                         |    2 +-
 arch/m68k/mm/fault.c                         |    1 -
 arch/m68k/mm/kmap.c                          |    2 +-
 arch/m68k/mm/mcfmmu.c                        |    1 +
 arch/m68k/mm/memory.c                        |    1 -
 arch/m68k/sun3x/dvma.c                       |    2 +-
 arch/microblaze/include/asm/tlbflush.h       |    1 -
 arch/microblaze/kernel/process.c             |    1 -
 arch/microblaze/kernel/signal.c              |    1 -
 arch/mips/sgi-ip32/ip32-memory.c             |    1 -
 arch/openrisc/include/asm/tlbflush.h         |    1 -
 arch/openrisc/kernel/or32_ksyms.c            |    1 -
 arch/parisc/include/asm/mmu_context.h        |    1 -
 arch/parisc/kernel/cache.c                   |    1 -
 arch/parisc/kernel/pci-dma.c                 |    1 -
 arch/parisc/kernel/process.c                 |    1 -
 arch/parisc/kernel/signal.c                  |    1 -
 arch/parisc/kernel/smp.c                     |    1 -
 arch/parisc/mm/hugetlbpage.c                 |    1 -
 arch/parisc/mm/ioremap.c                     |    2 +-
 arch/powerpc/include/asm/tlb.h               |    1 -
 arch/powerpc/mm/book3s64/hash_hugetlbpage.c  |    1 -
 arch/powerpc/mm/book3s64/hash_pgtable.c      |    1 -
 arch/powerpc/mm/book3s64/hash_tlb.c          |    1 -
 arch/powerpc/mm/book3s64/radix_hugetlbpage.c |    1 -
 arch/powerpc/mm/init_32.c                    |    1 -
 arch/powerpc/mm/kasan/8xx.c                  |    1 -
 arch/powerpc/mm/kasan/book3s_32.c            |    1 -
 arch/powerpc/mm/mem.c                        |    1 -
 arch/powerpc/mm/nohash/40x.c                 |    1 -
 arch/powerpc/mm/nohash/8xx.c                 |    1 -
 arch/powerpc/mm/nohash/fsl_booke.c           |    1 -
 arch/powerpc/mm/nohash/kaslr_booke.c         |    1 -
 arch/powerpc/mm/pgtable.c                    |    1 -
 arch/powerpc/mm/pgtable_64.c                 |    1 -
 arch/powerpc/mm/ptdump/hashpagetable.c       |    2 +-
 arch/powerpc/mm/ptdump/ptdump.c              |    1 -
 arch/powerpc/platforms/pseries/cmm.c         |    1 -
 arch/riscv/mm/fault.c                        |    1 -
 arch/s390/include/asm/tlb.h                  |    1 -
 arch/s390/include/asm/tlbflush.h             |    1 -
 arch/s390/kernel/machine_kexec.c             |    1 -
 arch/s390/kernel/ptrace.c                    |    1 -
 arch/s390/kvm/diag.c                         |    1 -
 arch/s390/kvm/priv.c                         |    1 -
 arch/s390/kvm/pv.c                           |    1 -
 arch/s390/mm/cmm.c                           |    1 -
 arch/s390/mm/mmap.c                          |    1 -
 arch/s390/mm/pgtable.c                       |    1 -
 arch/sh/kernel/idle.c                        |    1 -
 arch/sh/kernel/machine_kexec.c               |    1 -
 arch/sh/mm/cache-sh3.c                       |    1 -
 arch/sh/mm/cache-sh7705.c                    |    1 -
 arch/sh/mm/hugetlbpage.c                     |    1 -
 arch/sh/mm/init.c                            |    1 +
 arch/sh/mm/ioremap_fixed.c                   |    1 -
 arch/sh/mm/tlb-sh3.c                         |    1 -
 arch/sparc/include/asm/ide.h                 |    1 -
 arch/sparc/include/asm/tlb_64.h              |    1 -
 arch/sparc/kernel/leon_smp.c                 |    1 -
 arch/sparc/kernel/process_32.c               |    1 -
 arch/sparc/kernel/signal_32.c                |    1 -
 arch/sparc/kernel/smp_32.c                   |    1 -
 arch/sparc/kernel/smp_64.c                   |    1 +
 arch/sparc/kernel/sun4m_irq.c                |    1 -
 arch/sparc/mm/highmem.c                      |    1 -
 arch/sparc/mm/io-unit.c                      |    1 -
 arch/sparc/mm/iommu.c                        |    1 -
 arch/sparc/mm/tlb.c                          |    1 -
 arch/x86/ia32/ia32_aout.c                    |    1 -
 arch/x86/include/asm/mmu_context.h           |    1 -
 arch/x86/kernel/alternative.c                |    1 +
 arch/x86/kernel/apic/apic.c                  |    1 -
 arch/x86/kernel/mpparse.c                    |    1 -
 arch/x86/kernel/traps.c                      |    1 -
 arch/x86/mm/fault.c                          |    1 -
 arch/x86/mm/hugetlbpage.c                    |    1 -
 arch/x86/mm/kaslr.c                          |    1 -
 arch/x86/mm/pgtable_32.c                     |    1 -
 arch/x86/mm/pti.c                            |    1 -
 arch/x86/platform/uv/bios_uv.c               |    1 +
 arch/xtensa/kernel/xtensa_ksyms.c            |    1 -
 arch/xtensa/mm/cache.c                       |    1 -
 arch/xtensa/mm/fault.c                       |    1 -
 drivers/block/xen-blkback/common.h           |    1 -
 drivers/iommu/ipmmu-vmsa.c                   |    1 -
 drivers/xen/balloon.c                        |    1 -
 drivers/xen/privcmd.c                        |    1 -
 fs/binfmt_elf_fdpic.c                        |    1 -
 include/asm-generic/tlb.h                    |    1 -
 mm/hugetlb.c                                 |    1 +
 mm/sparse.c                                  |    1 -
 124 files changed, 16 insertions(+), 118 deletions(-)

--- a/arch/alpha/include/asm/tlbflush.h~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/arch/alpha/include/asm/tlbflush.h
@@ -5,7 +5,6 @@
 #include <linux/mm.h>
 #include <linux/sched.h>
 #include <asm/compiler.h>
-#include <asm/pgalloc.h>
 
 #ifndef __EXTERN_INLINE
 #define __EXTERN_INLINE extern inline
--- a/arch/alpha/kernel/core_irongate.c~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/arch/alpha/kernel/core_irongate.c
@@ -302,7 +302,6 @@ irongate_init_arch(void)
 #include <linux/agp_backend.h>
 #include <linux/agpgart.h>
 #include <linux/export.h>
-#include <asm/pgalloc.h>
 
 #define GET_PAGE_DIR_OFF(addr) (addr >> 22)
 #define GET_PAGE_DIR_IDX(addr) (GET_PAGE_DIR_OFF(addr))
--- a/arch/alpha/kernel/core_marvel.c~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/arch/alpha/kernel/core_marvel.c
@@ -23,7 +23,6 @@
 #include <asm/ptrace.h>
 #include <asm/smp.h>
 #include <asm/gct.h>
-#include <asm/pgalloc.h>
 #include <asm/tlbflush.h>
 #include <asm/vga.h>
 
--- a/arch/alpha/kernel/core_titan.c~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/arch/alpha/kernel/core_titan.c
@@ -20,7 +20,6 @@
 
 #include <asm/ptrace.h>
 #include <asm/smp.h>
-#include <asm/pgalloc.h>
 #include <asm/tlbflush.h>
 #include <asm/vga.h>
 
--- a/arch/alpha/kernel/machvec_impl.h~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/arch/alpha/kernel/machvec_impl.h
@@ -7,8 +7,6 @@
  * This file has goodies to help simplify instantiation of machine vectors.
  */
 
-#include <asm/pgalloc.h>
-
 /* Whee.  These systems don't have an HAE:
        IRONGATE, MARVEL, POLARIS, TSUNAMI, TITAN, WILDFIRE
    Fix things up for the GENERIC kernel by defining the HAE address
--- a/arch/alpha/kernel/smp.c~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/arch/alpha/kernel/smp.c
@@ -36,7 +36,6 @@
 
 #include <asm/io.h>
 #include <asm/irq.h>
-#include <asm/pgalloc.h>
 #include <asm/mmu_context.h>
 #include <asm/tlbflush.h>
 
--- a/arch/alpha/mm/numa.c~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/arch/alpha/mm/numa.c
@@ -17,7 +17,6 @@
 #include <linux/module.h>
 
 #include <asm/hwrpb.h>
-#include <asm/pgalloc.h>
 #include <asm/sections.h>
 
 pg_data_t node_data[MAX_NUMNODES];
--- a/arch/arc/mm/fault.c~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/arch/arc/mm/fault.c
@@ -13,7 +13,6 @@
 #include <linux/kdebug.h>
 #include <linux/perf_event.h>
 #include <linux/mm_types.h>
-#include <asm/pgalloc.h>
 #include <asm/mmu.h>
 
 /*
--- a/arch/arc/mm/init.c~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/arch/arc/mm/init.c
@@ -14,7 +14,6 @@
 #include <linux/module.h>
 #include <linux/highmem.h>
 #include <asm/page.h>
-#include <asm/pgalloc.h>
 #include <asm/sections.h>
 #include <asm/arcregs.h>
 
--- a/arch/arm64/kernel/smp.c~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/arch/arm64/kernel/smp.c
@@ -43,7 +43,6 @@
 #include <asm/kvm_mmu.h>
 #include <asm/mmu_context.h>
 #include <asm/numa.h>
-#include <asm/pgalloc.h>
 #include <asm/processor.h>
 #include <asm/smp_plat.h>
 #include <asm/sections.h>
--- a/arch/arm64/mm/hugetlbpage.c~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/arch/arm64/mm/hugetlbpage.c
@@ -17,7 +17,6 @@
 #include <asm/mman.h>
 #include <asm/tlb.h>
 #include <asm/tlbflush.h>
-#include <asm/pgalloc.h>
 
 #ifdef CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION
 bool arch_hugetlb_migration_supported(struct hstate *h)
--- a/arch/arm64/mm/ioremap.c~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/arch/arm64/mm/ioremap.c
@@ -16,7 +16,6 @@
 
 #include <asm/fixmap.h>
 #include <asm/tlbflush.h>
-#include <asm/pgalloc.h>
 
 static void __iomem *__ioremap_caller(phys_addr_t phys_addr, size_t size,
 				      pgprot_t prot, void *caller)
--- a/arch/arm64/mm/mmu.c~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/arch/arm64/mm/mmu.c
@@ -35,6 +35,7 @@
 #include <asm/mmu_context.h>
 #include <asm/ptdump.h>
 #include <asm/tlbflush.h>
+#include <asm/pgalloc.h>
 
 #define NO_BLOCK_MAPPINGS	BIT(0)
 #define NO_CONT_MAPPINGS	BIT(1)
--- a/arch/arm/include/asm/tlb.h~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/arch/arm/include/asm/tlb.h
@@ -27,7 +27,6 @@
 #else /* !CONFIG_MMU */
 
 #include <linux/swap.h>
-#include <asm/pgalloc.h>
 #include <asm/tlbflush.h>
 
 static inline void __tlb_remove_table(void *_table)
--- a/arch/arm/kernel/machine_kexec.c~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/arch/arm/kernel/machine_kexec.c
@@ -11,7 +11,6 @@
 #include <linux/irq.h>
 #include <linux/memblock.h>
 #include <linux/of_fdt.h>
-#include <asm/pgalloc.h>
 #include <asm/mmu_context.h>
 #include <asm/cacheflush.h>
 #include <asm/fncpy.h>
--- a/arch/arm/kernel/smp.c~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/arch/arm/kernel/smp.c
@@ -37,7 +37,6 @@
 #include <asm/idmap.h>
 #include <asm/topology.h>
 #include <asm/mmu_context.h>
-#include <asm/pgalloc.h>
 #include <asm/procinfo.h>
 #include <asm/processor.h>
 #include <asm/sections.h>
--- a/arch/arm/kernel/suspend.c~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/arch/arm/kernel/suspend.c
@@ -7,7 +7,6 @@
 #include <asm/bugs.h>
 #include <asm/cacheflush.h>
 #include <asm/idmap.h>
-#include <asm/pgalloc.h>
 #include <asm/memory.h>
 #include <asm/smp_plat.h>
 #include <asm/suspend.h>
--- a/arch/arm/mach-omap2/omap-mpuss-lowpower.c~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/arch/arm/mach-omap2/omap-mpuss-lowpower.c
@@ -42,7 +42,6 @@
 #include <asm/cacheflush.h>
 #include <asm/tlbflush.h>
 #include <asm/smp_scu.h>
-#include <asm/pgalloc.h>
 #include <asm/suspend.h>
 #include <asm/virt.h>
 #include <asm/hardware/cache-l2x0.h>
--- a/arch/arm/mm/hugetlbpage.c~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/arch/arm/mm/hugetlbpage.c
@@ -17,7 +17,6 @@
 #include <asm/mman.h>
 #include <asm/tlb.h>
 #include <asm/tlbflush.h>
-#include <asm/pgalloc.h>
 
 /*
  * On ARM, huge pages are backed by pmd's rather than pte's, so we do a lot
--- a/arch/arm/mm/mmu.c~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/arch/arm/mm/mmu.c
@@ -29,6 +29,7 @@
 #include <asm/traps.h>
 #include <asm/procinfo.h>
 #include <asm/memory.h>
+#include <asm/pgalloc.h>
 
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
--- a/arch/csky/kernel/smp.c~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/arch/csky/kernel/smp.c
@@ -21,7 +21,6 @@
 #include <asm/traps.h>
 #include <asm/sections.h>
 #include <asm/mmu_context.h>
-#include <asm/pgalloc.h>
 #ifdef CONFIG_CPU_HAS_FPU
 #include <abi/fpu.h>
 #endif
--- a/arch/ia64/include/asm/tlb.h~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/arch/ia64/include/asm/tlb.h
@@ -42,7 +42,6 @@
 #include <linux/pagemap.h>
 #include <linux/swap.h>
 
-#include <asm/pgalloc.h>
 #include <asm/processor.h>
 #include <asm/tlbflush.h>
 
--- a/arch/ia64/kernel/process.c~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/arch/ia64/kernel/process.c
@@ -40,7 +40,6 @@
 #include <asm/elf.h>
 #include <asm/irq.h>
 #include <asm/kexec.h>
-#include <asm/pgalloc.h>
 #include <asm/processor.h>
 #include <asm/sal.h>
 #include <asm/switch_to.h>
--- a/arch/ia64/kernel/smpboot.c~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/arch/ia64/kernel/smpboot.c
@@ -49,7 +49,6 @@
 #include <asm/irq.h>
 #include <asm/mca.h>
 #include <asm/page.h>
-#include <asm/pgalloc.h>
 #include <asm/processor.h>
 #include <asm/ptrace.h>
 #include <asm/sal.h>
--- a/arch/ia64/kernel/smp.c~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/arch/ia64/kernel/smp.c
@@ -39,7 +39,6 @@
 #include <asm/io.h>
 #include <asm/irq.h>
 #include <asm/page.h>
-#include <asm/pgalloc.h>
 #include <asm/processor.h>
 #include <asm/ptrace.h>
 #include <asm/sal.h>
--- a/arch/ia64/mm/contig.c~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/arch/ia64/mm/contig.c
@@ -21,7 +21,6 @@
 #include <linux/swap.h>
 
 #include <asm/meminit.h>
-#include <asm/pgalloc.h>
 #include <asm/sections.h>
 #include <asm/mca.h>
 
--- a/arch/ia64/mm/discontig.c~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/arch/ia64/mm/discontig.c
@@ -24,7 +24,6 @@
 #include <linux/efi.h>
 #include <linux/nodemask.h>
 #include <linux/slab.h>
-#include <asm/pgalloc.h>
 #include <asm/tlb.h>
 #include <asm/meminit.h>
 #include <asm/numa.h>
--- a/arch/ia64/mm/hugetlbpage.c~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/arch/ia64/mm/hugetlbpage.c
@@ -18,7 +18,6 @@
 #include <linux/sysctl.h>
 #include <linux/log2.h>
 #include <asm/mman.h>
-#include <asm/pgalloc.h>
 #include <asm/tlb.h>
 #include <asm/tlbflush.h>
 
--- a/arch/ia64/mm/tlb.c~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/arch/ia64/mm/tlb.c
@@ -27,7 +27,6 @@
 
 #include <asm/delay.h>
 #include <asm/mmu_context.h>
-#include <asm/pgalloc.h>
 #include <asm/pal.h>
 #include <asm/tlbflush.h>
 #include <asm/dma.h>
--- a/arch/m68k/include/asm/mmu_context.h~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/arch/m68k/include/asm/mmu_context.h
@@ -222,7 +222,7 @@ static inline void activate_mm(struct mm
 
 #include <asm/setup.h>
 #include <asm/page.h>
-#include <asm/pgalloc.h>
+#include <asm/cacheflush.h>
 
 static inline int init_new_context(struct task_struct *tsk,
 				   struct mm_struct *mm)
--- a/arch/m68k/kernel/dma.c~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/arch/m68k/kernel/dma.c
@@ -15,7 +15,7 @@
 #include <linux/vmalloc.h>
 #include <linux/export.h>
 
-#include <asm/pgalloc.h>
+#include <asm/cacheflush.h>
 
 #if defined(CONFIG_MMU) && !defined(CONFIG_COLDFIRE)
 void arch_dma_prep_coherent(struct page *page, size_t size)
--- a/arch/m68k/kernel/traps.c~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/arch/m68k/kernel/traps.c
@@ -35,10 +35,9 @@
 #include <asm/fpu.h>
 #include <linux/uaccess.h>
 #include <asm/traps.h>
-#include <asm/pgalloc.h>
 #include <asm/machdep.h>
 #include <asm/siginfo.h>
-
+#include <asm/tlbflush.h>
 
 static const char *vec_names[] = {
 	[VEC_RESETSP]	= "RESET SP",
--- a/arch/m68k/mm/cache.c~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/arch/m68k/mm/cache.c
@@ -8,7 +8,7 @@
  */
 
 #include <linux/module.h>
-#include <asm/pgalloc.h>
+#include <asm/cacheflush.h>
 #include <asm/traps.h>
 
 
--- a/arch/m68k/mm/fault.c~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/arch/m68k/mm/fault.c
@@ -15,7 +15,6 @@
 
 #include <asm/setup.h>
 #include <asm/traps.h>
-#include <asm/pgalloc.h>
 
 extern void die_if_kernel(char *, struct pt_regs *, long);
 
--- a/arch/m68k/mm/kmap.c~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/arch/m68k/mm/kmap.c
@@ -19,8 +19,8 @@
 #include <asm/setup.h>
 #include <asm/segment.h>
 #include <asm/page.h>
-#include <asm/pgalloc.h>
 #include <asm/io.h>
+#include <asm/tlbflush.h>
 
 #undef DEBUG
 
--- a/arch/m68k/mm/mcfmmu.c~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/arch/m68k/mm/mcfmmu.c
@@ -20,6 +20,7 @@
 #include <asm/mmu_context.h>
 #include <asm/mcf_pgalloc.h>
 #include <asm/tlbflush.h>
+#include <asm/pgalloc.h>
 
 #define KMAPAREA(x)	((x >= VMALLOC_START) && (x < KMAP_END))
 
--- a/arch/m68k/mm/memory.c~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/arch/m68k/mm/memory.c
@@ -17,7 +17,6 @@
 #include <asm/setup.h>
 #include <asm/segment.h>
 #include <asm/page.h>
-#include <asm/pgalloc.h>
 #include <asm/traps.h>
 #include <asm/machdep.h>
 
--- a/arch/m68k/sun3x/dvma.c~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/arch/m68k/sun3x/dvma.c
@@ -22,7 +22,7 @@
 #include <asm/dvma.h>
 #include <asm/io.h>
 #include <asm/page.h>
-#include <asm/pgalloc.h>
+#include <asm/tlbflush.h>
 
 /* IOMMU support */
 
--- a/arch/microblaze/include/asm/tlbflush.h~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/arch/microblaze/include/asm/tlbflush.h
@@ -15,7 +15,6 @@
 #include <asm/processor.h>	/* For TASK_SIZE */
 #include <asm/mmu.h>
 #include <asm/page.h>
-#include <asm/pgalloc.h>
 
 extern void _tlbie(unsigned long address);
 extern void _tlbia(void);
--- a/arch/microblaze/kernel/process.c~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/arch/microblaze/kernel/process.c
@@ -18,7 +18,6 @@
 #include <linux/tick.h>
 #include <linux/bitops.h>
 #include <linux/ptrace.h>
-#include <asm/pgalloc.h>
 #include <linux/uaccess.h> /* for USER_DS macros */
 #include <asm/cacheflush.h>
 
--- a/arch/microblaze/kernel/signal.c~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/arch/microblaze/kernel/signal.c
@@ -35,7 +35,6 @@
 #include <asm/entry.h>
 #include <asm/ucontext.h>
 #include <linux/uaccess.h>
-#include <asm/pgalloc.h>
 #include <linux/syscalls.h>
 #include <asm/cacheflush.h>
 #include <asm/syscalls.h>
--- a/arch/mips/sgi-ip32/ip32-memory.c~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/arch/mips/sgi-ip32/ip32-memory.c
@@ -14,7 +14,6 @@
 #include <asm/ip32/crime.h>
 #include <asm/bootinfo.h>
 #include <asm/page.h>
-#include <asm/pgalloc.h>
 
 extern void crime_init(void);
 
--- a/arch/openrisc/include/asm/tlbflush.h~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/arch/openrisc/include/asm/tlbflush.h
@@ -17,7 +17,6 @@
 
 #include <linux/mm.h>
 #include <asm/processor.h>
-#include <asm/pgalloc.h>
 #include <asm/current.h>
 #include <linux/sched.h>
 
--- a/arch/openrisc/kernel/or32_ksyms.c~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/arch/openrisc/kernel/or32_ksyms.c
@@ -26,7 +26,6 @@
 #include <asm/io.h>
 #include <asm/hardirq.h>
 #include <asm/delay.h>
-#include <asm/pgalloc.h>
 
 #define DECLARE_EXPORT(name) extern void name(void); EXPORT_SYMBOL(name)
 
--- a/arch/parisc/include/asm/mmu_context.h~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/arch/parisc/include/asm/mmu_context.h
@@ -5,7 +5,6 @@
 #include <linux/mm.h>
 #include <linux/sched.h>
 #include <linux/atomic.h>
-#include <asm/pgalloc.h>
 #include <asm-generic/mm_hooks.h>
 
 static inline void enter_lazy_tlb(struct mm_struct *mm, struct task_struct *tsk)
--- a/arch/parisc/kernel/cache.c~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/arch/parisc/kernel/cache.c
@@ -24,7 +24,6 @@
 #include <asm/cacheflush.h>
 #include <asm/tlbflush.h>
 #include <asm/page.h>
-#include <asm/pgalloc.h>
 #include <asm/processor.h>
 #include <asm/sections.h>
 #include <asm/shmparam.h>
--- a/arch/parisc/kernel/pci-dma.c~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/arch/parisc/kernel/pci-dma.c
@@ -32,7 +32,6 @@
 #include <asm/dma.h>    /* for DMA_CHUNK_SIZE */
 #include <asm/io.h>
 #include <asm/page.h>	/* get_order */
-#include <asm/pgalloc.h>
 #include <linux/uaccess.h>
 #include <asm/tlbflush.h>	/* for purge_tlb_*() macros */
 
--- a/arch/parisc/kernel/process.c~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/arch/parisc/kernel/process.c
@@ -47,7 +47,6 @@
 #include <asm/assembly.h>
 #include <asm/pdc.h>
 #include <asm/pdc_chassis.h>
-#include <asm/pgalloc.h>
 #include <asm/unwind.h>
 #include <asm/sections.h>
 
--- a/arch/parisc/kernel/signal.c~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/arch/parisc/kernel/signal.c
@@ -30,7 +30,6 @@
 #include <asm/ucontext.h>
 #include <asm/rt_sigframe.h>
 #include <linux/uaccess.h>
-#include <asm/pgalloc.h>
 #include <asm/cacheflush.h>
 #include <asm/asm-offsets.h>
 
--- a/arch/parisc/kernel/smp.c~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/arch/parisc/kernel/smp.c
@@ -39,7 +39,6 @@
 #include <asm/irq.h>		/* for CPU_IRQ_REGION and friends */
 #include <asm/mmu_context.h>
 #include <asm/page.h>
-#include <asm/pgalloc.h>
 #include <asm/processor.h>
 #include <asm/ptrace.h>
 #include <asm/unistd.h>
--- a/arch/parisc/mm/hugetlbpage.c~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/arch/parisc/mm/hugetlbpage.c
@@ -15,7 +15,6 @@
 #include <linux/sysctl.h>
 
 #include <asm/mman.h>
-#include <asm/pgalloc.h>
 #include <asm/tlb.h>
 #include <asm/tlbflush.h>
 #include <asm/cacheflush.h>
--- a/arch/parisc/mm/ioremap.c~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/arch/parisc/mm/ioremap.c
@@ -11,7 +11,7 @@
 #include <linux/errno.h>
 #include <linux/module.h>
 #include <linux/io.h>
-#include <asm/pgalloc.h>
+#include <linux/mm.h>
 
 /*
  * Generic mapping function (not visible outside):
--- a/arch/powerpc/include/asm/tlb.h~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/arch/powerpc/include/asm/tlb.h
@@ -12,7 +12,6 @@
 #ifndef __powerpc64__
 #include <linux/pgtable.h>
 #endif
-#include <asm/pgalloc.h>
 #ifndef __powerpc64__
 #include <asm/page.h>
 #include <asm/mmu.h>
--- a/arch/powerpc/mm/book3s64/hash_hugetlbpage.c~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/arch/powerpc/mm/book3s64/hash_hugetlbpage.c
@@ -10,7 +10,6 @@
 
 #include <linux/mm.h>
 #include <linux/hugetlb.h>
-#include <asm/pgalloc.h>
 #include <asm/cacheflush.h>
 #include <asm/machdep.h>
 
--- a/arch/powerpc/mm/book3s64/hash_pgtable.c~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/arch/powerpc/mm/book3s64/hash_pgtable.c
@@ -9,7 +9,6 @@
 #include <linux/mm_types.h>
 #include <linux/mm.h>
 
-#include <asm/pgalloc.h>
 #include <asm/sections.h>
 #include <asm/mmu.h>
 #include <asm/tlb.h>
--- a/arch/powerpc/mm/book3s64/hash_tlb.c~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/arch/powerpc/mm/book3s64/hash_tlb.c
@@ -21,7 +21,6 @@
 #include <linux/mm.h>
 #include <linux/percpu.h>
 #include <linux/hardirq.h>
-#include <asm/pgalloc.h>
 #include <asm/tlbflush.h>
 #include <asm/tlb.h>
 #include <asm/bug.h>
--- a/arch/powerpc/mm/book3s64/radix_hugetlbpage.c~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/arch/powerpc/mm/book3s64/radix_hugetlbpage.c
@@ -2,7 +2,6 @@
 #include <linux/mm.h>
 #include <linux/hugetlb.h>
 #include <linux/security.h>
-#include <asm/pgalloc.h>
 #include <asm/cacheflush.h>
 #include <asm/machdep.h>
 #include <asm/mman.h>
--- a/arch/powerpc/mm/init_32.c~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/arch/powerpc/mm/init_32.c
@@ -29,7 +29,6 @@
 #include <linux/slab.h>
 #include <linux/hugetlb.h>
 
-#include <asm/pgalloc.h>
 #include <asm/prom.h>
 #include <asm/io.h>
 #include <asm/mmu.h>
--- a/arch/powerpc/mm/kasan/8xx.c~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/arch/powerpc/mm/kasan/8xx.c
@@ -5,7 +5,6 @@
 #include <linux/kasan.h>
 #include <linux/memblock.h>
 #include <linux/hugetlb.h>
-#include <asm/pgalloc.h>
 
 static int __init
 kasan_init_shadow_8M(unsigned long k_start, unsigned long k_end, void *block)
--- a/arch/powerpc/mm/kasan/book3s_32.c~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/arch/powerpc/mm/kasan/book3s_32.c
@@ -4,7 +4,6 @@
 
 #include <linux/kasan.h>
 #include <linux/memblock.h>
-#include <asm/pgalloc.h>
 #include <mm/mmu_decl.h>
 
 int __init kasan_init_region(void *start, size_t size)
--- a/arch/powerpc/mm/mem.c~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/arch/powerpc/mm/mem.c
@@ -34,7 +34,6 @@
 #include <linux/dma-direct.h>
 #include <linux/kprobes.h>
 
-#include <asm/pgalloc.h>
 #include <asm/prom.h>
 #include <asm/io.h>
 #include <asm/mmu_context.h>
--- a/arch/powerpc/mm/nohash/40x.c~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/arch/powerpc/mm/nohash/40x.c
@@ -32,7 +32,6 @@
 #include <linux/highmem.h>
 #include <linux/memblock.h>
 
-#include <asm/pgalloc.h>
 #include <asm/prom.h>
 #include <asm/io.h>
 #include <asm/mmu_context.h>
--- a/arch/powerpc/mm/nohash/8xx.c~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/arch/powerpc/mm/nohash/8xx.c
@@ -13,7 +13,6 @@
 #include <asm/fixmap.h>
 #include <asm/code-patching.h>
 #include <asm/inst.h>
-#include <asm/pgalloc.h>
 
 #include <mm/mmu_decl.h>
 
--- a/arch/powerpc/mm/nohash/fsl_booke.c~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/arch/powerpc/mm/nohash/fsl_booke.c
@@ -37,7 +37,6 @@
 #include <linux/highmem.h>
 #include <linux/memblock.h>
 
-#include <asm/pgalloc.h>
 #include <asm/prom.h>
 #include <asm/io.h>
 #include <asm/mmu_context.h>
--- a/arch/powerpc/mm/nohash/kaslr_booke.c~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/arch/powerpc/mm/nohash/kaslr_booke.c
@@ -15,7 +15,6 @@
 #include <linux/libfdt.h>
 #include <linux/crash_core.h>
 #include <asm/cacheflush.h>
-#include <asm/pgalloc.h>
 #include <asm/prom.h>
 #include <asm/kdump.h>
 #include <mm/mmu_decl.h>
--- a/arch/powerpc/mm/pgtable_64.c~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/arch/powerpc/mm/pgtable_64.c
@@ -31,7 +31,6 @@
 #include <linux/slab.h>
 #include <linux/hugetlb.h>
 
-#include <asm/pgalloc.h>
 #include <asm/page.h>
 #include <asm/prom.h>
 #include <asm/mmu_context.h>
--- a/arch/powerpc/mm/pgtable.c~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/arch/powerpc/mm/pgtable.c
@@ -23,7 +23,6 @@
 #include <linux/percpu.h>
 #include <linux/hardirq.h>
 #include <linux/hugetlb.h>
-#include <asm/pgalloc.h>
 #include <asm/tlbflush.h>
 #include <asm/tlb.h>
 #include <asm/hugetlb.h>
--- a/arch/powerpc/mm/ptdump/hashpagetable.c~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/arch/powerpc/mm/ptdump/hashpagetable.c
@@ -17,10 +17,10 @@
 #include <linux/seq_file.h>
 #include <linux/const.h>
 #include <asm/page.h>
-#include <asm/pgalloc.h>
 #include <asm/plpar_wrappers.h>
 #include <linux/memblock.h>
 #include <asm/firmware.h>
+#include <asm/pgalloc.h>
 
 struct pg_state {
 	struct seq_file *seq;
--- a/arch/powerpc/mm/ptdump/ptdump.c~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/arch/powerpc/mm/ptdump/ptdump.c
@@ -21,7 +21,6 @@
 #include <asm/fixmap.h>
 #include <linux/const.h>
 #include <asm/page.h>
-#include <asm/pgalloc.h>
 #include <asm/hugetlb.h>
 
 #include <mm/mmu_decl.h>
--- a/arch/powerpc/platforms/pseries/cmm.c~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/arch/powerpc/platforms/pseries/cmm.c
@@ -26,7 +26,6 @@
 #include <asm/firmware.h>
 #include <asm/hvcall.h>
 #include <asm/mmu.h>
-#include <asm/pgalloc.h>
 #include <linux/uaccess.h>
 #include <linux/memory.h>
 #include <asm/plpar_wrappers.h>
--- a/arch/riscv/mm/fault.c~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/arch/riscv/mm/fault.c
@@ -14,7 +14,6 @@
 #include <linux/signal.h>
 #include <linux/uaccess.h>
 
-#include <asm/pgalloc.h>
 #include <asm/ptrace.h>
 #include <asm/tlbflush.h>
 
--- a/arch/s390/include/asm/tlbflush.h~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/arch/s390/include/asm/tlbflush.h
@@ -5,7 +5,6 @@
 #include <linux/mm.h>
 #include <linux/sched.h>
 #include <asm/processor.h>
-#include <asm/pgalloc.h>
 
 /*
  * Flush all TLB entries on the local CPU.
--- a/arch/s390/include/asm/tlb.h~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/arch/s390/include/asm/tlb.h
@@ -36,7 +36,6 @@ static inline bool __tlb_remove_page_siz
 #define p4d_free_tlb p4d_free_tlb
 #define pud_free_tlb pud_free_tlb
 
-#include <asm/pgalloc.h>
 #include <asm/tlbflush.h>
 #include <asm-generic/tlb.h>
 
--- a/arch/s390/kernel/machine_kexec.c~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/arch/s390/kernel/machine_kexec.c
@@ -16,7 +16,6 @@
 #include <linux/debug_locks.h>
 #include <asm/cio.h>
 #include <asm/setup.h>
-#include <asm/pgalloc.h>
 #include <asm/smp.h>
 #include <asm/ipl.h>
 #include <asm/diag.h>
--- a/arch/s390/kernel/ptrace.c~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/arch/s390/kernel/ptrace.c
@@ -25,7 +25,6 @@
 #include <linux/compat.h>
 #include <trace/syscall.h>
 #include <asm/page.h>
-#include <asm/pgalloc.h>
 #include <linux/uaccess.h>
 #include <asm/unistd.h>
 #include <asm/switch_to.h>
--- a/arch/s390/kvm/diag.c~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/arch/s390/kvm/diag.c
@@ -10,7 +10,6 @@
 
 #include <linux/kvm.h>
 #include <linux/kvm_host.h>
-#include <asm/pgalloc.h>
 #include <asm/gmap.h>
 #include <asm/virtio-ccw.h>
 #include "kvm-s390.h"
--- a/arch/s390/kvm/priv.c~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/arch/s390/kvm/priv.c
@@ -22,7 +22,6 @@
 #include <asm/ebcdic.h>
 #include <asm/sysinfo.h>
 #include <asm/page-states.h>
-#include <asm/pgalloc.h>
 #include <asm/gmap.h>
 #include <asm/io.h>
 #include <asm/ptrace.h>
--- a/arch/s390/kvm/pv.c~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/arch/s390/kvm/pv.c
@@ -9,7 +9,6 @@
 #include <linux/kvm_host.h>
 #include <linux/pagemap.h>
 #include <linux/sched/signal.h>
-#include <asm/pgalloc.h>
 #include <asm/gmap.h>
 #include <asm/uv.h>
 #include <asm/mman.h>
--- a/arch/s390/mm/cmm.c~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/arch/s390/mm/cmm.c
@@ -21,7 +21,6 @@
 #include <linux/oom.h>
 #include <linux/uaccess.h>
 
-#include <asm/pgalloc.h>
 #include <asm/diag.h>
 
 #ifdef CONFIG_CMM_IUCV
--- a/arch/s390/mm/mmap.c~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/arch/s390/mm/mmap.c
@@ -17,7 +17,6 @@
 #include <linux/random.h>
 #include <linux/compat.h>
 #include <linux/security.h>
-#include <asm/pgalloc.h>
 #include <asm/elf.h>
 
 static unsigned long stack_maxrandom_size(void)
--- a/arch/s390/mm/pgtable.c~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/arch/s390/mm/pgtable.c
@@ -19,7 +19,6 @@
 #include <linux/ksm.h>
 #include <linux/mman.h>
 
-#include <asm/pgalloc.h>
 #include <asm/tlb.h>
 #include <asm/tlbflush.h>
 #include <asm/mmu_context.h>
--- a/arch/sh/kernel/idle.c~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/arch/sh/kernel/idle.c
@@ -14,7 +14,6 @@
 #include <linux/irqflags.h>
 #include <linux/smp.h>
 #include <linux/atomic.h>
-#include <asm/pgalloc.h>
 #include <asm/smp.h>
 #include <asm/bl_bit.h>
 
--- a/arch/sh/kernel/machine_kexec.c~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/arch/sh/kernel/machine_kexec.c
@@ -14,7 +14,6 @@
 #include <linux/ftrace.h>
 #include <linux/suspend.h>
 #include <linux/memblock.h>
-#include <asm/pgalloc.h>
 #include <asm/mmu_context.h>
 #include <asm/io.h>
 #include <asm/cacheflush.h>
--- a/arch/sh/mm/cache-sh3.c~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/arch/sh/mm/cache-sh3.c
@@ -16,7 +16,6 @@
 #include <asm/cache.h>
 #include <asm/io.h>
 #include <linux/uaccess.h>
-#include <asm/pgalloc.h>
 #include <asm/mmu_context.h>
 #include <asm/cacheflush.h>
 
--- a/arch/sh/mm/cache-sh7705.c~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/arch/sh/mm/cache-sh7705.c
@@ -20,7 +20,6 @@
 #include <asm/cache.h>
 #include <asm/io.h>
 #include <linux/uaccess.h>
-#include <asm/pgalloc.h>
 #include <asm/mmu_context.h>
 #include <asm/cacheflush.h>
 
--- a/arch/sh/mm/hugetlbpage.c~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/arch/sh/mm/hugetlbpage.c
@@ -17,7 +17,6 @@
 #include <linux/sysctl.h>
 
 #include <asm/mman.h>
-#include <asm/pgalloc.h>
 #include <asm/tlb.h>
 #include <asm/tlbflush.h>
 #include <asm/cacheflush.h>
--- a/arch/sh/mm/init.c~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/arch/sh/mm/init.c
@@ -27,6 +27,7 @@
 #include <asm/sections.h>
 #include <asm/setup.h>
 #include <asm/cache.h>
+#include <asm/pgalloc.h>
 #include <linux/sizes.h>
 
 pgd_t swapper_pg_dir[PTRS_PER_PGD];
--- a/arch/sh/mm/ioremap_fixed.c~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/arch/sh/mm/ioremap_fixed.c
@@ -18,7 +18,6 @@
 #include <linux/proc_fs.h>
 #include <asm/fixmap.h>
 #include <asm/page.h>
-#include <asm/pgalloc.h>
 #include <asm/addrspace.h>
 #include <asm/cacheflush.h>
 #include <asm/tlbflush.h>
--- a/arch/sh/mm/tlb-sh3.c~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/arch/sh/mm/tlb-sh3.c
@@ -21,7 +21,6 @@
 
 #include <asm/io.h>
 #include <linux/uaccess.h>
-#include <asm/pgalloc.h>
 #include <asm/mmu_context.h>
 #include <asm/cacheflush.h>
 
--- a/arch/sparc/include/asm/ide.h~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/arch/sparc/include/asm/ide.h
@@ -13,7 +13,6 @@
 
 #include <asm/io.h>
 #ifdef CONFIG_SPARC64
-#include <asm/pgalloc.h>
 #include <asm/spitfire.h>
 #include <asm/cacheflush.h>
 #include <asm/page.h>
--- a/arch/sparc/include/asm/tlb_64.h~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/arch/sparc/include/asm/tlb_64.h
@@ -4,7 +4,6 @@
 
 #include <linux/swap.h>
 #include <linux/pagemap.h>
-#include <asm/pgalloc.h>
 #include <asm/tlbflush.h>
 #include <asm/mmu_context.h>
 
--- a/arch/sparc/kernel/leon_smp.c~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/arch/sparc/kernel/leon_smp.c
@@ -38,7 +38,6 @@
 #include <asm/delay.h>
 #include <asm/irq.h>
 #include <asm/page.h>
-#include <asm/pgalloc.h>
 #include <asm/oplib.h>
 #include <asm/cpudata.h>
 #include <asm/asi.h>
--- a/arch/sparc/kernel/process_32.c~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/arch/sparc/kernel/process_32.c
@@ -34,7 +34,6 @@
 #include <asm/oplib.h>
 #include <linux/uaccess.h>
 #include <asm/page.h>
-#include <asm/pgalloc.h>
 #include <asm/delay.h>
 #include <asm/processor.h>
 #include <asm/psr.h>
--- a/arch/sparc/kernel/signal_32.c~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/arch/sparc/kernel/signal_32.c
@@ -23,7 +23,6 @@
 
 #include <linux/uaccess.h>
 #include <asm/ptrace.h>
-#include <asm/pgalloc.h>
 #include <asm/cacheflush.h>	/* flush_sig_insns */
 #include <asm/switch_to.h>
 
--- a/arch/sparc/kernel/smp_32.c~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/arch/sparc/kernel/smp_32.c
@@ -29,7 +29,6 @@
 
 #include <asm/irq.h>
 #include <asm/page.h>
-#include <asm/pgalloc.h>
 #include <asm/oplib.h>
 #include <asm/cacheflush.h>
 #include <asm/tlbflush.h>
--- a/arch/sparc/kernel/smp_64.c~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/arch/sparc/kernel/smp_64.c
@@ -47,6 +47,7 @@
 #include <linux/uaccess.h>
 #include <asm/starfire.h>
 #include <asm/tlb.h>
+#include <asm/pgalloc.h>
 #include <asm/sections.h>
 #include <asm/prom.h>
 #include <asm/mdesc.h>
--- a/arch/sparc/kernel/sun4m_irq.c~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/arch/sparc/kernel/sun4m_irq.c
@@ -16,7 +16,6 @@
 
 #include <asm/timer.h>
 #include <asm/traps.h>
-#include <asm/pgalloc.h>
 #include <asm/irq.h>
 #include <asm/io.h>
 #include <asm/cacheflush.h>
--- a/arch/sparc/mm/highmem.c~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/arch/sparc/mm/highmem.c
@@ -29,7 +29,6 @@
 
 #include <asm/cacheflush.h>
 #include <asm/tlbflush.h>
-#include <asm/pgalloc.h>
 #include <asm/vaddrs.h>
 
 static pte_t *kmap_pte;
--- a/arch/sparc/mm/iommu.c~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/arch/sparc/mm/iommu.c
@@ -16,7 +16,6 @@
 #include <linux/of.h>
 #include <linux/of_device.h>
 
-#include <asm/pgalloc.h>
 #include <asm/io.h>
 #include <asm/mxcc.h>
 #include <asm/mbus.h>
--- a/arch/sparc/mm/io-unit.c~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/arch/sparc/mm/io-unit.c
@@ -15,7 +15,6 @@
 #include <linux/of.h>
 #include <linux/of_device.h>
 
-#include <asm/pgalloc.h>
 #include <asm/io.h>
 #include <asm/io-unit.h>
 #include <asm/mxcc.h>
--- a/arch/sparc/mm/tlb.c~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/arch/sparc/mm/tlb.c
@@ -10,7 +10,6 @@
 #include <linux/swap.h>
 #include <linux/preempt.h>
 
-#include <asm/pgalloc.h>
 #include <asm/tlbflush.h>
 #include <asm/cacheflush.h>
 #include <asm/mmu_context.h>
--- a/arch/x86/ia32/ia32_aout.c~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/arch/x86/ia32/ia32_aout.c
@@ -30,7 +30,6 @@
 #include <linux/sched/task_stack.h>
 
 #include <linux/uaccess.h>
-#include <asm/pgalloc.h>
 #include <asm/cacheflush.h>
 #include <asm/user32.h>
 #include <asm/ia32.h>
--- a/arch/x86/include/asm/mmu_context.h~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/arch/x86/include/asm/mmu_context.h
@@ -9,7 +9,6 @@
 
 #include <trace/events/tlb.h>
 
-#include <asm/pgalloc.h>
 #include <asm/tlbflush.h>
 #include <asm/paravirt.h>
 #include <asm/debugreg.h>
--- a/arch/x86/kernel/alternative.c~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/arch/x86/kernel/alternative.c
@@ -6,6 +6,7 @@
 #include <linux/mutex.h>
 #include <linux/list.h>
 #include <linux/stringify.h>
+#include <linux/highmem.h>
 #include <linux/mm.h>
 #include <linux/vmalloc.h>
 #include <linux/memory.h>
--- a/arch/x86/kernel/apic/apic.c~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/arch/x86/kernel/apic/apic.c
@@ -40,7 +40,6 @@
 #include <asm/irq_remapping.h>
 #include <asm/perf_event.h>
 #include <asm/x86_init.h>
-#include <asm/pgalloc.h>
 #include <linux/atomic.h>
 #include <asm/mpspec.h>
 #include <asm/i8259.h>
--- a/arch/x86/kernel/mpparse.c~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/arch/x86/kernel/mpparse.c
@@ -22,7 +22,6 @@
 #include <asm/irqdomain.h>
 #include <asm/mtrr.h>
 #include <asm/mpspec.h>
-#include <asm/pgalloc.h>
 #include <asm/io_apic.h>
 #include <asm/proto.h>
 #include <asm/bios_ebda.h>
--- a/arch/x86/kernel/traps.c~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/arch/x86/kernel/traps.c
@@ -62,7 +62,6 @@
 
 #ifdef CONFIG_X86_64
 #include <asm/x86_init.h>
-#include <asm/pgalloc.h>
 #include <asm/proto.h>
 #else
 #include <asm/processor-flags.h>
--- a/arch/x86/mm/fault.c~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/arch/x86/mm/fault.c
@@ -21,7 +21,6 @@
 
 #include <asm/cpufeature.h>		/* boot_cpu_has, ...		*/
 #include <asm/traps.h>			/* dotraplinkage, ...		*/
-#include <asm/pgalloc.h>		/* pgd_*(), ...			*/
 #include <asm/fixmap.h>			/* VSYSCALL_ADDR		*/
 #include <asm/vsyscall.h>		/* emulate_vsyscall		*/
 #include <asm/vm86.h>			/* struct vm86			*/
--- a/arch/x86/mm/hugetlbpage.c~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/arch/x86/mm/hugetlbpage.c
@@ -17,7 +17,6 @@
 #include <asm/mman.h>
 #include <asm/tlb.h>
 #include <asm/tlbflush.h>
-#include <asm/pgalloc.h>
 #include <asm/elf.h>
 
 #if 0	/* This is just for testing */
--- a/arch/x86/mm/kaslr.c~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/arch/x86/mm/kaslr.c
@@ -26,7 +26,6 @@
 #include <linux/memblock.h>
 #include <linux/pgtable.h>
 
-#include <asm/pgalloc.h>
 #include <asm/setup.h>
 #include <asm/kaslr.h>
 
--- a/arch/x86/mm/pgtable_32.c~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/arch/x86/mm/pgtable_32.c
@@ -11,7 +11,6 @@
 #include <linux/spinlock.h>
 
 #include <asm/cpu_entry_area.h>
-#include <asm/pgalloc.h>
 #include <asm/fixmap.h>
 #include <asm/e820/api.h>
 #include <asm/tlb.h>
--- a/arch/x86/mm/pti.c~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/arch/x86/mm/pti.c
@@ -34,7 +34,6 @@
 #include <asm/vsyscall.h>
 #include <asm/cmdline.h>
 #include <asm/pti.h>
-#include <asm/pgalloc.h>
 #include <asm/tlbflush.h>
 #include <asm/desc.h>
 #include <asm/sections.h>
--- a/arch/x86/platform/uv/bios_uv.c~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/arch/x86/platform/uv/bios_uv.c
@@ -11,6 +11,7 @@
 #include <linux/slab.h>
 #include <asm/efi.h>
 #include <linux/io.h>
+#include <asm/pgalloc.h>
 #include <asm/uv/bios.h>
 #include <asm/uv/uv_hub.h>
 
--- a/arch/xtensa/kernel/xtensa_ksyms.c~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/arch/xtensa/kernel/xtensa_ksyms.c
@@ -25,7 +25,6 @@
 #include <asm/dma.h>
 #include <asm/io.h>
 #include <asm/page.h>
-#include <asm/pgalloc.h>
 #include <asm/ftrace.h>
 #ifdef CONFIG_BLK_DEV_FD
 #include <asm/floppy.h>
--- a/arch/xtensa/mm/cache.c~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/arch/xtensa/mm/cache.c
@@ -31,7 +31,6 @@
 #include <asm/tlb.h>
 #include <asm/tlbflush.h>
 #include <asm/page.h>
-#include <asm/pgalloc.h>
 
 /* 
  * Note:
--- a/arch/xtensa/mm/fault.c~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/arch/xtensa/mm/fault.c
@@ -20,7 +20,6 @@
 #include <asm/mmu_context.h>
 #include <asm/cacheflush.h>
 #include <asm/hardirq.h>
-#include <asm/pgalloc.h>
 
 DEFINE_PER_CPU(unsigned long, asid_cache) = ASID_USER_FIRST;
 void bad_page_fault(struct pt_regs*, unsigned long, int);
--- a/drivers/block/xen-blkback/common.h~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/drivers/block/xen-blkback/common.h
@@ -36,7 +36,6 @@
 #include <linux/io.h>
 #include <linux/rbtree.h>
 #include <asm/setup.h>
-#include <asm/pgalloc.h>
 #include <asm/hypervisor.h>
 #include <xen/grant_table.h>
 #include <xen/page.h>
--- a/drivers/iommu/ipmmu-vmsa.c~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/drivers/iommu/ipmmu-vmsa.c
@@ -28,7 +28,6 @@
 
 #if defined(CONFIG_ARM) && !defined(CONFIG_IOMMU_DMA)
 #include <asm/dma-iommu.h>
-#include <asm/pgalloc.h>
 #else
 #define arm_iommu_create_mapping(...)	NULL
 #define arm_iommu_attach_device(...)	-ENODEV
--- a/drivers/xen/balloon.c~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/drivers/xen/balloon.c
@@ -58,7 +58,6 @@
 #include <linux/sysctl.h>
 
 #include <asm/page.h>
-#include <asm/pgalloc.h>
 #include <asm/tlb.h>
 
 #include <asm/xen/hypervisor.h>
--- a/drivers/xen/privcmd.c~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/drivers/xen/privcmd.c
@@ -25,7 +25,6 @@
 #include <linux/miscdevice.h>
 #include <linux/moduleparam.h>
 
-#include <asm/pgalloc.h>
 #include <asm/xen/hypervisor.h>
 #include <asm/xen/hypercall.h>
 
--- a/fs/binfmt_elf_fdpic.c~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/fs/binfmt_elf_fdpic.c
@@ -38,7 +38,6 @@
 
 #include <linux/uaccess.h>
 #include <asm/param.h>
-#include <asm/pgalloc.h>
 
 typedef char *elf_caddr_t;
 
--- a/include/asm-generic/tlb.h~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/include/asm-generic/tlb.h
@@ -14,7 +14,6 @@
 #include <linux/mmu_notifier.h>
 #include <linux/swap.h>
 #include <linux/hugetlb_inline.h>
-#include <asm/pgalloc.h>
 #include <asm/tlbflush.h>
 #include <asm/cacheflush.h>
 
--- a/mm/hugetlb.c~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/mm/hugetlb.c
@@ -31,6 +31,7 @@
 #include <linux/cma.h>
 
 #include <asm/page.h>
+#include <asm/pgalloc.h>
 #include <asm/tlb.h>
 
 #include <linux/io.h>
--- a/mm/sparse.c~mm-remove-unneeded-includes-of-asm-pgalloch
+++ a/mm/sparse.c
@@ -16,7 +16,6 @@
 
 #include "internal.h"
 #include <asm/dma.h>
-#include <asm/pgalloc.h>
 
 /*
  * Permanent SPARSEMEM data:
_

Patches currently in -mm which might be from rppt@linux.ibm.com are

mm-remove-unneeded-includes-of-asm-pgalloch.patch
opeinrisc-switch-to-generic-version-of-pte-allocation.patch
xtensa-switch-to-generic-version-of-pte-allocation.patch
asm-generic-pgalloc-provide-generic-pmd_alloc_one-and-pmd_free_one.patch
asm-generic-pgalloc-provide-generic-pud_alloc_one-and-pud_free_one.patch
asm-generic-pgalloc-provide-generic-pgd_free.patch
mm-move-lib-ioremapc-to-mm.patch
