Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6F4227293C
	for <mm-commits@vger.kernel.org>; Tue, 11 Feb 2025 23:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739314983; cv=none; b=kGtXov2b7qvjmIqZjzTRCqp7OpUWNt0WsVXZd9qn43PD/uVV4XB4tglhFEIuvwwJDqsedTj38yquTFcwDiwyGaGMU1yC2nAWNKqDrXvAPkX3lJh7SX9Rv9gnHHMw+Catw+ne2K0XHYaqH786TZ0mBOib8Q/a82vrrLx+MvGNR3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739314983; c=relaxed/simple;
	bh=vl8wLMXhtaMFN5ouDjYXvkPPevr9VtLgzowLrVWU2Ug=;
	h=Date:To:From:Subject:Message-Id; b=FkLpu1Mj0hHRdOdUnYMTpSJcL7Hx8MpbJ8KdGm0YpGt6S4FuTOfFBvg6HjwT6RwjKTViE3Nq3m0GiEyCRkeanK3SgXOPKd85ogrnhi9q4vGcLyHpZ8R+ft05mXJukm18sxGJbpKLHEXnqgm2mme+pUFurvNUP6o13fuxRgKj4SI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WzQxvjsP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WzQxvjsP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14C6BC4CEDD;
	Tue, 11 Feb 2025 23:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739314983;
	bh=vl8wLMXhtaMFN5ouDjYXvkPPevr9VtLgzowLrVWU2Ug=;
	h=Date:To:From:Subject:From;
	b=WzQxvjsPoyoeTIwtnIb4bPVU0L8Qd6vPvCtfwfsiyKjH1V8KoRiX3OvU3Rh5sTqAf
	 CuKs8qjzzctyzTPCXAnNYxzvGzQQZKGjlsWyzNZCEVNaqj32JDqxMZc42ZGk9Rk3nu
	 mjjNIXqC2ZzuiaVT6Kp3MTqKFtyVlLQlViw46bmI=
Date: Tue, 11 Feb 2025 15:03:02 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,yang@os.amperecomputing.com,willy@infradead.org,wangkefeng.wang@huawei.com,ryan.roberts@arm.com,linmiaohe@huawei.com,kirill.shutemov@linux.intel.com,jhubbard@nvidia.com,hughd@google.com,david@redhat.com,baolin.wang@linux.alibaba.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-add-two-new-not-yet-used-functions-for-folio_split.patch added to mm-unstable branch
Message-Id: <20250211230303.14C6BC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/huge_memory: add two new (not yet used) functions for folio_split()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-huge_memory-add-two-new-not-yet-used-functions-for-folio_split.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-add-two-new-not-yet-used-functions-for-folio_split.patch

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
Subject: mm/huge_memory: add two new (not yet used) functions for folio_split()
Date: Tue, 11 Feb 2025 10:50:27 -0500

This is a preparation patch, both added functions are not used yet.

The added __split_unmapped_folio() is able to split a folio with its
mapping removed in two manners: 1) uniform split (the existing way), and
2) buddy allocator like split.

The added __split_folio_to_order() can split a folio into any lower order.
For uniform split, __split_unmapped_folio() calls it once to split the
given folio to the new order.  For buddy allocator split,
__split_unmapped_folio() calls it (folio_order - new_order) times and each
time splits the folio containing the given page to one lower order.

Link: https://lkml.kernel.org/r/20250211155034.268962-3-ziy@nvidia.com
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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |  349 ++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 348 insertions(+), 1 deletion(-)

--- a/mm/huge_memory.c~mm-huge_memory-add-two-new-not-yet-used-functions-for-folio_split
+++ a/mm/huge_memory.c
@@ -3252,7 +3252,6 @@ static void remap_page(struct folio *fol
 static void lru_add_page_tail(struct folio *folio, struct page *tail,
 		struct lruvec *lruvec, struct list_head *list)
 {
-	VM_BUG_ON_FOLIO(!folio_test_large(folio), folio);
 	VM_BUG_ON_FOLIO(PageLRU(tail), folio);
 	lockdep_assert_held(&lruvec->lru_lock);
 
@@ -3497,6 +3496,354 @@ bool can_split_folio(struct folio *folio
 }
 
 /*
+ * It splits @folio into @new_order folios and copies the @folio metadata to
+ * all the resulting folios.
+ */
+static int __split_folio_to_order(struct folio *folio, int new_order)
+{
+	int curr_order = folio_order(folio);
+	long nr_pages = folio_nr_pages(folio);
+	long new_nr_pages = 1 << new_order;
+	long index;
+
+	if (curr_order <= new_order)
+		return -EINVAL;
+
+	/*
+	 * Skip the first new_nr_pages, since the new folio from them have all
+	 * the flags from the original folio.
+	 */
+	for (index = new_nr_pages; index < nr_pages; index += new_nr_pages) {
+		struct page *head = &folio->page;
+		struct page *new_head = head + index;
+
+		/*
+		 * Careful: new_folio is not a "real" folio before we cleared PageTail.
+		 * Don't pass it around before clear_compound_head().
+		 */
+		struct folio *new_folio = (struct folio *)new_head;
+
+		VM_BUG_ON_PAGE(atomic_read(&new_head->_mapcount) != -1, new_head);
+
+		/*
+		 * Clone page flags before unfreezing refcount.
+		 *
+		 * After successful get_page_unless_zero() might follow flags change,
+		 * for example lock_page() which set PG_waiters.
+		 *
+		 * Note that for mapped sub-pages of an anonymous THP,
+		 * PG_anon_exclusive has been cleared in unmap_folio() and is stored in
+		 * the migration entry instead from where remap_page() will restore it.
+		 * We can still have PG_anon_exclusive set on effectively unmapped and
+		 * unreferenced sub-pages of an anonymous THP: we can simply drop
+		 * PG_anon_exclusive (-> PG_mappedtodisk) for these here.
+		 */
+		new_head->flags &= ~PAGE_FLAGS_CHECK_AT_PREP;
+		new_head->flags |= (head->flags &
+				((1L << PG_referenced) |
+				 (1L << PG_swapbacked) |
+				 (1L << PG_swapcache) |
+				 (1L << PG_mlocked) |
+				 (1L << PG_uptodate) |
+				 (1L << PG_active) |
+				 (1L << PG_workingset) |
+				 (1L << PG_locked) |
+				 (1L << PG_unevictable) |
+#ifdef CONFIG_ARCH_USES_PG_ARCH_2
+				 (1L << PG_arch_2) |
+#endif
+#ifdef CONFIG_ARCH_USES_PG_ARCH_3
+				 (1L << PG_arch_3) |
+#endif
+				 (1L << PG_dirty) |
+				 LRU_GEN_MASK | LRU_REFS_MASK));
+
+		/* ->mapping in first and second tail page is replaced by other uses */
+		VM_BUG_ON_PAGE(new_nr_pages > 2 && new_head->mapping != TAIL_MAPPING,
+			       new_head);
+		new_head->mapping = head->mapping;
+		new_head->index = head->index + index;
+
+		/*
+		 * page->private should not be set in tail pages. Fix up and warn once
+		 * if private is unexpectedly set.
+		 */
+		if (unlikely(new_head->private)) {
+			VM_WARN_ON_ONCE_PAGE(true, new_head);
+			new_head->private = 0;
+		}
+
+		if (folio_test_swapcache(folio))
+			new_folio->swap.val = folio->swap.val + index;
+
+		/* Page flags must be visible before we make the page non-compound. */
+		smp_wmb();
+
+		/*
+		 * Clear PageTail before unfreezing page refcount.
+		 *
+		 * After successful get_page_unless_zero() might follow put_page()
+		 * which needs correct compound_head().
+		 */
+		clear_compound_head(new_head);
+		if (new_order) {
+			prep_compound_page(new_head, new_order);
+			folio_set_large_rmappable(new_folio);
+
+			folio_set_order(folio, new_order);
+		}
+
+		if (folio_test_young(folio))
+			folio_set_young(new_folio);
+		if (folio_test_idle(folio))
+			folio_set_idle(new_folio);
+
+		folio_xchg_last_cpupid(new_folio, folio_last_cpupid(folio));
+	}
+
+	if (!new_order)
+		ClearPageCompound(&folio->page);
+
+	return 0;
+}
+
+/*
+ * It splits an unmapped @folio to lower order smaller folios in two ways.
+ * @folio: the to-be-split folio
+ * @new_order: the smallest order of the after split folios (since buddy
+ *             allocator like split generates folios with orders from @folio's
+ *             order - 1 to new_order).
+ * @page: in buddy allocator like split, the folio containing @page will be
+ *        split until its order becomes @new_order.
+ * @list: the after split folios will be added to @list if it is not NULL,
+ *        otherwise to LRU lists.
+ * @end: the end of the file @folio maps to. -1 if @folio is anonymous memory.
+ * @xas: xa_state pointing to folio->mapping->i_pages and locked by caller
+ * @mapping: @folio->mapping
+ * @uniform_split: if the split is uniform or not (buddy allocator like split)
+ *
+ *
+ * 1. uniform split: the given @folio into multiple @new_order small folios,
+ *    where all small folios have the same order. This is done when
+ *    uniform_split is true.
+ * 2. buddy allocator like (non-uniform) split: the given @folio is split into
+ *    half and one of the half (containing the given page) is split into half
+ *    until the given @page's order becomes @new_order. This is done when
+ *    uniform_split is false.
+ *
+ * The high level flow for these two methods are:
+ * 1. uniform split: a single __split_folio_to_order() is called to split the
+ *    @folio into @new_order, then we traverse all the resulting folios one by
+ *    one in PFN ascending order and perform stats, unfreeze, adding to list,
+ *    and file mapping index operations.
+ * 2. non-uniform split: in general, folio_order - @new_order calls to
+ *    __split_folio_to_order() are made in a for loop to split the @folio
+ *    to one lower order at a time. The resulting small folios are processed
+ *    like what is done during the traversal in 1, except the one containing
+ *    @page, which is split in next for loop.
+ *
+ * After splitting, the caller's folio reference will be transferred to the
+ * folio containing @page. The other folios may be freed if they are not mapped.
+ *
+ * In terms of locking, after splitting,
+ * 1. uniform split leaves @page (or the folio contains it) locked;
+ * 2. buddy allocator like (non-uniform) split leaves @folio locked.
+ *
+ *
+ * For !uniform_split, when -ENOMEM is returned, the original folio might be
+ * split. The caller needs to check the input folio.
+ */
+static int __split_unmapped_folio(struct folio *folio, int new_order,
+		struct page *page, struct list_head *list, pgoff_t end,
+		struct xa_state *xas, struct address_space *mapping,
+		bool uniform_split)
+{
+	struct lruvec *lruvec;
+	struct address_space *swap_cache = NULL;
+	struct folio *origin_folio = folio;
+	struct folio *next_folio = folio_next(folio);
+	struct folio *new_folio;
+	struct folio *next;
+	int order = folio_order(folio);
+	int split_order;
+	int start_order = uniform_split ? new_order : order - 1;
+	int nr_dropped = 0;
+	int ret = 0;
+	bool stop_split = false;
+
+	if (folio_test_anon(folio) && folio_test_swapcache(folio)) {
+		/* a swapcache folio can only be uniformly split to order-0 */
+		if (!uniform_split || new_order != 0)
+			return -EINVAL;
+
+		swap_cache = swap_address_space(folio->swap);
+		xa_lock(&swap_cache->i_pages);
+	}
+
+	if (folio_test_anon(folio))
+		mod_mthp_stat(order, MTHP_STAT_NR_ANON, -1);
+
+	/* lock lru list/PageCompound, ref frozen by page_ref_freeze */
+	lruvec = folio_lruvec_lock(folio);
+
+	folio_clear_has_hwpoisoned(folio);
+
+	/*
+	 * split to new_order one order at a time. For uniform split,
+	 * folio is split to new_order directly.
+	 */
+	for (split_order = start_order;
+	     split_order >= new_order && !stop_split;
+	     split_order--) {
+		int old_order = folio_order(folio);
+		struct folio *release;
+		struct folio *end_folio = folio_next(folio);
+		int status;
+
+		/* order-1 anonymous folio is not supported */
+		if (folio_test_anon(folio) && split_order == 1)
+			continue;
+		if (uniform_split && split_order != new_order)
+			continue;
+
+		if (mapping) {
+			/*
+			 * uniform split has xas_split_alloc() called before
+			 * irq is disabled to allocate enough memory, whereas
+			 * non-uniform split can handle ENOMEM.
+			 */
+			if (uniform_split)
+				xas_split(xas, folio, old_order);
+			else {
+				xas_set_order(xas, folio->index, split_order);
+				xas_try_split(xas, folio, old_order,
+						GFP_NOWAIT);
+				if (xas_error(xas)) {
+					ret = xas_error(xas);
+					stop_split = true;
+					goto after_split;
+				}
+			}
+		}
+
+		/* complete memcg works before add pages to LRU */
+		split_page_memcg(&folio->page, old_order, split_order);
+		split_page_owner(&folio->page, old_order, split_order);
+		pgalloc_tag_split(folio, old_order, split_order);
+
+		status = __split_folio_to_order(folio, split_order);
+
+		if (status < 0) {
+			stop_split = true;
+			ret = -EINVAL;
+		}
+
+after_split:
+		/*
+		 * Iterate through after-split folios and perform related
+		 * operations. But in buddy allocator like split, the folio
+		 * containing the specified page is skipped until its order
+		 * is new_order, since the folio will be worked on in next
+		 * iteration.
+		 */
+		for (release = folio, next = folio_next(folio);
+		     release != end_folio;
+		     release = next, next = folio_next(next)) {
+			/*
+			 * for buddy allocator like split, the folio containing
+			 * page will be split next and should not be released,
+			 * until the folio's order is new_order or stop_split
+			 * is set to true by the above xas_split() failure.
+			 */
+			if (release == page_folio(page)) {
+				folio = release;
+				if (split_order != new_order && !stop_split)
+					continue;
+			}
+			if (folio_test_anon(release)) {
+				mod_mthp_stat(folio_order(release),
+						MTHP_STAT_NR_ANON, 1);
+			}
+
+			/*
+			 * Unfreeze refcount first. Additional reference from
+			 * page cache.
+			 */
+			folio_ref_unfreeze(release,
+				1 + ((!folio_test_anon(origin_folio) ||
+				     folio_test_swapcache(origin_folio)) ?
+					     folio_nr_pages(release) : 0));
+
+			if (release != origin_folio)
+				lru_add_page_tail(origin_folio, &release->page,
+						lruvec, list);
+
+			/* Some pages can be beyond EOF: drop them from page cache */
+			if (release->index >= end) {
+				if (shmem_mapping(origin_folio->mapping))
+					nr_dropped += folio_nr_pages(release);
+				else if (folio_test_clear_dirty(release))
+					folio_account_cleaned(release,
+						inode_to_wb(origin_folio->mapping->host));
+				__filemap_remove_folio(release, NULL);
+				folio_put(release);
+			} else if (!folio_test_anon(release)) {
+				__xa_store(&origin_folio->mapping->i_pages,
+						release->index, &release->page, 0);
+			} else if (swap_cache) {
+				__xa_store(&swap_cache->i_pages,
+						swap_cache_index(release->swap),
+						&release->page, 0);
+			}
+		}
+	}
+
+	unlock_page_lruvec(lruvec);
+
+	if (folio_test_anon(origin_folio)) {
+		if (folio_test_swapcache(origin_folio))
+			xa_unlock(&swap_cache->i_pages);
+	} else
+		xa_unlock(&mapping->i_pages);
+
+	/* Caller disabled irqs, so they are still disabled here */
+	local_irq_enable();
+
+	if (nr_dropped)
+		shmem_uncharge(mapping->host, nr_dropped);
+
+	remap_page(origin_folio, 1 << order,
+			folio_test_anon(origin_folio) ?
+				RMP_USE_SHARED_ZEROPAGE : 0);
+
+	/*
+	 * At this point, folio should contain the specified page.
+	 * For uniform split, it is left for caller to unlock.
+	 * For buddy allocator like split, the first after-split folio is left
+	 * for caller to unlock.
+	 */
+	for (new_folio = origin_folio, next = folio_next(origin_folio);
+	     new_folio != next_folio;
+	     new_folio = next, next = folio_next(next)) {
+		if (uniform_split && new_folio == folio)
+			continue;
+		if (!uniform_split && new_folio == origin_folio)
+			continue;
+
+		folio_unlock(new_folio);
+		/*
+		 * Subpages may be freed if there wasn't any mapping
+		 * like if add_to_swap() is running on a lru page that
+		 * had its mapping zapped. And freeing these pages
+		 * requires taking the lru_lock so we do the put_page
+		 * of the tail pages after the split is complete.
+		 */
+		free_page_and_swap_cache(&new_folio->page);
+	}
+	return ret;
+}
+
+/*
  * This function splits a large folio into smaller folios of order @new_order.
  * @page can point to any page of the large folio to split. The split operation
  * does not change the position of @page.
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

