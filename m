From: akpm@linux-foundation.org
Subject: [merged] thp-introduce-deferred_split_huge_page.patch removed
 from -mm tree
Date: Tue, 19 Jan 2016 12:03:01 -0800
Message-ID: <569e9675.c5k5A5GqDOhfrjTa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43141 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757203AbcASUDC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jan 2016 15:03:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, aneesh.kumar@linux.vnet.ibm.com, cl@linux.com, dave.hansen@intel.com, hannes@cmpxchg.org, hughd@google.com, jmarchan@redhat.com, mgorman@suse.de, mhocko@suse.cz, n-horiguchi@ah.jp.nec.com, riel@redhat.com, rientjes@google.com, sasha.levin@oracle.com, steve.capper@linaro.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: thp: introduce deferred_split_huge_page()
has been removed from the -mm tree.  Its filename was
     thp-introduce-deferred_split_huge_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: thp: introduce deferred_split_huge_page()

Currently we don't split huge page on partial unmap. It's not an ideal
situation. It can lead to memory overhead.

Furtunately, we can detect partial unmap on page_remove_rmap(). But we
cannot call split_huge_page() from there due to locking context.

It's also counterproductive to do directly from munmap() codepath: in
many cases we will hit this from exit(2) and splitting the huge page
just to free it up in small pages is not what we really want.

The patch introduce deferred_split_huge_page() which put the huge page
into queue for splitting. The splitting itself will happen when we get
memory pressure via shrinker interface. The page will be dropped from
list on freeing through compound page destructor.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Tested-by: Sasha Levin <sasha.levin@oracle.com>
Tested-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Jerome Marchand <jmarchan@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Steve Capper <steve.capper@linaro.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h  |    5 +
 include/linux/mm.h       |    5 +
 include/linux/mm_types.h |    2 
 mm/huge_memory.c         |  139 +++++++++++++++++++++++++++++++++++--
 mm/migrate.c             |    1 
 mm/page_alloc.c          |   27 +++++--
 mm/rmap.c                |    7 +
 7 files changed, 174 insertions(+), 12 deletions(-)

diff -puN include/linux/huge_mm.h~thp-introduce-deferred_split_huge_page include/linux/huge_mm.h
--- a/include/linux/huge_mm.h~thp-introduce-deferred_split_huge_page
+++ a/include/linux/huge_mm.h
@@ -90,11 +90,15 @@ extern bool is_vma_temporary_stack(struc
 
 extern unsigned long transparent_hugepage_flags;
 
+extern void prep_transhuge_page(struct page *page);
+extern void free_transhuge_page(struct page *page);
+
 int split_huge_page_to_list(struct page *page, struct list_head *list);
 static inline int split_huge_page(struct page *page)
 {
 	return split_huge_page_to_list(page, NULL);
 }
+void deferred_split_huge_page(struct page *page);
 
 void __split_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
 		unsigned long address);
@@ -170,6 +174,7 @@ static inline int split_huge_page(struct
 {
 	return 0;
 }
+static inline void deferred_split_huge_page(struct page *page) {}
 #define split_huge_pmd(__vma, __pmd, __address)	\
 	do { } while (0)
 static inline int hugepage_madvise(struct vm_area_struct *vma,
diff -puN include/linux/mm.h~thp-introduce-deferred_split_huge_page include/linux/mm.h
--- a/include/linux/mm.h~thp-introduce-deferred_split_huge_page
+++ a/include/linux/mm.h
@@ -508,6 +508,9 @@ enum compound_dtor_id {
 #ifdef CONFIG_HUGETLB_PAGE
 	HUGETLB_PAGE_DTOR,
 #endif
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	TRANSHUGE_PAGE_DTOR,
+#endif
 	NR_COMPOUND_DTORS,
 };
 extern compound_page_dtor * const compound_page_dtors[];
@@ -537,6 +540,8 @@ static inline void set_compound_order(st
 	page[1].compound_order = order;
 }
 
+void free_compound_page(struct page *page);
+
 #ifdef CONFIG_MMU
 /*
  * Do pte_mkwrite, but only if the vma says VM_WRITE.  We do this when
diff -puN include/linux/mm_types.h~thp-introduce-deferred_split_huge_page include/linux/mm_types.h
--- a/include/linux/mm_types.h~thp-introduce-deferred_split_huge_page
+++ a/include/linux/mm_types.h
@@ -55,6 +55,7 @@ struct page {
 						 */
 		void *s_mem;			/* slab first object */
 		atomic_t compound_mapcount;	/* first tail page */
+		/* page_deferred_list().next	 -- second tail page */
 	};
 
 	/* Second double word */
@@ -62,6 +63,7 @@ struct page {
 		union {
 			pgoff_t index;		/* Our offset within mapping. */
 			void *freelist;		/* sl[aou]b first free object */
+			/* page_deferred_list().prev	-- second tail page */
 		};
 
 		union {
diff -puN mm/huge_memory.c~thp-introduce-deferred_split_huge_page mm/huge_memory.c
--- a/mm/huge_memory.c~thp-introduce-deferred_split_huge_page
+++ a/mm/huge_memory.c
@@ -135,6 +135,10 @@ static struct khugepaged_scan khugepaged
 	.mm_head = LIST_HEAD_INIT(khugepaged_scan.mm_head),
 };
 
+static DEFINE_SPINLOCK(split_queue_lock);
+static LIST_HEAD(split_queue);
+static unsigned long split_queue_len;
+static struct shrinker deferred_split_shrinker;
 
 static void set_recommended_min_free_kbytes(void)
 {
@@ -667,6 +671,9 @@ static int __init hugepage_init(void)
 	err = register_shrinker(&huge_zero_page_shrinker);
 	if (err)
 		goto err_hzp_shrinker;
+	err = register_shrinker(&deferred_split_shrinker);
+	if (err)
+		goto err_split_shrinker;
 
 	/*
 	 * By default disable transparent hugepages on smaller systems,
@@ -684,6 +691,8 @@ static int __init hugepage_init(void)
 
 	return 0;
 err_khugepaged:
+	unregister_shrinker(&deferred_split_shrinker);
+err_split_shrinker:
 	unregister_shrinker(&huge_zero_page_shrinker);
 err_hzp_shrinker:
 	khugepaged_slab_exit();
@@ -740,6 +749,27 @@ static inline pmd_t mk_huge_pmd(struct p
 	return entry;
 }
 
+static inline struct list_head *page_deferred_list(struct page *page)
+{
+	/*
+	 * ->lru in the tail pages is occupied by compound_head.
+	 * Let's use ->mapping + ->index in the second tail page as list_head.
+	 */
+	return (struct list_head *)&page[2].mapping;
+}
+
+void prep_transhuge_page(struct page *page)
+{
+	/*
+	 * we use page->mapping and page->indexlru in second tail page
+	 * as list_head: assuming THP order >= 2
+	 */
+	BUILD_BUG_ON(HPAGE_PMD_ORDER < 2);
+
+	INIT_LIST_HEAD(page_deferred_list(page));
+	set_compound_page_dtor(page, TRANSHUGE_PAGE_DTOR);
+}
+
 static int __do_huge_pmd_anonymous_page(struct mm_struct *mm,
 					struct vm_area_struct *vma,
 					unsigned long address, pmd_t *pmd,
@@ -896,6 +926,7 @@ int do_huge_pmd_anonymous_page(struct mm
 		count_vm_event(THP_FAULT_FALLBACK);
 		return VM_FAULT_FALLBACK;
 	}
+	prep_transhuge_page(page);
 	return __do_huge_pmd_anonymous_page(mm, vma, address, pmd, page, gfp,
 					    flags);
 }
@@ -1192,7 +1223,9 @@ alloc:
 	} else
 		new_page = NULL;
 
-	if (unlikely(!new_page)) {
+	if (likely(new_page)) {
+		prep_transhuge_page(new_page);
+	} else {
 		if (!page) {
 			split_huge_pmd(vma, pmd, address);
 			ret |= VM_FAULT_FALLBACK;
@@ -2109,6 +2142,7 @@ khugepaged_alloc_page(struct page **hpag
 		return NULL;
 	}
 
+	prep_transhuge_page(*hpage);
 	count_vm_event(THP_COLLAPSE_ALLOC);
 	return *hpage;
 }
@@ -2120,8 +2154,12 @@ static int khugepaged_find_target_node(v
 
 static inline struct page *alloc_hugepage(int defrag)
 {
-	return alloc_pages(alloc_hugepage_gfpmask(defrag, 0),
-			   HPAGE_PMD_ORDER);
+	struct page *page;
+
+	page = alloc_pages(alloc_hugepage_gfpmask(defrag, 0), HPAGE_PMD_ORDER);
+	if (page)
+		prep_transhuge_page(page);
+	return page;
 }
 
 static struct page *khugepaged_alloc_hugepage(bool *wait)
@@ -3098,7 +3136,7 @@ static int __split_huge_page_tail(struct
 		set_page_idle(page_tail);
 
 	/* ->mapping in first tail page is compound_mapcount */
-	VM_BUG_ON_PAGE(tail != 1 && page_tail->mapping != TAIL_MAPPING,
+	VM_BUG_ON_PAGE(tail > 2 && page_tail->mapping != TAIL_MAPPING,
 			page_tail);
 	page_tail->mapping = head->mapping;
 
@@ -3207,12 +3245,20 @@ int split_huge_page_to_list(struct page
 	freeze_page(anon_vma, head);
 	VM_BUG_ON_PAGE(compound_mapcount(head), head);
 
+	/* Prevent deferred_split_scan() touching ->_count */
+	spin_lock(&split_queue_lock);
 	count = page_count(head);
 	mapcount = total_mapcount(head);
 	if (mapcount == count - 1) {
+		if (!list_empty(page_deferred_list(head))) {
+			split_queue_len--;
+			list_del(page_deferred_list(head));
+		}
+		spin_unlock(&split_queue_lock);
 		__split_huge_page(page, list);
 		ret = 0;
 	} else if (IS_ENABLED(CONFIG_DEBUG_VM) && mapcount > count - 1) {
+		spin_unlock(&split_queue_lock);
 		pr_alert("total_mapcount: %u, page_count(): %u\n",
 				mapcount, count);
 		if (PageTail(page))
@@ -3220,6 +3266,7 @@ int split_huge_page_to_list(struct page
 		dump_page(page, "total_mapcount(head) > page_count(head) - 1");
 		BUG();
 	} else {
+		spin_unlock(&split_queue_lock);
 		unfreeze_page(anon_vma, head);
 		ret = -EBUSY;
 	}
@@ -3231,3 +3278,87 @@ out:
 	count_vm_event(!ret ? THP_SPLIT_PAGE : THP_SPLIT_PAGE_FAILED);
 	return ret;
 }
+
+void free_transhuge_page(struct page *page)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&split_queue_lock, flags);
+	if (!list_empty(page_deferred_list(page))) {
+		split_queue_len--;
+		list_del(page_deferred_list(page));
+	}
+	spin_unlock_irqrestore(&split_queue_lock, flags);
+	free_compound_page(page);
+}
+
+void deferred_split_huge_page(struct page *page)
+{
+	unsigned long flags;
+
+	VM_BUG_ON_PAGE(!PageTransHuge(page), page);
+
+	spin_lock_irqsave(&split_queue_lock, flags);
+	if (list_empty(page_deferred_list(page))) {
+		list_add_tail(page_deferred_list(page), &split_queue);
+		split_queue_len++;
+	}
+	spin_unlock_irqrestore(&split_queue_lock, flags);
+}
+
+static unsigned long deferred_split_count(struct shrinker *shrink,
+		struct shrink_control *sc)
+{
+	/*
+	 * Split a page from split_queue will free up at least one page,
+	 * at most HPAGE_PMD_NR - 1. We don't track exact number.
+	 * Let's use HPAGE_PMD_NR / 2 as ballpark.
+	 */
+	return ACCESS_ONCE(split_queue_len) * HPAGE_PMD_NR / 2;
+}
+
+static unsigned long deferred_split_scan(struct shrinker *shrink,
+		struct shrink_control *sc)
+{
+	unsigned long flags;
+	LIST_HEAD(list), *pos, *next;
+	struct page *page;
+	int split = 0;
+
+	spin_lock_irqsave(&split_queue_lock, flags);
+	list_splice_init(&split_queue, &list);
+
+	/* Take pin on all head pages to avoid freeing them under us */
+	list_for_each_safe(pos, next, &list) {
+		page = list_entry((void *)pos, struct page, mapping);
+		page = compound_head(page);
+		/* race with put_compound_page() */
+		if (!get_page_unless_zero(page)) {
+			list_del_init(page_deferred_list(page));
+			split_queue_len--;
+		}
+	}
+	spin_unlock_irqrestore(&split_queue_lock, flags);
+
+	list_for_each_safe(pos, next, &list) {
+		page = list_entry((void *)pos, struct page, mapping);
+		lock_page(page);
+		/* split_huge_page() removes page from list on success */
+		if (!split_huge_page(page))
+			split++;
+		unlock_page(page);
+		put_page(page);
+	}
+
+	spin_lock_irqsave(&split_queue_lock, flags);
+	list_splice_tail(&list, &split_queue);
+	spin_unlock_irqrestore(&split_queue_lock, flags);
+
+	return split * HPAGE_PMD_NR / 2;
+}
+
+static struct shrinker deferred_split_shrinker = {
+	.count_objects = deferred_split_count,
+	.scan_objects = deferred_split_scan,
+	.seeks = DEFAULT_SEEKS,
+};
diff -puN mm/migrate.c~thp-introduce-deferred_split_huge_page mm/migrate.c
--- a/mm/migrate.c~thp-introduce-deferred_split_huge_page
+++ a/mm/migrate.c
@@ -1760,6 +1760,7 @@ int migrate_misplaced_transhuge_page(str
 		HPAGE_PMD_ORDER);
 	if (!new_page)
 		goto out_fail;
+	prep_transhuge_page(new_page);
 
 	isolated = numamigrate_isolate_page(pgdat, page);
 	if (!isolated) {
diff -puN mm/page_alloc.c~thp-introduce-deferred_split_huge_page mm/page_alloc.c
--- a/mm/page_alloc.c~thp-introduce-deferred_split_huge_page
+++ a/mm/page_alloc.c
@@ -222,13 +222,15 @@ static char * const zone_names[MAX_NR_ZO
 #endif
 };
 
-static void free_compound_page(struct page *page);
 compound_page_dtor * const compound_page_dtors[] = {
 	NULL,
 	free_compound_page,
 #ifdef CONFIG_HUGETLB_PAGE
 	free_huge_page,
 #endif
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	free_transhuge_page,
+#endif
 };
 
 int min_free_kbytes = 1024;
@@ -450,7 +452,7 @@ out:
  * This usage means that zero-order pages may not be compound.
  */
 
-static void free_compound_page(struct page *page)
+void free_compound_page(struct page *page)
 {
 	__free_pages_ok(page, compound_order(page));
 }
@@ -858,15 +860,26 @@ static int free_tail_pages_check(struct
 		ret = 0;
 		goto out;
 	}
-	/* mapping in first tail page is used for compound_mapcount() */
-	if (page - head_page == 1) {
+	switch (page - head_page) {
+	case 1:
+		/* the first tail page: ->mapping is compound_mapcount() */
 		if (unlikely(compound_mapcount(page))) {
 			bad_page(page, "nonzero compound_mapcount", 0);
 			goto out;
 		}
-	} else if (page->mapping != TAIL_MAPPING) {
-		bad_page(page, "corrupted mapping in tail page", 0);
-		goto out;
+		break;
+	case 2:
+		/*
+		 * the second tail page: ->mapping is
+		 * page_deferred_list().next -- ignore value.
+		 */
+		break;
+	default:
+		if (page->mapping != TAIL_MAPPING) {
+			bad_page(page, "corrupted mapping in tail page", 0);
+			goto out;
+		}
+		break;
 	}
 	if (unlikely(!PageTail(page))) {
 		bad_page(page, "PageTail not set", 0);
diff -puN mm/rmap.c~thp-introduce-deferred_split_huge_page mm/rmap.c
--- a/mm/rmap.c~thp-introduce-deferred_split_huge_page
+++ a/mm/rmap.c
@@ -1282,8 +1282,10 @@ static void page_remove_anon_compound_rm
 		nr = HPAGE_PMD_NR;
 	}
 
-	if (nr)
+	if (nr) {
 		__mod_zone_page_state(page_zone(page), NR_ANON_PAGES, -nr);
+		deferred_split_huge_page(page);
+	}
 }
 
 /**
@@ -1318,6 +1320,9 @@ void page_remove_rmap(struct page *page,
 	if (unlikely(PageMlocked(page)))
 		clear_page_mlock(page);
 
+	if (PageTransCompound(page))
+		deferred_split_huge_page(compound_head(page));
+
 	/*
 	 * It would be tidy to reset the PageAnon mapping here,
 	 * but that might overwrite a racing page_add_anon_rmap
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

