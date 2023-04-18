Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59790C77B76
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 23:35:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231520AbjDRXf5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 19:35:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231502AbjDRXew (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 19:34:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A5C3B449
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 16:34:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B59A262ED3
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 23:34:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13665C433EF;
        Tue, 18 Apr 2023 23:34:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681860871;
        bh=XUyWBOuDMgi2of82OJtpc/9gcYzm+nbphi8FdBVj4Fo=;
        h=Date:To:From:Subject:From;
        b=diYeoLG5EtXG8JLIqi1QAZYS9l9pvYzTqJnafYkuHzGyGCOvxu0tzD7iFHZ/8dBUG
         9GYPeS7E2OdbbT4O8C4gx6RQXvVHP3yxKBr0Nr9p3Lni/RZxuoABYNz9vzq+9M3r2L
         BZL15yZ1AoXKcf9Xy9iVr6657T7xvZbymxXOyjq0=
Date:   Tue, 18 Apr 2023 16:34:30 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        wangkefeng.wang@huawei.com, vishal.moola@gmail.com,
        sunnanyong@huawei.com, sidhartha.kumar@oracle.com,
        muchun.song@linux.dev, mike.kravetz@oracle.com,
        zhangpeng362@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] userfaultfd-convert-copy_huge_page_from_user-to-copy_folio_from_user.patch removed from -mm tree
Message-Id: <20230418233431.13665C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: userfaultfd: convert copy_huge_page_from_user() to copy_folio_from_user()
has been removed from the -mm tree.  Its filename was
     userfaultfd-convert-copy_huge_page_from_user-to-copy_folio_from_user.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: ZhangPeng <zhangpeng362@huawei.com>
Subject: userfaultfd: convert copy_huge_page_from_user() to copy_folio_from_user()
Date: Mon, 10 Apr 2023 21:39:29 +0800

Replace copy_huge_page_from_user() with copy_folio_from_user(). 
copy_folio_from_user() does the same as copy_huge_page_from_user(), but
takes in a folio instead of a page.

Convert page_kaddr to kaddr in copy_folio_from_user() to do indenting
cleanup.

Link: https://lkml.kernel.org/r/20230410133932.32288-4-zhangpeng362@huawei.com
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

 include/linux/mm.h |    7 +++----
 mm/hugetlb.c       |    5 ++---
 mm/memory.c        |   23 +++++++++++------------
 mm/userfaultfd.c   |    6 ++----
 4 files changed, 18 insertions(+), 23 deletions(-)

--- a/include/linux/mm.h~userfaultfd-convert-copy_huge_page_from_user-to-copy_folio_from_user
+++ a/include/linux/mm.h
@@ -3681,10 +3681,9 @@ extern void copy_user_huge_page(struct p
 				unsigned long addr_hint,
 				struct vm_area_struct *vma,
 				unsigned int pages_per_huge_page);
-extern long copy_huge_page_from_user(struct page *dst_page,
-				const void __user *usr_src,
-				unsigned int pages_per_huge_page,
-				bool allow_pagefault);
+long copy_folio_from_user(struct folio *dst_folio,
+			   const void __user *usr_src,
+			   bool allow_pagefault);
 
 /**
  * vma_is_special_huge - Are transhuge page-table entries considered special?
--- a/mm/hugetlb.c~userfaultfd-convert-copy_huge_page_from_user-to-copy_folio_from_user
+++ a/mm/hugetlb.c
@@ -6217,9 +6217,8 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_
 			goto out;
 		}
 
-		ret = copy_huge_page_from_user(&folio->page,
-						(const void __user *) src_addr,
-						pages_per_huge_page(h), false);
+		ret = copy_folio_from_user(folio, (const void __user *) src_addr,
+					   false);
 
 		/* fallback to copy_from_user outside mmap_lock */
 		if (unlikely(ret)) {
--- a/mm/memory.c~userfaultfd-convert-copy_huge_page_from_user-to-copy_folio_from_user
+++ a/mm/memory.c
@@ -5868,26 +5868,25 @@ void copy_user_huge_page(struct page *ds
 	process_huge_page(addr_hint, pages_per_huge_page, copy_subpage, &arg);
 }
 
-long copy_huge_page_from_user(struct page *dst_page,
-				const void __user *usr_src,
-				unsigned int pages_per_huge_page,
-				bool allow_pagefault)
+long copy_folio_from_user(struct folio *dst_folio,
+			   const void __user *usr_src,
+			   bool allow_pagefault)
 {
-	void *page_kaddr;
+	void *kaddr;
 	unsigned long i, rc = 0;
-	unsigned long ret_val = pages_per_huge_page * PAGE_SIZE;
+	unsigned int nr_pages = folio_nr_pages(dst_folio);
+	unsigned long ret_val = nr_pages * PAGE_SIZE;
 	struct page *subpage;
 
-	for (i = 0; i < pages_per_huge_page; i++) {
-		subpage = nth_page(dst_page, i);
-		page_kaddr = kmap_local_page(subpage);
+	for (i = 0; i < nr_pages; i++) {
+		subpage = folio_page(dst_folio, i);
+		kaddr = kmap_local_page(subpage);
 		if (!allow_pagefault)
 			pagefault_disable();
-		rc = copy_from_user(page_kaddr,
-				usr_src + i * PAGE_SIZE, PAGE_SIZE);
+		rc = copy_from_user(kaddr, usr_src + i * PAGE_SIZE, PAGE_SIZE);
 		if (!allow_pagefault)
 			pagefault_enable();
-		kunmap_local(page_kaddr);
+		kunmap_local(kaddr);
 
 		ret_val -= (PAGE_SIZE - rc);
 		if (rc)
--- a/mm/userfaultfd.c~userfaultfd-convert-copy_huge_page_from_user-to-copy_folio_from_user
+++ a/mm/userfaultfd.c
@@ -421,10 +421,8 @@ retry:
 			mmap_read_unlock(dst_mm);
 			BUG_ON(!page);
 
-			err = copy_huge_page_from_user(page,
-						(const void __user *)src_addr,
-						vma_hpagesize / PAGE_SIZE,
-						true);
+			err = copy_folio_from_user(page_folio(page),
+						   (const void __user *)src_addr, true);
 			if (unlikely(err)) {
 				err = -EFAULT;
 				goto out;
_

Patches currently in -mm which might be from zhangpeng362@huawei.com are

userfaultfd-convert-mfill_atomic_hugetlb-to-use-a-folio.patch
mm-convert-copy_user_huge_page-to-copy_user_large_folio.patch
userfaultfd-convert-mfill_atomic-to-use-a-folio.patch
userfaultfd-use-helper-function-range_in_vma.patch

