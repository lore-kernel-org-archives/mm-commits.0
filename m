From: akpm@linux-foundation.org
Subject: - mm-fix-alloc_bootmem_core-to-use-fast-searching-for-all-nodes.patch removed from -mm tree
Date: Sun, 27 Apr 2008 11:36:32 -0700
Message-ID: <200804271836.m3RIaW9s019351@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48997 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757767AbYD0Sho (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 27 Apr 2008 14:37:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yhlu.kernel@gmail.com, ak@suse.de, clameter@sgi.com, kamezawa.hiroyu@jp.fujitsu.com, mingo@elte.hu, y-goto@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     mm: fix alloc_bootmem_core to use fast searching for all nodes
has been removed from the -mm tree.  Its filename was
     mm-fix-alloc_bootmem_core-to-use-fast-searching-for-all-nodes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: fix alloc_bootmem_core to use fast searching for all nodes
From: "Yinghai Lu" <yhlu.kernel@gmail.com>

Make the nodes other than node 0 could use bdata->last_success for fast search
too.

We need to use __alloc_bootmem_core for vmemmap allocation for other nodes
when numa and sparsemem/vmemmap are enabled.

Also make fail_block path increase i with incr only needed after ALIGN to
avoid extra increase when size is large than align.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
Cc: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/bootmem.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff -puN mm/bootmem.c~mm-fix-alloc_bootmem_core-to-use-fast-searching-for-all-nodes mm/bootmem.c
--- a/mm/bootmem.c~mm-fix-alloc_bootmem_core-to-use-fast-searching-for-all-nodes
+++ a/mm/bootmem.c
@@ -238,28 +238,32 @@ __alloc_bootmem_core(struct bootmem_data
 	 * We try to allocate bootmem pages above 'goal'
 	 * first, then we try to allocate lower pages.
 	 */
-	if (goal && goal >= bdata->node_boot_start && PFN_DOWN(goal) < end_pfn) {
-		preferred = goal - bdata->node_boot_start;
+	preferred = 0;
+	if (goal && PFN_DOWN(goal) < end_pfn) {
+		if (goal > bdata->node_boot_start)
+			preferred = goal - bdata->node_boot_start;
 
 		if (bdata->last_success >= preferred)
 			if (!limit || (limit && limit > bdata->last_success))
 				preferred = bdata->last_success;
-	} else
-		preferred = 0;
+	}
 
 	preferred = PFN_DOWN(ALIGN(preferred, align)) + offset;
 	areasize = (size + PAGE_SIZE-1) / PAGE_SIZE;
 	incr = align >> PAGE_SHIFT ? : 1;
 
 restart_scan:
-	for (i = preferred; i < eidx; i += incr) {
+	for (i = preferred; i < eidx;) {
 		unsigned long j;
+
 		i = find_next_zero_bit(bdata->node_bootmem_map, eidx, i);
 		i = ALIGN(i, incr);
 		if (i >= eidx)
 			break;
-		if (test_bit(i, bdata->node_bootmem_map))
+		if (test_bit(i, bdata->node_bootmem_map)) {
+			i += incr;
 			continue;
+		}
 		for (j = i + 1; j < i + areasize; ++j) {
 			if (j >= eidx)
 				goto fail_block;
@@ -270,6 +274,8 @@ restart_scan:
 		goto found;
 	fail_block:
 		i = ALIGN(j, incr);
+		if (i == j)
+			i += incr;
 	}
 
 	if (preferred > offset) {
_

Patches currently in -mm which might be from yhlu.kernel@gmail.com are

origin.patch
x86_64-restore-mask_bits-in-msi-shutdown.patch
mm-make-reserve_bootmem-can-crossed-the-nodes-checkpatch-fixes.patch
memory-hotplug-register-section-node-id-to-free.patch
memory-hotplug-align-memmap-to-page-size.patch
memory-hotplug-make-alloc_bootmem_section.patch
memory-hotplugallocate-usemap-on-the-section-with-pgdat.patch
memory-hotplug-free-memmaps-allocated-by-bootmem.patch

