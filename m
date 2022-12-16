Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB124C4332F
	for <mm-commits@archiver.kernel.org>; Fri, 16 Dec 2022 23:06:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229785AbiLPXGN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Dec 2022 18:06:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbiLPXGM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Dec 2022 18:06:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBCB61B1EA
        for <mm-commits@vger.kernel.org>; Fri, 16 Dec 2022 15:06:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4D0DE6215C
        for <mm-commits@vger.kernel.org>; Fri, 16 Dec 2022 23:06:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2B95C433D2;
        Fri, 16 Dec 2022 23:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671231969;
        bh=TxM1CiK4dubbhtrGhavwHNBwumiRf9FQ7viSj1GKeow=;
        h=Date:To:From:Subject:From;
        b=q3+FP5atDH+aSNST6vDSEsJvJiCOi1GX9/gZyWWAzC3PO2jZclYNfAV/OkFg3uGIi
         AZuZRQyrEmnA7rfipLDhvTDN64iimfORyUz2iYD42YqpkghAk5DPlu26+lNYFj3PbB
         Wc2q4DOgadlaJZcASmiuO4F6iwMk01NZ5W3OeFDk=
Date:   Fri, 16 Dec 2022 15:06:08 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        vishal.moola@gmail.com, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-convert-mark_page_lazyfree-to-folio_mark_lazyfree.patch added to mm-unstable branch
Message-Id: <20221216230609.A2B95C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: swap: convert mark_page_lazyfree() to folio_mark_lazyfree()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swap-convert-mark_page_lazyfree-to-folio_mark_lazyfree.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-convert-mark_page_lazyfree-to-folio_mark_lazyfree.patch

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
Subject: mm: swap: convert mark_page_lazyfree() to folio_mark_lazyfree()
Date: Fri, 9 Dec 2022 10:06:18 +0800

mark_page_lazyfree() and the callers are converted to use folio, this
rename and make it to take in a folio argument instead of calling
page_folio().

Link: https://lkml.kernel.org/r/20221209020618.190306-1-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    2 +-
 mm/huge_memory.c     |    2 +-
 mm/madvise.c         |    2 +-
 mm/swap.c            |   12 +++++-------
 4 files changed, 8 insertions(+), 10 deletions(-)

--- a/include/linux/swap.h~mm-swap-convert-mark_page_lazyfree-to-folio_mark_lazyfree
+++ a/include/linux/swap.h
@@ -402,7 +402,7 @@ extern void lru_add_drain_cpu(int cpu);
 extern void lru_add_drain_cpu_zone(struct zone *zone);
 extern void lru_add_drain_all(void);
 extern void deactivate_page(struct page *page);
-extern void mark_page_lazyfree(struct page *page);
+void folio_mark_lazyfree(struct folio *folio);
 extern void swap_setup(void);
 
 extern void lru_cache_add_inactive_or_unevictable(struct page *page,
--- a/mm/huge_memory.c~mm-swap-convert-mark_page_lazyfree-to-folio_mark_lazyfree
+++ a/mm/huge_memory.c
@@ -1660,7 +1660,7 @@ bool madvise_free_huge_pmd(struct mmu_ga
 		tlb_remove_pmd_tlb_entry(tlb, pmd, addr);
 	}
 
-	mark_page_lazyfree(&folio->page);
+	folio_mark_lazyfree(folio);
 	ret = true;
 out:
 	spin_unlock(ptl);
--- a/mm/madvise.c~mm-swap-convert-mark_page_lazyfree-to-folio_mark_lazyfree
+++ a/mm/madvise.c
@@ -728,7 +728,7 @@ static int madvise_free_pte_range(pmd_t
 			set_pte_at(mm, addr, pte, ptent);
 			tlb_remove_tlb_entry(tlb, pte, addr);
 		}
-		mark_page_lazyfree(&folio->page);
+		folio_mark_lazyfree(folio);
 	}
 out:
 	if (nr_swap) {
--- a/mm/swap.c~mm-swap-convert-mark_page_lazyfree-to-folio_mark_lazyfree
+++ a/mm/swap.c
@@ -757,16 +757,14 @@ void deactivate_page(struct page *page)
 }
 
 /**
- * mark_page_lazyfree - make an anon page lazyfree
- * @page: page to deactivate
+ * folio_mark_lazyfree - make an anon folio lazyfree
+ * @folio: folio to deactivate
  *
- * mark_page_lazyfree() moves @page to the inactive file list.
- * This is done to accelerate the reclaim of @page.
+ * folio_mark_lazyfree() moves @folio to the inactive file list.
+ * This is done to accelerate the reclaim of @folio.
  */
-void mark_page_lazyfree(struct page *page)
+void folio_mark_lazyfree(struct folio *folio)
 {
-	struct folio *folio = page_folio(page);
-
 	if (folio_test_lru(folio) && folio_test_anon(folio) &&
 	    folio_test_swapbacked(folio) && !folio_test_swapcache(folio) &&
 	    !folio_test_unevictable(folio)) {
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-hwposion-support-recovery-from-ksm_might_need_to_copy.patch
mm-hwposion-support-recovery-from-ksm_might_need_to_copy-v3.patch
mm-huge_memory-convert-madvise_free_huge_pmd-to-use-a-folio.patch
mm-swap-convert-mark_page_lazyfree-to-folio_mark_lazyfree.patch

