Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 618DB2236FB
	for <mm-commits@vger.kernel.org>; Sat, 12 Jul 2025 22:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752358833; cv=none; b=l6QpOBdATAU0L0NRE99tK/5SClh/XddMfGlerHII5ZUAFX06PN9fie6bvxkiVFO1takWsXIpUrsVuYKnWl0lYHt2rYVbaEVJesTX0HEmzZR6Y4QD+UJgwYoYa2BmBpdIF6tXl2uoMTeAqyoHv78vLlmNSmGxlE0NzBHW3/pm9kQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752358833; c=relaxed/simple;
	bh=Cv0gEGdCZ2uwNkiYgCDKnBUslKuJ9DW2jTDy+iq+Bms=;
	h=Date:To:From:Subject:Message-Id; b=r34R92Gbnr9TxXSPL4sBrq9TADj1I2e3teJMGKWD6K2mo8CXxE40o3ehP1QORpbjkxUJ54S3N6I0gaI6gJQDY88+tfRu8Sm4CmzfAIwTThJytBDYh6Aq1PfRswRCcp/nbluE3gkIoScF7evstPNeedfnTiDHkDXKRpXnU/3T7gs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AeQVAgQU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AeQVAgQU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6E59C4CEEF;
	Sat, 12 Jul 2025 22:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752358833;
	bh=Cv0gEGdCZ2uwNkiYgCDKnBUslKuJ9DW2jTDy+iq+Bms=;
	h=Date:To:From:Subject:From;
	b=AeQVAgQUM7iMyW8yHkQ5ZiWwPBTRNGmINowPPTMNRKZo2z4U/DvPZk+MKsCkTK0d+
	 HajptFLpsrwyuFo4BhQUaWYFd9D/U6c120/Jdla3/Dyr5HjV65+fwql69MxY6K9QH1
	 cHuL+sKLTfhkoMNULRS+0Uasg5glgOKzJ9j8XKw8=
Date: Sat, 12 Jul 2025 15:20:32 -0700
To: mm-commits@vger.kernel.org,ryan.roberts@arm.com,npache@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,k.shutemov@gmail.com,hughd@google.com,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,balbirs@nvidia.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-move-unrelated-code-out-of-__split_unmapped_folio.patch added to mm-new branch
Message-Id: <20250712222032.D6E59C4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/huge_memory: move unrelated code out of __split_unmapped_folio()
has been added to the -mm mm-new branch.  Its filename is
     mm-huge_memory-move-unrelated-code-out-of-__split_unmapped_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-move-unrelated-code-out-of-__split_unmapped_folio.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
Subject: mm/huge_memory: move unrelated code out of __split_unmapped_folio()
Date: Fri, 11 Jul 2025 14:23:54 -0400

Patch series "__folio_split() clean up.", v2.

Based on the prior discussion[1], this patch improves
__split_unmapped_folio() by making it reusable for splitting unmapped
folios.  This helps avoid the need for a new boolean unmapped parameter to
guard mapping-related code.

An additional benefit is that __split_unmapped_folio() could be called on
after-split folios by __folio_split().  It can enable new split methods. 
For example, at deferred split time, unmapped subpages can scatter
arbitrarily within a large folio, neither uniform nor non-uniform split
can maximize after-split folio orders for mapped subpages.  The hope is
that by calling __split_unmapped_folio() multiple times, a better split
result can be achieved.


This patch (of 2):

remap(), folio_ref_unfreeze(), lru_add_split_folio() are not relevant to
splitting unmapped folio operations.  Move them out to the caller so that
__split_unmapped_folio() only handles unmapped folio splits.  This makes
__split_unmapped_folio() reusable.

Convert VM_BUG_ON(mapping) to use VM_WARN_ON_ONCE_FOLIO().

Link: https://lkml.kernel.org/r/20250711182355.3592618-1-ziy@nvidia.com
Link: https://lkml.kernel.org/r/20250711182355.3592618-2-ziy@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kirill A. Shutemov <k.shutemov@gmail.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |  273 ++++++++++++++++++++++-----------------------
 1 file changed, 137 insertions(+), 136 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-move-unrelated-code-out-of-__split_unmapped_folio
+++ a/mm/huge_memory.c
@@ -3385,10 +3385,6 @@ static void __split_folio_to_order(struc
  *             order - 1 to new_order).
  * @split_at: in buddy allocator like split, the folio containing @split_at
  *            will be split until its order becomes @new_order.
- * @lock_at: the folio containing @lock_at is left locked for caller.
- * @list: the after split folios will be added to @list if it is not NULL,
- *        otherwise to LRU lists.
- * @end: the end of the file @folio maps to. -1 if @folio is anonymous memory.
  * @xas: xa_state pointing to folio->mapping->i_pages and locked by caller
  * @mapping: @folio->mapping
  * @uniform_split: if the split is uniform or not (buddy allocator like split)
@@ -3414,51 +3410,26 @@ static void __split_folio_to_order(struc
  *    @page, which is split in next for loop.
  *
  * After splitting, the caller's folio reference will be transferred to the
- * folio containing @page. The other folios may be freed if they are not mapped.
- *
- * In terms of locking, after splitting,
- * 1. uniform split leaves @page (or the folio contains it) locked;
- * 2. buddy allocator like (non-uniform) split leaves @folio locked.
- *
+ * folio containing @page. The caller needs to unlock and/or free after-split
+ * folios if necessary.
  *
  * For !uniform_split, when -ENOMEM is returned, the original folio might be
  * split. The caller needs to check the input folio.
  */
 static int __split_unmapped_folio(struct folio *folio, int new_order,
-		struct page *split_at, struct page *lock_at,
-		struct list_head *list, pgoff_t end,
-		struct xa_state *xas, struct address_space *mapping,
-		bool uniform_split)
+		struct page *split_at, struct xa_state *xas,
+		struct address_space *mapping, bool uniform_split)
 {
-	struct lruvec *lruvec;
-	struct address_space *swap_cache = NULL;
-	struct folio *origin_folio = folio;
-	struct folio *next_folio = folio_next(folio);
-	struct folio *new_folio;
 	struct folio *next;
 	int order = folio_order(folio);
 	int split_order;
 	int start_order = uniform_split ? new_order : order - 1;
-	int nr_dropped = 0;
 	int ret = 0;
 	bool stop_split = false;
 
-	if (folio_test_swapcache(folio)) {
-		VM_BUG_ON(mapping);
-
-		/* a swapcache folio can only be uniformly split to order-0 */
-		if (!uniform_split || new_order != 0)
-			return -EINVAL;
-
-		swap_cache = swap_address_space(folio->swap);
-		xa_lock(&swap_cache->i_pages);
-	}
-
 	if (folio_test_anon(folio))
 		mod_mthp_stat(order, MTHP_STAT_NR_ANON, -1);
 
-	/* lock lru list/PageCompound, ref frozen by page_ref_freeze */
-	lruvec = folio_lruvec_lock(folio);
 
 	folio_clear_has_hwpoisoned(folio);
 
@@ -3469,9 +3440,9 @@ static int __split_unmapped_folio(struct
 	for (split_order = start_order;
 	     split_order >= new_order && !stop_split;
 	     split_order--) {
-		int old_order = folio_order(folio);
-		struct folio *release;
 		struct folio *end_folio = folio_next(folio);
+		int old_order = folio_order(folio);
+		struct folio *new_folio;
 
 		/* order-1 anonymous folio is not supported */
 		if (folio_test_anon(folio) && split_order == 1)
@@ -3506,113 +3477,34 @@ static int __split_unmapped_folio(struct
 
 after_split:
 		/*
-		 * Iterate through after-split folios and perform related
-		 * operations. But in buddy allocator like split, the folio
+		 * Iterate through after-split folios and update folio stats.
+		 * But in buddy allocator like split, the folio
 		 * containing the specified page is skipped until its order
 		 * is new_order, since the folio will be worked on in next
 		 * iteration.
 		 */
-		for (release = folio; release != end_folio; release = next) {
-			next = folio_next(release);
+		for (new_folio = folio; new_folio != end_folio; new_folio = next) {
+			next = folio_next(new_folio);
 			/*
-			 * for buddy allocator like split, the folio containing
-			 * page will be split next and should not be released,
-			 * until the folio's order is new_order or stop_split
-			 * is set to true by the above xas_split() failure.
+			 * for buddy allocator like split, new_folio containing
+			 * page could be split again, thus do not change stats
+			 * yet. Wait until new_folio's order is new_order or
+			 * stop_split is set to true by the above xas_split()
+			 * failure.
 			 */
-			if (release == page_folio(split_at)) {
-				folio = release;
+			if (new_folio == page_folio(split_at)) {
+				folio = new_folio;
 				if (split_order != new_order && !stop_split)
 					continue;
 			}
-			if (folio_test_anon(release)) {
-				mod_mthp_stat(folio_order(release),
+			if (folio_test_anon(new_folio)) {
+				mod_mthp_stat(folio_order(new_folio),
 						MTHP_STAT_NR_ANON, 1);
 			}
 
-			/*
-			 * origin_folio should be kept frozon until page cache
-			 * entries are updated with all the other after-split
-			 * folios to prevent others seeing stale page cache
-			 * entries.
-			 */
-			if (release == origin_folio)
-				continue;
-
-			folio_ref_unfreeze(release, 1 +
-					((mapping || swap_cache) ?
-						folio_nr_pages(release) : 0));
-
-			lru_add_split_folio(origin_folio, release, lruvec,
-					list);
-
-			/* Some pages can be beyond EOF: drop them from cache */
-			if (release->index >= end) {
-				if (shmem_mapping(mapping))
-					nr_dropped += folio_nr_pages(release);
-				else if (folio_test_clear_dirty(release))
-					folio_account_cleaned(release,
-						inode_to_wb(mapping->host));
-				__filemap_remove_folio(release, NULL);
-				folio_put_refs(release, folio_nr_pages(release));
-			} else if (mapping) {
-				__xa_store(&mapping->i_pages,
-						release->index, release, 0);
-			} else if (swap_cache) {
-				__xa_store(&swap_cache->i_pages,
-						swap_cache_index(release->swap),
-						release, 0);
-			}
 		}
 	}
 
-	/*
-	 * Unfreeze origin_folio only after all page cache entries, which used
-	 * to point to it, have been updated with new folios. Otherwise,
-	 * a parallel folio_try_get() can grab origin_folio and its caller can
-	 * see stale page cache entries.
-	 */
-	folio_ref_unfreeze(origin_folio, 1 +
-		((mapping || swap_cache) ? folio_nr_pages(origin_folio) : 0));
-
-	unlock_page_lruvec(lruvec);
-
-	if (swap_cache)
-		xa_unlock(&swap_cache->i_pages);
-	if (mapping)
-		xa_unlock(&mapping->i_pages);
-
-	/* Caller disabled irqs, so they are still disabled here */
-	local_irq_enable();
-
-	if (nr_dropped)
-		shmem_uncharge(mapping->host, nr_dropped);
-
-	remap_page(origin_folio, 1 << order,
-			folio_test_anon(origin_folio) ?
-				RMP_USE_SHARED_ZEROPAGE : 0);
-
-	/*
-	 * At this point, folio should contain the specified page.
-	 * For uniform split, it is left for caller to unlock.
-	 * For buddy allocator like split, the first after-split folio is left
-	 * for caller to unlock.
-	 */
-	for (new_folio = origin_folio; new_folio != next_folio; new_folio = next) {
-		next = folio_next(new_folio);
-		if (new_folio == page_folio(lock_at))
-			continue;
-
-		folio_unlock(new_folio);
-		/*
-		 * Subpages may be freed if there wasn't any mapping
-		 * like if add_to_swap() is running on a lru page that
-		 * had its mapping zapped. And freeing these pages
-		 * requires taking the lru_lock so we do the put_page
-		 * of the tail pages after the split is complete.
-		 */
-		free_folio_and_swap_cache(new_folio);
-	}
 	return ret;
 }
 
@@ -3695,10 +3587,13 @@ static int __folio_split(struct folio *f
 {
 	struct deferred_split *ds_queue = get_deferred_split_queue(folio);
 	XA_STATE(xas, &folio->mapping->i_pages, folio->index);
+	struct folio *next_folio = folio_next(folio);
 	bool is_anon = folio_test_anon(folio);
 	struct address_space *mapping = NULL;
 	struct anon_vma *anon_vma = NULL;
 	int order = folio_order(folio);
+	struct folio *new_folio, *next;
+	int nr_shmem_dropped = 0;
 	int extra_pins, ret;
 	pgoff_t end;
 	bool is_hzp;
@@ -3822,13 +3717,18 @@ static int __folio_split(struct folio *f
 		 */
 		xas_lock(&xas);
 		xas_reset(&xas);
-		if (xas_load(&xas) != folio)
+		if (xas_load(&xas) != folio) {
+			ret = -EAGAIN;
 			goto fail;
+		}
 	}
 
 	/* Prevent deferred_split_scan() touching ->_refcount */
 	spin_lock(&ds_queue->split_queue_lock);
 	if (folio_ref_freeze(folio, 1 + extra_pins)) {
+		struct address_space *swap_cache = NULL;
+		struct lruvec *lruvec;
+
 		if (folio_order(folio) > 1 &&
 		    !list_empty(&folio->_deferred_list)) {
 			ds_queue->split_queue_len--;
@@ -3862,18 +3762,119 @@ static int __folio_split(struct folio *f
 			}
 		}
 
-		ret = __split_unmapped_folio(folio, new_order,
-				split_at, lock_at, list, end, &xas, mapping,
-				uniform_split);
+		if (folio_test_swapcache(folio)) {
+			if (mapping) {
+				VM_WARN_ON_ONCE_FOLIO(mapping, folio);
+				ret = -EINVAL;
+				goto fail;
+			}
+
+			/*
+			 * a swapcache folio can only be uniformly split to
+			 * order-0
+			 */
+			if (!uniform_split || new_order != 0) {
+				ret = -EINVAL;
+				goto fail;
+			}
+
+			swap_cache = swap_address_space(folio->swap);
+			xa_lock(&swap_cache->i_pages);
+		}
+
+		/* lock lru list/PageCompound, ref frozen by page_ref_freeze */
+		lruvec = folio_lruvec_lock(folio);
+
+		ret = __split_unmapped_folio(folio, new_order, split_at, &xas,
+					     mapping, uniform_split);
+
+		/*
+		 * Unfreeze after-split folios and put them back to the right
+		 * list. @folio should be kept frozon until page cache entries
+		 * are updated with all the other after-split folios to prevent
+		 * others seeing stale page cache entries.
+		 */
+		for (new_folio = folio_next(folio); new_folio != next_folio;
+		     new_folio = next) {
+			next = folio_next(new_folio);
+
+			folio_ref_unfreeze(
+				new_folio,
+				1 + ((mapping || swap_cache) ?
+					     folio_nr_pages(new_folio) :
+					     0));
+
+			lru_add_split_folio(folio, new_folio, lruvec, list);
+
+			/* Some pages can be beyond EOF: drop them from cache */
+			if (new_folio->index >= end) {
+				if (shmem_mapping(mapping))
+					nr_shmem_dropped += folio_nr_pages(new_folio);
+				else if (folio_test_clear_dirty(new_folio))
+					folio_account_cleaned(
+						new_folio,
+						inode_to_wb(mapping->host));
+				__filemap_remove_folio(new_folio, NULL);
+				folio_put_refs(new_folio,
+					       folio_nr_pages(new_folio));
+			} else if (mapping) {
+				__xa_store(&mapping->i_pages, new_folio->index,
+					   new_folio, 0);
+			} else if (swap_cache) {
+				__xa_store(&swap_cache->i_pages,
+					   swap_cache_index(new_folio->swap),
+					   new_folio, 0);
+			}
+		}
+		/*
+		 * Unfreeze @folio only after all page cache entries, which
+		 * used to point to it, have been updated with new folios.
+		 * Otherwise, a parallel folio_try_get() can grab origin_folio
+		 * and its caller can see stale page cache entries.
+		 */
+		folio_ref_unfreeze(folio, 1 +
+			((mapping || swap_cache) ? folio_nr_pages(folio) : 0));
+
+		unlock_page_lruvec(lruvec);
+
+		if (swap_cache)
+			xa_unlock(&swap_cache->i_pages);
 	} else {
 		spin_unlock(&ds_queue->split_queue_lock);
-fail:
-		if (mapping)
-			xas_unlock(&xas);
-		local_irq_enable();
-		remap_page(folio, folio_nr_pages(folio), 0);
 		ret = -EAGAIN;
 	}
+fail:
+	if (mapping)
+		xas_unlock(&xas);
+
+	local_irq_enable();
+
+	if (nr_shmem_dropped)
+		shmem_uncharge(mapping->host, nr_shmem_dropped);
+
+	remap_page(folio, 1 << order,
+		   !ret && folio_test_anon(folio) ? RMP_USE_SHARED_ZEROPAGE :
+						    0);
+
+	/*
+	 * Unlock all after-split folios except the one containing @lock_at
+	 * page. If @folio is not split, it will be kept locked.
+	 */
+	for (new_folio = folio; new_folio != next_folio; new_folio = next) {
+		next = folio_next(new_folio);
+		if (new_folio == page_folio(lock_at))
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
+		free_folio_and_swap_cache(new_folio);
+	}
 
 out_unlock:
 	if (anon_vma) {
_

Patches currently in -mm which might be from ziy@nvidia.com are

selftests-mm-fix-split_huge_page_test-for-folio_split-tests.patch
mm-page_alloc-pageblock-flags-functions-clean-up.patch
mm-page_isolation-make-page-isolation-a-standalone-bit.patch
mm-page_alloc-add-support-for-initializing-pageblock-as-isolated.patch
mm-page_isolation-remove-migratetype-from-move_freepages_block_isolate.patch
mm-page_isolation-remove-migratetype-from-undo_isolate_page_range.patch
mm-page_isolation-remove-migratetype-parameter-from-more-functions.patch
mm-huge_memory-move-unrelated-code-out-of-__split_unmapped_folio.patch
mm-huge_memory-use-folio_expected_ref_count-to-calculate-ref_count.patch

