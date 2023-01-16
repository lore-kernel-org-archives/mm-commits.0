Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D655C677F1
	for <mm-commits@archiver.kernel.org>; Mon, 16 Jan 2023 20:05:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232788AbjAPUFy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 16 Jan 2023 15:05:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230092AbjAPUFu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 16 Jan 2023 15:05:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C16E23311
        for <mm-commits@vger.kernel.org>; Mon, 16 Jan 2023 12:05:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3CA3CB810A4
        for <mm-commits@vger.kernel.org>; Mon, 16 Jan 2023 20:05:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8A88C433D2;
        Mon, 16 Jan 2023 20:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673899546;
        bh=dafVuIUZUEBM9OA9JIk7ZgS6ALNc1SdYoSOHHJ84tx8=;
        h=Date:To:From:Subject:From;
        b=Zzoq7UdxbXNcodQxiZOk6UP24nCxk7Dd5PIwNNqgs0GoLQBkyxinYKpeA9o8EZygA
         vT4ryEKPczNV5CYe0ZiFFsHQ/nkYwFaujsZe9tOE+QoG9VY0jCOQl3WfuHl9BiFW3+
         x98emM+ddAtHIVUmcwdMEcI/QlnJoF5cDsNGNgL8=
Date:   Mon, 16 Jan 2023 12:05:45 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-convert-wp_page_copy-to-use-folios.patch added to mm-unstable branch
Message-Id: <20230116200545.D8A88C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: convert wp_page_copy() to use folios
has been added to the -mm mm-unstable branch.  Its filename is
     mm-convert-wp_page_copy-to-use-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-convert-wp_page_copy-to-use-folios.patch

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: convert wp_page_copy() to use folios
Date: Mon, 16 Jan 2023 19:18:11 +0000

Use new_folio instead of new_page throughout, because we allocated it
and know it's an order-0 folio.  Most old_page uses become old_folio,
but use vmf->page where we need the precise page.

Link: https://lkml.kernel.org/r/20230116191813.2145215-4-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/memory.c~mm-convert-wp_page_copy-to-use-folios
+++ a/mm/memory.c
@@ -3043,8 +3043,8 @@ static vm_fault_t wp_page_copy(struct vm
 	const bool unshare = vmf->flags & FAULT_FLAG_UNSHARE;
 	struct vm_area_struct *vma = vmf->vma;
 	struct mm_struct *mm = vma->vm_mm;
-	struct page *old_page = vmf->page;
-	struct page *new_page = NULL;
+	struct folio *old_folio = NULL;
+	struct folio *new_folio = NULL;
 	pte_t entry;
 	int page_copied = 0;
 	struct mmu_notifier_range range;
@@ -3052,23 +3052,22 @@ static vm_fault_t wp_page_copy(struct vm
 
 	delayacct_wpcopy_start();
 
+	if (vmf->page)
+		old_folio = page_folio(vmf->page);
 	if (unlikely(anon_vma_prepare(vma)))
 		goto oom;
 
 	if (is_zero_pfn(pte_pfn(vmf->orig_pte))) {
-		struct folio *new_folio;
-
 		new_folio = vma_alloc_zeroed_movable_folio(vma, vmf->address);
 		if (!new_folio)
 			goto oom;
-		new_page = &new_folio->page;
 	} else {
-		new_page = alloc_page_vma(GFP_HIGHUSER_MOVABLE, vma,
-				vmf->address);
-		if (!new_page)
+		new_folio = vma_alloc_folio(GFP_HIGHUSER_MOVABLE, 0, vma,
+				vmf->address, false);
+		if (!new_folio)
 			goto oom;
 
-		ret = __wp_page_copy_user(new_page, old_page, vmf);
+		ret = __wp_page_copy_user(&new_folio->page, vmf->page, vmf);
 		if (ret) {
 			/*
 			 * COW failed, if the fault was solved by other,
@@ -3077,21 +3076,21 @@ static vm_fault_t wp_page_copy(struct vm
 			 * from the second attempt.
 			 * The -EHWPOISON case will not be retried.
 			 */
-			put_page(new_page);
-			if (old_page)
-				put_page(old_page);
+			folio_put(new_folio);
+			if (old_folio)
+				folio_put(old_folio);
 
 			delayacct_wpcopy_end();
 			return ret == -EHWPOISON ? VM_FAULT_HWPOISON : 0;
 		}
-		kmsan_copy_page_meta(new_page, old_page);
+		kmsan_copy_page_meta(&new_folio->page, vmf->page);
 	}
 
-	if (mem_cgroup_charge(page_folio(new_page), mm, GFP_KERNEL))
+	if (mem_cgroup_charge(new_folio, mm, GFP_KERNEL))
 		goto oom_free_new;
-	cgroup_throttle_swaprate(new_page, GFP_KERNEL);
+	cgroup_throttle_swaprate(&new_folio->page, GFP_KERNEL);
 
-	__SetPageUptodate(new_page);
+	__folio_mark_uptodate(new_folio);
 
 	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm,
 				vmf->address & PAGE_MASK,
@@ -3103,16 +3102,16 @@ static vm_fault_t wp_page_copy(struct vm
 	 */
 	vmf->pte = pte_offset_map_lock(mm, vmf->pmd, vmf->address, &vmf->ptl);
 	if (likely(pte_same(*vmf->pte, vmf->orig_pte))) {
-		if (old_page) {
-			if (!PageAnon(old_page)) {
-				dec_mm_counter(mm, mm_counter_file(old_page));
+		if (old_folio) {
+			if (!folio_test_anon(old_folio)) {
+				dec_mm_counter(mm, mm_counter_file(&old_folio->page));
 				inc_mm_counter(mm, MM_ANONPAGES);
 			}
 		} else {
 			inc_mm_counter(mm, MM_ANONPAGES);
 		}
 		flush_cache_page(vma, vmf->address, pte_pfn(vmf->orig_pte));
-		entry = mk_pte(new_page, vma->vm_page_prot);
+		entry = mk_pte(&new_folio->page, vma->vm_page_prot);
 		entry = pte_sw_mkyoung(entry);
 		if (unlikely(unshare)) {
 			if (pte_soft_dirty(vmf->orig_pte))
@@ -3131,8 +3130,8 @@ static vm_fault_t wp_page_copy(struct vm
 		 * some TLBs while the old PTE remains in others.
 		 */
 		ptep_clear_flush_notify(vma, vmf->address, vmf->pte);
-		page_add_new_anon_rmap(new_page, vma, vmf->address);
-		lru_cache_add_inactive_or_unevictable(new_page, vma);
+		folio_add_new_anon_rmap(new_folio, vma, vmf->address);
+		folio_add_lru_vma(new_folio, vma);
 		/*
 		 * We call the notify macro here because, when using secondary
 		 * mmu page tables (such as kvm shadow page tables), we want the
@@ -3141,7 +3140,7 @@ static vm_fault_t wp_page_copy(struct vm
 		BUG_ON(unshare && pte_write(entry));
 		set_pte_at_notify(mm, vmf->address, vmf->pte, entry);
 		update_mmu_cache(vma, vmf->address, vmf->pte);
-		if (old_page) {
+		if (old_folio) {
 			/*
 			 * Only after switching the pte to the new page may
 			 * we remove the mapcount here. Otherwise another
@@ -3164,18 +3163,18 @@ static vm_fault_t wp_page_copy(struct vm
 			 * mapcount is visible. So transitively, TLBs to
 			 * old page will be flushed before it can be reused.
 			 */
-			page_remove_rmap(old_page, vma, false);
+			page_remove_rmap(vmf->page, vma, false);
 		}
 
 		/* Free the old page.. */
-		new_page = old_page;
+		new_folio = old_folio;
 		page_copied = 1;
 	} else {
 		update_mmu_tlb(vma, vmf->address, vmf->pte);
 	}
 
-	if (new_page)
-		put_page(new_page);
+	if (new_folio)
+		folio_put(new_folio);
 
 	pte_unmap_unlock(vmf->pte, vmf->ptl);
 	/*
@@ -3183,19 +3182,19 @@ static vm_fault_t wp_page_copy(struct vm
 	 * the above ptep_clear_flush_notify() did already call it.
 	 */
 	mmu_notifier_invalidate_range_only_end(&range);
-	if (old_page) {
+	if (old_folio) {
 		if (page_copied)
-			free_swap_cache(old_page);
-		put_page(old_page);
+			free_swap_cache(&old_folio->page);
+		folio_put(old_folio);
 	}
 
 	delayacct_wpcopy_end();
 	return 0;
 oom_free_new:
-	put_page(new_page);
+	folio_put(new_folio);
 oom:
-	if (old_page)
-		put_page(old_page);
+	if (old_folio)
+		folio_put(old_folio);
 
 	delayacct_wpcopy_end();
 	return VM_FAULT_OOM;
_

Patches currently in -mm which might be from willy@infradead.org are

buffer-add-b_folio-as-an-alias-of-b_page.patch
buffer-replace-obvious-uses-of-b_page-with-b_folio.patch
buffer-use-b_folio-in-touch_buffer.patch
buffer-use-b_folio-in-end_buffer_async_read.patch
buffer-use-b_folio-in-end_buffer_async_write.patch
page_io-remove-buffer_head-include.patch
buffer-use-b_folio-in-mark_buffer_dirty.patch
gfs2-replace-obvious-uses-of-b_page-with-b_folio.patch
jbd2-replace-obvious-uses-of-b_page-with-b_folio.patch
nilfs2-replace-obvious-uses-of-b_page-with-b_folio.patch
reiserfs-replace-obvious-uses-of-b_page-with-b_folio.patch
mpage-use-b_folio-in-do_mpage_readpage.patch
mm-memcg-add-folio_memcg_check.patch
mm-remove-folio_pincount_ptr-and-head_compound_pincount.patch
mm-convert-head_subpages_mapcount-into-folio_nr_pages_mapped.patch
doc-clarify-refcount-section-by-referring-to-folios-pages.patch
mm-convert-total_compound_mapcount-to-folio_total_mapcount.patch
mm-convert-page_remove_rmap-to-use-a-folio-internally.patch
mm-convert-page_add_anon_rmap-to-use-a-folio-internally.patch
mm-convert-page_add_file_rmap-to-use-a-folio-internally.patch
mm-add-folio_add_new_anon_rmap.patch
mm-add-folio_add_new_anon_rmap-fix-2.patch
page_alloc-use-folio-fields-directly.patch
mm-use-a-folio-in-hugepage_add_anon_rmap-and-hugepage_add_new_anon_rmap.patch
mm-use-entire_mapcount-in-__page_dup_rmap.patch
mm-debug-remove-call-to-head_compound_mapcount.patch
hugetlb-remove-uses-of-folio_mapcount_ptr.patch
mm-convert-page_mapcount-to-use-folio_entire_mapcount.patch
mm-remove-head_compound_mapcount-and-_ptr-functions.patch
mm-reimplement-compound_order.patch
mm-reimplement-compound_nr.patch
mm-reimplement-compound_nr-fix.patch
mm-convert-set_compound_page_dtor-and-set_compound_order-to-folios.patch
mm-convert-is_transparent_hugepage-to-use-a-folio.patch
mm-convert-destroy_large_folio-to-use-folio_dtor.patch
hugetlb-remove-uses-of-compound_dtor-and-compound_nr.patch
mm-remove-first-tail-page-members-from-struct-page.patch
doc-correct-struct-folio-kernel-doc.patch
mm-move-page-deferred_list-to-folio-_deferred_list.patch
mm-huge_memory-remove-page_deferred_list.patch
mm-huge_memory-convert-get_deferred_split_queue-to-take-a-folio.patch
mm-convert-deferred_split_huge_page-to-deferred_split_folio.patch
shmem-convert-shmem_write_end-to-use-a-folio.patch
mm-add-vma_alloc_zeroed_movable_folio.patch
mm-convert-do_anonymous_page-to-use-a-folio.patch
mm-convert-wp_page_copy-to-use-folios.patch
mm-use-a-folio-in-copy_pte_range.patch
mm-use-a-folio-in-copy_present_pte.patch
mm-fs-convert-inode_attach_wb-to-take-a-folio.patch
mm-convert-mem_cgroup_css_from_page-to-mem_cgroup_css_from_folio.patch
mm-remove-page_evictable.patch
mm-remove-mlock_vma_page.patch
mm-remove-munlock_vma_page.patch
mm-clean-up-mlock_page-munlock_page-references-in-comments.patch

