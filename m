From: akpm@linux-foundation.org
Subject: + x86_64-acpi-disable-srat-when-numa-emulation-succeeds-fix.patch added to -mm tree
Date: Wed, 06 Jun 2007 11:24:29 -0700
Message-ID: <200706061824.l56IOTDb003405@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36833 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932511AbXFFSYu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Jun 2007 14:24:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh@veritas.com, ak@suse.de, lenb@kernel.org, rientjes@google.com


The patch titled
     x86_64-acpi-disable-srat-when-numa-emulation-succeeds-fix
has been added to the -mm tree.  Its filename is
     x86_64-acpi-disable-srat-when-numa-emulation-succeeds-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 file changed, 2 insertions(+)

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
_

Patches currently in -mm which might be from hugh@veritas.com are

mount-t-tmpfs-o-mpol=-check-nodes-online.patch
x86_64-acpi-disable-srat-when-numa-emulation-succeeds-fix.patch
rework-ptep_set_access_flags-and-fix-sun4c.patch
rework-ptep_set_access_flags-and-fix-sun4c-fix.patch
rework-ptep_set_access_flags-and-fix-sun4c-fix-fix.patch
unmap_vm_area-becomes-unmap_kernel_range-for-the-public.patch
numa-mempolicy-allow-tunable-policy-for-system-init.patch
numa-mempolicy-allow-tunable-policy-for-system-init-fix.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
ext2-reservations.patch
ext2-balloc-use-io_error-label.patch
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
