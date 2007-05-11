From: akpm@linux-foundation.org
Subject: - x86_64-fix-fake-numa-for-machines-with-true-srat.patch removed from -mm tree
Date: Thu, 10 May 2007 17:08:00 -0700
Message-ID: <200705110008.l4B080vC001962@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:60525 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756741AbXEKAIH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 May 2007 20:08:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     x86_64: fix fake numa for machines with true srat
has been removed from the -mm tree.  Its filename was
     x86_64-fix-fake-numa-for-machines-with-true-srat.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
Subject: x86_64: fix fake numa for machines with true srat
From: David Rientjes <rientjes@google.com>

Use the newly exported disable_srat() function to disable all SRAT detected
values before registering emulated node active regions or calling
setup_node_bootmem().  This ensures we are correctly srat_disabled() since we
never call acpi_scan_nodes() in the emulated case, even on true SRAT machines.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/mm/numa.c |    7 +------
 1 files changed, 1 insertion(+), 6 deletions(-)

diff -puN arch/x86_64/mm/numa.c~x86_64-fix-fake-numa-for-machines-with-true-srat arch/x86_64/mm/numa.c
--- a/arch/x86_64/mm/numa.c~x86_64-fix-fake-numa-for-machines-with-true-srat
+++ a/arch/x86_64/mm/numa.c
@@ -463,6 +463,7 @@ done:
 		}
 	}
 out:
+	disable_srat();
 	memnode_shift = compute_hash_shift(nodes, num_nodes);
 	if (memnode_shift < 0) {
 		memnode_shift = 0;
@@ -470,12 +471,6 @@ out:
 		       "disabled.\n");
 		return -1;
 	}
-
-	/*
-	 * We need to vacate all active ranges that may have been registered by
-	 * SRAT.
-	 */
-	remove_all_active_ranges();
 	for_each_node_mask(i, node_possible_map) {
 		e820_register_active_regions(i, nodes[i].start >> PAGE_SHIFT,
 						nodes[i].end >> PAGE_SHIFT);
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
git-alsa.patch
powerpc-ps3-use-__maybe_unused.patch
mips-excite-use-__maybe_unused.patch
mips-tlbex-use-__maybe_unused.patch
scsi-fix-ambiguous-gdthtable-definition.patch
x86_64-extract-helper-function-from-e820_register_active_regions.patch
x86_64-extract-helper-function-from-e820_register_active_regions-fix.patch
x86_64-fix-e820_hole_size-based-on-address-ranges.patch
x86_64-fix-fake-numa-for-machines-with-true-srat.patch
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
