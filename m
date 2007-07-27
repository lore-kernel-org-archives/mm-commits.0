From: akpm@linux-foundation.org
Subject: + x86_64-use-core-id-bits-for-apicid_to_node-initialization.patch added to -mm tree
Date: Thu, 26 Jul 2007 23:37:34 -0700
Message-ID: <200707270637.l6R6bYae009770@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44323 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753846AbXG0Ghv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Jul 2007 02:37:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yhlu.kernel@gmail.com, ak@suse.de, clameter@sgi.com, lenb@kernel.org


The patch titled
     x86_64: use core id bits for apicid_to_node initialization
has been added to the -mm tree.  Its filename is
     x86_64-use-core-id-bits-for-apicid_to_node-initialization.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86_64: use core id bits for apicid_to_node initialization
From: "Yinghai Lu" <yhlu.kernel@gmail.com>

We shoud use core id bits instead of max cores, in case later with AMD
downcores Quad core Opteron.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/mm/k8topology.c |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff -puN arch/x86_64/mm/k8topology.c~x86_64-use-core-id-bits-for-apicid_to_node-initialization arch/x86_64/mm/k8topology.c
--- a/arch/x86_64/mm/k8topology.c~x86_64-use-core-id-bits-for-apicid_to_node-initialization
+++ a/arch/x86_64/mm/k8topology.c
@@ -44,12 +44,14 @@ int __init k8_scan_nodes(unsigned long s
 { 
 	unsigned long prevbase;
 	struct bootnode nodes[8];
-	int nodeid, i, j, nb;
+	int nodeid, i, nb;
 	unsigned char nodeids[8];
 	int found = 0;
 	u32 reg;
 	unsigned numnodes;
-	unsigned num_cores;
+	unsigned cores;
+	unsigned bits;
+	int j;
 
 	if (!early_pci_allowed())
 		return -1;
@@ -60,9 +62,6 @@ int __init k8_scan_nodes(unsigned long s
 
 	printk(KERN_INFO "Scanning NUMA topology in Northbridge %d\n", nb); 
 
-	num_cores = (cpuid_ecx(0x80000008) & 0xff) + 1;
-	printk(KERN_INFO "CPU has %d num_cores\n", num_cores);
-
 	reg = read_pci_config(0, nb, 0, 0x60); 
 	numnodes = ((reg >> 4) & 0xF) + 1;
 	if (numnodes <= 1)
@@ -168,11 +167,15 @@ int __init k8_scan_nodes(unsigned long s
 	} 
 	printk(KERN_INFO "Using node hash shift of %d\n", memnode_shift); 
 
+	/* use the coreid bits from early_identify_cpu */
+	bits = boot_cpu_data.x86_coreid_bits;
+	cores = (1<<bits);
+
 	for (i = 0; i < 8; i++) {
 		if (nodes[i].start != nodes[i].end) { 
 			nodeid = nodeids[i];
-			for (j = 0; j < num_cores; j++)
-				apicid_to_node[(nodeid * num_cores) + j] = i;
+			for (j = 0; j < cores; j++)
+				apicid_to_node[(nodeid << bits) + j] = i;
 			setup_node_bootmem(i, nodes[i].start, nodes[i].end); 
 		} 
 	}
_

Patches currently in -mm which might be from yhlu.kernel@gmail.com are

x86_64-get-mp_bus_to_node-as-early-v2.patch
x86_64-use-bus-conf-in-nb-conf-fun1-to-get-bus-range-on-node.patch
try-parent-numa_node-at-first-before-using-default-v2.patch
net-use-numa_node-in-net_devcice-dev-instead-of-parent.patch
dma-use-dev_to_node-to-get-node-for-device-in-dma_alloc_pages.patch
x86_64-store-core-id-bits-in-cpuinfo_x8.patch
x86_64-use-core-id-bits-for-apicid_to_node-initialization.patch
x86_64-remove-never-used-apic_mapped.patch
x86_64-get-boot_cpu_id-as-early-for-k8_scan_nodes.patch
