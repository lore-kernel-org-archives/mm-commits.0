Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7A0DC77B7E
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 23:35:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229750AbjDRXf5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 19:35:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231643AbjDRXew (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 19:34:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5758AF23
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 16:34:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4C54762F29
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 23:34:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A05CC433D2;
        Tue, 18 Apr 2023 23:34:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681860873;
        bh=CW2nZi33cF1ad3cffOSxf8HdNV/pbv8vLRyF77uIk/0=;
        h=Date:To:From:Subject:From;
        b=tMnXllLOZGxGD+h/ARk0jFFgsvfulA9bEsKxLYWBgmJM4ujZvwvsL582+BpHV+rhu
         AVsKcBY+mMUcRnqs3TywsaiwBPESKWaFcQsvnMWGNd5D6Bn/fFRMDFY6g664qnp6RA
         LgYxMT5XYAR2/HXvjxr6IpfkfRcS72mrtdKZB/jA=
Date:   Tue, 18 Apr 2023 16:34:33 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        wangkefeng.wang@huawei.com, vishal.moola@gmail.com,
        sunnanyong@huawei.com, sidhartha.kumar@oracle.com,
        muchun.song@linux.dev, mike.kravetz@oracle.com,
        zhangpeng362@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-convert-copy_user_huge_page-to-copy_user_large_folio.patch removed from -mm tree
Message-Id: <20230418233433.9A05CC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: convert copy_user_huge_page() to copy_user_large_folio()
has been removed from the -mm tree.  Its filename was
     mm-convert-copy_user_huge_page-to-copy_user_large_folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: ZhangPeng <zhangpeng362@huawei.com>
Subject: mm: convert copy_user_huge_page() to copy_user_large_folio()
Date: Mon, 10 Apr 2023 21:39:31 +0800

Replace copy_user_huge_page() with copy_user_large_folio(). 
copy_user_large_folio() does the same as copy_user_huge_page(), but takes
in folios instead of pages.  Remove pages_per_huge_page from
copy_user_large_folio(), because we can get that from folio_nr_pages(dst).

Convert copy_user_gigantic_page() to take in folios.

Link: https://lkml.kernel.org/r/20230410133932.32288-6-zhangpeng362@huawei.com
Signed-off-by: ZhangPeng <zhangpeng362@huawei.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    7 +++----
 mm/hugetlb.c       |   11 +++++------
 mm/memory.c        |   28 ++++++++++++++--------------
 3 files changed, 22 insertions(+), 24 deletions(-)

--- a/include/linux/mm.h~mm-convert-copy_user_huge_page-to-copy_user_large_folio
+++ a/include/linux/mm.h
@@ -3677,10 +3677,9 @@ extern const struct attribute_group memo
 extern void clear_huge_page(struct page *page,
 			    unsigned long addr_hint,
 			    unsigned int pages_per_huge_page);
-extern void copy_user_huge_page(struct page *dst, struct page *src,
-				unsigned long addr_hint,
-				struct vm_area_struct *vma,
-				unsigned int pages_per_huge_page);
+void copy_user_large_folio(struct folio *dst, struct folio *src,
+			   unsigned long addr_hint,
+			   struct vm_area_struct *vma);
 long copy_folio_from_user(struct folio *dst_folio,
 			   const void __user *usr_src,
 			   bool allow_pagefault);
--- a/mm/hugetlb.c~mm-convert-copy_user_huge_page-to-copy_user_large_folio
+++ a/mm/hugetlb.c
@@ -5097,8 +5097,9 @@ again:
 					ret = PTR_ERR(new_folio);
 					break;
 				}
-				copy_user_huge_page(&new_folio->page, ptepage, addr, dst_vma,
-						    npages);
+				copy_user_large_folio(new_folio,
+						      page_folio(ptepage),
+						      addr, dst_vma);
 				put_page(ptepage);
 
 				/* Install the new hugetlb folio if src pte stable */
@@ -5616,8 +5617,7 @@ retry_avoidcopy:
 		goto out_release_all;
 	}
 
-	copy_user_huge_page(&new_folio->page, old_page, address, vma,
-			    pages_per_huge_page(h));
+	copy_user_large_folio(new_folio, page_folio(old_page), address, vma);
 	__folio_mark_uptodate(new_folio);
 
 	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm, haddr,
@@ -6260,8 +6260,7 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_
 			*foliop = NULL;
 			goto out;
 		}
-		copy_user_huge_page(&folio->page, &(*foliop)->page, dst_addr, dst_vma,
-				    pages_per_huge_page(h));
+		copy_user_large_folio(folio, *foliop, dst_addr, dst_vma);
 		folio_put(*foliop);
 		*foliop = NULL;
 	}
--- a/mm/memory.c~mm-convert-copy_user_huge_page-to-copy_user_large_folio
+++ a/mm/memory.c
@@ -5815,21 +5815,21 @@ void clear_huge_page(struct page *page,
 	process_huge_page(addr_hint, pages_per_huge_page, clear_subpage, page);
 }
 
-static void copy_user_gigantic_page(struct page *dst, struct page *src,
-				    unsigned long addr,
-				    struct vm_area_struct *vma,
-				    unsigned int pages_per_huge_page)
+static void copy_user_gigantic_page(struct folio *dst, struct folio *src,
+				     unsigned long addr,
+				     struct vm_area_struct *vma,
+				     unsigned int pages_per_huge_page)
 {
 	int i;
-	struct page *dst_base = dst;
-	struct page *src_base = src;
+	struct page *dst_page;
+	struct page *src_page;
 
 	for (i = 0; i < pages_per_huge_page; i++) {
-		dst = nth_page(dst_base, i);
-		src = nth_page(src_base, i);
+		dst_page = folio_page(dst, i);
+		src_page = folio_page(src, i);
 
 		cond_resched();
-		copy_user_highpage(dst, src, addr + i*PAGE_SIZE, vma);
+		copy_user_highpage(dst_page, src_page, addr + i*PAGE_SIZE, vma);
 	}
 }
 
@@ -5847,15 +5847,15 @@ static void copy_subpage(unsigned long a
 			   addr, copy_arg->vma);
 }
 
-void copy_user_huge_page(struct page *dst, struct page *src,
-			 unsigned long addr_hint, struct vm_area_struct *vma,
-			 unsigned int pages_per_huge_page)
+void copy_user_large_folio(struct folio *dst, struct folio *src,
+			   unsigned long addr_hint, struct vm_area_struct *vma)
 {
+	unsigned int pages_per_huge_page = folio_nr_pages(dst);
 	unsigned long addr = addr_hint &
 		~(((unsigned long)pages_per_huge_page << PAGE_SHIFT) - 1);
 	struct copy_subpage_arg arg = {
-		.dst = dst,
-		.src = src,
+		.dst = &dst->page,
+		.src = &src->page,
 		.vma = vma,
 	};
 
_

Patches currently in -mm which might be from zhangpeng362@huawei.com are

userfaultfd-convert-mfill_atomic-to-use-a-folio.patch
userfaultfd-use-helper-function-range_in_vma.patch

