Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 459AAC4332F
	for <mm-commits@archiver.kernel.org>; Fri, 16 Dec 2022 23:06:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbiLPXGQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Dec 2022 18:06:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbiLPXGO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Dec 2022 18:06:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69F5D18B11
        for <mm-commits@vger.kernel.org>; Fri, 16 Dec 2022 15:06:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 010A9B81DA5
        for <mm-commits@vger.kernel.org>; Fri, 16 Dec 2022 23:06:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86770C433EF;
        Fri, 16 Dec 2022 23:06:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671231967;
        bh=KdCqG4zZNDngiKjV3BZVubUxknvmqcOS6PqsTJU+u3k=;
        h=Date:To:From:Subject:From;
        b=RPjvJ+tt9Q3nF/Qjlgd+dPgqaXruzEdv/Lg0/h0nDWTAi4qJDcQ//iggxcleytRa3
         EwF84AEmfyUM84qKLDTtpaGSGq2IJQr9oZ7VuV/6+eE/ip8x71Z8wUsCWTw1+CEiMp
         EY05kUt47Knl7rfB1dtmCl5+WYrLGgR4i2Geos0A=
Date:   Fri, 16 Dec 2022 15:06:06 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        vishal.moola@gmail.com, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-convert-madvise_free_huge_pmd-to-use-a-folio.patch added to mm-unstable branch
Message-Id: <20221216230607.86770C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: huge_memory: convert madvise_free_huge_pmd to use a folio
has been added to the -mm mm-unstable branch.  Its filename is
     mm-huge_memory-convert-madvise_free_huge_pmd-to-use-a-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-convert-madvise_free_huge_pmd-to-use-a-folio.patch

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
mm-huge_memory-convert-madvise_free_huge_pmd-to-use-a-folio.patch
mm-swap-convert-mark_page_lazyfree-to-folio_mark_lazyfree.patch

