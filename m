Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE359CCA481
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jul 2022 01:12:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231704AbiGDBMq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 3 Jul 2022 21:12:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232667AbiGDBLY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 3 Jul 2022 21:11:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8235A6404
        for <mm-commits@vger.kernel.org>; Sun,  3 Jul 2022 18:10:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 29F13B80CF1
        for <mm-commits@vger.kernel.org>; Mon,  4 Jul 2022 01:10:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D617EC341C7;
        Mon,  4 Jul 2022 01:10:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656897048;
        bh=2BQzDlVU7UK6ofOPBInnaC8ulvSzuc8AE8DVa9MSQg4=;
        h=Date:To:From:Subject:From;
        b=u7xyVtLm/QdGOb1J3/Yh/eue3FBq+zQtqhjkfhFQN0Vu7d+Q1XQLAM9w5vM66308L
         sBiXODcOV8hLFHon6cjqExRM642PGyE9wO0zT5H2wJxxAMGbN7Nv9Bcs6/sRYUeOu4
         xx+73yHaptTfzH6FL3QTfkitx0M7S9u/AVywMLcU=
Date:   Sun, 03 Jul 2022 18:10:48 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        mike.kravetz@oracle.com, baolin.wang@linux.alibaba.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-rmap-simplify-the-hugetlb-handling-when-unmapping-or-migration.patch removed from -mm tree
Message-Id: <20220704011048.D617EC341C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: rmap: simplify the hugetlb handling when unmapping or migration
has been removed from the -mm tree.  Its filename was
     mm-rmap-simplify-the-hugetlb-handling-when-unmapping-or-migration.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: rmap: simplify the hugetlb handling when unmapping or migration
Date: Mon, 20 Jun 2022 19:47:15 +0800

According to previous discussion [1], there are so many levels of
indenting to handle the hugetlb case when unmapping or migration.  We can
combine folio_test_anon() and huge_pmd_unshare() to save one level of
indenting, by adding a local variable and moving the VM_BUG_ON() a little
forward.

No intended functional changes in this patch.

[1] https://lore.kernel.org/all/0b986dc4-5843-3e2d-c2df-5a2e9f13e6ab@oracle.com/

Link: https://lkml.kernel.org/r/28414b1b96f095e838c1e548074f8e0fc70d78cf.1655724713.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |   90 +++++++++++++++++++++++++---------------------------
 1 file changed, 44 insertions(+), 46 deletions(-)

--- a/mm/rmap.c~mm-rmap-simplify-the-hugetlb-handling-when-unmapping-or-migration
+++ a/mm/rmap.c
@@ -1537,6 +1537,8 @@ static bool try_to_unmap_one(struct foli
 				 PageAnonExclusive(subpage);
 
 		if (folio_test_hugetlb(folio)) {
+			bool anon = folio_test_anon(folio);
+
 			/*
 			 * The try_to_unmap() is only passed a hugetlb page
 			 * in the case where the hugetlb page is poisoned.
@@ -1551,31 +1553,28 @@ static bool try_to_unmap_one(struct foli
 			 */
 			flush_cache_range(vma, range.start, range.end);
 
-			if (!folio_test_anon(folio)) {
+			/*
+			 * To call huge_pmd_unshare, i_mmap_rwsem must be
+			 * held in write mode.  Caller needs to explicitly
+			 * do this outside rmap routines.
+			 */
+			VM_BUG_ON(!anon && !(flags & TTU_RMAP_LOCKED));
+			if (!anon && huge_pmd_unshare(mm, vma, &address, pvmw.pte)) {
+				flush_tlb_range(vma, range.start, range.end);
+				mmu_notifier_invalidate_range(mm, range.start,
+							      range.end);
+
 				/*
-				 * To call huge_pmd_unshare, i_mmap_rwsem must be
-				 * held in write mode.  Caller needs to explicitly
-				 * do this outside rmap routines.
+				 * The ref count of the PMD page was dropped
+				 * which is part of the way map counting
+				 * is done for shared PMDs.  Return 'true'
+				 * here.  When there is no other sharing,
+				 * huge_pmd_unshare returns false and we will
+				 * unmap the actual page and drop map count
+				 * to zero.
 				 */
-				VM_BUG_ON(!(flags & TTU_RMAP_LOCKED));
-
-				if (huge_pmd_unshare(mm, vma, &address, pvmw.pte)) {
-					flush_tlb_range(vma, range.start, range.end);
-					mmu_notifier_invalidate_range(mm, range.start,
-								      range.end);
-
-					/*
-					 * The ref count of the PMD page was dropped
-					 * which is part of the way map counting
-					 * is done for shared PMDs.  Return 'true'
-					 * here.  When there is no other sharing,
-					 * huge_pmd_unshare returns false and we will
-					 * unmap the actual page and drop map count
-					 * to zero.
-					 */
-					page_vma_mapped_walk_done(&pvmw);
-					break;
-				}
+				page_vma_mapped_walk_done(&pvmw);
+				break;
 			}
 			pteval = huge_ptep_clear_flush(vma, address, pvmw.pte);
 		} else {
@@ -1906,6 +1905,8 @@ static bool try_to_migrate_one(struct fo
 				 PageAnonExclusive(subpage);
 
 		if (folio_test_hugetlb(folio)) {
+			bool anon = folio_test_anon(folio);
+
 			/*
 			 * huge_pmd_unshare may unmap an entire PMD page.
 			 * There is no way of knowing exactly which PMDs may
@@ -1915,31 +1916,28 @@ static bool try_to_migrate_one(struct fo
 			 */
 			flush_cache_range(vma, range.start, range.end);
 
-			if (!folio_test_anon(folio)) {
+			/*
+			 * To call huge_pmd_unshare, i_mmap_rwsem must be
+			 * held in write mode.  Caller needs to explicitly
+			 * do this outside rmap routines.
+			 */
+			VM_BUG_ON(!anon && !(flags & TTU_RMAP_LOCKED));
+			if (!anon && huge_pmd_unshare(mm, vma, &address, pvmw.pte)) {
+				flush_tlb_range(vma, range.start, range.end);
+				mmu_notifier_invalidate_range(mm, range.start,
+							      range.end);
+
 				/*
-				 * To call huge_pmd_unshare, i_mmap_rwsem must be
-				 * held in write mode.  Caller needs to explicitly
-				 * do this outside rmap routines.
+				 * The ref count of the PMD page was dropped
+				 * which is part of the way map counting
+				 * is done for shared PMDs.  Return 'true'
+				 * here.  When there is no other sharing,
+				 * huge_pmd_unshare returns false and we will
+				 * unmap the actual page and drop map count
+				 * to zero.
 				 */
-				VM_BUG_ON(!(flags & TTU_RMAP_LOCKED));
-
-				if (huge_pmd_unshare(mm, vma, &address, pvmw.pte)) {
-					flush_tlb_range(vma, range.start, range.end);
-					mmu_notifier_invalidate_range(mm, range.start,
-								      range.end);
-
-					/*
-					 * The ref count of the PMD page was dropped
-					 * which is part of the way map counting
-					 * is done for shared PMDs.  Return 'true'
-					 * here.  When there is no other sharing,
-					 * huge_pmd_unshare returns false and we will
-					 * unmap the actual page and drop map count
-					 * to zero.
-					 */
-					page_vma_mapped_walk_done(&pvmw);
-					break;
-				}
+				page_vma_mapped_walk_done(&pvmw);
+				break;
 			}
 
 			/* Nuke the hugetlb page table entry */
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

arm64-hugetlb-implement-arm64-specific-hugetlb_mask_last_page.patch
arm64-hugetlb-implement-arm64-specific-hugetlb_mask_last_page-fix.patch

