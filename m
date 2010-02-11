From: akpm@linux-foundation.org
Subject: + pci-dma-add-linux-pci-dmah-to-linux-pcih.patch added to -mm tree
Date: Thu, 11 Feb 2010 12:40:28 -0800
Message-ID: <201002112040.o1BKeTcb027326@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37393 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757062Ab0BKUkg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 11 Feb 2010 15:40:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp, arnd@arndb.de, jbarnes@virtuousgeek.org


The patch titled
     pci-dma: add linux/pci-dma.h to linux/pci.h
has been added to the -mm tree.  Its filename is
     pci-dma-add-linux-pci-dmah-to-linux-pcih.patch

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
Subject: pci-dma: add linux/pci-dma.h to linux/pci.h
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

All the architectures properly set NEED_DMA_MAP_STATE now so we can safely
add linux/pci-dma.h to linux/pci.h and remove the linux/pci-dma.h
inclusion in arch's asm/pci.h

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/pci.h   |    2 --
 arch/arm/include/asm/pci.h     |    2 --
 arch/cris/include/asm/pci.h    |    2 --
 arch/frv/include/asm/pci.h     |    2 --
 arch/ia64/include/asm/pci.h    |    2 --
 arch/mips/include/asm/pci.h    |    2 --
 arch/parisc/include/asm/pci.h  |    2 --
 arch/powerpc/include/asm/pci.h |    2 --
 arch/sh/include/asm/pci.h      |    2 --
 arch/sparc/include/asm/pci.h   |    2 --
 arch/x86/include/asm/pci.h     |    2 --
 arch/xtensa/include/asm/pci.h  |    2 --
 include/linux/pci.h            |    1 +
 13 files changed, 1 insertion(+), 24 deletions(-)

diff -puN arch/alpha/include/asm/pci.h~pci-dma-add-linux-pci-dmah-to-linux-pcih arch/alpha/include/asm/pci.h
--- a/arch/alpha/include/asm/pci.h~pci-dma-add-linux-pci-dmah-to-linux-pcih
+++ a/arch/alpha/include/asm/pci.h
@@ -119,8 +119,6 @@ pci_dma_mapping_error(struct pci_dev *pd
 extern void pci_unmap_single(struct pci_dev *, dma_addr_t, size_t, int);
 extern void pci_unmap_page(struct pci_dev *, dma_addr_t, size_t, int);
 
-#include <linux/pci-dma.h>
-
 /* Map a set of buffers described by scatterlist in streaming mode for
    PCI DMA.  This is the scatter-gather version of the above
    pci_map_single interface.  Here the scatter gather list elements
diff -puN arch/arm/include/asm/pci.h~pci-dma-add-linux-pci-dmah-to-linux-pcih arch/arm/include/asm/pci.h
--- a/arch/arm/include/asm/pci.h~pci-dma-add-linux-pci-dmah-to-linux-pcih
+++ a/arch/arm/include/asm/pci.h
@@ -30,8 +30,6 @@ static inline void pcibios_penalize_isa_
  */
 #define PCI_DMA_BUS_IS_PHYS     (1)
 
-#include <linux/pci-dma.h>
-
 #ifdef CONFIG_PCI
 static inline void pci_dma_burst_advice(struct pci_dev *pdev,
 					enum pci_dma_burst_strategy *strat,
diff -puN arch/cris/include/asm/pci.h~pci-dma-add-linux-pci-dmah-to-linux-pcih arch/cris/include/asm/pci.h
--- a/arch/cris/include/asm/pci.h~pci-dma-add-linux-pci-dmah-to-linux-pcih
+++ a/arch/cris/include/asm/pci.h
@@ -44,8 +44,6 @@ struct pci_dev;
  */
 #define PCI_DMA_BUS_IS_PHYS	(1)
 
-#include <linux/pci-dma.h>
-
 #define HAVE_PCI_MMAP
 extern int pci_mmap_page_range(struct pci_dev *dev, struct vm_area_struct *vma,
 			       enum pci_mmap_state mmap_state, int write_combine);
diff -puN arch/frv/include/asm/pci.h~pci-dma-add-linux-pci-dmah-to-linux-pcih arch/frv/include/asm/pci.h
--- a/arch/frv/include/asm/pci.h~pci-dma-add-linux-pci-dmah-to-linux-pcih
+++ a/arch/frv/include/asm/pci.h
@@ -43,8 +43,6 @@ extern void pci_free_consistent(struct p
 /* Return the index of the PCI controller for device PDEV. */
 #define pci_controller_num(PDEV)	(0)
 
-#include <linux/pci-dma.h>
-
 #ifdef CONFIG_PCI
 static inline void pci_dma_burst_advice(struct pci_dev *pdev,
 					enum pci_dma_burst_strategy *strat,
diff -puN arch/ia64/include/asm/pci.h~pci-dma-add-linux-pci-dmah-to-linux-pcih arch/ia64/include/asm/pci.h
--- a/arch/ia64/include/asm/pci.h~pci-dma-add-linux-pci-dmah-to-linux-pcih
+++ a/arch/ia64/include/asm/pci.h
@@ -56,8 +56,6 @@ pcibios_penalize_isa_irq (int irq, int a
 
 #include <asm-generic/pci-dma-compat.h>
 
-#include <linux/pci-dma.h>
-
 #ifdef CONFIG_PCI
 static inline void pci_dma_burst_advice(struct pci_dev *pdev,
 					enum pci_dma_burst_strategy *strat,
diff -puN arch/mips/include/asm/pci.h~pci-dma-add-linux-pci-dmah-to-linux-pcih arch/mips/include/asm/pci.h
--- a/arch/mips/include/asm/pci.h~pci-dma-add-linux-pci-dmah-to-linux-pcih
+++ a/arch/mips/include/asm/pci.h
@@ -102,8 +102,6 @@ struct pci_dev;
  */
 extern unsigned int PCI_DMA_BUS_IS_PHYS;
 
-#include <linux/pci-dma.h>
-
 #ifdef CONFIG_PCI
 static inline void pci_dma_burst_advice(struct pci_dev *pdev,
 					enum pci_dma_burst_strategy *strat,
diff -puN arch/parisc/include/asm/pci.h~pci-dma-add-linux-pci-dmah-to-linux-pcih arch/parisc/include/asm/pci.h
--- a/arch/parisc/include/asm/pci.h~pci-dma-add-linux-pci-dmah-to-linux-pcih
+++ a/arch/parisc/include/asm/pci.h
@@ -183,8 +183,6 @@ struct pci_bios_ops {
 	void (*fixup_bus)(struct pci_bus *bus);
 };
 
-#include <linux/pci-dma.h>
-
 /*
 ** Stuff declared in arch/parisc/kernel/pci.c
 */
diff -puN arch/powerpc/include/asm/pci.h~pci-dma-add-linux-pci-dmah-to-linux-pcih arch/powerpc/include/asm/pci.h
--- a/arch/powerpc/include/asm/pci.h~pci-dma-add-linux-pci-dmah-to-linux-pcih
+++ a/arch/powerpc/include/asm/pci.h
@@ -141,8 +141,6 @@ extern int pci_mmap_legacy_page_range(st
 
 #define HAVE_PCI_LEGACY	1
 
-#include <linux/pci-dma.h>
-
 #ifdef CONFIG_PPC64
 
 /* The PCI address space does not equal the physical memory address
diff -puN arch/sh/include/asm/pci.h~pci-dma-add-linux-pci-dmah-to-linux-pcih arch/sh/include/asm/pci.h
--- a/arch/sh/include/asm/pci.h~pci-dma-add-linux-pci-dmah-to-linux-pcih
+++ a/arch/sh/include/asm/pci.h
@@ -83,8 +83,6 @@ static inline void pcibios_penalize_isa_
  */
 #define PCI_DMA_BUS_IS_PHYS	(dma_ops->is_phys)
 
-#include <linux/pci-dma.h>
-
 #ifdef CONFIG_PCI
 /*
  * None of the SH PCI controllers support MWI, it is always treated as a
diff -puN arch/sparc/include/asm/pci.h~pci-dma-add-linux-pci-dmah-to-linux-pcih arch/sparc/include/asm/pci.h
--- a/arch/sparc/include/asm/pci.h~pci-dma-add-linux-pci-dmah-to-linux-pcih
+++ a/arch/sparc/include/asm/pci.h
@@ -6,8 +6,6 @@
 #include <asm/pci_32.h>
 #endif
 
-#include <linux/pci-dma.h>
-
 #include <asm-generic/pci-dma-compat.h>
 
 #endif
diff -puN arch/x86/include/asm/pci.h~pci-dma-add-linux-pci-dmah-to-linux-pcih arch/x86/include/asm/pci.h
--- a/arch/x86/include/asm/pci.h~pci-dma-add-linux-pci-dmah-to-linux-pcih
+++ a/arch/x86/include/asm/pci.h
@@ -99,8 +99,6 @@ extern void pci_iommu_alloc(void);
 /* implement the pci_ DMA API in terms of the generic device dma_ one */
 #include <asm-generic/pci-dma-compat.h>
 
-#include <linux/pci-dma.h>
-
 /* generic pci stuff */
 #include <asm-generic/pci.h>
 #define PCIBIOS_MAX_MEM_32 0xffffffff
diff -puN arch/xtensa/include/asm/pci.h~pci-dma-add-linux-pci-dmah-to-linux-pcih arch/xtensa/include/asm/pci.h
--- a/arch/xtensa/include/asm/pci.h~pci-dma-add-linux-pci-dmah-to-linux-pcih
+++ a/arch/xtensa/include/asm/pci.h
@@ -56,8 +56,6 @@ struct pci_dev;
 
 #define PCI_DMA_BUS_IS_PHYS	(1)
 
-#include <linux/pci-dma.h>
-
 /* Map a range of PCI memory or I/O space for a device into user space */
 int pci_mmap_page_range(struct pci_dev *pdev, struct vm_area_struct *vma,
                         enum pci_mmap_state mmap_state, int write_combine);
diff -puN include/linux/pci.h~pci-dma-add-linux-pci-dmah-to-linux-pcih include/linux/pci.h
--- a/include/linux/pci.h~pci-dma-add-linux-pci-dmah-to-linux-pcih
+++ a/include/linux/pci.h
@@ -872,6 +872,7 @@ int pci_set_vga_state(struct pci_dev *pd
 		      unsigned int command_bits, bool change_bridge);
 /* kmem_cache style wrapper around pci_alloc_consistent() */
 
+#include <linux/pci-dma.h>
 #include <linux/dmapool.h>
 
 #define	pci_pool dma_pool
_

Patches currently in -mm which might be from fujita.tomonori@lab.ntt.co.jp are

linux-next.patch
x86-agp-fix-agp_amd64_init-module-initialization-regression.patch
scsi-add-__init-__exit-macros-to-ibmvstgtc.patch
frv-remove-pci_dma_sync_single-and-pci_dma_sync_sg.patch
documentation-dma-apitxt-remove-deprecated-function-descriptions.patch
dma-apitxt-add-dma_sync_single-sg-api-description.patch
dma-apitxt-remove-dma_sync_single_range-description.patch
alpha-remove-dma_sync_single_range.patch
um-remove-dma_sync_single_range.patch
pci-dma-add-include-linux-pci-dmah.patch
pci-dma-x86-use-include-linux-pci-dmah.patch
pci-dma-alpha-use-include-linux-pci-dmah.patch
pci-dma-arm-use-include-linux-pci-dmah.patch
pci-dma-frv-use-include-linux-pci-dmah.patch
pci-dma-ia64-use-include-linux-pci-dmah.patch
pci-dma-mips-use-include-linux-pci-dmah.patch
pci-dma-parisc-use-include-linux-pci-dmah.patch
pci-dma-powerpc-use-include-linux-pci-dmah.patch
pci-dma-sh-use-include-linux-pci-dmah.patch
pci-dma-sparc-use-include-linux-pci-dmah.patch
pci-dma-xtensa-use-include-linux-pci-dmah.patch
pci-dma-cris-use-include-linux-pci-dmah.patch
pci-dma-add-linux-pci-dmah-to-linux-pcih.patch

