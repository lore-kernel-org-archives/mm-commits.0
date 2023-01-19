Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43A72C677F1
	for <mm-commits@archiver.kernel.org>; Thu, 19 Jan 2023 01:16:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbjASBQb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 20:16:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229816AbjASBOu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 20:14:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 142416B981
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 17:14:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C5431B81D66
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 01:14:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C848C433D2;
        Thu, 19 Jan 2023 01:14:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674090862;
        bh=acuCq3tZGXvwx1EuRBxoBUfrrOMZ5DjM4Oc5bYuNI0c=;
        h=Date:To:From:Subject:From;
        b=2Ra9zRhibyUY/0iaLv9OWpaT4kJg4AXlZH6JM8JOlceVehpEkachAjK075b5Ju8wj
         4KtJPBvwHbgxaRaFEVs1O54s2bJCY6ZRRw/k99PTqG+Q4AN6XZjZ9aaTlal8VM29Av
         3NNFvw9gsvKKrnJfve8FW5koziVmoO3o2OgBdziA=
Date:   Wed, 18 Jan 2023 17:14:21 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        vishal.moola@gmail.com, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-convert-mark_page_lazyfree-to-folio_mark_lazyfree.patch removed from -mm tree
Message-Id: <20230119011422.6C848C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: swap: convert mark_page_lazyfree() to folio_mark_lazyfree()
has been removed from the -mm tree.  Its filename was
     mm-swap-convert-mark_page_lazyfree-to-folio_mark_lazyfree.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
mm-madvise-use-vm_normal_folio-in-madvise_free_pte_range.patch

