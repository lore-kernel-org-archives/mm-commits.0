Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBB74C3DA78
	for <mm-commits@archiver.kernel.org>; Sat, 14 Jan 2023 04:34:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230105AbjANEeo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 Jan 2023 23:34:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbjANEed (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2023 23:34:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BE989E
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2023 20:34:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 42494B822B2
        for <mm-commits@vger.kernel.org>; Sat, 14 Jan 2023 04:34:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D408EC433D2;
        Sat, 14 Jan 2023 04:34:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673670869;
        bh=w6O/SLwbVo27rwnQuKkfwiHdf2pYb62frTHblDpkZwk=;
        h=Date:To:From:Subject:From;
        b=ef7zKAKhm6z8fdaegiPIk6txUXi125cdPF5kSj3EheGJdUUwTwBcfAYFou0hk1pPo
         W1COonv2WsqVqTyyUaWQxDkwjR30+5WQWToLtZlbwkrPv4We7zZ0w7XD5lSYTWaOto
         hBH9AHpT0XxlHWJDaZQIUTmYLO7qiVSuBJtYaBeI=
Date:   Fri, 13 Jan 2023 20:34:29 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        wangkefeng.wang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-memory-convert-do_cow_fault-to-use-folios.patch removed from -mm tree
Message-Id: <20230114043429.D408EC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: memory: convert do_cow_fault to use folios
has been removed from the -mm tree.  Its filename was
     mm-memory-convert-do_cow_fault-to-use-folios.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: memory: convert do_cow_fault to use folios
Date: Thu, 12 Jan 2023 16:30:02 +0800

The page functions are converted to corresponding folio functions in
do_cow_fault().

Link: https://lkml.kernel.org/r/20230112083006.163393-4-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

--- a/mm/memory.c~mm-memory-convert-do_cow_fault-to-use-folios
+++ a/mm/memory.c
@@ -4507,22 +4507,24 @@ static vm_fault_t do_read_fault(struct v
 static vm_fault_t do_cow_fault(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
+	struct folio *cow_folio, *folio;
 	vm_fault_t ret;
 
 	if (unlikely(anon_vma_prepare(vma)))
 		return VM_FAULT_OOM;
 
-	vmf->cow_page = alloc_page_vma(GFP_HIGHUSER_MOVABLE, vma, vmf->address);
-	if (!vmf->cow_page)
+	cow_folio = vma_alloc_folio(GFP_HIGHUSER_MOVABLE, 0, vma, vmf->address,
+				    false);
+	if (!cow_folio)
 		return VM_FAULT_OOM;
 
-	if (mem_cgroup_charge(page_folio(vmf->cow_page), vma->vm_mm,
-				GFP_KERNEL)) {
-		put_page(vmf->cow_page);
+	if (mem_cgroup_charge(cow_folio, vma->vm_mm, GFP_KERNEL)) {
+		folio_put(cow_folio);
 		return VM_FAULT_OOM;
 	}
-	cgroup_throttle_swaprate(vmf->cow_page, GFP_KERNEL);
+	folio_throttle_swaprate(cow_folio, GFP_KERNEL);
 
+	vmf->cow_page = &cow_folio->page;
 	ret = __do_fault(vmf);
 	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE | VM_FAULT_RETRY)))
 		goto uncharge_out;
@@ -4530,16 +4532,17 @@ static vm_fault_t do_cow_fault(struct vm
 		return ret;
 
 	copy_user_highpage(vmf->cow_page, vmf->page, vmf->address, vma);
-	__SetPageUptodate(vmf->cow_page);
+	__folio_mark_uptodate(cow_folio);
 
 	ret |= finish_fault(vmf);
-	unlock_page(vmf->page);
-	put_page(vmf->page);
+	folio = page_folio(vmf->page);
+	folio_unlock(folio);
+	folio_put(folio);
 	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE | VM_FAULT_RETRY)))
 		goto uncharge_out;
 	return ret;
 uncharge_out:
-	put_page(vmf->cow_page);
+	folio_put(cow_folio);
 	return ret;
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
mm-memory-convert-page_copy_prealloc-to-use-a-folio.patch
mm-memory-convert-wp_page_copy-to-use-folios.patch
mm-memory-use-folio_throttle_swaprate-in-do_swap_page.patch
mm-swap-remove-unneeded-cgroup_throttle_swaprate.patch

