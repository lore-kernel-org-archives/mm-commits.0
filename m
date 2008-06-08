From: akpm@linux-foundation.org
Subject: + bootmem-factor-out-the-marking-of-a-pfn-range.patch added to -mm tree
Date: Sun, 08 Jun 2008 16:35:36 -0700
Message-ID: <200806082335.m58NZaxS025619@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46192 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754697AbYFHXkF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 8 Jun 2008 19:40:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@saeurebad.de, andi@firstfloor.org, mingo@elte.hu, yhlu.kernel@gmail.com


The patch titled
     bootmem: factor out the marking of a PFN range
has been added to the -mm tree.  Its filename is
     bootmem-factor-out-the-marking-of-a-pfn-range.patch

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
Subject: bootmem: factor out the marking of a PFN range
From: Johannes Weiner <hannes@saeurebad.de>

Introduce new helpers that mark a range that resides completely on a node
or node-agnostic ranges that might also span node boundaries.

The free/reserve API functions will then directly use these helpers.

Note that the free/reserve semantics become more strict: while the prior
code took basically arbitrary range arguments and marked the PFNs that
happen to fall into that range, the new code requires node-specific ranges
to be completely on the node.  The node-agnostic requests might span node
boundaries as long as the nodes are contiguous.

Passing ranges that do not satisfy these criteria is a bug.

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bootmem.h |    2 
 mm/bootmem.c            |  189 ++++++++++++++------------------------
 2 files changed, 71 insertions(+), 120 deletions(-)

diff -puN include/linux/bootmem.h~bootmem-factor-out-the-marking-of-a-pfn-range include/linux/bootmem.h
--- a/include/linux/bootmem.h~bootmem-factor-out-the-marking-of-a-pfn-range
+++ a/include/linux/bootmem.h
@@ -65,7 +65,7 @@ extern void free_bootmem(unsigned long a
 #define BOOTMEM_DEFAULT		0
 #define BOOTMEM_EXCLUSIVE	(1<<0)
 
-extern void reserve_bootmem_node(pg_data_t *pgdat,
+extern int reserve_bootmem_node(pg_data_t *pgdat,
 				 unsigned long physaddr,
 				 unsigned long size,
 				 int flags);
diff -puN mm/bootmem.c~bootmem-factor-out-the-marking-of-a-pfn-range mm/bootmem.c
--- a/mm/bootmem.c~bootmem-factor-out-the-marking-of-a-pfn-range
+++ a/mm/bootmem.c
@@ -234,6 +234,9 @@ static void __init __free(bootmem_data_t
 		sidx + PFN_DOWN(bdata->node_boot_start),
 		eidx + PFN_DOWN(bdata->node_boot_start));
 
+	if (bdata->hint_idx > sidx)
+		bdata->hint_idx = sidx;
+
 	for (idx = sidx; idx < eidx; idx++)
 		if (!test_and_clear_bit(idx, bdata->node_bootmem_map))
 			BUG();
@@ -263,40 +266,57 @@ static int __init __reserve(bootmem_data
 	return 0;
 }
 
-static void __init free_bootmem_core(bootmem_data_t *bdata, unsigned long addr,
-				     unsigned long size)
+static int __init mark_bootmem_node(bootmem_data_t *bdata,
+				unsigned long start, unsigned long end,
+				int reserve, int flags)
 {
 	unsigned long sidx, eidx;
-	unsigned long i;
 
-	BUG_ON(!size);
+	bdebug("nid=%d start=%lx end=%lx reserve=%d flags=%x\n",
+		bdata - bootmem_node_data, start, end, reserve, flags);
 
-	/* out range */
-	if (addr + size < bdata->node_boot_start ||
-		PFN_DOWN(addr) > bdata->node_low_pfn)
-		return;
-	/*
-	 * round down end of usable mem, partially free pages are
-	 * considered reserved.
-	 */
+	BUG_ON(start < PFN_DOWN(bdata->node_boot_start));
+	BUG_ON(end > bdata->node_low_pfn);
 
-	if (addr >= bdata->node_boot_start &&
-			PFN_DOWN(addr - bdata->node_boot_start) < bdata->hint_idx)
-		bdata->hint_idx = PFN_DOWN(addr - bdata->node_boot_start);
+	sidx = start - PFN_DOWN(bdata->node_boot_start);
+	eidx = end - PFN_DOWN(bdata->node_boot_start);
 
-	/*
-	 * Round up to index to the range.
-	 */
-	if (PFN_UP(addr) > PFN_DOWN(bdata->node_boot_start))
-		sidx = PFN_UP(addr) - PFN_DOWN(bdata->node_boot_start);
+	if (reserve)
+		return __reserve(bdata, sidx, eidx, flags);
 	else
-		sidx = 0;
+		__free(bdata, sidx, eidx);
+	return 0;
+}
+
+static int __init mark_bootmem(unsigned long start, unsigned long end,
+				int reserve, int flags)
+{
+	unsigned long pos;
+	bootmem_data_t *bdata;
+
+	pos = start;
+	list_for_each_entry(bdata, &bdata_list, list) {
+		int err;
+		unsigned long max;
 
-	eidx = PFN_DOWN(addr + size - bdata->node_boot_start);
-	if (eidx > bdata->node_low_pfn - PFN_DOWN(bdata->node_boot_start))
-		eidx = bdata->node_low_pfn - PFN_DOWN(bdata->node_boot_start);
+		if (pos < PFN_DOWN(bdata->node_boot_start)) {
+			BUG_ON(pos != start);
+			continue;
+		}
+
+		max = min(bdata->node_low_pfn, end);
+
+		err = mark_bootmem_node(bdata, pos, max, reserve, flags);
+		if (reserve && err) {
+			mark_bootmem(start, pos, 0, 0);
+			return err;
+		}
 
-	__free(bdata, sidx, eidx);
+		if (max == end)
+			return 0;
+		pos = bdata->node_low_pfn;
+	}
+	BUG();
 }
 
 /**
@@ -307,12 +327,17 @@ static void __init free_bootmem_core(boo
  *
  * Partial pages will be considered reserved and left as they are.
  *
- * Only physical pages that actually reside on @pgdat are marked.
+ * The range must reside completely on the specified node.
  */
 void __init free_bootmem_node(pg_data_t *pgdat, unsigned long physaddr,
 			      unsigned long size)
 {
-	free_bootmem_core(pgdat->bdata, physaddr, size);
+	unsigned long start, end;
+
+	start = PFN_UP(physaddr);
+	end = PFN_DOWN(physaddr + size);
+
+	mark_bootmem_node(pgdat->bdata, start, end, 0, 0);
 }
 
 /**
@@ -322,83 +347,16 @@ void __init free_bootmem_node(pg_data_t 
  *
  * Partial pages will be considered reserved and left as they are.
  *
- * All physical pages within the range are marked, no matter what
- * node they reside on.
+ * The range must be contiguous but may span node boundaries.
  */
 void __init free_bootmem(unsigned long addr, unsigned long size)
 {
-	bootmem_data_t *bdata;
-	list_for_each_entry(bdata, &bdata_list, list)
-		free_bootmem_core(bdata, addr, size);
-}
-
-/*
- * Marks a particular physical memory range as unallocatable. Usable RAM
- * might be used for boot-time allocations - or it might get added
- * to the free page pool later on.
- */
-static int __init can_reserve_bootmem_core(bootmem_data_t *bdata,
-			unsigned long addr, unsigned long size, int flags)
-{
-	unsigned long sidx, eidx;
-	unsigned long i;
-
-	BUG_ON(!size);
-
-	/* out of range, don't hold other */
-	if (addr + size < bdata->node_boot_start ||
-		PFN_DOWN(addr) > bdata->node_low_pfn)
-		return 0;
-
-	/*
-	 * Round up to index to the range.
-	 */
-	if (addr > bdata->node_boot_start)
-		sidx= PFN_DOWN(addr - bdata->node_boot_start);
-	else
-		sidx = 0;
-
-	eidx = PFN_UP(addr + size - bdata->node_boot_start);
-	if (eidx > bdata->node_low_pfn - PFN_DOWN(bdata->node_boot_start))
-		eidx = bdata->node_low_pfn - PFN_DOWN(bdata->node_boot_start);
-
-	for (i = sidx; i < eidx; i++) {
-		if (test_bit(i, bdata->node_bootmem_map)) {
-			if (flags & BOOTMEM_EXCLUSIVE)
-				return -EBUSY;
-		}
-	}
-
-	return 0;
-
-}
-
-static void __init reserve_bootmem_core(bootmem_data_t *bdata,
-			unsigned long addr, unsigned long size, int flags)
-{
-	unsigned long sidx, eidx;
-	unsigned long i;
-
-	BUG_ON(!size);
+	unsigned long start, end;
 
-	/* out of range */
-	if (addr + size < bdata->node_boot_start ||
-		PFN_DOWN(addr) > bdata->node_low_pfn)
-		return;
+	start = PFN_UP(addr);
+	end = PFN_DOWN(addr + size);
 
-	/*
-	 * Round up to index to the range.
-	 */
-	if (addr > bdata->node_boot_start)
-		sidx= PFN_DOWN(addr - bdata->node_boot_start);
-	else
-		sidx = 0;
-
-	eidx = PFN_UP(addr + size - bdata->node_boot_start);
-	if (eidx > bdata->node_low_pfn - PFN_DOWN(bdata->node_boot_start))
-		eidx = bdata->node_low_pfn - PFN_DOWN(bdata->node_boot_start);
-
-	return __reserve(bdata, sidx, eidx, flags);
+	mark_bootmem(start, end, 0, 0);
 }
 
 /**
@@ -410,17 +368,17 @@ static void __init reserve_bootmem_core(
  *
  * Partial pages will be reserved.
  *
- * Only physical pages that actually reside on @pgdat are marked.
+ * The range must reside completely on the specified node.
  */
-void __init reserve_bootmem_node(pg_data_t *pgdat, unsigned long physaddr,
+int __init reserve_bootmem_node(pg_data_t *pgdat, unsigned long physaddr,
 				 unsigned long size, int flags)
 {
-	int ret;
+	unsigned long start, end;
 
-	ret = can_reserve_bootmem_core(pgdat->bdata, physaddr, size, flags);
-	if (ret < 0)
-		return;
-	reserve_bootmem_core(pgdat->bdata, physaddr, size, flags);
+	start = PFN_DOWN(physaddr);
+	end = PFN_UP(physaddr + size);
+
+	return mark_bootmem_node(pgdat->bdata, start, end, 1, flags);
 }
 
 #ifndef CONFIG_HAVE_ARCH_BOOTMEM_NODE
@@ -432,24 +390,17 @@ void __init reserve_bootmem_node(pg_data
  *
  * Partial pages will be reserved.
  *
- * All physical pages within the range are marked, no matter what
- * node they reside on.
+ * The range must be contiguous but may span node boundaries.
  */
 int __init reserve_bootmem(unsigned long addr, unsigned long size,
 			    int flags)
 {
-	bootmem_data_t *bdata;
-	int ret;
+	unsigned long start, end;
 
-	list_for_each_entry(bdata, &bdata_list, list) {
-		ret = can_reserve_bootmem_core(bdata, addr, size, flags);
-		if (ret < 0)
-			return ret;
-	}
-	list_for_each_entry(bdata, &bdata_list, list)
-		reserve_bootmem_core(bdata, addr, size, flags);
+	start = PFN_DOWN(addr);
+	end = PFN_UP(addr + size);
 
-	return 0;
+	return mark_bootmem(start, end, 1, flags);
 }
 #endif /* !CONFIG_HAVE_ARCH_BOOTMEM_NODE */
 
@@ -662,7 +613,7 @@ void * __init alloc_bootmem_section(unsi
 	if (start_nr != section_nr || end_nr != section_nr) {
 		printk(KERN_WARNING "alloc_bootmem failed on section %ld.\n",
 		       section_nr);
-		free_bootmem_core(pgdat->bdata, __pa(ptr), size);
+		free_bootmem_node(pgdat, __pa(ptr), size);
 		ptr = NULL;
 	}
 
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

