Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63E17C433F5
	for <mm-commits@archiver.kernel.org>; Wed, 27 Apr 2022 18:52:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231907AbiD0Szl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 27 Apr 2022 14:55:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233800AbiD0Syk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 27 Apr 2022 14:54:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BDCEE9944
        for <mm-commits@vger.kernel.org>; Wed, 27 Apr 2022 11:41:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BBDC961EF1
        for <mm-commits@vger.kernel.org>; Wed, 27 Apr 2022 18:41:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C5C6C385A7;
        Wed, 27 Apr 2022 18:41:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651084877;
        bh=yr3qN8X4DU6xagR+Xba2zXcRqy4EJP3UZ7gtRZiCxTw=;
        h=Date:To:From:Subject:From;
        b=cpwzJJFS3X887kjqrwlCi4MS5ZXY+2bR7zK6jKBhAlbhXkoz1TkHu5YBfD6ngIV7V
         xUNWuzK0oygch5lcjxWrxGbGXdSWWzIAa+TISm7G5cpAdYOL49aG8aoKF9E0xH7Doh
         K3uwla6sFHvz6AzgooAFNzj0j/kS2s8rTfaOp6IA=
Date:   Wed, 27 Apr 2022 11:41:16 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        mike.kravetz@oracle.com, almasrymina@google.com,
        baolin.wang@linux.alibaba.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-considering-pmd-sharing-when-flushing-cache-tlbs.patch added to -mm tree
Message-Id: <20220427184117.1C5C6C385A7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: hugetlb: considering PMD sharing when flushing cache/TLBs
has been added to the -mm tree.  Its filename is
     mm-hugetlb-considering-pmd-sharing-when-flushing-cache-tlbs.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-considering-pmd-sharing-when-flushing-cache-tlbs.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-considering-pmd-sharing-when-flushing-cache-tlbs.patch

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
Cc: Mina Almasry <almasrymina@google.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   17 +++++++++++++++--
 mm/mremap.c  |    2 +-
 2 files changed, 16 insertions(+), 3 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-considering-pmd-sharing-when-flushing-cache-tlbs
+++ a/mm/hugetlb.c
@@ -4935,10 +4935,17 @@ int move_hugetlb_page_tables(struct vm_a
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
@@ -4955,8 +4962,10 @@ int move_hugetlb_page_tables(struct vm_a
 		 */
 		old_addr_copy = old_addr;
 
-		if (huge_pmd_unshare(mm, vma, &old_addr_copy, src_pte))
+		if (huge_pmd_unshare(mm, vma, &old_addr_copy, src_pte)) {
+			shared_pmd = true;
 			continue;
+		}
 
 		dst_pte = huge_pte_alloc(mm, new_vma, new_addr, sz);
 		if (!dst_pte)
@@ -4964,7 +4973,11 @@ int move_hugetlb_page_tables(struct vm_a
 
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

mm-migrate-simplify-the-refcount-validation-when-migrating-hugetlb-mapping.patch
mm-hugetlb-add-missing-cache-flushing-in-hugetlb_unshare_all_pmds.patch
mm-hugetlb-considering-pmd-sharing-when-flushing-cache-tlbs.patch
mm-rmap-move-the-cache-flushing-to-the-correct-place-for-hugetlb-pmd-sharing.patch
mm-rmap-use-flush_cache_range-to-flush-cache-for-hugetlb-pages.patch

