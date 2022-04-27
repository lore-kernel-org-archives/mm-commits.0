Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D12A3C41535
	for <mm-commits@archiver.kernel.org>; Wed, 27 Apr 2022 18:51:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231449AbiD0SzF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 27 Apr 2022 14:55:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233992AbiD0Syq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 27 Apr 2022 14:54:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D9628BE21
        for <mm-commits@vger.kernel.org>; Wed, 27 Apr 2022 11:41:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2D52361EEC
        for <mm-commits@vger.kernel.org>; Wed, 27 Apr 2022 18:41:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73E42C385AA;
        Wed, 27 Apr 2022 18:41:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651084881;
        bh=qxOey8StLdFns/hakRHwe/V3t503Ine9l/XFmyFPEdU=;
        h=Date:To:From:Subject:From;
        b=b9uzrvnkKsz7U6ItlmP501k7ikvPKCYdINlxO7KMR2NVxQ7+lhTEmmUlHhx6Jlw7A
         Ifg6+07WOYRmlLH1sxFc/dpCBY+axZkVDsPTdplIIE0sSQJNWsSx8VAVvn+y6WIgsX
         LecfaV3YVrPyabMY9NXFG6x46/pB8PkFoePVQdUc=
Date:   Wed, 27 Apr 2022 11:41:20 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        mike.kravetz@oracle.com, almasrymina@google.com,
        baolin.wang@linux.alibaba.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rmap-use-flush_cache_range-to-flush-cache-for-hugetlb-pages.patch added to -mm tree
Message-Id: <20220427184121.73E42C385AA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: rmap: use flush_cache_range() to flush cache for hugetlb pages
has been added to the -mm tree.  Its filename is
     mm-rmap-use-flush_cache_range-to-flush-cache-for-hugetlb-pages.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-rmap-use-flush_cache_range-to-flush-cache-for-hugetlb-pages.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-rmap-use-flush_cache_range-to-flush-cache-for-hugetlb-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |   90 +++++++++++++++++++++++++++-------------------------
 1 file changed, 48 insertions(+), 42 deletions(-)

--- a/mm/rmap.c~mm-rmap-use-flush_cache_range-to-flush-cache-for-hugetlb-pages
+++ a/mm/rmap.c
@@ -1528,13 +1528,7 @@ static bool try_to_unmap_one(struct foli
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
@@ -1544,22 +1538,31 @@ static bool try_to_unmap_one(struct foli
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
@@ -1885,13 +1888,7 @@ static bool try_to_migrate_one(struct fo
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
@@ -1901,22 +1898,31 @@ static bool try_to_migrate_one(struct fo
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

mm-migrate-simplify-the-refcount-validation-when-migrating-hugetlb-mapping.patch
mm-hugetlb-add-missing-cache-flushing-in-hugetlb_unshare_all_pmds.patch
mm-hugetlb-considering-pmd-sharing-when-flushing-cache-tlbs.patch
mm-rmap-move-the-cache-flushing-to-the-correct-place-for-hugetlb-pmd-sharing.patch
mm-rmap-use-flush_cache_range-to-flush-cache-for-hugetlb-pages.patch

