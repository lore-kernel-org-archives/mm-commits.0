From: akpm@linux-foundation.org
Subject: [merged] sections-fix-section-conflicts-in-arch-frv.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:12:15 -0700
Message-ID: <20121005201215.9B71A100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:38013 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757263Ab2JEUMQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:12:16 -0400
Received: by mail-qa0-f74.google.com with SMTP id a16so93506qae.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:12:16 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ak@linux.intel.com, dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: sections: fix section conflicts in arch/frv
has been removed from the -mm tree.  Its filename was
     sections-fix-section-conflicts-in-arch-frv.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

