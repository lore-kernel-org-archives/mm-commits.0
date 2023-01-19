Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF6EBC677F1
	for <mm-commits@archiver.kernel.org>; Thu, 19 Jan 2023 01:16:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230023AbjASBQ0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 20:16:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230043AbjASBOq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 20:14:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13A8469226
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 17:14:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A04C261B10
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 01:14:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06976C433EF;
        Thu, 19 Jan 2023 01:14:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674090861;
        bh=NtsCtd6ZSSzcYTHJIDQApy9xojqbFpsAyrRjs2zXb0I=;
        h=Date:To:From:Subject:From;
        b=SLJM/OwqGQXHz/LmM7ypM15X9s7FI0gw4BhDUlU5++o5PPL6oyI7cXDqozHQjw3pp
         nJFJLucTgCAOkn0tWxpZDQnfe9l88PFGOjJhsygZHs4io+WbMOHagEJpfSwkjCqezb
         tC6otEJIOV1uqOSadqsEnbMxkNScOx9bibu8BEu8=
Date:   Wed, 18 Jan 2023 17:14:20 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        vishal.moola@gmail.com, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-huge_memory-convert-madvise_free_huge_pmd-to-use-a-folio.patch removed from -mm tree
Message-Id: <20230119011421.06976C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: huge_memory: convert madvise_free_huge_pmd to use a folio
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-convert-madvise_free_huge_pmd-to-use-a-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: huge_memory: convert madvise_free_huge_pmd to use a folio
Date: Wed, 7 Dec 2022 10:34:30 +0800

Using folios instead of pages removes several calls to compound_head(),

Link: https://lkml.kernel.org/r/20221207023431.151008-1-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-convert-madvise_free_huge_pmd-to-use-a-folio
+++ a/mm/huge_memory.c
@@ -1603,7 +1603,7 @@ bool madvise_free_huge_pmd(struct mmu_ga
 {
 	spinlock_t *ptl;
 	pmd_t orig_pmd;
-	struct page *page;
+	struct folio *folio;
 	struct mm_struct *mm = tlb->mm;
 	bool ret = false;
 
@@ -1623,15 +1623,15 @@ bool madvise_free_huge_pmd(struct mmu_ga
 		goto out;
 	}
 
-	page = pmd_page(orig_pmd);
+	folio = pfn_folio(pmd_pfn(orig_pmd));
 	/*
-	 * If other processes are mapping this page, we couldn't discard
-	 * the page unless they all do MADV_FREE so let's skip the page.
+	 * If other processes are mapping this folio, we couldn't discard
+	 * the folio unless they all do MADV_FREE so let's skip the folio.
 	 */
-	if (total_mapcount(page) != 1)
+	if (folio_mapcount(folio) != 1)
 		goto out;
 
-	if (!trylock_page(page))
+	if (!folio_trylock(folio))
 		goto out;
 
 	/*
@@ -1639,17 +1639,17 @@ bool madvise_free_huge_pmd(struct mmu_ga
 	 * will deactivate only them.
 	 */
 	if (next - addr != HPAGE_PMD_SIZE) {
-		get_page(page);
+		folio_get(folio);
 		spin_unlock(ptl);
-		split_huge_page(page);
-		unlock_page(page);
-		put_page(page);
+		split_folio(folio);
+		folio_unlock(folio);
+		folio_put(folio);
 		goto out_unlocked;
 	}
 
-	if (PageDirty(page))
-		ClearPageDirty(page);
-	unlock_page(page);
+	if (folio_test_dirty(folio))
+		folio_clear_dirty(folio);
+	folio_unlock(folio);
 
 	if (pmd_young(orig_pmd) || pmd_dirty(orig_pmd)) {
 		pmdp_invalidate(vma, addr, pmd);
@@ -1660,7 +1660,7 @@ bool madvise_free_huge_pmd(struct mmu_ga
 		tlb_remove_pmd_tlb_entry(tlb, pmd, addr);
 	}
 
-	mark_page_lazyfree(page);
+	mark_page_lazyfree(&folio->page);
 	ret = true;
 out:
 	spin_unlock(ptl);
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-hwposion-support-recovery-from-ksm_might_need_to_copy.patch
mm-hwposion-support-recovery-from-ksm_might_need_to_copy-v3.patch
mm-madvise-use-vm_normal_folio-in-madvise_free_pte_range.patch

