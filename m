From: akpm@linux-foundation.org
Subject: - bootmem-reorder-code-to-match-new-bootmem-structure.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:23:46 -0700
Message-ID: <200807242323.m6ONNkhY010713@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33543 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754477AbYGXXXv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:23:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@saeurebad.de, mm-commits@vger.kernel.org


The patch titled
     bootmem: reorder code to match new bootmem structure
has been removed from the -mm tree.  Its filename was
     bootmem-reorder-code-to-match-new-bootmem-structure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: bootmem: reorder code to match new bootmem structure
From: Johannes Weiner <hannes@saeurebad.de>

This only reorders functions so that further patches will be easier to
read.  No code changed.

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bootmem.h |   86 ++++-----
 mm/bootmem.c            |  356 ++++++++++++++++++--------------------
 2 files changed, 222 insertions(+), 220 deletions(-)

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
+extern int reserve_bootmem_node(pg_data_t *pgdat,
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
@@ -83,38 +109,16 @@ extern int reserve_bootmem(unsigned long
 
 extern int reserve_bootmem_generic(unsigned long addr, unsigned long size,
 				   int flags);
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
-extern int reserve_bootmem_node(pg_data_t *pgdat,
-				 unsigned long physaddr,
-				 unsigned long size,
-				 int flags);
-extern void free_bootmem_node(pg_data_t *pgdat,
-			      unsigned long addr,
-			      unsigned long size);
-extern void *alloc_bootmem_section(unsigned long size,
-				   unsigned long section_nr);
 
-#ifndef CONFIG_HAVE_ARCH_BOOTMEM_NODE
 #define alloc_bootmem_node(pgdat, x) \
 	__alloc_bootmem_node(pgdat, x, SMP_CACHE_BYTES, __pa(MAX_DMA_ADDRESS))
 #define alloc_bootmem_pages_node(pgdat, x) \
 	__alloc_bootmem_node(pgdat, x, PAGE_SIZE, __pa(MAX_DMA_ADDRESS))
 #define alloc_bootmem_low_pages_node(pgdat, x) \
 	__alloc_bootmem_low_node(pgdat, x, PAGE_SIZE, 0)
-#endif /* !CONFIG_HAVE_ARCH_BOOTMEM_NODE */
+
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
@@ -183,43 +323,36 @@ static void __init reserve_bootmem_core(
 	}
 }
 
-static void __init free_bootmem_core(bootmem_data_t *bdata, unsigned long addr,
-				     unsigned long size)
+int __init reserve_bootmem_node(pg_data_t *pgdat, unsigned long physaddr,
+				 unsigned long size, int flags)
 {
-	unsigned long sidx, eidx;
-	unsigned long i;
-
-	BUG_ON(!size);
-
-	/* out range */
-	if (addr + size < bdata->node_boot_start ||
-		PFN_DOWN(addr) > bdata->node_low_pfn)
-		return;
-	/*
-	 * round down end of usable mem, partially free pages are
-	 * considered reserved.
-	 */
-
-	if (addr >= bdata->node_boot_start && addr < bdata->last_success)
-		bdata->last_success = addr;
+	int ret;
 
-	/*
-	 * Round up to index to the range.
-	 */
-	if (PFN_UP(addr) > PFN_DOWN(bdata->node_boot_start))
-		sidx = PFN_UP(addr) - PFN_DOWN(bdata->node_boot_start);
-	else
-		sidx = 0;
+	ret = can_reserve_bootmem_core(pgdat->bdata, physaddr, size, flags);
+	if (ret < 0)
+		return -ENOMEM;
+	reserve_bootmem_core(pgdat->bdata, physaddr, size, flags);
+	return 0;
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
@@ -371,140 +504,6 @@ found:
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
-int __init reserve_bootmem_node(pg_data_t *pgdat, unsigned long physaddr,
-				 unsigned long size, int flags)
-{
-	int ret;
-
-	ret = can_reserve_bootmem_core(pgdat->bdata, physaddr, size, flags);
-	if (ret < 0)
-		return -ENOMEM;
-	reserve_bootmem_core(pgdat->bdata, physaddr, size, flags);
-
-	return 0;
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
@@ -534,7 +533,6 @@ void * __init __alloc_bootmem(unsigned l
 	return NULL;
 }
 
-
 void * __init __alloc_bootmem_node(pg_data_t *pgdat, unsigned long size,
 				   unsigned long align, unsigned long goal)
 {
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

