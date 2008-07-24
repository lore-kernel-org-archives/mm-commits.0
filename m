From: akpm@linux-foundation.org
Subject: - mm-unexport-__alloc_bootmem_core.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:21:14 -0700
Message-ID: <200807242321.m6ONLE2Y010387@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52540 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753915AbYGXXVn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:21:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@saeurebad.de, apw@shadowen.org, cl@linux-foundation.org, mel@csn.ul.ie, mingo@elte.hu, yhlu.kernel@gmail.com, mm-commits@vger.kernel.org


The patch titled
     mm: unexport __alloc_bootmem_core()
has been removed from the -mm tree.  Its filename was
     mm-unexport-__alloc_bootmem_core.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: unexport __alloc_bootmem_core()
From: Johannes Weiner <hannes@saeurebad.de>

This function has no external callers, so unexport it.  Also fix its naming
inconsistency.

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Andy Whitcroft <apw@shadowen.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bootmem.h |    5 -----
 mm/bootmem.c            |   24 ++++++++++++------------
 2 files changed, 12 insertions(+), 17 deletions(-)

diff -puN include/linux/bootmem.h~mm-unexport-__alloc_bootmem_core include/linux/bootmem.h
--- a/include/linux/bootmem.h~mm-unexport-__alloc_bootmem_core
+++ a/include/linux/bootmem.h
@@ -56,11 +56,6 @@ extern void *__alloc_bootmem_low_node(pg
 				      unsigned long size,
 				      unsigned long align,
 				      unsigned long goal);
-extern void *__alloc_bootmem_core(struct bootmem_data *bdata,
-				  unsigned long size,
-				  unsigned long align,
-				  unsigned long goal,
-				  unsigned long limit);
 
 /*
  * flags for reserve_bootmem (also if CONFIG_HAVE_ARCH_BOOTMEM_NODE,
diff -puN mm/bootmem.c~mm-unexport-__alloc_bootmem_core mm/bootmem.c
--- a/mm/bootmem.c~mm-unexport-__alloc_bootmem_core
+++ a/mm/bootmem.c
@@ -234,9 +234,9 @@ static void __init free_bootmem_core(boo
  *
  * NOTE:  This function is _not_ reentrant.
  */
-void * __init
-__alloc_bootmem_core(struct bootmem_data *bdata, unsigned long size,
-	      unsigned long align, unsigned long goal, unsigned long limit)
+static void * __init
+alloc_bootmem_core(struct bootmem_data *bdata, unsigned long size,
+		unsigned long align, unsigned long goal, unsigned long limit)
 {
 	unsigned long areasize, preferred;
 	unsigned long i, start = 0, incr, eidx, end_pfn;
@@ -245,7 +245,7 @@ __alloc_bootmem_core(struct bootmem_data
 	void *node_bootmem_map;
 
 	if (!size) {
-		printk("__alloc_bootmem_core(): zero-sized request\n");
+		printk("alloc_bootmem_core(): zero-sized request\n");
 		BUG();
 	}
 	BUG_ON(align & (align-1));
@@ -512,7 +512,7 @@ void * __init __alloc_bootmem_nopanic(un
 	void *ptr;
 
 	list_for_each_entry(bdata, &bdata_list, list) {
-		ptr = __alloc_bootmem_core(bdata, size, align, goal, 0);
+		ptr = alloc_bootmem_core(bdata, size, align, goal, 0);
 		if (ptr)
 			return ptr;
 	}
@@ -540,7 +540,7 @@ void * __init __alloc_bootmem_node(pg_da
 {
 	void *ptr;
 
-	ptr = __alloc_bootmem_core(pgdat->bdata, size, align, goal, 0);
+	ptr = alloc_bootmem_core(pgdat->bdata, size, align, goal, 0);
 	if (ptr)
 		return ptr;
 
@@ -559,8 +559,8 @@ void * __init alloc_bootmem_section(unsi
 	goal = PFN_PHYS(pfn);
 	limit = PFN_PHYS(section_nr_to_pfn(section_nr + 1)) - 1;
 	pgdat = NODE_DATA(early_pfn_to_nid(pfn));
-	ptr = __alloc_bootmem_core(pgdat->bdata, size, SMP_CACHE_BYTES, goal,
-				   limit);
+	ptr = alloc_bootmem_core(pgdat->bdata, size, SMP_CACHE_BYTES, goal,
+				limit);
 
 	if (!ptr)
 		return NULL;
@@ -589,8 +589,8 @@ void * __init __alloc_bootmem_low(unsign
 	void *ptr;
 
 	list_for_each_entry(bdata, &bdata_list, list) {
-		ptr = __alloc_bootmem_core(bdata, size, align, goal,
-						ARCH_LOW_ADDRESS_LIMIT);
+		ptr = alloc_bootmem_core(bdata, size, align, goal,
+					ARCH_LOW_ADDRESS_LIMIT);
 		if (ptr)
 			return ptr;
 	}
@@ -606,6 +606,6 @@ void * __init __alloc_bootmem_low(unsign
 void * __init __alloc_bootmem_low_node(pg_data_t *pgdat, unsigned long size,
 				       unsigned long align, unsigned long goal)
 {
-	return __alloc_bootmem_core(pgdat->bdata, size, align, goal,
-				    ARCH_LOW_ADDRESS_LIMIT);
+	return alloc_bootmem_core(pgdat->bdata, size, align, goal,
+				ARCH_LOW_ADDRESS_LIMIT);
 }
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

