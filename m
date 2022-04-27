Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90AEDC43217
	for <mm-commits@archiver.kernel.org>; Wed, 27 Apr 2022 18:52:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231959AbiD0Szs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 27 Apr 2022 14:55:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233961AbiD0Syq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 27 Apr 2022 14:54:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B739F3E5F4B
        for <mm-commits@vger.kernel.org>; Wed, 27 Apr 2022 11:41:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2A2E261EEF
        for <mm-commits@vger.kernel.org>; Wed, 27 Apr 2022 18:41:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85037C385A9;
        Wed, 27 Apr 2022 18:41:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651084879;
        bh=r7XYap9YBBSfgPo4n0mqrjTdNBdYEAnEs+XAfrKDIa4=;
        h=Date:To:From:Subject:From;
        b=1SWMMNL98HRS469LlYrJgu2RVKCGr8ndMloVEbvO/jPb4A4jvntCEtPgkeC1Bvu3+
         GvE6bzVB6azno+L4HHncf85P0sau+dJ2trw/W18kD/RueJJ8Wgd1bjL+BSKxDuw+6w
         Wae00ZeAoXY93dUy/DEheXTO8uuNDSRS5iiiZ+c4=
Date:   Wed, 27 Apr 2022 11:41:18 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        mike.kravetz@oracle.com, almasrymina@google.com,
        baolin.wang@linux.alibaba.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rmap-move-the-cache-flushing-to-the-correct-place-for-hugetlb-pmd-sharing.patch added to -mm tree
Message-Id: <20220427184119.85037C385A9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: rmap: move the cache flushing to the correct place for hugetlb PMD sharing
has been added to the -mm tree.  Its filename is
     mm-rmap-move-the-cache-flushing-to-the-correct-place-for-hugetlb-pmd-sharing.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-rmap-move-the-cache-flushing-to-the-correct-place-for-hugetlb-pmd-sharing.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-rmap-move-the-cache-flushing-to-the-correct-place-for-hugetlb-pmd-sharing.patch

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
Subject: mm: rmap: move the cache flushing to the correct place for hugetlb PMD sharing

The cache level flush will always be first when changing an existing
virtual–>physical mapping to a new value, since this allows us to
properly handle systems whose caches are strict and require a
virtual–>physical translation to exist for a virtual address.  So we
should move the cache flushing before huge_pmd_unshare().

As Muchun pointed out[1], now the architectures whose supporting hugetlb
PMD sharing have no cache flush issues in practice.  But I think we should
still follow the cache/TLB flushing rules when changing a valid virtual
address mapping in case of potential issues in future.

[1] https://lore.kernel.org/all/YmT%2F%2FhuUbFX+KHcy@FVFYT0MHHV2J.usts.net/

Link: https://lkml.kernel.org/r/4f7ae6dfdc838ab71e1655188b657c032ff1f28f.1651056365.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |   40 ++++++++++++++++++++++------------------
 1 file changed, 22 insertions(+), 18 deletions(-)

--- a/mm/rmap.c~mm-rmap-move-the-cache-flushing-to-the-correct-place-for-hugetlb-pmd-sharing
+++ a/mm/rmap.c
@@ -1535,15 +1535,16 @@ static bool try_to_unmap_one(struct foli
 			 * do this outside rmap routines.
 			 */
 			VM_BUG_ON(!(flags & TTU_RMAP_LOCKED));
+			/*
+			 * huge_pmd_unshare may unmap an entire PMD page.
+			 * There is no way of knowing exactly which PMDs may
+			 * be cached for this mm, so we must flush them all.
+			 * start/end were already adjusted above to cover this
+			 * range.
+			 */
+			flush_cache_range(vma, range.start, range.end);
+
 			if (huge_pmd_unshare(mm, vma, &address, pvmw.pte)) {
-				/*
-				 * huge_pmd_unshare unmapped an entire PMD
-				 * page.  There is no way of knowing exactly
-				 * which PMDs may be cached for this mm, so
-				 * we must flush them all.  start/end were
-				 * already adjusted above to cover this range.
-				 */
-				flush_cache_range(vma, range.start, range.end);
 				flush_tlb_range(vma, range.start, range.end);
 				mmu_notifier_invalidate_range(mm, range.start,
 							      range.end);
@@ -1560,13 +1561,14 @@ static bool try_to_unmap_one(struct foli
 				page_vma_mapped_walk_done(&pvmw);
 				break;
 			}
+		} else {
+			flush_cache_page(vma, address, pte_pfn(*pvmw.pte));
 		}
 
 		/*
 		 * Nuke the page table entry. When having to clear
 		 * PageAnonExclusive(), we always have to flush.
 		 */
-		flush_cache_page(vma, address, pte_pfn(*pvmw.pte));
 		if (should_defer_flush(mm, flags) && !anon_exclusive) {
 			/*
 			 * We clear the PTE but do not flush so potentially
@@ -1890,15 +1892,16 @@ static bool try_to_migrate_one(struct fo
 			 * do this outside rmap routines.
 			 */
 			VM_BUG_ON(!(flags & TTU_RMAP_LOCKED));
+			/*
+			 * huge_pmd_unshare may unmap an entire PMD page.
+			 * There is no way of knowing exactly which PMDs may
+			 * be cached for this mm, so we must flush them all.
+			 * start/end were already adjusted above to cover this
+			 * range.
+			 */
+			flush_cache_range(vma, range.start, range.end);
+
 			if (huge_pmd_unshare(mm, vma, &address, pvmw.pte)) {
-				/*
-				 * huge_pmd_unshare unmapped an entire PMD
-				 * page.  There is no way of knowing exactly
-				 * which PMDs may be cached for this mm, so
-				 * we must flush them all.  start/end were
-				 * already adjusted above to cover this range.
-				 */
-				flush_cache_range(vma, range.start, range.end);
 				flush_tlb_range(vma, range.start, range.end);
 				mmu_notifier_invalidate_range(mm, range.start,
 							      range.end);
@@ -1915,10 +1918,11 @@ static bool try_to_migrate_one(struct fo
 				page_vma_mapped_walk_done(&pvmw);
 				break;
 			}
+		} else {
+			flush_cache_page(vma, address, pte_pfn(*pvmw.pte));
 		}
 
 		/* Nuke the page table entry. */
-		flush_cache_page(vma, address, pte_pfn(*pvmw.pte));
 		pteval = ptep_clear_flush(vma, address, pvmw.pte);
 
 		/* Set the dirty flag on the folio now the pte is gone. */
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-migrate-simplify-the-refcount-validation-when-migrating-hugetlb-mapping.patch
mm-hugetlb-add-missing-cache-flushing-in-hugetlb_unshare_all_pmds.patch
mm-hugetlb-considering-pmd-sharing-when-flushing-cache-tlbs.patch
mm-rmap-move-the-cache-flushing-to-the-correct-place-for-hugetlb-pmd-sharing.patch
mm-rmap-use-flush_cache_range-to-flush-cache-for-hugetlb-pages.patch

