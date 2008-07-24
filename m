From: akpm@linux-foundation.org
Subject: - bootmem-respect-goal-more-likely.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:24:08 -0700
Message-ID: <200807242324.m6ONO8rN010755@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53030 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754918AbYGXXY1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:24:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@saeurebad.de, andi@firstfloor.org, mingo@elte.hu, y-goto@jp.fujitsu.com, yhlu.kernel@gmail.com, mm-commits@vger.kernel.org


The patch titled
     bootmem: respect goal more likely
has been removed from the -mm tree.  Its filename was
     bootmem-respect-goal-more-likely.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: bootmem: respect goal more likely
From: Johannes Weiner <hannes@saeurebad.de>

The old node-agnostic code tried allocating on all nodes starting from the
one with the lowest range.  alloc_bootmem_core retried without the goal if
it could not satisfy it and so the goal was only respected at all when it
happened to be on the first (lowest page numbers) node (or theoretically
if allocations failed on all nodes before to the one holding the goal).

Introduce a non-panicking helper that starts allocating from the node
holding the goal and falls back only after all thes tries failed, thus
moving the goal fallback code out of alloc_bootmem_core.

Make all other allocation functions benefit from this new helper.

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/bootmem.c |   92 ++++++++++++++++++++++++++++---------------------
 1 file changed, 54 insertions(+), 38 deletions(-)

diff -puN mm/bootmem.c~bootmem-respect-goal-more-likely mm/bootmem.c
--- a/mm/bootmem.c~bootmem-respect-goal-more-likely
+++ a/mm/bootmem.c
@@ -408,6 +408,7 @@ static void * __init alloc_bootmem_core(
 				unsigned long size, unsigned long align,
 				unsigned long goal, unsigned long limit)
 {
+	unsigned long fallback = 0;
 	unsigned long min, max, start, sidx, midx, step;
 
 	BUG_ON(!size);
@@ -443,8 +444,11 @@ static void * __init alloc_bootmem_core(
 	midx = max - PFN_DOWN(bdata->node_boot_start);
 
 	if (bdata->hint_idx > sidx) {
-		/* Make sure we retry on failure */
-		goal = 1;
+		/*
+		 * Handle the valid case of sidx being zero and still
+		 * catch the fallback below.
+		 */
+		fallback = sidx + 1;
 		sidx = ALIGN(bdata->hint_idx, step);
 	}
 
@@ -492,10 +496,39 @@ find_block:
 		return region;
 	}
 
+	if (fallback) {
+		sidx = ALIGN(fallback - 1, step);
+		fallback = 0;
+		goto find_block;
+	}
+
+	return NULL;
+}
+
+static void * __init ___alloc_bootmem_nopanic(unsigned long size,
+					unsigned long align,
+					unsigned long goal,
+					unsigned long limit)
+{
+	bootmem_data_t *bdata;
+
+restart:
+	list_for_each_entry(bdata, &bdata_list, list) {
+		void *region;
+
+		if (goal && bdata->node_low_pfn <= PFN_DOWN(goal))
+			continue;
+		if (limit && bdata->node_boot_start >= limit)
+			break;
+
+		region = alloc_bootmem_core(bdata, size, align, goal, limit);
+		if (region)
+			return region;
+	}
+
 	if (goal) {
 		goal = 0;
-		sidx = 0;
-		goto find_block;
+		goto restart;
 	}
 
 	return NULL;
@@ -515,16 +548,23 @@ find_block:
  * Returns NULL on failure.
  */
 void * __init __alloc_bootmem_nopanic(unsigned long size, unsigned long align,
-				      unsigned long goal)
+					unsigned long goal)
 {
-	bootmem_data_t *bdata;
-	void *ptr;
+	return ___alloc_bootmem_nopanic(size, align, goal, 0);
+}
 
-	list_for_each_entry(bdata, &bdata_list, list) {
-		ptr = alloc_bootmem_core(bdata, size, align, goal, 0);
-		if (ptr)
-			return ptr;
-	}
+static void * __init ___alloc_bootmem(unsigned long size, unsigned long align,
+					unsigned long goal, unsigned long limit)
+{
+	void *mem = ___alloc_bootmem_nopanic(size, align, goal, limit);
+
+	if (mem)
+		return mem;
+	/*
+	 * Whoops, we cannot satisfy the allocation request.
+	 */
+	printk(KERN_ALERT "bootmem alloc of %lu bytes failed!\n", size);
+	panic("Out of memory");
 	return NULL;
 }
 
@@ -544,16 +584,7 @@ void * __init __alloc_bootmem_nopanic(un
 void * __init __alloc_bootmem(unsigned long size, unsigned long align,
 			      unsigned long goal)
 {
-	void *mem = __alloc_bootmem_nopanic(size,align,goal);
-
-	if (mem)
-		return mem;
-	/*
-	 * Whoops, we cannot satisfy the allocation request.
-	 */
-	printk(KERN_ALERT "bootmem alloc of %lu bytes failed!\n", size);
-	panic("Out of memory");
-	return NULL;
+	return ___alloc_bootmem(size, align, goal, 0);
 }
 
 /**
@@ -653,22 +684,7 @@ void * __init __alloc_bootmem_node_nopan
 void * __init __alloc_bootmem_low(unsigned long size, unsigned long align,
 				  unsigned long goal)
 {
-	bootmem_data_t *bdata;
-	void *ptr;
-
-	list_for_each_entry(bdata, &bdata_list, list) {
-		ptr = alloc_bootmem_core(bdata, size, align, goal,
-					ARCH_LOW_ADDRESS_LIMIT);
-		if (ptr)
-			return ptr;
-	}
-
-	/*
-	 * Whoops, we cannot satisfy the allocation request.
-	 */
-	printk(KERN_ALERT "low bootmem alloc of %lu bytes failed!\n", size);
-	panic("Out of low memory");
-	return NULL;
+	return ___alloc_bootmem(size, align, goal, ARCH_LOW_ADDRESS_LIMIT);
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

