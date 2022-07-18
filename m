Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9530C43334
	for <mm-commits@archiver.kernel.org>; Mon, 18 Jul 2022 00:21:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233111AbiGRAVe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jul 2022 20:21:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233152AbiGRAUE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 17 Jul 2022 20:20:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F4F213D11
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 17:18:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 376EE60F54
        for <mm-commits@vger.kernel.org>; Mon, 18 Jul 2022 00:18:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F187C3411E;
        Mon, 18 Jul 2022 00:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658103509;
        bh=+pcOF807697q5fpYBSDqogPguHiGHbordP1c72fcwpU=;
        h=Date:To:From:Subject:From;
        b=FzCBjHVP7knn+30tik/k1PrNXYubbcz266mYzOJNpy6zG3Z8F2gBasVfK4by1De7W
         HeYkFc+ZWgUe022M/BXw4zL9hOaPANaC7lrdSNCzN/3O408SE6GnfVRazNJHS9xDIj
         d35pyYZvT7fV5J4K867oYtNt9lQpSGQ8fpnHGw8E=
Date:   Sun, 17 Jul 2022 17:18:28 -0700
To:     mm-commits@vger.kernel.org, zokeefe@google.com,
        willy@infradead.org, songmuchun@bytedance.com, shy828301@gmail.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-huge_memory-use-helper-touch_pmd-in-huge_pmd_set_accessed.patch removed from -mm tree
Message-Id: <20220718001829.8F187C3411E@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/huge_memory: use helper touch_pmd in huge_pmd_set_accessed
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-use-helper-touch_pmd-in-huge_pmd_set_accessed.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/huge_memory: use helper touch_pmd in huge_pmd_set_accessed
Date: Mon, 4 Jul 2022 21:21:50 +0800

Use helper touch_pmd to set pmd accessed to simplify the code and improve
the readability. No functional change intended.

Link: https://lkml.kernel.org/r/20220704132201.14611-6-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zach O'Keefe <zokeefe@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   22 +++++++---------------
 1 file changed, 7 insertions(+), 15 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-use-helper-touch_pmd-in-huge_pmd_set_accessed
+++ a/mm/huge_memory.c
@@ -1020,15 +1020,15 @@ EXPORT_SYMBOL_GPL(vmf_insert_pfn_pud_pro
 #endif /* CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD */
 
 static void touch_pmd(struct vm_area_struct *vma, unsigned long addr,
-		pmd_t *pmd, int flags)
+		      pmd_t *pmd, bool write)
 {
 	pmd_t _pmd;
 
 	_pmd = pmd_mkyoung(*pmd);
-	if (flags & FOLL_WRITE)
+	if (write)
 		_pmd = pmd_mkdirty(_pmd);
 	if (pmdp_set_access_flags(vma, addr & HPAGE_PMD_MASK,
-				pmd, _pmd, flags & FOLL_WRITE))
+				  pmd, _pmd, write))
 		update_mmu_cache_pmd(vma, addr, pmd);
 }
 
@@ -1061,7 +1061,7 @@ struct page *follow_devmap_pmd(struct vm
 		return NULL;
 
 	if (flags & FOLL_TOUCH)
-		touch_pmd(vma, addr, pmd, flags);
+		touch_pmd(vma, addr, pmd, flags & FOLL_WRITE);
 
 	/*
 	 * device mapped pages can only be returned if the
@@ -1298,21 +1298,13 @@ unlock:
 
 void huge_pmd_set_accessed(struct vm_fault *vmf)
 {
-	pmd_t entry;
-	unsigned long haddr;
 	bool write = vmf->flags & FAULT_FLAG_WRITE;
-	pmd_t orig_pmd = vmf->orig_pmd;
 
 	vmf->ptl = pmd_lock(vmf->vma->vm_mm, vmf->pmd);
-	if (unlikely(!pmd_same(*vmf->pmd, orig_pmd)))
+	if (unlikely(!pmd_same(*vmf->pmd, vmf->orig_pmd)))
 		goto unlock;
 
-	entry = pmd_mkyoung(orig_pmd);
-	if (write)
-		entry = pmd_mkdirty(entry);
-	haddr = vmf->address & HPAGE_PMD_MASK;
-	if (pmdp_set_access_flags(vmf->vma, haddr, vmf->pmd, entry, write))
-		update_mmu_cache_pmd(vmf->vma, vmf->address, vmf->pmd);
+	touch_pmd(vmf->vma, vmf->address, vmf->pmd, write);
 
 unlock:
 	spin_unlock(vmf->ptl);
@@ -1448,7 +1440,7 @@ struct page *follow_trans_huge_pmd(struc
 		return ERR_PTR(-ENOMEM);
 
 	if (flags & FOLL_TOUCH)
-		touch_pmd(vma, addr, pmd, flags);
+		touch_pmd(vma, addr, pmd, flags & FOLL_WRITE);
 
 	page += (addr & ~HPAGE_PMD_MASK) >> PAGE_SHIFT;
 	VM_BUG_ON_PAGE(!PageCompound(page) && !is_zone_device_page(page), page);
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-hugetlb-avoid-corrupting-page-mapping-in-hugetlb_mcopy_atomic_pte.patch
mm-page_alloc-minor-clean-up-for-memmap_init_compound.patch
mm-mmapc-fix-missing-call-to-vm_unacct_memory-in-mmap_region.patch
filemap-minor-cleanup-for-filemap_write_and_wait_range.patch
mm-remove-obsolete-comment-in-do_fault_around.patch

