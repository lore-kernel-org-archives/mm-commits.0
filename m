Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4F1513EFF3
	for <mm-commits@vger.kernel.org>; Wed, 19 Feb 2025 01:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739927435; cv=none; b=OSCA6GuQZNFw051JiMOHXrLgkZcAYgU3prfyVQKVdzm0YapmCWwI6gkj4qW2fUyeJInUrSTpNVsTzfs3UZakGKeuxKaUh548j66gXQchvZ2su0MAIWLSGK+L8dS7+Es4x4gXU0DxH1mvksVPZQ8thzOulEwVrTqiGsD7a0ppoxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739927435; c=relaxed/simple;
	bh=OIFdr0vWEzuveg37u0u3f0pZQ3yb8AEF3vwsREX7w1Y=;
	h=Date:To:From:Subject:Message-Id; b=kBckNpBjcuD2XXyXsgANEIZpXBefErZp2KHoiW/4euyCkvPHn6K4ftyvbkQGxvBIBb2mYQsyaMBgGckVWb8we1Y38IYjJl6lStSxVCRS+FxmVAl3kp9FvcdUq1qN+1Rhhsaa68v0Cqb9QsQXULeTvRL4DGUHcSXUnrYyW0BBKAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gzvYzq1B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gzvYzq1B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19830C4CEE6;
	Wed, 19 Feb 2025 01:10:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739927435;
	bh=OIFdr0vWEzuveg37u0u3f0pZQ3yb8AEF3vwsREX7w1Y=;
	h=Date:To:From:Subject:From;
	b=gzvYzq1BCWCb2MYgRr8Tj3wed0TK6HbOY4OikNnud3b3wsvBaUPqD7qggDgqIP/tm
	 iYc2dLd4+yPog3tUouRrSIgT+SHmNC+ySWldFp+B+FztoSBp3MbAdzReeipBRoTd7R
	 c97DkTiTI/gvqfg/NEv5k/1EqnISf1sTVwaXC0FQ=
Date: Tue, 18 Feb 2025 17:10:34 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,yang@os.amperecomputing.com,willy@infradead.org,wangkefeng.wang@huawei.com,ryan.roberts@arm.com,linmiaohe@huawei.com,kirill.shutemov@linux.intel.com,kasong@tencent.com,jhubbard@nvidia.com,hughd@google.com,david@redhat.com,baolin.wang@linux.alibaba.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-remove-the-old-unused-__split_huge_page.patch added to mm-unstable branch
Message-Id: <20250219011035.19830C4CEE6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/huge_memory: remove the old, unused __split_huge_page()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-huge_memory-remove-the-old-unused-__split_huge_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-remove-the-old-unused-__split_huge_page.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: mm/huge_memory: remove the old, unused __split_huge_page()
Date: Tue, 18 Feb 2025 18:50:09 -0500

Now split_huge_page_to_list_to_order() uses the new backend split code in
__folio_split_without_mapping(), the old __split_huge_page() and
__split_huge_page_tail() can be removed.

Link: https://lkml.kernel.org/r/20250218235012.1542225-6-ziy@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Kirill A. Shuemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <yang@os.amperecomputing.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Kairui Song <kasong@tencent.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |  207 ---------------------------------------------
 1 file changed, 207 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-remove-the-old-unused-__split_huge_page
+++ a/mm/huge_memory.c
@@ -3286,213 +3286,6 @@ static void lru_add_page_tail(struct fol
 	}
 }
 
-static void __split_huge_page_tail(struct folio *folio, int tail,
-		struct lruvec *lruvec, struct list_head *list,
-		unsigned int new_order)
-{
-	struct page *head = &folio->page;
-	struct page *page_tail = head + tail;
-	/*
-	 * Careful: new_folio is not a "real" folio before we cleared PageTail.
-	 * Don't pass it around before clear_compound_head().
-	 */
-	struct folio *new_folio = (struct folio *)page_tail;
-
-	VM_BUG_ON_PAGE(atomic_read(&page_tail->_mapcount) != -1, page_tail);
-
-	/*
-	 * Clone page flags before unfreezing refcount.
-	 *
-	 * After successful get_page_unless_zero() might follow flags change,
-	 * for example lock_page() which set PG_waiters.
-	 *
-	 * Note that for mapped sub-pages of an anonymous THP,
-	 * PG_anon_exclusive has been cleared in unmap_folio() and is stored in
-	 * the migration entry instead from where remap_page() will restore it.
-	 * We can still have PG_anon_exclusive set on effectively unmapped and
-	 * unreferenced sub-pages of an anonymous THP: we can simply drop
-	 * PG_anon_exclusive (-> PG_mappedtodisk) for these here.
-	 */
-	page_tail->flags &= ~PAGE_FLAGS_CHECK_AT_PREP;
-	page_tail->flags |= (head->flags &
-			((1L << PG_referenced) |
-			 (1L << PG_swapbacked) |
-			 (1L << PG_swapcache) |
-			 (1L << PG_mlocked) |
-			 (1L << PG_uptodate) |
-			 (1L << PG_active) |
-			 (1L << PG_workingset) |
-			 (1L << PG_locked) |
-			 (1L << PG_unevictable) |
-#ifdef CONFIG_ARCH_USES_PG_ARCH_2
-			 (1L << PG_arch_2) |
-#endif
-#ifdef CONFIG_ARCH_USES_PG_ARCH_3
-			 (1L << PG_arch_3) |
-#endif
-			 (1L << PG_dirty) |
-			 LRU_GEN_MASK | LRU_REFS_MASK));
-
-	/* ->mapping in first and second tail page is replaced by other uses */
-	VM_BUG_ON_PAGE(tail > 2 && page_tail->mapping != TAIL_MAPPING,
-			page_tail);
-	new_folio->mapping = folio->mapping;
-	new_folio->index = folio->index + tail;
-
-	/*
-	 * page->private should not be set in tail pages. Fix up and warn once
-	 * if private is unexpectedly set.
-	 */
-	if (unlikely(page_tail->private)) {
-		VM_WARN_ON_ONCE_PAGE(true, page_tail);
-		page_tail->private = 0;
-	}
-	if (folio_test_swapcache(folio))
-		new_folio->swap.val = folio->swap.val + tail;
-
-	/* Page flags must be visible before we make the page non-compound. */
-	smp_wmb();
-
-	/*
-	 * Clear PageTail before unfreezing page refcount.
-	 *
-	 * After successful get_page_unless_zero() might follow put_page()
-	 * which needs correct compound_head().
-	 */
-	clear_compound_head(page_tail);
-	if (new_order) {
-		prep_compound_page(page_tail, new_order);
-		folio_set_large_rmappable(new_folio);
-	}
-
-	/* Finally unfreeze refcount. Additional reference from page cache. */
-	page_ref_unfreeze(page_tail,
-		1 + ((!folio_test_anon(folio) || folio_test_swapcache(folio)) ?
-			     folio_nr_pages(new_folio) : 0));
-
-	if (folio_test_young(folio))
-		folio_set_young(new_folio);
-	if (folio_test_idle(folio))
-		folio_set_idle(new_folio);
-
-	folio_xchg_last_cpupid(new_folio, folio_last_cpupid(folio));
-
-	/*
-	 * always add to the tail because some iterators expect new
-	 * pages to show after the currently processed elements - e.g.
-	 * migrate_pages
-	 */
-	lru_add_page_tail(folio, page_tail, lruvec, list);
-}
-
-static void __split_huge_page(struct page *page, struct list_head *list,
-		pgoff_t end, unsigned int new_order)
-{
-	struct folio *folio = page_folio(page);
-	struct page *head = &folio->page;
-	struct lruvec *lruvec;
-	struct address_space *swap_cache = NULL;
-	unsigned long offset = 0;
-	int i, nr_dropped = 0;
-	unsigned int new_nr = 1 << new_order;
-	int order = folio_order(folio);
-	unsigned int nr = 1 << order;
-
-	/* complete memcg works before add pages to LRU */
-	split_page_memcg(head, order, new_order);
-
-	if (folio_test_anon(folio) && folio_test_swapcache(folio)) {
-		offset = swap_cache_index(folio->swap);
-		swap_cache = swap_address_space(folio->swap);
-		xa_lock(&swap_cache->i_pages);
-	}
-
-	/* lock lru list/PageCompound, ref frozen by page_ref_freeze */
-	lruvec = folio_lruvec_lock(folio);
-
-	folio_clear_has_hwpoisoned(folio);
-
-	for (i = nr - new_nr; i >= new_nr; i -= new_nr) {
-		struct folio *tail;
-		__split_huge_page_tail(folio, i, lruvec, list, new_order);
-		tail = page_folio(head + i);
-		/* Some pages can be beyond EOF: drop them from page cache */
-		if (tail->index >= end) {
-			if (shmem_mapping(folio->mapping))
-				nr_dropped += new_nr;
-			else if (folio_test_clear_dirty(tail))
-				folio_account_cleaned(tail,
-					inode_to_wb(folio->mapping->host));
-			__filemap_remove_folio(tail, NULL);
-			folio_put(tail);
-		} else if (!folio_test_anon(folio)) {
-			__xa_store(&folio->mapping->i_pages, tail->index,
-					tail, 0);
-		} else if (swap_cache) {
-			__xa_store(&swap_cache->i_pages, offset + i,
-					tail, 0);
-		}
-	}
-
-	if (!new_order)
-		ClearPageCompound(head);
-	else {
-		struct folio *new_folio = (struct folio *)head;
-
-		folio_set_order(new_folio, new_order);
-	}
-	unlock_page_lruvec(lruvec);
-	/* Caller disabled irqs, so they are still disabled here */
-
-	split_page_owner(head, order, new_order);
-	pgalloc_tag_split(folio, order, new_order);
-
-	/* See comment in __split_huge_page_tail() */
-	if (folio_test_anon(folio)) {
-		/* Additional pin to swap cache */
-		if (folio_test_swapcache(folio)) {
-			folio_ref_add(folio, 1 + new_nr);
-			xa_unlock(&swap_cache->i_pages);
-		} else {
-			folio_ref_inc(folio);
-		}
-	} else {
-		/* Additional pin to page cache */
-		folio_ref_add(folio, 1 + new_nr);
-		xa_unlock(&folio->mapping->i_pages);
-	}
-	local_irq_enable();
-
-	if (nr_dropped)
-		shmem_uncharge(folio->mapping->host, nr_dropped);
-	remap_page(folio, nr, PageAnon(head) ? RMP_USE_SHARED_ZEROPAGE : 0);
-
-	/*
-	 * set page to its compound_head when split to non order-0 pages, so
-	 * we can skip unlocking it below, since PG_locked is transferred to
-	 * the compound_head of the page and the caller will unlock it.
-	 */
-	if (new_order)
-		page = compound_head(page);
-
-	for (i = 0; i < nr; i += new_nr) {
-		struct page *subpage = head + i;
-		struct folio *new_folio = page_folio(subpage);
-		if (subpage == page)
-			continue;
-		folio_unlock(new_folio);
-
-		/*
-		 * Subpages may be freed if there wasn't any mapping
-		 * like if add_to_swap() is running on a lru page that
-		 * had its mapping zapped. And freeing these pages
-		 * requires taking the lru_lock so we do the put_page
-		 * of the tail pages after the split is complete.
-		 */
-		free_page_and_swap_cache(subpage);
-	}
-}
-
 /* Racy check whether the huge page can be split */
 bool can_split_folio(struct folio *folio, int caller_pins, int *pextra_pins)
 {
_

Patches currently in -mm which might be from ziy@nvidia.com are

selftests-mm-make-file-backed-thp-split-work-by-writing-pmd-size-data.patch
mm-huge_memory-allow-split-shmem-large-folio-to-any-lower-order.patch
selftests-mm-test-splitting-file-backed-thp-to-any-lower-order.patch
xarray-add-xas_try_split-to-split-a-multi-index-entry.patch
mm-huge_memory-add-two-new-not-yet-used-functions-for-folio_split.patch
mm-huge_memory-move-folio-split-common-code-to-__folio_split.patch
mm-huge_memory-add-buddy-allocator-like-non-uniform-folio_split.patch
mm-huge_memory-remove-the-old-unused-__split_huge_page.patch
mm-huge_memory-add-folio_split-to-debugfs-testing-interface.patch
mm-truncate-use-buddy-allocator-like-folio-split-for-truncate-operation.patch
selftests-mm-add-tests-for-folio_split-buddy-allocator-like-split.patch
mm-filemap-use-xas_try_split-in-__filemap_add_folio.patch
mm-shmem-use-xas_try_split-in-shmem_split_large_entry.patch

