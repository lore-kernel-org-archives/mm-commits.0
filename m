Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 354AAC433F5
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:06:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbiJCVF5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:05:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229730AbiJCVFN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:05:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71B2EF5AE
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:04:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1C284B811BF
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:04:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2742C433D7;
        Mon,  3 Oct 2022 21:04:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831095;
        bh=rjF0ZHRwk0RRrHibJlp8ghSmUmPnK4lOIg11Cb/Bmzc=;
        h=Date:To:From:Subject:From;
        b=rZD72Tylhr6AAcjixJwFZrwQ5uUI/rgR3EJhj6Hgz3wT3s3Qk7VsL4kUYYfyldvB1
         dcP4gtDPcZ/Dw3t7hMzVEPLm9pXADvhqJfDjUq/ARFrPP+MemIn0Hkk51HGp6x6Cvq
         iJtAJIb597Dh6qbhzN9VIY5uNyFmbck1zTFquX4M=
Date:   Mon, 03 Oct 2022 14:04:55 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] shmem-convert-shmem_mfill_atomic_pte-to-use-a-folio.patch removed from -mm tree
Message-Id: <20221003210455.B2742C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: shmem: convert shmem_mfill_atomic_pte() to use a folio
has been removed from the -mm tree.  Its filename was
     shmem-convert-shmem_mfill_atomic_pte-to-use-a-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: shmem: convert shmem_mfill_atomic_pte() to use a folio
Date: Fri, 2 Sep 2022 20:46:13 +0100

Assert that this is a single-page folio as there are several assumptions
in here that it's exactly PAGE_SIZE bytes large.  Saves several calls to
compound_head() and removes the last caller of shmem_alloc_page().

Link: https://lkml.kernel.org/r/20220902194653.1739778-18-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   45 +++++++++++++++++++--------------------------
 1 file changed, 19 insertions(+), 26 deletions(-)

--- a/mm/shmem.c~shmem-convert-shmem_mfill_atomic_pte-to-use-a-folio
+++ a/mm/shmem.c
@@ -2374,12 +2374,6 @@ static struct inode *shmem_get_inode(str
 }
 
 #ifdef CONFIG_USERFAULTFD
-static struct page *shmem_alloc_page(gfp_t gfp,
-			struct shmem_inode_info *info, pgoff_t index)
-{
-	return &shmem_alloc_folio(gfp, info, index)->page;
-}
-
 int shmem_mfill_atomic_pte(struct mm_struct *dst_mm,
 			   pmd_t *dst_pmd,
 			   struct vm_area_struct *dst_vma,
@@ -2395,7 +2389,6 @@ int shmem_mfill_atomic_pte(struct mm_str
 	pgoff_t pgoff = linear_page_index(dst_vma, dst_addr);
 	void *page_kaddr;
 	struct folio *folio;
-	struct page *page;
 	int ret;
 	pgoff_t max_off;
 
@@ -2414,53 +2407,53 @@ int shmem_mfill_atomic_pte(struct mm_str
 
 	if (!*pagep) {
 		ret = -ENOMEM;
-		page = shmem_alloc_page(gfp, info, pgoff);
-		if (!page)
+		folio = shmem_alloc_folio(gfp, info, pgoff);
+		if (!folio)
 			goto out_unacct_blocks;
 
 		if (!zeropage) {	/* COPY */
-			page_kaddr = kmap_atomic(page);
+			page_kaddr = kmap_local_folio(folio, 0);
 			ret = copy_from_user(page_kaddr,
 					     (const void __user *)src_addr,
 					     PAGE_SIZE);
-			kunmap_atomic(page_kaddr);
+			kunmap_local(page_kaddr);
 
 			/* fallback to copy_from_user outside mmap_lock */
 			if (unlikely(ret)) {
-				*pagep = page;
+				*pagep = &folio->page;
 				ret = -ENOENT;
 				/* don't free the page */
 				goto out_unacct_blocks;
 			}
 
-			flush_dcache_page(page);
+			flush_dcache_folio(folio);
 		} else {		/* ZEROPAGE */
-			clear_user_highpage(page, dst_addr);
+			clear_user_highpage(&folio->page, dst_addr);
 		}
 	} else {
-		page = *pagep;
+		folio = page_folio(*pagep);
+		VM_BUG_ON_FOLIO(folio_test_large(folio), folio);
 		*pagep = NULL;
 	}
 
-	VM_BUG_ON(PageLocked(page));
-	VM_BUG_ON(PageSwapBacked(page));
-	__SetPageLocked(page);
-	__SetPageSwapBacked(page);
-	__SetPageUptodate(page);
+	VM_BUG_ON(folio_test_locked(folio));
+	VM_BUG_ON(folio_test_swapbacked(folio));
+	__folio_set_locked(folio);
+	__folio_set_swapbacked(folio);
+	__folio_mark_uptodate(folio);
 
 	ret = -EFAULT;
 	max_off = DIV_ROUND_UP(i_size_read(inode), PAGE_SIZE);
 	if (unlikely(pgoff >= max_off))
 		goto out_release;
 
-	folio = page_folio(page);
 	ret = shmem_add_to_page_cache(folio, mapping, pgoff, NULL,
 				      gfp & GFP_RECLAIM_MASK, dst_mm);
 	if (ret)
 		goto out_release;
 
 	ret = mfill_atomic_install_pte(dst_mm, dst_pmd, dst_vma, dst_addr,
-				       page, true, wp_copy);
+				       &folio->page, true, wp_copy);
 	if (ret)
 		goto out_delete_from_cache;
 
@@ -2470,13 +2463,13 @@ int shmem_mfill_atomic_pte(struct mm_str
 	shmem_recalc_inode(inode);
 	spin_unlock_irq(&info->lock);
 
-	unlock_page(page);
+	folio_unlock(folio);
 	return 0;
 out_delete_from_cache:
-	delete_from_page_cache(page);
+	filemap_remove_folio(folio);
 out_release:
-	unlock_page(page);
-	put_page(page);
+	folio_unlock(folio);
+	folio_put(folio);
 out_unacct_blocks:
 	shmem_inode_unacct_blocks(inode, 1);
 	return ret;
_

Patches currently in -mm which might be from willy@infradead.org are


