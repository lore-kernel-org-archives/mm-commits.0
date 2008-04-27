From: akpm@linux-foundation.org
Subject: - mm-offset-align-in-alloc_bootmem.patch removed from -mm tree
Date: Sun, 27 Apr 2008 11:36:35 -0700
Message-ID: <200804271836.m3RIaZuI019354@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41949 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758447AbYD0Sh5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 27 Apr 2008 14:37:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yhlu.kernel.send@gmail.com, ak@suse.de, clameter@sgi.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, mingo@elte.hu, y-goto@jp.fujitsu.com, yhlu.kernel@gmail.com, mm-commits@vger.kernel.org


The patch titled
     mm: offset align in alloc_bootmem
has been removed from the -mm tree.  Its filename was
     mm-offset-align-in-alloc_bootmem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: offset align in alloc_bootmem
From: Yinghai Lu <yhlu.kernel.send@gmail.com>

Need offset alignment when node_boot_start's alignment is less than align
required

Use local node_boot_start to match align.  so don't add extra opteration in
search loop.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/bootmem.c |   60 +++++++++++++++++++++++++++----------------------
 1 file changed, 34 insertions(+), 26 deletions(-)

diff -puN mm/bootmem.c~mm-offset-align-in-alloc_bootmem mm/bootmem.c
--- a/mm/bootmem.c~mm-offset-align-in-alloc_bootmem
+++ a/mm/bootmem.c
@@ -206,9 +206,11 @@ void * __init
 __alloc_bootmem_core(struct bootmem_data *bdata, unsigned long size,
 	      unsigned long align, unsigned long goal, unsigned long limit)
 {
-	unsigned long offset, remaining_size, areasize, preferred;
+	unsigned long areasize, preferred;
 	unsigned long i, start = 0, incr, eidx, end_pfn;
 	void *ret;
+	unsigned long node_boot_start;
+	void *node_bootmem_map;
 
 	if (!size) {
 		printk("__alloc_bootmem_core(): zero-sized request\n");
@@ -216,23 +218,29 @@ __alloc_bootmem_core(struct bootmem_data
 	}
 	BUG_ON(align & (align-1));
 
-	if (limit && bdata->node_boot_start >= limit)
-		return NULL;
-
 	/* on nodes without memory - bootmem_map is NULL */
 	if (!bdata->node_bootmem_map)
 		return NULL;
 
+	/* bdata->node_boot_start is supposed to be (12+6)bits alignment on x86_64 ? */
+	node_boot_start = bdata->node_boot_start;
+	node_bootmem_map = bdata->node_bootmem_map;
+	if (align) {
+		node_boot_start = ALIGN(bdata->node_boot_start, align);
+		if (node_boot_start > bdata->node_boot_start)
+			node_bootmem_map = (unsigned long *)bdata->node_bootmem_map +
+			    PFN_DOWN(node_boot_start - bdata->node_boot_start)/BITS_PER_LONG;
+	}
+
+	if (limit && node_boot_start >= limit)
+		return NULL;
+
 	end_pfn = bdata->node_low_pfn;
 	limit = PFN_DOWN(limit);
 	if (limit && end_pfn > limit)
 		end_pfn = limit;
 
-	eidx = end_pfn - PFN_DOWN(bdata->node_boot_start);
-	offset = 0;
-	if (align && (bdata->node_boot_start & (align - 1UL)) != 0)
-		offset = align - (bdata->node_boot_start & (align - 1UL));
-	offset = PFN_DOWN(offset);
+	eidx = end_pfn - PFN_DOWN(node_boot_start);
 
 	/*
 	 * We try to allocate bootmem pages above 'goal'
@@ -240,15 +248,16 @@ __alloc_bootmem_core(struct bootmem_data
 	 */
 	preferred = 0;
 	if (goal && PFN_DOWN(goal) < end_pfn) {
-		if (goal > bdata->node_boot_start)
-			preferred = goal - bdata->node_boot_start;
+		if (goal > node_boot_start)
+			preferred = goal - node_boot_start;
 
-		if (bdata->last_success >= preferred)
+		if (bdata->last_success > node_boot_start &&
+			bdata->last_success - node_boot_start >= preferred)
 			if (!limit || (limit && limit > bdata->last_success))
-				preferred = bdata->last_success;
+				preferred = bdata->last_success - node_boot_start;
 	}
 
-	preferred = PFN_DOWN(ALIGN(preferred, align)) + offset;
+	preferred = PFN_DOWN(ALIGN(preferred, align));
 	areasize = (size + PAGE_SIZE-1) / PAGE_SIZE;
 	incr = align >> PAGE_SHIFT ? : 1;
 
@@ -256,18 +265,18 @@ restart_scan:
 	for (i = preferred; i < eidx;) {
 		unsigned long j;
 
-		i = find_next_zero_bit(bdata->node_bootmem_map, eidx, i);
+		i = find_next_zero_bit(node_bootmem_map, eidx, i);
 		i = ALIGN(i, incr);
 		if (i >= eidx)
 			break;
-		if (test_bit(i, bdata->node_bootmem_map)) {
+		if (test_bit(i, node_bootmem_map)) {
 			i += incr;
 			continue;
 		}
 		for (j = i + 1; j < i + areasize; ++j) {
 			if (j >= eidx)
 				goto fail_block;
-			if (test_bit(j, bdata->node_bootmem_map))
+			if (test_bit(j, node_bootmem_map))
 				goto fail_block;
 		}
 		start = i;
@@ -278,14 +287,14 @@ restart_scan:
 			i += incr;
 	}
 
-	if (preferred > offset) {
-		preferred = offset;
+	if (preferred > 0) {
+		preferred = 0;
 		goto restart_scan;
 	}
 	return NULL;
 
 found:
-	bdata->last_success = PFN_PHYS(start);
+	bdata->last_success = PFN_PHYS(start) + node_boot_start;
 	BUG_ON(start >= eidx);
 
 	/*
@@ -295,6 +304,7 @@ found:
 	 */
 	if (align < PAGE_SIZE &&
 	    bdata->last_offset && bdata->last_pos+1 == start) {
+		unsigned long offset, remaining_size;
 		offset = ALIGN(bdata->last_offset, align);
 		BUG_ON(offset > PAGE_SIZE);
 		remaining_size = PAGE_SIZE - offset;
@@ -303,14 +313,12 @@ found:
 			/* last_pos unchanged */
 			bdata->last_offset = offset + size;
 			ret = phys_to_virt(bdata->last_pos * PAGE_SIZE +
-					   offset +
-					   bdata->node_boot_start);
+					   offset + node_boot_start);
 		} else {
 			remaining_size = size - remaining_size;
 			areasize = (remaining_size + PAGE_SIZE-1) / PAGE_SIZE;
 			ret = phys_to_virt(bdata->last_pos * PAGE_SIZE +
-					   offset +
-					   bdata->node_boot_start);
+					   offset + node_boot_start);
 			bdata->last_pos = start + areasize - 1;
 			bdata->last_offset = remaining_size;
 		}
@@ -318,14 +326,14 @@ found:
 	} else {
 		bdata->last_pos = start + areasize - 1;
 		bdata->last_offset = size & ~PAGE_MASK;
-		ret = phys_to_virt(start * PAGE_SIZE + bdata->node_boot_start);
+		ret = phys_to_virt(start * PAGE_SIZE + node_boot_start);
 	}
 
 	/*
 	 * Reserve the area now:
 	 */
 	for (i = start; i < start + areasize; i++)
-		if (unlikely(test_and_set_bit(i, bdata->node_bootmem_map)))
+		if (unlikely(test_and_set_bit(i, node_bootmem_map)))
 			BUG();
 	memset(ret, 0, size);
 	return ret;
_

Patches currently in -mm which might be from yhlu.kernel.send@gmail.com are

origin.patch
x86_64-restore-mask_bits-in-msi-shutdown.patch

