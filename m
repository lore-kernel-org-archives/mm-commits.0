From: akpm@linux-foundation.org
Subject: - x86_64-fix-e820_hole_size-based-on-address-ranges.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:08:23 -0700
Message-ID: <200707192008.l6JK8NFN020453@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39258 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761037AbXGSUPj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:15:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     x86_64: fix e820_hole_size based on address ranges
has been removed from the -mm tree.  Its filename was
     x86_64-fix-e820_hole_size-based-on-address-ranges.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86_64: fix e820_hole_size based on address ranges
From: David Rientjes <rientjes@google.com>

e820_hole_size() now uses the newly extracted helper function,
e820_find_active_region(), to determine the size of usable RAM in a range of
PFN's.

This was previously broken because of two reasons:

 - The start and end PFN's of each e820 entry were not properly rounded
   prior to excluding those entries in the range, and

 - Entries smaller than a page were not properly excluded from being
   accumulated.

This resulted in emulated nodes being incorrectly mapped to ranges that
were completely reserved and not candidates for being registered as
active ranges.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/e820.c |   54 +++++++++++++++---------------------
 arch/x86_64/mm/numa.c     |    8 +----
 2 files changed, 25 insertions(+), 37 deletions(-)

diff -puN arch/x86_64/kernel/e820.c~x86_64-fix-e820_hole_size-based-on-address-ranges arch/x86_64/kernel/e820.c
--- a/arch/x86_64/kernel/e820.c~x86_64-fix-e820_hole_size-based-on-address-ranges
+++ a/arch/x86_64/kernel/e820.c
@@ -194,37 +194,6 @@ unsigned long __init e820_end_of_ram(voi
 }
 
 /*
- * Find the hole size in the range.
- */
-unsigned long __init e820_hole_size(unsigned long start, unsigned long end)
-{
-	unsigned long ram = 0;
-	int i;
-
-	for (i = 0; i < e820.nr_map; i++) {
-		struct e820entry *ei = &e820.map[i];
-		unsigned long last, addr;
-
-		if (ei->type != E820_RAM ||
-		    ei->addr+ei->size <= start ||
-		    ei->addr >= end)
-			continue;
-
-		addr = round_up(ei->addr, PAGE_SIZE);
-		if (addr < start)
-			addr = start;
-
-		last = round_down(ei->addr + ei->size, PAGE_SIZE);
-		if (last >= end)
-			last = end;
-
-		if (last > addr)
-			ram += last - addr;
-	}
-	return ((end - start) - ram);
-}
-
-/*
  * Mark e820 reserved areas as busy for the resource manager.
  */
 void __init e820_reserve_resources(void)
@@ -364,6 +333,29 @@ void __init add_memory_region(unsigned l
 	e820.nr_map++;
 }
 
+/*
+ * Find the hole size (in bytes) in the memory range.
+ * @start: starting address of the memory range to scan
+ * @end: ending address of the memory range to scan
+ */
+unsigned long __init e820_hole_size(unsigned long start, unsigned long end)
+{
+	unsigned long start_pfn = start >> PAGE_SHIFT;
+	unsigned long end_pfn = end >> PAGE_SHIFT;
+	unsigned long ei_startpfn;
+	unsigned long ei_endpfn;
+	unsigned long ram = 0;
+	int i;
+
+	for (i = 0; i < e820.nr_map; i++) {
+		if (e820_find_active_region(&e820.map[i],
+					    start_pfn, end_pfn,
+					    &ei_startpfn, &ei_endpfn))
+			ram += ei_endpfn - ei_startpfn;
+	}
+	return end - start - (ram << PAGE_SHIFT);
+}
+
 void __init e820_print_map(char *who)
 {
 	int i;
diff -puN arch/x86_64/mm/numa.c~x86_64-fix-e820_hole_size-based-on-address-ranges arch/x86_64/mm/numa.c
--- a/arch/x86_64/mm/numa.c~x86_64-fix-e820_hole_size-based-on-address-ranges
+++ a/arch/x86_64/mm/numa.c
@@ -273,9 +273,6 @@ void __init numa_init_array(void)
 
 #ifdef CONFIG_NUMA_EMU
 /* Numa emulation */
-#define E820_ADDR_HOLE_SIZE(start, end)					\
-	(e820_hole_size((start) >> PAGE_SHIFT, (end) >> PAGE_SHIFT) <<	\
-	PAGE_SHIFT)
 char *cmdline __initdata;
 
 /*
@@ -319,7 +316,7 @@ static int __init split_nodes_equally(st
 		return -1;
 	if (num_nodes > MAX_NUMNODES)
 		num_nodes = MAX_NUMNODES;
-	size = (max_addr - *addr - E820_ADDR_HOLE_SIZE(*addr, max_addr)) /
+	size = (max_addr - *addr - e820_hole_size(*addr, max_addr)) /
 	       num_nodes;
 	/*
 	 * Calculate the number of big nodes that can be allocated as a result
@@ -347,7 +344,7 @@ static int __init split_nodes_equally(st
 		if (i == num_nodes + node_start - 1)
 			end = max_addr;
 		else
-			while (end - *addr - E820_ADDR_HOLE_SIZE(*addr, end) <
+			while (end - *addr - e820_hole_size(*addr, end) <
 			       size) {
 				end += FAKE_NODE_MIN_SIZE;
 				if (end > max_addr) {
@@ -487,7 +484,6 @@ out:
  	numa_init_array();
  	return 0;
 }
-#undef E820_ADDR_HOLE_SIZE
 #endif /* CONFIG_NUMA_EMU */
 
 void __init numa_initmem_init(unsigned long start_pfn, unsigned long end_pfn)
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
