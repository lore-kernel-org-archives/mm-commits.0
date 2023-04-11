Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F94FC76196
	for <mm-commits@archiver.kernel.org>; Tue, 11 Apr 2023 03:48:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229932AbjDKDsG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 10 Apr 2023 23:48:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbjDKDsA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Apr 2023 23:48:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DB751BC
        for <mm-commits@vger.kernel.org>; Mon, 10 Apr 2023 20:47:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 39179620F9
        for <mm-commits@vger.kernel.org>; Tue, 11 Apr 2023 03:47:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C5E5C433D2;
        Tue, 11 Apr 2023 03:47:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681184878;
        bh=uMB/UHAvgL4rA3yHa4qT3ivXD+e+Ld38OMLluA7zFN8=;
        h=Date:To:From:Subject:From;
        b=XPDJe9htLqpUXy0E5+7Y+hKeSCpNWwxSTiYRjkrKCn6YFpMFuCYCYptnA7FCU70ZA
         2LDRlDLGQqcnGW7R5jwHc13hWm00+MJS085EdmabXhIyTEF9+27LT3irtGQv+JDnkR
         ytPrFNlZL4mSyi4xX/y4POP43z8maObio0d074o0=
Date:   Mon, 10 Apr 2023 20:47:58 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        wangkefeng.wang@huawei.com, vishal.moola@gmail.com,
        sunnanyong@huawei.com, sidhartha.kumar@oracle.com,
        muchun.song@linux.dev, mike.kravetz@oracle.com,
        zhangpeng362@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-convert-copy_user_huge_page-to-copy_user_large_folio.patch added to mm-unstable branch
Message-Id: <20230411034758.8C5E5C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: convert copy_user_huge_page() to copy_user_large_folio()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-convert-copy_user_huge_page-to-copy_user_large_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-convert-copy_user_huge_page-to-copy_user_large_folio.patch

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
@@ -3694,10 +3694,9 @@ extern const struct attribute_group memo
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
@@ -5606,8 +5607,7 @@ retry_avoidcopy:
 		goto out_release_all;
 	}
 
-	copy_user_huge_page(&new_folio->page, old_page, address, vma,
-			    pages_per_huge_page(h));
+	copy_user_large_folio(new_folio, page_folio(old_page), address, vma);
 	__folio_mark_uptodate(new_folio);
 
 	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm, haddr,
@@ -6250,8 +6250,7 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_
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
@@ -5801,21 +5801,21 @@ void clear_huge_page(struct page *page,
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
 
@@ -5833,15 +5833,15 @@ static void copy_subpage(unsigned long a
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

mm-madvise-use-vma_lookup-instead-of-find_vma.patch
userfaultfd-convert-mfill_atomic_pte_copy-to-use-a-folio.patch
userfaultfd-use-kmap_local_page-in-copy_huge_page_from_user.patch
userfaultfd-convert-copy_huge_page_from_user-to-copy_folio_from_user.patch
userfaultfd-convert-mfill_atomic_hugetlb-to-use-a-folio.patch
mm-convert-copy_user_huge_page-to-copy_user_large_folio.patch
userfaultfd-convert-mfill_atomic-to-use-a-folio.patch

