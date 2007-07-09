From: akpm@linux-foundation.org
Subject: - x86_64-acpi-disable-srat-when-numa-emulation-succeeds-fix.patch removed from -mm tree
Date: Mon, 09 Jul 2007 12:17:11 -0700
Message-ID: <200707091917.l69JHBvF003590@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39255 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754411AbXGITSA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jul 2007 15:18:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, ak@suse.de, lenb@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     x86_64-acpi-disable-srat-when-numa-emulation-succeeds-fix
has been removed from the -mm tree.  Its filename was
     x86_64-acpi-disable-srat-when-numa-emulation-succeeds-fix.patch

This patch was dropped because it was folded into x86_64-acpi-disable-srat-when-numa-emulation-succeeds.patch

------------------------------------------------------
Subject: x86_64-acpi-disable-srat-when-numa-emulation-succeeds-fix
From: Hugh Dickins <hugh@veritas.com>

Fix x86_64 CONFIG_NUMA_EMU build: acpi_numa needs CONFIG_ACPI_NUMA.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: Andi Kleen <ak@suse.de>
Cc: David Rientjes <rientjes@google.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/mm/numa.c |    2 ++
 linux/acpi.h          |    0 
 2 files changed, 2 insertions(+)

diff -puN arch/x86_64/mm/numa.c~x86_64-acpi-disable-srat-when-numa-emulation-succeeds-fix arch/x86_64/mm/numa.c
--- a/arch/x86_64/mm/numa.c~x86_64-acpi-disable-srat-when-numa-emulation-succeeds-fix
+++ a/arch/x86_64/mm/numa.c
@@ -477,7 +477,9 @@ out:
 	 * true.  NUMA emulation has succeeded so we will not scan ACPI nodes.
 	 */
 	remove_all_active_ranges();
+#ifdef CONFIG_ACPI_NUMA
 	acpi_numa = -1;
+#endif
 	for_each_node_mask(i, node_possible_map) {
 		e820_register_active_regions(i, nodes[i].start >> PAGE_SHIFT,
 						nodes[i].end >> PAGE_SHIFT);
diff -puN arch/x86_64/mm/srat.c~x86_64-acpi-disable-srat-when-numa-emulation-succeeds-fix arch/x86_64/mm/srat.c
diff -puN drivers/acpi/numa.c~x86_64-acpi-disable-srat-when-numa-emulation-succeeds-fix drivers/acpi/numa.c
diff -puN include/acpi/acpi_numa.h~x86_64-acpi-disable-srat-when-numa-emulation-succeeds-fix include/acpi/acpi_numa.h
diff -puN include/asm-x86_64/acpi.h~x86_64-acpi-disable-srat-when-numa-emulation-succeeds-fix include/asm-x86_64/acpi.h
diff -puN include/linux/acpi.h~x86_64-acpi-disable-srat-when-numa-emulation-succeeds-fix include/linux/acpi.h
_

Patches currently in -mm which might be from hugh@veritas.com are

pa-risc-use-page-allocator-instead-of-slab-allocator.patch
git-block.patch
x86_64-acpi-disable-srat-when-numa-emulation-succeeds.patch
x86_64-acpi-disable-srat-when-numa-emulation-succeeds-fix.patch
numa-mempolicy-dynamic-interleave-map-for-system-init.patch
mm-avoid-tlb-gather-restarts.patch
mm-remove-ptep_establish.patch
mm-remove-ptep_test_and_clear_dirty-and-ptep_clear_flush_dirty.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
add-vm_bug_on-in-case-someone-uses-page_mapping-on-a-slab-page.patch
hugetlbfs-use-lib-parser-fix-docs.patch
ext2-reservations.patch
ext2-balloc-use-io_error-label.patch
mm-variable-length-argument-support.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-swap-prefetch.patch
coredump-masking-bound-suid_dumpable-sysctl.patch
coredump-masking-reimplementation-of-dumpable-using-two-flags.patch
coredump-masking-reimplementation-of-dumpable-using-two-flags-fix.patch
coredump-masking-add-an-interface-for-core-dump-filter.patch
coredump-masking-elf-enable-core-dump-filtering.patch
coredump-masking-elf-fdpic-remove-an-unused-argument.patch
coredump-masking-elf-fdpic-enable-core-dump-filtering.patch
coredump-masking-documentation-for-proc-pid-coredump_filter.patch
prio_tree-debugging-patch.patch
