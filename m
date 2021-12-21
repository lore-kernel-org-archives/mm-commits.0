Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31AE7C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 21 Dec 2021 22:54:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234486AbhLUWyO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 21 Dec 2021 17:54:14 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:58206 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229732AbhLUWyO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 21 Dec 2021 17:54:14 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5034BB81A24
        for <mm-commits@vger.kernel.org>; Tue, 21 Dec 2021 22:54:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D00CBC36AE9;
        Tue, 21 Dec 2021 22:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1640127252;
        bh=VC/CVkNQ6Ocll9xvy69hOHsLXF6Nn960yxuAJ7qI9jE=;
        h=Date:From:To:Subject:From;
        b=niTRHV2e5oXJQlIJ14rXpFmNzQQoDVbsjhsQD51WzcoGfYqZaInc8Pk2vZWfE979Z
         GvHRkfJvSuAMV7o/sBfoeDtMXI2SuiQOsXBC1cYzuqpLzFHPAMF5EIeNuCEHAjhTx1
         izv3QhXCsh8RDieBWexkAC6KM/mmL2vzw6UXoAmM=
Date:   Tue, 21 Dec 2021 14:54:11 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, william.kucharski@oracle.com,
        torvalds@linux-foundation.org, david@redhat.com,
        willy@infradead.org
Subject:  + mm-remove-last-argument-of-reuse_swap_page.patch added to
 -mm tree
Message-ID: <20211221225411.bWV5L%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove last argument of reuse_swap_page()
has been added to the -mm tree.  Its filename is
     mm-remove-last-argument-of-reuse_swap_page.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-remove-last-argument-of-reuse_swap_page.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-remove-last-argument-of-reuse_swap_page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: remove last argument of reuse_swap_page()

None of the callers care about the total_map_swapcount() any more.

Link: https://lkml.kernel.org/r/20211220205943.456187-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Reviewed-by: William Kucharski <william.kucharski@oracle.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    6 +++---
 mm/huge_memory.c     |    2 +-
 mm/khugepaged.c      |    2 +-
 mm/memory.c          |    2 +-
 mm/swapfile.c        |    8 +-------
 5 files changed, 7 insertions(+), 13 deletions(-)

--- a/include/linux/swap.h~mm-remove-last-argument-of-reuse_swap_page
+++ a/include/linux/swap.h
@@ -514,7 +514,7 @@ extern int __swp_swapcount(swp_entry_t e
 extern int swp_swapcount(swp_entry_t entry);
 extern struct swap_info_struct *page_swap_info(struct page *);
 extern struct swap_info_struct *swp_swap_info(swp_entry_t entry);
-extern bool reuse_swap_page(struct page *, int *);
+extern bool reuse_swap_page(struct page *);
 extern int try_to_free_swap(struct page *);
 struct backing_dev_info;
 extern int init_swap_address_space(unsigned int type, unsigned long nr_pages);
@@ -680,8 +680,8 @@ static inline int swp_swapcount(swp_entr
 	return 0;
 }
 
-#define reuse_swap_page(page, total_map_swapcount) \
-	(page_trans_huge_mapcount(page, total_map_swapcount) == 1)
+#define reuse_swap_page(page) \
+	(page_trans_huge_mapcount(page, NULL) == 1)
 
 static inline int try_to_free_swap(struct page *page)
 {
--- a/mm/huge_memory.c~mm-remove-last-argument-of-reuse_swap_page
+++ a/mm/huge_memory.c
@@ -1322,7 +1322,7 @@ vm_fault_t do_huge_pmd_wp_page(struct vm
 	 * We can only reuse the page if nobody else maps the huge page or it's
 	 * part.
 	 */
-	if (reuse_swap_page(page, NULL)) {
+	if (reuse_swap_page(page)) {
 		pmd_t entry;
 		entry = pmd_mkyoung(orig_pmd);
 		entry = maybe_pmd_mkwrite(pmd_mkdirty(entry), vma);
--- a/mm/khugepaged.c~mm-remove-last-argument-of-reuse_swap_page
+++ a/mm/khugepaged.c
@@ -681,7 +681,7 @@ static int __collapse_huge_page_isolate(
 			goto out;
 		}
 		if (!pte_write(pteval) && PageSwapCache(page) &&
-				!reuse_swap_page(page, NULL)) {
+				!reuse_swap_page(page)) {
 			/*
 			 * Page is in the swap cache and cannot be re-used.
 			 * It cannot be collapsed into a THP.
--- a/mm/memory.c~mm-remove-last-argument-of-reuse_swap_page
+++ a/mm/memory.c
@@ -3627,7 +3627,7 @@ vm_fault_t do_swap_page(struct vm_fault
 	inc_mm_counter_fast(vma->vm_mm, MM_ANONPAGES);
 	dec_mm_counter_fast(vma->vm_mm, MM_SWAPENTS);
 	pte = mk_pte(page, vma->vm_page_prot);
-	if ((vmf->flags & FAULT_FLAG_WRITE) && reuse_swap_page(page, NULL)) {
+	if ((vmf->flags & FAULT_FLAG_WRITE) && reuse_swap_page(page)) {
 		pte = maybe_mkwrite(pte_mkdirty(pte), vma);
 		vmf->flags &= ~FAULT_FLAG_WRITE;
 		ret |= VM_FAULT_WRITE;
--- a/mm/swapfile.c~mm-remove-last-argument-of-reuse_swap_page
+++ a/mm/swapfile.c
@@ -1668,12 +1668,8 @@ static int page_trans_huge_map_swapcount
  * to it.  And as a side-effect, free up its swap: because the old content
  * on disk will never be read, and seeking back there to write new content
  * later would only waste time away from clustering.
- *
- * NOTE: total_map_swapcount should not be relied upon by the caller if
- * reuse_swap_page() returns false, but it may be always overwritten
- * (see the other implementation for CONFIG_SWAP=n).
  */
-bool reuse_swap_page(struct page *page, int *total_map_swapcount)
+bool reuse_swap_page(struct page *page)
 {
 	int count, total_mapcount, total_swapcount;
 
@@ -1682,8 +1678,6 @@ bool reuse_swap_page(struct page *page,
 		return false;
 	count = page_trans_huge_map_swapcount(page, &total_mapcount,
 					      &total_swapcount);
-	if (total_map_swapcount)
-		*total_map_swapcount = total_mapcount + total_swapcount;
 	if (count == 1 && PageSwapCache(page) &&
 	    (likely(!PageTransCompound(page)) ||
 	     /* The remaining swap count will be freed soon */
_

Patches currently in -mm which might be from willy@infradead.org are

mmfs-split-dump_mapping-out-from-dump_page.patch
mm-remove-last-argument-of-reuse_swap_page.patch
mm-remove-the-total_mapcount-argument-from-page_trans_huge_map_swapcount.patch
mm-remove-the-total_mapcount-argument-from-page_trans_huge_mapcount.patch

