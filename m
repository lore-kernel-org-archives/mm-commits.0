From: akpm@linux-foundation.org
Subject: + i386-pci-fixup-for-siemens-nixdorf-ag-fsc-multiprocessor-interrupt-controllers.patch added to -mm tree
Date: Fri, 11 May 2007 14:09:07 -0700
Message-ID: <200705112109.l4BL97C5026729@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:47474 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761172AbXEKVJY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 May 2007 17:09:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ink@jurassic.park.msu.ru, Wolfgang.Erig@gmx.de, ak@suse.de, cebbert@redhat.com, greg@kroah.com


The patch titled
     i386 pci: fixup for Siemens Nixdorf AG FSC Multiprocessor Interrupt Controllers
has been added to the -mm tree.  Its filename is
     i386-pci-fixup-for-siemens-nixdorf-ag-fsc-multiprocessor-interrupt-controllers.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
i386-pci-fixup-for-siemens-nixdorf-ag-fsc-multiprocessor-interrupt-controllers.patch
alpha-support-graphics-on-non-zero-pci-domains.patch
alpha-support-graphics-on-non-zero-pci-domains-fix.patch
alpha-correct-low-level-i-o-routines-for-sable-lynx.patch
alpha-misc-fixes.patch
make-sure-nobodys-leaking-resources.patch
