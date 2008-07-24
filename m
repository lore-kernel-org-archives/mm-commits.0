From: akpm@linux-foundation.org
Subject: - bootmem-clean-up-alloc_bootmem_core.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:24:02 -0700
Message-ID: <200807242324.m6ONO29V010743@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38064 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754818AbYGXXYI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:24:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@saeurebad.de, y-goto@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     bootmem: clean up alloc_bootmem_core
has been removed from the -mm tree.  Its filename was
     bootmem-clean-up-alloc_bootmem_core.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: bootmem: clean up alloc_bootmem_core
From: Johannes Weiner <hannes@saeurebad.de>

alloc_bootmem_core has become quite nasty to read over time.  This is a
clean rewrite that keeps the semantics.

bdata->last_pos has been dropped.

bdata->last_success has been renamed to hint_idx and it is now an index
relative to the node's range.  Since further block searching might start
at this index, it is now set to the end of a succeeded allocation rather
than its beginning.

bdata->last_offset has been renamed to last_end_off to be more clear that
it represents the ending address of the last allocation relative to the
node.

[y-goto@jp.fujitsu.com: fix new alloc_bootmem_core()]
Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bootmem.h |    6 -
 mm/bootmem.c            |  218 +++++++++++++-------------------------
 2 files changed, 81 insertions(+), 143 deletions(-)

diff -puN include/linux/bootmem.h~bootmem-clean-up-alloc_bootmem_core include/linux/bootmem.h
--- a/include/linux/bootmem.h~bootmem-clean-up-alloc_bootmem_core
+++ a/include/linux/bootmem.h
@@ -31,10 +31,8 @@ typedef struct bootmem_data {
 	unsigned long node_boot_start;
 	unsigned long node_low_pfn;
 	void *node_bootmem_map;
-	unsigned long last_offset;
-	unsigned long last_pos;
-	unsigned long last_success;	/* Previous allocation point.  To speed
-					 * up searching */
+	unsigned long last_end_off;
+	unsigned long hint_idx;
 	struct list_head list;
 } bootmem_data_t;
 
diff -puN mm/bootmem.c~bootmem-clean-up-alloc_bootmem_core mm/bootmem.c
--- a/mm/bootmem.c~bootmem-clean-up-alloc_bootmem_core
+++ a/mm/bootmem.c
@@ -242,8 +242,9 @@ static void __init free_bootmem_core(boo
 	 * considered reserved.
 	 */
 
-	if (addr >= bdata->node_boot_start && addr < bdata->last_success)
-		bdata->last_success = addr;
+	if (addr >= bdata->node_boot_start &&
+			PFN_DOWN(addr - bdata->node_boot_start) < bdata->hint_idx)
+		bdata->hint_idx = PFN_DOWN(addr - bdata->node_boot_start);
 
 	/*
 	 * Round up to index to the range.
@@ -431,36 +432,16 @@ int __init reserve_bootmem(unsigned long
 }
 #endif /* !CONFIG_HAVE_ARCH_BOOTMEM_NODE */
 
-/*
- * We 'merge' subsequent allocations to save space. We might 'lose'
- * some fraction of a page if allocations cannot be satisfied due to
- * size constraints on boxes where there is physical RAM space
- * fragmentation - in these cases (mostly large memory boxes) this
- * is not a problem.
- *
- * On low memory boxes we get it right in 100% of the cases.
- *
- * alignment has to be a power of 2 value.
- *
- * NOTE:  This function is _not_ reentrant.
- */
-static void * __init
-alloc_bootmem_core(struct bootmem_data *bdata, unsigned long size,
-		unsigned long align, unsigned long goal, unsigned long limit)
-{
-	unsigned long areasize, preferred;
-	unsigned long i, start = 0, incr, eidx, end_pfn;
-	void *ret;
-	unsigned long node_boot_start;
-	void *node_bootmem_map;
-
-	if (!size) {
-		printk("alloc_bootmem_core(): zero-sized request\n");
-		BUG();
-	}
-	BUG_ON(align & (align-1));
+static void * __init alloc_bootmem_core(struct bootmem_data *bdata,
+				unsigned long size, unsigned long align,
+				unsigned long goal, unsigned long limit)
+{
+	unsigned long min, max, start, sidx, midx, step;
+
+	BUG_ON(!size);
+	BUG_ON(align & (align - 1));
+	BUG_ON(limit && goal + size > limit);
 
-	/* on nodes without memory - bootmem_map is NULL */
 	if (!bdata->node_bootmem_map)
 		return NULL;
 
@@ -468,126 +449,85 @@ alloc_bootmem_core(struct bootmem_data *
 		bdata - bootmem_node_data, size, PAGE_ALIGN(size) >> PAGE_SHIFT,
 		align, goal, limit);
 
-	/* bdata->node_boot_start is supposed to be (12+6)bits alignment on x86_64 ? */
-	node_boot_start = bdata->node_boot_start;
-	node_bootmem_map = bdata->node_bootmem_map;
-	if (align) {
-		node_boot_start = ALIGN(bdata->node_boot_start, align);
-		if (node_boot_start > bdata->node_boot_start)
-			node_bootmem_map = (unsigned long *)bdata->node_bootmem_map +
-			    PFN_DOWN(node_boot_start - bdata->node_boot_start)/BITS_PER_LONG;
-	}
+	min = PFN_DOWN(bdata->node_boot_start);
+	max = bdata->node_low_pfn;
+
+	goal >>= PAGE_SHIFT;
+	limit >>= PAGE_SHIFT;
 
-	if (limit && node_boot_start >= limit)
+	if (limit && max > limit)
+		max = limit;
+	if (max <= min)
 		return NULL;
 
-	end_pfn = bdata->node_low_pfn;
-	limit = PFN_DOWN(limit);
-	if (limit && end_pfn > limit)
-		end_pfn = limit;
+	step = max(align >> PAGE_SHIFT, 1UL);
 
-	eidx = end_pfn - PFN_DOWN(node_boot_start);
+	if (goal && min < goal && goal < max)
+		start = ALIGN(goal, step);
+	else
+		start = ALIGN(min, step);
 
-	/*
-	 * We try to allocate bootmem pages above 'goal'
-	 * first, then we try to allocate lower pages.
-	 */
-	preferred = 0;
-	if (goal && PFN_DOWN(goal) < end_pfn) {
-		if (goal > node_boot_start)
-			preferred = goal - node_boot_start;
-
-		if (bdata->last_success > node_boot_start &&
-			bdata->last_success - node_boot_start >= preferred)
-			if (!limit || (limit && limit > bdata->last_success))
-				preferred = bdata->last_success - node_boot_start;
-	}
+	sidx = start - PFN_DOWN(bdata->node_boot_start);
+	midx = max - PFN_DOWN(bdata->node_boot_start);
 
-	preferred = PFN_DOWN(ALIGN(preferred, align));
-	areasize = (size + PAGE_SIZE-1) / PAGE_SIZE;
-	incr = align >> PAGE_SHIFT ? : 1;
-
-restart_scan:
-	for (i = preferred; i < eidx;) {
-		unsigned long j;
-
-		i = find_next_zero_bit(node_bootmem_map, eidx, i);
-		i = ALIGN(i, incr);
-		if (i >= eidx)
+	if (bdata->hint_idx > sidx) {
+		/* Make sure we retry on failure */
+		goal = 1;
+		sidx = ALIGN(bdata->hint_idx, step);
+	}
+
+	while (1) {
+		int merge;
+		void *region;
+		unsigned long eidx, i, start_off, end_off;
+find_block:
+		sidx = find_next_zero_bit(bdata->node_bootmem_map, midx, sidx);
+		sidx = ALIGN(sidx, step);
+		eidx = sidx + PFN_UP(size);
+
+		if (sidx >= midx || eidx > midx)
 			break;
-		if (test_bit(i, node_bootmem_map)) {
-			i += incr;
-			continue;
-		}
-		for (j = i + 1; j < i + areasize; ++j) {
-			if (j >= eidx)
-				goto fail_block;
-			if (test_bit(j, node_bootmem_map))
-				goto fail_block;
-		}
-		start = i;
-		goto found;
-	fail_block:
-		i = ALIGN(j, incr);
-		if (i == j)
-			i += incr;
-	}
 
-	if (preferred > 0) {
-		preferred = 0;
-		goto restart_scan;
+		for (i = sidx; i < eidx; i++)
+			if (test_bit(i, bdata->node_bootmem_map)) {
+				sidx = ALIGN(i, step);
+				if (sidx == i)
+					sidx += step;
+				goto find_block;
+			}
+
+		if (bdata->last_end_off &&
+				PFN_DOWN(bdata->last_end_off) + 1 == sidx)
+			start_off = ALIGN(bdata->last_end_off, align);
+		else
+			start_off = PFN_PHYS(sidx);
+
+		merge = PFN_DOWN(start_off) < sidx;
+		end_off = start_off + size;
+
+		bdata->last_end_off = end_off;
+		bdata->hint_idx = PFN_UP(end_off);
+
+		/*
+		 * Reserve the area now:
+		 */
+		for (i = PFN_DOWN(start_off) + merge;
+				i < PFN_UP(end_off); i++)
+			if (test_and_set_bit(i, bdata->node_bootmem_map))
+				BUG();
+
+		region = phys_to_virt(bdata->node_boot_start + start_off);
+		memset(region, 0, size);
+		return region;
 	}
-	return NULL;
 
-found:
-	bdata->last_success = PFN_PHYS(start) + node_boot_start;
-	BUG_ON(start >= eidx);
-
-	/*
-	 * Is the next page of the previous allocation-end the start
-	 * of this allocation's buffer? If yes then we can 'merge'
-	 * the previous partial page with this allocation.
-	 */
-	if (align < PAGE_SIZE &&
-	    bdata->last_offset && bdata->last_pos+1 == start) {
-		unsigned long offset, remaining_size;
-		offset = ALIGN(bdata->last_offset, align);
-		BUG_ON(offset > PAGE_SIZE);
-		remaining_size = PAGE_SIZE - offset;
-		if (size < remaining_size) {
-			areasize = 0;
-			/* last_pos unchanged */
-			bdata->last_offset = offset + size;
-			ret = phys_to_virt(bdata->last_pos * PAGE_SIZE +
-					   offset + node_boot_start);
-		} else {
-			remaining_size = size - remaining_size;
-			areasize = (remaining_size + PAGE_SIZE-1) / PAGE_SIZE;
-			ret = phys_to_virt(bdata->last_pos * PAGE_SIZE +
-					   offset + node_boot_start);
-			bdata->last_pos = start + areasize - 1;
-			bdata->last_offset = remaining_size;
-		}
-		bdata->last_offset &= ~PAGE_MASK;
-	} else {
-		bdata->last_pos = start + areasize - 1;
-		bdata->last_offset = size & ~PAGE_MASK;
-		ret = phys_to_virt(start * PAGE_SIZE + node_boot_start);
+	if (goal) {
+		goal = 0;
+		sidx = 0;
+		goto find_block;
 	}
 
-	bdebug("nid=%td start=%lx end=%lx\n",
-		bdata - bootmem_node_data,
-		start + PFN_DOWN(bdata->node_boot_start),
-		start + areasize + PFN_DOWN(bdata->node_boot_start));
-
-	/*
-	 * Reserve the area now:
-	 */
-	for (i = start; i < start + areasize; i++)
-		if (unlikely(test_and_set_bit(i, node_bootmem_map)))
-			BUG();
-	memset(ret, 0, size);
-	return ret;
+	return NULL;
 }
 
 /**
_

Patches currently in -mm which might be from hannes@saeurebad.de are

origin.patch
linux-next.patch
git-xtensa.patch
documentation-update-codingstyle-tips-for-emacs-users-v2.patch
mm-more-likely-reclaim-madv_sequential-mappings.patch
mm-print-swapcache-page-count-in-show_swap_cache_info.patch
lib-generic-show_mem.patch
alpha-use-generic-show_mem.patch
avr32-use-generic-show_mem.patch
blackfin-use-generic-show_mem.patch
xtensa-use-generic-show_mem.patch
x86-use-generic-show_mem.patch
um-use-generic-show_mem.patch
sparc64-use-generic-show_mem.patch
sh-use-generic-show_mem.patch
s390-use-generic-show_mem.patch
powerpc-use-generic-show_mem.patch
mn10300-use-generic-show_mem.patch
h8300-use-generic-show_mem.patch
mips-use-generic-show_mem.patch
m68knommu-use-generic-show_mem.patch
m68k-use-generic-show_mem.patch
m32r-use-generic-show_mem.patch
frv-use-generic-show_mem.patch
cris-use-generic-show_mem.patch

