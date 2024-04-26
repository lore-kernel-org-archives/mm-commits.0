Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CE907EEE3
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104018; cv=none; b=ZphpbRQhIc7gviy7y0hGc6feroU8UtvbDal226LAQLJQJjE8oWBFkzz8R8y6uRLwhULBVIqNPBw6oJ5fAieZ3k5vm1rfcqTLpIXuY4ufHuIA0qu5uWUheGcxn+bwz3/Yzx2DwZPZGRz9gQAJeb47lrVqNIE9KbYL+W4ptvG9C0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104018; c=relaxed/simple;
	bh=uZEFjw4tUUaXNxf6cL9n5yV+QtzQFgjNqbORn+0/CHw=;
	h=Date:To:From:Subject:Message-Id; b=sSBmiyRimOjhkFL3fEH88FBoREbPw7usAXJ+RScNZfNbYAiUkKP1Ph0EW0PM0TT8vxXahfUIv1DVRtJk8efwq747ITxVERIrI5YK3xn+98w81O2C9k0kQo2MjwYpEPLlS+BmTFRHNgoO/LtMjY/FS2I5WxjgCB1D0nd2HkuJueE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dVb96hRt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dVb96hRt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31C8BC113CD;
	Fri, 26 Apr 2024 04:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104018;
	bh=uZEFjw4tUUaXNxf6cL9n5yV+QtzQFgjNqbORn+0/CHw=;
	h=Date:To:From:Subject:From;
	b=dVb96hRtM+9qcNDrQGdVhZzKjia25GlXS8jLkjyqystApTVUMpkCIUZQ4pnUFvNsz
	 Rd/+313VKWCKDsSG78a1kfWLbsA7ClX9AfNc7uKn1QA62Z3ZkWxAuJHaEYaf1zOBFr
	 qR98acyumSaN8pAjWZJcTTEqxFT3hPKOWNkkc8NE=
Date: Thu, 25 Apr 2024 21:00:17 -0700
To: mm-commits@vger.kernel.org,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-make-page_mapped-take-a-const-argument.patch removed from -mm tree
Message-Id: <20240426040018.31C8BC113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: make page_mapped() take a const argument
has been removed from the -mm tree.  Its filename was
     mm-make-page_mapped-take-a-const-argument.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: make page_mapped() take a const argument
Date: Tue, 26 Mar 2024 17:10:28 +0000

None of the functions called by page_mapped() modify the page or folio, so
mark them all as const.

Link: https://lkml.kernel.org/r/20240326171045.410737-7-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   12 ++++++------
 mm/internal.h      |    7 ++++---
 mm/rmap.c          |    2 +-
 3 files changed, 11 insertions(+), 10 deletions(-)

--- a/include/linux/mm.h~mm-make-page_mapped-take-a-const-argument
+++ a/include/linux/mm.h
@@ -1200,7 +1200,7 @@ static inline int is_vmalloc_or_module_a
  * debugging purposes - it does not include PTE-mapped sub-pages; look
  * at folio_mapcount() or page_mapcount() instead.
  */
-static inline int folio_entire_mapcount(struct folio *folio)
+static inline int folio_entire_mapcount(const struct folio *folio)
 {
 	VM_BUG_ON_FOLIO(!folio_test_large(folio), folio);
 	return atomic_read(&folio->_entire_mapcount) + 1;
@@ -1240,7 +1240,7 @@ static inline int page_mapcount(struct p
 	return mapcount;
 }
 
-int folio_total_mapcount(struct folio *folio);
+int folio_total_mapcount(const struct folio *folio);
 
 /**
  * folio_mapcount() - Calculate the number of mappings of this folio.
@@ -1253,14 +1253,14 @@ int folio_total_mapcount(struct folio *f
  *
  * Return: The number of times this folio is mapped.
  */
-static inline int folio_mapcount(struct folio *folio)
+static inline int folio_mapcount(const struct folio *folio)
 {
 	if (likely(!folio_test_large(folio)))
 		return atomic_read(&folio->_mapcount) + 1;
 	return folio_total_mapcount(folio);
 }
 
-static inline bool folio_large_is_mapped(struct folio *folio)
+static inline bool folio_large_is_mapped(const struct folio *folio)
 {
 	/*
 	 * Reading _entire_mapcount below could be omitted if hugetlb
@@ -1288,7 +1288,7 @@ static inline bool folio_mapped(struct f
  * For compound page it returns true if any sub-page of compound page is mapped,
  * even if this particular sub-page is not itself mapped by any PTE or PMD.
  */
-static inline bool page_mapped(struct page *page)
+static inline bool page_mapped(const struct page *page)
 {
 	if (likely(!PageCompound(page)))
 		return atomic_read(&page->_mapcount) >= 0;
@@ -2070,7 +2070,7 @@ static inline void set_page_links(struct
  *
  * Return: A positive power of two.
  */
-static inline long folio_nr_pages(struct folio *folio)
+static inline long folio_nr_pages(const struct folio *folio)
 {
 	if (!folio_test_large(folio))
 		return 1;
--- a/mm/internal.h~mm-make-page_mapped-take-a-const-argument
+++ a/mm/internal.h
@@ -71,7 +71,7 @@ void page_writeback_init(void);
  * How many individual pages have an elevated _mapcount.  Excludes
  * the folio's entire_mapcount.
  */
-static inline int folio_nr_pages_mapped(struct folio *folio)
+static inline int folio_nr_pages_mapped(const struct folio *folio)
 {
 	return atomic_read(&folio->_nr_pages_mapped) & FOLIO_PAGES_MAPPED;
 }
@@ -81,7 +81,8 @@ static inline int folio_nr_pages_mapped(
  * folio. We cannot rely on folio->swap as there is no guarantee that it has
  * been initialized. Used for calling arch_swap_restore()
  */
-static inline swp_entry_t folio_swap(swp_entry_t entry, struct folio *folio)
+static inline swp_entry_t folio_swap(swp_entry_t entry,
+		const struct folio *folio)
 {
 	swp_entry_t swap = {
 		.val = ALIGN_DOWN(entry.val, folio_nr_pages(folio)),
@@ -90,7 +91,7 @@ static inline swp_entry_t folio_swap(swp
 	return swap;
 }
 
-static inline void *folio_raw_mapping(struct folio *folio)
+static inline void *folio_raw_mapping(const struct folio *folio)
 {
 	unsigned long mapping = (unsigned long)folio->mapping;
 
--- a/mm/rmap.c~mm-make-page_mapped-take-a-const-argument
+++ a/mm/rmap.c
@@ -1134,7 +1134,7 @@ int pfn_mkclean_range(unsigned long pfn,
 	return page_vma_mkclean_one(&pvmw);
 }
 
-int folio_total_mapcount(struct folio *folio)
+int folio_total_mapcount(const struct folio *folio)
 {
 	int mapcount = folio_entire_mapcount(folio);
 	int nr_pages;
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

