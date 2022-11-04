Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F15BC433FE
	for <mm-commits@archiver.kernel.org>; Fri,  4 Nov 2022 22:53:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230075AbiKDWxm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 4 Nov 2022 18:53:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230450AbiKDWwr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 4 Nov 2022 18:52:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D15C449B60
        for <mm-commits@vger.kernel.org>; Fri,  4 Nov 2022 15:52:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 896B8B83020
        for <mm-commits@vger.kernel.org>; Fri,  4 Nov 2022 22:52:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29868C433D7;
        Fri,  4 Nov 2022 22:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667602359;
        bh=sy2sP4hv530k/YF4gCkwjJ2PHXB3FsICdrzj4lpVCxY=;
        h=Date:To:From:Subject:From;
        b=N1F/axsK3zKr6jun+4C7FI2WiNLzNcVXEM7Gyv+8DtslwXFuLcNAkRnXYAfDiaL5T
         9zeMoiJ4Qwqz4sSD57a1Z30T4mEtq/dnRogRFDmulMPrAoRA7cCqOCMRA339AB2ku/
         miGiFGgpS2cwYbhk+JyRaGR1X9+GN2LwB2XGfe7Y=
Date:   Fri, 04 Nov 2022 15:52:38 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org, svens@linux.ibm.com,
        peterz@infradead.org, npiggin@gmail.com, nadav.amit@gmail.com,
        jhubbard@nvidia.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, borntraeger@linux.ibm.com,
        aneesh.kumar@linux.ibm.com, agordeev@linux.ibm.com,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-re-unify-the-simplified-page_zap__rmap-function.patch added to mm-unstable branch
Message-Id: <20221104225239.29868C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: re-unify the simplified page_zap_*_rmap() function
has been added to the -mm mm-unstable branch.  Its filename is
     mm-re-unify-the-simplified-page_zap__rmap-function.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-re-unify-the-simplified-page_zap__rmap-function.patch

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
From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: mm: re-unify the simplified page_zap_*_rmap() function
Date:   Sun Oct 30 15:14:43 2022 -0700
    
Now that we've simplified both the anonymous and file-backed page zap
functions, they end up being identical except for which page statistic
they update, and we can re-unify the implementation of that much
simplified code.

To make it very clear that this is only for the final pte zapping (since a
lot of the simplifications depended on that), name the unified function
'page_zap_pte_rmap()'.

Link: https://lore.kernel.org/all/B88D3073-440A-41C7-95F4-895D3F657EF2@gmail.com/
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nadav Amit <nadav.amit@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Aneesh Kumar <aneesh.kumar@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Nick Piggin <npiggin@gmail.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |    3 +--
 mm/memory.c          |    5 ++---
 mm/rmap.c            |   39 +++++++++------------------------------
 3 files changed, 12 insertions(+), 35 deletions(-)

--- a/include/linux/rmap.h~mm-re-unify-the-simplified-page_zap__rmap-function
+++ a/include/linux/rmap.h
@@ -196,8 +196,7 @@ void page_add_new_anon_rmap(struct page
 		unsigned long address);
 void page_add_file_rmap(struct page *, struct vm_area_struct *,
 		bool compound);
-void page_zap_file_rmap(struct page *);
-void page_zap_anon_rmap(struct page *);
+void page_zap_pte_rmap(struct page *);
 void page_remove_rmap(struct page *, struct vm_area_struct *,
 		bool compound);
 
--- a/mm/memory.c~mm-re-unify-the-simplified-page_zap__rmap-function
+++ a/mm/memory.c
@@ -1402,9 +1402,8 @@ again:
 				if (pte_young(ptent) &&
 				    likely(!(vma->vm_flags & VM_SEQ_READ)))
 					mark_page_accessed(page);
-				page_zap_file_rmap(page);
-			} else
-				page_zap_anon_rmap(page);
+			}
+			page_zap_pte_rmap(page);
 			munlock_vma_page(page, vma, false);
 			rss[mm_counter(page)]--;
 			if (unlikely(page_mapcount(page) < 0))
--- a/mm/rmap.c~mm-re-unify-the-simplified-page_zap__rmap-function
+++ a/mm/rmap.c
@@ -1413,47 +1413,26 @@ static void page_remove_anon_compound_rm
 }
 
 /**
- * page_zap_file_rmap - take down non-anon pte mapping from a page
+ * page_zap_pte_rmap - take down a pte mapping from a page
  * @page:	page to remove mapping from
  *
- * This is the simplified form of page_remove_rmap(), with:
- *  - we've already checked for '!PageAnon(page)'
- *  - 'compound' is always false
- *  - the caller does 'munlock_vma_page(page, vma, compound)' separately
- * which allows for a much simpler calling convention.
+ * This is the simplified form of page_remove_rmap(), that only
+ * deals with last-level pages, so 'compound' is always false,
+ * and the caller does 'munlock_vma_page(page, vma, compound)'
+ * separately.
  *
- * The caller holds the pte lock.
- */
-void page_zap_file_rmap(struct page *page)
-{
-	if (!atomic_add_negative(-1, &page->_mapcount))
-		return;
-
-	lock_page_memcg(page);
-	__dec_lruvec_page_state(page, NR_FILE_MAPPED);
-	unlock_page_memcg(page);
-}
-
-/**
- * page_zap_anon_rmap(page) - take down non-anon pte mapping from a page
- * @page:	page to remove mapping from
- *
- * This is the simplified form of page_remove_rmap(), with:
- *  - we've already checked for 'PageAnon(page)'
- *  - 'compound' is always false
- *  - the caller does 'munlock_vma_page(page, vma, compound)' separately
- * which allows for a much simpler calling convention.
+ * This allows for a much simpler calling convention and code.
  *
  * The caller holds the pte lock.
  */
-void page_zap_anon_rmap(struct page *page)
+void page_zap_pte_rmap(struct page *page)
 {
-	/* page still mapped by someone else? */
 	if (!atomic_add_negative(-1, &page->_mapcount))
 		return;
 
 	lock_page_memcg(page);
-	__dec_lruvec_page_state(page, NR_ANON_MAPPED);
+	__dec_lruvec_page_state(page,
+		PageAnon(page) ? NR_ANON_MAPPED : NR_FILE_MAPPED);
 	unlock_page_memcg(page);
 }
 
_

Patches currently in -mm which might be from torvalds@linux-foundation.org are

mm-introduce-simplified-versions-of-page_remove_rmap.patch
mm-inline-simpler-case-of-page_remove_file_rmap.patch
mm-re-unify-the-simplified-page_zap__rmap-function.patch
mm-delay-rmap-removal-until-after-tlb-flush.patch

