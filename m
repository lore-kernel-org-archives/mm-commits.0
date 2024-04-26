Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B37D7EEF8
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104022; cv=none; b=Acn3l7Es8K8tM+wVyvPpIBy1kSn5UbRB4qqqtBWomyQf2Ixfd2liKc3ON2D2Nz960/0YvXzZsRCqX2yhhizZABTbBCYWh4kcB2fWBKm3wslyW+ddQIJw9od8JYoYener2tt8rn/7rNPDdEvmxn86rOLsrtuVt4Xy6Htri6fIwLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104022; c=relaxed/simple;
	bh=LLBZbOP1qLUd2pEcOD5h11cNW6+9sw9CiQjbHaBRBRo=;
	h=Date:To:From:Subject:Message-Id; b=k9B3ygYH/H3BWRBScXU26kUVt+GrSRkB1dD/6p4CcKJB3K6HSWCQ+Jj0gbtl/4qmUFeN3DyHfiNWrKR2xrBnPy3XTprCzy436LBmPRj59RSbpaGg3r39dt60hFLWkG7ucdZUCVylZsGxUkybwNnJdD4WTNHESwOjSrpIKomGjWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MHeZoqPd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MHeZoqPd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D3EDC113CD;
	Fri, 26 Apr 2024 04:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104022;
	bh=LLBZbOP1qLUd2pEcOD5h11cNW6+9sw9CiQjbHaBRBRo=;
	h=Date:To:From:Subject:From;
	b=MHeZoqPdQEEcvPyvuT0Q72xsvmEvsusHxcQGLFRHb5vb5JpkboF/xIQivMBGwgflT
	 UGPOiOYLZP3tvZXPooi0hD+jaSXchZ2X8oMAujJ7LH4Rt5vBsqHoWhmXKI338l5Ia+
	 1l0F74IuiN8G/t4qkzIjpLSEIvQ7BhRM+fGhrY48=
Date: Thu, 25 Apr 2024 21:00:21 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] remove-references-to-page-flags-in-documentation.patch removed from -mm tree
Message-Id: <20240426040022.1D3EDC113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: remove references to page->flags in documentation
has been removed from the -mm tree.  Its filename was
     remove-references-to-page-flags-in-documentation.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: remove references to page->flags in documentation
Date: Tue, 26 Mar 2024 17:10:31 +0000

Mostly rewording, but remove entirely the copy of page_fixed_fake_head()
in the documentation; we can refer people to the actual source if
necessary.

Link: https://lkml.kernel.org/r/20240326171045.410737-10-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/cgroup-v1/memory.rst         |    4 -
 Documentation/mm/vmemmap_dedup.rst                     |   22 ----------
 Documentation/translations/zh_CN/core-api/cachetlb.rst |    2 
 mm/migrate.c                                           |    2 
 mm/rmap.c                                              |    4 -
 5 files changed, 7 insertions(+), 27 deletions(-)

--- a/Documentation/admin-guide/cgroup-v1/memory.rst~remove-references-to-page-flags-in-documentation
+++ a/Documentation/admin-guide/cgroup-v1/memory.rst
@@ -300,14 +300,14 @@ When oom event notifier is registered, e
 
 Lock order is as follows::
 
-  Page lock (PG_locked bit of page->flags)
+  folio_lock
     mm->page_table_lock or split pte_lock
       folio_memcg_lock (memcg->move_lock)
         mapping->i_pages lock
           lruvec->lru_lock.
 
 Per-node-per-memcgroup LRU (cgroup's private LRU) is guarded by
-lruvec->lru_lock; PG_lru bit of page->flags is cleared before
+lruvec->lru_lock; the folio LRU flag is cleared before
 isolating a page from its LRU under lruvec->lru_lock.
 
 .. _cgroup-v1-memory-kernel-extension:
--- a/Documentation/mm/vmemmap_dedup.rst~remove-references-to-page-flags-in-documentation
+++ a/Documentation/mm/vmemmap_dedup.rst
@@ -180,27 +180,7 @@ this correctly. There is only **one** he
 ``struct page`` with ``PG_head`` are fake head ``struct page``.  We need an
 approach to distinguish between those two different types of ``struct page`` so
 that ``compound_head()`` can return the real head ``struct page`` when the
-parameter is the tail ``struct page`` but with ``PG_head``. The following code
-snippet describes how to distinguish between real and fake head ``struct page``.
-
-.. code-block:: c
-
-	if (test_bit(PG_head, &page->flags)) {
-		unsigned long head = READ_ONCE(page[1].compound_head);
-
-		if (head & 1) {
-			if (head == (unsigned long)page + 1)
-				/* head struct page */
-			else
-				/* tail struct page */
-		} else {
-			/* head struct page */
-		}
-	}
-
-We can safely access the field of the **page[1]** with ``PG_head`` because the
-page is a compound page composed with at least two contiguous pages.
-The implementation refers to ``page_fixed_fake_head()``.
+parameter is the tail ``struct page`` but with ``PG_head``.
 
 Device DAX
 ==========
--- a/Documentation/translations/zh_CN/core-api/cachetlb.rst~remove-references-to-page-flags-in-documentation
+++ a/Documentation/translations/zh_CN/core-api/cachetlb.rst
@@ -260,7 +260,7 @@ 问题有可能存在，因为内核已�
 	如果D-cache别名不是一个问题，这个程序可以简单地定义为该架构上
 	的nop。
 
-	在page->flags (PG_arch_1)中有一个位是“架构私有”。内核保证，
+	在folio->flags (PG_arch_1)中有一个位是“架构私有”。内核保证，
 	对于分页缓存的页面，当这样的页面第一次进入分页缓存时，它将清除
 	这个位。
 
--- a/mm/migrate.c~remove-references-to-page-flags-in-documentation
+++ a/mm/migrate.c
@@ -113,7 +113,7 @@ bool isolate_movable_page(struct page *p
 	if (!mops->isolate_page(&folio->page, mode))
 		goto out_no_isolated;
 
-	/* Driver shouldn't use PG_isolated bit of page->flags */
+	/* Driver shouldn't use the isolated flag */
 	WARN_ON_ONCE(folio_test_isolated(folio));
 	folio_set_isolated(folio);
 	folio_unlock(folio);
--- a/mm/rmap.c~remove-references-to-page-flags-in-documentation
+++ a/mm/rmap.c
@@ -23,7 +23,7 @@
  * inode->i_rwsem	(while writing or truncating, not reading or faulting)
  *   mm->mmap_lock
  *     mapping->invalidate_lock (in filemap_fault)
- *       page->flags PG_locked (lock_page)
+ *       folio_lock
  *         hugetlbfs_i_mmap_rwsem_key (in huge_pmd_share, see hugetlbfs below)
  *           vma_start_write
  *             mapping->i_mmap_rwsem
@@ -50,7 +50,7 @@
  *   hugetlb_fault_mutex (hugetlbfs specific page fault mutex)
  *     vma_lock (hugetlb specific lock for pmd_sharing)
  *       mapping->i_mmap_rwsem (also used for hugetlb pmd sharing)
- *         page->flags PG_locked (lock_page)
+ *         folio_lock
  */
 
 #include <linux/mm.h>
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

