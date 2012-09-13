From: akpm@linux-foundation.org
Subject: + sections-fix-section-conflicts-in-arch-frv.patch added to -mm tree
Date: Thu, 13 Sep 2012 16:36:41 -0700
Message-ID: <20120913233642.9116420004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:48669 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759089Ab2IMXgo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 13 Sep 2012 19:36:44 -0400
Received: by fass10 with SMTP id s10so219284fas.1
        for <mm-commits@vger.kernel.org>; Thu, 13 Sep 2012 16:36:43 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ak@linux.intel.com, dhowells@redhat.com


The patch titled
     Subject: sections: fix section conflicts in arch/frv
has been added to the -mm tree.  Its filename is
     sections-fix-section-conflicts-in-arch-frv.patch

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
Subject: sections: fix section conflicts in arch/frv

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/frv/kernel/setup.c         |    2 +-
 arch/frv/mb93090-mb00/pci-irq.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/frv/kernel/setup.c~sections-fix-section-conflicts-in-arch-frv arch/frv/kernel/setup.c
--- a/arch/frv/kernel/setup.c~sections-fix-section-conflicts-in-arch-frv
+++ a/arch/frv/kernel/setup.c
@@ -184,7 +184,7 @@ static struct clock_cmode __pminitdata c
 	[6]	= {	_x1,	_x1_5,	_x1_5,	_x4_5,	_x0_375	},
 };
 
-static const struct clock_cmode __pminitdata *clock_cmodes;
+static const struct clock_cmode __pminitconst *clock_cmodes;
 static int __pminitdata clock_doubled;
 
 static struct uart_port __pminitdata __frv_uart0 = {
diff -puN arch/frv/mb93090-mb00/pci-irq.c~sections-fix-section-conflicts-in-arch-frv arch/frv/mb93090-mb00/pci-irq.c
--- a/arch/frv/mb93090-mb00/pci-irq.c~sections-fix-section-conflicts-in-arch-frv
+++ a/arch/frv/mb93090-mb00/pci-irq.c
@@ -28,7 +28,7 @@
  *
  */
 
-static const uint8_t __initdata pci_bus0_irq_routing[32][4] = {
+static const uint8_t __initconst pci_bus0_irq_routing[32][4] = {
 	[0 ] = { IRQ_FPGA_MB86943_PCI_INTA },
 	[16] = { IRQ_FPGA_RTL8029_INTA },
 	[17] = { IRQ_FPGA_PCI_INTC, IRQ_FPGA_PCI_INTD, IRQ_FPGA_PCI_INTA, IRQ_FPGA_PCI_INTB },
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

