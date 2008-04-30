From: akpm@linux-foundation.org
Subject: + mm-unexport-__alloc_bootmem_core.patch added to -mm tree
Date: Wed, 30 Apr 2008 12:30:09 -0700
Message-ID: <200804301930.m3UJU9vK031167@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56686 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760714AbYD3Tao (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 15:30:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@saeurebad.de, apw@shadowen.org, clameter@sgi.com, mel@csn.ul.ie, mingo@elte.hu, yhlu.kernel@gmail.com


The patch titled
     mm: unexport __alloc_bootmem_core()
has been added to the -mm tree.  Its filename is
     mm-unexport-__alloc_bootmem_core.patch

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
Subject: mm: unexport __alloc_bootmem_core()
From: Johannes Weiner <hannes@saeurebad.de>

This function has no external callers, so unexport it.  Also fix its naming
inconsistency.

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Andy Whitcroft <apw@shadowen.org>
Cc: Christoph Lameter <clameter@sgi.com>
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
@@ -510,7 +510,7 @@ void * __init __alloc_bootmem_nopanic(un
 	void *ptr;
 
 	list_for_each_entry(bdata, &bdata_list, list) {
-		ptr = __alloc_bootmem_core(bdata, size, align, goal, 0);
+		ptr = alloc_bootmem_core(bdata, size, align, goal, 0);
 		if (ptr)
 			return ptr;
 	}
@@ -538,7 +538,7 @@ void * __init __alloc_bootmem_node(pg_da
 {
 	void *ptr;
 
-	ptr = __alloc_bootmem_core(pgdat->bdata, size, align, goal, 0);
+	ptr = alloc_bootmem_core(pgdat->bdata, size, align, goal, 0);
 	if (ptr)
 		return ptr;
 
@@ -557,8 +557,8 @@ void * __init alloc_bootmem_section(unsi
 	goal = PFN_PHYS(pfn);
 	limit = PFN_PHYS(section_nr_to_pfn(section_nr + 1)) - 1;
 	pgdat = NODE_DATA(early_pfn_to_nid(pfn));
-	ptr = __alloc_bootmem_core(pgdat->bdata, size, SMP_CACHE_BYTES, goal,
-				   limit);
+	ptr = alloc_bootmem_core(pgdat->bdata, size, SMP_CACHE_BYTES, goal,
+				limit);
 
 	if (!ptr)
 		return NULL;
@@ -587,8 +587,8 @@ void * __init __alloc_bootmem_low(unsign
 	void *ptr;
 
 	list_for_each_entry(bdata, &bdata_list, list) {
-		ptr = __alloc_bootmem_core(bdata, size, align, goal,
-						ARCH_LOW_ADDRESS_LIMIT);
+		ptr = alloc_bootmem_core(bdata, size, align, goal,
+					ARCH_LOW_ADDRESS_LIMIT);
 		if (ptr)
 			return ptr;
 	}
@@ -604,6 +604,6 @@ void * __init __alloc_bootmem_low(unsign
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
git-mips.patch
parisc-remove-redundant-display-of-free-swap-space-in-show_mem.patch
git-xtensa.patch
mm-move-bootmem-descriptors-definition-to-a-single-place.patch
mm-fix-free_all_bootmem_core-alignment-check.patch
mm-normalize-internal-argument-passing-of-bootmem-data.patch
mm-unexport-__alloc_bootmem_core.patch

