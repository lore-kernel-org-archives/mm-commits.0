Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 227177F47B
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:00:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104048; cv=none; b=VnVd75YgTDGaoaTAJd7EeevwruO473bqV92pJ6es8NzOYBlqHtq1V5g89tfzTGxCESDHBOTvxXDLKIRkwrSp/YcP+xwAaJc7PzwGXwTGdzO3h1QC1Hu/qBzHGXebh/IeKvbtx0dbjNMzAiodLgwO0OUY5Xcp8GWsrFuCvZlKKYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104048; c=relaxed/simple;
	bh=4M5okWKNpYZraqeTaUaXFXMKi909kxSFtan2I4CMYEM=;
	h=Date:To:From:Subject:Message-Id; b=rNvonHt8Gl+AvmJQT4erXUaKfVE+wTtAJquB3ndp4T2sLK7mrXzrLYga0wZKnEDgrPl0mh6zVVWzX4l78OHQgWjOM7WQ8o1KRMQVCrMCysfdrjd2kZiMb4RFr63W7RNRSWyl3sYCEeIqEzvENOlLHo/6HnLgNSqdkTaupqxxtLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=h31zKW2y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="h31zKW2y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4E17C116B1;
	Fri, 26 Apr 2024 04:00:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104048;
	bh=4M5okWKNpYZraqeTaUaXFXMKi909kxSFtan2I4CMYEM=;
	h=Date:To:From:Subject:From;
	b=h31zKW2y7woDtW3nEHP+goE5l+Pb7ylVjz8U/ESDDjvYfngzHKaqOdbbNaOuvOWzY
	 WHqCjsIprZg1AOrUAo61YnbcWH0N7yT8hJoBPTxM5fe4Ec8eqTiQHxwSrGwkSjIAbv
	 KHM+FZUp8rqYswLafoFbhi2YfJ7lhnEXGdo2pRgI=
Date: Thu, 25 Apr 2024 21:00:47 -0700
To: mm-commits@vger.kernel.org,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-rename-mm_put_huge_zero_page-to-mm_put_huge_zero_folio.patch removed from -mm tree
Message-Id: <20240426040047.E4E17C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: rename mm_put_huge_zero_page to mm_put_huge_zero_folio
has been removed from the -mm tree.  Its filename was
     mm-rename-mm_put_huge_zero_page-to-mm_put_huge_zero_folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: rename mm_put_huge_zero_page to mm_put_huge_zero_folio
Date: Tue, 26 Mar 2024 20:28:28 +0000

Also remove mm_get_huge_zero_page() now it has no users.

Link: https://lkml.kernel.org/r/20240326202833.523759-9-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |    9 ++-------
 kernel/fork.c           |    2 +-
 mm/huge_memory.c        |    2 +-
 3 files changed, 4 insertions(+), 9 deletions(-)

--- a/include/linux/huge_mm.h~mm-rename-mm_put_huge_zero_page-to-mm_put_huge_zero_folio
+++ a/include/linux/huge_mm.h
@@ -367,12 +367,7 @@ static inline bool is_huge_zero_pud(pud_
 }
 
 struct folio *mm_get_huge_zero_folio(struct mm_struct *mm);
-void mm_put_huge_zero_page(struct mm_struct *mm);
-
-static inline struct page *mm_get_huge_zero_page(struct mm_struct *mm)
-{
-	return &mm_get_huge_zero_folio(mm)->page;
-}
+void mm_put_huge_zero_folio(struct mm_struct *mm);
 
 #define mk_huge_pmd(page, prot) pmd_mkhuge(mk_pmd(page, prot))
 
@@ -500,7 +495,7 @@ static inline bool is_huge_zero_pud(pud_
 	return false;
 }
 
-static inline void mm_put_huge_zero_page(struct mm_struct *mm)
+static inline void mm_put_huge_zero_folio(struct mm_struct *mm)
 {
 	return;
 }
--- a/kernel/fork.c~mm-rename-mm_put_huge_zero_page-to-mm_put_huge_zero_folio
+++ a/kernel/fork.c
@@ -1344,7 +1344,7 @@ static inline void __mmput(struct mm_str
 	ksm_exit(mm);
 	khugepaged_exit(mm); /* must run before exit_mmap */
 	exit_mmap(mm);
-	mm_put_huge_zero_page(mm);
+	mm_put_huge_zero_folio(mm);
 	set_mm_exe_file(mm, NULL);
 	if (!list_empty(&mm->mmlist)) {
 		spin_lock(&mmlist_lock);
--- a/mm/huge_memory.c~mm-rename-mm_put_huge_zero_page-to-mm_put_huge_zero_folio
+++ a/mm/huge_memory.c
@@ -241,7 +241,7 @@ struct folio *mm_get_huge_zero_folio(str
 	return READ_ONCE(huge_zero_folio);
 }
 
-void mm_put_huge_zero_page(struct mm_struct *mm)
+void mm_put_huge_zero_folio(struct mm_struct *mm)
 {
 	if (test_bit(MMF_HUGE_ZERO_PAGE, &mm->flags))
 		put_huge_zero_page();
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

