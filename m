Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D3A97F7C1
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104112; cv=none; b=J2zEr8soJ1p3t0BMgEk8J426enHbyA4btiYq2/ZTVLYt4lF4pwCbeYdarcIq62P2JK9Zkv0EphKf7prnkmWjg+v5QkDkVMed5w5uQpU3rJ9WM09qWdGx8oKu9Dz4ydmEDE3o4nKe0HzJbo70QZlSBvmi8gvJTIB8Std8Am8kQxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104112; c=relaxed/simple;
	bh=YrR1yMoDj78GiTuaOtRevXTsETchtTXbTrVl3dltZAI=;
	h=Date:To:From:Subject:Message-Id; b=NdCFPEvT1uY/0SOtUeReqxZSY15q+KI6VBFYXkPUGRu2Kx/EmIcR9PktWT/svDwQ14XioJ1ASdpxjHtgxhJxnvrS5m9k2ldC51WbCBb2C9r/1gIvKmdQ+Bo+fGabothXLiote/pPL6EueSz89PJ2t3aDz0btLuAaZ+Ty+KbCkdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=su86TWOz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="su86TWOz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 745F2C113CD;
	Fri, 26 Apr 2024 04:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104112;
	bh=YrR1yMoDj78GiTuaOtRevXTsETchtTXbTrVl3dltZAI=;
	h=Date:To:From:Subject:From;
	b=su86TWOz3MGDuQSLpfuP6C1kfgj9Dq2GDPloG4Px6EaGbHzu90KXgaLZFugaUCp3W
	 xVnZ+/WbOvKp6oV3h+fp7/QUVa8WNFYeKlql5iuyzaMw6h6OQo5FB+K+5SWbqNAi+v
	 fV57KIwFtpo/UD3XMeMjglWCFbRgkDxsulGmQqgo=
Date: Thu, 25 Apr 2024 21:01:51 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-vma_address.patch removed from -mm tree
Message-Id: <20240426040152.745F2C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: remove vma_address()
has been removed from the -mm tree.  Its filename was
     mm-remove-vma_address.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: remove vma_address()
Date: Thu, 28 Mar 2024 22:58:28 +0000

Convert the three remaining callers to call vma_pgoff_address() directly. 
This removes an ambiguity where we'd check just one page if passed a tail
page and all N pages if passed a head page.

Also add better kernel-doc for vma_pgoff_address().

Link: https://lkml.kernel.org/r/20240328225831.1765286-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |   23 ++++++++---------------
 mm/rmap.c     |   12 +++++++++---
 2 files changed, 17 insertions(+), 18 deletions(-)

--- a/mm/internal.h~mm-remove-vma_address
+++ a/mm/internal.h
@@ -804,9 +804,14 @@ void mlock_drain_remote(int cpu);
 
 extern pmd_t maybe_pmd_mkwrite(pmd_t pmd, struct vm_area_struct *vma);
 
-/*
- * Return the start of user virtual address at the specific offset within
- * a vma.
+/**
+ * vma_pgoff_address - Find the virtual address a page range is mapped at
+ * @pgoff: The page offset within its object.
+ * @nr_pages: The number of pages to consider.
+ * @vma: The vma which maps this object.
+ *
+ * If any page in this range is mapped by this VMA, return the first address
+ * where any of these pages appear.  Otherwise, return -EFAULT.
  */
 static inline unsigned long
 vma_pgoff_address(pgoff_t pgoff, unsigned long nr_pages,
@@ -830,18 +835,6 @@ vma_pgoff_address(pgoff_t pgoff, unsigne
 }
 
 /*
- * Return the start of user virtual address of a page within a vma.
- * Returns -EFAULT if all of the page is outside the range of vma.
- * If page is a compound head, the entire compound page is considered.
- */
-static inline unsigned long
-vma_address(struct page *page, struct vm_area_struct *vma)
-{
-	VM_BUG_ON_PAGE(PageKsm(page), page);	/* KSM page->index unusable */
-	return vma_pgoff_address(page_to_pgoff(page), compound_nr(page), vma);
-}
-
-/*
  * Then at what user virtual address will none of the range be found in vma?
  * Assumes that vma_address() already returned a good starting address.
  */
--- a/mm/rmap.c~mm-remove-vma_address
+++ a/mm/rmap.c
@@ -775,6 +775,8 @@ static bool should_defer_flush(struct mm
 unsigned long page_address_in_vma(struct page *page, struct vm_area_struct *vma)
 {
 	struct folio *folio = page_folio(page);
+	pgoff_t pgoff;
+
 	if (folio_test_anon(folio)) {
 		struct anon_vma *page__anon_vma = folio_anon_vma(folio);
 		/*
@@ -790,7 +792,9 @@ unsigned long page_address_in_vma(struct
 		return -EFAULT;
 	}
 
-	return vma_address(page, vma);
+	/* The !page__anon_vma above handles KSM folios */
+	pgoff = folio->index + folio_page_idx(folio, page);
+	return vma_pgoff_address(pgoff, 1, vma);
 }
 
 /*
@@ -2588,7 +2592,8 @@ static void rmap_walk_anon(struct folio
 	anon_vma_interval_tree_foreach(avc, &anon_vma->rb_root,
 			pgoff_start, pgoff_end) {
 		struct vm_area_struct *vma = avc->vma;
-		unsigned long address = vma_address(&folio->page, vma);
+		unsigned long address = vma_pgoff_address(pgoff_start,
+				folio_nr_pages(folio), vma);
 
 		VM_BUG_ON_VMA(address == -EFAULT, vma);
 		cond_resched();
@@ -2649,7 +2654,8 @@ static void rmap_walk_file(struct folio
 lookup:
 	vma_interval_tree_foreach(vma, &mapping->i_mmap,
 			pgoff_start, pgoff_end) {
-		unsigned long address = vma_address(&folio->page, vma);
+		unsigned long address = vma_pgoff_address(pgoff_start,
+			       folio_nr_pages(folio), vma);
 
 		VM_BUG_ON_VMA(address == -EFAULT, vma);
 		cond_resched();
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

