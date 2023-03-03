Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC62FC678D4
	for <mm-commits@archiver.kernel.org>; Fri,  3 Mar 2023 02:04:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbjCCCEK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Mar 2023 21:04:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjCCCEJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 2 Mar 2023 21:04:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DEC8166D1
        for <mm-commits@vger.kernel.org>; Thu,  2 Mar 2023 18:04:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C30DA615C7
        for <mm-commits@vger.kernel.org>; Fri,  3 Mar 2023 02:04:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2395EC433EF;
        Fri,  3 Mar 2023 02:04:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677809047;
        bh=hD5gf8ER2gQ+5Ua3PuZRinxk5OfRMsvmv3BGH2G3vMI=;
        h=Date:To:From:Subject:From;
        b=MgjmGfwMN7kEjSMT1tFLFCSGaspIcAUhc/RAmGhszy1GPDEZ0Xz/qBrqzH8d4TCoE
         Jxnzh1Q6eafBuZfSpuYdV9IH8RHxppTzwbD0Lp0xMFKVtYv8Srv9v8ebC94T9oHaPF
         Q7g1fyYttQjALHDDYKhtBDWNa+WadD1YXobEkoWU=
Date:   Thu, 02 Mar 2023 18:04:06 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        wangkefeng.wang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-convert-__do_huge_pmd_anonymous_page-to-use-a-folio.patch added to mm-unstable branch
Message-Id: <20230303020407.2395EC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: huge_memory: convert __do_huge_pmd_anonymous_page() to use a folio
has been added to the -mm mm-unstable branch.  Its filename is
     mm-huge_memory-convert-__do_huge_pmd_anonymous_page-to-use-a-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-convert-__do_huge_pmd_anonymous_page-to-use-a-folio.patch

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
Subject: mm: huge_memory: convert __do_huge_pmd_anonymous_page() to use a folio
Date: Thu, 2 Mar 2023 19:58:29 +0800

Patch series "mm: remove cgroup_throttle_swaprate() completely", v2.

Convert all the caller functions of cgroup_throttle_swaprate() to use
folios, and use folio_throttle_swaprate(), which allows us to remove
cgroup_throttle_swaprate() completely.


This patch (of 7):

Convert from page to folio within __do_huge_pmd_anonymous_page(), as we
need the precise page which is to be stored at this PTE in the folio, the
function still keep a page as the parameter.

Link: https://lkml.kernel.org/r/20230302115835.105364-1-wangkefeng.wang@huawei.com
Link: https://lkml.kernel.org/r/20230302115835.105364-2-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/huge_memory.c~mm-huge_memory-convert-__do_huge_pmd_anonymous_page-to-use-a-folio
+++ a/mm/huge_memory.c
@@ -656,19 +656,20 @@ static vm_fault_t __do_huge_pmd_anonymou
 			struct page *page, gfp_t gfp)
 {
 	struct vm_area_struct *vma = vmf->vma;
+	struct folio *folio = page_folio(page);
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
@@ -678,11 +679,11 @@ static vm_fault_t __do_huge_pmd_anonymou
 
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
@@ -697,7 +698,7 @@ static vm_fault_t __do_huge_pmd_anonymou
 		/* Deliver the page fault to userland */
 		if (userfaultfd_missing(vma)) {
 			spin_unlock(vmf->ptl);
-			put_page(page);
+			folio_put(folio);
 			pte_free(vma->vm_mm, pgtable);
 			ret = handle_userfault(vmf, VM_UFFD_MISSING);
 			VM_BUG_ON(ret & VM_FAULT_FALLBACK);
@@ -706,8 +707,8 @@ static vm_fault_t __do_huge_pmd_anonymou
 
 		entry = mk_huge_pmd(page, vma->vm_page_prot);
 		entry = maybe_pmd_mkwrite(pmd_mkdirty(entry), vma);
-		page_add_new_anon_rmap(page, vma, haddr);
-		lru_cache_add_inactive_or_unevictable(page, vma);
+		folio_add_new_anon_rmap(folio, vma, haddr);
+		folio_add_lru_vma(folio, vma);
 		pgtable_trans_huge_deposit(vma->vm_mm, vmf->pmd, pgtable);
 		set_pmd_at(vma->vm_mm, haddr, vmf->pmd, entry);
 		update_mmu_cache_pmd(vma, vmf->address, vmf->pmd);
@@ -724,7 +725,7 @@ unlock_release:
 release:
 	if (pgtable)
 		pte_free(vma->vm_mm, pgtable);
-	put_page(page);
+	folio_put(folio);
 	return ret;
 
 }
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-huge_memory-convert-__do_huge_pmd_anonymous_page-to-use-a-folio.patch
mm-memory-use-folio_throttle_swaprate-in-do_swap_page.patch
mm-memory-use-folio_throttle_swaprate-in-page_copy_prealloc.patch
mm-memory-use-folio_throttle_swaprate-in-wp_page_copy.patch
mm-memory-use-folio_throttle_swaprate-in-do_anonymous_page.patch
mm-memory-use-folio_throttle_swaprate-in-do_cow_fault.patch
mm-swap-remove-unneeded-cgroup_throttle_swaprate.patch

