From: akpm@linux-foundation.org
Subject: + alloc_bootmem_core-fix-misaligned-allocation-of-1g-page.patch added to -mm tree
Date: Mon, 18 Aug 2008 14:18:53 -0700
Message-ID: <200808182118.m7ILIrxM013207@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39679 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752981AbYHRVS7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Aug 2008 17:18:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@saeurebad.de, andreas.herrmann3@amd.com


The patch titled
     bootmem: fix aligning of node-relative indexes and offsets
has been added to the -mm tree.  Its filename is
     alloc_bootmem_core-fix-misaligned-allocation-of-1g-page.patch

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
Subject: bootmem: fix aligning of node-relative indexes and offsets
From: Johannes Weiner <hannes@saeurebad.de>

needs changlelog and signoff.

Reviewed-and-tested-by: Andreas Herrmann <andreas.herrmann3@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/bootmem.c |   43 +++++++++++++++++++++++++++++++++++++------
 1 file changed, 37 insertions(+), 6 deletions(-)

diff -puN mm/bootmem.c~alloc_bootmem_core-fix-misaligned-allocation-of-1g-page mm/bootmem.c
--- a/mm/bootmem.c~alloc_bootmem_core-fix-misaligned-allocation-of-1g-page
+++ a/mm/bootmem.c
@@ -405,6 +405,30 @@ int __init reserve_bootmem(unsigned long
 }
 #endif /* !CONFIG_HAVE_ARCH_BOOTMEM_NODE */
 
+static unsigned long align_idx(struct bootmem_data *bdata, unsigned long idx,
+			unsigned long step)
+{
+	unsigned long base = bdata->node_min_pfn;
+
+	/*
+	 * Align the index with respect to the node start so that the
+	 * resulting absolute PFN (node-start + index) is properly
+	 * aligned.
+	 */
+
+	return ALIGN(base + idx, step) - base;
+}
+
+static unsigned long align_off(struct bootmem_data *bdata, unsigned long off,
+			unsigned long align)
+{
+	unsigned long base = PFN_PHYS(bdata->node_min_pfn);
+
+	/* Same as align_idx for byte offsets */
+
+	return ALIGN(base + off, align) - base;
+}
+
 static void * __init alloc_bootmem_core(struct bootmem_data *bdata,
 				unsigned long size, unsigned long align,
 				unsigned long goal, unsigned long limit)
@@ -441,16 +465,23 @@ static void * __init alloc_bootmem_core(
 	else
 		start = ALIGN(min, step);
 
-	sidx = start - bdata->node_min_pfn;;
+	sidx = start - bdata->node_min_pfn;
 	midx = max - bdata->node_min_pfn;
 
+	/*
+	 * Because the indexes are relative to the node, all alignment
+	 * below has to be done with respect to the node's start in
+	 * order to have the resulting PFNs and addresses properly
+	 * aligned.
+	 */
+
 	if (bdata->hint_idx > sidx) {
 		/*
 		 * Handle the valid case of sidx being zero and still
 		 * catch the fallback below.
 		 */
 		fallback = sidx + 1;
-		sidx = ALIGN(bdata->hint_idx, step);
+		sidx = align_idx(bdata, bdata->hint_idx, step);
 	}
 
 	while (1) {
@@ -459,7 +490,7 @@ static void * __init alloc_bootmem_core(
 		unsigned long eidx, i, start_off, end_off;
 find_block:
 		sidx = find_next_zero_bit(bdata->node_bootmem_map, midx, sidx);
-		sidx = ALIGN(sidx, step);
+		sidx = align_idx(bdata, sidx, step);
 		eidx = sidx + PFN_UP(size);
 
 		if (sidx >= midx || eidx > midx)
@@ -467,7 +498,7 @@ find_block:
 
 		for (i = sidx; i < eidx; i++)
 			if (test_bit(i, bdata->node_bootmem_map)) {
-				sidx = ALIGN(i, step);
+				sidx = align_idx(bdata, i, step);
 				if (sidx == i)
 					sidx += step;
 				goto find_block;
@@ -475,7 +506,7 @@ find_block:
 
 		if (bdata->last_end_off & (PAGE_SIZE - 1) &&
 				PFN_DOWN(bdata->last_end_off) + 1 == sidx)
-			start_off = ALIGN(bdata->last_end_off, align);
+			start_off = align_off(bdata, bdata->last_end_off, align);
 		else
 			start_off = PFN_PHYS(sidx);
 
@@ -499,7 +530,7 @@ find_block:
 	}
 
 	if (fallback) {
-		sidx = ALIGN(fallback - 1, step);
+		sidx = align_idx(bdata, fallback - 1, step);
 		fallback = 0;
 		goto find_block;
 	}
_

Patches currently in -mm which might be from hannes@saeurebad.de are

origin.patch
documentation-describe-bootmem_debug-kernel-parameter.patch
git-xtensa.patch
alloc_bootmem_core-fix-misaligned-allocation-of-1g-page.patch
bootmem-fix-aligning-of-node-relative-indexes-and-offsets.patch
vmscan-dont-accumulate-scan-pressure-on-unrelated-lists.patch
mm-more-likely-reclaim-madv_sequential-mappings.patch

