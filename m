From: akpm@linux-foundation.org
Subject: + bootmem-fix-aligning-of-node-relative-indexes-and-offsets.patch added to -mm tree
Date: Wed, 13 Aug 2008 17:23:56 -0700
Message-ID: <200808140023.m7E0NuRB014076@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53209 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752701AbYHNAYd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Aug 2008 20:24:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@saeurebad.de, andreas.herrmann3@amd.com


The patch titled
     bootmem: fix aligning of node-relative indexes and offsets
has been added to the -mm tree.  Its filename is
     bootmem-fix-aligning-of-node-relative-indexes-and-offsets.patch

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

Absolute alignment requirements may never be applied to node-relative
offsets.  Andreas Herrmann spotted this flaw when a bootmem allocation on
an unaligned node was itself not aligned because the combination of an
unaligned node with an aligned offset into that node is not garuanteed to
be aligned itself.

This patch introduces two helper functions that align a node-relative
index or offset with respect to the node's starting address so that the
absolute PFN or virtual address that results from combining the two
satisfies the requested alignment.

Then all the broken ALIGN()s in alloc_bootmem_core() are replaced by these
helpers.

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
Reported-by: Andreas Herrmann <andreas.herrmann3@amd.com>
Debugged-by: Andreas Herrmann <andreas.herrmann3@amd.com>
Reviewed-by: Andreas Herrmann <andreas.herrmann3@amd.com>
Tested-by: Andreas Herrmann <andreas.herrmann3@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/bootmem.c |   35 +++++++++++++++++++++++++++++------
 1 file changed, 29 insertions(+), 6 deletions(-)

diff -puN mm/bootmem.c~bootmem-fix-aligning-of-node-relative-indexes-and-offsets mm/bootmem.c
--- a/mm/bootmem.c~bootmem-fix-aligning-of-node-relative-indexes-and-offsets
+++ a/mm/bootmem.c
@@ -405,6 +405,29 @@ int __init reserve_bootmem(unsigned long
 }
 #endif /* !CONFIG_HAVE_ARCH_BOOTMEM_NODE */
 
+static unsigned long align_idx(struct bootmem_data *bdata, unsigned long idx,
+			unsigned long step)
+{
+	unsigned long base = bdata->node_min_pfn;
+
+	/*
+	 * Align the index with respect to the node start so that the
+	 * combination of both satisfies the requested alignment.
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
@@ -441,7 +464,7 @@ static void * __init alloc_bootmem_core(
 	else
 		start = ALIGN(min, step);
 
-	sidx = start - bdata->node_min_pfn;;
+	sidx = start - bdata->node_min_pfn;
 	midx = max - bdata->node_min_pfn;
 
 	if (bdata->hint_idx > sidx) {
@@ -450,7 +473,7 @@ static void * __init alloc_bootmem_core(
 		 * catch the fallback below.
 		 */
 		fallback = sidx + 1;
-		sidx = ALIGN(bdata->hint_idx, step);
+		sidx = align_idx(bdata, bdata->hint_idx, step);
 	}
 
 	while (1) {
@@ -459,7 +482,7 @@ static void * __init alloc_bootmem_core(
 		unsigned long eidx, i, start_off, end_off;
 find_block:
 		sidx = find_next_zero_bit(bdata->node_bootmem_map, midx, sidx);
-		sidx = ALIGN(sidx, step);
+		sidx = align_idx(bdata, sidx, step);
 		eidx = sidx + PFN_UP(size);
 
 		if (sidx >= midx || eidx > midx)
@@ -467,7 +490,7 @@ find_block:
 
 		for (i = sidx; i < eidx; i++)
 			if (test_bit(i, bdata->node_bootmem_map)) {
-				sidx = ALIGN(i, step);
+				sidx = align_idx(bdata, i, step);
 				if (sidx == i)
 					sidx += step;
 				goto find_block;
@@ -475,7 +498,7 @@ find_block:
 
 		if (bdata->last_end_off &&
 				PFN_DOWN(bdata->last_end_off) + 1 == sidx)
-			start_off = ALIGN(bdata->last_end_off, align);
+			start_off = align_off(bdata, bdata->last_end_off, align);
 		else
 			start_off = PFN_PHYS(sidx);
 
@@ -499,7 +522,7 @@ find_block:
 	}
 
 	if (fallback) {
-		sidx = ALIGN(fallback - 1, step);
+		sidx = align_idx(bdata, fallback - 1, step);
 		fallback = 0;
 		goto find_block;
 	}
_

Patches currently in -mm which might be from hannes@saeurebad.de are

git-xtensa.patch
bootmem-fix-aligning-of-node-relative-indexes-and-offsets.patch
vmscan-dont-accumulate-scan-pressure-on-unrelated-lists.patch
mm-more-likely-reclaim-madv_sequential-mappings.patch

