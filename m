Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C74B8C43334
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jul 2022 23:04:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbiGDXEO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 4 Jul 2022 19:04:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230170AbiGDXEM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 4 Jul 2022 19:04:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAAF4BF6B
        for <mm-commits@vger.kernel.org>; Mon,  4 Jul 2022 16:04:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 345B0617A1
        for <mm-commits@vger.kernel.org>; Mon,  4 Jul 2022 23:04:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89682C3411E;
        Mon,  4 Jul 2022 23:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656975850;
        bh=BgDxeZpFq69MhwP2ETch2iUIXCNMY0oWWVOGr2k0sUs=;
        h=Date:To:From:Subject:From;
        b=l2IX5059+/syj8QygiWSlXC+fKKDWZGeP1kIYDeR9GmkUwpYz/e59v4yv9ADIV2jh
         xw27CakKdubCLUT3BOcZVDh+gLTIxTABmLPQaerER8YalgLWZAyR8IpeTz0QeIy2aW
         awtZYOsrMNnAWvmWSvKXGKkDd+L3qP3J/m3Vnk5A=
Date:   Mon, 04 Jul 2022 16:04:09 -0700
To:     mm-commits@vger.kernel.org, zokeefe@google.com,
        willy@infradead.org, songmuchun@bytedance.com, shy828301@gmail.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-use-helper-touch_pud-in-huge_pud_set_accessed.patch added to mm-unstable branch
Message-Id: <20220704230410.89682C3411E@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/huge_memory: use helper touch_pud in huge_pud_set_accessed
has been added to the -mm mm-unstable branch.  Its filename is
     mm-huge_memory-use-helper-touch_pud-in-huge_pud_set_accessed.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-use-helper-touch_pud-in-huge_pud_set_accessed.patch

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
Subject: mm/huge_memory: use helper touch_pud in huge_pud_set_accessed
Date: Mon, 4 Jul 2022 21:21:49 +0800

Use helper touch_pud to set pud accessed to simplify the code and improve
the readability. No functional change intended.

Link: https://lkml.kernel.org/r/20220704132201.14611-5-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zach O'Keefe <zokeefe@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-use-helper-touch_pud-in-huge_pud_set_accessed
+++ a/mm/huge_memory.c
@@ -1284,15 +1284,15 @@ out:
 
 #ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
 static void touch_pud(struct vm_area_struct *vma, unsigned long addr,
-		pud_t *pud, int flags)
+		      pud_t *pud, bool write)
 {
 	pud_t _pud;
 
 	_pud = pud_mkyoung(*pud);
-	if (flags & FOLL_WRITE)
+	if (write)
 		_pud = pud_mkdirty(_pud);
 	if (pudp_set_access_flags(vma, addr & HPAGE_PUD_MASK,
-				pud, _pud, flags & FOLL_WRITE))
+				  pud, _pud, write))
 		update_mmu_cache_pud(vma, addr, pud);
 }
 
@@ -1319,7 +1319,7 @@ struct page *follow_devmap_pud(struct vm
 		return NULL;
 
 	if (flags & FOLL_TOUCH)
-		touch_pud(vma, addr, pud, flags);
+		touch_pud(vma, addr, pud, flags & FOLL_WRITE);
 
 	/*
 	 * device mapped pages can only be returned if the
@@ -1384,21 +1384,13 @@ out_unlock:
 
 void huge_pud_set_accessed(struct vm_fault *vmf, pud_t orig_pud)
 {
-	pud_t entry;
-	unsigned long haddr;
 	bool write = vmf->flags & FAULT_FLAG_WRITE;
 
 	vmf->ptl = pud_lock(vmf->vma->vm_mm, vmf->pud);
 	if (unlikely(!pud_same(*vmf->pud, orig_pud)))
 		goto unlock;
 
-	entry = pud_mkyoung(orig_pud);
-	if (write)
-		entry = pud_mkdirty(entry);
-	haddr = vmf->address & HPAGE_PUD_MASK;
-	if (pudp_set_access_flags(vmf->vma, haddr, vmf->pud, entry, write))
-		update_mmu_cache_pud(vmf->vma, vmf->address, vmf->pud);
-
+	touch_pud(vmf->vma, vmf->address, vmf->pud, write);
 unlock:
 	spin_unlock(vmf->ptl);
 }
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

