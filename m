From: akpm@linux-foundation.org
Subject: + thp-introduce-deferred_split_huge_page.patch added to -mm tree
Date: Wed, 14 Oct 2015 14:14:04 -0700
Message-ID: <561ec59c.Pzis+bFM4OKHOB2r%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50376 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754645AbbJNVOG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 14 Oct 2015 17:14:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, aneesh.kumar@linux.vnet.ibm.com, cl@linux.com, dave.hansen@intel.com, hannes@cmpxchg.org, hughd@google.com, jmarchan@redhat.com, mgorman@suse.de, mhocko@suse.cz, n-horiguchi@ah.jp.nec.com, riel@redhat.com, rientjes@google.com, sasha.levin@oracle.com, steve.capper@linaro.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: thp: introduce deferred_split_huge_page()
has been added to the -mm tree.  Its filename is
     thp-introduce-deferred_split_huge_page.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/thp-introduce-deferred_split_huge_page.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/thp-introduce-deferred_split_huge_page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Vlastimil Babka <vbabka@suse.cz>
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
 mm/huge_memory.c         |  137 +++++++++++++++++++++++++++++++++++--
 mm/migrate.c             |    1 
 mm/page_alloc.c          |   27 +++++--
 mm/rmap.c                |    7 +
 7 files changed, 172 insertions(+), 12 deletions(-)

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
@@ -493,6 +493,9 @@ enum compound_dtor_id {
 #ifdef CONFIG_HUGETLB_PAGE
 	HUGETLB_PAGE_DTOR,
 #endif
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	TRANSHUGE_PAGE_DTOR,
+#endif
 	NR_COMPOUND_DTORS,
 };
 extern compound_page_dtor * const compound_page_dtors[];
@@ -522,6 +525,8 @@ static inline void set_compound_order(st
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
@@ -137,6 +137,10 @@ static struct khugepaged_scan khugepaged
 	.mm_head = LIST_HEAD_INIT(khugepaged_scan.mm_head),
 };
 
+static DEFINE_SPINLOCK(split_queue_lock);
+static LIST_HEAD(split_queue);
+static unsigned long split_queue_len;
+static struct shrinker deferred_split_shrinker;
 
 static void set_recommended_min_free_kbytes(void)
 {
@@ -697,6 +701,9 @@ static int __init hugepage_init(void)
 	err = register_shrinker(&huge_zero_page_shrinker);
 	if (err)
 		goto err_hzp_shrinker;
+	err = register_shrinker(&deferred_split_shrinker);
+	if (err)
+		goto err_split_shrinker;
 
 	/*
 	 * By default disable transparent hugepages on smaller systems,
@@ -714,6 +721,8 @@ static int __init hugepage_init(void)
 
 	return 0;
 err_khugepaged:
+	unregister_shrinker(&deferred_split_shrinker);
+err_split_shrinker:
 	unregister_shrinker(&huge_zero_page_shrinker);
 err_hzp_shrinker:
 	khugepaged_slab_exit();
@@ -770,6 +779,27 @@ static inline pmd_t mk_huge_pmd(struct p
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
@@ -926,6 +956,7 @@ int do_huge_pmd_anonymous_page(struct mm
 		count_vm_event(THP_FAULT_FALLBACK);
 		return VM_FAULT_FALLBACK;
 	}
+	prep_transhuge_page(page);
 	return __do_huge_pmd_anonymous_page(mm, vma, address, pmd, page, gfp,
 					    flags);
 }
@@ -1222,7 +1253,9 @@ alloc:
 	} else
 		new_page = NULL;
 
-	if (unlikely(!new_page)) {
+	if (likely(new_page)) {
+		prep_transhuge_page(new_page);
+	} else {
 		if (!page) {
 			split_huge_pmd(vma, pmd, address);
 			ret |= VM_FAULT_FALLBACK;
@@ -2138,6 +2171,7 @@ khugepaged_alloc_page(struct page **hpag
 		return NULL;
 	}
 
+	prep_transhuge_page(*hpage);
 	count_vm_event(THP_COLLAPSE_ALLOC);
 	return *hpage;
 }
@@ -2149,8 +2183,12 @@ static int khugepaged_find_target_node(v
 
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
@@ -3123,7 +3161,7 @@ static int __split_huge_page_tail(struct
 		set_page_idle(page_tail);
 
 	/* ->mapping in first tail page is compound_mapcount */
-	VM_BUG_ON_PAGE(tail != 1 && page_tail->mapping != TAIL_MAPPING,
+	VM_BUG_ON_PAGE(tail > 2 && page_tail->mapping != TAIL_MAPPING,
 			page_tail);
 	page_tail->mapping = head->mapping;
 
@@ -3145,6 +3183,13 @@ static void __split_huge_page(struct pag
 	spin_lock_irq(&zone->lru_lock);
 	lruvec = mem_cgroup_page_lruvec(head, zone);
 
+	spin_lock(&split_queue_lock);
+	if (!list_empty(page_deferred_list(head))) {
+		split_queue_len--;
+		list_del(page_deferred_list(head));
+	}
+	spin_unlock(&split_queue_lock);
+
 	/* complete memcg works before add pages to LRU */
 	mem_cgroup_split_huge_fixup(head);
 
@@ -3256,3 +3301,87 @@ out:
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
@@ -1758,6 +1758,7 @@ int migrate_misplaced_transhuge_page(str
 		HPAGE_PMD_ORDER);
 	if (!new_page)
 		goto out_fail;
+	prep_transhuge_page(new_page);
 
 	isolated = numamigrate_isolate_page(pgdat, page);
 	if (!isolated) {
diff -puN mm/page_alloc.c~thp-introduce-deferred_split_huge_page mm/page_alloc.c
--- a/mm/page_alloc.c~thp-introduce-deferred_split_huge_page
+++ a/mm/page_alloc.c
@@ -229,13 +229,15 @@ static char * const zone_names[MAX_NR_ZO
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
@@ -457,7 +459,7 @@ out:
  * This usage means that zero-order pages may not be compound.
  */
 
-static void free_compound_page(struct page *page)
+void free_compound_page(struct page *page)
 {
 	__free_pages_ok(page, compound_order(page));
 }
@@ -865,15 +867,26 @@ static int free_tail_pages_check(struct
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
@@ -1290,8 +1290,10 @@ static void page_remove_anon_compound_rm
 		nr = HPAGE_PMD_NR;
 	}
 
-	if (nr)
+	if (nr) {
 		__mod_zone_page_state(page_zone(page), NR_ANON_PAGES, -nr);
+		deferred_split_huge_page(page);
+	}
 }
 
 /**
@@ -1326,6 +1328,9 @@ void page_remove_rmap(struct page *page,
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

rcu-force-alignment-on-struct-callback_head-rcu_head.patch
mm-make-optimistic-check-for-swapin-readahead-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-2.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-3.patch
mm-drop-page-slab_page.patch
slab-slub-use-page-rcu_head-instead-of-page-lru-plus-cast.patch
zsmalloc-use-page-private-instead-of-page-first_page.patch
mm-pack-compound_dtor-and-compound_order-into-one-word-in-struct-page.patch
mm-make-compound_head-robust.patch
mm-make-compound_head-robust-fix.patch
mm-use-unsigned-int-for-page-order.patch
mm-use-unsigned-int-for-compound_dtor-compound_order-on-64bit.patch
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
mm-differentiate-page_mapped-from-page_mapcount-for-compound-pages.patch
mm-numa-skip-pte-mapped-thp-on-numa-fault.patch
thp-implement-split_huge_pmd.patch
thp-add-option-to-setup-migration-entries-during-pmd-split.patch
thp-mm-split_huge_page-caller-need-to-lock-page.patch
thp-reintroduce-split_huge_page.patch
migrate_pages-try-to-split-pages-on-qeueuing.patch
thp-introduce-deferred_split_huge_page.patch
mm-re-enable-thp.patch
thp-update-documentation.patch
thp-allow-mlocked-thp-again.patch
mm-support-madvisemadv_free-fix-3.patch

