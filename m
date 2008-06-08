From: akpm@linux-foundation.org
Subject: + bootmem-respect-goal-more-likely.patch added to -mm tree
Date: Sun, 08 Jun 2008 16:35:39 -0700
Message-ID: <200806082335.m58NZdLw025625@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40864 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752784AbYFHXlC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 8 Jun 2008 19:41:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@saeurebad.de, andi@firstfloor.org, mingo@elte.hu, y-goto@jp.fujitsu.com, yhlu.kernel@gmail.com


The patch titled
     bootmem: respect goal more likely
has been added to the -mm tree.  Its filename is
     bootmem-respect-goal-more-likely.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

git-xtensa.patch
mm-move-bootmem-descriptors-definition-to-a-single-place.patch
mm-fix-free_all_bootmem_core-alignment-check.patch
mm-normalize-internal-argument-passing-of-bootmem-data.patch
mm-unexport-__alloc_bootmem_core.patch
mm-drop-unneeded-pgdat-argument-from-free_area_init_node.patch
hugetlb-guarantee-that-cow-faults-for-a-process-that-called-mmapmap_private-on-hugetlbfs-will-succeed-fix.patch
huge-page-private-reservation-review-cleanups.patch
huge-page-private-reservation-review-cleanups-fix.patch
mm-record-map_noreserve-status-on-vmas-and-fix-small-page-mprotect-reservations.patch
hugetlb-move-reservation-region-support-earlier.patch
hugetlb-allow-huge-page-mappings-to-be-created-without-reservations.patch
hugetlb-allow-huge-page-mappings-to-be-created-without-reservations-cleanups.patch
bootmem-reorder-code-to-match-new-bootmem-structure.patch
bootmem-clean-up-bootmemc-file-header.patch
bootmem-add-documentation-to-api-functions.patch
bootmem-add-debugging-framework.patch
bootmem-revisit-bitmap-size-calculations.patch
bootmem-revisit-bootmem-descriptor-list-handling.patch
bootmem-clean-up-free_all_bootmem_core.patch
bootmem-clean-up-alloc_bootmem_core.patch
bootmem-free-reserve-helpers.patch
bootmem-factor-out-the-marking-of-a-pfn-range.patch
bootmem-respect-goal-more-likely.patch
bootmem-make-__alloc_bootmem_low_node-fall-back-to-other-nodes.patch
bootmem-revisit-alloc_bootmem_section.patch
bootmem-replace-node_boot_start-in-struct-bootmem_data.patch

