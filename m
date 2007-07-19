From: akpm@linux-foundation.org
Subject: - x86_64-acpi-disable-srat-when-numa-emulation-succeeds.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:08:25 -0700
Message-ID: <200707192008.l6JK8P3x020456@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41500 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759527AbXGSUQl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:16:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, ak@suse.de, hugh@veritas.com, lenb@kernel.org, mm-commits@vger.kernel.org


The patch titled
     x86_64 acpi: disable srat when numa emulation succeeds
has been removed from the -mm tree.  Its filename was
     x86_64-acpi-disable-srat-when-numa-emulation-succeeds.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86_64 acpi: disable srat when numa emulation succeeds
From: David Rientjes <rientjes@google.com>

When NUMA emulation succeeds, acpi_numa needs to be set to -1 so that
srat_disabled() will always return true.  We won't be calling
acpi_scan_nodes() or registering the true nodes we've found.

[hugh@veritas.com: Fix x86_64 CONFIG_NUMA_EMU build: acpi_numa needs CONFIG_ACPI_NUMA]
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/mm/numa.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletion(-)

diff -puN arch/x86_64/mm/numa.c~x86_64-acpi-disable-srat-when-numa-emulation-succeeds arch/x86_64/mm/numa.c
--- a/arch/x86_64/mm/numa.c~x86_64-acpi-disable-srat-when-numa-emulation-succeeds
+++ a/arch/x86_64/mm/numa.c
@@ -473,9 +473,13 @@ out:
 
 	/*
 	 * We need to vacate all active ranges that may have been registered by
-	 * SRAT.
+	 * SRAT and set acpi_numa to -1 so that srat_disabled() always returns
+	 * true.  NUMA emulation has succeeded so we will not scan ACPI nodes.
 	 */
 	remove_all_active_ranges();
+#ifdef CONFIG_ACPI_NUMA
+	acpi_numa = -1;
+#endif
 	for_each_node_mask(i, node_possible_map) {
 		e820_register_active_regions(i, nodes[i].start >> PAGE_SHIFT,
 						nodes[i].end >> PAGE_SHIFT);
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
