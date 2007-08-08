From: akpm@linux-foundation.org
Subject: + x86_64-use-bus-conf-in-nb-conf-fun1-to-get-bus-range-on-node.patch added to -mm tree
Date: Tue, 07 Aug 2007 19:29:25 -0700
Message-ID: <200708080229.l782TPeG016680@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43250 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757124AbXHHCaO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Aug 2007 22:30:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Yinghai.Lu@Sun.COM, ak@suse.de, apw@shadowen.org, clameter@sgi.com, jeff@garzik.org, yinghai.lu@Sun.COM


The patch titled
     x86_64: use bus conf in NB conf fun1 to get bus range on node
has been added to the -mm tree.  Its filename is
     x86_64-use-bus-conf-in-nb-conf-fun1-to-get-bus-range-on-node.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86_64: use bus conf in NB conf fun1 to get bus range on node
From: Yinghai Lu <Yinghai.Lu@Sun.COM>

So we use the same code with Quad core cpu as old opteron.  this patch is
usful when acpi=off or _PXM is not there in DSDT

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Andy Whitcroft <apw@shadowen.org>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/pci/k8-bus.c |   88 ++++++++++++++++++++-----------------
 1 file changed, 48 insertions(+), 40 deletions(-)

diff -puN arch/x86_64/pci/k8-bus.c~x86_64-use-bus-conf-in-nb-conf-fun1-to-get-bus-range-on-node arch/x86_64/pci/k8-bus.c
--- a/arch/x86_64/pci/k8-bus.c~x86_64-use-bus-conf-in-nb-conf-fun1-to-get-bus-range-on-node
+++ a/arch/x86_64/pci/k8-bus.c
@@ -12,15 +12,18 @@
  * RED-PEN empty cpus get reported wrong
  */
 
-#define NODE_ID_REGISTER 0x60
-#define NODE_ID(dword) (dword & 0x07)
-#define LDT_BUS_NUMBER_REGISTER_0 0x94
-#define LDT_BUS_NUMBER_REGISTER_1 0xB4
-#define LDT_BUS_NUMBER_REGISTER_2 0xD4
-#define NR_LDT_BUS_NUMBER_REGISTERS 3
-#define SECONDARY_LDT_BUS_NUMBER(dword) ((dword >> 8) & 0xFF)
-#define SUBORDINATE_LDT_BUS_NUMBER(dword) ((dword >> 16) & 0xFF)
+#define NODE_ID(dword) ((dword>>4) & 0x07)
+#define LDT_BUS_NUMBER_REGISTER_0 0xE0
+#define LDT_BUS_NUMBER_REGISTER_1 0xE4
+#define LDT_BUS_NUMBER_REGISTER_2 0xE8
+#define LDT_BUS_NUMBER_REGISTER_3 0xEC
+#define NR_LDT_BUS_NUMBER_REGISTERS 4
+#define SECONDARY_LDT_BUS_NUMBER(dword) ((dword >> 16) & 0xFF)
+#define SUBORDINATE_LDT_BUS_NUMBER(dword) ((dword >> 24) & 0xFF)
+
 #define PCI_DEVICE_ID_K8HTCONFIG 0x1100
+#define PCI_DEVICE_ID_K8_10H_HTCONFIG 0x1200
+#define PCI_DEVICE_ID_K8_11H_HTCONFIG 0x1300
 
 #define BUS_NR 256
 
@@ -60,12 +63,19 @@ early_fill_mp_bus_to_node(void)
 {
 	int i, j;
 	unsigned slot;
-	u32 ldtbus, nid;
+	u32 ldtbus;
 	u32 id;
-	static int lbnr[3] = {
+	int node;
+	u16 deviceid;
+	u16 vendorid;
+	int min_bus;
+	int max_bus;
+
+	static int lbnr[NR_LDT_BUS_NUMBER_REGISTERS] = {
 		LDT_BUS_NUMBER_REGISTER_0,
 		LDT_BUS_NUMBER_REGISTER_1,
-		LDT_BUS_NUMBER_REGISTER_2
+		LDT_BUS_NUMBER_REGISTER_2,
+		LDT_BUS_NUMBER_REGISTER_3
 	};
 
 	memset(mp_bus_to_node, 0, BUS_NR);
@@ -73,38 +83,36 @@ early_fill_mp_bus_to_node(void)
 	if (!early_pci_allowed())
 		return -1;
 
-	for (slot = 0x18; slot < 0x20; slot++) {
-		id = read_pci_config(0, slot, 0, PCI_VENDOR_ID);
-		if (id != (PCI_VENDOR_ID_AMD | (PCI_DEVICE_ID_K8HTCONFIG<<16)))
-			break;
-		nid = read_pci_config(0, slot, 0, NODE_ID_REGISTER);
-
-		for (i = 0; i < NR_LDT_BUS_NUMBER_REGISTERS; i++) {
-			ldtbus = read_pci_config(0, slot, 0, lbnr[i]);
-			/*
-			 * if there are no busses hanging off of the current
-			 * ldt link then both the secondary and subordinate
-			 * bus number fields are set to 0.
-			 *
-			 * RED-PEN
-			 * This is slightly broken because it assumes
-			 * HT node IDs == Linux node ids, which is not always
-			 * true. However it is probably mostly true.
-			 */
-			if (!(SECONDARY_LDT_BUS_NUMBER(ldtbus) == 0
-				&& SUBORDINATE_LDT_BUS_NUMBER(ldtbus) == 0)) {
-				for (j = SECONDARY_LDT_BUS_NUMBER(ldtbus);
-				     j <= SUBORDINATE_LDT_BUS_NUMBER(ldtbus);
-				     j++) {
-					int node = NODE_ID(nid);
-					mp_bus_to_node[j] = (unsigned char)node;
-				}
-			}
-		}
+	slot = 0x18;
+	id = read_pci_config(0, slot, 0, PCI_VENDOR_ID);
+
+	vendorid = id & 0xffff;
+	if (vendorid != PCI_VENDOR_ID_AMD)
+		goto out;
+
+	deviceid = (id>>16) & 0xffff;
+	if ((deviceid != PCI_DEVICE_ID_K8HTCONFIG) &&
+	    (deviceid != PCI_DEVICE_ID_K8_10H_HTCONFIG) &&
+	    (deviceid != PCI_DEVICE_ID_K8_11H_HTCONFIG))
+		goto out;
+
+	for (i = 0; i < NR_LDT_BUS_NUMBER_REGISTERS; i++) {
+		ldtbus = read_pci_config(0, slot, 1, lbnr[i]);
+
+		/* Check if that register is enabled for bus range */
+		if ((ldtbus & 7) != 3)
+			continue;
+
+		min_bus = SECONDARY_LDT_BUS_NUMBER(ldtbus);
+		max_bus = SUBORDINATE_LDT_BUS_NUMBER(ldtbus);
+		node = NODE_ID(ldtbus);
+		for (j = min_bus; j <= max_bus; j++)
+			mp_bus_to_node[j] = (unsigned char) node;
 	}
 
+out:
 	for (i = 0; i < BUS_NR; i++) {
-		int node = mp_bus_to_node[i];
+		node = mp_bus_to_node[i];
 		if (node)
 			printk(KERN_DEBUG "bus: %02x to node: %02x\n", i, node);
 	}
_

Patches currently in -mm which might be from Yinghai.Lu@Sun.COM are

x86_64-remove-sync_arb_ids.patch
x86_64-clear-io_apic-before-enabing-apic-error-vector.patch
x86_64-get-mp_bus_to_node-as-early-v3.patch
x86_64-use-bus-conf-in-nb-conf-fun1-to-get-bus-range-on-node.patch
try-parent-numa_node-at-first-before-using-default.patch
net-use-numa_node-in-net_devcice-dev-instead-of-parent.patch
dma-use-dev_to_node-to-get-node-for-device-in-dma_alloc_pages.patch
