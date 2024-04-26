Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23B427F7FC
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104045; cv=none; b=LzKswNqnkjt+Y2ohPgqEF1wmyRwt07lfd5A32NwJNYqs49RP6ad9QbTqTG6Pu1xImIzUTwT8CorpYYhRanphHqyV1xjkqGQZ33DmjSIpznnwq/0cxuUah6s5tWe6ha2J0ab6XNlQDmNrF96gosCCHt3h6NUcZoijBSwVm5tZEFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104045; c=relaxed/simple;
	bh=1HelJZW6p2gRc2XJRefG8sEBXnJ/ztvgxoDrpzDckGE=;
	h=Date:To:From:Subject:Message-Id; b=rVVvJOEq/on/0i326mwLYW28SuGG4x8+S8/R5wjSY8OjTxZ3Cw4WGi0dKiHintC05yOOCwmRBT3mNCjw7q20S0ApmtH3VhH1wVNuGn4baG6s/Vh699d0b/tMmEgQm8pMofma6A1aRqt/tSYCJqKnEiyzGQxisx0UI1h8Bk8mog8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=t2hqqvEm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="t2hqqvEm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE4A2C113CD;
	Fri, 26 Apr 2024 04:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104045;
	bh=1HelJZW6p2gRc2XJRefG8sEBXnJ/ztvgxoDrpzDckGE=;
	h=Date:To:From:Subject:From;
	b=t2hqqvEmgTTIRpgY2dElkWyzqcpiOK3qPnXVV7sUHfurLkR1m5W9j3htrK61dv8U2
	 emy2eVZZc/DbBJ+xaVWNV5C999mfiHAukrUy7WT1cpCBhwoMZuHSSXy+uF0tiJFprz
	 RHoRm239FyItxNXHm/Wk1oV/HLkkNyqY5gESGxeI=
Date: Thu, 25 Apr 2024 21:00:44 -0700
To: mm-commits@vger.kernel.org,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-convert-huge_zero_page-to-huge_zero_folio.patch removed from -mm tree
Message-Id: <20240426040044.EE4A2C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: convert huge_zero_page to huge_zero_folio
has been removed from the -mm tree.  Its filename was
     mm-convert-huge_zero_page-to-huge_zero_folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: convert huge_zero_page to huge_zero_folio
Date: Tue, 26 Mar 2024 20:28:25 +0000

With all callers of is_huge_zero_page() converted, we can now switch the
huge_zero_page itself from being a compound page to a folio.

Link: https://lkml.kernel.org/r/20240326202833.523759-6-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |   21 ++++++++-------------
 mm/huge_memory.c        |   28 ++++++++++++++--------------
 2 files changed, 22 insertions(+), 27 deletions(-)

--- a/include/linux/huge_mm.h~mm-convert-huge_zero_page-to-huge_zero_folio
+++ a/include/linux/huge_mm.h
@@ -348,17 +348,12 @@ struct page *follow_devmap_pud(struct vm
 
 vm_fault_t do_huge_pmd_numa_page(struct vm_fault *vmf);
 
-extern struct page *huge_zero_page;
+extern struct folio *huge_zero_folio;
 extern unsigned long huge_zero_pfn;
 
-static inline bool is_huge_zero_page(const struct page *page)
-{
-	return READ_ONCE(huge_zero_page) == page;
-}
-
 static inline bool is_huge_zero_folio(const struct folio *folio)
 {
-	return READ_ONCE(huge_zero_page) == &folio->page;
+	return READ_ONCE(huge_zero_folio) == folio;
 }
 
 static inline bool is_huge_zero_pmd(pmd_t pmd)
@@ -371,9 +366,14 @@ static inline bool is_huge_zero_pud(pud_
 	return false;
 }
 
-struct page *mm_get_huge_zero_page(struct mm_struct *mm);
+struct folio *mm_get_huge_zero_folio(struct mm_struct *mm);
 void mm_put_huge_zero_page(struct mm_struct *mm);
 
+static inline struct page *mm_get_huge_zero_page(struct mm_struct *mm)
+{
+	return &mm_get_huge_zero_folio(mm)->page;
+}
+
 #define mk_huge_pmd(page, prot) pmd_mkhuge(mk_pmd(page, prot))
 
 static inline bool thp_migration_supported(void)
@@ -485,11 +485,6 @@ static inline vm_fault_t do_huge_pmd_num
 	return 0;
 }
 
-static inline bool is_huge_zero_page(const struct page *page)
-{
-	return false;
-}
-
 static inline bool is_huge_zero_folio(const struct folio *folio)
 {
 	return false;
--- a/mm/huge_memory.c~mm-convert-huge_zero_page-to-huge_zero_folio
+++ a/mm/huge_memory.c
@@ -74,7 +74,7 @@ static unsigned long deferred_split_scan
 					 struct shrink_control *sc);
 
 static atomic_t huge_zero_refcount;
-struct page *huge_zero_page __read_mostly;
+struct folio *huge_zero_folio __read_mostly;
 unsigned long huge_zero_pfn __read_mostly = ~0UL;
 unsigned long huge_anon_orders_always __read_mostly;
 unsigned long huge_anon_orders_madvise __read_mostly;
@@ -192,24 +192,24 @@ unsigned long __thp_vma_allowable_orders
 
 static bool get_huge_zero_page(void)
 {
-	struct page *zero_page;
+	struct folio *zero_folio;
 retry:
 	if (likely(atomic_inc_not_zero(&huge_zero_refcount)))
 		return true;
 
-	zero_page = alloc_pages((GFP_TRANSHUGE | __GFP_ZERO) & ~__GFP_MOVABLE,
+	zero_folio = folio_alloc((GFP_TRANSHUGE | __GFP_ZERO) & ~__GFP_MOVABLE,
 			HPAGE_PMD_ORDER);
-	if (!zero_page) {
+	if (!zero_folio) {
 		count_vm_event(THP_ZERO_PAGE_ALLOC_FAILED);
 		return false;
 	}
 	preempt_disable();
-	if (cmpxchg(&huge_zero_page, NULL, zero_page)) {
+	if (cmpxchg(&huge_zero_folio, NULL, zero_folio)) {
 		preempt_enable();
-		__free_pages(zero_page, compound_order(zero_page));
+		folio_put(zero_folio);
 		goto retry;
 	}
-	WRITE_ONCE(huge_zero_pfn, page_to_pfn(zero_page));
+	WRITE_ONCE(huge_zero_pfn, folio_pfn(zero_folio));
 
 	/* We take additional reference here. It will be put back by shrinker */
 	atomic_set(&huge_zero_refcount, 2);
@@ -227,10 +227,10 @@ static void put_huge_zero_page(void)
 	BUG_ON(atomic_dec_and_test(&huge_zero_refcount));
 }
 
-struct page *mm_get_huge_zero_page(struct mm_struct *mm)
+struct folio *mm_get_huge_zero_folio(struct mm_struct *mm)
 {
 	if (test_bit(MMF_HUGE_ZERO_PAGE, &mm->flags))
-		return READ_ONCE(huge_zero_page);
+		return READ_ONCE(huge_zero_folio);
 
 	if (!get_huge_zero_page())
 		return NULL;
@@ -238,7 +238,7 @@ struct page *mm_get_huge_zero_page(struc
 	if (test_and_set_bit(MMF_HUGE_ZERO_PAGE, &mm->flags))
 		put_huge_zero_page();
 
-	return READ_ONCE(huge_zero_page);
+	return READ_ONCE(huge_zero_folio);
 }
 
 void mm_put_huge_zero_page(struct mm_struct *mm)
@@ -258,10 +258,10 @@ static unsigned long shrink_huge_zero_pa
 				       struct shrink_control *sc)
 {
 	if (atomic_cmpxchg(&huge_zero_refcount, 1, 0) == 1) {
-		struct page *zero_page = xchg(&huge_zero_page, NULL);
-		BUG_ON(zero_page == NULL);
+		struct folio *zero_folio = xchg(&huge_zero_folio, NULL);
+		BUG_ON(zero_folio == NULL);
 		WRITE_ONCE(huge_zero_pfn, ~0UL);
-		__free_pages(zero_page, compound_order(zero_page));
+		folio_put(zero_folio);
 		return HPAGE_PMD_NR;
 	}
 
@@ -1340,7 +1340,7 @@ int copy_huge_pmd(struct mm_struct *dst_
 		 * since we already have a zero page to copy. It just takes a
 		 * reference.
 		 */
-		mm_get_huge_zero_page(dst_mm);
+		mm_get_huge_zero_folio(dst_mm);
 		goto out_zero_page;
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

