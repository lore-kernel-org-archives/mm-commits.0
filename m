From: akpm@linux-foundation.org
Subject: + x86_64-extract-helper-function-from-e820_register_active_regions.patch added to -mm tree
Date: Wed, 09 May 2007 16:13:22 -0700
Message-ID: <200705092313.l49NDMWT005308@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:38541 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756568AbXEIXNg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 19:13:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, ak@suse.de, mel@csn.ul.ie


The patch titled
     x86_64: extract helper function from e820_register_active_regions
has been added to the -mm tree.  Its filename is
     x86_64-extract-helper-function-from-e820_register_active_regions.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86_64: extract helper function from e820_register_active_regions
From: David Rientjes <rientjes@google.com>

The logic in e820_find_active_regions() for determining the true active
regions for an e820 entry given a range of PFN's is needed for
e820_hole_size() as well.

e820_hole_size() is called from the NUMA emulation code to determine the
reserved area within an address range on a per-node basis.  Its logic should
duplicate that of finding active regions in an e820 entry because these are
the only true ranges we may register anyway.

Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/e820.c |   82 +++++++++++++++++++++---------------
 1 files changed, 48 insertions(+), 34 deletions(-)

diff -puN arch/x86_64/kernel/e820.c~x86_64-extract-helper-function-from-e820_register_active_regions arch/x86_64/kernel/e820.c
--- a/arch/x86_64/kernel/e820.c~x86_64-extract-helper-function-from-e820_register_active_regions
+++ a/arch/x86_64/kernel/e820.c
@@ -289,47 +289,61 @@ void __init e820_mark_nosave_regions(voi
 	}
 }
 
+/*
+ * Finds an active region in the address range from start_pfn to end_pfn and
+ * returns its range in ei_startpfn and ei_endpfn for the e820 entry.
+ */
+static __init int e820_find_active_region(const struct e820entry *ei,
+					  unsigned long start_pfn,
+					  unsigned long end_pfn,
+					  unsigned long *ei_startpfn,
+					  unsigned long *ei_endpfn)
+{
+	*ei_startpfn = round_up(ei->addr, PAGE_SIZE) >> PAGE_SHIFT;
+	*ei_endpfn = round_down(ei->addr + ei->size, PAGE_SIZE) >> PAGE_SHIFT;
+
+	/* Skip map entries smaller than a page */
+	if (*ei_startpfn >= *ei_endpfn)
+		return 0;
+
+	/* Check if end_pfn_map should be updated */
+	if (ei->type != E820_RAM && *ei_endpfn > end_pfn_map)
+		end_pfn_map = *ei_endpfn;
+
+	/* Skip if map is outside the node */
+	if (ei->type != E820_RAM || *ei_endpfn <= start_pfn ||
+				    *ei_startpfn >= end_pfn)
+		return 0;
+
+	/* Check for overlaps */
+	if (*ei_startpfn < start_pfn)
+		*ei_startpfn = start_pfn;
+	if (*ei_endpfn > end_pfn)
+		*ei_endpfn = end_pfn;
+
+	/* Obey end_user_pfn to save on memmap */
+	if (*ei_startpfn >= end_user_pfn)
+		return 0;
+	if (*ei_endpfn > end_user_pfn)
+		*ei_endpfn = end_user_pfn;
+
+	return 1;
+}
+
 /* Walk the e820 map and register active regions within a node */
 void __init
 e820_register_active_regions(int nid, unsigned long start_pfn,
 							unsigned long end_pfn)
 {
+	unsigned long ei_startpfn;
+	unsigned long ei_endpfn;
 	int i;
-	unsigned long ei_startpfn, ei_endpfn;
-	for (i = 0; i < e820.nr_map; i++) {
-		struct e820entry *ei = &e820.map[i];
-		ei_startpfn = round_up(ei->addr, PAGE_SIZE) >> PAGE_SHIFT;
-		ei_endpfn = round_down(ei->addr + ei->size, PAGE_SIZE)
-								>> PAGE_SHIFT;
-
-		/* Skip map entries smaller than a page */
-		if (ei_startpfn >= ei_endpfn)
-			continue;
-
-		/* Check if end_pfn_map should be updated */
-		if (ei->type != E820_RAM && ei_endpfn > end_pfn_map)
-			end_pfn_map = ei_endpfn;
-
-		/* Skip if map is outside the node */
-		if (ei->type != E820_RAM ||
-				ei_endpfn <= start_pfn ||
-				ei_startpfn >= end_pfn)
-			continue;
-
-		/* Check for overlaps */
-		if (ei_startpfn < start_pfn)
-			ei_startpfn = start_pfn;
-		if (ei_endpfn > end_pfn)
-			ei_endpfn = end_pfn;
-
-		/* Obey end_user_pfn to save on memmap */
-		if (ei_startpfn >= end_user_pfn)
-			continue;
-		if (ei_endpfn > end_user_pfn)
-			ei_endpfn = end_user_pfn;
 
-		add_active_range(nid, ei_startpfn, ei_endpfn);
-	}
+	for (i = 0; i < e820.nr_map; i++)
+		if (e820_find_active_region(&e820.map[i],
+					    start_pfn, end_pfn,
+					    &ei_startpfn, &ei_endpfn))
+			add_active_range(nid, ei_startpfn, ei_endpfn);
 }
 
 /* 
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
