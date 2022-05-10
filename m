Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5733CC433F5
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:18:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236377AbiEJEWP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:22:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236089AbiEJEUg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:20:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF3B21FCD0
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:15:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 697816176B
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:15:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B954AC385A6;
        Tue, 10 May 2022 04:15:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652156138;
        bh=2NMb7+LZkkR7Rfl37nEQPALj/0h0mVdkLh8QL8st0Eg=;
        h=Date:To:From:Subject:From;
        b=QXLXiIwpDFy3Yhb4LuZ11K0P2N52IxBr5mV7MZg8F9Kn8PGzjoGQ3LcI1oZUEag+C
         LHChTxFnAMCsjWYPqgOcvKinIb930oH2Vx7MGgS6HVYapLrrUcVEuJPDiqMDYers5s
         nv5q7iZmWjw06uTQp+SAwhgLLvLVqQU91C+th78g=
Date:   Mon, 09 May 2022 21:15:38 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        mike.kravetz@oracle.com, almasrymina@google.com,
        baolin.wang@linux.alibaba.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-rmap-move-the-cache-flushing-to-the-correct-place-for-hugetlb-pmd-sharing.patch removed from -mm tree
Message-Id: <20220510041538.B954AC385A6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: rmap: move the cache flushing to the correct place for hugetlb PMD sharing
has been removed from the -mm tree.  Its filename was
     mm-rmap-move-the-cache-flushing-to-the-correct-place-for-hugetlb-pmd-sharing.patch

This patch was dropped because it was merged into mm-stable

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
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |   40 ++++++++++++++++++++++------------------
 1 file changed, 22 insertions(+), 18 deletions(-)

--- a/mm/rmap.c~mm-rmap-move-the-cache-flushing-to-the-correct-place-for-hugetlb-pmd-sharing
+++ a/mm/rmap.c
@@ -1532,15 +1532,16 @@ static bool try_to_unmap_one(struct foli
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
@@ -1557,13 +1558,14 @@ static bool try_to_unmap_one(struct foli
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
@@ -1884,15 +1886,16 @@ static bool try_to_migrate_one(struct fo
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
@@ -1909,10 +1912,11 @@ static bool try_to_migrate_one(struct fo
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


