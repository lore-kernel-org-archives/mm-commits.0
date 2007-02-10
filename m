From: akpm@linux-foundation.org
Subject: - mmconfig-fix-unreachable_devices.patch removed from -mm tree
Date: Fri, 09 Feb 2007 20:57:49 -0800
Message-ID: <200702100457.l1A4vnh8004053@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36199 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753095AbXBJE54 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 9 Feb 2007 23:57:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hirofumi@mail.parknet.co.jp, ak@suse.de, arjan@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     MMCONFIG: fix unreachable_devices()
has been removed from the -mm tree.  Its filename was
     mmconfig-fix-unreachable_devices.patch

This patch was dropped because acpi and x86_64 tree changes wrecked it

------------------------------------------------------
Subject: MMCONFIG: fix unreachable_devices()
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

Currently, unreachable_devices() compares value of mmconfig and value of
conf1.  But it doesn't check the device is reachable or not.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/pci/mmconfig-shared.c |   12 +++++++-----
 arch/i386/pci/mmconfig.c        |    6 ++++++
 arch/i386/pci/pci.h             |    2 ++
 arch/x86_64/pci/mmconfig.c      |    6 ++++++
 4 files changed, 21 insertions(+), 5 deletions(-)

diff -puN arch/i386/pci/mmconfig-shared.c~mmconfig-fix-unreachable_devices arch/i386/pci/mmconfig-shared.c
--- a/arch/i386/pci/mmconfig-shared.c~mmconfig-fix-unreachable_devices
+++ a/arch/i386/pci/mmconfig-shared.c
@@ -43,12 +43,14 @@ static void __init unreachable_devices(v
 			if (val1 == 0xffffffff)
 				continue;
 
-			raw_pci_ops->read(0, bus, devfn, 0, 4, &val2);
-			if (val1 != val2) {
-				set_bit(i + 32 * bus, pci_mmcfg_fallback_slots);
-				printk(KERN_NOTICE "PCI: No mmconfig possible"
-				       " on device %02x:%02x\n", bus, i);
+			if (pci_mmcfg_arch_reachable(0, bus, devfn)) {
+				raw_pci_ops->read(0, bus, devfn, 0, 4, &val2);
+				if (val1 == val2)
+					continue;
 			}
+			set_bit(i + 32 * bus, pci_mmcfg_fallback_slots);
+			printk(KERN_NOTICE "PCI: No mmconfig possible on device"
+			       " %02x:%02x\n", bus, i);
 		}
 	}
 }
diff -puN arch/i386/pci/mmconfig.c~mmconfig-fix-unreachable_devices arch/i386/pci/mmconfig.c
--- a/arch/i386/pci/mmconfig.c~mmconfig-fix-unreachable_devices
+++ a/arch/i386/pci/mmconfig.c
@@ -136,6 +136,12 @@ static struct pci_raw_ops pci_mmcfg = {
 	.write =	pci_mmcfg_write,
 };
 
+int __init pci_mmcfg_arch_reachable(unsigned int seg, unsigned int bus,
+				    unsigned int devfn)
+{
+	return get_base_addr(seg, bus, devfn) != 0;
+}
+
 int __init pci_mmcfg_arch_init(void)
 {
 	printk(KERN_INFO "PCI: Using MMCONFIG\n");
diff -puN arch/i386/pci/pci.h~mmconfig-fix-unreachable_devices arch/i386/pci/pci.h
--- a/arch/i386/pci/pci.h~mmconfig-fix-unreachable_devices
+++ a/arch/i386/pci/pci.h
@@ -101,4 +101,6 @@ extern void pcibios_sort(void);
 #define PCI_MMCFG_MAX_CHECK_BUS 16
 extern DECLARE_BITMAP(pci_mmcfg_fallback_slots, 32*PCI_MMCFG_MAX_CHECK_BUS);
 
+extern int __init pci_mmcfg_arch_reachable(unsigned int seg, unsigned int bus,
+					   unsigned int devfn);
 extern int __init pci_mmcfg_arch_init(void);
diff -puN arch/x86_64/pci/mmconfig.c~mmconfig-fix-unreachable_devices arch/x86_64/pci/mmconfig.c
--- a/arch/x86_64/pci/mmconfig.c~mmconfig-fix-unreachable_devices
+++ a/arch/x86_64/pci/mmconfig.c
@@ -126,6 +126,12 @@ static void __iomem * __init mcfg_iorema
 	return addr;
 }
 
+int __init pci_mmcfg_arch_reachable(unsigned int seg, unsigned int bus,
+				    unsigned int devfn)
+{
+	return pci_dev_base(seg, bus, devfn) != NULL;
+}
+
 int __init pci_mmcfg_arch_init(void)
 {
 	int i;
_

Patches currently in -mm which might be from hirofumi@mail.parknet.co.jp are

fix-the-reproducible-oops-in-scsi.patch
mmconfig-fix-unreachable_devices.patch
relax-check-for-aix-in-msdos-partition-table.patch
msdos-partitions-fix-logic-error-in-aix-detection.patch
