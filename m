Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFEDF823B0
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104177; cv=none; b=blmtih5fmwsw1rp3Hx4t9Abg5//B8iAKybmlmtZ1x3NTR+7CPFWLXHP7xPbpXTUWUxjUPvZMF0HWoAiDV7ZkJOdUPsBnqRrNr16GaazXTCjgMktntmlVXhBCEVfVhe+Z3ILAyYUiQXU75lNNBnRaxdFF/stNr4uGgOz9JjYOrW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104177; c=relaxed/simple;
	bh=TXbKlwdiG0HlK5qlOi2PYf1D0z4ZYQCzlzuG+RV9fXU=;
	h=Date:To:From:Subject:Message-Id; b=h8U7zBupc8AgMWUBYqEMr/eaLpMZIJLwhLeQYwjc+HQPyh0Elxa5sfKkLJAIPEP3V2ixwaTBfwJACAI2mtJ1KGW0Qw/eNpmarQo92HLEVPCQPIaCdfsMJg+0b1Ug1hY3gskklV9AOSS7N9mR4+Hbm0PZVT/IPtKrYQb9QgZaluU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AK/1Bb41; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AK/1Bb41"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94894C113CD;
	Fri, 26 Apr 2024 04:02:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104177;
	bh=TXbKlwdiG0HlK5qlOi2PYf1D0z4ZYQCzlzuG+RV9fXU=;
	h=Date:To:From:Subject:From;
	b=AK/1Bb41YAazmINmLmZNWBylc0dP5FLLU2+EfvBpPKUr3ktESXe3aBnkAqJFsJOfM
	 MnILTCDAY7MXlH1s+f5nwWajkvX8wQ1AicwVHod97S5PoIpRPYITUqyQ0WGNnDHrUA
	 IJwYCbI+xuOmb+YQJqU3rhMasZT3ixt95VC4mrwU=
Date: Thu, 25 Apr 2024 21:02:57 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-convert-free_zone_device_page-to-free_zone_device_folio.patch removed from -mm tree
Message-Id: <20240426040257.94894C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: convert free_zone_device_page to free_zone_device_folio
has been removed from the -mm tree.  Its filename was
     mm-convert-free_zone_device_page-to-free_zone_device_folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: convert free_zone_device_page to free_zone_device_folio
Date: Fri, 5 Apr 2024 16:32:27 +0100

Both callers already have a folio; pass it in and save a few calls to
compound_head().

Link: https://lkml.kernel.org/r/20240405153228.2563754-6-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    2 +-
 mm/memremap.c |   30 ++++++++++++++++--------------
 mm/swap.c     |    4 ++--
 3 files changed, 19 insertions(+), 17 deletions(-)

--- a/mm/internal.h~mm-convert-free_zone_device_page-to-free_zone_device_folio
+++ a/mm/internal.h
@@ -1165,7 +1165,7 @@ void __vunmap_range_noflush(unsigned lon
 int numa_migrate_prep(struct folio *folio, struct vm_fault *vmf,
 		      unsigned long addr, int page_nid, int *flags);
 
-void free_zone_device_page(struct page *page);
+void free_zone_device_folio(struct folio *folio);
 int migrate_device_coherent_page(struct page *page);
 
 /*
--- a/mm/memremap.c~mm-convert-free_zone_device_page-to-free_zone_device_folio
+++ a/mm/memremap.c
@@ -456,21 +456,23 @@ struct dev_pagemap *get_dev_pagemap(unsi
 }
 EXPORT_SYMBOL_GPL(get_dev_pagemap);
 
-void free_zone_device_page(struct page *page)
+void free_zone_device_folio(struct folio *folio)
 {
-	if (WARN_ON_ONCE(!page->pgmap->ops || !page->pgmap->ops->page_free))
+	if (WARN_ON_ONCE(!folio->page.pgmap->ops ||
+			!folio->page.pgmap->ops->page_free))
 		return;
 
-	mem_cgroup_uncharge(page_folio(page));
+	mem_cgroup_uncharge(folio);
 
 	/*
 	 * Note: we don't expect anonymous compound pages yet. Once supported
 	 * and we could PTE-map them similar to THP, we'd have to clear
 	 * PG_anon_exclusive on all tail pages.
 	 */
-	VM_BUG_ON_PAGE(PageAnon(page) && PageCompound(page), page);
-	if (PageAnon(page))
-		__ClearPageAnonExclusive(page);
+	if (folio_test_anon(folio)) {
+		VM_BUG_ON_FOLIO(folio_test_large(folio), folio);
+		__ClearPageAnonExclusive(folio_page(folio, 0));
+	}
 
 	/*
 	 * When a device managed page is freed, the folio->mapping field
@@ -481,20 +483,20 @@ void free_zone_device_page(struct page *
 	 *
 	 * For other types of ZONE_DEVICE pages, migration is either
 	 * handled differently or not done at all, so there is no need
-	 * to clear page->mapping.
+	 * to clear folio->mapping.
 	 */
-	page->mapping = NULL;
-	page->pgmap->ops->page_free(page);
+	folio->mapping = NULL;
+	folio->page.pgmap->ops->page_free(folio_page(folio, 0));
 
-	if (page->pgmap->type != MEMORY_DEVICE_PRIVATE &&
-	    page->pgmap->type != MEMORY_DEVICE_COHERENT)
+	if (folio->page.pgmap->type != MEMORY_DEVICE_PRIVATE &&
+	    folio->page.pgmap->type != MEMORY_DEVICE_COHERENT)
 		/*
-		 * Reset the page count to 1 to prepare for handing out the page
+		 * Reset the refcount to 1 to prepare for handing out the page
 		 * again.
 		 */
-		set_page_count(page, 1);
+		folio_set_count(folio, 1);
 	else
-		put_dev_pagemap(page->pgmap);
+		put_dev_pagemap(folio->page.pgmap);
 }
 
 void zone_device_page_init(struct page *page)
--- a/mm/swap.c~mm-convert-free_zone_device_page-to-free_zone_device_folio
+++ a/mm/swap.c
@@ -115,7 +115,7 @@ static void page_cache_release(struct fo
 void __folio_put(struct folio *folio)
 {
 	if (unlikely(folio_is_zone_device(folio))) {
-		free_zone_device_page(&folio->page);
+		free_zone_device_folio(folio);
 		return;
 	} else if (folio_test_hugetlb(folio)) {
 		free_huge_folio(folio);
@@ -983,7 +983,7 @@ void folios_put_refs(struct folio_batch
 			if (put_devmap_managed_page_refs(&folio->page, nr_refs))
 				continue;
 			if (folio_ref_sub_and_test(folio, nr_refs))
-				free_zone_device_page(&folio->page);
+				free_zone_device_folio(folio);
 			continue;
 		}
 
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

