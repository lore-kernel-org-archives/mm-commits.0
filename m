From: akpm@linux-foundation.org
Subject: - bootmem-free-reserve-helpers.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:24:04 -0700
Message-ID: <200807242324.m6ONO40H010748@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37092 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754902AbYGXXYY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:24:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@saeurebad.de, andi@firstfloor.org, mingo@elte.hu, yhlu.kernel@gmail.com, mm-commits@vger.kernel.org


The patch titled
     bootmem: free/reserve helpers
has been removed from the -mm tree.  Its filename was
     bootmem-free-reserve-helpers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: bootmem: free/reserve helpers
From: Johannes Weiner <hannes@saeurebad.de>

Factor out the common operation of marking a range on the bitmap.

[akpm@linux-foundation.org: fix various warnings]
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
+	bdebug("nid=%td start=%lx end=%lx\n", bdata - bootmem_node_data,
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
+	bdebug("nid=%td start=%lx end=%lx flags=%x\n",
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
 
-	bdebug("nid=%td start=%lx end=%lx\n", bdata - bootmem_node_data,
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
 
-	bdebug("nid=%td start=%lx end=%lx flags=%x\n",
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
@@ -511,10 +533,9 @@ find_block:
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

