Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2C3EC77B75
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 23:35:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231620AbjDRXf4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 19:35:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229750AbjDRXew (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 19:34:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EAC083F8
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 16:34:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3AC4262EE4
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 23:34:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9176FC433D2;
        Tue, 18 Apr 2023 23:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681860868;
        bh=1bzs57xfjV2q1dbGpsYkGGmWEbnCWs84lE3Xc29V6do=;
        h=Date:To:From:Subject:From;
        b=YzKMHqvtPRPl4TJFL/aJ5eFEIQu4hn/yRDSV2jWbz3kJeyGXnEItcVTsCJ/JSaSSM
         5e8ML7TNz1sd2c/CcOUd9wJaa2n7CHg6i1uWVYi8CaUtqwVd09MTIzRN5yk0Bg13lT
         OBQKttNQgWvFiacatTDNMT3fB9U/4VajrXmvkC8g=
Date:   Tue, 18 Apr 2023 16:34:28 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        wangkefeng.wang@huawei.com, vishal.moola@gmail.com,
        sunnanyong@huawei.com, sidhartha.kumar@oracle.com,
        muchun.song@linux.dev, mike.kravetz@oracle.com,
        zhangpeng362@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] userfaultfd-convert-mfill_atomic_pte_copy-to-use-a-folio.patch removed from -mm tree
Message-Id: <20230418233428.9176FC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: userfaultfd: convert mfill_atomic_pte_copy() to use a folio
has been removed from the -mm tree.  Its filename was
     userfaultfd-convert-mfill_atomic_pte_copy-to-use-a-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: ZhangPeng <zhangpeng362@huawei.com>
Subject: userfaultfd: convert mfill_atomic_pte_copy() to use a folio
Date: Mon, 10 Apr 2023 21:39:27 +0800

Patch series "userfaultfd: convert userfaultfd functions to use folios",
v6.

This patch series converts several userfaultfd functions to use folios.


This patch (of 6):

Call vma_alloc_folio() directly instead of alloc_page_vma() and convert
page_kaddr to kaddr in mfill_atomic_pte_copy().  Removes several calls to
compound_head().

Link: https://lkml.kernel.org/r/20230410133932.32288-1-zhangpeng362@huawei.com
Link: https://lkml.kernel.org/r/20230410133932.32288-2-zhangpeng362@huawei.com
Signed-off-by: ZhangPeng <zhangpeng362@huawei.com>
Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/userfaultfd.c |   32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

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
@@ -162,45 +163,44 @@ static int mfill_atomic_pte_copy(pmd_t *
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

userfaultfd-use-kmap_local_page-in-copy_huge_page_from_user.patch
userfaultfd-convert-copy_huge_page_from_user-to-copy_folio_from_user.patch
userfaultfd-convert-mfill_atomic_hugetlb-to-use-a-folio.patch
mm-convert-copy_user_huge_page-to-copy_user_large_folio.patch
userfaultfd-convert-mfill_atomic-to-use-a-folio.patch
userfaultfd-use-helper-function-range_in_vma.patch

