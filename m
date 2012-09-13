From: akpm@linux-foundation.org
Subject: + sections-fix-section-conflicts-in-arch-mips.patch added to -mm tree
Date: Thu, 13 Sep 2012 16:36:50 -0700
Message-ID: <20120913233651.2DD231E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:38926 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759146Ab2IMXgw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 13 Sep 2012 19:36:52 -0400
Received: by qafl39 with SMTP id l39so398542qaf.1
        for <mm-commits@vger.kernel.org>; Thu, 13 Sep 2012 16:36:51 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ak@linux.intel.com, ralf@linux-mips.org


The patch titled
     Subject: sections: fix section conflicts in arch/mips
has been added to the -mm tree.  Its filename is
     sections-fix-section-conflicts-in-arch-mips.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -639,7 +639,7 @@ static struct board_info __initdata boar
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

compilerh-add-__visible.patch
linux-next.patch
thp-x86-introduce-have_arch_transparent_hugepage.patch
thp-remove-assumptions-on-pgtable_t-type.patch
thp-introduce-pmdp_invalidate.patch
thp-make-madv_hugepage-check-for-mm-def_flags.patch
thp-s390-thp-splitting-backend-for-s390.patch
thp-s390-thp-pagetable-pre-allocation-for-s390.patch
thp-s390-disable-thp-for-kvm-host-on-s390.patch
thp-s390-architecture-backend-for-thp-on-s390.patch
sections-disable-const-sections-for-pa-risc-v2.patch
sections-fix-section-conflicts-in-arch-arm.patch
sections-fix-section-conflicts-in-arch-frv.patch
sections-fix-section-conflicts-in-arch-h8300.patch
sections-fix-section-conflicts-in-arch-ia64.patch
sections-fix-section-conflicts-in-arch-mips.patch
sections-fix-section-conflicts-in-arch-powerpc.patch
sections-fix-section-conflicts-in-arch-score.patch
sections-fix-section-conflicts-in-arch-sh.patch
sections-fix-section-conflicts-in-arch-x86.patch
sections-fix-section-conflicts-in-drivers-atm.patch
sections-fix-section-conflicts-in-drivers-char.patch
sections-fix-section-conflicts-in-drivers-cpufreq.patch
sections-fix-section-conflicts-in-drivers-ide.patch
sections-fix-section-conflicts-in-drivers-macintosh.patch
sections-fix-section-conflicts-in-drivers-mfd.patch
sections-fix-section-conflicts-in-drivers-mmc.patch
sections-fix-section-conflicts-in-drivers-net.patch
sections-fix-section-conflicts-in-drivers-net-hamradio.patch
sections-fix-section-conflicts-in-drivers-net-wan.patch
sections-fix-section-conflicts-in-drivers-platform-x86.patch
sections-fix-section-conflicts-in-drivers-scsi.patch
sections-fix-section-conflicts-in-drivers-video.patch
sections-fix-section-conflicts-in-mm-percpuc.patch
sections-fix-section-conflicts-in-net-can.patch
sections-fix-section-conflicts-in-net.patch
sections-fix-section-conflicts-in-sound.patch
sectons-fix-const-sections-for-crc32-table.patch
compat_ioctl-remove-unused-local-typedef.patch

