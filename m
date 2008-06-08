From: akpm@linux-foundation.org
Subject: + bootmem-free-reserve-helpers.patch added to -mm tree
Date: Sun, 08 Jun 2008 16:35:34 -0700
Message-ID: <200806082335.m58NZYdr025616@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36301 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757092AbYFHXg4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 8 Jun 2008 19:36:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@saeurebad.de, andi@firstfloor.org, mingo@elte.hu, yhlu.kernel@gmail.com


The patch titled
     bootmem: free/reserve helpers
has been added to the -mm tree.  Its filename is
     bootmem-free-reserve-helpers.patch

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
Subject: bootmem: free/reserve helpers
From: Johannes Weiner <hannes@saeurebad.de>

Factor out the common operation of marking a range on the bitmap.

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/bootmem.c |   65 ++++++++++++++++++++++++++++++++-----------------
 1 file changed, 43 insertions(+), 22 deletions(-)

diff -puN mm/bootmem.c~bootmem-free-reserve-helpers mm/bootmem.c
--- a/mm/bootmem.c~bootmem-free-reserve-helpers
+++ a/mm/bootmem.c
@@ -225,6 +225,44 @@ unsigned long __init free_all_bootmem(vo
 	return free_all_bootmem_core(NODE_DATA(0)->bdata);
 }
 
+static void __init __free(bootmem_data_t *bdata,
+			unsigned long sidx, unsigned long eidx)
+{
+	unsigned long idx;
+
+	bdebug("nid=%d start=%lx end=%lx\n", bdata - bootmem_node_data,
+		sidx + PFN_DOWN(bdata->node_boot_start),
+		eidx + PFN_DOWN(bdata->node_boot_start));
+
+	for (idx = sidx; idx < eidx; idx++)
+		if (!test_and_clear_bit(idx, bdata->node_bootmem_map))
+			BUG();
+}
+
+static int __init __reserve(bootmem_data_t *bdata, unsigned long sidx,
+			unsigned long eidx, int flags)
+{
+	unsigned long idx;
+	int exclusive = flags & BOOTMEM_EXCLUSIVE;
+
+	bdebug("nid=%d start=%lx end=%lx flags=%x\n",
+		bdata - bootmem_node_data,
+		sidx + PFN_DOWN(bdata->node_boot_start),
+		eidx + PFN_DOWN(bdata->node_boot_start),
+		flags);
+
+	for (idx = sidx; idx < eidx; idx++)
+		if (test_and_set_bit(idx, bdata->node_bootmem_map)) {
+			if (exclusive) {
+				__free(bdata, sidx, idx);
+				return -EBUSY;
+			}
+			bdebug("silent double reserve of PFN %lx\n",
+				idx + PFN_DOWN(bdata->node_boot_start));
+		}
+	return 0;
+}
+
 static void __init free_bootmem_core(bootmem_data_t *bdata, unsigned long addr,
 				     unsigned long size)
 {
@@ -258,14 +296,7 @@ static void __init free_bootmem_core(boo
 	if (eidx > bdata->node_low_pfn - PFN_DOWN(bdata->node_boot_start))
 		eidx = bdata->node_low_pfn - PFN_DOWN(bdata->node_boot_start);
 
-	bdebug("nid=%d start=%lx end=%lx\n", bdata - bootmem_node_data,
-		sidx + PFN_DOWN(bdata->node_boot_start),
-		eidx + PFN_DOWN(bdata->node_boot_start));
-
-	for (i = sidx; i < eidx; i++) {
-		if (unlikely(!test_and_clear_bit(i, bdata->node_bootmem_map)))
-			BUG();
-	}
+	__free(bdata, sidx, eidx);
 }
 
 /**
@@ -367,16 +398,7 @@ static void __init reserve_bootmem_core(
 	if (eidx > bdata->node_low_pfn - PFN_DOWN(bdata->node_boot_start))
 		eidx = bdata->node_low_pfn - PFN_DOWN(bdata->node_boot_start);
 
-	bdebug("nid=%d start=%lx end=%lx flags=%x\n",
-		bdata - bootmem_node_data,
-		sidx + PFN_DOWN(bdata->node_boot_start),
-		eidx + PFN_DOWN(bdata->node_boot_start),
-		flags);
-
-	for (i = sidx; i < eidx; i++)
-		if (test_and_set_bit(i, bdata->node_bootmem_map))
-			bdebug("hm, page %lx reserved twice.\n",
-				PFN_DOWN(bdata->node_boot_start) + i);
+	return __reserve(bdata, sidx, eidx, flags);
 }
 
 /**
@@ -510,10 +532,9 @@ find_block:
 		/*
 		 * Reserve the area now:
 		 */
-		for (i = PFN_DOWN(start_off) + merge;
-				i < PFN_UP(end_off); i++)
-			if (test_and_set_bit(i, bdata->node_bootmem_map))
-				BUG();
+		if (__reserve(bdata, PFN_DOWN(start_off) + merge,
+				PFN_UP(end_off), BOOTMEM_EXCLUSIVE))
+			BUG();
 
 		region = phys_to_virt(bdata->node_boot_start + start_off);
 		memset(region, 0, size);
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

