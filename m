From: akpm@linux-foundation.org
Subject: - pci-remove-default-pci-expansion-rom-memory-allocation.patch removed from -mm tree
Date: Fri, 21 Dec 2007 14:08:22 -0800
Message-ID: <200712212208.lBLM8M7x001705@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50239 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755951AbXLUWKo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Dec 2007 17:10:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: garyhade@us.ibm.com, greg@kroah.com, j-nomura@ce.jp.nec.com, jbeulich@novell.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     PCI: remove default PCI expansion ROM memory allocation
has been removed from the -mm tree.  Its filename was
     pci-remove-default-pci-expansion-rom-memory-allocation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: PCI: remove default PCI expansion ROM memory allocation
From: Gary Hade <garyhade@us.ibm.com>

Contention for scarce PCI memory resources has been growing due to an
increasing number of PCI slots in large multi-node systems.  The kernel
currently attempts by default to allocate memory for all PCI expansion ROMs
so there has also been an increasing number of PCI memory allocation
failures seen on these systems.  This occurs because the BIOS either (1)
provides insufficient PCI memory resource for all the expansion ROMs or (2)
provides adequate PCI memory resource for expansion ROMs but provides the
space in kernel unexpected BIOS assigned P2P non-prefetch windows.

The resulting PCI memory allocation failures may be benign when related to
memory requests for expansion ROMs themselves but in some cases they can
occur when attempting to allocate space for more critical BARs.  This can
happen when a successful expansion ROM allocation request consumes memory
resource that was intended for a non-ROM BAR.  We have seen this happen
during PCI hotplug of an adapter that contains a P2P bridge where
successful memory allocation for an expansion ROM BAR on device behind the
bridge consumed memory that was intended for a non-ROM BAR on the P2P
bridge.  In all cases the allocation failure messages can be very confusing
for users.

This patch addresses the issue by changing the kernel default behavior so
that expansion ROM memory allocations are no longer attempted by default
when the BIOS has not assigned a specific address range to the expansion
ROM BAR.  This was done by changing the 'pci=rom' boot option behavior for
BIOS unassigned expansion ROMs to actually match it's current
kernel-parameters.txt description which already implies "off" by default. 
Behavior for BIOS assigned expansion ROMs implemented in
pcibios_assign_resources() [arch/x86/pci/i386.c] is unchanged.

Signed-off-by: Gary Hade <garyhade@us.ibm.com>
Cc: Greg KH <greg@kroah.com>
Cc: Jan Beulich <jbeulich@novell.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Acked-by: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/pci/common.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff -puN arch/x86/pci/common.c~pci-remove-default-pci-expansion-rom-memory-allocation arch/x86/pci/common.c
--- a/arch/x86/pci/common.c~pci-remove-default-pci-expansion-rom-memory-allocation
+++ a/arch/x86/pci/common.c
@@ -109,6 +109,19 @@ static void __devinit pcibios_fixup_ghos
 	}
 }
 
+static void __devinit pcibios_fixup_device_resources(struct pci_dev *dev)
+{
+	struct resource *rom_r = &dev->resource[PCI_ROM_RESOURCE];
+
+	if (rom_r->parent)
+		return;
+	if (rom_r->start)
+		/* we deal with BIOS assigned ROM later */
+		return;
+	if (!(pci_probe & PCI_ASSIGN_ROMS))
+		rom_r->start = rom_r->end = rom_r->flags = 0;
+}
+
 /*
  *  Called after each bus is probed, but before its children
  *  are examined.
@@ -116,8 +129,12 @@ static void __devinit pcibios_fixup_ghos
 
 void __devinit  pcibios_fixup_bus(struct pci_bus *b)
 {
+	struct pci_dev *dev;
+
 	pcibios_fixup_ghosts(b);
 	pci_read_bridge_bases(b);
+	list_for_each_entry(dev, &b->devices, bus_list)
+		pcibios_fixup_device_resources(dev);
 }
 
 /*
_

Patches currently in -mm which might be from garyhade@us.ibm.com are

git-x86.patch
