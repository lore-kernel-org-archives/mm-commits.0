Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C1C7C3DA7D
	for <mm-commits@archiver.kernel.org>; Fri, 30 Dec 2022 21:52:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229527AbiL3Vww (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Dec 2022 16:52:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235497AbiL3Vws (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 30 Dec 2022 16:52:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 213AD1CFE6
        for <mm-commits@vger.kernel.org>; Fri, 30 Dec 2022 13:52:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AECD461C27
        for <mm-commits@vger.kernel.org>; Fri, 30 Dec 2022 21:52:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12D12C433D2;
        Fri, 30 Dec 2022 21:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1672437167;
        bh=yhFB3ezoMbLtPIspM/L57ngDyMqv5vLdkontaHdyVIY=;
        h=Date:To:From:Subject:From;
        b=N7CJOk0sVa3yTadx4r1NSXKfRUHOZMTfWqD9yeZz8RYqyrgKhjGP1GApd6ylK75lU
         j6HT5Yksp3hLcyvRPiQf02Vy6TbObCb2MHbjFNsYx25d86TOALkZ8Q8JdAvYnbDs/K
         FXMDLIxLg4LXT0iXvLPcVkjNWr0eECBD1xpm6Ahg=
Date:   Fri, 30 Dec 2022 13:52:46 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        vishal.moola@gmail.com, sj@kernel.org, david@redhat.com,
        wangkefeng.wang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-vaddr-convert-hugetlb-related-functions-to-use-a-folio.patch added to mm-unstable branch
Message-Id: <20221230215247.12D12C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/vaddr: convert hugetlb related functions to use a folio
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-vaddr-convert-hugetlb-related-functions-to-use-a-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-vaddr-convert-hugetlb-related-functions-to-use-a-folio.patch

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
Subject: mm/damon/vaddr: convert hugetlb related functions to use a folio
Date: Fri, 30 Dec 2022 15:08:49 +0800

Convert damon_hugetlb_mkold() and damon_young_hugetlb_entry() to
use a folio.

Link: https://lkml.kernel.org/r/20221230070849.63358-9-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/damon/vaddr.c~mm-damon-vaddr-convert-hugetlb-related-functions-to-use-a-folio
+++ a/mm/damon/vaddr.c
@@ -335,9 +335,9 @@ static void damon_hugetlb_mkold(pte_t *p
 {
 	bool referenced = false;
 	pte_t entry = huge_ptep_get(pte);
-	struct page *page = pte_page(entry);
+	struct folio *folio = pfn_folio(pte_pfn(entry));
 
-	get_page(page);
+	folio_get(folio);
 
 	if (pte_young(entry)) {
 		referenced = true;
@@ -352,10 +352,10 @@ static void damon_hugetlb_mkold(pte_t *p
 #endif /* CONFIG_MMU_NOTIFIER */
 
 	if (referenced)
-		set_page_young(page);
+		folio_set_young(folio);
 
-	set_page_idle(page);
-	put_page(page);
+	folio_set_idle(folio);
+	folio_put(folio);
 }
 
 static int damon_mkold_hugetlb_entry(pte_t *pte, unsigned long hmask,
@@ -490,7 +490,7 @@ static int damon_young_hugetlb_entry(pte
 {
 	struct damon_young_walk_private *priv = walk->private;
 	struct hstate *h = hstate_vma(walk->vma);
-	struct page *page;
+	struct folio *folio;
 	spinlock_t *ptl;
 	pte_t entry;
 
@@ -499,16 +499,16 @@ static int damon_young_hugetlb_entry(pte
 	if (!pte_present(entry))
 		goto out;
 
-	page = pte_page(entry);
-	get_page(page);
+	folio = pfn_folio(pte_pfn(entry));
+	folio_get(folio);
 
-	if (pte_young(entry) || !page_is_idle(page) ||
+	if (pte_young(entry) || !folio_test_idle(folio) ||
 	    mmu_notifier_test_young(walk->mm, addr)) {
 		*priv->page_sz = huge_page_size(h);
 		priv->young = true;
 	}
 
-	put_page(page);
+	folio_put(folio);
 
 out:
 	spin_unlock(ptl);
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

