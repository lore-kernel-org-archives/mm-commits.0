Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58DC7C76196
	for <mm-commits@archiver.kernel.org>; Fri, 31 Mar 2023 22:09:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231858AbjCaWJN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 31 Mar 2023 18:09:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232467AbjCaWJM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 31 Mar 2023 18:09:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FEFD59E9
        for <mm-commits@vger.kernel.org>; Fri, 31 Mar 2023 15:09:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 84FF862C47
        for <mm-commits@vger.kernel.org>; Fri, 31 Mar 2023 22:09:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6AA8C433D2;
        Fri, 31 Mar 2023 22:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680300549;
        bh=G/XgaMpnh1zU+Xo5lDJaxpNLjg8XDomAS4QYG6V4WoI=;
        h=Date:To:From:Subject:From;
        b=y1ikzsL1GfDtHGGjggVj8X9yWmrLR/7dqjQOxvP0gwqRjFRizM2HO3frgDSOxD1ay
         ymfe1Kyns9zausgmdkbgEoUfBvZZj8vx3Vj04RHhMjq7ekqwmXWYn5Ujg4ATRnrJ63
         h3cExlmvmBDOrYnjkAAobQsgSHCsvVvA1d3ZFgio=
Date:   Fri, 31 Mar 2023 15:09:09 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        wangkefeng.wang@huawei.com, vishal.moola@gmail.com,
        sunnanyong@huawei.com, sidhartha.kumar@oracle.com,
        muchun.song@linux.dev, mike.kravetz@oracle.com,
        zhangpeng362@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + userfaultfd-convert-mfill_atomic_pte_copy-to-use-a-folio.patch added to mm-unstable branch
Message-Id: <20230331220909.D6AA8C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: convert mfill_atomic_pte_copy() to use a folio
has been added to the -mm mm-unstable branch.  Its filename is
     userfaultfd-convert-mfill_atomic_pte_copy-to-use-a-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/userfaultfd-convert-mfill_atomic_pte_copy-to-use-a-folio.patch

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
From: ZhangPeng <zhangpeng362@huawei.com>
Subject: userfaultfd: convert mfill_atomic_pte_copy() to use a folio
Date: Fri, 31 Mar 2023 17:39:32 +0800

Patch series "userfaultfd: convert userfaultfd functions to use folios",
v5.

This series converts several userfaultfd functions to use folios.


This patch (of 6):

Call vma_alloc_folio() directly instead of alloc_page_vma() and convert
page_kaddr to kaddr in mfill_atomic_pte_copy().  Removes several calls to
compound_head().

Link: https://lkml.kernel.org/r/20230331093937.945725-1-zhangpeng362@huawei.com
Link: https://lkml.kernel.org/r/20230331093937.945725-2-zhangpeng362@huawei.com
Signed-off-by: ZhangPeng <zhangpeng362@huawei.com>
Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/userfaultfd.c |   33 +++++++++++++++++----------------
 1 file changed, 17 insertions(+), 16 deletions(-)

--- a/mm/userfaultfd.c~userfaultfd-convert-mfill_atomic_pte_copy-to-use-a-folio
+++ a/mm/userfaultfd.c
@@ -135,17 +135,18 @@ static int mfill_atomic_pte_copy(pmd_t *
 				 uffd_flags_t flags,
 				 struct page **pagep)
 {
-	void *page_kaddr;
+	void *kaddr;
 	int ret;
-	struct page *page;
+	struct folio *folio;
 
 	if (!*pagep) {
 		ret = -ENOMEM;
-		page = alloc_page_vma(GFP_HIGHUSER_MOVABLE, dst_vma, dst_addr);
-		if (!page)
+		folio = vma_alloc_folio(GFP_HIGHUSER_MOVABLE, 0, dst_vma,
+					dst_addr, false);
+		if (!folio)
 			goto out;
 
-		page_kaddr = kmap_local_page(page);
+		kaddr = kmap_local_folio(folio, 0);
 		/*
 		 * The read mmap_lock is held here.  Despite the
 		 * mmap_lock being read recursive a deadlock is still
@@ -162,45 +163,45 @@ static int mfill_atomic_pte_copy(pmd_t *
 		 * and retry the copy outside the mmap_lock.
 		 */
 		pagefault_disable();
-		ret = copy_from_user(page_kaddr,
-				     (const void __user *) src_addr,
+		ret = copy_from_user(kaddr, (const void __user *) src_addr,
 				     PAGE_SIZE);
 		pagefault_enable();
-		kunmap_local(page_kaddr);
+		kunmap_local(kaddr);
 
 		/* fallback to copy_from_user outside mmap_lock */
 		if (unlikely(ret)) {
 			ret = -ENOENT;
-			*pagep = page;
+			*pagep = &folio->page;
 			/* don't free the page */
 			goto out;
 		}
 
-		flush_dcache_page(page);
+		flush_dcache_folio(folio);
 	} else {
-		page = *pagep;
+		folio = page_folio(*pagep);
+		VM_BUG_ON_FOLIO(folio_test_large(folio), folio);
 		*pagep = NULL;
 	}
 
 	/*
-	 * The memory barrier inside __SetPageUptodate makes sure that
+	 * The memory barrier inside __folio_mark_uptodate makes sure that
 	 * preceding stores to the page contents become visible before
 	 * the set_pte_at() write.
 	 */
-	__SetPageUptodate(page);
+	__folio_mark_uptodate(folio);
 
 	ret = -ENOMEM;
-	if (mem_cgroup_charge(page_folio(page), dst_vma->vm_mm, GFP_KERNEL))
+	if (mem_cgroup_charge(folio, dst_vma->vm_mm, GFP_KERNEL))
 		goto out_release;
 
 	ret = mfill_atomic_install_pte(dst_pmd, dst_vma, dst_addr,
-				       page, true, flags);
+				       &folio->page, true, flags);
 	if (ret)
 		goto out_release;
 out:
 	return ret;
 out_release:
-	put_page(page);
+	folio_put(folio);
 	goto out;
 }
 
_

Patches currently in -mm which might be from zhangpeng362@huawei.com are

userfaultfd-convert-mfill_atomic_pte_copy-to-use-a-folio.patch
userfaultfd-use-kmap_local_page-in-copy_huge_page_from_user.patch
userfaultfd-convert-copy_huge_page_from_user-to-copy_folio_from_user.patch
userfaultfd-convert-mfill_atomic_hugetlb-to-use-a-folio.patch
mm-convert-copy_user_huge_page-to-copy_user_folio.patch
userfaultfd-convert-mfill_atomic-to-use-a-folio.patch

