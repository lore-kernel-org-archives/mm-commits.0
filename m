Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20EABC3DA78
	for <mm-commits@archiver.kernel.org>; Sat, 14 Jan 2023 04:34:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229945AbjANEer (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 Jan 2023 23:34:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbjANEeg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2023 23:34:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84834AB
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2023 20:34:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 40C76B822C8
        for <mm-commits@vger.kernel.org>; Sat, 14 Jan 2023 04:34:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB776C433D2;
        Sat, 14 Jan 2023 04:34:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673670873;
        bh=L21TGjUKLvZNibZajkF4PkwgnzDIjXE1OmMweQmTT0I=;
        h=Date:To:From:Subject:From;
        b=AfNODuJ4jNzep3YhYmvOvnzk2TDGYPn0AHj5qMYMl1BR0he/Pg2VfBUVO7ytp3M21
         AkyYfwCEiOtXtHB5gCCHoDJx1HGTREkM4Orw0Ecz6v0PrKm7Nf/NTm8J7V0DZCPIqC
         1qQOKJrB0JMPOWhEL0rteUFmdQbmEEUfU6dBm3C4=
Date:   Fri, 13 Jan 2023 20:34:32 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        wangkefeng.wang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-memory-use-folio_throttle_swaprate-in-do_swap_page.patch removed from -mm tree
Message-Id: <20230114043432.DB776C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: memory: use folio_throttle_swaprate() in do_swap_page()
has been removed from the -mm tree.  Its filename was
     mm-memory-use-folio_throttle_swaprate-in-do_swap_page.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: memory: use folio_throttle_swaprate() in do_swap_page()
Date: Thu, 12 Jan 2023 16:30:05 +0800

Directly use folio_throttle_swaprate() instead cgroup_throttle_swaprate().

Link: https://lkml.kernel.org/r/20230112083006.163393-7-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory.c~mm-memory-use-folio_throttle_swaprate-in-do_swap_page
+++ a/mm/memory.c
@@ -3839,7 +3839,7 @@ vm_fault_t do_swap_page(struct vm_fault
 			lru_add_drain();
 	}
 
-	cgroup_throttle_swaprate(page, GFP_KERNEL);
+	folio_throttle_swaprate(folio, GFP_KERNEL);
 
 	/*
 	 * Back out if somebody else already faulted in this pte.
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
mm-swap-remove-unneeded-cgroup_throttle_swaprate.patch

