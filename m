Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6847EC77B60
	for <mm-commits@archiver.kernel.org>; Fri, 31 Mar 2023 22:09:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232039AbjCaWJb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 31 Mar 2023 18:09:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233195AbjCaWJY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 31 Mar 2023 18:09:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFA6CEC4B
        for <mm-commits@vger.kernel.org>; Fri, 31 Mar 2023 15:09:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 860FA62C47
        for <mm-commits@vger.kernel.org>; Fri, 31 Mar 2023 22:09:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEFF8C433D2;
        Fri, 31 Mar 2023 22:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680300561;
        bh=/t8enhflG0tnbwjioAuUBC4oJckN6f2hJcAuZFjEuY0=;
        h=Date:To:From:Subject:From;
        b=BVar9O6iWP9zUciHTF+j3dlTrcfPys8EDsOmMUinDUM+zXqpIEpc5wadQLOFKPUbr
         Zo36ywhbIGxlrM6hukq5eqaSM91WgzQMCDzCfOG/PBTLFwYXe/9tFad0UenCrpOtQe
         hKPmHWt0OWtIRsdQCzEbaEF/+UHBqHjG8AZs2Ags=
Date:   Fri, 31 Mar 2023 15:09:20 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        wangkefeng.wang@huawei.com, vishal.moola@gmail.com,
        sunnanyong@huawei.com, sidhartha.kumar@oracle.com,
        muchun.song@linux.dev, mike.kravetz@oracle.com,
        zhangpeng362@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + userfaultfd-convert-mfill_atomic-to-use-a-folio.patch added to mm-unstable branch
Message-Id: <20230331220920.DEFF8C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: convert mfill_atomic() to use a folio
has been added to the -mm mm-unstable branch.  Its filename is
     userfaultfd-convert-mfill_atomic-to-use-a-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/userfaultfd-convert-mfill_atomic-to-use-a-folio.patch

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
Subject: userfaultfd: convert mfill_atomic() to use a folio
Date: Fri, 31 Mar 2023 17:39:37 +0800

Convert mfill_atomic_pte_copy(), shmem_mfill_atomic_pte() and
mfill_atomic_pte() to take in a folio pointer.  Convert mfill_atomic() to
use a folio.  Convert page_kaddr to kaddr in mfill_atomic().

Link: https://lkml.kernel.org/r/20230331093937.945725-7-zhangpeng362@huawei.com
Signed-off-by: ZhangPeng <zhangpeng362@huawei.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/shmem_fs.h |    4 +--
 mm/shmem.c               |   16 +++++++-------
 mm/userfaultfd.c         |   40 ++++++++++++++++++-------------------
 3 files changed, 30 insertions(+), 30 deletions(-)

--- a/include/linux/shmem_fs.h~userfaultfd-convert-mfill_atomic-to-use-a-folio
+++ a/include/linux/shmem_fs.h
@@ -158,10 +158,10 @@ extern int shmem_mfill_atomic_pte(pmd_t
 				  unsigned long dst_addr,
 				  unsigned long src_addr,
 				  uffd_flags_t flags,
-				  struct page **pagep);
+				  struct folio **foliop);
 #else /* !CONFIG_SHMEM */
 #define shmem_mfill_atomic_pte(dst_pmd, dst_vma, dst_addr, \
-			       src_addr, flags, pagep) ({ BUG(); 0; })
+			       src_addr, flags, foliop) ({ BUG(); 0; })
 #endif /* CONFIG_SHMEM */
 #endif /* CONFIG_USERFAULTFD */
 
--- a/mm/shmem.c~userfaultfd-convert-mfill_atomic-to-use-a-folio
+++ a/mm/shmem.c
@@ -2548,7 +2548,7 @@ int shmem_mfill_atomic_pte(pmd_t *dst_pm
 			   unsigned long dst_addr,
 			   unsigned long src_addr,
 			   uffd_flags_t flags,
-			   struct page **pagep)
+			   struct folio **foliop)
 {
 	struct inode *inode = file_inode(dst_vma->vm_file);
 	struct shmem_inode_info *info = SHMEM_I(inode);
@@ -2566,14 +2566,14 @@ int shmem_mfill_atomic_pte(pmd_t *dst_pm
 		 * and now we find ourselves with -ENOMEM. Release the page, to
 		 * avoid a BUG_ON in our caller.
 		 */
-		if (unlikely(*pagep)) {
-			put_page(*pagep);
-			*pagep = NULL;
+		if (unlikely(*foliop)) {
+			folio_put(*foliop);
+			*foliop = NULL;
 		}
 		return -ENOMEM;
 	}
 
-	if (!*pagep) {
+	if (!*foliop) {
 		ret = -ENOMEM;
 		folio = shmem_alloc_folio(gfp, info, pgoff);
 		if (!folio)
@@ -2605,7 +2605,7 @@ int shmem_mfill_atomic_pte(pmd_t *dst_pm
 
 			/* fallback to copy_from_user outside mmap_lock */
 			if (unlikely(ret)) {
-				*pagep = &folio->page;
+				*foliop = folio;
 				ret = -ENOENT;
 				/* don't free the page */
 				goto out_unacct_blocks;
@@ -2616,9 +2616,9 @@ int shmem_mfill_atomic_pte(pmd_t *dst_pm
 			clear_user_highpage(&folio->page, dst_addr);
 		}
 	} else {
-		folio = page_folio(*pagep);
+		folio = *foliop;
 		VM_BUG_ON_FOLIO(folio_test_large(folio), folio);
-		*pagep = NULL;
+		*foliop = NULL;
 	}
 
 	VM_BUG_ON(folio_test_locked(folio));
--- a/mm/userfaultfd.c~userfaultfd-convert-mfill_atomic-to-use-a-folio
+++ a/mm/userfaultfd.c
@@ -133,13 +133,13 @@ static int mfill_atomic_pte_copy(pmd_t *
 				 unsigned long dst_addr,
 				 unsigned long src_addr,
 				 uffd_flags_t flags,
-				 struct page **pagep)
+				 struct folio **foliop)
 {
 	void *kaddr;
 	int ret;
 	struct folio *folio;
 
-	if (!*pagep) {
+	if (!*foliop) {
 		ret = -ENOMEM;
 		folio = vma_alloc_folio(GFP_HIGHUSER_MOVABLE, 0, dst_vma,
 					dst_addr, false);
@@ -171,16 +171,16 @@ static int mfill_atomic_pte_copy(pmd_t *
 		/* fallback to copy_from_user outside mmap_lock */
 		if (unlikely(ret)) {
 			ret = -ENOENT;
-			*pagep = &folio->page;
+			*foliop = folio;
 			/* don't free the page */
 			goto out;
 		}
 
 		flush_dcache_folio(folio);
 	} else {
-		folio = page_folio(*pagep);
+		folio = *foliop;
 		VM_BUG_ON_FOLIO(folio_test_large(folio), folio);
-		*pagep = NULL;
+		*foliop = NULL;
 	}
 
 	/*
@@ -471,7 +471,7 @@ static __always_inline ssize_t mfill_ato
 						unsigned long dst_addr,
 						unsigned long src_addr,
 						uffd_flags_t flags,
-						struct page **pagep)
+						struct folio **foliop)
 {
 	ssize_t err;
 
@@ -494,14 +494,14 @@ static __always_inline ssize_t mfill_ato
 		if (uffd_flags_mode_is(flags, MFILL_ATOMIC_COPY))
 			err = mfill_atomic_pte_copy(dst_pmd, dst_vma,
 						    dst_addr, src_addr,
-						    flags, pagep);
+						    flags, foliop);
 		else
 			err = mfill_atomic_pte_zeropage(dst_pmd,
 						 dst_vma, dst_addr);
 	} else {
 		err = shmem_mfill_atomic_pte(dst_pmd, dst_vma,
 					     dst_addr, src_addr,
-					     flags, pagep);
+					     flags, foliop);
 	}
 
 	return err;
@@ -519,7 +519,7 @@ static __always_inline ssize_t mfill_ato
 	pmd_t *dst_pmd;
 	unsigned long src_addr, dst_addr;
 	long copied;
-	struct page *page;
+	struct folio *folio;
 
 	/*
 	 * Sanitize the command parameters:
@@ -534,7 +534,7 @@ static __always_inline ssize_t mfill_ato
 	src_addr = src_start;
 	dst_addr = dst_start;
 	copied = 0;
-	page = NULL;
+	folio = NULL;
 retry:
 	mmap_read_lock(dst_mm);
 
@@ -630,28 +630,28 @@ retry:
 		BUG_ON(pmd_trans_huge(*dst_pmd));
 
 		err = mfill_atomic_pte(dst_pmd, dst_vma, dst_addr,
-				       src_addr, flags, &page);
+				       src_addr, flags, &folio);
 		cond_resched();
 
 		if (unlikely(err == -ENOENT)) {
-			void *page_kaddr;
+			void *kaddr;
 
 			mmap_read_unlock(dst_mm);
-			BUG_ON(!page);
+			BUG_ON(!folio);
 
-			page_kaddr = kmap_local_page(page);
-			err = copy_from_user(page_kaddr,
+			kaddr = kmap_local_folio(folio, 0);
+			err = copy_from_user(kaddr,
 					     (const void __user *) src_addr,
 					     PAGE_SIZE);
-			kunmap_local(page_kaddr);
+			kunmap_local(kaddr);
 			if (unlikely(err)) {
 				err = -EFAULT;
 				goto out;
 			}
-			flush_dcache_page(page);
+			flush_dcache_folio(folio);
 			goto retry;
 		} else
-			BUG_ON(page);
+			BUG_ON(folio);
 
 		if (!err) {
 			dst_addr += PAGE_SIZE;
@@ -668,8 +668,8 @@ retry:
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

