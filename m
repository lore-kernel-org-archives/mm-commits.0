From: akpm@linux-foundation.org
Subject: - x86_64-get-mp_bus_to_node-as-early-v2.patch removed from -mm tree
Date: Tue, 07 Aug 2007 15:45:31 -0700
Message-ID: <200708072245.l77MjVxU008742@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46882 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759598AbXHGWqy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Aug 2007 18:46:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yhlu.kernel@gmail.com, ak@suse.de, apw@shadowen.org, clameter@sgi.com, greg@kroah.com, muli@il.ibm.com, yinghai.lu@sun.com, mm-commits@vger.kernel.org


The patch titled
     x86_64: get mp_bus_to_node as early
has been removed from the -mm tree.  Its filename was
     x86_64-get-mp_bus_to_node-as-early-v2.patch

This patch was dropped because finish-i386-and-x86-64-sysdata-conversion.patch destroyed it

------------------------------------------------------
Subject: x86_64: get mp_bus_to_node as early
From: "Yinghai Lu" <yhlu.kernel@gmail.com>

In struct device, we already have numa_node member.  and we can use
dev_to_node() /set_dev_node() to get and set numa_node in the device. 
set_dev_node is called in pci_device_add() with pcibus_to_node(bus).  and
pci_bus_to_node use bus->sysdata for nodeid.  the problem is when
pci_add_device is called, bus->sysdata is not assigned correct nodeid yet. 
the result will be numa_node always is 0.  pcibios_scan_root and pci_scan_root
could take sysdata.  So we need to get mp_bus_to_node mapping before these two
are called.  and get_mp_bus_to_node could get correct node for sysdata in root
bus.  in scanning of root bus, all child bus will take parent bus sysdata.  So
all pci_device->dev.numa_node will be assigned correctly automatically.  later
we could use dev_to_node(&pci_dev->dev) to numa_node, and we could also could
make other bus specific device get the correct numa_node too.  and in
different driver we could use kmalloc_node instead of kmalloc for skbuff/net
or urb/usb etc.  That could help improve performance with usb or net or sata
for AMD K8 two sockets beyond system.

For example:

two way opteron system and only one HT chain on node 0.  USB controller on SB
will be on node0.  some dma accessing is used with kmalloc/dma_map_single. 
and these address will be on node1 instead of node0.  and even worse, when
node1 ram is above 4G, we may need to iommu mapping for usb operation.  two
way system with one HT chain on different node, we will need to
kmalloc/dma_map_single to use ram on corresonding node too.  esp for nvidia
mcp55/io55 system.  the second io55 could have nic/sata/pcie devices.

this is one update version to pci_sysdata ...  also reverse pci_acpi_scan_root
to use pcibios_scan_root again.

without this patch: /sys/devices/pci0000:80/*/numa_node for HT chains other
than on node0 always 0.

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Andy Whitcroft <apw@shadowen.org>
Cc: Greg KH <greg@kroah.com>
Cc: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/pci/Makefile         |    1 
 arch/i386/pci/acpi.c           |   40 ++++----------
 arch/i386/pci/common.c         |    7 ++
 arch/i386/pci/irq.c            |   18 ++++++
 arch/i386/pci/legacy.c         |   22 +++++++-
 arch/i386/pci/mp_bus_to_node.c |   23 ++++++++
 arch/x86_64/pci/k8-bus.c       |   83 +++++++++++++++++++++----------
 include/asm-i386/topology.h    |   10 +++
 include/asm-x86_64/topology.h  |   13 ++++
 9 files changed, 159 insertions(+), 58 deletions(-)

diff -puN arch/i386/pci/Makefile~x86_64-get-mp_bus_to_node-as-early-v2 arch/i386/pci/Makefile
--- a/arch/i386/pci/Makefile~x86_64-get-mp_bus_to_node-as-early-v2
+++ a/arch/i386/pci/Makefile
@@ -10,5 +10,6 @@ pci-y				+= legacy.o irq.o
 
 pci-$(CONFIG_X86_VISWS)		:= visws.o fixup.o
 pci-$(CONFIG_X86_NUMAQ)		:= numa.o irq.o
+pci-$(CONFIG_NUMA)		+= mp_bus_to_node.o
 
 obj-y				+= $(pci-y) common.o early.o
diff -puN arch/i386/pci/acpi.c~x86_64-get-mp_bus_to_node-as-early-v2 arch/i386/pci/acpi.c
--- a/arch/i386/pci/acpi.c~x86_64-get-mp_bus_to_node-as-early-v2
+++ a/arch/i386/pci/acpi.c
@@ -8,46 +8,28 @@
 struct pci_bus * __devinit pci_acpi_scan_root(struct acpi_device *device, int domain, int busnum)
 {
 	struct pci_bus *bus;
-	struct pci_sysdata *sd;
+#ifdef CONFIG_ACPI_NUMA
 	int pxm;
-
-	/* Allocate per-root-bus (not per bus) arch-specific data.
-	 * TODO: leak; this memory is never freed.
-	 * It's arguable whether it's worth the trouble to care.
-	 */
-	sd = kzalloc(sizeof(*sd), GFP_KERNEL);
-	if (!sd) {
-		printk(KERN_ERR "PCI: OOM, not probing PCI bus %02x\n", busnum);
-		return NULL;
-	}
+	int node;
+#endif
 
 	if (domain != 0) {
 		printk(KERN_WARNING "PCI: Multiple domains not supported\n");
-		kfree(sd);
 		return NULL;
 	}
 
-	sd->node = -1;
-
-	pxm = acpi_get_pxm(device->handle);
 #ifdef CONFIG_ACPI_NUMA
-	if (pxm >= 0)
-		sd->node = pxm_to_node(pxm);
+	pxm = acpi_get_pxm(device->handle);
+	if (pxm >= 0) {
+		node = pxm_to_node(pxm);
+		printk(KERN_INFO "bus %02x -> pxm %d -> node %02x\n",
+			busnum, pxm, node);
+		set_mp_bus_to_node(busnum, node);
+	}
 #endif
 
-	bus = pci_scan_bus_parented(NULL, busnum, &pci_root_ops, sd);
-	if (!bus)
-		kfree(sd);
+	bus = pcibios_scan_root(busnum);
 
-#ifdef CONFIG_ACPI_NUMA
-	if (bus != NULL) {
-		if (pxm >= 0) {
-			printk("bus %d -> pxm %d -> node %d\n",
-				busnum, pxm, sd->node);
-		}
-	}
-#endif
-	
 	return bus;
 }
 
diff -puN arch/i386/pci/common.c~x86_64-get-mp_bus_to_node-as-early-v2 arch/i386/pci/common.c
--- a/arch/i386/pci/common.c~x86_64-get-mp_bus_to_node-as-early-v2
+++ a/arch/i386/pci/common.c
@@ -314,9 +314,14 @@ struct pci_bus * __devinit pcibios_scan_
 		return NULL;
 	}
 
+	sd->node = get_mp_bus_to_node(busnum);
+
 	printk(KERN_DEBUG "PCI: Probing PCI hardware (bus %02x)\n", busnum);
+	bus = pci_scan_bus_parented(NULL, busnum, &pci_root_ops, sd);
+	if (!bus)
+		kfree(sd);
 
-	return pci_scan_bus_parented(NULL, busnum, &pci_root_ops, sd);
+	return bus;
 }
 
 extern u8 pci_cache_line_size;
diff -puN arch/i386/pci/irq.c~x86_64-get-mp_bus_to_node-as-early-v2 arch/i386/pci/irq.c
--- a/arch/i386/pci/irq.c~x86_64-get-mp_bus_to_node-as-early-v2
+++ a/arch/i386/pci/irq.c
@@ -136,10 +136,26 @@ static void __init pirq_peer_trick(void)
 		busmap[e->bus] = 1;
 	}
 	for(i = 1; i < 256; i++) {
+		struct pci_bus *bus = NULL;
+		struct pci_sysdata *sd;
 		if (!busmap[i] || pci_find_bus(0, i))
 			continue;
-		if (pci_scan_bus(i, &pci_root_ops, NULL))
+		/* Allocate per-root-bus (not per bus) arch-specific data.
+		 * TODO: leak; this memory is never freed.
+		 * It's arguable whether it's worth the trouble to care.
+		 */
+		sd = kzalloc(sizeof(*sd), GFP_KERNEL);
+		if (!sd) {
+			printk(KERN_ERR "PCI: OOM, not probing PCI bus %02x\n",
+				i);
+			continue;
+		}
+		sd->node = get_mp_bus_to_node(i);
+		bus = pci_scan_bus(i, &pci_root_ops, sd);
+		if (bus)
 			printk(KERN_INFO "PCI: Discovered primary peer bus %02x [IRQ]\n", i);
+		else
+			kfree(sd);
 	}
 	pcibios_last_bus = -1;
 }
diff -puN arch/i386/pci/legacy.c~x86_64-get-mp_bus_to_node-as-early-v2 arch/i386/pci/legacy.c
--- a/arch/i386/pci/legacy.c~x86_64-get-mp_bus_to_node-as-early-v2
+++ a/arch/i386/pci/legacy.c
@@ -12,6 +12,9 @@
 static void __devinit pcibios_fixup_peer_bridges(void)
 {
 	int n, devfn;
+	struct pci_bus *bus = NULL;
+	struct pci_sysdata *sd;
+	long node;
 
 	if (pcibios_last_bus <= 0 || pcibios_last_bus >= 0xff)
 		return;
@@ -21,12 +24,29 @@ static void __devinit pcibios_fixup_peer
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
+				/* Allocate per-root-bus (not per bus)
+				 * arch-specific data.
+				 * TODO: leak; this memory is never freed.
+				 * It's arguable whether it's worth the trouble
+				 * to care.
+				 */
+				sd = kzalloc(sizeof(*sd), GFP_KERNEL);
+				if (!sd) {
+					printk(KERN_ERR
+					"PCI: OOM, not probing PCI bus %02x\n",
+						 n);
+					break;
+				}
+				sd->node = node;
+				bus = pci_scan_bus(n, &pci_root_ops, sd);
+				if (!bus)
+					kfree(sd);
 				break;
 			}
 		}
diff -puN /dev/null arch/i386/pci/mp_bus_to_node.c
--- /dev/null
+++ a/arch/i386/pci/mp_bus_to_node.c
@@ -0,0 +1,23 @@
+#include <linux/pci.h>
+#include <linux/init.h>
+#include <linux/topology.h>
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
diff -puN arch/x86_64/pci/k8-bus.c~x86_64-get-mp_bus_to_node-as-early-v2 arch/x86_64/pci/k8-bus.c
--- a/arch/x86_64/pci/k8-bus.c~x86_64-get-mp_bus_to_node-as-early-v2
+++ a/arch/x86_64/pci/k8-bus.c
@@ -1,7 +1,9 @@
 #include <linux/init.h>
 #include <linux/pci.h>
+#include <asm/pci-direct.h>
 #include <asm/mpspec.h>
 #include <linux/cpumask.h>
+#include <linux/topology.h>
 
 /*
  * This discovers the pcibus <-> node mapping on AMD K8.
@@ -20,64 +22,93 @@
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
-					struct pci_sysdata *sd;
-
-					long node = NODE_ID(nid);
-					/* Algorithm a bit dumb, but
- 					   it shouldn't matter here */
-					bus = pci_find_bus(0, j);
-					if (!bus)
-						continue;
-					if (!node_online(node))
-						node = 0;
-
-					sd = bus->sysdata;
-					sd->node = node;
-				}		
+				     j++) {
+					int node = NODE_ID(nid);
+					mp_bus_to_node[j] = (unsigned char)node;
+				}
 			}
 		}
 	}
 
+	for (i = 0; i < BUS_NR; i++) {
+		int node = mp_bus_to_node[i];
+		if (node)
+			printk(KERN_DEBUG "bus: %02x to node: %02x\n", i, node);
+	}
 	return 0;
 }
 
-fs_initcall(fill_mp_bus_to_cpumask);
+postcore_initcall(early_fill_mp_bus_to_node);
diff -puN include/asm-i386/topology.h~x86_64-get-mp_bus_to_node-as-early-v2 include/asm-i386/topology.h
--- a/include/asm-i386/topology.h~x86_64-get-mp_bus_to_node-as-early-v2
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
diff -puN include/asm-x86_64/topology.h~x86_64-get-mp_bus_to_node-as-early-v2 include/asm-x86_64/topology.h
--- a/include/asm-x86_64/topology.h~x86_64-get-mp_bus_to_node-as-early-v2
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

Patches currently in -mm which might be from yhlu.kernel@gmail.com are

finish-i386-and-x86-64-sysdata-conversion.patch
x86_64-get-mp_bus_to_node-as-early-v2.patch
x86_64-use-bus-conf-in-nb-conf-fun1-to-get-bus-range-on-node.patch
try-parent-numa_node-at-first-before-using-default-v2.patch
net-use-numa_node-in-net_devcice-dev-instead-of-parent.patch
dma-use-dev_to_node-to-get-node-for-device-in-dma_alloc_pages.patch
x86_64-store-core-id-bits-in-cpuinfo_x8.patch
x86_64-use-core-id-bits-for-apicid_to_node-initialization.patch
x86_64-remove-never-used-apic_mapped.patch
x86_64-get-boot_cpu_id-as-early-for-k8_scan_nodes.patch
