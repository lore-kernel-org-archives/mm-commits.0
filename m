From: akpm@linux-foundation.org
Subject: - x86_64-numa-fake-apicid_to_node-mapping-for-fake-numa-2.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:08:30 -0700
Message-ID: <200707192008.l6JK8U66020465@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38593 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760900AbXGSUPa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:15:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     x86_64 numa: fake apicid_to_node mapping for fake numa
has been removed from the -mm tree.  Its filename was
     x86_64-numa-fake-apicid_to_node-mapping-for-fake-numa-2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86_64 numa: fake apicid_to_node mapping for fake numa
From: David Rientjes <rientjes@google.com>

When we are in the emulated NUMA case, we need to make sure that all existing
apicid_to_node mappings that point to real node ID's now point to the
equivalent fake node ID's.

If we simply iterate over all apicid_to_node[] members for each node, we risk
remapping an entry if it shares a node ID with a real node.  Since apicid's
may not be consecutive, we're forced to create an automatic array of
apicid_to_node mappings and then copy it over once we have finished remapping
fake to real nodes.

Cc: Andi Kleen <ak@suse.de>
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/mm/srat.c |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletion(-)

diff -puN arch/x86_64/mm/srat.c~x86_64-numa-fake-apicid_to_node-mapping-for-fake-numa-2 arch/x86_64/mm/srat.c
--- a/arch/x86_64/mm/srat.c~x86_64-numa-fake-apicid_to_node-mapping-for-fake-numa-2
+++ a/arch/x86_64/mm/srat.c
@@ -470,10 +470,13 @@ static int __init find_node_by_addr(unsi
  */
 void __init acpi_fake_nodes(const struct bootnode *fake_nodes, int num_nodes)
 {
-	int i;
+	int i, j;
 	int fake_node_to_pxm_map[MAX_NUMNODES] = {
 		[0 ... MAX_NUMNODES-1] = PXM_INVAL
 	};
+	unsigned char fake_apicid_to_node[MAX_LOCAL_APIC] = {
+		[0 ... MAX_LOCAL_APIC-1] = NUMA_NO_NODE
+	};
 
 	printk(KERN_INFO "Faking PXM affinity for fake nodes on real "
 			 "topology.\n");
@@ -487,9 +490,17 @@ void __init acpi_fake_nodes(const struct
 		if (pxm == PXM_INVAL)
 			continue;
 		fake_node_to_pxm_map[i] = pxm;
+		/*
+		 * For each apicid_to_node mapping that exists for this real
+		 * node, it must now point to the fake node ID.
+		 */
+		for (j = 0; j < MAX_LOCAL_APIC; j++)
+			if (apicid_to_node[j] == nid)
+				fake_apicid_to_node[j] = i;
 	}
 	for (i = 0; i < num_nodes; i++)
 		__acpi_map_pxm_to_node(fake_node_to_pxm_map[i], i);
+	memcpy(apicid_to_node, fake_apicid_to_node, sizeof(apicid_to_node));
 
 	nodes_clear(nodes_parsed);
 	for (i = 0; i < num_nodes; i++)
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
x86_64-clean-up-apicid_to_node-declaration.patch
maps2-uninline-some-functions-in-the-page-walker.patch
maps2-eliminate-the-pmd_walker-struct-in-the-page-walker.patch
maps2-remove-vma-from-args-in-the-page-walker.patch
maps2-propagate-errors-from-callback-in-page-walker.patch
maps2-add-callbacks-for-each-level-to-page-walker.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-simplify-interdependence-of-proc-pid-maps-and-smaps.patch
maps2-move-clear_refs-code-to-task_mmuc.patch
maps2-regroup-task_mmu-by-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embedded.patch
maps2-make-proc-pid-clear_refs-option-under-config_embedded.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-add-proc-kpagemap-interface.patch
