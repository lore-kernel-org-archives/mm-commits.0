From: akpm@linux-foundation.org
Subject: + x86_64-numa-fake-apicid_to_node-mapping-for-fake-numa.patch added to -mm tree
Date: Wed, 09 May 2007 16:18:37 -0700
Message-ID: <200705092318.l49NIbDt005456@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:59169 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759045AbXEIXT4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 19:19:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, ak@suse.de, lenb@kernel.org


The patch titled
     x86_64 numa: fake apicid_to_node mapping for fake numa
has been added to the -mm tree.  Its filename is
     x86_64-numa-fake-apicid_to_node-mapping-for-fake-numa.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86_64 numa: fake apicid_to_node mapping for fake numa
From: David Rientjes <rientjes@google.com>

When we are in the emulated NUMA case, we need to make sure that all existing
apicid_to_node mappings that point to real node ID's now point to the
equivalent fake node ID's.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/mm/srat.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletion(-)

diff -puN arch/x86_64/mm/srat.c~x86_64-numa-fake-apicid_to_node-mapping-for-fake-numa arch/x86_64/mm/srat.c
--- a/arch/x86_64/mm/srat.c~x86_64-numa-fake-apicid_to_node-mapping-for-fake-numa
+++ a/arch/x86_64/mm/srat.c
@@ -472,7 +472,7 @@ static int __init find_node_by_addr(cons
  */
 void __init acpi_fake_nodes(const struct bootnode *fake_nodes, int num_nodes)
 {
-	int i;
+	int i, j;
 
 	printk(KERN_INFO "Faking PXM affinity for fake nodes on real "
 			 "topology.\n");
@@ -486,6 +486,13 @@ void __init acpi_fake_nodes(const struct
 		if (nid == NUMA_NO_NODE)
 			continue;
 		__acpi_map_pxm_to_node(pxm, nid);
+		/*
+		 * For each apicid-to-node mapping that exists for this real
+		 * node, it must now point to the fake node ID.
+		 */
+		for (j = 0; j < MAX_LOCAL_APIC; j++)
+			if (apicid_to_node[j] == i)
+				apicid_to_node[j] = nid;
 	}
 
 	nodes_clear(nodes_parsed);
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
git-alsa.patch
powerpc-ps3-use-__maybe_unused.patch
mips-excite-use-__maybe_unused.patch
mips-tlbex-use-__maybe_unused.patch
scsi-fix-ambiguous-gdthtable-definition.patch
x86_64-rename-and-export-bad_srat-to-kernel-code.patch
x86_64-rename-and-export-bad_srat-to-kernel-code-fix.patch
x86_64-extract-helper-function-from-e820_register_active_regions.patch
x86_64-extract-helper-function-from-e820_register_active_regions-fix.patch
x86_64-fix-e820_hole_size-based-on-address-ranges.patch
x86_64-fix-fake-numa-for-machines-with-true-srat.patch
x86_64-acpi-define-and-use-local_distance-and.patch
x86_64-acpi-various-cleanups.patch
x86_64-slit-fake-pxm-to-node-mapping-for-fake-numa.patch
x86_64-numa-fake-apicid_to_node-mapping-for-fake-numa.patch
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
frv-gdb-use-__maybe_unused.patch
