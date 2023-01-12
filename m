Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42F94C61DB3
	for <mm-commits@archiver.kernel.org>; Thu, 12 Jan 2023 22:35:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232713AbjALWfV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 12 Jan 2023 17:35:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232919AbjALWfN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 12 Jan 2023 17:35:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B129B2EF
        for <mm-commits@vger.kernel.org>; Thu, 12 Jan 2023 14:35:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 69C82B82035
        for <mm-commits@vger.kernel.org>; Thu, 12 Jan 2023 22:35:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F597C433EF;
        Thu, 12 Jan 2023 22:35:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673562910;
        bh=UlD5S0wOJcO5KzfvArUPzytZgXF3yfCAemc9uFGBRYw=;
        h=Date:To:From:Subject:From;
        b=seUzSK4qbzRTI6ZTk5ZYvJ0cthFcxLn41NWqsNwXWW5bZrpvUsY2MDQLnEF4W0L6Z
         XNrI6MQx6u5zGxfDXuE+Dl/JzzCDG6rXE3LOnI9dg8dxyxjSLEABFzI4C8iebgVauH
         3SyUZpMmrxiXqIviK17XeAKn6oO9TWyFthB81BiE=
Date:   Thu, 12 Jan 2023 14:35:09 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        wangkefeng.wang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-convert-wp_page_copy-to-use-folios.patch added to mm-unstable branch
Message-Id: <20230112223510.0F597C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memory: convert wp_page_copy() to use folios
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-convert-wp_page_copy-to-use-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-convert-wp_page_copy-to-use-folios.patch

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
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: memory: convert wp_page_copy() to use folios
Date: Thu, 12 Jan 2023 16:30:04 +0800

The old_page/new_page are converted to old_folio/new_folio in
wp_page_copy(), then replaced related page functions to folio functions.

Link: https://lkml.kernel.org/r/20230112083006.163393-6-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   47 +++++++++++++++++++++++++----------------------
 1 file changed, 25 insertions(+), 22 deletions(-)

--- a/mm/memory.c~mm-memory-convert-wp_page_copy-to-use-folios
+++ a/mm/memory.c
@@ -3044,7 +3044,9 @@ static vm_fault_t wp_page_copy(struct vm
 	struct vm_area_struct *vma = vmf->vma;
 	struct mm_struct *mm = vma->vm_mm;
 	struct page *old_page = vmf->page;
+	struct folio *old_folio = page_folio(old_page);
 	struct page *new_page = NULL;
+	struct folio *new_folio = NULL;
 	pte_t entry;
 	int page_copied = 0;
 	struct mmu_notifier_range range;
@@ -3060,12 +3062,13 @@ static vm_fault_t wp_page_copy(struct vm
 							      vmf->address);
 		if (!new_page)
 			goto oom;
+		new_folio = page_folio(new_page);
 	} else {
-		new_page = alloc_page_vma(GFP_HIGHUSER_MOVABLE, vma,
-				vmf->address);
-		if (!new_page)
+		new_folio = vma_alloc_folio(GFP_HIGHUSER_MOVABLE, 0, vma,
+					    vmf->address, false);
+		if (!new_folio)
 			goto oom;
-
+		new_page = &new_folio->page;
 		ret = __wp_page_copy_user(new_page, old_page, vmf);
 		if (ret) {
 			/*
@@ -3075,9 +3078,9 @@ static vm_fault_t wp_page_copy(struct vm
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
@@ -3085,11 +3088,11 @@ static vm_fault_t wp_page_copy(struct vm
 		kmsan_copy_page_meta(new_page, old_page);
 	}
 
-	if (mem_cgroup_charge(page_folio(new_page), mm, GFP_KERNEL))
+	if (mem_cgroup_charge(new_folio, mm, GFP_KERNEL))
 		goto oom_free_new;
-	cgroup_throttle_swaprate(new_page, GFP_KERNEL);
+	folio_throttle_swaprate(new_folio, GFP_KERNEL);
 
-	__SetPageUptodate(new_page);
+	__folio_mark_uptodate(new_folio);
 
 	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm,
 				vmf->address & PAGE_MASK,
@@ -3101,8 +3104,8 @@ static vm_fault_t wp_page_copy(struct vm
 	 */
 	vmf->pte = pte_offset_map_lock(mm, vmf->pmd, vmf->address, &vmf->ptl);
 	if (likely(pte_same(*vmf->pte, vmf->orig_pte))) {
-		if (old_page) {
-			if (!PageAnon(old_page)) {
+		if (old_folio) {
+			if (!folio_test_anon(old_folio)) {
 				dec_mm_counter(mm, mm_counter_file(old_page));
 				inc_mm_counter(mm, MM_ANONPAGES);
 			}
@@ -3130,7 +3133,7 @@ static vm_fault_t wp_page_copy(struct vm
 		 */
 		ptep_clear_flush_notify(vma, vmf->address, vmf->pte);
 		page_add_new_anon_rmap(new_page, vma, vmf->address);
-		lru_cache_add_inactive_or_unevictable(new_page, vma);
+		folio_add_lru_vma(new_folio, vma);
 		/*
 		 * We call the notify macro here because, when using secondary
 		 * mmu page tables (such as kvm shadow page tables), we want the
@@ -3139,7 +3142,7 @@ static vm_fault_t wp_page_copy(struct vm
 		BUG_ON(unshare && pte_write(entry));
 		set_pte_at_notify(mm, vmf->address, vmf->pte, entry);
 		update_mmu_cache(vma, vmf->address, vmf->pte);
-		if (old_page) {
+		if (old_folio) {
 			/*
 			 * Only after switching the pte to the new page may
 			 * we remove the mapcount here. Otherwise another
@@ -3166,14 +3169,14 @@ static vm_fault_t wp_page_copy(struct vm
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
@@ -3181,19 +3184,19 @@ static vm_fault_t wp_page_copy(struct vm
 	 * the above ptep_clear_flush_notify() did already call it.
 	 */
 	mmu_notifier_invalidate_range_only_end(&range);
-	if (old_page) {
+	if (old_folio) {
 		if (page_copied)
 			free_swap_cache(old_page);
-		put_page(old_page);
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

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-hwposion-support-recovery-from-ksm_might_need_to_copy.patch
mm-hwposion-support-recovery-from-ksm_might_need_to_copy-v3.patch
mm-huge_memory-convert-madvise_free_huge_pmd-to-use-a-folio.patch
mm-swap-convert-mark_page_lazyfree-to-folio_mark_lazyfree.patch
mm-huge_memory-convert-split_huge_pages_all-to-use-a-folio.patch
mm-page_idle-convert-page-idle-to-use-a-folio.patch
mm-damon-introduce-damon_get_folio.patch
mm-damon-convert-damon_ptep-pmdp_mkold-to-use-a-folio.patch
mm-damon-paddr-convert-damon_pa_-to-use-a-folio.patch
mm-damon-vaddr-convert-damon_young_pmd_entry-to-use-a-folio.patch
mm-damon-remove-unneeded-damon_get_page.patch
mm-damon-vaddr-convert-hugetlb-related-functions-to-use-a-folio.patch
mm-madvise-use-vm_normal_folio-in-madvise_free_pte_range.patch
mm-huge_memory-make-__do_huge_pmd_anonymous_page-to-take-a-folio.patch
mm-memory-convert-do_anonymous_page-to-use-a-folio.patch
mm-memory-convert-do_cow_fault-to-use-folios.patch
mm-memory-convert-page_copy_prealloc-to-use-a-folio.patch
mm-memory-convert-wp_page_copy-to-use-folios.patch
mm-memory-use-folio_throttle_swaprate-in-do_swap_page.patch
mm-swap-remove-unneeded-cgroup_throttle_swaprate.patch

