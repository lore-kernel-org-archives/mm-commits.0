Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23821C433FE
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:18:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236096AbiEJEWg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:22:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236292AbiEJEUg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:20:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B42721AF
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:15:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 19614B81B07
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:15:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B83FBC385C5;
        Tue, 10 May 2022 04:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652156137;
        bh=MjuNUVymj1jvtLRhzzbu1ln7WfpYTchbmPP0CZEZzTM=;
        h=Date:To:From:Subject:From;
        b=TOg0lvUa1aKpaU0KduSTD48wZ4VlnHpvwcxiqvyYRbIQdo82t3QT286oFTG2BwABx
         y56n2Bi/SvuWcqkEA43tEHQkBfURxrnRtzP5KXoBUEpO/IxnCB9qfm0UiF55tBFWJT
         BamuNOgweyLWUA73I98clPWhOTQCh9CwberxNM7k=
Date:   Mon, 09 May 2022 21:15:37 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        mike.kravetz@oracle.com, almasrymina@google.com,
        baolin.wang@linux.alibaba.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-considering-pmd-sharing-when-flushing-cache-tlbs.patch removed from -mm tree
Message-Id: <20220510041537.B83FBC385C5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: hugetlb: considering PMD sharing when flushing cache/TLBs
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-considering-pmd-sharing-when-flushing-cache-tlbs.patch

This patch was dropped because it was merged into mm-stable

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: hugetlb: considering PMD sharing when flushing cache/TLBs

This patchset fixes some cache flushing issues if PMD sharing is possible
for hugetlb pages, which were found by code inspection.  Meanwhile Mike
found the flush_cache_page() can not cover the whole size of a hugetlb
page on some architectures [1], so I added a new patch 3 to fix this
issue, since I found only try_to_unmap_one() and try_to_migrate_one() need
to fix after some investigation.

[1] https://lore.kernel.org/linux-mm/064da3bb-5b4b-7332-a722-c5a541128705@oracle.com/


This patch (of 3):

When moving hugetlb page tables, the cache flushing is called in
move_page_tables() without considering the shared PMDs, which may be cause
cache issues on some architectures.

Thus we should move the hugetlb cache flushing into
move_hugetlb_page_tables() with considering the shared PMDs ranges,
calculated by adjust_range_if_pmd_sharing_possible().  Meanwhile also
expanding the TLBs flushing range in case of shared PMDs.

Note this is discovered via code inspection, and did not meet a real
problem in practice so far.

Link: https://lkml.kernel.org/r/cover.1651056365.git.baolin.wang@linux.alibaba.com
Link: https://lkml.kernel.org/r/0443c8cf20db554d3ff4b439b30e0ff26c0181dd.1651056365.git.baolin.wang@linux.alibaba.com
Fixes: 550a7d60bd5e ("mm, hugepages: add mremap() support for hugepage backed vma")
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: Mina Almasry <almasrymina@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   17 +++++++++++++++--
 mm/mremap.c  |    2 +-
 2 files changed, 16 insertions(+), 3 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-considering-pmd-sharing-when-flushing-cache-tlbs
+++ a/mm/hugetlb.c
@@ -4922,10 +4922,17 @@ int move_hugetlb_page_tables(struct vm_a
 	unsigned long old_addr_copy;
 	pte_t *src_pte, *dst_pte;
 	struct mmu_notifier_range range;
+	bool shared_pmd = false;
 
 	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma, mm, old_addr,
 				old_end);
 	adjust_range_if_pmd_sharing_possible(vma, &range.start, &range.end);
+	/*
+	 * In case of shared PMDs, we should cover the maximum possible
+	 * range.
+	 */
+	flush_cache_range(vma, range.start, range.end);
+
 	mmu_notifier_invalidate_range_start(&range);
 	/* Prevent race with file truncation */
 	i_mmap_lock_write(mapping);
@@ -4942,8 +4949,10 @@ int move_hugetlb_page_tables(struct vm_a
 		 */
 		old_addr_copy = old_addr;
 
-		if (huge_pmd_unshare(mm, vma, &old_addr_copy, src_pte))
+		if (huge_pmd_unshare(mm, vma, &old_addr_copy, src_pte)) {
+			shared_pmd = true;
 			continue;
+		}
 
 		dst_pte = huge_pte_alloc(mm, new_vma, new_addr, sz);
 		if (!dst_pte)
@@ -4951,7 +4960,11 @@ int move_hugetlb_page_tables(struct vm_a
 
 		move_huge_pte(vma, old_addr, new_addr, src_pte, dst_pte);
 	}
-	flush_tlb_range(vma, old_end - len, old_end);
+
+	if (shared_pmd)
+		flush_tlb_range(vma, range.start, range.end);
+	else
+		flush_tlb_range(vma, old_end - len, old_end);
 	mmu_notifier_invalidate_range_end(&range);
 	i_mmap_unlock_write(mapping);
 
--- a/mm/mremap.c~mm-hugetlb-considering-pmd-sharing-when-flushing-cache-tlbs
+++ a/mm/mremap.c
@@ -490,12 +490,12 @@ unsigned long move_page_tables(struct vm
 		return 0;
 
 	old_end = old_addr + len;
-	flush_cache_range(vma, old_addr, old_end);
 
 	if (is_vm_hugetlb_page(vma))
 		return move_hugetlb_page_tables(vma, new_vma, old_addr,
 						new_addr, len);
 
+	flush_cache_range(vma, old_addr, old_end);
 	mmu_notifier_range_init(&range, MMU_NOTIFY_UNMAP, 0, vma, vma->vm_mm,
 				old_addr, old_end);
 	mmu_notifier_invalidate_range_start(&range);
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are


