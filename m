From: akpm@linux-foundation.org
Subject: - powerpc-scan-device-tree-for-gigantic-pages.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:23:32 -0700
Message-ID: <200807242323.m6ONNWxH010683@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34745 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754352AbYGXXXn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:23:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, agl@us.ibm.com, kniht@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     powerpc: scan device tree for gigantic pages
has been removed from the -mm tree.  Its filename was
     powerpc-scan-device-tree-for-gigantic-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: powerpc: scan device tree for gigantic pages
From: Nick Piggin <npiggin@suse.de>

The 16G huge pages have to be reserved in the HMC prior to boot.  The
location of the pages are placed in the device tree.  This patch adds code
to scan the device tree during very early boot and save these page
locations until hugetlbfs is ready for them.

Acked-by: Adam Litke <agl@us.ibm.com>
Signed-off-by: Jon Tollefson <kniht@linux.vnet.ibm.com>
Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/hash_utils_64.c  |   44 ++++++++++++++++++++++++++++-
 arch/powerpc/mm/hugetlbpage.c    |   16 ++++++++++
 include/asm-powerpc/mmu-hash64.h |    2 +
 3 files changed, 61 insertions(+), 1 deletion(-)

diff -puN arch/powerpc/mm/hash_utils_64.c~powerpc-scan-device-tree-for-gigantic-pages arch/powerpc/mm/hash_utils_64.c
--- a/arch/powerpc/mm/hash_utils_64.c~powerpc-scan-device-tree-for-gigantic-pages
+++ a/arch/powerpc/mm/hash_utils_64.c
@@ -68,6 +68,7 @@
 
 #define KB (1024)
 #define MB (1024*KB)
+#define GB (1024L*MB)
 
 /*
  * Note:  pte   --> Linux PTE
@@ -329,6 +330,44 @@ static int __init htab_dt_scan_page_size
 	return 0;
 }
 
+/* Scan for 16G memory blocks that have been set aside for huge pages
+ * and reserve those blocks for 16G huge pages.
+ */
+static int __init htab_dt_scan_hugepage_blocks(unsigned long node,
+					const char *uname, int depth,
+					void *data) {
+	char *type = of_get_flat_dt_prop(node, "device_type", NULL);
+	unsigned long *addr_prop;
+	u32 *page_count_prop;
+	unsigned int expected_pages;
+	long unsigned int phys_addr;
+	long unsigned int block_size;
+
+	/* We are scanning "memory" nodes only */
+	if (type == NULL || strcmp(type, "memory") != 0)
+		return 0;
+
+	/* This property is the log base 2 of the number of virtual pages that
+	 * will represent this memory block. */
+	page_count_prop = of_get_flat_dt_prop(node, "ibm,expected#pages", NULL);
+	if (page_count_prop == NULL)
+		return 0;
+	expected_pages = (1 << page_count_prop[0]);
+	addr_prop = of_get_flat_dt_prop(node, "reg", NULL);
+	if (addr_prop == NULL)
+		return 0;
+	phys_addr = addr_prop[0];
+	block_size = addr_prop[1];
+	if (block_size != (16 * GB))
+		return 0;
+	printk(KERN_INFO "Huge page(16GB) memory: "
+			"addr = 0x%lX size = 0x%lX pages = %d\n",
+			phys_addr, block_size, expected_pages);
+	lmb_reserve(phys_addr, block_size * expected_pages);
+	add_gpage(phys_addr, block_size, expected_pages);
+	return 0;
+}
+
 static void __init htab_init_page_sizes(void)
 {
 	int rc;
@@ -418,7 +457,10 @@ static void __init htab_init_page_sizes(
 	       );
 
 #ifdef CONFIG_HUGETLB_PAGE
-	/* Init large page size. Currently, we pick 16M or 1M depending
+	/* Reserve 16G huge page memory sections for huge pages */
+	of_scan_flat_dt(htab_dt_scan_hugepage_blocks, NULL);
+
+/* Init large page size. Currently, we pick 16M or 1M depending
 	 * on what is available
 	 */
 	if (mmu_psize_defs[MMU_PAGE_16M].shift)
diff -puN arch/powerpc/mm/hugetlbpage.c~powerpc-scan-device-tree-for-gigantic-pages arch/powerpc/mm/hugetlbpage.c
--- a/arch/powerpc/mm/hugetlbpage.c~powerpc-scan-device-tree-for-gigantic-pages
+++ a/arch/powerpc/mm/hugetlbpage.c
@@ -110,6 +110,22 @@ pmd_t *hpmd_alloc(struct mm_struct *mm, 
 }
 #endif
 
+/* Build list of addresses of gigantic pages.  This function is used in early
+ * boot before the buddy or bootmem allocator is setup.
+ */
+void add_gpage(unsigned long addr, unsigned long page_size,
+	unsigned long number_of_pages)
+{
+	if (!addr)
+		return;
+	while (number_of_pages > 0) {
+		gpage_freearray[nr_gpages] = addr;
+		nr_gpages++;
+		number_of_pages--;
+		addr += page_size;
+	}
+}
+
 /* Moves the gigantic page addresses from the temporary list to the
  * huge_boot_pages list.  */
 int alloc_bootmem_huge_page(struct hstate *h)
diff -puN include/asm-powerpc/mmu-hash64.h~powerpc-scan-device-tree-for-gigantic-pages include/asm-powerpc/mmu-hash64.h
--- a/include/asm-powerpc/mmu-hash64.h~powerpc-scan-device-tree-for-gigantic-pages
+++ a/include/asm-powerpc/mmu-hash64.h
@@ -281,6 +281,8 @@ extern int htab_bolt_mapping(unsigned lo
 			     unsigned long pstart, unsigned long mode,
 			     int psize, int ssize);
 extern void set_huge_psize(int psize);
+extern void add_gpage(unsigned long addr, unsigned long page_size,
+			  unsigned long number_of_pages);
 extern void demote_segment_4k(struct mm_struct *mm, unsigned long addr);
 
 extern void htab_initialize(void);
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
linux-next.patch
mmu-notifiers-add-list_del_init_rcu.patch
mmu-notifiers-add-mm_take_all_locks-operation.patch
mmu-notifier-core.patch
x86-implement-pte_special.patch
x86-implement-pte_special-fix.patch
mm-introduce-get_user_pages_fast.patch
mm-introduce-get_user_pages_fast-fix.patch
mm-introduce-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast.patch
x86-lockless-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast-fix.patch
x86-lockless-get_user_pages_fast-fix-2.patch
x86-lockless-get_user_pages_fast-fix-2-fix-fix.patch
x86-lockless-get_user_pages_fast-fix-warning.patch
dio-use-get_user_pages_fast.patch
splice-use-get_user_pages_fast.patch
x86-support-1gb-hugepages-with-get_user_pages_lockless.patch
mm-readahead-scan-lockless.patch
radix-tree-add-gang_lookup_slot-gang_lookup_slot_tag.patch
mm-speculative-page-references.patch
mm-speculative-page-references-fix.patch
mm-speculative-page-references-fix-add_to_page_cache.patch
mm-speculative-page-references-fix-add_to_page_cache-fix.patch
mm-lockless-pagecache.patch
mm-spinlock-tree_lock.patch
powerpc-implement-pte_special.patch
powerpc-implement-pte_special-update.patch
powerpc-lockless-get_user_pages.patch
vmscan-move-isolate_lru_page-to-vmscanc.patch
vmscan-move-isolate_lru_page-to-vmscanc-fix.patch
vmscan-split-lru-lists-into-anon-file-sets-splitlru-bdi_cap_swap_backed.patch
mlock-mlocked-pages-are-unevictable.patch
mlock-mlocked-pages-are-unevictable-fix.patch
mlock-mlocked-pages-are-unevictable-fix-fix.patch
mlock-mlocked-pages-are-unevictable-fix-3.patch
mlock-mlocked-pages-are-unevictable-fix-fix-munlock-page-table-walk-now-requires-mm.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-cleanup.patch
fix-double-unlock_page-in-2626-rc5-mm3-kernel-bug-at-mm-filemapc-575.patch
vmstat-mlocked-pages-statistics.patch
vmstat-mlocked-pages-statistics-fix-incorrect-mlocked-field-of-proc-meminfo.patch
reiser4.patch
likeliness-accounting-change-and-cleanup.patch

