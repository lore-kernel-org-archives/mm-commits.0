Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B776B80BF8
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104174; cv=none; b=gNbc6BauMuVrH6fnzuV0t6CmcyEOY/v5/W9BNr2yIImhul7w187l+2sIPNquNSWNgLKFccwbqZgJBmev6RTWdF2M396xKMIEhs6h7Vq9M5buW3U6L5PDwX6+NyyGhdGT4qT47iamwYaLn+SlVRSdzDRrg/30VSLHEjd9ttQ5IJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104174; c=relaxed/simple;
	bh=ydXfJYfmEfIP5dHx4Wl4B2dbXuTUXyfjxBo4wbZhvPY=;
	h=Date:To:From:Subject:Message-Id; b=ap9nXwhBCtKbLi7K0UMm4FpynX72UDNiplNe2uSC5FwF/TBcPNOaqdWJeiRUvIG/f1QVxjNdN0GGMECmNTQtmrtvWt/Xrmr2AuR8a5RBWrQ1y+dWrA5tgA2+rz3JGOvixeNW7whM3Az42IdMpqNh9eqGXMXZwhLo7ITdkELZxwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VOmL5O+8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VOmL5O+8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E4BFC113CD;
	Fri, 26 Apr 2024 04:02:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104174;
	bh=ydXfJYfmEfIP5dHx4Wl4B2dbXuTUXyfjxBo4wbZhvPY=;
	h=Date:To:From:Subject:From;
	b=VOmL5O+8vnKevRKMMCvze5elCviLbI8/RhN12U5sRRCn9pd8zs7ZraZSzjXlZ3Q5h
	 5FTXWEHcjn7xu8moisb0bC9qEMbiZzVEqvfOL51AVrTSIw2Av35/8+GkBX+rcd1s6o
	 VXAQ8N/bqkJbvavoXyXfRJGQ9HbY6opsQGBtIj0Q=
Date: Thu, 25 Apr 2024 21:02:54 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-combine-free_the_page-and-free_unref_page.patch removed from -mm tree
Message-Id: <20240426040254.8E4BFC113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: combine free_the_page() and free_unref_page()
has been removed from the -mm tree.  Its filename was
     mm-combine-free_the_page-and-free_unref_page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: combine free_the_page() and free_unref_page()
Date: Fri, 5 Apr 2024 16:32:24 +0100

The pcp_allowed_order() check in free_the_page() was only being skipped by
__folio_put_small() which is about to be rearranged.

Link: https://lkml.kernel.org/r/20240405153228.2563754-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

--- a/mm/page_alloc.c~mm-combine-free_the_page-and-free_unref_page
+++ a/mm/page_alloc.c
@@ -541,14 +541,6 @@ static inline bool pcp_allowed_order(uns
 	return false;
 }
 
-static inline void free_the_page(struct page *page, unsigned int order)
-{
-	if (pcp_allowed_order(order))		/* Via pcp? */
-		free_unref_page(page, order);
-	else
-		__free_pages_ok(page, order, FPI_NONE);
-}
-
 /*
  * Higher-order pages are called "compound pages".  They are structured thusly:
  *
@@ -584,7 +576,7 @@ void destroy_large_folio(struct folio *f
 		folio_undo_large_rmappable(folio);
 
 	mem_cgroup_uncharge(folio);
-	free_the_page(&folio->page, folio_order(folio));
+	free_unref_page(&folio->page, folio_order(folio));
 }
 
 static inline void set_buddy_order(struct page *page, unsigned int order)
@@ -2573,6 +2565,11 @@ void free_unref_page(struct page *page,
 	unsigned long pfn = page_to_pfn(page);
 	int migratetype;
 
+	if (!pcp_allowed_order(order)) {
+		__free_pages_ok(page, order, FPI_NONE);
+		return;
+	}
+
 	if (!free_pages_prepare(page, order))
 		return;
 
@@ -4755,11 +4752,11 @@ void __free_pages(struct page *page, uns
 	struct alloc_tag *tag = pgalloc_tag_get(page);
 
 	if (put_page_testzero(page))
-		free_the_page(page, order);
+		free_unref_page(page, order);
 	else if (!head) {
 		pgalloc_tag_sub_pages(tag, (1 << order) - 1);
 		while (order-- > 0)
-			free_the_page(page + (1 << order), order);
+			free_unref_page(page + (1 << order), order);
 	}
 }
 EXPORT_SYMBOL(__free_pages);
@@ -4821,7 +4818,7 @@ void __page_frag_cache_drain(struct page
 	VM_BUG_ON_PAGE(page_ref_count(page) == 0, page);
 
 	if (page_ref_sub_and_test(page, count))
-		free_the_page(page, compound_order(page));
+		free_unref_page(page, compound_order(page));
 }
 EXPORT_SYMBOL(__page_frag_cache_drain);
 
@@ -4862,7 +4859,7 @@ refill:
 			goto refill;
 
 		if (unlikely(nc->pfmemalloc)) {
-			free_the_page(page, compound_order(page));
+			free_unref_page(page, compound_order(page));
 			goto refill;
 		}
 
@@ -4906,7 +4903,7 @@ void page_frag_free(void *addr)
 	struct page *page = virt_to_head_page(addr);
 
 	if (unlikely(put_page_testzero(page)))
-		free_the_page(page, compound_order(page));
+		free_unref_page(page, compound_order(page));
 }
 EXPORT_SYMBOL(page_frag_free);
 
_

Patches currently in -mm which might be from willy@infradead.org are

doc-improve-the-description-of-__folio_mark_dirty.patch
buffer-add-kernel-doc-for-block_dirty_folio.patch
buffer-add-kernel-doc-for-try_to_free_buffers.patch
buffer-fix-__bread-and-__bread_gfp-kernel-doc.patch
buffer-add-kernel-doc-for-brelse-and-__brelse.patch
buffer-add-kernel-doc-for-bforget-and-__bforget.patch
buffer-improve-bdev_getblk-documentation.patch
doc-split-bufferrst-out-of-api-summaryrst.patch
doc-split-bufferrst-out-of-api-summaryrst-fix.patch
mm-memory-failure-remove-fsdax_pgoff-argument-from-__add_to_kill.patch
mm-memory-failure-pass-addr-to-__add_to_kill.patch
mm-return-the-address-from-page_mapped_in_vma.patch
mm-make-page_mapped_in_vma-conditional-on-config_memory_failure.patch
mm-memory-failure-convert-shake_page-to-shake_folio.patch
mm-convert-hugetlb_page_mapping_lock_write-to-folio.patch
mm-memory-failure-convert-memory_failure-to-use-a-folio.patch
mm-memory-failure-convert-hwpoison_user_mappings-to-take-a-folio.patch
mm-memory-failure-add-some-folio-conversions-to-unpoison_memory.patch
mm-memory-failure-use-folio-functions-throughout-collect_procs.patch
mm-memory-failure-pass-the-folio-to-collect_procs_ksm.patch
fscrypt-convert-bh_get_inode_and_lblk_num-to-use-a-folio.patch
f2fs-convert-f2fs_clear_page_cache_dirty_tag-to-use-a-folio.patch
memory-failure-remove-calls-to-page_mapping.patch
migrate-expand-the-use-of-folio-in-__migrate_device_pages.patch
userfault-expand-folio-use-in-mfill_atomic_install_pte.patch
mm-remove-page_mapping.patch
mm-remove-page_cache_alloc.patch
mm-remove-put_devmap_managed_page.patch
mm-convert-put_devmap_managed_page_refs-to-put_devmap_managed_folio_refs.patch
mm-remove-page_ref_sub_return.patch
gup-use-folios-for-gup_devmap.patch
mm-add-kernel-doc-for-folio_mark_accessed.patch
mm-remove-pagereferenced.patch
mm-simplify-thp_vma_allowable_order.patch

