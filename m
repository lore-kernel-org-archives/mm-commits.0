From: akpm@linux-foundation.org
Subject: - x86_64-set-node_possible_map-at-runtime-fix.patch removed from -mm tree
Date: Thu, 26 Apr 2007 00:38:50 -0700
Message-ID: <200704260738.l3Q7co5P024441@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:53575 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933215AbXDZHjn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Apr 2007 03:39:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, andi@firstfloor.org, clameter@engr.sgi.com, dada1@cosmosbay.com, suresh.b.siddha@intel.com, mm-commits@vger.kernel.org


The patch titled
     x86_64-set-node_possible_map-at-runtime fix
has been removed from the -mm tree.  Its filename was
     x86_64-set-node_possible_map-at-runtime-fix.patch

This patch was dropped because it was folded into x86_64-set-node_possible_map-at-runtime.patch

------------------------------------------------------
Subject: x86_64-set-node_possible_map-at-runtime fix
From: David Rientjes <rientjes@google.com>

Clear node_possible_map if numa_emulation() fails for some reason, such as
a failed hash shift, but setup_node_range() has already set some fake nodes
as online.

Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Eric Dumazet <dada1@cosmosbay.com>
Cc: Christoph Lameter <clameter@engr.sgi.com>
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/mm/numa.c |    1 +
 1 files changed, 1 insertion(+)

diff -puN arch/x86_64/mm/numa.c~x86_64-set-node_possible_map-at-runtime-fix arch/x86_64/mm/numa.c
--- a/arch/x86_64/mm/numa.c~x86_64-set-node_possible_map-at-runtime-fix
+++ a/arch/x86_64/mm/numa.c
@@ -500,6 +500,7 @@ void __init numa_initmem_init(unsigned l
 #ifdef CONFIG_NUMA_EMU
 	if (cmdline && !numa_emulation(start_pfn, end_pfn))
  		return;
+	nodes_clear(node_possible_map);
 #endif
 
 #ifdef CONFIG_ACPI_NUMA
_

Patches currently in -mm which might be from rientjes@google.com are

x86_64-set-node_possible_map-at-runtime.patch
x86_64-set-node_possible_map-at-runtime-fix.patch
x86_64-set-node_possible_map-at-runtime-fix-2.patch
slab-x86_64-skip-cache_free_alien-on-non-numa.patch
i386-add-ptep_test_and_clear_dirtyyoung.patch
i386-use-pte_update_defer-in-ptep_test_and_clear_dirtyyoung.patch
i386-use-pte_update_defer-in-ptep_test_and_clear_dirtyyoung-fix.patch
smaps-extract-pmd-walker-from-smaps-code.patch
smaps-add-pages-referenced-count-to-smaps.patch
smaps-add-clear_refs-file-to-clear-reference.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix-fix-2.patch
smaps-add-clear_refs-file-to-clear-reference-cleanup.patch
smaps-use-ptep_test_and_clear_young.patch
smaps-add-clear_refs-file-to-clear-reference-docs.patch
maps2-uninline-some-functions-in-the-page-walker.patch
maps2-eliminate-the-pmd_walker-struct-in-the-page-walker.patch
maps2-remove-vma-from-args-in-the-page-walker.patch
maps2-propagate-errors-from-callback-in-page-walker.patch
maps2-add-callbacks-for-each-level-to-page-walker.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-move-the-page-walker-code-to-lib-fix.patch
maps2-simplify-interdependence-of-proc-pid-maps-and-smaps.patch
maps2-move-clear_refs-code-to-task_mmuc.patch
maps2-regroup-task_mmu-by-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embedded.patch
maps2-make-proc-pid-clear_refs-option-under-config_embedded.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-add-proc-kpagemap-interface.patch
cpusets-allow-tif_memdie-threads-to-allocate-anywhere.patch
mm-fix-handling-of-panic_on_oom-when-cpusets-are-in-use.patch
