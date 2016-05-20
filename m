From: akpm@linux-foundation.org
Subject: [merged]
 mm-rename-_count-field-of-the-struct-page-to-_refcount.patch removed from
 -mm tree
Date: Fri, 20 May 2016 14:03:52 -0700
Message-ID: <573f7bb8.LNaavKy5kR5JaUJr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46890 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961AbcETVDx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 17:03:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, cmetcalf@mellanox.com, davem@davemloft.net, hughd@google.com, johannes@sipsolutions.net, manish.chopra@qlogic.com, saeedm@mellanox.com, sfr@canb.auug.org.au, sgoutham@cavium.com, tariqt@mellanox.com, vbabka@suse.cz, yuval.mintz@qlogic.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: rename _count, field of the struct page, to _refcount
has been removed from the -mm tree.  Its filename was
     mm-rename-_count-field-of-the-struct-page-to-_refcount.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm: rename _count, field of the struct page, to _refcount

Many developers already know that field for reference count of the struct
page is _count and atomic type.  They would try to handle it directly and
this could break the purpose of page reference count tracepoint.  To
prevent direct _count modification, this patch rename it to _refcount and
add warning message on the code.  After that, developer who need to handle
reference count will find that field should not be accessed directly.

[akpm@linux-foundation.org: fix comments, per Vlastimil]
[akpm@linux-foundation.org: Documentation/vm/transhuge.txt too]
[sfr@canb.auug.org.au: sync ethernet driver changes]
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Sunil Goutham <sgoutham@cavium.com>
Cc: Chris Metcalf <cmetcalf@mellanox.com>
Cc: Manish Chopra <manish.chopra@qlogic.com>
Cc: Yuval Mintz <yuval.mintz@qlogic.com>
Cc: Tariq Toukan <tariqt@mellanox.com>
Cc: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/transhuge.txt                  |   10 ++---
 arch/tile/mm/init.c                             |    2 -
 drivers/block/aoe/aoecmd.c                      |    2 -
 drivers/hwtracing/intel_th/msu.c                |    2 -
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c |   20 +++++-----
 drivers/net/ethernet/qlogic/qede/qede_main.c    |    4 +-
 fs/proc/page.c                                  |    2 -
 include/linux/mm.h                              |    2 -
 include/linux/mm_types.h                        |   14 ++++---
 include/linux/page_ref.h                        |   26 +++++++-------
 include/linux/pagemap.h                         |    8 ++--
 kernel/kexec_core.c                             |    2 -
 mm/huge_memory.c                                |    4 +-
 mm/internal.h                                   |    2 -
 mm/page_alloc.c                                 |    4 +-
 mm/slub.c                                       |    4 +-
 mm/vmscan.c                                     |    4 +-
 17 files changed, 58 insertions(+), 54 deletions(-)

diff -puN Documentation/vm/transhuge.txt~mm-rename-_count-field-of-the-struct-page-to-_refcount Documentation/vm/transhuge.txt
--- a/Documentation/vm/transhuge.txt~mm-rename-_count-field-of-the-struct-page-to-_refcount
+++ a/Documentation/vm/transhuge.txt
@@ -394,9 +394,9 @@ hugepage natively. Once finished you can
 Refcounting on THP is mostly consistent with refcounting on other compound
 pages:
 
-  - get_page()/put_page() and GUP operate in head page's ->_count.
+  - get_page()/put_page() and GUP operate in head page's ->_refcount.
 
-  - ->_count in tail pages is always zero: get_page_unless_zero() never
+  - ->_refcount in tail pages is always zero: get_page_unless_zero() never
     succeed on tail pages.
 
   - map/unmap of the pages with PTE entry increment/decrement ->_mapcount
@@ -426,15 +426,15 @@ requests to split pinned huge page: it e
 sum of mapcount of all sub-pages plus one (split_huge_page caller must
 have reference for head page).
 
-split_huge_page uses migration entries to stabilize page->_count and
+split_huge_page uses migration entries to stabilize page->_refcount and
 page->_mapcount.
 
 We safe against physical memory scanners too: the only legitimate way
 scanner can get reference to a page is get_page_unless_zero().
 
-All tail pages has zero ->_count until atomic_add(). It prevent scanner
+All tail pages has zero ->_refcount until atomic_add(). It prevent scanner
 from geting reference to tail page up to the point. After the atomic_add()
-we don't care about ->_count value.  We already known how many references
+we don't care about ->_refcount value.  We already known how many references
 with should uncharge from head page.
 
 For head page get_page_unless_zero() will succeed and we don't mind. It's
diff -puN arch/tile/mm/init.c~mm-rename-_count-field-of-the-struct-page-to-_refcount arch/tile/mm/init.c
--- a/arch/tile/mm/init.c~mm-rename-_count-field-of-the-struct-page-to-_refcount
+++ a/arch/tile/mm/init.c
@@ -679,7 +679,7 @@ static void __init init_free_pfn_range(u
 			 * Hacky direct set to avoid unnecessary
 			 * lock take/release for EVERY page here.
 			 */
-			p->_count.counter = 0;
+			p->_refcount.counter = 0;
 			p->_mapcount.counter = -1;
 		}
 		init_page_count(page);
diff -puN drivers/block/aoe/aoecmd.c~mm-rename-_count-field-of-the-struct-page-to-_refcount drivers/block/aoe/aoecmd.c
--- a/drivers/block/aoe/aoecmd.c~mm-rename-_count-field-of-the-struct-page-to-_refcount
+++ a/drivers/block/aoe/aoecmd.c
@@ -861,7 +861,7 @@ rqbiocnt(struct request *r)
  * discussion.
  *
  * We cannot use get_page in the workaround, because it insists on a
- * positive page count as a precondition.  So we use _count directly.
+ * positive page count as a precondition.  So we use _refcount directly.
  */
 static void
 bio_pageinc(struct bio *bio)
diff -puN drivers/hwtracing/intel_th/msu.c~mm-rename-_count-field-of-the-struct-page-to-_refcount drivers/hwtracing/intel_th/msu.c
--- a/drivers/hwtracing/intel_th/msu.c~mm-rename-_count-field-of-the-struct-page-to-_refcount
+++ a/drivers/hwtracing/intel_th/msu.c
@@ -1164,7 +1164,7 @@ static void msc_mmap_close(struct vm_are
 	if (!atomic_dec_and_mutex_lock(&msc->mmap_count, &msc->buf_mutex))
 		return;
 
-	/* drop page _counts */
+	/* drop page _refcounts */
 	for (pg = 0; pg < msc->nr_pages; pg++) {
 		struct page *page = msc_buffer_get_page(msc, pg);
 
diff -puN drivers/net/ethernet/mellanox/mlx5/core/en_rx.c~mm-rename-_count-field-of-the-struct-page-to-_refcount drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c~mm-rename-_count-field-of-the-struct-page-to-_refcount
+++ a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -433,8 +433,8 @@ static int mlx5e_alloc_rx_fragmented_mpw
 	for (i = 0; i < MLX5_MPWRQ_PAGES_PER_WQE; i++) {
 		if (unlikely(mlx5e_alloc_and_map_page(rq, wi, i)))
 			goto err_unmap;
-		atomic_add(mlx5e_mpwqe_strides_per_page(rq),
-			   &wi->umr.dma_info[i].page->_count);
+		page_ref_add(wi->umr.dma_info[i].page,
+			     mlx5e_mpwqe_strides_per_page(rq));
 		wi->skbs_frags[i] = 0;
 	}
 
@@ -452,8 +452,8 @@ err_unmap:
 	while (--i >= 0) {
 		dma_unmap_page(rq->pdev, wi->umr.dma_info[i].addr, PAGE_SIZE,
 			       PCI_DMA_FROMDEVICE);
-		atomic_sub(mlx5e_mpwqe_strides_per_page(rq),
-			   &wi->umr.dma_info[i].page->_count);
+		page_ref_sub(wi->umr.dma_info[i].page,
+			     mlx5e_mpwqe_strides_per_page(rq));
 		put_page(wi->umr.dma_info[i].page);
 	}
 	dma_unmap_single(rq->pdev, wi->umr.mtt_addr, mtt_sz, PCI_DMA_TODEVICE);
@@ -477,8 +477,8 @@ void mlx5e_free_rx_fragmented_mpwqe(stru
 	for (i = 0; i < MLX5_MPWRQ_PAGES_PER_WQE; i++) {
 		dma_unmap_page(rq->pdev, wi->umr.dma_info[i].addr, PAGE_SIZE,
 			       PCI_DMA_FROMDEVICE);
-		atomic_sub(mlx5e_mpwqe_strides_per_page(rq) - wi->skbs_frags[i],
-			   &wi->umr.dma_info[i].page->_count);
+		page_ref_sub(wi->umr.dma_info[i].page,
+			mlx5e_mpwqe_strides_per_page(rq) - wi->skbs_frags[i]);
 		put_page(wi->umr.dma_info[i].page);
 	}
 	dma_unmap_single(rq->pdev, wi->umr.mtt_addr, mtt_sz, PCI_DMA_TODEVICE);
@@ -527,8 +527,8 @@ static int mlx5e_alloc_rx_linear_mpwqe(s
 	 */
 	split_page(wi->dma_info.page, MLX5_MPWRQ_WQE_PAGE_ORDER);
 	for (i = 0; i < MLX5_MPWRQ_PAGES_PER_WQE; i++) {
-		atomic_add(mlx5e_mpwqe_strides_per_page(rq),
-			   &wi->dma_info.page[i]._count);
+		page_ref_add(&wi->dma_info.page[i],
+			     mlx5e_mpwqe_strides_per_page(rq));
 		wi->skbs_frags[i] = 0;
 	}
 
@@ -551,8 +551,8 @@ void mlx5e_free_rx_linear_mpwqe(struct m
 	dma_unmap_page(rq->pdev, wi->dma_info.addr, rq->wqe_sz,
 		       PCI_DMA_FROMDEVICE);
 	for (i = 0; i < MLX5_MPWRQ_PAGES_PER_WQE; i++) {
-		atomic_sub(mlx5e_mpwqe_strides_per_page(rq) - wi->skbs_frags[i],
-			   &wi->dma_info.page[i]._count);
+		page_ref_sub(&wi->dma_info.page[i],
+			mlx5e_mpwqe_strides_per_page(rq) - wi->skbs_frags[i]);
 		put_page(&wi->dma_info.page[i]);
 	}
 }
diff -puN drivers/net/ethernet/qlogic/qede/qede_main.c~mm-rename-_count-field-of-the-struct-page-to-_refcount drivers/net/ethernet/qlogic/qede/qede_main.c
--- a/drivers/net/ethernet/qlogic/qede/qede_main.c~mm-rename-_count-field-of-the-struct-page-to-_refcount
+++ a/drivers/net/ethernet/qlogic/qede/qede_main.c
@@ -1036,7 +1036,7 @@ static int qede_fill_frag_skb(struct qed
 		/* Incr page ref count to reuse on allocation failure
 		 * so that it doesn't get freed while freeing SKB.
 		 */
-		atomic_inc(&current_bd->data->_count);
+		page_ref_inc(current_bd->data);
 		goto out;
 	}
 
@@ -1487,7 +1487,7 @@ static int qede_rx_int(struct qede_fastp
 				 * freeing SKB.
 				 */
 
-				atomic_inc(&sw_rx_data->data->_count);
+				page_ref_inc(sw_rx_data->data);
 				rxq->rx_alloc_errors++;
 				qede_recycle_rx_bd_ring(rxq, edev,
 							fp_cqe->bd_num);
diff -puN fs/proc/page.c~mm-rename-_count-field-of-the-struct-page-to-_refcount fs/proc/page.c
--- a/fs/proc/page.c~mm-rename-_count-field-of-the-struct-page-to-_refcount
+++ a/fs/proc/page.c
@@ -142,7 +142,7 @@ u64 stable_page_flags(struct page *page)
 
 
 	/*
-	 * Caveats on high order pages: page->_count will only be set
+	 * Caveats on high order pages: page->_refcount will only be set
 	 * -1 on the head page; SLUB/SLQB do the same for PG_slab;
 	 * SLOB won't set PG_slab at all on compound pages.
 	 */
diff -puN include/linux/mm.h~mm-rename-_count-field-of-the-struct-page-to-_refcount include/linux/mm.h
--- a/include/linux/mm.h~mm-rename-_count-field-of-the-struct-page-to-_refcount
+++ a/include/linux/mm.h
@@ -734,7 +734,7 @@ static inline void get_page(struct page
 	page = compound_head(page);
 	/*
 	 * Getting a normal page or the head of a compound page
-	 * requires to already have an elevated page->_count.
+	 * requires to already have an elevated page->_refcount.
 	 */
 	VM_BUG_ON_PAGE(page_ref_count(page) <= 0, page);
 	page_ref_inc(page);
diff -puN include/linux/mm_types.h~mm-rename-_count-field-of-the-struct-page-to-_refcount include/linux/mm_types.h
--- a/include/linux/mm_types.h~mm-rename-_count-field-of-the-struct-page-to-_refcount
+++ a/include/linux/mm_types.h
@@ -73,9 +73,9 @@ struct page {
 			unsigned long counters;
 #else
 			/*
-			 * Keep _count separate from slub cmpxchg_double data.
-			 * As the rest of the double word is protected by
-			 * slab_lock but _count is not.
+			 * Keep _refcount separate from slub cmpxchg_double
+			 * data.  As the rest of the double word is protected by
+			 * slab_lock but _refcount is not.
 			 */
 			unsigned counters;
 #endif
@@ -97,7 +97,11 @@ struct page {
 					};
 					int units;	/* SLOB */
 				};
-				atomic_t _count;		/* Usage count, see below. */
+				/*
+				 * Usage count, *USE WRAPPER FUNCTION*
+				 * when manual accounting. See page_ref.h
+				 */
+				atomic_t _refcount;
 			};
 			unsigned int active;	/* SLAB */
 		};
@@ -248,7 +252,7 @@ struct page_frag_cache {
 	__u32 offset;
 #endif
 	/* we maintain a pagecount bias, so that we dont dirty cache line
-	 * containing page->_count every time we allocate a fragment.
+	 * containing page->_refcount every time we allocate a fragment.
 	 */
 	unsigned int		pagecnt_bias;
 	bool pfmemalloc;
diff -puN include/linux/page_ref.h~mm-rename-_count-field-of-the-struct-page-to-_refcount include/linux/page_ref.h
--- a/include/linux/page_ref.h~mm-rename-_count-field-of-the-struct-page-to-_refcount
+++ a/include/linux/page_ref.h
@@ -63,17 +63,17 @@ static inline void __page_ref_unfreeze(s
 
 static inline int page_ref_count(struct page *page)
 {
-	return atomic_read(&page->_count);
+	return atomic_read(&page->_refcount);
 }
 
 static inline int page_count(struct page *page)
 {
-	return atomic_read(&compound_head(page)->_count);
+	return atomic_read(&compound_head(page)->_refcount);
 }
 
 static inline void set_page_count(struct page *page, int v)
 {
-	atomic_set(&page->_count, v);
+	atomic_set(&page->_refcount, v);
 	if (page_ref_tracepoint_active(__tracepoint_page_ref_set))
 		__page_ref_set(page, v);
 }
@@ -89,35 +89,35 @@ static inline void init_page_count(struc
 
 static inline void page_ref_add(struct page *page, int nr)
 {
-	atomic_add(nr, &page->_count);
+	atomic_add(nr, &page->_refcount);
 	if (page_ref_tracepoint_active(__tracepoint_page_ref_mod))
 		__page_ref_mod(page, nr);
 }
 
 static inline void page_ref_sub(struct page *page, int nr)
 {
-	atomic_sub(nr, &page->_count);
+	atomic_sub(nr, &page->_refcount);
 	if (page_ref_tracepoint_active(__tracepoint_page_ref_mod))
 		__page_ref_mod(page, -nr);
 }
 
 static inline void page_ref_inc(struct page *page)
 {
-	atomic_inc(&page->_count);
+	atomic_inc(&page->_refcount);
 	if (page_ref_tracepoint_active(__tracepoint_page_ref_mod))
 		__page_ref_mod(page, 1);
 }
 
 static inline void page_ref_dec(struct page *page)
 {
-	atomic_dec(&page->_count);
+	atomic_dec(&page->_refcount);
 	if (page_ref_tracepoint_active(__tracepoint_page_ref_mod))
 		__page_ref_mod(page, -1);
 }
 
 static inline int page_ref_sub_and_test(struct page *page, int nr)
 {
-	int ret = atomic_sub_and_test(nr, &page->_count);
+	int ret = atomic_sub_and_test(nr, &page->_refcount);
 
 	if (page_ref_tracepoint_active(__tracepoint_page_ref_mod_and_test))
 		__page_ref_mod_and_test(page, -nr, ret);
@@ -126,7 +126,7 @@ static inline int page_ref_sub_and_test(
 
 static inline int page_ref_dec_and_test(struct page *page)
 {
-	int ret = atomic_dec_and_test(&page->_count);
+	int ret = atomic_dec_and_test(&page->_refcount);
 
 	if (page_ref_tracepoint_active(__tracepoint_page_ref_mod_and_test))
 		__page_ref_mod_and_test(page, -1, ret);
@@ -135,7 +135,7 @@ static inline int page_ref_dec_and_test(
 
 static inline int page_ref_dec_return(struct page *page)
 {
-	int ret = atomic_dec_return(&page->_count);
+	int ret = atomic_dec_return(&page->_refcount);
 
 	if (page_ref_tracepoint_active(__tracepoint_page_ref_mod_and_return))
 		__page_ref_mod_and_return(page, -1, ret);
@@ -144,7 +144,7 @@ static inline int page_ref_dec_return(st
 
 static inline int page_ref_add_unless(struct page *page, int nr, int u)
 {
-	int ret = atomic_add_unless(&page->_count, nr, u);
+	int ret = atomic_add_unless(&page->_refcount, nr, u);
 
 	if (page_ref_tracepoint_active(__tracepoint_page_ref_mod_unless))
 		__page_ref_mod_unless(page, nr, ret);
@@ -153,7 +153,7 @@ static inline int page_ref_add_unless(st
 
 static inline int page_ref_freeze(struct page *page, int count)
 {
-	int ret = likely(atomic_cmpxchg(&page->_count, count, 0) == count);
+	int ret = likely(atomic_cmpxchg(&page->_refcount, count, 0) == count);
 
 	if (page_ref_tracepoint_active(__tracepoint_page_ref_freeze))
 		__page_ref_freeze(page, count, ret);
@@ -165,7 +165,7 @@ static inline void page_ref_unfreeze(str
 	VM_BUG_ON_PAGE(page_count(page) != 0, page);
 	VM_BUG_ON(count == 0);
 
-	atomic_set(&page->_count, count);
+	atomic_set(&page->_refcount, count);
 	if (page_ref_tracepoint_active(__tracepoint_page_ref_unfreeze))
 		__page_ref_unfreeze(page, count);
 }
diff -puN include/linux/pagemap.h~mm-rename-_count-field-of-the-struct-page-to-_refcount include/linux/pagemap.h
--- a/include/linux/pagemap.h~mm-rename-_count-field-of-the-struct-page-to-_refcount
+++ a/include/linux/pagemap.h
@@ -90,12 +90,12 @@ void release_pages(struct page **pages,
 
 /*
  * speculatively take a reference to a page.
- * If the page is free (_count == 0), then _count is untouched, and 0
- * is returned. Otherwise, _count is incremented by 1 and 1 is returned.
+ * If the page is free (_refcount == 0), then _refcount is untouched, and 0
+ * is returned. Otherwise, _refcount is incremented by 1 and 1 is returned.
  *
  * This function must be called inside the same rcu_read_lock() section as has
  * been used to lookup the page in the pagecache radix-tree (or page table):
- * this allows allocators to use a synchronize_rcu() to stabilize _count.
+ * this allows allocators to use a synchronize_rcu() to stabilize _refcount.
  *
  * Unless an RCU grace period has passed, the count of all pages coming out
  * of the allocator must be considered unstable. page_count may return higher
@@ -111,7 +111,7 @@ void release_pages(struct page **pages,
  * 2. conditionally increment refcount
  * 3. check the page is still in pagecache (if no, goto 1)
  *
- * Remove-side that cares about stability of _count (eg. reclaim) has the
+ * Remove-side that cares about stability of _refcount (eg. reclaim) has the
  * following (with tree_lock held for write):
  * A. atomically check refcount is correct and set it to 0 (atomic_cmpxchg)
  * B. remove page from pagecache
diff -puN kernel/kexec_core.c~mm-rename-_count-field-of-the-struct-page-to-_refcount kernel/kexec_core.c
--- a/kernel/kexec_core.c~mm-rename-_count-field-of-the-struct-page-to-_refcount
+++ a/kernel/kexec_core.c
@@ -1410,7 +1410,7 @@ static int __init crash_save_vmcoreinfo_
 	VMCOREINFO_STRUCT_SIZE(list_head);
 	VMCOREINFO_SIZE(nodemask_t);
 	VMCOREINFO_OFFSET(page, flags);
-	VMCOREINFO_OFFSET(page, _count);
+	VMCOREINFO_OFFSET(page, _refcount);
 	VMCOREINFO_OFFSET(page, mapping);
 	VMCOREINFO_OFFSET(page, lru);
 	VMCOREINFO_OFFSET(page, _mapcount);
diff -puN mm/huge_memory.c~mm-rename-_count-field-of-the-struct-page-to-_refcount mm/huge_memory.c
--- a/mm/huge_memory.c~mm-rename-_count-field-of-the-struct-page-to-_refcount
+++ a/mm/huge_memory.c
@@ -3113,7 +3113,7 @@ static void __split_huge_page_tail(struc
 	VM_BUG_ON_PAGE(page_ref_count(page_tail) != 0, page_tail);
 
 	/*
-	 * tail_page->_count is zero and not changing from under us. But
+	 * tail_page->_refcount is zero and not changing from under us. But
 	 * get_page_unless_zero() may be running from under us on the
 	 * tail_page. If we used atomic_set() below instead of atomic_inc(), we
 	 * would then run atomic_set() concurrently with
@@ -3340,7 +3340,7 @@ int split_huge_page_to_list(struct page
 	if (mlocked)
 		lru_add_drain();
 
-	/* Prevent deferred_split_scan() touching ->_count */
+	/* Prevent deferred_split_scan() touching ->_refcount */
 	spin_lock_irqsave(&pgdata->split_queue_lock, flags);
 	count = page_count(head);
 	mapcount = total_mapcount(head);
diff -puN mm/internal.h~mm-rename-_count-field-of-the-struct-page-to-_refcount mm/internal.h
--- a/mm/internal.h~mm-rename-_count-field-of-the-struct-page-to-_refcount
+++ a/mm/internal.h
@@ -58,7 +58,7 @@ static inline unsigned long ra_submit(st
 }
 
 /*
- * Turn a non-refcounted page (->_count == 0) into refcounted with
+ * Turn a non-refcounted page (->_refcount == 0) into refcounted with
  * a count of one.
  */
 static inline void set_page_refcounted(struct page *page)
diff -puN mm/page_alloc.c~mm-rename-_count-field-of-the-struct-page-to-_refcount mm/page_alloc.c
--- a/mm/page_alloc.c~mm-rename-_count-field-of-the-struct-page-to-_refcount
+++ a/mm/page_alloc.c
@@ -794,7 +794,7 @@ static inline int free_pages_check(struc
 	if (unlikely(page->mapping != NULL))
 		bad_reason = "non-NULL mapping";
 	if (unlikely(page_ref_count(page) != 0))
-		bad_reason = "nonzero _count";
+		bad_reason = "nonzero _refcount";
 	if (unlikely(page->flags & PAGE_FLAGS_CHECK_AT_FREE)) {
 		bad_reason = "PAGE_FLAGS_CHECK_AT_FREE flag(s) set";
 		bad_flags = PAGE_FLAGS_CHECK_AT_FREE;
@@ -6864,7 +6864,7 @@ bool has_unmovable_pages(struct zone *zo
 		 * We can't use page_count without pin a page
 		 * because another CPU can free compound page.
 		 * This check already skips compound tails of THP
-		 * because their page->_count is zero at all time.
+		 * because their page->_refcount is zero at all time.
 		 */
 		if (!page_ref_count(page)) {
 			if (PageBuddy(page))
diff -puN mm/slub.c~mm-rename-_count-field-of-the-struct-page-to-_refcount mm/slub.c
--- a/mm/slub.c~mm-rename-_count-field-of-the-struct-page-to-_refcount
+++ a/mm/slub.c
@@ -329,8 +329,8 @@ static inline void set_page_slub_counter
 	tmp.counters = counters_new;
 	/*
 	 * page->counters can cover frozen/inuse/objects as well
-	 * as page->_count.  If we assign to ->counters directly
-	 * we run the risk of losing updates to page->_count, so
+	 * as page->_refcount.  If we assign to ->counters directly
+	 * we run the risk of losing updates to page->_refcount, so
 	 * be careful and only assign to the fields we need.
 	 */
 	page->frozen  = tmp.frozen;
diff -puN mm/vmscan.c~mm-rename-_count-field-of-the-struct-page-to-_refcount mm/vmscan.c
--- a/mm/vmscan.c~mm-rename-_count-field-of-the-struct-page-to-_refcount
+++ a/mm/vmscan.c
@@ -633,7 +633,7 @@ static int __remove_mapping(struct addre
 	 *
 	 * Reversing the order of the tests ensures such a situation cannot
 	 * escape unnoticed. The smp_rmb is needed to ensure the page->flags
-	 * load is not satisfied before that of page->_count.
+	 * load is not satisfied before that of page->_refcount.
 	 *
 	 * Note that if SetPageDirty is always performed via set_page_dirty,
 	 * and thus under tree_lock, then this ordering is not required.
@@ -1720,7 +1720,7 @@ shrink_inactive_list(unsigned long nr_to
  * It is safe to rely on PG_active against the non-LRU pages in here because
  * nobody will play with that bit on a non-LRU page.
  *
- * The downside is that we have to touch page->_count against each page.
+ * The downside is that we have to touch page->_refcount against each page.
  * But we had to alter page->flags anyway.
  */
 
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are


