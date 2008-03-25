From: akpm@linux-foundation.org
Subject: - mm-fix-boundary-checking-in-free_bootmem_core.patch removed from -mm tree
Date: Tue, 25 Mar 2008 15:29:31 -0700
Message-ID: <200803252229.m2PMTVxl016817@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60757 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759403AbYCYWaW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 Mar 2008 18:30:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yhlu.kernel@gmail.com, ak@suse.de, clameter@sgi.com, kamezawa.hiroyu@jp.fujitsu.com, mingo@elte.hu, y-goto@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     mm: fix boundary checking in free_bootmem_core
has been removed from the -mm tree.  Its filename was
     mm-fix-boundary-checking-in-free_bootmem_core.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: fix boundary checking in free_bootmem_core
From: "Yinghai Lu" <yhlu.kernel@gmail.com>

With numa enabled, some callers could have a range o fmemory on one node but
try to free that on other node.  This can cause some pages to be freed
wrongly.

For example: when we try to allocate 128g boot ram early for gart/swiotlb, and
free that range later so gart/swiotlb can get some range afterwards.

With this patch, we don't need to care which node holds the range, just loop
to call free_bootmem_node for all online nodes.

This patch makes free_bootmem_core() more robust by trimming the sidx and eidx
according the ram range that the node has.

And make the free_bootmem_core handle this out of range case.  We could use
bdata_list to make sure the range can be freed for sure.  So next time, we
don't need to loop online nodes and could use free_bootmem directly.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
Tested-by: Ingo Molnar <mingo@elte.hu>
Cc: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/bootmem.c |   25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff -puN mm/bootmem.c~mm-fix-boundary-checking-in-free_bootmem_core mm/bootmem.c
--- a/mm/bootmem.c~mm-fix-boundary-checking-in-free_bootmem_core
+++ a/mm/bootmem.c
@@ -125,6 +125,7 @@ static int __init reserve_bootmem_core(b
 	BUG_ON(!size);
 	BUG_ON(PFN_DOWN(addr) >= bdata->node_low_pfn);
 	BUG_ON(PFN_UP(addr + size) > bdata->node_low_pfn);
+	BUG_ON(addr < bdata->node_boot_start);
 
 	sidx = PFN_DOWN(addr - bdata->node_boot_start);
 	eidx = PFN_UP(addr + size - bdata->node_boot_start);
@@ -156,21 +157,31 @@ static void __init free_bootmem_core(boo
 	unsigned long sidx, eidx;
 	unsigned long i;
 
+	BUG_ON(!size);
+
+	/* out range */
+	if (addr + size < bdata->node_boot_start ||
+		PFN_DOWN(addr) > bdata->node_low_pfn)
+		return;
 	/*
 	 * round down end of usable mem, partially free pages are
 	 * considered reserved.
 	 */
-	BUG_ON(!size);
-	BUG_ON(PFN_DOWN(addr + size) > bdata->node_low_pfn);
 
-	if (addr < bdata->last_success)
+	if (addr >= bdata->node_boot_start && addr < bdata->last_success)
 		bdata->last_success = addr;
 
 	/*
-	 * Round up the beginning of the address.
+	 * Round up to index to the range.
 	 */
-	sidx = PFN_UP(addr) - PFN_DOWN(bdata->node_boot_start);
+	if (PFN_UP(addr) > PFN_DOWN(bdata->node_boot_start))
+		sidx = PFN_UP(addr) - PFN_DOWN(bdata->node_boot_start);
+	else
+		sidx = 0;
+
 	eidx = PFN_DOWN(addr + size - bdata->node_boot_start);
+	if (eidx > bdata->node_low_pfn - PFN_DOWN(bdata->node_boot_start))
+		eidx = bdata->node_low_pfn - PFN_DOWN(bdata->node_boot_start);
 
 	for (i = sidx; i < eidx; i++) {
 		if (unlikely(!test_and_clear_bit(i, bdata->node_bootmem_map)))
@@ -421,7 +432,9 @@ int __init reserve_bootmem(unsigned long
 
 void __init free_bootmem(unsigned long addr, unsigned long size)
 {
-	free_bootmem_core(NODE_DATA(0)->bdata, addr, size);
+	bootmem_data_t *bdata;
+	list_for_each_entry(bdata, &bdata_list, list)
+		free_bootmem_core(bdata, addr, size);
 }
 
 unsigned long __init free_all_bootmem(void)
_

Patches currently in -mm which might be from yhlu.kernel@gmail.com are

origin.patch
git-x86.patch
x86_64-do-not-reserve-ramdisk-two-times.patch
mm-make-mem_map-allocation-continuous.patch
mm-make-mem_map-allocation-continuous-checkpatch-fixes.patch
mm-fix-alloc_bootmem_core-to-use-fast-searching-for-all-nodes.patch
mm-allocate-section_map-for-sparse_init.patch
mm-allocate-section_map-for-sparse_init-update.patch
mm-offset-align-in-alloc_bootmem.patch
mm-make-reserve_bootmem-can-crossed-the-nodes.patch
mm-make-reserve_bootmem-can-crossed-the-nodes-checkpatch-fixes.patch

