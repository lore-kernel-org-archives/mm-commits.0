From: akpm@linux-foundation.org
Subject: + pci-device-ensure-sysdata-initialised-v4.patch added to -mm tree
Date: Wed, 01 Aug 2007 16:33:29 -0700
Message-ID: <200708012333.l71NXUfq022947@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36546 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755250AbXHAXet (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2007 19:34:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: apw@shadowen.org, ak@suse.de, greg@kroah.com, jeff@garzik.org, yinghai.lu@sun.com


The patch titled
     pci device ensure sysdata initialised
has been added to the -mm tree.  Its filename is
     pci-device-ensure-sysdata-initialised-v4.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pci device ensure sysdata initialised
From: Andy Whitcroft <apw@shadowen.org>

We have been seeing panic's on NUMA systems in pci_call_probe() in
2.6.19-rc1-mm1 and later.  This is related to the changes introduced in the
commit below:

    [x86, PCI] Switch pci_bus::sysdata from NUMA node integer to a pointer
    0a247a58fc3e2ecfc17654301033e8b8d08df2a2

In this change the sysdata has changed from directly representing a value
(the node number in NUMA) to a pointer to a structure.  However, it seems
that we do not always initialise this sysdata before we probe the device.

Prior to the changes above the node was defaulted to 'NULL' allocating the
devices to node 0 unconditionally.  This patch adds a default sysdata entry
(pci_default_sysdata), this is then used where 'NULL' was used previously. 
pci_default_sysdata defaults the node to unknown (-1).  This is a more
accurate assignment, mirroring the value returned where no topology support
is provided and no locality information is available.

There are only two uses of this value in the affected architectures
(x86, x86_64) and generic code:

1) in x86_64, dma_alloc_pages() looks up the node in order to
   allocate node local memory.  Here if the node is invalid we
   will default to the first online node.  Behaviour here should
   be unchanged.
2) in generic, pci_call_probe() looks up the node in order to
   restrict execution of the probe on the card local node, to
   favor node local allocation.  Where this is unknown previously
   we would force execution (and thereby allocation) to node 0,
   this is arguably wrong and using -1 releases this restriction.

In an ideal world we should be supplying a sysdata for the
appropriate node where it is known.  Where it is not known defaulting
to -1 seems a better course, and would help us where node 0 is
short of memory.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Acked-by: Yinghai Lu <yinghai.lu@sun.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/pci/common.c   |    2 ++
 arch/i386/pci/fixup.c    |    8 +++++---
 arch/i386/pci/numa.c     |    8 +++++---
 arch/i386/pci/visws.c    |    4 ++--
 include/asm-i386/pci.h   |    1 +
 include/asm-x86_64/pci.h |    1 +
 6 files changed, 16 insertions(+), 8 deletions(-)

diff -puN arch/i386/pci/common.c~pci-device-ensure-sysdata-initialised-v4 arch/i386/pci/common.c
--- a/arch/i386/pci/common.c~pci-device-ensure-sysdata-initialised-v4
+++ a/arch/i386/pci/common.c
@@ -27,6 +27,8 @@ unsigned long pirq_table_addr;
 struct pci_bus *pci_root_bus;
 struct pci_raw_ops *raw_pci_ops;
 
+struct pci_sysdata pci_default_sysdata = { .node = -1 };
+
 static int pci_read(struct pci_bus *bus, unsigned int devfn, int where, int size, u32 *value)
 {
 	return raw_pci_ops->read(0, bus->number, devfn, where, size, value);
diff -puN arch/i386/pci/fixup.c~pci-device-ensure-sysdata-initialised-v4 arch/i386/pci/fixup.c
--- a/arch/i386/pci/fixup.c~pci-device-ensure-sysdata-initialised-v4
+++ a/arch/i386/pci/fixup.c
@@ -25,9 +25,11 @@ static void __devinit pci_fixup_i450nx(s
 		pci_read_config_byte(d, reg++, &subb);
 		DBG("i450NX PXB %d: %02x/%02x/%02x\n", pxb, busno, suba, subb);
 		if (busno)
-			pci_scan_bus(busno, &pci_root_ops, NULL);	/* Bus A */
+			pci_scan_bus(busno, &pci_root_ops,
+					&pci_default_sysdata);	/* Bus A */
 		if (suba < subb)
-			pci_scan_bus(suba+1, &pci_root_ops, NULL);	/* Bus B */
+			pci_scan_bus(suba+1, &pci_root_ops,
+					&pci_default_sysdata);	/* Bus B */
 	}
 	pcibios_last_bus = -1;
 }
@@ -42,7 +44,7 @@ static void __devinit pci_fixup_i450gx(s
 	u8 busno;
 	pci_read_config_byte(d, 0x4a, &busno);
 	printk(KERN_INFO "PCI: i440KX/GX host bridge %s: secondary bus %02x\n", pci_name(d), busno);
-	pci_scan_bus(busno, &pci_root_ops, NULL);
+	pci_scan_bus(busno, &pci_root_ops, &pci_default_sysdata);
 	pcibios_last_bus = -1;
 }
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82454GX, pci_fixup_i450gx);
diff -puN arch/i386/pci/numa.c~pci-device-ensure-sysdata-initialised-v4 arch/i386/pci/numa.c
--- a/arch/i386/pci/numa.c~pci-device-ensure-sysdata-initialised-v4
+++ a/arch/i386/pci/numa.c
@@ -97,9 +97,11 @@ static void __devinit pci_fixup_i450nx(s
 		pci_read_config_byte(d, reg++, &subb);
 		DBG("i450NX PXB %d: %02x/%02x/%02x\n", pxb, busno, suba, subb);
 		if (busno)
-			pci_scan_bus(QUADLOCAL2BUS(quad,busno), &pci_root_ops, NULL);	/* Bus A */
+			pci_scan_bus(QUADLOCAL2BUS(quad,busno), &pci_root_ops,
+					&pci_default_sysdata);	/* Bus A */
 		if (suba < subb)
-			pci_scan_bus(QUADLOCAL2BUS(quad,suba+1), &pci_root_ops, NULL);	/* Bus B */
+			pci_scan_bus(QUADLOCAL2BUS(quad,suba+1), &pci_root_ops,
+					&pci_default_sysdata);	/* Bus B */
 	}
 	pcibios_last_bus = -1;
 }
@@ -124,7 +126,7 @@ static int __init pci_numa_init(void)
 			printk("Scanning PCI bus %d for quad %d\n", 
 				QUADLOCAL2BUS(quad,0), quad);
 			pci_scan_bus(QUADLOCAL2BUS(quad,0), 
-				&pci_root_ops, NULL);
+				&pci_root_ops, &pci_default_sysdata);
 		}
 	return 0;
 }
diff -puN arch/i386/pci/visws.c~pci-device-ensure-sysdata-initialised-v4 arch/i386/pci/visws.c
--- a/arch/i386/pci/visws.c~pci-device-ensure-sysdata-initialised-v4
+++ a/arch/i386/pci/visws.c
@@ -101,8 +101,8 @@ static int __init pcibios_init(void)
 		"bridge B (PIIX4) bus: %u\n", pci_bus1, pci_bus0);
 
 	raw_pci_ops = &pci_direct_conf1;
-	pci_scan_bus(pci_bus0, &pci_root_ops, NULL);
-	pci_scan_bus(pci_bus1, &pci_root_ops, NULL);
+	pci_scan_bus(pci_bus0, &pci_root_ops, &pci_default_sysdata);
+	pci_scan_bus(pci_bus1, &pci_root_ops, &pci_default_sysdata);
 	pci_fixup_irqs(visws_swizzle, visws_map_irq);
 	pcibios_resource_survey();
 	return 0;
diff -puN include/asm-i386/pci.h~pci-device-ensure-sysdata-initialised-v4 include/asm-i386/pci.h
--- a/include/asm-i386/pci.h~pci-device-ensure-sysdata-initialised-v4
+++ a/include/asm-i386/pci.h
@@ -7,6 +7,7 @@
 struct pci_sysdata {
 	int		node;		/* NUMA node */
 };
+extern struct pci_sysdata pci_default_sysdata;
 
 #include <linux/mm.h>		/* for struct page */
 
diff -puN include/asm-x86_64/pci.h~pci-device-ensure-sysdata-initialised-v4 include/asm-x86_64/pci.h
--- a/include/asm-x86_64/pci.h~pci-device-ensure-sysdata-initialised-v4
+++ a/include/asm-x86_64/pci.h
@@ -9,6 +9,7 @@ struct pci_sysdata {
 	int		node;		/* NUMA node */
 	void*		iommu;		/* IOMMU private data */
 };
+extern struct pci_sysdata pci_default_sysdata;
 
 #ifdef CONFIG_CALGARY_IOMMU
 static inline void* pci_iommu(struct pci_bus *bus)
_

Patches currently in -mm which might be from apw@shadowen.org are

origin.patch
x86_64-get-mp_bus_to_node-as-early-v2.patch
x86_64-use-bus-conf-in-nb-conf-fun1-to-get-bus-range-on-node.patch
try-parent-numa_node-at-first-before-using-default-v2.patch
net-use-numa_node-in-net_devcice-dev-instead-of-parent.patch
dma-use-dev_to_node-to-get-node-for-device-in-dma_alloc_pages.patch
pci-device-ensure-sysdata-initialised-v4.patch
sparsemem-ensure-we-initialise-the-node-mapping-for-sparsemem_static.patch
sparsemem-ensure-we-initialise-the-node-mapping-for-sparsemem_static-fix.patch
sparsemem-clean-up-spelling-error-in-comments.patch
sparsemem-record-when-a-section-has-a-valid-mem_map.patch
sparsemem-record-when-a-section-has-a-valid-mem_map-fix.patch
generic-virtual-memmap-support-for-sparsemem.patch
generic-virtual-memmap-support-for-sparsemem-fix.patch
x86_64-sparsemem_vmemmap-2m-page-size-support.patch
ia64-sparsemem_vmemmap-16k-page-size-support.patch
sparc64-sparsemem_vmemmap-support.patch
ppc64-sparsemem_vmemmap-support.patch
add-a-bitmap-that-is-used-to-track-flags-affecting-a-block-of-pages.patch
add-a-configure-option-to-group-pages-by-mobility.patch
move-free-pages-between-lists-on-steal.patch
group-short-lived-and-reclaimable-kernel-allocations.patch
do-not-group-pages-by-mobility-type-on-low-memory-systems.patch
fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2.patch
fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2-fix.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
remove-page_group_by_mobility.patch
dont-group-high-order-atomic-allocations.patch
fix-calculation-in-move_freepages_block-for-counting-pages.patch
breakout-page_order-to-internalh-to-avoid-special-knowledge-of-the-buddy-allocator.patch
do-not-depend-on-max_order-when-grouping-pages-by-mobility.patch
print-out-statistics-in-relation-to-fragmentation-avoidance-to-proc-pagetypeinfo.patch
have-kswapd-keep-a-minimum-order-free-other-than-order-0.patch
only-check-absolute-watermarks-for-alloc_high-and-alloc_harder-allocations.patch
rename-gfp_high_movable-to-gfp_highuser_movable-prefetch.patch
page-owner-tracking-leak-detector.patch
