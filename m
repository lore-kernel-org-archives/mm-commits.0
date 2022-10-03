Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68D87C4332F
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:08:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229946AbiJCVIY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:08:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbiJCVGX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:06:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 680134D4CF
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:05:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 00D67611F0
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:05:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A0BBC433D6;
        Mon,  3 Oct 2022 21:05:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831141;
        bh=ys8ws6IaT6lZTdDPmVYBytdna7ALzkXcWG2VVIvEyHA=;
        h=Date:To:From:Subject:From;
        b=Go9gqRu2M7mMPNOdmyLZGMBJQSD3MeUDkJWj2j2AdUIpJNCVdIDiWFJMYw8wv0N2E
         4MpJ1kdoB1EjbiLUh+B0WlByHnHWsZ8Yjex8ILLGLfNS/HgPNSVh2UWYJQm+YccjBG
         Qr/EB8m91iJOE7bZJ9kmWsqUxrWnKocdF99B7Rz0=
Date:   Mon, 03 Oct 2022 14:05:40 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-convert-lock_page_or_retry-to-folio_lock_or_retry.patch removed from -mm tree
Message-Id: <20221003210541.5A0BBC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: convert lock_page_or_retry() to folio_lock_or_retry()
has been removed from the -mm tree.  Its filename was
     mm-convert-lock_page_or_retry-to-folio_lock_or_retry.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: convert lock_page_or_retry() to folio_lock_or_retry()
Date: Fri, 2 Sep 2022 20:46:53 +0100

Remove a call to compound_head() in each of the two callers.

Link: https://lkml.kernel.org/r/20220902194653.1739778-58-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |    9 +++------
 mm/memory.c             |   10 +++++-----
 2 files changed, 8 insertions(+), 11 deletions(-)

--- a/include/linux/pagemap.h~mm-convert-lock_page_or_retry-to-folio_lock_or_retry
+++ a/include/linux/pagemap.h
@@ -989,19 +989,16 @@ static inline int lock_page_killable(str
 }
 
 /*
- * lock_page_or_retry - Lock the page, unless this would block and the
+ * folio_lock_or_retry - Lock the folio, unless this would block and the
  * caller indicated that it can handle a retry.
  *
  * Return value and mmap_lock implications depend on flags; see
  * __folio_lock_or_retry().
  */
-static inline bool lock_page_or_retry(struct page *page, struct mm_struct *mm,
-				     unsigned int flags)
+static inline bool folio_lock_or_retry(struct folio *folio,
+		struct mm_struct *mm, unsigned int flags)
 {
-	struct folio *folio;
 	might_sleep();
-
-	folio = page_folio(page);
 	return folio_trylock(folio) || __folio_lock_or_retry(folio, mm, flags);
 }
 
--- a/mm/memory.c~mm-convert-lock_page_or_retry-to-folio_lock_or_retry
+++ a/mm/memory.c
@@ -3618,11 +3618,11 @@ EXPORT_SYMBOL(unmap_mapping_range);
  */
 static vm_fault_t remove_device_exclusive_entry(struct vm_fault *vmf)
 {
-	struct page *page = vmf->page;
+	struct folio *folio = page_folio(vmf->page);
 	struct vm_area_struct *vma = vmf->vma;
 	struct mmu_notifier_range range;
 
-	if (!lock_page_or_retry(page, vma->vm_mm, vmf->flags))
+	if (!folio_lock_or_retry(folio, vma->vm_mm, vmf->flags))
 		return VM_FAULT_RETRY;
 	mmu_notifier_range_init_owner(&range, MMU_NOTIFY_EXCLUSIVE, 0, vma,
 				vma->vm_mm, vmf->address & PAGE_MASK,
@@ -3632,10 +3632,10 @@ static vm_fault_t remove_device_exclusiv
 	vmf->pte = pte_offset_map_lock(vma->vm_mm, vmf->pmd, vmf->address,
 				&vmf->ptl);
 	if (likely(pte_same(*vmf->pte, vmf->orig_pte)))
-		restore_exclusive_pte(vma, page, vmf->address, vmf->pte);
+		restore_exclusive_pte(vma, vmf->page, vmf->address, vmf->pte);
 
 	pte_unmap_unlock(vmf->pte, vmf->ptl);
-	unlock_page(page);
+	folio_unlock(folio);
 
 	mmu_notifier_invalidate_range_end(&range);
 	return 0;
@@ -3835,7 +3835,7 @@ vm_fault_t do_swap_page(struct vm_fault
 		goto out_release;
 	}
 
-	locked = lock_page_or_retry(page, vma->vm_mm, vmf->flags);
+	locked = folio_lock_or_retry(folio, vma->vm_mm, vmf->flags);
 
 	if (!locked) {
 		ret |= VM_FAULT_RETRY;
_

Patches currently in -mm which might be from willy@infradead.org are


