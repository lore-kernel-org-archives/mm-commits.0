Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B879CC433EF
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:18:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236123AbiEJEWj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:22:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236146AbiEJEUg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:20:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC5A1201AC
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:15:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 671F66176C
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:15:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB990C385C2;
        Tue, 10 May 2022 04:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652156139;
        bh=L8Z3VAFRTMExFfilqMbJTzD9+R+cPiG4hMtqjOWJq34=;
        h=Date:To:From:Subject:From;
        b=oqJC6ykhOK3oSy57ne7ub/uy7FbmwmpZA2XXsTV8TgPQGvXnlIpFoYVT1rYheH1ly
         2JN28SgvQFPtTUonA2dpSClXGw2/wSPt2LoMLvsRgp/rTGYsj0JaOIw2vZz+g0lOxo
         m+T+vD2rhAFRrrcdgdrGe+4l3eBWWPrmzHWUjxAo=
Date:   Mon, 09 May 2022 21:15:39 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        mike.kravetz@oracle.com, almasrymina@google.com,
        baolin.wang@linux.alibaba.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-rmap-use-flush_cache_range-to-flush-cache-for-hugetlb-pages.patch removed from -mm tree
Message-Id: <20220510041539.BB990C385C2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: rmap: use flush_cache_range() to flush cache for hugetlb pages
has been removed from the -mm tree.  Its filename was
     mm-rmap-use-flush_cache_range-to-flush-cache-for-hugetlb-pages.patch

This patch was dropped because it was merged into mm-stable

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: rmap: use flush_cache_range() to flush cache for hugetlb pages

Now we will use flush_cache_page() to flush cache for anonymous hugetlb
pages when unmapping or migrating a hugetlb page mapping, but the
flush_cache_page() only handles a PAGE_SIZE range on some architectures
(like arm32, arc and so on), which will cause potential cache issues. 
Thus change to use flush_cache_range() to cover the whole size of a
hugetlb page.

Link: https://lkml.kernel.org/r/dc903b378d1e2d26bbbe85409ab9d009631f175c.1651056365.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |   90 +++++++++++++++++++++++++++-------------------------
 1 file changed, 48 insertions(+), 42 deletions(-)

--- a/mm/rmap.c~mm-rmap-use-flush_cache_range-to-flush-cache-for-hugetlb-pages
+++ a/mm/rmap.c
@@ -1525,13 +1525,7 @@ static bool try_to_unmap_one(struct foli
 		anon_exclusive = folio_test_anon(folio) &&
 				 PageAnonExclusive(subpage);
 
-		if (folio_test_hugetlb(folio) && !folio_test_anon(folio)) {
-			/*
-			 * To call huge_pmd_unshare, i_mmap_rwsem must be
-			 * held in write mode.  Caller needs to explicitly
-			 * do this outside rmap routines.
-			 */
-			VM_BUG_ON(!(flags & TTU_RMAP_LOCKED));
+		if (folio_test_hugetlb(folio)) {
 			/*
 			 * huge_pmd_unshare may unmap an entire PMD page.
 			 * There is no way of knowing exactly which PMDs may
@@ -1541,22 +1535,31 @@ static bool try_to_unmap_one(struct foli
 			 */
 			flush_cache_range(vma, range.start, range.end);
 
-			if (huge_pmd_unshare(mm, vma, &address, pvmw.pte)) {
-				flush_tlb_range(vma, range.start, range.end);
-				mmu_notifier_invalidate_range(mm, range.start,
-							      range.end);
-
+			if (!folio_test_anon(folio)) {
 				/*
-				 * The ref count of the PMD page was dropped
-				 * which is part of the way map counting
-				 * is done for shared PMDs.  Return 'true'
-				 * here.  When there is no other sharing,
-				 * huge_pmd_unshare returns false and we will
-				 * unmap the actual page and drop map count
-				 * to zero.
+				 * To call huge_pmd_unshare, i_mmap_rwsem must be
+				 * held in write mode.  Caller needs to explicitly
+				 * do this outside rmap routines.
 				 */
-				page_vma_mapped_walk_done(&pvmw);
-				break;
+				VM_BUG_ON(!(flags & TTU_RMAP_LOCKED));
+
+				if (huge_pmd_unshare(mm, vma, &address, pvmw.pte)) {
+					flush_tlb_range(vma, range.start, range.end);
+					mmu_notifier_invalidate_range(mm, range.start,
+								      range.end);
+
+					/*
+					 * The ref count of the PMD page was dropped
+					 * which is part of the way map counting
+					 * is done for shared PMDs.  Return 'true'
+					 * here.  When there is no other sharing,
+					 * huge_pmd_unshare returns false and we will
+					 * unmap the actual page and drop map count
+					 * to zero.
+					 */
+					page_vma_mapped_walk_done(&pvmw);
+					break;
+				}
 			}
 		} else {
 			flush_cache_page(vma, address, pte_pfn(*pvmw.pte));
@@ -1879,13 +1882,7 @@ static bool try_to_migrate_one(struct fo
 		anon_exclusive = folio_test_anon(folio) &&
 				 PageAnonExclusive(subpage);
 
-		if (folio_test_hugetlb(folio) && !folio_test_anon(folio)) {
-			/*
-			 * To call huge_pmd_unshare, i_mmap_rwsem must be
-			 * held in write mode.  Caller needs to explicitly
-			 * do this outside rmap routines.
-			 */
-			VM_BUG_ON(!(flags & TTU_RMAP_LOCKED));
+		if (folio_test_hugetlb(folio)) {
 			/*
 			 * huge_pmd_unshare may unmap an entire PMD page.
 			 * There is no way of knowing exactly which PMDs may
@@ -1895,22 +1892,31 @@ static bool try_to_migrate_one(struct fo
 			 */
 			flush_cache_range(vma, range.start, range.end);
 
-			if (huge_pmd_unshare(mm, vma, &address, pvmw.pte)) {
-				flush_tlb_range(vma, range.start, range.end);
-				mmu_notifier_invalidate_range(mm, range.start,
-							      range.end);
-
+			if (!folio_test_anon(folio)) {
 				/*
-				 * The ref count of the PMD page was dropped
-				 * which is part of the way map counting
-				 * is done for shared PMDs.  Return 'true'
-				 * here.  When there is no other sharing,
-				 * huge_pmd_unshare returns false and we will
-				 * unmap the actual page and drop map count
-				 * to zero.
+				 * To call huge_pmd_unshare, i_mmap_rwsem must be
+				 * held in write mode.  Caller needs to explicitly
+				 * do this outside rmap routines.
 				 */
-				page_vma_mapped_walk_done(&pvmw);
-				break;
+				VM_BUG_ON(!(flags & TTU_RMAP_LOCKED));
+
+				if (huge_pmd_unshare(mm, vma, &address, pvmw.pte)) {
+					flush_tlb_range(vma, range.start, range.end);
+					mmu_notifier_invalidate_range(mm, range.start,
+								      range.end);
+
+					/*
+					 * The ref count of the PMD page was dropped
+					 * which is part of the way map counting
+					 * is done for shared PMDs.  Return 'true'
+					 * here.  When there is no other sharing,
+					 * huge_pmd_unshare returns false and we will
+					 * unmap the actual page and drop map count
+					 * to zero.
+					 */
+					page_vma_mapped_walk_done(&pvmw);
+					break;
+				}
 			}
 		} else {
 			flush_cache_page(vma, address, pte_pfn(*pvmw.pte));
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are


