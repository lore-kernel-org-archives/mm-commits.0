Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E74C7C433EF
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jul 2022 23:04:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233565AbiGDXEX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 4 Jul 2022 19:04:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbiGDXER (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 4 Jul 2022 19:04:17 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38904BF79
        for <mm-commits@vger.kernel.org>; Mon,  4 Jul 2022 16:04:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 60AD3CE1A01
        for <mm-commits@vger.kernel.org>; Mon,  4 Jul 2022 23:04:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78BB7C3411E;
        Mon,  4 Jul 2022 23:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656975852;
        bh=6O+In0pipg/Qj/zE5smIBmVnL5Cc34zSV3RnhhVLsvI=;
        h=Date:To:From:Subject:From;
        b=YxkVQUYQoUE3jxxSOpM4nZympMOxQqF84PltcJqo90AsxV5v1T5Ic4WPcIC45NV7y
         F5mQfoqNNm7w7/Z5WqRpMk+ed32nspo2wSnEpBED0qqBq8z5GKfxGxWM3zPzL/QIq9
         wcPMp41aibOBs6fRdWiIio+9bfqX91HN3UCtEP8Y=
Date:   Mon, 04 Jul 2022 16:04:11 -0700
To:     mm-commits@vger.kernel.org, zokeefe@google.com,
        willy@infradead.org, songmuchun@bytedance.com, shy828301@gmail.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-use-helper-touch_pmd-in-huge_pmd_set_accessed.patch added to mm-unstable branch
Message-Id: <20220704230412.78BB7C3411E@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/huge_memory: use helper touch_pmd in huge_pmd_set_accessed
has been added to the -mm mm-unstable branch.  Its filename is
     mm-huge_memory-use-helper-touch_pmd-in-huge_pmd_set_accessed.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-use-helper-touch_pmd-in-huge_pmd_set_accessed.patch

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
@@ -1120,15 +1120,15 @@ EXPORT_SYMBOL_GPL(vmf_insert_pfn_pud_pro
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
 
@@ -1161,7 +1161,7 @@ struct page *follow_devmap_pmd(struct vm
 		return NULL;
 
 	if (flags & FOLL_TOUCH)
-		touch_pmd(vma, addr, pmd, flags);
+		touch_pmd(vma, addr, pmd, flags & FOLL_WRITE);
 
 	/*
 	 * device mapped pages can only be returned if the
@@ -1398,21 +1398,13 @@ unlock:
 
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
@@ -1548,7 +1540,7 @@ struct page *follow_trans_huge_pmd(struc
 		return ERR_PTR(-ENOMEM);
 
 	if (flags & FOLL_TOUCH)
-		touch_pmd(vma, addr, pmd, flags);
+		touch_pmd(vma, addr, pmd, flags & FOLL_WRITE);
 
 	page += (addr & ~HPAGE_PMD_MASK) >> PAGE_SHIFT;
 	VM_BUG_ON_PAGE(!PageCompound(page) && !is_zone_device_page(page), page);
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-page_alloc-minor-clean-up-for-memmap_init_compound.patch
mm-mmapc-fix-missing-call-to-vm_unacct_memory-in-mmap_region.patch
filemap-minor-cleanup-for-filemap_write_and_wait_range.patch
mm-huge_memory-use-flush_pmd_tlb_range-in-move_huge_pmd.patch
mm-huge_memory-access-vm_page_prot-with-read_once-in-remove_migration_pmd.patch
mm-huge_memory-fix-comment-of-__pud_trans_huge_lock.patch
mm-huge_memory-use-helper-touch_pud-in-huge_pud_set_accessed.patch
mm-huge_memory-use-helper-touch_pmd-in-huge_pmd_set_accessed.patch
mm-huge_memory-rename-mmun_start-to-haddr-in-remove_migration_pmd.patch
mm-huge_memory-use-helper-function-vma_lookup-in-split_huge_pages_pid.patch
mm-huge_memory-use-helper-macro-__attr_rw.patch
mm-huge_memory-fix-comment-in-zap_huge_pud.patch
mm-huge_memory-check-pmd_present-first-in-is_huge_zero_pmd.patch
mm-huge_memory-try-to-free-subpage-in-swapcache-when-possible.patch
mm-huge_memory-minor-cleanup-for-split_huge_pages_all.patch
mm-huge_memory-fix-comment-of-page_deferred_list.patch
mm-huge_memory-correct-comment-of-prep_transhuge_page.patch
mm-huge_memory-comment-the-subtly-logic-in-__split_huge_pmd.patch
mm-huge_memory-use-helper-macro-is_err_or_null-in-split_huge_pages_pid.patch

