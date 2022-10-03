Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5292AC433F5
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:06:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbiJCVGF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:06:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbiJCVFb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:05:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B673513E95
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:05:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6CB30B81123
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:05:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28D55C433D7;
        Mon,  3 Oct 2022 21:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831100;
        bh=uD0LxtSl+PubF3Wgsxclc4o8UDznI6jB+oI5YcjADrU=;
        h=Date:To:From:Subject:From;
        b=gFozu9UOg4yDAdPWMnj2Be14CAaFMANpvOv2/huQ6hao9/z7rLQ4tuGL/YMsgRK5O
         b3w2pkxZEFMjoybRUtYugn7BI9lZZHwO3nnPhvMQAAt/m8JOMdaNDhT+lf1M3k5UnJ
         Pu6ptaU8sCCuu+I2+86cpPtpgdXnTdFykLR3/cpg=
Date:   Mon, 03 Oct 2022 14:04:59 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] shmem-convert-shmem_getpage_gfp-to-shmem_get_folio_gfp.patch removed from -mm tree
Message-Id: <20221003210500.28D55C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: shmem: convert shmem_getpage_gfp() to shmem_get_folio_gfp()
has been removed from the -mm tree.  Its filename was
     shmem-convert-shmem_getpage_gfp-to-shmem_get_folio_gfp.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: shmem: convert shmem_getpage_gfp() to shmem_get_folio_gfp()
Date: Fri, 2 Sep 2022 20:46:17 +0100

Add a shmem_getpage_gfp() wrapper for compatibility with current users.

Link: https://lkml.kernel.org/r/20220902194653.1739778-22-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   70 +++++++++++++++++++++++++++++----------------------
 1 file changed, 41 insertions(+), 29 deletions(-)

--- a/mm/shmem.c~shmem-convert-shmem_getpage_gfp-to-shmem_get_folio_gfp
+++ a/mm/shmem.c
@@ -139,17 +139,6 @@ static int shmem_swapin_folio(struct ino
 			     struct folio **foliop, enum sgp_type sgp,
 			     gfp_t gfp, struct vm_area_struct *vma,
 			     vm_fault_t *fault_type);
-static int shmem_getpage_gfp(struct inode *inode, pgoff_t index,
-		struct page **pagep, enum sgp_type sgp,
-		gfp_t gfp, struct vm_area_struct *vma,
-		struct vm_fault *vmf, vm_fault_t *fault_type);
-
-int shmem_getpage(struct inode *inode, pgoff_t index,
-		struct page **pagep, enum sgp_type sgp)
-{
-	return shmem_getpage_gfp(inode, index, pagep, sgp,
-		mapping_gfp_mask(inode->i_mapping), NULL, NULL, NULL);
-}
 
 static inline struct shmem_sb_info *SHMEM_SB(struct super_block *sb)
 {
@@ -1595,7 +1584,7 @@ failed:
 
 /*
  * When a page is moved from swapcache to shmem filecache (either by the
- * usual swapin of shmem_getpage_gfp(), or by the less common swapoff of
+ * usual swapin of shmem_get_folio_gfp(), or by the less common swapoff of
  * shmem_unuse_inode()), it may have been read in earlier from swap, in
  * ignorance of the mapping it belongs to.  If that mapping has special
  * constraints (like the gma500 GEM driver, which requires RAM below 4GB),
@@ -1812,7 +1801,7 @@ unlock:
 }
 
 /*
- * shmem_getpage_gfp - find page in cache, or get from swap, or allocate
+ * shmem_get_folio_gfp - find page in cache, or get from swap, or allocate
  *
  * If we allocate a new one we do not mark it dirty. That's up to the
  * vm. If we swap it in we mark it dirty since we also free the swap
@@ -1821,10 +1810,10 @@ unlock:
  * vma, vmf, and fault_type are only supplied by shmem_fault:
  * otherwise they are NULL.
  */
-static int shmem_getpage_gfp(struct inode *inode, pgoff_t index,
-	struct page **pagep, enum sgp_type sgp, gfp_t gfp,
-	struct vm_area_struct *vma, struct vm_fault *vmf,
-			vm_fault_t *fault_type)
+static int shmem_get_folio_gfp(struct inode *inode, pgoff_t index,
+		struct folio **foliop, enum sgp_type sgp, gfp_t gfp,
+		struct vm_area_struct *vma, struct vm_fault *vmf,
+		vm_fault_t *fault_type)
 {
 	struct address_space *mapping = inode->i_mapping;
 	struct shmem_inode_info *info = SHMEM_I(inode);
@@ -1864,7 +1853,7 @@ repeat:
 		if (error == -EEXIST)
 			goto repeat;
 
-		*pagep = &folio->page;
+		*foliop = folio;
 		return error;
 	}
 
@@ -1874,7 +1863,7 @@ repeat:
 			folio_mark_accessed(folio);
 		if (folio_test_uptodate(folio))
 			goto out;
-		/* fallocated page */
+		/* fallocated folio */
 		if (sgp != SGP_READ)
 			goto clear;
 		folio_unlock(folio);
@@ -1882,10 +1871,10 @@ repeat:
 	}
 
 	/*
-	 * SGP_READ: succeed on hole, with NULL page, letting caller zero.
-	 * SGP_NOALLOC: fail on hole, with NULL page, letting caller fail.
+	 * SGP_READ: succeed on hole, with NULL folio, letting caller zero.
+	 * SGP_NOALLOC: fail on hole, with NULL folio, letting caller fail.
 	 */
-	*pagep = NULL;
+	*foliop = NULL;
 	if (sgp == SGP_READ)
 		return 0;
 	if (sgp == SGP_NOALLOC)
@@ -1918,7 +1907,7 @@ alloc_nohuge:
 		if (error != -ENOSPC)
 			goto unlock;
 		/*
-		 * Try to reclaim some space by splitting a huge page
+		 * Try to reclaim some space by splitting a large folio
 		 * beyond i_size on the filesystem.
 		 */
 		while (retry--) {
@@ -1954,9 +1943,9 @@ alloc_nohuge:
 
 	if (folio_test_pmd_mappable(folio) &&
 	    DIV_ROUND_UP(i_size_read(inode), PAGE_SIZE) <
-			hindex + HPAGE_PMD_NR - 1) {
+					folio_next_index(folio) - 1) {
 		/*
-		 * Part of the huge page is beyond i_size: subject
+		 * Part of the large folio is beyond i_size: subject
 		 * to shrink under memory pressure.
 		 */
 		spin_lock(&sbinfo->shrinklist_lock);
@@ -1973,14 +1962,14 @@ alloc_nohuge:
 	}
 
 	/*
-	 * Let SGP_FALLOC use the SGP_WRITE optimization on a new page.
+	 * Let SGP_FALLOC use the SGP_WRITE optimization on a new folio.
 	 */
 	if (sgp == SGP_FALLOC)
 		sgp = SGP_WRITE;
 clear:
 	/*
-	 * Let SGP_WRITE caller clear ends if write does not fill page;
-	 * but SGP_FALLOC on a page fallocated earlier must initialize
+	 * Let SGP_WRITE caller clear ends if write does not fill folio;
+	 * but SGP_FALLOC on a folio fallocated earlier must initialize
 	 * it now, lest undo on failure cancel our earlier guarantee.
 	 */
 	if (sgp != SGP_WRITE && !folio_test_uptodate(folio)) {
@@ -2006,7 +1995,7 @@ clear:
 		goto unlock;
 	}
 out:
-	*pagep = folio_page(folio, index - hindex);
+	*foliop = folio;
 	return 0;
 
 	/*
@@ -2036,6 +2025,29 @@ unlock:
 	return error;
 }
 
+static int shmem_getpage_gfp(struct inode *inode, pgoff_t index,
+		struct page **pagep, enum sgp_type sgp,
+		gfp_t gfp, struct vm_area_struct *vma,
+		struct vm_fault *vmf, vm_fault_t *fault_type)
+{
+	struct folio *folio = NULL;
+	int ret = shmem_get_folio_gfp(inode, index, &folio, sgp, gfp, vma,
+			vmf, fault_type);
+
+	if (folio)
+		*pagep = folio_file_page(folio, index);
+	else
+		*pagep = NULL;
+	return ret;
+}
+
+int shmem_getpage(struct inode *inode, pgoff_t index,
+		struct page **pagep, enum sgp_type sgp)
+{
+	return shmem_getpage_gfp(inode, index, pagep, sgp,
+		mapping_gfp_mask(inode->i_mapping), NULL, NULL, NULL);
+}
+
 /*
  * This is like autoremove_wake_function, but it removes the wait queue
  * entry unconditionally - even if something else had already woken the
_

Patches currently in -mm which might be from willy@infradead.org are


