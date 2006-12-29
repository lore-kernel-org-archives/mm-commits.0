From: akpm@osdl.org
Subject: + x86-fix-dev_to_node-for-x86-and-x86_64.patch added to -mm tree
Date: Thu, 28 Dec 2006 16:06:04 -0800
Message-ID: <200612290006.kBT06458016893@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:44148 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753952AbWL2AGZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Dec 2006 19:06:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kiran@scalex86.org, alok.kataria@calsoftinc.com, shai@scalex86.org


The patch titled
     x86: Fix dev_to_node for x86 and x86_64
has been added to the -mm tree.  Its filename is
     x86-fix-dev_to_node-for-x86-and-x86_64.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86: Fix dev_to_node for x86 and x86_64
From: Ravikiran G Thirumalai <kiran@scalex86.org>

dev_to_node does not work as expected on x86_64 (and i386).  This is
because node value returned by pcibus_to_node is initialized after a struct
device is created with current x86_64 code.

We need the node value initialized before the call to
pci_scan_bus_parented, as the generic devices are allocated and initialized
off pci_scan_child_bus, which gets called from pci_scan_bus_parented The
following patch does that using "pci_sysdata" introduced by the PCI domain
patches in -mm.

Signed-off-by: Alok N Kataria <alok.kataria@calsoftinc.com>
Signed-off-by: Ravikiran Thirumalai <kiran@scalex86.org>
Signed-off-by: Shai Fultheim <shai@scalex86.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/pci/acpi.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff -puN arch/i386/pci/acpi.c~x86-fix-dev_to_node-for-x86-and-x86_64 arch/i386/pci/acpi.c
--- a/arch/i386/pci/acpi.c~x86-fix-dev_to_node-for-x86-and-x86_64
+++ a/arch/i386/pci/acpi.c
@@ -9,6 +9,7 @@ struct pci_bus * __devinit pci_acpi_scan
 {
 	struct pci_bus *bus;
 	struct pci_sysdata *sd;
+	int pxm;
 
 	/* Allocate per-root-bus (not per bus) arch-specific data.
 	 * TODO: leak; this memory is never freed.
@@ -30,15 +31,21 @@ struct pci_bus * __devinit pci_acpi_scan
 	}
 #endif /* CONFIG_PCI_DOMAINS */
 
+	sd->node = -1;
+
+	pxm = acpi_get_pxm(device->handle);
+#ifdef CONFIG_ACPI_NUMA
+	if (pxm >= 0)
+		sd->node = pxm_to_node(pxm);
+#endif
+
 	bus = pci_scan_bus_parented(NULL, busnum, &pci_root_ops, sd);
 	if (!bus)
 		kfree(sd);
 
 #ifdef CONFIG_ACPI_NUMA
 	if (bus != NULL) {
-		int pxm = acpi_get_pxm(device->handle);
 		if (pxm >= 0) {
-			sd->node = pxm_to_node(pxm);
 			printk("bus %d -> pxm %d -> node %d\n",
 				busnum, pxm, sd->node);
 		}
_

Patches currently in -mm which might be from kiran@scalex86.org are

x86-fix-dev_to_node-for-x86-and-x86_64.patch
mm-set-hashdist_default-to-1-for-x86_64-numa.patch
slab-leaks3-default-y.patch

