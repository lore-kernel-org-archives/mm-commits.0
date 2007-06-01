From: akpm@linux-foundation.org
Subject: - i386-pci-fixup-for-siemens-nixdorf-ag-fsc-multiprocessor-interrupt-controllers.patch removed from -mm tree
Date: Fri, 01 Jun 2007 00:07:08 -0700
Message-ID: <200706010707.l517772X004764@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:59978 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756601AbXFAHHh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jun 2007 03:07:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ink@jurassic.park.msu.ru, Wolfgang.Erig@gmx.de, ak@suse.de, cebbert@redhat.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     i386 pci: fixup for Siemens Nixdorf AG FSC Multiprocessor Interrupt Controllers
has been removed from the -mm tree.  Its filename was
     i386-pci-fixup-for-siemens-nixdorf-ag-fsc-multiprocessor-interrupt-controllers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: i386 pci: fixup for Siemens Nixdorf AG FSC Multiprocessor Interrupt Controllers
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>

Wolfgang gets:

 PCI: Cannot allocate resource region 0 of device 0000:00:04.0
 PCI: Error while updating region 0000:00:04.0/0 (a8008000 != fec08000)

Note that the BAR seems to have high address bits hardwired to fec00000.
And device 0000:00:04.0 is

 00:04.0 System peripheral: Siemens Nixdorf AG FSC Multiprocessor Interrupt Controller (rev 02)

I'd guess that when we try to reassign this resource, PCI interrupts might
just stop working. This could explain SCSI timeouts and other weird things.

Cc: Wolfgang Erig <Wolfgang.Erig@gmx.de>
Cc: Chuck Ebbert <cebbert@redhat.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/pci/fixup.c |   11 +++++++++++
 1 files changed, 11 insertions(+)

diff -puN arch/i386/pci/fixup.c~i386-pci-fixup-for-siemens-nixdorf-ag-fsc-multiprocessor-interrupt-controllers arch/i386/pci/fixup.c
--- a/arch/i386/pci/fixup.c~i386-pci-fixup-for-siemens-nixdorf-ag-fsc-multiprocessor-interrupt-controllers
+++ a/arch/i386/pci/fixup.c
@@ -438,3 +438,14 @@ DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_CY
 			pci_early_fixup_cyrix_5530);
 DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_CYRIX, PCI_DEVICE_ID_CYRIX_5530_LEGACY,
 			pci_early_fixup_cyrix_5530);
+
+/*
+ * Siemens Nixdorf AG FSC Multiprocessor Interrupt Controller:
+ * prevent update of the BAR0, which doesn't look like a normal BAR.
+ */
+static void __devinit pci_siemens_interrupt_controller(struct pci_dev *dev)
+{
+	dev->resource[0].flags |= IORESOURCE_PCI_FIXED;
+}
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_SIEMENS, 0x0015,
+			  pci_siemens_interrupt_controller);
_

Patches currently in -mm which might be from ink@jurassic.park.msu.ru are

origin.patch
potential-parse-error-in-ifdef-update.patch
alpha-support-graphics-on-non-zero-pci-domains.patch
alpha-support-graphics-on-non-zero-pci-domains-fix.patch
alpha-support-graphics-on-non-zero-pci-domains-fix-2.patch
alpha-correct-low-level-i-o-routines-for-sable-lynx.patch
alpha-misc-fixes.patch
make-sure-nobodys-leaking-resources.patch
