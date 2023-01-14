Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A3DDC6379F
	for <mm-commits@archiver.kernel.org>; Sat, 14 Jan 2023 04:34:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229851AbjANEeq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 Jan 2023 23:34:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229966AbjANEee (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2023 23:34:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9859BB5
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2023 20:34:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4D5B2B822C2
        for <mm-commits@vger.kernel.org>; Sat, 14 Jan 2023 04:34:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA136C433EF;
        Sat, 14 Jan 2023 04:34:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673670871;
        bh=HtfwrP+QmqdaNsN0TLgz2ppizpn+Eg3UpSPf3AhC5HM=;
        h=Date:To:From:Subject:From;
        b=wq/JeBjODxwJjKCr35iwb+P9njyslRnav8XPH1jLHp4qgzaMX7Za9vhH8wxmr6U4N
         Y6edGLM+HBTncmC0Baq0Nf3vnPCbV4j1RofXmEFo2IncHs4NRnsZgyBPRZ9vEzBss/
         V8Xj8b+ktBxKNiG/8DmLak9PE5M1hyiKyhL4ci90=
Date:   Fri, 13 Jan 2023 20:34:30 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        wangkefeng.wang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-memory-convert-page_copy_prealloc-to-use-a-folio.patch removed from -mm tree
Message-Id: <20230114043430.DA136C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: memory: convert page_copy_prealloc() to use a folio
has been removed from the -mm tree.  Its filename was
     mm-memory-convert-page_copy_prealloc-to-use-a-folio.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: memory: convert page_copy_prealloc() to use a folio
Date: Thu, 12 Jan 2023 16:30:03 +0800

The page functions are converted to corresponding to folio functions in
page_copy_prealloc().

Link: https://lkml.kernel.org/r/20230112083006.163393-5-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/mm/memory.c~mm-memory-convert-page_copy_prealloc-to-use-a-folio
+++ a/mm/memory.c
@@ -958,19 +958,19 @@ static inline struct page *
 page_copy_prealloc(struct mm_struct *src_mm, struct vm_area_struct *vma,
 		   unsigned long addr)
 {
-	struct page *new_page;
+	struct folio *new_folio;
 
-	new_page = alloc_page_vma(GFP_HIGHUSER_MOVABLE, vma, addr);
-	if (!new_page)
+	new_folio = vma_alloc_folio(GFP_HIGHUSER_MOVABLE, 0, vma, addr, false);
+	if (!new_folio)
 		return NULL;
 
-	if (mem_cgroup_charge(page_folio(new_page), src_mm, GFP_KERNEL)) {
-		put_page(new_page);
+	if (mem_cgroup_charge(new_folio, src_mm, GFP_KERNEL)) {
+		folio_put(new_folio);
 		return NULL;
 	}
-	cgroup_throttle_swaprate(new_page, GFP_KERNEL);
+	folio_throttle_swaprate(new_folio, GFP_KERNEL);
 
-	return new_page;
+	return &new_folio->page;
 }
 
 static int
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
mm-memory-convert-wp_page_copy-to-use-folios.patch
mm-memory-use-folio_throttle_swaprate-in-do_swap_page.patch
mm-swap-remove-unneeded-cgroup_throttle_swaprate.patch

