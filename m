From: akpm@linux-foundation.org
Subject: - finish-i386-and-x86-64-sysdata-conversion.patch removed from -mm tree
Date: Tue, 14 Aug 2007 12:11:48 -0700
Message-ID: <200708141911.l7EJBmeh016330@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57462 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934793AbXHNTNK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Aug 2007 15:13:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: muli@il.ibm.com, ak@suse.de, apw@shadowen.org, cebbert@redhat.com, jeff@garzik.org, riku.seppala@kymp.net, yhlu.kernel@gmail.com, mm-commits@vger.kernel.org


The patch titled
     finish i386 and x86-64 sysdata conversion
has been removed from the -mm tree.  Its filename was
     finish-i386-and-x86-64-sysdata-conversion.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: finish i386 and x86-64 sysdata conversion
From: Muli Ben-Yehuda <muli@il.ibm.com>

This patch finishes the i386 and x86-64 ->sysdata conversion and hopefully
also fixes Riku's and Andy's observed bugs.  It is based on Yinghai Lu's
and Andy Whitcroft's patches (thanks!) with some changes:

- introduce pci_scan_bus_with_sysdata() and use it instead of
  pci_scan_bus() where appropriate. pci_scan_bus_with_sysdata() will
  allocate the sysdata structure and then call pci_scan_bus().
- always allocate pci_sysdata dynamically. The whole point of this
  sysdata work is to make it easy to do root-bus specific things
  (e.g., support PCI domains and IOMMU's). I dislike using a default
  struct pci_sysdata in some places and a dynamically allocated
  pci_sysdata elsewhere - the potential for someone indavertantly
  changing the default structure is too high.
- this patch only makes the minimal changes necessary, i.e., the NUMA node is
  always initialized to -1. Patches to do the right thing with regards
  to the NUMA node can build on top of this (either add a 'node'
  parameter to pci_scan_bus_with_sysdata() or just update the node
  when it becomes known).

The patch was compile tested with various configurations (e.g., NUMAQ,
VISWS) and run-time tested on i386 and x86-64.  Unfortunately none of my
machines exhibited the bugs so caveat emptor.

Andy, could you please see if this fixes the NUMA issues you've seen?
Riku, does this fix "pci=noacpi" on your laptop?

Signed-off-by: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Chuck Ebbert <cebbert@redhat.com>
Cc: <riku.seppala@kymp.net>
Cc: Andy Whitcroft <apw@shadowen.org>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/pci/common.c   |   23 +++++++++++++++++++++++
 arch/i386/pci/fixup.c    |    6 +++---
 arch/i386/pci/irq.c      |    5 +++--
 arch/i386/pci/legacy.c   |    2 +-
 arch/i386/pci/numa.c     |   15 +++++++++------
 arch/i386/pci/visws.c    |    4 ++--
 include/asm-i386/pci.h   |    3 +++
 include/asm-x86_64/pci.h |    2 ++
 8 files changed, 46 insertions(+), 14 deletions(-)

diff -puN arch/i386/pci/common.c~finish-i386-and-x86-64-sysdata-conversion arch/i386/pci/common.c
--- a/arch/i386/pci/common.c~finish-i386-and-x86-64-sysdata-conversion
+++ a/arch/i386/pci/common.c
@@ -455,3 +455,26 @@ void pcibios_disable_device (struct pci_
 	if (!dev->msi_enabled && pcibios_disable_irq)
 		pcibios_disable_irq(dev);
 }
+
+struct pci_bus *pci_scan_bus_with_sysdata(int busno)
+{
+	struct pci_bus *bus = NULL;
+	struct pci_sysdata *sd;
+
+	/*
+	 * Allocate per-root-bus (not per bus) arch-specific data.
+	 * TODO: leak; this memory is never freed.
+	 * It's arguable whether it's worth the trouble to care.
+	 */
+	sd = kzalloc(sizeof(*sd), GFP_KERNEL);
+	if (!sd) {
+		printk(KERN_ERR "PCI: OOM, skipping PCI bus %02x\n", busno);
+		return NULL;
+	}
+	sd->node = -1;
+	bus = pci_scan_bus(busno, &pci_root_ops, sd);
+	if (!bus)
+		kfree(sd);
+
+	return bus;
+}
diff -puN arch/i386/pci/fixup.c~finish-i386-and-x86-64-sysdata-conversion arch/i386/pci/fixup.c
--- a/arch/i386/pci/fixup.c~finish-i386-and-x86-64-sysdata-conversion
+++ a/arch/i386/pci/fixup.c
@@ -25,9 +25,9 @@ static void __devinit pci_fixup_i450nx(s
 		pci_read_config_byte(d, reg++, &subb);
 		DBG("i450NX PXB %d: %02x/%02x/%02x\n", pxb, busno, suba, subb);
 		if (busno)
-			pci_scan_bus(busno, &pci_root_ops, NULL);	/* Bus A */
+			pci_scan_bus_with_sysdata(busno);	/* Bus A */
 		if (suba < subb)
-			pci_scan_bus(suba+1, &pci_root_ops, NULL);	/* Bus B */
+			pci_scan_bus_with_sysdata(suba+1);	/* Bus B */
 	}
 	pcibios_last_bus = -1;
 }
@@ -42,7 +42,7 @@ static void __devinit pci_fixup_i450gx(s
 	u8 busno;
 	pci_read_config_byte(d, 0x4a, &busno);
 	printk(KERN_INFO "PCI: i440KX/GX host bridge %s: secondary bus %02x\n", pci_name(d), busno);
-	pci_scan_bus(busno, &pci_root_ops, NULL);
+	pci_scan_bus_with_sysdata(busno);
 	pcibios_last_bus = -1;
 }
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82454GX, pci_fixup_i450gx);
diff -puN arch/i386/pci/irq.c~finish-i386-and-x86-64-sysdata-conversion arch/i386/pci/irq.c
--- a/arch/i386/pci/irq.c~finish-i386-and-x86-64-sysdata-conversion
+++ a/arch/i386/pci/irq.c
@@ -138,8 +138,9 @@ static void __init pirq_peer_trick(void)
 	for(i = 1; i < 256; i++) {
 		if (!busmap[i] || pci_find_bus(0, i))
 			continue;
-		if (pci_scan_bus(i, &pci_root_ops, NULL))
-			printk(KERN_INFO "PCI: Discovered primary peer bus %02x [IRQ]\n", i);
+		if (pci_scan_bus_with_sysdata(i))
+			printk(KERN_INFO "PCI: Discovered primary peer "
+			       "bus %02x [IRQ]\n", i);
 	}
 	pcibios_last_bus = -1;
 }
diff -puN arch/i386/pci/legacy.c~finish-i386-and-x86-64-sysdata-conversion arch/i386/pci/legacy.c
--- a/arch/i386/pci/legacy.c~finish-i386-and-x86-64-sysdata-conversion
+++ a/arch/i386/pci/legacy.c
@@ -26,7 +26,7 @@ static void __devinit pcibios_fixup_peer
 			    l != 0x0000 && l != 0xffff) {
 				DBG("Found device at %02x:%02x [%04x]\n", n, devfn, l);
 				printk(KERN_INFO "PCI: Discovered peer bus %02x\n", n);
-				pci_scan_bus(n, &pci_root_ops, NULL);
+				pci_scan_bus_with_sysdata(n);
 				break;
 			}
 		}
diff -puN arch/i386/pci/numa.c~finish-i386-and-x86-64-sysdata-conversion arch/i386/pci/numa.c
--- a/arch/i386/pci/numa.c~finish-i386-and-x86-64-sysdata-conversion
+++ a/arch/i386/pci/numa.c
@@ -96,10 +96,14 @@ static void __devinit pci_fixup_i450nx(s
 		pci_read_config_byte(d, reg++, &suba);
 		pci_read_config_byte(d, reg++, &subb);
 		DBG("i450NX PXB %d: %02x/%02x/%02x\n", pxb, busno, suba, subb);
-		if (busno)
-			pci_scan_bus(QUADLOCAL2BUS(quad,busno), &pci_root_ops, NULL);	/* Bus A */
-		if (suba < subb)
-			pci_scan_bus(QUADLOCAL2BUS(quad,suba+1), &pci_root_ops, NULL);	/* Bus B */
+		if (busno) {
+			/* Bus A */
+			pci_scan_bus_with_sysdata(QUADLOCAL2BUS(quad, busno));
+		}
+		if (suba < subb) {
+			/* Bus B */
+			pci_scan_bus_with_sysdata(QUADLOCAL2BUS(quad, suba+1));
+		}
 	}
 	pcibios_last_bus = -1;
 }
@@ -123,8 +127,7 @@ static int __init pci_numa_init(void)
 				continue;
 			printk("Scanning PCI bus %d for quad %d\n", 
 				QUADLOCAL2BUS(quad,0), quad);
-			pci_scan_bus(QUADLOCAL2BUS(quad,0), 
-				&pci_root_ops, NULL);
+			pci_scan_bus_with_sysdata(QUADLOCAL2BUS(quad, 0));
 		}
 	return 0;
 }
diff -puN arch/i386/pci/visws.c~finish-i386-and-x86-64-sysdata-conversion arch/i386/pci/visws.c
--- a/arch/i386/pci/visws.c~finish-i386-and-x86-64-sysdata-conversion
+++ a/arch/i386/pci/visws.c
@@ -101,8 +101,8 @@ static int __init pcibios_init(void)
 		"bridge B (PIIX4) bus: %u\n", pci_bus1, pci_bus0);
 
 	raw_pci_ops = &pci_direct_conf1;
-	pci_scan_bus(pci_bus0, &pci_root_ops, NULL);
-	pci_scan_bus(pci_bus1, &pci_root_ops, NULL);
+	pci_scan_bus_with_sysdata(pci_bus0);
+	pci_scan_bus_with_sysdata(pci_bus1);
 	pci_fixup_irqs(visws_swizzle, visws_map_irq);
 	pcibios_resource_survey();
 	return 0;
diff -puN include/asm-i386/pci.h~finish-i386-and-x86-64-sysdata-conversion include/asm-i386/pci.h
--- a/include/asm-i386/pci.h~finish-i386-and-x86-64-sysdata-conversion
+++ a/include/asm-i386/pci.h
@@ -8,6 +8,9 @@ struct pci_sysdata {
 	int		node;		/* NUMA node */
 };
 
+/* scan a bus after allocating a pci_sysdata for it */
+extern struct pci_bus *pci_scan_bus_with_sysdata(int busno);
+
 #include <linux/mm.h>		/* for struct page */
 
 /* Can be used to override the logic in pci_scan_bus for skipping
diff -puN include/asm-x86_64/pci.h~finish-i386-and-x86-64-sysdata-conversion include/asm-x86_64/pci.h
--- a/include/asm-x86_64/pci.h~finish-i386-and-x86-64-sysdata-conversion
+++ a/include/asm-x86_64/pci.h
@@ -10,6 +10,8 @@ struct pci_sysdata {
 	void*		iommu;		/* IOMMU private data */
 };
 
+extern struct pci_bus *pci_scan_bus_with_sysdata(int busno);
+
 #ifdef CONFIG_CALGARY_IOMMU
 static inline void* pci_iommu(struct pci_bus *bus)
 {
_

Patches currently in -mm which might be from muli@il.ibm.com are

intel-iommu-dmar-detection-and-parsing-logic.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-clflush_cache_range-now-takes-size-param.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-avoid-memory-allocation-failures-in-dma-map-api-calls.patch
intel-iommu-intel-iommu-cmdline-option-forcedac.patch
intel-iommu-dmar-fault-handling-support.patch
intel-iommu-iommu-gfx-workaround.patch
intel-iommu-iommu-floppy-workaround.patch
