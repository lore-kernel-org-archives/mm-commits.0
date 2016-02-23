From: akpm@linux-foundation.org
Subject: + mm-introduce-page-reference-manipulation-functions.patch added
 to -mm tree
Date: Tue, 23 Feb 2016 15:33:47 -0800
Message-ID: <56ccec5b.vDbmDdiulQD+lGPv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34515 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270AbcBWXds (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 23 Feb 2016 18:33:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, kirill.shutemov@linux.intel.com, mgorman@techsingularity.net, mina86@mina86.com, minchan@kernel.org, rostedt@goodmis.org, sergey.senozhatsky.work@gmail.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: introduce page reference manipulation functions
has been added to the -mm tree.  Its filename is
     mm-introduce-page-reference-manipulation-functions.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-introduce-page-reference-manipulation-functions.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-introduce-page-reference-manipulation-functions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm: introduce page reference manipulation functions

Success of CMA allocation largely depends on success of migration and key
factor of it is page reference count.  Until now, page reference is
manipulated by direct calling atomic functions so we cannot follow up who
and where manipulate it.  Then, it is hard to find actual reason of CMA
allocation failure.  CMA allocation should be guaranteed to succeed so
finding offending place is really important.

In this patch, call sites where page reference is manipulated are
converted to introduced wrapper function.  This is preparation step to add
tracepoint to each page reference manipulation function.  With this
facility, we can easily find reason of CMA allocation failure.  There is
no functional change in this patch.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Michal Nazarewicz <mina86@mina86.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/mm/gup.c                                |    2 
 arch/powerpc/mm/mmu_context_hash64.c              |    3 
 arch/powerpc/mm/pgtable_64.c                      |    2 
 arch/x86/mm/gup.c                                 |    2 
 drivers/block/aoe/aoecmd.c                        |    4 
 drivers/net/ethernet/freescale/gianfar.c          |    2 
 drivers/net/ethernet/intel/fm10k/fm10k_main.c     |    2 
 drivers/net/ethernet/intel/igb/igb_main.c         |    2 
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c     |    2 
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c |    2 
 drivers/net/ethernet/mellanox/mlx4/en_rx.c        |    7 -
 drivers/net/ethernet/sun/niu.c                    |    2 
 include/linux/mm.h                                |   21 ---
 include/linux/page_ref.h                          |   76 ++++++++++++
 include/linux/pagemap.h                           |   19 ---
 mm/huge_memory.c                                  |    4 
 mm/internal.h                                     |    5 
 mm/memory_hotplug.c                               |    4 
 mm/migrate.c                                      |   10 -
 mm/page_alloc.c                                   |    6 
 mm/vmscan.c                                       |    6 
 21 files changed, 113 insertions(+), 70 deletions(-)

diff -puN arch/mips/mm/gup.c~mm-introduce-page-reference-manipulation-functions arch/mips/mm/gup.c
--- a/arch/mips/mm/gup.c~mm-introduce-page-reference-manipulation-functions
+++ a/arch/mips/mm/gup.c
@@ -64,7 +64,7 @@ static inline void get_head_page_multipl
 {
 	VM_BUG_ON(page != compound_head(page));
 	VM_BUG_ON(page_count(page) == 0);
-	atomic_add(nr, &page->_count);
+	page_ref_add(page, nr);
 	SetPageReferenced(page);
 }
 
diff -puN arch/powerpc/mm/mmu_context_hash64.c~mm-introduce-page-reference-manipulation-functions arch/powerpc/mm/mmu_context_hash64.c
--- a/arch/powerpc/mm/mmu_context_hash64.c~mm-introduce-page-reference-manipulation-functions
+++ a/arch/powerpc/mm/mmu_context_hash64.c
@@ -118,8 +118,7 @@ static void destroy_pagetable_page(struc
 	/* drop all the pending references */
 	count = ((unsigned long)pte_frag & ~PAGE_MASK) >> PTE_FRAG_SIZE_SHIFT;
 	/* We allow PTE_FRAG_NR fragments from a PTE page */
-	count = atomic_sub_return(PTE_FRAG_NR - count, &page->_count);
-	if (!count) {
+	if (page_ref_sub_and_test(page, PTE_FRAG_NR - count)) {
 		pgtable_page_dtor(page);
 		free_hot_cold_page(page, 0);
 	}
diff -puN arch/powerpc/mm/pgtable_64.c~mm-introduce-page-reference-manipulation-functions arch/powerpc/mm/pgtable_64.c
--- a/arch/powerpc/mm/pgtable_64.c~mm-introduce-page-reference-manipulation-functions
+++ a/arch/powerpc/mm/pgtable_64.c
@@ -403,7 +403,7 @@ static pte_t *__alloc_for_cache(struct m
 	 * count.
 	 */
 	if (likely(!mm->context.pte_frag)) {
-		atomic_set(&page->_count, PTE_FRAG_NR);
+		set_page_count(page, PTE_FRAG_NR);
 		mm->context.pte_frag = ret + PTE_FRAG_SIZE;
 	}
 	spin_unlock(&mm->page_table_lock);
diff -puN arch/x86/mm/gup.c~mm-introduce-page-reference-manipulation-functions arch/x86/mm/gup.c
--- a/arch/x86/mm/gup.c~mm-introduce-page-reference-manipulation-functions
+++ a/arch/x86/mm/gup.c
@@ -131,7 +131,7 @@ static inline void get_head_page_multipl
 {
 	VM_BUG_ON_PAGE(page != compound_head(page), page);
 	VM_BUG_ON_PAGE(page_count(page) == 0, page);
-	atomic_add(nr, &page->_count);
+	page_ref_add(page, nr);
 	SetPageReferenced(page);
 }
 
diff -puN drivers/block/aoe/aoecmd.c~mm-introduce-page-reference-manipulation-functions drivers/block/aoe/aoecmd.c
--- a/drivers/block/aoe/aoecmd.c~mm-introduce-page-reference-manipulation-functions
+++ a/drivers/block/aoe/aoecmd.c
@@ -875,7 +875,7 @@ bio_pageinc(struct bio *bio)
 		 * compound pages is no longer allowed by the kernel.
 		 */
 		page = compound_head(bv.bv_page);
-		atomic_inc(&page->_count);
+		page_ref_inc(page);
 	}
 }
 
@@ -888,7 +888,7 @@ bio_pagedec(struct bio *bio)
 
 	bio_for_each_segment(bv, bio, iter) {
 		page = compound_head(bv.bv_page);
-		atomic_dec(&page->_count);
+		page_ref_dec(page);
 	}
 }
 
diff -puN drivers/net/ethernet/freescale/gianfar.c~mm-introduce-page-reference-manipulation-functions drivers/net/ethernet/freescale/gianfar.c
--- a/drivers/net/ethernet/freescale/gianfar.c~mm-introduce-page-reference-manipulation-functions
+++ a/drivers/net/ethernet/freescale/gianfar.c
@@ -2942,7 +2942,7 @@ static bool gfar_add_rx_frag(struct gfar
 	/* change offset to the other half */
 	rxb->page_offset ^= GFAR_RXB_TRUESIZE;
 
-	atomic_inc(&page->_count);
+	page_ref_inc(page);
 
 	return true;
 }
diff -puN drivers/net/ethernet/intel/fm10k/fm10k_main.c~mm-introduce-page-reference-manipulation-functions drivers/net/ethernet/intel/fm10k/fm10k_main.c
--- a/drivers/net/ethernet/intel/fm10k/fm10k_main.c~mm-introduce-page-reference-manipulation-functions
+++ a/drivers/net/ethernet/intel/fm10k/fm10k_main.c
@@ -243,7 +243,7 @@ static bool fm10k_can_reuse_rx_page(stru
 	/* Even if we own the page, we are not allowed to use atomic_set()
 	 * This would break get_page_unless_zero() users.
 	 */
-	atomic_inc(&page->_count);
+	page_ref_inc(page);
 
 	return true;
 }
diff -puN drivers/net/ethernet/intel/igb/igb_main.c~mm-introduce-page-reference-manipulation-functions drivers/net/ethernet/intel/igb/igb_main.c
--- a/drivers/net/ethernet/intel/igb/igb_main.c~mm-introduce-page-reference-manipulation-functions
+++ a/drivers/net/ethernet/intel/igb/igb_main.c
@@ -6630,7 +6630,7 @@ static bool igb_can_reuse_rx_page(struct
 	/* Even if we own the page, we are not allowed to use atomic_set()
 	 * This would break get_page_unless_zero() users.
 	 */
-	atomic_inc(&page->_count);
+	page_ref_inc(page);
 
 	return true;
 }
diff -puN drivers/net/ethernet/intel/ixgbe/ixgbe_main.c~mm-introduce-page-reference-manipulation-functions drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c~mm-introduce-page-reference-manipulation-functions
+++ a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -1942,7 +1942,7 @@ static bool ixgbe_add_rx_frag(struct ixg
 	/* Even if we own the page, we are not allowed to use atomic_set()
 	 * This would break get_page_unless_zero() users.
 	 */
-	atomic_inc(&page->_count);
+	page_ref_inc(page);
 
 	return true;
 }
diff -puN drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c~mm-introduce-page-reference-manipulation-functions drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
--- a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c~mm-introduce-page-reference-manipulation-functions
+++ a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
@@ -837,7 +837,7 @@ add_tail_frag:
 	/* Even if we own the page, we are not allowed to use atomic_set()
 	 * This would break get_page_unless_zero() users.
 	 */
-	atomic_inc(&page->_count);
+	page_ref_inc(page);
 
 	return true;
 }
diff -puN drivers/net/ethernet/mellanox/mlx4/en_rx.c~mm-introduce-page-reference-manipulation-functions drivers/net/ethernet/mellanox/mlx4/en_rx.c
--- a/drivers/net/ethernet/mellanox/mlx4/en_rx.c~mm-introduce-page-reference-manipulation-functions
+++ a/drivers/net/ethernet/mellanox/mlx4/en_rx.c
@@ -82,8 +82,7 @@ static int mlx4_alloc_pages(struct mlx4_
 	/* Not doing get_page() for each frag is a big win
 	 * on asymetric workloads. Note we can not use atomic_set().
 	 */
-	atomic_add(page_alloc->page_size / frag_info->frag_stride - 1,
-		   &page->_count);
+	page_ref_add(page, page_alloc->page_size / frag_info->frag_stride - 1);
 	return 0;
 }
 
@@ -127,7 +126,7 @@ out:
 			dma_unmap_page(priv->ddev, page_alloc[i].dma,
 				page_alloc[i].page_size, PCI_DMA_FROMDEVICE);
 			page = page_alloc[i].page;
-			atomic_set(&page->_count, 1);
+			set_page_count(page, 1);
 			put_page(page);
 		}
 	}
@@ -177,7 +176,7 @@ out:
 		dma_unmap_page(priv->ddev, page_alloc->dma,
 			       page_alloc->page_size, PCI_DMA_FROMDEVICE);
 		page = page_alloc->page;
-		atomic_set(&page->_count, 1);
+		set_page_count(page, 1);
 		put_page(page);
 		page_alloc->page = NULL;
 	}
diff -puN drivers/net/ethernet/sun/niu.c~mm-introduce-page-reference-manipulation-functions drivers/net/ethernet/sun/niu.c
--- a/drivers/net/ethernet/sun/niu.c~mm-introduce-page-reference-manipulation-functions
+++ a/drivers/net/ethernet/sun/niu.c
@@ -3341,7 +3341,7 @@ static int niu_rbr_add_page(struct niu *
 
 	niu_hash_page(rp, page, addr);
 	if (rp->rbr_blocks_per_page > 1)
-		atomic_add(rp->rbr_blocks_per_page - 1, &page->_count);
+		page_ref_add(page, rp->rbr_blocks_per_page - 1);
 
 	for (i = 0; i < rp->rbr_blocks_per_page; i++) {
 		__le32 *rbr = &rp->rbr[start_index + i];
diff -puN include/linux/mm.h~mm-introduce-page-reference-manipulation-functions include/linux/mm.h
--- a/include/linux/mm.h~mm-introduce-page-reference-manipulation-functions
+++ a/include/linux/mm.h
@@ -22,6 +22,7 @@
 #include <linux/resource.h>
 #include <linux/page_ext.h>
 #include <linux/err.h>
+#include <linux/page_ref.h>
 
 struct mempolicy;
 struct anon_vma;
@@ -387,7 +388,7 @@ static inline int pmd_devmap(pmd_t pmd)
 static inline int put_page_testzero(struct page *page)
 {
 	VM_BUG_ON_PAGE(atomic_read(&page->_count) == 0, page);
-	return atomic_dec_and_test(&page->_count);
+	return page_ref_dec_and_test(page);
 }
 
 /*
@@ -398,7 +399,7 @@ static inline int put_page_testzero(stru
  */
 static inline int get_page_unless_zero(struct page *page)
 {
-	return atomic_inc_not_zero(&page->_count);
+	return page_ref_add_unless(page, 1, 0);
 }
 
 extern int page_is_ram(unsigned long pfn);
@@ -485,11 +486,6 @@ static inline int total_mapcount(struct
 }
 #endif
 
-static inline int page_count(struct page *page)
-{
-	return atomic_read(&compound_head(page)->_count);
-}
-
 static inline struct page *virt_to_head_page(const void *x)
 {
 	struct page *page = virt_to_page(x);
@@ -497,15 +493,6 @@ static inline struct page *virt_to_head_
 	return compound_head(page);
 }
 
-/*
- * Setup the page count before being freed into the page allocator for
- * the first time (boot or memory hotplug)
- */
-static inline void init_page_count(struct page *page)
-{
-	atomic_set(&page->_count, 1);
-}
-
 void __put_page(struct page *page);
 
 void put_pages_list(struct list_head *pages);
@@ -716,7 +703,7 @@ static inline void get_page(struct page
 	 * requires to already have an elevated page->_count.
 	 */
 	VM_BUG_ON_PAGE(atomic_read(&page->_count) <= 0, page);
-	atomic_inc(&page->_count);
+	page_ref_inc(page);
 
 	if (unlikely(is_zone_device_page(page)))
 		get_zone_device_page(page);
diff -puN /dev/null include/linux/page_ref.h
--- /dev/null
+++ a/include/linux/page_ref.h
@@ -0,0 +1,76 @@
+#include <linux/atomic.h>
+#include <linux/mm_types.h>
+#include <linux/page-flags.h>
+
+static inline int page_count(struct page *page)
+{
+	return atomic_read(&compound_head(page)->_count);
+}
+
+static inline void set_page_count(struct page *page, int v)
+{
+	atomic_set(&page->_count, v);
+}
+
+/*
+ * Setup the page count before being freed into the page allocator for
+ * the first time (boot or memory hotplug)
+ */
+static inline void init_page_count(struct page *page)
+{
+	set_page_count(page, 1);
+}
+
+static inline void page_ref_add(struct page *page, int nr)
+{
+	atomic_add(nr, &page->_count);
+}
+
+static inline void page_ref_sub(struct page *page, int nr)
+{
+	atomic_sub(nr, &page->_count);
+}
+
+static inline void page_ref_inc(struct page *page)
+{
+	atomic_inc(&page->_count);
+}
+
+static inline void page_ref_dec(struct page *page)
+{
+	atomic_dec(&page->_count);
+}
+
+static inline int page_ref_sub_and_test(struct page *page, int nr)
+{
+	return atomic_sub_and_test(nr, &page->_count);
+}
+
+static inline int page_ref_dec_and_test(struct page *page)
+{
+	return atomic_dec_and_test(&page->_count);
+}
+
+static inline int page_ref_dec_return(struct page *page)
+{
+	return atomic_dec_return(&page->_count);
+}
+
+static inline int page_ref_add_unless(struct page *page, int nr, int u)
+{
+	return atomic_add_unless(&page->_count, nr, u);
+}
+
+static inline int page_ref_freeze(struct page *page, int count)
+{
+	return likely(atomic_cmpxchg(&page->_count, count, 0) == count);
+}
+
+static inline void page_ref_unfreeze(struct page *page, int count)
+{
+	VM_BUG_ON_PAGE(page_count(page) != 0, page);
+	VM_BUG_ON(count == 0);
+
+	atomic_set(&page->_count, count);
+}
+
diff -puN include/linux/pagemap.h~mm-introduce-page-reference-manipulation-functions include/linux/pagemap.h
--- a/include/linux/pagemap.h~mm-introduce-page-reference-manipulation-functions
+++ a/include/linux/pagemap.h
@@ -165,7 +165,7 @@ static inline int page_cache_get_specula
 	 * SMP requires.
 	 */
 	VM_BUG_ON_PAGE(page_count(page) == 0, page);
-	atomic_inc(&page->_count);
+	page_ref_inc(page);
 
 #else
 	if (unlikely(!get_page_unless_zero(page))) {
@@ -194,10 +194,10 @@ static inline int page_cache_add_specula
 	VM_BUG_ON(!in_atomic());
 # endif
 	VM_BUG_ON_PAGE(page_count(page) == 0, page);
-	atomic_add(count, &page->_count);
+	page_ref_add(page, count);
 
 #else
-	if (unlikely(!atomic_add_unless(&page->_count, count, 0)))
+	if (unlikely(!page_ref_add_unless(page, count, 0)))
 		return 0;
 #endif
 	VM_BUG_ON_PAGE(PageCompound(page) && page != compound_head(page), page);
@@ -205,19 +205,6 @@ static inline int page_cache_add_specula
 	return 1;
 }
 
-static inline int page_freeze_refs(struct page *page, int count)
-{
-	return likely(atomic_cmpxchg(&page->_count, count, 0) == count);
-}
-
-static inline void page_unfreeze_refs(struct page *page, int count)
-{
-	VM_BUG_ON_PAGE(page_count(page) != 0, page);
-	VM_BUG_ON(count == 0);
-
-	atomic_set(&page->_count, count);
-}
-
 #ifdef CONFIG_NUMA
 extern struct page *__page_cache_alloc(gfp_t gfp);
 #else
diff -puN mm/huge_memory.c~mm-introduce-page-reference-manipulation-functions mm/huge_memory.c
--- a/mm/huge_memory.c~mm-introduce-page-reference-manipulation-functions
+++ a/mm/huge_memory.c
@@ -2856,7 +2856,7 @@ static void __split_huge_pmd_locked(stru
 
 	page = pmd_page(*pmd);
 	VM_BUG_ON_PAGE(!page_count(page), page);
-	atomic_add(HPAGE_PMD_NR - 1, &page->_count);
+	page_ref_add(page, HPAGE_PMD_NR - 1);
 	write = pmd_write(*pmd);
 	young = pmd_young(*pmd);
 	dirty = pmd_dirty(*pmd);
@@ -3238,7 +3238,7 @@ static void __split_huge_page_tail(struc
 	 * atomic_set() here would be safe on all archs (and not only on x86),
 	 * it's safer to use atomic_inc().
 	 */
-	atomic_inc(&page_tail->_count);
+	page_ref_inc(page_tail);
 
 	page_tail->flags &= ~PAGE_FLAGS_CHECK_AT_PREP;
 	page_tail->flags |= (head->flags &
diff -puN mm/internal.h~mm-introduce-page-reference-manipulation-functions mm/internal.h
--- a/mm/internal.h~mm-introduce-page-reference-manipulation-functions
+++ a/mm/internal.h
@@ -43,11 +43,6 @@ void unmap_page_range(struct mmu_gather
 			     unsigned long addr, unsigned long end,
 			     struct zap_details *details);
 
-static inline void set_page_count(struct page *page, int v)
-{
-	atomic_set(&page->_count, v);
-}
-
 extern int __do_page_cache_readahead(struct address_space *mapping,
 		struct file *filp, pgoff_t offset, unsigned long nr_to_read,
 		unsigned long lookahead_size);
diff -puN mm/memory_hotplug.c~mm-introduce-page-reference-manipulation-functions mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-introduce-page-reference-manipulation-functions
+++ a/mm/memory_hotplug.c
@@ -167,7 +167,7 @@ void get_page_bootmem(unsigned long info
 	page->lru.next = (struct list_head *) type;
 	SetPagePrivate(page);
 	set_page_private(page, info);
-	atomic_inc(&page->_count);
+	page_ref_inc(page);
 }
 
 void put_page_bootmem(struct page *page)
@@ -178,7 +178,7 @@ void put_page_bootmem(struct page *page)
 	BUG_ON(type < MEMORY_HOTPLUG_MIN_BOOTMEM_TYPE ||
 	       type > MEMORY_HOTPLUG_MAX_BOOTMEM_TYPE);
 
-	if (atomic_dec_return(&page->_count) == 1) {
+	if (page_ref_dec_return(page) == 1) {
 		ClearPagePrivate(page);
 		set_page_private(page, 0);
 		INIT_LIST_HEAD(&page->lru);
diff -puN mm/migrate.c~mm-introduce-page-reference-manipulation-functions mm/migrate.c
--- a/mm/migrate.c~mm-introduce-page-reference-manipulation-functions
+++ a/mm/migrate.c
@@ -349,7 +349,7 @@ int migrate_page_move_mapping(struct add
 		return -EAGAIN;
 	}
 
-	if (!page_freeze_refs(page, expected_count)) {
+	if (!page_ref_freeze(page, expected_count)) {
 		spin_unlock_irq(&mapping->tree_lock);
 		return -EAGAIN;
 	}
@@ -363,7 +363,7 @@ int migrate_page_move_mapping(struct add
 	 */
 	if (mode == MIGRATE_ASYNC && head &&
 			!buffer_migrate_lock_buffers(head, mode)) {
-		page_unfreeze_refs(page, expected_count);
+		page_ref_unfreeze(page, expected_count);
 		spin_unlock_irq(&mapping->tree_lock);
 		return -EAGAIN;
 	}
@@ -397,7 +397,7 @@ int migrate_page_move_mapping(struct add
 	 * to one less reference.
 	 * We know this isn't the last reference.
 	 */
-	page_unfreeze_refs(page, expected_count - 1);
+	page_ref_unfreeze(page, expected_count - 1);
 
 	spin_unlock(&mapping->tree_lock);
 	/* Leave irq disabled to prevent preemption while updating stats */
@@ -451,7 +451,7 @@ int migrate_huge_page_move_mapping(struc
 		return -EAGAIN;
 	}
 
-	if (!page_freeze_refs(page, expected_count)) {
+	if (!page_ref_freeze(page, expected_count)) {
 		spin_unlock_irq(&mapping->tree_lock);
 		return -EAGAIN;
 	}
@@ -463,7 +463,7 @@ int migrate_huge_page_move_mapping(struc
 
 	radix_tree_replace_slot(pslot, newpage);
 
-	page_unfreeze_refs(page, expected_count - 1);
+	page_ref_unfreeze(page, expected_count - 1);
 
 	spin_unlock_irq(&mapping->tree_lock);
 
diff -puN mm/page_alloc.c~mm-introduce-page-reference-manipulation-functions mm/page_alloc.c
--- a/mm/page_alloc.c~mm-introduce-page-reference-manipulation-functions
+++ a/mm/page_alloc.c
@@ -3479,7 +3479,7 @@ refill:
 		/* Even if we own the page, we do not use atomic_set().
 		 * This would break get_page_unless_zero() users.
 		 */
-		atomic_add(size - 1, &page->_count);
+		page_ref_add(page, size - 1);
 
 		/* reset page count bias and offset to start of new frag */
 		nc->pfmemalloc = page_is_pfmemalloc(page);
@@ -3491,7 +3491,7 @@ refill:
 	if (unlikely(offset < 0)) {
 		page = virt_to_page(nc->va);
 
-		if (!atomic_sub_and_test(nc->pagecnt_bias, &page->_count))
+		if (!page_ref_sub_and_test(page, nc->pagecnt_bias))
 			goto refill;
 
 #if (PAGE_SIZE < PAGE_FRAG_CACHE_MAX_SIZE)
@@ -3499,7 +3499,7 @@ refill:
 		size = nc->size;
 #endif
 		/* OK, page count is 0, we can safely set it */
-		atomic_set(&page->_count, size);
+		set_page_count(page, size);
 
 		/* reset page count bias and offset to start of new frag */
 		nc->pagecnt_bias = size;
diff -puN mm/vmscan.c~mm-introduce-page-reference-manipulation-functions mm/vmscan.c
--- a/mm/vmscan.c~mm-introduce-page-reference-manipulation-functions
+++ a/mm/vmscan.c
@@ -638,11 +638,11 @@ static int __remove_mapping(struct addre
 	 * Note that if SetPageDirty is always performed via set_page_dirty,
 	 * and thus under tree_lock, then this ordering is not required.
 	 */
-	if (!page_freeze_refs(page, 2))
+	if (!page_ref_freeze(page, 2))
 		goto cannot_free;
 	/* note: atomic_cmpxchg in page_freeze_refs provides the smp_rmb */
 	if (unlikely(PageDirty(page))) {
-		page_unfreeze_refs(page, 2);
+		page_ref_unfreeze(page, 2);
 		goto cannot_free;
 	}
 
@@ -704,7 +704,7 @@ int remove_mapping(struct address_space
 		 * drops the pagecache ref for us without requiring another
 		 * atomic operation.
 		 */
-		page_unfreeze_refs(page, 1);
+		page_ref_unfreeze(page, 1);
 		return 1;
 	}
 	return 0;
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

mm-slab-fix-stale-code-comment.patch
mm-slab-remove-useless-structure-define.patch
mm-slab-remove-the-checks-for-slab-implementation-bug.patch
mm-slab-activate-debug_pagealloc-in-slab-when-it-is-actually-enabled.patch
mm-slab-use-more-appropriate-condition-check-for-debug_pagealloc.patch
mm-slab-clean-up-debug_pagealloc-processing-code.patch
mm-slab-alternative-implementation-for-debug_slab_leak.patch
mm-slab-remove-object-status-buffer-for-debug_slab_leak.patch
mm-slab-put-the-freelist-at-the-end-of-slab-page.patch
mm-slab-align-cache-size-first-before-determination-of-off_slab-candidate.patch
mm-slab-clean-up-cache-type-determination.patch
mm-slab-do-not-change-cache-size-if-debug-pagealloc-isnt-possible.patch
mm-slab-make-criteria-for-off-slab-determination-robust-and-simple.patch
mm-slab-factor-out-slab-list-fixup-code.patch
mm-slab-factor-out-debugging-initialization-in-cache_init_objs.patch
mm-slab-introduce-new-slab-management-type-objfreelist_slab.patch
mm-slab-introduce-new-slab-management-type-objfreelist_slab-fix.patch
mm-slab-re-implement-pfmemalloc-support.patch
mm-slab-re-implement-pfmemalloc-support-v2.patch
mm-slub-support-left-red-zone.patch
mm-compaction-fix-invalid-free_pfn-and-compact_cached_free_pfn.patch
mm-compaction-pass-only-pageblock-aligned-range-to-pageblock_pfn_to_page.patch
mm-compaction-speed-up-pageblock_pfn_to_page-when-zone-is-contiguous.patch
mm-vmalloc-query-dynamic-debug_pagealloc-setting.patch
mm-slub-query-dynamic-debug_pagealloc-setting.patch
mm-slub-query-dynamic-debug_pagealloc-setting-v2.patch
sound-query-dynamic-debug_pagealloc-setting.patch
powerpc-query-dynamic-debug_pagealloc-setting.patch
tile-query-dynamic-debug_pagealloc-setting.patch
mm-introduce-page-reference-manipulation-functions.patch
mm-page_ref-add-tracepoint-to-track-down-page-reference-manipulation.patch

