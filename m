From: akpm@linux-foundation.org
Subject: [merged] sections-fix-section-conflicts-in-arch-mips.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:12:24 -0700
Message-ID: <20121005201225.13C2820004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-la0-f74.google.com ([209.85.215.74]:55016 "EHLO
	mail-la0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757263Ab2JEUM1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:12:27 -0400
Received: by mail-la0-f74.google.com with SMTP id j13so98788lah.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:12:26 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ak@linux.intel.com, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     Subject: sections: fix section conflicts in arch/mips
has been removed from the -mm tree.  Its filename was
     sections-fix-section-conflicts-in-arch-mips.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andi Kleen <ak@linux.intel.com>
Subject: sections: fix section conflicts in arch/mips

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/bcm63xx/boards/board_bcm963xx.c |    2 +-
 arch/mips/pci/pci-octeon.c                |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/mips/bcm63xx/boards/board_bcm963xx.c~sections-fix-section-conflicts-in-arch-mips arch/mips/bcm63xx/boards/board_bcm963xx.c
--- a/arch/mips/bcm63xx/boards/board_bcm963xx.c~sections-fix-section-conflicts-in-arch-mips
+++ a/arch/mips/bcm63xx/boards/board_bcm963xx.c
@@ -632,7 +632,7 @@ static struct board_info __initdata boar
 /*
  * all boards
  */
-static const struct board_info __initdata *bcm963xx_boards[] = {
+static const struct board_info __initconst *bcm963xx_boards[] = {
 #ifdef CONFIG_BCM63XX_CPU_6328
 	&board_96328avng,
 #endif
diff -puN arch/mips/pci/pci-octeon.c~sections-fix-section-conflicts-in-arch-mips arch/mips/pci/pci-octeon.c
--- a/arch/mips/pci/pci-octeon.c~sections-fix-section-conflicts-in-arch-mips
+++ a/arch/mips/pci/pci-octeon.c
@@ -58,7 +58,7 @@ union octeon_pci_address {
 	} s;
 };
 
-int __initdata (*octeon_pcibios_map_irq)(const struct pci_dev *dev,
+int __initconst (*octeon_pcibios_map_irq)(const struct pci_dev *dev,
 					 u8 slot, u8 pin);
 enum octeon_dma_bar_type octeon_dma_bar_type = OCTEON_DMA_BAR_TYPE_INVALID;
 
_

Patches currently in -mm which might be from ak@linux.intel.com are

origin.patch
linux-next.patch
thp-x86-introduce-have_arch_transparent_hugepage.patch
thp-remove-assumptions-on-pgtable_t-type.patch
thp-introduce-pmdp_invalidate.patch
thp-make-madv_hugepage-check-for-mm-def_flags.patch
thp-s390-thp-splitting-backend-for-s390.patch
thp-s390-thp-pagetable-pre-allocation-for-s390.patch
thp-s390-disable-thp-for-kvm-host-on-s390.patch
thp-s390-architecture-backend-for-thp-on-s390.patch

