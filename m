From: akpm@linux-foundation.org
Subject: [merged] mm-make-compound_head-robust.patch removed from -mm tree
Date: Mon, 09 Nov 2015 11:45:29 -0800
Message-ID: <5640f7d9.Vj8FyGiS4mD0OVMR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57240 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495AbbKITpa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Nov 2015 14:45:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, ak@linux.intel.com, aneesh.kumar@linux.vnet.ibm.com, cl@linux.com, hughd@google.com, iamjoonsoo.kim@lge.com, mhocko@suse.com, paulmck@linux.vnet.ibm.com, rientjes@google.com, sergey.senozhatsky@gmail.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: make compound_head() robust
has been removed from the -mm tree.  Its filename was
     mm-make-compound_head-robust.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm: make compound_head() robust

Hugh has pointed that compound_head() call can be unsafe in some
context. There's one example:

	CPU0					CPU1

isolate_migratepages_block()
  page_count()
    compound_head()
      !!PageTail() == true
					put_page()
					  tail->first_page = NULL
      head = tail->first_page
					alloc_pages(__GFP_COMP)
					   prep_compound_page()
					     tail->first_page = head
					     __SetPageTail(p);
      !!PageTail() == true
    <head == NULL dereferencing>

The race is pure theoretical. I don't it's possible to trigger it in
practice. But who knows.

We can fix the race by changing how encode PageTail() and compound_head()
within struct page to be able to update them in one shot.

The patch introduces page->compound_head into third double word block in
front of compound_dtor and compound_order. Bit 0 encodes PageTail() and
the rest bits are pointer to head page if bit zero is set.

The patch moves page->pmd_huge_pte out of word, just in case if an
architecture defines pgtable_t into something what can have the bit 0
set.

hugetlb_cgroup uses page->lru.next in the second tail page to store
pointer struct hugetlb_cgroup. The patch switch it to use page->private
in the second tail page instead. The space is free since ->first_page is
removed from the union.

The patch also opens possibility to remove HUGETLB_CGROUP_MIN_ORDER
limitation, since there's now space in first tail page to store struct
hugetlb_cgroup pointer. But that's out of scope of the patch.

That means page->compound_head shares storage space with:

 - page->lru.next;
 - page->next;
 - page->rcu_head.next;

That's too long list to be absolutely sure, but looks like nobody uses
bit 0 of the word.

page->rcu_head.next guaranteed[1] to have bit 0 clean as long as we use
call_rcu(), call_rcu_bh(), call_rcu_sched(), or call_srcu(). But future
call_rcu_lazy() is not allowed as it makes use of the bit and we can
get false positive PageTail().

[1] http://lkml.kernel.org/g/20150827163634.GD4029@linux.vnet.ibm.com

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/split_page_table_lock |    4 -
 arch/xtensa/configs/iss_defconfig      |    1 
 include/linux/hugetlb_cgroup.h         |    4 -
 include/linux/mm.h                     |   53 ---------------
 include/linux/mm_types.h               |   22 +++++-
 include/linux/page-flags.h             |   80 +++++------------------
 mm/Kconfig                             |   12 ---
 mm/debug.c                             |    5 -
 mm/huge_memory.c                       |    3 
 mm/hugetlb.c                           |    8 --
 mm/hugetlb_cgroup.c                    |    2 
 mm/internal.h                          |    4 -
 mm/memory-failure.c                    |    7 --
 mm/page_alloc.c                        |   48 ++++++++-----
 mm/swap.c                              |    4 -
 15 files changed, 82 insertions(+), 175 deletions(-)

diff -puN Documentation/vm/split_page_table_lock~mm-make-compound_head-robust Documentation/vm/split_page_table_lock
--- a/Documentation/vm/split_page_table_lock~mm-make-compound_head-robust
+++ a/Documentation/vm/split_page_table_lock
@@ -54,8 +54,8 @@ everything required is done by pgtable_p
 which must be called on PTE table allocation / freeing.
 
 Make sure the architecture doesn't use slab allocator for page table
-allocation: slab uses page->slab_cache and page->first_page for its pages.
-These fields share storage with page->ptl.
+allocation: slab uses page->slab_cache for its pages.
+This field shares storage with page->ptl.
 
 PMD split lock only makes sense if you have more than two page table
 levels.
diff -puN arch/xtensa/configs/iss_defconfig~mm-make-compound_head-robust arch/xtensa/configs/iss_defconfig
--- a/arch/xtensa/configs/iss_defconfig~mm-make-compound_head-robust
+++ a/arch/xtensa/configs/iss_defconfig
@@ -169,7 +169,6 @@ CONFIG_FLATMEM_MANUAL=y
 # CONFIG_SPARSEMEM_MANUAL is not set
 CONFIG_FLATMEM=y
 CONFIG_FLAT_NODE_MEM_MAP=y
-CONFIG_PAGEFLAGS_EXTENDED=y
 CONFIG_SPLIT_PTLOCK_CPUS=4
 # CONFIG_PHYS_ADDR_T_64BIT is not set
 CONFIG_ZONE_DMA_FLAG=1
diff -puN include/linux/hugetlb_cgroup.h~mm-make-compound_head-robust include/linux/hugetlb_cgroup.h
--- a/include/linux/hugetlb_cgroup.h~mm-make-compound_head-robust
+++ a/include/linux/hugetlb_cgroup.h
@@ -32,7 +32,7 @@ static inline struct hugetlb_cgroup *hug
 
 	if (compound_order(page) < HUGETLB_CGROUP_MIN_ORDER)
 		return NULL;
-	return (struct hugetlb_cgroup *)page[2].lru.next;
+	return (struct hugetlb_cgroup *)page[2].private;
 }
 
 static inline
@@ -42,7 +42,7 @@ int set_hugetlb_cgroup(struct page *page
 
 	if (compound_order(page) < HUGETLB_CGROUP_MIN_ORDER)
 		return -1;
-	page[2].lru.next = (void *)h_cg;
+	page[2].private	= (unsigned long)h_cg;
 	return 0;
 }
 
diff -puN include/linux/mm.h~mm-make-compound_head-robust include/linux/mm.h
--- a/include/linux/mm.h~mm-make-compound_head-robust
+++ a/include/linux/mm.h
@@ -430,46 +430,6 @@ static inline void compound_unlock_irqre
 #endif
 }
 
-static inline struct page *compound_head_by_tail(struct page *tail)
-{
-	struct page *head = tail->first_page;
-
-	/*
-	 * page->first_page may be a dangling pointer to an old
-	 * compound page, so recheck that it is still a tail
-	 * page before returning.
-	 */
-	smp_rmb();
-	if (likely(PageTail(tail)))
-		return head;
-	return tail;
-}
-
-/*
- * Since either compound page could be dismantled asynchronously in THP
- * or we access asynchronously arbitrary positioned struct page, there
- * would be tail flag race. To handle this race, we should call
- * smp_rmb() before checking tail flag. compound_head_by_tail() did it.
- */
-static inline struct page *compound_head(struct page *page)
-{
-	if (unlikely(PageTail(page)))
-		return compound_head_by_tail(page);
-	return page;
-}
-
-/*
- * If we access compound page synchronously such as access to
- * allocated page, there is no need to handle tail flag race, so we can
- * check tail flag directly without any synchronization primitive.
- */
-static inline struct page *compound_head_fast(struct page *page)
-{
-	if (unlikely(PageTail(page)))
-		return page->first_page;
-	return page;
-}
-
 /*
  * The atomic page->_mapcount, starts from -1: so that transitions
  * both from it and to it can be tracked, using atomic_inc_and_test
@@ -518,7 +478,7 @@ static inline void get_huge_page_tail(st
 	VM_BUG_ON_PAGE(!PageTail(page), page);
 	VM_BUG_ON_PAGE(page_mapcount(page) < 0, page);
 	VM_BUG_ON_PAGE(atomic_read(&page->_count) != 0, page);
-	if (compound_tail_refcounted(page->first_page))
+	if (compound_tail_refcounted(compound_head(page)))
 		atomic_inc(&page->_mapcount);
 }
 
@@ -541,13 +501,7 @@ static inline struct page *virt_to_head_
 {
 	struct page *page = virt_to_page(x);
 
-	/*
-	 * We don't need to worry about synchronization of tail flag
-	 * when we call virt_to_head_page() since it is only called for
-	 * already allocated page and this page won't be freed until
-	 * this virt_to_head_page() is finished. So use _fast variant.
-	 */
-	return compound_head_fast(page);
+	return compound_head(page);
 }
 
 /*
@@ -1586,8 +1540,7 @@ static inline bool ptlock_init(struct pa
 	 * with 0. Make sure nobody took it in use in between.
 	 *
 	 * It can happen if arch try to use slab for page table allocation:
-	 * slab code uses page->slab_cache and page->first_page (for tail
-	 * pages), which share storage with page->ptl.
+	 * slab code uses page->slab_cache, which share storage with page->ptl.
 	 */
 	VM_BUG_ON_PAGE(*(unsigned long *)&page->ptl, page);
 	if (!ptlock_alloc(page))
diff -puN include/linux/mm_types.h~mm-make-compound_head-robust include/linux/mm_types.h
--- a/include/linux/mm_types.h~mm-make-compound_head-robust
+++ a/include/linux/mm_types.h
@@ -111,7 +111,13 @@ struct page {
 		};
 	};
 
-	/* Third double word block */
+	/*
+	 * Third double word block
+	 *
+	 * WARNING: bit 0 of the first word encode PageTail(). That means
+	 * the rest users of the storage space MUST NOT use the bit to
+	 * avoid collision and false-positive PageTail().
+	 */
 	union {
 		struct list_head lru;	/* Pageout list, eg. active_list
 					 * protected by zone->lru_lock !
@@ -132,14 +138,23 @@ struct page {
 		struct rcu_head rcu_head;	/* Used by SLAB
 						 * when destroying via RCU
 						 */
-		/* First tail page of compound page */
+		/* Tail pages of compound page */
 		struct {
+			unsigned long compound_head; /* If bit zero is set */
+
+			/* First tail page only */
 			unsigned short int compound_dtor;
 			unsigned short int compound_order;
 		};
 
 #if defined(CONFIG_TRANSPARENT_HUGEPAGE) && USE_SPLIT_PMD_PTLOCKS
-		pgtable_t pmd_huge_pte; /* protected by page->ptl */
+		struct {
+			unsigned long __pad;	/* do not overlay pmd_huge_pte
+						 * with compound_head to avoid
+						 * possible bit 0 collision.
+						 */
+			pgtable_t pmd_huge_pte; /* protected by page->ptl */
+		};
 #endif
 	};
 
@@ -160,7 +175,6 @@ struct page {
 #endif
 #endif
 		struct kmem_cache *slab_cache;	/* SL[AU]B: Pointer to slab */
-		struct page *first_page;	/* Compound tail pages */
 	};
 
 #ifdef CONFIG_MEMCG
diff -puN include/linux/page-flags.h~mm-make-compound_head-robust include/linux/page-flags.h
--- a/include/linux/page-flags.h~mm-make-compound_head-robust
+++ a/include/linux/page-flags.h
@@ -86,12 +86,7 @@ enum pageflags {
 	PG_private,		/* If pagecache, has fs-private data */
 	PG_private_2,		/* If pagecache, has fs aux data */
 	PG_writeback,		/* Page is under writeback */
-#ifdef CONFIG_PAGEFLAGS_EXTENDED
 	PG_head,		/* A head page */
-	PG_tail,		/* A tail page */
-#else
-	PG_compound,		/* A compound page */
-#endif
 	PG_swapcache,		/* Swap page: swp_entry_t in private */
 	PG_mappedtodisk,	/* Has blocks allocated on-disk */
 	PG_reclaim,		/* To be reclaimed asap */
@@ -398,85 +393,46 @@ static inline void set_page_writeback_ke
 	test_set_page_writeback_keepwrite(page);
 }
 
-#ifdef CONFIG_PAGEFLAGS_EXTENDED
-/*
- * System with lots of page flags available. This allows separate
- * flags for PageHead() and PageTail() checks of compound pages so that bit
- * tests can be used in performance sensitive paths. PageCompound is
- * generally not used in hot code paths except arch/powerpc/mm/init_64.c
- * and arch/powerpc/kvm/book3s_64_vio_hv.c which use it to detect huge pages
- * and avoid handling those in real mode.
- */
 __PAGEFLAG(Head, head) CLEARPAGEFLAG(Head, head)
-__PAGEFLAG(Tail, tail)
 
-static inline int PageCompound(struct page *page)
-{
-	return page->flags & ((1L << PG_head) | (1L << PG_tail));
-
-}
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-static inline void ClearPageCompound(struct page *page)
+static inline int PageTail(struct page *page)
 {
-	BUG_ON(!PageHead(page));
-	ClearPageHead(page);
+	return READ_ONCE(page->compound_head) & 1;
 }
-#endif
-
-#define PG_head_mask ((1L << PG_head))
 
-#else
-/*
- * Reduce page flag use as much as possible by overlapping
- * compound page flags with the flags used for page cache pages. Possible
- * because PageCompound is always set for compound pages and not for
- * pages on the LRU and/or pagecache.
- */
-TESTPAGEFLAG(Compound, compound)
-__SETPAGEFLAG(Head, compound)  __CLEARPAGEFLAG(Head, compound)
-
-/*
- * PG_reclaim is used in combination with PG_compound to mark the
- * head and tail of a compound page. This saves one page flag
- * but makes it impossible to use compound pages for the page cache.
- * The PG_reclaim bit would have to be used for reclaim or readahead
- * if compound pages enter the page cache.
- *
- * PG_compound & PG_reclaim	=> Tail page
- * PG_compound & ~PG_reclaim	=> Head page
- */
-#define PG_head_mask ((1L << PG_compound))
-#define PG_head_tail_mask ((1L << PG_compound) | (1L << PG_reclaim))
-
-static inline int PageHead(struct page *page)
+static inline void set_compound_head(struct page *page, struct page *head)
 {
-	return ((page->flags & PG_head_tail_mask) == PG_head_mask);
+	WRITE_ONCE(page->compound_head, (unsigned long)head + 1);
 }
 
-static inline int PageTail(struct page *page)
+static inline void clear_compound_head(struct page *page)
 {
-	return ((page->flags & PG_head_tail_mask) == PG_head_tail_mask);
+	WRITE_ONCE(page->compound_head, 0);
 }
 
-static inline void __SetPageTail(struct page *page)
+static inline struct page *compound_head(struct page *page)
 {
-	page->flags |= PG_head_tail_mask;
+	unsigned long head = READ_ONCE(page->compound_head);
+
+	if (unlikely(head & 1))
+		return (struct page *) (head - 1);
+	return page;
 }
 
-static inline void __ClearPageTail(struct page *page)
+static inline int PageCompound(struct page *page)
 {
-	page->flags &= ~PG_head_tail_mask;
-}
+	return PageHead(page) || PageTail(page);
 
+}
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 static inline void ClearPageCompound(struct page *page)
 {
-	BUG_ON((page->flags & PG_head_tail_mask) != (1 << PG_compound));
-	clear_bit(PG_compound, &page->flags);
+	BUG_ON(!PageHead(page));
+	ClearPageHead(page);
 }
 #endif
 
-#endif /* !PAGEFLAGS_EXTENDED */
+#define PG_head_mask ((1L << PG_head))
 
 #ifdef CONFIG_HUGETLB_PAGE
 int PageHuge(struct page *page);
diff -puN mm/Kconfig~mm-make-compound_head-robust mm/Kconfig
--- a/mm/Kconfig~mm-make-compound_head-robust
+++ a/mm/Kconfig
@@ -200,18 +200,6 @@ config MEMORY_HOTREMOVE
 	depends on MEMORY_HOTPLUG && ARCH_ENABLE_MEMORY_HOTREMOVE
 	depends on MIGRATION
 
-#
-# If we have space for more page flags then we can enable additional
-# optimizations and functionality.
-#
-# Regular Sparsemem takes page flag bits for the sectionid if it does not
-# use a virtual memmap. Disable extended page flags for 32 bit platforms
-# that require the use of a sectionid in the page flags.
-#
-config PAGEFLAGS_EXTENDED
-	def_bool y
-	depends on 64BIT || SPARSEMEM_VMEMMAP || !SPARSEMEM
-
 # Heavily threaded applications may benefit from splitting the mm-wide
 # page_table_lock, so that faults on different parts of the user address
 # space can be handled with less contention: split it at this NR_CPUS.
diff -puN mm/debug.c~mm-make-compound_head-robust mm/debug.c
--- a/mm/debug.c~mm-make-compound_head-robust
+++ a/mm/debug.c
@@ -25,12 +25,7 @@ static const struct trace_print_flags pa
 	{1UL << PG_private,		"private"	},
 	{1UL << PG_private_2,		"private_2"	},
 	{1UL << PG_writeback,		"writeback"	},
-#ifdef CONFIG_PAGEFLAGS_EXTENDED
 	{1UL << PG_head,		"head"		},
-	{1UL << PG_tail,		"tail"		},
-#else
-	{1UL << PG_compound,		"compound"	},
-#endif
 	{1UL << PG_swapcache,		"swapcache"	},
 	{1UL << PG_mappedtodisk,	"mappedtodisk"	},
 	{1UL << PG_reclaim,		"reclaim"	},
diff -puN mm/huge_memory.c~mm-make-compound_head-robust mm/huge_memory.c
--- a/mm/huge_memory.c~mm-make-compound_head-robust
+++ a/mm/huge_memory.c
@@ -1755,8 +1755,7 @@ static void __split_huge_page_refcount(s
 				      (1L << PG_unevictable)));
 		page_tail->flags |= (1L << PG_dirty);
 
-		/* clear PageTail before overwriting first_page */
-		smp_wmb();
+		clear_compound_head(page_tail);
 
 		if (page_is_young(page))
 			set_page_young(page_tail);
diff -puN mm/hugetlb.c~mm-make-compound_head-robust mm/hugetlb.c
--- a/mm/hugetlb.c~mm-make-compound_head-robust
+++ a/mm/hugetlb.c
@@ -1001,9 +1001,8 @@ static void destroy_compound_gigantic_pa
 	struct page *p = page + 1;
 
 	for (i = 1; i < nr_pages; i++, p = mem_map_next(p, page, i)) {
-		__ClearPageTail(p);
+		clear_compound_head(p);
 		set_page_refcounted(p);
-		p->first_page = NULL;
 	}
 
 	set_compound_order(page, 0);
@@ -1276,10 +1275,7 @@ static void prep_compound_gigantic_page(
 		 */
 		__ClearPageReserved(p);
 		set_page_count(p, 0);
-		p->first_page = page;
-		/* Make sure p->first_page is always valid for PageTail() */
-		smp_wmb();
-		__SetPageTail(p);
+		set_compound_head(p, page);
 	}
 }
 
diff -puN mm/hugetlb_cgroup.c~mm-make-compound_head-robust mm/hugetlb_cgroup.c
--- a/mm/hugetlb_cgroup.c~mm-make-compound_head-robust
+++ a/mm/hugetlb_cgroup.c
@@ -385,7 +385,7 @@ void __init hugetlb_cgroup_file_init(voi
 		/*
 		 * Add cgroup control files only if the huge page consists
 		 * of more than two normal pages. This is because we use
-		 * page[2].lru.next for storing cgroup details.
+		 * page[2].private for storing cgroup details.
 		 */
 		if (huge_page_order(h) >= HUGETLB_CGROUP_MIN_ORDER)
 			__hugetlb_cgroup_file_init(hstate_index(h));
diff -puN mm/internal.h~mm-make-compound_head-robust mm/internal.h
--- a/mm/internal.h~mm-make-compound_head-robust
+++ a/mm/internal.h
@@ -80,9 +80,9 @@ static inline void __get_page_tail_foll(
 	 * speculative page access (like in
 	 * page_cache_get_speculative()) on tail pages.
 	 */
-	VM_BUG_ON_PAGE(atomic_read(&page->first_page->_count) <= 0, page);
+	VM_BUG_ON_PAGE(atomic_read(&compound_head(page)->_count) <= 0, page);
 	if (get_page_head)
-		atomic_inc(&page->first_page->_count);
+		atomic_inc(&compound_head(page)->_count);
 	get_huge_page_tail(page);
 }
 
diff -puN mm/memory-failure.c~mm-make-compound_head-robust mm/memory-failure.c
--- a/mm/memory-failure.c~mm-make-compound_head-robust
+++ a/mm/memory-failure.c
@@ -776,8 +776,6 @@ static int me_huge_page(struct page *p,
 #define lru		(1UL << PG_lru)
 #define swapbacked	(1UL << PG_swapbacked)
 #define head		(1UL << PG_head)
-#define tail		(1UL << PG_tail)
-#define compound	(1UL << PG_compound)
 #define slab		(1UL << PG_slab)
 #define reserved	(1UL << PG_reserved)
 
@@ -800,12 +798,7 @@ static struct page_state {
 	 */
 	{ slab,		slab,		MF_MSG_SLAB,	me_kernel },
 
-#ifdef CONFIG_PAGEFLAGS_EXTENDED
 	{ head,		head,		MF_MSG_HUGE,		me_huge_page },
-	{ tail,		tail,		MF_MSG_HUGE,		me_huge_page },
-#else
-	{ compound,	compound,	MF_MSG_HUGE,		me_huge_page },
-#endif
 
 	{ sc|dirty,	sc|dirty,	MF_MSG_DIRTY_SWAPCACHE,	me_swapcache_dirty },
 	{ sc|dirty,	sc,		MF_MSG_CLEAN_SWAPCACHE,	me_swapcache_clean },
diff -puN mm/page_alloc.c~mm-make-compound_head-robust mm/page_alloc.c
--- a/mm/page_alloc.c~mm-make-compound_head-robust
+++ a/mm/page_alloc.c
@@ -445,15 +445,15 @@ out:
 /*
  * Higher-order pages are called "compound pages".  They are structured thusly:
  *
- * The first PAGE_SIZE page is called the "head page".
+ * The first PAGE_SIZE page is called the "head page" and have PG_head set.
  *
- * The remaining PAGE_SIZE pages are called "tail pages".
+ * The remaining PAGE_SIZE pages are called "tail pages". PageTail() is encoded
+ * in bit 0 of page->compound_head. The rest of bits is pointer to head page.
  *
- * All pages have PG_compound set.  All tail pages have their ->first_page
- * pointing at the head page.
+ * The first tail page's ->compound_dtor holds the offset in array of compound
+ * page destructors. See compound_page_dtors.
  *
- * The first tail page's ->lru.next holds the address of the compound page's
- * put_page() function.  Its ->lru.prev holds the order of allocation.
+ * The first tail page's ->compound_order holds the order of allocation.
  * This usage means that zero-order pages may not be compound.
  */
 
@@ -473,10 +473,7 @@ void prep_compound_page(struct page *pag
 	for (i = 1; i < nr_pages; i++) {
 		struct page *p = page + i;
 		set_page_count(p, 0);
-		p->first_page = page;
-		/* Make sure p->first_page is always valid for PageTail() */
-		smp_wmb();
-		__SetPageTail(p);
+		set_compound_head(p, page);
 	}
 }
 
@@ -854,17 +851,30 @@ static void free_one_page(struct zone *z
 
 static int free_tail_pages_check(struct page *head_page, struct page *page)
 {
-	if (!IS_ENABLED(CONFIG_DEBUG_VM))
-		return 0;
+	int ret = 1;
+
+	/*
+	 * We rely page->lru.next never has bit 0 set, unless the page
+	 * is PageTail(). Let's make sure that's true even for poisoned ->lru.
+	 */
+	BUILD_BUG_ON((unsigned long)LIST_POISON1 & 1);
+
+	if (!IS_ENABLED(CONFIG_DEBUG_VM)) {
+		ret = 0;
+		goto out;
+	}
 	if (unlikely(!PageTail(page))) {
 		bad_page(page, "PageTail not set", 0);
-		return 1;
+		goto out;
 	}
-	if (unlikely(page->first_page != head_page)) {
-		bad_page(page, "first_page not consistent", 0);
-		return 1;
+	if (unlikely(compound_head(page) != head_page)) {
+		bad_page(page, "compound_head not consistent", 0);
+		goto out;
 	}
-	return 0;
+	ret = 0;
+out:
+	clear_compound_head(page);
+	return ret;
 }
 
 static void __meminit __init_single_page(struct page *page, unsigned long pfn,
@@ -931,6 +941,10 @@ void __meminit reserve_bootmem_region(un
 			struct page *page = pfn_to_page(start_pfn);
 
 			init_reserved_page(start_pfn);
+
+			/* Avoid false-positive PageTail() */
+			INIT_LIST_HEAD(&page->lru);
+
 			SetPageReserved(page);
 		}
 	}
diff -puN mm/swap.c~mm-make-compound_head-robust mm/swap.c
--- a/mm/swap.c~mm-make-compound_head-robust
+++ a/mm/swap.c
@@ -201,7 +201,7 @@ out_put_single:
 				__put_single_page(page);
 			return;
 		}
-		VM_BUG_ON_PAGE(page_head != page->first_page, page);
+		VM_BUG_ON_PAGE(page_head != compound_head(page), page);
 		/*
 		 * We can release the refcount taken by
 		 * get_page_unless_zero() now that
@@ -262,7 +262,7 @@ static void put_compound_page(struct pag
 	 *  Case 3 is possible, as we may race with
 	 *  __split_huge_page_refcount tearing down a THP page.
 	 */
-	page_head = compound_head_by_tail(page);
+	page_head = compound_head(page);
 	if (!__compound_tail_refcounted(page_head))
 		put_unrefcounted_compound_page(page_head, page);
 	else
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mm-make-optimistic-check-for-swapin-readahead-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-2.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-3.patch
page-flags-trivial-cleanup-for-pagetrans-helpers.patch
page-flags-move-code-around.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages-fix.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages-fix-fix.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages-fix-3.patch
page-flags-define-pg_locked-behavior-on-compound-pages.patch
page-flags-define-behavior-of-fs-io-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-xen-related-flags-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages-fix.patch
page-flags-define-pg_swapbacked-behavior-on-compound-pages.patch
page-flags-define-pg_swapcache-behavior-on-compound-pages.patch
page-flags-define-pg_mlocked-behavior-on-compound-pages.patch
page-flags-define-pg_uncached-behavior-on-compound-pages.patch
page-flags-define-pg_uptodate-behavior-on-compound-pages.patch
page-flags-look-at-head-page-if-the-flag-is-encoded-in-page-mapping.patch
mm-sanitize-page-mapping-for-tail-pages.patch
mm-proc-adjust-pss-calculation.patch
rmap-add-argument-to-charge-compound-page.patch
memcg-adjust-to-support-new-thp-refcounting.patch
mm-thp-adjust-conditions-when-we-can-reuse-the-page-on-wp-fault.patch
mm-adjust-foll_split-for-new-refcounting.patch
mm-handle-pte-mapped-tail-pages-in-gerneric-fast-gup-implementaiton.patch
thp-mlock-do-not-allow-huge-pages-in-mlocked-area.patch
khugepaged-ignore-pmd-tables-with-thp-mapped-with-ptes.patch
thp-rename-split_huge_page_pmd-to-split_huge_pmd.patch
mm-vmstats-new-thp-splitting-event.patch
mm-temporally-mark-thp-broken.patch
thp-drop-all-split_huge_page-related-code.patch
mm-drop-tail-page-refcounting.patch
futex-thp-remove-special-case-for-thp-in-get_futex_key.patch
ksm-prepare-to-new-thp-semantics.patch
mm-thp-remove-compound_lock.patch
arm64-thp-remove-infrastructure-for-handling-splitting-pmds.patch
arm-thp-remove-infrastructure-for-handling-splitting-pmds.patch
mips-thp-remove-infrastructure-for-handling-splitting-pmds.patch
powerpc-thp-remove-infrastructure-for-handling-splitting-pmds.patch
s390-thp-remove-infrastructure-for-handling-splitting-pmds.patch
sparc-thp-remove-infrastructure-for-handling-splitting-pmds.patch
tile-thp-remove-infrastructure-for-handling-splitting-pmds.patch
x86-thp-remove-infrastructure-for-handling-splitting-pmds.patch
mm-thp-remove-infrastructure-for-handling-splitting-pmds.patch
mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps.patch
mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix-2.patch
mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix-3.patch
mm-differentiate-page_mapped-from-page_mapcount-for-compound-pages.patch
mm-numa-skip-pte-mapped-thp-on-numa-fault.patch
thp-implement-split_huge_pmd.patch
thp-add-option-to-setup-migration-entries-during-pmd-split.patch
thp-mm-split_huge_page-caller-need-to-lock-page.patch
thp-reintroduce-split_huge_page.patch
thp-reintroduce-split_huge_page-fix-3.patch
migrate_pages-try-to-split-pages-on-qeueuing.patch
thp-introduce-deferred_split_huge_page.patch
mm-re-enable-thp.patch
thp-update-documentation.patch
thp-allow-mlocked-thp-again.patch
mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting.patch

