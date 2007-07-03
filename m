From: akpm@linux-foundation.org
Subject: + x86_64-get-mp_bus_to_node-as-early.patch added to -mm tree
Date: Tue, 03 Jul 2007 11:35:50 -0700
Message-ID: <200707031835.l63IZo9K008197@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43177 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755542AbXGCSgp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Jul 2007 14:36:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Yinghai.Lu@Sun.COM, ak@suse.de, clameter@sgi.com, rientjes@google.com, yinghai.lu@Sun.COM


The patch titled
     x86_64: get mp_bus_to_node as early
has been added to the -mm tree.  Its filename is
     x86_64-get-mp_bus_to_node-as-early.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86_64: get mp_bus_to_node as early
From: Yinghai Lu <Yinghai.Lu@Sun.COM>

In struct device, we already have numa_node member.  and we can use
dev_to_node() /set_dev_node() to get and set numa_node in the device. 
set_dev_node is called in pci_device_add() with pcibus_to_node(bus).  and
pci_bus_to_node use bus->sysdata for nodeid.

The problem is when pci_add_device is called, bus->sysdata is not assigned
correct nodeid yet.  the result will be numa_node always is 0. 
pcibios_scan_root and pci_scan_root could take sysdata.  So we need to get
mp_bus_to_node mapping before these two are called.  and get_mp_bus_to_node
could get correct node for sysdata in root bus.

In scanning of root bus, all child bus will take parent bus sysdata.  So
all pci_device->dev.numa_node will be assigned correctly automatically. 
later we could use dev_to_node(&pci_dev->dev) to numa_node, and we could
also could make other bus specific device get the correct numa_node too. 
and in different driver we could use kmalloc_node instead of kmalloc for
skbuff/net or urb/usb etc.  That could help improve performance with usb or
net or sata for AMD K8 two sockets beyond system.

For example:

Two way opteron system and only one HT chain on node 0.  USB controller on
SB will be on node0.  some dma accessing is used with
kmalloc/dma_map_single.  and these address will be on node1 instead of
node0.  and even worse, when node1 ram is above 4G, we may need to iommu
mapping for usb operation.  two way system with one HT chain on different
node, we will need to kmalloc/dma_map_single to use ram on corresonding
node too.  esp for nvidia mcp55/io55 system.  the second io55 could have
nic/sata/pcie devices.

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/pci/Makefile         |    1 
 arch/i386/pci/acpi.c           |   21 ++++----
 arch/i386/pci/common.c         |    9 +++
 arch/i386/pci/irq.c            |    4 +
 arch/i386/pci/legacy.c         |    4 +
 arch/i386/pci/mp_bus_to_node.c |   23 +++++++++
 arch/x86_64/pci/k8-bus.c       |   79 ++++++++++++++++++++++---------
 include/asm-i386/topology.h    |   10 +++
 include/asm-x86_64/topology.h  |   13 +++++
 9 files changed, 130 insertions(+), 34 deletions(-)

diff -puN arch/i386/pci/Makefile~x86_64-get-mp_bus_to_node-as-early arch/i386/pci/Makefile
--- a/arch/i386/pci/Makefile~x86_64-get-mp_bus_to_node-as-early
+++ a/arch/i386/pci/Makefile
@@ -10,5 +10,6 @@ pci-y				+= legacy.o irq.o
 
 pci-$(CONFIG_X86_VISWS)		:= visws.o fixup.o
 pci-$(CONFIG_X86_NUMAQ)		:= numa.o irq.o
+pci-$(CONFIG_NUMA)		+= mp_bus_to_node.o
 
 obj-y				+= $(pci-y) common.o early.o
diff -puN arch/i386/pci/acpi.c~x86_64-get-mp_bus_to_node-as-early arch/i386/pci/acpi.c
--- a/arch/i386/pci/acpi.c~x86_64-get-mp_bus_to_node-as-early
+++ a/arch/i386/pci/acpi.c
@@ -8,24 +8,27 @@
 struct pci_bus * __devinit pci_acpi_scan_root(struct acpi_device *device, int domain, int busnum)
 {
 	struct pci_bus *bus;
+#ifdef CONFIG_ACPI_NUMA
+	int pxm;
+	int node;
+#endif
 
 	if (domain != 0) {
 		printk(KERN_WARNING "PCI: Multiple domains not supported\n");
 		return NULL;
 	}
 
-	bus = pcibios_scan_root(busnum);
 #ifdef CONFIG_ACPI_NUMA
-	if (bus != NULL) {
-		int pxm = acpi_get_pxm(device->handle);
-		if (pxm >= 0) {
-			bus->sysdata = (void *)(unsigned long)pxm_to_node(pxm);
-			printk("bus %d -> pxm %d -> node %ld\n",
-				busnum, pxm, (long)(bus->sysdata));
-		}
+	pxm = acpi_get_pxm(device->handle);
+	if (pxm >= 0) {
+		node  = pxm_to_node(pxm);
+		printk("bus %02x -> pxm %d -> node %02x\n", busnum, pxm, node);
+		set_mp_bus_to_node(busnum, node);
 	}
 #endif
-	
+
+	bus = pcibios_scan_root(busnum);
+
 	return bus;
 }
 
diff -puN arch/i386/pci/common.c~x86_64-get-mp_bus_to_node-as-early arch/i386/pci/common.c
--- a/arch/i386/pci/common.c~x86_64-get-mp_bus_to_node-as-early
+++ a/arch/i386/pci/common.c
@@ -293,6 +293,7 @@ static struct dmi_system_id __devinitdat
 struct pci_bus * __devinit pcibios_scan_root(int busnum)
 {
 	struct pci_bus *bus = NULL;
+	long node;
 
 	dmi_check_system(pciprobe_dmi_table);
 
@@ -303,9 +304,15 @@ struct pci_bus * __devinit pcibios_scan_
 		}
 	}
 
+	node = get_mp_bus_to_node(busnum);
+
+#ifdef CONFIG_NUMA
+	printk(KERN_DEBUG "PCI: Probing PCI hardware (bus %02x) with (node %02lx)\n", busnum, node);
+#else
 	printk(KERN_DEBUG "PCI: Probing PCI hardware (bus %02x)\n", busnum);
+#endif
 
-	return pci_scan_bus_parented(NULL, busnum, &pci_root_ops, NULL);
+	return pci_scan_bus_parented(NULL, busnum, &pci_root_ops, (void *)node);
 }
 
 extern u8 pci_cache_line_size;
diff -puN arch/i386/pci/irq.c~x86_64-get-mp_bus_to_node-as-early arch/i386/pci/irq.c
--- a/arch/i386/pci/irq.c~x86_64-get-mp_bus_to_node-as-early
+++ a/arch/i386/pci/irq.c
@@ -136,9 +136,11 @@ static void __init pirq_peer_trick(void)
 		busmap[e->bus] = 1;
 	}
 	for(i = 1; i < 256; i++) {
+		long node;
 		if (!busmap[i] || pci_find_bus(0, i))
 			continue;
-		if (pci_scan_bus(i, &pci_root_ops, NULL))
+		node = get_mp_bus_to_node(i);
+		if (pci_scan_bus(i, &pci_root_ops, (void *)node))
 			printk(KERN_INFO "PCI: Discovered primary peer bus %02x [IRQ]\n", i);
 	}
 	pcibios_last_bus = -1;
diff -puN arch/i386/pci/legacy.c~x86_64-get-mp_bus_to_node-as-early arch/i386/pci/legacy.c
--- a/arch/i386/pci/legacy.c~x86_64-get-mp_bus_to_node-as-early
+++ a/arch/i386/pci/legacy.c
@@ -12,6 +12,7 @@
 static void __devinit pcibios_fixup_peer_bridges(void)
 {
 	int n, devfn;
+	long node;
 
 	if (pcibios_last_bus <= 0 || pcibios_last_bus >= 0xff)
 		return;
@@ -21,12 +22,13 @@ static void __devinit pcibios_fixup_peer
 		u32 l;
 		if (pci_find_bus(0, n))
 			continue;
+		node = get_mp_bus_to_node(n);
 		for (devfn = 0; devfn < 256; devfn += 8) {
 			if (!raw_pci_ops->read(0, n, devfn, PCI_VENDOR_ID, 2, &l) &&
 			    l != 0x0000 && l != 0xffff) {
 				DBG("Found device at %02x:%02x [%04x]\n", n, devfn, l);
 				printk(KERN_INFO "PCI: Discovered peer bus %02x\n", n);
-				pci_scan_bus(n, &pci_root_ops, NULL);
+				pci_scan_bus(n, &pci_root_ops, (void *)node);
 				break;
 			}
 		}
diff -puN /dev/null arch/i386/pci/mp_bus_to_node.c
--- /dev/null
+++ a/arch/i386/pci/mp_bus_to_node.c
@@ -0,0 +1,23 @@
+#include <linux/pci.h>
+#include <linux/init.h>
+#include <asm/topology.h>
+
+#define BUS_NR 256
+
+static unsigned char mp_bus_to_node[BUS_NR];
+
+void set_mp_bus_to_node(int busnum, int node)
+{
+	if (busnum >= 0 &&  busnum < BUS_NR)
+	mp_bus_to_node[busnum] = (unsigned char) node;
+}
+
+int get_mp_bus_to_node(int busnum)
+{
+	int node;
+
+	if (busnum < 0 || busnum > (BUS_NR - 1) )
+		return 0;
+	node = mp_bus_to_node[busnum];
+	return node;
+}
diff -puN arch/x86_64/pci/k8-bus.c~x86_64-get-mp_bus_to_node-as-early arch/x86_64/pci/k8-bus.c
--- a/arch/x86_64/pci/k8-bus.c~x86_64-get-mp_bus_to_node-as-early
+++ a/arch/x86_64/pci/k8-bus.c
@@ -1,7 +1,9 @@
 #include <linux/init.h>
 #include <linux/pci.h>
+#include <asm/pci-direct.h>
 #include <asm/mpspec.h>
 #include <linux/cpumask.h>
+#include <asm/topology.h>
 
 /*
  * This discovers the pcibus <-> node mapping on AMD K8.
@@ -20,60 +22,93 @@
 #define SUBORDINATE_LDT_BUS_NUMBER(dword) ((dword >> 16) & 0xFF)
 #define PCI_DEVICE_ID_K8HTCONFIG 0x1100
 
+#define BUS_NR 256
+
+static unsigned char mp_bus_to_node[BUS_NR];
+
+void set_mp_bus_to_node(int busnum, int node)
+{
+	if (busnum >= 0 &&  busnum < BUS_NR)
+		mp_bus_to_node[busnum] = (unsigned char) node;
+}
+
+int get_mp_bus_to_node(int busnum)
+{
+	int node;
+
+	if (busnum < 0 || busnum > (BUS_NR - 1) )
+		return 0;
+
+	node = mp_bus_to_node[busnum];
+
+	/* Algorithm a bit dumb, but it shouldn't matter here.
+	   even there is no ram installed for node0*/
+	if (!node_online(node))
+		node = 0;
+
+	return node;
+}
+
 /**
- * fill_mp_bus_to_cpumask()
+ * early_fill_mp_bus_to_node()
+ * called before pcibios_scan_root and pci_scan_bus
  * fills the mp_bus_to_cpumask array based according to the LDT Bus Number
  * Registers found in the K8 northbridge
  */
 __init static int
-fill_mp_bus_to_cpumask(void)
+early_fill_mp_bus_to_node(void)
 {
-	struct pci_dev *nb_dev = NULL;
 	int i, j;
+	unsigned slot;
 	u32 ldtbus, nid;
+	u32 id;
 	static int lbnr[3] = {
 		LDT_BUS_NUMBER_REGISTER_0,
 		LDT_BUS_NUMBER_REGISTER_1,
 		LDT_BUS_NUMBER_REGISTER_2
 	};
 
-	while ((nb_dev = pci_get_device(PCI_VENDOR_ID_AMD,
-			PCI_DEVICE_ID_K8HTCONFIG, nb_dev))) {
-		pci_read_config_dword(nb_dev, NODE_ID_REGISTER, &nid);
+	memset(mp_bus_to_node, 0, BUS_NR);
+
+	if (!early_pci_allowed())
+		return -1;
+
+	for (slot = 0x18; slot < 0x20; slot++) {
+		id = read_pci_config(0, slot, 0, PCI_VENDOR_ID);
+		if (id != (PCI_VENDOR_ID_AMD | (PCI_DEVICE_ID_K8HTCONFIG<<16)))
+			break;
+		nid = read_pci_config(0, slot, 0, NODE_ID_REGISTER);
 
 		for (i = 0; i < NR_LDT_BUS_NUMBER_REGISTERS; i++) {
-			pci_read_config_dword(nb_dev, lbnr[i], &ldtbus);
+			ldtbus = read_pci_config(0, slot, 0, lbnr[i]);
 			/*
 			 * if there are no busses hanging off of the current
 			 * ldt link then both the secondary and subordinate
 			 * bus number fields are set to 0.
-			 * 
+			 *
 			 * RED-PEN
 			 * This is slightly broken because it assumes
- 			 * HT node IDs == Linux node ids, which is not always
+			 * HT node IDs == Linux node ids, which is not always
 			 * true. However it is probably mostly true.
 			 */
 			if (!(SECONDARY_LDT_BUS_NUMBER(ldtbus) == 0
 				&& SUBORDINATE_LDT_BUS_NUMBER(ldtbus) == 0)) {
 				for (j = SECONDARY_LDT_BUS_NUMBER(ldtbus);
 				     j <= SUBORDINATE_LDT_BUS_NUMBER(ldtbus);
-				     j++) { 
-					struct pci_bus *bus;
-					long node = NODE_ID(nid);
-					/* Algorithm a bit dumb, but
- 					   it shouldn't matter here */
-					bus = pci_find_bus(0, j);
-					if (!bus)
-						continue;
-					if (!node_online(node))
-						node = 0;
-					bus->sysdata = (void *)node;
-				}		
+				     j++) {
+					int node = NODE_ID(nid);
+					mp_bus_to_node[j] = (unsigned char) node;
+				}
 			}
 		}
 	}
 
+	for (i=0; i<BUS_NR; i++) {
+		int node = mp_bus_to_node[i];
+		if (node)
+			printk(KERN_DEBUG "bus: %02x to node: %02x\n", i, node);
+	}
 	return 0;
 }
 
-fs_initcall(fill_mp_bus_to_cpumask);
+postcore_initcall(early_fill_mp_bus_to_node);
diff -puN include/asm-i386/topology.h~x86_64-get-mp_bus_to_node-as-early include/asm-i386/topology.h
--- a/include/asm-i386/topology.h~x86_64-get-mp_bus_to_node-as-early
+++ a/include/asm-i386/topology.h
@@ -101,7 +101,17 @@ extern unsigned long node_remap_size[];
 
 #define node_has_online_mem(nid) (node_start_pfn[nid] != node_end_pfn[nid])
 
+int get_mp_bus_to_node(int busnum);
+void set_mp_bus_to_node(int busnum, int node);
+
 #else /* !CONFIG_NUMA */
+static inline int get_mp_bus_to_node(int busnum)
+{
+	return 0;
+}
+static inline void set_mp_bus_to_node(int busnum, int node)
+{
+}
 /*
  * Other i386 platforms should define their own version of the 
  * above macros here.
diff -puN include/asm-x86_64/topology.h~x86_64-get-mp_bus_to_node-as-early include/asm-x86_64/topology.h
--- a/include/asm-x86_64/topology.h~x86_64-get-mp_bus_to_node-as-early
+++ a/include/asm-x86_64/topology.h
@@ -53,6 +53,19 @@ extern int __node_distance(int, int);
 	.nr_balance_failed	= 0,			\
 }
 
+int get_mp_bus_to_node(int busnum);
+void set_mp_bus_to_node(int busnum, int node);
+
+#else
+
+static inline int get_mp_bus_to_node(int busnum)
+{
+	return 0;
+}
+static inline void set_mp_bus_to_node(int busnum, int node)
+{
+}
+
 #endif
 
 #ifdef CONFIG_SMP
_

Patches currently in -mm which might be from Yinghai.Lu@Sun.COM are

serial-assert-dtr-for-serial-console-devices.patch
usb-make-the-usb_device-numa_node-to-get-assigned-from.patch
x86-64-disable-the-gart-in-shutdown.patch
x86_84-move-iommu-declaration-from-proto-to-iommuh.patch
x86_64-change-_map_single-to-static-in-pci_gartc-etc.patch
x86_64-geode-hw-random-number-generator-depend-on-x86_3.patch
x86_64-get-mp_bus_to_node-as-early.patch
console-more-buf-for-index-parsing.patch
console-console-handover-to-preferred-console.patch
serial-convert-early_uart-to-earlycon-for-8250.patch
serial-convert-early_uart-to-earlycon-for-8250-fix.patch
serial-convert-early_uart-to-earlycon-for-8250-ia64-fix.patch
serial-convert-early_uart-to-earlycon-for-8250-fix-3-alias.patch
