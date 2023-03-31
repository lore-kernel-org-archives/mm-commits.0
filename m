Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17E8CC76196
	for <mm-commits@archiver.kernel.org>; Fri, 31 Mar 2023 22:09:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233029AbjCaWJX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 31 Mar 2023 18:09:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232039AbjCaWJU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 31 Mar 2023 18:09:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 190735279
        for <mm-commits@vger.kernel.org>; Fri, 31 Mar 2023 15:09:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A91D5B83288
        for <mm-commits@vger.kernel.org>; Fri, 31 Mar 2023 22:09:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 391C6C433EF;
        Fri, 31 Mar 2023 22:09:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680300556;
        bh=v886S1TivBGw+ujZMq0KSIlwQccJdNn5TLoUs/MV1Tg=;
        h=Date:To:From:Subject:From;
        b=PQ1zvgOMZWyuBIi0c3g+uuegqOmcxWsvYZVuVtl71FTJG7994IBaRLnzMQn5+/loV
         3DqtggjPdme7xsMZE4qO3WUMtoK+WxMNRvCxhZvKgYZUv7jCZjyCX4uN4DqG3lJ0mE
         Yqh23ThOWtq+elL6ncXBzF+5V5bDXDg3BJNplaIM=
Date:   Fri, 31 Mar 2023 15:09:15 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        wangkefeng.wang@huawei.com, vishal.moola@gmail.com,
        sunnanyong@huawei.com, sidhartha.kumar@oracle.com,
        muchun.song@linux.dev, mike.kravetz@oracle.com,
        zhangpeng362@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + userfaultfd-convert-mfill_atomic_hugetlb-to-use-a-folio.patch added to mm-unstable branch
Message-Id: <20230331220916.391C6C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: convert mfill_atomic_hugetlb() to use a folio
has been added to the -mm mm-unstable branch.  Its filename is
     userfaultfd-convert-mfill_atomic_hugetlb-to-use-a-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/userfaultfd-convert-mfill_atomic_hugetlb-to-use-a-folio.patch

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
Subject: userfaultfd: convert mfill_atomic_hugetlb() to use a folio
Date: Fri, 31 Mar 2023 17:39:35 +0800

Convert hugetlb_mfill_atomic_pte() to take in a folio pointer instead of a
page pointer.  Convert mfill_atomic_hugetlb() to use a folio.

Link: https://lkml.kernel.org/r/20230331093937.945725-5-zhangpeng362@huawei.com
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

 include/linux/hugetlb.h |    4 ++--
 mm/hugetlb.c            |   26 +++++++++++++-------------
 mm/userfaultfd.c        |   16 ++++++++--------
 3 files changed, 23 insertions(+), 23 deletions(-)

--- a/include/linux/hugetlb.h~userfaultfd-convert-mfill_atomic_hugetlb-to-use-a-folio
+++ a/include/linux/hugetlb.h
@@ -163,7 +163,7 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_
 			     unsigned long dst_addr,
 			     unsigned long src_addr,
 			     uffd_flags_t flags,
-			     struct page **pagep);
+			     struct folio **foliop);
 #endif /* CONFIG_USERFAULTFD */
 bool hugetlb_reserve_pages(struct inode *inode, long from, long to,
 						struct vm_area_struct *vma,
@@ -397,7 +397,7 @@ static inline int hugetlb_mfill_atomic_p
 					   unsigned long dst_addr,
 					   unsigned long src_addr,
 					   uffd_flags_t flags,
-					   struct page **pagep)
+					   struct folio **foliop)
 {
 	BUG();
 	return 0;
--- a/mm/hugetlb.c~userfaultfd-convert-mfill_atomic_hugetlb-to-use-a-folio
+++ a/mm/hugetlb.c
@@ -6178,7 +6178,7 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_
 			     unsigned long dst_addr,
 			     unsigned long src_addr,
 			     uffd_flags_t flags,
-			     struct page **pagep)
+			     struct folio **foliop)
 {
 	struct mm_struct *dst_mm = dst_vma->vm_mm;
 	bool is_continue = uffd_flags_mode_is(flags, MFILL_ATOMIC_CONTINUE);
@@ -6201,8 +6201,8 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_
 		if (IS_ERR(folio))
 			goto out;
 		folio_in_pagecache = true;
-	} else if (!*pagep) {
-		/* If a page already exists, then it's UFFDIO_COPY for
+	} else if (!*foliop) {
+		/* If a folio already exists, then it's UFFDIO_COPY for
 		 * a non-missing case. Return -EEXIST.
 		 */
 		if (vm_shared &&
@@ -6237,33 +6237,33 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_
 				ret = -ENOMEM;
 				goto out;
 			}
-			*pagep = &folio->page;
-			/* Set the outparam pagep and return to the caller to
+			*foliop = folio;
+			/* Set the outparam foliop and return to the caller to
 			 * copy the contents outside the lock. Don't free the
-			 * page.
+			 * folio.
 			 */
 			goto out;
 		}
 	} else {
 		if (vm_shared &&
 		    hugetlbfs_pagecache_present(h, dst_vma, dst_addr)) {
-			put_page(*pagep);
+			folio_put(*foliop);
 			ret = -EEXIST;
-			*pagep = NULL;
+			*foliop = NULL;
 			goto out;
 		}
 
 		folio = alloc_hugetlb_folio(dst_vma, dst_addr, 0);
 		if (IS_ERR(folio)) {
-			put_page(*pagep);
+			folio_put(*foliop);
 			ret = -ENOMEM;
-			*pagep = NULL;
+			*foliop = NULL;
 			goto out;
 		}
-		copy_user_huge_page(&folio->page, *pagep, dst_addr, dst_vma,
+		copy_user_huge_page(&folio->page, &(*foliop)->page, dst_addr, dst_vma,
 				    pages_per_huge_page(h));
-		put_page(*pagep);
-		*pagep = NULL;
+		folio_put(*foliop);
+		*foliop = NULL;
 	}
 
 	/*
--- a/mm/userfaultfd.c~userfaultfd-convert-mfill_atomic_hugetlb-to-use-a-folio
+++ a/mm/userfaultfd.c
@@ -322,7 +322,7 @@ static __always_inline ssize_t mfill_ato
 	pte_t *dst_pte;
 	unsigned long src_addr, dst_addr;
 	long copied;
-	struct page *page;
+	struct folio *folio;
 	unsigned long vma_hpagesize;
 	pgoff_t idx;
 	u32 hash;
@@ -342,7 +342,7 @@ static __always_inline ssize_t mfill_ato
 	src_addr = src_start;
 	dst_addr = dst_start;
 	copied = 0;
-	page = NULL;
+	folio = NULL;
 	vma_hpagesize = vma_kernel_pagesize(dst_vma);
 
 	/*
@@ -411,7 +411,7 @@ retry:
 		}
 
 		err = hugetlb_mfill_atomic_pte(dst_pte, dst_vma, dst_addr,
-					       src_addr, flags, &page);
+					       src_addr, flags, &folio);
 
 		hugetlb_vma_unlock_read(dst_vma);
 		mutex_unlock(&hugetlb_fault_mutex_table[hash]);
@@ -420,9 +420,9 @@ retry:
 
 		if (unlikely(err == -ENOENT)) {
 			mmap_read_unlock(dst_mm);
-			BUG_ON(!page);
+			BUG_ON(!folio);
 
-			err = copy_folio_from_user(page_folio(page),
+			err = copy_folio_from_user(folio,
 						   (const void __user *)src_addr, true);
 			if (unlikely(err)) {
 				err = -EFAULT;
@@ -433,7 +433,7 @@ retry:
 			dst_vma = NULL;
 			goto retry;
 		} else
-			BUG_ON(page);
+			BUG_ON(folio);
 
 		if (!err) {
 			dst_addr += vma_hpagesize;
@@ -450,8 +450,8 @@ retry:
 out_unlock:
 	mmap_read_unlock(dst_mm);
 out:
-	if (page)
-		put_page(page);
+	if (folio)
+		folio_put(folio);
 	BUG_ON(copied < 0);
 	BUG_ON(err > 0);
 	BUG_ON(!copied && !err);
_

Patches currently in -mm which might be from zhangpeng362@huawei.com are

userfaultfd-convert-mfill_atomic_pte_copy-to-use-a-folio.patch
userfaultfd-use-kmap_local_page-in-copy_huge_page_from_user.patch
userfaultfd-convert-copy_huge_page_from_user-to-copy_folio_from_user.patch
userfaultfd-convert-mfill_atomic_hugetlb-to-use-a-folio.patch
mm-convert-copy_user_huge_page-to-copy_user_folio.patch
userfaultfd-convert-mfill_atomic-to-use-a-folio.patch

