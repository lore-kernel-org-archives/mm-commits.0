From: akpm@linux-foundation.org
Subject: + bootmem-reorder-code-to-match-new-bootmem-structure.patch added to -mm tree
Date: Sun, 08 Jun 2008 16:35:13 -0700
Message-ID: <200806082335.m58NZDLd025589@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34563 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752784AbYFHXfr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 8 Jun 2008 19:35:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@saeurebad.de


The patch titled
     bootmem: reorder code to match new bootmem structure
has been added to the -mm tree.  Its filename is
     bootmem-reorder-code-to-match-new-bootmem-structure.patch

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
Subject: bootmem: reorder code to match new bootmem structure
From: Johannes Weiner <hannes@saeurebad.de>

This only reorders functions so that further patches will be easier to
read.  No code changed.

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bootmem.h |   85 ++++-----
 mm/bootmem.c            |  351 ++++++++++++++++++--------------------
 2 files changed, 219 insertions(+), 217 deletions(-)

diff -puN include/linux/bootmem.h~bootmem-reorder-code-to-match-new-bootmem-structure include/linux/bootmem.h
--- a/include/linux/bootmem.h~bootmem-reorder-code-to-match-new-bootmem-structure
+++ a/include/linux/bootmem.h
@@ -41,36 +41,62 @@ typedef struct bootmem_data {
 extern bootmem_data_t bootmem_node_data[];
 
 extern unsigned long bootmem_bootmap_pages(unsigned long);
+
+extern unsigned long init_bootmem_node(pg_data_t *pgdat,
+				       unsigned long freepfn,
+				       unsigned long startpfn,
+				       unsigned long endpfn);
 extern unsigned long init_bootmem(unsigned long addr, unsigned long memend);
+
+extern unsigned long free_all_bootmem_node(pg_data_t *pgdat);
+extern unsigned long free_all_bootmem(void);
+
+extern void free_bootmem_node(pg_data_t *pgdat,
+			      unsigned long addr,
+			      unsigned long size);
 extern void free_bootmem(unsigned long addr, unsigned long size);
-extern void *__alloc_bootmem(unsigned long size,
+
+/*
+ * Flags for reserve_bootmem (also if CONFIG_HAVE_ARCH_BOOTMEM_NODE,
+ * the architecture-specific code should honor this).
+ *
+ * If flags is 0, then the return value is always 0 (success). If
+ * flags contains BOOTMEM_EXCLUSIVE, then -EBUSY is returned if the
+ * memory already was reserved.
+ */
+#define BOOTMEM_DEFAULT		0
+#define BOOTMEM_EXCLUSIVE	(1<<0)
+
+extern void reserve_bootmem_node(pg_data_t *pgdat,
+				 unsigned long physaddr,
+				 unsigned long size,
+				 int flags);
+#ifndef CONFIG_HAVE_ARCH_BOOTMEM_NODE
+extern int reserve_bootmem(unsigned long addr, unsigned long size, int flags);
+#endif
+
+extern void *__alloc_bootmem_nopanic(unsigned long size,
 			     unsigned long align,
 			     unsigned long goal);
-extern void *__alloc_bootmem_nopanic(unsigned long size,
+extern void *__alloc_bootmem(unsigned long size,
 				     unsigned long align,
 				     unsigned long goal);
 extern void *__alloc_bootmem_low(unsigned long size,
 				 unsigned long align,
 				 unsigned long goal);
+extern void *__alloc_bootmem_node(pg_data_t *pgdat,
+				  unsigned long size,
+				  unsigned long align,
+				  unsigned long goal);
+extern void *__alloc_bootmem_node_nopanic(pg_data_t *pgdat,
+				  unsigned long size,
+				  unsigned long align,
+				  unsigned long goal);
 extern void *__alloc_bootmem_low_node(pg_data_t *pgdat,
 				      unsigned long size,
 				      unsigned long align,
 				      unsigned long goal);
-
-/*
- * flags for reserve_bootmem (also if CONFIG_HAVE_ARCH_BOOTMEM_NODE,
- * the architecture-specific code should honor this)
- */
-#define BOOTMEM_DEFAULT		0
-#define BOOTMEM_EXCLUSIVE	(1<<0)
-
 #ifndef CONFIG_HAVE_ARCH_BOOTMEM_NODE
-/*
- * If flags is 0, then the return value is always 0 (success). If
- * flags contains BOOTMEM_EXCLUSIVE, then -EBUSY is returned if the
- * memory already was reserved.
- */
-extern int reserve_bootmem(unsigned long addr, unsigned long size, int flags);
 #define alloc_bootmem(x) \
 	__alloc_bootmem(x, SMP_CACHE_BYTES, __pa(MAX_DMA_ADDRESS))
 #define alloc_bootmem_low(x) \
@@ -81,31 +107,6 @@ extern int reserve_bootmem(unsigned long
 	__alloc_bootmem_low(x, PAGE_SIZE, 0)
 #endif /* !CONFIG_HAVE_ARCH_BOOTMEM_NODE */
 
-extern unsigned long free_all_bootmem(void);
-extern unsigned long free_all_bootmem_node(pg_data_t *pgdat);
-extern void *__alloc_bootmem_node(pg_data_t *pgdat,
-				  unsigned long size,
-				  unsigned long align,
-				  unsigned long goal);
-extern void *__alloc_bootmem_node_nopanic(pg_data_t *pgdat,
-				  unsigned long size,
-				  unsigned long align,
-				  unsigned long goal);
-extern unsigned long init_bootmem_node(pg_data_t *pgdat,
-				       unsigned long freepfn,
-				       unsigned long startpfn,
-				       unsigned long endpfn);
-extern void reserve_bootmem_node(pg_data_t *pgdat,
-				 unsigned long physaddr,
-				 unsigned long size,
-				 int flags);
-extern void free_bootmem_node(pg_data_t *pgdat,
-			      unsigned long addr,
-			      unsigned long size);
-extern void *alloc_bootmem_section(unsigned long size,
-				   unsigned long section_nr);
-
-#ifndef CONFIG_HAVE_ARCH_BOOTMEM_NODE
 #define alloc_bootmem_node(pgdat, x) \
 	__alloc_bootmem_node(pgdat, x, SMP_CACHE_BYTES, __pa(MAX_DMA_ADDRESS))
 #define alloc_bootmem_pages_node(pgdat, x) \
@@ -113,6 +114,8 @@ extern void *alloc_bootmem_section(unsig
 #define alloc_bootmem_low_pages_node(pgdat, x) \
 	__alloc_bootmem_low_node(pgdat, x, PAGE_SIZE, 0)
 #endif /* !CONFIG_HAVE_ARCH_BOOTMEM_NODE */
+extern void *alloc_bootmem_section(unsigned long size,
+				   unsigned long section_nr);
 
 #ifdef CONFIG_HAVE_ARCH_ALLOC_REMAP
 extern void *alloc_remap(int nid, unsigned long size);
diff -puN mm/bootmem.c~bootmem-reorder-code-to-match-new-bootmem-structure mm/bootmem.c
--- a/mm/bootmem.c~bootmem-reorder-code-to-match-new-bootmem-structure
+++ a/mm/bootmem.c
@@ -38,6 +38,19 @@ unsigned long saved_max_pfn;
 
 bootmem_data_t bootmem_node_data[MAX_NUMNODES] __initdata;
 
+/*
+ * Given an initialised bdata, it returns the size of the boot bitmap
+ */
+static unsigned long __init get_mapsize(bootmem_data_t *bdata)
+{
+	unsigned long mapsize;
+	unsigned long start = PFN_DOWN(bdata->node_boot_start);
+	unsigned long end = bdata->node_low_pfn;
+
+	mapsize = ((end - start) + 7) / 8;
+	return ALIGN(mapsize, sizeof(long));
+}
+
 /* return the number of _pages_ that will be allocated for the boot bitmap */
 unsigned long __init bootmem_bootmap_pages(unsigned long pages)
 {
@@ -72,19 +85,6 @@ static void __init link_bootmem(bootmem_
 }
 
 /*
- * Given an initialised bdata, it returns the size of the boot bitmap
- */
-static unsigned long __init get_mapsize(bootmem_data_t *bdata)
-{
-	unsigned long mapsize;
-	unsigned long start = PFN_DOWN(bdata->node_boot_start);
-	unsigned long end = bdata->node_low_pfn;
-
-	mapsize = ((end - start) + 7) / 8;
-	return ALIGN(mapsize, sizeof(long));
-}
-
-/*
  * Called once to set up the allocator itself.
  */
 static unsigned long __init init_bootmem_core(bootmem_data_t *bdata,
@@ -108,6 +108,146 @@ static unsigned long __init init_bootmem
 	return mapsize;
 }
 
+unsigned long __init init_bootmem_node(pg_data_t *pgdat, unsigned long freepfn,
+				unsigned long startpfn, unsigned long endpfn)
+{
+	return init_bootmem_core(pgdat->bdata, freepfn, startpfn, endpfn);
+}
+
+unsigned long __init init_bootmem(unsigned long start, unsigned long pages)
+{
+	max_low_pfn = pages;
+	min_low_pfn = start;
+	return init_bootmem_core(NODE_DATA(0)->bdata, start, 0, pages);
+}
+
+static unsigned long __init free_all_bootmem_core(bootmem_data_t *bdata)
+{
+	struct page *page;
+	unsigned long pfn;
+	unsigned long i, count;
+	unsigned long idx;
+	unsigned long *map;
+	int gofast = 0;
+
+	BUG_ON(!bdata->node_bootmem_map);
+
+	count = 0;
+	/* first extant page of the node */
+	pfn = PFN_DOWN(bdata->node_boot_start);
+	idx = bdata->node_low_pfn - pfn;
+	map = bdata->node_bootmem_map;
+	/*
+	 * Check if we are aligned to BITS_PER_LONG pages.  If so, we might
+	 * be able to free page orders of that size at once.
+	 */
+	if (!(pfn & (BITS_PER_LONG-1)))
+		gofast = 1;
+
+	for (i = 0; i < idx; ) {
+		unsigned long v = ~map[i / BITS_PER_LONG];
+
+		if (gofast && v == ~0UL) {
+			int order;
+
+			page = pfn_to_page(pfn);
+			count += BITS_PER_LONG;
+			order = ffs(BITS_PER_LONG) - 1;
+			__free_pages_bootmem(page, order);
+			i += BITS_PER_LONG;
+			page += BITS_PER_LONG;
+		} else if (v) {
+			unsigned long m;
+
+			page = pfn_to_page(pfn);
+			for (m = 1; m && i < idx; m<<=1, page++, i++) {
+				if (v & m) {
+					count++;
+					__free_pages_bootmem(page, 0);
+				}
+			}
+		} else {
+			i += BITS_PER_LONG;
+		}
+		pfn += BITS_PER_LONG;
+	}
+
+	/*
+	 * Now free the allocator bitmap itself, it's not
+	 * needed anymore:
+	 */
+	page = virt_to_page(bdata->node_bootmem_map);
+	idx = (get_mapsize(bdata) + PAGE_SIZE-1) >> PAGE_SHIFT;
+	for (i = 0; i < idx; i++, page++)
+		__free_pages_bootmem(page, 0);
+	count += i;
+	bdata->node_bootmem_map = NULL;
+
+	return count;
+}
+
+unsigned long __init free_all_bootmem_node(pg_data_t *pgdat)
+{
+	register_page_bootmem_info_node(pgdat);
+	return free_all_bootmem_core(pgdat->bdata);
+}
+
+unsigned long __init free_all_bootmem(void)
+{
+	return free_all_bootmem_core(NODE_DATA(0)->bdata);
+}
+
+static void __init free_bootmem_core(bootmem_data_t *bdata, unsigned long addr,
+				     unsigned long size)
+{
+	unsigned long sidx, eidx;
+	unsigned long i;
+
+	BUG_ON(!size);
+
+	/* out range */
+	if (addr + size < bdata->node_boot_start ||
+		PFN_DOWN(addr) > bdata->node_low_pfn)
+		return;
+	/*
+	 * round down end of usable mem, partially free pages are
+	 * considered reserved.
+	 */
+
+	if (addr >= bdata->node_boot_start && addr < bdata->last_success)
+		bdata->last_success = addr;
+
+	/*
+	 * Round up to index to the range.
+	 */
+	if (PFN_UP(addr) > PFN_DOWN(bdata->node_boot_start))
+		sidx = PFN_UP(addr) - PFN_DOWN(bdata->node_boot_start);
+	else
+		sidx = 0;
+
+	eidx = PFN_DOWN(addr + size - bdata->node_boot_start);
+	if (eidx > bdata->node_low_pfn - PFN_DOWN(bdata->node_boot_start))
+		eidx = bdata->node_low_pfn - PFN_DOWN(bdata->node_boot_start);
+
+	for (i = sidx; i < eidx; i++) {
+		if (unlikely(!test_and_clear_bit(i, bdata->node_bootmem_map)))
+			BUG();
+	}
+}
+
+void __init free_bootmem_node(pg_data_t *pgdat, unsigned long physaddr,
+			      unsigned long size)
+{
+	free_bootmem_core(pgdat->bdata, physaddr, size);
+}
+
+void __init free_bootmem(unsigned long addr, unsigned long size)
+{
+	bootmem_data_t *bdata;
+	list_for_each_entry(bdata, &bdata_list, list)
+		free_bootmem_core(bdata, addr, size);
+}
+
 /*
  * Marks a particular physical memory range as unallocatable. Usable RAM
  * might be used for boot-time allocations - or it might get added
@@ -183,43 +323,35 @@ static void __init reserve_bootmem_core(
 	}
 }
 
-static void __init free_bootmem_core(bootmem_data_t *bdata, unsigned long addr,
-				     unsigned long size)
+void __init reserve_bootmem_node(pg_data_t *pgdat, unsigned long physaddr,
+				 unsigned long size, int flags)
 {
-	unsigned long sidx, eidx;
-	unsigned long i;
-
-	BUG_ON(!size);
+	int ret;
 
-	/* out range */
-	if (addr + size < bdata->node_boot_start ||
-		PFN_DOWN(addr) > bdata->node_low_pfn)
+	ret = can_reserve_bootmem_core(pgdat->bdata, physaddr, size, flags);
+	if (ret < 0)
 		return;
-	/*
-	 * round down end of usable mem, partially free pages are
-	 * considered reserved.
-	 */
-
-	if (addr >= bdata->node_boot_start && addr < bdata->last_success)
-		bdata->last_success = addr;
-
-	/*
-	 * Round up to index to the range.
-	 */
-	if (PFN_UP(addr) > PFN_DOWN(bdata->node_boot_start))
-		sidx = PFN_UP(addr) - PFN_DOWN(bdata->node_boot_start);
-	else
-		sidx = 0;
+	reserve_bootmem_core(pgdat->bdata, physaddr, size, flags);
+}
 
-	eidx = PFN_DOWN(addr + size - bdata->node_boot_start);
-	if (eidx > bdata->node_low_pfn - PFN_DOWN(bdata->node_boot_start))
-		eidx = bdata->node_low_pfn - PFN_DOWN(bdata->node_boot_start);
+#ifndef CONFIG_HAVE_ARCH_BOOTMEM_NODE
+int __init reserve_bootmem(unsigned long addr, unsigned long size,
+			    int flags)
+{
+	bootmem_data_t *bdata;
+	int ret;
 
-	for (i = sidx; i < eidx; i++) {
-		if (unlikely(!test_and_clear_bit(i, bdata->node_bootmem_map)))
-			BUG();
+	list_for_each_entry(bdata, &bdata_list, list) {
+		ret = can_reserve_bootmem_core(bdata, addr, size, flags);
+		if (ret < 0)
+			return ret;
 	}
+	list_for_each_entry(bdata, &bdata_list, list)
+		reserve_bootmem_core(bdata, addr, size, flags);
+
+	return 0;
 }
+#endif /* !CONFIG_HAVE_ARCH_BOOTMEM_NODE */
 
 /*
  * We 'merge' subsequent allocations to save space. We might 'lose'
@@ -371,138 +503,6 @@ found:
 	return ret;
 }
 
-static unsigned long __init free_all_bootmem_core(bootmem_data_t *bdata)
-{
-	struct page *page;
-	unsigned long pfn;
-	unsigned long i, count;
-	unsigned long idx;
-	unsigned long *map; 
-	int gofast = 0;
-
-	BUG_ON(!bdata->node_bootmem_map);
-
-	count = 0;
-	/* first extant page of the node */
-	pfn = PFN_DOWN(bdata->node_boot_start);
-	idx = bdata->node_low_pfn - pfn;
-	map = bdata->node_bootmem_map;
-	/*
-	 * Check if we are aligned to BITS_PER_LONG pages.  If so, we might
-	 * be able to free page orders of that size at once.
-	 */
-	if (!(pfn & (BITS_PER_LONG-1)))
-		gofast = 1;
-
-	for (i = 0; i < idx; ) {
-		unsigned long v = ~map[i / BITS_PER_LONG];
-
-		if (gofast && v == ~0UL) {
-			int order;
-
-			page = pfn_to_page(pfn);
-			count += BITS_PER_LONG;
-			order = ffs(BITS_PER_LONG) - 1;
-			__free_pages_bootmem(page, order);
-			i += BITS_PER_LONG;
-			page += BITS_PER_LONG;
-		} else if (v) {
-			unsigned long m;
-
-			page = pfn_to_page(pfn);
-			for (m = 1; m && i < idx; m<<=1, page++, i++) {
-				if (v & m) {
-					count++;
-					__free_pages_bootmem(page, 0);
-				}
-			}
-		} else {
-			i += BITS_PER_LONG;
-		}
-		pfn += BITS_PER_LONG;
-	}
-
-	/*
-	 * Now free the allocator bitmap itself, it's not
-	 * needed anymore:
-	 */
-	page = virt_to_page(bdata->node_bootmem_map);
-	idx = (get_mapsize(bdata) + PAGE_SIZE-1) >> PAGE_SHIFT;
-	for (i = 0; i < idx; i++, page++)
-		__free_pages_bootmem(page, 0);
-	count += i;
-	bdata->node_bootmem_map = NULL;
-
-	return count;
-}
-
-unsigned long __init init_bootmem_node(pg_data_t *pgdat, unsigned long freepfn,
-				unsigned long startpfn, unsigned long endpfn)
-{
-	return init_bootmem_core(pgdat->bdata, freepfn, startpfn, endpfn);
-}
-
-void __init reserve_bootmem_node(pg_data_t *pgdat, unsigned long physaddr,
-				 unsigned long size, int flags)
-{
-	int ret;
-
-	ret = can_reserve_bootmem_core(pgdat->bdata, physaddr, size, flags);
-	if (ret < 0)
-		return;
-	reserve_bootmem_core(pgdat->bdata, physaddr, size, flags);
-}
-
-void __init free_bootmem_node(pg_data_t *pgdat, unsigned long physaddr,
-			      unsigned long size)
-{
-	free_bootmem_core(pgdat->bdata, physaddr, size);
-}
-
-unsigned long __init free_all_bootmem_node(pg_data_t *pgdat)
-{
-	register_page_bootmem_info_node(pgdat);
-	return free_all_bootmem_core(pgdat->bdata);
-}
-
-unsigned long __init init_bootmem(unsigned long start, unsigned long pages)
-{
-	max_low_pfn = pages;
-	min_low_pfn = start;
-	return init_bootmem_core(NODE_DATA(0)->bdata, start, 0, pages);
-}
-
-#ifndef CONFIG_HAVE_ARCH_BOOTMEM_NODE
-int __init reserve_bootmem(unsigned long addr, unsigned long size,
-			    int flags)
-{
-	bootmem_data_t *bdata;
-	int ret;
-
-	list_for_each_entry(bdata, &bdata_list, list) {
-		ret = can_reserve_bootmem_core(bdata, addr, size, flags);
-		if (ret < 0)
-			return ret;
-	}
-	list_for_each_entry(bdata, &bdata_list, list)
-		reserve_bootmem_core(bdata, addr, size, flags);
-
-	return 0;
-}
-#endif /* !CONFIG_HAVE_ARCH_BOOTMEM_NODE */
-
-void __init free_bootmem(unsigned long addr, unsigned long size)
-{
-	bootmem_data_t *bdata;
-	list_for_each_entry(bdata, &bdata_list, list)
-		free_bootmem_core(bdata, addr, size);
-}
-
-unsigned long __init free_all_bootmem(void)
-{
-	return free_all_bootmem_core(NODE_DATA(0)->bdata);
-}
-
 void * __init __alloc_bootmem_nopanic(unsigned long size, unsigned long align,
 				      unsigned long goal)
 {
@@ -532,7 +532,6 @@ void * __init __alloc_bootmem(unsigned l
 	return NULL;
 }
 
-
 void * __init __alloc_bootmem_node(pg_data_t *pgdat, unsigned long size,
 				   unsigned long align, unsigned long goal)
 {
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

