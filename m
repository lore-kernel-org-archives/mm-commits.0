From: akpm@linux-foundation.org
Subject: [merged]
 mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps.patch removed
 from -mm tree
Date: Tue, 19 Jan 2016 12:02:32 -0800
Message-ID: <569e9658.sfv1sS7AC49588W1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42935 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757110AbcASUCd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jan 2016 15:02:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, aneesh.kumar@linux.vnet.ibm.com, cl@linux.com, dave.hansen@intel.com, hannes@cmpxchg.org, hughd@google.com, jmarchan@redhat.com, mgorman@suse.de, mhocko@suse.com, n-horiguchi@ah.jp.nec.com, riel@redhat.com, rientjes@google.com, sasha.levin@oracle.com, steve.capper@linaro.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: rework mapcount accounting to enable 4k mapping of THPs
has been removed from the -mm tree.  Its filename was
     mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm: rework mapcount accounting to enable 4k mapping of THPs

We're going to allow mapping of individual 4k pages of THP compound.
It means we need to track mapcount on per small page basis.

Straight-forward approach is to use ->_mapcount in all subpages to track
how many time this subpage is mapped with PMDs or PTEs combined. But
this is rather expensive: mapping or unmapping of a THP page with PMD
would require HPAGE_PMD_NR atomic operations instead of single we have
now.

The idea is to store separately how many times the page was mapped as
whole -- compound_mapcount. This frees up ->_mapcount in subpages to
track PTE mapcount.

We use the same approach as with compound page destructor and compound
order to store compound_mapcount: use space in first tail page,
->mapping this time.

Any time we map/unmap whole compound page (THP or hugetlb) -- we
increment/decrement compound_mapcount. When we map part of compound page
with PTE we operate on ->_mapcount of the subpage.

page_mapcount() counts both: PTE and PMD mappings of the page.

Basically, we have mapcount for a subpage spread over two counters.
It makes tricky to detect when last mapcount for a page goes away.

We introduced PageDoubleMap() for this. When we split THP PMD for the
first time and there's other PMD mapping left we offset up ->_mapcount
in all subpages by one and set PG_double_map on the compound page.
These additional references go away with last compound_mapcount.

This approach provides a way to detect when last mapcount goes away on
per small page basis without introducing new overhead for most common
cases.

[akpm@linux-foundation.org: fix typo in comment]
[mhocko@suse.com: ignore partial THP when moving task]
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Tested-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Acked-by: Jerome Marchand <jmarchan@redhat.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Jerome Marchand <jmarchan@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Steve Capper <steve.capper@linaro.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h         |   26 ++++++++-
 include/linux/mm_types.h   |    1 
 include/linux/page-flags.h |   36 ++++++++++++
 include/linux/rmap.h       |    4 -
 mm/debug.c                 |    5 +
 mm/huge_memory.c           |    2 
 mm/hugetlb.c               |    4 -
 mm/memcontrol.c            |    8 ++
 mm/memory.c                |    2 
 mm/migrate.c               |    2 
 mm/page_alloc.c            |   13 +++-
 mm/rmap.c                  |   98 +++++++++++++++++++++++++++--------
 12 files changed, 166 insertions(+), 35 deletions(-)

diff -puN include/linux/mm.h~mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps include/linux/mm.h
--- a/include/linux/mm.h~mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps
+++ a/include/linux/mm.h
@@ -410,6 +410,19 @@ static inline int is_vmalloc_or_module_a
 
 extern void kvfree(const void *addr);
 
+static inline atomic_t *compound_mapcount_ptr(struct page *page)
+{
+	return &page[1].compound_mapcount;
+}
+
+static inline int compound_mapcount(struct page *page)
+{
+	if (!PageCompound(page))
+		return 0;
+	page = compound_head(page);
+	return atomic_read(compound_mapcount_ptr(page)) + 1;
+}
+
 /*
  * The atomic page->_mapcount, starts from -1: so that transitions
  * both from it and to it can be tracked, using atomic_inc_and_test
@@ -422,8 +435,17 @@ static inline void page_mapcount_reset(s
 
 static inline int page_mapcount(struct page *page)
 {
+	int ret;
 	VM_BUG_ON_PAGE(PageSlab(page), page);
-	return atomic_read(&page->_mapcount) + 1;
+
+	ret = atomic_read(&page->_mapcount) + 1;
+	if (PageCompound(page)) {
+		page = compound_head(page);
+		ret += atomic_read(compound_mapcount_ptr(page)) + 1;
+		if (PageDoubleMap(page))
+			ret--;
+	}
+	return ret;
 }
 
 static inline int page_count(struct page *page)
@@ -934,7 +956,7 @@ static inline pgoff_t page_file_index(st
  */
 static inline int page_mapped(struct page *page)
 {
-	return atomic_read(&(page)->_mapcount) >= 0;
+	return atomic_read(&(page)->_mapcount) + compound_mapcount(page) >= 0;
 }
 
 /*
diff -puN include/linux/mm_types.h~mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps include/linux/mm_types.h
--- a/include/linux/mm_types.h~mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps
+++ a/include/linux/mm_types.h
@@ -54,6 +54,7 @@ struct page {
 						 * see PAGE_MAPPING_ANON below.
 						 */
 		void *s_mem;			/* slab first object */
+		atomic_t compound_mapcount;	/* first tail page */
 	};
 
 	/* Second double word */
diff -puN include/linux/page-flags.h~mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps include/linux/page-flags.h
--- a/include/linux/page-flags.h~mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps
+++ a/include/linux/page-flags.h
@@ -126,6 +126,9 @@ enum pageflags {
 
 	/* SLOB */
 	PG_slob_free = PG_private,
+
+	/* Compound pages. Stored in first tail page's flags */
+	PG_double_map = PG_private_2,
 };
 
 #ifndef __GENERATING_BOUNDS_H
@@ -523,10 +526,43 @@ static inline int PageTransTail(struct p
 	return PageTail(page);
 }
 
+/*
+ * PageDoubleMap indicates that the compound page is mapped with PTEs as well
+ * as PMDs.
+ *
+ * This is required for optimization of rmap operations for THP: we can postpone
+ * per small page mapcount accounting (and its overhead from atomic operations)
+ * until the first PMD split.
+ *
+ * For the page PageDoubleMap means ->_mapcount in all sub-pages is offset up
+ * by one. This reference will go away with last compound_mapcount.
+ *
+ * See also __split_huge_pmd_locked() and page_remove_anon_compound_rmap().
+ */
+static inline int PageDoubleMap(struct page *page)
+{
+	return PageHead(page) && test_bit(PG_double_map, &page[1].flags);
+}
+
+static inline int TestSetPageDoubleMap(struct page *page)
+{
+	VM_BUG_ON_PAGE(!PageHead(page), page);
+	return test_and_set_bit(PG_double_map, &page[1].flags);
+}
+
+static inline int TestClearPageDoubleMap(struct page *page)
+{
+	VM_BUG_ON_PAGE(!PageHead(page), page);
+	return test_and_clear_bit(PG_double_map, &page[1].flags);
+}
+
 #else
 TESTPAGEFLAG_FALSE(TransHuge)
 TESTPAGEFLAG_FALSE(TransCompound)
 TESTPAGEFLAG_FALSE(TransTail)
+TESTPAGEFLAG_FALSE(DoubleMap)
+	TESTSETFLAG_FALSE(DoubleMap)
+	TESTCLEARFLAG_FALSE(DoubleMap)
 #endif
 
 /*
diff -puN include/linux/rmap.h~mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps include/linux/rmap.h
--- a/include/linux/rmap.h~mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps
+++ a/include/linux/rmap.h
@@ -183,9 +183,9 @@ void hugepage_add_anon_rmap(struct page
 void hugepage_add_new_anon_rmap(struct page *, struct vm_area_struct *,
 				unsigned long);
 
-static inline void page_dup_rmap(struct page *page)
+static inline void page_dup_rmap(struct page *page, bool compound)
 {
-	atomic_inc(&page->_mapcount);
+	atomic_inc(compound ? compound_mapcount_ptr(page) : &page->_mapcount);
 }
 
 /*
diff -puN mm/debug.c~mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps mm/debug.c
--- a/mm/debug.c~mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps
+++ a/mm/debug.c
@@ -79,9 +79,12 @@ static void dump_flags(unsigned long fla
 void dump_page_badflags(struct page *page, const char *reason,
 		unsigned long badflags)
 {
-	pr_emerg("page:%p count:%d mapcount:%d mapping:%p index:%#lx\n",
+	pr_emerg("page:%p count:%d mapcount:%d mapping:%p index:%#lx",
 		  page, atomic_read(&page->_count), page_mapcount(page),
 		  page->mapping, page->index);
+	if (PageCompound(page))
+		pr_cont(" compound_mapcount: %d", compound_mapcount(page));
+	pr_cont("\n");
 	BUILD_BUG_ON(ARRAY_SIZE(pageflag_names) != __NR_PAGEFLAGS);
 	dump_flags(page->flags, pageflag_names, ARRAY_SIZE(pageflag_names));
 	if (reason)
diff -puN mm/huge_memory.c~mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps mm/huge_memory.c
--- a/mm/huge_memory.c~mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps
+++ a/mm/huge_memory.c
@@ -989,7 +989,7 @@ int copy_huge_pmd(struct mm_struct *dst_
 	src_page = pmd_page(pmd);
 	VM_BUG_ON_PAGE(!PageHead(src_page), src_page);
 	get_page(src_page);
-	page_dup_rmap(src_page);
+	page_dup_rmap(src_page, true);
 	add_mm_counter(dst_mm, MM_ANONPAGES, HPAGE_PMD_NR);
 
 	pmdp_set_wrprotect(src_mm, addr, src_pmd);
diff -puN mm/hugetlb.c~mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps mm/hugetlb.c
--- a/mm/hugetlb.c~mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps
+++ a/mm/hugetlb.c
@@ -3102,7 +3102,7 @@ int copy_hugetlb_page_range(struct mm_st
 			entry = huge_ptep_get(src_pte);
 			ptepage = pte_page(entry);
 			get_page(ptepage);
-			page_dup_rmap(ptepage);
+			page_dup_rmap(ptepage, true);
 			set_huge_pte_at(dst, addr, dst_pte, entry);
 			hugetlb_count_add(pages_per_huge_page(h), dst);
 		}
@@ -3585,7 +3585,7 @@ retry:
 		ClearPagePrivate(page);
 		hugepage_add_new_anon_rmap(page, vma, address);
 	} else
-		page_dup_rmap(page);
+		page_dup_rmap(page, true);
 	new_pte = make_huge_pte(vma, page, ((vma->vm_flags & VM_WRITE)
 				&& (vma->vm_flags & VM_SHARED)));
 	set_huge_pte_at(mm, address, ptep, new_pte);
diff -puN mm/memcontrol.c~mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps mm/memcontrol.c
--- a/mm/memcontrol.c~mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps
+++ a/mm/memcontrol.c
@@ -4899,6 +4899,14 @@ retry:
 		switch (get_mctgt_type(vma, addr, ptent, &target)) {
 		case MC_TARGET_PAGE:
 			page = target.page;
+			/*
+			 * We can have a part of the split pmd here. Moving it
+			 * can be done but it would be too convoluted so simply
+			 * ignore such a partial THP and keep it in original
+			 * memcg. There should be somebody mapping the head.
+			 */
+			if (PageTransCompound(page))
+				goto put;
 			if (isolate_lru_page(page))
 				goto put;
 			if (!mem_cgroup_move_account(page, false,
diff -puN mm/memory.c~mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps mm/memory.c
--- a/mm/memory.c~mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps
+++ a/mm/memory.c
@@ -864,7 +864,7 @@ copy_one_pte(struct mm_struct *dst_mm, s
 	page = vm_normal_page(vma, addr, pte);
 	if (page) {
 		get_page(page);
-		page_dup_rmap(page);
+		page_dup_rmap(page, false);
 		rss[mm_counter(page)]++;
 	}
 
diff -puN mm/migrate.c~mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps mm/migrate.c
--- a/mm/migrate.c~mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps
+++ a/mm/migrate.c
@@ -165,7 +165,7 @@ static int remove_migration_pte(struct p
 		if (PageAnon(new))
 			hugepage_add_anon_rmap(new, vma, addr);
 		else
-			page_dup_rmap(new);
+			page_dup_rmap(new, true);
 	} else if (PageAnon(new))
 		page_add_anon_rmap(new, vma, addr, false);
 	else
diff -puN mm/page_alloc.c~mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps mm/page_alloc.c
--- a/mm/page_alloc.c~mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps
+++ a/mm/page_alloc.c
@@ -469,6 +469,7 @@ void prep_compound_page(struct page *pag
 		p->mapping = TAIL_MAPPING;
 		set_compound_head(p, page);
 	}
+	atomic_set(compound_mapcount_ptr(page), -1);
 }
 
 #ifdef CONFIG_DEBUG_PAGEALLOC
@@ -733,7 +734,7 @@ static inline int free_pages_check(struc
 	const char *bad_reason = NULL;
 	unsigned long bad_flags = 0;
 
-	if (unlikely(page_mapcount(page)))
+	if (unlikely(atomic_read(&page->_mapcount) != -1))
 		bad_reason = "nonzero mapcount";
 	if (unlikely(page->mapping != NULL))
 		bad_reason = "non-NULL mapping";
@@ -857,7 +858,13 @@ static int free_tail_pages_check(struct
 		ret = 0;
 		goto out;
 	}
-	if (page->mapping != TAIL_MAPPING) {
+	/* mapping in first tail page is used for compound_mapcount() */
+	if (page - head_page == 1) {
+		if (unlikely(compound_mapcount(page))) {
+			bad_page(page, "nonzero compound_mapcount", 0);
+			goto out;
+		}
+	} else if (page->mapping != TAIL_MAPPING) {
 		bad_page(page, "corrupted mapping in tail page", 0);
 		goto out;
 	}
@@ -1335,7 +1342,7 @@ static inline int check_new_page(struct
 	const char *bad_reason = NULL;
 	unsigned long bad_flags = 0;
 
-	if (unlikely(page_mapcount(page)))
+	if (unlikely(atomic_read(&page->_mapcount) != -1))
 		bad_reason = "nonzero mapcount";
 	if (unlikely(page->mapping != NULL))
 		bad_reason = "non-NULL mapping";
diff -puN mm/rmap.c~mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps mm/rmap.c
--- a/mm/rmap.c~mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps
+++ a/mm/rmap.c
@@ -1122,7 +1122,7 @@ static void __page_check_anon_rmap(struc
 	 * over the call to page_add_new_anon_rmap.
 	 */
 	BUG_ON(page_anon_vma(page)->root != vma->anon_vma->root);
-	BUG_ON(page->index != linear_page_index(vma, address));
+	BUG_ON(page_to_pgoff(page) != linear_page_index(vma, address));
 #endif
 }
 
@@ -1152,9 +1152,28 @@ void page_add_anon_rmap(struct page *pag
 void do_page_add_anon_rmap(struct page *page,
 	struct vm_area_struct *vma, unsigned long address, int flags)
 {
-	int first = atomic_inc_and_test(&page->_mapcount);
+	bool compound = flags & RMAP_COMPOUND;
+	bool first;
+
+	if (PageTransCompound(page)) {
+		VM_BUG_ON_PAGE(!PageLocked(page), page);
+		if (compound) {
+			atomic_t *mapcount;
+
+			VM_BUG_ON_PAGE(!PageTransHuge(page), page);
+			mapcount = compound_mapcount_ptr(page);
+			first = atomic_inc_and_test(mapcount);
+		} else {
+			/* Anon THP always mapped first with PMD */
+			first = 0;
+			VM_BUG_ON_PAGE(!page_mapcount(page), page);
+			atomic_inc(&page->_mapcount);
+		}
+	} else {
+		first = atomic_inc_and_test(&page->_mapcount);
+	}
+
 	if (first) {
-		bool compound = flags & RMAP_COMPOUND;
 		int nr = compound ? hpage_nr_pages(page) : 1;
 		/*
 		 * We use the irq-unsafe __{inc|mod}_zone_page_stat because
@@ -1173,6 +1192,7 @@ void do_page_add_anon_rmap(struct page *
 		return;
 
 	VM_BUG_ON_PAGE(!PageLocked(page), page);
+
 	/* address might be in next vma when migration races vma_adjust */
 	if (first)
 		__page_set_anon_rmap(page, vma, address,
@@ -1199,10 +1219,16 @@ void page_add_new_anon_rmap(struct page
 
 	VM_BUG_ON_VMA(address < vma->vm_start || address >= vma->vm_end, vma);
 	SetPageSwapBacked(page);
-	atomic_set(&page->_mapcount, 0); /* increment count (starts at -1) */
 	if (compound) {
 		VM_BUG_ON_PAGE(!PageTransHuge(page), page);
+		/* increment count (starts at -1) */
+		atomic_set(compound_mapcount_ptr(page), 0);
 		__inc_zone_page_state(page, NR_ANON_TRANSPARENT_HUGEPAGES);
+	} else {
+		/* Anon THP always mapped first with PMD */
+		VM_BUG_ON_PAGE(PageTransCompound(page), page);
+		/* increment count (starts at -1) */
+		atomic_set(&page->_mapcount, 0);
 	}
 	__mod_zone_page_state(page_zone(page), NR_ANON_PAGES, nr);
 	__page_set_anon_rmap(page, vma, address, 1);
@@ -1232,12 +1258,15 @@ static void page_remove_file_rmap(struct
 
 	memcg = mem_cgroup_begin_page_stat(page);
 
-	/* page still mapped by someone else? */
-	if (!atomic_add_negative(-1, &page->_mapcount))
+	/* Hugepages are not counted in NR_FILE_MAPPED for now. */
+	if (unlikely(PageHuge(page))) {
+		/* hugetlb pages are always mapped with pmds */
+		atomic_dec(compound_mapcount_ptr(page));
 		goto out;
+	}
 
-	/* Hugepages are not counted in NR_FILE_MAPPED for now. */
-	if (unlikely(PageHuge(page)))
+	/* page still mapped by someone else? */
+	if (!atomic_add_negative(-1, &page->_mapcount))
 		goto out;
 
 	/*
@@ -1254,6 +1283,39 @@ out:
 	mem_cgroup_end_page_stat(memcg);
 }
 
+static void page_remove_anon_compound_rmap(struct page *page)
+{
+	int i, nr;
+
+	if (!atomic_add_negative(-1, compound_mapcount_ptr(page)))
+		return;
+
+	/* Hugepages are not counted in NR_ANON_PAGES for now. */
+	if (unlikely(PageHuge(page)))
+		return;
+
+	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
+		return;
+
+	__dec_zone_page_state(page, NR_ANON_TRANSPARENT_HUGEPAGES);
+
+	if (TestClearPageDoubleMap(page)) {
+		/*
+		 * Subpages can be mapped with PTEs too. Check how many of
+		 * themi are still mapped.
+		 */
+		for (i = 0, nr = 0; i < HPAGE_PMD_NR; i++) {
+			if (atomic_add_negative(-1, &page[i]._mapcount))
+				nr++;
+		}
+	} else {
+		nr = HPAGE_PMD_NR;
+	}
+
+	if (nr)
+		__mod_zone_page_state(page_zone(page), NR_ANON_PAGES, -nr);
+}
+
 /**
  * page_remove_rmap - take down pte mapping from a page
  * @page:	page to remove mapping from
@@ -1263,33 +1325,25 @@ out:
  */
 void page_remove_rmap(struct page *page, bool compound)
 {
-	int nr = compound ? hpage_nr_pages(page) : 1;
-
 	if (!PageAnon(page)) {
 		VM_BUG_ON_PAGE(compound && !PageHuge(page), page);
 		page_remove_file_rmap(page);
 		return;
 	}
 
+	if (compound)
+		return page_remove_anon_compound_rmap(page);
+
 	/* page still mapped by someone else? */
 	if (!atomic_add_negative(-1, &page->_mapcount))
 		return;
 
-	/* Hugepages are not counted in NR_ANON_PAGES for now. */
-	if (unlikely(PageHuge(page)))
-		return;
-
 	/*
 	 * We use the irq-unsafe __{inc|mod}_zone_page_stat because
 	 * these counters are not modified in interrupt context, and
 	 * pte lock(a spinlock) is held, which implies preemption disabled.
 	 */
-	if (compound) {
-		VM_BUG_ON_PAGE(!PageTransHuge(page), page);
-		__dec_zone_page_state(page, NR_ANON_TRANSPARENT_HUGEPAGES);
-	}
-
-	__mod_zone_page_state(page_zone(page), NR_ANON_PAGES, -nr);
+	__dec_zone_page_state(page, NR_ANON_PAGES);
 
 	if (unlikely(PageMlocked(page)))
 		clear_page_mlock(page);
@@ -1710,7 +1764,7 @@ void hugepage_add_anon_rmap(struct page
 	BUG_ON(!PageLocked(page));
 	BUG_ON(!anon_vma);
 	/* address might be in next vma when migration races vma_adjust */
-	first = atomic_inc_and_test(&page->_mapcount);
+	first = atomic_inc_and_test(compound_mapcount_ptr(page));
 	if (first)
 		__hugepage_set_anon_rmap(page, vma, address, 0);
 }
@@ -1719,7 +1773,7 @@ void hugepage_add_new_anon_rmap(struct p
 			struct vm_area_struct *vma, unsigned long address)
 {
 	BUG_ON(address < vma->vm_start || address >= vma->vm_end);
-	atomic_set(&page->_mapcount, 0);
+	atomic_set(compound_mapcount_ptr(page), 0);
 	__hugepage_set_anon_rmap(page, vma, address, 1);
 }
 #endif /* CONFIG_HUGETLB_PAGE */
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

thp-update-documentation.patch
thp-allow-mlocked-thp-again.patch
mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting.patch
thp-add-debugfs-handle-to-split-all-huge-pages.patch
thp-increase-split_huge_page-success-rate.patch
thp-fix-split_huge_page-after-mremap-of-thp.patch
memblock-fix-section-mismatch.patch
mm-fix-locking-order-in-mm_take_all_locks.patch
mm-make-optimistic-check-for-swapin-readahead-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-2.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-3.patch

