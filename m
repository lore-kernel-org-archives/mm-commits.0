Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 053F7C54EBE
	for <mm-commits@archiver.kernel.org>; Thu, 12 Jan 2023 22:35:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230230AbjALWfI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 12 Jan 2023 17:35:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232919AbjALWfI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 12 Jan 2023 17:35:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B9852EF
        for <mm-commits@vger.kernel.org>; Thu, 12 Jan 2023 14:35:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7959DB8202F
        for <mm-commits@vger.kernel.org>; Thu, 12 Jan 2023 22:35:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F606C433F0;
        Thu, 12 Jan 2023 22:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673562902;
        bh=5gf0JgUgK8QD87VrvHJBT1+ARR0H0UdCCrjd5KW4As0=;
        h=Date:To:From:Subject:From;
        b=s9lo11rvVSZenp/pM44pbeU6WUkeKJnP7wsG6rN+ihkKTLTbCvhmYbnC3SEbn/a0U
         63kxnr5pHIRKVHmueA3gfZ9rhptnOxlWAp2np7Lzu/hRoO9qKaGrFy+Do5bh8CAJkD
         /tniKMxcQel9VvVAVXBJkqCfTvULFuOmTunJciGs=
Date:   Thu, 12 Jan 2023 14:35:01 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        wangkefeng.wang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-make-__do_huge_pmd_anonymous_page-to-take-a-folio.patch added to mm-unstable branch
Message-Id: <20230112223502.0F606C433F0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: huge_memory: make __do_huge_pmd_anonymous_page() take a folio
has been added to the -mm mm-unstable branch.  Its filename is
     mm-huge_memory-make-__do_huge_pmd_anonymous_page-to-take-a-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-make-__do_huge_pmd_anonymous_page-to-take-a-folio.patch

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
Subject: mm: huge_memory: make __do_huge_pmd_anonymous_page() take a folio
Date: Thu, 12 Jan 2023 16:30:00 +0800

Patch series "mm: remove cgroup_throttle_swaprate() completely".

Convert all the caller functions of cgroup_throttle_swaprate() to use
folios, and use folio_throttle_swaprate(), which allows us to remove
cgroup_throttle_swaprate() completely.


This patch (of 7):

Make __do_huge_pmd_anonymous_page() take a folio and convert related
functions to use folios.

Link: https://lkml.kernel.org/r/20230112083006.163393-1-wangkefeng.wang@huawei.com
Link: https://lkml.kernel.org/r/20230112083006.163393-2-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-make-__do_huge_pmd_anonymous_page-to-take-a-folio
+++ a/mm/huge_memory.c
@@ -652,22 +652,23 @@ unsigned long thp_get_unmapped_area(stru
 EXPORT_SYMBOL_GPL(thp_get_unmapped_area);
 
 static vm_fault_t __do_huge_pmd_anonymous_page(struct vm_fault *vmf,
-			struct page *page, gfp_t gfp)
+			struct folio *folio, gfp_t gfp)
 {
 	struct vm_area_struct *vma = vmf->vma;
+	struct page *page = &folio->page;
 	pgtable_t pgtable;
 	unsigned long haddr = vmf->address & HPAGE_PMD_MASK;
 	vm_fault_t ret = 0;
 
-	VM_BUG_ON_PAGE(!PageCompound(page), page);
+	VM_BUG_ON_FOLIO(!folio_test_large(folio), folio);
 
-	if (mem_cgroup_charge(page_folio(page), vma->vm_mm, gfp)) {
-		put_page(page);
+	if (mem_cgroup_charge(folio, vma->vm_mm, gfp)) {
+		folio_put(folio);
 		count_vm_event(THP_FAULT_FALLBACK);
 		count_vm_event(THP_FAULT_FALLBACK_CHARGE);
 		return VM_FAULT_FALLBACK;
 	}
-	cgroup_throttle_swaprate(page, gfp);
+	folio_throttle_swaprate(folio, gfp);
 
 	pgtable = pte_alloc_one(vma->vm_mm);
 	if (unlikely(!pgtable)) {
@@ -677,11 +678,11 @@ static vm_fault_t __do_huge_pmd_anonymou
 
 	clear_huge_page(page, vmf->address, HPAGE_PMD_NR);
 	/*
-	 * The memory barrier inside __SetPageUptodate makes sure that
+	 * The memory barrier inside __folio_mark_uptodate makes sure that
 	 * clear_huge_page writes become visible before the set_pmd_at()
 	 * write.
 	 */
-	__SetPageUptodate(page);
+	__folio_mark_uptodate(folio);
 
 	vmf->ptl = pmd_lock(vma->vm_mm, vmf->pmd);
 	if (unlikely(!pmd_none(*vmf->pmd))) {
@@ -696,7 +697,7 @@ static vm_fault_t __do_huge_pmd_anonymou
 		/* Deliver the page fault to userland */
 		if (userfaultfd_missing(vma)) {
 			spin_unlock(vmf->ptl);
-			put_page(page);
+			folio_put(folio);
 			pte_free(vma->vm_mm, pgtable);
 			ret = handle_userfault(vmf, VM_UFFD_MISSING);
 			VM_BUG_ON(ret & VM_FAULT_FALLBACK);
@@ -706,7 +707,7 @@ static vm_fault_t __do_huge_pmd_anonymou
 		entry = mk_huge_pmd(page, vma->vm_page_prot);
 		entry = maybe_pmd_mkwrite(pmd_mkdirty(entry), vma);
 		page_add_new_anon_rmap(page, vma, haddr);
-		lru_cache_add_inactive_or_unevictable(page, vma);
+		folio_add_lru_vma(folio, vma);
 		pgtable_trans_huge_deposit(vma->vm_mm, vmf->pmd, pgtable);
 		set_pmd_at(vma->vm_mm, haddr, vmf->pmd, entry);
 		update_mmu_cache_pmd(vma, vmf->address, vmf->pmd);
@@ -723,7 +724,7 @@ unlock_release:
 release:
 	if (pgtable)
 		pte_free(vma->vm_mm, pgtable);
-	put_page(page);
+	folio_put(folio);
 	return ret;
 
 }
@@ -836,7 +837,7 @@ vm_fault_t do_huge_pmd_anonymous_page(st
 		count_vm_event(THP_FAULT_FALLBACK);
 		return VM_FAULT_FALLBACK;
 	}
-	return __do_huge_pmd_anonymous_page(vmf, &folio->page, gfp);
+	return __do_huge_pmd_anonymous_page(vmf, folio, gfp);
 }
 
 static void insert_pfn_pmd(struct vm_area_struct *vma, unsigned long addr,
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

