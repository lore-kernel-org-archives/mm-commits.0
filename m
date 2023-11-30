Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71A96C4167B
	for <mm-commits@archiver.kernel.org>; Thu, 30 Nov 2023 22:26:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235171AbjK3W0M (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 30 Nov 2023 17:26:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230203AbjK3W0L (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 30 Nov 2023 17:26:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B61410DC
        for <mm-commits@vger.kernel.org>; Thu, 30 Nov 2023 14:26:18 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0DE5C433C8;
        Thu, 30 Nov 2023 22:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701383177;
        bh=EFTTvE8HIfCyX7OjfNU6RG2JAEq2itvGnPwb1Mgiw0w=;
        h=Date:To:From:Subject:From;
        b=wHzzH6akzIZpMymT7CCuNl9K+AsqVI6jLMDDHI6ZfYmiw8lNl+DZasce2I5vhaNL8
         RyRltT2xhPJQWAJUTuOpZGaH7hROhy3wGx4Pw48OaEr8Shf9eGXZvSWsVKtD+tyfKd
         /nfQbwutm5oVLQ3wjQl9et7mz0IRhVbTEqWTCTX0=
Date:   Thu, 30 Nov 2023 14:26:16 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        vishal.moola@gmail.com, sidhartha.kumar@oracle.com,
        david@redhat.com, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-ksm-use-more-folio-api-in-ksm_might_need_to_copy.patch added to mm-unstable branch
Message-Id: <20231130222617.A0DE5C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: ksm: use more folio api in ksm_might_need_to_copy()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-ksm-use-more-folio-api-in-ksm_might_need_to_copy.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-ksm-use-more-folio-api-in-ksm_might_need_to_copy.patch

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
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: ksm: use more folio api in ksm_might_need_to_copy()
Date: Sat, 18 Nov 2023 10:32:28 +0800

Patch series "mm: cleanup and use more folio in page fault", v3.

Rename page_copy_prealloc() to folio_prealloc(), which is used by more
functions, also do more folio conversion in page fault.


This patch (of 5):

Since ksm only support normal page, no swapout/in for ksm large folio too,
add large folio check in ksm_might_need_to_copy(), also convert
page->index to folio->index as page->index is going away.

Then convert ksm_might_need_to_copy() to use more folio api to save nine
compound_head() calls, short 'address' to reduce max-line-length.

Link: https://lkml.kernel.org/r/20231118023232.1409103-1-wangkefeng.wang@huawei.com
Link: https://lkml.kernel.org/r/20231118023232.1409103-2-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ksm.h |    4 ++--
 mm/ksm.c            |   39 +++++++++++++++++++++------------------
 2 files changed, 23 insertions(+), 20 deletions(-)

--- a/include/linux/ksm.h~mm-ksm-use-more-folio-api-in-ksm_might_need_to_copy
+++ a/include/linux/ksm.h
@@ -77,7 +77,7 @@ static inline void ksm_exit(struct mm_st
  * but what if the vma was unmerged while the page was swapped out?
  */
 struct page *ksm_might_need_to_copy(struct page *page,
-			struct vm_area_struct *vma, unsigned long address);
+			struct vm_area_struct *vma, unsigned long addr);
 
 void rmap_walk_ksm(struct folio *folio, struct rmap_walk_control *rwc);
 void folio_migrate_ksm(struct folio *newfolio, struct folio *folio);
@@ -130,7 +130,7 @@ static inline int ksm_madvise(struct vm_
 }
 
 static inline struct page *ksm_might_need_to_copy(struct page *page,
-			struct vm_area_struct *vma, unsigned long address)
+			struct vm_area_struct *vma, unsigned long addr)
 {
 	return page;
 }
--- a/mm/ksm.c~mm-ksm-use-more-folio-api-in-ksm_might_need_to_copy
+++ a/mm/ksm.c
@@ -2876,48 +2876,51 @@ void __ksm_exit(struct mm_struct *mm)
 }
 
 struct page *ksm_might_need_to_copy(struct page *page,
-			struct vm_area_struct *vma, unsigned long address)
+			struct vm_area_struct *vma, unsigned long addr)
 {
 	struct folio *folio = page_folio(page);
 	struct anon_vma *anon_vma = folio_anon_vma(folio);
-	struct page *new_page;
+	struct folio *new_folio;
 
-	if (PageKsm(page)) {
-		if (page_stable_node(page) &&
+	if (folio_test_large(folio))
+		return page;
+
+	if (folio_test_ksm(folio)) {
+		if (folio_stable_node(folio) &&
 		    !(ksm_run & KSM_RUN_UNMERGE))
 			return page;	/* no need to copy it */
 	} else if (!anon_vma) {
 		return page;		/* no need to copy it */
-	} else if (page->index == linear_page_index(vma, address) &&
+	} else if (folio->index == linear_page_index(vma, addr) &&
 			anon_vma->root == vma->anon_vma->root) {
 		return page;		/* still no need to copy it */
 	}
 	if (PageHWPoison(page))
 		return ERR_PTR(-EHWPOISON);
-	if (!PageUptodate(page))
+	if (!folio_test_uptodate(folio))
 		return page;		/* let do_swap_page report the error */
 
-	new_page = alloc_page_vma(GFP_HIGHUSER_MOVABLE, vma, address);
-	if (new_page &&
-	    mem_cgroup_charge(page_folio(new_page), vma->vm_mm, GFP_KERNEL)) {
-		put_page(new_page);
-		new_page = NULL;
+	new_folio = vma_alloc_folio(GFP_HIGHUSER_MOVABLE, 0, vma, addr, false);
+	if (new_folio &&
+	    mem_cgroup_charge(new_folio, vma->vm_mm, GFP_KERNEL)) {
+		folio_put(new_folio);
+		new_folio = NULL;
 	}
-	if (new_page) {
-		if (copy_mc_user_highpage(new_page, page, address, vma)) {
-			put_page(new_page);
+	if (new_folio) {
+		if (copy_mc_user_highpage(&new_folio->page, page, addr, vma)) {
+			folio_put(new_folio);
 			memory_failure_queue(page_to_pfn(page), 0);
 			return ERR_PTR(-EHWPOISON);
 		}
-		SetPageDirty(new_page);
-		__SetPageUptodate(new_page);
-		__SetPageLocked(new_page);
+		folio_set_dirty(new_folio);
+		__folio_mark_uptodate(new_folio);
+		__folio_set_locked(new_folio);
 #ifdef CONFIG_SWAP
 		count_vm_event(KSM_SWPIN_COPY);
 #endif
 	}
 
-	return new_page;
+	return new_folio ? &new_folio->page : NULL;
 }
 
 void rmap_walk_ksm(struct folio *folio, struct rmap_walk_control *rwc)
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-ksm-use-more-folio-api-in-ksm_might_need_to_copy.patch
mm-memory-use-a-folio-in-validate_page_before_insert.patch
mm-memory-rename-page_copy_prealloc-to-folio_prealloc.patch
mm-memory-use-a-folio-in-do_cow_fault.patch
mm-memory-use-folio_prealloc-in-wp_page_copy.patch

