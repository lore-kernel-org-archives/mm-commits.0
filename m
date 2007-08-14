From: akpm@linux-foundation.org
Subject: - x86_64-use-core-id-bits-for-apicid_to_node-initialization.patch removed from -mm tree
Date: Tue, 14 Aug 2007 12:14:19 -0700
Message-ID: <200708141914.l7EJEJbF016605@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41797 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933688AbXHNTVM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Aug 2007 15:21:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yhlu.kernel@gmail.com, ak@suse.de, clameter@sgi.com, lenb@kernel.org, mm-commits@vger.kernel.org


The patch titled
     x86_64: use core id bits for apicid_to_node initialization
has been removed from the -mm tree.  Its filename was
     x86_64-use-core-id-bits-for-apicid_to_node-initialization.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 1 files changed, 10 insertions(+), 7 deletions(-)

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

x86_64-get-boot_cpu_id-as-early-for-k8_scan_nodes.patch
