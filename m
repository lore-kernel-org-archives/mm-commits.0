Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 259EFC77B7C
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 23:36:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231623AbjDRXf7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 19:35:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231644AbjDRXew (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 19:34:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E87F28A7A
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 16:34:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8777A634A5
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 23:34:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB6EAC433EF;
        Tue, 18 Apr 2023 23:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681860875;
        bh=iMiTa3oJIZn15IdU5uc3kTGg0QrQ4FARGJy09sEusZ4=;
        h=Date:To:From:Subject:From;
        b=SH7edFp+MDmEEkCL1b0rbeABzeF/YmjEg81aNLWAk8WyXExxU/wJa5kpgNpmQ7c5o
         W4pgZBBzqqsJnlV5fdpnEhu/BqcNpDMQDQSjaVsaS5gcpWJXA22goJRoUXRouBJxRz
         hWv9Kp/2u3TkD9A9V51Ozp6bx09wOjASlHaOeZLI=
Date:   Tue, 18 Apr 2023 16:34:34 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        wangkefeng.wang@huawei.com, vishal.moola@gmail.com,
        sunnanyong@huawei.com, sidhartha.kumar@oracle.com,
        muchun.song@linux.dev, mike.kravetz@oracle.com,
        zhangpeng362@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] userfaultfd-convert-mfill_atomic-to-use-a-folio.patch removed from -mm tree
Message-Id: <20230418233434.DB6EAC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: userfaultfd: convert mfill_atomic() to use a folio
has been removed from the -mm tree.  Its filename was
     userfaultfd-convert-mfill_atomic-to-use-a-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: ZhangPeng <zhangpeng362@huawei.com>
Subject: userfaultfd: convert mfill_atomic() to use a folio
Date: Mon, 10 Apr 2023 21:39:32 +0800

Convert mfill_atomic_pte_copy(), shmem_mfill_atomic_pte() and
mfill_atomic_pte() to take in a folio pointer.

Convert mfill_atomic() to use a folio.  Convert page_kaddr to kaddr in
mfill_atomic().

Link: https://lkml.kernel.org/r/20230410133932.32288-7-zhangpeng362@huawei.com
Signed-off-by: ZhangPeng <zhangpeng362@huawei.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Matthew Wilcox <willy@infradead.org>
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
@@ -165,10 +165,10 @@ extern int shmem_mfill_atomic_pte(pmd_t
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
@@ -2433,7 +2433,7 @@ int shmem_mfill_atomic_pte(pmd_t *dst_pm
 			   unsigned long dst_addr,
 			   unsigned long src_addr,
 			   uffd_flags_t flags,
-			   struct page **pagep)
+			   struct folio **foliop)
 {
 	struct inode *inode = file_inode(dst_vma->vm_file);
 	struct shmem_inode_info *info = SHMEM_I(inode);
@@ -2451,14 +2451,14 @@ int shmem_mfill_atomic_pte(pmd_t *dst_pm
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
@@ -2490,7 +2490,7 @@ int shmem_mfill_atomic_pte(pmd_t *dst_pm
 
 			/* fallback to copy_from_user outside mmap_lock */
 			if (unlikely(ret)) {
-				*pagep = &folio->page;
+				*foliop = folio;
 				ret = -ENOENT;
 				/* don't free the page */
 				goto out_unacct_blocks;
@@ -2501,9 +2501,9 @@ int shmem_mfill_atomic_pte(pmd_t *dst_pm
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
@@ -171,15 +171,15 @@ static int mfill_atomic_pte_copy(pmd_t *
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
-		*pagep = NULL;
+		folio = *foliop;
+		*foliop = NULL;
 	}
 
 	/*
@@ -470,7 +470,7 @@ static __always_inline ssize_t mfill_ato
 						unsigned long dst_addr,
 						unsigned long src_addr,
 						uffd_flags_t flags,
-						struct page **pagep)
+						struct folio **foliop)
 {
 	ssize_t err;
 
@@ -493,14 +493,14 @@ static __always_inline ssize_t mfill_ato
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
@@ -518,7 +518,7 @@ static __always_inline ssize_t mfill_ato
 	pmd_t *dst_pmd;
 	unsigned long src_addr, dst_addr;
 	long copied;
-	struct page *page;
+	struct folio *folio;
 
 	/*
 	 * Sanitize the command parameters:
@@ -533,7 +533,7 @@ static __always_inline ssize_t mfill_ato
 	src_addr = src_start;
 	dst_addr = dst_start;
 	copied = 0;
-	page = NULL;
+	folio = NULL;
 retry:
 	mmap_read_lock(dst_mm);
 
@@ -629,28 +629,28 @@ retry:
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
@@ -667,8 +667,8 @@ retry:
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

userfaultfd-use-helper-function-range_in_vma.patch

