From: akpm@linux-foundation.org
Subject: + x86_64-acpi-disable-srat-when-numa-emulation-succeeds.patch added to -mm tree
Date: Thu, 10 May 2007 17:08:58 -0700
Message-ID: <200705110008.l4B08w6H001979@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:42122 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755321AbXEKAK2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 May 2007 20:10:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, ak@suse.de, lenb@kernel.org


The patch titled
     x86_64 acpi: disable srat when numa emulation succeeds
has been added to the -mm tree.  Its filename is
     x86_64-acpi-disable-srat-when-numa-emulation-succeeds.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86_64 acpi: disable srat when numa emulation succeeds
From: David Rientjes <rientjes@google.com>

When NUMA emulation succeeds, acpi_numa needs to be set to -1 so that
srat_disabled() will always return true.  We won't be calling
acpi_scan_nodes() or registering the true nodes we've found.

Cc: Andi Kleen <ak@suse.de>
Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/mm/numa.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletion(-)

diff -puN arch/x86_64/mm/numa.c~x86_64-acpi-disable-srat-when-numa-emulation-succeeds arch/x86_64/mm/numa.c
--- a/arch/x86_64/mm/numa.c~x86_64-acpi-disable-srat-when-numa-emulation-succeeds
+++ a/arch/x86_64/mm/numa.c
@@ -476,9 +476,11 @@ out:
 
 	/*
 	 * We need to vacate all active ranges that may have been registered by
-	 * SRAT.
+	 * SRAT and set acpi_numa to -1 so that srat_disabled() always returns
+	 * true.  NUMA emulation has succeeded so we will not scan ACPI nodes.
 	 */
 	remove_all_active_ranges();
+	acpi_numa = -1;
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
x86_64-acpi-disable-srat-when-numa-emulation-succeeds.patch
x86_64-extract-helper-function-from-e820_register_active_regions.patch
x86_64-extract-helper-function-from-e820_register_active_regions-fix.patch
x86_64-fix-e820_hole_size-based-on-address-ranges.patch
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
