Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FFCAC67871
	for <mm-commits@archiver.kernel.org>; Sat, 14 Jan 2023 04:34:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229531AbjANEes (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 Jan 2023 23:34:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230038AbjANEen (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2023 23:34:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAB5EAC
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2023 20:34:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4BE94B822CE
        for <mm-commits@vger.kernel.org>; Sat, 14 Jan 2023 04:34:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD498C433EF;
        Sat, 14 Jan 2023 04:34:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673670874;
        bh=xWxhMa/F/zvIP7ppieLSIkeg3Cap5gA3+qcBhhTtr6k=;
        h=Date:To:From:Subject:From;
        b=q7JFnbT8dCtuuYjIfZvGQGh5kUAYNmyFOiXkCgcNM5+hdx1ZuhiWMSuy7ewlfvqBw
         TA3mlZ9VVbRQht8Z0VCpMS2V0qcJEFBpoPPPCLBGCI+dR9uVoTlZ0zYGJjLih428z4
         y9pwYnZo6807THrZ/4gJkLZdBAByDBnlIr218XiQ=
Date:   Fri, 13 Jan 2023 20:34:33 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        wangkefeng.wang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-swap-remove-unneeded-cgroup_throttle_swaprate.patch removed from -mm tree
Message-Id: <20230114043433.DD498C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: swap: remove unneeded cgroup_throttle_swaprate()
has been removed from the -mm tree.  Its filename was
     mm-swap-remove-unneeded-cgroup_throttle_swaprate.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: swap: remove unneeded cgroup_throttle_swaprate()
Date: Thu, 12 Jan 2023 16:30:06 +0800

All the callers of cgroup_throttle_swaprate() are converted to
folio_throttle_swaprate(), so make __cgroup_throttle_swaprate() to take a
folio, and drop unused cgroup_throttle_swaprate().

Link: https://lkml.kernel.org/r/20230112083006.163393-8-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |   12 ++++--------
 mm/swapfile.c        |    4 ++--
 2 files changed, 6 insertions(+), 10 deletions(-)

--- a/include/linux/swap.h~mm-swap-remove-unneeded-cgroup_throttle_swaprate
+++ a/include/linux/swap.h
@@ -641,22 +641,18 @@ extern atomic_t zswap_stored_pages;
 #endif
 
 #if defined(CONFIG_SWAP) && defined(CONFIG_MEMCG) && defined(CONFIG_BLK_CGROUP)
-extern void __cgroup_throttle_swaprate(struct page *page, gfp_t gfp_mask);
-static inline  void cgroup_throttle_swaprate(struct page *page, gfp_t gfp_mask)
+extern void __cgroup_throttle_swaprate(struct folio *folio, gfp_t gfp_mask);
+static inline void folio_throttle_swaprate(struct folio *folio, gfp_t gfp_mask)
 {
 	if (mem_cgroup_disabled())
 		return;
-	__cgroup_throttle_swaprate(page, gfp_mask);
+	__cgroup_throttle_swaprate(folio, gfp_mask);
 }
 #else
-static inline void cgroup_throttle_swaprate(struct page *page, gfp_t gfp_mask)
+static inline void folio_throttle_swaprate(struct folio *folio, gfp_t gfp_mask)
 {
 }
 #endif
-static inline void folio_throttle_swaprate(struct folio *folio, gfp_t gfp)
-{
-	cgroup_throttle_swaprate(&folio->page, gfp);
-}
 
 #if defined(CONFIG_MEMCG) && defined(CONFIG_SWAP)
 void mem_cgroup_swapout(struct folio *folio, swp_entry_t entry);
--- a/mm/swapfile.c~mm-swap-remove-unneeded-cgroup_throttle_swaprate
+++ a/mm/swapfile.c
@@ -3636,10 +3636,10 @@ static void free_swap_count_continuation
 }
 
 #if defined(CONFIG_MEMCG) && defined(CONFIG_BLK_CGROUP)
-void __cgroup_throttle_swaprate(struct page *page, gfp_t gfp_mask)
+void __cgroup_throttle_swaprate(struct folio *folio, gfp_t gfp_mask)
 {
 	struct swap_info_struct *si, *next;
-	int nid = page_to_nid(page);
+	int nid = folio_nid(folio);
 
 	if (!(gfp_mask & __GFP_IO))
 		return;
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-hwposion-support-recovery-from-ksm_might_need_to_copy.patch
mm-hwposion-support-recovery-from-ksm_might_need_to_copy-v3.patch
mm-huge_memory-convert-madvise_free_huge_pmd-to-use-a-folio.patch
mm-swap-convert-mark_page_lazyfree-to-folio_mark_lazyfree.patch
mm-huge_memory-convert-split_huge_pages_all-to-use-a-folio.patch
mm-page_idle-convert-page-idle-to-use-a-folio.patch
mm-damon-introduce-damon_get_folio.patch
mm-damon-convert-damon_ptep-pmdp_mkold-to-use-a-folio.patch
mm-damon-paddr-convert-damon_pa_-to-use-a-folio.patch
mm-damon-vaddr-convert-damon_young_pmd_entry-to-use-a-folio.patch
mm-damon-remove-unneeded-damon_get_page.patch
mm-damon-vaddr-convert-hugetlb-related-functions-to-use-a-folio.patch
mm-madvise-use-vm_normal_folio-in-madvise_free_pte_range.patch

