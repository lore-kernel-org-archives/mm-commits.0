Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB7DA45D5FF
	for <mm-commits@vger.kernel.org>; Wed, 23 Sep 2026 22:32:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790202752; cv=none; b=d8Hl5nXn3B/+T0olI7+GnokYactbEJkBMG7R0aL0DNFfjnnYH3fgfMljt8ewOHget1KObHGT7wuS5aBl8ydlxzowBFQSbFzJWV4dfa/JMPk8U9xA87nr0+RGYbi55ChGAMKPeq6kVldLtIt6m1uzwldo9cHq1UftkuivCXMCXI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790202752; c=relaxed/simple;
	bh=eHS12Aj72b1y7CSt3UCq1oYVwDV3GK5V6yuXB6QpY+Y=;
	h=Date:To:From:Subject:Message-Id; b=izmwjOaoYvHwk/bj6At5fJEcY6yXgJEMqRWIPIGpjhBbagV/gFTV3a7GDvldgULWMfdR4NAMhmK+xcZSYjsPDa+IZaRN8x6GvJLmWnibAOUzKvIWo5LWZyQl/qI3YWvqdGBAI2OT/lKx8nUkhw0QZZjTvKTWYfQ11ELEQx2rZtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XGmGdQNx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XGmGdQNx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C88B1F00893;
	Wed, 23 Sep 2026 22:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790202748;
	bh=s+p2G4iDGFN6Mm0yOxWPRNiTd/DF3cuKCIWFjM5kfxk=;
	h=Date:To:From:Subject;
	b=XGmGdQNx+pDd3NoNwB7OR3aBT5mzFAd7YB3ee3cw6IuAZnySYm6jahuO/kIr1F9MP
	 yp8IngIK1c7ZwftTeutqKxUIhdQQp6XUU/WKlaexVYI/Dd655GD9EunnI2yPkPZ4Cz
	 631VI1H8zVp9ibWjziLGy4lNv0RYdvg/edrcCZDE=
Date: Wed, 23 Sep 2026 15:32:27 -0700
To: mm-commits@vger.kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-invert-folio_ref_freeze-check-to-reduce-indentation.patch added to mm-unstable branch
Message-Id: <20260923223228.5C88B1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/huge_memory: invert folio_ref_freeze() check to reduce indentation
has been added to the -mm mm-unstable branch.  Its filename is
     mm-huge_memory-invert-folio_ref_freeze-check-to-reduce-indentation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-invert-folio_ref_freeze-check-to-reduce-indentation.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm/huge_memory: invert folio_ref_freeze() check to reduce indentation
Date: Wed, 23 Sep 2026 23:32:34 +0200

Invert the folio_ref_freeze() success check in
__folio_freeze_and_split_unmapped() to return early on failure, which
removes one level of indentation from the entire success path.

This is a pure refactoring with no functional change.  It prepares the
function to be split into separate helpers for anonymous and file-backed
folios in a later patch.

Link: https://lore.kernel.org/20260923-swap-thp-cleanup-v6-3-ba1b4ba72c6f@tencent.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Youngjun Park <youngjun.park@lge.com>
Cc: Shivam Kalra <shivamkalra98@zohomail.in>
Cc: Kairui Song <ryncsn@gmail.com>
---

 mm/huge_memory.c |  186 ++++++++++++++++++++++-----------------------
 1 file changed, 92 insertions(+), 94 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-invert-folio_ref_freeze-check-to-reduce-indentation
+++ a/mm/huge_memory.c
@@ -4014,122 +4014,120 @@ static int __folio_freeze_and_split_unma
 					     pgoff_t end, int *nr_shmem_dropped)
 {
 	struct folio *end_folio = folio_next(folio);
+	struct swap_cluster_info *ci = NULL;
 	struct folio *new_folio, *next;
+	struct lruvec *lruvec;
 	int ret = 0;
 
 	VM_WARN_ON_ONCE(!mapping && end);
 
-	if (folio_ref_freeze(folio, folio_cache_ref_count(folio) + 1)) {
-		struct swap_cluster_info *ci = NULL;
-		struct lruvec *lruvec;
-
-		/* Take off the deferred split queue while frozen and memcg set */
-		folio_unqueue_deferred_split(folio);
-
-		/*
-		 * deferred_split_scan() takes the folio off the queue before it
-		 * splits it, so the unqueue above finds an empty list and
-		 * leaves PG_partially_mapped set.
-		 * Clear it here: the flag does not survive the split.
-		 */
-		folio_reset_partially_mapped(folio);
+	if (!folio_ref_freeze(folio, folio_cache_ref_count(folio) + 1))
+		return -EAGAIN;
 
-		if (mapping) {
-			int nr = folio_nr_pages(folio);
+	/* Take off the deferred split queue while frozen and memcg set */
+	folio_unqueue_deferred_split(folio);
 
-			if (folio_test_pmd_mappable(folio) &&
-			    new_order < HPAGE_PMD_ORDER) {
-				if (folio_test_swapbacked(folio)) {
-					lruvec_stat_mod_folio(folio,
-							NR_SHMEM_THPS, -nr);
-				} else {
-					lruvec_stat_mod_folio(folio,
-							NR_FILE_THPS, -nr);
-				}
+	/*
+	 * deferred_split_scan() takes the folio off the queue before it
+	 * splits it, so the unqueue above finds an empty list and
+	 * leaves PG_partially_mapped set.
+	 * Clear it here: the flag does not survive the split.
+	 */
+	folio_reset_partially_mapped(folio);
+
+	if (mapping) {
+		int nr = folio_nr_pages(folio);
+
+		if (folio_test_pmd_mappable(folio) &&
+		    new_order < HPAGE_PMD_ORDER) {
+			if (folio_test_swapbacked(folio)) {
+				lruvec_stat_mod_folio(folio,
+						NR_SHMEM_THPS, -nr);
+			} else {
+				lruvec_stat_mod_folio(folio,
+						NR_FILE_THPS, -nr);
 			}
 		}
+	}
 
-		if (folio_test_swapcache(folio))
-			ci = swap_cluster_get_and_lock(folio);
+	if (folio_test_swapcache(folio))
+		ci = swap_cluster_get_and_lock(folio);
 
-		/* lock lru list/PageCompound, ref frozen by page_ref_freeze */
-		if (do_lru)
-			lruvec = folio_lruvec_lock(folio);
+	/* lock lru list/PageCompound, ref frozen by page_ref_freeze */
+	if (do_lru)
+		lruvec = folio_lruvec_lock(folio);
+
+	ret = __split_unmapped_folio(folio, new_order, split_at, xas,
+				     mapping, split_type);
+
+	/*
+	 * Unfreeze after-split folios and put them back to the right
+	 * list. @folio should be kept frozon until page cache
+	 * entries are updated with all the other after-split folios
+	 * to prevent others seeing stale page cache entries.
+	 * As a result, new_folio starts from the next folio of
+	 * @folio.
+	 */
+	for (new_folio = folio_next(folio); new_folio != end_folio;
+	     new_folio = next) {
+		unsigned long nr_pages = folio_nr_pages(new_folio);
 
-		ret = __split_unmapped_folio(folio, new_order, split_at, xas,
-					     mapping, split_type);
+		next = folio_next(new_folio);
 
-		/*
-		 * Unfreeze after-split folios and put them back to the right
-		 * list. @folio should be kept frozon until page cache
-		 * entries are updated with all the other after-split folios
-		 * to prevent others seeing stale page cache entries.
-		 * As a result, new_folio starts from the next folio of
-		 * @folio.
-		 */
-		for (new_folio = folio_next(folio); new_folio != end_folio;
-		     new_folio = next) {
-			unsigned long nr_pages = folio_nr_pages(new_folio);
-
-			next = folio_next(new_folio);
-
-			zone_device_private_split_cb(folio, new_folio);
-
-			folio_ref_unfreeze(new_folio,
-					   folio_cache_ref_count(new_folio) + 1);
-
-			if (do_lru)
-				lru_add_split_folio(folio, new_folio, lruvec, list);
-
-			/*
-			 * Anonymous folio with swap cache.
-			 * NOTE: shmem in swap cache is not supported yet.
-			 */
-			if (ci) {
-				__swap_cache_replace_folio(ci, folio, new_folio);
-				continue;
-			}
+		zone_device_private_split_cb(folio, new_folio);
 
-			/* Anonymous folio without swap cache */
-			if (!mapping)
-				continue;
-
-			/* Add the new folio to the page cache. */
-			if (new_folio->index < end) {
-				__xa_store(&mapping->i_pages, new_folio->index,
-					   new_folio, 0);
-				continue;
-			}
+		folio_ref_unfreeze(new_folio,
+				   folio_cache_ref_count(new_folio) + 1);
 
-			VM_WARN_ON_ONCE(!nr_shmem_dropped);
-			/* Drop folio beyond EOF: ->index >= end */
-			if (shmem_mapping(mapping) && nr_shmem_dropped)
-				*nr_shmem_dropped += nr_pages;
-			else if (folio_test_clear_dirty(new_folio))
-				folio_account_cleaned(
-					new_folio, inode_to_wb(mapping->host));
-			__filemap_remove_folio(new_folio, NULL);
-			folio_put_refs(new_folio, nr_pages);
-		}
+		if (do_lru)
+			lru_add_split_folio(folio, new_folio, lruvec, list);
 
-		zone_device_private_split_cb(folio, NULL);
 		/*
-		 * Unfreeze @folio only after all page cache entries, which
-		 * used to point to it, have been updated with new folios.
-		 * Otherwise, a parallel folio_try_get() can grab @folio
-		 * and its caller can see stale page cache entries.
+		 * Anonymous folio with swap cache.
+		 * NOTE: shmem in swap cache is not supported yet.
 		 */
-		folio_ref_unfreeze(folio, folio_cache_ref_count(folio) + 1);
+		if (ci) {
+			__swap_cache_replace_folio(ci, folio, new_folio);
+			continue;
+		}
 
-		if (do_lru)
-			lruvec_unlock(lruvec);
+		/* Anonymous folio without swap cache */
+		if (!mapping)
+			continue;
+
+		/* Add the new folio to the page cache. */
+		if (new_folio->index < end) {
+			__xa_store(&mapping->i_pages, new_folio->index,
+				   new_folio, 0);
+			continue;
+		}
 
-		if (ci)
-			swap_cluster_unlock(ci);
-	} else {
-		return -EAGAIN;
+		VM_WARN_ON_ONCE(!nr_shmem_dropped);
+		/* Drop folio beyond EOF: ->index >= end */
+		if (shmem_mapping(mapping) && nr_shmem_dropped)
+			*nr_shmem_dropped += nr_pages;
+		else if (folio_test_clear_dirty(new_folio))
+			folio_account_cleaned(
+				new_folio, inode_to_wb(mapping->host));
+		__filemap_remove_folio(new_folio, NULL);
+		folio_put_refs(new_folio, nr_pages);
 	}
 
+	zone_device_private_split_cb(folio, NULL);
+	/*
+	 * Unfreeze @folio only after all page cache entries, which
+	 * used to point to it, have been updated with new folios.
+	 * Otherwise, a parallel folio_try_get() can grab @folio
+	 * and its caller can see stale page cache entries.
+	 */
+	folio_ref_unfreeze(folio, folio_cache_ref_count(folio) + 1);
+
+	if (do_lru)
+		lruvec_unlock(lruvec);
+
+	if (ci)
+		swap_cluster_unlock(ci);
+
 	return ret;
 }
 
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-memcontrol-move-the-lru_zone_size-sanity-check-to-the-reader-side.patch
mm-mglru-introduce-helpers-for-manipulating-gen-and-refs-flags.patch
mm-migrate-copy-all-referenced-state-via-folio_migrate_lru_refs.patch
mm-mglru-move-max_seq-read-into-walk_update_folio.patch
mm-mglru-use-explicit-tier-range-in-read_ctrl_pos.patch
mm-mglru-fix-potential-generation-folio-number-leak.patch
mm-swap-fix-off-by-one-in-swap-cache-replace-sanity-check.patch
mm-huge_memory-fix-rejection-of-swap-cache-folios-with-a-mapping.patch
mm-huge_memory-invert-folio_ref_freeze-check-to-reduce-indentation.patch
mm-huge_memory-split-the-routine-for-splitting-anon-and-file-folio.patch
mm-huge_memory-rename-__split_unmapped_folio-to-__split_frozen_folio.patch
mm-huge_memory-consolidate-irq-and-locking-for-folio-split.patch
mm-huge_memory-move-eof-trimming-into-the-file-split-helper.patch
mm-huge_memory-move-unmap-and-remap-into-the-split-helpers.patch
mm-huge_memory-rename-remap_page-to-remap_anon_folio.patch
mm-huge_memory-move-the-racy-refcount-check-into-unmap_folio.patch
mm-huge_memory-move-filemap-management-into-the-file-split-helper.patch
mm-huge_memory-move-anon_vma-handling-into-the-anon-split-helper.patch
mm-huge_memory-move-memcg-switch-into-the-file-split-helper.patch
mm-huge_memory-drop-the-unused-do_lru-argument-of-the-file-split-helper.patch
mm-huge_memory-clean-up-after-split-folio-freeing-in-__folio_split.patch
mm-huge_memory-count-only-swap-cache-refs-in-anon-folio-split.patch
mm-huge_memory-drop-the-redundant-mapping-argument-of-__split_frozen_folio.patch

