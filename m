Return-Path: <SRS0=U74d=BZ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DATE_IN_PAST_12_24,
	DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA2F9C433E1
	for <mm-commits@archiver.kernel.org>; Sat, 15 Aug 2020 22:11:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8ACC420657
	for <mm-commits@archiver.kernel.org>; Sat, 15 Aug 2020 22:11:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597529497;
	bh=kvdylF6mLbCTUnr58EVYolLOWOUTaTZNEqOWOPreU6s=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=LXe5j0oWZfFsxjIocx72HpJQeRXZd+A+xFSQ6Vtko5vs8nV1NRPesc6EGojhd6Qc1
	 CC48u7T4kEhsNnMVQuvb6DxuyMLIuoVUBnPiXdMDJAHjtzrZOFMie2bVmK3aYIiTAZ
	 9LPNrucdKhIu7a3DFhObseXO9ei7K0U/5XRy65gY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729320AbgHOWLe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 15 Aug 2020 18:11:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:41772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729013AbgHOWKa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 15 Aug 2020 18:10:30 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6E18322C9F;
        Sat, 15 Aug 2020 00:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597451437;
        bh=kvdylF6mLbCTUnr58EVYolLOWOUTaTZNEqOWOPreU6s=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=sKWKTh+nPIlPPOwDd9oe8++cNGkTuJD4Wf2CtetGIlhjYHCsb3W2ajK9aS1vvpkAp
         +pK0zE3GrkhCFUcbWA0ZO7a+Gl606bWjlGdIa+8mEHdzFmYt56rDsiLHFTynT4WWDl
         hECmriMvFG0hnQ1bB8fVf4nG3+gIFhz8NIngy0tM=
Date:   Fri, 14 Aug 2020 17:30:37 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com,
        kirill.shutemov@linux.intel.com, linux-mm@kvack.org,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, william.kucharski@oracle.com,
        willy@infradead.org, ziy@nvidia.com
Subject:  [patch 11/39] mm: replace hpage_nr_pages with
 thp_nr_pages
Message-ID: <20200815003037.ZD_wl4cvk%akpm@linux-foundation.org>
In-Reply-To: <20200814172939.55d6d80b6e21e4241f1ee1f3@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: replace hpage_nr_pages with thp_nr_pages

The thp prefix is more frequently used than hpage and we should be
consistent between the various functions.

[akpm@linux-foundation.org: fix mm/migrate.c]
Link: http://lkml.kernel.org/r/20200629151959.15779-6-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: William Kucharski <william.kucharski@oracle.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h   |   13 +++++++++----
 include/linux/mm_inline.h |    6 +++---
 include/linux/pagemap.h   |    6 +++---
 mm/compaction.c           |    2 +-
 mm/filemap.c              |    2 +-
 mm/gup.c                  |    2 +-
 mm/internal.h             |    2 +-
 mm/memcontrol.c           |   10 +++++-----
 mm/memory_hotplug.c       |    7 +++----
 mm/mempolicy.c            |    2 +-
 mm/migrate.c              |   18 +++++++++---------
 mm/mlock.c                |    9 ++++-----
 mm/page_io.c              |    2 +-
 mm/page_vma_mapped.c      |    2 +-
 mm/rmap.c                 |    8 ++++----
 mm/swap.c                 |   16 ++++++++--------
 mm/swap_state.c           |    6 +++---
 mm/swapfile.c             |    2 +-
 mm/vmscan.c               |    6 +++---
 mm/workingset.c           |    6 +++---
 20 files changed, 65 insertions(+), 62 deletions(-)

--- a/include/linux/huge_mm.h~mm-replace-hpage_nr_pages-with-thp_nr_pages
+++ a/include/linux/huge_mm.h
@@ -271,9 +271,14 @@ static inline unsigned int thp_order(str
 	return 0;
 }
 
-static inline int hpage_nr_pages(struct page *page)
+/**
+ * thp_nr_pages - The number of regular pages in this huge page.
+ * @page: The head page of a huge page.
+ */
+static inline int thp_nr_pages(struct page *page)
 {
-	if (unlikely(PageTransHuge(page)))
+	VM_BUG_ON_PGFLAGS(PageTail(page), page);
+	if (PageHead(page))
 		return HPAGE_PMD_NR;
 	return 1;
 }
@@ -336,9 +341,9 @@ static inline unsigned int thp_order(str
 	return 0;
 }
 
-static inline int hpage_nr_pages(struct page *page)
+static inline int thp_nr_pages(struct page *page)
 {
-	VM_BUG_ON_PAGE(PageTail(page), page);
+	VM_BUG_ON_PGFLAGS(PageTail(page), page);
 	return 1;
 }
 
--- a/include/linux/mm_inline.h~mm-replace-hpage_nr_pages-with-thp_nr_pages
+++ a/include/linux/mm_inline.h
@@ -48,14 +48,14 @@ static __always_inline void update_lru_s
 static __always_inline void add_page_to_lru_list(struct page *page,
 				struct lruvec *lruvec, enum lru_list lru)
 {
-	update_lru_size(lruvec, lru, page_zonenum(page), hpage_nr_pages(page));
+	update_lru_size(lruvec, lru, page_zonenum(page), thp_nr_pages(page));
 	list_add(&page->lru, &lruvec->lists[lru]);
 }
 
 static __always_inline void add_page_to_lru_list_tail(struct page *page,
 				struct lruvec *lruvec, enum lru_list lru)
 {
-	update_lru_size(lruvec, lru, page_zonenum(page), hpage_nr_pages(page));
+	update_lru_size(lruvec, lru, page_zonenum(page), thp_nr_pages(page));
 	list_add_tail(&page->lru, &lruvec->lists[lru]);
 }
 
@@ -63,7 +63,7 @@ static __always_inline void del_page_fro
 				struct lruvec *lruvec, enum lru_list lru)
 {
 	list_del(&page->lru);
-	update_lru_size(lruvec, lru, page_zonenum(page), -hpage_nr_pages(page));
+	update_lru_size(lruvec, lru, page_zonenum(page), -thp_nr_pages(page));
 }
 
 /**
--- a/include/linux/pagemap.h~mm-replace-hpage_nr_pages-with-thp_nr_pages
+++ a/include/linux/pagemap.h
@@ -381,7 +381,7 @@ static inline struct page *find_subpage(
 	if (PageHuge(head))
 		return head;
 
-	return head + (index & (hpage_nr_pages(head) - 1));
+	return head + (index & (thp_nr_pages(head) - 1));
 }
 
 struct page *find_get_entry(struct address_space *mapping, pgoff_t offset);
@@ -773,7 +773,7 @@ static inline struct page *readahead_pag
 
 	page = xa_load(&rac->mapping->i_pages, rac->_index);
 	VM_BUG_ON_PAGE(!PageLocked(page), page);
-	rac->_batch_count = hpage_nr_pages(page);
+	rac->_batch_count = thp_nr_pages(page);
 
 	return page;
 }
@@ -796,7 +796,7 @@ static inline unsigned int __readahead_b
 		VM_BUG_ON_PAGE(!PageLocked(page), page);
 		VM_BUG_ON_PAGE(PageTail(page), page);
 		array[i++] = page;
-		rac->_batch_count += hpage_nr_pages(page);
+		rac->_batch_count += thp_nr_pages(page);
 
 		/*
 		 * The page cache isn't using multi-index entries yet,
--- a/mm/compaction.c~mm-replace-hpage_nr_pages-with-thp_nr_pages
+++ a/mm/compaction.c
@@ -1009,7 +1009,7 @@ isolate_migratepages_block(struct compac
 		del_page_from_lru_list(page, lruvec, page_lru(page));
 		mod_node_page_state(page_pgdat(page),
 				NR_ISOLATED_ANON + page_is_file_lru(page),
-				hpage_nr_pages(page));
+				thp_nr_pages(page));
 
 isolate_success:
 		list_add(&page->lru, &cc->migratepages);
--- a/mm/filemap.c~mm-replace-hpage_nr_pages-with-thp_nr_pages
+++ a/mm/filemap.c
@@ -198,7 +198,7 @@ static void unaccount_page_cache_page(st
 	if (PageHuge(page))
 		return;
 
-	nr = hpage_nr_pages(page);
+	nr = thp_nr_pages(page);
 
 	__mod_lruvec_page_state(page, NR_FILE_PAGES, -nr);
 	if (PageSwapBacked(page)) {
--- a/mm/gup.c~mm-replace-hpage_nr_pages-with-thp_nr_pages
+++ a/mm/gup.c
@@ -1637,7 +1637,7 @@ check_again:
 					mod_node_page_state(page_pgdat(head),
 							    NR_ISOLATED_ANON +
 							    page_is_file_lru(head),
-							    hpage_nr_pages(head));
+							    thp_nr_pages(head));
 				}
 			}
 		}
--- a/mm/internal.h~mm-replace-hpage_nr_pages-with-thp_nr_pages
+++ a/mm/internal.h
@@ -369,7 +369,7 @@ extern void clear_page_mlock(struct page
 static inline void mlock_migrate_page(struct page *newpage, struct page *page)
 {
 	if (TestClearPageMlocked(page)) {
-		int nr_pages = hpage_nr_pages(page);
+		int nr_pages = thp_nr_pages(page);
 
 		/* Holding pmd lock, no change in irq context: __mod is safe */
 		__mod_zone_page_state(page_zone(page), NR_MLOCK, -nr_pages);
--- a/mm/memcontrol.c~mm-replace-hpage_nr_pages-with-thp_nr_pages
+++ a/mm/memcontrol.c
@@ -5589,7 +5589,7 @@ static int mem_cgroup_move_account(struc
 {
 	struct lruvec *from_vec, *to_vec;
 	struct pglist_data *pgdat;
-	unsigned int nr_pages = compound ? hpage_nr_pages(page) : 1;
+	unsigned int nr_pages = compound ? thp_nr_pages(page) : 1;
 	int ret;
 
 	VM_BUG_ON(from == to);
@@ -6682,7 +6682,7 @@ void mem_cgroup_calculate_protection(str
  */
 int mem_cgroup_charge(struct page *page, struct mm_struct *mm, gfp_t gfp_mask)
 {
-	unsigned int nr_pages = hpage_nr_pages(page);
+	unsigned int nr_pages = thp_nr_pages(page);
 	struct mem_cgroup *memcg = NULL;
 	int ret = 0;
 
@@ -6912,7 +6912,7 @@ void mem_cgroup_migrate(struct page *old
 		return;
 
 	/* Force-charge the new page. The old one will be freed soon */
-	nr_pages = hpage_nr_pages(newpage);
+	nr_pages = thp_nr_pages(newpage);
 
 	page_counter_charge(&memcg->memory, nr_pages);
 	if (do_memsw_account())
@@ -7114,7 +7114,7 @@ void mem_cgroup_swapout(struct page *pag
 	 * ancestor for the swap instead and transfer the memory+swap charge.
 	 */
 	swap_memcg = mem_cgroup_id_get_online(memcg);
-	nr_entries = hpage_nr_pages(page);
+	nr_entries = thp_nr_pages(page);
 	/* Get references for the tail pages, too */
 	if (nr_entries > 1)
 		mem_cgroup_id_get_many(swap_memcg, nr_entries - 1);
@@ -7158,7 +7158,7 @@ void mem_cgroup_swapout(struct page *pag
  */
 int mem_cgroup_try_charge_swap(struct page *page, swp_entry_t entry)
 {
-	unsigned int nr_pages = hpage_nr_pages(page);
+	unsigned int nr_pages = thp_nr_pages(page);
 	struct page_counter *counter;
 	struct mem_cgroup *memcg;
 	unsigned short oldid;
--- a/mm/memory_hotplug.c~mm-replace-hpage_nr_pages-with-thp_nr_pages
+++ a/mm/memory_hotplug.c
@@ -1299,7 +1299,7 @@ static int
 do_migrate_range(unsigned long start_pfn, unsigned long end_pfn)
 {
 	unsigned long pfn;
-	struct page *page;
+	struct page *page, *head;
 	int ret = 0;
 	LIST_HEAD(source);
 
@@ -1307,15 +1307,14 @@ do_migrate_range(unsigned long start_pfn
 		if (!pfn_valid(pfn))
 			continue;
 		page = pfn_to_page(pfn);
+		head = compound_head(page);
 
 		if (PageHuge(page)) {
-			struct page *head = compound_head(page);
 			pfn = page_to_pfn(head) + compound_nr(head) - 1;
 			isolate_huge_page(head, &source);
 			continue;
 		} else if (PageTransHuge(page))
-			pfn = page_to_pfn(compound_head(page))
-				+ hpage_nr_pages(page) - 1;
+			pfn = page_to_pfn(head) + thp_nr_pages(page) - 1;
 
 		/*
 		 * HWPoison pages have elevated reference counts so the migration would
--- a/mm/mempolicy.c~mm-replace-hpage_nr_pages-with-thp_nr_pages
+++ a/mm/mempolicy.c
@@ -1049,7 +1049,7 @@ static int migrate_page_add(struct page
 			list_add_tail(&head->lru, pagelist);
 			mod_node_page_state(page_pgdat(head),
 				NR_ISOLATED_ANON + page_is_file_lru(head),
-				hpage_nr_pages(head));
+				thp_nr_pages(head));
 		} else if (flags & MPOL_MF_STRICT) {
 			/*
 			 * Non-movable page may reach here.  And, there may be
--- a/mm/migrate.c~mm-replace-hpage_nr_pages-with-thp_nr_pages
+++ a/mm/migrate.c
@@ -193,7 +193,7 @@ void putback_movable_pages(struct list_h
 			put_page(page);
 		} else {
 			mod_node_page_state(page_pgdat(page), NR_ISOLATED_ANON +
-					page_is_file_lru(page), -hpage_nr_pages(page));
+					page_is_file_lru(page), -thp_nr_pages(page));
 			putback_lru_page(page);
 		}
 	}
@@ -386,7 +386,7 @@ static int expected_page_refs(struct add
 	 */
 	expected_count += is_device_private_page(page);
 	if (mapping)
-		expected_count += hpage_nr_pages(page) + page_has_private(page);
+		expected_count += thp_nr_pages(page) + page_has_private(page);
 
 	return expected_count;
 }
@@ -441,7 +441,7 @@ int migrate_page_move_mapping(struct add
 	 */
 	newpage->index = page->index;
 	newpage->mapping = page->mapping;
-	page_ref_add(newpage, hpage_nr_pages(page)); /* add cache reference */
+	page_ref_add(newpage, thp_nr_pages(page)); /* add cache reference */
 	if (PageSwapBacked(page)) {
 		__SetPageSwapBacked(newpage);
 		if (PageSwapCache(page)) {
@@ -474,7 +474,7 @@ int migrate_page_move_mapping(struct add
 	 * to one less reference.
 	 * We know this isn't the last reference.
 	 */
-	page_ref_unfreeze(page, expected_count - hpage_nr_pages(page));
+	page_ref_unfreeze(page, expected_count - thp_nr_pages(page));
 
 	xas_unlock(&xas);
 	/* Leave irq disabled to prevent preemption while updating stats */
@@ -591,7 +591,7 @@ static void copy_huge_page(struct page *
 	} else {
 		/* thp page */
 		BUG_ON(!PageTransHuge(src));
-		nr_pages = hpage_nr_pages(src);
+		nr_pages = thp_nr_pages(src);
 	}
 
 	for (i = 0; i < nr_pages; i++) {
@@ -1213,7 +1213,7 @@ out:
 		 */
 		if (likely(!__PageMovable(page)))
 			mod_node_page_state(page_pgdat(page), NR_ISOLATED_ANON +
-					page_is_file_lru(page), -hpage_nr_pages(page));
+					page_is_file_lru(page), -thp_nr_pages(page));
 	}
 
 	/*
@@ -1446,7 +1446,7 @@ retry:
 			 * during migration.
 			 */
 			is_thp = PageTransHuge(page);
-			nr_subpages = hpage_nr_pages(page);
+			nr_subpages = thp_nr_pages(page);
 			cond_resched();
 
 			if (PageHuge(page))
@@ -1670,7 +1670,7 @@ static int add_page_for_migration(struct
 		list_add_tail(&head->lru, pagelist);
 		mod_node_page_state(page_pgdat(head),
 			NR_ISOLATED_ANON + page_is_file_lru(head),
-			hpage_nr_pages(head));
+			thp_nr_pages(head));
 	}
 out_putpage:
 	/*
@@ -2034,7 +2034,7 @@ static int numamigrate_isolate_page(pg_d
 
 	page_lru = page_is_file_lru(page);
 	mod_node_page_state(page_pgdat(page), NR_ISOLATED_ANON + page_lru,
-				hpage_nr_pages(page));
+				thp_nr_pages(page));
 
 	/*
 	 * Isolating the page has taken another reference, so the
--- a/mm/mlock.c~mm-replace-hpage_nr_pages-with-thp_nr_pages
+++ a/mm/mlock.c
@@ -61,8 +61,7 @@ void clear_page_mlock(struct page *page)
 	if (!TestClearPageMlocked(page))
 		return;
 
-	mod_zone_page_state(page_zone(page), NR_MLOCK,
-			    -hpage_nr_pages(page));
+	mod_zone_page_state(page_zone(page), NR_MLOCK, -thp_nr_pages(page));
 	count_vm_event(UNEVICTABLE_PGCLEARED);
 	/*
 	 * The previous TestClearPageMlocked() corresponds to the smp_mb()
@@ -95,7 +94,7 @@ void mlock_vma_page(struct page *page)
 
 	if (!TestSetPageMlocked(page)) {
 		mod_zone_page_state(page_zone(page), NR_MLOCK,
-				    hpage_nr_pages(page));
+				    thp_nr_pages(page));
 		count_vm_event(UNEVICTABLE_PGMLOCKED);
 		if (!isolate_lru_page(page))
 			putback_lru_page(page);
@@ -192,7 +191,7 @@ unsigned int munlock_vma_page(struct pag
 	/*
 	 * Serialize with any parallel __split_huge_page_refcount() which
 	 * might otherwise copy PageMlocked to part of the tail pages before
-	 * we clear it in the head page. It also stabilizes hpage_nr_pages().
+	 * we clear it in the head page. It also stabilizes thp_nr_pages().
 	 */
 	spin_lock_irq(&pgdat->lru_lock);
 
@@ -202,7 +201,7 @@ unsigned int munlock_vma_page(struct pag
 		goto unlock_out;
 	}
 
-	nr_pages = hpage_nr_pages(page);
+	nr_pages = thp_nr_pages(page);
 	__mod_zone_page_state(page_zone(page), NR_MLOCK, -nr_pages);
 
 	if (__munlock_isolate_lru_page(page, true)) {
--- a/mm/page_io.c~mm-replace-hpage_nr_pages-with-thp_nr_pages
+++ a/mm/page_io.c
@@ -274,7 +274,7 @@ static inline void count_swpout_vm_event
 	if (unlikely(PageTransHuge(page)))
 		count_vm_event(THP_SWPOUT);
 #endif
-	count_vm_events(PSWPOUT, hpage_nr_pages(page));
+	count_vm_events(PSWPOUT, thp_nr_pages(page));
 }
 
 #if defined(CONFIG_MEMCG) && defined(CONFIG_BLK_CGROUP)
--- a/mm/page_vma_mapped.c~mm-replace-hpage_nr_pages-with-thp_nr_pages
+++ a/mm/page_vma_mapped.c
@@ -61,7 +61,7 @@ static inline bool pfn_is_match(struct p
 		return page_pfn == pfn;
 
 	/* THP can be referenced by any subpage */
-	return pfn >= page_pfn && pfn - page_pfn < hpage_nr_pages(page);
+	return pfn >= page_pfn && pfn - page_pfn < thp_nr_pages(page);
 }
 
 /**
--- a/mm/rmap.c~mm-replace-hpage_nr_pages-with-thp_nr_pages
+++ a/mm/rmap.c
@@ -1130,7 +1130,7 @@ void do_page_add_anon_rmap(struct page *
 	}
 
 	if (first) {
-		int nr = compound ? hpage_nr_pages(page) : 1;
+		int nr = compound ? thp_nr_pages(page) : 1;
 		/*
 		 * We use the irq-unsafe __{inc|mod}_zone_page_stat because
 		 * these counters are not modified in interrupt context, and
@@ -1169,7 +1169,7 @@ void do_page_add_anon_rmap(struct page *
 void page_add_new_anon_rmap(struct page *page,
 	struct vm_area_struct *vma, unsigned long address, bool compound)
 {
-	int nr = compound ? hpage_nr_pages(page) : 1;
+	int nr = compound ? thp_nr_pages(page) : 1;
 
 	VM_BUG_ON_VMA(address < vma->vm_start || address >= vma->vm_end, vma);
 	__SetPageSwapBacked(page);
@@ -1860,7 +1860,7 @@ static void rmap_walk_anon(struct page *
 		return;
 
 	pgoff_start = page_to_pgoff(page);
-	pgoff_end = pgoff_start + hpage_nr_pages(page) - 1;
+	pgoff_end = pgoff_start + thp_nr_pages(page) - 1;
 	anon_vma_interval_tree_foreach(avc, &anon_vma->rb_root,
 			pgoff_start, pgoff_end) {
 		struct vm_area_struct *vma = avc->vma;
@@ -1913,7 +1913,7 @@ static void rmap_walk_file(struct page *
 		return;
 
 	pgoff_start = page_to_pgoff(page);
-	pgoff_end = pgoff_start + hpage_nr_pages(page) - 1;
+	pgoff_end = pgoff_start + thp_nr_pages(page) - 1;
 	if (!locked)
 		i_mmap_lock_read(mapping);
 	vma_interval_tree_foreach(vma, &mapping->i_mmap,
--- a/mm/swap.c~mm-replace-hpage_nr_pages-with-thp_nr_pages
+++ a/mm/swap.c
@@ -241,7 +241,7 @@ static void pagevec_move_tail_fn(struct
 		del_page_from_lru_list(page, lruvec, page_lru(page));
 		ClearPageActive(page);
 		add_page_to_lru_list_tail(page, lruvec, page_lru(page));
-		(*pgmoved) += hpage_nr_pages(page);
+		(*pgmoved) += thp_nr_pages(page);
 	}
 }
 
@@ -312,7 +312,7 @@ void lru_note_cost(struct lruvec *lruvec
 void lru_note_cost_page(struct page *page)
 {
 	lru_note_cost(mem_cgroup_page_lruvec(page, page_pgdat(page)),
-		      page_is_file_lru(page), hpage_nr_pages(page));
+		      page_is_file_lru(page), thp_nr_pages(page));
 }
 
 static void __activate_page(struct page *page, struct lruvec *lruvec,
@@ -320,7 +320,7 @@ static void __activate_page(struct page
 {
 	if (PageLRU(page) && !PageActive(page) && !PageUnevictable(page)) {
 		int lru = page_lru_base_type(page);
-		int nr_pages = hpage_nr_pages(page);
+		int nr_pages = thp_nr_pages(page);
 
 		del_page_from_lru_list(page, lruvec, lru);
 		SetPageActive(page);
@@ -500,7 +500,7 @@ void lru_cache_add_inactive_or_unevictab
 		 * lock is held(spinlock), which implies preemption disabled.
 		 */
 		__mod_zone_page_state(page_zone(page), NR_MLOCK,
-				    hpage_nr_pages(page));
+				    thp_nr_pages(page));
 		count_vm_event(UNEVICTABLE_PGMLOCKED);
 	}
 	lru_cache_add(page);
@@ -532,7 +532,7 @@ static void lru_deactivate_file_fn(struc
 {
 	int lru;
 	bool active;
-	int nr_pages = hpage_nr_pages(page);
+	int nr_pages = thp_nr_pages(page);
 
 	if (!PageLRU(page))
 		return;
@@ -580,7 +580,7 @@ static void lru_deactivate_fn(struct pag
 {
 	if (PageLRU(page) && PageActive(page) && !PageUnevictable(page)) {
 		int lru = page_lru_base_type(page);
-		int nr_pages = hpage_nr_pages(page);
+		int nr_pages = thp_nr_pages(page);
 
 		del_page_from_lru_list(page, lruvec, lru + LRU_ACTIVE);
 		ClearPageActive(page);
@@ -599,7 +599,7 @@ static void lru_lazyfree_fn(struct page
 	if (PageLRU(page) && PageAnon(page) && PageSwapBacked(page) &&
 	    !PageSwapCache(page) && !PageUnevictable(page)) {
 		bool active = PageActive(page);
-		int nr_pages = hpage_nr_pages(page);
+		int nr_pages = thp_nr_pages(page);
 
 		del_page_from_lru_list(page, lruvec,
 				       LRU_INACTIVE_ANON + active);
@@ -972,7 +972,7 @@ static void __pagevec_lru_add_fn(struct
 {
 	enum lru_list lru;
 	int was_unevictable = TestClearPageUnevictable(page);
-	int nr_pages = hpage_nr_pages(page);
+	int nr_pages = thp_nr_pages(page);
 
 	VM_BUG_ON_PAGE(PageLRU(page), page);
 
--- a/mm/swapfile.c~mm-replace-hpage_nr_pages-with-thp_nr_pages
+++ a/mm/swapfile.c
@@ -1370,7 +1370,7 @@ void put_swap_page(struct page *page, sw
 	unsigned char *map;
 	unsigned int i, free_entries = 0;
 	unsigned char val;
-	int size = swap_entry_size(hpage_nr_pages(page));
+	int size = swap_entry_size(thp_nr_pages(page));
 
 	si = _swap_info_get(entry);
 	if (!si)
--- a/mm/swap_state.c~mm-replace-hpage_nr_pages-with-thp_nr_pages
+++ a/mm/swap_state.c
@@ -130,7 +130,7 @@ int add_to_swap_cache(struct page *page,
 	struct address_space *address_space = swap_address_space(entry);
 	pgoff_t idx = swp_offset(entry);
 	XA_STATE_ORDER(xas, &address_space->i_pages, idx, compound_order(page));
-	unsigned long i, nr = hpage_nr_pages(page);
+	unsigned long i, nr = thp_nr_pages(page);
 	void *old;
 
 	VM_BUG_ON_PAGE(!PageLocked(page), page);
@@ -183,7 +183,7 @@ void __delete_from_swap_cache(struct pag
 			swp_entry_t entry, void *shadow)
 {
 	struct address_space *address_space = swap_address_space(entry);
-	int i, nr = hpage_nr_pages(page);
+	int i, nr = thp_nr_pages(page);
 	pgoff_t idx = swp_offset(entry);
 	XA_STATE(xas, &address_space->i_pages, idx);
 
@@ -278,7 +278,7 @@ void delete_from_swap_cache(struct page
 	xa_unlock_irq(&address_space->i_pages);
 
 	put_swap_page(page, entry);
-	page_ref_sub(page, hpage_nr_pages(page));
+	page_ref_sub(page, thp_nr_pages(page));
 }
 
 void clear_shadow_from_swap_cache(int type, unsigned long begin,
--- a/mm/vmscan.c~mm-replace-hpage_nr_pages-with-thp_nr_pages
+++ a/mm/vmscan.c
@@ -1354,7 +1354,7 @@ static unsigned int shrink_page_list(str
 			case PAGE_ACTIVATE:
 				goto activate_locked;
 			case PAGE_SUCCESS:
-				stat->nr_pageout += hpage_nr_pages(page);
+				stat->nr_pageout += thp_nr_pages(page);
 
 				if (PageWriteback(page))
 					goto keep;
@@ -1862,7 +1862,7 @@ static unsigned noinline_for_stack move_
 		SetPageLRU(page);
 		lru = page_lru(page);
 
-		nr_pages = hpage_nr_pages(page);
+		nr_pages = thp_nr_pages(page);
 		update_lru_size(lruvec, lru, page_zonenum(page), nr_pages);
 		list_move(&page->lru, &lruvec->lists[lru]);
 
@@ -2065,7 +2065,7 @@ static void shrink_active_list(unsigned
 			 * so we ignore them here.
 			 */
 			if ((vm_flags & VM_EXEC) && page_is_file_lru(page)) {
-				nr_rotated += hpage_nr_pages(page);
+				nr_rotated += thp_nr_pages(page);
 				list_add(&page->lru, &l_active);
 				continue;
 			}
--- a/mm/workingset.c~mm-replace-hpage_nr_pages-with-thp_nr_pages
+++ a/mm/workingset.c
@@ -263,7 +263,7 @@ void *workingset_eviction(struct page *p
 	VM_BUG_ON_PAGE(!PageLocked(page), page);
 
 	lruvec = mem_cgroup_lruvec(target_memcg, pgdat);
-	workingset_age_nonresident(lruvec, hpage_nr_pages(page));
+	workingset_age_nonresident(lruvec, thp_nr_pages(page));
 	/* XXX: target_memcg can be NULL, go through lruvec */
 	memcgid = mem_cgroup_id(lruvec_memcg(lruvec));
 	eviction = atomic_long_read(&lruvec->nonresident_age);
@@ -374,7 +374,7 @@ void workingset_refault(struct page *pag
 		goto out;
 
 	SetPageActive(page);
-	workingset_age_nonresident(lruvec, hpage_nr_pages(page));
+	workingset_age_nonresident(lruvec, thp_nr_pages(page));
 	inc_lruvec_state(lruvec, WORKINGSET_ACTIVATE_BASE + file);
 
 	/* Page was active prior to eviction */
@@ -411,7 +411,7 @@ void workingset_activation(struct page *
 	if (!mem_cgroup_disabled() && !memcg)
 		goto out;
 	lruvec = mem_cgroup_page_lruvec(page, page_pgdat(page));
-	workingset_age_nonresident(lruvec, hpage_nr_pages(page));
+	workingset_age_nonresident(lruvec, thp_nr_pages(page));
 out:
 	rcu_read_unlock();
 }
_
