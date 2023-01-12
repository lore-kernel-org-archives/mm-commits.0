Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 323ABC61DB3
	for <mm-commits@archiver.kernel.org>; Thu, 12 Jan 2023 22:35:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233096AbjALWfI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 12 Jan 2023 17:35:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232816AbjALWfG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 12 Jan 2023 17:35:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70DCA187
        for <mm-commits@vger.kernel.org>; Thu, 12 Jan 2023 14:35:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B816F621A6
        for <mm-commits@vger.kernel.org>; Thu, 12 Jan 2023 22:35:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13607C433D2;
        Thu, 12 Jan 2023 22:35:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673562904;
        bh=QzDd/5fUBgl9kh3LBIRZUA0pd3ye3tIxi7vVMEl/akw=;
        h=Date:To:From:Subject:From;
        b=WOxtyeHQre1q4tHNiXsRUoa0v/qeK+CnpM9lITDfY2ewlCZkKzaSWmIXbar49Xl+F
         uz8TZ0OcTGzpOteoATFBJBoWS1B/oSY7aZeguJ2EypHN3LeSuaMiXvNUqOWoudQe2m
         48jZ+jLgrrJr41DwQ69uqf7PMKtxmlsVfURNTHAU=
Date:   Thu, 12 Jan 2023 14:35:03 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        wangkefeng.wang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-convert-do_anonymous_page-to-use-a-folio.patch added to mm-unstable branch
Message-Id: <20230112223504.13607C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memory: convert do_anonymous_page() to use a folio
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-convert-do_anonymous_page-to-use-a-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-convert-do_anonymous_page-to-use-a-folio.patch

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
Subject: mm: memory: convert do_anonymous_page() to use a folio
Date: Thu, 12 Jan 2023 16:30:01 +0800

Convert do_anonymous_page() to use a folio and replace related functions
with folio functions.

Link: https://lkml.kernel.org/r/20230112083006.163393-3-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

--- a/mm/memory.c~mm-memory-convert-do_anonymous_page-to-use-a-folio
+++ a/mm/memory.c
@@ -4002,6 +4002,7 @@ static vm_fault_t do_anonymous_page(stru
 {
 	struct vm_area_struct *vma = vmf->vma;
 	struct page *page;
+	struct folio *folio;
 	vm_fault_t ret = 0;
 	pte_t entry;
 
@@ -4055,16 +4056,17 @@ static vm_fault_t do_anonymous_page(stru
 	if (!page)
 		goto oom;
 
-	if (mem_cgroup_charge(page_folio(page), vma->vm_mm, GFP_KERNEL))
+	folio = page_folio(page);
+	if (mem_cgroup_charge(folio, vma->vm_mm, GFP_KERNEL))
 		goto oom_free_page;
-	cgroup_throttle_swaprate(page, GFP_KERNEL);
+	folio_throttle_swaprate(folio, GFP_KERNEL);
 
 	/*
-	 * The memory barrier inside __SetPageUptodate makes sure that
+	 * The memory barrier inside __folio_mark_uptodate makes sure that
 	 * preceding stores to the page contents become visible before
 	 * the set_pte_at() write.
 	 */
-	__SetPageUptodate(page);
+	__folio_mark_uptodate(folio);
 
 	entry = mk_pte(page, vma->vm_page_prot);
 	entry = pte_sw_mkyoung(entry);
@@ -4085,13 +4087,13 @@ static vm_fault_t do_anonymous_page(stru
 	/* Deliver the page fault to userland, check inside PT lock */
 	if (userfaultfd_missing(vma)) {
 		pte_unmap_unlock(vmf->pte, vmf->ptl);
-		put_page(page);
+		folio_put(folio);
 		return handle_userfault(vmf, VM_UFFD_MISSING);
 	}
 
 	inc_mm_counter(vma->vm_mm, MM_ANONPAGES);
 	page_add_new_anon_rmap(page, vma, vmf->address);
-	lru_cache_add_inactive_or_unevictable(page, vma);
+	folio_add_lru_vma(folio, vma);
 setpte:
 	set_pte_at(vma->vm_mm, vmf->address, vmf->pte, entry);
 
@@ -4101,10 +4103,10 @@ unlock:
 	pte_unmap_unlock(vmf->pte, vmf->ptl);
 	return ret;
 release:
-	put_page(page);
+	folio_put(folio);
 	goto unlock;
 oom_free_page:
-	put_page(page);
+	folio_put(folio);
 oom:
 	return VM_FAULT_OOM;
 }
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

